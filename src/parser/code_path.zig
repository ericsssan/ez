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
        if (seg.looped_prev_end == 0 and seg.looped_prev_start == 0) {
            seg.looped_prev_start = @intCast(self.looped_targets.items.len);
        }
        try self.looped_targets.append(self.allocator, prev_seg_id);
        seg.looped_prev_end = @intCast(self.looped_targets.items.len);

        // Also add to forward edges: prev→seg
        var prev = &self.segments.items[prev_seg_id];
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
    pub fn enterCodePath(self: *CodePathBuilder, node: NodeIndex, origin: Origin) !void {
        const cp_id: CodePathId = @intCast(self.codepaths.items.len);
        const upper = self.current_codepath;
        self.current_codepath = cp_id;

        // Create initial segment
        const initial_seg = try self.newRootSegment();

        // Create fork context (save current as upper for restore on exitCodePath)
        const fc = try self.allocator.create(ForkContext);
        const upper_fc: ?*ForkContext = if (self.current_codepath != NONE_CP) self.fork_context else null;
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

        // Mark initial segment used and emit segment start
        try self.markUsed(initial_seg);
        try self.emitSegStart(initial_seg, node, .enter);
    }

    /// Exit the current code path.
    pub fn exitCodePath(self: *CodePathBuilder, node: NodeIndex) !void {
        const cp_id = self.current_codepath;

        // End current segments (post phase — fires AFTER exit handlers, matching ESLint's postprocess)
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

        // End current segments
        try self.leaveFromCurrentSegment(node, .exit);

        // Merge true and false paths
        var combined = newEmptyForkContext(self.allocator, self.fork_context, false);
        try combined.addAll(&ctx.true_fork);
        try combined.addAll(&ctx.false_fork);

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
        // Switch to true fork path
        const new_segs = try ctx.true_fork.makeNext(0, -1, self);
        try self.fork_context.replaceHead(new_segs, self);
        // End old segments, start new
        try self.leaveFromCurrentSegment(node, .enter);
        try self.forwardCurrentToHead(node, .enter);
    }

    pub fn makeIfAlternate(self: *CodePathBuilder, node: NodeIndex) !void {
        const ctx = self.choice_context orelse return;
        // Save end of true branch
        const true_end = try self.allocator.dupe(SegmentId, self.fork_context.head());
        try ctx.true_fork.add(true_end, self);
        // Switch to false fork path
        const new_segs = try ctx.false_fork.makeNext(0, -1, self);
        try self.fork_context.replaceHead(new_segs, self);
        // End old segments, start new
        try self.leaveFromCurrentSegment(node, .enter);
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
        try self.popForkContext();
        self.popBreakContext();
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

    pub fn pushTryContext(self: *CodePathBuilder, has_finalizer: bool) !void {
        const ctx = try self.allocator.create(TryContext);
        ctx.* = .{
            .upper = self.try_context,
            .has_finalizer = has_finalizer,
            .position = .try_body,
            .returned_fork = newEmptyForkContext(self.allocator, self.fork_context, false),
            .thrown_fork = newEmptyForkContext(self.allocator, self.fork_context, false),
            .try_end_fork = newEmptyForkContext(self.allocator, self.fork_context, false),
            .pre_try_segments = self.allocator.dupe(SegmentId, self.fork_context.head()) catch null,
            .last_of_try_reachable = false,
            .last_of_catch_reachable = false,
        };
        self.try_context = ctx;

        // If there's a finalizer, fork the leaving path
        if (has_finalizer) {
            try self.pushForkContext();
        }
    }

    pub fn popTryContext(self: *CodePathBuilder, node: NodeIndex) !void {
        const ctx = self.try_context orelse return;
        self.try_context = ctx.upper;

        if (ctx.has_finalizer) {
            try self.popForkContext();
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

        // End try body segments, start catch segments
        try self.leaveFromCurrentSegment(node, .enter);
        // Catch is reachable from pre-try state (exceptions can be thrown at any point)
        // Use pre-try segments as predecessors so catch starts reachable
        if (ctx.pre_try_segments) |pre_try| {
            const catch_seg_slice = try self.allocator.dupe(SegmentId, pre_try);
            try self.fork_context.add(catch_seg_slice, self);
        }
        const catch_segs = try self.fork_context.makeNext(-1, -1, self);
        try self.fork_context.replaceHead(catch_segs, self);
        try self.forwardCurrentToHead(node, .enter);
    }

    pub fn makeFinallyBlock(self: *CodePathBuilder, node: NodeIndex) !void {
        const ctx = self.try_context orelse return;
        ctx.last_of_catch_reachable = self.fork_context.reachable(self);
        ctx.position = .finally_body;

        try self.leaveFromCurrentSegment(node, .enter);
        const new_segs = try self.fork_context.makeNext(-1, -1, self);
        try self.fork_context.replaceHead(new_segs, self);
        try self.forwardCurrentToHead(node, .enter);
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
        // Save break context's broken_fork BEFORE popping
        const break_ctx = self.break_context;
        try self.popChoiceContext(node);
        self.popBreakContext();
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
                        // Current head is all unreachable — replace with break exits
                        try self.fork_context.replaceHead(broken_segs, self);
                        // Re-emit segment events for the new reachable head
                        try self.forwardCurrentToHead(node, .exit);
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
                for (d) |to_seg| {
                    if (from_seg != NONE_SEG and to_seg != NONE_SEG) {
                        try self.markLooped(to_seg, from_seg);
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
                for (e) |to_seg| {
                    if (from_seg != NONE_SEG and to_seg != NONE_SEG) {
                        try self.emitSegLoop(from_seg, to_seg, node);
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

    pub fn popBreakContext(self: *CodePathBuilder) void {
        const ctx = self.break_context orelse return;
        self.break_context = ctx.upper;
        // For non-loop break contexts (labels, switches handled by popSwitchContext),
        // merge broken segments as reachable continuation after the statement.
        if (!ctx.breakable and !ctx.broken_fork.empty()) {
            const broken_segs = ctx.broken_fork.makeNext(0, -1, self) catch return;
            // Replace head if it's all unreachable, otherwise add alongside
            const head = self.fork_context.head();
            var any_reachable = false;
            for (head) |s| {
                if (s != NONE_SEG and self.segments.items[s].reachable) any_reachable = true;
            }
            if (!any_reachable) {
                self.fork_context.replaceHead(broken_segs, self) catch {};
            } else {
                self.fork_context.add(broken_segs, self) catch {};
            }
        }
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

        // Make subsequent code unreachable
        try self.leaveFromCurrentSegment(node, .exit);
        const unreachable_segs = try self.fork_context.makeUnreachable(-1, -1, self);
        try self.fork_context.replaceHead(unreachable_segs, self);
        try self.forwardCurrentToHead(node, .exit);
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
            const head = try self.allocator.dupe(SegmentId, self.fork_context.head());
            try ctx.continue_fork.add(head, self);
        }

        // Make subsequent code unreachable
        try self.leaveFromCurrentSegment(node, .exit);
        const unreachable_segs = try self.fork_context.makeUnreachable(-1, -1, self);
        try self.fork_context.replaceHead(unreachable_segs, self);
        try self.forwardCurrentToHead(node, .exit);
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

        // Make subsequent code unreachable
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

        // Make subsequent code unreachable
        try self.leaveFromCurrentSegment(node, .exit);
        const unreachable_segs = try self.fork_context.makeUnreachable(-1, -1, self);
        try self.fork_context.replaceHead(unreachable_segs, self);
        try self.forwardCurrentToHead(node, .exit);
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

    pub fn popForkContext(self: *CodePathBuilder) !void {
        const fc = self.fork_context;
        if (fc.upper) |upper| {
            if (!fc.empty()) {
                const merged = try fc.makeNext(0, -1, self);
                try upper.replaceHead(merged, self);
            }
            self.fork_context = upper;
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
