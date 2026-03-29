const std = @import("std");
const ast = @import("ast.zig");

// ── Imported ID types ──────────────────────────────────────
pub const SymbolId = @import("symbol.zig").SymbolId;
pub const ScopeId = @import("scope.zig").ScopeId;

// ── Reference types ────────────────────────────────────────

/// Index into the reference table arrays.
pub const ReferenceId = enum(u32) {
    none = std.math.maxInt(u32),
    _,

    pub fn unwrap(self: ReferenceId) ?u32 {
        return if (self == .none) null else @intFromEnum(self);
    }

    pub fn toInt(self: ReferenceId) u32 {
        return @intFromEnum(self);
    }

    pub fn fromInt(i: u32) ReferenceId {
        return @enumFromInt(i);
    }
};

/// How an identifier is used at a reference site.
///
/// Reference tracking rules:
///   - `x = value`            → write
///   - `x += value`, `x++`    → read_write
///   - `typeof x`             → type_of  (doesn't throw for undeclared)
///   - all other uses          → read
pub const ReferenceKind = enum {
    /// Value is read: `x + 1`, `f(x)`, `return x`
    read,
    /// Value is written: `x = 1`
    write,
    /// Value is both read and written: `x += 1`, `x++`, `x--`
    read_write,
    /// `typeof x` — does not throw ReferenceError for undeclared identifiers
    type_of,

    /// Returns true when this reference reads from the symbol.
    pub fn isRead(self: ReferenceKind) bool {
        return switch (self) {
            .read, .read_write, .type_of => true,
            .write => false,
        };
    }

    /// Returns true when this reference writes to the symbol.
    pub fn isWrite(self: ReferenceKind) bool {
        return switch (self) {
            .write, .read_write => true,
            .read, .type_of => false,
        };
    }
};

// ── Reference table (SoA) ──────────────────────────────────

/// Tracks every identifier reference in a source file.
///
/// Stored in struct-of-arrays layout for cache-friendly iteration over
/// individual fields (e.g., scanning all symbol_ids to count unresolved
/// references without touching node or scope data).
///
/// Uses Zig 0.16 unmanaged ArrayLists — the allocator is stored once in the
/// struct and passed to each mutating call.
pub const ReferenceTable = struct {
    /// Resolved symbol for each reference, or `.none` if unresolved.
    symbol_ids: std.ArrayList(SymbolId),
    /// How the identifier is used at this reference site.
    kinds: std.ArrayList(ReferenceKind),
    /// AST node where the reference occurs.
    node_ids: std.ArrayList(ast.NodeIndex),
    /// Scope in which the reference occurs.
    scope_ids: std.ArrayList(ScopeId),

    /// Allocator used for all internal arrays.
    gpa: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) ReferenceTable {
        return .{
            .symbol_ids = .empty,
            .kinds = .empty,
            .node_ids = .empty,
            .scope_ids = .empty,
            .gpa = allocator,
        };
    }

    pub fn deinit(self: *ReferenceTable) void {
        self.symbol_ids.deinit(self.gpa);
        self.kinds.deinit(self.gpa);
        self.node_ids.deinit(self.gpa);
        self.scope_ids.deinit(self.gpa);
    }

    /// Add a new reference. The reference starts unresolved (symbol_id = .none).
    /// Resolution happens later via `resolve` once scope-chain lookup succeeds.
    /// Returns the new reference's id.
    pub fn addReference(
        self: *ReferenceTable,
        kind: ReferenceKind,
        node_id: ast.NodeIndex,
        scope_id: ScopeId,
    ) !ReferenceId {
        const index: u32 = @intCast(self.symbol_ids.items.len);

        // Pre-allocate all parallel arrays together so that if any
        // allocation fails we haven't partially grown the SoA.
        try self.symbol_ids.ensureUnusedCapacity(self.gpa, 1);
        try self.kinds.ensureUnusedCapacity(self.gpa, 1);
        try self.node_ids.ensureUnusedCapacity(self.gpa, 1);
        try self.scope_ids.ensureUnusedCapacity(self.gpa, 1);

        // Append without capacity checks — all arrays were pre-allocated above.
        self.symbol_ids.appendAssumeCapacity(.none);
        self.kinds.appendAssumeCapacity(kind);
        self.node_ids.appendAssumeCapacity(node_id);
        self.scope_ids.appendAssumeCapacity(scope_id);

        return ReferenceId.fromInt(index);
    }

    /// Resolve a previously-unresolved reference to a symbol.
    pub fn resolve(self: *ReferenceTable, ref_id: ReferenceId, symbol_id: SymbolId) void {
        self.symbol_ids.items[ref_id.toInt()] = symbol_id;
    }

    /// Get the symbol a reference is resolved to (`.none` if unresolved).
    pub fn getSymbol(self: *const ReferenceTable, ref_id: ReferenceId) SymbolId {
        return self.symbol_ids.items[ref_id.toInt()];
    }

    /// Check if a reference has been resolved to a symbol.
    pub fn isResolved(self: *const ReferenceTable, ref_id: ReferenceId) bool {
        return self.symbol_ids.items[ref_id.toInt()] != .none;
    }

    /// Get the kind of reference (read, write, read_write, type_of).
    pub fn getKind(self: *const ReferenceTable, ref_id: ReferenceId) ReferenceKind {
        return self.kinds.items[ref_id.toInt()];
    }

    /// Get the AST node where this reference occurs.
    pub fn getNode(self: *const ReferenceTable, ref_id: ReferenceId) ast.NodeIndex {
        return self.node_ids.items[ref_id.toInt()];
    }

    /// Get the scope in which this reference occurs.
    pub fn getScope(self: *const ReferenceTable, ref_id: ReferenceId) ScopeId {
        return self.scope_ids.items[ref_id.toInt()];
    }

    /// Total number of tracked references.
    pub fn count(self: *const ReferenceTable) u32 {
        return @intCast(self.symbol_ids.items.len);
    }

    /// Count unresolved references (potential globals or errors).
    pub fn unresolvedCount(self: *const ReferenceTable) u32 {
        var n: u32 = 0;
        for (self.symbol_ids.items) |sid| {
            if (sid == .none) n += 1;
        }
        return n;
    }
};

