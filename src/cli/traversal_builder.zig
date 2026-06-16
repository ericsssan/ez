//! ESTree / runPlugins traversal bridge — Ez-specific.
//!
//! Builds the traversal artifacts that Ez's JS-side linter consumes over the
//! serialized buffer: `pre_order` / `post_order` / `dfs_events` (the interleaved
//! enter=`node` / exit=`~node` stream `runPlugins` dispatches on), plus the
//! ESTree-shape bridge data — `resolved_parents` (grouping/parenthesized
//! unwrap, matching estree-adapter's `nodeView`) and `type_overrides` /
//! `parent_kinds` (the pre-baked `_computeNodeType` disambiguation).
//!
//! This lives in Ez, not es-parser: it exists only because Ez's linter runs in
//! JS across the Zig→buffer boundary. A general parser has no business shaping a
//! consumer's visit stream (cf. oxc puts this in oxc_semantic; biome's CST
//! carries parents intrinsically; ESLint adds `node.parent` during its own
//! traverse). The parser-side primitive — `setChildParents` / `buildParentsOnly`
//! — stays in es-parser's parent_builder; this module composes on top of it.
const std = @import("std");
const es_parser = @import("es_parser");
const Ast = es_parser.ast.Ast;
const SubRange = es_parser.ast.SubRange;

// Parent-building primitives stay in the parser; the bridge composes on them.
const NONE: u32 = es_parser.parent_builder.NONE;
const setChildParents = es_parser.parent_builder.setChildParents;

pub const TraversalResult = struct {
    parents: []u32,
    pre_order: []u32,
    post_order: []u32,
    dfs_events: []i32,
    /// min_tok[i] = minimum main_token index in the subtree rooted at node i.
    min_tok: []u32,
    /// resolved_parents[i] = parents[i] with grouping_expr / ts_parenthesized_type
    /// ancestors skipped — i.e. the parent that ESTree-shaped JS sees after
    /// `nodeView` unwraps parenthesised expressions. Eliminates a hot while-loop
    /// in the JS `get parent` slow path.
    resolved_parents: []u32,
    /// type_overrides[i] = ESTree-shape type override slot for node i, or 0 to
    /// mean "use TAG_NAMES[tag]" (the common default). Lets JS skip the
    /// per-node `_computeNodeType` switch + token text matching for the five
    /// disambiguation cases. See `TypeOverride` below for the slot layout.
    type_overrides: []u8,
    /// parent_kinds[i] = ESTree-shape parent-synthesis dispatch slot for node i,
    /// or 0 to mean "no synthesis; resolved_parents[i]'s NodeView is the parent
    /// directly". Pre-bakes the per-node tag-pattern matching that JS-side
    /// `get parent` runs after resolving the direct parent. See `ParentKind`
    /// below for the slot layout.
    parent_kinds: []u8,
};

/// ESTree-shape parent-synthesis IDs. Slot 0 means "no synthesis" — the JS
/// adapter returns the resolved-parent NodeView unchanged. Slots 1..6 each
/// trigger a specific synthetic-wrapper or redirect path in the JS `get
/// parent` getter, replacing the per-node tag-pattern cascade with a single
/// u8 lookup. Must stay in sync with the dispatch in `js/estree-adapter.js`'s
/// `get parent`.
pub const ParentKind = enum(u8) {
    none = 0,
    /// This node is the outermost optional in a chain — wrap parent NodeView
    /// in a synthetic ChainExpression. Tag is one of optional_member_expr /
    /// optional_computed_member_expr / optional_call_expr, and the direct
    /// parent (post grouping_expr skip) does not extend the chain by using
    /// this as object/callee.
    chain_expression = 1,
    /// Resolved parent is one of method_def / getter_def / setter_def /
    /// constructor_def / computed_method_def / computed_getter_def /
    /// computed_setter_def, and this node is NOT the method's key (lhs).
    /// JS returns the synthetic FunctionExpression (`parent.value`) instead.
    method_value = 2,
    /// Resolved parent is object_pattern and this node is assignment_pattern
    /// or identifier — JS synthesizes a Property wrapper around it.
    object_pattern_property = 3,
    /// Resolved parent is jsx_self_closing and this node is jsx_attribute or
    /// jsx_spread_attribute — JS synthesizes a JSXOpeningElement wrapper.
    jsx_opening_element = 4,
    /// Resolved parent is ts_enum_decl and this node is ts_enum_member — JS
    /// returns the synthetic TSEnumBody (cached on the parent NodeView).
    ts_enum_body = 5,
    /// Resolved parent is ts_interface_decl and this node is one of
    /// ts_method_signature / ts_property_signature / ts_call_signature /
    /// ts_construct_signature / ts_index_signature — JS returns the synthetic
    /// TSInterfaceBody (cached on the parent NodeView).
    ts_interface_body = 6,
    /// This node is a ts_type_parameter whose resolved parent owns a
    /// type_params SubRange. JS synthesizes a TSTypeParameterDeclaration
    /// wrapper around the SubRange and returns it as the parent.
    ts_type_parameter_declaration = 7,
    /// This block_stmt is from `declare global {}` (parent is root, no ts_module_decl wrapper).
    /// JS synthesizes TSModuleDeclaration{global:true} as the parent of this TSModuleBlock.
    ts_global_module_declaration = 8,
};

