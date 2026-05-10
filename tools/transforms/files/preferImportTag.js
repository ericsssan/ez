// Programmatic transform for `eslint-plugin-jsdoc`'s `preferImportTag` rule.
//
// Same shape and same fix as `noUndefinedTypes.js`: the iterate callback
// rebuilds a parsed list of NON-jsdoc block comments per visit.
// Hoist into a sourceCode-keyed WeakMap so the work happens once per file.

export const upstreamPath = "/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-jsdoc/src/rules/preferImportTag.js";

const ANCHOR = `  const allComments = sourceCode.getAllComments();
  const comments = allComments
    .filter((comment) => {
      return (/^\\*(?!\\*)/v).test(comment.value);
    })
    .map((commentNode) => {
      return commentParserToESTree(
        parseComment(commentNode, ''), mode === 'permissive' ? 'typescript' : mode,
      );
    });`;

const REPLACEMENT = `  // === ez transform: cached parsed non-jsdoc comments per (sourceCode, mode) ===
  if (!__ez_prefer_import_tag_cache) __ez_prefer_import_tag_cache = new WeakMap();
  const __ez_mode_key = mode === 'permissive' ? 'typescript' : mode;
  let __ez_by_sc = __ez_prefer_import_tag_cache.get(sourceCode);
  if (!__ez_by_sc) { __ez_by_sc = new Map(); __ez_prefer_import_tag_cache.set(sourceCode, __ez_by_sc); }
  let comments = __ez_by_sc.get(__ez_mode_key);
  if (!comments) {
    const allComments = sourceCode.getAllComments();
    comments = [];
    for (let __i = 0; __i < allComments.length; __i++) {
      const __c = allComments[__i];
      if (/^\\*(?!\\*)/v.test(__c.value)) {
        comments.push(commentParserToESTree(parseComment(__c, ''), __ez_mode_key));
      }
    }
    __ez_by_sc.set(__ez_mode_key, comments);
  }`;

export function transform(src) {
  if (src.includes("__ez_prefer_import_tag_cache")) return src; // idempotent
  if (!src.includes(ANCHOR)) {
    throw new Error("preferImportTag: iterate-callback allComments.filter+map anchor shape changed");
  }
  const TOP_ANCHOR = `import iterateJsdoc, {
  parseComment,
} from '../iterateJsdoc.js';`;
  if (!src.includes(TOP_ANCHOR)) {
    throw new Error("preferImportTag: iterateJsdoc import anchor shape changed");
  }
  src = src.replace(
    TOP_ANCHOR,
    `${TOP_ANCHOR}\n\n// === ez transform: shared parsed-non-jsdoc-comments cache ===\nlet __ez_prefer_import_tag_cache = null;`,
  );
  return src.replace(ANCHOR, REPLACEMENT);
}
