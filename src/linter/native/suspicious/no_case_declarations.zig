// GENERATED — do not edit. Source: tools/rule-ir-extract.js + tools/rule-codegen.js.
// Rule: no-case-declarations
// Source rule: tests/conformance/eslint/lib/rules/no-case-declarations.js

const ast = @import("../../../parser/ast.zig");
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-case-declarations",
    .category = .style,
    .default_severity = .warning,
    .description = "Disallow lexical declarations in case clauses",
};

pub const relevant_tags = [_]Node.Tag{.switch_case, .switch_default};

// messageIds (declared in rule meta.messages — carried for future use)
const Messages = enum {
    addBrackets,
    unexpected,
};

// helper: isLexicalDeclaration
fn isLexicalDeclaration(tag: Node.Tag) bool {
    return switch (tag) {
        .async_fn_decl, .async_generator_fn_decl, .class_decl, .const_decl, .fn_decl, .generator_fn_decl, .let_decl => true,
        else => false,
    };
}

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    // iterate over node.consequent
    {
        const __data = ctx.nodeData(node);
        if (__data.rhs == .none) return;
        const __range = ctx.extraData(ast.SubRange, @intFromEnum(__data.rhs));
        const __stmts = ctx.extraSlice(__range);
        if (__stmts.len == 1) {
            const __single: NodeIndex = @enumFromInt(__stmts[0]);
            if (ctx.nodeTag(__single) == .block_stmt) return;
        }
        for (__stmts) |__raw| {
            const statement: NodeIndex = @enumFromInt(__raw);
            const statement_tag = ctx.nodeTag(statement);
            if (isLexicalDeclaration(statement_tag)) {
                ctx.reportWithMessageId(statement, "unexpected");
            }
        }
    }
}
