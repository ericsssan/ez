const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const SubRange = ast.SubRange;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const relevant_tags = [_]Node.Tag{.try_stmt};

pub const meta = RuleMeta{
    .name = "no-unsafe-finally",
    .category = .suspicious,
    .default_severity = .warning,
    .description = "Disallow control flow statements in finally blocks",
};

/// Flags tracking what's "safe" at the current point in the DFS.
/// Mirrors ESLint's sentinel node logic:
///   - loops are sentinels for break and continue → once inside a loop, unlabeled break/continue are safe
///   - switch is sentinel for unlabeled break only → once inside a switch, unlabeled break is safe
const Flags = struct {
    in_loop: bool = false,
    in_switch: bool = false,
};

/// Recursively scan `node` (a statement inside a finally block) for unsafe
/// control-flow statements. Stops recursion at function/class/arrow boundaries.
fn scan(node: NodeIndex, flags: Flags, ctx: *const LintContext) void {
    if (node == .none) return;
    const tag = ctx.nodeTag(node);
    const data = ctx.nodeData(node);

    switch (tag) {
        // ── Control flow → potentially report ────────────────
        .return_stmt, .throw_stmt => {
            ctx.report(node);
        },
        .break_stmt => {
            // Unlabeled break is safe inside a loop or switch
            if (!flags.in_loop and !flags.in_switch) {
                ctx.report(node);
            }
        },
        .break_label => {
            // Labeled break always unsafe (exits the finally block via label outside it)
            ctx.report(node);
        },
        .continue_stmt => {
            // Unlabeled continue is safe inside a loop (but NOT just a switch)
            if (!flags.in_loop) {
                ctx.report(node);
            }
        },
        .continue_label => {
            // Labeled continue always unsafe
            ctx.report(node);
        },

        // ── Stop at function/class boundaries ─────────────────
        .fn_decl, .async_fn_decl, .generator_fn_decl, .async_generator_fn_decl,
        .fn_expr, .async_fn_expr, .generator_fn_expr, .async_generator_fn_expr,
        .arrow_fn, .async_arrow_fn,
        .class_decl, .class_expr,
        => return,

        // ── Recurse into block ────────────────────────────────
        .block_stmt => {
            const range = SubRange{ .start = @intFromEnum(data.lhs), .end = @intFromEnum(data.rhs) };
            for (ctx.extraSlice(range)) |raw| {
                scan(@enumFromInt(raw), flags, ctx);
            }
        },

        // ── Recurse into if / if-else ─────────────────────────
        .if_stmt => scan(data.rhs, flags, ctx), // rhs = then-branch
        .if_else_stmt => {
            const ie = ctx.extraData(ast.IfData, @intFromEnum(data.rhs));
            scan(ie.consequent, flags, ctx);
            scan(ie.alternate, flags, ctx);
        },

        // ── Recurse into loops (set in_loop=true) ─────────────
        .while_stmt => scan(data.rhs, Flags{ .in_loop = true, .in_switch = false }, ctx),
        .do_while_stmt => scan(data.lhs, Flags{ .in_loop = true, .in_switch = false }, ctx),
        .for_stmt => {
            const fd = ctx.extraData(ast.ForData, @intFromEnum(data.lhs));
            scan(data.rhs, Flags{ .in_loop = true, .in_switch = false }, ctx);
            _ = fd;
        },
        .for_in_stmt, .for_of_stmt, .for_await_of_stmt => {
            const fod = ctx.extraData(ast.ForInOfData, @intFromEnum(data.lhs));
            scan(fod.body, Flags{ .in_loop = true, .in_switch = false }, ctx);
        },

        // ── Recurse into switch (set in_switch=true) ──────────
        .switch_stmt => {
            // lhs = discriminant, rhs = extra SubRange of cases
            const range = ctx.extraData(SubRange, @intFromEnum(data.rhs));
            const new_flags = Flags{ .in_loop = flags.in_loop, .in_switch = true };
            for (ctx.extraSlice(range)) |raw| {
                scan(@enumFromInt(raw), new_flags, ctx);
            }
        },
        .switch_case => {
            // lhs = test, rhs = extra SubRange of statements
            const range = ctx.extraData(SubRange, @intFromEnum(data.rhs));
            for (ctx.extraSlice(range)) |raw| {
                scan(@enumFromInt(raw), flags, ctx);
            }
        },
        .switch_default => {
            // lhs = none, rhs = extra SubRange of statements
            const range = ctx.extraData(SubRange, @intFromEnum(data.rhs));
            for (ctx.extraSlice(range)) |raw| {
                scan(@enumFromInt(raw), flags, ctx);
            }
        },

        // ── Recurse into labeled statement ────────────────────
        .labeled_stmt => scan(data.lhs, flags, ctx),

        // ── Recurse into nested try ───────────────────────────
        .try_stmt => {
            const try_data = ctx.extraData(ast.TryData, @intFromEnum(data.rhs));
            scan(data.lhs, flags, ctx); // try body
            if (try_data.catch_node != .none) {
                const cc = ctx.nodeData(try_data.catch_node);
                scan(cc.rhs, flags, ctx); // catch body
            }
            scan(try_data.finally_body, flags, ctx); // nested finally body
        },

        // ── Other statement types ─────────────────────────────
        // with_stmt, debugger_stmt, declarations, etc. — no control flow to scan
        else => {},
    }
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    const data = ctx.nodeData(node);
    if (data.rhs == .none) return;
    const try_data = ctx.extraData(ast.TryData, @intFromEnum(data.rhs));

    const finally_body = try_data.finally_body;
    if (finally_body == .none) return;

    // Scan the finally block body
    scan(finally_body, .{}, ctx);
}

pub fn runOnSymbols(_: *const LintContext) void {}
