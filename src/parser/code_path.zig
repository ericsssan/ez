/// Code path analysis — full multi-segment CFG builder.
///
/// This is a Zig port of ESLint's CodePathAnalysis. It builds a complete
/// segment graph during semantic analysis and serializes it to the shared
/// buffer so JS can read precomputed segment/codepath objects without
/// any reconstruction.
///
/// Architecture:
///   CodePathBuilder  — drives the analysis (replaces CodePathAnalyzer + CodePathState)
///   Segment          — a straight-line code block (replaces CodePathSegment)
///   ForkContext       — manages parallel segment arrays (replaces ForkContext)
///   ChoiceContext     — if/else, &&, ||, ?? branching
///   SwitchContext     — switch/case/default
///   TryContext        — try/catch/finally
///   LoopContext       — while/do-while/for/for-in/for-of
///   CodePath          — one per function/program (replaces CodePath)

const std = @import("std");
const Allocator = std.mem.Allocator;
const ast_mod = @import("ast.zig");
const NodeIndex = ast_mod.NodeIndex;

// ── Segment ──────────────────────────────────────────────────────

pub const SegmentId = u32;
pub const NONE_SEG: SegmentId = std.math.maxInt(SegmentId);

pub const Segment = struct {
    reachable: bool,
    codepath: CodePathId,

    // Adjacency — stored as ranges into flat target arrays in CodePathBuilder.
    // Populated during markUsed() and loop back-edge creation.
    all_prev_start: u32,
    all_prev_end: u32,
    prev_start: u32, // reachable-only prev
    prev_end: u32,
    all_next_start: u32,
    all_next_end: u32,
    next_start: u32, // reachable-only next
    next_end: u32,
    looped_prev_start: u32,
    looped_prev_end: u32,
};

// ── CodePath ─────────────────────────────────────────────────────

pub const CodePathId = u32;
pub const NONE_CP: CodePathId = std.math.maxInt(CodePathId);

pub const Origin = enum(u8) {
    program = 0,
    function = 1,
    class_field_initializer = 2,
    class_static_block = 3,
};

pub const CodePath = struct {
    origin: Origin,
    upper: CodePathId, // parent code path, NONE_CP = root
    initial_segment: SegmentId,
    // Final/returned/thrown segments stored as ranges into flat arrays.
    final_start: u32,
    final_end: u32,
    returned_start: u32,
    returned_end: u32,
    thrown_start: u32,
    thrown_end: u32,
};

// ── Event ────────────────────────────────────────────────────────

pub const EventType = enum(u32) {
    codepath_start = 0,
    codepath_end = 1,
    seg_start = 2,
    seg_end = 3,
    unreachable_seg_start = 4,
    unreachable_seg_end = 5,
    seg_loop = 6,
};

/// Bits 30-31 of the serialized node field encode the event phase:
///   00 = fire at node ENTER (before enter handler)
///   01 = fire at node EXIT (before exit handler)
///   10 = fire at node POST (after exit handler)
///   11 = fire at node AFTER_ENTER (after enter handler, before children)
pub const EVENT_EXIT_FLAG: u32 = 0x40000000;
pub const EVENT_POST_FLAG: u32 = 0x80000000;
pub const EVENT_NODE_MASK: u32 = 0x3FFFFFFF;

pub const EventPhase = enum(u2) { enter = 0, exit = 1, post = 2, after_enter = 3 };

pub const Event = struct {
    type: EventType,
    node: NodeIndex,
    data1: u32,
    data2: u32,
    phase: EventPhase,
};

// ── ForkContext ───────────────────────────────────────────────────
// Manages parallel segment arrays. Each element in segments_list is
// a slice of `count` segments representing one step in each fork.

const FC_INLINE_CAP: u32 = 2;

const ForkContext = struct {
    count: u32,
    upper: ?*ForkContext,
    // Inline storage for the first FC_INLINE_CAP entries — most ForkContexts
    // hold ≤2 segment-ID slices before being discarded.  Avoids the default
    // ArrayList 0→8 grow allocation per init.
    sl_inline: [FC_INLINE_CAP][]SegmentId,
    sl_count: u32,
    // Heap spill for entries beyond the inline buffer.
    sl_heap: std.ArrayListUnmanaged([]SegmentId),
    allocator: Allocator,

    fn init(alloc: Allocator, upper: ?*ForkContext, count: u32) ForkContext {
        return .{
            .count = count,
            .upper = upper,
            .sl_inline = undefined,
            .sl_count = 0,
            .sl_heap = .empty,
            .allocator = alloc,
        };
    }

    inline fn totalLen(self: *const ForkContext) usize {
        return @as(usize, self.sl_count) + self.sl_heap.items.len;
    }

    inline fn getEntry(self: *const ForkContext, idx: usize) []SegmentId {
        if (idx < self.sl_count) return self.sl_inline[idx];
        return self.sl_heap.items[idx - self.sl_count];
    }

    fn head(self: *const ForkContext) []SegmentId {
        const n = self.totalLen();
        if (n == 0) return &.{};
        return self.getEntry(n - 1);
    }

    fn empty(self: *const ForkContext) bool {
        return self.sl_count == 0 and self.sl_heap.items.len == 0;
    }

    fn reachable(self: *const ForkContext, builder: *const CodePathBuilder) bool {
        const h = self.head();
        for (h) |seg_id| {
            if (seg_id != NONE_SEG and (builder.seg_reachable.items[seg_id] != 0)) return true;
        }
        return false;
    }

    fn pushEntry(self: *ForkContext, entry: []SegmentId) !void {
        if (self.sl_count < FC_INLINE_CAP) {
            self.sl_inline[self.sl_count] = entry;
            self.sl_count += 1;
            return;
        }
        try self.sl_heap.append(self.allocator, entry);
    }

    fn setLastEntry(self: *ForkContext, entry: []SegmentId) void {
        if (self.sl_heap.items.len > 0) {
            self.sl_heap.items[self.sl_heap.items.len - 1] = entry;
            return;
        }
        // Must be in inline buffer (sl_count > 0 guaranteed by caller).
        self.sl_inline[self.sl_count - 1] = entry;
    }

    fn add(self: *ForkContext, segments: []SegmentId, builder: *CodePathBuilder) !void {
        const merged = try mergeExtraSegments(self, segments, builder);
        try self.pushEntry(merged);
    }

    fn replaceHead(self: *ForkContext, segments: []SegmentId, builder: *CodePathBuilder) !void {
        const merged = try mergeExtraSegments(self, segments, builder);
        if (self.totalLen() > 0) {
            self.setLastEntry(merged);
        } else {
            try self.pushEntry(merged);
        }
    }

    fn addAll(self: *ForkContext, other: *const ForkContext) !void {
        const other_inline_n = other.sl_count;
        for (0..other_inline_n) |i| try self.pushEntry(other.sl_inline[i]);
        for (other.sl_heap.items) |entry| try self.pushEntry(entry);
    }

    fn clear(self: *ForkContext) void {
        self.sl_count = 0;
        self.sl_heap.clearRetainingCapacity();
    }

    /// Create new segments from a range of the segments_list.
    fn makeNext(self: *ForkContext, start_idx: i32, end_idx: i32, builder: *CodePathBuilder) ![]SegmentId {
        return self.createSegments(start_idx, end_idx, builder, .next);
    }

    fn makeUnreachable(self: *ForkContext, start_idx: i32, end_idx: i32, builder: *CodePathBuilder) ![]SegmentId {
        return self.createSegments(start_idx, end_idx, builder, .unreachable_seg);
    }

    const CreateMode = enum { next, unreachable_seg };

    fn createSegments(self: *ForkContext, start_idx: i32, end_idx: i32, builder: *CodePathBuilder, mode: CreateMode) ![]SegmentId {
        const total: i32 = @intCast(self.totalLen());

        // Guard: if the list is empty, create segments with no prev
        if (total == 0) {
            const result = try self.allocator.alloc(SegmentId, self.count);
            for (0..self.count) |i| {
                result[i] = switch (mode) {
                    .next => try builder.newNextSegment(&.{}),
                    .unreachable_seg => try builder.newUnreachableSegment(&.{}),
                };
            }
            return result;
        }

        const norm_start: usize = @intCast(if (start_idx >= 0) start_idx else total + start_idx);
        const norm_end: usize = @intCast(if (end_idx >= 0) end_idx else total + end_idx);

        const result = try self.allocator.alloc(SegmentId, self.count);
        for (0..self.count) |i| {
            // Two-pass count+fill via getEntry (bridges inline + heap storage).
            var n_prev: usize = 0;
            var j = norm_start;
            while (j <= norm_end) : (j += 1) {
                if (i < self.getEntry(j).len) n_prev += 1;
            }
            const prev_slice = try self.allocator.alloc(SegmentId, n_prev);
            var idx: usize = 0;
            j = norm_start;
            while (j <= norm_end) : (j += 1) {
                const entry = self.getEntry(j);
                if (i < entry.len) {
                    prev_slice[idx] = entry[i];
                    idx += 1;
                }
            }

            result[i] = switch (mode) {
                .next => try builder.newNextSegment(prev_slice),
                .unreachable_seg => try builder.newUnreachableSegment(prev_slice),
            };
        }
        return result;
    }
};

