// Type representation for the Ez TS type checker.
//
// Design constraints:
//   * Types live in a TypeStore arena (no individual frees).
//   * TypeId is a u32 index; .none is the sentinel for "not yet computed".
//   * Singletons for the common scalar types live at fixed slots [0..N) so
//     hot-paths can compare TypeIds directly without a flag dispatch.
//   * Composite types (union, intersection, object, function, array, tuple,
//     reference) carry payload slices stored in side-arrays so the base
//     struct stays small and uniform.

const std = @import("std");
const ast = @import("../parser/ast.zig");

pub const TypeId = enum(u32) {
    none = std.math.maxInt(u32),
    _,

    pub fn toInt(self: TypeId) u32 {
        return @intFromEnum(self);
    }
    pub fn fromInt(i: u32) TypeId {
        return @enumFromInt(i);
    }
    pub fn eq(a: TypeId, b: TypeId) bool {
        return @intFromEnum(a) == @intFromEnum(b);
    }
};

pub const TypeKind = enum(u8) {
    // ── scalars (every instance points at the singleton slot) ──
    any,
    unknown,
    never,
    null_t,
    undefined_t,
    void_t,
    number,
    string,
    boolean,
    bigint,
    symbol,
    object_keyword, // the bare `object` keyword (non-primitive)
    /// TS "intrinsic error type" — used when a type reference doesn't
    /// resolve to any declared name (`let v: NotKnown`).  Rules fire
    /// `error*` messageIds on these.
    error_t,

    // ── literals ───────────────────────────────────────────
    string_literal,
    number_literal,
    bigint_literal,
    boolean_literal,

    // ── composite ──────────────────────────────────────────
    union_t,
    intersection_t,
    /// Anonymous object type — `{ a: number; b: string }`.  Properties live
    /// in `object_props` at [extra_start .. extra_end).
    object_t,
    /// Function/method/constructor — signatures in `signatures` at
    /// [extra_start .. extra_end).
    function_t,
    /// Array<T> / T[].  extra_start = element TypeId (single slot).
    array_t,
    /// readonly T[] / ReadonlyArray<T>.  extra_start = element TypeId.
    readonly_array_t,
    /// [A, B, C].  Element TypeIds at [extra_start .. extra_end).
    tuple_t,
    /// Named reference: Foo, Foo<T>, etc.  `name` holds the textual name,
    /// type args at [extra_start .. extra_end).  Used pre-resolution and
    /// for type-parameter references that we can't resolve fully.
    type_ref,
    /// Type parameter binding (T inside `function<T>(...)`).
    type_param,
};

/// Side-array of TypeIds — used by union/intersection/tuple/function args.
pub const TypeIdList = struct {
    start: u32,
    end: u32,

    pub const empty: TypeIdList = .{ .start = 0, .end = 0 };

    pub fn len(self: TypeIdList) u32 {
        return self.end - self.start;
    }
};

pub const ObjectProp = struct {
    name: []const u8,
    type_id: TypeId,
    optional: bool = false,
    readonly: bool = false,
};

pub const Signature = struct {
    params_start: u32, // into signature_params (TypeId slice)
    params_end: u32,
    return_type: TypeId,
    is_async: bool = false,
    is_generator: bool = false,
};

pub const Type = struct {
    kind: TypeKind,
    /// Tagged extra:
    ///   string_literal/number_literal/bigint_literal/boolean_literal → literal_value
    ///   union/intersection/tuple/function → list_data
    ///   object_t → object_props list
    ///   array_t/readonly_array_t → list_data.start = element TypeId
    ///   type_ref/type_param → name + type_args
    literal_value: LiteralValue = .{ .none = {} },
    list_data: TypeIdList = .empty,
    object_props: ObjectPropList = ObjectPropList.empty,
    signatures: SignatureList = SignatureList.empty,
    name: []const u8 = "",
};

pub const LiteralValue = union(enum) {
    none: void,
    string: []const u8,
    number: f64,
    bigint: []const u8,
    boolean: bool,
};

pub const ObjectPropList = struct {
    start: u32,
    end: u32,
    pub const empty: ObjectPropList = .{ .start = 0, .end = 0 };
    pub fn len(self: ObjectPropList) u32 {
        return self.end - self.start;
    }
};

pub const SignatureList = struct {
    start: u32,
    end: u32,
    pub const empty: SignatureList = .{ .start = 0, .end = 0 };
    pub fn len(self: SignatureList) u32 {
        return self.end - self.start;
    }
};

