const path = require("path");
const Module = require("module");

const JS_ROOT = path.resolve(__dirname, "js");
Module.globalPaths.push(path.join(JS_ROOT, "node_modules"));

const { parseSource: parse } = require(path.join(JS_ROOT, "index"));
const { nodeView } = require(path.join(JS_ROOT, "estree-adapter"));

const code = "Object.defineProperty(Object?.prototype, 'p', { value: 0 })";
const ast = parse(code, { filename: "test.js" });

const root = nodeView(ast, 0);

const callExpr = root.body[0].expression;
console.log("CallExpression arguments[0]:", callExpr.arguments[0]?.type);
console.log("Is it ChainExpression?", callExpr.arguments[0]?.type === "ChainExpression");

const firstArg = callExpr.arguments[0];
if (firstArg) {
  console.log("firstArg.type:", firstArg.type);
  console.log("firstArg._isChainExpr:", firstArg._isChainExpr);
  console.log("firstArg.parent:", firstArg.parent?.type);

  if (firstArg._isChainExpr) {
    console.log("firstArg.expression:", firstArg.expression?.type);
    console.log("firstArg.expression.parent:", firstArg.expression?.parent?.type);
  }
}
