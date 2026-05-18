# Ez Borrow Checker — Design Sketch

**Status:** week-1 draft. Goal: define the abstract state + transfer functions concretely enough to start implementing in week 2.

**Inspiration:** Move bytecode verifier (`move-bytecode-verifier/src/reference_safety/abstract_state.rs`).  Same algorithm shape — abstract interpretation over CFG, per-function analysis, fixed-point iteration, conservative merge at joins — adapted to our specific invariants.

**Non-goal:** become a full borrow checker for arbitrary Zig.  We are checking ~5 specific patterns we care about in *our* codebase.  Conservativism (false positives) is acceptable; false negatives on the named invariants are not.

## Invariants we want to enforce

| # | Invariant | Bug shape it prevents |
|---|---|---|
| 1 | A `NodeIndex` extracted from `Ast` A must only flow back into A | Using a node from one parse against another's AST |
| 2 | A slice borrowed from an `Ast`'s source buffer must not outlive that `Ast` | Use-after-free on `tokenText()` results once the parse arena is dropped |
| 3 | A pointer into the worker-thread bump partition must not be read by the main thread before the join point | Race in streaming-sem worker |
| 4 | A `ScopeId` / `SymbolId` from analysis pass N must not be used by pass M (M ≠ N) | Identity drift after passes that reorder/rewrite |
| 5 | After parse completion, the `Ast` is read-only — any mutating method invalidates derived data (parent_indices, tag CSRs) | Stale derived caches |

Anything else is out of scope for v1.  We will add invariants only when we have a real bug class to point at.

## Inspiration vs adaptation

Move's domain:
- Linear resources (move semantics, exactly-once consumption)
- `&` / `&mut` exclusivity
- Stack-machine bytecode