/// ESTree-shape type override IDs. Must stay in sync with `_OVERRIDE_TYPES`
/// in `js/estree-adapter.js`. Slot 0 is reserved to mean "no override".
pub const TypeOverride = enum(u8) {
    none = 0,
    private_identifier = 1,
    property = 2, // method_def inside object_literal/object_pattern
    ts_import_equals_declaration = 3,
    ts_module_block = 4,
    ts_literal_type = 5,
    ts_any_keyword = 6,
    ts_bigint_keyword = 7,
    ts_boolean_keyword = 8,
    ts_intrinsic_keyword = 9,
    ts_never_keyword = 10,
    ts_null_keyword = 11,
    ts_number_keyword = 12,
    ts_object_keyword = 13,
    ts_string_keyword = 14,
    ts_symbol_keyword = 15,
    ts_this_type = 16,
    ts_undefined_keyword = 17,
    ts_unknown_keyword = 18,
    ts_void_keyword = 19,
    ts_qualified_name = 20,
    /// `call_expr(ts_instantiation_expr(new_expr(callee,NONE),typeArgs),args)` —
    /// the canonical parse of `new Foo<T>()`. Present to rules as NewExpression.
    new_expression = 21,
    /// ES2024 auto-accessor class field (`accessor method = …`). Presented as
    /// AccessorProperty in ESTree, not PropertyDefinition.
    accessor_property = 22,
    /// Abstract class property (`abstract field: T`). Presented as
    /// TSAbstractPropertyDefinition in ESTree.
    ts_abstract_property_definition = 23,
    /// Abstract accessor class field (`abstract accessor field: T`). Presented as
    /// TSAbstractAccessorProperty in ESTree.
    ts_abstract_accessor_property = 24,
};