// ── Singleton slots (must match the order in TypeStore.init) ──
pub const ID_ANY: TypeId = @enumFromInt(0);
pub const ID_UNKNOWN: TypeId = @enumFromInt(1);
pub const ID_NEVER: TypeId = @enumFromInt(2);
pub const ID_NULL: TypeId = @enumFromInt(3);
pub const ID_UNDEFINED: TypeId = @enumFromInt(4);
pub const ID_VOID: TypeId = @enumFromInt(5);
pub const ID_NUMBER: TypeId = @enumFromInt(6);
pub const ID_STRING: TypeId = @enumFromInt(7);
pub const ID_BOOLEAN: TypeId = @enumFromInt(8);
pub const ID_BIGINT: TypeId = @enumFromInt(9);
pub const ID_SYMBOL: TypeId = @enumFromInt(10);
pub const ID_OBJECT_KW: TypeId = @enumFromInt(11);
/// "error type" — TS's representation of an unresolved or
/// uncomputable type (e.g. `let v: NotKnown` where `NotKnown` isn't
/// declared anywhere).  TSe's rules fire with `error*` messageIds
/// (`errorMemberExpression`, `errorComputedMemberAccess`, `errorCall`,
/// etc.) on these types in addition to firing on `any`.
pub const ID_ERROR: TypeId = @enumFromInt(12);

pub const SINGLETON_COUNT: u32 = 13;

