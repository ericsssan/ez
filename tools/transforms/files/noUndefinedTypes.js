// Programmatic transform for `eslint-plugin-jsdoc`'s `noUndefinedTypes` rule.
//
// What it changes
// ---------------
// The iterate callback (runs once per jsdoc comment in the file) builds a
// list of all NON-jsdoc block comments by filtering all comments and parsing
// each match:
//
//   const allComments = sourceCode.getAllComments();
//   const comments = allComments
//     .filter((comment) => /^\*(?!\*)/v.test(comment.value))
//     .map((commentNode) => parseComment(commentNode, ''));
//
// `getAllComments()` is O(N) where N = total comments (~35k on typescript.js).
// The iterate callback fires N_jsdoc times (~276), so the filter alone runs
// 35k × 276 ≈ 9.7M regex tests per file. The CPU profile attributed ~95 ms
// (2.4 %) to that single regex.
//
// The result depends only on `sourceCode`, so it can be cached per file.
// We hoist the build into a module-scope WeakMap keyed on sourceCode; the
// first iterate-callback invocation pays the cost, all subsequent ones get
// O(1) lookup.

export const upstreamPath = "/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-jsdoc/src/rules/noUndefinedTypes.js";

// Anchor on the precise upstream shape so an upstream rewrite breaks the
// build loudly instead of silently no-opping.
const ANCHOR = `  const allComments = sourceCode.getAllComments();
  const comments = allComments
    .filter((comment) => {
      return (/^\\*(?!\\*)/v).test(comment.value);
    })
    .map((commentNode) => {
      return parseComment(commentNode, '');
    });`;

const REPLACEMENT = `  // === ez transform: cached non-jsdoc comments per sourceCode ===
  if (!__ez_no_undef_types_cache) __ez_no_undef_types_cache = new WeakMap();
  let comments = __ez_no_undef_types_cache.get(sourceCode);
  if (!comments) {
    const allComments = sourceCode.getAllComments();
    comments = [];
    for (let __i = 0; __i < allComments.length; __i++) {
      const __c = allComments[__i];
      if (/^\\*(?!\\*)/v.test(__c.value)) comments.push(parseComment(__c, ''));
    }
    __ez_no_undef_types_cache.set(sourceCode, comments);
  }`;

export function transform(src) {
  if (src.includes("__ez_no_undef_types_cache")) return src; // idempotent
  if (!src.includes(ANCHOR)) {
    throw new Error("noUndefinedTypes: iterate-callback allComments.filter+map anchor shape changed");
  }
  // Inject the WeakMap declaration at module scope, near the top after imports.
  // The file uses ESM `import` statements at the top; declare the cache after
  // them by anchoring on a known statement.
  const TOP_ANCHOR = `import iterateJsdoc, {
  parseComment,
} from '../iterateJsdoc.js';`;
  if (!src.includes(TOP_ANCHOR)) {
    throw new Error("noUndefinedTypes: iterateJsdoc import anchor shape changed");
  }
  src = src.replace(
    TOP_ANCHOR,
    `${TOP_ANCHOR}\n\n// === ez transform: shared non-jsdoc-comments cache ===\nlet __ez_no_undef_types_cache = null;`,
  );
  return src.replace(ANCHOR, REPLACEMENT);
}
