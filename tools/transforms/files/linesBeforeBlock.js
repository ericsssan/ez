// Programmatic transform for `eslint-plugin-jsdoc`'s `linesBeforeBlock`.
//
// What it changes
// ---------------
// The rule fetches `sourceCode.getTokensBefore(jsdocNode, ...)` and then
// only uses `.at(-1)` to grab the closest preceding token. Inside the fix
// callback it later does `.pop()` on the same array.
//
// `getTokensBefore` builds a JS Token object for EVERY token preceding the
// jsdoc node — for jsdoc nodes deep into typescript.js that's thousands of
// `_makeToken` allocations + `slice()` calls per visit. CPU profile of an
// all-jsdoc-rules run on typescript.js attributed 28.6 % of total time
// (1.6 s / 5.6 s) to `slice` calls fan-in by this single line.
//
// Strategy
// --------
// Replace the eager array fetch with a single-token call (`getTokenBefore`)
// for the hot visit path, and a lazy proxy that defers the full
// `getTokensBefore` call until `.pop()` actually fires inside `fix()` —
// which only happens during `--fix` runs and only when the indent fallback
// branch executes. The visit path becomes a single token fetch instead of
// a full array allocation.
//
// Anchor the transform on the precise upstream lines so any upstream
// rewrite breaks the build loudly instead of silently no-opping.

// Bun resolves `eslint-plugin-jsdoc` to the package at
// `js/node_modules/eslint-plugin-jsdoc/src/...` (the original `.js`
// sources, ESM `import`s wired up via the package's `exports` map),
// not the `dist/*.cjs` files used by the standalone `loadPlugin`
// path. Anchor on the source layout so the bundle build picks it up.
export const upstreamPath = "/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-plugin-jsdoc/src/rules/linesBeforeBlock.js";

const ANCHOR = `  const tokensBefore = sourceCode.getTokensBefore(jsdocNode, {
    includeComments: true,
  });
  const tokenBefore = tokensBefore.at(-1);`;

export function transform(src) {
  if (!src.includes("getTokensBefore")) {
    throw new Error("linesBeforeBlock: upstream no longer references getTokensBefore");
  }
  if (src.includes("__ez_lines_before_block_lazy")) return src; // idempotent

  if (!src.includes(ANCHOR)) {
    throw new Error("linesBeforeBlock: anchor (eager getTokensBefore + .at(-1)) shape changed");
  }

  // Hot path: single-token fetch.
  // Cold path: lazy `tokensBefore` proxy whose `.pop()` builds the array
  // on first call and pops thereafter. Only the array methods the rule
  // actually uses are forwarded (`pop` is the only one).
  const replacement =
`  // === ez transform: lazy tokensBefore (tools/transforms/files/linesBeforeBlock.js) ===
  const __ez_lines_before_block_lazy = true;
  const tokenBefore = sourceCode.getTokenBefore(jsdocNode, {
    includeComments: true
  });
  let __ez_tokens_before_arr;
  const tokensBefore = {
    pop() {
      if (!__ez_tokens_before_arr) {
        __ez_tokens_before_arr = sourceCode.getTokensBefore(jsdocNode, {
          includeComments: true
        });
      }
      return __ez_tokens_before_arr.pop();
    }
  };`;

  return src.replace(ANCHOR, replacement);
}
