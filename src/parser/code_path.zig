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
///   BreakContext      — break/continue target resolution
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
    used: bool,
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
pub const EVENT_EXIT_FLAG: u32 = 0x40000000;
pub const EVENT_POST_FLAG: u32 = 0x80000000;
pub const EVENT_NODE_MASK: u32 = 0x3FFFFFFF;

pub const EventPhase = enum(u2) { enter = 0, exit = 1, post = 2 };

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

const ForkContext = struct {
    count: u32,
    upper: ?*ForkContext,
    // segments_list: ArrayList of segment-ID slices (each slice has `count` elements)
    // We flatten this as: segments_list stores indices into a flat pool.
    segments_list: std.ArrayListUnmanaged([]SegmentId),
    allocator: Allocator,

    fn init(alloc: Allocator, upper: ?*ForkContext, count: u32) ForkContext {
        return .{
            .count = count,
            .upper = upper,
            .segments_list = .empty,
            .allocator = alloc,
        };
    }

    fn head(self: *const ForkContext) []SegmentId {
        if (self.segments_list.items.len == 0) return &.{};
        return self.segments_list.items[self.segments_list.items.len - 1];
    }

    fn empty(self: *const ForkContext) bool {
        return self.segments_list.items.len == 0;
    }

    fn reachable(self: *const ForkContext, builder: *const CodePathBuilder) bool {
        const h = self.head();
        for (h) |seg_id| {
            if (seg_id != NONE_SEG and builder.segments.items[seg_id].reachable) return true;
        }
        return false;
    }

    fn add(self: *ForkContext, segments: []SegmentId, builder: *CodePathBuilder) !void {
        const merged = try mergeExtraSegments(self, segments, builder);
        try self.segments_list.append(self.allocator, merged);
    }

    fn replaceHead(self: *ForkContext, segments: []SegmentId, builder: *CodePathBuilder) !void {
        const merged = try mergeExtraSegments(self, segments, builder);
        if (self.segments_list.items.len > 0) {
            self.segments_list.items[self.segments_list.items.len - 1] = merged;
        } else {
            try self.segments_list.append(self.allocator, merged);
        }
    }

    fn addAll(self: *ForkContext, other: *const ForkContext) !void {
        try self.segments_list.appendSlice(self.allocator, other.segments_list.items);
    }

    fn clear(self: *ForkContext) void {
        self.segments_list.clearRetainingCapacity();
    }

    /// Create new segments from a range of the segments_list.
    fn makeNext(self: *ForkContext, start_idx: i32, end_idx: i32, builder: *CodePathBuilder) ![]SegmentId {
        return self.createSegments(start_idx, end_idx, builder, .next);
    }

    fn makeUnreachable(self: *ForkContext, start_idx: i32, end_idx: i32, builder: *CodePathBuilder) ![]SegmentId {
        return self.createSegments(start_idx, end_idx, builder, .unreachable_seg);
    }

    fn makeDisconnected(self: *ForkContext, start_idx: i32, end_idx: i32, builder: *CodePathBuilder) ![]SegmentId {
        return self.createSegments(start_idx, end_idx, builder, .disconnected);
    }

    const CreateMode = enum { next, unreachable_seg, disconnected };

    fn createSegments(self: *ForkContext, start_idx: i32, end_idx: i32, builder: *CodePathBuilder, mode: CreateMode) ![]SegmentId {
        const list = self.segments_list.items;
        const len: i32 = @intCast(list.len);

        // Guard: if the list is empty, create segments with no prev
        if (len == 0) {
            const result = try self.allocator.alloc(SegmentId, self.count);
            for (0..self.count) |i| {
                result[i] = switch (mode) {
                    .next => try builder.newNextSegment(&.{}),
                    .unreachable_seg => try builder.newUnreachableSegment(&.{}),
                    .disconnected => try builder.newDisconnectedSegment(&.{}),
                };
            }
            return result;
        }

        const norm_start: usize = @intCast(if (start_idx >= 0) start_idx else len + start_idx);
        const norm_end: usize = @intCast(if (end_idx >= 0) end_idx else len + end_idx);

        const result = try self.allocator.alloc(SegmentId, self.count);
        for (0..self.count) |i| {
            // Collect allPrevSegments for this fork lane
            var all_prev: std.ArrayListUnmanaged(SegmentId) = .empty;
            var j = norm_start;
            while (j <= norm_end) : (j += 1) {
                if (i < list[j].len) {
                    try all_prev.append(self.allocator, list[j][i]);
                }
            }
            const prev_slice = try all_prev.toOwnedSlice(self.allocator);

            result[i] = switch (mode) {
                .next => try builder.newNextSegment(prev_slice),
                .unreachable_seg => try builder.newUnreachableSegment(prev_slice),
                .disconnected => try builder.newDisconnectedSegment(prev_slice),
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

const ChoiceKind = enum { test_kind, logical_and, logical_or, nullish, loop };

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
    broken_fork: ForkContext,
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

const BreakContext = struct {
    upper: ?*BreakContext,
    breakable: bool,
    label: ?[]const u8,
    broken_fork: ForkContext,
};

// ── CodePathBuilder ──────────────────────────────────────────────

pub const CodePathBuilder = struct {
    allocator: Allocator,

    // Results
    segments: std.ArrayList(Segment),
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
    break_context: ?*BreakContext,

    // Segment ID counter
    seg_counter: u32,

    pub fn init(alloc: Allocator) CodePathBuilder {
        return .{
            .allocator = alloc,
            .segments = .empty,
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
            .break_context = null,
            .seg_counter = 0,
        };
    }

    // ── Segment creation ─────────────────────────────────────

    fn newRootSegment(self: *CodePathBuilder) !SegmentId {
        const id: SegmentId = @intCast(self.segments.items.len);
        try self.segments.append(self.allocator, .{
            .reachable = true,
            .used = false,
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
        return id;
    }

    /// Create a new segment that follows the given previous segments.
    /// Reachable if any prev is reachable.
    pub fn newNextSegment(self: *CodePathBuilder, all_prev: []const SegmentId) !SegmentId {
        const flattened = try self.flattenUnused(all_prev);
        var any_reachable = false;
        for (flattened) |p| {
            if (p != NONE_SEG and self.segments.items[p].reachable) {
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
    pub fn newDisconnectedSegment(self: *CodePathBuilder, all_prev: []const SegmentId) !SegmentId {
        var any_reachable = false;
        for (all_prev) |p| {
            if (p != NONE_SEG and self.segments.items[p].reachable) {
                any_reachable = true;
                break;
            }
        }
        // Disconnected: no allPrevSegments stored (empty array)
        return self.createSegment(&.{}, any_reachable, false);
    }

    fn createSegment(self: *CodePathBuilder, all_prev: []const SegmentId, is_reachable: bool, _: bool) !SegmentId {
        const id: SegmentId = @intCast(self.segments.items.len);

        // Record allPrevSegments
        const ap_start: u32 = @intCast(self.all_prev_targets.items.len);
        for (all_prev) |p| try self.all_prev_targets.append(self.allocator, p);
        const ap_end: u32 = @intCast(self.all_prev_targets.items.len);

        // Record prevSegments (reachable only)
        const p_start: u32 = @intCast(self.prev_targets.items.len);
        for (all_prev) |p| {
            if (p != NONE_SEG and self.segments.items[p].reachable) {
                try self.prev_targets.append(self.allocator, p);
            }
        }
        const p_end: u32 = @intCast(self.prev_targets.items.len);

        try self.segments.append(self.allocator, .{
            .reachable = is_reachable,
            .used = false,
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
        return id;
    }

    /// Mark a segment as used — registers it in prev segments' next lists.
    pub fn markUsed(self: *CodePathBuilder, seg_id: SegmentId) !void {
        if (seg_id == NONE_SEG) return;
        var seg = &self.segments.items[seg_id];
        if (seg.used) return;
        seg.used = true;

        // Update next/allNext of all prev segments
        const all_prev = self.all_prev_targets.items[seg.all_prev_start..seg.all_prev_end];
        for (all_prev) |prev_id| {
            if (prev_id == NONE_SEG) continue;
            var prev = &self.segments.items[prev_id];
            // allNextSegments: always add
            if (prev.all_next_end == 0 and prev.all_next_start == 0) {
                prev.all_next_start = @intCast(self.all_next_targets.items.len);
            }
            try self.all_next_targets.append(self.allocator, seg_id);
            prev.all_next_end = @intCast(self.all_next_targets.items.len);

            // nextSegments: only if this segment is reachable
            if (seg.reachable) {
                if (prev.next_end == 0 and prev.next_start == 0) {
                    prev.next_start = @intCast(self.next_targets.items.len);
                }
                try self.next_targets.append(self.allocator, seg_id);
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

        if (self.segments.items[prev_seg_id].reachable) {
            if (prev.next_end == 0 and prev.next_start == 0) {
                prev.next_start = @intCast(self.next_targets.items.len);
            }
            try self.next_targets.append(self.allocator, seg_id);
            prev.next_end = @intCast(self.next_targets.items.len);
        }
    }

    /// Flatten unused segments: replace unused segments with their prev segments.
    fn flattenUnused(self: *CodePathBuilder, segments: []const SegmentId) ![]SegmentId {
        var result: std.ArrayListUnmanaged(SegmentId) = .empty;
        var seen = std.AutoHashMap(SegmentId, void).init(self.allocator);
        defer seen.deinit();

        for (segments) |seg_id| {
            if (seg_id == NONE_SEG) continue;
            if (seen.contains(seg_id)) continue;

            if (!self.segments.items[seg_id].used) {
                // Replace with its allPrevSegments
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

        // Record final segments
        var cp = &self.codepaths.items[cp_id];
        cp.final_start = @intCast(self.cp_final_pool.items.len);
        for (head) |seg_id| {
            try self.cp_final_pool.append(self.allocator, seg_id);
        }
        cp.final_end = @intCast(self.cp_final_pool.items.len);

        // Reachable final segments are also returned segments (implicit return).
        // Only add reachable ones — unreachable finals mean all paths explicitly
        // return/throw, so they shouldn't appear in returnedSegments.
        if (cp.origin != .program) {
            for (head) |seg_id| {
                if (seg_id != NONE_SEG and self.segments.items[seg_id].reachable) {
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
        const seg = self.segments.items[seg_id];
        try self.events.append(self.allocator, .{
            .type = if (seg.reachable) .seg_start else .unreachable_seg_start,
            .node = node,
            .data1 = seg_id,
            .data2 = 0,
            .phase = phase,
        });
    }

    fn emitSegEnd(self: *CodePathBuilder, seg_id: SegmentId, node: NodeIndex, phase: EventPhase) !void {
        if (seg_id == NONE_SEG) return;
        const seg = self.segments.items[seg_id];
        try self.events.append(self.allocator, .{
            .type = if (seg.reachable) .seg_end else .unreachable_seg_end,
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

        // Save the current (last branch ending) segments
        const last_branch_end = try self.allocator.dupe(SegmentId, self.fork_context.head());

        // End current segments
        try self.leaveFromCurrentSegment(node, .exit);

        // Merge branch endings:
        // true_fork.head() = if-consequent ending (saved by makeIfAlternate)
        // last_branch_end = else-alternate ending (or last case in switch)
        var combined = newEmptyForkContext(self.allocator, self.fork_context, false);
        if (!ctx.true_fork.empty()) {
            const true_end = ctx.true_fork.head();
            const true_copy = try self.allocator.dupe(SegmentId, true_end);
            try combined.add(true_copy, self);
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
            // Fork current head to both true and false paths
            const head = self.fork_context.head();
            const head_copy = try self.allocator.dupe(SegmentId, head);
            try ctx.true_fork.add(head_copy, self);
            const head_copy2 = try self.allocator.dupe(SegmentId, head);
            try ctx.false_fork.add(head_copy2, self);
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
        // popChoiceContext merges true_fork + last_branch_end (RHS ending).
        // For all logical operators, the short-circuit path is merged at the end.
        const head = try self.allocator.dupe(SegmentId, self.fork_context.head());
        try ctx.true_fork.add(head, self);
        // End LHS segment, create new segment for RHS
        try self.leaveFromCurrentSegment(node, .enter);
        const new_segs = try self.fork_context.makeNext(-1, -1, self);
        try self.fork_context.replaceHead(new_segs, self);
        try self.forwardCurrentToHead(node, .enter);
    }

    pub fn makeIfAlternate(self: *CodePathBuilder, node: NodeIndex) !void {
        const ctx = self.choice_context orelse return;
        // Save end of true branch
        const true_end = try self.allocator.dupe(SegmentId, self.fork_context.head());
        try ctx.true_fork.add(true_end, self);
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
        // Push a break context for the switch
        try self.pushBreakContext(true, label);

        const ctx = try self.allocator.create(SwitchContext);
        ctx.* = .{
            .upper = self.switch_context,
            .has_case = has_case,
            .default_segments = null,
            .default_body_segments = null,
            .found_empty_default = false,
            .last_is_default = false,
            .fork_count = 0,
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
        // Switch break = reachable exit from the switch statement.
        if (self.break_context) |bc| {
            if (!bc.broken_fork.empty()) {
                if (self.choice_context) |cc| {
                    try cc.true_fork.addAll(&bc.broken_fork);
                }
            }
        }
        try self.popChoiceContext(node);

        // If the switch has a default case, all branches are covered.
        // Remove the initial discriminant entry from the fork context so
        // the merge reflects only case-body exits (not the reachable discriminant).
        // Without default, the discriminant path flows to after the switch.
        if (ctx.default_segments != null) {
            const fc = self.fork_context;
            if (fc.segments_list.items.len > 1) {
                const last = fc.segments_list.items[fc.segments_list.items.len - 1];
                fc.segments_list.clearRetainingCapacity();
                try fc.segments_list.append(fc.allocator, last);
            }
        }

        try self.popForkContext(node);
        _ = self.popBreakContext(node);
    }

    pub fn makeSwitchCaseBody(self: *CodePathBuilder, is_default: bool, node: NodeIndex) !void {
        const ctx = self.switch_context orelse return;
        if (is_default) {
            ctx.last_is_default = true;
            ctx.default_segments = try self.allocator.dupe(SegmentId, self.fork_context.head());
        } else {
            ctx.last_is_default = false;
        }
        ctx.fork_count += 1;

        // End current segments and start new ones for the case body
        try self.leaveFromCurrentSegment(node, .enter);
        const new_segs = try self.fork_context.makeNext(-1, -1, self);
        try self.fork_context.add(new_segs, self);
        try self.forwardCurrentToHead(node, .enter);
    }

    // ── Try/catch/finally ────────────────────────────────────

    pub fn pushTryContext(self: *CodePathBuilder, has_finalizer: bool, try_body_node: NodeIndex) !void {
        // Save pre-try head BEFORE creating try-body segment.
        const pre_try = self.allocator.dupe(SegmentId, self.fork_context.head()) catch null;

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
            // Current head has catch-end segments
            const catch_end = try self.allocator.dupe(SegmentId, self.fork_context.head());
            try combined.add(catch_end, self);
            if (!combined.empty()) {
                const merged = try combined.makeNext(0, -1, self);
                try self.fork_context.replaceHead(merged, self);
            }
            try self.forwardCurrentToHead(node, .exit);
        }
    }

    pub fn makeCatchBlock(self: *CodePathBuilder, node: NodeIndex) !void {
        const ctx = self.try_context orelse return;
        ctx.last_of_try_reachable = self.fork_context.reachable(self);
        // Save try-body exit segments for merging in popTryContext
        const try_end_head = try self.allocator.dupe(SegmentId, self.fork_context.head());
        try ctx.try_end_fork.add(try_end_head, self);
        ctx.position = .catch_body;

        // End try body segments, start catch segments.
        // Catch predecessor is pre-try state ONLY — exception can throw before
        // any try-body code, so catch must not inherit try-body-end state.
        try self.leaveFromCurrentSegment(node, .enter);
        if (ctx.pre_try_segments) |pre_try| {
            const pre_copy = try self.allocator.dupe(SegmentId, pre_try);
            try self.fork_context.replaceHead(pre_copy, self);
        }
        const catch_segs = try self.fork_context.makeNext(-1, -1, self);
        try self.fork_context.replaceHead(catch_segs, self);
        try self.forwardCurrentToHead(node, .enter);
    }

    /// Called for the first potentially-throwing node inside a try body
    /// (call expressions, member expressions, identifiers, etc.).
    /// Saves the current head to thrownForkContext so that finally can see
    /// the exception path (state before any try-body code completed).
    pub fn makeFirstThrowablePathInTryBlock(self: *CodePathBuilder) !void {
        if (!self.fork_context.reachable(self)) return;
        const ctx = self.try_context orelse return;
        if (ctx.position != .try_body or ctx.first_throwable_called) return;
        if (!ctx.has_finalizer) return; // only needed for finally
        ctx.first_throwable_called = true;
        // Save PRE-TRY segments to thrownForkContext — this represents the
        // exception path where code throws before any try-body code completed.
        if (ctx.pre_try_segments) |pre_try| {
            const pre_copy = try self.allocator.dupe(SegmentId, pre_try);
            try ctx.thrown_fork.add(pre_copy, self);
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
        if (!ctx.thrown_fork.empty()) {
            // Create the normal-path finally entry
            const normal_segs = try self.fork_context.makeNext(-1, -1, self);

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
            try new_fc.segments_list.append(self.allocator, doubled);
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
        try self.pushBreakContext(true, label);
        const break_ctx = self.break_context orelse unreachable;

        const ctx = try self.allocator.create(LoopContext);
        ctx.* = .{
            .upper = self.loop_context,
            .loop_type = loop_type,
            .label = label,
            .broken_fork = break_ctx.broken_fork,
            .continue_fork = newEmptyForkContext(self.allocator, self.fork_context, false),
        };
        self.loop_context = ctx;

        try self.pushChoiceContext(.loop, false);

        // For while/for loops, save current head as the "loop skipped" path.
        // If the condition is false initially, control skips the body entirely.
        // do-while always executes the body at least once, so no skip path.
        if (loop_type != .do_while_stmt) {
            const skip_path = try self.allocator.dupe(SegmentId, self.fork_context.head());
            if (self.choice_context) |cc| {
                try cc.true_fork.add(skip_path, self);
            }
        }

        // Emit segment transition: end current, start loop body segment
        // Use target_node (test/body/update child) so isLoopingTarget matches
        try self.leaveFromCurrentSegment(target_node, .enter);
        const new_segs = try self.fork_context.makeNext(-1, -1, self);
        try self.fork_context.replaceHead(new_segs, self);
        try self.forwardCurrentToHead(target_node, .enter);
        // Always save entry segments for LOOP event (used as toSegment)
        ctx.entry_segments = self.allocator.dupe(SegmentId, self.fork_context.head()) catch null;
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
        // Save break context's broken_fork BEFORE popping
        const break_ctx = self.break_context;
        try self.popChoiceContext(node);
        _ = self.popBreakContext(node);
        // After both pops: merge break exits as reachable post-loop paths.
        // Break exits the loop, so they flow AFTER the loop (not through back-edge).
        if (break_ctx) |bc| {
            if (!bc.broken_fork.empty()) {
                // Create new reachable segments from the saved break segments
                const broken_segs = try bc.broken_fork.makeNext(0, -1, self);
                // Replace the current head (which may be unreachable from the merge)
                // with a merge of current head + break exits
                const current_head = self.fork_context.head();
                if (current_head.len > 0) {
                    // Check if current head is unreachable
                    var any_reachable = false;
                    for (current_head) |s| {
                        if (s != NONE_SEG and self.segments.items[s].reachable) any_reachable = true;
                    }
                    if (!any_reachable) {
                        // End unreachable segments, replace with break exits, emit starts
                        for (current_head) |s| {
                            if (s != NONE_SEG) try self.emitSegEnd(s, node, .post);
                        }
                        try self.fork_context.replaceHead(broken_segs, self);
                        for (broken_segs) |s| {
                            if (s != NONE_SEG) try self.emitSegStart(s, node, .post);
                        }
                    }
                }
            }
        }
    }

    pub fn makeLoopBackEdge(self: *CodePathBuilder, node: NodeIndex) !void {
        const ctx = self.loop_context orelse return;
        const head = self.fork_context.head();
        const dest = ctx.continue_dest_segments orelse ctx.entry_segments;
        if (dest) |d| {
            for (head) |from_seg| {
                // Only create back-edges from reachable segments.
                // If the loop body always exits (return/throw/break), no back-edge.
                if (from_seg != NONE_SEG and self.segments.items[from_seg].reachable) {
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
                if (from_seg != NONE_SEG and self.segments.items[from_seg].reachable) {
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
        ctx.continue_dest_segments = self.allocator.dupe(SegmentId, self.fork_context.head()) catch null;
    }

    pub fn setLoopEntrySegments(self: *CodePathBuilder) void {
        const ctx = self.loop_context orelse return;
        ctx.entry_segments = self.allocator.dupe(SegmentId, self.fork_context.head()) catch null;
    }

    // ── Break/Continue ───────────────────────────────────────

    pub fn pushBreakContext(self: *CodePathBuilder, breakable: bool, label: ?[]const u8) !void {
        const ctx = try self.allocator.create(BreakContext);
        ctx.* = .{
            .upper = self.break_context,
            .breakable = breakable,
            .label = label,
            .broken_fork = newEmptyForkContext(self.allocator, self.fork_context, false),
        };
        self.break_context = ctx;
    }

    /// Returns true if any `break` targeted this context.
    /// `node` is the statement node where the break context ends (for event emission).
    pub fn popBreakContext(self: *CodePathBuilder, node: NodeIndex) bool {
        const ctx = self.break_context orelse return false;
        const had_break = !ctx.broken_fork.empty();
        self.break_context = ctx.upper;
        // For non-loop break contexts (labels, switches handled by popSwitchContext),
        // merge broken segments as reachable continuation after the statement.
        if (!ctx.breakable and had_break) {
            const broken_segs = ctx.broken_fork.makeNext(0, -1, self) catch return had_break;
            // End current (unreachable) segments, then start the new merge segments
            const head = self.fork_context.head();
            for (head) |s| {
                if (s != NONE_SEG) self.emitSegEnd(s, node, .post) catch {};
            }
            var any_reachable = false;
            for (head) |s| {
                if (s != NONE_SEG and self.segments.items[s].reachable) any_reachable = true;
            }
            if (!any_reachable) {
                self.fork_context.replaceHead(broken_segs, self) catch {};
            } else {
                self.fork_context.add(broken_segs, self) catch {};
            }
            // Emit SEG_START for the new merge segments
            for (broken_segs) |s| {
                if (s != NONE_SEG) self.emitSegStart(s, node, .post) catch {};
            }
        }
        return had_break;
    }

    pub fn makeBreak(self: *CodePathBuilder, label: ?[]const u8, node: NodeIndex) !void {
        // Find the target break context
        var target: ?*BreakContext = self.break_context;
        if (label) |lbl| {
            while (target) |ctx| {
                if (ctx.label) |ctx_lbl| {
                    if (std.mem.eql(u8, ctx_lbl, lbl)) break;
                }
                target = ctx.upper;
            }
        } else {
            while (target) |ctx| {
                if (ctx.breakable) break;
                target = ctx.upper;
            }
        }

        if (target) |ctx| {
            const head = try self.allocator.dupe(SegmentId, self.fork_context.head());
            try ctx.broken_fork.add(head, self);
        }

        // Make subsequent code unreachable (post phase so exit handlers see current segment)
        try self.leaveFromCurrentSegment(node, .post);
        const unreachable_segs = try self.fork_context.makeUnreachable(-1, -1, self);
        try self.fork_context.replaceHead(unreachable_segs, self);
        try self.forwardCurrentToHead(node, .post);
    }

    pub fn makeContinue(self: *CodePathBuilder, label: ?[]const u8, node: NodeIndex) !void {
        // Find the target loop context for continue
        var target_loop: ?*LoopContext = self.loop_context;
        if (label) |lbl| {
            while (target_loop) |ctx| {
                if (ctx.label) |ctx_lbl| {
                    if (std.mem.eql(u8, ctx_lbl, lbl)) break;
                }
                target_loop = ctx.upper;
            }
        }

        if (target_loop) |ctx| {
            const head = self.fork_context.head();
            const head_copy = try self.allocator.dupe(SegmentId, head);
            try ctx.continue_fork.add(head_copy, self);

            // Create graph back-edges and emit LOOP events for the continue.
            // Graph edge targets the continue destination (test/update).
            const dest = ctx.continue_dest_segments orelse ctx.entry_segments;
            if (dest) |d| {
                for (head) |from_seg| {
                    if (from_seg != NONE_SEG and self.segments.items[from_seg].reachable) {
                        for (d) |to_seg| {
                            if (to_seg != NONE_SEG) {
                                try self.markLooped(to_seg, from_seg);
                            }
                        }
                    }
                }
            }
            // LOOP event uses entry_segments (isLoopingTarget mapping).
            const entry = ctx.entry_segments orelse ctx.continue_dest_segments;
            if (entry) |e| {
                for (head) |from_seg| {
                    if (from_seg != NONE_SEG and self.segments.items[from_seg].reachable) {
                        for (e) |to_seg| {
                            if (to_seg != NONE_SEG) {
                                try self.emitSegLoop(from_seg, to_seg, node);
                            }
                        }
                    }
                }
            }
        }

        // Make subsequent code unreachable (post phase so exit handlers see current segment)
        try self.leaveFromCurrentSegment(node, .post);
        const unreachable_segs = try self.fork_context.makeUnreachable(-1, -1, self);
        try self.fork_context.replaceHead(unreachable_segs, self);
        try self.forwardCurrentToHead(node, .post);
    }

    // ── Return/Throw ─────────────────────────────────────────

    pub fn makeReturn(self: *CodePathBuilder, node: NodeIndex) !void {
        const cp_id = self.current_codepath;

        // Record in returned pool
        const head = self.fork_context.head();
        var cp = &self.codepaths.items[cp_id];
        if (cp.returned_end == 0 and cp.returned_start == 0) {
            cp.returned_start = @intCast(self.cp_returned_pool.items.len);
        }
        for (head) |seg_id| {
            try self.cp_returned_pool.append(self.allocator, seg_id);
        }
        cp.returned_end = @intCast(self.cp_returned_pool.items.len);

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

        // Record in thrown pool
        const head = self.fork_context.head();
        var cp = &self.codepaths.items[cp_id];
        if (cp.thrown_end == 0 and cp.thrown_start == 0) {
            cp.thrown_start = @intCast(self.cp_thrown_pool.items.len);
        }
        for (head) |seg_id| {
            try self.cp_thrown_pool.append(self.allocator, seg_id);
        }
        cp.thrown_end = @intCast(self.cp_thrown_pool.items.len);

        // If inside a try block, also add to try context's thrown fork
        if (self.try_context) |ctx| {
            if (ctx.position == .try_body) {
                const head_copy = try self.allocator.dupe(SegmentId, head);
                try ctx.thrown_fork.add(head_copy, self);
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
        // Carry over parent's current head so child operations can reference them as prev
        const parent_head = self.fork_context.head();
        if (parent_head.len > 0) {
            const head_copy = try self.allocator.dupe(SegmentId, parent_head);
            try new_fc.add(head_copy, self);
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
    };

    pub fn finish(self: *CodePathBuilder) Result {
        return .{
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
        };
    }
};
