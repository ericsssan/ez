//! Checker — single-file type inference over a parsed Ast.
//!
//! Computes a TypeId for every expression node, lazily.  Resolves
//! identifier references via the semantic table to find a declared
//! type annotation (declarator → ts_type_annotation, function param
//! type, return type), then propagates through the local expression
//! tree.  Anything we can't resolve becomes `any` — this is the same
//! "unknown source ⇒ any" assumption that typescript-eslint makes
//! when noImplicitAny is off, and it gives the unsafe-* rules their
//! correct behavior: `JSON.parse(...)` returns `any`, so assigning
//! it to a typed target fires.

const std = @import("std");
const parser = @import("../parser/root.zig");
const ast = parser.ast;
const symbol_mod = parser.symbol;
const Ast = ast.Ast;
const NodeIndex = ast.NodeIndex;
const TokenIndex = ast.TokenIndex;
const SubRange = ast.SubRange;
const SemanticResult = parser.semantic.SemanticResult;

const tymod = @import("types.zig");
const TypeStore = tymod.TypeStore;
const TypeId = tymod.TypeId;
const Type = tymod.Type;

pub const EnumKind = enum(u8) { number, string, mixed };

pub const Checker = struct {
    gpa: std.mem.Allocator,
    ast_ref: *const Ast,
    semantic: *const SemanticResult,
    store: TypeStore,
    /// node → TypeId cache (lazy; .none means "not yet computed").
    node_types: []TypeId,
    /// sym → declared TypeId (lazy).
    sym_types: []TypeId,
    /// Set of type-name identifiers declared in the file (interfaces,
    /// type aliases, classes, enums, type params, imports).  A type
    /// reference to a name NOT in this set AND NOT a built-in resolves
    /// to `error_t` — TSe's "intrinsic error type" condition.
    known_type_names: std.StringHashMapUnmanaged(void),

    /// Maps type names to their AST declaration node so `resolveTypeRef`
    /// can build the structural type on demand.  Filled at init time
    /// for interfaces and classes — type aliases use the same mechanism
    /// when their RHS is a structural type.
    type_decl_nodes: std.StringHashMapUnmanaged(NodeIndex),

    /// Cache: type name → resolved TypeId for declared structural types.
    /// Populated lazily by `resolveDeclaredType`.  Recursion-safe via a
    /// sentinel (ID_UNKNOWN inserted before recursion, replaced after).
    declared_type_cache: std.StringHashMapUnmanaged(TypeId),

    /// Per-enum classification: number-valued or string-valued.  TS infers
    /// each enum as one or the other based on whether ANY member has a
    /// string initializer.  Used by no-mixed-enums and no-unsafe-enum-
    /// comparison.  Populated by `buildKnownTypeNames`.
    enum_kinds: std.StringHashMapUnmanaged(EnumKind),

    /// Built-in global *values* (`console`, `Math`, `JSON`, ...).  Maps
    /// the identifier name → structural TypeId.  Acts as a minimal
    /// stand-in for the lib.d.ts shapes TSC loads at startup.  When
    /// `inferIdentifier` can't find a local symbol or AST declaration
    /// it falls back to this map — letting `console.log()` resolve to
    /// `void` without modelling the full Window / globalThis chain.
    global_value_types: std.StringHashMapUnmanaged(TypeId),

    pub fn init(
        gpa: std.mem.Allocator,
        ast_ref: *const Ast,
        semantic: *const SemanticResult,
    ) !Checker {
        const node_count = ast_ref.nodes.len;
        const node_types = try gpa.alloc(TypeId, node_count);
        @memset(node_types, TypeId.none);
        const sym_count = semantic.symbols.scope_ids.items.len;
        const sym_types = try gpa.alloc(TypeId, sym_count);
        @memset(sym_types, TypeId.none);
        var self: Checker = .{
            .gpa = gpa,
            .ast_ref = ast_ref,
            .semantic = semantic,
            .store = try TypeStore.init(gpa),
            .node_types = node_types,
            .sym_types = sym_types,
            .known_type_names = .empty,
            .type_decl_nodes = .empty,
            .declared_type_cache = .empty,
            .enum_kinds = .empty,
            .global_value_types = .empty,
        };
        try self.buildKnownTypeNames();
        try self.buildGlobalValueTypes();
        return self;
    }

    pub fn deinit(self: *Checker) void {
        self.store.deinit();
        self.gpa.free(self.node_types);
        self.gpa.free(self.sym_types);
        self.known_type_names.deinit(self.gpa);
        self.enum_kinds.deinit(self.gpa);
        self.type_decl_nodes.deinit(self.gpa);
        self.declared_type_cache.deinit(self.gpa);
        self.global_value_types.deinit(self.gpa);
    }

    // ── Public queries (LintContext-facing) ───────────────

    pub fn typeOf(self: *Checker, node: NodeIndex) TypeId {
        if (node == .none) return tymod.ID_ANY;
        const idx = node.toInt();
        const cached = self.node_types[idx];
        if (!cached.eq(TypeId.none)) return cached;
        const computed = self.inferExpr(node);
        self.node_types[idx] = computed;
        return computed;
    }

    pub fn typeIsAny(self: *Checker, node: NodeIndex) bool {
        return tymod.isAny(&self.store, self.typeOf(node));
    }

    pub fn typeContainsAny(self: *Checker, node: NodeIndex) bool {
        return tymod.containsAny(&self.store, self.typeOf(node));
    }

    // ── Expression inference ──────────────────────────────

    fn inferExpr(self: *Checker, node: NodeIndex) TypeId {
        const t = self.ast_ref.nodeTag(node);
        return switch (t) {
            .string_literal => self.literalString(node),
            .number_literal => tymod.ID_NUMBER,
            .bigint_literal => tymod.ID_BIGINT,
            .boolean_literal => tymod.ID_BOOLEAN,
            .null_literal => tymod.ID_NULL,
            .regex_literal => self.regexpRefType(),
            .template_literal => tymod.ID_STRING,
            .tagged_template => tymod.ID_UNKNOWN,
            .this_expr => self.inferThis(node),
            .super_expr => tymod.ID_UNKNOWN,

            .identifier => self.inferIdentifier(node),

            .ts_as_expr, .ts_type_assertion => self.inferAsCast(node, t),
            .ts_satisfies_expr => self.inferSatisfies(node),
            .ts_non_null_expr => self.typeOf(self.ast_ref.nodeData(node).lhs),

            .grouping_expr => self.typeOf(self.ast_ref.nodeData(node).lhs),
            .sequence_expr => self.inferSequence(node),
            .conditional => self.inferConditional(node),
            .assign => self.typeOf(self.ast_ref.nodeData(node).rhs),
            // Compound assignments: result is the new value of LHS.  If
            // LHS is any, result is any.  Otherwise approximate based on
            // operator class (most produce number; string/bigint variants
            // would need a more refined check but rarely surface for
            // unsafe-* rules).
            .add_assign, .sub_assign, .mul_assign, .div_assign, .mod_assign,
            .exp_assign, .and_assign, .or_assign, .xor_assign, .shl_assign,
            .shr_assign, .ushr_assign, .logical_and_assign, .logical_or_assign,
            .nullish_assign => blk: {
                const lhs_ty = self.typeOf(self.ast_ref.nodeData(node).lhs);
                if (tymod.isAny(&self.store, lhs_ty)) break :blk tymod.ID_ANY;
                const rhs_ty = self.typeOf(self.ast_ref.nodeData(node).rhs);
                if (tymod.isAny(&self.store, rhs_ty)) break :blk tymod.ID_ANY;
                break :blk lhs_ty;
            },

            .logical_and, .logical_or, .nullish_coalesce => self.inferLogical(node),

            .add, .subtract, .multiply, .divide, .modulo, .exponentiate => self.inferArith(node, t),

            .equal, .not_equal, .strict_equal, .strict_not_equal,
            .less_than, .greater_than, .less_equal, .greater_equal,
            .instanceof_expr, .in_expr,
            .logical_not => tymod.ID_BOOLEAN,

            .typeof_expr => tymod.ID_STRING,
            .void_expr => tymod.ID_UNDEFINED,
            .delete_expr => tymod.ID_BOOLEAN,

            .unary_plus, .unary_minus, .bitwise_not,
            .bitwise_and, .bitwise_or, .bitwise_xor,
            .shift_left, .shift_right, .unsigned_shift_right,
            .prefix_inc, .prefix_dec, .postfix_inc, .postfix_dec => tymod.ID_NUMBER,

            .array_literal => self.inferArrayLiteral(node),
            .object_literal => self.inferObjectLiteral(node),

            // Call/new: propagate any through the call (TSe: calling
            // `any` returns `any`).  Default to `unknown` otherwise —
            // we don't infer return types from bodies yet.
            .call_expr, .optional_call_expr, .new_expr => self.inferCallReturn(node),

            .member_expr, .computed_member_expr,
            .optional_member_expr, .optional_computed_member_expr => self.inferMember(node),

            .await_expr => self.inferAwait(node),
            .yield_expr, .yield_delegate => tymod.ID_UNKNOWN,

            // Function/arrow expressions build a function_t carrying
            // their signature (param types + return type).  Class
            // expressions still fall back to unknown for now.
            .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
                => self.functionTypeFromFnDecl(node),
            .arrow_fn, .async_arrow_fn => self.functionTypeFromArrow(node),
            .class_expr => tymod.ID_UNKNOWN,
            else => tymod.ID_UNKNOWN,
        };
    }

    fn literalString(self: *Checker, node: NodeIndex) TypeId {
        _ = self;
        _ = node;
        return tymod.ID_STRING;
    }

    fn regexpRefType(self: *Checker) TypeId {
        return self.store.typeRef("RegExp", &.{}) catch tymod.ID_ANY;
    }

    fn inferIdentifier(self: *Checker, node: NodeIndex) TypeId {
        if (self.symbolForIdentRef(node)) |sym| {
            const base = self.declaredTypeForSymbol(sym);
            if (!base.eq(tymod.ID_UNKNOWN)) return self.narrowAtUse(node, sym, base);
            // Symbol resolves but has no declared type — likely an
            // implicit global.  Try the curated lib globals next.
            const decl_node = self.semantic.symbols.getDeclNode(sym);
            if (decl_node == .none) {
                const tok2 = self.ast_ref.nodeMainToken(node);
                const name2 = self.ast_ref.tokenText(tok2);
                if (self.global_value_types.get(name2)) |t| return t;
            }
            return self.narrowAtUse(node, sym, base);
        }
        // Fallback: semantic didn't resolve the reference (common for
        // identifiers used in TS-specific contexts like enum member
        // initializers).  Look up by name through the AST for a
        // declarator with matching name.
        const tok = self.ast_ref.nodeMainToken(node);
        const name = self.ast_ref.tokenText(tok);
        if (name.len == 0) return tymod.ID_UNKNOWN;
        if (self.typeOfNameByAstSearch(name)) |t| return t;
        // Built-in global values (`console`, `Math`, `JSON`, ...) — fall
        // back to the curated lib shapes so member access / calls type
        // correctly without modelling the full lib.d.ts.
        if (self.global_value_types.get(name)) |t| return t;
        return tymod.ID_UNKNOWN;
    }

    /// Walk the AST looking for a top-level declarator/fn_decl/class_decl
    /// with the given name.  Returns the declared/inferred type, or null
    /// if not found.
    fn typeOfNameByAstSearch(self: *Checker, name: []const u8) ?TypeId {
        const total: u32 = @intCast(self.ast_ref.nodes.len);
        var i: u32 = 0;
        while (i < total) : (i += 1) {
            const ni: NodeIndex = @enumFromInt(i);
            const t = self.ast_ref.nodeTag(ni);
            switch (t) {
                .declarator => {
                    const data = self.ast_ref.nodeData(ni);
                    if (data.lhs == .none) continue;
                    if (self.ast_ref.nodeTag(data.lhs) != .identifier) continue;
                    const dn = self.ast_ref.tokenText(self.ast_ref.nodeMainToken(data.lhs));
                    if (!std.mem.eql(u8, dn, name)) continue;
                    if (data.rhs == .none) {
                        // Use annotation if present.
                        const ann = self.ast_ref.nodeData(data.lhs).rhs;
                        if (ann != .none and self.ast_ref.nodeTag(ann) == .ts_type_annotation) {
                            return self.resolveTypeNode(self.ast_ref.nodeData(ann).lhs);
                        }
                        return null;
                    }
                    return self.typeOf(data.rhs);
                },
                .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
                .ts_declare_function => {
                    const data = self.ast_ref.nodeData(ni);
                    if (data.lhs == .none) continue;
                    const fd = self.ast_ref.extraData(ast.FnData, @intFromEnum(data.lhs));
                    if (fd.name == .none) continue;
                    const dn = self.ast_ref.tokenText(self.ast_ref.nodeMainToken(fd.name));
                    if (!std.mem.eql(u8, dn, name)) continue;
                    return self.functionTypeFromFnDecl(ni);
                },
                else => {},
            }
        }
        return null;
    }

    /// Walk parent chain looking for `if_stmt` / `logical_and` / `conditional`
    /// constructs whose test narrows `sym`.  Applies the narrowing to
    /// `base` and returns the result.  Handles:
    ///   - `if (x !== null) { ...use... }` → narrowed to non-null.
    ///   - `if (x !== undefined) { ... }` → narrowed to non-undefined.
    ///   - `if (typeof x === 'string') { ... }` → narrowed to string.
    ///   - `if (x === null) { ...use... }` → narrowed to null.
    ///   - Negated forms via `!`.
    fn narrowAtUse(self: *Checker, node: NodeIndex, sym: symbol_mod.SymbolId, base: TypeId) TypeId {
        if (self.ast_ref.parents.len == 0) return base;
        var ty = base;
        const NONE: u32 = @intFromEnum(NodeIndex.none);
        var prev = node.toInt();
        var p = self.ast_ref.parents[prev];
        while (p != NONE) {
            const pn: NodeIndex = @enumFromInt(p);
            const tag = self.ast_ref.nodeTag(pn);
            // Cross-statement narrowing: when we cross into a
            // block_stmt, walk prior siblings looking for
            // `if (cond) <early-exit>;` patterns and apply the
            // inverse-cond narrowing.  Done once at the most-specific
            // block — preceding flow constraints flow inward but not
            // outward across function boundaries.
            if (tag == .block_stmt) {
                ty = self.narrowByPriorEarlyExits(pn, @enumFromInt(prev), sym, ty);
            }
            switch (tag) {
                .if_stmt => {
                    // if_stmt: lhs=cond, rhs=consequent.  If `prev` is
                    // the consequent (or descends from it), apply
                    // narrowing.  TS also narrows the else branch with
                    // the negated condition.
                    const data = self.ast_ref.nodeData(pn);
                    if (@intFromEnum(data.rhs) == prev or self.descendsFrom(node, data.rhs)) {
                        ty = self.applyNarrowing(data.lhs, sym, ty, false);
                    }
                },
                .if_else_stmt => {
                    const data = self.ast_ref.nodeData(pn);
                    const ifd = self.ast_ref.extraData(ast.IfData, @intFromEnum(data.rhs));
                    if (self.descendsFrom(node, ifd.consequent)) {
                        ty = self.applyNarrowing(data.lhs, sym, ty, false);
                    } else if (self.descendsFrom(node, ifd.alternate)) {
                        ty = self.applyNarrowing(data.lhs, sym, ty, true);
                    }
                },
                .conditional => {
                    // `cond ? a : b` — a is narrowed by cond, b by !cond.
                    const data = self.ast_ref.nodeData(pn);
                    const cd = self.ast_ref.extraData(ast.Conditional, @intFromEnum(data.rhs));
                    if (self.descendsFrom(node, cd.consequent)) {
                        ty = self.applyNarrowing(data.lhs, sym, ty, false);
                    } else if (self.descendsFrom(node, cd.alternate)) {
                        ty = self.applyNarrowing(data.lhs, sym, ty, true);
                    }
                },
                .logical_and => {
                    // `cond && use` — `use` runs only when cond is truthy.
                    const data = self.ast_ref.nodeData(pn);
                    if (self.descendsFrom(node, data.rhs)) {
                        ty = self.applyNarrowing(data.lhs, sym, ty, false);
                    }
                },
                else => {},
            }
            prev = p;
            p = self.ast_ref.parents[p];
        }
        return ty;
    }

    /// Within `block`, walk the children that appear *before* `child`
    /// and apply the inverse-condition narrowing from any
    /// `if (cond) <early-exit>;` so subsequent uses of `sym` see the
    /// remaining type.  Early-exit = return / throw / continue / break.
    fn narrowByPriorEarlyExits(
        self: *Checker,
        block: NodeIndex,
        child: NodeIndex,
        sym: symbol_mod.SymbolId,
        base: TypeId,
    ) TypeId {
        const data = self.ast_ref.nodeData(block);
        const slice = self.directRange(data.lhs, data.rhs) orelse return base;
        var ty = base;
        for (slice) |raw| {
            const stmt: NodeIndex = @enumFromInt(raw);
            if (stmt == child) break;
            // Single-armed if with an early exit:
            // `if (cond) return;` / `if (cond) throw ...;`
            const stmt_tag = self.ast_ref.nodeTag(stmt);
            if (stmt_tag == .if_stmt) {
                const sd = self.ast_ref.nodeData(stmt);
                if (statementIsEarlyExit(self, sd.rhs)) {
                    ty = self.applyNarrowing(sd.lhs, sym, ty, true);
                }
            } else if (stmt_tag == .if_else_stmt) {
                // `if (cond) earlyExit() else earlyExit()` — both branches
                // exit, so the post-statement state is unreachable; we
                // can't narrow safely, leave ty unchanged.  Single-branch
                // exit (else branch falls through) is handled by the
                // same shape as if_stmt.
                const sd = self.ast_ref.nodeData(stmt);
                const ifd = self.ast_ref.extraData(ast.IfData, @intFromEnum(sd.rhs));
                if (statementIsEarlyExit(self, ifd.consequent) and !statementIsEarlyExit(self, ifd.alternate)) {
                    ty = self.applyNarrowing(sd.lhs, sym, ty, true);
                } else if (statementIsEarlyExit(self, ifd.alternate) and !statementIsEarlyExit(self, ifd.consequent)) {
                    ty = self.applyNarrowing(sd.lhs, sym, ty, false);
                }
            }
            // `cond && earlyExit()` as an expression statement is rare
            // enough to skip.
        }
        return ty;
    }

    fn statementIsEarlyExit(self: *Checker, stmt: NodeIndex) bool {
        if (stmt == .none) return false;
        var n = stmt;
        // Peel a single-stmt block: `if (cond) { return; }`.
        if (self.ast_ref.nodeTag(n) == .block_stmt) {
            const d = self.ast_ref.nodeData(n);
            const slice = self.directRange(d.lhs, d.rhs) orelse return false;
            if (slice.len == 0) return false;
            // Only an early exit if every path ends with one — for
            // simplicity, check that the LAST stmt is an early exit
            // (most common in practice).
            n = @enumFromInt(slice[slice.len - 1]);
        }
        return switch (self.ast_ref.nodeTag(n)) {
            .return_stmt, .throw_stmt, .continue_stmt, .break_stmt => true,
            else => false,
        };
    }

    fn descendsFrom(self: *Checker, node: NodeIndex, ancestor: NodeIndex) bool {
        if (ancestor == .none) return false;
        if (node == ancestor) return true;
        if (self.ast_ref.parents.len == 0) return false;
        const NONE: u32 = @intFromEnum(NodeIndex.none);
        var p = self.ast_ref.parents[node.toInt()];
        const target = @intFromEnum(ancestor);
        while (p != NONE) : (p = self.ast_ref.parents[p]) {
            if (p == target) return true;
        }
        return false;
    }

    /// Apply narrowing implied by `test`.  When `negate` is true, the
    /// narrowing comes from the else branch.
    fn applyNarrowing(self: *Checker, test_node: NodeIndex, sym: symbol_mod.SymbolId, ty: TypeId, negate: bool) TypeId {
        var t = test_node;
        var neg = negate;
        // Peel `!cond`.
        while (self.ast_ref.nodeTag(t) == .logical_not) {
            t = self.ast_ref.nodeData(t).lhs;
            neg = !neg;
        }
        // Peel grouping.
        while (self.ast_ref.nodeTag(t) == .grouping_expr) t = self.ast_ref.nodeData(t).lhs;
        const tag = self.ast_ref.nodeTag(t);
        switch (tag) {
            .strict_not_equal, .not_equal,
            .strict_equal, .equal => {
                return self.narrowEquality(t, sym, ty, neg);
            },
            .instanceof_expr => return self.narrowInstanceof(t, sym, ty, neg),
            // Truthy guard `if (x) {...}` — inside the truthy branch
            // remove null / undefined / 0 / "" / false.  Inside falsy
            // branch keep only those.
            .identifier => {
                if (self.identifierBindsToSym(t, sym)) {
                    return self.narrowTruthy(ty, neg);
                }
                return ty;
            },
            // Logical-and chain: every conjunct narrows the use site
            // (since all must be true for the body to run).
            .logical_and => {
                const data = self.ast_ref.nodeData(t);
                const lty = self.applyNarrowing(data.lhs, sym, ty, neg);
                return self.applyNarrowing(data.rhs, sym, lty, neg);
            },
            else => return ty,
        }
    }

    /// `x instanceof Foo` — inside truthy branch, narrow x to Foo.
    fn narrowInstanceof(self: *Checker, cmp: NodeIndex, sym: symbol_mod.SymbolId, ty: TypeId, negate: bool) TypeId {
        const data = self.ast_ref.nodeData(cmp);
        if (!self.identifierBindsToSym(data.lhs, sym)) return ty;
        const rhs = data.rhs;
        if (self.ast_ref.nodeTag(rhs) != .identifier) return ty;
        const name = self.ast_ref.tokenText(self.ast_ref.nodeMainToken(rhs));
        // Built-in error classes — narrow x to the class instance type.
        // For unknown constructors, leave ty unchanged.
        const class_t = self.store.typeRef(name, &.{}) catch return ty;
        if (negate) {
            // Falsy branch: keep only members NOT assignable to class_t.
            // Approximation: don't narrow.
            return ty;
        }
        // Truthy branch: replace with class_t.
        return class_t;
    }

    /// Truthy guard: remove null / undefined from a union.  Keep
    /// everything else as-is (we don't model literal-falsy types).
    fn narrowTruthy(self: *Checker, ty: TypeId, negate: bool) TypeId {
        const t = self.store.get(ty);
        if (t.kind != .union_t) return ty;
        var buf: [16]TypeId = undefined;
        var n: usize = 0;
        for (self.store.idsOf(t.list_data)) |m| {
            const is_falsy_literal = m.eq(tymod.ID_NULL) or
                m.eq(tymod.ID_UNDEFINED) or m.eq(tymod.ID_VOID);
            const keep = if (negate) is_falsy_literal else !is_falsy_literal;
            if (keep) {
                if (n >= buf.len) return ty;
                buf[n] = m;
                n += 1;
            }
        }
        if (n == 0) return tymod.ID_NEVER;
        if (n == 1) return buf[0];
        return self.store.unionOf(buf[0..n]) catch ty;
    }

    /// Narrow against `x === null` / `x !== undefined` / `typeof x === '...'` etc.
    fn narrowEquality(self: *Checker, cmp: NodeIndex, sym: symbol_mod.SymbolId, ty: TypeId, negate: bool) TypeId {
        const data = self.ast_ref.nodeData(cmp);
        const tag = self.ast_ref.nodeTag(cmp);
        const is_neq = tag == .strict_not_equal or tag == .not_equal;
        // typeof narrowing: `typeof x === 'string'` / `typeof x !== 'function'`
        if (self.tryTypeofNarrow(data.lhs, data.rhs, sym, is_neq, negate)) |narrowed| {
            return self.intersectNarrow(ty, narrowed.kind, narrowed.keep_only);
        }
        if (self.tryTypeofNarrow(data.rhs, data.lhs, sym, is_neq, negate)) |narrowed| {
            return self.intersectNarrow(ty, narrowed.kind, narrowed.keep_only);
        }
        // Try `<sym> op <literal>` and `<literal> op <sym>`.
        var sym_side: NodeIndex = .none;
        var lit_side: NodeIndex = .none;
        if (self.identifierBindsToSym(data.lhs, sym)) {
            sym_side = data.lhs;
            lit_side = data.rhs;
        } else if (self.identifierBindsToSym(data.rhs, sym)) {
            sym_side = data.rhs;
            lit_side = data.lhs;
        } else return ty;
        _ = &sym_side;
        const removed = self.narrowKindFromLiteral(lit_side);
        if (removed == .none) return ty;
        const keep_only = (!is_neq) != negate;
        return self.narrowUnion(ty, removed, keep_only);
    }

    const TypeofNarrowSpec = struct { kind: Narrowable, keep_only: bool };

    /// Recognise `typeof <sym-ref> <op> <"kind">`.  Returns the narrow
    /// spec when the typeof's operand resolves to `sym`.
    fn tryTypeofNarrow(self: *Checker, typeof_side: NodeIndex, str_side: NodeIndex, sym: symbol_mod.SymbolId, is_neq: bool, negate: bool) ?TypeofNarrowSpec {
        if (self.ast_ref.nodeTag(typeof_side) != .typeof_expr) return null;
        const operand = self.ast_ref.nodeData(typeof_side).lhs;
        if (!self.identifierBindsToSym(operand, sym)) return null;
        const str_kind = self.typeofStringValue(str_side) orelse return null;
        const keep_only = (!is_neq) != negate;
        return .{ .kind = str_kind, .keep_only = keep_only };
    }

    fn typeofStringValue(self: *Checker, node: NodeIndex) ?Narrowable {
        var n = node;
        while (self.ast_ref.nodeTag(n) == .grouping_expr) n = self.ast_ref.nodeData(n).lhs;
        if (self.ast_ref.nodeTag(n) != .string_literal) return null;
        const span = self.ast_ref.nodeSpan(n);
        const src = self.ast_ref.source;
        if (span.end <= span.start + 2 or span.end > src.len) return null;
        const inner = src[span.start + 1 .. span.end - 1];
        if (std.mem.eql(u8, inner, "string")) return .string;
        if (std.mem.eql(u8, inner, "number")) return .number;
        if (std.mem.eql(u8, inner, "boolean")) return .boolean;
        if (std.mem.eql(u8, inner, "bigint")) return .bigint;
        if (std.mem.eql(u8, inner, "undefined")) return .undefined_t;
        return null;
    }

    /// Combine narrow spec with current type: for `typeof x === 'string'`
    /// in truthy branch, keep_only=true → keep only string-ish from a
    /// union (or replace primitive `ID_STRING` etc.).  For !==, drop.
    fn intersectNarrow(self: *Checker, ty: TypeId, kind: Narrowable, keep_only: bool) TypeId {
        // Map the narrowable to its primitive TypeId for whole-type
        // replacement when ty isn't a union.
        const target: TypeId = switch (kind) {
            .string => tymod.ID_STRING,
            .number => tymod.ID_NUMBER,
            .boolean => tymod.ID_BOOLEAN,
            .bigint => tymod.ID_BIGINT,
            .undefined_t => tymod.ID_UNDEFINED,
            .null_t => tymod.ID_NULL,
            .void_t => tymod.ID_VOID,
            .none => return ty,
        };
        const t = self.store.get(ty);
        if (t.kind != .union_t) {
            if (keep_only) {
                // typeof of a non-union value that matches → keep ty;
                // doesn't match → never.
                if (typeIsKindOf(self.store.get(ty).kind, kind)) return ty;
                return target;
            }
            return ty;
        }
        return self.narrowUnion(ty, kind, keep_only);
    }

    const Narrowable = enum(u8) { none, null_t, undefined_t, void_t, string, number, boolean, bigint };

    fn narrowKindFromLiteral(self: *Checker, lit: NodeIndex) Narrowable {
        var n = lit;
        while (self.ast_ref.nodeTag(n) == .grouping_expr) n = self.ast_ref.nodeData(n).lhs;
        const tag = self.ast_ref.nodeTag(n);
        if (tag == .null_literal) return .null_t;
        if (tag == .identifier) {
            const name = self.ast_ref.tokenText(self.ast_ref.nodeMainToken(n));
            if (std.mem.eql(u8, name, "undefined")) return .undefined_t;
        }
        if (tag == .void_expr) return .undefined_t;
        return .none;
    }

    /// Remove a kind from a union, or keep only that kind.
    fn narrowUnion(self: *Checker, ty: TypeId, kind: Narrowable, keep_only: bool) TypeId {
        const t = self.store.get(ty);
        if (t.kind != .union_t) {
            const matches = self.idMatchesNarrowable(ty, kind);
            if (keep_only) return if (matches) ty else tymod.ID_NEVER;
            return if (matches) tymod.ID_NEVER else ty;
        }
        var buf: [16]TypeId = undefined;
        var n: usize = 0;
        for (self.store.idsOf(t.list_data)) |m| {
            const matches = self.idMatchesNarrowable(m, kind);
            if ((keep_only and matches) or (!keep_only and !matches)) {
                if (n >= buf.len) return ty;
                buf[n] = m;
                n += 1;
            }
        }
        if (n == 0) return tymod.ID_NEVER;
        if (n == 1) return buf[0];
        return self.store.unionOf(buf[0..n]) catch ty;
    }

    fn idMatchesNarrowable(self: *Checker, id: TypeId, kind: Narrowable) bool {
        // Also accept the corresponding literal kind for typeof
        // checks (e.g. `typeof x === 'string'` matches both `string`
        // and `'foo'` (string_literal)).
        const k = self.store.get(id).kind;
        if (typeIsKindOf(k, kind)) return true;
        return switch (kind) {
            .null_t => id.eq(tymod.ID_NULL),
            .undefined_t => id.eq(tymod.ID_UNDEFINED) or k == .void_t,
            .void_t => id.eq(tymod.ID_VOID),
            .string => id.eq(tymod.ID_STRING),
            .number => id.eq(tymod.ID_NUMBER),
            .boolean => id.eq(tymod.ID_BOOLEAN),
            .bigint => id.eq(tymod.ID_BIGINT),
            .none => false,
        };
    }

    fn typeIsKindOf(k: tymod.TypeKind, n: Narrowable) bool {
        return switch (n) {
            .string => k == .string or k == .string_literal,
            .number => k == .number or k == .number_literal,
            .boolean => k == .boolean or k == .boolean_literal,
            .bigint => k == .bigint or k == .bigint_literal,
            .undefined_t => k == .undefined_t or k == .void_t,
            .null_t => k == .null_t,
            .void_t => k == .void_t,
            .none => false,
        };
    }

    fn identifierBindsToSym(self: *Checker, node: NodeIndex, sym: symbol_mod.SymbolId) bool {
        if (self.ast_ref.nodeTag(node) != .identifier) return false;
        const s = self.symbolForIdentRef(node) orelse return false;
        return s.toInt() == sym.toInt();
    }

    /// Find the symbol bound to an identifier reference, if any.
    fn symbolForIdentRef(self: *Checker, ident_node: NodeIndex) ?symbol_mod.SymbolId {
        const refs = &self.semantic.references;
        const total = refs.count();
        var i: u32 = 0;
        while (i < total) : (i += 1) {
            const rid = parser.reference.ReferenceId.fromInt(i);
            if (refs.getNode(rid) != ident_node) continue;
            if (!refs.isResolved(rid)) return null;
            return refs.getSymbol(rid);
        }
        return null;
    }

    fn declaredTypeForSymbol(self: *Checker, sym: symbol_mod.SymbolId) TypeId {
        const cached = self.sym_types[sym.toInt()];
        if (!cached.eq(TypeId.none)) return cached;
        // Mark in-progress with .any so recursive lookups can't loop.
        self.sym_types[sym.toInt()] = tymod.ID_ANY;
        const decl_node = self.semantic.symbols.getDeclNode(sym);
        const ty = self.declaredTypeAtBinding(decl_node);
        self.sym_types[sym.toInt()] = ty;
        return ty;
    }

    /// Given a binding identifier node, find its declared TS type by
    /// reading the annotation attached to the identifier (parser stores
    /// the ts_type_annotation node in identifier.data.rhs), or by walking
    /// up to the declarator and falling back to the initializer.
    fn declaredTypeAtBinding(self: *Checker, binding: NodeIndex) TypeId {
        if (binding == .none) return tymod.ID_UNKNOWN;
        // Direct annotation on the identifier.
        if (self.ast_ref.nodeTag(binding) == .identifier) {
            const bd = self.ast_ref.nodeData(binding);
            if (bd.rhs != .none and self.ast_ref.nodeTag(bd.rhs) == .ts_type_annotation) {
                const ty_node = self.ast_ref.nodeData(bd.rhs).lhs;
                return self.resolveTypeNode(ty_node);
            }
        }
        const parents = self.ast_ref.parents;
        if (parents.len == 0) return tymod.ID_ANY;
        const pidx = parents[binding.toInt()];
        if (pidx == @intFromEnum(NodeIndex.none)) return tymod.ID_ANY;
        const parent: NodeIndex = @enumFromInt(pidx);
        const ptag = self.ast_ref.nodeTag(parent);
        switch (ptag) {
            .declarator => {
                const data = self.ast_ref.nodeData(parent);
                if (data.rhs != .none) return self.typeOf(data.rhs);
                return tymod.ID_UNKNOWN;
            },
            // Function declarations: build a function_t from the
            // FnData (params + return).  Caller-side call inference
            // can then resolve the return type and check arg types.
            .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
            .ts_declare_function => return self.functionTypeFromFnDecl(parent),
            .class_decl => return tymod.ID_UNKNOWN,
            // Function/method/getter/setter parameter, class field, etc.
            // We don't resolve these structurally yet — return unknown
            // rather than any so unsafe-* rules don't spuriously fire.
            else => return tymod.ID_UNKNOWN,
        }
    }

    /// Build a function_t from an fn_decl / async_fn_decl / etc. node.
    /// Params come from the FnData params SubRange; each param's
    /// declared annotation (if any) becomes its TypeId, defaulting to
    /// `unknown` when un-annotated.  Return type comes from the
    /// declared annotation, else falls back to body-inference for
    /// arrow-expression-body, else `unknown`.
    fn functionTypeFromFnDecl(self: *Checker, fn_node: NodeIndex) TypeId {
        const data = self.ast_ref.nodeData(fn_node);
        const fd = self.ast_ref.extraData(ast.FnData, @intFromEnum(data.lhs));
        const is_async = switch (self.ast_ref.nodeTag(fn_node)) {
            .async_fn_decl, .async_fn_expr, .async_generator_fn_decl,
            .async_generator_fn_expr => true,
            else => false,
        };
        return self.buildFunctionType(fd.params, fd.params_end, fd.return_type, fd.body, is_async);
    }

    /// Build a function_t from an arrow_fn / async_arrow_fn node.
    fn functionTypeFromArrow(self: *Checker, arrow_node: NodeIndex) TypeId {
        const data = self.ast_ref.nodeData(arrow_node);
        const ad = self.ast_ref.extraData(ast.ArrowData, @intFromEnum(data.lhs));
        const is_async = self.ast_ref.nodeTag(arrow_node) == .async_arrow_fn;
        return self.buildFunctionType(ad.params_start, ad.params_end, ad.return_type, ad.body, is_async);
    }

    fn buildFunctionType(
        self: *Checker,
        params_start: u32,
        params_end: u32,
        return_type_node: NodeIndex,
        body_for_inference: NodeIndex,
        is_async: bool,
    ) TypeId {
        // Resolve each param's type from its annotation.
        var param_buf: [16]tymod.TypeId = undefined;
        var count: usize = 0;
        const ext_len: u32 = @intCast(self.ast_ref.extra_data.len);
        if (params_start <= params_end and params_end <= ext_len) {
            const params = self.ast_ref.extra_data[params_start..params_end];
            for (params) |raw| {
                if (count >= param_buf.len) break;
                const param: NodeIndex = @enumFromInt(raw);
                param_buf[count] = self.paramDeclaredType(param);
                count += 1;
            }
        }
        // Resolve return type.  Declared annotation wins; arrow with
        // expression body uses its body type directly; block-body
        // returns are inferred by walking direct `return <expr>;`
        // statements in the body (no nested function descent).
        var ret_ty: TypeId = tymod.ID_UNKNOWN;
        if (return_type_node != .none and
            self.ast_ref.nodeTag(return_type_node) == .ts_type_annotation)
        {
            const ty_inner = self.ast_ref.nodeData(return_type_node).lhs;
            ret_ty = self.resolveTypeNode(ty_inner);
        } else if (body_for_inference != .none) {
            const btag = self.ast_ref.nodeTag(body_for_inference);
            if (btag != .block_stmt) {
                ret_ty = self.typeOf(body_for_inference);
            } else {
                ret_ty = self.inferBlockReturn(body_for_inference);
            }
        }
        const param_range = self.store.appendSignatureParams(param_buf[0..count]) catch {
            return tymod.ID_UNKNOWN;
        };
        const sig: tymod.Signature = .{
            .params_start = param_range.start,
            .params_end = param_range.end,
            .return_type = ret_ty,
            .is_async = is_async,
        };
        return self.store.functionType(sig) catch tymod.ID_UNKNOWN;
    }

    /// Infer the return type of a block body by union-ing the types
    /// of every `return <expr>;` whose nearest enclosing function is
    /// this block.  Bare `return;` and missing returns contribute
    /// `undefined`.  We approximate the "nearest enclosing function"
    /// check via parent walk.
    fn inferBlockReturn(self: *Checker, body: NodeIndex) TypeId {
        const parents = self.ast_ref.parents;
        if (parents.len == 0) return tymod.ID_UNKNOWN;
        const body_idx = @intFromEnum(body);
        // The body's direct parent is the function node — anything
        // whose parent chain reaches the body BEFORE another function
        // counts.
        const NONE: u32 = @intFromEnum(NodeIndex.none);
        const total: u32 = @intCast(self.ast_ref.nodes.len);
        var result: TypeId = TypeId.none;
        var has_bare_return = false;
        var i: u32 = 0;
        while (i < total) : (i += 1) {
            const ni: NodeIndex = @enumFromInt(i);
            if (self.ast_ref.nodeTag(ni) != .return_stmt) continue;
            // Walk parents up looking for body — stop if we hit
            // another function first.
            var p = parents[i];
            var reached = false;
            while (p != NONE) : (p = parents[p]) {
                if (p == body_idx) { reached = true; break; }
                const pt = self.ast_ref.nodeTag(@enumFromInt(p));
                if (pt == .fn_decl or pt == .async_fn_decl or pt == .generator_fn_decl or
                    pt == .async_generator_fn_decl or pt == .fn_expr or pt == .async_fn_expr or
                    pt == .generator_fn_expr or pt == .async_generator_fn_expr or
                    pt == .arrow_fn or pt == .async_arrow_fn)
                {
                    break;
                }
            }
            if (!reached) continue;
            const arg = self.ast_ref.nodeData(ni).lhs;
            if (arg == .none) { has_bare_return = true; continue; }
            const t = self.typeOf(arg);
            if (result.eq(TypeId.none)) {
                result = t;
            } else if (!result.eq(t)) {
                // Different from prior — union them.
                const ids = [_]TypeId{ result, t };
                result = self.store.unionOf(&ids) catch result;
            }
        }
        if (result.eq(TypeId.none)) return tymod.ID_VOID;
        if (has_bare_return) {
            const ids = [_]TypeId{ result, tymod.ID_UNDEFINED };
            result = self.store.unionOf(&ids) catch result;
        }
        return result;
    }

    fn paramDeclaredType(self: *Checker, param: NodeIndex) TypeId {
        var node = param;
        // Peel assignment_pattern (default value) — the binding side
        // is what carries the annotation.
        if (self.ast_ref.nodeTag(node) == .assignment_pattern) {
            node = self.ast_ref.nodeData(node).lhs;
        }
        // Peel ts_parameter_property (constructor access modifiers).
        if (self.ast_ref.nodeTag(node) == .ts_parameter_property) {
            node = self.ast_ref.nodeData(node).lhs;
        }
        if (self.ast_ref.nodeTag(node) == .rest_element) {
            const rdata = self.ast_ref.nodeData(node);
            if (rdata.rhs != .none and self.ast_ref.nodeTag(rdata.rhs) == .ts_type_annotation) {
                const ty = self.ast_ref.nodeData(rdata.rhs).lhs;
                return self.resolveTypeNode(ty);
            }
            return tymod.ID_UNKNOWN;
        }
        if (self.ast_ref.nodeTag(node) != .identifier) return tymod.ID_UNKNOWN;
        const bd = self.ast_ref.nodeData(node);
        if (bd.rhs == .none) return tymod.ID_UNKNOWN;
        if (self.ast_ref.nodeTag(bd.rhs) != .ts_type_annotation) return tymod.ID_UNKNOWN;
        const ty = self.ast_ref.nodeData(bd.rhs).lhs;
        return self.resolveTypeNode(ty);
    }

    /// Map a TS type-position AST node to a TypeId.
    pub fn resolveTypeNode(self: *Checker, ty_node: NodeIndex) TypeId {
        if (ty_node == .none) return tymod.ID_ANY;
        const tag = self.ast_ref.nodeTag(ty_node);
        return switch (tag) {
            .ts_type_reference => self.resolveTypeRef(ty_node),
            .ts_union_type => self.resolveUnion(ty_node),
            .ts_intersection_type => self.resolveIntersection(ty_node),
            .ts_array_type => blk: {
                const elem = self.resolveTypeNode(self.ast_ref.nodeData(ty_node).lhs);
                break :blk self.store.arrayOf(elem) catch tymod.ID_ANY;
            },
            .ts_parenthesized_type => self.resolveTypeNode(self.ast_ref.nodeData(ty_node).lhs),
            // Unresolved-but-not-any cases default to `unknown` so
            // no-unsafe-* rules don't spuriously fire on objects /
            // functions / etc. declared via structural annotations.
            .ts_typeof_type => tymod.ID_UNKNOWN, // we don't resolve `typeof x` yet
            .ts_keyof_type => blk: {
                // Parser also uses .ts_keyof_type as TSTypeOperator for
                // 'readonly T[]' / 'readonly [T, U]' (TS doesn't share
                // a distinct tag).  Detect the readonly form via the
                // main_token and resolve to the underlying array,
                // converting array_t to readonly_array_t so assignability
                // checks distinguish writable from readonly forms.
                const op_tok = self.ast_ref.nodeMainToken(ty_node);
                const op_text = self.ast_ref.tokenText(op_tok);
                if (std.mem.eql(u8, op_text, "readonly")) {
                    const inner = self.ast_ref.nodeData(ty_node).lhs;
                    const inner_ty = self.resolveTypeNode(inner);
                    const it = self.store.get(inner_ty);
                    if (it.kind == .array_t) {
                        const elems = self.store.idsOf(it.list_data);
                        if (elems.len > 0) break :blk self.store.readonlyArrayOf(elems[0]) catch inner_ty;
                    }
                    break :blk inner_ty;
                }
                break :blk tymod.ID_STRING; // keyof default approx
            },
            .ts_type_literal => self.resolveTypeLiteral(ty_node),
            .ts_function_type, .ts_constructor_type => self.resolveFunctionType(ty_node),
            .ts_tuple_type => self.resolveTupleType(ty_node),
            .ts_indexed_access_type => self.resolveIndexedAccess(ty_node),
            .ts_conditional_type => self.resolveConditionalType(ty_node),
            .ts_mapped_type => self.resolveMappedType(ty_node),
            .ts_template_literal_type => self.resolveTemplateLiteralType(ty_node),
            // Literal types in type position — parser keeps them as
            // value-style literal nodes.
            .string_literal => tymod.ID_STRING,
            .number_literal => tymod.ID_NUMBER,
            .boolean_literal => tymod.ID_BOOLEAN,
            .bigint_literal => tymod.ID_BIGINT,
            .null_literal => tymod.ID_NULL,
            else => tymod.ID_UNKNOWN,
        };
    }

    /// Build a function_t from a ts_function_type / ts_constructor_type
    /// AST node.  Params live at FnData.params..params_end; return type
    /// lives in FnData.body (the parser reuses the field for type-position
    /// function declarations).
    fn resolveFunctionType(self: *Checker, ty_node: NodeIndex) TypeId {
        const data = self.ast_ref.nodeData(ty_node);
        const fd = self.ast_ref.extraData(ast.FnData, @intFromEnum(data.lhs));
        // Resolve params from FnData.params..params_end.
        var param_buf: [16]TypeId = undefined;
        var count: usize = 0;
        const ext_len: u32 = @intCast(self.ast_ref.extra_data.len);
        if (fd.params <= fd.params_end and fd.params_end <= ext_len) {
            const params = self.ast_ref.extra_data[fd.params..fd.params_end];
            for (params) |raw| {
                if (count >= param_buf.len) break;
                const param: NodeIndex = @enumFromInt(raw);
                param_buf[count] = self.paramDeclaredType(param);
                count += 1;
            }
        }
        // Return type is in body for ts_function_type.
        const ret_ty = if (fd.body != .none)
            self.resolveTypeNode(fd.body)
        else
            tymod.ID_UNKNOWN;
        const param_range = self.store.appendSignatureParams(param_buf[0..count]) catch {
            return tymod.ID_UNKNOWN;
        };
        const sig: tymod.Signature = .{
            .params_start = param_range.start,
            .params_end = param_range.end,
            .return_type = ret_ty,
        };
        return self.store.functionType(sig) catch tymod.ID_UNKNOWN;
    }

    /// Walk a `{ k1: T1; k2: T2; ... }` type literal and build an
    /// object_t in the type store.  Captures named property signatures
    /// only — index signatures (`[key: K]: V`) and call/construct
    /// signatures are out of scope (they need separate representation
    /// in our Type model).  Index signatures cause the property lookup
    /// to fall back to "we don't know" — equivalent to unknown.
    /// Source-scan helper: is there a `?` between the end of `name_node`
    /// and the next colon/lparen/lbrace?  Property signatures lose the
    /// optional marker during parse, so we recover it here.
    fn propertyHasOptionalMarker(self: *Checker, name_node: NodeIndex) bool {
        const span = self.ast_ref.nodeSpan(name_node);
        const src = self.ast_ref.source;
        var i: usize = span.end;
        while (i < src.len) : (i += 1) {
            const c = src[i];
            if (c == ' ' or c == '\t' or c == '\n' or c == '\r') continue;
            return c == '?';
        }
        return false;
    }

    fn resolveTypeLiteral(self: *Checker, ty_node: NodeIndex) TypeId {
        // Members range stored directly in lhs/rhs — see directRange comment.
        const data = self.ast_ref.nodeData(ty_node);
        const member_node_indices = self.directRange(data.lhs, data.rhs) orelse return tymod.ID_UNKNOWN;
        var props_buf: [32]tymod.ObjectProp = undefined;
        var prop_count: usize = 0;
        for (member_node_indices) |raw| {
            if (prop_count >= props_buf.len) break;
            const member: NodeIndex = @enumFromInt(raw);
            const m_tag = self.ast_ref.nodeTag(member);
            if (m_tag != .ts_property_signature and m_tag != .ts_method_signature) continue;
            if (m_tag == .ts_property_signature) {
                const member_data = self.ast_ref.nodeData(member);
                const name_node = member_data.lhs;
                if (name_node == .none) continue;
                const name_tok = self.ast_ref.nodeMainToken(name_node);
                const raw_name = self.ast_ref.tokenText(name_tok);
                const name_tag = self.ast_ref.nodeTag(name_node);
                const name = if ((name_tag == .string_literal or name_tag == .template_literal) and raw_name.len >= 2)
                    raw_name[1 .. raw_name.len - 1]
                else
                    raw_name;
                var prop_ty: TypeId = tymod.ID_ANY;
                if (member_data.rhs != .none and self.ast_ref.nodeTag(member_data.rhs) == .ts_type_annotation) {
                    const ty_inner = self.ast_ref.nodeData(member_data.rhs).lhs;
                    prop_ty = self.resolveTypeNode(ty_inner);
                }
                const optional = propertyHasOptionalMarker(self, name_node);
                props_buf[prop_count] = .{ .name = name, .type_id = prop_ty, .optional = optional };
                prop_count += 1;
            } else {
                // ts_method_signature: name is in InterfaceSigData.key.
                const sig_data = self.ast_ref.extraData(ast.InterfaceSigData, @intFromEnum(self.ast_ref.nodeData(member).lhs));
                if (sig_data.key == .none) continue;
                const name_tag = self.ast_ref.nodeTag(sig_data.key);
                const name = blk: {
                    // Computed `[Symbol.toPrimitive]` key — synthesize a stable
                    // name so consumers can detect user-defined string coercion.
                    if (name_tag == .member_expr or name_tag == .optional_member_expr) {
                        const kd = self.ast_ref.nodeData(sig_data.key);
                        if (kd.lhs != .none and kd.rhs != .none and
                            self.ast_ref.nodeTag(kd.lhs) == .identifier)
                        {
                            const obj = self.ast_ref.tokenText(self.ast_ref.nodeMainToken(kd.lhs));
                            const prop = self.ast_ref.tokenText(self.ast_ref.nodeMainToken(kd.rhs));
                            if (std.mem.eql(u8, obj, "Symbol") and std.mem.eql(u8, prop, "toPrimitive")) {
                                break :blk "@@toPrimitive";
                            }
                        }
                    }
                    const name_tok = self.ast_ref.nodeMainToken(sig_data.key);
                    const raw_name = self.ast_ref.tokenText(name_tok);
                    break :blk if ((name_tag == .string_literal or name_tag == .template_literal) and raw_name.len >= 2)
                        raw_name[1 .. raw_name.len - 1]
                    else
                        raw_name;
                };
                const fn_ty = self.buildFunctionType(
                    sig_data.params_start,
                    sig_data.params_end,
                    sig_data.return_type,
                    .none,
                    false,
                );
                props_buf[prop_count] = .{ .name = name, .type_id = fn_ty };
                prop_count += 1;
            }
        }
        const list = self.store.appendObjectProps(props_buf[0..prop_count]) catch return tymod.ID_UNKNOWN;
        return self.store.add(.{ .kind = .object_t, .object_props = list }) catch tymod.ID_UNKNOWN;
    }

    /// Evaluate a `ts_mapped_type` AST node into an `object_t` whose
    /// props are the keys named by the constraint, each typed by the
    /// value-type expression.  Only handles cases where the constraint
    /// is a closed set of string-literal types (the form rules care
    /// about, e.g. `{ [K in 'toString' | 'valueOf']: ... }`).
    /// Evaluate a template-literal type into a concrete string-literal
    /// when every interpolation resolves to a string-literal type.
    /// Otherwise approximate as `string`.  Composes results across
    /// unions: each interpolation can expand to multiple variants
    /// when its type is a union of string literals; the result is the
    /// cross-product of all such variants.
    fn resolveTemplateLiteralType(self: *Checker, ty_node: NodeIndex) TypeId {
        const data = self.ast_ref.nodeData(ty_node);
        const slice = self.directRange(data.lhs, data.rhs) orelse return tymod.ID_STRING;
        // Parts alternate template_element (quasi) and expression
        // (interpolation type).  Accumulate possible string variants.
        var variants: std.ArrayList([]const u8) = .empty;
        defer variants.deinit(self.gpa);
        variants.append(self.gpa, "") catch return tymod.ID_STRING;
        for (slice) |raw| {
            const part: NodeIndex = @enumFromInt(raw);
            if (self.ast_ref.nodeTag(part) == .template_element) {
                const tok = self.ast_ref.nodeMainToken(part);
                const start = self.ast_ref.tokenStart(tok);
                const len = self.ast_ref.tokens.items(.len)[tok];
                const src = self.ast_ref.source;
                if (start + len > src.len) return tymod.ID_STRING;
                var span_start = start;
                var span_end: u32 = start + len;
                if (span_start < span_end and (src[span_start] == '`' or src[span_start] == '}')) span_start += 1;
                if (span_end >= span_start + 2 and src[span_end - 1] == '{' and src[span_end - 2] == '$') {
                    span_end -= 2;
                } else if (span_end > span_start and src[span_end - 1] == '`') {
                    span_end -= 1;
                }
                const quasi_text = src[span_start..span_end];
                if (quasi_text.len == 0) continue;
                for (variants.items) |*v| {
                    const joined = std.fmt.allocPrint(self.gpa, "{s}{s}", .{ v.*, quasi_text }) catch return tymod.ID_STRING;
                    v.* = joined;
                }
                continue;
            }
            // Interpolation — gather string-literal options.
            const id = self.resolveTypeNode(part);
            var options_buf: [16][]const u8 = undefined;
            const opt_count = self.gatherStringLiteralOptions(id, &options_buf) catch return tymod.ID_STRING;
            if (opt_count == 0) return tymod.ID_STRING;
            const prev_len = variants.items.len;
            // Cross product: each existing variant × each option.
            for (0..opt_count - 1) |_| {
                var dup_i: usize = 0;
                while (dup_i < prev_len) : (dup_i += 1) {
                    variants.append(self.gpa, variants.items[dup_i]) catch return tymod.ID_STRING;
                }
            }
            // Append option suffix to each variant slot.
            var oi: usize = 0;
            while (oi < opt_count) : (oi += 1) {
                var vi: usize = 0;
                while (vi < prev_len) : (vi += 1) {
                    const slot = oi * prev_len + vi;
                    const joined = std.fmt.allocPrint(self.gpa, "{s}{s}", .{ variants.items[slot], options_buf[oi] }) catch return tymod.ID_STRING;
                    variants.items[slot] = joined;
                }
            }
        }
        if (variants.items.len == 0) return tymod.ID_STRING;
        if (variants.items.len == 1) {
            return self.store.add(.{ .kind = .string_literal, .literal_value = .{ .string = variants.items[0] } }) catch tymod.ID_STRING;
        }
        var ids_buf: [16]TypeId = undefined;
        const n = @min(variants.items.len, ids_buf.len);
        var i: usize = 0;
        while (i < n) : (i += 1) {
            ids_buf[i] = self.store.add(.{ .kind = .string_literal, .literal_value = .{ .string = variants.items[i] } }) catch return tymod.ID_STRING;
        }
        return self.store.unionOf(ids_buf[0..n]) catch tymod.ID_STRING;
    }

    /// Collect string-literal values from a type id (or a union of
    /// them).  Returns the count written; returns 0 when the type
    /// can't be reduced to concrete strings.
    fn gatherStringLiteralOptions(self: *Checker, id: TypeId, out: *[16][]const u8) !usize {
        const t = self.store.get(id);
        if (t.kind == .string_literal) {
            out[0] = switch (t.literal_value) { .string => |s| s, else => return 0 };
            return 1;
        }
        if (t.kind == .union_t) {
            var n: usize = 0;
            for (self.store.idsOf(t.list_data)) |m| {
                const mt = self.store.get(m);
                if (mt.kind != .string_literal) return 0;
                if (n >= out.len) return 0;
                out[n] = switch (mt.literal_value) { .string => |s| s, else => return 0 };
                n += 1;
            }
            return n;
        }
        return 0;
    }

    /// Evaluate `T extends U ? A : B`.  We support only the cases
    /// where the relation is decidable from the type representations
    /// available — primitive vs primitive, literal vs base type, void
    /// vs void.  When undecidable we union the two branches so
    /// downstream rules don't pick a wrong arm.
    fn resolveConditionalType(self: *Checker, ty_node: NodeIndex) TypeId {
        const data = self.ast_ref.nodeData(ty_node);
        const slice = self.directRange(data.lhs, data.rhs) orelse return tymod.ID_UNKNOWN;
        if (slice.len < 4) return tymod.ID_UNKNOWN;
        const check_node: NodeIndex = @enumFromInt(slice[0]);
        const extends_node: NodeIndex = @enumFromInt(slice[1]);
        const true_node: NodeIndex = @enumFromInt(slice[2]);
        const false_node: NodeIndex = @enumFromInt(slice[3]);
        const check_ty = self.resolveTypeNode(check_node);
        const extends_ty = self.resolveTypeNode(extends_node);
        switch (self.simpleAssignable(check_ty, extends_ty)) {
            .yes => return self.resolveTypeNode(true_node),
            .no => return self.resolveTypeNode(false_node),
            .unknown => {
                const a = self.resolveTypeNode(true_node);
                const b = self.resolveTypeNode(false_node);
                return self.store.unionOf(&.{ a, b }) catch tymod.ID_UNKNOWN;
            },
        }
    }

    /// Three-valued assignability check for the cases we can decide
    /// without a full TypeScript-style relation algebra.  Returns
    /// `.unknown` when either side is `any`/`unknown` or the
    /// relation depends on machinery we don't implement.
    pub const AssignResult = enum { yes, no, unknown };
    pub fn simpleAssignablePub(self: *Checker, source: TypeId, target: TypeId) AssignResult {
        return self.simpleAssignable(source, target);
    }
    fn simpleAssignable(self: *Checker, source: TypeId, target: TypeId) AssignResult {
        if (source.eq(target)) return .yes;
        if (target.eq(tymod.ID_ANY) or source.eq(tymod.ID_ANY)) return .yes;
        if (target.eq(tymod.ID_UNKNOWN)) return .yes;
        const s = self.store.get(source);
        const t = self.store.get(target);
        // Primitive kind match.
        if (s.kind == t.kind) {
            switch (s.kind) {
                .number, .string, .boolean, .bigint, .symbol,
                .null_t, .undefined_t, .void_t, .object_keyword,
                => return .yes,
                else => {},
            }
        }
        // Literal types assign to their base.
        if (t.kind == .number and s.kind == .number_literal) return .yes;
        if (t.kind == .string and s.kind == .string_literal) return .yes;
        if (t.kind == .boolean and s.kind == .boolean_literal) return .yes;
        if (t.kind == .bigint and s.kind == .bigint_literal) return .yes;
        // Union targets: assignable if assignable to any member.
        if (t.kind == .union_t) {
            var any_unknown = false;
            for (self.store.idsOf(t.list_data)) |m| {
                switch (self.simpleAssignable(source, m)) {
                    .yes => return .yes,
                    .unknown => any_unknown = true,
                    .no => {},
                }
            }
            return if (any_unknown) .unknown else .no;
        }
        // Union sources: assignable if EVERY member is assignable.
        if (s.kind == .union_t) {
            var any_unknown = false;
            for (self.store.idsOf(s.list_data)) |m| {
                switch (self.simpleAssignable(m, target)) {
                    .yes => {},
                    .no => return .no,
                    .unknown => any_unknown = true,
                }
            }
            return if (any_unknown) .unknown else .yes;
        }
        return .unknown;
    }

    /// Evaluate a `ts_indexed_access_type` (`T[K]`) when both sides
    /// are statically resolvable: object types looked up by a string-
    /// literal key, array/tuple types indexed by `number` or a numeric
    /// literal, and unions distribute member-wise.
    fn resolveIndexedAccess(self: *Checker, ty_node: NodeIndex) TypeId {
        const data = self.ast_ref.nodeData(ty_node);
        if (data.lhs == .none or data.rhs == .none) return tymod.ID_UNKNOWN;
        const obj_ty = self.resolveTypeNode(data.lhs);
        // Collect candidate string keys from the index type.  We accept
        // string literal types directly and unions of them.
        var key_buf: [16][]const u8 = undefined;
        const key_count = self.collectStringLiteralKeys(data.rhs, &key_buf, 0) orelse {
            // `keyof T` / `number` index → return any prop's union; for
            // arrays index = number → element type.
            const idx_tag = self.ast_ref.nodeTag(data.rhs);
            if (idx_tag == .ts_type_reference) {
                const name = self.ast_ref.tokenText(self.ast_ref.nodeMainToken(data.rhs));
                if (std.mem.eql(u8, name, "number")) {
                    const ot = self.store.get(obj_ty);
                    if (ot.kind == .array_t or ot.kind == .readonly_array_t or ot.kind == .tuple_t) {
                        const elems = self.store.idsOf(ot.list_data);
                        if (ot.kind == .tuple_t and elems.len > 0) {
                            return self.store.unionOf(elems) catch tymod.ID_UNKNOWN;
                        }
                        if (elems.len > 0) return elems[0];
                    }
                }
            }
            return tymod.ID_UNKNOWN;
        };
        if (key_count == 0) return tymod.ID_UNKNOWN;
        var member_buf: [16]TypeId = undefined;
        var member_n: usize = 0;
        var i: usize = 0;
        while (i < key_count) : (i += 1) {
            const t = self.propertyTypeOfTypeId(obj_ty, key_buf[i]) orelse continue;
            if (member_n < member_buf.len) {
                member_buf[member_n] = t;
                member_n += 1;
            }
        }
        if (member_n == 0) return tymod.ID_UNKNOWN;
        if (member_n == 1) return member_buf[0];
        return self.store.unionOf(member_buf[0..member_n]) catch tymod.ID_UNKNOWN;
    }

    /// Look up `key` in `obj_ty`'s structural shape, walking unions/
    /// intersections.  Returns the prop's TypeId when found.
    fn propertyTypeOfTypeId(self: *Checker, obj_ty: TypeId, key: []const u8) ?TypeId {
        const t = self.store.get(obj_ty);
        if (t.kind == .object_t) {
            for (self.store.propsOf(t.object_props)) |p| {
                if (std.mem.eql(u8, p.name, key)) return p.type_id;
            }
            return null;
        }
        if (t.kind == .union_t or t.kind == .intersection_t) {
            for (self.store.idsOf(t.list_data)) |m| {
                if (self.propertyTypeOfTypeId(m, key)) |r| return r;
            }
        }
        return null;
    }

    fn resolveMappedType(self: *Checker, ty_node: NodeIndex) TypeId {
        const data = self.ast_ref.nodeData(ty_node);
        const slice = self.directRange(data.lhs, data.rhs) orelse return tymod.ID_UNKNOWN;
        // SubRange layout for ts_mapped_type: [key_param, constraint, as_type, value_type]
        if (slice.len < 4) return tymod.ID_UNKNOWN;
        const constraint: NodeIndex = @enumFromInt(slice[1]);
        const as_type: NodeIndex = @enumFromInt(slice[2]);
        const value_type: NodeIndex = @enumFromInt(slice[3]);
        if (constraint == .none or value_type == .none) return tymod.ID_UNKNOWN;
        // `as` clause not modelled — bail to keep semantics safe.
        if (as_type != .none) return tymod.ID_UNKNOWN;

        var keys_buf: [16][]const u8 = undefined;
        const key_count = self.collectStringLiteralKeys(constraint, &keys_buf, 0) orelse return tymod.ID_UNKNOWN;
        if (key_count == 0) return tymod.ID_UNKNOWN;

        const val_ty = self.resolveTypeNode(value_type);
        var props_buf: [16]tymod.ObjectProp = undefined;
        var prop_count: usize = 0;
        var i: usize = 0;
        while (i < key_count) : (i += 1) {
            const name = keys_buf[i];
            // TypeScript synthesises mapped-type properties without a real
            // declaration node — TSe's `no-base-to-string` (and similar
            // rules) intentionally treat these as if the default Object
            // method applies, so a mapped `toString` / `toLocaleString` /
            // `valueOf` key does NOT count as user-defined coercion.
            // Skipping the prop keeps `hasUserStringCoercion`-style checks
            // honest while still producing a real object_t for the type.
            if (std.mem.eql(u8, name, "toString") or
                std.mem.eql(u8, name, "toLocaleString") or
                std.mem.eql(u8, name, "valueOf"))
            {
                continue;
            }
            props_buf[prop_count] = .{ .name = name, .type_id = val_ty };
            prop_count += 1;
        }
        const list = self.store.appendObjectProps(props_buf[0..prop_count]) catch return tymod.ID_UNKNOWN;
        return self.store.add(.{ .kind = .object_t, .object_props = list }) catch tymod.ID_UNKNOWN;
    }

    /// Walk `node` collecting any string-literal type members it
    /// represents.  Handles plain `string_literal`, parenthesised
    /// wrappers, unions of string literals, and aliases that
    /// resolve to the same.  Returns the count written, or null if
    /// any member can't be reduced to a known string key.
    fn collectStringLiteralKeys(
        self: *Checker,
        node: NodeIndex,
        out: *[16][]const u8,
        start: usize,
    ) ?usize {
        var n = node;
        while (self.ast_ref.nodeTag(n) == .ts_parenthesized_type) n = self.ast_ref.nodeData(n).lhs;
        const tag = self.ast_ref.nodeTag(n);
        if (tag == .string_literal) {
            if (start >= out.len) return null;
            const tok = self.ast_ref.nodeMainToken(n);
            const raw = self.ast_ref.tokenText(tok);
            const name = if (raw.len >= 2) raw[1 .. raw.len - 1] else raw;
            out[start] = name;
            return start + 1;
        }
        // TS parses `'foo'` in type position as ts_type_reference whose
        // main_token is the quoted literal text — peel the quotes.
        if (tag == .ts_type_reference) {
            const tok = self.ast_ref.nodeMainToken(n);
            const raw = self.ast_ref.tokenText(tok);
            if (raw.len >= 2 and (raw[0] == '\'' or raw[0] == '"' or raw[0] == '`')) {
                if (start >= out.len) return null;
                out[start] = raw[1 .. raw.len - 1];
                return start + 1;
            }
            const name = raw;
            const decl = self.type_decl_nodes.get(name) orelse return null;
            if (self.ast_ref.nodeTag(decl) != .ts_type_alias_decl) return null;
            const dd = self.ast_ref.nodeData(decl);
            const ad = self.ast_ref.extraData(ast.TypeAliasData, @intFromEnum(dd.lhs));
            return self.collectStringLiteralKeys(ad.type_node, out, start);
        }
        if (tag == .ts_union_type) {
            const d = self.ast_ref.nodeData(n);
            const members = self.directRange(d.lhs, d.rhs) orelse return null;
            var pos = start;
            for (members) |raw_idx| {
                const member: NodeIndex = @enumFromInt(raw_idx);
                pos = self.collectStringLiteralKeys(member, out, pos) orelse return null;
            }
            return pos;
        }
        if (tag == .identifier) {
            const tok = self.ast_ref.nodeMainToken(n);
            const name = self.ast_ref.tokenText(tok);
            const decl = self.type_decl_nodes.get(name) orelse return null;
            if (self.ast_ref.nodeTag(decl) != .ts_type_alias_decl) return null;
            const dd = self.ast_ref.nodeData(decl);
            const ad = self.ast_ref.extraData(ast.TypeAliasData, @intFromEnum(dd.lhs));
            return self.collectStringLiteralKeys(ad.type_node, out, start);
        }
        return null;
    }

    /// Walk the AST once and collect names declared as types.  Sources:
    ///   * ts_type_alias_decl, ts_interface_decl, ts_enum_decl
    ///   * class_decl (also acts as a type name)
    ///   * ts_namespace_decl, ts_module_decl
    ///   * import_specifier / import_default_specifier / import_namespace_specifier
    ///   * ts_type_parameter (generic params)
    /// We also pre-populate built-in lib type names so common imports
    /// like `Date`, `Map`, `Promise<T>` don't get classified as errors.
    /// True when an enum member's initializer is string-valued.  Handles
    /// direct string/template literals and call/member expressions
    /// whose source includes a string literal hint.
    fn enumMemberKindIsString(self: *Checker, init_node: NodeIndex) bool {
        var n = init_node;
        while (self.ast_ref.nodeTag(n) == .grouping_expr) n = self.ast_ref.nodeData(n).lhs;
        const t = self.ast_ref.nodeTag(n);
        if (t == .string_literal) return true;
        if (t == .template_literal) {
            // Template without substitutions is string; with substitutions
            // we can't tell — fall through.
            return true;
        }
        // Cross-enum reference: First.A where First is a string enum.
        if (t == .member_expr or t == .optional_member_expr) {
            const md = self.ast_ref.nodeData(n);
            if (md.lhs != .none and self.ast_ref.nodeTag(md.lhs) == .identifier) {
                const obj_name = self.ast_ref.tokenText(self.ast_ref.nodeMainToken(md.lhs));
                if (self.enum_kinds.get(obj_name)) |k| return k == .string;
            }
        }
        // Function call returning string — resolve via type checker.
        const ty = self.typeOf(n);
        const tt = self.store.get(ty);
        if (tt.kind == .string or tt.kind == .string_literal) return true;
        return false;
    }

    fn enumMemberKindIsNumber(self: *Checker, init_node: NodeIndex) bool {
        var n = init_node;
        while (self.ast_ref.nodeTag(n) == .grouping_expr) n = self.ast_ref.nodeData(n).lhs;
        const t = self.ast_ref.nodeTag(n);
        if (t == .number_literal or t == .bigint_literal) return true;
        if (t == .unary_minus or t == .unary_plus) {
            return self.enumMemberKindIsNumber(self.ast_ref.nodeData(n).lhs);
        }
        if (t == .member_expr or t == .optional_member_expr) {
            const md = self.ast_ref.nodeData(n);
            if (md.lhs != .none and self.ast_ref.nodeTag(md.lhs) == .identifier) {
                const obj_name = self.ast_ref.tokenText(self.ast_ref.nodeMainToken(md.lhs));
                if (self.enum_kinds.get(obj_name)) |k| return k == .number;
            }
        }
        const ty = self.typeOf(n);
        const tt = self.store.get(ty);
        if (tt.kind == .number or tt.kind == .number_literal or
            tt.kind == .bigint or tt.kind == .bigint_literal) return true;
        return false;
    }

    pub fn enumKindOf(self: *const Checker, name: []const u8) ?EnumKind {
        return self.enum_kinds.get(name);
    }

    /// Populate `global_value_types` with structural shapes for the
    /// well-known JS globals that lint rules care about.  This is a
    /// hand-curated subset of TSC's lib.es5/lib.dom — enough to type
    /// `console.log()` as `void`, `JSON.parse()` as `any`,
    /// `Math.random()` as `number`, etc.  Expand as rules need more.
    fn buildGlobalValueTypes(self: *Checker) !void {
        // ── helpers ───────────────────────────────────────────
        const Helper = struct {
            checker: *Checker,
            fn fnType(h: @This(), ret: TypeId) !TypeId {
                const sig = tymod.Signature{
                    .params_start = 0,
                    .params_end = 0,
                    .return_type = ret,
                };
                return try h.checker.store.functionType(sig);
            }
            fn fnTypeWithParams(h: @This(), params: []const TypeId, ret: TypeId) !TypeId {
                const pr = try h.checker.store.appendSignatureParams(params);
                const sig = tymod.Signature{
                    .params_start = pr.start,
                    .params_end = pr.end,
                    .return_type = ret,
                };
                return try h.checker.store.functionType(sig);
            }
            fn objType(h: @This(), props: []const tymod.ObjectProp) !TypeId {
                const list = try h.checker.store.appendObjectProps(props);
                return try h.checker.store.add(.{ .kind = .object_t, .object_props = list });
            }
        };
        const h = Helper{ .checker = self };

        // Console — every method returns void.
        const void_fn = try h.fnType(tymod.ID_VOID);
        const console_methods = [_][]const u8{
            "log", "error", "warn", "info", "debug", "trace",
            "dir", "dirxml", "table", "group", "groupEnd",
            "groupCollapsed", "time", "timeEnd", "timeLog",
            "count", "countReset", "clear", "assert", "profile",
            "profileEnd", "timeStamp",
        };
        var console_props: [console_methods.len]tymod.ObjectProp = undefined;
        for (console_methods, 0..) |name, i| {
            console_props[i] = .{ .name = name, .type_id = void_fn };
        }
        const console_ty = try h.objType(&console_props);
        try self.global_value_types.put(self.gpa, "console", console_ty);

        // Math — selection of common methods returning number.
        const num_fn = try h.fnType(tymod.ID_NUMBER);
        const math_methods = [_][]const u8{
            "random", "floor", "ceil", "round", "trunc", "abs",
            "min", "max", "sign", "sqrt", "cbrt", "pow", "exp",
            "log", "log2", "log10", "log1p", "expm1", "hypot",
            "sin", "cos", "tan", "asin", "acos", "atan", "atan2",
            "sinh", "cosh", "tanh", "asinh", "acosh", "atanh",
            "fround", "clz32", "imul",
        };
        var math_props_buf: [math_methods.len + 8]tymod.ObjectProp = undefined;
        var math_n: usize = 0;
        for (math_methods) |name| {
            math_props_buf[math_n] = .{ .name = name, .type_id = num_fn };
            math_n += 1;
        }
        // Math constants — number-typed.
        const math_constants = [_][]const u8{ "E", "LN10", "LN2", "LOG10E", "LOG2E", "PI", "SQRT1_2", "SQRT2" };
        for (math_constants) |name| {
            math_props_buf[math_n] = .{ .name = name, .type_id = tymod.ID_NUMBER };
            math_n += 1;
        }
        const math_ty = try h.objType(math_props_buf[0..math_n]);
        try self.global_value_types.put(self.gpa, "Math", math_ty);

        // JSON — parse: any, stringify: string.
        const any_fn = try h.fnType(tymod.ID_ANY);
        const str_fn = try h.fnType(tymod.ID_STRING);
        const json_props = [_]tymod.ObjectProp{
            .{ .name = "parse", .type_id = any_fn },
            .{ .name = "stringify", .type_id = str_fn },
        };
        const json_ty = try h.objType(&json_props);
        try self.global_value_types.put(self.gpa, "JSON", json_ty);

        // Number — global constructor + utilities; calling it returns number.
        const number_props = [_]tymod.ObjectProp{
            .{ .name = "isFinite", .type_id = try h.fnType(tymod.ID_BOOLEAN) },
            .{ .name = "isInteger", .type_id = try h.fnType(tymod.ID_BOOLEAN) },
            .{ .name = "isNaN", .type_id = try h.fnType(tymod.ID_BOOLEAN) },
            .{ .name = "isSafeInteger", .type_id = try h.fnType(tymod.ID_BOOLEAN) },
            .{ .name = "parseFloat", .type_id = try h.fnType(tymod.ID_NUMBER) },
            .{ .name = "parseInt", .type_id = try h.fnType(tymod.ID_NUMBER) },
            .{ .name = "EPSILON", .type_id = tymod.ID_NUMBER },
            .{ .name = "MAX_SAFE_INTEGER", .type_id = tymod.ID_NUMBER },
            .{ .name = "MIN_SAFE_INTEGER", .type_id = tymod.ID_NUMBER },
            .{ .name = "MAX_VALUE", .type_id = tymod.ID_NUMBER },
            .{ .name = "MIN_VALUE", .type_id = tymod.ID_NUMBER },
            .{ .name = "NaN", .type_id = tymod.ID_NUMBER },
            .{ .name = "NEGATIVE_INFINITY", .type_id = tymod.ID_NUMBER },
            .{ .name = "POSITIVE_INFINITY", .type_id = tymod.ID_NUMBER },
        };
        // The global Number is also callable: `Number(x)` → number.
        const number_callable = try h.fnTypeWithParams(&.{tymod.ID_ANY}, tymod.ID_NUMBER);
        // Stash it on `Number` itself via the same TypeId — at the
        // value site we look up `Number` and read its .signatures when
        // present.  For simplicity expose Number as the function type
        // and attach static methods via a parallel namespace name.
        try self.global_value_types.put(self.gpa, "Number", number_callable);
        const number_static_ty = try h.objType(&number_props);
        // (No standard way to merge call sigs + props yet — rules that
        // need both go through `Number.isFinite` lookups: register the
        // namespace under a second key the member-access path can use.)
        try self.global_value_types.put(self.gpa, "__Number_static", number_static_ty);

        // String — global constructor returning string.
        try self.global_value_types.put(self.gpa, "String", try h.fnTypeWithParams(&.{tymod.ID_ANY}, tymod.ID_STRING));
        // Boolean — global constructor returning boolean.
        try self.global_value_types.put(self.gpa, "Boolean", try h.fnTypeWithParams(&.{tymod.ID_ANY}, tymod.ID_BOOLEAN));
        // parseInt / parseFloat / isNaN / isFinite — global functions.
        try self.global_value_types.put(self.gpa, "parseInt", try h.fnTypeWithParams(&.{tymod.ID_STRING}, tymod.ID_NUMBER));
        try self.global_value_types.put(self.gpa, "parseFloat", try h.fnTypeWithParams(&.{tymod.ID_STRING}, tymod.ID_NUMBER));
        try self.global_value_types.put(self.gpa, "isNaN", try h.fnTypeWithParams(&.{tymod.ID_ANY}, tymod.ID_BOOLEAN));
        try self.global_value_types.put(self.gpa, "isFinite", try h.fnTypeWithParams(&.{tymod.ID_ANY}, tymod.ID_BOOLEAN));
        // `void`-like literals exposed as values.
        try self.global_value_types.put(self.gpa, "undefined", tymod.ID_UNDEFINED);
        try self.global_value_types.put(self.gpa, "NaN", tymod.ID_NUMBER);
        try self.global_value_types.put(self.gpa, "Infinity", tymod.ID_NUMBER);

        // Process / globalThis — keep as `any` so member access on
        // `process.cwd()` doesn't trip strict rules but doesn't
        // hallucinate types we haven't modelled.
        try self.global_value_types.put(self.gpa, "process", tymod.ID_ANY);
        try self.global_value_types.put(self.gpa, "globalThis", tymod.ID_ANY);
        try self.global_value_types.put(self.gpa, "window", tymod.ID_ANY);
        try self.global_value_types.put(self.gpa, "document", tymod.ID_ANY);
        try self.global_value_types.put(self.gpa, "self", tymod.ID_ANY);
    }

    fn buildKnownTypeNames(self: *Checker) !void {
        const lib_types = [_][]const u8{
            "Array", "ReadonlyArray", "Promise", "Map", "Set", "WeakMap", "WeakSet",
            "Date", "RegExp", "Error", "TypeError", "RangeError", "SyntaxError",
            "ReferenceError", "URIError", "EvalError", "AggregateError",
            "Function", "Object", "Symbol", "BigInt", "JSON", "Math",
            "Iterable", "AsyncIterable", "IterableIterator", "AsyncIterator",
            "Iterator", "Generator", "AsyncGenerator", "AsyncIterableIterator",
            "Record", "Partial", "Required", "Readonly", "Pick", "Omit",
            "Exclude", "Extract", "Parameters", "ReturnType",
            "ConstructorParameters", "InstanceType", "NonNullable", "Awaited",
            "ThisType", "NoInfer", "ThisParameterType", "OmitThisParameter",
            "Uppercase", "Lowercase", "Capitalize", "Uncapitalize",
            "ArrayLike", "PropertyKey", "PropertyDescriptor", "PropertyDescriptorMap",
            "TemplateStringsArray", "Buffer", "URL", "URLSearchParams",
            "Element", "HTMLElement", "Node", "Event", "Window", "Document",
            "console", "process",
        };
        for (lib_types) |name| try self.known_type_names.put(self.gpa, name, {});

        const total: u32 = @intCast(self.ast_ref.nodes.len);
        var i: u32 = 0;
        while (i < total) : (i += 1) {
            const ni: NodeIndex = @enumFromInt(i);
            const tag = self.ast_ref.nodeTag(ni);
            const data = self.ast_ref.nodeData(ni);
            switch (tag) {
                .ts_type_alias_decl => {
                    const ad = self.ast_ref.extraData(ast.TypeAliasData, @intFromEnum(data.lhs));
                    const name = self.ast_ref.tokenText(ad.name);
                    try self.known_type_names.put(self.gpa, name, {});
                    try self.type_decl_nodes.put(self.gpa, name, ni);
                },
                .ts_interface_decl => {
                    const id = self.ast_ref.extraData(ast.InterfaceData, @intFromEnum(data.lhs));
                    const name = self.ast_ref.tokenText(id.name);
                    try self.known_type_names.put(self.gpa, name, {});
                    try self.type_decl_nodes.put(self.gpa, name, ni);
                },
                .ts_enum_decl => {
                    const ed = self.ast_ref.extraData(ast.EnumData, @intFromEnum(data.lhs));
                    const enum_name = self.ast_ref.tokenText(ed.name);
                    try self.known_type_names.put(self.gpa, enum_name, {});
                    try self.type_decl_nodes.put(self.gpa, enum_name, ni);
                    // Determine the ESTABLISHED member kind: the kind of
                    // the FIRST member with a concrete value (string or
                    // number).  This is the rule's "established" kind:
                    // subsequent mismatches fire.  Decl merging: only set
                    // if no prior decl with the same name already set it.
                    if (self.enum_kinds.get(enum_name) == null) {
                        var saw_number = false;
                        var saw_string = false;
                        if (ed.members_start < ed.members_end and ed.members_end <= self.ast_ref.extra_data.len) {
                            for (self.ast_ref.extra_data[ed.members_start..ed.members_end]) |raw| {
                                const m: NodeIndex = @enumFromInt(raw);
                                if (self.ast_ref.nodeTag(m) != .ts_enum_member) continue;
                                const md = self.ast_ref.nodeData(m);
                                if (md.rhs == .none) {
                                    saw_number = true; // auto-increment is numeric
                                    continue;
                                }
                                if (self.enumMemberKindIsString(md.rhs)) { saw_string = true; continue; }
                                if (self.enumMemberKindIsNumber(md.rhs)) { saw_number = true; continue; }
                            }
                        }
                        const kind: ?EnumKind = if (saw_string and saw_number) .mixed
                            else if (saw_string) .string
                            else if (saw_number) .number
                            else null;
                        if (kind) |k| try self.enum_kinds.put(self.gpa, enum_name, k);
                    }
                },
                .class_decl => {
                    const cd = self.ast_ref.extraData(ast.ClassData, @intFromEnum(data.lhs));
                    if (cd.name != .none) {
                        const tok = self.ast_ref.nodeMainToken(cd.name);
                        const name = self.ast_ref.tokenText(tok);
                        try self.known_type_names.put(self.gpa, name, {});
                        try self.type_decl_nodes.put(self.gpa, name, ni);
                    }
                },
                .ts_namespace_decl, .ts_module_decl => {
                    if (data.lhs != .none) {
                        const tok = self.ast_ref.nodeMainToken(data.lhs);
                        try self.known_type_names.put(self.gpa, self.ast_ref.tokenText(tok), {});
                    }
                },
                .import_specifier, .import_default_specifier,
                .import_namespace_specifier, .ts_type_parameter => {
                    const tok = self.ast_ref.nodeMainToken(ni);
                    try self.known_type_names.put(self.gpa, self.ast_ref.tokenText(tok), {});
                },
                else => {},
            }
        }
    }

    fn resolveTypeRef(self: *Checker, ty_node: NodeIndex) TypeId {
        const name_tok = self.ast_ref.nodeMainToken(ty_node);
        const name = self.ast_ref.tokenText(name_tok);
        // Literal types in type position end up as a ts_type_reference
        // whose name token is the literal source — recognize the
        // common shapes and map them to the corresponding TS keyword.
        if (name.len > 0) switch (name[0]) {
            // Quoted string literal in type position → string_literal type
            // carrying the unquoted value.  Subset of `string` for
            // assignability purposes.
            '\'', '"', '`' => {
                const inner: []const u8 = if (name.len >= 2) name[1 .. name.len - 1] else "";
                return self.store.add(.{
                    .kind = .string_literal,
                    .literal_value = .{ .string = inner },
                }) catch tymod.ID_STRING;
            },
            // Numeric literal types: `0n` (bigint_literal), `0`/`1.5`
            // (number_literal).
            '0'...'9' => {
                if (name[name.len - 1] == 'n') {
                    return self.store.add(.{
                        .kind = .bigint_literal,
                        .literal_value = .{ .bigint = name[0 .. name.len - 1] },
                    }) catch tymod.ID_BIGINT;
                }
                return self.store.add(.{
                    .kind = .number_literal,
                    .literal_value = .{ .number = std.fmt.parseFloat(f64, name) catch 0 },
                }) catch tymod.ID_NUMBER;
            },
            else => {},
        };
        if (std.mem.eql(u8, name, "true")) {
            return self.store.add(.{ .kind = .boolean_literal, .literal_value = .{ .boolean = true } }) catch tymod.ID_BOOLEAN;
        }
        if (std.mem.eql(u8, name, "false")) {
            return self.store.add(.{ .kind = .boolean_literal, .literal_value = .{ .boolean = false } }) catch tymod.ID_BOOLEAN;
        }
        // Map common built-ins to canonical types so containsAny on
        // `Array<any>` flags correctly without resolving the lib.
        if (std.mem.eql(u8, name, "Array") or std.mem.eql(u8, name, "ReadonlyArray")) {
            const elem = self.firstTypeArg(ty_node);
            const inner = if (elem == .none) tymod.ID_ANY else self.resolveTypeNode(elem);
            return self.store.arrayOf(inner) catch tymod.ID_ANY;
        }
        if (std.mem.eql(u8, name, "any")) return tymod.ID_ANY;
        if (std.mem.eql(u8, name, "unknown")) return tymod.ID_UNKNOWN;
        if (std.mem.eql(u8, name, "never")) return tymod.ID_NEVER;
        if (std.mem.eql(u8, name, "string")) return tymod.ID_STRING;
        if (std.mem.eql(u8, name, "number")) return tymod.ID_NUMBER;
        if (std.mem.eql(u8, name, "boolean")) return tymod.ID_BOOLEAN;
        if (std.mem.eql(u8, name, "bigint")) return tymod.ID_BIGINT;
        if (std.mem.eql(u8, name, "symbol")) return tymod.ID_SYMBOL;
        if (std.mem.eql(u8, name, "object")) return tymod.ID_OBJECT_KW;
        if (std.mem.eql(u8, name, "void")) return tymod.ID_VOID;
        if (std.mem.eql(u8, name, "undefined")) return tymod.ID_UNDEFINED;
        if (std.mem.eql(u8, name, "null")) return tymod.ID_NULL;
        // Unknown name (not built-in, not declared anywhere in the file
        // or a known lib type) → error type, unless it matches a
        // type parameter in scope — in which case resolve to its
        // constraint (`<T extends X>(t: T)` should make `t` have
        // type X for the unsafe-* family).
        if (!self.known_type_names.contains(name)) {
            if (self.resolveTypeParameterConstraint(ty_node, name)) |c| return c;
            return tymod.ID_ERROR;
        }
        // User-declared interface or class → resolve to its structural
        // shape (object_t with field/method ObjectProps).
        if (self.resolveDeclaredType(name)) |resolved| {
            // Type alias instantiation: if `Foo` is a generic alias
            // (`type Foo<T> = ...`) and the use site supplies type
            // args, substitute them through the body.
            const decl_opt = self.type_decl_nodes.get(name);
            if (decl_opt) |decl| {
                if (self.ast_ref.nodeTag(decl) == .ts_type_alias_decl) {
                    if (self.substituteAliasArgs(decl, ty_node, resolved)) |inst| return inst;
                }
            }
            return resolved;
        }
        // Built-in lib types with structural shapes (Promise, Set, Map,
        // etc.).  Generic args get substituted into the method signatures.
        if (self.resolveLibType(ty_node, name)) |resolved| return resolved;
        // Type parameter with matching name in scope?  Resolve to its
        // constraint type (an over-approximation that lets `t: T` where
        // `T extends Foo` behave as `t: Foo`).
        if (self.resolveTypeParameterConstraint(ty_node, name)) |c| return c;
        // Generic args: collect for the typeRef payload.
        var args_buf: [8]TypeId = undefined;
        const args = self.collectTypeArgs(ty_node, &args_buf);
        return self.store.typeRef(name, args) catch tymod.ID_ANY;
    }

    /// Find a `ts_type_parameter` declaration named `name` enclosing
    /// `ty_node` and return its constraint's resolved TypeId.  Falls
    /// back to null when no such parameter is found or it has no
    /// constraint.
    fn resolveTypeParameterConstraint(self: *Checker, ty_node: NodeIndex, name: []const u8) ?TypeId {
        // Walk the parent index to find an enclosing fn/class/alias
        // scope; if one is found, look for a ts_type_parameter whose
        // parent chain reaches the same scope (using main-token
        // position for "before ty_node" comparison).
        const tree = self.ast_ref;
        const parents = tree.parents;
        if (parents.len == 0) return null;
        const NONE: u32 = @intFromEnum(NodeIndex.none);
        // Collect ancestors in a buffer for cheap containment checks.
        var anc_buf: [16]u32 = undefined;
        var nanc: usize = 0;
        var p = parents[ty_node.toInt()];
        while (p != NONE and nanc < anc_buf.len) : (p = parents[p]) {
            anc_buf[nanc] = p;
            nanc += 1;
        }
        // Find ts_type_parameter nodes named `name` whose ancestor chain
        // includes a scope ancestor shared with ty_node.
        const total: u32 = @intCast(tree.nodes.len);
        const ty_main_tok = tree.nodeMainToken(ty_node);
        const ty_pos = tree.tokenStart(ty_main_tok);
        var j: u32 = 0;
        while (j < total) : (j += 1) {
            const ni: NodeIndex = @enumFromInt(j);
            if (tree.nodeTag(ni) != .ts_type_parameter) continue;
            if (!std.mem.eql(u8, tree.tokenText(tree.nodeMainToken(ni)), name)) continue;
            // Type param must appear textually before ty_node.
            const tp_pos = tree.tokenStart(tree.nodeMainToken(ni));
            if (tp_pos >= ty_pos) continue;
            // Determine if some ancestor of the tp is a scope that
            // also appears in ty_node's ancestor chain — meaning they
            // share an enclosing scope (the alias/fn/class header).
            // Type params parents aren't always set, so we use spans
            // via tokenStart and compare against ty_node's ancestors.
            // For each ancestor of ty_node, check if it's a scope
            // node and if it textually CONTAINS the tp's main token.
            for (anc_buf[0..nanc]) |anc_idx| {
                const anc: NodeIndex = @enumFromInt(anc_idx);
                const tag = tree.nodeTag(anc);
                const is_scope = tag == .fn_decl or tag == .async_fn_decl or
                    tag == .generator_fn_decl or tag == .async_generator_fn_decl or
                    tag == .ts_declare_function or tag == .fn_expr or
                    tag == .async_fn_expr or tag == .generator_fn_expr or
                    tag == .async_generator_fn_expr or tag == .arrow_fn or
                    tag == .async_arrow_fn or tag == .method_def or
                    tag == .computed_method_def or tag == .class_decl or
                    tag == .class_expr or tag == .ts_type_alias_decl or
                    tag == .ts_interface_decl;
                if (!is_scope) continue;
                // Check if tp_pos lies AFTER scope's main_token (i.e.
                // tp is structurally inside the scope's header) AND
                // before ty_pos.  We don't have end-spans for the
                // scope, but the main_token position is the keyword
                // start; tp inside the same fn/class will always be
                // after that.
                const anc_pos = tree.tokenStart(tree.nodeMainToken(anc));
                if (tp_pos < anc_pos) continue;
                // Found a plausible match — same scope ancestor.
                const constraint = tree.nodeData(ni).lhs;
                if (constraint == .none) return null;
                const resolved = self.resolveTypeNode(constraint);
                // Don't substitute when the constraint is `any` — TS
                // treats `<T extends any>` as an unconstrained type
                // parameter, not as a value of type `any`.  Substituting
                // would make rules like no-unsafe-call fire on `x()`
                // where `x: T`.
                if (tymod.isAny(&self.store, resolved)) return null;
                return resolved;
            }
        }
        return null;
    }

    /// Hardcoded lib type seeds for the most common parameterized types.
    /// Each builds an object_t with the methods that show up in our
    /// rules' fixtures.  Not a substitute for lib.d.ts; sized for the
    /// type-aware family we care about.
    fn resolveLibType(self: *Checker, ty_node: NodeIndex, name: []const u8) ?TypeId {
        var args_buf: [4]TypeId = undefined;
        const args = self.collectTypeArgs(ty_node, &args_buf);
        if (std.mem.eql(u8, name, "Promise")) {
            const t = if (args.len > 0) args[0] else tymod.ID_UNKNOWN;
            return self.buildPromiseLib(t);
        }
        if (std.mem.eql(u8, name, "Set") or std.mem.eql(u8, name, "ReadonlySet")) {
            const t = if (args.len > 0) args[0] else tymod.ID_UNKNOWN;
            return self.buildSetLib(t, std.mem.eql(u8, name, "ReadonlySet"));
        }
        if (std.mem.eql(u8, name, "Map") or std.mem.eql(u8, name, "ReadonlyMap")) {
            const k = if (args.len > 0) args[0] else tymod.ID_UNKNOWN;
            const v = if (args.len > 1) args[1] else tymod.ID_UNKNOWN;
            return self.buildMapLib(k, v, std.mem.eql(u8, name, "ReadonlyMap"));
        }
        return null;
    }

    /// Promise<T> structural shape — methods that no-floating-promises
    /// and unsafe-* rules query.  Each method's return type carries the
    /// generic arg so chains compose: `Promise<T>.then(...) → Promise<U>`
    /// where U is the handler's return.  Without inference we approximate
    /// U as unknown.
    fn buildPromiseLib(self: *Checker, t: TypeId) TypeId {
        const promise_t = self.store.typeRef("Promise", &.{t}) catch return tymod.ID_UNKNOWN;
        const unknown_promise = self.store.typeRef("Promise", &.{tymod.ID_UNKNOWN}) catch return tymod.ID_UNKNOWN;
        // `.then(onF, onR?) → Promise<unknown>` (could refine to Promise<U|V>)
        const then_sig: tymod.Signature = .{
            .params_start = self.appendTypeIdsToSigPool(&.{ tymod.ID_UNKNOWN, tymod.ID_UNKNOWN }) catch return tymod.ID_UNKNOWN,
            .params_end = @intCast(self.store.signature_param_pool.items.len),
            .return_type = unknown_promise,
        };
        const then_t = self.store.functionType(then_sig) catch return tymod.ID_UNKNOWN;
        // `.catch(onR?) → Promise<T | U>` (approximate as Promise<unknown>)
        const catch_sig: tymod.Signature = .{
            .params_start = self.appendTypeIdsToSigPool(&.{tymod.ID_UNKNOWN}) catch return tymod.ID_UNKNOWN,
            .params_end = @intCast(self.store.signature_param_pool.items.len),
            .return_type = unknown_promise,
        };
        const catch_t = self.store.functionType(catch_sig) catch return tymod.ID_UNKNOWN;
        // `.finally(handler?) → Promise<T>`
        const finally_sig: tymod.Signature = .{
            .params_start = self.appendTypeIdsToSigPool(&.{tymod.ID_UNKNOWN}) catch return tymod.ID_UNKNOWN,
            .params_end = @intCast(self.store.signature_param_pool.items.len),
            .return_type = promise_t,
        };
        const finally_t = self.store.functionType(finally_sig) catch return tymod.ID_UNKNOWN;
        // Build the type as a type_ref for assignability/containsAny
        // purposes — we DON'T return an object_t here because type_ref
        // is what propagates through generic arg semantics best.
        // Method lookup happens in inferMember through a fallback that
        // recognizes lib types and synthesizes the props on demand.
        _ = then_t;
        _ = catch_t;
        _ = finally_t;
        return promise_t;
    }

    fn buildSetLib(self: *Checker, t: TypeId, readonly: bool) TypeId {
        _ = readonly;
        return self.store.typeRef("Set", &.{t}) catch tymod.ID_UNKNOWN;
    }

    fn buildMapLib(self: *Checker, k: TypeId, v: TypeId, readonly: bool) TypeId {
        _ = readonly;
        return self.store.typeRef("Map", &.{ k, v }) catch tymod.ID_UNKNOWN;
    }

    fn appendTypeIdsToSigPool(self: *Checker, ids: []const TypeId) !u32 {
        const start: u32 = @intCast(self.store.signature_param_pool.items.len);
        try self.store.signature_param_pool.appendSlice(self.gpa, ids);
        return start;
    }

    /// Resolve a declared type name (interface or class) to its structural
    /// object_t.  Returns null when the name isn't a declared structural
    /// True when the AST subtree at `ty_node` contains a
    /// `ts_type_reference` whose name matches `name`.  Used to detect
    /// directly-recursive type aliases before attempting to resolve
    /// their bodies.
    fn typeNodeReferences(self: *Checker, ty_node: NodeIndex, name: []const u8) bool {
        if (ty_node == .none) return false;
        const tag = self.ast_ref.nodeTag(ty_node);
        if (tag == .ts_type_reference) {
            const tok = self.ast_ref.nodeMainToken(ty_node);
            if (std.mem.eql(u8, self.ast_ref.tokenText(tok), name)) return true;
        }
        // Walk every ts_type_reference and check whether its parent
        // chain reaches `ty_node` — needed because `nodeSpan` only
        // covers the main token, not the subtree.
        const parents = self.ast_ref.parents;
        if (parents.len == 0) return false;
        const target_idx = @intFromEnum(ty_node);
        const NONE: u32 = @intFromEnum(NodeIndex.none);
        const total: u32 = @intCast(self.ast_ref.nodes.len);
        var i: u32 = 0;
        while (i < total) : (i += 1) {
            const ni: NodeIndex = @enumFromInt(i);
            if (ni == ty_node) continue;
            if (self.ast_ref.nodeTag(ni) != .ts_type_reference) continue;
            const tok = self.ast_ref.nodeMainToken(ni);
            if (!std.mem.eql(u8, self.ast_ref.tokenText(tok), name)) continue;
            // Walk up parents looking for ty_node.
            var p = parents[@intFromEnum(ni)];
            while (p != NONE) : (p = parents[p]) {
                if (p == target_idx) return true;
            }
        }
        return false;
    }

    /// Public wrapper around `resolveDeclaredType` so LintContext rules can
    /// reach in for inheritance / property walks.
    pub fn resolveDeclaredTypePub(self: *Checker, name: []const u8) ?TypeId {
        return self.resolveDeclaredType(name);
    }

    /// True when the TypeId reaches a class/interface named `name`
    /// through its declaration's `extends` chain.  Walks unions/
    /// intersections and follows declared parent classes via AST.
    pub fn typeInheritsFromName(self: *Checker, id: TypeId, name: []const u8) bool {
        return self.typeInheritsFromNameDepth(id, name, 0);
    }

    /// Same as `typeInheritsFromName` but starts from a name string.
    /// Resolves `decl_name` via the file's declared-type table, then
    /// walks its `extends` chain looking for `base_name`.
    pub fn declaredTypeInheritsFromByName(self: *Checker, decl_name: []const u8, base_name: []const u8) bool {
        if (std.mem.eql(u8, decl_name, base_name)) return true;
        const decl = self.type_decl_nodes.get(decl_name) orelse return false;
        return self.declInheritsFromName(decl, base_name, 0);
    }

    fn typeInheritsFromNameDepth(self: *Checker, id: TypeId, name: []const u8, depth: u8) bool {
        if (depth > 8) return false;
        const t = self.store.get(id);
        if (t.kind == .type_ref) {
            if (std.mem.eql(u8, t.name, name)) return true;
            // Walk the declared class's extends chain.
            const decl = self.type_decl_nodes.get(t.name) orelse return false;
            return self.declInheritsFromName(decl, name, depth + 1);
        }
        // Union: EVERY constituent must inherit (otherwise the value
        // could be a non-Error-like at runtime — matches TS's "every
        // branch must satisfy" semantics for narrowing-on-throw).
        if (t.kind == .union_t) {
            const members = self.store.idsOf(t.list_data);
            if (members.len == 0) return false;
            for (members) |m| {
                if (!self.typeInheritsFromNameDepth(m, name, depth + 1)) return false;
            }
            return true;
        }
        // Intersection: ANY constituent inheriting is enough — the
        // intersection narrows to at least that shape.
        if (t.kind == .intersection_t) {
            for (self.store.idsOf(t.list_data)) |m| {
                if (self.typeInheritsFromNameDepth(m, name, depth + 1)) return true;
            }
            return false;
        }
        return false;
    }

    /// For a class_decl / ts_interface_decl AST node, check if its
    /// `extends` clause names `name` (transitively).
    fn declInheritsFromName(self: *Checker, decl: NodeIndex, name: []const u8, depth: u8) bool {
        if (depth > 8) return false;
        const tag = self.ast_ref.nodeTag(decl);
        if (tag == .class_decl) {
            const data = self.ast_ref.nodeData(decl);
            const cd = self.ast_ref.extraData(ast.ClassData, @intFromEnum(data.lhs));
            if (cd.super_class == .none) return false;
            var sc = cd.super_class;
            // Peel ts_instantiation_expr (`extends Promise<number>`) and
            // grouping wrappers.
            while (true) {
                const sct = self.ast_ref.nodeTag(sc);
                if (sct == .grouping_expr or sct == .ts_instantiation_expr) {
                    sc = self.ast_ref.nodeData(sc).lhs;
                    continue;
                }
                break;
            }
            if (self.ast_ref.nodeTag(sc) == .identifier) {
                const parent_name = self.ast_ref.tokenText(self.ast_ref.nodeMainToken(sc));
                if (std.mem.eql(u8, parent_name, name)) return true;
                if (self.type_decl_nodes.get(parent_name)) |parent_decl| {
                    return self.declInheritsFromName(parent_decl, name, depth + 1);
                }
            }
            return false;
        }
        if (tag == .ts_interface_decl) {
            const data = self.ast_ref.nodeData(decl);
            const id_data = self.ast_ref.extraData(ast.InterfaceData, @intFromEnum(data.lhs));
            if (id_data.extends_end <= id_data.extends_start) return false;
            const ext_len: u32 = @intCast(self.ast_ref.extra_data.len);
            if (id_data.extends_end > ext_len) return false;
            // The extends list stores NodeIndex values (one per
            // `extends Foo<...>` type reference).  Walk each, peeling
            // ts_instantiation_expr / grouping, and read the name token.
            for (self.ast_ref.extra_data[id_data.extends_start..id_data.extends_end]) |raw| {
                var ext_node: NodeIndex = @enumFromInt(raw);
                while (true) {
                    const t = self.ast_ref.nodeTag(ext_node);
                    if (t == .grouping_expr or t == .ts_instantiation_expr) {
                        ext_node = self.ast_ref.nodeData(ext_node).lhs;
                        continue;
                    }
                    break;
                }
                if (self.ast_ref.nodeTag(ext_node) != .ts_type_reference and
                    self.ast_ref.nodeTag(ext_node) != .identifier) continue;
                const ext_name = self.ast_ref.tokenText(self.ast_ref.nodeMainToken(ext_node));
                if (std.mem.eql(u8, ext_name, name)) return true;
                if (self.type_decl_nodes.get(ext_name)) |parent_decl| {
                    if (self.declInheritsFromName(parent_decl, name, depth + 1)) return true;
                }
            }
            return false;
        }
        return false;
    }

    /// type (e.g. an import or type alias to a non-structural type).
    fn resolveDeclaredType(self: *Checker, name: []const u8) ?TypeId {
        if (self.declared_type_cache.get(name)) |cached| {
            // Resolved or sentinel (recursion in progress).
            return cached;
        }
        const decl = self.type_decl_nodes.get(name) orelse return null;
        // Insert sentinel to break cycles (e.g. `interface Node { children: Node[] }`).
        self.declared_type_cache.put(self.gpa, name, tymod.ID_UNKNOWN) catch return null;
        const result = switch (self.ast_ref.nodeTag(decl)) {
            .ts_interface_decl => self.buildInterfaceType(decl),
            .class_decl => self.buildClassInstanceType(decl),
            .ts_type_alias_decl => blk: {
                // `type Foo = ...` — resolve the alias body to its
                // TypeId.  Skip if the body recursively references
                // `name`: the sentinel-based recursion break leaves
                // ID_UNKNOWN holes that confuse downstream checks.
                const dd = self.ast_ref.nodeData(decl);
                const ad = self.ast_ref.extraData(ast.TypeAliasData, @intFromEnum(dd.lhs));
                if (self.typeNodeReferences(ad.type_node, name)) {
                    // Remove the sentinel so the next lookup doesn't
                    // see ID_UNKNOWN and think the alias resolved.
                    _ = self.declared_type_cache.remove(name);
                    return null;
                }
                break :blk self.resolveTypeNode(ad.type_node);
            },
            else => {
                _ = self.declared_type_cache.remove(name);
                return null;
            },
        };
        self.declared_type_cache.put(self.gpa, name, result) catch {};
        return result;
    }

    /// Build an object_t from an interface declaration's body.  Each
    /// `ts_property_signature` / `ts_method_signature` becomes one
    /// ObjectProp.  Method signatures resolve to a function_t for that
    /// method.  Extends clauses contribute their parent's props (one
    /// level deep — we don't yet flatten through arbitrary inheritance
    /// chains).
    fn buildInterfaceType(self: *Checker, decl: NodeIndex) TypeId {
        const data = self.ast_ref.nodeData(decl);
        const id = self.ast_ref.extraData(ast.InterfaceData, @intFromEnum(data.lhs));
        var props: std.ArrayList(tymod.ObjectProp) = .empty;
        defer props.deinit(self.gpa);
        // Inherited props from `extends` clauses (one hop).
        // The extends list stores NodeIndex per type reference.
        if (id.extends_end > id.extends_start) {
            const extends = self.ast_ref.extra_data[id.extends_start..id.extends_end];
            for (extends) |raw| {
                var ext_node: NodeIndex = @enumFromInt(raw);
                while (true) {
                    const t_tag = self.ast_ref.nodeTag(ext_node);
                    if (t_tag == .grouping_expr or t_tag == .ts_instantiation_expr) {
                        ext_node = self.ast_ref.nodeData(ext_node).lhs;
                        continue;
                    }
                    break;
                }
                if (self.ast_ref.nodeTag(ext_node) != .ts_type_reference and
                    self.ast_ref.nodeTag(ext_node) != .identifier) continue;
                const ext_name = self.ast_ref.tokenText(self.ast_ref.nodeMainToken(ext_node));
                if (self.resolveDeclaredType(ext_name)) |ext_ty| {
                    const t = self.store.get(ext_ty);
                    if (t.kind == .object_t) {
                        for (self.store.propsOf(t.object_props)) |p| {
                            props.append(self.gpa, p) catch {};
                        }
                    }
                }
            }
        }
        if (id.body_end > id.body_start) {
            const body = self.ast_ref.extra_data[id.body_start..id.body_end];
            for (body) |raw| {
                const member: NodeIndex = @enumFromInt(raw);
                if (self.interfaceMemberToProp(member)) |p| {
                    props.append(self.gpa, p) catch {};
                }
            }
        }
        const list = self.store.appendObjectProps(props.items) catch return tymod.ID_UNKNOWN;
        return self.store.add(.{ .kind = .object_t, .object_props = list }) catch tymod.ID_UNKNOWN;
    }

    fn interfaceMemberToProp(self: *Checker, member: NodeIndex) ?tymod.ObjectProp {
        const tag = self.ast_ref.nodeTag(member);
        const data = self.ast_ref.nodeData(member);
        switch (tag) {
            .ts_property_signature => {
                if (data.lhs == .none) return null;
                const name_tok = self.ast_ref.nodeMainToken(data.lhs);
                const name = self.ast_ref.tokenText(name_tok);
                var ty: TypeId = tymod.ID_UNKNOWN;
                if (data.rhs != .none and self.ast_ref.nodeTag(data.rhs) == .ts_type_annotation) {
                    const ty_node = self.ast_ref.nodeData(data.rhs).lhs;
                    ty = self.resolveTypeNode(ty_node);
                }
                return .{ .name = name, .type_id = ty };
            },
            .ts_method_signature => {
                const sig_data = self.ast_ref.extraData(ast.InterfaceSigData, @intFromEnum(data.lhs));
                if (sig_data.key == .none) return null;
                const name_tok = self.ast_ref.nodeMainToken(sig_data.key);
                const name = self.ast_ref.tokenText(name_tok);
                // Build a function_t for the method.
                const fn_ty = self.buildFunctionType(
                    sig_data.params_start,
                    sig_data.params_end,
                    sig_data.return_type,
                    .none,
                    false,
                );
                return .{ .name = name, .type_id = fn_ty };
            },
            else => return null,
        }
    }

    /// Build the INSTANCE type of a class — a record of fields and methods.
    /// Static members are not included (those live on the constructor).
    /// `extends ParentClass` contributes the parent's instance props so
    /// structural assignability (subclass → superclass) holds.
    fn buildClassInstanceType(self: *Checker, decl: NodeIndex) TypeId {
        const data = self.ast_ref.nodeData(decl);
        const cd = self.ast_ref.extraData(ast.ClassData, @intFromEnum(data.lhs));
        var props: std.ArrayList(tymod.ObjectProp) = .empty;
        defer props.deinit(self.gpa);
        // Inherit instance props from the immediate superclass (one hop).
        if (cd.super_class != .none) {
            var sc = cd.super_class;
            while (self.ast_ref.nodeTag(sc) == .grouping_expr or
                self.ast_ref.nodeTag(sc) == .ts_instantiation_expr)
            {
                sc = self.ast_ref.nodeData(sc).lhs;
            }
            var inherited = false;
            if (self.ast_ref.nodeTag(sc) == .identifier) {
                const parent_name = self.ast_ref.tokenText(self.ast_ref.nodeMainToken(sc));
                if (self.resolveDeclaredType(parent_name)) |parent_ty| {
                    const pt = self.store.get(parent_ty);
                    if (pt.kind == .object_t) {
                        for (self.store.propsOf(pt.object_props)) |p| {
                            props.append(self.gpa, p) catch {};
                        }
                        inherited = true;
                    }
                }
            }
            // Couldn't resolve the parent's structural shape (e.g. extends a
            // value of constructor type like `Constructable<X>`).  Be
            // conservative and synthesize a `toString` prop so consumers
            // treating its presence as "user-defined string coercion" don't
            // mis-classify the instance as un-coerced.
            if (!inherited) {
                props.append(self.gpa, .{ .name = "toString", .type_id = tymod.ID_ANY }) catch {};
            }
        }
        if (cd.body == .none) {
            const list = self.store.appendObjectProps(props.items) catch return tymod.ID_UNKNOWN;
            return self.store.add(.{ .kind = .object_t, .object_props = list }) catch tymod.ID_UNKNOWN;
        }
        const body_data = self.ast_ref.nodeData(cd.body);
        const slice = self.directRange(body_data.lhs, body_data.rhs) orelse {
            const list = self.store.appendObjectProps(props.items) catch return tymod.ID_UNKNOWN;
            return self.store.add(.{ .kind = .object_t, .object_props = list }) catch tymod.ID_UNKNOWN;
        };
        for (slice) |raw| {
            const member: NodeIndex = @enumFromInt(raw);
            if (self.classMemberToProp(member)) |p| {
                // Inherited prop with the same name is overridden by the
                // subclass definition — remove the prior entry.
                var k: usize = 0;
                while (k < props.items.len) : (k += 1) {
                    if (std.mem.eql(u8, props.items[k].name, p.name)) {
                        _ = props.orderedRemove(k);
                        break;
                    }
                }
                props.append(self.gpa, p) catch {};
            }
        }
        const list = self.store.appendObjectProps(props.items) catch return tymod.ID_UNKNOWN;
        return self.store.add(.{ .kind = .object_t, .object_props = list }) catch tymod.ID_UNKNOWN;
    }

    fn classMemberToProp(self: *Checker, member: NodeIndex) ?tymod.ObjectProp {
        const tag = self.ast_ref.nodeTag(member);
        const data = self.ast_ref.nodeData(member);
        switch (tag) {
            .property_def => {
                // lhs = key, rhs = extra index to PropertyData
                if (data.lhs == .none) return null;
                if (self.ast_ref.nodeTag(data.lhs) != .identifier and
                    self.ast_ref.nodeTag(data.lhs) != .property_ident) return null;
                const name = self.ast_ref.tokenText(self.ast_ref.nodeMainToken(data.lhs));
                const pd = self.ast_ref.extraData(ast.PropertyData, @intFromEnum(data.rhs));
                // Skip static members — they live on the constructor, not the instance.
                var ty: TypeId = tymod.ID_UNKNOWN;
                if (pd.type_annotation != .none and
                    self.ast_ref.nodeTag(pd.type_annotation) == .ts_type_annotation)
                {
                    const ty_node = self.ast_ref.nodeData(pd.type_annotation).lhs;
                    ty = self.resolveTypeNode(ty_node);
                } else if (pd.value != .none) {
                    ty = self.typeOf(pd.value);
                }
                return .{ .name = name, .type_id = ty };
            },
            .method_def, .getter_def, .setter_def => {
                if (data.lhs == .none) return null;
                if (self.ast_ref.nodeTag(data.lhs) != .identifier and
                    self.ast_ref.nodeTag(data.lhs) != .property_ident) return null;
                const name = self.ast_ref.tokenText(self.ast_ref.nodeMainToken(data.lhs));
                const md = self.ast_ref.extraData(ast.MethodData, @intFromEnum(data.rhs));
                const is_async = (md.modifiers & ast.ModifierBit.@"async") != 0;
                const fn_ty = self.buildFunctionType(
                    md.params_start,
                    md.params_end,
                    md.return_type,
                    .none,
                    is_async,
                );
                return .{ .name = name, .type_id = fn_ty };
            },
            else => return null,
        }
    }

    fn firstTypeArg(self: *Checker, ref_node: NodeIndex) NodeIndex {
        const data = self.ast_ref.nodeData(ref_node);
        const range = self.safeSubRange(data.rhs) orelse return .none;
        if (range.end <= range.start) return .none;
        const idx = self.ast_ref.extra_data[range.start];
        return @enumFromInt(idx);
    }

    fn collectTypeArgs(self: *Checker, ref_node: NodeIndex, buf: []TypeId) []TypeId {
        const data = self.ast_ref.nodeData(ref_node);
        const range = self.safeSubRange(data.rhs) orelse return buf[0..0];
        const slice = self.ast_ref.extra_data[range.start..range.end];
        const n = @min(slice.len, buf.len);
        var i: usize = 0;
        while (i < n) : (i += 1) {
            const arg_node: NodeIndex = @enumFromInt(slice[i]);
            buf[i] = self.resolveTypeNode(arg_node);
        }
        return buf[0..n];
    }

    fn resolveUnion(self: *Checker, ty_node: NodeIndex) TypeId {
        const data = self.ast_ref.nodeData(ty_node);
        const slice = self.directRange(data.lhs, data.rhs) orelse return tymod.ID_UNKNOWN;
        var buf: [16]TypeId = undefined;
        const n = @min(slice.len, buf.len);
        var i: usize = 0;
        while (i < n) : (i += 1) {
            const m: NodeIndex = @enumFromInt(slice[i]);
            buf[i] = self.resolveTypeNode(m);
        }
        return self.store.unionOf(buf[0..n]) catch tymod.ID_UNKNOWN;
    }

    fn resolveTupleType(self: *Checker, ty_node: NodeIndex) TypeId {
        const data = self.ast_ref.nodeData(ty_node);
        const slice = self.directRange(data.lhs, data.rhs) orelse return tymod.ID_UNKNOWN;
        var buf: [16]TypeId = undefined;
        const n = @min(slice.len, buf.len);
        var i: usize = 0;
        while (i < n) : (i += 1) {
            const m: NodeIndex = @enumFromInt(slice[i]);
            buf[i] = self.resolveTypeNode(m);
        }
        const list = self.store.appendTypeIds(buf[0..n]) catch return tymod.ID_UNKNOWN;
        return self.store.add(.{ .kind = .tuple_t, .list_data = list }) catch tymod.ID_UNKNOWN;
    }

    fn resolveIntersection(self: *Checker, ty_node: NodeIndex) TypeId {
        const data = self.ast_ref.nodeData(ty_node);
        const slice = self.directRange(data.lhs, data.rhs) orelse return tymod.ID_UNKNOWN;
        var buf: [16]TypeId = undefined;
        const n = @min(slice.len, buf.len);
        var i: usize = 0;
        while (i < n) : (i += 1) {
            const m: NodeIndex = @enumFromInt(slice[i]);
            buf[i] = self.resolveTypeNode(m);
        }
        return self.store.intersectionOf(buf[0..n]) catch tymod.ID_UNKNOWN;
    }

    // ── Expression helpers ────────────────────────────────

    fn inferAsCast(self: *Checker, node: NodeIndex, tag: ast.Node.Tag) TypeId {
        const data = self.ast_ref.nodeData(node);
        const ty_node = if (tag == .ts_as_expr) data.rhs else data.lhs;
        const inner_node = if (tag == .ts_as_expr) data.lhs else data.rhs;
        // `as const`: TS-specific syntax that converts literals to their
        // narrowest readonly form.  Parses as a type reference to `const`.
        // For an array literal source we synthesize a tuple_t with each
        // element's specific type — this lets spread-of-tuple checks see
        // per-position any in `['a', 1 as any] as const`.
        if (ty_node != .none and self.ast_ref.nodeTag(ty_node) == .ts_type_reference) {
            const name_tok = self.ast_ref.nodeMainToken(ty_node);
            const name = self.ast_ref.tokenText(name_tok);
            if (std.mem.eql(u8, name, "const")) {
                return self.inferAsConst(inner_node);
            }
        }
        return self.resolveTypeNode(ty_node);
    }

    /// `as const` lowering: for an array_literal source, build a tuple_t
    /// with each element's specific type.  Otherwise return the source's
    /// inferred type unchanged.
    fn inferAsConst(self: *Checker, src: NodeIndex) TypeId {
        if (src == .none) return tymod.ID_UNKNOWN;
        if (self.ast_ref.nodeTag(src) != .array_literal) return self.typeOf(src);
        const data = self.ast_ref.nodeData(src);
        const slice = self.directRange(data.lhs, data.rhs) orelse return tymod.ID_UNKNOWN;
        var buf: [32]TypeId = undefined;
        const n = @min(slice.len, buf.len);
        var i: usize = 0;
        while (i < n) : (i += 1) {
            const elem: NodeIndex = @enumFromInt(slice[i]);
            buf[i] = if (elem == .none) tymod.ID_UNDEFINED else self.typeOf(elem);
        }
        const list = self.store.appendTypeIds(buf[0..n]) catch return tymod.ID_UNKNOWN;
        return self.store.add(.{ .kind = .tuple_t, .list_data = list }) catch tymod.ID_UNKNOWN;
    }

    fn inferSatisfies(self: *Checker, node: NodeIndex) TypeId {
        // `x satisfies T` leaves the type of x unchanged.
        return self.typeOf(self.ast_ref.nodeData(node).lhs);
    }

    fn inferSequence(self: *Checker, node: NodeIndex) TypeId {
        const data = self.ast_ref.nodeData(node);
        const range = self.safeSubRange(data.lhs) orelse return tymod.ID_UNDEFINED;
        if (range.end <= range.start) return tymod.ID_UNDEFINED;
        const last_idx = self.ast_ref.extra_data[range.end - 1];
        return self.typeOf(@enumFromInt(last_idx));
    }

    fn inferConditional(self: *Checker, node: NodeIndex) TypeId {
        const data = self.ast_ref.nodeData(node);
        const cond_data = self.ast_ref.extraData(ast.Conditional, @intFromEnum(data.rhs));
        const a = self.typeOf(cond_data.consequent);
        const b = self.typeOf(cond_data.alternate);
        return self.store.unionOf(&.{ a, b }) catch tymod.ID_ANY;
    }

    fn inferLogical(self: *Checker, node: NodeIndex) TypeId {
        const data = self.ast_ref.nodeData(node);
        const a = self.typeOf(data.lhs);
        const b = self.typeOf(data.rhs);
        return self.store.unionOf(&.{ a, b }) catch tymod.ID_ANY;
    }

    fn inferCallReturn(self: *Checker, node: NodeIndex) TypeId {
        const data = self.ast_ref.nodeData(node);
        const callee = data.lhs;
        if (callee == .none) return tymod.ID_UNKNOWN;
        if (self.ast_ref.nodeTag(node) == .new_expr or
            self.calleeIsConstructible(callee))
        {
            if (self.newExprInstanceType(callee)) |ty| return ty;
        }
        const callee_ty = self.typeOf(callee);
        if (tymod.isAny(&self.store, callee_ty)) return tymod.ID_ANY;
        const node_tag = self.ast_ref.nodeTag(node);
        const in_optional_chain = node_tag == .optional_call_expr or
            self.calleeIsInOptionalChain(callee);
        const lookup_ty = if (in_optional_chain) self.stripNullishForLookup(callee_ty) else callee_ty;
        const t = self.store.get(lookup_ty);
        var result: TypeId = tymod.ID_UNKNOWN;
        if (t.kind == .function_t) {
            const sigs = self.store.signaturesOf(t.signatures);
            if (sigs.len > 0) result = sigs[0].return_type;
        }
        // Generic call-site inference — if the callee is a generic
        // function declaration in this file, infer its type parameters
        // from the argument types and substitute them into the
        // return.
        if (self.inferGenericReturn(callee, node, result)) |substituted| {
            result = substituted;
        }
        if (in_optional_chain and !result.eq(tymod.ID_UNKNOWN)) {
            if (self.typeContainsNullish(callee_ty) and !self.typeContainsUndefined(result)) {
                return self.store.unionOf(&.{ result, tymod.ID_UNDEFINED }) catch result;
            }
        }
        return result;
    }

    /// Match argument types against parameter types looking for
    /// type-parameter references; substitute the inferred bindings
    /// into `return_ty`.  Returns `null` when the callee isn't a
    /// generic function declaration we can find, or when there were
    /// no inferences to make.
    fn inferGenericReturn(self: *Checker, callee: NodeIndex, call: NodeIndex, return_ty: TypeId) ?TypeId {
        const fn_decl = self.findCalleeFnDecl(callee) orelse return null;
        const fd = self.ast_ref.extraData(ast.FnData, @intFromEnum(self.ast_ref.nodeData(fn_decl).lhs));
        if (fd.type_params_end <= fd.type_params) return null;
        // Collect type-parameter names.
        var tp_names_buf: [4][]const u8 = undefined;
        var tp_count: usize = 0;
        const ext_len: u32 = @intCast(self.ast_ref.extra_data.len);
        if (fd.type_params_end <= ext_len) {
            for (self.ast_ref.extra_data[fd.type_params..fd.type_params_end]) |raw| {
                if (tp_count >= tp_names_buf.len) break;
                const tp_node: NodeIndex = @enumFromInt(raw);
                if (self.ast_ref.nodeTag(tp_node) != .ts_type_parameter) continue;
                tp_names_buf[tp_count] = self.ast_ref.tokenText(self.ast_ref.nodeMainToken(tp_node));
                tp_count += 1;
            }
        }
        if (tp_count == 0) return null;
        // Collect explicit type args from the call (e.g. `id<number>(x)`).
        var bindings_buf: [4]TypeId = undefined;
        var bound: usize = 0;
        while (bound < tp_count) : (bound += 1) bindings_buf[bound] = TypeId.none;
        // Currently we don't parse explicit type arguments at call
        // sites — fall back to pure inference from arg types.

        // Walk params + args, matching type-ref names against the
        // type-parameter names to build bindings.
        const arg_nodes = self.callArguments(call);
        if (fd.params_end > ext_len) return null;
        const params = self.ast_ref.extra_data[fd.params..fd.params_end];
        var i: usize = 0;
        while (i < params.len and i < arg_nodes.len) : (i += 1) {
            const param: NodeIndex = @enumFromInt(params[i]);
            const param_ty_node = self.paramAnnotationNode(param) orelse continue;
            const arg_node: NodeIndex = @enumFromInt(arg_nodes[i]);
            const arg_ty = self.typeOf(arg_node);
            self.matchTypeParam(param_ty_node, arg_ty, tp_names_buf[0..tp_count], bindings_buf[0..tp_count]);
        }
        // Anything still unbound stays as a constraint reference (or
        // `any` if no constraint) — for substitution we just leave the
        // type_ref alone, which behaves as "unknown" downstream.
        var any_bound = false;
        for (bindings_buf[0..tp_count]) |b| {
            if (!b.eq(TypeId.none)) { any_bound = true; break; }
        }
        if (!any_bound) return null;
        // Replace unbound entries with `unknown` so substituteTypeId
        // doesn't preserve the literal name.
        for (bindings_buf[0..tp_count]) |*b| {
            if (b.eq(TypeId.none)) b.* = tymod.ID_UNKNOWN;
        }
        return self.substituteTypeId(return_ty, tp_names_buf[0..tp_count], bindings_buf[0..tp_count]);
    }

    fn callArguments(self: *Checker, call: NodeIndex) []const u32 {
        const d = self.ast_ref.nodeData(call);
        if (d.rhs == .none) return &.{};
        const sr = self.ast_ref.extraData(ast.SubRange, @intFromEnum(d.rhs));
        if (sr.start >= sr.end or sr.end > self.ast_ref.extra_data.len) return &.{};
        return self.ast_ref.extra_data[sr.start..sr.end];
    }

    fn paramAnnotationNode(self: *Checker, param: NodeIndex) ?NodeIndex {
        var p = param;
        if (self.ast_ref.nodeTag(p) == .assignment_pattern) p = self.ast_ref.nodeData(p).lhs;
        if (self.ast_ref.nodeTag(p) == .ts_parameter_property) p = self.ast_ref.nodeData(p).lhs;
        if (self.ast_ref.nodeTag(p) == .rest_element) p = self.ast_ref.nodeData(p).lhs;
        if (self.ast_ref.nodeTag(p) != .identifier) return null;
        const bd = self.ast_ref.nodeData(p);
        if (bd.rhs == .none or self.ast_ref.nodeTag(bd.rhs) != .ts_type_annotation) return null;
        return self.ast_ref.nodeData(bd.rhs).lhs;
    }

    /// Walk `param_node` looking for `ts_type_reference`s whose name
    /// matches one of `names`.  When found and not yet bound, set
    /// `bindings[i]` to `arg_ty`.  Recurses through unions /
    /// intersections / arrays / `Foo<T>` type args.
    fn matchTypeParam(
        self: *Checker,
        param_node: NodeIndex,
        arg_ty: TypeId,
        names: []const []const u8,
        bindings: []TypeId,
    ) void {
        var n = param_node;
        while (self.ast_ref.nodeTag(n) == .ts_parenthesized_type) n = self.ast_ref.nodeData(n).lhs;
        const tag = self.ast_ref.nodeTag(n);
        if (tag == .ts_type_reference) {
            const tname = self.ast_ref.tokenText(self.ast_ref.nodeMainToken(n));
            for (names, 0..) |k, i| {
                if (std.mem.eql(u8, k, tname)) {
                    if (bindings[i].eq(TypeId.none)) bindings[i] = arg_ty;
                    return;
                }
            }
            // `Foo<T>` — recurse into the type arg list against the
            // argument's type-args when possible (we don't yet model
            // that mapping; leave as no-op).
            return;
        }
        if (tag == .ts_array_type) {
            // `T[]` matched against `arg_ty[]` — bind T to the element
            // type of arg_ty when arg_ty is an array.
            const at = self.store.get(arg_ty);
            if (at.kind == .array_t or at.kind == .readonly_array_t or at.kind == .tuple_t) {
                const elems = self.store.idsOf(at.list_data);
                if (elems.len > 0) {
                    const inner = self.ast_ref.nodeData(n).lhs;
                    self.matchTypeParam(inner, elems[0], names, bindings);
                }
            }
            return;
        }
        if (tag == .ts_union_type or tag == .ts_intersection_type) {
            const d = self.ast_ref.nodeData(n);
            const s = @intFromEnum(d.lhs);
            const e = @intFromEnum(d.rhs);
            if (e > s and e <= self.ast_ref.extra_data.len) {
                for (self.ast_ref.extra_data[s..e]) |raw| {
                    const m: NodeIndex = @enumFromInt(raw);
                    self.matchTypeParam(m, arg_ty, names, bindings);
                }
            }
        }
    }

    /// For a call's callee, find the matching function declaration
    /// node in the AST (by identifier name).  Returns null if the
    /// callee isn't a simple identifier or we can't find a fn-decl.
    fn findCalleeFnDecl(self: *Checker, callee: NodeIndex) ?NodeIndex {
        var c = callee;
        while (self.ast_ref.nodeTag(c) == .grouping_expr) c = self.ast_ref.nodeData(c).lhs;
        if (self.ast_ref.nodeTag(c) != .identifier) return null;
        const name = self.ast_ref.tokenText(self.ast_ref.nodeMainToken(c));
        if (name.len == 0) return null;
        const total: u32 = @intCast(self.ast_ref.nodes.len);
        var i: u32 = 0;
        while (i < total) : (i += 1) {
            const ni: NodeIndex = @enumFromInt(i);
            const t = self.ast_ref.nodeTag(ni);
            if (t != .fn_decl and t != .async_fn_decl and t != .ts_declare_function and
                t != .generator_fn_decl and t != .async_generator_fn_decl) continue;
            const fd = self.ast_ref.extraData(ast.FnData, @intFromEnum(self.ast_ref.nodeData(ni).lhs));
            if (fd.name == .none) continue;
            const dn = self.ast_ref.tokenText(self.ast_ref.nodeMainToken(fd.name));
            if (std.mem.eql(u8, dn, name)) return ni;
        }
        return null;
    }

    /// True when `node` is part of an optional chain — i.e. walking down
    /// the left-spine of member/call expressions reaches an
    /// `optional_*` node.  Matches TS's "once you `?.`, the whole chain
    /// propagates undefined" rule.
    fn calleeIsInOptionalChain(self: *Checker, node: NodeIndex) bool {
        var cur = node;
        while (cur != .none) {
            const tag = self.ast_ref.nodeTag(cur);
            switch (tag) {
                .optional_member_expr,
                .optional_computed_member_expr,
                .optional_call_expr => return true,
                .member_expr, .computed_member_expr, .call_expr => {
                    cur = self.ast_ref.nodeData(cur).lhs;
                },
                .grouping_expr => {
                    cur = self.ast_ref.nodeData(cur).lhs;
                },
                else => return false,
            }
        }
        return false;
    }

    /// For `new X<T>()` / `new X()`: peel ts_instantiation_expr / new_expr
    /// / grouping wrappers to get the underlying class identifier and
    /// its type args, then resolve to the corresponding type-ref or
    /// declared object_t.
    fn newExprInstanceType(self: *Checker, callee: NodeIndex) ?TypeId {
        var c = callee;
        // Peel grouping_expr and new_expr (when the parser shape is
        // `call_expr(new_expr(...))` for `new X<T>()` calls).
        while (true) {
            const tag = self.ast_ref.nodeTag(c);
            if (tag == .grouping_expr) { c = self.ast_ref.nodeData(c).lhs; continue; }
            if (tag == .new_expr) { c = self.ast_ref.nodeData(c).lhs; continue; }
            break;
        }
        var type_args_start: u32 = 0;
        var type_args_end: u32 = 0;
        if (self.ast_ref.nodeTag(c) == .ts_instantiation_expr) {
            const idata = self.ast_ref.nodeData(c);
            if (idata.rhs != .none) {
                if (self.safeSubRange(idata.rhs)) |range| {
                    type_args_start = range.start;
                    type_args_end = range.end;
                }
            }
            c = idata.lhs;
        }
        // Peel any leftover new_expr / grouping wrappers below the
        // ts_instantiation_expr layer.
        while (true) {
            const tag = self.ast_ref.nodeTag(c);
            if (tag == .grouping_expr or tag == .new_expr) {
                c = self.ast_ref.nodeData(c).lhs;
                continue;
            }
            break;
        }
        if (self.ast_ref.nodeTag(c) != .identifier) return null;
        var args_buf: [4]TypeId = undefined;
        const args_count = blk: {
            if (type_args_end <= type_args_start) break :blk 0;
            const slice = self.ast_ref.extra_data[type_args_start..type_args_end];
            const n = @min(slice.len, args_buf.len);
            var i: usize = 0;
            while (i < n) : (i += 1) {
                const arg_node: NodeIndex = @enumFromInt(slice[i]);
                args_buf[i] = self.resolveTypeNode(arg_node);
            }
            break :blk n;
        };
        return self.classOrLibInstance(c, args_buf[0..args_count]);
    }

    /// True when the callee looks constructible — a ts_instantiation_expr
    /// over a class/lib identifier OR a new_expr child (which suggests
    /// the parser wrapped `new X<T>()` as `call_expr(new_expr(...))`).
    fn calleeIsConstructible(self: *Checker, callee: NodeIndex) bool {
        var c = callee;
        while (self.ast_ref.nodeTag(c) == .grouping_expr) c = self.ast_ref.nodeData(c).lhs;
        return switch (self.ast_ref.nodeTag(c)) {
            .ts_instantiation_expr, .new_expr => true,
            else => false,
        };
    }

    fn classOrLibInstance(self: *Checker, callee_ident: NodeIndex, args: []const TypeId) ?TypeId {
        const name = self.ast_ref.tokenText(self.ast_ref.nodeMainToken(callee_ident));
        // Built-in lib types — produce a type_ref carrying the args.
        if (std.mem.eql(u8, name, "Set") or std.mem.eql(u8, name, "Map") or
            std.mem.eql(u8, name, "Promise") or std.mem.eql(u8, name, "WeakSet") or
            std.mem.eql(u8, name, "WeakMap") or std.mem.eql(u8, name, "Date") or
            std.mem.eql(u8, name, "RegExp") or std.mem.eql(u8, name, "Array") or
            std.mem.eql(u8, name, "String") or std.mem.eql(u8, name, "Number") or
            std.mem.eql(u8, name, "Boolean") or std.mem.eql(u8, name, "Object") or
            std.mem.eql(u8, name, "Symbol"))
        {
            return self.store.typeRef(name, args) catch null;
        }
        // User class — return the class instance type.
        if (self.resolveDeclaredType(name)) |ty| return ty;
        return null;
    }

    fn inferArith(self: *Checker, node: NodeIndex, tag: ast.Node.Tag) TypeId {
        // Only `+` can return string.  Others coerce to number/bigint;
        // we approximate as number unless either operand is bigint.
        const data = self.ast_ref.nodeData(node);
        const a = self.typeOf(data.lhs);
        const b = self.typeOf(data.rhs);
        if (tag == .add) {
            // string + anything → string
            if (a.eq(tymod.ID_STRING) or b.eq(tymod.ID_STRING)) return tymod.ID_STRING;
            // Either side any → any (so unsafe-* fires through arithmetic).
            if (tymod.isAny(&self.store, a) or tymod.isAny(&self.store, b)) return tymod.ID_ANY;
            if (a.eq(tymod.ID_BIGINT) or b.eq(tymod.ID_BIGINT)) return tymod.ID_BIGINT;
            return tymod.ID_NUMBER;
        }
        if (tymod.isAny(&self.store, a) or tymod.isAny(&self.store, b)) return tymod.ID_ANY;
        if (a.eq(tymod.ID_BIGINT) or b.eq(tymod.ID_BIGINT)) return tymod.ID_BIGINT;
        return tymod.ID_NUMBER;
    }

    /// Safely read a SubRange stored in a NodeIndex slot.  The parser
    /// uses .none for "no payload"; out-of-bounds extra indices appear
    /// when the parser stores 0 (root sentinel) for empty payloads.
    /// Returns null when the range can't be safely read or yields a
    /// span that extends past extra_data.
    fn safeSubRange(self: *Checker, slot: NodeIndex) ?SubRange {
        if (slot == .none) return null;
        const idx = @intFromEnum(slot);
        const ext_len: u32 = @intCast(self.ast_ref.extra_data.len);
        if (idx + 1 >= ext_len) return null;
        const r = self.ast_ref.extraData(SubRange, idx);
        if (r.start > r.end or r.end > ext_len) return null;
        return r;
    }

    /// Several AST node tags (ts_union_type, ts_intersection_type,
    /// ts_tuple_type, ts_type_literal, template_literal) store the
    /// range start/end DIRECTLY in data.lhs/data.rhs as NodeIndex
    /// values — NOT a SubRange struct at an extra index.  This helper
    /// reads that pattern consistently.  Returns null when either slot
    /// is .none or the range extends past extra_data.
    fn directRange(self: *Checker, lhs: NodeIndex, rhs: NodeIndex) ?[]const u32 {
        if (lhs == .none or rhs == .none) return null;
        const s = @intFromEnum(lhs);
        const e = @intFromEnum(rhs);
        const ext_len: u32 = @intCast(self.ast_ref.extra_data.len);
        if (s > e or e > ext_len) return null;
        return self.ast_ref.extra_data[s..e];
    }

    fn inferArrayLiteral(self: *Checker, node: NodeIndex) TypeId {
        const data = self.ast_ref.nodeData(node);
        const slice = self.directRange(data.lhs, data.rhs) orelse {
            return self.store.arrayOf(tymod.ID_NEVER) catch tymod.ID_ANY;
        };
        if (slice.len == 0) return self.store.arrayOf(tymod.ID_NEVER) catch tymod.ID_ANY;
        // Element type = union of element types.
        var buf: [32]TypeId = undefined;
        const n = @min(slice.len, buf.len);
        var i: usize = 0;
        while (i < n) : (i += 1) {
            const elem_node: NodeIndex = @enumFromInt(slice[i]);
            if (elem_node == .none) {
                buf[i] = tymod.ID_UNDEFINED;
                continue;
            }
            const elem_tag = self.ast_ref.nodeTag(elem_node);
            if (elem_tag == .spread_element) {
                // Best-effort: if spread source is array, peel; else any.
                const inner = self.typeOf(self.ast_ref.nodeData(elem_node).lhs);
                const t = self.store.get(inner);
                if (t.kind == .array_t or t.kind == .readonly_array_t) {
                    const elems = self.store.idsOf(t.list_data);
                    buf[i] = if (elems.len == 0) tymod.ID_ANY else elems[0];
                } else {
                    buf[i] = tymod.ID_ANY;
                }
            } else {
                buf[i] = self.typeOf(elem_node);
            }
        }
        const elem_t = self.store.unionOf(buf[0..n]) catch tymod.ID_ANY;
        return self.store.arrayOf(elem_t) catch tymod.ID_ANY;
    }

    fn inferObjectLiteral(self: *Checker, node: NodeIndex) TypeId {
        // Walk the property list and build an object_t.  Spread/computed/
        // accessor properties bail out structurally — they widen the
        // type beyond what we can statically represent.
        const data = self.ast_ref.nodeData(node);
        const slice = self.directRange(data.lhs, data.rhs) orelse return tymod.ID_UNKNOWN;
        var buf: [16]tymod.ObjectProp = undefined;
        var n: usize = 0;
        for (slice) |raw| {
            if (n >= buf.len) break;
            const p: NodeIndex = @enumFromInt(raw);
            const pt = self.ast_ref.nodeTag(p);
            switch (pt) {
                .property => {
                    const pd = self.ast_ref.nodeData(p);
                    const key_name = self.staticPropertyKey(pd.lhs) orelse return tymod.ID_UNKNOWN;
                    const val_ty = self.typeOf(pd.rhs);
                    buf[n] = .{ .name = key_name, .type_id = val_ty };
                    n += 1;
                },
                .shorthand_property => {
                    const pd = self.ast_ref.nodeData(p);
                    const key_name = self.staticPropertyKey(pd.lhs) orelse return tymod.ID_UNKNOWN;
                    const val_ty = self.typeOf(pd.lhs);
                    buf[n] = .{ .name = key_name, .type_id = val_ty };
                    n += 1;
                },
                // Bail on spread / computed / methods / accessors —
                // structural type would not be sound.
                else => return tymod.ID_UNKNOWN,
            }
        }
        return self.store.objectOf(buf[0..n]) catch tymod.ID_UNKNOWN;
    }

    fn staticPropertyKey(self: *Checker, key: NodeIndex) ?[]const u8 {
        if (key == .none) return null;
        const tag = self.ast_ref.nodeTag(key);
        if (tag == .identifier or tag == .property_ident or tag == .property_literal) {
            const tok = self.ast_ref.nodeMainToken(key);
            return self.ast_ref.tokenText(tok);
        }
        if (tag == .string_literal) {
            const tok = self.ast_ref.nodeMainToken(key);
            const raw = self.ast_ref.tokenText(tok);
            if (raw.len >= 2) return raw[1 .. raw.len - 1];
        }
        return null;
    }

    fn inferMember(self: *Checker, node: NodeIndex) TypeId {
        const data = self.ast_ref.nodeData(node);
        const obj_ty = self.typeOf(data.lhs);
        if (tymod.isAny(&self.store, obj_ty)) return tymod.ID_ANY;
        const tag = self.ast_ref.nodeTag(node);
        const is_optional = tag == .optional_member_expr or tag == .optional_computed_member_expr;
        // Optional chain propagates: even on plain `.x` access, if a prior
        // step in the chain used `?.`, the receiver type carries `|
        // undefined` and we need to strip it before lookup.
        const in_chain = is_optional or self.calleeIsInOptionalChain(data.lhs);
        // Computed member: `obj[idx]`.  Handles array/tuple element access
        // and string-literal key indexing into object types.
        if (tag == .computed_member_expr or tag == .optional_computed_member_expr) {
            const lookup_obj = if (in_chain) self.stripNullishForLookup(obj_ty) else obj_ty;
            const inner = self.inferComputedMember(lookup_obj, data.rhs, data.lhs);
            return self.maybeAddOptionalUndefined(inner, obj_ty, in_chain);
        }
        const prop_name: []const u8 = switch (tag) {
            .member_expr, .optional_member_expr => blk: {
                if (data.rhs == .none) break :blk &.{};
                const t = self.ast_ref.nodeMainToken(data.rhs);
                break :blk self.ast_ref.tokenText(t);
            },
            else => return tymod.ID_UNKNOWN,
        };
        if (prop_name.len == 0) return tymod.ID_UNKNOWN;
        // For `obj?.prop` or any in-chain member access, strip the
        // nullish part for property lookup (`{a?:T} | undefined`'s `.a`
        // is `T | undefined`, not unknown).
        const lookup_ty = if (in_chain) self.stripNullishForLookup(obj_ty) else obj_ty;
        const inner = self.memberOnApparentType(lookup_ty, prop_name, data.lhs);
        return self.maybeAddOptionalUndefined(inner, obj_ty, in_chain);
    }

    fn stripNullishForLookup(self: *Checker, ty: TypeId) TypeId {
        const t = self.store.get(ty);
        if (t.kind != .union_t) return ty;
        var buf: [16]TypeId = undefined;
        var n: usize = 0;
        for (self.store.idsOf(t.list_data)) |m| {
            if (m.eq(tymod.ID_NULL) or m.eq(tymod.ID_UNDEFINED) or m.eq(tymod.ID_VOID)) continue;
            if (n >= buf.len) return ty;
            buf[n] = m;
            n += 1;
        }
        if (n == 0) return ty;
        if (n == 1) return buf[0];
        return self.store.unionOf(buf[0..n]) catch ty;
    }

    fn maybeAddOptionalUndefined(self: *Checker, inner: TypeId, obj_ty: TypeId, is_optional: bool) TypeId {
        if (!is_optional) return inner;
        // For `?.` access, if the object's type was nullish, the result
        // is `inner | undefined` (short-circuits to undefined).
        if (!self.typeContainsNullish(obj_ty)) return inner;
        if (self.typeContainsUndefined(inner)) return inner;
        return self.store.unionOf(&.{ inner, tymod.ID_UNDEFINED }) catch inner;
    }

    fn typeContainsNullish(self: *Checker, id: TypeId) bool {
        return self.typeContainsNull(id) or self.typeContainsUndefined(id);
    }

    fn typeContainsNull(self: *Checker, id: TypeId) bool {
        if (id.eq(tymod.ID_NULL)) return true;
        const t = self.store.get(id);
        if (t.kind == .null_t) return true;
        if (t.kind == .union_t) {
            for (self.store.idsOf(t.list_data)) |m| if (self.typeContainsNull(m)) return true;
        }
        return false;
    }

    fn typeContainsUndefined(self: *Checker, id: TypeId) bool {
        if (id.eq(tymod.ID_UNDEFINED) or id.eq(tymod.ID_VOID)) return true;
        const t = self.store.get(id);
        if (t.kind == .undefined_t or t.kind == .void_t) return true;
        if (t.kind == .union_t) {
            for (self.store.idsOf(t.list_data)) |m| if (self.typeContainsUndefined(m)) return true;
        }
        return false;
    }

    /// Compute the type of `obj[key]` access.  For arrays/tuples returns
    /// the element type; for objects with a static string key, returns
    /// that property's type; otherwise unknown.
    fn inferComputedMember(self: *Checker, obj_ty: TypeId, key_node: NodeIndex, obj_node: NodeIndex) TypeId {
        if (key_node == .none) return tymod.ID_UNKNOWN;
        const obj = self.store.get(obj_ty);
        // Array element access — index by number → element type.
        // For tuples, a numeric literal selects a specific element;
        // otherwise return the union of all elements.
        if (obj.kind == .array_t or obj.kind == .readonly_array_t) {
            const elems = self.store.idsOf(obj.list_data);
            if (elems.len == 0) return tymod.ID_UNKNOWN;
            return elems[0];
        }
        if (obj.kind == .tuple_t) {
            const elems = self.store.idsOf(obj.list_data);
            if (elems.len == 0) return tymod.ID_UNKNOWN;
            // Numeric literal index → specific element if in range.
            if (self.ast_ref.nodeTag(key_node) == .number_literal) {
                const tok = self.ast_ref.nodeMainToken(key_node);
                const text = self.ast_ref.tokenText(tok);
                const idx = std.fmt.parseInt(usize, text, 10) catch return tymod.ID_UNKNOWN;
                if (idx < elems.len) return elems[idx];
                return tymod.ID_UNDEFINED;
            }
            // Non-literal index → first element type (approximation).
            return elems[0];
        }
        // String literal key into object — look up by name.
        if (obj.kind == .object_t and self.ast_ref.nodeTag(key_node) == .string_literal) {
            const tok = self.ast_ref.nodeMainToken(key_node);
            const raw = self.ast_ref.tokenText(tok);
            if (raw.len >= 2) {
                const name = raw[1 .. raw.len - 1];
                for (self.store.propsOf(obj.object_props)) |p| {
                    if (std.mem.eql(u8, p.name, name)) return p.type_id;
                }
            }
        }
        // Type reference (Promise / Array / etc.): resolve to the
        // underlying structural shape, then retry.
        if (obj.kind == .type_ref) {
            if (self.resolveDeclaredType(obj.name)) |resolved| {
                if (!resolved.eq(obj_ty)) {
                    return self.inferComputedMember(resolved, key_node, obj_node);
                }
            }
            // `ArrayLike<T>` / `Array<T>` / `ReadonlyArray<T>`: numeric
            // index returns the type argument.
            if (std.mem.eql(u8, obj.name, "ArrayLike") or
                std.mem.eql(u8, obj.name, "Array") or
                std.mem.eql(u8, obj.name, "ReadonlyArray"))
            {
                const args = self.store.idsOf(obj.list_data);
                if (args.len > 0) return args[0];
            }
        }
        // Union/intersection: walk members, take first concrete result.
        if (obj.kind == .union_t or obj.kind == .intersection_t) {
            for (self.store.idsOf(obj.list_data)) |m| {
                const t = self.inferComputedMember(m, key_node, obj_node);
                if (!tymod.isUnknown(&self.store, t)) return t;
            }
        }
        return tymod.ID_UNKNOWN;
    }

    /// Look up `prop_name` on the apparent type of `obj_ty`.  Handles:
    ///   - union: every member must have the property; result is the
    ///     union of property types (we approximate with the first
    ///     non-unknown).
    ///   - intersection: any member's property fires.
    ///   - type_ref to lib (Promise / Array / etc.): synthesised methods.
    ///   - type_ref to user alias / interface / class: look up the
    ///     resolved declared type's members.
    ///   - type_ref to type parameter: chase the constraint (apparent
    ///     type) and re-do the lookup.
    ///   - array_t / readonly_array_t / tuple_t: Array.prototype.
    ///   - object_t: direct property lookup.
    fn memberOnApparentType(self: *Checker, obj_ty: TypeId, prop_name: []const u8, obj_node: NodeIndex) TypeId {
        const obj = self.store.get(obj_ty);
        // Composite receivers: walk members.
        if (obj.kind == .union_t) {
            // Per TS: every union member must have the property.  We
            // approximate by returning the first non-unknown result.
            for (self.store.idsOf(obj.list_data)) |m| {
                const t = self.memberOnApparentType(m, prop_name, obj_node);
                if (!tymod.isUnknown(&self.store, t)) return t;
            }
            return tymod.ID_UNKNOWN;
        }
        if (obj.kind == .intersection_t) {
            for (self.store.idsOf(obj.list_data)) |m| {
                const t = self.memberOnApparentType(m, prop_name, obj_node);
                if (!tymod.isUnknown(&self.store, t)) return t;
            }
            return tymod.ID_UNKNOWN;
        }
        // Array.prototype.
        if (obj.kind == .array_t or obj.kind == .readonly_array_t or obj.kind == .tuple_t) {
            const elem: TypeId = blk: {
                const elems = self.store.idsOf(obj.list_data);
                if (elems.len == 0) break :blk tymod.ID_UNKNOWN;
                break :blk elems[0];
            };
            return self.arrayPrototypeProperty(prop_name, elem);
        }
        // Lib type_ref methods.
        if (obj.kind == .type_ref) {
            if (self.libTypeRefProperty(obj_ty, prop_name)) |ty| return ty;
            // User-declared types — resolve via the declared cache.
            if (self.resolveDeclaredType(obj.name)) |resolved| {
                if (!resolved.eq(obj_ty)) {
                    const t = self.memberOnApparentType(resolved, prop_name, obj_node);
                    if (!tymod.isUnknown(&self.store, t)) return t;
                }
            }
            // Type parameter: chase constraint (apparent type).
            const constraint = self.typeParameterConstraintFromName(obj.name, obj_node);
            if (constraint) |c| {
                if (!c.eq(obj_ty)) {
                    return self.memberOnApparentType(c, prop_name, obj_node);
                }
            }
            return tymod.ID_UNKNOWN;
        }
        if (obj.kind == .object_t) {
            for (self.store.propsOf(obj.object_props)) |p| {
                if (std.mem.eql(u8, p.name, prop_name)) {
                    if (p.optional) {
                        return self.store.unionOf(&.{ p.type_id, tymod.ID_UNDEFINED }) catch p.type_id;
                    }
                    return p.type_id;
                }
            }
        }
        // Primitive apparent types: number / string / boolean have
        // prototype methods we should model eventually.  For now we
        // only model array / promise / object.
        return tymod.ID_UNKNOWN;
    }

    /// Walk to the enclosing scope and find a `ts_type_parameter`
    /// named `name`, then return its constraint TypeId.
    fn typeParameterConstraintFromName(self: *Checker, name: []const u8, at_node: NodeIndex) ?TypeId {
        if (at_node == .none) return null;
        return self.resolveTypeParameterConstraint(at_node, name);
    }

    /// True when `ty_node` is a `ts_type_reference` whose name resolves
    /// to a TS type parameter declared in enclosing scope.
    pub fn typeAnnotationIsTypeParameter(self: *Checker, ty_node: NodeIndex) bool {
        var n = ty_node;
        if (n == .none) return false;
        if (self.ast_ref.nodeTag(n) == .ts_type_annotation) n = self.ast_ref.nodeData(n).lhs;
        while (self.ast_ref.nodeTag(n) == .ts_parenthesized_type) n = self.ast_ref.nodeData(n).lhs;
        if (self.ast_ref.nodeTag(n) != .ts_type_reference) return false;
        const name = self.ast_ref.tokenText(self.ast_ref.nodeMainToken(n));
        return self.findTypeParameterDecl(n, name) != null;
    }

    /// For a `ts_type_reference` to a type parameter, return its constraint
    /// TypeId (or `ID_UNKNOWN` if unconstrained).  Returns null when the
    /// node is not a type-parameter reference.
    pub fn typeParameterConstraintOf(self: *Checker, ty_node: NodeIndex) ?TypeId {
        var n = ty_node;
        if (n == .none) return null;
        if (self.ast_ref.nodeTag(n) == .ts_type_annotation) n = self.ast_ref.nodeData(n).lhs;
        while (self.ast_ref.nodeTag(n) == .ts_parenthesized_type) n = self.ast_ref.nodeData(n).lhs;
        if (self.ast_ref.nodeTag(n) != .ts_type_reference) return null;
        const name = self.ast_ref.tokenText(self.ast_ref.nodeMainToken(n));
        const tp = self.findTypeParameterDecl(n, name) orelse return null;
        // ts_type_parameter encodes: main_token = name, lhs = constraint
        // (or .none), rhs = default (or .none).
        const tp_data = self.ast_ref.nodeData(tp);
        if (tp_data.lhs == .none) return tymod.ID_UNKNOWN;
        return self.resolveTypeNode(tp_data.lhs);
    }

    /// Find a `ts_type_parameter` AST node whose name matches and is
    /// declared in an enclosing scope of `ref_node`.
    fn findTypeParameterDecl(self: *Checker, ref_node: NodeIndex, name: []const u8) ?NodeIndex {
        const tree = self.ast_ref;
        const parents = tree.parents;
        if (parents.len == 0) return null;
        const NONE: u32 = @intFromEnum(NodeIndex.none);
        var anc_buf: [16]u32 = undefined;
        var nanc: usize = 0;
        var p = parents[ref_node.toInt()];
        while (p != NONE and nanc < anc_buf.len) : (p = parents[p]) {
            anc_buf[nanc] = p;
            nanc += 1;
        }
        const total: u32 = @intCast(tree.nodes.len);
        const ref_main_tok = tree.nodeMainToken(ref_node);
        const ref_pos = tree.tokenStart(ref_main_tok);
        var j: u32 = 0;
        while (j < total) : (j += 1) {
            const ni: NodeIndex = @enumFromInt(j);
            if (tree.nodeTag(ni) != .ts_type_parameter) continue;
            if (!std.mem.eql(u8, tree.tokenText(tree.nodeMainToken(ni)), name)) continue;
            const tp_pos = tree.tokenStart(tree.nodeMainToken(ni));
            if (tp_pos >= ref_pos) continue;
            // Ensure the tp is in scope of ref_node: walk tp's parents
            // and check any ancestor is shared with ref_node's ancestors.
            const tp_parent = parents[j];
            if (tp_parent == NONE) continue;
            var tp_p = tp_parent;
            while (tp_p != NONE) : (tp_p = parents[tp_p]) {
                for (anc_buf[0..nanc]) |anc| {
                    if (anc == tp_p) return ni;
                }
            }
        }
        return null;
    }

    /// Substitute type arguments into a generic type-alias body.
    /// Returns null when the alias has no type parameters or the
    /// use-site has no type args.  Otherwise returns the substituted
    /// TypeId (cloned through the type store).
    fn substituteAliasArgs(self: *Checker, decl: NodeIndex, ref_node: NodeIndex, alias_body: TypeId) ?TypeId {
        const tad = self.ast_ref.extraData(ast.TypeAliasData, @intFromEnum(self.ast_ref.nodeData(decl).lhs));
        if (tad.type_params_end <= tad.type_params) return null;
        const ref_rhs = self.ast_ref.nodeData(ref_node).rhs;
        if (ref_rhs == .none) return null;
        const arg_range = self.ast_ref.extraData(ast.SubRange, @intFromEnum(ref_rhs));
        if (arg_range.end <= arg_range.start) return null;
        // Build substitution map: param name → TypeId.
        var keys_buf: [4][]const u8 = undefined;
        var vals_buf: [4]TypeId = undefined;
        var nsub: usize = 0;
        const tp_count = tad.type_params_end - tad.type_params;
        const arg_count = arg_range.end - arg_range.start;
        const n = @min(@min(tp_count, arg_count), keys_buf.len);
        var i: u32 = 0;
        while (i < n) : (i += 1) {
            const tp: NodeIndex = @enumFromInt(self.ast_ref.extra_data[tad.type_params + i]);
            const arg: NodeIndex = @enumFromInt(self.ast_ref.extra_data[arg_range.start + i]);
            if (self.ast_ref.nodeTag(tp) != .ts_type_parameter) continue;
            keys_buf[nsub] = self.ast_ref.tokenText(self.ast_ref.nodeMainToken(tp));
            vals_buf[nsub] = self.resolveTypeNode(arg);
            nsub += 1;
        }
        if (nsub == 0) return null;
        return self.substituteTypeId(alias_body, keys_buf[0..nsub], vals_buf[0..nsub]);
    }

    /// Walk a TypeId and replace any `type_ref` whose name matches a
    /// substitution key.  Recurses through composites (union, intersection,
    /// array, tuple, object props).  Returns the original id when no
    /// substitution happened.
    fn substituteTypeId(self: *Checker, id: TypeId, keys: []const []const u8, vals: []const TypeId) TypeId {
        const t = self.store.get(id);
        switch (t.kind) {
            .type_ref => {
                for (keys, vals) |k, v| {
                    if (std.mem.eql(u8, k, t.name)) return v;
                }
                // Substitute through type args (e.g. `Promise<T>`).
                const args = self.store.idsOf(t.list_data);
                if (args.len == 0) return id;
                var new_args_buf: [8]TypeId = undefined;
                if (args.len > new_args_buf.len) return id;
                var changed = false;
                for (args, 0..) |a, i| {
                    new_args_buf[i] = self.substituteTypeId(a, keys, vals);
                    if (!new_args_buf[i].eq(a)) changed = true;
                }
                if (!changed) return id;
                return self.store.typeRef(t.name, new_args_buf[0..args.len]) catch id;
            },
            .union_t => return self.substituteList(id, t, keys, vals, .union_t),
            .intersection_t => return self.substituteList(id, t, keys, vals, .intersection_t),
            .array_t, .readonly_array_t, .tuple_t => return self.substituteArrayLike(id, t, keys, vals),
            .object_t => return self.substituteObject(id, t, keys, vals),
            else => return id,
        }
    }

    fn substituteList(self: *Checker, id: TypeId, t: *const tymod.Type, keys: []const []const u8, vals: []const TypeId, kind: tymod.TypeKind) TypeId {
        const members = self.store.idsOf(t.list_data);
        if (members.len == 0) return id;
        var new_buf: [16]TypeId = undefined;
        if (members.len > new_buf.len) return id;
        var changed = false;
        for (members, 0..) |m, i| {
            new_buf[i] = self.substituteTypeId(m, keys, vals);
            if (!new_buf[i].eq(m)) changed = true;
        }
        if (!changed) return id;
        if (kind == .union_t) return self.store.unionOf(new_buf[0..members.len]) catch id;
        return self.store.intersectionOf(new_buf[0..members.len]) catch id;
    }

    fn substituteArrayLike(self: *Checker, id: TypeId, t: *const tymod.Type, keys: []const []const u8, vals: []const TypeId) TypeId {
        const elems = self.store.idsOf(t.list_data);
        if (elems.len == 0) return id;
        if (t.kind == .tuple_t) {
            var new_buf: [16]TypeId = undefined;
            if (elems.len > new_buf.len) return id;
            var changed = false;
            for (elems, 0..) |m, i| {
                new_buf[i] = self.substituteTypeId(m, keys, vals);
                if (!new_buf[i].eq(m)) changed = true;
            }
            if (!changed) return id;
            return self.store.tupleOf(new_buf[0..elems.len]) catch id;
        }
        const new_elem = self.substituteTypeId(elems[0], keys, vals);
        if (new_elem.eq(elems[0])) return id;
        if (t.kind == .readonly_array_t) return self.store.readonlyArrayOf(new_elem) catch id;
        return self.store.arrayOf(new_elem) catch id;
    }

    fn substituteObject(self: *Checker, id: TypeId, t: *const tymod.Type, keys: []const []const u8, vals: []const TypeId) TypeId {
        const props = self.store.propsOf(t.object_props);
        if (props.len == 0) return id;
        var new_buf: [16]tymod.ObjectProp = undefined;
        if (props.len > new_buf.len) return id;
        var changed = false;
        for (props, 0..) |p, i| {
            const new_pty = self.substituteTypeId(p.type_id, keys, vals);
            new_buf[i] = .{ .name = p.name, .type_id = new_pty };
            if (!new_pty.eq(p.type_id)) changed = true;
        }
        if (!changed) return id;
        return self.store.objectOf(new_buf[0..props.len]) catch id;
    }

    /// Look up a property on a lib type_ref (Promise / Array / Set /
    /// Map).  Returns null when the type isn't recognised or doesn't
    /// have the named property modeled.
    fn libTypeRefProperty(self: *Checker, ref_ty: TypeId, name: []const u8) ?TypeId {
        const t = self.store.get(ref_ty);
        if (t.kind != .type_ref) return null;
        const args = self.store.idsOf(t.list_data);
        if (std.mem.eql(u8, t.name, "Array") or std.mem.eql(u8, t.name, "ReadonlyArray")) {
            const elem = if (args.len > 0) args[0] else tymod.ID_UNKNOWN;
            return self.arrayPrototypeProperty(name, elem);
        }
        if (std.mem.eql(u8, t.name, "Promise")) {
            const inner = if (args.len > 0) args[0] else tymod.ID_UNKNOWN;
            return self.promisePrototypeProperty(name, inner);
        }
        return null;
    }

    fn promisePrototypeProperty(self: *Checker, name: []const u8, _: TypeId) ?TypeId {
        // The Promise<T> chain methods .then/.catch/.finally all return
        // Promise<unknown> (loose approximation, doesn't track resolved
        // handler return types).  Each is a function_t that propagates
        // chains so 'promise.then(...).catch(...)' is also Promise.
        const unknown_promise = self.store.typeRef("Promise", &.{tymod.ID_UNKNOWN}) catch return null;
        if (std.mem.eql(u8, name, "then") or std.mem.eql(u8, name, "catch") or
            std.mem.eql(u8, name, "finally"))
        {
            return self.makeNullaryFn(unknown_promise);
        }
        return null;
    }

    /// Lookup an Array.prototype method by name and return its
    /// (function or scalar) type.  Returns ID_UNKNOWN for properties
    /// we don't model.
    fn arrayPrototypeProperty(self: *Checker, name: []const u8, elem: TypeId) TypeId {
        // length / indexOf / lastIndexOf return numbers.
        if (std.mem.eql(u8, name, "length")) return tymod.ID_NUMBER;
        // T | undefined returners.
        if (std.mem.eql(u8, name, "shift") or std.mem.eql(u8, name, "pop") or
            std.mem.eql(u8, name, "at") or std.mem.eql(u8, name, "find") or
            std.mem.eql(u8, name, "findLast"))
        {
            const opt = self.store.unionOf(&.{ elem, tymod.ID_UNDEFINED }) catch return tymod.ID_UNKNOWN;
            return self.makeNullaryFn(opt);
        }
        // T[] returners.
        if (std.mem.eql(u8, name, "slice") or std.mem.eql(u8, name, "concat") or
            std.mem.eql(u8, name, "filter") or std.mem.eql(u8, name, "reverse") or
            std.mem.eql(u8, name, "toSorted") or std.mem.eql(u8, name, "toReversed") or
            std.mem.eql(u8, name, "splice"))
        {
            const arr_ty = self.store.arrayOf(elem) catch return tymod.ID_UNKNOWN;
            return self.makeNullaryFn(arr_ty);
        }
        // boolean returners.
        if (std.mem.eql(u8, name, "includes") or std.mem.eql(u8, name, "every") or
            std.mem.eql(u8, name, "some"))
        {
            return self.makeNullaryFn(tymod.ID_BOOLEAN);
        }
        // number returners.
        if (std.mem.eql(u8, name, "push") or std.mem.eql(u8, name, "unshift") or
            std.mem.eql(u8, name, "indexOf") or std.mem.eql(u8, name, "lastIndexOf") or
            std.mem.eql(u8, name, "findIndex") or std.mem.eql(u8, name, "findLastIndex"))
        {
            return self.makeNullaryFn(tymod.ID_NUMBER);
        }
        // string returners.
        if (std.mem.eql(u8, name, "join") or std.mem.eql(u8, name, "toString") or
            std.mem.eql(u8, name, "toLocaleString"))
        {
            return self.makeNullaryFn(tymod.ID_STRING);
        }
        return tymod.ID_UNKNOWN;
    }

    fn makeNullaryFn(self: *Checker, ret: TypeId) TypeId {
        const param_range = self.store.appendSignatureParams(&.{}) catch return tymod.ID_UNKNOWN;
        const sig: tymod.Signature = .{
            .params_start = param_range.start,
            .params_end = param_range.end,
            .return_type = ret,
        };
        return self.store.functionType(sig) catch tymod.ID_UNKNOWN;
    }

    /// `this` inside a class method/getter/setter/constructor resolves
    /// to the enclosing class's instance type.  Walks parents to find
    /// the nearest method-or-class declaration; bails (returns unknown)
    /// for `this` in a stand-alone function (no class context) or at
    /// module level — those cases need `noImplicitThis` compiler-options
    /// awareness we don't track.
    fn inferThis(self: *Checker, node: NodeIndex) TypeId {
        const parents = self.ast_ref.parents;
        if (parents.len == 0) return tymod.ID_UNKNOWN;
        var p = parents[node.toInt()];
        const NONE: u32 = @intFromEnum(NodeIndex.none);
        while (p != NONE) : (p = parents[p]) {
            const pn: NodeIndex = @enumFromInt(p);
            const tag = self.ast_ref.nodeTag(pn);
            // Reaching another fn_decl/fn_expr/arrow_fn that ISN'T a
            // method definition means we've left the class context.
            // Arrow functions inherit `this`, so we keep walking through
            // arrow_fn but stop at non-arrow function definitions.
            switch (tag) {
                .method_def, .computed_method_def, .getter_def, .setter_def,
                .computed_getter_def, .computed_setter_def, .constructor_def => {
                    // Walk up to the class_decl / class_expr.
                    var q = parents[p];
                    while (q != NONE) : (q = parents[q]) {
                        const qn: NodeIndex = @enumFromInt(q);
                        const qtag = self.ast_ref.nodeTag(qn);
                        if (qtag == .class_decl) return self.buildClassInstanceType(qn);
                        if (qtag == .class_expr) return self.buildClassInstanceType(qn);
                        // class_body sits between method_def and class_decl/expr;
                        // keep walking until we hit the decl/expr.
                        if (qtag == .class_body) continue;
                        // Other intermediate nodes (computed key wrappers?) — keep walking.
                    }
                    return tymod.ID_UNKNOWN;
                },
                // Hit a function context that owns its own `this` binding
                // — `this` here doesn't belong to an enclosing class.
                .fn_decl, .async_fn_decl, .generator_fn_decl,
                .async_generator_fn_decl, .fn_expr, .async_fn_expr,
                .generator_fn_expr, .async_generator_fn_expr => return tymod.ID_UNKNOWN,
                else => {},
            }
        }
        return tymod.ID_UNKNOWN;
    }

    fn inferAwait(self: *Checker, node: NodeIndex) TypeId {
        // await Promise<T> → T; otherwise unchanged.
        const inner = self.typeOf(self.ast_ref.nodeData(node).lhs);
        const t = self.store.get(inner);
        if (t.kind == .type_ref and std.mem.eql(u8, t.name, "Promise")) {
            const args = self.store.idsOf(t.list_data);
            if (args.len > 0) return args[0];
        }
        return inner;
    }
};