/// Called by Parser.addNode to record parent→child edges incrementally.
/// `extra` is the parser's extra_data at the time the node is finalized
/// (all children have already been appended to extra_data before addNode).
/// `idx` is the new node's own index (= the parent index for its children).
/// Compute resolved_parents and type_overrides given the parents array.
/// Independent of mintok/preorder/dfs — runs in parallel in
/// buildTraversalParallel().  Both are per-node loops over disjoint output
/// arrays; the only input is parents (read-only) plus tree fields.
pub fn buildTraversalAux(
    tree: *const Ast,
    alloc: std.mem.Allocator,
    parents: []const u32,
) !struct { resolved_parents: []u32, type_overrides: []u8, parent_kinds: []u8 } {
    const n = tree.nodes.len;
    const resolved_parents = try alloc.alloc(u32, n);
    const type_overrides = try alloc.alloc(u8, n);
    const parent_kinds = try alloc.alloc(u8, n);
    @memset(type_overrides, 0);
    @memset(parent_kinds, 0);

    if (n == 0) return .{ .resolved_parents = resolved_parents, .type_overrides = type_overrides, .parent_kinds = parent_kinds };

    const tags = tree.nodes.items(.tag);

    // Resolved parents — skip grouping_expr / ts_parenthesized_type ancestors.
    for (0..n) |i| {
        var p = parents[i];
        var guard: u32 = 0;
        // A `ts_type_parameter` whose parent chains through a sibling type_param
        // (es-parser links `<T, U>`'s `U` to `T`, not to the host) must resolve
        // past the siblings to the real generic host (arrow/method/fn/class/…).
        while (p != NONE and (tags[p] == .grouping_expr or tags[p] == .ts_parenthesized_type or
            (tags[i] == .ts_type_parameter and tags[p] == .ts_type_parameter)))
        {
            p = parents[p];
            guard += 1;
            if (guard > 64) { p = NONE; break; }
        }
        resolved_parents[i] = p;
    }

    // Type overrides — pre-bake JS adapter's `_computeNodeType` switch.
    const node_main_tokens = tree.nodes.items(.main_token);
    const data = tree.nodes.items(.data);
    const tok_starts = tree.tokens.items(.start);
    const tok_lens = tree.tokens.items(.len);
    const source = tree.source;
    for (0..n) |i| {
        switch (tags[i]) {
            .identifier, .property_ident => {
                const tok = node_main_tokens[i];
                const start = tok_starts[tok];
                if (start < source.len and source[start] == '#') {
                    type_overrides[i] = @intFromEnum(TypeOverride.private_identifier);
                }
                // `typeof Foo.Bar`: remap identifier's parent to the enclosing
                // ts_type_reference so `identifier.parent.type === "TSTypeReference"`.
                // @typescript-eslint/scope-manager excludes typeof-type refs from value
                // scope; this replicates the effect for ignoreTypeReferences: true.
                {
                    const rp = resolved_parents[i];
                    if (rp != NONE and (tags[rp] == .member_expr or tags[rp] == .computed_member_expr)) {
                        var cur = rp;
                        var g: u32 = 0;
                        while (g < 16) : (g += 1) {
                            const cp = parents[cur];
                            if (cp == NONE) break;
                            const cptag = tags[cp];
                            if (cptag == .member_expr or cptag == .computed_member_expr) {
                                cur = cp;
                                continue;
                            }
                            if (cptag == .ts_type_reference) {
                                const gp = parents[cp];
                                if (gp != NONE and (tags[gp] == .ts_typeof_type or tags[gp] == .ts_type_query)) {
                                    resolved_parents[i] = cp;
                                }
                            }
                            break;
                        }
                    }
                }
            },
            .method_def, .getter_def, .setter_def,
            .computed_method_def, .computed_getter_def, .computed_setter_def,
            => {
                // Class-body members are tagged identically to object-literal
                // properties in ez (method_def/getter_def/setter_def). ESTree
                // distinguishes them by node type: MethodDefinition in classes,
                // Property in object literals. Apply the type-override when the
                // parent is an object literal (or pattern) so rules like
                // accessor-pairs see node.value.parent.type === "Property".
                const p = parents[i];
                if (p != NONE) {
                    const ptag = tags[p];
                    if (ptag == .object_literal or ptag == .object_pattern) {
                        type_overrides[i] = @intFromEnum(TypeOverride.property);
                    }
                }
            },
            .import_decl => {
                if (data[i].lhs == .none and data[i].rhs != .none) {
                    type_overrides[i] = @intFromEnum(TypeOverride.ts_import_equals_declaration);
                }
            },
            .member_expr => {
                var cur_p = parents[i];
                while (cur_p != NONE) {
                    const cur_tag = tags[cur_p];
                    if (cur_tag == .ts_type_reference) {
                        // `typeof X.Y` encodes as ts_type_reference{member_expr} where
                        // ts_type_reference.parent = ts_typeof_type or ts_type_query.
                        // These expressions are NOT type names; don't remap to TSQualifiedName.
                        const gran_p = parents[cur_p];
                        const gran_is_typeof = gran_p != NONE and
                            (tags[gran_p] == .ts_typeof_type or tags[gran_p] == .ts_type_query);
                        if (!gran_is_typeof) {
                            type_overrides[i] = @intFromEnum(TypeOverride.ts_qualified_name);
                        }
                        break;
                    }
                    if (cur_tag != .member_expr) break;
                    cur_p = parents[cur_p];
                }
            },
            .block_stmt => {
                const p = parents[i];
                if (p != NONE) {
                    const ptag = tags[p];
                    if (ptag == .ts_namespace_decl or ptag == .ts_module_decl) {
                        type_overrides[i] = @intFromEnum(TypeOverride.ts_module_block);
                    } else if (ptag == .root) {
                        // `declare global {}` — es-parser emits block_stmt directly under root
                        // with no ts_module_decl wrapper. Detect by tokens before the `{`.
                        const tok = node_main_tokens[i];
                        if (tok >= 2) {
                            const gs = tok_starts[tok - 1];
                            const gl = tok_lens[tok - 1];
                            const ds = tok_starts[tok - 2];
                            const dl = tok_lens[tok - 2];
                            if (gs + gl <= source.len and ds + dl <= source.len and
                                std.mem.eql(u8, source[gs .. gs + gl], "global") and
                                std.mem.eql(u8, source[ds .. ds + dl], "declare"))
                            {
                                type_overrides[i] = @intFromEnum(TypeOverride.ts_module_block);
                                parent_kinds[i] = @intFromEnum(ParentKind.ts_global_module_declaration);
                            }
                        }
                    }
                }
            },
            .ts_type_reference => {
                if (data[i].rhs == .none) {
                    const tok = node_main_tokens[i];
                    const start = tok_starts[tok];
                    const len = tok_lens[tok];
                    if (start + len <= source.len) {
                        const text = source[start .. start + len];
                        if (computeTsTypeRefOverride(text)) |ov| {
                            type_overrides[i] = @intFromEnum(ov);
                        }
                    }
                }
            },
            // `new Foo<T>()` is parsed as call_expr(ts_instantiation_expr(new_expr(callee,NONE),typeArgs),args).
            // Present it to ESLint rules as NewExpression so callee-type checks pass.
            .call_expr => {
                const lhs = data[i].lhs;
                if (lhs != .none and tags[@intFromEnum(lhs)] == .ts_instantiation_expr) {
                    const inner = data[@intFromEnum(lhs)].lhs;
                    if (inner != .none and tags[@intFromEnum(inner)] == .new_expr and
                        data[@intFromEnum(inner)].rhs == .none)
                    {
                        type_overrides[i] = @intFromEnum(TypeOverride.new_expression);
                    }
                }
            },
            // ES2024 auto-accessor class field or abstract class property.
            // Scan backward from the property key through modifier tokens.
            .property_def, .computed_property_def => {
                const tok = node_main_tokens[i];
                var has_accessor = false;
                var has_abstract = false;
                var j: i32 = @as(i32, @intCast(tok)) - 1;
                while (j >= 0) : (j -= 1) {
                    const k = @as(usize, @intCast(j));
                    const ps = tok_starts[k];
                    const pl = tok_lens[k];
                    if (ps + pl > source.len) break;
                    const txt = source[ps..ps + pl];
                    if (std.mem.eql(u8, txt, "accessor")) { has_accessor = true; }
                    else if (std.mem.eql(u8, txt, "abstract")) { has_abstract = true; }
                    else if (std.mem.eql(u8, txt, "public") or
                             std.mem.eql(u8, txt, "private") or
                             std.mem.eql(u8, txt, "protected") or
                             std.mem.eql(u8, txt, "readonly") or
                             std.mem.eql(u8, txt, "static") or
                             std.mem.eql(u8, txt, "declare") or
                             std.mem.eql(u8, txt, "override")) {}
                    else { break; }
                }
                if (has_accessor and has_abstract) {
                    type_overrides[i] = @intFromEnum(TypeOverride.ts_abstract_accessor_property);
                } else if (has_accessor) {
                    type_overrides[i] = @intFromEnum(TypeOverride.accessor_property);
                } else if (has_abstract) {
                    type_overrides[i] = @intFromEnum(TypeOverride.ts_abstract_property_definition);
                }
            },
            else => {},
        }
    }

    // Parent-synthesis kinds — pre-bake the JS `get parent` post-resolve
    // dispatch. Determined entirely from (this.tag, resolved_parent.tag,
    // direct_parent.tag for chain detection, nodeLhs(parent)) — all static.
    {
        for (0..n) |i| {
            const rp = resolved_parents[i];
            if (rp == NONE) continue;
            const this_tag = tags[i];

            // Kind 1: ChainExpression wrap — this node is the outermost
            // optional in its chain. Uses DIRECT parent (post grouping_expr
            // skip only) per `_isChainChild` semantics in the JS adapter.
            //
            // Also fires for regular member_expr/call_expr/computed_member_expr
            // when their callee/object chain reaches an optional `?.`. ESLint
            // wraps the OUTERMOST node of the chain in ChainExpression — that
            // outermost node may be a regular call/member if the optional is
            // nested inside (e.g. `a?.b(c).d` — outer member_expr is the wrap).
            const is_optional_self = this_tag == .optional_member_expr or
                this_tag == .optional_computed_member_expr or
                this_tag == .optional_call_expr;
            var chain_contains_optional = is_optional_self;
            if (!is_optional_self and (this_tag == .member_expr or
                this_tag == .computed_member_expr or this_tag == .call_expr))
            {
                // Walk down the lhs chain looking for an optional_* node.
                // Do NOT walk through grouping_expr: parentheses break the chain.
                // `(a?.b).c` is NOT an optional chain — the outer member_expr
                // should not be wrapped in ChainExpression.
                var c = data[i].lhs;
                var cguard: u32 = 0;
                while (c != .none and cguard < 128) : (cguard += 1) {
                    const ci = c.toInt();
                    const ct = tags[ci];
                    if (ct == .optional_member_expr or ct == .optional_computed_member_expr or
                        ct == .optional_call_expr) { chain_contains_optional = true; break; }
                    if (ct == .member_expr or
                        ct == .computed_member_expr or ct == .call_expr)
                    { c = data[ci].lhs; continue; }
                    break;
                }
            }
            if (chain_contains_optional) {
                var dp = parents[i];
                var dguard: u32 = 0;
                while (dp != NONE and tags[dp] == .grouping_expr) {
                    dp = parents[dp];
                    dguard += 1;
                    if (dguard > 64) { dp = NONE; break; }
                }
                var is_chain_child = false;
                if (dp != NONE) {
                    const dpt = tags[dp];
                    const is_optional = dpt == .optional_member_expr or
                        dpt == .optional_computed_member_expr or
                        dpt == .optional_call_expr;
                    const is_middle = dpt == .member_expr or
                        dpt == .computed_member_expr or
                        dpt == .call_expr;
                    if ((is_optional or is_middle) and data[dp].lhs.toInt() == @as(u32, @intCast(i))) {
                        is_chain_child = true;
                    }
                }
                if (!is_chain_child) {
                    parent_kinds[i] = @intFromEnum(ParentKind.chain_expression);
                    continue;
                }
            }

            const pt = tags[rp];

            // Kind 2: method.value redirect — non-key child of a method-like.
            switch (pt) {
                .method_def, .getter_def, .setter_def, .constructor_def,
                .computed_method_def, .computed_getter_def, .computed_setter_def => {
                    // A method's type parameters are non-key children too, but
                    // they must become a TSTypeParameterDeclaration (kind 7
                    // below), NOT the method's value FunctionExpression.
                    if (this_tag != .ts_type_parameter and data[rp].lhs.toInt() != @as(u32, @intCast(i))) {
                        parent_kinds[i] = @intFromEnum(ParentKind.method_value);
                        continue;
                    }
                },
                .object_pattern => {
                    if (this_tag == .assignment_pattern or this_tag == .identifier) {
                        parent_kinds[i] = @intFromEnum(ParentKind.object_pattern_property);
                        continue;
                    }
                },
                .jsx_self_closing => {
                    if (this_tag == .jsx_attribute or this_tag == .jsx_spread_attribute) {
                        parent_kinds[i] = @intFromEnum(ParentKind.jsx_opening_element);
                        continue;
                    }
                },
                .ts_enum_decl => {
                    if (this_tag == .ts_enum_member) {
                        parent_kinds[i] = @intFromEnum(ParentKind.ts_enum_body);
                        continue;
                    }
                },
                .ts_interface_decl => {
                    if (this_tag == .ts_method_signature or
                        this_tag == .ts_property_signature or
                        this_tag == .ts_call_signature or
                        this_tag == .ts_construct_signature or
                        this_tag == .ts_index_signature)
                    {
                        parent_kinds[i] = @intFromEnum(ParentKind.ts_interface_body);
                        continue;
                    }
                },
                else => {},
            }

            // Kind 7: TSTypeParameterDeclaration wrap — all ts_type_parameter
            // nodes are inside a type_params SubRange of their resolved parent;
            // JS synthesizes the TSTypeParameterDeclaration wrapper.
            if (this_tag == .ts_type_parameter) {
                parent_kinds[i] = @intFromEnum(ParentKind.ts_type_parameter_declaration);
                continue;
            }
        }
    }

    return .{ .resolved_parents = resolved_parents, .type_overrides = type_overrides, .parent_kinds = parent_kinds };
}