pub const TypeStore = struct {
    gpa: std.mem.Allocator,
    types: std.ArrayList(Type) = .empty,
    /// Backing storage for TypeIdList payloads (union/intersection/tuple).
    type_id_pool: std.ArrayList(TypeId) = .empty,
    /// Backing storage for object_props.
    object_prop_pool: std.ArrayList(ObjectProp) = .empty,
    /// Backing storage for signature_params (TypeIds packed).
    signature_pool: std.ArrayList(Signature) = .empty,
    signature_param_pool: std.ArrayList(TypeId) = .empty,

    pub fn init(gpa: std.mem.Allocator) !TypeStore {
        var self: TypeStore = .{ .gpa = gpa };
        try self.types.ensureTotalCapacity(gpa, SINGLETON_COUNT);
        // Order MUST match the ID_* constants above.
        try self.types.append(gpa, .{ .kind = .any });
        try self.types.append(gpa, .{ .kind = .unknown });
        try self.types.append(gpa, .{ .kind = .never });
        try self.types.append(gpa, .{ .kind = .null_t });
        try self.types.append(gpa, .{ .kind = .undefined_t });
        try self.types.append(gpa, .{ .kind = .void_t });
        try self.types.append(gpa, .{ .kind = .number });
        try self.types.append(gpa, .{ .kind = .string });
        try self.types.append(gpa, .{ .kind = .boolean });
        try self.types.append(gpa, .{ .kind = .bigint });
        try self.types.append(gpa, .{ .kind = .symbol });
        try self.types.append(gpa, .{ .kind = .object_keyword });
        try self.types.append(gpa, .{ .kind = .error_t });
        return self;
    }

    pub fn deinit(self: *TypeStore) void {
        self.types.deinit(self.gpa);
        self.type_id_pool.deinit(self.gpa);
        self.object_prop_pool.deinit(self.gpa);
        self.signature_pool.deinit(self.gpa);
        self.signature_param_pool.deinit(self.gpa);
    }

    pub inline fn get(self: *const TypeStore, id: TypeId) *const Type {
        return &self.types.items[id.toInt()];
    }

    pub fn add(self: *TypeStore, ty: Type) !TypeId {
        const id: TypeId = .fromInt(@intCast(self.types.items.len));
        try self.types.append(self.gpa, ty);
        return id;
    }

    /// Append the given TypeIds to the pool and return a list pointing at them.
    pub fn appendTypeIds(self: *TypeStore, ids: []const TypeId) !TypeIdList {
        const start: u32 = @intCast(self.type_id_pool.items.len);
        try self.type_id_pool.appendSlice(self.gpa, ids);
        const end: u32 = @intCast(self.type_id_pool.items.len);
        return .{ .start = start, .end = end };
    }

    pub fn idsOf(self: *const TypeStore, list: TypeIdList) []const TypeId {
        return self.type_id_pool.items[list.start..list.end];
    }

    pub fn appendObjectProps(self: *TypeStore, props: []const ObjectProp) !ObjectPropList {
        const start: u32 = @intCast(self.object_prop_pool.items.len);
        try self.object_prop_pool.appendSlice(self.gpa, props);
        const end: u32 = @intCast(self.object_prop_pool.items.len);
        return .{ .start = start, .end = end };
    }

    pub fn propsOf(self: *const TypeStore, list: ObjectPropList) []const ObjectProp {
        return self.object_prop_pool.items[list.start..list.end];
    }

    /// Append a slice of signature param TypeIds and return a range.
    /// Used when building a Signature's params slice in `signature_param_pool`.
    pub fn appendSignatureParams(self: *TypeStore, params: []const TypeId) !struct { start: u32, end: u32 } {
        const start: u32 = @intCast(self.signature_param_pool.items.len);
        try self.signature_param_pool.appendSlice(self.gpa, params);
        const end: u32 = @intCast(self.signature_param_pool.items.len);
        return .{ .start = start, .end = end };
    }

    pub fn signatureParamsOf(self: *const TypeStore, sig: Signature) []const TypeId {
        return self.signature_param_pool.items[sig.params_start..sig.params_end];
    }

    pub fn appendSignatures(self: *TypeStore, sigs: []const Signature) !SignatureList {
        const start: u32 = @intCast(self.signature_pool.items.len);
        try self.signature_pool.appendSlice(self.gpa, sigs);
        const end: u32 = @intCast(self.signature_pool.items.len);
        return .{ .start = start, .end = end };
    }

    pub fn signaturesOf(self: *const TypeStore, list: SignatureList) []const Signature {
        return self.signature_pool.items[list.start..list.end];
    }

    /// Construct a function type from a single signature.  Caller passes
    /// the signature struct (with params/return already loaded into the
    /// respective pools via appendSignatureParams).
    pub fn functionType(self: *TypeStore, sig: Signature) !TypeId {
        const sigs = try self.appendSignatures(&.{sig});
        return try self.add(.{ .kind = .function_t, .signatures = sigs });
    }

    // ── Convenience constructors ──────────────────────────

    pub fn unionOf(self: *TypeStore, members: []const TypeId) !TypeId {
        // Flatten + dedup (cheap: most unions are small).
        var buf = std.ArrayList(TypeId).empty;
        defer buf.deinit(self.gpa);
        for (members) |m| {
            const t = self.get(m);
            if (t.kind == .union_t) {
                for (self.idsOf(t.list_data)) |inner| {
                    try addUnique(self.gpa, &buf, inner);
                }
            } else {
                try addUnique(self.gpa, &buf, m);
            }
        }
        if (buf.items.len == 0) return ID_NEVER;
        if (buf.items.len == 1) return buf.items[0];
        // any-in-union collapses to any (TS semantics).
        for (buf.items) |m| if (m.eq(ID_ANY)) return ID_ANY;
        const list = try self.appendTypeIds(buf.items);
        return try self.add(.{ .kind = .union_t, .list_data = list });
    }

    pub fn arrayOf(self: *TypeStore, elem: TypeId) !TypeId {
        const list = try self.appendTypeIds(&.{elem});
        return try self.add(.{ .kind = .array_t, .list_data = list });
    }

    pub fn readonlyArrayOf(self: *TypeStore, elem: TypeId) !TypeId {
        const list = try self.appendTypeIds(&.{elem});
        return try self.add(.{ .kind = .readonly_array_t, .list_data = list });
    }

    pub fn tupleOf(self: *TypeStore, elems: []const TypeId) !TypeId {
        const list = try self.appendTypeIds(elems);
        return try self.add(.{ .kind = .tuple_t, .list_data = list });
    }

    pub fn intersectionOf(self: *TypeStore, members: []const TypeId) !TypeId {
        // Flatten + dedup, mirroring unionOf.
        var buf = std.ArrayList(TypeId).empty;
        defer buf.deinit(self.gpa);
        for (members) |m| {
            const t = self.get(m);
            if (t.kind == .intersection_t) {
                for (self.idsOf(t.list_data)) |inner| {
                    try addUnique(self.gpa, &buf, inner);
                }
            } else {
                try addUnique(self.gpa, &buf, m);
            }
        }
        if (buf.items.len == 0) return ID_NEVER;
        if (buf.items.len == 1) return buf.items[0];
        const list = try self.appendTypeIds(buf.items);
        return try self.add(.{ .kind = .intersection_t, .list_data = list });
    }

    pub fn objectOf(self: *TypeStore, props: []const ObjectProp) !TypeId {
        if (props.len == 0) return try self.add(.{ .kind = .object_t });
        // Append props to the object prop pool.
        const start: u32 = @intCast(self.object_prop_pool.items.len);
        try self.object_prop_pool.appendSlice(self.gpa, props);
        const end: u32 = @intCast(self.object_prop_pool.items.len);
        return try self.add(.{
            .kind = .object_t,
            .object_props = .{ .start = start, .end = end },
        });
    }

    pub fn typeRef(self: *TypeStore, name: []const u8, args: []const TypeId) !TypeId {
        const list = if (args.len == 0) TypeIdList.empty else try self.appendTypeIds(args);
        return try self.add(.{ .kind = .type_ref, .name = name, .list_data = list });
    }

    fn addUnique(gpa: std.mem.Allocator, buf: *std.ArrayList(TypeId), id: TypeId) !void {
        for (buf.items) |x| if (x.eq(id)) return;
        try buf.append(gpa, id);
    }
};

