const std = @import("std");
const Value = @import("value.zig").Value;

/// Variable environment for the JS interpreter.
/// Uses fixed slots for the common case (ESLint handlers have 2-3 vars)
/// and falls back to a hash map only when more variables are needed.
/// Zero heap allocation for typical rule handler execution.
pub const Environment = struct {
    /// Fixed slots for fast access (no allocation).
    /// Covers the common case: "node", "context", + a few locals.
    fixed_names: [MAX_FIXED][]const u8,
    fixed_values: [MAX_FIXED]Value,
    fixed_count: u8,

    /// Overflow map for handlers with many locals (rare).
    overflow: ?std.StringArrayHashMap(Value),

    /// Parent scope (for lexical scoping / closure chain).
    parent: ?*Environment,
    /// Allocator (only used if overflow is needed).
    allocator: std.mem.Allocator,

    const MAX_FIXED: usize = 8;

    pub fn init(allocator: std.mem.Allocator, parent: ?*Environment) Environment {
        return .{
            .fixed_names = undefined,
            .fixed_values = undefined,
            .fixed_count = 0,
            .overflow = null,
            .parent = parent,
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *Environment) void {
        if (self.overflow) |*m| m.deinit();
    }

    /// Look up a variable by name, walking the scope chain.
    pub fn lookup(self: *const Environment, name: []const u8) Value {
        // Check fixed slots first (fast path)
        for (0..self.fixed_count) |i| {
            if (std.mem.eql(u8, self.fixed_names[i], name)) return self.fixed_values[i];
        }
        // Check overflow
        if (self.overflow) |m| {
            if (m.get(name)) |val| return val;
        }
        // Walk parent chain
        if (self.parent) |p| return p.lookup(name);
        return .undefined;
    }

    /// Set a variable in the current scope.
    pub fn set(self: *Environment, name: []const u8, value: Value) void {
        // Check if already in fixed slots (update in place)
        for (0..self.fixed_count) |i| {
            if (std.mem.eql(u8, self.fixed_names[i], name)) {
                self.fixed_values[i] = value;
                return;
            }
        }
        // Add to fixed slots if space available
        if (self.fixed_count < MAX_FIXED) {
            self.fixed_names[self.fixed_count] = name;
            self.fixed_values[self.fixed_count] = value;
            self.fixed_count += 1;
            return;
        }
        // Overflow to hash map
        if (self.overflow == null) {
            self.overflow = std.StringArrayHashMap(Value).init(self.allocator);
        }
        if (self.overflow) |*m| m.put(name, value) catch {};
    }

    /// Assign a variable: walk up the scope chain to update the first scope
    /// that already has it. If not found in any scope, create in current scope
    /// (JavaScript "implicit global" semantics for non-strict mode).
    pub fn assign(self: *Environment, name: []const u8, value: Value) void {
        // Check current scope fixed slots
        for (0..self.fixed_count) |i| {
            if (std.mem.eql(u8, self.fixed_names[i], name)) {
                self.fixed_values[i] = value;
                return;
            }
        }
        // Check current scope overflow
        if (self.overflow) |*m| {
            if (m.getPtr(name)) |ptr| {
                ptr.* = value;
                return;
            }
        }
        // Walk up the parent chain
        if (self.parent) |p| {
            if (p.has(name)) {
                p.assign(name, value);
                return;
            }
        }
        // Not found anywhere — create in current scope
        self.set(name, value);
    }

    /// Check if the current scope (not parent chain) has a binding for name.
    fn has(self: *const Environment, name: []const u8) bool {
        for (0..self.fixed_count) |i| {
            if (std.mem.eql(u8, self.fixed_names[i], name)) return true;
        }
        if (self.overflow) |m| return m.contains(name);
        if (self.parent) |p| return p.has(name);
        return false;
    }

    /// Update an existing variable in the nearest scope that has it.
    pub fn update(self: *Environment, name: []const u8, value: Value) void {
        for (0..self.fixed_count) |i| {
            if (std.mem.eql(u8, self.fixed_names[i], name)) {
                self.fixed_values[i] = value;
                return;
            }
        }
        if (self.overflow) |*m| {
            if (m.getPtr(name)) |ptr| {
                ptr.* = value;
                return;
            }
        }
        self.set(name, value);
    }

    /// Check if a variable exists in the current scope (not parent chain).
    pub fn hasLocal(self: *const Environment, name: []const u8) bool {
        for (0..self.fixed_count) |i| {
            if (std.mem.eql(u8, self.fixed_names[i], name)) return true;
        }
        if (self.overflow) |m| return m.contains(name);
        return false;
    }
};

/// Per-file mutable state for rules that use closures across visitors.
/// Created once per rule at startup from the create() body, then
/// cloned/reset for each file.
pub const ClosureState = struct {
    /// Named slots for closure variables (e.g., `const stack = []`).
    slots: std.StringArrayHashMap(Value),
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) ClosureState {
        return .{
            .slots = std.StringArrayHashMap(Value).init(allocator),
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *ClosureState) void {
        self.slots.deinit();
    }

    pub fn get(self: *const ClosureState, name: []const u8) Value {
        return self.slots.get(name) orelse .undefined;
    }

    pub fn set(self: *ClosureState, name: []const u8, value: Value) void {
        self.slots.put(name, value) catch {};
    }

    /// Reset all slots to their initial values for a new file.
    pub fn reset(self: *ClosureState) void {
        var iter = self.slots.iterator();
        while (iter.next()) |entry| {
            entry.value_ptr.* = .undefined;
        }
    }
};