Our domain:
- Arena-allocated everything (no per-object linearity)
- Pointers/slices/indices borrowed from arenas; no `&mut` exclusivity model
- Source-level Zig (we'll lower to a CFG first)

So our `AbstractValue` is richer (more value categories) but our borrow graph is *simpler* (no aliasing exclusivity rules — just "borrow X is alive iff origin Y is alive").

## AbstractValue

Mirrors Move's enum but more variants for our domain:

```zig
pub const AbstractValue = union(enum) {
    /// Uninitialized / moved-out / unknown.
    none,
    /// Copyable primitive — integers, bools, comptime-known consts.
    plain,
    /// A NodeIndex tagged with which Ast it was extracted from.
    /// Two `NodeIndex` values from different Asts are NOT interchangeable.
    node_index: AstOrigin,
    /// A borrowed slice, tracked in the borrow graph by id.
    slice: BorrowId,
    /// A borrowed pointer, tracked the same way.
    pointer: BorrowId,
    /// Scope/symbol ID tagged with the pass that produced it.
    scope_id: PassOrigin,
    symbol_id: PassOrigin,
    /// A composite — `AbstractValue`s grouped (e.g. struct field tracking).
    composite: []const AbstractValue,
};
```

`AstOrigin`, `BorrowId`, `PassOrigin` are all `u32` newtype wrappers minted at the program point where the value originates.

## AbstractState

```zig
pub const AbstractState = struct {
    /// One entry per local variable at this program point.
    locals: std.AutoArrayHashMapUnmanaged(LocalId, AbstractValue),

    /// Borrow graph: which borrows are alive, and what they borrow from.
    borrows: BorrowGraph,

    /// Which arenas are alive at this program point.
    /// Deinit'd arenas remain in the map but flip to .dead so any
    /// later borrow against them is immediately invalid.
    arenas: std.AutoArrayHashMapUnmanaged(ArenaId, ArenaState),

    /// Thread context — main, worker, or "either" (after join).
    /// Determines whether a worker-bump borrow is readable.
    thread: ThreadContext,

    /// Monotonically-increasing counter for minting fresh BorrowIds /
    /// AstOrigins / PassOrigins. Matches Move's `next_id`.
    next_id: u32,
};

pub const ArenaState = enum { live, dead };

pub const ThreadContext = enum { main, worker, joined };
```

## BorrowGraph

```zig
pub const BorrowGraph = struct {
    /// For each live borrow id, what it ultimately points into.
    /// An origin is either an arena (slice/pointer into bump memory),
    /// an Ast (NodeIndex-bearing reference), or another borrow
    /// (transitive — e.g. a sub-slice of a slice).
    origins: std.AutoArrayHashMapUnmanaged(BorrowId, BorrowOrigin),

    /// Inverted index: for each origin, which borrows currently live
    /// against it. Used by `kill(origin)` when the origin dies.
    live: std.AutoArrayHashMapUnmanaged(BorrowOrigin, std.AutoArrayHashMapUnmanaged(BorrowId, void)),
};

pub const BorrowOrigin = union(enum) {
    arena: ArenaId,
    ast: AstOrigin,
    borrow: BorrowId,   // transitive borrow
};
```

This is essentially Move's `BorrowGraph<(), Label>` with the label being our `BorrowOrigin`. Edges are untyped (the `()` in Move's signature — we don't need to distinguish edge kinds; the origin type is enough).

## Transfer functions

One per Zig operation we recognize. Most operations don't change abstract state; we list only the ones that do.

| Operation in Zig | Transfer function | What it does |
|---|---|---|
| Local declaration | `decl(local, value)` | Add to `locals`, set to `value` (often `.none`) |
| Assignment | `assign(local, value)` | Update `locals[local] = value` |
| Call to a `borrowed_from(...)`-annotated helper | `borrow_call(callee, args) → AbstractValue` | Mint fresh BorrowId, register in graph with origin derived from callee's annotation |
| Call to a plain helper | `call(callee, args) → AbstractValue` | Apply callee's known summary (see below) |
| Slice expression `arr[a..b]` | `subslice(parent: AbstractValue) → AbstractValue` | Mint fresh BorrowId, parent → `BorrowOrigin.borrow(parent_id)` |
| Address-of `&x` | `borrow_loc(local) → AbstractValue` | Mint fresh borrow against local's value |
| Arena `deinit()` call | `kill_arena(arena: ArenaId)` | Mark arena dead; iterate `live[arena]`, error on any reads later |
| Thread join | `thread_join()` | Switch `thread` to `.joined` |
| Function return | `ret(values)` | Verify no returned value borrows from a local/dying-arena |

The trickiest two:
- **borrow_call**: requires the caller to know what the callee returns. This is where our `// @returns` annotations live (next section).
- **kill_arena**: enforces invariant #2 (slice doesn't outlive arena).

## Annotation system

Functions that introduce or transmit borrows need annotations. Format: special comment lines on function signatures.

```zig
/// @returns borrowed_from(self)
pub fn tokenText(self: *const Ast, tok: TokenIdx) []const u8 { ... }

/// @returns borrowed_from(ast)
pub fn nodeMainToken(self: *const LintContext, n: NodeIndex, ast: *const Ast) Token { ... }

/// @returns owned
pub fn nodeSpan(self: *const Ast, n: NodeIndex) Span { ... }  // Span is value-typed

/// @takes node_index_of(ast)
pub fn nodeData(self: *const Ast, n: NodeIndex) Node.Data { ... }

/// @kills_arena(arena)
pub fn deinit(arena: *ArenaAllocator) void { ... }

/// @thread_join
pub fn join(thread: *std.Thread) void { ... }
```

Initial annotation count estimate, from grepping our codebase:
- ~50 functions return borrowed data (slices/pointers from Ast/Source)
- ~20 functions take NodeIndex args
- ~10 functions deinit arenas
- ~5 thread-join points

So ~85 annotations total to get coverage. Manageable.

Unannotated functions are treated conservatively — return `.none`, take any value. False positives possible; no false negatives.

## Merge (join) function

At CFG joins, we combine the state from each incoming edge:

```zig
fn join(self: *AbstractState, other: *const AbstractState) JoinResult {
    var changed = false;

    // Locals: per-variable join.
    for (other.locals.keys(), other.locals.values()) |local, other_val| {
        const our_val = self.locals.get(local) orelse {
            self.locals.put(local, other_val);
            changed = true;
            continue;
        };
        const merged = AbstractValue.join(our_val, other_val);
        if (!merged.eql(our_val)) {
            self.locals.put(local, merged);
            changed = true;
        }
    }

    // Borrows: union live set per origin. (Both paths' borrows are alive
    // on the merged path until something kills them.)
    for (other.borrows.live.keys(), other.borrows.live.values()) |origin, other_set| {
        // ... merge sets ...
    }

    // Arenas: an arena is dead on the merged path iff dead on BOTH inputs.
    // (Conservatively, if either path keeps it alive we keep it alive.)
    // Actually NO — if one path killed it and the other didn't, accessing
    // it after the join is unsafe. Mark it dead.
    for (other.arenas.keys(), other.arenas.values()) |arena, other_state| {
        const our_state = self.arenas.get(arena) orelse continue;
        if (our_state == .live and other_state == .dead) {
            self.arenas.put(arena, .dead);
            changed = true;
        }
    }

    // Thread: if both inputs are same, keep. If different, error
    // (CFG should never join across thread boundaries).
    if (self.thread != other.thread) return error.thread_join_mismatch;

    return if (changed) .changed else .unchanged;
}

pub fn join_value(a: AbstractValue, b: AbstractValue) AbstractValue {
    // Same → same.
    if (a.eql(b)) return a;
    // Otherwise → conservative .none (might be either, treat as moved-out).
    return .none;
}
```

`JoinResult` is `{ changed, unchanged }` — same as Move. Iteration terminates when no block's incoming state changed.

## Algorithm

Standard worklist fixed-point:

```
for each function f in input:
    cfg = lower(f)                           # extract.zig + cfg.zig
    initial_state = AbstractState.init(...)   # all locals = .none
    states = {block_id → AbstractState}      # per-block in-state
    states[entry] = initial_state
    worklist = [entry]

    while worklist not empty:
        block = worklist.pop()
        state = states[block].clone()
        for each stmt in block:
            state = transfer(stmt, state) or report_error
        for each successor s:
            joined, result = join(states[s], state)
            states[s] = joined
            if result == .changed:
                worklist.push(s)
```

## Output

Errors are reported per Zig source span:

```
src/linter/lint_context.zig:4823:18: error: slice borrowed from `ast.source` may outlive its arena
    const name = self.ast.tokenText(self.ast.nodeMainToken(catch_param));
                          ^~~~~~~~~~
note: arena `ast` is deinitialized at src/linter/lint_context.zig:4830:5
    arena.deinit();
    ^~~~~~~~~~~~~~
note: `name` is used at src/linter/lint_context.zig:4886:42
    if (std.mem.eql(u8, val_name, caught_name)) {
                                  ^~~~~~~~~~
```

We get source spans from `std.zig.Ast`'s `tokenLocation()` for free.

## Implementation plan

### Week 1 (this week) — Foundations
- [x] Read Move's `reference_safety/mod.rs` and `abstract_state.rs`
- [ ] Document our invariants formally (this file)
- [ ] Hand-trace 3 representative functions through the abstract state
- [ ] Specify the annotation format precisely

### Week 2 — Skeleton
- [ ] `src/borrow_check/cfg.zig` — Zig AST → CFG (we have prior art in `src/parser/code_path.zig` we can borrow ideas from)
- [ ] `src/borrow_check/abstract_state.zig` — state struct + join
- [ ] `src/borrow_check/transfer.zig` — transfer functions for the common ops
- [ ] `src/borrow_check/annotations.zig` — parse `// @returns` etc. from comments
- [ ] Wire a CLI entry point: `zig build borrow-check -- <file>`

### Week 3 — First invariant end-to-end
- [ ] Implement invariant #2 (slice outlives arena) on `src/linter/lint_context.zig`
- [ ] Inject a synthetic bug, verify we catch it
- [ ] Run on real codebase, examine any reports

### Week 4 — Decision point
- [ ] If invariant #2 finds ≥1 real bug or pre-empts a known bug class → continue with #1, #3, #4, #5
- [ ] If no real findings → assess whether our architecture already prevents these bugs (good outcome) or our checker is too imprecise (bad outcome)
- [ ] Wire to CI if continuing

## Open questions

1. **Comptime monomorphisation.** Functions taking `comptime T: type` need per-instantiation analysis. Easiest: skip them in v1, run only on concrete functions.
2. **`defer` modeling.** `defer` runs at scope exit on all paths; `errdefer` only on error returns. We need to insert synthetic statements at block ends for both. CFG should already represent scopes, so this is mechanical.
3. **`anytype` parameters.** We can't reason about callees that take `anytype` — too generic. Skip in v1.
4. **`@call` and friends.** Manual call-site dispatch. Probably skip (rare in our codebase).
5. **Inline assembly, `@ptrCast`, `@alignCast`.** Bypass our model. Annotate as "trust me" comments that suppress analysis on that expression.

## Why not Polonius / rustc

See `memory/project_bun_left_zig.md` and prior conversation. Summary:
- Polonius is a research crate evolving with rustc — API churn we don't want
- Surface-Rust shadow requires inventing fake Rust bodies; impedance mismatch
- Our patterns are simpler than full Rust borrow rules — we don't need NLL or origin tracking
- Self-hosted in Zig means no Rust toolchain dependency, no Cargo, no version-pinning
- ~5–10k LOC of Zig is something we own and evolve

## Why not rely entirely on arenas + ASan

ASan catches use-after-free *at runtime*, *when exercised*. Borrow check catches it *at compile time*, *on every code path*. Complementary:
- ASan: high precision (zero false positives), low coverage (only triggered paths)
- Borrow check: lower precision (some false positives), high coverage (all paths)

Use both. ASan first (half-day, immediate ROI); borrow checker as the longer investment.

## References

- `move-bytecode-verifier` (Aptos repo): `third_party/move/move-bytecode-verifier/src/reference_safety/`
- Move whitepaper: "Move: A Language With Programmable Resources" (2018)
- RustBelt papers (theoretical foundations for borrow checking)
- Our `src/parser/code_path.zig` — already does fixed-point CFG analysis for code-path tracking, similar shape
