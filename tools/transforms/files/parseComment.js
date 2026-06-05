// Programmatic transform for `@es-joy/jsdoccomment`'s `parseComment.js`.
//
// What it changes
// ---------------
// Upstream `parseComment(commentOrNode)` runs comment-parser's full
// regex pipeline on the comment text every call (~20µs per medium block).
// With ~30 active jsdoc rules iterating through ~200 comments per file
// on typescript.js, that's M×N = 6000 parses for the same handful of
// comment strings.
//
// We pre-parse every `/**` comment in Zig during the same NAPI parse
// call that builds the AST. The result lives as packed binary records
// in the buffer and is reachable through `AstView.jsdocLookup(rangeStart)`,
// which returns a JsdocBlock wrapper backed by the buffer.
//
// This transform inserts a fast-path at the top of `parseComment`:
//   - if commentOrNode is an object with a `range`, look up the wrapper
//     via `globalThis.__EZ_CURRENT_AST__.jsdocLookup(range[0])`
//   - if found, run `parseInlineTags` on it (matches upstream contract)
//     and return — no comment-parser invocation
//   - on miss, fall through to the original implementation
//
// The wrapper objects support mutation (rules that fix-up `jsdoc.source`
// or replace tags get copy-on-write semantics), so the contract matches
// the original parsed object byte-for-byte from the rule's perspective.

export const upstreamPath = "/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@es-joy/jsdoccomment/src/parseComment.js";

export function transform(src) {
  if (!src.includes("const parseComment = ")) throw new Error("upstream parseComment declaration changed");
  if (!src.includes("export {getTokenizers, parseComment};")) throw new Error("upstream parseComment export changed");
  if (src.includes("__ez_jsdoc_buffer_lookup")) return src; // idempotent

  // Insert the fast-path body at the very top of `parseComment`.
  const oldOpening = "const parseComment = (commentOrNode, indent = '') => {\n  let result;";
  if (!src.includes(oldOpening)) throw new Error("upstream parseComment opening shape changed");

  const newOpening =
`const __ez_jsdoc_buffer_lookup = true;
const parseComment = (commentOrNode, indent = '') => {
  // Ez fast path: AstView pre-parsed the /** comment into binary records
  // during the source parse. Look it up by source-relative range start.
  // Pass commentOrNode so the wrapper can be WeakMap-cached across rules
  // — internal field caches amortize across all rule visits.
  if (commentOrNode !== null && typeof commentOrNode === 'object' && commentOrNode.range) {
    const __ez_ast = globalThis.__EZ_CURRENT_AST__;
    if (__ez_ast && __ez_ast.jsdocLookup) {
      const __ez_block = __ez_ast.jsdocLookup(commentOrNode.range[0], commentOrNode);
      if (__ez_block) return parseInlineTags(__ez_block);
    }
  }
  let result;`;

  return src.replace(oldOpening, newOpening);
}
