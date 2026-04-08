const path = require("path");
const Module = require("module");

const JS_ROOT = path.resolve(__dirname, "js");
Module.globalPaths.push(path.join(JS_ROOT, "node_modules"));

const { parseSource: parse } = require(path.join(JS_ROOT, "index"));
const { nodeView } = require(path.join(JS_ROOT, "estree-adapter"));

const code = "(Object?.prototype).p = 0";
const ast = parse(code, { filename: "test.js" });

const root = nodeView(ast, 0);

// Navigate to the Object identifier
const assignExpr = root.body[0].expression;
const memberExprP = assignExpr.left;
const chainExpr = memberExprP.object;
const optionalMemberExpr = chainExpr.expression;
const objectIdent = optionalMemberExpr.object;

console.log("Object identifier:", objectIdent.name);
console.log("Object parent:", objectIdent.parent?.type || "null");

console.log("\nOptional MemberExpression (.prototype):");
console.log("Type:", optionalMemberExpr.type);
console.log("Parent:", optionalMemberExpr.parent?.type || "null");
console.log("Parent is ChainExpression?", optionalMemberExpr.parent?.type === "ChainExpression");

if (optionalMemberExpr.parent) {
  console.log("\nParent of optional MemberExpr:");
  console.log("Parent's parent:", optionalMemberExpr.parent.parent?.type || "null");
}
