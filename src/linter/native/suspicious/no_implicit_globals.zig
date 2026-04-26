const std = @import("std");
const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const BindingKind = @import("../../../parser/symbol.zig").BindingKind;
const SymbolId = @import("../../../parser/symbol.zig").SymbolId;
const ReferenceId = @import("../../../parser/reference.zig").ReferenceId;
const ReferenceKind = @import("../../../parser/reference.zig").ReferenceKind;
const ScopeId = @import("../../../parser/scope.zig").ScopeId;
const ScopeTree = @import("../../../parser/scope.zig").ScopeTree;

pub const meta = RuleMeta{
    .name = "no-implicit-globals",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow declarations in the global scope",
};

pub const relevant_tags = [_]Node.Tag{};

/// Check if the write reference is inside a scope that has a "use strict" directive.
/// Scans the source text near the enclosing function/global scope's opening brace.
fn isInDirectiveStrictScope(ctx: *const LintContext, src: []const u8, ref_scope: ScopeId, scopes: *const ScopeTree) bool {
    // Walk up to the nearest var-scope (function or global).
    var scope = ref_scope;
    while (scope.isValid()) {
        const flags = scopes.getFlags(scope);
        if (flags.is_var_scope) break;
        scope = scopes.parent(scope);
    }
    if (!scope.isValid()) return false;
    // Get the scope's node to find the opening brace.
    const scope_node = scopes.nodeId(scope);
    // Global scope (node = .root or .none): check beginning of source for directive.
    const is_root_scope = scope_node == .none or ctx.nodeTag(scope_node) == .root;
    if (is_root_scope) {
        var skip: usize = 0;
        while (skip < src.len and (src[skip] == ' ' or src[skip] == '\t' or
               src[skip] == '\n' or src[skip] == '\r')) skip += 1;
        const t = src[skip..];
        return std.mem.startsWith(u8, t, "'use strict'") or
               std.mem.startsWith(u8, t, "\"use strict\"");
    }
    // Function scope: find the `{` after the scope node's position.
    const fn_start = ctx.nodeSpan(scope_node).start;
    var i: u32 = fn_start;
    while (i < src.len and src[i] != '{') i += 1;
    if (i >= src.len) return false;
    i += 1; // skip `{`
    while (i < src.len and (src[i] == ' ' or src[i] == '\t' or src[i] == '\n' or src[i] == '\r')) i += 1;
    if (i + 13 <= src.len and (std.mem.startsWith(u8, src[i..], "'use strict'") or
                                std.mem.startsWith(u8, src[i..], "\"use strict\""))) return true;
    return false;
}

pub fn run(_: NodeIndex, _: *const LintContext) void {}

/// Returns true if source contains a `/* exported varName */` comment.
fn isExported(src: []const u8, name: []const u8) bool {
    var i: usize = 0;
    while (i + 1 < src.len) {
        if (src[i] != '/' or src[i + 1] != '*') { i += 1; continue; }
        const start = i + 2;
        var end = start;
        while (end + 1 < src.len and !(src[end] == '*' and src[end + 1] == '/')) end += 1;
        const content = src[start..end];
        if (std.mem.indexOf(u8, content, "exported") != null and
            std.mem.indexOf(u8, content, name) != null) return true;
        i = if (end + 2 <= src.len) end + 2 else src.len;
    }
    return false;
}