// ── Assignability ────────────────────────────────────────────

/// Is `source` assignable to `target`?  Approximates TS's `isAssignableTo`
/// to the depth needed for the type-aware rule family.
pub fn isAssignableTo(store: *const TypeStore, source: TypeId, target: TypeId) bool {
    if (source.eq(target)) return true;
    if (isUnknown(store, target)) return true;
    if (isAny(store, source) or isAny(store, target)) return true;
    const s = store.get(source);
    if (s.kind == .never) return true;
    // Union source: every member must be assignable to target.
    if (s.kind == .union_t) {
        for (store.idsOf(s.list_data)) |m| {
            if (!isAssignableTo(store, m, target)) return false;
        }
        return true;
    }
    // Union target: source assignable to ANY member.
    const t = store.get(target);
    if (t.kind == .union_t) {
        for (store.idsOf(t.list_data)) |m| {
            if (isAssignableTo(store, source, m)) return true;
        }
        return false;
    }
    // Intersection target: source must be assignable to EVERY member.
    if (t.kind == .intersection_t) {
        for (store.idsOf(t.list_data)) |m| {
            if (!isAssignableTo(store, source, m)) return false;
        }
        return true;
    }
    // Intersection source: ANY member assignable to target is enough.
    if (s.kind == .intersection_t) {
        for (store.idsOf(s.list_data)) |m| {
            if (isAssignableTo(store, m, target)) return true;
        }
        return false;
    }
    // Literal → primitive of same kind.
    if (s.kind == .string_literal and t.kind == .string) return true;
    if (s.kind == .number_literal and t.kind == .number) return true;
    if (s.kind == .boolean_literal and t.kind == .boolean) return true;
    if (s.kind == .bigint_literal and t.kind == .bigint) return true;
    // Structural object: target's every prop present + assignable in source.
    if (s.kind == .object_t and t.kind == .object_t) {
        const s_props = store.propsOf(s.object_props);
        for (store.propsOf(t.object_props)) |tp| {
            const sp = findProp(s_props, tp.name) orelse return false;
            if (!isAssignableTo(store, sp.type_id, tp.type_id)) return false;
        }
        return true;
    }
    // Array/tuple covariance (sound for read-only positions).
    if ((s.kind == .array_t or s.kind == .readonly_array_t) and
        (t.kind == .array_t or t.kind == .readonly_array_t))
    {
        const se = store.idsOf(s.list_data);
        const te = store.idsOf(t.list_data);
        if (se.len == 0 or te.len == 0) return false;
        return isAssignableTo(store, se[0], te[0]);
    }
    // Tuple ↔ tuple: element-wise covariant.
    if (s.kind == .tuple_t and t.kind == .tuple_t) {
        const se = store.idsOf(s.list_data);
        const te = store.idsOf(t.list_data);
        if (se.len != te.len) return false;
        for (se, te) |a, b| if (!isAssignableTo(store, a, b)) return false;
        return true;
    }
    // Tuple → array: tuple T1, T2, ... assignable to (T1 | T2 | ...)[].
    if (s.kind == .tuple_t and (t.kind == .array_t or t.kind == .readonly_array_t)) {
        const elems = store.idsOf(s.list_data);
        const te = store.idsOf(t.list_data);
        if (te.len == 0) return false;
        for (elems) |e| if (!isAssignableTo(store, e, te[0])) return false;
        return true;
    }
    // type_ref: same NAME and assignable type args (covariant approximation).
    if (s.kind == .type_ref and t.kind == .type_ref) {
        if (!std.mem.eql(u8, s.name, t.name)) return false;
        const sa = store.idsOf(s.list_data);
        const ta = store.idsOf(t.list_data);
        if (sa.len != ta.len) return false;
        for (sa, ta) |a, b| if (!isAssignableTo(store, a, b)) return false;
        return true;
    }
    // Function variance:
    //   - target's param count <= source's param count (extra source
    //     params are allowed — JS callers can ignore).
    //   - parameters contravariant: target_param assignable to source_param.
    //   - return covariant: source_return assignable to target_return.
    if (s.kind == .function_t and t.kind == .function_t) {
        const s_sigs = store.signaturesOf(s.signatures);
        const t_sigs = store.signaturesOf(t.signatures);
        if (s_sigs.len == 0 or t_sigs.len == 0) return false;
        // Use the first overload of each — TSe rule family doesn't
        // exercise overload matrix selection.
        const ss = s_sigs[0];
        const ts = t_sigs[0];
        const s_params = store.signatureParamsOf(ss);
        const t_params = store.signatureParamsOf(ts);
        if (t_params.len > s_params.len) return false;
        for (t_params, 0..) |tp, i| {
            // contravariant: target_param ≤ source_param.
            if (!isAssignableTo(store, tp, s_params[i])) return false;
        }
        return isAssignableTo(store, ss.return_type, ts.return_type);
    }
    return false;
}

