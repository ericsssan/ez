// Programmatic transform for sonarjs's `S138/rule.js` (max-lines-per-function).
//
// What it changes
// ---------------
// On every FunctionDeclaration / FunctionExpression / ArrowFunctionExpression
// the rule calls `getLocsNumber(node.loc, lines, commentLineNumbers)` which
// iterates every line of the function (skipping blanks and full-line comments).
// On typescript.js most functions are well below the default threshold of
// 200 lines, but they all pay the per-line iteration anyway.
//
// Fast-path: if the function's raw line span (end.line − start.line + 1) is
// already at or below the threshold, the comment-stripped count can only be
// smaller, so it can never exceed the threshold. Skip storing the entry —
// Program:exit only reports for `lineCount > threshold`.
//
// Saves the per-line scan for the long tail of small functions.

export const upstreamPath = "/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-sonarjs/cjs/S138/rule.js";

export function transform(src) {
  if (!src.includes("const lineCount = getLocsNumber(node.loc, lines, commentLineNumbers);")) {
    throw new Error("upstream S138 getLocsNumber anchor missed");
  }
  src = src.replace(
    "const lineCount = getLocsNumber(node.loc, lines, commentLineNumbers);",
    "// ez fast-path: raw span <= threshold means the stripped count can't exceed it.\n                if (node.loc.end.line - node.loc.start.line + 1 <= threshold) return;\n                const lineCount = getLocsNumber(node.loc, lines, commentLineNumbers);",
  );
  return src;
}
