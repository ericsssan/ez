const path = require("path");
const Module = require("module");

const JS_ROOT = path.resolve(__dirname, "js");
Module.globalPaths.push(path.join(JS_ROOT, "node_modules"));

const { parseSource: parse } = require(path.join(JS_ROOT, "index"));
const { nodeView } = require(path.join(JS_ROOT, "estree-adapter"));

const code = "(Object?.prototype).p = 0";
const ast = parse(code, { filename: "test.js" });

const root = nodeView(ast, 0);

// Find Object identifier
const assignExpr = root.body[0].expression;
const memberExprP = assignExpr.left;
const chainExpr = memberExprP.object;
const optionalMember = chainExpr.expression;
const objectIdent = optionalMember.object;

console.log("=== Testing isPrototypePropertyAccessed ===");
const identifierNode = objectIdent;

// Check: identifierNode.parent.type === "MemberExpression"
console.log("identifierNode.parent.type === 'MemberExpression'?", identifierNode.parent.type === "MemberExpression");

// Check: identifierNode.parent.object === identifierNode
console.log("identifierNode.parent.object === identifierNode?", identifierNode.parent.object === identifierNode);

// Check: getStaticPropertyName(identifierNode.parent) === "prototype"
console.log("identifierNode.parent.property.name === 'prototype'?", identifierNode.parent.property.name === "prototype");

console.log("\n=== Testing ChainExpression wrapping logic ===");
// Line 150-153 in rule
const prototypeNode = identifierNode.parent.parent.type === "ChainExpression" ? identifierNode.parent.parent : identifierNode.parent;
console.log("prototypeNode.type:", prototypeNode.type);
console.log("prototypeNode._isChainExpr:", prototypeNode._isChainExpr);

console.log("\n=== Testing isAssigningToPropertyOf ===");
const node = prototypeNode;

// Check 1: node.parent.type === "MemberExpression"
console.log("node.parent.type === 'MemberExpression'?", node.parent.type === "MemberExpression");

// Check 2: node.parent.object === node
console.log("node.parent.object === node?", node.parent.object === node);
console.log("  node.parent.object type:", node.parent.object?.type);
console.log("  node type:", node.type);
console.log("  Are they identical?", node.parent.object === node);

// Check 3: node.parent.parent.type === "AssignmentExpression"
console.log("node.parent.parent.type === 'AssignmentExpression'?", node.parent.parent.type === "AssignmentExpression");

// Check 4: node.parent.parent.left === node.parent
console.log("node.parent.parent.left === node.parent?", node.parent.parent.left === node.parent);

console.log("\n=== Summary ===");
const isAssigning = (
  node.parent.type === "MemberExpression" &&
  node.parent.object === node &&
  node.parent.parent.type === "AssignmentExpression" &&
  node.parent.parent.left === node.parent
);
console.log("Should report error?", isAssigning);