fn findProp(props: []const ObjectProp, name: []const u8) ?ObjectProp {
    for (props) |p| if (std.mem.eql(u8, p.name, name)) return p;
    return null;
}

// ── Anyness — the core query for no-unsafe-* rules ──────────

/// Returns true when the type is `any` or contains `any` anywhere reachable
/// without a barrier (function return type counts; opaque type ref payload
/// does not — we don't follow refs here).
pub fn isAny(store: *const TypeStore, id: TypeId) bool {
    if (id.eq(ID_ANY)) return true;
    const t = store.get(id);
    return t.kind == .any;
}

/// True when the type is `unknown` or contains `unknown` reachable at
/// any composite position.  `unknown` is the recommended safe target
/// for any-typed values (e.g. `function f(x: unknown)` is the typed
/// API contract that says "I'll narrow this before use"), so the
/// unsafe-* rules must suppress when the destination type accepts
/// any via an unknown slot.
pub fn isUnknown(store: *const TypeStore, id: TypeId) bool {
    if (id.eq(ID_UNKNOWN)) return true;
    return store.get(id).kind == .unknown;
}

/// True when the type is the built-in `Function` type — typescript-eslint
/// flags calling values of type `Function` because the type is callable
/// without signature constraints (any args, any return).  This catches
/// the simple case (`const f: Function = ...; f()`) but not custom
/// subtypes (`interface MyFn extends Function {}`) which would need
/// interface heritage tracking we don't yet do.
pub fn isFunctionRef(store: *const TypeStore, id: TypeId) bool {
    const t = store.get(id);
    if (t.kind != .type_ref) return false;
    return std.mem.eql(u8, t.name, "Function");
}

/// True when the type is the "error" type — unresolved type-name
/// reference.  TSe's rules fire `error*` messageIds on these.
pub fn isError(store: *const TypeStore, id: TypeId) bool {
    if (id.eq(ID_ERROR)) return true;
    return store.get(id).kind == .error_t;
}

/// True when the type is `Promise<T>` (any T or T contains any).
pub fn isPromiseOfAny(store: *const TypeStore, id: TypeId) bool {
    const t = store.get(id);
    if (t.kind != .type_ref) return false;
    if (!std.mem.eql(u8, t.name, "Promise")) return false;
    const args = store.idsOf(t.list_data);
    if (args.len == 0) return false;
    return containsAny(store, args[0]);
}

