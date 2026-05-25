// HAND-WRITTEN — type-aware rule.
// Rule: @typescript-eslint/prefer-readonly-parameter-types
//
// For each function-like (fn_decl/fn_expr/arrow/method/sig/...) parameter,
// classify the resolved type as "deeply readonly" or not.  Mutable
// arrays, tuples, or objects with writable members → `shouldBeReadonly`.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const tymod = @import("../../../checker/types.zig");
const TypeId = tymod.TypeId;

pub const meta = RuleMeta{
    .name = "prefer-readonly-parameter-types",
    .category = .style,
    .default_severity = .warning,
    .description = "Suggest readonly types for function parameters",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{
    .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
    .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
    .arrow_fn, .async_arrow_fn,
    .method_def, .computed_method_def, .constructor_def,
    .ts_method_signature, .ts_call_signature, .ts_construct_signature,
    .ts_declare_function,
    .ts_function_type, .ts_constructor_type,
};

pub const needs_semantic = true;

const Options = struct {
    treat_methods_as_readonly: bool = false,
    ignore_inferred_types: bool = false,
    check_parameter_properties: bool = true,
    allow: ?*const std.json.Value = null,
};

fn readOptions(ctx: *const LintContext) Options {
    var opts = Options{};
    const v = ctx.rule_options orelse return opts;
    if (v.* != .object) return opts;
    if (v.object.get("treatMethodsAsReadonly")) |x| if (x == .bool) {
        opts.treat_methods_as_readonly = x.bool;
    };
    if (v.object.get("ignoreInferredTypes")) |x| if (x == .bool) {
        opts.ignore_inferred_types = x.bool;
    };
    if (v.object.get("checkParameterProperties")) |x| if (x == .bool) {
        opts.check_parameter_properties = x.bool;
    };
    if (v.object.getPtr("allow")) |a| {
        if (a.* == .array) opts.allow = a;
    }
    return opts;
}

fn nameMatchesAllow(name: []const u8, opts: Options, ctx: *const LintContext) bool {
    const allow = opts.allow orelse return false;
    if (allow.* != .array) return false;
    for (allow.array.items) |item| {
        switch (item) {
            .string => |s| if (std.mem.eql(u8, s, name)) return true,
            .object => {
                // Match the name first (string or string[]).
                const n = item.object.get("name") orelse continue;
                var name_ok = false;
                switch (n) {
                    .string => |s| name_ok = std.mem.eql(u8, s, name),
                    .array => {
                        for (n.array.items) |sn| {
                            if (sn == .string and std.mem.eql(u8, sn.string, name)) {
                                name_ok = true;
                                break;
                            }
                        }
                    },
                    else => {},
                }
                if (!name_ok) continue;
                // `from` distinguishes types declared in file vs lib vs
                // package.  We can only verify "file" (the source we're
                // linting) — "lib"/"package" point at sources we don't
                // model.  Conservatively skip non-file allows so the
                // rule still fires when oracle expects it.
                if (item.object.get("from")) |from| {
                    if (from == .string) {
                        const from_s = from.string;
                        if (std.mem.eql(u8, from_s, "file")) {
                            // `from: "file"` with a specific `path` would
                            // need path comparison; skip to be conservative.
                            if (item.object.get("path") != null) continue;
                            // For "file", the name must refer to a
                            // type declared in this file.
                            if (ctx.typeDeclNode(name) == .none) continue;
                        } else if (std.mem.eql(u8, from_s, "lib")) {
                            // "lib" types are TS built-ins — match only
                            // when the name doesn't resolve to a local
                            // declaration in this file.
                            if (ctx.typeDeclNode(name) != .none) continue;
                        } else if (std.mem.eql(u8, from_s, "package")) {
                            // We can't verify a type's package origin.
                            // Always skip so the rule still fires when
                            // the user expects it (oracle treats the
                            // package source as unverifiable too).
                            continue;
                        }
                    }
                }
                return true;
            },
            else => {},
        }
    }
    return false;
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    if (!ctx.hasTypeChecker()) return;
    const opts = readOptions(ctx);
    const tag = ctx.nodeTag(node);
    const d = ctx.nodeData(node);
    var params_start: u32 = 0;
    var params_end: u32 = 0;
    switch (tag) {
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .ts_declare_function, .ts_function_type, .ts_constructor_type => {
            if (d.lhs == .none) return;
            const fd = ctx.extraData(ast.FnData, @intFromEnum(d.lhs));
            params_start = fd.params;
            params_end = fd.params_end;
        },
        .arrow_fn, .async_arrow_fn => {
            if (d.lhs == .none) return;
            const ad = ctx.extraData(ast.ArrowData, @intFromEnum(d.lhs));
            params_start = ad.params_start;
            params_end = ad.params_end;
        },
        .method_def, .computed_method_def, .constructor_def => {
            if (d.rhs == .none) return;
            const meth = ctx.extraData(ast.MethodData, @intFromEnum(d.rhs));
            params_start = meth.params_start;
            params_end = meth.params_end;
        },
        .ts_method_signature, .ts_call_signature, .ts_construct_signature => {
            if (d.lhs == .none) return;
            const sd = ctx.extraData(ast.InterfaceSigData, @intFromEnum(d.lhs));
            params_start = sd.params_start;
            params_end = sd.params_end;
        },
        else => return,
    }

    if (params_end <= params_start) return;
    if (params_end > ctx.ast.extra_data.len) return;
    for (ctx.ast.extra_data[params_start..params_end]) |raw| {
        const p: NodeIndex = @enumFromInt(raw);
        checkParam(p, opts, ctx);
    }
}

fn checkParam(param: NodeIndex, opts: Options, ctx: *const LintContext) void {
    var n = param;
    if (ctx.nodeTag(n) == .ts_parameter_property) {
        if (!opts.check_parameter_properties) return;
        n = ctx.nodeData(n).lhs;
    }
    if (ctx.nodeTag(n) == .assignment_pattern) {
        n = ctx.nodeData(n).lhs;
    }
    if (ctx.nodeTag(n) == .rest_element) {
        n = ctx.nodeData(n).lhs;
    }
    // The binding must have an annotation for the rule to apply (unless
    // ignoreInferredTypes — then bind to inferred type, but we don't have
    // reliable inferred function-context type here, so respect the
    // annotation either way).
    if (ctx.nodeTag(n) != .identifier) return;
    const ann = ctx.nodeData(n).rhs;
    if (ann == .none) {
        if (opts.ignore_inferred_types) return;
        return; // no annotation; nothing reliable to check
    }
    var ty_node = ann;
    if (ctx.nodeTag(ty_node) == .ts_type_annotation) ty_node = ctx.nodeData(ty_node).lhs;
    // Prefer syntactic AST inspection — type-resolution discards
    // readonly modifiers on most paths.
    if (typeNodeIsDeeplyReadonly(ty_node, opts, ctx, 0)) return;
    // ts-eslint reports the parameter Identifier whose ESTree range
    // includes the typeAnnotation child.  Our identifier node ends at
    // the name; extend to the end of the annotation node.
    // ts-eslint anchors on the INNER binding identifier, not the
    // parameter-property wrapper, so the modifier (`private`,
    // `readonly`, ...) isn't included in the diagnostic range.
    const ps = ctx.nodeSpan(n);
    const ts = ctx.nodeSpan(ty_node);
    ctx.reportSpanWithMessageId(.{ .start = ps.start, .end = ts.end }, "shouldBeReadonly");
}

/// Walk a TS type-annotation AST node, checking that every nested
/// array/tuple/object is readonly.
fn typeNodeIsDeeplyReadonly(node: NodeIndex, opts: Options, ctx: *const LintContext, depth: u32) bool {
    if (node == .none or depth > 16) return true;
    const tag = ctx.nodeTag(node);
    const d = ctx.nodeData(node);
    // Bail safely on deep self-recursive types — return true so a
    // user-declared recursive interface like `{ readonly prop: Foo }`
    // doesn't FP at the depth limit.
    if (depth > 14) return true;
    switch (tag) {
        .ts_parenthesized_type => return typeNodeIsDeeplyReadonly(d.lhs, opts, ctx, depth + 1),
        .ts_type_annotation => return typeNodeIsDeeplyReadonly(d.lhs, opts, ctx, depth + 1),
        .ts_array_type => return false, // T[] is mutable
        .ts_tuple_type => return false, // mutable tuple
        .ts_keyof_type => {
            // Repurposed as `readonly T[]` / `readonly [...]` when
            // main_token text is "readonly".
            const op_tok = ctx.nodeMainToken(node);
            const op_text = ctx.tokenText(op_tok);
            if (std.mem.eql(u8, op_text, "readonly")) {
                // The element-or-tuple inside.
                const inner = d.lhs;
                if (ctx.nodeTag(inner) == .ts_array_type) {
                    return typeNodeIsDeeplyReadonly(ctx.nodeData(inner).lhs, opts, ctx, depth + 1);
                }
                if (ctx.nodeTag(inner) == .ts_tuple_type) {
                    return tupleElementsReadonly(inner, opts, ctx, depth + 1);
                }
                return true;
            }
            return true; // keyof T → string keys; no nested mutability
        },
        .ts_union_type => {
            const s = @intFromEnum(d.lhs);
            const e = @intFromEnum(d.rhs);
            if (e > s and e <= ctx.ast.extra_data.len) {
                for (ctx.ast.extra_data[s..e]) |raw| {
                    const m: NodeIndex = @enumFromInt(raw);
                    if (!typeNodeIsDeeplyReadonly(m, opts, ctx, depth + 1)) return false;
                }
            }
            return true;
        },
        .ts_intersection_type => {
            // Brand-style intersections (`string & {__tag}`) are
            // readonly when the primitive member is present — the
            // brand objects are markers and don't introduce mutation.
            const s = @intFromEnum(d.lhs);
            const e = @intFromEnum(d.rhs);
            if (e > s and e <= ctx.ast.extra_data.len) {
                var has_primitive = false;
                for (ctx.ast.extra_data[s..e]) |raw| {
                    const m: NodeIndex = @enumFromInt(raw);
                    if (typeNodeIsPrimitive(m, ctx)) { has_primitive = true; break; }
                }
                if (has_primitive) return true;
                for (ctx.ast.extra_data[s..e]) |raw| {
                    const m: NodeIndex = @enumFromInt(raw);
                    if (!typeNodeIsDeeplyReadonly(m, opts, ctx, depth + 1)) return false;
                }
            }
            return true;
        },
        .ts_type_reference => {
            // Inspect the name and (if generic) the type args.
            const name_node = d.lhs;
            const name = if (name_node != .none) ctx.tokenText(ctx.nodeMainToken(name_node)) else &.{};
            if (nameMatchesAllow(name, opts, ctx)) return true;
            // Readonly<X> / ReadonlyArray<X> / ReadonlySet<X> /
            // ReadonlyMap<K,V> — outer wrapper enforces readonly at
            // depth 1; check that the argument's INNER (next level)
            // types are themselves deeply readonly.
            if (std.mem.eql(u8, name, "Readonly") or
                std.mem.eql(u8, name, "ReadonlyArray") or
                std.mem.eql(u8, name, "ReadonlySet") or
                std.mem.eql(u8, name, "ReadonlyMap"))
            {
                if (d.rhs == .none) return true;
                const sr = ctx.extraData(ast.SubRange, @intFromEnum(d.rhs));
                if (sr.start < sr.end and sr.end <= ctx.ast.extra_data.len) {
                    for (ctx.ast.extra_data[sr.start..sr.end]) |raw| {
                        const arg: NodeIndex = @enumFromInt(raw);
                        if (!innerOfReadonlyOk(arg, opts, ctx, depth + 1)) return false;
                    }
                }
                return true;
            }
            // Mutable built-in generics.
            if (isMutableBuiltin(name)) return false;
            // Built-in primitives / common readonly classes are leaf-readonly.
            if (std.mem.eql(u8, name, "string") or
                std.mem.eql(u8, name, "number") or
                std.mem.eql(u8, name, "boolean") or
                std.mem.eql(u8, name, "bigint") or
                std.mem.eql(u8, name, "symbol") or
                std.mem.eql(u8, name, "null") or
                std.mem.eql(u8, name, "undefined") or
                std.mem.eql(u8, name, "void") or
                std.mem.eql(u8, name, "never") or
                std.mem.eql(u8, name, "any") or
                std.mem.eql(u8, name, "unknown"))
            {
                return true;
            }
            const decl = ctx.typeDeclNode(name);
            if (decl != .none) {
                const dtag = ctx.nodeTag(decl);
                if (dtag == .ts_interface_decl) {
                    return interfaceIsDeeplyReadonly(decl, opts, ctx, depth + 1);
                }
                if (dtag == .ts_type_alias_decl) {
                    const body = ctx.typeAliasBodyNode(name);
                    if (body == .none) return true;
                    return typeNodeIsDeeplyReadonly(body, opts, ctx, depth + 1);
                }
            }
            return true;
        },
        .ts_type_literal => {
            // { ... } — every member must be readonly + deeply readonly.
            const s = @intFromEnum(d.lhs);
            const e = @intFromEnum(d.rhs);
            if (e > s and e <= ctx.ast.extra_data.len) {
                for (ctx.ast.extra_data[s..e]) |raw| {
                    const m: NodeIndex = @enumFromInt(raw);
                    if (!memberIsDeeplyReadonly(m, opts, ctx, depth + 1)) return false;
                }
            }
            return true;
        },
        .ts_function_type, .ts_constructor_type => return true, // functions OK
        .ts_mapped_type => return false, // approximate; mapped types may not be readonly
        .ts_conditional_type => return true, // approximate
        else => return true, // primitives / unknown — lenient
    }
}

/// Treat the outer level of `node` as readonly (the way `Readonly<X>`
/// behaves) and check that the inner types are themselves deeply
/// readonly.  For arrays/tuples: element types must be deeply readonly.
/// For objects: each property's TYPE must be deeply readonly (ignore
/// the property's own `readonly` modifier — Readonly<> overrides).
fn insideReadonlyOk(node: NodeIndex, opts: Options, ctx: *const LintContext, depth: u32) bool {
    if (node == .none or depth > 16) return true;
    var n = node;
    while (ctx.nodeTag(n) == .ts_parenthesized_type) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    const d = ctx.nodeData(n);
    switch (tag) {
        .ts_array_type => return typeNodeIsDeeplyReadonly(d.lhs, opts, ctx, depth + 1),
        .ts_tuple_type => return tupleElementsReadonly(n, opts, ctx, depth + 1),
        .ts_type_literal => {
            const s = @intFromEnum(d.lhs);
            const e = @intFromEnum(d.rhs);
            if (e > s and e <= ctx.ast.extra_data.len) {
                for (ctx.ast.extra_data[s..e]) |raw| {
                    const m: NodeIndex = @enumFromInt(raw);
                    // Skip the readonly-modifier check since Readonly<> adds it;
                    // just check the member's value type.
                    if (!memberValueTypeIsDeeplyReadonly(m, opts, ctx, depth + 1)) return false;
                }
            }
            return true;
        },
        else => return typeNodeIsDeeplyReadonly(n, opts, ctx, depth + 1),
    }
}

fn memberValueTypeIsDeeplyReadonly(member: NodeIndex, opts: Options, ctx: *const LintContext, depth: u32) bool {
    const tag = ctx.nodeTag(member);
    if (tag == .ts_property_signature) {
        return typeNodeIsDeeplyReadonly(ctx.nodeData(member).rhs, opts, ctx, depth + 1);
    }
    // Methods / call sigs / index sigs — treat as OK.
    if (tag == .ts_method_signature or tag == .ts_call_signature or tag == .ts_construct_signature) return true;
    if (tag == .ts_index_signature) return true;
    return true;
}

/// X used inside a Readonly<X> wrapper.  TSe enforces readonly at one
/// level — for arrays/tuples, the elements still need to be deeply
/// readonly; for type literals, each property's value-type must be
/// deeply readonly.  For arbitrary `T` (named types), accept.
fn typeNodeIsPrimitive(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    var n = node;
    while (ctx.nodeTag(n) == .ts_parenthesized_type) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    // Literal types are immutable (primitive literals + template_literal)
    if (tag == .string_literal or tag == .number_literal or
        tag == .bigint_literal or tag == .boolean_literal or
        tag == .null_literal or tag == .ts_template_literal_type) return true;
    if (tag != .ts_type_reference) return false;
    const name = ctx.tokenText(ctx.nodeMainToken(n));
    return std.mem.eql(u8, name, "string") or
        std.mem.eql(u8, name, "number") or
        std.mem.eql(u8, name, "boolean") or
        std.mem.eql(u8, name, "bigint") or
        std.mem.eql(u8, name, "symbol") or
        std.mem.eql(u8, name, "null") or
        std.mem.eql(u8, name, "undefined") or
        std.mem.eql(u8, name, "void") or
        std.mem.eql(u8, name, "never");
}

fn innerOfReadonlyOk(node: NodeIndex, opts: Options, ctx: *const LintContext, depth: u32) bool {
    if (node == .none or depth > 16) return true;
    var n = node;
    while (ctx.nodeTag(n) == .ts_parenthesized_type) n = ctx.nodeData(n).lhs;
    const tag = ctx.nodeTag(n);
    const d = ctx.nodeData(n);
    switch (tag) {
        .ts_array_type => return typeNodeIsDeeplyReadonly(d.lhs, opts, ctx, depth + 1),
        .ts_tuple_type => return tupleElementsReadonly(n, opts, ctx, depth + 1),
        .ts_type_literal => {
            const s = @intFromEnum(d.lhs);
            const e = @intFromEnum(d.rhs);
            if (e > s and e <= ctx.ast.extra_data.len) {
                for (ctx.ast.extra_data[s..e]) |raw| {
                    const m: NodeIndex = @enumFromInt(raw);
                    if (!memberValueTypeIsDeeplyReadonly(m, opts, ctx, depth + 1)) return false;
                }
            }
            return true;
        },
        // Inner type reference: check user-declared interfaces for
        // inherited mutability (extends Array<X> etc.) — and walk
        // properties' VALUE types (NOT the propertyHasReadonly check,
        // since the outer Readonly wrapper makes them readonly).
        .ts_type_reference => {
            const name_node = d.lhs;
            if (name_node == .none) return true;
            const name = ctx.tokenText(ctx.nodeMainToken(name_node));
            if (isMutableBuiltin(name)) return false;
            const decl = ctx.typeDeclNode(name);
            if (decl != .none) {
                const dtag = ctx.nodeTag(decl);
                if (dtag == .ts_interface_decl) {
                    // Outer Readonly only makes prop keys readonly —
                    // each prop's VALUE type still needs to be
                    // deeply-readonly.  Check extends + members' value
                    // types only (skip propertyHasReadonly).
                    if (interfaceExtendsList(decl, ctx)) |ext| {
                        for (ctx.ast.extra_data[ext.start..ext.end]) |raw| {
                            const t: NodeIndex = @enumFromInt(raw);
                            if (!typeNodeIsDeeplyReadonly(t, opts, ctx, depth + 1)) return false;
                        }
                    }
                    const members = ctx.interfaceDeclMembers(decl) orelse return true;
                    if (members.end > members.start and members.end <= ctx.ast.extra_data.len) {
                        for (ctx.ast.extra_data[members.start..members.end]) |raw| {
                            const m: NodeIndex = @enumFromInt(raw);
                            if (!memberValueTypeIsDeeplyReadonly(m, opts, ctx, depth + 1)) return false;
                        }
                    }
                    return true;
                }
            }
            return true;
        },
        else => return true, // primitives / others — lenient
    }
}

fn interfaceIsDeeplyReadonly(decl: NodeIndex, opts: Options, ctx: *const LintContext, depth: u32) bool {
    // Check the `extends` list: an interface extending a mutable type
    // inherits that type's properties (e.g. `extends Array<X>` brings
    // in Array's mutable methods).
    if (interfaceExtendsList(decl, ctx)) |ext| {
        const ext_data = ctx.ast.extra_data[ext.start..ext.end];
        for (ext_data) |raw| {
            const t: NodeIndex = @enumFromInt(raw);
            if (!typeNodeIsDeeplyReadonly(t, opts, ctx, depth + 1)) return false;
        }
    }
    const members = ctx.interfaceDeclMembers(decl) orelse return true;
    if (members.end <= members.start or members.end > ctx.ast.extra_data.len) return true;
    for (ctx.ast.extra_data[members.start..members.end]) |raw| {
        const m: NodeIndex = @enumFromInt(raw);
        if (!memberIsDeeplyReadonly(m, opts, ctx, depth + 1)) return false;
    }
    return true;
}

fn isMutableBuiltin(name: []const u8) bool {
    // Built-in classes whose default shape has mutable members.
    // These can't be "deeply readonly" without an explicit Readonly /
    // ReadonlyArray wrapper.
    const names = [_][]const u8{
        "Array", "Set", "Map", "WeakSet", "WeakMap",
        "Date", "RegExp",
        "Int8Array", "Uint8Array", "Uint8ClampedArray",
        "Int16Array", "Uint16Array",
        "Int32Array", "Uint32Array",
        "Float32Array", "Float64Array",
        "BigInt64Array", "BigUint64Array",
    };
    inline for (names) |n| if (std.mem.eql(u8, n, name)) return true;
    return false;
}

fn interfaceExtendsList(decl: NodeIndex, ctx: *const LintContext) ?struct { start: u32, end: u32 } {
    if (ctx.nodeTag(decl) != .ts_interface_decl) return null;
    const d = ctx.nodeData(decl);
    if (d.lhs == .none) return null;
    const id = ctx.extraData(ast.InterfaceData, @intFromEnum(d.lhs));
    if (id.extends_end <= id.extends_start) return null;
    if (id.extends_end > ctx.ast.extra_data.len) return null;
    return .{ .start = id.extends_start, .end = id.extends_end };
}

fn tupleElementsReadonly(node: NodeIndex, opts: Options, ctx: *const LintContext, depth: u32) bool {
    const d = ctx.nodeData(node);
    const s = @intFromEnum(d.lhs);
    const e = @intFromEnum(d.rhs);
    if (e > s and e <= ctx.ast.extra_data.len) {
        for (ctx.ast.extra_data[s..e]) |raw| {
            const m: NodeIndex = @enumFromInt(raw);
            if (!typeNodeIsDeeplyReadonly(m, opts, ctx, depth + 1)) return false;
        }
    }
    return true;
}

fn memberIsDeeplyReadonly(member: NodeIndex, opts: Options, ctx: *const LintContext, depth: u32) bool {
    const tag = ctx.nodeTag(member);
    switch (tag) {
        .ts_property_signature => {
            // lhs = name, rhs = type annotation.  Member must be marked
            // `readonly`: scan tokens before the name.
            const d = ctx.nodeData(member);
            if (!propertyHasReadonly(member, ctx)) return false;
            return typeNodeIsDeeplyReadonly(d.rhs, opts, ctx, depth + 1);
        },
        .ts_method_signature => {
            // Methods: by default mutable, but `treatMethodsAsReadonly`
            // option says treat method members as readonly even without
            // the modifier.
            if (opts.treat_methods_as_readonly) return true;
            return propertyHasReadonly(member, ctx);
        },
        .ts_call_signature, .ts_construct_signature => return true, // callable members are readonly
        .ts_index_signature => return propertyHasReadonly(member, ctx),
        else => return true,
    }
}

fn propertyHasReadonly(node: NodeIndex, ctx: *const LintContext) bool {
    const tok = ctx.nodeMainToken(node);
    // ts_property_signature's main_token points at the start of the
    // member — `readonly` itself when present.  Check it directly
    // before scanning backward.
    if (std.mem.eql(u8, ctx.tokenText(tok), "readonly")) return true;
    if (tok == 0) return false;
    var t = tok - 1;
    var depth: u32 = 0;
    while (depth < 6) : (depth += 1) {
        const txt = ctx.tokenText(t);
        if (std.mem.eql(u8, txt, "readonly")) return true;
        if (std.mem.eql(u8, txt, "static") or
            std.mem.eql(u8, txt, "public") or
            std.mem.eql(u8, txt, "private") or
            std.mem.eql(u8, txt, "protected") or
            std.mem.eql(u8, txt, "abstract") or
            std.mem.eql(u8, txt, "override"))
        {
            // skip — keep looking
        } else {
            break;
        }
        if (t == 0) break;
        t -= 1;
    }
    return false;
}


fn isDeeplyReadonly(id: TypeId, opts: Options, ctx: *const LintContext, depth: u32) bool {
    if (depth > 16) return true;
    const kind = ctx.typeIdKind(id) orelse return true; // no checker — be lenient
    switch (kind) {
        .string, .string_literal,
        .number, .number_literal,
        .bigint, .bigint_literal,
        .boolean, .boolean_literal,
        .null_t, .undefined_t, .void_t,
        .never, .symbol, .any, .unknown, .error_t => return true,
        .function_t => return true,
        .array_t => return false,
        .readonly_array_t => {
            const elems = ctx.typeIdTupleElements(id);
            // No element info — accept (lenient).
            if (elems.len == 0) {
                if (ctx.typeIdArrayElement(id)) |el| {
                    return isDeeplyReadonly(el, opts, ctx, depth + 1);
                }
                return true;
            }
            for (elems) |e| if (!isDeeplyReadonly(e, opts, ctx, depth + 1)) return false;
            return true;
        },
        .tuple_t => return false, // mutable tuple by default
        .union_t, .intersection_t => {
            for (ctx.typeIdUnionMembers(id)) |m| {
                if (!isDeeplyReadonly(m, opts, ctx, depth + 1)) return false;
            }
            return true;
        },
        .object_t => return objectIsDeeplyReadonly(id, opts, ctx, depth + 1),
        .object_keyword => return false, // bare `object` keyword is mutable
        .type_ref => {
            const name = ctx.typeIdRefName(id);
            // Built-in readonly wrappers.
            if (std.mem.eql(u8, name, "Readonly") or
                std.mem.eql(u8, name, "ReadonlyArray") or
                std.mem.eql(u8, name, "ReadonlySet") or
                std.mem.eql(u8, name, "ReadonlyMap"))
            {
                const args = ctx.typeIdRefArgs(id);
                for (args) |arg| if (!isDeeplyReadonly(arg, opts, ctx, depth + 1)) return false;
                return true;
            }
            // `Array<T>` / `Set<T>` / `Map<K,V>` / etc. are mutable.
            if (std.mem.eql(u8, name, "Array") or
                std.mem.eql(u8, name, "Set") or
                std.mem.eql(u8, name, "Map") or
                std.mem.eql(u8, name, "WeakSet") or
                std.mem.eql(u8, name, "WeakMap"))
            {
                return false;
            }
            // Other named types — be lenient (likely user types we can't introspect).
            return true;
        },
        else => return true,
    }
}

fn objectIsDeeplyReadonly(id: TypeId, opts: Options, ctx: *const LintContext, depth: u32) bool {
    // Walk the object type's properties.  Each must be readonly and its
    // type deeply readonly.
    const props = ctx.typeIdObjectProps(id);
    for (props) |p| {
        if (!p.readonly) return false;
        if (!isDeeplyReadonly(p.type_id, opts, ctx, depth + 1)) return false;
    }
    return true;
}