fn firstNodeOfTag(ast_result: *const Ast, tag: ast.Node.Tag) ?NodeIndex {
    const total: u32 = @intCast(ast_result.nodes.len);
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (ast_result.nodeTag(ni) == tag) return ni;
    }
    return null;
}

test "Checker: number literal type" {
    const allocator = std.testing.allocator;
    var lex_result = try parser.Lexer.tokenize(allocator, "42;");
    defer lex_result.deinit(allocator);
    var tokens = lex_result.tokens;
    var ast_result = try parser.Parser.parse(allocator, "42;", tokens.slice());
    defer ast_result.deinit(allocator);
    var sem = try parser.semantic.SemanticAnalyzer.analyze(allocator, &ast_result);
    defer sem.deinit(allocator);

    var checker = try Checker.init(allocator, &ast_result, &sem);
    defer checker.deinit();

    const expr = firstNodeOfTag(&ast_result, .number_literal) orelse return error.NoLiteral;
    try std.testing.expect(checker.typeOf(expr).eq(tymod.ID_NUMBER));
    try std.testing.expect(!checker.typeIsAny(expr));
}

test "Checker: identifier bound to number annotation" {
    const allocator = std.testing.allocator;
    const src = "const x: number = 1; x;";
    var lex_result = try parser.Lexer.tokenize(allocator, src);
    defer lex_result.deinit(allocator);
    var tokens = lex_result.tokens;
    var ast_result = try parser.Parser.parseWithLanguage(allocator, src, tokens.slice(), .ts, true);
    defer ast_result.deinit(allocator);
    var sem = try parser.semantic.SemanticAnalyzer.analyzeWithOptions(allocator, &ast_result, .{
        .is_module = true,
        .build_parents = true,
    });
    defer sem.deinit(allocator);

    var checker = try Checker.init(allocator, &ast_result, &sem);
    defer checker.deinit();

    // Find the LAST identifier (the `x` reference) — the binding `x` is also an identifier.
    const total: u32 = @intCast(ast_result.nodes.len);
    var last_ident: ?NodeIndex = null;
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (ast_result.nodeTag(ni) == .identifier) last_ident = ni;
    }
    const ident = last_ident orelse return error.NoIdent;
    const ty = checker.typeOf(ident);
    try std.testing.expect(ty.eq(tymod.ID_NUMBER));
}

test "Checker: array of any flagged via containsAny" {
    const allocator = std.testing.allocator;
    const src = "const arr: any[] = []; arr;";
    var lex_result = try parser.Lexer.tokenize(allocator, src);
    defer lex_result.deinit(allocator);
    var tokens = lex_result.tokens;
    var ast_result = try parser.Parser.parseWithLanguage(allocator, src, tokens.slice(), .ts, true);
    defer ast_result.deinit(allocator);
    var sem = try parser.semantic.SemanticAnalyzer.analyzeWithOptions(allocator, &ast_result, .{
        .is_module = true,
        .build_parents = true,
    });
    defer sem.deinit(allocator);

    var checker = try Checker.init(allocator, &ast_result, &sem);
    defer checker.deinit();

    const total: u32 = @intCast(ast_result.nodes.len);
    var last_ident: ?NodeIndex = null;
    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const ni: NodeIndex = @enumFromInt(i);
        if (ast_result.nodeTag(ni) == .identifier) last_ident = ni;
    }
    const ident = last_ident orelse return error.NoIdent;
    try std.testing.expect(checker.typeContainsAny(ident));
    try std.testing.expect(!checker.typeIsAny(ident));
}
