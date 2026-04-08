const path = require("path");
const Module = require("module");

const JS_ROOT = path.resolve(__dirname, "js");
Module.globalPaths.push(path.join(JS_ROOT, "node_modules"));

const { parseSource: parse } = require(path.join(JS_ROOT, "index"));
const { nodeView } = require(path.join(JS_ROOT, "estree-adapter"));

const code = "(Object?.prototype).p = 0";
const ast = parse(code, { filename: "test.js" });

const root = nodeView(ast, 0);

// Navigate to nodes
const assignExpr = root.body[0].expression;
const memberExprP = assignExpr.left;
const chainExpr1 = memberExprP.object;
const optionalMemberExpr = chainExpr1.expression;

// Get parent again
const chainExpr2 = optionalMemberExpr.parent;

console.log("ChainExpression from .object property:", chainExpr1.type, chainExpr1._isChainExpr);
console.log("ChainExpression from .parent getter:", chainExpr2?.type, chainExpr2?._isChainExpr);
console.log("Are they the same object?", chainExpr1 === chainExpr2);
console.log("chainExpr1._i =", chainExpr1._i);
console.log("chainExpr2._i =", chainExpr2?._i);

// Check what parent.object is
const parentOfOptional = optionalMemberExpr.parent;
console.log("\nparentOfOptional.object:");
console.log("Type:", parentOfOptional?.object?.type);
console.log("Is it chainExpr1?", parentOfOptional?.object === chainExpr1);
console.log("Is it chainExpr2?", parentOfOptional?.object === chainExpr2);
