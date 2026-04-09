const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{
    // Control-flow statements whose bodies could be empty blocks
    .if_stmt,
    .if_else_stmt,
    .while_stmt,
    .do_while_stmt,
    .for_stmt,
    .for_in_stmt,
    .for_of_stmt,
    .for_await_of_stmt,
    .try_stmt,
    .catch_clause,
    .with_stmt,
    .switch_stmt,
};

pub const meta = RuleMeta{
    .name = "no-empty",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow empty block statements",
};

fn isEmptyBlock(node: NodeIndex, ctx: *const LintContext) bool {
    if (node == .none) return false;
    if (ctx.nodeTag(node) != .block_stmt) return false;
    const data = ctx.nodeData(node);
    if (@intFromEnum(data.lhs) != @intFromEnum(data.rhs)) return false; // has child nodes
    // Block has no child nodes. ESLint allows blocks containing only comments.
    // The main token of block_stmt is '{'. Scan source from there to find '}'
    // and check for any comment markers along the way.
    const open_tok = ctx.nodeMainToken(node);
    const src = ctx.source();
    const open_pos = ctx.tokenStart(open_tok);
    if (open_pos >= src.len or src[open_pos] != '{') return true;
    var i: usize = open_pos + 1;
    while (i < src.len) : (i += 1) {
        switch (src[i]) {
            '}' => return true, // reached closing brace with no comment
            '/' => {
                if (i + 1 < src.len and (src[i + 1] == '/' or src[i + 1] == '*')) {
                    return false; // has comment — not considered empty by ESLint
                }
            },
            else => {},
        }
    }
    return true;
}

/// Check if the switch body (between { and }) has no comments.
/// Returns true if the body is truly empty (no comments), false if it has comments.
fn isSwitchBodyEmpty(switch_node: NodeIndex, ctx: *const LintContext) bool {
    const main_tok = ctx.nodeMainToken(switch_node);
    const src = ctx.source();
    // Scan forward from the switch keyword to find the '{' of the switch body.
    // Need to skip past the '(discriminant)' — track paren depth.
    const start_pos = ctx.tokenStart(main_tok);
    var i: usize = start_pos;
    // Find opening '(' of discriminant
    while (i < src.len and src[i] != '(') : (i += 1) {}
    // Skip past the discriminant with balanced parens
    var depth: u32 = 0;
    while (i < src.len) : (i += 1) {
        if (src[i] == '(') depth += 1
        else if (src[i] == ')') {
            depth -= 1;
            if (depth == 0) { i += 1; break; }
        }
    }
    // Now find '{'
    while (i < src.len and src[i] != '{') : (i += 1) {}
    if (i >= src.len or src[i] != '{') return true;
    i += 1;
    // Scan between '{' and '}' for comments or case/default
    while (i < src.len) : (i += 1) {
        switch (src[i]) {
            '}' => return true,
            '/' => {
                if (i + 1 < src.len and (src[i + 1] == '/' or src[i + 1] == '*')) {
                    return false; // has comment
                }
            },
            else => {},
        }
    }
    return true;
}

fn checkBlock(block: NodeIndex, ctx: *const LintContext) void {
    if (isEmptyBlock(block, ctx)) {
        ctx.report(block);
    }
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);

    switch (tag) {
        // if (cond) { } — check consequent only (no else)
        .if_stmt => {
            const body: NodeIndex = @enumFromInt(@intFromEnum(data.rhs));
            checkBlock(body, ctx);
        },
        // if (cond) { } else { }
        .if_else_stmt => {
            const if_data = ctx.extraData(ast.IfData, @intFromEnum(data.rhs));
            checkBlock(if_data.consequent, ctx);
            checkBlock(if_data.alternate, ctx);
        },
        // while (cond) { }
        .while_stmt => {
            const body: NodeIndex = @enumFromInt(@intFromEnum(data.rhs));
            checkBlock(body, ctx);
        },
        // do { } while (cond)
        .do_while_stmt => {
            const body: NodeIndex = @enumFromInt(@intFromEnum(data.lhs));
            checkBlock(body, ctx);
        },
        // for (...) { }
        .for_stmt => {
            const body: NodeIndex = @enumFromInt(@intFromEnum(data.rhs));
            checkBlock(body, ctx);
        },
        // for (x in y) { } / for (x of y) { } / for await (x of y) { }
        .for_in_stmt, .for_of_stmt, .for_await_of_stmt => {
            const for_data = ctx.extraData(ast.ForInOfData, @intFromEnum(data.lhs));
            checkBlock(for_data.body, ctx);
        },
        // try { } catch { } finally { }
        .try_stmt => {
            const try_block: NodeIndex = @enumFromInt(@intFromEnum(data.lhs));
            checkBlock(try_block, ctx);
            const try_data = ctx.extraData(ast.TryData, @intFromEnum(data.rhs));
            if (try_data.finally_body != .none) checkBlock(try_data.finally_body, ctx);
        },
        // catch (e) { }
        .catch_clause => {
            const body: NodeIndex = @enumFromInt(@intFromEnum(data.rhs));
            checkBlock(body, ctx);
        },
        // with (expr) { }
        .with_stmt => {
            const body: NodeIndex = @enumFromInt(@intFromEnum(data.rhs));
            checkBlock(body, ctx);
        },
        // switch (expr) { } — flag if no cases and no comments
        .switch_stmt => {
            const has_cases = data.rhs != .none and blk: {
                const sub_range = ctx.extraData(ast.SubRange, @intFromEnum(data.rhs));
                break :blk sub_range.start != sub_range.end;
            };
            if (!has_cases and isSwitchBodyEmpty(node, ctx)) {
                ctx.report(node);
            }
        },
        else => {},
    }
}
