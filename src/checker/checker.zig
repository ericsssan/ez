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
        };
        try self.buildKnownTypeNames();
        return self;
    }

    pub fn deinit(self: *Checker) void {
        self.store.deinit();
        self.gpa.free(self.node_types);
        self.gpa.free(self.sym_types);
        self.known_type_names.deinit(self.gpa);
        self.type_decl_nodes.deinit(self.gpa);
        self.declared_type_cache.deinit(self.gpa);
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
        // Look up the symbol for this identifier and consult its declared
        // type.  Identifiers that don't resolve to a user-declared binding
        // are typically globals (console, window, etc.) — we don't have
        // type info for them, but defaulting to `any` would cascade
        // unsafe-* FPs on `console.log`, `window.x`, etc.  Use `unknown`
        // so unsafe-* rules don't fire on unresolved references.
        const sym = self.symbolForIdentRef(node) orelse return tymod.ID_UNKNOWN;
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
        return self.buildFunctionType(fd.params, fd.params_end, fd.return_type, .none, is_async);
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
        // expression body falls back to inferring from the body; else
        // `unknown` (we don't yet infer block-body returns).
        var ret_ty: TypeId = tymod.ID_UNKNOWN;
        if (return_type_node != .none and
            self.ast_ref.nodeTag(return_type_node) == .ts_type_annotation)
        {
            const ty_inner = self.ast_ref.nodeData(return_type_node).lhs;
            ret_ty = self.resolveTypeNode(ty_inner);
        } else if (body_for_inference != .none and
            self.ast_ref.nodeTag(body_for_inference) != .block_stmt)
        {
            ret_ty = self.typeOf(body_for_inference);
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
                // main_token and resolve to the underlying array.
                const op_tok = self.ast_ref.nodeMainToken(ty_node);
                const op_text = self.ast_ref.tokenText(op_tok);
                if (std.mem.eql(u8, op_text, "readonly")) {
                    const inner = self.ast_ref.nodeData(ty_node).lhs;
                    break :blk self.resolveTypeNode(inner);
                }
                break :blk tymod.ID_STRING; // keyof default approx
            },
            .ts_type_literal => self.resolveTypeLiteral(ty_node),
            .ts_function_type, .ts_constructor_type => self.resolveFunctionType(ty_node),
            .ts_tuple_type => self.resolveTupleType(ty_node),
            .ts_indexed_access_type => tymod.ID_UNKNOWN,
            .ts_conditional_type => tymod.ID_UNKNOWN,
            .ts_mapped_type => tymod.ID_UNKNOWN,
            .ts_template_literal_type => tymod.ID_STRING,
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
    fn resolveTypeLiteral(self: *Checker, ty_node: NodeIndex) TypeId {
        // Members range stored directly in lhs/rhs — see directRange comment.
        const data = self.ast_ref.nodeData(ty_node);
        const member_node_indices = self.directRange(data.lhs, data.rhs) orelse return tymod.ID_UNKNOWN;
        var props_buf: [32]tymod.ObjectProp = undefined;
        var prop_count: usize = 0;
        for (member_node_indices) |raw| {
            if (prop_count >= props_buf.len) break;
            const member: NodeIndex = @enumFromInt(raw);
            if (self.ast_ref.nodeTag(member) != .ts_property_signature) continue;
            const member_data = self.ast_ref.nodeData(member);
            const name_node = member_data.lhs;
            if (name_node == .none) continue;
            const name_tok = self.ast_ref.nodeMainToken(name_node);
            const raw_name = self.ast_ref.tokenText(name_tok);
            // Strip quotes/backticks for string-literal / template-literal
            // computed keys: `['x']: T` and `` [`x`]: T `` both denote a
            // property literally named "x".
            const name_tag = self.ast_ref.nodeTag(name_node);
            const name = if ((name_tag == .string_literal or name_tag == .template_literal) and raw_name.len >= 2)
                raw_name[1 .. raw_name.len - 1]
            else
                raw_name;
            // The type annotation is stored in rhs as a ts_type_annotation
            // wrapper (`name: Type` → the colon-wrapped type node).
            // No annotation → property type is any (TS implicit any).
            var prop_ty: TypeId = tymod.ID_ANY;
            if (member_data.rhs != .none and self.ast_ref.nodeTag(member_data.rhs) == .ts_type_annotation) {
                const ty_inner = self.ast_ref.nodeData(member_data.rhs).lhs;
                prop_ty = self.resolveTypeNode(ty_inner);
            }
            props_buf[prop_count] = .{ .name = name, .type_id = prop_ty };
            prop_count += 1;
        }
        const list = self.store.appendObjectProps(props_buf[0..prop_count]) catch return tymod.ID_UNKNOWN;
        return self.store.add(.{ .kind = .object_t, .object_props = list }) catch tymod.ID_UNKNOWN;
    }

    /// Walk the AST once and collect names declared as types.  Sources:
    ///   * ts_type_alias_decl, ts_interface_decl, ts_enum_decl
    ///   * class_decl (also acts as a type name)
    ///   * ts_namespace_decl, ts_module_decl
    ///   * import_specifier / import_default_specifier / import_namespace_specifier
    ///   * ts_type_parameter (generic params)
    /// We also pre-populate built-in lib type names so common imports
    /// like `Date`, `Map`, `Promise<T>` don't get classified as errors.
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
                    try self.known_type_names.put(self.gpa, self.ast_ref.tokenText(ed.name), {});
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
                // `type Foo = { ... }` / `type Foo = X & Y` — resolve the
                // alias body to its TypeId.  ONLY resolve when the body
                // is a plain ts_type_literal: recursive aliases bottom
                // out at the ID_UNKNOWN sentinel which would pollute
                // downstream "contains unknown" checks for any type
                // that references the alias.
                const dd = self.ast_ref.nodeData(decl);
                const ad = self.ast_ref.extraData(ast.TypeAliasData, @intFromEnum(dd.lhs));
                if (self.ast_ref.nodeTag(ad.type_node) != .ts_type_literal) return null;
                break :blk self.resolveTypeNode(ad.type_node);
            },
            else => return null,
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
        if (id.extends_end > id.extends_start) {
            const extends = self.ast_ref.extra_data[id.extends_start..id.extends_end];
            for (extends) |tok| {
                const ext_name = self.ast_ref.tokenText(tok);
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
    fn buildClassInstanceType(self: *Checker, decl: NodeIndex) TypeId {
        const data = self.ast_ref.nodeData(decl);
        const cd = self.ast_ref.extraData(ast.ClassData, @intFromEnum(data.lhs));
        var props: std.ArrayList(tymod.ObjectProp) = .empty;
        defer props.deinit(self.gpa);
        if (cd.body == .none) return tymod.ID_UNKNOWN;
        const body_data = self.ast_ref.nodeData(cd.body);
        const slice = self.directRange(body_data.lhs, body_data.rhs) orelse {
            const list = self.store.appendObjectProps(props.items) catch return tymod.ID_UNKNOWN;
            return self.store.add(.{ .kind = .object_t, .object_props = list }) catch tymod.ID_UNKNOWN;
        };
        for (slice) |raw| {
            const member: NodeIndex = @enumFromInt(raw);
            if (self.classMemberToProp(member)) |p| {
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
        // For now intersections are treated like unions for the
        // purpose of any-detection: `T & any` becomes any either way.
        return self.resolveUnion(ty_node);
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
        const t = self.store.get(callee_ty);
        if (t.kind == .function_t) {
            const sigs = self.store.signaturesOf(t.signatures);
            if (sigs.len > 0) return sigs[0].return_type;
        }
        return tymod.ID_UNKNOWN;
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
            std.mem.eql(u8, name, "RegExp") or std.mem.eql(u8, name, "Array"))
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
        _ = self;
        _ = node;
        // Without structural typing we return `unknown`, not `any` —
        // TS doesn't make `{ a: 1 }` an any-flavored value, it's an
        // inferred structural type.  Returning unknown prevents
        // false-positives on no-unsafe-*.
        return tymod.ID_UNKNOWN;
    }

    fn inferMember(self: *Checker, node: NodeIndex) TypeId {
        const data = self.ast_ref.nodeData(node);
        const obj_ty = self.typeOf(data.lhs);
        if (tymod.isAny(&self.store, obj_ty)) return tymod.ID_ANY;
        const tag = self.ast_ref.nodeTag(node);
        const prop_name: []const u8 = switch (tag) {
            .member_expr, .optional_member_expr => blk: {
                if (data.rhs == .none) break :blk &.{};
                const t = self.ast_ref.nodeMainToken(data.rhs);
                break :blk self.ast_ref.tokenText(t);
            },
            else => return tymod.ID_UNKNOWN,
        };
        if (prop_name.len == 0) return tymod.ID_UNKNOWN;
        // Look up the property on the apparent type — TS substitutes
        // type parameters with their constraints when accessing members
        // (the "apparent type"), which lets `t.foo()` where `t: T
        // extends Bar` resolve to `Bar.foo`.  We walk through union
        // members similarly to TS (every member contributes its
        // property type, joined by union).
        return self.memberOnApparentType(obj_ty, prop_name, data.lhs);
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
                if (std.mem.eql(u8, p.name, prop_name)) return p.type_id;
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