/// Parallel variant of buildTraversal: spawns an aux sub-thread that runs
/// resolved_parents + type_overrides while this thread runs the
/// mintok→preorder→dfs chain.  Both finish in parallel; total wall time
/// drops from sum (8.84 ms on typescript.js) to max(core, aux) ≈ 6.0 ms.
///
pub fn buildTraversalParallel(
    tree: *const Ast,
    alloc: std.mem.Allocator,
) !TraversalResult {
    const n = tree.nodes.len;
    if (n == 0) return buildTraversal(tree, alloc);

    // Pre-allocate parents so aux can read it without extra sync.
    const parents = try alloc.alloc(u32, n);
    @memset(parents, NONE);
    {
        const tags  = tree.nodes.items(.tag);
        const data  = tree.nodes.items(.data);
        const extra = tree.extra_data;
        for (0..n) |i| {
            setChildParents(parents, extra, tags[i], data[i], @intCast(i));
        }
        var fi: usize = 0;
        while (fi + 1 < tree.parent_fixups.len) : (fi += 2) {
            const child = tree.parent_fixups[fi];
            if (child < n) parents[child] = tree.parent_fixups[fi + 1];
        }
    }

    const AuxJob = struct {
        tree: *const Ast,
        alloc: std.mem.Allocator,
        parents: []const u32,
        resolved_parents: []u32 = &.{},
        type_overrides: []u8 = &.{},
        parent_kinds: []u8 = &.{},
        err: ?anyerror = null,
        fn run(self: *@This()) void {
            if (buildTraversalAux(self.tree, self.alloc, self.parents)) |r| {
                self.resolved_parents = r.resolved_parents;
                self.type_overrides = r.type_overrides;
                self.parent_kinds = r.parent_kinds;
            } else |e| {
                self.err = e;
            }
        }
    };
    var aux_job: AuxJob = .{
        .tree = tree,
        .alloc = alloc,
        .parents = parents,
    };
    const aux_thread = std.Thread.spawn(.{}, AuxJob.run, .{&aux_job}) catch null;

    // Core path: postorder + mintok + preorder + dfs (parents already done).
    const pre_order = try alloc.alloc(u32, n);
    const post_order = try alloc.alloc(u32, n);
    const dfs_events = try alloc.alloc(i32, n * 2);

    for (1..n) |i| post_order[i - 1] = @intCast(i);
    post_order[n - 1] = 0;

    const min_tok = try alloc.alloc(u32, n);
    const main_tokens = tree.nodes.items(.main_token);
    @memcpy(min_tok, main_tokens[0..n]);

    const counts = try alloc.alloc(u32, tree.tokens.len + 1);
    defer alloc.free(counts);
    @memset(counts, 0);

    var max_min_tok: u32 = 0;
    for (1..n) |i| {
        const v = min_tok[i];
        max_min_tok = @max(max_min_tok, v);
        counts[v] += 1;
        const p = parents[i];
        if (p != NONE) min_tok[p] = @min(min_tok[p], v);
    }

    {
        var sum: u32 = 1;
        for (counts[0..max_min_tok + 1]) |*c| { const old = c.*; c.* = sum; sum += old; }
        pre_order[0] = 0;
        var ii: usize = n;
        while (ii > 1) {
            ii -= 1;
            const k = min_tok[ii];
            pre_order[counts[k]] = @intCast(ii);
            counts[k] += 1;
        }
    }

    // Parentless non-root nodes (parent == NONE) arise from error recovery and
    // from a few parser setChildParents gaps (e.g. some TS type annotations).
    // They must still be visited — rules that don't touch `.parent` rely on it —
    // but a null `node.parent` crashes the ones that do (`node.parent.type`). So
    // we emit each under the current DFS stack top and ADOPT that node as its
    // parent: a real, non-null parent matching its position in the tree. The
    // adopted list is fixed up in resolved_parents after the aux join below
    // (aux may have already computed resolved_parents[orphan] from the old NONE).
    const adopted = try alloc.alloc(u32, n);
    var adopted_len: usize = 0;
    {
        const stk = try alloc.alloc(u32, n);
        defer alloc.free(stk);
        var stk_top: usize = 0;
        var ei: u32 = 0;
        for (pre_order) |node| {
            const parent = parents[node];
            if (parent != NONE) {
                while (stk_top > 0 and parent != stk[stk_top - 1]) {
                    stk_top -= 1;
                    dfs_events[ei] = ~@as(i32, @intCast(stk[stk_top]));
                    ei += 1;
                }
            } else if (node != 0 and stk_top > 0) {
                parents[node] = stk[stk_top - 1];
                adopted[adopted_len] = node;
                adopted_len += 1;
            }
            dfs_events[ei] = @intCast(node);
            ei += 1;
            stk[stk_top] = node;
            stk_top += 1;
        }
        while (stk_top > 0) {
            stk_top -= 1;
            dfs_events[ei] = ~@as(i32, @intCast(stk[stk_top]));
            ei += 1;
        }
    }

    if (aux_thread) |t| {
        t.join();
        if (aux_job.err) |e| return e;
    } else {
        // Fallback: aux runs synchronously here.
        const r = try buildTraversalAux(tree, alloc, parents);
        aux_job.resolved_parents = r.resolved_parents;
        aux_job.type_overrides = r.type_overrides;
        aux_job.parent_kinds = r.parent_kinds;
    }

    // Re-resolve resolved_parents for adopted orphans: aux ran in parallel and
    // may have read parents[orphan] == NONE before adoption set it above.
    if (adopted_len > 0) {
        const tags = tree.nodes.items(.tag);
        for (adopted[0..adopted_len]) |orphan| {
            var p = parents[orphan];
            var guard: u32 = 0;
            while (p != NONE and (tags[p] == .grouping_expr or tags[p] == .ts_parenthesized_type or
                (tags[orphan] == .ts_type_parameter and tags[p] == .ts_type_parameter)))
            {
                p = parents[p];
                guard += 1;
                if (guard > 64) { p = NONE; break; }
            }
            aux_job.resolved_parents[orphan] = p;
        }
    }
    alloc.free(adopted);

    return .{
        .parents = parents,
        .pre_order = pre_order,
        .post_order = post_order,
        .dfs_events = dfs_events,
        .min_tok = min_tok,
        .resolved_parents = aux_job.resolved_parents,
        .type_overrides = aux_job.type_overrides,
        .parent_kinds = aux_job.parent_kinds,
    };
}

