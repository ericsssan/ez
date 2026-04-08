const path = require("path");
const Module = require("module");

const JS_ROOT = path.resolve(__dirname, "js");
Module.globalPaths.push(path.join(JS_ROOT, "node_modules"));

const { parseSource: parse, getTagNames } = require(path.join(JS_ROOT, "index"));
const { nodeView } = require(path.join(JS_ROOT, "estree-adapter"));

const code = "(Object?.prototype).p = 0";
const ast = parse(code, { filename: "test.js" });
const tagNames = getTagNames();

// Manually walk the AST like eslint-runner does and check what nodes we see
const root = nodeView(ast, 0);

function walk(node, depth = 0) {
  if (!node || !node.type) return;

  const indent = "  ".repeat(depth);
  const name = node.name ? ` (${node.name})` : "";

  console.log(`${indent}${node.type}${name}`);

  // Special logging for our target identifier
  if (node.type === "Identifier" && node.name === "Object") {
    console.log(`${indent}  -> .parent.type = ${node.parent?.type}`);
    console.log(`${indent}  -> .parent.parent.type = ${node.parent?.parent?.type}`);
  }

  if (node.type === "MemberExpression" && node.property?.name === "prototype") {
    console.log(`${indent}  -> .parent.type = ${node.parent?.type}`);
    console.log(`${indent}  -> .parent.parent.type = ${node.parent?.parent?.type}`);
  }

  if (node.body && Array.isArray(node.body)) {
    for (const child of node.body) walk(child, depth + 1);
  }
  if (node.expression) walk(node.expression, depth + 1);
  if (node.left) walk(node.left, depth + 1);
  if (node.right) walk(node.right, depth + 1);
  if (node.object && node.object.type !== "Program") walk(node.object, depth + 1);
  if (node.property && node.property.type !== "Program") walk(node.property, depth + 1);
}

walk(root);