/// True when the type is `any[]` / `readonly any[]` / `Array<any>` /
/// `ReadonlyArray<any>` — TSe's "any array" classification.
pub fn isAnyArray(store: *const TypeStore, id: TypeId) bool {
    const t = store.get(id);
    switch (t.kind) {
        .array_t, .readonly_array_t => {
            const elems = store.idsOf(t.list_data);
            return elems.len > 0 and containsAny(store, elems[0]);
        },
        .type_ref => {
            if (std.mem.eql(u8, t.name, "Array") or std.mem.eql(u8, t.name, "ReadonlyArray")) {
                const args = store.idsOf(t.list_data);
                return args.len > 0 and containsAny(store, args[0]);
            }
            return false;
        },
        else => return false,
    }
}

pub fn containsUnknown(store: *const TypeStore, id: TypeId) bool {
    if (isUnknown(store, id)) return true;
    const t = store.get(id);
    return switch (t.kind) {
        .union_t, .intersection_t => for (store.idsOf(t.list_data)) |m| {
            if (containsUnknown(store, m)) break true;
        } else false,
        .array_t, .readonly_array_t, .tuple_t => for (store.idsOf(t.list_data)) |m| {
            if (containsUnknown(store, m)) break true;
        } else false,
        // type_ref with type args: peek args.  Catches Set<unknown>,
        // Promise<unknown>, etc.
        .type_ref => for (store.idsOf(t.list_data)) |m| {
            if (containsUnknown(store, m)) break true;
        } else false,
        else => false,
    };
}

/// True when the type has any `any` reachable in the local shape: unions
/// where one member is any, intersections (any & T = any), generics whose
/// type arguments contain any (`Promise<any>`, `Set<any>`).  Used by
/// no-unsafe-assignment to flag `const x: { a: number } = { a: anyVal }`
/// when the source has any in the corresponding slot.
pub fn containsAny(store: *const TypeStore, id: TypeId) bool {
    if (isAny(store, id)) return true;
    const t = store.get(id);
    return switch (t.kind) {
        .union_t, .intersection_t => for (store.idsOf(t.list_data)) |m| {
            if (containsAny(store, m)) break true;
        } else false,
        .array_t, .readonly_array_t, .tuple_t => for (store.idsOf(t.list_data)) |m| {
            if (containsAny(store, m)) break true;
        } else false,
        // Walk generic type args: `Promise<any>`, `Set<any>`, etc.
        .type_ref => for (store.idsOf(t.list_data)) |m| {
            if (containsAny(store, m)) break true;
        } else false,
        // Walk object properties: `{ a: any }` should report anyness.
        .object_t => for (store.propsOf(t.object_props)) |p| {
            if (containsAny(store, p.type_id)) break true;
        } else false,
        else => false,
    };
}

/// True when the type reaches `error` at any composite position.  TSe's
/// unsafe-* rules fire `error*` messageIds on these — an unresolved
/// type name reads as `error typed` in the diagnostic data.
pub fn containsError(store: *const TypeStore, id: TypeId) bool {
    if (isError(store, id)) return true;
    const t = store.get(id);
    return switch (t.kind) {
        .union_t, .intersection_t,
        .array_t, .readonly_array_t, .tuple_t,
        .type_ref => for (store.idsOf(t.list_data)) |m| {
            if (containsError(store, m)) break true;
        } else false,
        .object_t => for (store.propsOf(t.object_props)) |p| {
            if (containsError(store, p.type_id)) break true;
        } else false,
        else => false,
    };
}

test "TypeStore singletons" {
    var store = try TypeStore.init(std.testing.allocator);
    defer store.deinit();
    try std.testing.expect(isAny(&store, ID_ANY));
    try std.testing.expect(!isAny(&store, ID_NUMBER));
    try std.testing.expect(!containsAny(&store, ID_STRING));
}

test "TypeStore union flattens and collapses any" {
    var store = try TypeStore.init(std.testing.allocator);
    defer store.deinit();
    const num_or_str = try store.unionOf(&.{ ID_NUMBER, ID_STRING });
    try std.testing.expect(!containsAny(&store, num_or_str));
    const with_any = try store.unionOf(&.{ ID_NUMBER, ID_ANY });
    try std.testing.expect(with_any.eq(ID_ANY));
}

test "TypeStore array of any flagged by containsAny" {
    var store = try TypeStore.init(std.testing.allocator);
    defer store.deinit();
    const arr_any = try store.arrayOf(ID_ANY);
    try std.testing.expect(!isAny(&store, arr_any));
    try std.testing.expect(containsAny(&store, arr_any));
}

// Keep std referenced when only used in tests.
comptime {
    _ = ast;
}
