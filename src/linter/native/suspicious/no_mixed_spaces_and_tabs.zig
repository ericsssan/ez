const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const std = @import("std");
const Span = @import("../../../parser/span.zig").Span;

pub const relevant_tags = [_]Node.Tag{.root};

pub const meta = RuleMeta{
    .name = "no-mixed-spaces-and-tabs",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow mixed spaces and tabs for indentation",
};

pub fn run(_: NodeIndex, ctx: *const LintContext) void {
    const source = ctx.source();

    // allowIndentingTabs: when true (or "smart-tabs"), allow tabs followed by spaces.
    const allow_indenting_tabs = blk: {
        if (ctx.getOptions()) |o| {
            if (o.* == .bool and o.bool) break :blk true;
            if (o.* == .string and std.mem.eql(u8, o.string, "smart-tabs")) break :blk true;
        }
        break :blk false;
    };

    var line_start: usize = 0;
    var line_num: u32 = 0;
    var in_block_comment = false;
    var block_comment_start_line: u32 = 0;
    var in_string: bool = false;
    // Template literal tracking:
    // template_depth > 0 means we're inside at least one template literal string part
    // template_expr_depth > 0 means we're inside a ${ ... } expression part
    var template_depth: u32 = 0;
    var template_expr_depth: u32 = 0;
    // State at the START of each line.
    var line_in_template_string: bool = false;  // in string part of template
    var line_in_string: bool = false;
    var line_in_comment_interior: bool = false;

    var i: usize = 0;
    while (i <= source.len) : (i += 1) {
        const is_end = i == source.len;
        const c: u8 = if (is_end) '\n' else source[i];

        // At the start of each line (right after \n), snapshot state.
        if (i == line_start) {
            // In template string part if we're in a template but NOT in an expression
            line_in_template_string = template_depth > 0 and template_expr_depth == 0;
            line_in_string = in_string;
            line_in_comment_interior = in_block_comment;
        }

        if (!is_end and !in_block_comment and !in_string) {
            if (c == '`') {
                if (template_depth > 0 and template_expr_depth == 0) {
                    // Closing backtick of inner template
                    template_depth -= 1;
                } else if (template_depth > 0 and template_expr_depth > 0) {
                    // Opening backtick inside template expression = nested template
                    template_depth += 1;
                } else {
                    // Opening backtick at top level
                    template_depth += 1;
                }
            } else if (c == '$' and i + 1 < source.len and source[i + 1] == '{' and template_depth > 0 and template_expr_depth == 0) {
                // Enter template expression
                template_expr_depth += 1;
                i += 1; // skip '{'
            } else if (c == '{' and template_expr_depth > 0) {
                template_expr_depth += 1;
            } else if (c == '}' and template_expr_depth > 0) {
                template_expr_depth -= 1;
            }
        }

        // Track multiline string (backslash before newline).
        if (c == '\n') {
            if (i > 0 and source[i - 1] == '\\' and !in_block_comment and template_depth == 0) {
                in_string = true;
            } else {
                in_string = false;
            }
        }

        // Track block comment state (not inside templates).
        if (!is_end and template_depth == 0 and template_expr_depth == 0 and !in_string) {
            if (c == '/' and i + 1 < source.len and source[i + 1] == '*') {
                if (!in_block_comment) {
                    in_block_comment = true;
                    block_comment_start_line = line_num;
                }
            } else if (c == '*' and i + 1 < source.len and source[i + 1] == '/') {
                if (in_block_comment) {
                    in_block_comment = false;
                }
            }
        }

        if (c == '\n' or is_end) {
            // Check if this line closes a block comment started on a previous line.
            const closes_earlier_comment = !in_block_comment and
                line_num > block_comment_start_line and
                std.mem.indexOf(u8, source[line_start..i], "*/") != null and
                std.mem.indexOf(u8, source[line_start..i], "/*") == null;

            const should_skip = line_in_comment_interior or closes_earlier_comment or
                                 line_in_template_string or line_in_string;

            if (!should_skip) {
                checkLine(source, line_start, i, ctx, allow_indenting_tabs);
            }

            line_start = i + 1;
            line_num += 1;
        }
    }
}

fn checkLine(source: []const u8, start: usize, end: usize, ctx: *const LintContext, allow_indenting_tabs: bool) void {
    var has_space = false;
    var has_tab = false;
    var has_tab_after_space = false;

    var i = start;
    while (i < end) : (i += 1) {
        const c = source[i];
        if (c == ' ') {
            has_space = true;
        } else if (c == '\t') {
            if (has_space) has_tab_after_space = true;
            has_tab = true;
        } else {
            break;
        }
    }

    if (allow_indenting_tabs) {
        // Allow: tabs for indentation, then spaces for alignment.
        // Flag only if there's a tab AFTER a space.
        if (has_tab_after_space) {
            ctx.reportSpan(Span{ .start = @intCast(start), .end = @intCast(start) });
        }
    } else {
        if (has_space and has_tab) {
            ctx.reportSpan(Span{ .start = @intCast(start), .end = @intCast(start) });
        }
    }
}
