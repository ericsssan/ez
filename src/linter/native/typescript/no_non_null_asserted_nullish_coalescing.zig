// HAND-WRITTEN.
// Rule: @typescript-eslint/no-non-null-asserted-nullish-coalescing
//
// Reports `<expr>! ?? <other>`: the `!` removes `null|undefined` from
// the operand, which is exactly the case `??` would have handled —
// the operator combination is contradictory.  The rule also flags
// `x!` when `x` was declared with a definite-assignment assertion
// (`let x!: T`) and used in `??`, but only the direct shape is
// caught here.

const std = @import("std");
const parser = @import("../../../parser/root.zig");
const ast = parser.ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-non-null-asserted-nullish-coalescing",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow non-null assertions in the LHS of nullish coalescing",
    .lang = .ts_only,
};

pub const relevant_tags = [_]Node.Tag{.nullish_coalesce};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    const lhs = data.lhs;
    if (lhs == .none) return;
    var l = lhs;
    while (ctx.nodeTag(l) == .grouping_expr) l = ctx.nodeData(l).lhs;
    if (ctx.nodeTag(l) != .ts_non_null_expr) return;
    // Only fire when the asserted operand is provably non-nullable
    // without the `!`.  We detect the simple case: a bare identifier
    // whose declaration uses a definite-assignment marker (`let x!:`),
    // or a parameter property / field of that shape.  Member-access
    // forms (`foo.bar!`) and call results stay because the operand's
    // type may legitimately include `undefined`.
    const inner = ctx.nodeData(l).lhs;
    if (inner == .none) return;
    const assertion_pos = ctx.nodeSpan(l).start;
    if (!operandIsNonNullable(inner, ctx, assertion_pos)) return;
    ctx.reportWithMessageId(l, "noNonNullAssertedNullishCoalescing");
}

fn operandIsNonNullable(n: NodeIndex, ctx: *const LintContext, before: u32) bool {
    var node = n;
    while (ctx.nodeTag(node) == .grouping_expr) node = ctx.nodeData(node).lhs;
    const tag = ctx.nodeTag(node);
    // For identifiers, fire UNLESS the declaration is a `let|var|
    // const <name>:` form with NO definite-assignment marker — TS
    // treats those uses as possibly-undefined, so the `!` is needed.
    if (tag == .identifier) {
        const name = ctx.tokenText(ctx.nodeMainToken(node));
        if (name.len == 0) return false;
        return !identifierDeclaredWithoutBang(name, ctx, before);
    }
    // Member access, call results, etc. — fire by default; the
    // property/return type is inferred.
    return true;
}

fn identifierDeclaredWithoutBang(name: []const u8, ctx: *const LintContext, before: u32) bool {
    const src = ctx.ast.source;
    const kws = [_][]const u8{ "let ", "var ", "const " };
    var found_decl = false;
    var found_definite = false;
    for (kws) |kw| {
        var pos: usize = 0;
        while (pos < src.len) {
            const idx = std.mem.indexOfPos(u8, src, pos, kw) orelse break;
            const after_kw = idx + kw.len;
            if (after_kw + name.len > src.len) break;
            if (!std.mem.eql(u8, src[after_kw .. after_kw + name.len], name)) {
                pos = idx + 1;
                continue;
            }
            // Make sure this match isn't a prefix of a longer identifier.
            const after_name = after_kw + name.len;
            if (after_name < src.len) {
                const c = src[after_name];
                if ((c >= 'a' and c <= 'z') or (c >= 'A' and c <= 'Z') or
                    (c >= '0' and c <= '9') or c == '_' or c == '$')
                {
                    pos = idx + 1;
                    continue;
                }
                found_decl = true;
                if (c == '!') found_definite = true;
                // Initializer at the declaration site (`let x = …`) makes
                // x definitely assigned. Skip whitespace before checking.
                if (!found_definite) {
                    var k: usize = after_name;
                    while (k < src.len and (src[k] == ' ' or src[k] == '\t')) : (k += 1) {}
                    if (k < src.len and src[k] == '=' and
                        (k + 1 >= src.len or src[k + 1] != '='))
                    {
                        found_definite = true;
                    }
                }
            }
            pos = idx + 1;
        }
    }
    // Even if the declaration had no initializer, treat the variable as
    // definitely assigned when source contains a plain `name = …`
    // assignment BEFORE the assertion site (TS narrows to non-nullable).
    if (found_decl and !found_definite and assignedBefore(name, src, before)) {
        found_definite = true;
    }
    return found_decl and !found_definite;
}

fn assignedBefore(name: []const u8, src: []const u8, before: u32) bool {
    var pos: usize = 0;
    const limit: usize = @intCast(before);
    while (pos < limit) {
        const idx = std.mem.indexOfPos(u8, src, pos, name) orelse return false;
        if (idx >= limit) return false;
        pos = idx + 1;
        // Boundary check: previous char must not be identifier-continuation
        // and must not be the part of a `let|var|const NAME` declaration.
        if (idx > 0) {
            const prev = src[idx - 1];
            if ((prev >= 'a' and prev <= 'z') or (prev >= 'A' and prev <= 'Z') or
                (prev >= '0' and prev <= '9') or prev == '_' or prev == '$' or
                prev == '.') continue;
        }
        const after = idx + name.len;
        if (after >= src.len) continue;
        const next = src[after];
        if ((next >= 'a' and next <= 'z') or (next >= 'A' and next <= 'Z') or
            (next >= '0' and next <= '9') or next == '_' or next == '$') continue;
        // Skip whitespace, look for `=` not followed by `=` (i.e. assignment).
        var k: usize = after;
        while (k < src.len and (src[k] == ' ' or src[k] == '\t')) : (k += 1) {}
        if (k >= src.len) continue;
        if (src[k] != '=') continue;
        if (k + 1 < src.len and src[k + 1] == '=') continue;
        // Exclude declarator: `let x = …` already counted via the decl walk.
        // Look back through whitespace for the start of a `let|var|const ` keyword.
        var b: usize = idx;
        while (b > 0 and (src[b - 1] == ' ' or src[b - 1] == '\t')) : (b -= 1) {}
        const kws = [_][]const u8{ "let", "var", "const" };
        var is_decl = false;
        for (kws) |kw| {
            if (b >= kw.len and std.mem.eql(u8, src[b - kw.len .. b], kw)) {
                is_decl = true;
                break;
            }
        }
        if (is_decl) continue;
        return true;
    }
    return false;
}
