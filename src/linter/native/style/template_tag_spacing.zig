// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: template-tag-spacing
// Source rule: tests/conformance/eslint/lib/rules/template-tag-spacing.js

const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "template-tag-spacing",
    .category = .style,
    .default_severity = .warning,
    .description = "Require or disallow spacing between template tags and their literals",
    .fixable = true,
};

pub const relevant_tags = [_]Node.Tag{.tagged_template};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    unexpected,
    missing,
};

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const quasi_main = ctx.nodeMainToken(ctx.nodeData(node).rhs);
    const tag_end = ctx.tokenEnd(quasi_main - 1);
    const literal_start = ctx.ast.tokenStart(quasi_main);
    if (!ctx.optionEqualsString("always") and ctx.tokenHasSpaceBetween(quasi_main - 1, quasi_main)) {
        // Fix: drop the whitespace between the tag and the template
        // literal.  ESLint's fix preserves comments in the gap; we
        // approximate by also preserving them (find the first '/' or
        // '`' and split).  Most cases are a single space → empty.
        const src = ctx.ast.source;
        if (tag_end >= literal_start or literal_start > src.len) {
            ctx.reportSpanWithMessageId(.{ .start = tag_end, .end = literal_start }, "unexpected");
            return;
        }
        // Build the kept-comments text: scan the gap, preserve any
        // /* block comments */ verbatim, drop the surrounding whitespace.
        // If a line comment is in the gap, skip the fix entirely (matches
        // ESLint behaviour — the comment can't be safely inlined).
        var kept: [256]u8 = undefined;
        var kept_len: usize = 0;
        var i: u32 = tag_end;
        while (i < literal_start) : (i += 1) {
            const c = src[i];
            if (c == ' ' or c == '\t' or c == '\n' or c == '\r') continue;
            if (c == '/' and i + 1 < literal_start and src[i + 1] == '/') {
                // Line comment — bail.
                ctx.reportSpanWithMessageId(.{ .start = tag_end, .end = literal_start }, "unexpected");
                return;
            }
            if (c == '/' and i + 1 < literal_start and src[i + 1] == '*') {
                // Block comment — find the close.
                var j: u32 = i + 2;
                while (j + 1 < literal_start and !(src[j] == '*' and src[j + 1] == '/')) : (j += 1) {}
                const end = if (j + 1 < literal_start) j + 2 else literal_start;
                if (kept_len + (end - i) > kept.len) {
                    ctx.reportSpanWithMessageId(.{ .start = tag_end, .end = literal_start }, "unexpected");
                    return;
                }
                @memcpy(kept[kept_len..kept_len + (end - i)], src[i..end]);
                kept_len += end - i;
                i = end - 1; // loop increments
                continue;
            }
        }
        ctx.reportSpanWithFixAndMessageId(
            .{ .start = tag_end, .end = literal_start },
            .{ .start = tag_end, .end = literal_start },
            kept[0..kept_len],
            "unexpected",
        );
    } else if (ctx.optionEqualsString("always") and !ctx.tokenHasSpaceBetween(quasi_main - 1, quasi_main)) {
        ctx.reportSpanWithFixAndMessageId(
            .{ .start = ctx.nodeSpan(node).start, .end = literal_start },
            .{ .start = tag_end, .end = tag_end },
            " ",
            "missing",
        );
    }
}
