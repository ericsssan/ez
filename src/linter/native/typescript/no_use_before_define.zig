// HAND-WRITTEN.
// TS variant: @typescript-eslint/no-use-before-define
// Delegates to the base no-use-before-define implementation but reports
// under the TS messageId "noUseBeforeDefine" (camelCase vs "usedBeforeDefined").
const base = @import("../correctness/no_use_before_define.zig");
const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;
const MessageDataEntry = @import("../../lint_context.zig").MessageDataEntry;

pub const meta = RuleMeta{
    .name = "@typescript-eslint/no-use-before-define",
    .category = .correctness,
    .default_severity = .warning,
    .description = "Disallow the use of variables before they are defined.",
};

pub const relevant_tags = base.relevant_tags;
pub const needs_semantic = base.needs_semantic;

pub fn run(_: NodeIndex, _: *const LintContext) void {}

pub fn runOnSymbols(ctx: *const LintContext) void {
    base.runWithMessageId(ctx, "noUseBeforeDefine");
}