// ── Tests ──────────────────────────────────────────────────

test "add and resolve references" {
    var table = ReferenceTable.init(std.testing.allocator);
    defer table.deinit();

    const ref0 = try table.addReference(.read, ast.NodeIndex.fromInt(10), ScopeId.fromInt(0));
    const ref1 = try table.addReference(.write, ast.NodeIndex.fromInt(20), ScopeId.fromInt(1));
    const ref2 = try table.addReference(.read_write, ast.NodeIndex.fromInt(30), ScopeId.fromInt(1));
    const ref3 = try table.addReference(.type_of, ast.NodeIndex.fromInt(40), ScopeId.fromInt(0));

    try std.testing.expectEqual(@as(u32, 4), table.count());
    try std.testing.expectEqual(@as(u32, 4), table.unresolvedCount());

    // All start unresolved.
    try std.testing.expect(!table.isResolved(ref0));
    try std.testing.expect(!table.isResolved(ref1));

    // Resolve ref0 and ref2.
    const sym_x = SymbolId.fromInt(0);
    const sym_y = SymbolId.fromInt(1);
    table.resolve(ref0, sym_x);
    table.resolve(ref2, sym_y);

    try std.testing.expect(table.isResolved(ref0));
    try std.testing.expect(!table.isResolved(ref1));
    try std.testing.expect(table.isResolved(ref2));
    try std.testing.expect(!table.isResolved(ref3));

    try std.testing.expectEqual(sym_x, table.getSymbol(ref0));
    try std.testing.expectEqual(sym_y, table.getSymbol(ref2));
    try std.testing.expectEqual(SymbolId.none, table.getSymbol(ref1));

    try std.testing.expectEqual(@as(u32, 2), table.unresolvedCount());
}

test "accessor round-trip" {
    var table = ReferenceTable.init(std.testing.allocator);
    defer table.deinit();

    const node = ast.NodeIndex.fromInt(42);
    const scope = ScopeId.fromInt(7);
    const ref_id = try table.addReference(.write, node, scope);

    try std.testing.expectEqual(ReferenceKind.write, table.getKind(ref_id));
    try std.testing.expectEqual(node, table.getNode(ref_id));
    try std.testing.expectEqual(scope, table.getScope(ref_id));
}

test "ReferenceKind helpers" {
    try std.testing.expect(ReferenceKind.read.isRead());
    try std.testing.expect(!ReferenceKind.read.isWrite());

    try std.testing.expect(!ReferenceKind.write.isRead());
    try std.testing.expect(ReferenceKind.write.isWrite());

    try std.testing.expect(ReferenceKind.read_write.isRead());
    try std.testing.expect(ReferenceKind.read_write.isWrite());

    try std.testing.expect(ReferenceKind.type_of.isRead());
    try std.testing.expect(!ReferenceKind.type_of.isWrite());
}