fn mergeExtraSegments(ctx: *ForkContext, segments: []SegmentId, builder: *CodePathBuilder) ![]SegmentId {
    var current = segments;
    while (current.len > ctx.count) {
        const half = current.len / 2;
        const merged = try ctx.allocator.alloc(SegmentId, half);
        for (0..half) |i| {
            const prev = try ctx.allocator.alloc(SegmentId, 2);
            prev[0] = current[i];
            prev[1] = current[i + half];
            merged[i] = try builder.newNextSegment(prev);
        }
        current = merged;
    }
    return current;
}

fn newEmptyForkContext(alloc: Allocator, parent: *ForkContext, should_fork_leaving: bool) ForkContext {
    const count = (if (should_fork_leaving) @as(u32, 2) else @as(u32, 1)) * parent.count;
    return ForkContext.init(alloc, parent, count);
}

// ── Context Types ────────────────────────────────────────────────

pub const ChoiceKind = enum { test_kind, logical_and, logical_or, nullish, loop };

const ChoiceContext = struct {
    upper: ?*ChoiceContext,
    kind: ChoiceKind,
    is_forking_as_result: bool,
    true_fork: ForkContext,
    false_fork: ForkContext,
    nullish_fork: ForkContext,
    processed: bool,
};

const SwitchContext = struct {
    upper: ?*SwitchContext,
    has_case: bool,
    default_segments: ?[]SegmentId,
    default_body_segments: ?[]SegmentId,
    found_empty_default: bool,
    last_is_default: bool,
    fork_count: u32,
    /// Discriminant entry segments — each case forks from here.
    entry_segments: ?[]SegmentId,
};

const TryContext = struct {
    upper: ?*TryContext,
    has_finalizer: bool,
    position: enum { try_body, catch_body, finally_body },
    returned_fork: ForkContext,
    thrown_fork: ForkContext,
    try_end_fork: ForkContext, // segments at end of try body (for merging with catch end)
    pre_try_segments: ?[]SegmentId, // head before try body (for catch entry reachability)
    last_of_try_reachable: bool,
    last_of_catch_reachable: bool,
    first_throwable_called: bool, // has makeFirstThrowablePathInTryBlock been called?
};

pub const LoopType = enum {
    while_stmt,
    do_while_stmt,
    for_stmt,
    for_in_stmt,
    for_of_stmt,
};

const LoopContext = struct {
    upper: ?*LoopContext,
    loop_type: LoopType,
    label: ?[]const u8,
    // Loop-type specific data
    test_value: enum { unknown, literal_true, literal_false } = .unknown,
    continue_dest_segments: ?[]SegmentId = null,
    entry_segments: ?[]SegmentId = null, // for do-while
    continue_fork: ForkContext,
    // For for-loops
    test_segments: ?[]SegmentId = null,
    update_segments: ?[]SegmentId = null,
    end_of_init_segments: ?[]SegmentId = null,
    end_of_test_segments: ?[]SegmentId = null,
    end_of_update_segments: ?[]SegmentId = null,
    // For for-in/of
    left_segments: ?[]SegmentId = null,
    end_of_left_segments: ?[]SegmentId = null,
};

// ── CodePathBuilder ──────────────────────────────────────────────

