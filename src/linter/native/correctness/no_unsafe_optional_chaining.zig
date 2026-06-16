// HAND-WRITTEN.
// Rule: no-unsafe-optional-chaining
// Disallow use of optional chaining in contexts where `undefined` is not allowed.

const ast = @import("es_parser").ast;
const NodeIndex = ast.NodeIndex;
const Node = ast.Node;
const LintContext = @import("../../lint_context.zig").LintContext;
const RuleMeta = @import("../rule.zig").RuleMeta;

pub const meta = RuleMeta{
    .name = "no-unsafe-optional-chaining",
    .category = .correctness,
    .default_severity = .@"error",
    .description = "Disallow use of optional chaining in contexts where the `undefined` value is not allowed.",
};

pub const relevant_tags = [_]Node.Tag{
    // CallExpression / NewExpression
    .call_expr,
    .new_expr,
    // MemberExpression (non-optional)
    .member_expr,
    .computed_member_expr,
    // TaggedTemplateExpression
    .tagged_template,
    // ForOfStatement / ForAwaitOfStatement
    .for_of_stmt,
    .for_await_of_stmt,
    // SpreadElement
    .spread_element,
    // BinaryExpression in/instanceof
    .in_expr,
    .instanceof_expr,
    // BinaryExpression arithmetic (for disallowArithmeticOperators)
    .add, .subtract, .multiply, .divide, .modulo, .exponentiate,
    // UnaryExpression arithmetic (for disallowArithmeticOperators)
    .unary_plus, .unary_minus,
    // AssignmentExpression
    .assign,
    // AssignmentExpression arithmetic (for disallowArithmeticOperators)
    .add_assign, .sub_assign, .mul_assign, .div_assign, .mod_assign, .exp_assign,
    // AssignmentPattern (in destructuring)
    .assignment_pattern,
    // VariableDeclarator
    .declarator,
    // ClassDeclaration / ClassExpression
    .class_decl,
    .class_expr,
    // WithStatement
    .with_stmt,
};

pub const needs_semantic = false;

pub fn run(node: NodeIndex, ctx: *const LintContext) void {
    ctx.checkNoUnsafeOptionalChaining(node);
}
