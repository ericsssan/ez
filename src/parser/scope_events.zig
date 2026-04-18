//! Semantic event stream produced by the parser.
//!
//! Rather than walking the full AST in semantic analysis (36k+ nodes on acorn.js,
//! ~30% of which have no scope/binding/reference significance), the parser emits
//! a linear stream of events as it parses.  Semantic analysis then performs a
//! single linear pass over this stream — no per-node tag dispatch, no recursion,
//! no visiting of literal nodes.
//!
//! Event packing: 8 bytes each.  Fits 8 per cache line.
//!   kind:   u8   (4 variants: open/close/declare/reference)
//!   aux:    u8   (BindingKind for declare, ReferenceKind for reference,
//!                 ScopeKind for open, unused for close)
//!   _pad:   u16
//!   node:   u32  (NodeIndex — for declarations: name token's owning node;
//!                 for references: identifier node; for scopes: the node
//!                 that owns the scope, e.g. block_stmt or fn_decl)
//!
//! The consumer resolves names lazily via the node's main_token.
const std = @import("std");

pub const EventKind = enum(u8) {
    scope_open,   // aux = ScopeKind
    scope_close,  // aux unused
    declare,      // aux = BindingKind
    reference,    // aux = ReferenceKind
    /// A statement that terminates the current control-flow path:
    /// return, throw, break, continue.  Used by the event-driven CFG
    /// approximation to compute `node_reachable` for rules like
    /// `no-unreachable`.  aux byte: 0=return, 1=throw, 2=break, 3=continue.
    terminator,
    /// `if` statement entry — the next two `branch_close` events belong
    /// to this if.  aux: 0 = has-alternate, 1 = no-alternate.
    /// node: the if_stmt node.
    branch_open,
    /// End of the consequent branch of a `branch_open`.  After this event
    /// the resolver reverts to the pre-branch alive state to process the
    /// alternate branch (if any).
    branch_else,
    /// End of a branch_open (closes the if entirely).  The alive state
    /// after this event is the OR of the two branches' alive states.
    branch_close,
};

pub const Event = packed struct(u64) {
    kind: EventKind,
    aux: u8,
    _pad: u16 = 0,
    node: u32,
};

/// Growable, unmanaged event buffer.  Caller provides the allocator.
pub const EventStream = struct {
    events: std.ArrayList(Event) = .empty,

    pub fn deinit(self: *EventStream, alloc: std.mem.Allocator) void {
        self.events.deinit(alloc);
    }

    pub inline fn push(self: *EventStream, alloc: std.mem.Allocator, ev: Event) !void {
        try self.events.append(alloc, ev);
    }

    pub inline fn pushAssumeCapacity(self: *EventStream, ev: Event) void {
        self.events.appendAssumeCapacity(ev);
    }

    pub fn ensureCapacity(self: *EventStream, alloc: std.mem.Allocator, n: usize) !void {
        try self.events.ensureTotalCapacity(alloc, n);
    }

    pub inline fn items(self: *const EventStream) []const Event {
        return self.events.items;
    }

    pub inline fn len(self: *const EventStream) usize {
        return self.events.items.len;
    }
};