pub const CodePathBuilder = struct {
    /// Parent allocator — used only for copying result slices out in finish().
    parent_allocator: Allocator,
    /// Arena owns all internal allocations (ArrayLists backing, ForkContexts, etc.).
    /// Freed as a unit in deinit().
    arena: std.heap.ArenaAllocator,
    /// Shortcut to arena.allocator() — set in init().
    allocator: Allocator,

    // Results
    segments: std.ArrayList(Segment),
    /// Hot sidecar of segments.items[i].reachable — 1 byte per segment.
    /// Segment struct is 48 bytes; isolating this flag cuts reachability
    /// checks from 1 struct-load (random 48-byte access) to 1 byte-load.
    seg_reachable: std.ArrayList(u8),
    /// Sidecar of used flag — same motivation, also hot in flattenUnused.
    seg_used: std.ArrayList(u8),
    codepaths: std.ArrayList(CodePath),
    events: std.ArrayList(Event),

    // Adjacency target pools (segments reference ranges into these)
    all_prev_targets: std.ArrayList(SegmentId),
    prev_targets: std.ArrayList(SegmentId),
    all_next_targets: std.ArrayList(SegmentId),
    next_targets: std.ArrayList(SegmentId),
    looped_targets: std.ArrayList(SegmentId),

    // CodePath segment lists (finals, returned, thrown)
    cp_final_pool: std.ArrayList(SegmentId),
    cp_returned_pool: std.ArrayList(SegmentId),
    cp_thrown_pool: std.ArrayList(SegmentId),

    // State
    fork_context: *ForkContext,
    current_codepath: CodePathId,
    choice_context: ?*ChoiceContext,
    switch_context: ?*SwitchContext,
    try_context: ?*TryContext,
    loop_context: ?*LoopContext,

    // Segment ID counter
    seg_counter: u32,

    pub fn init(alloc: Allocator) CodePathBuilder {
        return .{
            .parent_allocator = alloc,
            .arena = std.heap.ArenaAllocator.init(alloc),
            .allocator = undefined, // fixed up by caller: self.cpb.allocator = self.cpb.arena.allocator()
            .segments = .empty,
            .seg_reachable = .empty,
            .seg_used = .empty,
            .codepaths = .empty,
            .events = .empty,
            .all_prev_targets = .empty,
            .prev_targets = .empty,
            .all_next_targets = .empty,
            .next_targets = .empty,
            .looped_targets = .empty,
            .cp_final_pool = .empty,
            .cp_returned_pool = .empty,
            .cp_thrown_pool = .empty,
            .fork_context = undefined,
            .current_codepath = NONE_CP,
            .choice_context = null,
            .switch_context = null,
            .try_context = null,
            .loop_context = null,
            .seg_counter = 0,
        };
    }

    /// Pre-size internal ArrayLists to avoid growth reallocs during event
    /// processing.  Hints come from the event stream (scope/declare/reference
    /// counts).  Over-estimation is fine — arena-backed, so unused capacity
    /// lives in the final arena reset.
    pub fn ensureCapacity(self: *CodePathBuilder, est_segments: u32, est_codepaths: u32) !void {
        try self.segments.ensureTotalCapacity(self.allocator, est_segments);
        try self.seg_reachable.ensureTotalCapacity(self.allocator, est_segments);
        try self.seg_used.ensureTotalCapacity(self.allocator, est_segments);
        try self.codepaths.ensureTotalCapacity(self.allocator, est_codepaths);
        try self.events.ensureTotalCapacity(self.allocator, est_segments * 2);
        try self.all_prev_targets.ensureTotalCapacity(self.allocator, est_segments);
        try self.prev_targets.ensureTotalCapacity(self.allocator, est_segments);
        try self.all_next_targets.ensureTotalCapacity(self.allocator, est_segments);
        try self.next_targets.ensureTotalCapacity(self.allocator, est_segments);
        // Loop back-edges and cp pools scale with loop/function counts — smaller.
        try self.looped_targets.ensureTotalCapacity(self.allocator, est_codepaths * 8);
        try self.cp_final_pool.ensureTotalCapacity(self.allocator, est_codepaths * 2);
        try self.cp_returned_pool.ensureTotalCapacity(self.allocator, est_codepaths);
        try self.cp_thrown_pool.ensureTotalCapacity(self.allocator, est_codepaths / 4);
    }

    /// Free all internal allocations. Call after finish() returns the Result.
    pub fn deinit(self: *CodePathBuilder) void {
        self.arena.deinit();
        self.* = undefined;
    }

    // ── Segment creation ─────────────────────────────────────

    fn newRootSegment(self: *CodePathBuilder) !SegmentId {
        const id: SegmentId = @intCast(self.segments.items.len);
        try self.segments.append(self.allocator, .{
            .reachable = true,
            .codepath = self.current_codepath,
            .all_prev_start = 0,
            .all_prev_end = 0,
            .prev_start = 0,
            .prev_end = 0,
            .all_next_start = 0,
            .all_next_end = 0,
            .next_start = 0,
            .next_end = 0,
            .looped_prev_start = 0,
            .looped_prev_end = 0,
        });
        try self.seg_reachable.append(self.allocator, 1);
        try self.seg_used.append(self.allocator, 0);
        return id;
    }

    /// Create a new segment that follows the given previous segments.
    /// Reachable if any prev is reachable.
    pub fn newNextSegment(self: *CodePathBuilder, all_prev: []const SegmentId) !SegmentId {
        const flattened = try self.flattenUnused(all_prev);
        var any_reachable = false;
        for (flattened) |p| {
            if (p != NONE_SEG and (self.seg_reachable.items[p] != 0)) {
                any_reachable = true;
                break;
            }
        }
        return self.createSegment(flattened, any_reachable, false);
    }

    /// Create an unreachable segment.
    pub fn newUnreachableSegment(self: *CodePathBuilder, all_prev: []const SegmentId) !SegmentId {
        const flattened = try self.flattenUnused(all_prev);
        const id = try self.createSegment(flattened, false, false);
        // Unreachable segments are immediately marked used (ESLint behavior).
        try self.markUsed(id);
        return id;
    }

    /// Create a disconnected segment (no edge connections, inherits reachability).

    fn createSegment(self: *CodePathBuilder, all_prev: []const SegmentId, is_reachable: bool, _: bool) !SegmentId {
        const id: SegmentId = @intCast(self.segments.items.len);
        const alloc = self.allocator;

        // Single fused pass over all_prev — one capacity check per target list,
        // no re-read of the input slice.
        try self.all_prev_targets.ensureUnusedCapacity(alloc, all_prev.len);
        try self.prev_targets.ensureUnusedCapacity(alloc, all_prev.len);
        const ap_start: u32 = @intCast(self.all_prev_targets.items.len);
        const p_start: u32 = @intCast(self.prev_targets.items.len);
        const segs = self.segments.items;
        for (all_prev) |p| {
            self.all_prev_targets.appendAssumeCapacity(p);
            if (p != NONE_SEG and segs[p].reachable) {
                self.prev_targets.appendAssumeCapacity(p);
            }
        }
        const ap_end: u32 = @intCast(self.all_prev_targets.items.len);
        const p_end: u32 = @intCast(self.prev_targets.items.len);

        try self.segments.append(alloc, .{
            .reachable = is_reachable,
            .codepath = self.current_codepath,
            .all_prev_start = ap_start,
            .all_prev_end = ap_end,
            .prev_start = p_start,
            .prev_end = p_end,
            .all_next_start = 0,
            .all_next_end = 0,
            .next_start = 0,
            .next_end = 0,
            .looped_prev_start = 0,
            .looped_prev_end = 0,
        });
        try self.seg_reachable.append(alloc, if (is_reachable) 1 else 0);
        try self.seg_used.append(alloc, 0);
        return id;
    }

    /// Mark a segment as used — registers it in prev segments' next lists.
    pub fn markUsed(self: *CodePathBuilder, seg_id: SegmentId) !void {
        if (seg_id == NONE_SEG) return;
        if (self.seg_used.items[seg_id] != 0) return;
        self.seg_used.items[seg_id] = 1;
        const seg = &self.segments.items[seg_id];

        // Hoist hot values out of the loop.
        const all_prev = self.all_prev_targets.items[seg.all_prev_start..seg.all_prev_end];
        const alloc = self.allocator;
        const is_reachable = self.seg_reachable.items[seg_id] != 0;

        // Preflight capacity — at most all_prev.len appends per list.
        try self.all_next_targets.ensureUnusedCapacity(alloc, all_prev.len);
        if (is_reachable) try self.next_targets.ensureUnusedCapacity(alloc, all_prev.len);

        for (all_prev) |prev_id| {
            if (prev_id == NONE_SEG) continue;
            var prev = &self.segments.items[prev_id];
            if (prev.all_next_end == 0 and prev.all_next_start == 0) {
                prev.all_next_start = @intCast(self.all_next_targets.items.len);
            }
            self.all_next_targets.appendAssumeCapacity(seg_id);
            prev.all_next_end = @intCast(self.all_next_targets.items.len);

            if (is_reachable) {
                if (prev.next_end == 0 and prev.next_start == 0) {
                    prev.next_start = @intCast(self.next_targets.items.len);
                }
                self.next_targets.appendAssumeCapacity(seg_id);
                prev.next_end = @intCast(self.next_targets.items.len);
            }
        }
    }

    /// Mark a prev segment as looped (back-edge from loop end to loop head).
    pub fn markLooped(self: *CodePathBuilder, seg_id: SegmentId, prev_seg_id: SegmentId) !void {
        if (seg_id == NONE_SEG or prev_seg_id == NONE_SEG) return;
        var seg = &self.segments.items[seg_id];
        const prev = &self.segments.items[prev_seg_id];

        // loopedPrevSegments
        if (seg.looped_prev_end == 0 and seg.looped_prev_start == 0) {
            seg.looped_prev_start = @intCast(self.looped_targets.items.len);
        }
        try self.looped_targets.append(self.allocator, prev_seg_id);
        seg.looped_prev_end = @intCast(self.looped_targets.items.len);

        // Also add to forward edges: prev→seg allNextSegments
        if (prev.all_next_end == 0 and prev.all_next_start == 0) {
            prev.all_next_start = @intCast(self.all_next_targets.items.len);
        }
        try self.all_next_targets.append(self.allocator, seg_id);
        prev.all_next_end = @intCast(self.all_next_targets.items.len);

        if ((self.seg_reachable.items[prev_seg_id] != 0)) {
            if (prev.next_end == 0 and prev.next_start == 0) {
                prev.next_start = @intCast(self.next_targets.items.len);
            }
            try self.next_targets.append(self.allocator, seg_id);
            prev.next_end = @intCast(self.next_targets.items.len);
        }
    }

    /// Flatten unused segments: replace unused segments with their prev segments.
    /// Fast paths: (1) empty input, (2) single used segment — no dedup needed.
    /// Linear-scan dedup for small inputs avoids HashMap allocation.
    fn flattenUnused(self: *CodePathBuilder, segments: []const SegmentId) ![]SegmentId {
        // Fast path: empty.
        if (segments.len == 0) return &.{};

        // Fast path: single segment — already unique, no flatten if used.
        if (segments.len == 1) {
            const s = segments[0];
            if (s == NONE_SEG) return &.{};
            if (self.seg_used.items[s] != 0) {
                const out = try self.allocator.alloc(SegmentId, 1);
                out[0] = s;
                return out;
            }
            // Unused — expand to prev (shared case, still small).
            const seg = self.segments.items[s];
            return self.all_prev_targets.items[seg.all_prev_start..seg.all_prev_end];
        }

        // General path: small linear-scan dedup (up to 16 entries on stack).
        // Falls back to HashMap for pathological large inputs (>16 distinct segs).
        if (segments.len <= 16) {
            var buf: [32]SegmentId = undefined;
            var n: usize = 0;
            const used_s = self.seg_used.items;
            outer: for (segments) |seg_id| {
                if (seg_id == NONE_SEG) continue;
                if (used_s[seg_id] != 0) {
                    // Check dedup
                    for (buf[0..n]) |e| if (e == seg_id) continue :outer;
                    if (n < buf.len) { buf[n] = seg_id; n += 1; }
                } else {
                    const seg = self.segments.items[seg_id];
                    const prev = self.all_prev_targets.items[seg.all_prev_start..seg.all_prev_end];
                    prev_loop: for (prev) |p| {
                        if (p == NONE_SEG) continue;
                        for (buf[0..n]) |e| if (e == p) continue :prev_loop;
                        if (n < buf.len) { buf[n] = p; n += 1; }
                    }
                }
            }
            const out = try self.allocator.alloc(SegmentId, n);
            @memcpy(out, buf[0..n]);
            return out;
        }

        // Pathological: HashMap dedup.
        var result: std.ArrayListUnmanaged(SegmentId) = .empty;
        var seen = std.AutoHashMap(SegmentId, void).init(self.allocator);
        defer seen.deinit();

        for (segments) |seg_id| {
            if (seg_id == NONE_SEG) continue;
            if (seen.contains(seg_id)) continue;

            if (self.seg_used.items[seg_id] == 0) {
                const seg = self.segments.items[seg_id];
                const prev = self.all_prev_targets.items[seg.all_prev_start..seg.all_prev_end];
                for (prev) |p| {
                    if (p != NONE_SEG and !seen.contains(p)) {
                        try seen.put(p, {});
                        try result.append(self.allocator, p);
                    }
                }
            } else {
                try seen.put(seg_id, {});
                try result.append(self.allocator, seg_id);
            }
        }
        return result.toOwnedSlice(self.allocator);
    }

    // ── CodePath management ──────────────────────────────────

    /// Enter a new code path (function, program, class field, static block).
    /// Enter a new code path. `node` = the function/program node. `body_node` = the body
    /// (BlockStatement) — initial segment events fire at body_node so they're after the
    /// function node's enter handler (rules set up state in MethodDefinition handler first).
    pub fn enterCodePath(self: *CodePathBuilder, node: NodeIndex, origin: Origin, body_node: NodeIndex) !void {
        const cp_id: CodePathId = @intCast(self.codepaths.items.len);
        const upper = self.current_codepath;
        self.current_codepath = cp_id;

        // Create initial segment
        const initial_seg = try self.newRootSegment();

        // Create fork context (save current as upper for restore on exitCodePath)
        const fc = try self.allocator.create(ForkContext);
        const upper_fc: ?*ForkContext = if (upper != NONE_CP) self.fork_context else null;
        fc.* = ForkContext.init(self.allocator, upper_fc, 1);
        const seg_slice = try self.allocator.alloc(SegmentId, 1);
        seg_slice[0] = initial_seg;
        try fc.add(seg_slice, self);
        self.fork_context = fc;

        try self.codepaths.append(self.allocator, .{
            .origin = origin,
            .upper = upper,
            .initial_segment = initial_seg,
            .final_start = 0,
            .final_end = 0,
            .returned_start = 0,
            .returned_end = 0,
            .thrown_start = 0,
            .thrown_end = 0,
        });

        // Emit events (enter phase)
        try self.events.append(self.allocator, .{
            .type = .codepath_start,
            .node = node,
            .data1 = cp_id,
            .data2 = 0,
            .phase = .enter,
        });

        // Mark initial segment used and emit segment start at body_node
        // (fires at body enter, after the function node's enter handler)
        try self.markUsed(initial_seg);
        try self.emitSegStart(initial_seg, body_node, .enter);
    }

    /// Exit the current code path.
    pub fn exitCodePath(self: *CodePathBuilder, node: NodeIndex) !void {
        const cp_id = self.current_codepath;

        // End current segments (post phase — fires AFTER exit handlers)
        const head = self.fork_context.head();
        for (head) |seg_id| {
            if (seg_id != NONE_SEG) {
                try self.emitSegEnd(seg_id, node, .post);
            }
        }

        // Record final segments.
        // ESLint populates finalSegments incrementally: when return/throw is called,
        // the REACHABLE segments at that point are added. At exit, the head may be
        // unreachable (after return/throw), but finalSegments already has the reachable ones.
        // We replicate: use returned+thrown as finals, plus any reachable head segments.
        var cp = &self.codepaths.items[cp_id];
        cp.final_start = @intCast(self.cp_final_pool.items.len);
        // Add returned segments first (reachable at point of return)
        if (cp.returned_end > cp.returned_start) {
            for (self.cp_returned_pool.items[cp.returned_start..cp.returned_end]) |seg_id| {
                try self.cp_final_pool.append(self.allocator, seg_id);
            }
        }
        // Add thrown segments
        if (cp.thrown_end > cp.thrown_start) {
            for (self.cp_thrown_pool.items[cp.thrown_start..cp.thrown_end]) |seg_id| {
                var dup = false;
                for (self.cp_final_pool.items[cp.final_start..]) |existing| {
                    if (existing == seg_id) { dup = true; break; }
                }
                if (!dup) try self.cp_final_pool.append(self.allocator, seg_id);
            }
        }
        // Add reachable head segments (for paths that reach the end without return/throw)
        for (head) |seg_id| {
            if (seg_id != NONE_SEG and (self.seg_reachable.items[seg_id] != 0)) {
                var dup = false;
                for (self.cp_final_pool.items[cp.final_start..]) |existing| {
                    if (existing == seg_id) { dup = true; break; }
                }
                if (!dup) try self.cp_final_pool.append(self.allocator, seg_id);
            }
        }
        // If nothing was added (all paths exit and head is unreachable), add head anyway
        if (self.cp_final_pool.items.len == cp.final_start) {
            for (head) |seg_id| {
                try self.cp_final_pool.append(self.allocator, seg_id);
            }
        }
        cp.final_end = @intCast(self.cp_final_pool.items.len);

        // Reachable final segments are also returned segments (implicit return).
        // Only add reachable ones — unreachable finals mean all paths explicitly
        // return/throw, so they shouldn't appear in returnedSegments.
        if (cp.origin != .program) {
            for (head) |seg_id| {
                if (seg_id != NONE_SEG and (self.seg_reachable.items[seg_id] != 0)) {
                    if (cp.returned_end == 0 and cp.returned_start == 0) {
                        cp.returned_start = @intCast(self.cp_returned_pool.items.len);
                    }
                    try self.cp_returned_pool.append(self.allocator, seg_id);
                    cp.returned_end = @intCast(self.cp_returned_pool.items.len);
                }
            }
        }

        // Emit codepath end (post phase — fires AFTER exit handlers)
        try self.events.append(self.allocator, .{
            .type = .codepath_end,
            .node = node,
            .data1 = cp_id,
            .data2 = 0,
            .phase = .post,
        });

        // Restore upper code path
        self.current_codepath = cp.upper;
        if (self.fork_context.upper) |upper_fc| {
            self.fork_context = upper_fc;
        }
    }

    // ── Segment event emission ───────────────────────────────

    fn emitSegStart(self: *CodePathBuilder, seg_id: SegmentId, node: NodeIndex, phase: EventPhase) !void {
        if (seg_id == NONE_SEG) return;
        const is_reachable = self.seg_reachable.items[seg_id] != 0;
        try self.events.append(self.allocator, .{
            .type = if (is_reachable) .seg_start else .unreachable_seg_start,
            .node = node,
            .data1 = seg_id,
            .data2 = 0,
            .phase = phase,
        });
    }

    fn emitSegEnd(self: *CodePathBuilder, seg_id: SegmentId, node: NodeIndex, phase: EventPhase) !void {
        if (seg_id == NONE_SEG) return;
        const is_reachable = self.seg_reachable.items[seg_id] != 0;
        try self.events.append(self.allocator, .{
            .type = if (is_reachable) .seg_end else .unreachable_seg_end,
            .node = node,
            .data1 = seg_id,
            .data2 = 0,
            .phase = phase,
        });
    }

    fn emitSegLoop(self: *CodePathBuilder, from_seg: SegmentId, to_seg: SegmentId, node: NodeIndex) !void {
        try self.events.append(self.allocator, .{
            .type = .seg_loop,
            .node = node,
            .data1 = from_seg,
            .data2 = to_seg,
            .phase = .exit, // loop events always fire at exit
        });
    }

    // ── Forward head segments (emit end + start for new segments) ─

    pub fn forwardCurrentToHead(self: *CodePathBuilder, node: NodeIndex, phase: EventPhase) !void {
        const head = self.fork_context.head();
        for (head) |seg_id| {
            if (seg_id != NONE_SEG) {
                try self.markUsed(seg_id);
                try self.emitSegStart(seg_id, node, phase);
            }
        }
    }

    pub fn leaveFromCurrentSegment(self: *CodePathBuilder, node: NodeIndex, phase: EventPhase) !void {
        const head = self.fork_context.head();
        for (head) |seg_id| {
            if (seg_id != NONE_SEG) {
                try self.emitSegEnd(seg_id, node, phase);
            }
        }
    }

    // ── Choice (if/else, logical, conditional) ───────────────

    pub fn pushChoiceContext(self: *CodePathBuilder, kind: ChoiceKind, is_forking: bool) !void {
        const ctx = try self.allocator.create(ChoiceContext);
        ctx.* = .{
            .upper = self.choice_context,
            .kind = kind,
            .is_forking_as_result = is_forking,
            .true_fork = newEmptyForkContext(self.allocator, self.fork_context, false),
            .false_fork = newEmptyForkContext(self.allocator, self.fork_context, false),
            .nullish_fork = newEmptyForkContext(self.allocator, self.fork_context, false),
            .processed = false,
        };
        self.choice_context = ctx;
    }

    pub fn popChoiceContext(self: *CodePathBuilder, node: NodeIndex) !void {
        const ctx = self.choice_context orelse return;
        self.choice_context = ctx.upper;

        // Current (last branch ending) segments — arena-backed, no mutation until
        // after we've copied out the ref below.  No dupe needed.
        const last_branch_end = self.fork_context.head();

        // End current segments
        try self.leaveFromCurrentSegment(node, .exit);

        // Merge branch endings:
        // true_fork.head() = if-consequent ending (saved by makeIfAlternate)
        // last_branch_end = else-alternate ending (or last case in switch)
        var combined = newEmptyForkContext(self.allocator, self.fork_context, false);
        if (!ctx.true_fork.empty()) {
            // ctx is being discarded; its arena-backed slice stays valid.  No dupe needed.
            try combined.add(ctx.true_fork.head(), self);
        }
        try combined.add(last_branch_end, self);

        if (!combined.empty()) {
            const merged = try combined.makeNext(0, -1, self);
            try self.fork_context.replaceHead(merged, self);
        }

        // Start merged segment
        try self.forwardCurrentToHead(node, .exit);
    }

    pub fn makeIfConsequent(self: *CodePathBuilder, node: NodeIndex) !void {
        const ctx = self.choice_context orelse return;
        if (!ctx.processed) {
            ctx.processed = true;
            // Fork current head into both forks — arena-backed slice stays valid.
            const head = self.fork_context.head();
            try ctx.true_fork.add(head, self);
            try ctx.false_fork.add(head, self);
        }
        // End current segments BEFORE switching to the true fork path
        try self.leaveFromCurrentSegment(node, .enter);
        const new_segs = try ctx.true_fork.makeNext(0, -1, self);
        try self.fork_context.replaceHead(new_segs, self);
        try self.forwardCurrentToHead(node, .enter);
    }

    /// Called between LHS and RHS of a logical expression (&&, ||, ??).
    /// For `a && b`: LHS evaluated, now fork — truthy continues to RHS,
    /// falsy short-circuits to merge. Save LHS-end to the short-circuit
    /// branch, create new segment for RHS.
    pub fn makeLogicalRight(self: *CodePathBuilder, node: NodeIndex) !void {
        const ctx = self.choice_context orelse return;
        // Save LHS ending to the short-circuit branch (true_fork).
        // leaveFromCurrentSegment replaces fork_context.head but leaves the old
        // arena-backed slice alive — true_fork keeps a valid reference.
        try ctx.true_fork.add(self.fork_context.head(), self);
        // End LHS segment, create new segment for RHS
        try self.leaveFromCurrentSegment(node, .enter);
        const new_segs = try self.fork_context.makeNext(-1, -1, self);
        try self.fork_context.replaceHead(new_segs, self);
        try self.forwardCurrentToHead(node, .enter);
    }

    pub fn makeIfAlternate(self: *CodePathBuilder, node: NodeIndex) !void {
        const ctx = self.choice_context orelse return;
        // Save end of true branch (arena-backed slice stays valid after replaceHead).
        try ctx.true_fork.add(self.fork_context.head(), self);
        // End current (true branch ending) BEFORE switching to false path
        try self.leaveFromCurrentSegment(node, .enter);
        // Switch to false fork path
        const new_segs = try ctx.false_fork.makeNext(0, -1, self);
        try self.fork_context.replaceHead(new_segs, self);
        // Start new (else branch) segments
        try self.forwardCurrentToHead(node, .enter);
    }

    // ── Switch ───────────────────────────────────────────────

    pub fn pushSwitchContext(self: *CodePathBuilder, has_case: bool, label: ?[]const u8) !void {
        _ = label;

        const ctx = try self.allocator.create(SwitchContext);
        ctx.* = .{
            .upper = self.switch_context,
            .has_case = has_case,
            .default_segments = null,
            .default_body_segments = null,
            .found_empty_default = false,
            .last_is_default = false,
            .fork_count = 0,
            // No dupe: pushForkContext below stacks a new fork_context, so the
            // outer fork's segments_list[last] stays arena-stable for us.
            .entry_segments = self.fork_context.head(),
        };
        self.switch_context = ctx;

        // Push fork context and choice context for the switch
        try self.pushForkContext();
        try self.pushChoiceContext(.test_kind, false);
    }

    pub fn popSwitchContext(self: *CodePathBuilder, node: NodeIndex) !void {
        const ctx = self.switch_context orelse return;
        self.switch_context = ctx.upper;
        // Merge switch-break segments into the choice context BEFORE merging.
        try self.popChoiceContext(node);

        // If the switch has a default case, all branches are covered.
        if (ctx.default_segments != null) {
            const fc = self.fork_context;
            if (fc.totalLen() > 1) {
                const last = fc.head();
                fc.clear();
                try fc.pushEntry(last);
            }
        }

        try self.popForkContext(node);
    }

    pub fn makeSwitchCaseBody(self: *CodePathBuilder, is_default: bool, node: NodeIndex) !void {
        const ctx = self.switch_context orelse return;
        if (is_default) {
            ctx.last_is_default = true;
            // Arena slice stays valid; no dupe.
            ctx.default_segments = self.fork_context.head();
        } else {
            ctx.last_is_default = false;
        }
        ctx.fork_count += 1;

        // End current segments (fires before SwitchCase handler)
        try self.leaveFromCurrentSegment(node, .enter);

        // Each case body forks from the discriminant entry (head of the outer
        // fork context), NOT from the previous case's exit. This ensures cases
        // after break/return start reachable.
        const current_head = self.fork_context.head();
        var has_reachable_prev = false;
        for (current_head) |s| {
            if (s != NONE_SEG and (self.seg_reachable.items[s] != 0)) has_reachable_prev = true;
        }

        // Merge ALL entries in the fork context (0 to -1), not just the last.
        // This combines fallthrough from previous case + discriminant fork path.
        const list_len = self.fork_context.totalLen();
        if (list_len > 1) {
            // Multiple entries exist (fallthrough + fork): merge all
            const new_segs = try self.fork_context.makeNext(0, -1, self);
            try self.fork_context.add(new_segs, self);
        } else {
            const new_segs = try self.fork_context.makeNext(-1, -1, self);
            try self.fork_context.add(new_segs, self);
        }
        // Fire SEGMENT_START after the SwitchCase handler (after_enter phase) so that
        // sonarjs/no-fallthrough's `enteringSwitchCase` flag is set before onCodePathSegmentStart fires.
        try self.forwardCurrentToHead(node, .after_enter);
    }

    // ── Try/catch/finally ────────────────────────────────────

    pub fn pushTryContext(self: *CodePathBuilder, has_finalizer: bool, try_body_node: NodeIndex) !void {
        // Save pre-try head BEFORE creating try-body segment.  The arena-backed
        // slice stays valid even after replaceHead (only overwrites the list entry).
        const pre_try = self.fork_context.head();

        // Create a new segment for the try body so it's separate from pre-try.
        // Catch predecessor must be pre-try (before any try-body code ran).
        try self.leaveFromCurrentSegment(try_body_node, .enter);
        const try_body_segs = try self.fork_context.makeNext(-1, -1, self);
        try self.fork_context.replaceHead(try_body_segs, self);
        try self.forwardCurrentToHead(try_body_node, .enter);

        const ctx = try self.allocator.create(TryContext);
        ctx.* = .{
            .upper = self.try_context,
            .has_finalizer = has_finalizer,
            .position = .try_body,
            .returned_fork = newEmptyForkContext(self.allocator, self.fork_context, false),
            .thrown_fork = newEmptyForkContext(self.allocator, self.fork_context, false),
            .try_end_fork = newEmptyForkContext(self.allocator, self.fork_context, false),
            .pre_try_segments = pre_try,
            .last_of_try_reachable = false,
            .last_of_catch_reachable = false,
            .first_throwable_called = false,
        };
        self.try_context = ctx;

        if (has_finalizer) {
            try self.pushForkContext();
        }
    }

    pub fn popTryContext(self: *CodePathBuilder, node: NodeIndex) !void {
        const ctx = self.try_context orelse return;
        self.try_context = ctx.upper;

        if (ctx.has_finalizer) {
            if (!ctx.thrown_fork.empty()) {
                // Pop the doubled-count fork. Extract only lane 0 (normal path).
                // Lane 1 (exception) re-throws — code after try/finally doesn't run on it.
                const doubled_fc = self.fork_context;
                if (doubled_fc.upper) |parent_fc| {
                    const parent_count = parent_fc.count;
                    const head = doubled_fc.head();
                    const lane0 = try self.allocator.alloc(SegmentId, parent_count);
                    for (0..parent_count) |i| {
                        lane0[i] = if (i < head.len) head[i] else NONE_SEG;
                    }
                    try self.leaveFromCurrentSegment(node, .exit);
                    try parent_fc.replaceHead(lane0, self);
                    self.fork_context = parent_fc;
                    try self.forwardCurrentToHead(node, .exit);
                }
            } else {
                try self.popForkContext(node);
            }
        }

        // Merge try-end + catch-end as reachable continuations
        // (either try completed normally OR catch completed)
        if (!ctx.try_end_fork.empty()) {
            try self.leaveFromCurrentSegment(node, .exit);
            var combined = newEmptyForkContext(self.allocator, self.fork_context, false);
            try combined.addAll(&ctx.try_end_fork);
            // Current head has catch-end segments.  combined is transient; no dupe needed.
            try combined.add(self.fork_context.head(), self);
            if (!combined.empty()) {
                const merged = try combined.makeNext(0, -1, self);
                try self.fork_context.replaceHead(merged, self);
            }
            try self.forwardCurrentToHead(node, .exit);
        }

        // If there's a finally block and all paths into it were via return/throw
        // (both try and catch ended unreachably), AND there were no throwable expressions
        // in the try body (thrown_fork empty), code after the try-finally is dead.
        // When thrown_fork is non-empty, ESLint propagates leaving segments to the
        // enclosing return context (leavingSegments forwarding) which we don't do;
        // applying makeUnreachable in that case causes no-useless-return FPs.
        if (ctx.has_finalizer and ctx.thrown_fork.empty() and
            !ctx.last_of_try_reachable and !ctx.last_of_catch_reachable)
        {
            try self.leaveFromCurrentSegment(node, .exit);
            const unreachable_segs = try self.fork_context.makeUnreachable(-1, -1, self);
            try self.fork_context.replaceHead(unreachable_segs, self);
            try self.forwardCurrentToHead(node, .exit);
        }
    }

    pub fn makeCatchBlock(self: *CodePathBuilder, node: NodeIndex) !void {
        const ctx = self.try_context orelse return;
        ctx.last_of_try_reachable = self.fork_context.reachable(self);
        // Save try-body exit segments for merging in popTryContext.
        // Arena backing stays valid after subsequent replaceHead.
        try ctx.try_end_fork.add(self.fork_context.head(), self);
        ctx.position = .catch_body;

        // End try body segments, start catch segments.
        try self.leaveFromCurrentSegment(node, .enter);
        // Catch is unreachable only if: (a) no throwable expressions in try body, AND
        // (b) the try body always exits (return/throw/break — current head is unreachable).
        // Otherwise catch is reachable from pre-try segments.
        const try_body_dead = !self.fork_context.reachable(self);
        if (!ctx.first_throwable_called and try_body_dead) {
            // Try body exited without any throwable expression — catch is dead.
            const unreachable_segs = try self.fork_context.makeUnreachable(-1, -1, self);
            try self.fork_context.replaceHead(unreachable_segs, self);
            try self.forwardCurrentToHead(node, .enter);
        } else {
            // Catch is reachable from pre-try.  pre_try's arena data is immortal;
            // replaceHead just overwrites the list entry pointer.
            if (ctx.pre_try_segments) |pre_try| {
                try self.fork_context.replaceHead(pre_try, self);
            }
            const catch_segs = try self.fork_context.makeNext(-1, -1, self);
            try self.fork_context.replaceHead(catch_segs, self);
            try self.forwardCurrentToHead(node, .enter);
        }
    }

    pub fn makeFinallyBlock(self: *CodePathBuilder, node: NodeIndex) !void {
        const ctx = self.try_context orelse return;
        ctx.last_of_catch_reachable = self.fork_context.reachable(self);
        ctx.position = .finally_body;

        try self.leaveFromCurrentSegment(node, .enter);

        // If thrownForkContext has entries (from makeFirstThrowablePathInTryBlock),
        // create a doubled-count fork for the finally body. Lane 0 = normal path,
        // lane 1 = exception/thrown path.
        if (!ctx.thrown_fork.empty() or !ctx.returned_fork.empty()) {
            // Merge normal path + returned paths for the finally entry.
            // Finally is always reachable because at least one path leads to it.
            var fc_for_normal = newEmptyForkContext(self.allocator, self.fork_context, false);
            // Add current head (may be unreachable after return).  fc_for_normal
            // is transient; shared ref into fork_context.segments_list is safe.
            const cur_head = self.fork_context.head();
            if (cur_head.len > 0) {
                try fc_for_normal.add(cur_head, self);
            }
            // Add returned paths (these are reachable — they existed before return made code dead)
            if (!ctx.returned_fork.empty()) {
                try fc_for_normal.addAll(&ctx.returned_fork);
            }
            const normal_segs = try fc_for_normal.makeNext(0, -1, self);

            // Create the exception-path finally entry from thrown segments
            const thrown_segs = try ctx.thrown_fork.makeNext(0, -1, self);

            // Push a doubled-count fork context
            const parent_count = self.fork_context.count;
            const new_fc = try self.allocator.create(ForkContext);
            new_fc.* = ForkContext.init(self.allocator, self.fork_context, parent_count * 2);

            // Seed with [normal_lane..., exception_lane...]
            const doubled = try self.allocator.alloc(SegmentId, parent_count * 2);
            for (0..parent_count) |i| {
                doubled[i] = if (i < normal_segs.len) normal_segs[i] else NONE_SEG;
                doubled[i + parent_count] = if (i < thrown_segs.len) thrown_segs[i] else NONE_SEG;
            }
            try new_fc.pushEntry(doubled);
            self.fork_context = new_fc;
            // Start both lanes
            try self.forwardCurrentToHead(node, .enter);
        } else {
            // No throwable paths — simple finally (no count doubling)
            const new_segs = try self.fork_context.makeNext(-1, -1, self);
            try self.fork_context.replaceHead(new_segs, self);
            try self.forwardCurrentToHead(node, .enter);
        }
    }

    // ── Loops ────────────────────────────────────────────────

    /// `target_node`: the loop's condition/body/update child node for isLoopingTarget matching.
    pub fn pushLoopContext(self: *CodePathBuilder, loop_type: LoopType, label: ?[]const u8, _: NodeIndex, target_node: NodeIndex) !void {
        const ctx = try self.allocator.create(LoopContext);
        ctx.* = .{
            .upper = self.loop_context,
            .loop_type = loop_type,
            .label = label,
            .continue_fork = newEmptyForkContext(self.allocator, self.fork_context, false),
        };
        self.loop_context = ctx;

        try self.pushChoiceContext(.loop, false);

        // For while/for loops, save current head as the "loop skipped" path.
        // If the condition is false initially, control skips the body entirely.
        // do-while always executes the body at least once, so no skip path.
        if (loop_type != .do_while_stmt) {
            if (self.choice_context) |cc| {
                try cc.true_fork.add(self.fork_context.head(), self);
            }
        }

        // Emit segment transition: end current, start loop body segment
        // Use target_node (test/body/update child) so isLoopingTarget matches
        try self.leaveFromCurrentSegment(target_node, .enter);
        const new_segs = try self.fork_context.makeNext(-1, -1, self);
        try self.fork_context.replaceHead(new_segs, self);
        try self.forwardCurrentToHead(target_node, .enter);
        // Always save entry segments for LOOP event (used as toSegment).
        ctx.entry_segments = self.fork_context.head();
    }

    pub fn popLoopContext(self: *CodePathBuilder, node: NodeIndex) !void {
        const ctx = self.loop_context orelse return;
        self.loop_context = ctx.upper;
        // Merge continue segments into choice context — these flow back to loop head
        // and indicate the loop CAN iterate (preventing false unreachable-loop reports)
        if (!ctx.continue_fork.empty()) {
            if (self.choice_context) |cc| {
                try cc.true_fork.addAll(&ctx.continue_fork);
            }
        }
        try self.popChoiceContext(node);
    }

    pub fn makeLoopBackEdge(self: *CodePathBuilder, node: NodeIndex) !void {
        const ctx = self.loop_context orelse return;
        const head = self.fork_context.head();
        const dest = ctx.continue_dest_segments orelse ctx.entry_segments;
        if (dest) |d| {
            for (head) |from_seg| {
                // Only create back-edges from reachable segments.
                // If the loop body always exits (return/throw/break), no back-edge.
                if (from_seg != NONE_SEG and (self.seg_reachable.items[from_seg] != 0)) {
                    for (d) |to_seg| {
                        if (to_seg != NONE_SEG) {
                            try self.markLooped(to_seg, from_seg);
                        }
                    }
                }
            }
        }
        // Emit LOOP event with entry_segments as toSegment (for isLoopingTarget)
        // The entry segment is the one created at pushLoopContext — rules use it
        // to map segment→loop via onCodePathSegmentStart.
        const entry = ctx.entry_segments orelse ctx.continue_dest_segments;
        if (entry) |e| {
            for (head) |from_seg| {
                if (from_seg != NONE_SEG and (self.seg_reachable.items[from_seg] != 0)) {
                    for (e) |to_seg| {
                        if (to_seg != NONE_SEG) {
                            try self.emitSegLoop(from_seg, to_seg, node);
                        }
                    }
                }
            }
        }
    }

    pub fn setLoopContinueDest(self: *CodePathBuilder) void {
        const ctx = self.loop_context orelse return;
        ctx.continue_dest_segments = self.fork_context.head();
    }

    // ── Return/Throw ─────────────────────────────────────────

    pub fn makeReturn(self: *CodePathBuilder, node: NodeIndex) !void {
        const cp_id = self.current_codepath;

        // Record reachable segments in returned pool (unreachable returns are dead code)
        const head = self.fork_context.head();
        var cp = &self.codepaths.items[cp_id];
        for (head) |seg_id| {
            if (seg_id != NONE_SEG and (self.seg_reachable.items[seg_id] != 0)) {
                if (cp.returned_end == 0 and cp.returned_start == 0) {
                    cp.returned_start = @intCast(self.cp_returned_pool.items.len);
                }
                try self.cp_returned_pool.append(self.allocator, seg_id);
                cp.returned_end = @intCast(self.cp_returned_pool.items.len);
            }
        }

        // If inside a try-with-finally, add head to the try's returned_fork
        // so finally knows about the return path.
        if (self.try_context) |tc| {
            if (tc.has_finalizer and tc.position != .finally_body) {
                try tc.returned_fork.add(head, self);
            }
        }

        // Make subsequent code unreachable.
        // Use post phase so SEG_END fires AFTER exit handlers — rules like
        // no-useless-return check currentSegments in ReturnStatement:exit.
        try self.leaveFromCurrentSegment(node, .post);
        const unreachable_segs = try self.fork_context.makeUnreachable(-1, -1, self);
        try self.fork_context.replaceHead(unreachable_segs, self);
        try self.forwardCurrentToHead(node, .post);
    }

    /// Mark current head as unreachable (e.g., after infinite loop with no break).
    pub fn makeUnreachable(self: *CodePathBuilder, node: NodeIndex) !void {
        try self.leaveFromCurrentSegment(node, .exit);
        const unreachable_segs = try self.fork_context.makeUnreachable(-1, -1, self);
        try self.fork_context.replaceHead(unreachable_segs, self);
        try self.forwardCurrentToHead(node, .exit);
    }

    pub fn makeThrow(self: *CodePathBuilder, node: NodeIndex) !void {
        const cp_id = self.current_codepath;

        // Record reachable segments in thrown pool
        const head = self.fork_context.head();
        var cp = &self.codepaths.items[cp_id];
        for (head) |seg_id| {
            if (seg_id != NONE_SEG and (self.seg_reachable.items[seg_id] != 0)) {
                if (cp.thrown_end == 0 and cp.thrown_start == 0) {
                    cp.thrown_start = @intCast(self.cp_thrown_pool.items.len);
                }
                try self.cp_thrown_pool.append(self.allocator, seg_id);
                cp.thrown_end = @intCast(self.cp_thrown_pool.items.len);
            }
        }

        // If inside a try block, also add to try context's thrown fork
        if (self.try_context) |ctx| {
            if (ctx.position == .try_body) {
                ctx.first_throwable_called = true;
                try ctx.thrown_fork.add(head, self);
            }
        }

        // Make subsequent code unreachable (post phase so exit handlers see current segment)
        try self.leaveFromCurrentSegment(node, .post);
        const unreachable_segs = try self.fork_context.makeUnreachable(-1, -1, self);
        try self.fork_context.replaceHead(unreachable_segs, self);
        try self.forwardCurrentToHead(node, .post);
    }

    // ── Fork context management ──────────────────────────────

    pub fn pushForkContext(self: *CodePathBuilder) !void {
        const new_fc = try self.allocator.create(ForkContext);
        new_fc.* = ForkContext.init(self.allocator, self.fork_context, self.fork_context.count);
        // Carry over parent's current head so child operations can reference them as prev.
        // Parent stays alive as new_fc.upper — no dupe needed.
        const parent_head = self.fork_context.head();
        if (parent_head.len > 0) {
            try new_fc.add(parent_head, self);
        }
        self.fork_context = new_fc;
    }

    pub fn popForkContext(self: *CodePathBuilder, node: NodeIndex) !void {
        const fc = self.fork_context;
        if (fc.upper) |upper| {
            if (!fc.empty()) {
                // End current segments before merge
                try self.leaveFromCurrentSegment(node, .exit);
                const merged = try fc.makeNext(0, -1, self);
                try upper.replaceHead(merged, self);
            }
            self.fork_context = upper;
            // Start the merged segments so they get SEG_START events
            if (!fc.empty()) {
                try self.forwardCurrentToHead(node, .exit);
            }
        }
    }

    // ── Result extraction ────────────────────────────────────

    pub const Result = struct {
        segments: []const Segment,
        codepaths: []const CodePath,
        events: []const Event,
        // Adjacency target pools
        all_prev_targets: []const SegmentId,
        prev_targets: []const SegmentId,
        all_next_targets: []const SegmentId,
        next_targets: []const SegmentId,
        looped_targets: []const SegmentId,
        // CodePath segment pools
        cp_final_pool: []const SegmentId,
        cp_returned_pool: []const SegmentId,
        cp_thrown_pool: []const SegmentId,
        /// Arena owning all the above slices.  `finish()` transfers ownership
        /// of the builder's arena here so we skip ~20 MB of per-array memcpy.
        arena: std.heap.ArenaAllocator,

        pub fn deinit(self: *Result, _: std.mem.Allocator) void {
            self.arena.deinit();
            self.* = undefined;
        }
    };

    /// Consume the builder and return a Result that owns the arena.
    /// After finish(), `self` is invalid — do NOT call deinit() on it.
    /// `Result.deinit()` frees the arena.
    pub fn finish(self: *CodePathBuilder) Result {
        const result: Result = .{
            .segments = self.segments.items,
            .codepaths = self.codepaths.items,
            .events = self.events.items,
            .all_prev_targets = self.all_prev_targets.items,
            .prev_targets = self.prev_targets.items,
            .all_next_targets = self.all_next_targets.items,
            .next_targets = self.next_targets.items,
            .looped_targets = self.looped_targets.items,
            .cp_final_pool = self.cp_final_pool.items,
            .cp_returned_pool = self.cp_returned_pool.items,
            .cp_thrown_pool = self.cp_thrown_pool.items,
            .arena = self.arena,
        };
        self.* = undefined;
        return result;
    }
};
