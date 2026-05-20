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

pub const Checker = struct {
    gpa: std.mem.Allocator,
    ast_ref: *const Ast,
    semantic: *const SemanticResult,
    store: TypeStore,
    /// node → TypeId cache (lazy; .none means "not yet computed").
    node_types: []TypeId,
    /// sym → declared TypeId (lazy).
    sym_types: []TypeId,

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
        return .{
            .gpa = gpa,
            .ast_ref = ast_ref,
            .semantic = semantic,
            .store = try TypeStore.init(gpa),
            .node_types = node_types,
            .sym_types = sym_types,
        };
    }

    pub fn deinit(self: *Checker) void {
        self.store.deinit();
        self.gpa.free(self.node_types);
        self.gpa.free(self.sym_types);
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
            .this_expr, .super_expr => tymod.ID_UNKNOWN,

            .identifier => self.inferIdentifier(node),

            .ts_as_expr, .ts_type_assertion => self.inferAsCast(node, t),
            .ts_satisfies_expr => self.inferSatisfies(node),
            .ts_non_null_expr => self.typeOf(self.ast_ref.nodeData(node).lhs),

            .grouping_expr => self.typeOf(self.ast_ref.nodeData(node).lhs),
            .sequence_expr => self.inferSequence(node),
            .conditional => self.inferConditional(node),
            .assign => self.typeOf(self.ast_ref.nodeData(node).rhs),

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

            // We don't infer function return types yet.  Default to
            // `unknown` (NOT `any`) — `unknown` doesn't trigger
            // no-unsafe-* rules, which is the safer default.  When the
            // callee itself is `any`, anyness propagates through `call_expr`
            // because rules query `typeOfNode(callee)` directly.
            .call_expr, .optional_call_expr, .new_expr => tymod.ID_UNKNOWN,

            .member_expr, .computed_member_expr,
            .optional_member_expr, .optional_computed_member_expr => self.inferMember(node),

            .await_expr => self.inferAwait(node),
            .yield_expr, .yield_delegate => tymod.ID_UNKNOWN,

            // Function and class expressions have function/constructor
            // types in TS — never `any` by default.  Return unknown
            // until we wire up real function-signature types.
            .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
            .arrow_fn, .async_arrow_fn,
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
        // Look up the symbol for this identifier and consult its declared
        // type.  Identifiers that don't resolve (globals, etc.) → any.
        const sym = self.symbolForIdentRef(node) orelse return tymod.ID_ANY;
        return self.declaredTypeForSymbol(sym);
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
        if (binding == .none) return tymod.ID_ANY;
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
            // Function/class declarations are not `any` — they have an
            // inferred (or declared) signature/constructor type.  We
            // don't model these structurally yet, so return `unknown`
            // — it's not `any`, so no-unsafe-* won't fire on calls.
            .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
            .class_decl => return tymod.ID_UNKNOWN,
            // Function/method/getter/setter parameter, class field, etc.
            // We don't resolve these structurally yet — return unknown
            // rather than any so unsafe-* rules don't spuriously fire.
            else => return tymod.ID_UNKNOWN,
        }
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
            .ts_keyof_type => tymod.ID_STRING, // approx
            .ts_type_literal => tymod.ID_UNKNOWN, // TODO: walk members
            .ts_function_type, .ts_constructor_type => tymod.ID_UNKNOWN,
            .ts_tuple_type => tymod.ID_UNKNOWN,
            .ts_indexed_access_type => tymod.ID_UNKNOWN,
            .ts_conditional_type => tymod.ID_UNKNOWN,
            .ts_mapped_type => tymod.ID_UNKNOWN,
            .ts_template_literal_type => tymod.ID_STRING,
            else => tymod.ID_UNKNOWN,
        };
    }

    fn resolveTypeRef(self: *Checker, ty_node: NodeIndex) TypeId {
        const name_tok = self.ast_ref.nodeMainToken(ty_node);
        const name = self.ast_ref.tokenText(name_tok);
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
        // Generic args: collect for the typeRef payload.
        var args_buf: [8]TypeId = undefined;
        const args = self.collectTypeArgs(ty_node, &args_buf);
        return self.store.typeRef(name, args) catch tymod.ID_ANY;
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
        const range = self.safeSubRange(data.lhs) orelse return tymod.ID_ANY;
        const slice = self.ast_ref.extra_data[range.start..range.end];
        var buf: [16]TypeId = undefined;
        const n = @min(slice.len, buf.len);
        var i: usize = 0;
        while (i < n) : (i += 1) {
            const m: NodeIndex = @enumFromInt(slice[i]);
            buf[i] = self.resolveTypeNode(m);
        }
        return self.store.unionOf(buf[0..n]) catch tymod.ID_ANY;
    }

    fn resolveIntersection(self: *Checker, ty_node: NodeIndex) TypeId {
        // For now intersections are treated like unions for the
        // purpose of any-detection: `T & any` becomes any either way.
        return self.resolveUnion(ty_node);
    }

    // ── Expression helpers ────────────────────────────────

    fn inferAsCast(self: *Checker, node: NodeIndex, tag: ast.Node.Tag) TypeId {
        const data = self.ast_ref.nodeData(node);
        const ty_node = if (tag == .ts_as_expr) data.rhs else data.lhs;
        const inner_node = if (tag == .ts_as_expr) data.lhs else data.rhs;
        // `x as any` widens to any; `x as Foo` becomes Foo.  But
        // `any as Foo` is exactly the unsafe-* pattern: typescript-eslint
        // still considers the source `any` for assignment purposes only
        // when no explicit annotation is given.  Our rule will inspect
        // the SOURCE expression for any-ness BEFORE the cast, so here
        // we honor the cast for downstream uses (final type).
        _ = inner_node;
        return self.resolveTypeNode(ty_node);
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

    fn inferArrayLiteral(self: *Checker, node: NodeIndex) TypeId {
        const data = self.ast_ref.nodeData(node);
        const range = self.safeSubRange(data.lhs) orelse {
            return self.store.arrayOf(tymod.ID_NEVER) catch tymod.ID_ANY;
        };
        if (range.end <= range.start) return self.store.arrayOf(tymod.ID_NEVER) catch tymod.ID_ANY;
        // Element type = union of element types.
        var buf: [32]TypeId = undefined;
        const slice = self.ast_ref.extra_data[range.start..range.end];
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
        _ = self;
        _ = node;
        // Without structural typing we return `unknown`, not `any` —
        // TS doesn't make `{ a: 1 }` an any-flavored value, it's an
        // inferred structural type.  Returning unknown prevents
        // false-positives on no-unsafe-*.
        return tymod.ID_UNKNOWN;
    }

    fn inferMember(self: *Checker, node: NodeIndex) TypeId {
        // Member access on any → any (anyness propagates through the
        // unknown property).  Otherwise the property's type is
        // unresolved — default to `unknown` rather than `any` so we
        // don't false-positive no-unsafe-* on every plain method call
        // like `x.toString()`.
        const data = self.ast_ref.nodeData(node);
        const obj_ty = self.typeOf(data.lhs);
        if (tymod.isAny(&self.store, obj_ty)) return tymod.ID_ANY;
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
