const path = require("path");
const Module = require("module");

const JS_ROOT = path.resolve(__dirname, "js");
Module.globalPaths.push(path.join(JS_ROOT, "node_modules"));

const { parseSource: parse } = require(path.join(JS_ROOT, "index"));
const { nodeView } = require(path.join(JS_ROOT, "estree-adapter"));

const code = "Object.defineProperty(Object?.prototype, 'p', { value: 0 })";
const ast = parse(code, { filename: "test.js" });

const root = nodeView(ast, 0);

// Walk the tree to find the optional MemberExpression
function findOptional(node) {
  if (!node) return null;

  if (node.type === "MemberExpression" && node.optional) {
    return node;
  }

  if (node.arguments) {
    for (const arg of node.arguments) {
      const result = findOptional(arg);
      if (result) return result;
    }
  }
  if (node.callee) {
    const result = findOptional(node.callee);
    if (result) return result;
  }
  if (node.expression) {
    const result = findOptional(node.expression);
    if (result) return result;
  }

  return null;
}

const optionalMember = findOptional(root);
if (optionalMember) {
  console.log("Found optional MemberExpression");
  console.log("Parent:", optionalMember.parent?.type);
  console.log("Parent is ChainExpression?", optionalMember.parent?.type === "ChainExpression");

  if (optionalMember.parent) {
    console.log("Parent.parent:", optionalMember.parent.parent?.type);

    // Check if it looks like it's in a CallExpression
    const chainExpr = optionalMember.parent;
    if (chainExpr.parent && chainExpr.parent.type === "CallExpression") {
      const callExpr = chainExpr.parent;
      console.log("Looks like first argument of CallExpression?", callExpr.arguments && callExpr.arguments[0] === chainExpr);
    }
  }
} else {
  console.log("Optional MemberExpression not found");
}