pub fn runOnSymbols(ctx: *const LintContext) void {
    // Module: all top-level bindings are module-scoped, not globals.
    if (ctx.getLanguageOptionString("sourceType")) |st| {
        if (std.mem.eql(u8, st, "module")) return;
    }
    const is_commonjs = blk: {
        if (ctx.getLanguageOptionString("sourceType")) |st|
            break :blk std.mem.eql(u8, st, "commonjs");
        break :blk false;
    };
    // parserOptions.ecmaFeatures.globalReturn: true → code treated as function body, no globals.
    if (ctx.getLanguageOptions()) |lo| {
        if (lo.* == .object) {
            if (lo.object.get("parserOptions")) |po| {
                if (po == .object) {
                    if (po.object.get("ecmaFeatures")) |ef| {
                        if (ef == .object) {
                            if (ef.object.get("globalReturn")) |gr| {
                                if (gr == .bool and gr.bool) return;
                            }
                        }
                    }
                }
            }
        }
    }

    // lexicalBindings option: when true, also flag let/const/class at global scope.
    const lexical_bindings = blk: {
        if (ctx.getOptions()) |o| switch (o.*) {
            .object => |obj| {
                if (obj.get("lexicalBindings")) |v| {
                    if (v == .bool) break :blk v.bool;
                }
            },
            else => {},
        };
        break :blk false;
    };

    const symbols = ctx.symbols();
    const scopes = ctx.scopes();
    const total = symbols.count();

    var i: u32 = 0;
    while (i < total) : (i += 1) {
        const id = SymbolId.fromInt(i);
        const flags = symbols.getFlags(id);

        const scope_id = symbols.getScope(id);
        if (scopes.depth(scope_id) != 0) continue;
        if (scopes.kind(scope_id) == .module) continue;

        const kind = symbols.getBindingKind(id);

        if (flags.is_implicit_global) {
            // Undeclared global write (foo = 1 in sloppy mode) — flag regardless of scope depth.
            // Implicit globals are never module-scoped so sourceType=module already returned above.
            const sym_name = symbols.getName(id);
            if (ctx.globalIsExplicitlyEnabled(sym_name)) continue;
            if (isExported(ctx.source(), sym_name)) continue;
            ctx.report(symbols.getDeclNode(id));
            continue;
        }
        if (!flags.isDeclared()) continue;

        // In commonjs mode, declared bindings are module-scoped; only implicit globals need reporting.
        if (is_commonjs) continue;

        const should_report = switch (kind) {
            .@"var", .function_decl => true,
            .let, .@"const", .class_decl => lexical_bindings,
            else => false,
        };
        if (!should_report) continue;

        // Skip if the name is an explicitly declared global or exported via comment directive.
        const sym_name = symbols.getName(id);
        if (ctx.globalIsExplicitlyEnabled(sym_name)) continue;
        if (isExported(ctx.source(), sym_name)) continue;

        ctx.report(symbols.getDeclNode(id));
    }

    const src = ctx.source();

    // Also flag unresolved write references — these are implicit global writes like `foo = 1`.
    // In module mode we already returned. In commonjs mode these still create globals.
    const refs = ctx.references();
    const ref_count: u32 = @intCast(refs.count());
    var r: u32 = 0;
    while (r < ref_count) : (r += 1) {
        const ref_id = ReferenceId.fromInt(r);
        if (refs.getSymbol(ref_id) != .none) continue; // resolved — not an implicit global
        // Only plain writes create implicit globals. `foo++` (read_write) reads first → no implicit global.
        // Only plain writes (not `foo++`) create implicit globals.
        if (refs.getKind(ref_id) != .write) continue;
        const ref_scope = refs.getScope(ref_id);
        // Skip strict mode scopes (class body, module, static_block — detected by scope tree).
        if (scopes.isStrictMode(ref_scope)) continue;
        // Skip module scopes.
        if (scopes.kind(ref_scope) == .module) continue;
        // Skip if the write is inside a function/global scope with "use strict" directive.
        // (scope.strict_mode doesn't track directives — check source near the enclosing scope.)
        if (isInDirectiveStrictScope(ctx, src, ref_scope, scopes)) continue;
        const node = refs.getNode(ref_id);
        if (node == .none) continue;
        // Get the identifier text to check against globals.
        const main_tok = ctx.nodeMainToken(node);
        const ref_name = ctx.tokenText(main_tok);
        if (ctx.globalIsExplicitlyEnabled(ref_name)) continue;
        if (isExported(ctx.source(), ref_name)) continue;
        ctx.report(node);
    }
}