pub fn buildTraversal(tree: *const Ast, alloc: std.mem.Allocator) !TraversalResult {
    const n = tree.nodes.len;
    const parents    = try alloc.alloc(u32, n);
    const pre_order  = try alloc.alloc(u32, n);
    const post_order = try alloc.alloc(u32, n);
    const dfs_events = try alloc.alloc(i32, n * 2);

    if (n == 0) {
        const empty_min_tok = try alloc.alloc(u32, 0);
        const empty_resolved = try alloc.alloc(u32, 0);
        const empty_type_ov = try alloc.alloc(u8, 0);
        const empty_parent_kinds = try alloc.alloc(u8, 0);
        return .{ .parents = parents, .pre_order = pre_order, .post_order = post_order, .dfs_events = dfs_events, .min_tok = empty_min_tok, .resolved_parents = empty_resolved, .type_overrides = empty_type_ov, .parent_kinds = empty_parent_kinds };
    }

    // Post-order: trivial (bottom-up build → always [1..n-1, 0]).
    for (1..n) |i| post_order[i - 1] = @intCast(i);
    post_order[n - 1] = 0;

    // ── Step 1: Parents ────────────────────────────────────────────────────────
    @memset(parents, NONE);
    {
        const tags  = tree.nodes.items(.tag);
        const data  = tree.nodes.items(.data);
        const extra = tree.extra_data;
        for (0..n) |i| {
            setChildParents(parents, extra, tags[i], data[i], @intCast(i));
        }
        var fi: usize = 0;
        while (fi + 1 < tree.parent_fixups.len) : (fi += 2) {
            const child = tree.parent_fixups[fi];
            if (child < n) parents[child] = tree.parent_fixups[fi + 1];
        }
    }

    // ── Step 2+3a: min_tok forward pass + counting (fused) ───────────────────
    // min_tok[i] is final at iteration i (all children j<i have propagated).
    const min_tok = try alloc.alloc(u32, n);
    const main_tokens = tree.nodes.items(.main_token);
    @memcpy(min_tok, main_tokens[0..n]);

    // Pre-allocate counts using token count (safe upper bound for any min_tok value).
    const counts = try alloc.alloc(u32, tree.tokens.len + 1);
    defer alloc.free(counts);
    @memset(counts, 0);

    var max_min_tok: u32 = 0;
    for (1..n) |i| {
        const v = min_tok[i];
        max_min_tok = @max(max_min_tok, v);
        counts[v] += 1;
        const p = parents[i];
        if (p != NONE) min_tok[p] = @min(min_tok[p], v);
    }

    // ── Step 3b: Counting sort prefix sum + scatter → pre_order ──────────────
    // Root (idx 0) always goes first.  For non-root nodes, descending-index
    // placement within each bucket gives parent (higher idx) before child.
    {
        var sum: u32 = 1; // position 0 reserved for root
        for (counts[0..max_min_tok + 1]) |*c| { const old = c.*; c.* = sum; sum += old; }
        pre_order[0] = 0;
        var ii: usize = n;
        while (ii > 1) {
            ii -= 1;
            const k = min_tok[ii];
            pre_order[counts[k]] = @intCast(ii);
            counts[k] += 1;
        }
    }

    // ── Step 4: dfs_events via ancestor-stack walk ────────────────────────────
    // Parentless non-root nodes (parent == NONE) come from error recovery and a
    // few parser setChildParents gaps. They stay visible to rule visitors (rules
    // that don't touch `.parent` rely on it), but a null `node.parent` crashes
    // those that do. We emit each under the current DFS stack top and ADOPT that
    // node as its parent — a real, non-null parent matching tree position. Step 5
    // below recomputes resolved_parents from this updated parents[] array.
    {
        // Raw slice stack avoids ArrayList overhead (capacity checks, optional unwrapping).
        const stk = try alloc.alloc(u32, n);
        defer alloc.free(stk);
        var stk_top: usize = 0;
        var ei: u32 = 0;
        for (pre_order) |node| {
            const parent = parents[node];
            // Pop the stack until this node's parent is on top, emitting exit
            // events for the popped ancestors.
            if (parent != NONE) {
                while (stk_top > 0 and parent != stk[stk_top - 1]) {
                    stk_top -= 1;
                    dfs_events[ei] = ~@as(i32, @intCast(stk[stk_top]));
                    ei += 1;
                }
            } else if (node != 0 and stk_top > 0) {
                parents[node] = stk[stk_top - 1];
            }
            dfs_events[ei] = @intCast(node);
            ei += 1;
            stk[stk_top] = node;
            stk_top += 1;
        }
        while (stk_top > 0) {
            stk_top -= 1;
            dfs_events[ei] = ~@as(i32, @intCast(stk[stk_top]));
            ei += 1;
        }
    }

    // ── Resolved parents (post grouping_expr / ts_parenthesized_type skip) ─
    // JS-side `nodeView` transparently unwraps grouping_expr and
    // ts_parenthesized_type, so the ESTree-visible parent of a node whose
    // direct parent is a grouping_expr is the grouping's own parent. The JS
    // `get parent` slow path used to walk this chain on every first access;
    // pre-baking it here turns that walk into a single typed-array read.
    const resolved_parents = try alloc.alloc(u32, n);
    {
        const tags = tree.nodes.items(.tag);
        for (0..n) |i| {
            var p = parents[i];
            var guard: u32 = 0;
            while (p != NONE and (tags[p] == .grouping_expr or tags[p] == .ts_parenthesized_type or
                (tags[i] == .ts_type_parameter and tags[p] == .ts_type_parameter)))
            {
                p = parents[p];
                guard += 1;
                if (guard > 64) { p = NONE; break; }
            }
            resolved_parents[i] = p;
        }
    }

    // ── Type overrides (ESTree-shape `type` disambiguation) ────────────────
    // Pre-bake the result of JS-side `_computeNodeType` into a u8 per node so
    // the JS adapter skips its per-node switch + token-text matching. Slot 0
    // means "no override; use TAG_NAMES[tag]" (the common case).
    const type_overrides = try alloc.alloc(u8, n);
    @memset(type_overrides, 0);
    {
        const tags = tree.nodes.items(.tag);
        const node_main_tokens = tree.nodes.items(.main_token);
        const data = tree.nodes.items(.data);
        const tok_starts = tree.tokens.items(.start);
        const tok_lens = tree.tokens.items(.len);
        const source = tree.source;
        for (0..n) |i| {
            switch (tags[i]) {
                .identifier, .property_ident => {
                    const tok = node_main_tokens[i];
                    const start = tok_starts[tok];
                    if (start < source.len and source[start] == '#') {
                        type_overrides[i] = @intFromEnum(TypeOverride.private_identifier);
                    }
                    // `typeof Foo.Bar`: remap identifier's parent to the enclosing
                    // ts_type_reference so `identifier.parent.type === "TSTypeReference"`.
                    {
                        const rp = resolved_parents[i];
                        if (rp != NONE and (tags[rp] == .member_expr or tags[rp] == .computed_member_expr)) {
                            var cur = rp;
                            var g: u32 = 0;
                            while (g < 16) : (g += 1) {
                                const cp = parents[cur];
                                if (cp == NONE) break;
                                const cptag = tags[cp];
                                if (cptag == .member_expr or cptag == .computed_member_expr) {
                                    cur = cp;
                                    continue;
                                }
                                if (cptag == .ts_type_reference) {
                                    const gp = parents[cp];
                                    if (gp != NONE and (tags[gp] == .ts_typeof_type or tags[gp] == .ts_type_query)) {
                                        resolved_parents[i] = cp;
                                    }
                                }
                                break;
                            }
                        }
                    }
                },
                .method_def, .getter_def, .setter_def,
                .computed_method_def, .computed_getter_def, .computed_setter_def,
                => {
                    // Same as the streaming-path arm above: getters/setters in
                    // object literals are Property nodes, not MethodDefinitions.
                    const p = parents[i];
                    if (p != NONE) {
                        const ptag = tags[p];
                        if (ptag == .object_literal or ptag == .object_pattern) {
                            type_overrides[i] = @intFromEnum(TypeOverride.property);
                        }
                    }
                },
                .import_decl => {
                    if (data[i].lhs == .none and data[i].rhs != .none) {
                        type_overrides[i] = @intFromEnum(TypeOverride.ts_import_equals_declaration);
                    }
                },
                .member_expr => {
                    // A member_expr chain inside ts_type_reference is a TSQualifiedName
                    // (e.g. `NS.Foo` in `let x: NS.Foo`). Walk up through member_expr
                    // ancestors to check if the chain is rooted in a ts_type_reference.
                    var cur_p = parents[i];
                    while (cur_p != NONE) {
                        const cur_tag = tags[cur_p];
                        if (cur_tag == .ts_type_reference) {
                            // `typeof X.Y` encodes as ts_type_reference{member_expr} where
                            // ts_type_reference.parent = ts_typeof_type or ts_type_query.
                            const gran_p = parents[cur_p];
                            const gran_is_typeof2 = gran_p != NONE and
                                (tags[gran_p] == .ts_typeof_type or tags[gran_p] == .ts_type_query);
                            if (!gran_is_typeof2) {
                                type_overrides[i] = @intFromEnum(TypeOverride.ts_qualified_name);
                            }
                            break;
                        }
                        if (cur_tag != .member_expr) break;
                        cur_p = parents[cur_p];
                    }
                },
                .block_stmt => {
                    const p = parents[i];
                    if (p != NONE) {
                        const ptag = tags[p];
                        if (ptag == .ts_namespace_decl or ptag == .ts_module_decl) {
                            type_overrides[i] = @intFromEnum(TypeOverride.ts_module_block);
                        } else if (ptag == .root) {
                            const tok = node_main_tokens[i];
                            if (tok >= 2) {
                                const gs = tok_starts[tok - 1];
                                const gl = tok_lens[tok - 1];
                                const ds = tok_starts[tok - 2];
                                const dl = tok_lens[tok - 2];
                                if (gs + gl <= source.len and ds + dl <= source.len and
                                    std.mem.eql(u8, source[gs .. gs + gl], "global") and
                                    std.mem.eql(u8, source[ds .. ds + dl], "declare"))
                                {
                                    type_overrides[i] = @intFromEnum(TypeOverride.ts_module_block);
                                }
                            }
                        }
                    }
                },
                .ts_type_reference => {
                    if (data[i].rhs == .none) {
                        const tok = node_main_tokens[i];
                        const start = tok_starts[tok];
                        const len = tok_lens[tok];
                        if (start + len <= source.len) {
                            const text = source[start .. start + len];
                            if (computeTsTypeRefOverride(text)) |ov| {
                                type_overrides[i] = @intFromEnum(ov);
                            }
                        }
                    }
                },
                // `new Foo<T>()` is parsed as call_expr(ts_instantiation_expr(new_expr(callee,NONE),typeArgs),args).
                // Present it to ESLint rules as NewExpression so callee-type checks pass.
                .call_expr => {
                    const lhs = data[i].lhs;
                    if (lhs != .none and tags[@intFromEnum(lhs)] == .ts_instantiation_expr) {
                        const inner = data[@intFromEnum(lhs)].lhs;
                        if (inner != .none and tags[@intFromEnum(inner)] == .new_expr and
                            data[@intFromEnum(inner)].rhs == .none)
                        {
                            type_overrides[i] = @intFromEnum(TypeOverride.new_expression);
                        }
                    }
                },
                // ES2024 auto-accessor class field or abstract class property.
                .property_def, .computed_property_def => {
                    const tok = node_main_tokens[i];
                    var has_accessor = false;
                    var has_abstract = false;
                    var j: i32 = @as(i32, @intCast(tok)) - 1;
                    while (j >= 0) : (j -= 1) {
                        const k = @as(usize, @intCast(j));
                        const ps = tok_starts[k];
                        const pl = tok_lens[k];
                        if (ps + pl > source.len) break;
                        const txt = source[ps..ps + pl];
                        if (std.mem.eql(u8, txt, "accessor")) { has_accessor = true; }
                        else if (std.mem.eql(u8, txt, "abstract")) { has_abstract = true; }
                        else if (std.mem.eql(u8, txt, "public") or
                                 std.mem.eql(u8, txt, "private") or
                                 std.mem.eql(u8, txt, "protected") or
                                 std.mem.eql(u8, txt, "readonly") or
                                 std.mem.eql(u8, txt, "static") or
                                 std.mem.eql(u8, txt, "declare") or
                                 std.mem.eql(u8, txt, "override")) {}
                        else { break; }
                    }
                    if (has_accessor and has_abstract) {
                        type_overrides[i] = @intFromEnum(TypeOverride.ts_abstract_accessor_property);
                    } else if (has_accessor) {
                        type_overrides[i] = @intFromEnum(TypeOverride.accessor_property);
                    } else if (has_abstract) {
                        type_overrides[i] = @intFromEnum(TypeOverride.ts_abstract_property_definition);
                    }
                },
                else => {},
            }
        }
    }

    // ── Parent-synthesis kinds ─────────────────────────────────────────────
    // Pre-bake the JS `get parent` post-resolve dispatch (see ParentKind).
    const parent_kinds = try alloc.alloc(u8, n);
    @memset(parent_kinds, 0);
    {
        const tags = tree.nodes.items(.tag);
        const data = tree.nodes.items(.data);
        for (0..n) |i| {
            const rp = resolved_parents[i];
            if (rp == NONE) continue;
            const this_tag = tags[i];

            // Mirror of the kind=1 detection in the streaming arm above.
            const is_optional_self_p = this_tag == .optional_member_expr or
                this_tag == .optional_computed_member_expr or
                this_tag == .optional_call_expr;
            var chain_contains_optional_p = is_optional_self_p;
            if (!is_optional_self_p and (this_tag == .member_expr or
                this_tag == .computed_member_expr or this_tag == .call_expr))
            {
                var c2 = data[i].lhs;
                var cguard2: u32 = 0;
                while (c2 != .none and cguard2 < 128) : (cguard2 += 1) {
                    const ci2 = c2.toInt();
                    const ct2 = tags[ci2];
                    if (ct2 == .optional_member_expr or ct2 == .optional_computed_member_expr or
                        ct2 == .optional_call_expr) { chain_contains_optional_p = true; break; }
                    // Do NOT walk through grouping_expr: parentheses break the chain.
                    if (ct2 == .member_expr or
                        ct2 == .computed_member_expr or ct2 == .call_expr)
                    { c2 = data[ci2].lhs; continue; }
                    break;
                }
            }
            if (chain_contains_optional_p) {
                var dp = parents[i];
                var dguard: u32 = 0;
                while (dp != NONE and tags[dp] == .grouping_expr) {
                    dp = parents[dp];
                    dguard += 1;
                    if (dguard > 64) { dp = NONE; break; }
                }
                var is_chain_child = false;
                if (dp != NONE) {
                    const dpt = tags[dp];
                    const is_optional = dpt == .optional_member_expr or
                        dpt == .optional_computed_member_expr or
                        dpt == .optional_call_expr;
                    const is_middle = dpt == .member_expr or
                        dpt == .computed_member_expr or
                        dpt == .call_expr;
                    if ((is_optional or is_middle) and data[dp].lhs.toInt() == @as(u32, @intCast(i))) {
                        is_chain_child = true;
                    }
                }
                if (!is_chain_child) {
                    parent_kinds[i] = @intFromEnum(ParentKind.chain_expression);
                    continue;
                }
            }

            const pt = tags[rp];
            switch (pt) {
                .method_def, .getter_def, .setter_def, .constructor_def,
                .computed_method_def, .computed_getter_def, .computed_setter_def => {
                    // A method's type parameters are non-key children too, but
                    // they must become a TSTypeParameterDeclaration (kind 7
                    // below), NOT the method's value FunctionExpression.
                    if (this_tag != .ts_type_parameter and data[rp].lhs.toInt() != @as(u32, @intCast(i))) {
                        parent_kinds[i] = @intFromEnum(ParentKind.method_value);
                        continue;
                    }
                },
                .object_pattern => {
                    if (this_tag == .assignment_pattern or this_tag == .identifier) {
                        parent_kinds[i] = @intFromEnum(ParentKind.object_pattern_property);
                        continue;
                    }
                },
                .jsx_self_closing => {
                    if (this_tag == .jsx_attribute or this_tag == .jsx_spread_attribute) {
                        parent_kinds[i] = @intFromEnum(ParentKind.jsx_opening_element);
                        continue;
                    }
                },
                .ts_enum_decl => {
                    if (this_tag == .ts_enum_member) {
                        parent_kinds[i] = @intFromEnum(ParentKind.ts_enum_body);
                        continue;
                    }
                },
                .ts_interface_decl => {
                    if (this_tag == .ts_method_signature or
                        this_tag == .ts_property_signature or
                        this_tag == .ts_call_signature or
                        this_tag == .ts_construct_signature or
                        this_tag == .ts_index_signature)
                    {
                        parent_kinds[i] = @intFromEnum(ParentKind.ts_interface_body);
                        continue;
                    }
                },
                else => {},
            }

            if (this_tag == .ts_type_parameter) {
                parent_kinds[i] = @intFromEnum(ParentKind.ts_type_parameter_declaration);
                continue;
            }
            // Kind 8: declare global {} — block_stmt under root tagged as TSModuleBlock,
            // synthesize TSModuleDeclaration{global:true} as its parent.
            if (this_tag == .block_stmt and
                type_overrides[i] == @intFromEnum(TypeOverride.ts_module_block) and
                tags[rp] == .root)
            {
                parent_kinds[i] = @intFromEnum(ParentKind.ts_global_module_declaration);
                continue;
            }
        }
    }

    return .{ .parents = parents, .pre_order = pre_order, .post_order = post_order, .dfs_events = dfs_events, .min_tok = min_tok, .resolved_parents = resolved_parents, .type_overrides = type_overrides, .parent_kinds = parent_kinds };
}

/// Match a TSTypeReference's main-token text against TS keyword type names
/// and literal-type sigils, returning the corresponding override slot.
/// Mirrors the `_TS_KW_TYPES` table + literal sigil checks in the JS adapter.
fn computeTsTypeRefOverride(text: []const u8) ?TypeOverride {
    if (text.len == 0) return null;
    // Whitespace trim is unnecessary here — main-token text is already
    // trimmed by the lexer for identifier/keyword tokens.
    const TsKw = struct { name: []const u8, ov: TypeOverride };
    const kws = [_]TsKw{
        .{ .name = "any", .ov = .ts_any_keyword },
        .{ .name = "bigint", .ov = .ts_bigint_keyword },
        .{ .name = "boolean", .ov = .ts_boolean_keyword },
        .{ .name = "intrinsic", .ov = .ts_intrinsic_keyword },
        .{ .name = "never", .ov = .ts_never_keyword },
        .{ .name = "null", .ov = .ts_null_keyword },
        .{ .name = "number", .ov = .ts_number_keyword },
        .{ .name = "object", .ov = .ts_object_keyword },
        .{ .name = "string", .ov = .ts_string_keyword },
        .{ .name = "symbol", .ov = .ts_symbol_keyword },
        .{ .name = "this", .ov = .ts_this_type },
        .{ .name = "undefined", .ov = .ts_undefined_keyword },
        .{ .name = "unknown", .ov = .ts_unknown_keyword },
        .{ .name = "void", .ov = .ts_void_keyword },
    };
    for (kws) |kw| {
        if (std.mem.eql(u8, text, kw.name)) return kw.ov;
    }
    // Literal-type sigils: matches JS `text.charCodeAt(0)` checks for
    // string/template/numeric/boolean/negative-numeric literal type refs.
    const c = text[0];
    if (c == '\'' or c == '"' or c == '`' or (c >= '0' and c <= '9') or c == '-') {
        return .ts_literal_type;
    }
    if (std.mem.eql(u8, text, "true") or std.mem.eql(u8, text, "false")) {
        return .ts_literal_type;
    }
    return null;
}
