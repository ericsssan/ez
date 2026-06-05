# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 5.63s | 3606 | 1.0ms | 1186 |

**Top 10:** `slice` 28.6%, `getTokensAfter` 7.2%, `anonymous` 4.2%, `parse` 4.0%, `_makeToken` 3.5%, `get flags` 2.2%, `(anonymous)` 2.1%, `_makeToken` 2.0%, ``/^\n?([A-Z`\d_][\s\S]*[.?!`\p{RGI_Emoji}]\s*)?$/v`` 1.6%, `entries` 1.6%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 28.6% | 1.61s | 28.6% | 1.61s | `slice` | `[native code]` |
| 7.2% | 405.9ms | 7.3% | 411.5ms | `getTokensAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3566` |
| 4.2% | 237.0ms | 27.9% | 1.57s | `anonymous` | `[native code]` |
| 4.0% | 229.4ms | 4.0% | 229.4ms | `parse` | `[native code]` |
| 3.5% | 197.8ms | 3.5% | 197.8ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1300` |
| 2.2% | 125.9ms | 2.3% | 132.7ms | `get flags` | `[native code]` |
| 2.1% | 119.3ms | 2.3% | 133.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329111` |
| 2.0% | 115.4ms | 2.0% | 115.4ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1288` |
| 1.6% | 94.2ms | 1.6% | 94.2ms | ``/^\n?([A-Z`\d_][\s\S]*[.?!`\p{RGI_Emoji}]\s*)?$/v`` | `[native code]` |
| 1.6% | 92.4ms | 1.6% | 92.4ms | `entries` | `[native code]` |
| 1.5% | 84.5ms | 1.5% | 84.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 1.4% | 81.1ms | 1.6% | 94.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329779` |
| 1.4% | 80.4ms | 11.0% | 623.7ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1673` |
| 1.2% | 70.0ms | 1.9% | 112.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329116` |
| 1.2% | 69.4ms | 1.2% | 69.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:3` |
| 1.2% | 68.2ms | 1.2% | 68.2ms | `getTokensAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3565` |
| 1.1% | 66.5ms | 10.7% | 603.3ms | `filter` | `[native code]` |
| 1.1% | 65.8ms | 1.1% | 65.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301326` |
| 0.9% | 55.1ms | 70.0% | 3.94s | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7720` |
| 0.9% | 54.7ms | 0.9% | 54.7ms | `/(?<!\])\{@(?<tag>[^\}\s]+)\s?(?<namepathOrURL>[^\}\s\\|]*)\s*(?<separator>[\s\\|])?\s*(?<text>[^\}]*)\}/dgv` | `[native code]` |
| 0.9% | 53.0ms | 0.9% | 53.0ms | `DataView` | `[native code]` |
| 0.8% | 45.1ms | 0.8% | 46.4ms | `Set` | `[native code]` |
| 0.7% | 42.8ms | 0.7% | 42.8ms | `getValidRuntimeIdentifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329198` |
| 0.7% | 42.1ms | 0.7% | 42.1ms | `/^\s*globals/v` | `[native code]` |
| 0.6% | 37.1ms | 0.6% | 37.1ms | `/\r\n\|\r\|\n\|\u2028\|\u2029/` | `[native code]` |
| 0.5% | 32.2ms | 0.8% | 46.0ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1285` |
| 0.5% | 28.7ms | 1.1% | 65.9ms | `regExpSplitFast` | `[native code]` |
| 0.5% | 28.5ms | 0.9% | 54.2ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1975` |
| 0.4% | 28.0ms | 0.4% | 28.0ms | `/^\*(?!\*)/v` | `[native code]` |
| 0.4% | 25.9ms | 5.3% | 299.3ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318182` |
| 0.4% | 24.1ms | 0.4% | 24.1ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1264` |
| 0.4% | 23.8ms | 0.4% | 23.8ms | `getTokensAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3563` |
| 0.4% | 23.5ms | 0.4% | 23.5ms | `stringSplitFast` | `[native code]` |
| 0.3% | 21.3ms | 0.3% | 21.3ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1292` |
| 0.3% | 21.3ms | 2.0% | 115.5ms | `test` | `[native code]` |
| 0.3% | 20.7ms | 0.3% | 20.7ms | `getAncestors` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3668` |
| 0.3% | 19.8ms | 0.3% | 19.8ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1260` |
| 0.3% | 19.2ms | 0.3% | 19.2ms | `esSpecIsRegExp` | `[native code]` |
| 0.3% | 18.3ms | 0.3% | 18.3ms | `[Symbol.matchAll]` | `[native code]` |
| 0.3% | 18.0ms | 0.3% | 18.0ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.3% | 17.5ms | 0.3% | 17.5ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318170` |
| 0.2% | 16.6ms | 0.3% | 17.9ms | `_getAllTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1933` |
| 0.2% | 15.8ms | 0.2% | 15.8ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:731` |
| 0.2% | 15.7ms | 0.2% | 15.7ms | `includes` | `[native code]` |
| 0.2% | 15.4ms | 0.2% | 15.4ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318167` |
| 0.2% | 14.7ms | 7.9% | 446.1ms | `_getAllTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1932` |
| 0.2% | 14.4ms | 0.2% | 14.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.2% | 13.8ms | 42.5% | 2.39s | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5080` |
| 0.2% | 13.7ms | 0.2% | 13.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7382` |
| 0.2% | 13.6ms | 0.2% | 13.6ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318155` |
| 0.2% | 13.5ms | 0.2% | 13.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7855` |
| 0.2% | 12.7ms | 2.8% | 158.1ms | `parseDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318820` |
| 0.2% | 12.5ms | 0.2% | 12.5ms | `getCommentsBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3401` |
| 0.2% | 11.7ms | 4.2% | 238.4ms | `map` | `[native code]` |
| 0.2% | 11.7ms | 0.2% | 11.7ms | `getBasicUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320370` |
| 0.1% | 10.8ms | 0.1% | 10.8ms | `getText` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1346` |
| 0.1% | 10.7ms | 0.1% | 10.7ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4577` |
| 0.1% | 10.7ms | 0.3% | 18.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328274` |
| 0.1% | 10.7ms | 0.7% | 43.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.1% | 10.6ms | 0.1% | 10.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4266` |
| 0.1% | 10.5ms | 0.1% | 10.5ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1202` |
| 0.1% | 10.4ms | 0.1% | 10.4ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321034` |
| 0.1% | 10.1ms | 0.4% | 25.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319619` |
| 0.1% | 9.7ms | 0.1% | 9.7ms | `stringIncludesInternal` | `[native code]` |
| 0.1% | 9.5ms | 3.0% | 171.7ms | `checkJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321476` |
| 0.1% | 9.5ms | 0.1% | 9.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7682` |
| 0.1% | 9.4ms | 0.1% | 9.4ms | `RegExp` | `[native code]` |
| 0.1% | 9.3ms | 0.1% | 9.3ms | `push` | `[native code]` |
| 0.1% | 9.1ms | 0.1% | 9.1ms | `concat` | `[native code]` |
| 0.1% | 8.8ms | 1.3% | 77.4ms | `next` | `[native code]` |
| 0.1% | 8.6ms | 0.1% | 8.6ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318152` |
| 0.1% | 8.6ms | 0.1% | 8.6ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1228` |
| 0.1% | 8.4ms | 0.1% | 8.4ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4149` |
| 0.1% | 8.3ms | 0.1% | 8.3ms | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321242` |
| 0.1% | 8.2ms | 0.1% | 8.2ms | `trimStart` | `[native code]` |
| 0.1% | 8.1ms | 1.4% | 84.2ms | `performIteration` | `[native code]` |
| 0.1% | 8.0ms | 0.2% | 12.8ms | `[Symbol.match]` | `[native code]` |
| 0.1% | 7.8ms | 0.6% | 36.2ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5058` |
| 0.1% | 7.8ms | 0.1% | 7.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7386` |
| 0.1% | 7.7ms | 1.1% | 67.1ms | `regExpExec` | `[native code]` |
| 0.1% | 7.7ms | 0.1% | 7.7ms | `trim` | `[native code]` |
| 0.1% | 7.7ms | 0.1% | 7.7ms | `unshift` | `[native code]` |
| 0.1% | 7.5ms | 0.1% | 7.5ms | `getOwnPropertyDescriptor` | `[native code]` |
| 0.1% | 7.5ms | 0.4% | 23.9ms | `getDecorator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317883` |
| 0.1% | 7.2ms | 0.2% | 16.8ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1656` |
| 0.1% | 6.9ms | 0.1% | 6.9ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 6.9ms | 2.4% | 138.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328294` |
| 0.1% | 6.5ms | 0.1% | 6.5ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3689` |
| 0.1% | 6.3ms | 0.3% | 21.0ms | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321244` |
| 0.1% | 6.3ms | 0.1% | 6.3ms | `_LazyReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4072` |
| 0.1% | 6.2ms | 0.1% | 6.2ms | `seedTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318218` |
| 0.1% | 6.0ms | 10.3% | 585.0ms | `bound checkJsdoc` | `[native code]` |
| 0.1% | 6.0ms | 0.1% | 6.0ms | `splitSpace` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318206` |
| 0.1% | 6.0ms | 0.1% | 6.0ms | `/(?:\[(?<text>[^\]]+)\])\{@(?<tag>[^\}\s]+)\s?(?<namepathOrURL>[^\}\s\\|]*)\}/dgv` | `[native code]` |
| 0.1% | 5.9ms | 0.1% | 5.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7680` |
| 0.1% | 5.7ms | 0.1% | 5.7ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.1% | 5.7ms | 0.1% | 5.7ms | `replaceAll` | `[native code]` |
| 0.0% | 5.6ms | 0.0% | 5.6ms | `getBasicUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320404` |
| 0.0% | 5.5ms | 0.0% | 5.5ms | `ensureMap` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319767` |
| 0.0% | 5.4ms | 0.0% | 5.4ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318159` |
| 0.0% | 5.4ms | 0.0% | 5.4ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:645` |
| 0.0% | 5.3ms | 0.0% | 5.3ms | `maskCodeBlocks` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 5.2ms | 0.3% | 20.9ms | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317968` |
| 0.0% | 5.0ms | 0.0% | 5.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1317` |
| 0.0% | 4.8ms | 0.1% | 6.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319636` |
| 0.0% | 4.8ms | 0.1% | 6.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329318` |
| 0.0% | 4.7ms | 0.1% | 6.6ms | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318008` |
| 0.0% | 4.7ms | 0.0% | 4.7ms | `/\r+$/` | `[native code]` |
| 0.0% | 4.7ms | 0.2% | 15.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329124` |
| 0.0% | 4.5ms | 0.0% | 4.5ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 4.5ms | 0.0% | 4.5ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1677` |
| 0.0% | 4.5ms | 0.1% | 7.6ms | `replace` | `[native code]` |
| 0.0% | 4.5ms | 0.5% | 30.5ms | `some` | `[native code]` |
| 0.0% | 4.4ms | 0.0% | 4.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4265` |
| 0.0% | 4.4ms | 0.0% | 4.4ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318183` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:648` |
| 0.0% | 4.1ms | 2.1% | 123.1ms | `parseDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318819` |
| 0.0% | 4.1ms | 0.0% | 4.1ms | `checkJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321480` |
| 0.0% | 4.1ms | 0.0% | 4.1ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318270` |
| 0.0% | 4.1ms | 0.0% | 4.1ms | `isNameOrNamepathDefiningTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319816` |
| 0.0% | 3.9ms | 0.0% | 3.9ms | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318580` |
| 0.0% | 3.9ms | 0.2% | 12.9ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320424` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320782` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `join` | `[native code]` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `/^\/\*\*\s/v` | `[native code]` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `toLocaleLowerCase` | `[native code]` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:5093` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `join` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318605` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `parseBlock` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `endsWith` | `[native code]` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3737` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `Map` | `[native code]` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1653` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `trimEnd` | `[native code]` |
| 0.0% | 3.2ms | 11.3% | 639.2ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318031` |
| 0.0% | 3.2ms | 0.3% | 17.2ms | `getAncestors` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3698` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `/^@[^\s/]+(?=\s\|$)/` | `[native code]` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1192` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `defineProperty` | `[native code]` |
| 0.0% | 3.2ms | 90.2% | 5.08s | `(anonymous)` | `[native code]` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `log` | `[native code]` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7689` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:772` |
| 0.0% | 3.1ms | 0.4% | 27.2ms | `getNonJsdocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318088` |
| 0.0% | 3.1ms | 0.1% | 10.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318591` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329130` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320954` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4187` |
| 0.0% | 3.0ms | 0.4% | 25.2ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318026` |
| 0.0% | 3.0ms | 0.4% | 23.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4271` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318267` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7368` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318173` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `getParser3` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318301` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `getTokensBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3518` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_jdReadStr` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4907` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1230` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_jdReadStr` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4899` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318286` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `nameTokenizer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318413` |
| 0.0% | 2.8ms | 0.3% | 17.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318586` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:635` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `repeat` | `[native code]` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `bind` | `[native code]` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `splitCR` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318202` |
| 0.0% | 2.7ms | 8.4% | 477.9ms | `getNonJsdocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318089` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4160` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2198` |
| 0.0% | 2.6ms | 0.1% | 8.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318554` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332280` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1977` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:725` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2241` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318139` |
| 0.0% | 2.4ms | 0.0% | 2.4ms | `get unicode` | `[native code]` |
| 0.0% | 2.2ms | 0.0% | 2.2ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4106` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1308` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.8ms | 1.0% | 58.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329344` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `/([ \t]+\*)[ \t]@(?:example)(?=[ \n])([\w\\|\W]*?\n)(?=[ \t]*\*(?:[ \t]*@\w+\s\|\/))/gv` | `[native code]` |
| 0.0% | 1.8ms | 0.1% | 6.3ms | `tryParslets` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315094` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321653` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `add` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318269` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:657` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `Lc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `uniqueSymbolParslet` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316988` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1021` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:183987` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323669` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:967` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `hasRejectValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318020` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:337106` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:265` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:650` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `hasSchemaOption` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320165` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getBasicUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320385` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:232476` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301300` |
| 0.0% | 1.7ms | 0.4% | 23.4ms | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321250` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330658` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `checkHyphens` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.7ms | 17.4% | 983.7ms | `bound ` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `rewireSpecs` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318228` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320501` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_ensureNameToTagIds` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317683` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `toLocaleUpperCase` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get message` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4114` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3763` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326709` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1974` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `dlopen` | `[native code]` |
| 0.0% | 1.7ms | 0.6% | 35.4ms | `flatIntoArrayWithCallback` | `[native code]` |
| 0.0% | 1.7ms | 0.2% | 12.6ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1027` |
| 0.0% | 1.6ms | 0.3% | 17.3ms | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317993` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:310149` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `makeSafeRegex` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:226508` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:8` |
| 0.0% | 1.6ms | 0.2% | 15.8ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318271` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183383` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:169312` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getBasicUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320400` |
| 0.0% | 1.6ms | 5.6% | 320.5ms | `checkJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321487` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `onNodeWithComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1962` |
| 0.0% | 1.6ms | 0.2% | 13.5ms | `flatMap` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320445` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getJsdocTagsDeep` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319524` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getText` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1332` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `flat` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330541` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `test` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/comparator.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:51143` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `makeReport` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321182` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `parse` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `findExpectedIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332309` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getBasicUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320368` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `regexTester` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `fix10` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330476` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getBasicUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320373` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:779` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `/^\/\*(?!\*)/v` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 2.9ms | `getRegexFromString` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320201` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3747` |
| 0.0% | 1.5ms | 7.6% | 428.8ms | `invokeHandlersWithNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6890` |
| 0.0% | 1.5ms | 0.2% | 13.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1316` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getLocFromIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3658` |
| 0.0% | 1.5ms | 0.0% | 4.8ms | `parseBlock` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318242` |
| 0.0% | 1.5ms | 0.0% | 3.2ms | `getCommentsBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3400` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:200125` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `fix10` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.5ms | 2.3% | 132.8ms | `parseInlineTags` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318839` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318583` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1666` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328278` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getPreferredTagName` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319653` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get unicodeSets` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1307` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318163` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321095` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334004` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1672` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:169445` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318048` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190605` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:179731` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330804` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `hasRejectValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333274` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `hasRejectValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333310` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `nullableParslet` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315145` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `Boolean` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171518` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2213` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get global` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 2.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7692` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320771` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6927` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `setCustomPollingValues` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `default` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328458` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1309` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2205` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318180` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330261` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getDefaultTagStructureForMode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314378` |
| 0.0% | 1.4ms | 8.9% | 505.0ms | `checkNonJsdocAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326355` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318051` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `GetIntrinsic` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:94709` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.1% | 7.8ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4173` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318171` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320896` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318292` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `Uint8Array` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `replaceXRanges` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `/[^\p{L}\d]+/giu` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323695` |
| 0.0% | 1.4ms | 0.0% | 2.8ms | `readFileSync` | `[native code]` |
| 0.0% | 1.4ms | 0.1% | 7.4ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5043` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_getSharedCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:746` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `ensureMap` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319770` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318578` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1246` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `__export` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:24` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `typeTokenizer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318341` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `__toESM` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.3ms | 48.2% | 2.71s | `iterate` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321202` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `normalizeWord` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327009` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `keys` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329388` |
| 0.0% | 1.3ms | 0.1% | 9.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334351` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/node.js:260` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318135` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:58290` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `createSafeIterator` | `internal:primordials` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334030` |
| 0.0% | 1.3ms | 0.0% | 2.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333697` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318263` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_tokType` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:601` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:193121` |
| 0.0% | 1.3ms | 11.9% | 673.4ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318154` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `createTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332506` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `ownKeys` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `values` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get hasIndices` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `LRUCache` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/internal/lrucache.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317650` |
| 0.0% | 1.3ms | 0.0% | 2.6ms | `getPreferredTagNameSimple` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319596` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `canSkip6` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334515` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `flattenRoots` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319292` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `namePathParslet` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318059` |
| 0.0% | 1.2ms | 0.5% | 31.1ms | `bound checkNonJsdoc` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 2.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328273` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7090` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1794` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:711` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173322` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get key` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5073` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `/Note that this does not return projects in info\.containingProjects$/mv` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322605` |
| 0.0% | 1.2ms | 0.0% | 2.5ms | `getParamName` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319373` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getDefaultTagStructureForMode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314561` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `encodeInto` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `parseBlock` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318241` |
| 0.0% | 1.2ms | 0.6% | 39.1ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320420` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `rootNamer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332199` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7092` |
| 0.0% | 1.1ms | 0.0% | 1.1ms | `__toESM` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:11` |
| 0.0% | 1.0ms | 0.0% | 1.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323931` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 90.2% | 5.08s | 0.0% | 3.2ms | `(anonymous)` | `[native code]` |
| 90.2% | 5.07s | 0.0% | 0us | `processTicksAndRejections` | `[native code]` |
| 84.5% | 4.75s | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:274` |
| 83.4% | 4.69s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8207` |
| 70.0% | 3.94s | 0.9% | 55.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7720` |
| 48.2% | 2.71s | 0.0% | 1.3ms | `iterate` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321202` |
| 44.9% | 2.53s | 0.0% | 0us | `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321371` |
| 44.9% | 2.52s | 0.0% | 0us | `onNodeWithComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321318` |
| 43.9% | 2.47s | 0.0% | 0us | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321280` |
| 42.5% | 2.39s | 0.2% | 13.8ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5080` |
| 28.6% | 1.61s | 28.6% | 1.61s | `slice` | `[native code]` |
| 28.6% | 1.61s | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327227` |
| 27.9% | 1.57s | 4.2% | 237.0ms | `anonymous` | `[native code]` |
| 27.5% | 1.55s | 0.0% | 0us | `bound require` | `[native code]` |
| 27.4% | 1.54s | 0.0% | 0us | `require` | `[native code]` |
| 25.4% | 1.43s | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:33` |
| 18.7% | 1.05s | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5023` |
| 17.4% | 983.7ms | 0.0% | 1.7ms | `bound ` | `[native code]` |
| 11.9% | 673.4ms | 0.0% | 1.3ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318154` |
| 11.3% | 639.2ms | 0.0% | 3.2ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318031` |
| 11.0% | 623.7ms | 1.4% | 80.4ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1673` |
| 10.7% | 603.3ms | 1.1% | 66.5ms | `filter` | `[native code]` |
| 10.3% | 585.0ms | 0.1% | 6.0ms | `bound checkJsdoc` | `[native code]` |
| 10.3% | 580.6ms | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5035` |
| 9.7% | 550.0ms | 0.0% | 0us | `parseModule` | `[native code]` |
| 9.7% | 550.0ms | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 9.4% | 534.7ms | 0.0% | 0us | `_loadBundle` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-loader.js:34` |
| 9.4% | 534.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_jsdoc_all.js:19` |
| 9.4% | 534.7ms | 0.0% | 0us | `bundleRulesFor` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-loader.js:59` |
| 8.9% | 506.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326382` |
| 8.9% | 505.1ms | 0.0% | 0us | `checkNonJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326338` |
| 8.9% | 505.0ms | 0.0% | 1.4ms | `checkNonJsdocAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326355` |
| 8.9% | 503.6ms | 0.0% | 0us | `getTokensAfterIgnoringSemis` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318100` |
| 8.9% | 503.6ms | 0.0% | 0us | `tokenAfterIgnoringSemis` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318107` |
| 8.9% | 503.6ms | 0.0% | 0us | `getFollowingComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318110` |
| 8.6% | 486.5ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7822` |
| 8.5% | 480.0ms | 0.0% | 0us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6952` |
| 8.4% | 477.9ms | 0.0% | 2.7ms | `getNonJsdocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318089` |
| 8.4% | 475.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326380` |
| 8.2% | 464.1ms | 0.0% | 0us | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1947` |
| 7.9% | 446.1ms | 0.2% | 14.7ms | `_getAllTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1932` |
| 7.6% | 428.8ms | 0.0% | 1.5ms | `invokeHandlersWithNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6890` |
| 7.3% | 411.5ms | 7.2% | 405.9ms | `getTokensAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3566` |
| 5.6% | 320.5ms | 0.0% | 1.6ms | `checkJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321487` |
| 5.5% | 310.5ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` |
| 5.3% | 299.3ms | 0.4% | 25.9ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318182` |
| 5.0% | 284.4ms | 0.0% | 0us | `parseComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318950` |
| 4.2% | 238.4ms | 0.2% | 11.7ms | `map` | `[native code]` |
| 4.0% | 230.3ms | 0.0% | 0us | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318058` |
| 4.0% | 229.4ms | 4.0% | 229.4ms | `parse` | `[native code]` |
| 4.0% | 227.9ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` |
| 3.5% | 200.8ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7919` |
| 3.5% | 197.8ms | 3.5% | 197.8ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1300` |
| 3.3% | 185.9ms | 0.0% | 0us | `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321368` |
| 3.2% | 181.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329112` |
| 3.2% | 180.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329113` |
| 3.0% | 171.7ms | 0.1% | 9.5ms | `checkJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321476` |
| 2.9% | 167.2ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321404` |
| 2.9% | 164.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328272` |
| 2.8% | 161.7ms | 0.0% | 0us | `matchAll` | `[native code]` |
| 2.8% | 158.1ms | 0.2% | 12.7ms | `parseDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318820` |
| 2.6% | 151.6ms | 0.0% | 0us | `parseInlineTags` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318842` |
| 2.6% | 147.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329110` |
| 2.4% | 138.0ms | 0.1% | 6.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328294` |
| 2.3% | 133.5ms | 2.1% | 119.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329111` |
| 2.3% | 132.8ms | 0.0% | 1.5ms | `parseInlineTags` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318839` |
| 2.3% | 132.7ms | 2.2% | 125.9ms | `get flags` | `[native code]` |
| 2.3% | 131.0ms | 0.0% | 0us | `parse3` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318783` |
| 2.3% | 130.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329115` |
| 2.1% | 123.1ms | 0.0% | 4.1ms | `parseDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318819` |
| 2.1% | 121.0ms | 0.0% | 0us | `getPreferredTagName` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319659` |
| 2.1% | 119.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313242` |
| 2.1% | 119.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329778` |
| 2.0% | 116.7ms | 0.0% | 0us | `getPreferredTagNameSimple` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319615` |
| 2.0% | 115.5ms | 0.3% | 21.3ms | `test` | `[native code]` |
| 2.0% | 115.4ms | 2.0% | 115.4ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1288` |
| 1.9% | 112.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327361` |
| 1.9% | 112.1ms | 1.2% | 70.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329116` |
| 1.9% | 110.7ms | 0.0% | 0us | `validateDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327351` |
| 1.8% | 102.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173370` |
| 1.8% | 101.3ms | 0.0% | 0us | `getIndentAndJSDoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321224` |
| 1.7% | 98.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172663` |
| 1.7% | 98.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173342` |
| 1.7% | 96.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172520` |
| 1.6% | 94.9ms | 1.4% | 81.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329779` |
| 1.6% | 94.2ms | 1.6% | 94.2ms | ``/^\n?([A-Z`\d_][\s\S]*[.?!`\p{RGI_Emoji}]\s*)?$/v`` | `[native code]` |
| 1.6% | 93.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171858` |
| 1.6% | 93.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172438` |
| 1.6% | 92.4ms | 1.6% | 92.4ms | `entries` | `[native code]` |
| 1.6% | 92.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/index.js:18` |
| 1.6% | 92.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171637` |
| 1.6% | 92.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171483` |
| 1.5% | 84.5ms | 1.5% | 84.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 1.4% | 84.2ms | 0.1% | 8.1ms | `performIteration` | `[native code]` |
| 1.4% | 82.5ms | 0.0% | 0us | `checkJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321483` |
| 1.4% | 81.3ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` |
| 1.3% | 77.4ms | 0.1% | 8.8ms | `next` | `[native code]` |
| 1.3% | 76.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:168241` |
| 1.3% | 76.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:168417` |
| 1.3% | 76.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313234` |
| 1.3% | 75.3ms | 0.0% | 0us | `iterate` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321187` |
| 1.3% | 74.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321087` |
| 1.2% | 72.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/clear-caches.js:5` |
| 1.2% | 70.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/getWatchProgramsForProjects.js:45` |
| 1.2% | 70.7ms | 0.0% | 0us | `forEachPreferredTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319681` |
| 1.2% | 69.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:30` |
| 1.2% | 69.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:48` |
| 1.2% | 69.4ms | 1.2% | 69.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:3` |
| 1.2% | 68.2ms | 1.2% | 68.2ms | `getTokensAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3565` |
| 1.1% | 67.1ms | 0.1% | 7.7ms | `regExpExec` | `[native code]` |
| 1.1% | 65.9ms | 0.5% | 28.7ms | `regExpSplitFast` | `[native code]` |
| 1.1% | 65.8ms | 1.1% | 65.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301326` |
| 1.0% | 59.3ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8206` |
| 1.0% | 58.5ms | 0.0% | 1.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329344` |
| 0.9% | 54.7ms | 0.9% | 54.7ms | `/(?<!\])\{@(?<tag>[^\}\s]+)\s?(?<namepathOrURL>[^\}\s\\|]*)\s*(?<separator>[\s\\|])?\s*(?<text>[^\}]*)\}/dgv` | `[native code]` |
| 0.9% | 54.2ms | 0.5% | 28.5ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1975` |
| 0.9% | 53.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329251` |
| 0.9% | 53.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320906` |
| 0.9% | 53.0ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:303` |
| 0.9% | 53.0ms | 0.9% | 53.0ms | `DataView` | `[native code]` |
| 0.9% | 51.6ms | 0.0% | 0us | `get lines` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3580` |
| 0.9% | 51.6ms | 0.0% | 0us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321473` |
| 0.9% | 51.1ms | 0.0% | 0us | `invokeHandlersWithNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6894` |
| 0.9% | 50.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318587` |
| 0.8% | 46.4ms | 0.8% | 45.1ms | `Set` | `[native code]` |
| 0.8% | 46.0ms | 0.5% | 32.2ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1285` |
| 0.7% | 43.8ms | 0.1% | 10.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.7% | 42.8ms | 0.7% | 42.8ms | `getValidRuntimeIdentifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329198` |
| 0.7% | 42.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:337820` |
| 0.7% | 42.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290165` |
| 0.7% | 42.1ms | 0.7% | 42.1ms | `/^\s*globals/v` | `[native code]` |
| 0.7% | 41.8ms | 0.0% | 0us | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318057` |
| 0.7% | 39.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:293567` |
| 0.7% | 39.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/unsupported-api.js:14` |
| 0.6% | 39.1ms | 0.0% | 1.2ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320420` |
| 0.6% | 37.1ms | 0.6% | 37.1ms | `/\r\n\|\r\|\n\|\u2028\|\u2029/` | `[native code]` |
| 0.6% | 36.3ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4559` |
| 0.6% | 36.2ms | 0.1% | 7.8ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5058` |
| 0.6% | 35.4ms | 0.0% | 1.7ms | `flatIntoArrayWithCallback` | `[native code]` |
| 0.5% | 33.6ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321382` |
| 0.5% | 32.7ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4190` |
| 0.5% | 31.1ms | 0.0% | 1.2ms | `bound checkNonJsdoc` | `[native code]` |
| 0.5% | 30.9ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321174` |
| 0.5% | 30.5ms | 0.0% | 4.5ms | `some` | `[native code]` |
| 0.5% | 30.4ms | 0.0% | 0us | `onProgramExit` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321334` |
| 0.5% | 29.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313261` |
| 0.4% | 28.0ms | 0.4% | 28.0ms | `/^\*(?!\*)/v` | `[native code]` |
| 0.4% | 27.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:44` |
| 0.4% | 27.2ms | 0.0% | 3.1ms | `getNonJsdocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318088` |
| 0.4% | 26.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318590` |
| 0.4% | 25.9ms | 0.0% | 0us | `find` | `[native code]` |
| 0.4% | 25.9ms | 0.1% | 10.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319619` |
| 0.4% | 25.2ms | 0.0% | 3.0ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318026` |
| 0.4% | 24.1ms | 0.4% | 24.1ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1264` |
| 0.4% | 23.9ms | 0.1% | 7.5ms | `getDecorator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317883` |
| 0.4% | 23.8ms | 0.4% | 23.8ms | `getTokensAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3563` |
| 0.4% | 23.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327372` |
| 0.4% | 23.5ms | 0.4% | 23.5ms | `stringSplitFast` | `[native code]` |
| 0.4% | 23.4ms | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4161` |
| 0.4% | 23.4ms | 0.0% | 1.7ms | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321250` |
| 0.4% | 23.3ms | 0.0% | 3.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4271` |
| 0.3% | 21.3ms | 0.3% | 21.3ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1292` |
| 0.3% | 21.2ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4682` |
| 0.3% | 21.0ms | 0.1% | 6.3ms | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321244` |
| 0.3% | 20.9ms | 0.0% | 5.2ms | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317968` |
| 0.3% | 20.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:20` |
| 0.3% | 20.7ms | 0.3% | 20.7ms | `getAncestors` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3668` |
| 0.3% | 20.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329120` |
| 0.3% | 19.8ms | 0.3% | 19.8ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1260` |
| 0.3% | 19.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/clear-caches.js:6` |
| 0.3% | 19.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/index.js:3` |
| 0.3% | 19.2ms | 0.3% | 19.2ms | `esSpecIsRegExp` | `[native code]` |
| 0.3% | 19.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:198766` |
| 0.3% | 19.0ms | 0.0% | 0us | `getAllComments` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3465` |
| 0.3% | 19.0ms | 0.0% | 0us | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1948` |
| 0.3% | 18.9ms | 0.1% | 10.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328274` |
| 0.3% | 18.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329121` |
| 0.3% | 18.3ms | 0.3% | 18.3ms | `[Symbol.matchAll]` | `[native code]` |
| 0.3% | 18.0ms | 0.3% | 18.0ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.3% | 18.0ms | 0.0% | 0us | `every` | `[native code]` |
| 0.3% | 18.0ms | 0.0% | 0us | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321271` |
| 0.3% | 18.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321276` |
| 0.3% | 17.9ms | 0.2% | 16.6ms | `_getAllTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1933` |
| 0.3% | 17.9ms | 0.0% | 0us | `we` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.3% | 17.9ms | 0.0% | 0us | `ke` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.3% | 17.9ms | 0.0% | 0us | `Pe` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.3% | 17.5ms | 0.3% | 17.5ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318170` |
| 0.3% | 17.3ms | 0.0% | 1.6ms | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317993` |
| 0.3% | 17.3ms | 0.0% | 0us | `parseBlock` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318247` |
| 0.3% | 17.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318254` |
| 0.3% | 17.3ms | 0.0% | 0us | `toggleFence` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318237` |
| 0.3% | 17.2ms | 0.0% | 2.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318586` |
| 0.3% | 17.2ms | 0.0% | 3.2ms | `getAncestors` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3698` |
| 0.3% | 17.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173369` |
| 0.2% | 16.8ms | 0.1% | 7.2ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1656` |
| 0.2% | 16.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/apply-disable-directives.js:22` |
| 0.2% | 16.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:19` |
| 0.2% | 15.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320471` |
| 0.2% | 15.8ms | 0.2% | 15.8ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:731` |
| 0.2% | 15.8ms | 0.0% | 1.6ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318271` |
| 0.2% | 15.7ms | 0.2% | 15.7ms | `includes` | `[native code]` |
| 0.2% | 15.7ms | 0.0% | 4.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329124` |
| 0.2% | 15.4ms | 0.2% | 15.4ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318167` |
| 0.2% | 14.9ms | 0.0% | 0us | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321241` |
| 0.2% | 14.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327386` |
| 0.2% | 14.4ms | 0.2% | 14.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.2% | 14.3ms | 0.0% | 0us | `splitLines` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318209` |
| 0.2% | 13.7ms | 0.0% | 1.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1316` |
| 0.2% | 13.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:43` |
| 0.2% | 13.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/Scope.js:38` |
| 0.2% | 13.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/index.js:26` |
| 0.2% | 13.7ms | 0.2% | 13.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7382` |
| 0.2% | 13.6ms | 0.2% | 13.6ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318155` |
| 0.2% | 13.5ms | 0.0% | 0us | `_e` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.2% | 13.5ms | 0.0% | 1.6ms | `flatMap` | `[native code]` |
| 0.2% | 13.5ms | 0.2% | 13.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7855` |
| 0.2% | 13.1ms | 0.0% | 0us | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317998` |
| 0.2% | 12.9ms | 0.0% | 3.9ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320424` |
| 0.2% | 12.8ms | 0.0% | 0us | `match` | `[native code]` |
| 0.2% | 12.8ms | 0.1% | 8.0ms | `[Symbol.match]` | `[native code]` |
| 0.2% | 12.6ms | 0.0% | 1.7ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1027` |
| 0.2% | 12.5ms | 0.2% | 12.5ms | `getCommentsBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3401` |
| 0.2% | 12.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_jsdoc_all.js:10` |
| 0.2% | 12.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/analyze.js:5` |
| 0.2% | 12.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/index.js:18` |
| 0.2% | 12.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/index.js:4` |
| 0.2% | 12.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:12` |
| 0.2% | 11.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301236` |
| 0.2% | 11.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92697` |
| 0.2% | 11.7ms | 0.2% | 11.7ms | `getBasicUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320370` |
| 0.2% | 11.5ms | 0.0% | 0us | `compactJoiner` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318554` |
| 0.2% | 11.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318593` |
| 0.1% | 11.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323005` |
| 0.1% | 11.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323004` |
| 0.1% | 11.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320382` |
| 0.1% | 10.9ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:911` |
| 0.1% | 10.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332545` |
| 0.1% | 10.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317738` |
| 0.1% | 10.8ms | 0.0% | 0us | `g` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.1% | 10.8ms | 0.1% | 10.8ms | `getText` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1346` |
| 0.1% | 10.7ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:502` |
| 0.1% | 10.7ms | 0.1% | 10.7ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4577` |
| 0.1% | 10.6ms | 0.1% | 10.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4266` |
| 0.1% | 10.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:19` |
| 0.1% | 10.5ms | 0.1% | 10.5ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1202` |
| 0.1% | 10.4ms | 0.0% | 3.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318591` |
| 0.1% | 10.4ms | 0.1% | 10.4ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321034` |
| 0.1% | 10.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:11` |
| 0.1% | 10.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:15` |
| 0.1% | 9.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320897` |
| 0.1% | 9.7ms | 0.1% | 9.7ms | `stringIncludesInternal` | `[native code]` |
| 0.1% | 9.5ms | 0.1% | 9.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7682` |
| 0.1% | 9.4ms | 0.1% | 9.4ms | `RegExp` | `[native code]` |
| 0.1% | 9.3ms | 0.1% | 9.3ms | `push` | `[native code]` |
| 0.1% | 9.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` |
| 0.1% | 9.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/default-config.js:37` |
| 0.1% | 9.2ms | 0.0% | 0us | `Ae` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.1% | 9.2ms | 0.0% | 0us | `parse` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.1% | 9.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329334` |
| 0.1% | 9.1ms | 0.1% | 9.1ms | `concat` | `[native code]` |
| 0.1% | 9.1ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334351` |
| 0.1% | 9.0ms | 0.0% | 0us | `fixer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332536` |
| 0.1% | 9.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320472` |
| 0.1% | 8.7ms | 0.0% | 2.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318554` |
| 0.1% | 8.6ms | 0.1% | 8.6ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318152` |
| 0.1% | 8.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/ast-converter.js:4` |
| 0.1% | 8.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/convert.js:41` |
| 0.1% | 8.6ms | 0.1% | 8.6ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1228` |
| 0.1% | 8.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:7` |
| 0.1% | 8.4ms | 0.1% | 8.4ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4149` |
| 0.1% | 8.3ms | 0.1% | 8.3ms | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321242` |
| 0.1% | 8.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301278` |
| 0.1% | 8.2ms | 0.1% | 8.2ms | `trimStart` | `[native code]` |
| 0.1% | 8.2ms | 0.0% | 0us | `forEach` | `[native code]` |
| 0.1% | 8.0ms | 0.0% | 0us | `splitSpace` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318205` |
| 0.1% | 8.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334213` |
| 0.1% | 7.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:277230` |
| 0.1% | 7.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:277206` |
| 0.1% | 7.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:276659` |
| 0.1% | 7.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289828` |
| 0.1% | 7.8ms | 0.1% | 7.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7386` |
| 0.1% | 7.8ms | 0.0% | 1.4ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4173` |
| 0.1% | 7.7ms | 0.0% | 0us | `fix10` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332524` |
| 0.1% | 7.7ms | 0.1% | 7.7ms | `trim` | `[native code]` |
| 0.1% | 7.7ms | 0.0% | 0us | `checkTagName` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334313` |
| 0.1% | 7.7ms | 0.1% | 7.7ms | `unshift` | `[native code]` |
| 0.1% | 7.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329313` |
| 0.1% | 7.6ms | 0.0% | 0us | `hasTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319635` |
| 0.1% | 7.6ms | 0.0% | 4.5ms | `replace` | `[native code]` |
| 0.1% | 7.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/index.js:12` |
| 0.1% | 7.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/index.js:3` |
| 0.1% | 7.5ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318265` |
| 0.1% | 7.5ms | 0.1% | 7.5ms | `getOwnPropertyDescriptor` | `[native code]` |
| 0.1% | 7.4ms | 0.0% | 1.4ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5043` |
| 0.1% | 7.2ms | 0.0% | 0us | `commentParserToESTree` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317553` |
| 0.1% | 7.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:38` |
| 0.1% | 6.9ms | 0.1% | 6.9ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 6.9ms | 0.0% | 0us | `isNameOrNamepathDefiningTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319812` |
| 0.1% | 6.7ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:279` |
| 0.1% | 6.7ms | 0.0% | 0us | `getESLintCoreRule` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:174894` |
| 0.1% | 6.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318608` |
| 0.1% | 6.6ms | 0.0% | 4.7ms | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318008` |
| 0.1% | 6.6ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318277` |
| 0.1% | 6.5ms | 0.0% | 0us | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318001` |
| 0.1% | 6.5ms | 0.1% | 6.5ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3689` |
| 0.1% | 6.4ms | 0.0% | 4.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329318` |
| 0.1% | 6.4ms | 0.0% | 0us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4306` |
| 0.1% | 6.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327262` |
| 0.1% | 6.3ms | 0.1% | 6.3ms | `_LazyReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4072` |
| 0.1% | 6.3ms | 0.0% | 0us | `parse` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315065` |
| 0.1% | 6.3ms | 0.0% | 1.8ms | `tryParslets` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315094` |
| 0.1% | 6.3ms | 0.0% | 0us | `parseIntermediateType` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315075` |
| 0.1% | 6.3ms | 0.0% | 0us | `parse2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317154` |
| 0.1% | 6.3ms | 0.0% | 0us | `parseType` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315072` |
| 0.1% | 6.3ms | 0.0% | 0us | `maskExcludedContent` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322973` |
| 0.1% | 6.3ms | 0.0% | 4.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319636` |
| 0.1% | 6.2ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318264` |
| 0.1% | 6.2ms | 0.1% | 6.2ms | `seedTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318218` |
| 0.1% | 6.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:497` |
| 0.1% | 6.1ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:455` |
| 0.1% | 6.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:20` |
| 0.1% | 6.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334556` |
| 0.1% | 6.0ms | 0.0% | 0us | `checkTagName2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334521` |
| 0.1% | 6.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-modifiers.js:38` |
| 0.1% | 6.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/getModifiers.js:39` |
| 0.1% | 6.0ms | 0.1% | 6.0ms | `splitSpace` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318206` |
| 0.1% | 6.0ms | 0.1% | 6.0ms | `/(?:\[(?<text>[^\]]+)\])\{@(?<tag>[^\}\s]+)\s?(?<namepathOrURL>[^\}\s\\|]*)\}/dgv` | `[native code]` |
| 0.1% | 6.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333370` |
| 0.1% | 6.0ms | 0.0% | 0us | `shouldReport` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333368` |
| 0.1% | 6.0ms | 0.0% | 0us | `getSettings` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321129` |
| 0.1% | 6.0ms | 0.0% | 0us | `setTagStructure` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319286` |
| 0.1% | 5.9ms | 0.1% | 5.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7680` |
| 0.1% | 5.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313046` |
| 0.1% | 5.7ms | 0.1% | 5.7ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.1% | 5.7ms | 0.0% | 0us | `maskCodeBlocks` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322980` |
| 0.1% | 5.7ms | 0.1% | 5.7ms | `replaceAll` | `[native code]` |
| 0.0% | 5.6ms | 0.0% | 5.6ms | `getBasicUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320404` |
| 0.0% | 5.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323937` |
| 0.0% | 5.5ms | 0.0% | 5.5ms | `ensureMap` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319767` |
| 0.0% | 5.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92623` |
| 0.0% | 5.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92521` |
| 0.0% | 5.4ms | 0.0% | 5.4ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318159` |
| 0.0% | 5.4ms | 0.0% | 5.4ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:645` |
| 0.0% | 5.3ms | 0.0% | 5.3ms | `maskCodeBlocks` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 5.1ms | 0.0% | 0us | `camelCase` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295758` |
| 0.0% | 5.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320473` |
| 0.0% | 5.0ms | 0.0% | 0us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6928` |
| 0.0% | 5.0ms | 0.0% | 5.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1317` |
| 0.0% | 5.0ms | 0.0% | 0us | `_fromRunnerReport` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:205` |
| 0.0% | 4.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323945` |
| 0.0% | 4.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332870` |
| 0.0% | 4.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301314` |
| 0.0% | 4.8ms | 0.0% | 0us | `addPolyfillToken` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301274` |
| 0.0% | 4.8ms | 0.0% | 0us | `maskExcludedContent` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322972` |
| 0.0% | 4.8ms | 0.0% | 1.5ms | `parseBlock` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318242` |
| 0.0% | 4.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333473` |
| 0.0% | 4.7ms | 0.0% | 0us | `getValidRuntimeIdentifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329197` |
| 0.0% | 4.7ms | 0.0% | 0us | `splitCR` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318201` |
| 0.0% | 4.7ms | 0.0% | 4.7ms | `/\r+$/` | `[native code]` |
| 0.0% | 4.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332964` |
| 0.0% | 4.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328277` |
| 0.0% | 4.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329082` |
| 0.0% | 4.7ms | 0.0% | 0us | `get globalScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3938` |
| 0.0% | 4.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332236` |
| 0.0% | 4.6ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:729` |
| 0.0% | 4.5ms | 0.0% | 4.5ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 4.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329781` |
| 0.0% | 4.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329780` |
| 0.0% | 4.5ms | 0.0% | 4.5ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1677` |
| 0.0% | 4.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326780` |
| 0.0% | 4.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333797` |
| 0.0% | 4.4ms | 0.0% | 4.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4265` |
| 0.0% | 4.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:324134` |
| 0.0% | 4.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:37` |
| 0.0% | 4.4ms | 0.0% | 4.4ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318183` |
| 0.0% | 4.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319742` |
| 0.0% | 4.3ms | 0.0% | 0us | `hasATag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319741` |
| 0.0% | 4.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.0% | 4.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:9` |
| 0.0% | 4.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/rules.js:3` |
| 0.0% | 4.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326165` |
| 0.0% | 4.3ms | 0.0% | 0us | `Ce` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:648` |
| 0.0% | 4.2ms | 0.0% | 0us | `exec` | `[native code]` |
| 0.0% | 4.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:110358` |
| 0.0% | 4.2ms | 0.0% | 0us | `hasRejectValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333266` |
| 0.0% | 4.2ms | 0.0% | 0us | `hasRejectValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333269` |
| 0.0% | 4.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317739` |
| 0.0% | 4.2ms | 0.0% | 0us | `validateDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330453` |
| 0.0% | 4.2ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330485` |
| 0.0% | 4.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330562` |
| 0.0% | 4.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330499` |
| 0.0% | 4.1ms | 0.0% | 4.1ms | `checkJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321480` |
| 0.0% | 4.1ms | 0.0% | 4.1ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318270` |
| 0.0% | 4.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:3` |
| 0.0% | 4.1ms | 0.0% | 4.1ms | `isNameOrNamepathDefiningTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319816` |
| 0.0% | 3.9ms | 0.0% | 3.9ms | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318580` |
| 0.0% | 3.8ms | 0.0% | 0us | `getCommentsBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3421` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320782` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `join` | `[native code]` |
| 0.0% | 3.4ms | 0.0% | 0us | `findExpectedIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332296` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `/^\/\*\*\s/v` | `[native code]` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `toLocaleLowerCase` | `[native code]` |
| 0.0% | 3.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295778` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:5093` |
| 0.0% | 3.4ms | 0.0% | 0us | `jsdocTagsByName` | `/Users/ericsan/Development/OpenSource/Ez/js/rewrite-helpers.js:511` |
| 0.0% | 3.4ms | 0.0% | 0us | `tagsByName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:5093` |
| 0.0% | 3.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333037` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `join` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318605` |
| 0.0% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320468` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `parseBlock` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `endsWith` | `[native code]` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3737` |
| 0.0% | 3.3ms | 0.0% | 0us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321439` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `Map` | `[native code]` |
| 0.0% | 3.3ms | 0.0% | 0us | `getDefaultTagStructureForMode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313714` |
| 0.0% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:48` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1653` |
| 0.0% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:45765` |
| 0.0% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290269` |
| 0.0% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12521` |
| 0.0% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12515` |
| 0.0% | 3.3ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1604` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `trimEnd` | `[native code]` |
| 0.0% | 3.2ms | 0.0% | 0us | `filterTags` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319640` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330673` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321800` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `/^@[^\s/]+(?=\s\|$)/` | `[native code]` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:331031` |
| 0.0% | 3.2ms | 0.0% | 1.5ms | `getCommentsBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3400` |
| 0.0% | 3.2ms | 0.0% | 0us | `FunctionDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332133` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1192` |
| 0.0% | 3.2ms | 0.0% | 0us | `onProgramExit` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321333` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `defineProperty` | `[native code]` |
| 0.0% | 3.2ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2482` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322474` |
| 0.0% | 3.2ms | 0.0% | 0us | `validateParameterNames` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323683` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326936` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `log` | `[native code]` |
| 0.0% | 3.1ms | 0.0% | 0us | `setDeps` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326926` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7689` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92619` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:772` |
| 0.0% | 3.1ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2851` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333348` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329130` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320954` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320918` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4187` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:324381` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320936` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318267` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:324541` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290519` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:51201` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328310` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7368` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318173` |
| 0.0% | 3.0ms | 0.0% | 0us | `isValidTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319628` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320915` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:324380` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `getParser3` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318301` |
| 0.0% | 3.0ms | 0.0% | 0us | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318582` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201051` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `getTokensBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3518` |
| 0.0% | 2.9ms | 0.0% | 0us | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318034` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_jdReadStr` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4907` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333270` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320507` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332258` |
| 0.0% | 2.9ms | 0.0% | 1.5ms | `getRegexFromString` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320201` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1230` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313061` |
| 0.0% | 2.9ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7692` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_jdReadStr` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4899` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318286` |
| 0.0% | 2.8ms | 0.0% | 0us | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318575` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `nameTokenizer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318413` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:635` |
| 0.0% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138748` |
| 0.0% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313168` |
| 0.0% | 2.8ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2480` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.0% | 2.8ms | 0.0% | 0us | `y` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317741` |
| 0.0% | 2.8ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333697` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `repeat` | `[native code]` |
| 0.0% | 2.8ms | 0.0% | 0us | `getIndentAndJSDoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321223` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `bind` | `[native code]` |
| 0.0% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333871` |
| 0.0% | 2.8ms | 0.0% | 1.4ms | `readFileSync` | `[native code]` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:16` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `splitCR` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318202` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:8` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/ClassVisitor.js:6` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:21` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint/plugin-kit/dist/cjs/index.cjs:3` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:22` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:53` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/resolveProjectList.js:10` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/index.js:3` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4160` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2198` |
| 0.0% | 2.6ms | 0.0% | 0us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321302` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332280` |
| 0.0% | 2.6ms | 0.0% | 0us | `findIndex` | `[native code]` |
| 0.0% | 2.6ms | 0.0% | 0us | `findExpectedIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332279` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1977` |
| 0.0% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295761` |
| 0.0% | 2.6ms | 0.0% | 1.3ms | `getPreferredTagNameSimple` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319596` |
| 0.0% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290218` |
| 0.0% | 2.6ms | 0.0% | 0us | `fix10` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330460` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:725` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2241` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318139` |
| 0.0% | 2.5ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328273` |
| 0.0% | 2.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301308` |
| 0.0% | 2.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295760` |
| 0.0% | 2.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319509` |
| 0.0% | 2.5ms | 0.0% | 1.2ms | `getParamName` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319373` |
| 0.0% | 2.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320882` |
| 0.0% | 2.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333035` |
| 0.0% | 2.5ms | 0.0% | 0us | `getFunctionParameterNames` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319508` |
| 0.0% | 2.5ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7679` |
| 0.0% | 2.4ms | 0.0% | 2.4ms | `get unicode` | `[native code]` |
| 0.0% | 2.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:24` |
| 0.0% | 2.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301309` |
| 0.0% | 2.2ms | 0.0% | 2.2ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4106` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1308` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:16` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/code-path-analysis/code-path-state.js:12` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/code-path-analysis/code-path-segment.js:12` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/code-path-analysis/code-path.js:12` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/code-path-analysis/code-path-analyzer.js:14` |
| 0.0% | 1.8ms | 0.0% | 0us | `createToken` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:52044` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:52088` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295065` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:53668` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313169` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138801` |
| 0.0% | 1.8ms | 0.0% | 0us | `validateDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327352` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:41` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92620` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `/([ \t]+\*)[ \t]@(?:example)(?=[ \n])([\w\\|\W]*?\n)(?=[ \t]*\*(?:[ \t]*@\w+\s\|\/))/gv` | `[native code]` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201969` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188567` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201956` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:185409` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321036` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321652` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321035` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321653` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319641` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `add` | `[native code]` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301337` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:13` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320921` |
| 0.0% | 1.7ms | 0.0% | 0us | `canSkip` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333338` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320930` |
| 0.0% | 1.7ms | 0.0% | 0us | `forEachPreferredTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319692` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333345` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323875` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318269` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:657` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `Lc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:272225` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91298` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329353` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `uniqueSymbolParslet` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316988` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329365` |
| 0.0% | 1.7ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332065` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:181150` |
| 0.0% | 1.7ms | 0.0% | 0us | `checkJsDoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332084` |
| 0.0% | 1.7ms | 0.0% | 0us | `fix10` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332030` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201928` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290309` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161658` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:159547` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161415` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313215` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161604` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161353` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313257` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:176201` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:176210` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:176166` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:4` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/esquery.js:12` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1021` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/source-code-traverser.js:12` |
| 0.0% | 1.7ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1599` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:183987` |
| 0.0% | 1.7ms | 0.0% | 0us | `validateParameterNames` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323669` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323669` |
| 0.0% | 1.7ms | 0.0% | 0us | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:955` |
| 0.0% | 1.7ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2348` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:967` |
| 0.0% | 1.7ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2137` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `hasRejectValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322534` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:213129` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289680` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/token-store/index.js:13` |
| 0.0% | 1.7ms | 0.0% | 0us | `internal:stream` | `internal:stream:2` |
| 0.0% | 1.7ms | 0.0% | 0us | `internal:streams/duplex` | `internal:streams/duplex:2` |
| 0.0% | 1.7ms | 0.0% | 0us | `internal:fs/streams` | `internal:fs/streams:2` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:11` |
| 0.0% | 1.7ms | 0.0% | 0us | `node:stream` | `node:stream:2` |
| 0.0% | 1.7ms | 0.0% | 0us | `internal:streams/compose` | `internal:streams/compose:2` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/token-store/cursors.js:11` |
| 0.0% | 1.7ms | 0.0% | 0us | `internal:streams/pipeline` | `internal:streams/pipeline:2` |
| 0.0% | 1.7ms | 0.0% | 0us | `internal:streams/operators` | `internal:streams/operators:2` |
| 0.0% | 1.7ms | 0.0% | 0us | `node:tty` | `node:tty:6` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12341` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:337106` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318020` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `_addSchema` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:309` |
| 0.0% | 1.7ms | 0.0% | 0us | `resolveIds` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:239` |
| 0.0% | 1.7ms | 0.0% | 0us | `addSchema` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:137` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:265` |
| 0.0% | 1.7ms | 0.0% | 0us | `_traverse` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/json-schema-traverse/index.js:76` |
| 0.0% | 1.7ms | 0.0% | 0us | `addMetaSchema` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:152` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:29` |
| 0.0% | 1.7ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:728` |
| 0.0% | 1.7ms | 0.0% | 0us | `_traverse` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/json-schema-traverse/index.js:65` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/json-schema-traverse/index.js:14` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:29585` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290397` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:650` |
| 0.0% | 1.7ms | 0.0% | 0us | `canSkip4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334204` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334210` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `hasSchemaOption` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320165` |
| 0.0% | 1.7ms | 0.0% | 0us | `exemptSpeciaMethods` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320169` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320556` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330268` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getBasicUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320385` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289687` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:232476` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236731` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236503` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236608` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:282438` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289848` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:282361` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:5923` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301300` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330658` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289800` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:261303` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260701` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:261237` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:244612` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:244550` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:244477` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:244473` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289723` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289697` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:238932` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:238788` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `checkHyphens` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `forEachPreferredTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319694` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `rewireSpecs` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318228` |
| 0.0% | 1.7ms | 0.0% | 0us | `checkNotAlignedPerTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323475` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323552` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320466` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320501` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_ensureNameToTagIds` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4632` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317683` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/dotjs/index.js:20` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/index.js:18` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295789` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295781` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `toLocaleUpperCase` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301287` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get message` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4114` |
| 0.0% | 1.7ms | 0.0% | 0us | `_fromRunnerReport` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:203` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3763` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326709` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326707` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1974` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289883` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:288747` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `dlopen` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `loadBinding` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` |
| 0.0% | 1.7ms | 0.0% | 0us | `getTagNames` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:191` |
| 0.0% | 1.7ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:267` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:219778` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:219710` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289638` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/ast-converter.js:7` |
| 0.0% | 1.7ms | 0.0% | 0us | `checkNonJsdocAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326356` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326357` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228839` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228578` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228680` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `makeSafeRegex` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:226508` |
| 0.0% | 1.6ms | 0.0% | 0us | `createToken` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:226514` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:226564` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:310149` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228163` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289672` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/warnAboutTSVersion.js:42` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/warnAboutTSVersion.js:8` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:54` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/warnAboutTSVersion.js:30` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330269` |
| 0.0% | 1.6ms | 0.0% | 0us | `checkDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330239` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:182631` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201939` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:30` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:45` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:8` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96160` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96182` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96800` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96125` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:110356` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96670` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96733` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183383` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183392` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201946` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:169341` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:169312` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173329` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:169357` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326129` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322436` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getBasicUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320400` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `onNodeWithComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329136` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329137` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1962` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329117` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326769` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320445` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getJsdocTagsDeep` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319524` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320903` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getText` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1332` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `flat` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:285378` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289865` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330541` |
| 0.0% | 1.6ms | 0.0% | 0us | `getPreferredTagNameSimple` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319602` |
| 0.0% | 1.6ms | 0.0% | 0us | `test` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:207` |
| 0.0% | 1.6ms | 0.0% | 0us | `testSet` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:525` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:62` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `test` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/comparator.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317612` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:51143` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `makeReport` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321182` |
| 0.0% | 1.6ms | 0.0% | 0us | `iterate` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321186` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `parse` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `findExpectedIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332309` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getBasicUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320368` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137561` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `regexTester` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137796` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137993` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137597` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138558` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137664` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138320` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137847` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137930` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `fix10` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330476` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getBasicUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320373` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:779` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `/^\/\*(?!\*)/v` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:256126` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/brace-expansion/dist/commonjs/index.js:5` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/minimatch/dist/commonjs/index.js:4` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289781` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:256205` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:18` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:187686` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:187680` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201965` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3747` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:40084` |
| 0.0% | 1.5ms | 0.0% | 0us | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2395` |
| 0.0% | 1.5ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2855` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:296489` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:58223` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:202002` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:144188` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:144230` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:143983` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:144139` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:143807` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:144248` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313183` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172435` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171032` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171041` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170997` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getLocFromIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3658` |
| 0.0% | 1.5ms | 0.0% | 0us | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4103` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:99341` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:99288` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:99211` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:278557` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:99420` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289833` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109733` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:123` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:200125` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:200163` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:202021` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:200154` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:247562` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289741` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:247682` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:247566` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:247637` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:202003` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:196251` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:195832` |
| 0.0% | 1.5ms | 0.0% | 0us | `canSkip5` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334303` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334344` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:40` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/index.js:17` |
| 0.0% | 1.5ms | 0.0% | 0us | `get description` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:5040` |
| 0.0% | 1.5ms | 0.0% | 0us | `internal:util/inspect` | `internal:util/inspect:9` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12342` |
| 0.0% | 1.5ms | 0.0% | 0us | `node:util` | `node:util:2` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332246` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:51660` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:293515` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:51652` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `fix10` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.5ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2358` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 0us | `_computeIdentifierName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4209` |
| 0.0% | 1.5ms | 0.0% | 0us | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2926` |
| 0.0% | 1.5ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2384` |
| 0.0% | 1.5ms | 0.0% | 0us | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4221` |
| 0.0% | 1.5ms | 0.0% | 0us | `get identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:795` |
| 0.0% | 1.5ms | 0.0% | 0us | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318583` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1666` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201975` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:16` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:8` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:30` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:42` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328278` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getPreferredTagName` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319653` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326659` |
| 0.0% | 1.5ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7265` |
| 0.0% | 1.5ms | 0.0% | 0us | `_getOrBuildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6160` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get unicodeSets` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92489` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92469` |
| 0.0% | 1.5ms | 0.0% | 0us | `canSkip3` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333682` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1307` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318163` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334004` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321095` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313441` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1672` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:169485` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173330` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:169445` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:128056` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:169474` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:116280` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318048` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:22` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190646` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190605` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190639` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201979` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201920` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:179731` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201046` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:202025` |
| 0.0% | 1.4ms | 0.0% | 0us | `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321376` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330804` |
| 0.0% | 1.4ms | 0.0% | 0us | `onNodeAllNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321329` |
| 0.0% | 1.4ms | 0.0% | 0us | `getTags` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319645` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333710` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321027` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Visitor.js:4` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/TypeVisitor.js:7` |
| 0.0% | 1.4ms | 0.0% | 0us | `hasRejectValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333264` |
| 0.0% | 1.4ms | 0.0% | 0us | `hasRejectValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333311` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `hasRejectValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333274` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:223868` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289658` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:37` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:223799` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:223938` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:30` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `hasRejectValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333310` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:174953` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:174910` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:174945` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313251` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `nullableParslet` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315145` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171639` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171555` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171547` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329331` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171518` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `Boolean` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2213` |
| 0.0% | 1.4ms | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4164` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get global` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:217111` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289625` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:202017` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:198703` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/dotjs/index.js:31` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:262339` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289805` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:262266` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:262270` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:262392` |
| 0.0% | 1.4ms | 0.0% | 0us | `checkJsDoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332001` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:28` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/es2016.full.js:11` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320771` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6927` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:222334` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:222330` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:222600` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289650` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:222405` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313218` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `setCustomPollingValues` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:162377` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:8684` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:3` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:162504` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328458` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201985` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:192407` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:338268` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `default` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `_unwrap` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:337822` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:271833` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1309` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:148891` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2205` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313206` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318180` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330261` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getDefaultTagStructureForMode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314378` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318051` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:122251` |
| 0.0% | 1.4ms | 0.0% | 0us | `callBoundIntrinsic` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:122072` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:122164` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `GetIntrinsic` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:94709` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:128086` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:122147` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327682` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:197313` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:202009` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318171` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:197348` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:197357` |
| 0.0% | 1.4ms | 0.0% | 0us | `generateNamedReferences` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321889` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321912` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:90172` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92621` |
| 0.0% | 1.4ms | 0.0% | 0us | `getPreferredTagName` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319661` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330254` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320896` |
| 0.0% | 1.4ms | 0.0% | 0us | `get tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4988` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318292` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:105266` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109738` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:102857` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:104242` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:106431` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:106845` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:103878` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321046` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:94` |
| 0.0% | 1.4ms | 0.0% | 0us | `getInlineTags` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319714` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:324409` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/index.js:8` |
| 0.0% | 1.4ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:585` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `Uint8Array` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164588` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `replaceXRanges` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `Range` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:163554` |
| 0.0% | 1.4ms | 0.0% | 0us | `parseComparator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:163707` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:62` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313220` |
| 0.0% | 1.4ms | 0.0% | 0us | `parseRange` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:163615` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164675` |
| 0.0% | 1.4ms | 0.0% | 0us | `splitPrefixSuffix` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295814` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `/[^\p{L}\d]+/giu` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `split` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295726` |
| 0.0% | 1.4ms | 0.0% | 0us | `camelCase` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295754` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_jsdoc_all.js:16` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323695` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:49680` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:49666` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:51145` |
| 0.0% | 1.4ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8199` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_getSharedCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:746` |
| 0.0% | 1.4ms | 0.0% | 0us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1123` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `ensureMap` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319770` |
| 0.0% | 1.4ms | 0.0% | 0us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4288` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/fdir/dist/index.cjs:462` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318578` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/tinyglobby/dist/index.cjs:27` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/index.js:3` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/lib/picomatch.js:3` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1246` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:139441` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `__export` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:24` |
| 0.0% | 1.3ms | 0.0% | 0us | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318574` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `typeTokenizer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318341` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/parse-string.js:113` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:4` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/prelude-ls/lib/index.js:4` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/parse-string.js:4` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `__toESM` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `splitTextIntoWords` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327014` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327115` |
| 0.0% | 1.3ms | 0.0% | 0us | `descriptionIsRedundant` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327093` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `normalizeWord` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327009` |
| 0.0% | 1.3ms | 0.0% | 0us | `areDocsInformative` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326998` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `keys` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329388` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/index.js:11` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/index.js:9` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/lazy-loading-rule-map.js:7` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/node.js:260` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/default-config.js:12` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318135` |
| 0.0% | 1.3ms | 0.0% | 0us | `node:events` | `node:events:9` |
| 0.0% | 1.3ms | 0.0% | 0us | `internal:validators` | `internal:validators:2` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `createSafeIterator` | `internal:primordials` |
| 0.0% | 1.3ms | 0.0% | 0us | `internal:shared` | `internal:shared:2` |
| 0.0% | 1.3ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.0% | 1.3ms | 0.0% | 0us | `internal:primordials` | `internal:primordials:50` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_jsdoc_all.js:6` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:58290` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334030` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:241506` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289708` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:241540` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318263` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313535` |
| 0.0% | 1.3ms | 0.0% | 0us | `union` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:35697` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290444` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333704` |
| 0.0% | 1.3ms | 0.0% | 0us | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1282` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_tokType` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:601` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:35704` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201991` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:193121` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:193150` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:193160` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/cast.js:4` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/cast.js:327` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:5` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290268` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/cli-engine/hash.js:12` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:17` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `createTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332506` |
| 0.0% | 1.3ms | 0.0% | 0us | `fix10` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332531` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `ownKeys` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172522` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172496` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `values` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get hasIndices` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:17` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:14` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:252900` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289767` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:218` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:31` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/comparator.js:143` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:253205` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `LRUCache` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/internal/lrucache.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317650` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:250172` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:250341` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289753` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `canSkip6` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334515` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334546` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289818` |
| 0.0% | 1.3ms | 0.0% | 0us | `exemptSpeciaMethods` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320170` |
| 0.0% | 1.3ms | 0.0% | 0us | `canSkip2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333442` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333461` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `flattenRoots` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319292` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332260` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317563` |
| 0.0% | 1.2ms | 0.0% | 0us | `cleanUpLastTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317512` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `namePathParslet` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317576` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:14` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint/config-array/dist/cjs/index.cjs:3` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318059` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201962` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7090` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313150` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319404` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329182` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329183` |
| 0.0% | 1.2ms | 0.0% | 0us | `getParamName` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319403` |
| 0.0% | 1.2ms | 0.0% | 0us | `getTemplateTags` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329179` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:108954` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:108506` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109109` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109739` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:108785` |
| 0.0% | 1.2ms | 0.0% | 0us | `applyBind` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:94784` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:108989` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109021` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109044` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:108524` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1794` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:711` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:134047` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138541` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:134057` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173322` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173358` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329317` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get key` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201915` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5073` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `/Note that this does not return projects in info\.containingProjects$/mv` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:10` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322605` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:6` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170809` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170774` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172430` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170818` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:559` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:1664` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getDefaultTagStructureForMode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314561` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/TypeVisitor.js:6` |
| 0.0% | 1.2ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:220` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/scope/BlockScope.js:4` |
| 0.0% | 1.2ms | 0.0% | 0us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `parseBlock` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318241` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/scope/index.js:17` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `encodeInto` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332324` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `rootNamer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332199` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91299` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7092` |
| 0.0% | 1.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/dotjs/index.js:5` |
| 0.0% | 1.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295072` |
| 0.0% | 1.1ms | 0.0% | 1.1ms | `__toESM` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:11` |
| 0.0% | 1.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.0% | 1.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/locate-path/index.js:5` |
| 0.0% | 1.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/p-limit/index.js:2` |
| 0.0% | 1.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/find-up/index.js:3` |
| 0.0% | 1.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/p-locate/index.js:2` |
| 0.0% | 1.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config-loader.js:14` |
| 0.0% | 1.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-modifiers.js:39` |
| 0.0% | 1.0ms | 0.0% | 1.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323931` |
| 0.0% | 1.0ms | 0.0% | 0us | `Ajv` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:63` |
| 0.0% | 1.0ms | 0.0% | 0us | `rules` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/rules.js:33` |
| 0.0% | 1.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/rules.js:45` |
| 0.0% | 1.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/rules.js:34` |
| 0.0% | 1.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:19` |
| 0.0% | 921us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295790` |
| 0.0% | 910us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:90428` |
| 0.0% | 910us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91300` |

## Function Details

### `slice`
`[native code]` | Self: 28.6% (1.61s) | Total: 28.6% (1.61s) | Samples: 1059

**Called by:**
- `(anonymous)` (1057)
- `_computeIdentifierName` (1)
- `(anonymous)` (1)

### `getTokensAfter`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3566` | Self: 7.2% (405.9ms) | Total: 7.3% (411.5ms) | Samples: 265

**Called by:**
- `getTokensAfterIgnoringSemis` (269)

**Calls:**
- `push` (4)

### `anonymous`
`[native code]` | Self: 4.2% (237.0ms) | Total: 27.9% (1.57s) | Samples: 155

**Called by:**
- `require` (793)
- `bound require` (5)
- `node:util` (1)
- `node:stream` (1)
- `internal:shared` (1)
- `node:tty` (1)
- `(anonymous)` (1)
- `node:fs` (1)
- `internal:streams/duplex` (1)
- `internal:stream` (1)
- `internal:streams/compose` (1)
- `internal:streams/operators` (1)
- `internal:validators` (1)
- `internal:fs/streams` (1)
- `internal:streams/pipeline` (1)
- `node:events` (1)

**Calls:**
- `(anonymous)` (49)
- `(anonymous)` (39)
- `(anonymous)` (27)
- `(anonymous)` (27)
- `(anonymous)` (27)
- `(anonymous)` (20)
- `(anonymous)` (19)
- `(anonymous)` (19)
- `(anonymous)` (14)
- `(anonymous)` (13)
- `(anonymous)` (13)
- `(anonymous)` (12)
- `(anonymous)` (11)
- `(anonymous)` (11)
- `(anonymous)` (11)
- `(anonymous)` (10)
- `(anonymous)` (10)
- `(anonymous)` (10)
- `(anonymous)` (9)
- `(anonymous)` (9)
- `(anonymous)` (9)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:streams/duplex` (1)
- `(anonymous)` (1)
- `internal:util/inspect` (1)
- `internal:stream` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:streams/compose` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:shared` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:fs` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:fs/streams` (1)
- `node:util` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:primordials` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:streams/pipeline` (1)
- `(anonymous)` (1)
- `node:events` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:stream` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:tty` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:streams/operators` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:validators` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `parse`
`[native code]` | Self: 4.0% (229.4ms) | Total: 4.0% (229.4ms) | Samples: 150

**Called by:**
- `parseSource` (149)
- `(anonymous)` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1300` | Self: 3.5% (197.8ms) | Total: 3.5% (197.8ms) | Samples: 128

**Called by:**
- `_getAllTokens` (128)

### `get flags`
`[native code]` | Self: 2.2% (125.9ms) | Total: 2.3% (132.7ms) | Samples: 84

**Called by:**
- `matchAll` (89)

**Calls:**
- `get unicode` (2)
- `get global` (1)
- `get hasIndices` (1)
- `get unicodeSets` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329111` | Self: 2.1% (119.3ms) | Total: 2.3% (133.5ms) | Samples: 79

**Called by:**
- `filter` (88)

**Calls:**
- `/^\*(?!\*)/v` (9)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1288` | Self: 2.0% (115.4ms) | Total: 2.0% (115.4ms) | Samples: 74

**Called by:**
- `_getAllTokens` (74)

### ``/^\n?([A-Z`\d_][\s\S]*[.?!`\p{RGI_Emoji}]\s*)?$/v``
`[native code]` | Self: 1.6% (94.2ms) | Total: 1.6% (94.2ms) | Samples: 61

**Called by:**
- `test` (61)

### `entries`
`[native code]` | Self: 1.6% (92.4ms) | Total: 1.6% (92.4ms) | Samples: 60

**Called by:**
- `getPreferredTagNameSimple` (59)
- `getPreferredTagNameSimple` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 1.5% (84.5ms) | Total: 1.5% (84.5ms) | Samples: 55

**Called by:**
- `(anonymous)` (39)
- `filter` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `iterate` (1)
- `flatIntoArrayWithCallback` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `map` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329779` | Self: 1.4% (81.1ms) | Total: 1.6% (94.9ms) | Samples: 50

**Called by:**
- `filter` (59)

**Calls:**
- `/^\*(?!\*)/v` (9)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1673` | Self: 1.4% (80.4ms) | Total: 11.0% (623.7ms) | Samples: 53

**Called by:**
- `findJSDocComment` (398)
- `getReducedASTNode` (7)

**Calls:**
- `_getTokensAndCommentsMerged` (300)
- `_getTokensAndCommentsMerged` (36)
- `_getTokensAndCommentsMerged` (12)
- `_getTokensAndCommentsMerged` (2)
- `_getTokensAndCommentsMerged` (1)
- `_getTokensAndCommentsMerged` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329116` | Self: 1.2% (70.0ms) | Total: 1.9% (112.1ms) | Samples: 46

**Called by:**
- `filter` (73)

**Calls:**
- `/^\s*globals/v` (27)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:3` | Self: 1.2% (69.4ms) | Total: 1.2% (69.4ms) | Samples: 5

**Called by:**
- `(anonymous)` (5)

### `getTokensAfter`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3565` | Self: 1.2% (68.2ms) | Total: 1.2% (68.2ms) | Samples: 45

**Called by:**
- `getTokensAfterIgnoringSemis` (45)

### `filter`
`[native code]` | Self: 1.1% (66.5ms) | Total: 10.7% (603.3ms) | Samples: 43

**Called by:**
- `(anonymous)` (108)
- `(anonymous)` (97)
- `(anonymous)` (85)
- `(anonymous)` (75)
- `(anonymous)` (13)
- `tagsByName` (2)
- `filterTags` (2)
- `findExpectedIndex` (2)
- `compactJoiner` (2)
- `onProgramExit` (2)
- `validateParameterNames` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `_execReport` (1)

**Calls:**
- `(anonymous)` (91)
- `(anonymous)` (88)
- `(anonymous)` (73)
- `(anonymous)` (59)
- `(anonymous)` (12)
- `(anonymous)` (11)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `Boolean` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301326` | Self: 1.1% (65.8ms) | Total: 1.1% (65.8ms) | Samples: 11

**Called by:**
- `anonymous` (11)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7720` | Self: 0.9% (55.1ms) | Total: 70.0% (3.94s) | Samples: 37

**Called by:**
- `runPlugins` (2581)

**Calls:**
- `_invokeFused` (1435)
- `_invokeFused` (686)
- `_invokeFused` (381)
- `_invokeFused` (24)
- `_nodeViewRaw` (11)
- `_invokeFused` (5)
- `nodeView` (1)
- `_invokeFused` (1)

### `/(?<!\])\{@(?<tag>[^\}\s]+)\s?(?<namepathOrURL>[^\}\s\\|]*)\s*(?<separator>[\s\\|])?\s*(?<text>[^\}]*)\}/dgv`
`[native code]` | Self: 0.9% (54.7ms) | Total: 0.9% (54.7ms) | Samples: 36

**Called by:**
- `regExpExec` (35)
- `exec` (1)

### `DataView`
`[native code]` | Self: 0.9% (53.0ms) | Total: 0.9% (53.0ms) | Samples: 35

**Called by:**
- `AstView` (35)

### `Set`
`[native code]` | Self: 0.8% (45.1ms) | Total: 0.8% (46.4ms) | Samples: 29

**Called by:**
- `(anonymous)` (28)
- `union` (1)
- `getRegexFromString` (1)

**Calls:**
- `next` (1)

### `getValidRuntimeIdentifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329198` | Self: 0.7% (42.8ms) | Total: 0.7% (42.8ms) | Samples: 29

**Called by:**
- `(anonymous)` (29)

### `/^\s*globals/v`
`[native code]` | Self: 0.7% (42.1ms) | Total: 0.7% (42.1ms) | Samples: 27

**Called by:**
- `(anonymous)` (27)

### `/\r\n\|\r\|\n\|\u2028\|\u2029/`
`[native code]` | Self: 0.6% (37.1ms) | Total: 0.6% (37.1ms) | Samples: 24

**Called by:**
- `regExpSplitFast` (24)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1285` | Self: 0.5% (32.2ms) | Total: 0.8% (46.0ms) | Samples: 22

**Called by:**
- `_getAllTokens` (30)

**Calls:**
- `_getJsxTextTokFlags` (6)
- `_getJsxTextTokFlags` (2)

### `regExpSplitFast`
`[native code]` | Self: 0.5% (28.7ms) | Total: 1.1% (65.9ms) | Samples: 19

**Called by:**
- `get lines` (34)
- `splitLines` (9)

**Calls:**
- `/\r\n\|\r\|\n\|\u2028\|\u2029/` (24)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1975` | Self: 0.5% (28.5ms) | Total: 0.9% (54.2ms) | Samples: 19

**Called by:**
- `getTokenBefore` (36)

**Calls:**
- `_makeToken` (12)
- `_makeToken` (3)
- `_makeToken` (2)

### `/^\*(?!\*)/v`
`[native code]` | Self: 0.4% (28.0ms) | Total: 0.4% (28.0ms) | Samples: 18

**Called by:**
- `(anonymous)` (9)
- `(anonymous)` (9)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318182` | Self: 0.4% (25.9ms) | Total: 5.3% (299.3ms) | Samples: 17

**Called by:**
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (118)
- `checkJsdoc` (78)

**Calls:**
- `getJSDocComment` (151)
- `getJSDocComment` (27)
- `getJSDocComment` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1264` | Self: 0.4% (24.1ms) | Total: 0.4% (24.1ms) | Samples: 14

**Called by:**
- `_getAllTokens` (14)

### `getTokensAfter`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3563` | Self: 0.4% (23.8ms) | Total: 0.4% (23.8ms) | Samples: 16

**Called by:**
- `getTokensAfterIgnoringSemis` (16)

### `stringSplitFast`
`[native code]` | Self: 0.4% (23.5ms) | Total: 0.4% (23.5ms) | Samples: 15

**Called by:**
- `(anonymous)` (11)
- `(anonymous)` (2)
- `generateNamedReferences` (1)
- `(anonymous)` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1292` | Self: 0.3% (21.3ms) | Total: 0.3% (21.3ms) | Samples: 14

**Called by:**
- `_getAllTokens` (14)

### `test`
`[native code]` | Self: 0.3% (21.3ms) | Total: 2.0% (115.5ms) | Samples: 14

**Called by:**
- `validateDescription` (72)
- `_buildScopeVarsAndSet` (2)
- `_precomputeScopes` (1)

**Calls:**
- ``/^\n?([A-Z`\d_][\s\S]*[.?!`\p{RGI_Emoji}]\s*)?$/v`` (61)

### `getAncestors`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3668` | Self: 0.3% (20.7ms) | Total: 0.3% (20.7ms) | Samples: 14

**Called by:**
- `getUtils` (14)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1260` | Self: 0.3% (19.8ms) | Total: 0.3% (19.8ms) | Samples: 13

**Called by:**
- `_getAllTokens` (13)

### `esSpecIsRegExp`
`[native code]` | Self: 0.3% (19.2ms) | Total: 0.3% (19.2ms) | Samples: 13

**Called by:**
- `matchAll` (13)

### `[Symbol.matchAll]`
`[native code]` | Self: 0.3% (18.3ms) | Total: 0.3% (18.3ms) | Samples: 12

**Called by:**
- `parseDescription` (10)
- `parseDescription` (2)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.3% (18.0ms) | Total: 0.3% (18.0ms) | Samples: 12

**Called by:**
- `_getTokensAndCommentsMerged` (12)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318170` | Self: 0.3% (17.5ms) | Total: 0.3% (17.5ms) | Samples: 11

**Called by:**
- `checkJsdoc` (10)
- `checkJsDoc` (1)

### `_getAllTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1933` | Self: 0.2% (16.6ms) | Total: 0.3% (17.9ms) | Samples: 11

**Called by:**
- `_getTokensAndCommentsMerged` (12)

**Calls:**
- `push` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:731` | Self: 0.2% (15.8ms) | Total: 0.2% (15.8ms) | Samples: 10

**Called by:**
- `getAllComments` (10)

### `includes`
`[native code]` | Self: 0.2% (15.7ms) | Total: 0.2% (15.7ms) | Samples: 10

**Called by:**
- `(anonymous)` (10)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318167` | Self: 0.2% (15.4ms) | Total: 0.2% (15.4ms) | Samples: 10

**Called by:**
- `checkJsdoc` (10)

### `_getAllTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1932` | Self: 0.2% (14.7ms) | Total: 7.9% (446.1ms) | Samples: 10

**Called by:**
- `_getTokensAndCommentsMerged` (288)

**Calls:**
- `_makeToken` (128)
- `_makeToken` (74)
- `_makeToken` (30)
- `_makeToken` (14)
- `_makeToken` (14)
- `_makeToken` (13)
- `_makeToken` (3)
- `_makeToken` (1)
- `_makeToken` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` | Self: 0.2% (14.4ms) | Total: 0.2% (14.4ms) | Samples: 9

**Called by:**
- `(anonymous)` (7)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5080` | Self: 0.2% (13.8ms) | Total: 42.5% (2.39s) | Samples: 9

**Called by:**
- `walkNodes` (1435)
- `walkNodes` (131)

**Calls:**
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (1320)
- `Program:exit` (110)
- `bound checkJsdoc` (90)
- `Program:exit` (21)
- `bound checkNonJsdoc` (13)
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7382` | Self: 0.2% (13.7ms) | Total: 0.2% (13.7ms) | Samples: 9

**Called by:**
- `runPlugins` (9)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318155` | Self: 0.2% (13.6ms) | Total: 0.2% (13.6ms) | Samples: 9

**Called by:**
- `getJSDocComment` (6)
- `getNonJsdocComment` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7855` | Self: 0.2% (13.5ms) | Total: 0.2% (13.5ms) | Samples: 9

**Called by:**
- `runPlugins` (9)

### `parseDescription`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318820` | Self: 0.2% (12.7ms) | Total: 2.8% (158.1ms) | Samples: 8

**Called by:**
- `parseInlineTags` (58)
- `parseInlineTags` (46)

**Calls:**
- `matchAll` (50)
- `performIteration` (44)
- `[Symbol.matchAll]` (2)

### `getCommentsBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3401` | Self: 0.2% (12.5ms) | Total: 0.2% (12.5ms) | Samples: 8

**Called by:**
- `getReducedASTNode` (6)
- `getReducedASTNode` (2)

### `map`
`[native code]` | Self: 0.2% (11.7ms) | Total: 4.2% (238.4ms) | Samples: 8

**Called by:**
- `(anonymous)` (120)
- `(anonymous)` (6)
- `compactJoiner` (6)
- `_lintSourceOne` (5)
- `(anonymous)` (5)
- `camelCase` (4)
- `(anonymous)` (3)
- `getFunctionParameterNames` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `getParamName` (1)
- `parseRange` (1)
- `(anonymous)` (1)
- `Range` (1)
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (119)
- `(anonymous)` (5)
- `_fromRunnerReport` (4)
- `(anonymous)` (4)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `parseRange` (1)
- `parseComparator` (1)
- `_fromRunnerReport` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `getBasicUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320370` | Self: 0.2% (11.7ms) | Total: 0.2% (11.7ms) | Samples: 8

**Called by:**
- `callIterator` (7)
- `getUtils` (1)

### `getText`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1346` | Self: 0.1% (10.8ms) | Total: 0.1% (10.8ms) | Samples: 7

**Called by:**
- `callIterator` (6)
- `(anonymous)` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4577` | Self: 0.1% (10.7ms) | Total: 0.1% (10.7ms) | Samples: 3

**Called by:**
- `AstView` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328274` | Self: 0.1% (10.7ms) | Total: 0.3% (18.9ms) | Samples: 7

**Called by:**
- `filter` (12)

**Calls:**
- `trimStart` (4)
- `/^\/\*(?!\*)/v` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.1% (10.7ms) | Total: 0.7% (43.8ms) | Samples: 6

**Called by:**
- `(anonymous)` (14)
- `ke` (11)
- `(anonymous)` (2)
- `y` (2)

**Calls:**
- `(anonymous)` (14)
- `_e` (3)
- `Ce` (3)
- `y` (2)
- `push` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4266` | Self: 0.1% (10.6ms) | Total: 0.1% (10.6ms) | Samples: 7

**Called by:**
- `get parent` (4)
- `getAncestors` (2)
- `nodeView` (1)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1202` | Self: 0.1% (10.5ms) | Total: 0.1% (10.5ms) | Samples: 6

**Called by:**
- `_makeToken` (6)

### `getUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321034` | Self: 0.1% (10.4ms) | Total: 0.1% (10.4ms) | Samples: 7

**Called by:**
- `iterate` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319619` | Self: 0.1% (10.1ms) | Total: 0.4% (25.9ms) | Samples: 7

**Called by:**
- `find` (17)

**Calls:**
- `includes` (10)

### `stringIncludesInternal`
`[native code]` | Self: 0.1% (9.7ms) | Total: 0.1% (9.7ms) | Samples: 6

**Called by:**
- `matchAll` (6)

### `checkJsdoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321476` | Self: 0.1% (9.5ms) | Total: 3.0% (171.7ms) | Samples: 6

**Called by:**
- `bound checkJsdoc` (112)

**Calls:**
- `getJSDocComment` (78)
- `getJSDocComment` (10)
- `getJSDocComment` (10)
- `getJSDocComment` (4)
- `getJSDocComment` (2)
- `getJSDocComment` (1)
- `getJSDocComment` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7682` | Self: 0.1% (9.5ms) | Total: 0.1% (9.5ms) | Samples: 6

**Called by:**
- `runPlugins` (6)

### `RegExp`
`[native code]` | Self: 0.1% (9.4ms) | Total: 0.1% (9.4ms) | Samples: 6

**Called by:**
- `maskExcludedContent` (3)
- `fix10` (1)
- `(anonymous)` (1)
- `createToken` (1)

### `push`
`[native code]` | Self: 0.1% (9.3ms) | Total: 0.1% (9.3ms) | Samples: 7

**Called by:**
- `getTokensAfter` (4)
- `(anonymous)` (1)
- `_getAllTokens` (1)
- `(anonymous)` (1)

### `concat`
`[native code]` | Self: 0.1% (9.1ms) | Total: 0.1% (9.1ms) | Samples: 6

**Called by:**
- `(anonymous)` (6)

### `next`
`[native code]` | Self: 0.1% (8.8ms) | Total: 1.3% (77.4ms) | Samples: 6

**Called by:**
- `performIteration` (50)
- `Set` (1)

**Calls:**
- `regExpExec` (44)
- `exec` (1)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318152` | Self: 0.1% (8.6ms) | Total: 0.1% (8.6ms) | Samples: 5

**Called by:**
- `getJSDocComment` (3)
- `getNonJsdocComment` (2)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1228` | Self: 0.1% (8.6ms) | Total: 0.1% (8.6ms) | Samples: 6

**Called by:**
- `_getTokensAndCommentsMerged` (3)
- `_getAllTokens` (3)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4149` | Self: 0.1% (8.4ms) | Total: 0.1% (8.4ms) | Samples: 5

**Called by:**
- `_nodeViewRaw` (5)

### `callIterator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321242` | Self: 0.1% (8.3ms) | Total: 0.1% (8.3ms) | Samples: 5

**Called by:**
- `onNodeWithComment` (5)

### `trimStart`
`[native code]` | Self: 0.1% (8.2ms) | Total: 0.1% (8.2ms) | Samples: 5

**Called by:**
- `(anonymous)` (4)
- `(anonymous)` (1)

### `performIteration`
`[native code]` | Self: 0.1% (8.1ms) | Total: 1.4% (84.2ms) | Samples: 5

**Called by:**
- `parseDescription` (44)
- `parseDescription` (11)

**Calls:**
- `next` (50)

### `[Symbol.match]`
`[native code]` | Self: 0.1% (8.0ms) | Total: 0.2% (12.8ms) | Samples: 5

**Called by:**
- `match` (8)

**Calls:**
- `/\r+$/` (3)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5058` | Self: 0.1% (7.8ms) | Total: 0.6% (36.2ms) | Samples: 5

**Called by:**
- `walkNodes` (24)

**Calls:**
- `bound checkJsdoc` (12)
- `bound checkNonJsdoc` (5)
- `FunctionDeclaration` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7386` | Self: 0.1% (7.8ms) | Total: 0.1% (7.8ms) | Samples: 5

**Called by:**
- `runPlugins` (5)

### `regExpExec`
`[native code]` | Self: 0.1% (7.7ms) | Total: 1.1% (67.1ms) | Samples: 5

**Called by:**
- `next` (44)

**Calls:**
- `/(?<!\])\{@(?<tag>[^\}\s]+)\s?(?<namepathOrURL>[^\}\s\\|]*)\s*(?<separator>[\s\\|])?\s*(?<text>[^\}]*)\}/dgv` (35)
- `/(?:\[(?<text>[^\]]+)\])\{@(?<tag>[^\}\s]+)\s?(?<namepathOrURL>[^\}\s\\|]*)\}/dgv` (4)

### `trim`
`[native code]` | Self: 0.1% (7.7ms) | Total: 0.1% (7.7ms) | Samples: 5

**Called by:**
- `(anonymous)` (4)
- `checkDescription` (1)

### `unshift`
`[native code]` | Self: 0.1% (7.7ms) | Total: 0.1% (7.7ms) | Samples: 5

**Called by:**
- `getAncestors` (5)

### `getOwnPropertyDescriptor`
`[native code]` | Self: 0.1% (7.5ms) | Total: 0.1% (7.5ms) | Samples: 5

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `getDecorator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317883` | Self: 0.1% (7.5ms) | Total: 0.4% (23.9ms) | Samples: 5

**Called by:**
- `findJSDocComment` (16)
- `fix10` (1)

**Calls:**
- `get decorators` (5)
- `get decorators` (2)
- `get decorators` (2)
- `get decorators` (1)
- `get decorators` (1)
- `get parent` (1)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1656` | Self: 0.1% (7.2ms) | Total: 0.2% (16.8ms) | Samples: 5

**Called by:**
- `findJSDocComment` (9)
- `getReducedASTNode` (2)

**Calls:**
- `get range` (3)
- `get range` (2)
- `get range` (1)

### `get decorators`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (6.9ms) | Total: 0.1% (6.9ms) | Samples: 5

**Called by:**
- `getDecorator` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328294` | Self: 0.1% (6.9ms) | Total: 2.4% (138.0ms) | Samples: 5

**Called by:**
- `filter` (91)

**Calls:**
- `parse3` (86)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3689` | Self: 0.1% (6.5ms) | Total: 0.1% (6.5ms) | Samples: 4

**Called by:**
- `getTokenBefore` (3)
- `getCommentsBefore` (1)

### `callIterator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321244` | Self: 0.1% (6.3ms) | Total: 0.3% (21.0ms) | Samples: 4

**Called by:**
- `onProgramExit` (13)

**Calls:**
- `getText` (6)
- `/^\/\*\*\s/v` (2)
- `getText` (1)

### `_LazyReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4072` | Self: 0.1% (6.3ms) | Total: 0.1% (6.3ms) | Samples: 4

**Called by:**
- `_execReport` (4)

### `seedTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318218` | Self: 0.1% (6.2ms) | Total: 0.1% (6.2ms) | Samples: 4

**Called by:**
- `parseSource` (4)

### `bound checkJsdoc`
`[native code]` | Self: 0.1% (6.0ms) | Total: 10.3% (585.0ms) | Samples: 4

**Called by:**
- `invokeHandlersWithNode` (246)
- `_invokeFused` (90)
- `invokeHandlersWithNode` (34)
- `_invokeFused` (12)

**Calls:**
- `checkJsdoc` (209)
- `checkJsdoc` (112)
- `checkJsdoc` (55)
- `checkJsdoc` (2)

### `splitSpace`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318206` | Self: 0.1% (6.0ms) | Total: 0.1% (6.0ms) | Samples: 4

**Called by:**
- `parseSource` (4)

### `/(?:\[(?<text>[^\]]+)\])\{@(?<tag>[^\}\s]+)\s?(?<namepathOrURL>[^\}\s\\|]*)\}/dgv`
`[native code]` | Self: 0.1% (6.0ms) | Total: 0.1% (6.0ms) | Samples: 4

**Called by:**
- `regExpExec` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7680` | Self: 0.1% (5.9ms) | Total: 0.1% (5.9ms) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.1% (5.7ms) | Total: 0.1% (5.7ms) | Samples: 4

**Called by:**
- `getJSDocComment` (3)
- `getNonJsdocComment` (1)

### `replaceAll`
`[native code]` | Self: 0.1% (5.7ms) | Total: 0.1% (5.7ms) | Samples: 4

**Called by:**
- `maskCodeBlocks` (4)

### `getBasicUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320404` | Self: 0.0% (5.6ms) | Total: 0.0% (5.6ms) | Samples: 4

**Called by:**
- `getUtils` (3)
- `callIterator` (1)

### `ensureMap`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319767` | Self: 0.0% (5.5ms) | Total: 0.0% (5.5ms) | Samples: 4

**Called by:**
- `isNameOrNamepathDefiningTag` (4)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318159` | Self: 0.0% (5.4ms) | Total: 0.0% (5.4ms) | Samples: 4

**Called by:**
- `checkJsdoc` (4)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:645` | Self: 0.0% (5.4ms) | Total: 0.0% (5.4ms) | Samples: 4

**Called by:**
- `parseSource` (4)

### `maskCodeBlocks`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (5.3ms) | Total: 0.0% (5.3ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `getReducedASTNode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317968` | Self: 0.0% (5.2ms) | Total: 0.3% (20.9ms) | Samples: 3

**Called by:**
- `getNonJsdocComment` (7)
- `getJSDocComment` (6)

**Calls:**
- `get parent` (7)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1317` | Self: 0.0% (5.0ms) | Total: 0.0% (5.0ms) | Samples: 3

**Called by:**
- `_invokeFused` (2)
- `getReducedASTNode` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319636` | Self: 0.0% (4.8ms) | Total: 0.1% (6.3ms) | Samples: 3

**Called by:**
- `some` (4)

**Calls:**
- `get tag` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329318` | Self: 0.0% (4.8ms) | Total: 0.1% (6.4ms) | Samples: 3

**Called by:**
- `flatIntoArrayWithCallback` (4)

**Calls:**
- `get id` (1)

### `getReducedASTNode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318008` | Self: 0.0% (4.7ms) | Total: 0.1% (6.6ms) | Samples: 3

**Called by:**
- `getJSDocComment` (2)
- `getNonJsdocComment` (2)

**Calls:**
- `get parent` (1)

### `/\r+$/`
`[native code]` | Self: 0.0% (4.7ms) | Total: 0.0% (4.7ms) | Samples: 3

**Called by:**
- `[Symbol.match]` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329124` | Self: 0.0% (4.7ms) | Total: 0.2% (15.7ms) | Samples: 3

**Called by:**
- `filter` (11)

**Calls:**
- `(anonymous)` (8)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (4.5ms) | Total: 0.0% (4.5ms) | Samples: 3

**Called by:**
- `_nodeViewRaw` (3)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1677` | Self: 0.0% (4.5ms) | Total: 0.0% (4.5ms) | Samples: 3

**Called by:**
- `findJSDocComment` (2)
- `getReducedASTNode` (1)

### `replace`
`[native code]` | Self: 0.0% (4.5ms) | Total: 0.1% (7.6ms) | Samples: 3

**Called by:**
- `maskExcludedContent` (4)
- `fix10` (1)

**Calls:**
- `/Note that this does not return projects in info\.containingProjects$/mv` (1)
- `/([ \t]+\*)[ \t]@(?:example)(?=[ \n])([\w\\|\W]*?\n)(?=[ \t]*\*(?:[ \t]*@\w+\s\|\/))/gv` (1)

### `some`
`[native code]` | Self: 0.0% (4.5ms) | Total: 0.5% (30.5ms) | Samples: 3

**Called by:**
- `hasTag` (5)
- `validateDescription` (3)
- `(anonymous)` (3)
- `hasATag` (3)
- `hasRejectValue` (2)
- `validateParameterNames` (2)
- `(anonymous)` (1)
- `checkNonJsdocAfter` (1)

**Calls:**
- `(anonymous)` (4)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4265` | Self: 0.0% (4.4ms) | Total: 0.0% (4.4ms) | Samples: 3

**Called by:**
- `getAncestors` (2)
- `get parent` (1)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318183` | Self: 0.0% (4.4ms) | Total: 0.0% (4.4ms) | Samples: 3

**Called by:**
- `checkJsdoc` (2)
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:648` | Self: 0.0% (4.3ms) | Total: 0.0% (4.3ms) | Samples: 3

**Called by:**
- `parseSource` (3)

### `parseDescription`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318819` | Self: 0.0% (4.1ms) | Total: 2.1% (123.1ms) | Samples: 3

**Called by:**
- `parseInlineTags` (43)
- `parseInlineTags` (39)

**Calls:**
- `matchAll` (58)
- `performIteration` (11)
- `[Symbol.matchAll]` (10)

### `checkJsdoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321480` | Self: 0.0% (4.1ms) | Total: 0.0% (4.1ms) | Samples: 2

**Called by:**
- `bound checkJsdoc` (2)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318270` | Self: 0.0% (4.1ms) | Total: 0.0% (4.1ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `isNameOrNamepathDefiningTag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319816` | Self: 0.0% (4.1ms) | Total: 0.0% (4.1ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `getParser4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318580` | Self: 0.0% (3.9ms) | Total: 0.0% (3.9ms) | Samples: 3

**Called by:**
- `parse3` (3)

### `getUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320424` | Self: 0.0% (3.9ms) | Total: 0.2% (12.9ms) | Samples: 3

**Called by:**
- `iterate` (9)

**Calls:**
- `getBasicUtils` (3)
- `getBasicUtils` (1)
- `getBasicUtils` (1)
- `getBasicUtils` (1)

### `getUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320782` | Self: 0.0% (3.5ms) | Total: 0.0% (3.5ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `join`
`[native code]` | Self: 0.0% (3.5ms) | Total: 0.0% (3.5ms) | Samples: 2

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `/^\/\*\*\s/v`
`[native code]` | Self: 0.0% (3.4ms) | Total: 0.0% (3.4ms) | Samples: 2

**Called by:**
- `callIterator` (2)

### `toLocaleLowerCase`
`[native code]` | Self: 0.0% (3.4ms) | Total: 0.0% (3.4ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:5093` | Self: 0.0% (3.4ms) | Total: 0.0% (3.4ms) | Samples: 2

**Called by:**
- `filter` (2)

### `join`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318605` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `parseBlock`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `endsWith`
`[native code]` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `parseSource` (2)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3737` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `getTokenBefore` (2)

### `Map`
`[native code]` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `getDefaultTagStructureForMode` (2)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1653` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `findJSDocComment` (2)

### `trimEnd`
`[native code]` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `parseSource` (2)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318031` | Self: 0.0% (3.2ms) | Total: 11.3% (639.2ms) | Samples: 2

**Called by:**
- `findJSDocComment` (415)

**Calls:**
- `getTokenBefore` (398)
- `getTokenBefore` (9)
- `getTokenBefore` (2)
- `getTokenBefore` (2)
- `getTokenBefore` (1)
- `getTokenBefore` (1)

### `getAncestors`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3698` | Self: 0.0% (3.2ms) | Total: 0.3% (17.2ms) | Samples: 2

**Called by:**
- `getUtils` (11)

**Calls:**
- `unshift` (5)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (2)

### `/^@[^\s/]+(?=\s\|$)/`
`[native code]` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `parseBlock` (2)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1192` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `_makeToken` (2)

### `defineProperty`
`[native code]` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`[native code]` | Self: 0.0% (3.2ms) | Total: 90.2% (5.08s) | Samples: 2

**Called by:**
- `processTicksAndRejections` (3317)
- `(anonymous)` (1)
- `bound require` (1)

**Calls:**
- `_lintSourceOne` (3110)
- `_lintSourceOne` (200)
- `_lintSourceOne` (5)
- `_lintSourceOne` (1)
- `dlopen` (1)
- `anonymous` (1)

### `log`
`[native code]` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `setDeps` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7689` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:772` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `commentsInRange` (1)
- `commentsInRange` (1)

### `getNonJsdocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318088` | Self: 0.0% (3.1ms) | Total: 0.4% (27.2ms) | Samples: 2

**Called by:**
- `checkNonJsdoc` (17)

**Calls:**
- `getReducedASTNode` (7)
- `getReducedASTNode` (3)
- `getReducedASTNode` (2)
- `getReducedASTNode` (2)
- `getReducedASTNode` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318591` | Self: 0.0% (3.1ms) | Total: 0.1% (10.4ms) | Samples: 2

**Called by:**
- `parse3` (7)

**Calls:**
- `map` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329130` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `filter` (2)

### `getUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320954` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `iterate` (2)

### `_NodeView_LRN`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4187` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `_nodeViewRaw` (2)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318026` | Self: 0.0% (3.0ms) | Total: 0.4% (25.2ms) | Samples: 2

**Called by:**
- `findJSDocComment` (18)

**Calls:**
- `getDecorator` (16)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4271` | Self: 0.0% (3.0ms) | Total: 0.4% (23.3ms) | Samples: 2

**Called by:**
- `walkNodes` (11)
- `nodeView` (3)
- `_computeVarDefs` (1)

**Calls:**
- `_NodeView` (5)
- `_NodeView` (3)
- `_NodeView` (2)
- `_NodeView_LRN` (2)
- `_NodeView_LR` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318267` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7368` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318173` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (2)

### `getParser3`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318301` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `getParser4` (2)

### `getTokensBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3518` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `findJSDocComment` (2)

### `_jdReadStr`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4907` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `get description` (1)
- `get tag` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1230` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `_getTokensAndCommentsMerged` (2)

### `_jdReadStr`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4899` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318286` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `nameTokenizer`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318413` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `getParser4` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318586` | Self: 0.0% (2.8ms) | Total: 0.3% (17.2ms) | Samples: 2

**Called by:**
- `parse3` (11)

**Calls:**
- `splitLines` (9)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:635` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `parseSource` (2)

### `/\/\*([\s\S]*?)\*\//g`
`[native code]` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `exec` (2)

### `repeat`
`[native code]` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `getIndentAndJSDoc` (2)

### `bind`
`[native code]` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `applyBind` (1)
- `internal:util/inspect` (1)

### `splitCR`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318202` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `parseSource` (2)

### `getNonJsdocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318089` | Self: 0.0% (2.7ms) | Total: 8.4% (477.9ms) | Samples: 2

**Called by:**
- `checkNonJsdoc` (311)

**Calls:**
- `findJSDocComment` (303)
- `findJSDocComment` (3)
- `findJSDocComment` (2)
- `findJSDocComment` (1)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4160` | Self: 0.0% (2.6ms) | Total: 0.0% (2.6ms) | Samples: 2

**Called by:**
- `_nodeViewRaw` (2)

### `get decorators`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2198` | Self: 0.0% (2.6ms) | Total: 0.0% (2.6ms) | Samples: 2

**Called by:**
- `getDecorator` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318554` | Self: 0.0% (2.6ms) | Total: 0.1% (8.7ms) | Samples: 2

**Called by:**
- `map` (5)
- `filter` (1)

**Calls:**
- `trim` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332280` | Self: 0.0% (2.6ms) | Total: 0.0% (2.6ms) | Samples: 2

**Called by:**
- `findIndex` (2)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1977` | Self: 0.0% (2.6ms) | Total: 0.0% (2.6ms) | Samples: 2

**Called by:**
- `getTokenBefore` (2)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:725` | Self: 0.0% (2.5ms) | Total: 0.0% (2.5ms) | Samples: 2

**Called by:**
- `getCommentsBefore` (2)

### `get decorators`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2241` | Self: 0.0% (2.5ms) | Total: 0.0% (2.5ms) | Samples: 2

**Called by:**
- `getDecorator` (2)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318139` | Self: 0.0% (2.5ms) | Total: 0.0% (2.5ms) | Samples: 2

**Called by:**
- `getJSDocComment` (2)

### `get unicode`
`[native code]` | Self: 0.0% (2.4ms) | Total: 0.0% (2.4ms) | Samples: 2

**Called by:**
- `get flags` (2)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4106` | Self: 0.0% (2.2ms) | Total: 0.0% (2.2ms) | Samples: 2

**Called by:**
- `_fromRunnerReport` (2)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1308` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `getReducedASTNode` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `validateDescription` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329344` | Self: 0.0% (1.8ms) | Total: 1.0% (58.5ms) | Samples: 1

**Called by:**
- `iterate` (39)

**Calls:**
- `getValidRuntimeIdentifiers` (29)
- `concat` (6)
- `getValidRuntimeIdentifiers` (3)

### `/([ \t]+\*)[ \t]@(?:example)(?=[ \n])([\w\\|\W]*?\n)(?=[ \t]*\*(?:[ \t]*@\w+\s\|\/))/gv`
`[native code]` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `replace` (1)

### `tryParslets`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315094` | Self: 0.0% (1.8ms) | Total: 0.1% (6.3ms) | Samples: 1

**Called by:**
- `parseIntermediateType` (4)

**Calls:**
- `uniqueSymbolParslet` (1)
- `nullableParslet` (1)
- `namePathParslet` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321653` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `add`
`[native code]` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318269` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:657` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `parseSource` (1)

### `Lc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `uniqueSymbolParslet`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316988` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `tryParslets` (1)

### `getUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1021` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `get value` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:183987` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323669` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `filter` (1)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:967` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_symName` (1)

### `hasRejectValue`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `shouldReport` (1)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318020` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `findJSDocComment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:337106` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:265` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_traverse` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:650` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `parseSource` (1)

### `hasSchemaOption`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320165` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `exemptSpeciaMethods` (1)

### `getBasicUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320385` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `callIterator` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:232476` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301300` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `map` (1)

### `callIterator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321250` | Self: 0.0% (1.7ms) | Total: 0.4% (23.4ms) | Samples: 1

**Called by:**
- `onNodeWithComment` (15)

**Calls:**
- `getIndentAndJSDoc` (14)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330658` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `checkHyphens`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `forEachPreferredTag` (1)

### `bound `
`[native code]` | Self: 0.0% (1.7ms) | Total: 17.4% (983.7ms) | Samples: 1

**Called by:**
- `_invokeFused` (612)
- `_invokeFused` (30)

**Calls:**
- `(anonymous)` (332)
- `(anonymous)` (309)

### `rewireSpecs`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318228` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320501` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_execReport` (1)

### `_ensureNameToTagIds`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317683` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `forEach` (1)

### `toLocaleUpperCase`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get message`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4114` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_fromRunnerReport` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3763` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `get value` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326709` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `some` (1)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1974` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getTokenBefore` (1)

### `dlopen`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `flatIntoArrayWithCallback`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.6% (35.4ms) | Samples: 1

**Called by:**
- `flatMap` (8)
- `(anonymous)` (6)
- `(anonymous)` (5)
- `(anonymous)` (1)
- `getInlineTags` (1)
- `splitTextIntoWords` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (13)
- `(anonymous)` (4)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `normalizeWord` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1027` | Self: 0.0% (1.7ms) | Total: 0.2% (12.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (5)
- `getValidRuntimeIdentifiers` (3)

**Calls:**
- `_ensureVarsSet` (7)

### `getReducedASTNode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317993` | Self: 0.0% (1.6ms) | Total: 0.3% (17.3ms) | Samples: 1

**Called by:**
- `getJSDocComment` (10)
- `getNonJsdocComment` (1)

**Calls:**
- `getTokenBefore` (7)
- `getTokenBefore` (2)
- `getTokenBefore` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:310149` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `makeSafeRegex`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:226508` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `createToken` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:8` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318271` | Self: 0.0% (1.6ms) | Total: 0.2% (15.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (10)

**Calls:**
- `splitSpace` (5)
- `splitSpace` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183383` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:169312` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getBasicUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320400` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `getUtils` (1)

### `checkJsdoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321487` | Self: 0.0% (1.6ms) | Total: 5.6% (320.5ms) | Samples: 1

**Called by:**
- `bound checkJsdoc` (209)

**Calls:**
- `iterate` (184)
- `iterate` (23)
- `iterate` (1)

### `onNodeWithComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (1)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1962` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `getTokenBefore` (1)

### `flatMap`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.2% (13.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (8)
- `(anonymous)` (1)

**Calls:**
- `flatIntoArrayWithCallback` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320445` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getJsdocTagsDeep`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319524` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getText`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1332` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `callIterator` (1)

### `flat`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `isValidTag` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330541` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `test`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/comparator.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `testSet` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:51143` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `makeReport`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321182` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `parse`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `g` (1)

### `findExpectedIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332309` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `fix10` (1)

### `getBasicUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320368` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `callIterator` (1)

### `regexTester`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `fix10`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330476` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_execReport` (1)

### `getBasicUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320373` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `getUtils` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:779` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `commentsInRange` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `commentsInRange` (1)

### `/^\/\*(?!\*)/v`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getRegexFromString`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320201` | Self: 0.0% (1.5ms) | Total: 0.0% (2.9ms) | Samples: 1

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `Set` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3747` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `get value` (1)

### `invokeHandlersWithNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6890` | Self: 0.0% (1.5ms) | Total: 7.6% (428.8ms) | Samples: 1

**Called by:**
- `invokeMethodFnHandlers` (278)

**Calls:**
- `bound checkJsdoc` (246)
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (28)
- `bound checkNonJsdoc` (2)
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1316` | Self: 0.0% (1.5ms) | Total: 0.2% (13.7ms) | Samples: 1

**Called by:**
- `getReducedASTNode` (7)
- `_invokeFused` (2)

**Calls:**
- `_nodeViewRaw` (4)
- `nodeView` (3)
- `_nodeViewRaw` (1)

### `getLocFromIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3658` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `get loc` (1)

### `parseBlock`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318242` | Self: 0.0% (1.5ms) | Total: 0.0% (4.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `/^@[^\s/]+(?=\s\|$)/` (2)

### `getCommentsBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3400` | Self: 0.0% (1.5ms) | Total: 0.0% (3.2ms) | Samples: 1

**Called by:**
- `getReducedASTNode` (2)

**Calls:**
- `get range` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:200125` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `fix10`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_execReport` (1)

### `parseInlineTags`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318839` | Self: 0.0% (1.5ms) | Total: 2.3% (132.8ms) | Samples: 1

**Called by:**
- `parseComment` (87)

**Calls:**
- `parseDescription` (46)
- `parseDescription` (39)
- `get description` (1)

### `get`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `getParser4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318583` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `parse3` (1)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1666` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `findJSDocComment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328278` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `some` (1)

### `getPreferredTagName`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319653` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `forEachPreferredTag` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_getOrBuildPlan` (1)

### `get unicodeSets`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `get flags` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1307` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `getReducedASTNode` (1)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318163` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `checkJsdoc` (1)

### `getUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321095` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334004` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1672` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `findJSDocComment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:169445` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318048` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `findJSDocComment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190605` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:179731` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330804` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `hasRejectValue`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333274` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `hasRejectValue` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `hasRejectValue`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333310` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `nullableParslet`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315145` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `tryParslets` (1)

### `Boolean`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `filter` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171518` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get decorators`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2213` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getDecorator` (1)

### `get global`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get flags` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7692` | Self: 0.0% (1.4ms) | Total: 0.0% (2.9ms) | Samples: 1

**Called by:**
- `runPlugins` (2)

**Calls:**
- `_resolveHandlers` (1)

### `getUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320771` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `_resolveHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6927` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `setCustomPollingValues`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `default`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_unwrap` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328458` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1309` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getReducedASTNode` (1)

### `get decorators`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2205` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getDecorator` (1)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318180` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330261` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `getDefaultTagStructureForMode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314378` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `setTagStructure` (1)

### `checkNonJsdocAfter`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326355` | Self: 0.0% (1.4ms) | Total: 8.9% (505.0ms) | Samples: 1

**Called by:**
- `(anonymous)` (331)

**Calls:**
- `getFollowingComment` (330)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318051` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `findJSDocComment` (1)

### `GetIntrinsic`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:94709` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `callBoundIntrinsic` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getTokenBefore` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4173` | Self: 0.0% (1.4ms) | Total: 0.1% (7.8ms) | Samples: 1

**Called by:**
- `report` (5)

**Calls:**
- `_LazyReport` (4)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318171` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `checkJsdoc` (1)

### `getUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320896` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318292` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `Uint8Array`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `replaceXRanges`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `parseComparator` (1)

### `/[^\p{L}\d]+/giu`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `split` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323695` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `some` (1)

### `readFileSync`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (2.8ms) | Samples: 1

**Called by:**
- `readFileSync` (1)
- `(anonymous)` (1)

**Calls:**
- `readFileSync` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5043` | Self: 0.0% (1.4ms) | Total: 0.1% (7.4ms) | Samples: 1

**Called by:**
- `walkNodes` (5)

**Calls:**
- `get parent` (2)
- `get parent` (2)

### `_getSharedCaches`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:746` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `reset` (1)

### `ensureMap`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319770` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `isNameOrNamepathDefiningTag` (1)

### `getParser4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318578` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `parse3` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1246` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_getAllTokens` (1)

### `__export`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:24` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `typeTokenizer`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318341` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getParser4` (1)

### `__toESM`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `iterate`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321202` | Self: 0.0% (1.3ms) | Total: 48.2% (2.71s) | Samples: 1

**Called by:**
- `callIterator` (1593)
- `checkJsdoc` (184)

**Calls:**
- `(anonymous)` (1057)
- `(anonymous)` (120)
- `(anonymous)` (97)
- `(anonymous)` (85)
- `(anonymous)` (75)
- `(anonymous)` (73)
- `(anonymous)` (39)
- `(anonymous)` (34)
- `(anonymous)` (16)
- `(anonymous)` (14)
- `(anonymous)` (10)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (6)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `normalizeWord`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327009` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `flatIntoArrayWithCallback` (1)

### `keys`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `isValidTag` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329388` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334351` | Self: 0.0% (1.3ms) | Total: 0.1% (9.1ms) | Samples: 1

**Called by:**
- `iterate` (5)

**Calls:**
- `checkTagName` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/node.js:260` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318135` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getJSDocComment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:58290` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `createSafeIterator`
`internal:primordials` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `internal:primordials` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334030` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333697` | Self: 0.0% (1.3ms) | Total: 0.0% (2.8ms) | Samples: 1

**Called by:**
- `iterate` (2)

**Calls:**
- `canSkip3` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318263` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_tokType`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:601` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_makeToken` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:193121` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318154` | Self: 0.0% (1.3ms) | Total: 11.9% (673.4ms) | Samples: 1

**Called by:**
- `getNonJsdocComment` (303)
- `getJSDocComment` (136)

**Calls:**
- `findJSDocComment` (415)
- `findJSDocComment` (18)
- `findJSDocComment` (2)
- `findJSDocComment` (1)
- `findJSDocComment` (1)
- `findJSDocComment` (1)

### `createTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332506` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `fix10` (1)

### `ownKeys`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `values`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getPreferredTagNameSimple` (1)

### `get hasIndices`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `get flags` (1)

### `LRUCache`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/internal/lrucache.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317650` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `forEach` (1)

### `getPreferredTagNameSimple`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319596` | Self: 0.0% (1.3ms) | Total: 0.0% (2.6ms) | Samples: 1

**Called by:**
- `getPreferredTagName` (2)

**Calls:**
- `values` (1)

### `canSkip6`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334515` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `flattenRoots`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319292` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `namePathParslet`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `tryParslets` (1)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318059` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `getJSDocComment` (1)

### `bound checkNonJsdoc`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.5% (31.1ms) | Samples: 1

**Called by:**
- `_invokeFused` (13)
- `_invokeFused` (5)
- `invokeHandlersWithNode` (2)

**Calls:**
- `checkNonJsdoc` (19)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328273` | Self: 0.0% (1.2ms) | Total: 0.0% (2.5ms) | Samples: 1

**Called by:**
- `filter` (2)

**Calls:**
- `getText` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7090` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `get typeAnnotation`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `getParamName` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1794` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `hasRejectValue` (1)

### `getReducedASTNode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `getJSDocComment` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:711` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `getCommentsBefore` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173322` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get key`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5073` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `/Note that this does not return projects in info\.containingProjects$/mv`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `replace` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322605` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `getParamName`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319373` | Self: 0.0% (1.2ms) | Total: 0.0% (2.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `get typeAnnotation` (1)

### `getDefaultTagStructureForMode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314561` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `setTagStructure` (1)

### `encodeInto`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_encodeSource` (1)

### `parseBlock`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318241` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320420` | Self: 0.0% (1.2ms) | Total: 0.6% (39.1ms) | Samples: 1

**Called by:**
- `iterate` (26)

**Calls:**
- `getAncestors` (14)
- `getAncestors` (11)

### `rootNamer`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332199` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `getDecorator` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_fromRunnerReport` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7092` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `__toESM`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:11` | Self: 0.0% (1.1ms) | Total: 0.0% (1.1ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323931` | Self: 0.0% (1.0ms) | Total: 0.0% (1.0ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333871` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `(anonymous)` (2)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1282` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_getAllTokens` (1)

**Calls:**
- `_tokType` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323937` | Self: 0.0% (0us) | Total: 0.0% (5.5ms) | Samples: 0

**Called by:**
- `iterate` (4)

**Calls:**
- `(anonymous)` (3)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/index.js:4` | Self: 0.0% (0us) | Total: 0.2% (12.5ms) | Samples: 0

**Called by:**
- `anonymous` (9)

**Calls:**
- `bound require` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289800` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:51660` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:43` | Self: 0.0% (0us) | Total: 0.2% (13.7ms) | Samples: 0

**Called by:**
- `anonymous` (10)

**Calls:**
- `bound require` (10)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333348` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `(anonymous)` (2)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` | Self: 0.0% (0us) | Total: 1.4% (81.3ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (50)

**Calls:**
- `AstView` (35)
- `AstView` (4)
- `AstView` (3)
- `AstView` (3)
- `AstView` (2)
- `AstView` (1)
- `AstView` (1)
- `AstView` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:274` | Self: 0.0% (0us) | Total: 84.5% (4.75s) | Samples: 0

**Called by:**
- `(anonymous)` (3110)

**Calls:**
- `runPlugins` (3070)
- `runPlugins` (39)
- `runPlugins` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `parseComparator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:163707` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `replaceXRanges` (1)

### `checkJsDoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332084` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `FunctionDeclaration` (1)

**Calls:**
- `report` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:502` | Self: 0.0% (0us) | Total: 0.1% (10.7ms) | Samples: 0

**Called by:**
- `parseSource` (3)

**Calls:**
- `CfgGraph` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329353` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `parse2` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313206` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289687` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `callBoundIntrinsic`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:122072` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `GetIntrinsic` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/cast.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7822` | Self: 0.0% (0us) | Total: 8.6% (486.5ms) | Samples: 0

**Called by:**
- `runPlugins` (316)

**Calls:**
- `invokeMethodFnHandlers` (312)
- `invokeMethodFnHandlers` (3)
- `invokeMethodFnHandlers` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/esquery.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `getSettings`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321129` | Self: 0.0% (0us) | Total: 0.1% (6.0ms) | Samples: 0

**Called by:**
- `create` (2)
- `create` (2)

**Calls:**
- `setTagStructure` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:122251` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:193160` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `forEachPreferredTag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319681` | Self: 0.0% (0us) | Total: 1.2% (70.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (47)

**Calls:**
- `getPreferredTagName` (46)
- `getPreferredTagName` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319742` | Self: 0.0% (0us) | Total: 0.0% (4.3ms) | Samples: 0

**Called by:**
- `some` (3)

**Calls:**
- `hasTag` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/TypeVisitor.js:7` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `checkTagName`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334313` | Self: 0.0% (0us) | Total: 0.1% (7.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `(anonymous)` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:30` | Self: 0.0% (0us) | Total: 1.2% (69.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `(anonymous)` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_jsdoc_all.js:19` | Self: 0.0% (0us) | Total: 9.4% (534.7ms) | Samples: 0

**Called by:**
- `parseModule` (278)

**Calls:**
- `bundleRulesFor` (278)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172438` | Self: 0.0% (0us) | Total: 1.6% (93.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (21)

**Calls:**
- `(anonymous)` (21)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201979` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getPreferredTagName`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319659` | Self: 0.0% (0us) | Total: 2.1% (121.0ms) | Samples: 0

**Called by:**
- `forEachPreferredTag` (46)
- `(anonymous)` (33)

**Calls:**
- `getPreferredTagNameSimple` (76)
- `getPreferredTagNameSimple` (2)
- `getPreferredTagNameSimple` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:256205` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289818` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172430` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8199` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `reset` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:196251` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313220` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317576` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `forEach` (1)

**Calls:**
- `cleanUpLastTag` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint/plugin-kit/dist/cjs/index.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `hasRejectValue`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333266` | Self: 0.0% (0us) | Total: 0.0% (4.2ms) | Samples: 0

**Called by:**
- `shouldReport` (3)

**Calls:**
- `hasRejectValue` (3)

### `callIterator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321280` | Self: 0.0% (0us) | Total: 43.9% (2.47s) | Samples: 0

**Called by:**
- `onNodeWithComment` (1612)
- `onProgramExit` (6)
- `onNodeAllNodes` (1)

**Calls:**
- `iterate` (1593)
- `iterate` (26)

### `addMetaSchema`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:152` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `addSchema` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321302` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (2)

**Calls:**
- `getSettings` (2)

### `splitPrefixSuffix`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295814` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `camelCase` (1)

**Calls:**
- `split` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:40084` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:247682` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332324` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `rootNamer` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:241506` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7679` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `getDFSEvents` (1)
- `getDFSEvents` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313441` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `setTagStructure`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319286` | Self: 0.0% (0us) | Total: 0.1% (6.0ms) | Samples: 0

**Called by:**
- `getSettings` (4)

**Calls:**
- `getDefaultTagStructureForMode` (2)
- `getDefaultTagStructureForMode` (1)
- `getDefaultTagStructureForMode` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:187686` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:324380` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `(anonymous)` (2)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:262392` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290519` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295065` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:143807` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201046` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `flatIntoArrayWithCallback` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236731` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `validateParameterNames`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323669` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `filter` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333037` | Self: 0.0% (0us) | Total: 0.0% (3.4ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320882` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `getFunctionParameterNames` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319641` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `filter` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92469` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `slice` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313218` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `cleanUpLastTag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317512` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `parse2` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236608` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1599` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (1)

**Calls:**
- `_nodesFromRange` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/brace-expansion/dist/commonjs/index.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320915` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `isValidTag` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109738` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `parse3`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318783` | Self: 0.0% (0us) | Total: 2.3% (131.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (86)

**Calls:**
- `(anonymous)` (33)
- `(anonymous)` (17)
- `(anonymous)` (11)
- `(anonymous)` (8)
- `(anonymous)` (7)
- `getParser4` (3)
- `getParser4` (2)
- `getParser4` (2)
- `getParser4` (1)
- `getParser4` (1)
- `getParser4` (1)

### `onNodeWithComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321318` | Self: 0.0% (0us) | Total: 44.9% (2.52s) | Samples: 0

**Called by:**
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (1653)

**Calls:**
- `callIterator` (1612)
- `callIterator` (15)
- `callIterator` (11)
- `callIterator` (10)
- `callIterator` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config-loader.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.1ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:169357` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:49680` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289638` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:219710` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327361` | Self: 0.0% (0us) | Total: 1.9% (112.5ms) | Samples: 0

**Called by:**
- `iterate` (73)

**Calls:**
- `validateDescription` (72)
- `validateDescription` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:202002` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:262270` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328310` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `Program:exit` (2)

**Calls:**
- `report` (2)

### `commentParserToESTree`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317553` | Self: 0.0% (0us) | Total: 0.1% (7.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)
- `(anonymous)` (2)

**Calls:**
- `forEach` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:37` | Self: 0.0% (0us) | Total: 0.0% (4.4ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:8` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329778` | Self: 0.0% (0us) | Total: 2.1% (119.5ms) | Samples: 0

**Called by:**
- `iterate` (75)

**Calls:**
- `filter` (75)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/json-schema-traverse/index.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `resolveIds` (1)

**Calls:**
- `_traverse` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4306` | Self: 0.0% (0us) | Total: 0.1% (6.4ms) | Samples: 0

**Called by:**
- `get parent` (3)
- `get id` (1)

**Calls:**
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322474` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `stringSplitFast` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:238932` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/p-locate/index.js:2` | Self: 0.0% (0us) | Total: 0.0% (1.1ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/analyze.js:5` | Self: 0.0% (0us) | Total: 0.2% (12.5ms) | Samples: 0

**Called by:**
- `anonymous` (9)

**Calls:**
- `bound require` (9)

### `canSkip2`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333442` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:223868` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getDefaultTagStructureForMode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313714` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `setTagStructure` (2)

**Calls:**
- `Map` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170809` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/clear-caches.js:5` | Self: 0.0% (0us) | Total: 1.2% (72.6ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172496` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `ownKeys` (1)

### `_unwrap`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:337822` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `default` (1)

### `exemptSpeciaMethods`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320169` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `hasSchemaOption` (1)

### `FunctionDeclaration`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332133` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `_invokeFused` (2)

**Calls:**
- `checkJsDoc` (1)
- `checkJsDoc` (1)

### `findIndex`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `findExpectedIndex` (2)

**Calls:**
- `(anonymous)` (2)

### `forEach`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (8.2ms) | Samples: 0

**Called by:**
- `commentParserToESTree` (5)
- `rules` (1)

**Calls:**
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326707` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `some` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:144248` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317563` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `forEach` (1)

**Calls:**
- `_jdReadStr` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201939` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332545` | Self: 0.0% (0us) | Total: 0.1% (10.8ms) | Samples: 0

**Called by:**
- `iterate` (7)

**Calls:**
- `(anonymous)` (7)

### `isValidTag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319628` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `keys` (1)
- `flat` (1)

### `test`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:207` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `testSet` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:279` | Self: 0.0% (0us) | Total: 0.1% (6.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `map` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334546` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `canSkip6` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:176210` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188567` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/minimatch/dist/commonjs/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330499` | Self: 0.0% (0us) | Total: 0.0% (4.2ms) | Samples: 0

**Called by:**
- `some` (3)

**Calls:**
- `report` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:123` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `maskCodeBlocks`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322980` | Self: 0.0% (0us) | Total: 0.1% (5.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `replaceAll` (4)

### `hasRejectValue`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333264` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `hasRejectValue` (1)

**Calls:**
- `hasRejectValue` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138320` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313251` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `parseRange`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:163615` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329365` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/warnAboutTSVersion.js:42` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:19` | Self: 0.0% (0us) | Total: 0.0% (1.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `Ajv` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/locate-path/index.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.1ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313150` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1948` | Self: 0.0% (0us) | Total: 0.3% (19.0ms) | Samples: 0

**Called by:**
- `getTokenBefore` (12)

**Calls:**
- `getAllComments` (12)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329780` | Self: 0.0% (0us) | Total: 0.0% (4.5ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `map` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:41` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/TypeVisitor.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:185409` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getESLintCoreRule` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/ast-converter.js:7` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295760` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `map` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190646` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:247562` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236503` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170997` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321368` | Self: 0.0% (0us) | Total: 3.3% (185.9ms) | Samples: 0

**Called by:**
- `_invokeFused` (74)
- `_invokeFused` (45)
- `_invokeFused` (3)

**Calls:**
- `getJSDocComment` (118)
- `getJSDocComment` (2)
- `getJSDocComment` (1)
- `getJSDocComment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319509` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `map` (2)

**Calls:**
- `getParamName` (1)
- `getParamName` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:198766` | Self: 0.0% (0us) | Total: 0.3% (19.1ms) | Samples: 0

**Called by:**
- `anonymous` (12)

**Calls:**
- `(anonymous)` (7)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `internal:fs/streams`
`internal:fs/streams:2` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `checkTagName2`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334521` | Self: 0.0% (0us) | Total: 0.1% (6.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `(anonymous)` (4)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318034` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `findJSDocComment` (2)

**Calls:**
- `getTokensBefore` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `defineProperty` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `Ajv`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:63` | Self: 0.0% (0us) | Total: 0.0% (1.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `rules` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:54` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289753` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:51652` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:144188` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183392` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138748` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:19` | Self: 0.0% (0us) | Total: 0.1% (10.6ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/p-limit/index.js:2` | Self: 0.0% (0us) | Total: 0.0% (1.1ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313061` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (2)

### `hasRejectValue`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333311` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `hasRejectValue` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329117` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `flatMap` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137796` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/resolveProjectList.js:10` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:49666` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289781` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289848` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332065` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `checkJsDoc` (1)

**Calls:**
- `report` (1)

### `get identifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:795` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `defs` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320903` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getJsdocTagsDeep` (1)

### `canSkip`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333338` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329334` | Self: 0.0% (0us) | Total: 0.1% (9.1ms) | Samples: 0

**Called by:**
- `iterate` (6)

**Calls:**
- `(anonymous)` (5)
- `(anonymous)` (1)

### `hasTag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319635` | Self: 0.0% (0us) | Total: 0.1% (7.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)
- `(anonymous)` (1)
- `getPreferredTagName` (1)

**Calls:**
- `some` (5)

### `getTagNames`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:191` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `loadBinding` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2137` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `_symName` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201991` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2358` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `get` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:250341` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-modifiers.js:39` | Self: 0.0% (0us) | Total: 0.0% (1.1ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321382` | Self: 0.0% (0us) | Total: 0.5% (33.6ms) | Samples: 0

**Called by:**
- `_invokeFused` (21)

**Calls:**
- `onProgramExit` (19)
- `onProgramExit` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328272` | Self: 0.0% (0us) | Total: 2.9% (164.2ms) | Samples: 0

**Called by:**
- `Program:exit` (108)

**Calls:**
- `filter` (108)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/index.js:18` | Self: 0.0% (0us) | Total: 0.2% (12.5ms) | Samples: 0

**Called by:**
- `anonymous` (9)

**Calls:**
- `bound require` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138558` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4161` | Self: 0.0% (0us) | Total: 0.4% (23.4ms) | Samples: 0

**Called by:**
- `report` (15)

**Calls:**
- `(anonymous)` (6)
- `(anonymous)` (3)
- `fix10` (2)
- `fix10` (1)
- `fix10` (1)
- `(anonymous)` (1)
- `fix10` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228839` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12341` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289697` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326780` | Self: 0.0% (0us) | Total: 0.0% (4.5ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `(anonymous)` (3)

### `getInlineTags`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319714` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `flatIntoArrayWithCallback` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161658` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `callIterator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321271` | Self: 0.0% (0us) | Total: 0.3% (18.0ms) | Samples: 0

**Called by:**
- `onNodeWithComment` (11)

**Calls:**
- `every` (11)

### `validateDescription`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327351` | Self: 0.0% (0us) | Total: 1.9% (110.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (72)

**Calls:**
- `test` (72)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/index.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `getReducedASTNode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317998` | Self: 0.0% (0us) | Total: 0.2% (13.1ms) | Samples: 0

**Called by:**
- `getJSDocComment` (6)
- `getNonJsdocComment` (3)

**Calls:**
- `getCommentsBefore` (6)
- `getCommentsBefore` (3)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318058` | Self: 0.0% (0us) | Total: 4.0% (230.3ms) | Samples: 0

**Called by:**
- `getJSDocComment` (151)

**Calls:**
- `findJSDocComment` (136)
- `findJSDocComment` (6)
- `findJSDocComment` (3)
- `findJSDocComment` (3)
- `findJSDocComment` (2)
- `findJSDocComment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:247566` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:559` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `getESLintCoreRule`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:174894` | Self: 0.0% (0us) | Total: 0.1% (6.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `bound require` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:35704` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `union` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330254` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `parseType`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315072` | Self: 0.0% (0us) | Total: 0.1% (6.3ms) | Samples: 0

**Called by:**
- `parse` (4)

**Calls:**
- `parseIntermediateType` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/index.js:3` | Self: 0.0% (0us) | Total: 0.3% (19.4ms) | Samples: 0

**Called by:**
- `anonymous` (13)

**Calls:**
- `bound require` (13)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/apply-disable-directives.js:22` | Self: 0.0% (0us) | Total: 0.2% (16.1ms) | Samples: 0

**Called by:**
- `anonymous` (11)

**Calls:**
- `bound require` (11)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332236` | Self: 0.0% (0us) | Total: 0.0% (4.6ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173329` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289805` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_getOrBuildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6160` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_buildPlan` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:222330` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:222600` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318590` | Self: 0.0% (0us) | Total: 0.4% (26.7ms) | Samples: 0

**Called by:**
- `parse3` (17)

**Calls:**
- `parseBlock` (11)
- `parseBlock` (3)
- `parseBlock` (2)
- `parseBlock` (1)

### `validateParameterNames`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323683` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `some` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (1.1ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:94` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/fdir/dist/index.cjs:462` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `parseInlineTags`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318842` | Self: 0.0% (0us) | Total: 2.6% (151.6ms) | Samples: 0

**Called by:**
- `parseComment` (101)

**Calls:**
- `parseDescription` (58)
- `parseDescription` (43)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318593` | Self: 0.0% (0us) | Total: 0.2% (11.5ms) | Samples: 0

**Called by:**
- `parse3` (8)

**Calls:**
- `compactJoiner` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329317` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `flatIntoArrayWithCallback` (1)

**Calls:**
- `get key` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320472` | Self: 0.0% (0us) | Total: 0.1% (9.0ms) | Samples: 0

**Called by:**
- `_execReport` (6)

**Calls:**
- `fixer` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:104242` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `descriptionIsRedundant`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327093` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `areDocsInformative` (1)

### `getTags`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319645` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `filterTags` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329115` | Self: 0.0% (0us) | Total: 2.3% (130.6ms) | Samples: 0

**Called by:**
- `iterate` (85)

**Calls:**
- `filter` (85)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328277` | Self: 0.0% (0us) | Total: 0.0% (4.7ms) | Samples: 0

**Called by:**
- `filter` (3)

**Calls:**
- `some` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313169` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330485` | Self: 0.0% (0us) | Total: 0.0% (4.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `report` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289708` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `onNodeAllNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321329` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (1)

**Calls:**
- `callIterator` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:195832` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295778` | Self: 0.0% (0us) | Total: 0.0% (3.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)
- `(anonymous)` (1)

**Calls:**
- `toLocaleLowerCase` (3)

### `validateDescription`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330453` | Self: 0.0% (0us) | Total: 0.0% (4.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `some` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323004` | Self: 0.0% (0us) | Total: 0.1% (11.0ms) | Samples: 0

**Called by:**
- `iterate` (7)

**Calls:**
- `maskCodeBlocks` (4)
- `maskCodeBlocks` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:238788` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321046` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getInlineTags` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/unsupported-api.js:14` | Self: 0.0% (0us) | Total: 0.7% (39.6ms) | Samples: 0

**Called by:**
- `anonymous` (27)

**Calls:**
- `bound require` (27)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:200154` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `shouldReport`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333368` | Self: 0.0% (0us) | Total: 0.1% (6.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `hasRejectValue` (3)
- `hasRejectValue` (1)

### `getCommentsBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3421` | Self: 0.0% (0us) | Total: 0.0% (3.8ms) | Samples: 0

**Called by:**
- `getReducedASTNode` (3)

**Calls:**
- `commentsInRange` (2)
- `commentsInRange` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:139441` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `__export` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:277230` | Self: 0.0% (0us) | Total: 0.1% (7.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `(anonymous)` (5)

### `node:tty`
`node:tty:6` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:42` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109733` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201965` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190639` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92489` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329110` | Self: 0.0% (0us) | Total: 2.6% (147.6ms) | Samples: 0

**Called by:**
- `iterate` (97)

**Calls:**
- `filter` (97)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:168417` | Self: 0.0% (0us) | Total: 1.3% (76.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (49)

**Calls:**
- `(anonymous)` (49)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322534` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:272225` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `Lc` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/index.js:17` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326769` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313234` | Self: 0.0% (0us) | Total: 1.3% (76.2ms) | Samples: 0

**Called by:**
- `anonymous` (49)

**Calls:**
- `(anonymous)` (49)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/source-code-traverser.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:226564` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `createToken` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295790` | Self: 0.0% (0us) | Total: 0.0% (921us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318254` | Self: 0.0% (0us) | Total: 0.3% (17.3ms) | Samples: 0

**Called by:**
- `toggleFence` (11)

**Calls:**
- `stringSplitFast` (11)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:17` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:116280` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:48` | Self: 0.0% (0us) | Total: 1.2% (69.4ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `(anonymous)` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137597` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:202009` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-modifiers.js:38` | Self: 0.0% (0us) | Total: 0.1% (6.0ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `bound require` (4)

### `validateDescription`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327352` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `report` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332870` | Self: 0.0% (0us) | Total: 0.0% (4.9ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/index.js:26` | Self: 0.0% (0us) | Total: 0.2% (13.7ms) | Samples: 0

**Called by:**
- `anonymous` (10)

**Calls:**
- `bound require` (10)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4103` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_fromRunnerReport` (1)

**Calls:**
- `getLocFromIndex` (1)

### `areDocsInformative`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326998` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `descriptionIsRedundant` (1)

**Calls:**
- `splitTextIntoWords` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/dotjs/index.js:20` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333461` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `canSkip2` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:128056` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:159547` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:53668` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:134057` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getIndentAndJSDoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321224` | Self: 0.0% (0us) | Total: 1.8% (101.3ms) | Samples: 0

**Called by:**
- `checkJsdoc` (53)
- `callIterator` (14)

**Calls:**
- `parseComment` (67)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:162504` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/index.js:18` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329313` | Self: 0.0% (0us) | Total: 0.1% (7.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `flatIntoArrayWithCallback` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313242` | Self: 0.0% (0us) | Total: 2.1% (119.5ms) | Samples: 0

**Called by:**
- `anonymous` (39)

**Calls:**
- `(anonymous)` (39)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/index.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171547` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `tokenAfterIgnoringSemis`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318107` | Self: 0.0% (0us) | Total: 8.9% (503.6ms) | Samples: 0

**Called by:**
- `getFollowingComment` (330)

**Calls:**
- `getTokensAfterIgnoringSemis` (330)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:187680` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:244612` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260701` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/code-path-analysis/code-path-state.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330673` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:108506` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `applyBind` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4288` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `reset` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290269` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (2)

### `canSkip5`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334303` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_loadBundle`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-loader.js:34` | Self: 0.0% (0us) | Total: 9.4% (534.7ms) | Samples: 0

**Called by:**
- `bundleRulesFor` (278)

**Calls:**
- `bound require` (278)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290309` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333473` | Self: 0.0% (0us) | Total: 0.0% (4.7ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329120` | Self: 0.0% (0us) | Total: 0.3% (20.5ms) | Samples: 0

**Called by:**
- `iterate` (14)

**Calls:**
- `flatMap` (8)
- `flatIntoArrayWithCallback` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:21` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:197313` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295781` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `toLocaleUpperCase` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109021` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `canSkip3`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333682` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91298` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:45765` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321652` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:12` | Self: 0.0% (0us) | Total: 0.2% (12.0ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329251` | Self: 0.0% (0us) | Total: 0.9% (53.2ms) | Samples: 0

**Called by:**
- `iterate` (34)

**Calls:**
- `Set` (28)
- `get` (5)
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:202021` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_addSchema`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:309` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `addSchema` (1)

**Calls:**
- `resolveIds` (1)

### `get tag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4988` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `_jdReadStr` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/cast.js:327` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:282438` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326659` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `stringSplitFast` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:45` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326129` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 27.5% (1.55s) | Samples: 0

**Called by:**
- `_loadBundle` (278)
- `(anonymous)` (49)
- `(anonymous)` (27)
- `(anonymous)` (27)
- `(anonymous)` (20)
- `(anonymous)` (20)
- `(anonymous)` (19)
- `(anonymous)` (14)
- `(anonymous)` (13)
- `(anonymous)` (13)
- `(anonymous)` (12)
- `(anonymous)` (11)
- `(anonymous)` (11)
- `(anonymous)` (10)
- `(anonymous)` (10)
- `(anonymous)` (10)
- `(anonymous)` (9)
- `(anonymous)` (9)
- `(anonymous)` (9)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `getESLintCoreRule` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `patchAstUtils` (4)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `loadBinding` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `require` (793)
- `anonymous` (5)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:24` | Self: 0.0% (0us) | Total: 0.0% (2.4ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:28` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171858` | Self: 0.0% (0us) | Total: 1.6% (93.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (21)

**Calls:**
- `(anonymous)` (21)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327682` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `report` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/rules.js:45` | Self: 0.0% (0us) | Total: 0.0% (1.0ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `push` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:176201` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:10` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:128086` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301236` | Self: 0.0% (0us) | Total: 0.2% (11.8ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `(anonymous)` (8)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4221` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_nodeViewRaw` (1)

**Calls:**
- `_computeIdentifierName` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint/config-array/dist/cjs/index.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4559` | Self: 0.0% (0us) | Total: 0.6% (36.3ms) | Samples: 0

**Called by:**
- `runPlugins` (24)

**Calls:**
- `create` (23)
- `create` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:162377` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12521` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91300` | Self: 0.0% (0us) | Total: 0.0% (910us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `findExpectedIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332296` | Self: 0.0% (0us) | Total: 0.0% (3.4ms) | Samples: 0

**Called by:**
- `fix10` (2)

**Calls:**
- `filter` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96670` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `every`
`[native code]` | Self: 0.0% (0us) | Total: 0.3% (18.0ms) | Samples: 0

**Called by:**
- `callIterator` (11)

**Calls:**
- `(anonymous)` (11)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173369` | Self: 0.0% (0us) | Total: 0.3% (17.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (12)

**Calls:**
- `bound require` (12)

### `splitLines`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318209` | Self: 0.0% (0us) | Total: 0.2% (14.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (9)

**Calls:**
- `regExpSplitFast` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170774` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:99211` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:324134` | Self: 0.0% (0us) | Total: 0.0% (4.4ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `(anonymous)` (3)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:955` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_ensureDeclSymIndex` (1)

**Calls:**
- `_buildSymNameCache` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:223799` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295789` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:108954` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326357` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `some` (1)

**Calls:**
- `trimStart` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4682` | Self: 0.0% (0us) | Total: 0.3% (21.2ms) | Samples: 0

**Called by:**
- `runPlugins` (14)

**Calls:**
- `create` (11)
- `create` (2)
- `create` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/clear-caches.js:6` | Self: 0.0% (0us) | Total: 0.3% (19.7ms) | Samples: 0

**Called by:**
- `anonymous` (13)

**Calls:**
- `bound require` (13)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:252900` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.0% (4.3ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `matchAll`
`[native code]` | Self: 0.0% (0us) | Total: 2.8% (161.7ms) | Samples: 0

**Called by:**
- `parseDescription` (58)
- `parseDescription` (50)

**Calls:**
- `get flags` (89)
- `esSpecIsRegExp` (13)
- `stringIncludesInternal` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321035` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `filterTags` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_jsdoc_all.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `readFileSync` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171637` | Self: 0.0% (0us) | Total: 1.6% (92.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (20)

**Calls:**
- `(anonymous)` (20)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2348` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `_ensureDeclSymIndex` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96733` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289723` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313183` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/cli-engine/hash.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320466` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `rewireSpecs` (1)

### `onProgramExit`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321334` | Self: 0.0% (0us) | Total: 0.5% (30.4ms) | Samples: 0

**Called by:**
- `Program:exit` (19)

**Calls:**
- `callIterator` (13)
- `callIterator` (6)

### `splitCR`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318201` | Self: 0.0% (0us) | Total: 0.0% (4.7ms) | Samples: 0

**Called by:**
- `parseSource` (3)

**Calls:**
- `match` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/dotjs/index.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318277` | Self: 0.0% (0us) | Total: 0.1% (6.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `trimEnd` (2)
- `endsWith` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:102857` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `RegExp` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/index.js:3` | Self: 0.0% (0us) | Total: 0.1% (7.5ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329082` | Self: 0.0% (0us) | Total: 0.0% (4.7ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `get globalScope` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:29` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `addMetaSchema` (1)

### `getFunctionParameterNames`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319508` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `map` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290268` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `internal:util/inspect`
`internal:util/inspect:9` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bind` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323552` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `checkNotAlignedPerTag` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1123` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `reset` (1)

**Calls:**
- `_getSharedCaches` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:108524` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `forEachPreferredTag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319694` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `checkHyphens` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228680` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:122147` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `callBoundIntrinsic` (1)

### `invokeHandlersWithNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6894` | Self: 0.0% (0us) | Total: 0.9% (51.1ms) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (34)

**Calls:**
- `bound checkJsdoc` (34)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:455` | Self: 0.0% (0us) | Total: 0.1% (6.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `bound require` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/lazy-loading-rule-map.js:7` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/code-path-analysis/code-path.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301308` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `addPolyfillToken` (2)

### `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321376` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `invokeHandlersWithNode` (1)

**Calls:**
- `onNodeAllNodes` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318265` | Self: 0.0% (0us) | Total: 0.1% (7.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `splitCR` (3)
- `splitCR` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:324541` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `(anonymous)` (2)

### `get globalScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3938` | Self: 0.0% (0us) | Total: 0.0% (4.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `_precomputeScopes` (2)
- `_precomputeScopes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321087` | Self: 0.0% (0us) | Total: 1.3% (74.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (16)
- `(anonymous)` (10)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `forEachPreferredTag` (47)
- `forEachPreferredTag` (1)
- `forEachPreferredTag` (1)

### `canSkip4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334204` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `hasRejectValue`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333269` | Self: 0.0% (0us) | Total: 0.0% (4.2ms) | Samples: 0

**Called by:**
- `hasRejectValue` (3)

**Calls:**
- `some` (2)
- `get body` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109109` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:144139` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329121` | Self: 0.0% (0us) | Total: 0.3% (18.8ms) | Samples: 0

**Called by:**
- `flatIntoArrayWithCallback` (13)

**Calls:**
- `filter` (13)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:99341` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:17` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `fix10`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330460` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `_execReport` (2)

**Calls:**
- `RegExp` (1)
- `replace` (1)

### `exemptSpeciaMethods`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320170` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `hasATag` (1)

### `rules`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/rules.js:33` | Self: 0.0% (0us) | Total: 0.0% (1.0ms) | Samples: 0

**Called by:**
- `Ajv` (1)

**Calls:**
- `forEach` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:174945` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/warnAboutTSVersion.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12515` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290397` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `parse`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.1% (9.2ms) | Samples: 0

**Called by:**
- `g` (5)

**Calls:**
- `Ae` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201946` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `applyBind`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:94784` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bind` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:261303` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333270` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `some` (2)

**Calls:**
- `hasRejectValue` (1)
- `hasRejectValue` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2480` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (2)

**Calls:**
- `exec` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327227` | Self: 0.0% (0us) | Total: 28.6% (1.61s) | Samples: 0

**Called by:**
- `iterate` (1057)

**Calls:**
- `slice` (1057)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:222334` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321371` | Self: 0.0% (0us) | Total: 44.9% (2.53s) | Samples: 0

**Called by:**
- `_invokeFused` (1320)
- `_invokeFused` (306)
- `invokeHandlersWithNode` (28)

**Calls:**
- `onNodeWithComment` (1653)
- `onNodeWithComment` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321404` | Self: 0.0% (0us) | Total: 2.9% (167.2ms) | Samples: 0

**Called by:**
- `_invokeFused` (110)

**Calls:**
- `(anonymous)` (108)
- `(anonymous)` (2)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1947` | Self: 0.0% (0us) | Total: 8.2% (464.1ms) | Samples: 0

**Called by:**
- `getTokenBefore` (300)

**Calls:**
- `_getAllTokens` (288)
- `_getAllTokens` (12)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:110358` | Self: 0.0% (0us) | Total: 0.0% (4.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `(anonymous)` (3)

### `Ae`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.1% (9.2ms) | Samples: 0

**Called by:**
- `parse` (5)

**Calls:**
- `_e` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172435` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `testSet`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:525` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `test` (1)

**Calls:**
- `test` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201915` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:296489` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:200163` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333704` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201969` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `Range`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:163554` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92620` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:223938` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getFollowingComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318110` | Self: 0.0% (0us) | Total: 8.9% (503.6ms) | Samples: 0

**Called by:**
- `checkNonJsdocAfter` (330)

**Calls:**
- `tokenAfterIgnoringSemis` (330)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228578` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:202003` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `internal:streams/pipeline`
`internal:streams/pipeline:2` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172520` | Self: 0.0% (0us) | Total: 1.7% (96.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (23)

**Calls:**
- `(anonymous)` (23)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:174910` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `parseComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318950` | Self: 0.0% (0us) | Total: 5.0% (284.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (119)
- `getIndentAndJSDoc` (67)
- `(anonymous)` (1)
- `getTemplateTags` (1)

**Calls:**
- `parseInlineTags` (101)
- `parseInlineTags` (87)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290218` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `__toESM` (1)
- `(anonymous)` (1)

### `ke`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.3% (17.9ms) | Samples: 0

**Called by:**
- `we` (11)

**Calls:**
- `(anonymous)` (11)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172663` | Self: 0.0% (0us) | Total: 1.7% (98.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (24)

**Calls:**
- `(anonymous)` (24)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326936` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `setDeps` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:16` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `resolveIds`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:239` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_addSchema` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172522` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320507` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `getRegexFromString` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330562` | Self: 0.0% (0us) | Total: 0.0% (4.2ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `validateDescription` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334210` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `canSkip4` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:219778` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `union`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:35697` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `Set` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/tinyglobby/dist/index.cjs:27` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `checkNonJsdocAfter`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326356` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `some` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:20` | Self: 0.0% (0us) | Total: 0.1% (6.0ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `bound require` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:192407` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getESLintCoreRule` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171041` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `find`
`[native code]` | Self: 0.0% (0us) | Total: 0.4% (25.9ms) | Samples: 0

**Called by:**
- `getPreferredTagNameSimple` (17)

**Calls:**
- `(anonymous)` (17)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:324409` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `match`
`[native code]` | Self: 0.0% (0us) | Total: 0.2% (12.8ms) | Samples: 0

**Called by:**
- `splitSpace` (5)
- `splitCR` (3)

**Calls:**
- `[Symbol.match]` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `splitTextIntoWords`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327014` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `areDocsInformative` (1)

**Calls:**
- `flatIntoArrayWithCallback` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334556` | Self: 0.0% (0us) | Total: 0.1% (6.0ms) | Samples: 0

**Called by:**
- `iterate` (4)

**Calls:**
- `checkTagName2` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:293515` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313168` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320906` | Self: 0.0% (0us) | Total: 0.9% (53.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (7)
- `(anonymous)` (5)
- `checkTagName` (4)
- `checkTagName2` (4)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `getPreferredTagName` (33)
- `getPreferredTagName` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:220` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `_encodeSource` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161415` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_computeIdentifierName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4209` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_NodeView_LR` (1)

**Calls:**
- `slice` (1)

### `_e`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.2% (13.5ms) | Samples: 0

**Called by:**
- `Ae` (5)
- `(anonymous)` (3)

**Calls:**
- `Pe` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313046` | Self: 0.0% (0us) | Total: 0.1% (5.9ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `(anonymous)` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:48` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320921` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `hasTag` (1)

### `getParser4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318574` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `parse3` (1)

**Calls:**
- `typeTokenizer` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/default-config.js:37` | Self: 0.0% (0us) | Total: 0.1% (9.2ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8206` | Self: 0.0% (0us) | Total: 1.0% (59.3ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (39)

**Calls:**
- `buildVisitorMap` (24)
- `buildVisitorMap` (14)
- `buildVisitorMap` (1)

### `defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `get identifiers` (1)

**Calls:**
- `_computeVarDefs` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:728` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (1)

**Calls:**
- `_findLineIdx` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:217111` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `parse`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315065` | Self: 0.0% (0us) | Total: 0.1% (6.3ms) | Samples: 0

**Called by:**
- `parse2` (4)

**Calls:**
- `parseType` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96160` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` | Self: 0.0% (0us) | Total: 0.1% (9.3ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4632` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_ensureNameToTagIds` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:337820` | Self: 0.0% (0us) | Total: 0.7% (42.7ms) | Samples: 0

**Called by:**
- `anonymous` (27)

**Calls:**
- `(anonymous)` (27)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:37` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109739` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301278` | Self: 0.0% (0us) | Total: 0.1% (8.3ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `map` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92619` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138801` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92697` | Self: 0.0% (0us) | Total: 0.2% (11.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (8)

**Calls:**
- `(anonymous)` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_jsdoc_all.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313257` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173370` | Self: 0.0% (0us) | Total: 1.8% (102.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (27)

**Calls:**
- `(anonymous)` (27)

### `maskExcludedContent`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322972` | Self: 0.0% (0us) | Total: 0.0% (4.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `RegExp` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:19` | Self: 0.0% (0us) | Total: 0.2% (16.1ms) | Samples: 0

**Called by:**
- `anonymous` (11)

**Calls:**
- `bound require` (11)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:33` | Self: 0.0% (0us) | Total: 25.4% (1.43s) | Samples: 0

**Called by:**
- `(anonymous)` (49)
- `(anonymous)` (49)
- `(anonymous)` (39)
- `(anonymous)` (27)
- `(anonymous)` (27)
- `(anonymous)` (27)
- `(anonymous)` (24)
- `(anonymous)` (24)
- `(anonymous)` (23)
- `(anonymous)` (21)
- `(anonymous)` (21)
- `(anonymous)` (20)
- `(anonymous)` (19)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (49)
- `(anonymous)` (49)
- `(anonymous)` (39)
- `(anonymous)` (27)
- `(anonymous)` (27)
- `(anonymous)` (24)
- `(anonymous)` (24)
- `(anonymous)` (23)
- `(anonymous)` (21)
- `(anonymous)` (21)
- `(anonymous)` (20)
- `(anonymous)` (20)
- `(anonymous)` (12)
- `(anonymous)` (8)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173330` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/comparator.js:143` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `internal:validators`
`internal:validators:2` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `parseIntermediateType`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315075` | Self: 0.0% (0us) | Total: 0.1% (6.3ms) | Samples: 0

**Called by:**
- `parseType` (4)

**Calls:**
- `tryParslets` (4)

### `iterate`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321186` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `checkJsdoc` (1)

**Calls:**
- `makeReport` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:244477` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326382` | Self: 0.0% (0us) | Total: 8.9% (506.7ms) | Samples: 0

**Called by:**
- `bound ` (332)

**Calls:**
- `checkNonJsdocAfter` (331)
- `checkNonJsdocAfter` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/parse-string.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:58223` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:247637` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `fix10`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332524` | Self: 0.0% (0us) | Total: 0.1% (7.7ms) | Samples: 0

**Called by:**
- `fixer` (5)

**Calls:**
- `findExpectedIndex` (2)
- `findExpectedIndex` (2)
- `findExpectedIndex` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:197357` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getPreferredTagNameSimple`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319602` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `getPreferredTagName` (1)

**Calls:**
- `entries` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290444` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `internal:stream`
`internal:stream:2` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290165` | Self: 0.0% (0us) | Total: 0.7% (42.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (27)

**Calls:**
- `(anonymous)` (27)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/convert.js:41` | Self: 0.0% (0us) | Total: 0.1% (8.6ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:51145` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:62` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:218` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `LRUCache` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:29585` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:11` | Self: 0.0% (0us) | Total: 0.1% (10.2ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2855` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `get globalScope` (1)

**Calls:**
- `test` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318587` | Self: 0.0% (0us) | Total: 0.9% (50.8ms) | Samples: 0

**Called by:**
- `parse3` (33)

**Calls:**
- `parseSource` (10)
- `parseSource` (5)
- `parseSource` (4)
- `parseSource` (4)
- `parseSource` (3)
- `parseSource` (2)
- `parseSource` (2)
- `parseSource` (1)
- `parseSource` (1)
- `parseSource` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334213` | Self: 0.0% (0us) | Total: 0.1% (8.0ms) | Samples: 0

**Called by:**
- `iterate` (5)

**Calls:**
- `(anonymous)` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:40` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `parseBlock`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318247` | Self: 0.0% (0us) | Total: 0.3% (17.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (11)

**Calls:**
- `toggleFence` (11)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96182` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:181150` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getESLintCoreRule` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7919` | Self: 0.0% (0us) | Total: 3.5% (200.8ms) | Samples: 0

**Called by:**
- `runPlugins` (131)

**Calls:**
- `_invokeFused` (131)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323945` | Self: 0.0% (0us) | Total: 0.0% (4.9ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `validateParameterNames` (2)
- `validateParameterNames` (1)

### `Ce`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (4.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `Pe` (3)

### `exec`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (4.2ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (2)
- `next` (1)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (2)
- `/(?<!\])\{@(?<tag>[^\}\s]+)\s?(?<namepathOrURL>[^\}\s\\|]*)\s*(?<separator>[\s\\|])?\s*(?<text>[^\}]*)\}/dgv` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:5923` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:285378` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289658` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321036` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/es2016.full.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201920` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Visitor.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:110356` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:38` | Self: 0.0% (0us) | Total: 0.1% (7.1ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333345` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `canSkip` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/lib/picomatch.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `findExpectedIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332279` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `fix10` (2)

**Calls:**
- `findIndex` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137664` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137561` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `regexTester` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320556` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `join` (1)

### `getParamName`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319403` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333035` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301314` | Self: 0.0% (0us) | Total: 0.0% (4.8ms) | Samples: 0

**Called by:**
- `map` (4)

**Calls:**
- `(anonymous)` (2)
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327262` | Self: 0.0% (0us) | Total: 0.1% (6.3ms) | Samples: 0

**Called by:**
- `iterate` (4)

**Calls:**
- `report` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329112` | Self: 0.0% (0us) | Total: 3.2% (181.6ms) | Samples: 0

**Called by:**
- `iterate` (120)

**Calls:**
- `map` (120)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:143983` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/token-store/cursors.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329182` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `flatIntoArrayWithCallback` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334344` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `canSkip5` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/rules.js:34` | Self: 0.0% (0us) | Total: 0.0% (1.0ms) | Samples: 0

**Called by:**
- `forEach` (1)

**Calls:**
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92521` | Self: 0.0% (0us) | Total: 0.0% (5.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `(anonymous)` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:99288` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `get id`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2395` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `nodeView` (1)

### `getPreferredTagNameSimple`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319615` | Self: 0.0% (0us) | Total: 2.0% (116.7ms) | Samples: 0

**Called by:**
- `getPreferredTagName` (76)

**Calls:**
- `entries` (59)
- `find` (17)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170818` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228163` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319404` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `getParamName` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:271833` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `parse` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:222405` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getAllComments`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3465` | Self: 0.0% (0us) | Total: 0.3% (19.0ms) | Samples: 0

**Called by:**
- `_getTokensAndCommentsMerged` (12)

**Calls:**
- `commentsInRange` (10)
- `commentsInRange` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:497` | Self: 0.0% (0us) | Total: 0.1% (6.1ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `patchAstUtils` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:44` | Self: 0.0% (0us) | Total: 0.4% (27.6ms) | Samples: 0

**Called by:**
- `anonymous` (19)

**Calls:**
- `bound require` (19)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329331` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `filter` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:53` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `processTicksAndRejections`
`[native code]` | Self: 0.0% (0us) | Total: 90.2% (5.07s) | Samples: 0

**Calls:**
- `(anonymous)` (3317)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/find-up/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.1ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `camelCase`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295754` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `addPolyfillToken` (1)

**Calls:**
- `splitPrefixSuffix` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289650` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `hasATag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319741` | Self: 0.0% (0us) | Total: 0.0% (4.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)
- `exemptSpeciaMethods` (1)

**Calls:**
- `some` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:22` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `y`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317612` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `forEach` (1)

**Calls:**
- `_jdReadStr` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137930` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:62` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `test` (1)

### `fixer`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332536` | Self: 0.0% (0us) | Total: 0.1% (9.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `fix10` (5)
- `fix10` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323005` | Self: 0.0% (0us) | Total: 0.1% (11.2ms) | Samples: 0

**Called by:**
- `iterate` (7)

**Calls:**
- `maskExcludedContent` (4)
- `maskExcludedContent` (3)

### `getValidRuntimeIdentifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329197` | Self: 0.0% (0us) | Total: 0.0% (4.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `get` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/prelude-ls/lib/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2482` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (2)

**Calls:**
- `test` (2)

### `generateNamedReferences`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321889` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `stringSplitFast` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301337` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `add` (1)

### `internal:streams/operators`
`internal:streams/operators:2` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:250172` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2926` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `defs` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `addPolyfillToken`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301274` | Self: 0.0% (0us) | Total: 0.0% (4.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)
- `(anonymous)` (2)

**Calls:**
- `camelCase` (3)
- `camelCase` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323875` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `some` (1)

**Calls:**
- `join` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/Scope.js:38` | Self: 0.0% (0us) | Total: 0.2% (13.7ms) | Samples: 0

**Called by:**
- `anonymous` (10)

**Calls:**
- `bound require` (10)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/index.js:18` | Self: 0.0% (0us) | Total: 1.6% (92.3ms) | Samples: 0

**Called by:**
- `anonymous` (20)

**Calls:**
- `bound require` (20)

### `node:stream`
`node:stream:2` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329136` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `flatIntoArrayWithCallback` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201975` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `node:events`
`node:events:9` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/code-path-analysis/code-path-segment.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201051` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `filter` (1)
- `flatIntoArrayWithCallback` (1)

**Calls:**
- `filter` (1)
- `(anonymous)` (1)

### `internal:primordials`
`internal:primordials:50` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `createSafeIterator` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173358` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `node:util`
`node:util:2` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:15` | Self: 0.0% (0us) | Total: 0.1% (10.2ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `jsdocTagsByName`
`/Users/ericsan/Development/OpenSource/Ez/js/rewrite-helpers.js:511` | Self: 0.0% (0us) | Total: 0.0% (3.4ms) | Samples: 0

**Called by:**
- `forEachPreferredTag` (1)
- `(anonymous)` (1)

**Calls:**
- `tagsByName` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329113` | Self: 0.0% (0us) | Total: 3.2% (180.2ms) | Samples: 0

**Called by:**
- `map` (119)

**Calls:**
- `parseComment` (119)

### `getIndentAndJSDoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321223` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `checkJsdoc` (2)

**Calls:**
- `repeat` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321027` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getTags` (1)

### `checkJsDoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332001` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `FunctionDeclaration` (1)

**Calls:**
- `getJSDocComment` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` | Self: 0.0% (0us) | Total: 4.0% (227.9ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (149)

**Calls:**
- `parse` (149)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:52088` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `createToken` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/default-config.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330269` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `checkDescription` (1)

### `internal:streams/compose`
`internal:streams/compose:2` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:277206` | Self: 0.0% (0us) | Total: 0.1% (7.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `(anonymous)` (5)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2851` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `get globalScope` (2)

**Calls:**
- `commentsInRange` (1)
- `commentsInRange` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289625` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `iterate`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321187` | Self: 0.0% (0us) | Total: 1.3% (75.3ms) | Samples: 0

**Called by:**
- `callIterator` (26)
- `checkJsdoc` (23)

**Calls:**
- `getUtils` (26)
- `getUtils` (9)
- `getUtils` (7)
- `getUtils` (2)
- `getUtils` (1)
- `getUtils` (1)
- `getUtils` (1)
- `getUtils` (1)
- `getUtils` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:20` | Self: 0.0% (0us) | Total: 0.3% (20.7ms) | Samples: 0

**Called by:**
- `anonymous` (14)

**Calls:**
- `bound require` (14)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:3` | Self: 0.0% (0us) | Total: 0.0% (4.1ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332260` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `flattenRoots` (1)

### `checkDescription`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330239` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `trim` (1)

### `_fromRunnerReport`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:203` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `get message` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:51201` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/getWatchProgramsForProjects.js:45` | Self: 0.0% (0us) | Total: 1.2% (70.9ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:213129` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321912` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `generateNamedReferences` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317739` | Self: 0.0% (0us) | Total: 0.0% (4.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `commentParserToESTree` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:278557` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320897` | Self: 0.0% (0us) | Total: 0.1% (9.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171639` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318057` | Self: 0.0% (0us) | Total: 0.7% (41.8ms) | Samples: 0

**Called by:**
- `getJSDocComment` (27)

**Calls:**
- `getReducedASTNode` (10)
- `getReducedASTNode` (6)
- `getReducedASTNode` (6)
- `getReducedASTNode` (2)
- `getReducedASTNode` (2)
- `getReducedASTNode` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322436` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:122164` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getReducedASTNode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318001` | Self: 0.0% (0us) | Total: 0.1% (6.5ms) | Samples: 0

**Called by:**
- `getJSDocComment` (2)
- `getNonJsdocComment` (2)

**Calls:**
- `getCommentsBefore` (2)
- `getCommentsBefore` (2)

### `getPreferredTagName`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319661` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `hasTag` (1)

### `filterTags`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319640` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `getTags` (1)
- `(anonymous)` (1)

**Calls:**
- `filter` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317741` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317738` | Self: 0.0% (0us) | Total: 0.1% (10.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `g` (6)

### `checkNotAlignedPerTag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323475` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295761` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `map` (2)

**Calls:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171483` | Self: 0.0% (0us) | Total: 1.6% (92.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (20)

**Calls:**
- `bound require` (20)

### `fix10`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332030` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_execReport` (1)

**Calls:**
- `getDecorator` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:144230` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137847` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:198703` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `map` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5023` | Self: 0.0% (0us) | Total: 18.7% (1.05s) | Samples: 0

**Called by:**
- `walkNodes` (686)

**Calls:**
- `bound ` (612)
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (74)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/rules.js:3` | Self: 0.0% (0us) | Total: 0.0% (4.3ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:108785` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:90172` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289680` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/ast-converter.js:4` | Self: 0.0% (0us) | Total: 0.1% (8.6ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `encodeInto` (1)

### `camelCase`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295758` | Self: 0.0% (0us) | Total: 0.0% (5.1ms) | Samples: 0

**Called by:**
- `addPolyfillToken` (3)
- `(anonymous)` (1)

**Calls:**
- `map` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289767` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:202025` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171032` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/code-path-analysis/code-path-analyzer.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `parseModule`
`[native code]` | Self: 0.0% (0us) | Total: 9.7% (550.0ms) | Samples: 0

**Called by:**
- `async (anonymous)` (288)

**Calls:**
- `(anonymous)` (278)
- `(anonymous)` (8)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:99420` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109044` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295072` | Self: 0.0% (0us) | Total: 0.0% (1.1ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `__toESM` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:331031` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `(anonymous)` (2)

### `getParser4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318582` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `parse3` (2)

**Calls:**
- `getParser3` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/getModifiers.js:39` | Self: 0.0% (0us) | Total: 0.1% (6.0ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `bound require` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329137` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `flatIntoArrayWithCallback` (1)

**Calls:**
- `jsdocTagsByName` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:106845` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92623` | Self: 0.0% (0us) | Total: 0.0% (5.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `(anonymous)` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321800` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `parse2` (2)

### `createToken`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:52044` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `RegExp` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321439` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (1)
- `buildVisitorMap` (1)

**Calls:**
- `getSettings` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:22` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320918` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `canSkip5` (1)
- `canSkip3` (1)

**Calls:**
- `hasATag` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:169485` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332246` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `getTokensAfterIgnoringSemis`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318100` | Self: 0.0% (0us) | Total: 8.9% (503.6ms) | Samples: 0

**Called by:**
- `tokenAfterIgnoringSemis` (330)

**Calls:**
- `getTokensAfter` (269)
- `getTokensAfter` (45)
- `getTokensAfter` (16)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289672` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330268` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:256126` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `callIterator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321241` | Self: 0.0% (0us) | Total: 0.2% (14.9ms) | Samples: 0

**Called by:**
- `onNodeWithComment` (10)

**Calls:**
- `getBasicUtils` (7)
- `getBasicUtils` (1)
- `getBasicUtils` (1)
- `getBasicUtils` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1604` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (2)

**Calls:**
- `get loc` (1)
- `get loc` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/ClassVisitor.js:6` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289741` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333710` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `getTemplateTags`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329179` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `parseComment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:9` | Self: 0.0% (0us) | Total: 0.0% (4.3ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` | Self: 0.0% (0us) | Total: 5.5% (310.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (200)

**Calls:**
- `parseSource` (149)
- `parseSource` (50)
- `parseSource` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326380` | Self: 0.0% (0us) | Total: 8.4% (475.2ms) | Samples: 0

**Called by:**
- `bound ` (309)

**Calls:**
- `checkNonJsdoc` (309)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320471` | Self: 0.0% (0us) | Total: 0.2% (15.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (7)
- `(anonymous)` (2)
- `checkNotAlignedPerTag` (1)

**Calls:**
- `report` (10)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:276659` | Self: 0.0% (0us) | Total: 0.1% (7.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `(anonymous)` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171555` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_jsdoc_all.js:10` | Self: 0.0% (0us) | Total: 0.2% (12.5ms) | Samples: 0

**Called by:**
- `parseModule` (8)

**Calls:**
- `bound require` (8)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7265` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_getOrBuildPlan` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320936` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `canSkip2` (1)
- `canSkip4` (1)

**Calls:**
- `exemptSpeciaMethods` (1)
- `exemptSpeciaMethods` (1)

### `get lines`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3580` | Self: 0.0% (0us) | Total: 0.9% (51.6ms) | Samples: 0

**Called by:**
- `create` (34)

**Calls:**
- `regExpSplitFast` (34)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326165` | Self: 0.0% (0us) | Total: 0.0% (4.3ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:7` | Self: 0.0% (0us) | Total: 0.1% (8.4ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/token-store/index.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289833` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:169474` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12342` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:911` | Self: 0.0% (0us) | Total: 0.1% (10.9ms) | Samples: 0

**Called by:**
- `get` (7)

**Calls:**
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201928` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327386` | Self: 0.0% (0us) | Total: 0.2% (14.7ms) | Samples: 0

**Called by:**
- `iterate` (10)

**Calls:**
- `(anonymous)` (10)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:197348` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:90428` | Self: 0.0% (0us) | Total: 0.0% (910us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96800` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318608` | Self: 0.0% (0us) | Total: 0.1% (6.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)
- `map` (2)

**Calls:**
- `join` (2)
- `map` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:105266` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333797` | Self: 0.0% (0us) | Total: 0.0% (4.4ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `(anonymous)` (3)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:585` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `Uint8Array` (1)

### `toggleFence`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318237` | Self: 0.0% (0us) | Total: 0.3% (17.3ms) | Samples: 0

**Called by:**
- `parseBlock` (11)

**Calls:**
- `(anonymous)` (11)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301309` | Self: 0.0% (0us) | Total: 0.0% (2.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `addPolyfillToken` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164588` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `Range` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:202017` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332258` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `(anonymous)` (2)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 9.7% (550.0ms) | Samples: 0

**Calls:**
- `parseModule` (288)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/scope/BlockScope.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 27.4% (1.54s) | Samples: 0

**Called by:**
- `bound require` (793)

**Calls:**
- `anonymous` (793)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301287` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `camelCase` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201962` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320382` | Self: 0.0% (0us) | Total: 0.1% (11.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (8)

**Calls:**
- `isNameOrNamepathDefiningTag` (5)
- `isNameOrNamepathDefiningTag` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:134047` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8207` | Self: 0.0% (0us) | Total: 83.4% (4.69s) | Samples: 0

**Called by:**
- `_lintSourceOne` (3070)

**Calls:**
- `walkNodes` (2581)
- `walkNodes` (316)
- `walkNodes` (131)
- `walkNodes` (9)
- `walkNodes` (9)
- `walkNodes` (6)
- `walkNodes` (5)
- `walkNodes` (4)
- `walkNodes` (2)
- `walkNodes` (2)
- `walkNodes` (2)
- `walkNodes` (2)
- `walkNodes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:1664` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327115` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `descriptionIsRedundant` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:288747` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91299` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327372` | Self: 0.0% (0us) | Total: 0.4% (23.5ms) | Samples: 0

**Called by:**
- `iterate` (16)

**Calls:**
- `(anonymous)` (16)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333370` | Self: 0.0% (0us) | Total: 0.1% (6.0ms) | Samples: 0

**Called by:**
- `iterate` (4)

**Calls:**
- `shouldReport` (4)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2384` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `get identifiers` (1)

### `checkJsdoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321483` | Self: 0.0% (0us) | Total: 1.4% (82.5ms) | Samples: 0

**Called by:**
- `bound checkJsdoc` (55)

**Calls:**
- `getIndentAndJSDoc` (53)
- `getIndentAndJSDoc` (2)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6952` | Self: 0.0% (0us) | Total: 8.5% (480.0ms) | Samples: 0

**Called by:**
- `walkNodes` (312)

**Calls:**
- `invokeHandlersWithNode` (278)
- `invokeHandlersWithNode` (34)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:106431` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:241540` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:729` | Self: 0.0% (0us) | Total: 0.0% (4.6ms) | Samples: 0

**Called by:**
- `getAllComments` (2)
- `_precomputeScopes` (1)

**Calls:**
- `_findLineIdx` (1)
- `_findLineIdx` (1)
- `_findLineIdx` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:176166` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137993` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_traverse`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/json-schema-traverse/index.js:65` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_traverse` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161353` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321473` | Self: 0.0% (0us) | Total: 0.9% (51.6ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (23)
- `buildVisitorMap` (11)

**Calls:**
- `get lines` (34)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:169341` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:168241` | Self: 0.0% (0us) | Total: 1.3% (76.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (49)

**Calls:**
- `bound require` (49)

### `fix10`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332531` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `fixer` (1)

**Calls:**
- `createTokens` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313535` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6928` | Self: 0.0% (0us) | Total: 0.0% (5.0ms) | Samples: 0

**Called by:**
- `walkNodes` (3)

**Calls:**
- `get value` (2)
- `get value` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92621` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:174953` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `Pe`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.3% (17.9ms) | Samples: 0

**Called by:**
- `_e` (8)
- `Ce` (3)

**Calls:**
- `we` (11)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:253205` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289865` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_fromRunnerReport`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:205` | Self: 0.0% (0us) | Total: 0.0% (5.0ms) | Samples: 0

**Called by:**
- `map` (4)

**Calls:**
- `get loc` (2)
- `get loc` (1)
- `get loc` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:103878` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:193150` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `onProgramExit`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321333` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `Program:exit` (2)

**Calls:**
- `filter` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201956` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:244550` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `checkNonJsdoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326338` | Self: 0.0% (0us) | Total: 8.9% (505.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (309)
- `bound checkNonJsdoc` (19)

**Calls:**
- `getNonJsdocComment` (311)
- `getNonJsdocComment` (17)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:267` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getTagNames` (1)

### `g`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.1% (10.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `parse` (5)
- `parse` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:324381` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313215` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321174` | Self: 0.0% (0us) | Total: 0.5% (30.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (10)
- `(anonymous)` (4)
- `report` (3)
- `(anonymous)` (2)
- `(anonymous)` (1)

**Calls:**
- `report` (20)

### `tagsByName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:5093` | Self: 0.0% (0us) | Total: 0.0% (3.4ms) | Samples: 0

**Called by:**
- `jsdocTagsByName` (2)

**Calls:**
- `filter` (2)

### `addSchema`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:137` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `addMetaSchema` (1)

**Calls:**
- `_addSchema` (1)

### `internal:shared`
`internal:shared:2` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:261237` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/scope/index.js:17` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `internal:streams/duplex`
`internal:streams/duplex:2` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `loadBinding`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `getTagNames` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/dotjs/index.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.1ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `parse2`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317154` | Self: 0.0% (0us) | Total: 0.1% (6.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)
- `(anonymous)` (1)
- `cleanUpLastTag` (1)

**Calls:**
- `parse` (4)

### `splitSpace`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318205` | Self: 0.0% (0us) | Total: 0.1% (8.0ms) | Samples: 0

**Called by:**
- `parseSource` (5)

**Calls:**
- `match` (5)

### `compactJoiner`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318554` | Self: 0.0% (0us) | Total: 0.2% (11.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (8)

**Calls:**
- `map` (6)
- `filter` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289883` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4190` | Self: 0.0% (0us) | Total: 0.5% (32.7ms) | Samples: 0

**Called by:**
- `report` (20)
- `report` (1)

**Calls:**
- `_execReport` (15)
- `_execReport` (5)
- `_execReport` (1)

### `bundleRulesFor`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-loader.js:59` | Self: 0.0% (0us) | Total: 9.4% (534.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (278)

**Calls:**
- `_loadBundle` (278)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:282361` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320473` | Self: 0.0% (0us) | Total: 0.0% (5.0ms) | Samples: 0

**Called by:**
- `_execReport` (3)

**Calls:**
- `(anonymous)` (2)
- `(anonymous)` (1)

### `_traverse`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/json-schema-traverse/index.js:76` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `_traverse` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:303` | Self: 0.0% (0us) | Total: 0.9% (53.0ms) | Samples: 0

**Called by:**
- `parseSource` (35)

**Calls:**
- `DataView` (35)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201985` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:148891` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `setDeps`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326926` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `log` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:262266` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:244473` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321276` | Self: 0.0% (0us) | Total: 0.3% (18.0ms) | Samples: 0

**Called by:**
- `every` (11)

**Calls:**
- `(anonymous)` (6)
- `(anonymous)` (3)
- `(anonymous)` (2)

### `createToken`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:226514` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `makeSafeRegex` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320930` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `canSkip` (1)

**Calls:**
- `(anonymous)` (1)

### `split`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295726` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `splitPrefixSuffix` (1)

**Calls:**
- `/[^\p{L}\d]+/giu` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/parse-string.js:113` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `we`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.3% (17.9ms) | Samples: 0

**Called by:**
- `Pe` (11)

**Calls:**
- `ke` (11)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318264` | Self: 0.0% (0us) | Total: 0.1% (6.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `seedTokens` (4)

### `forEachPreferredTag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319692` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `jsdocTagsByName` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329781` | Self: 0.0% (0us) | Total: 0.0% (4.5ms) | Samples: 0

**Called by:**
- `map` (3)

**Calls:**
- `commentParserToESTree` (2)
- `parseComment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320468` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161604` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138541` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4164` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `report` (1)

**Calls:**
- `filter` (1)

### `get description`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:5040` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `parseInlineTags` (1)

**Calls:**
- `_jdReadStr` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:18` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:8684` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `setCustomPollingValues` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329183` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `flatIntoArrayWithCallback` (1)

**Calls:**
- `getTemplateTags` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/index.js:9` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:182631` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getESLintCoreRule` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/index.js:12` | Self: 0.0% (0us) | Total: 0.1% (7.5ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313261` | Self: 0.0% (0us) | Total: 0.5% (29.3ms) | Samples: 0

**Called by:**
- `anonymous` (19)

**Calls:**
- `(anonymous)` (19)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289828` | Self: 0.0% (0us) | Total: 0.1% (7.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `(anonymous)` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:262339` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:108989` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getParser4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318575` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `parse3` (2)

**Calls:**
- `nameTokenizer` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:293567` | Self: 0.0% (0us) | Total: 0.7% (39.6ms) | Samples: 0

**Called by:**
- `anonymous` (27)

**Calls:**
- `bound require` (27)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/warnAboutTSVersion.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `defineProperty` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:338268` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `_unwrap` (1)

### `maskExcludedContent`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322973` | Self: 0.0% (0us) | Total: 0.1% (6.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `replace` (4)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5035` | Self: 0.0% (0us) | Total: 10.3% (580.6ms) | Samples: 0

**Called by:**
- `walkNodes` (381)

**Calls:**
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (306)
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (45)
- `bound ` (30)

### `isNameOrNamepathDefiningTag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319812` | Self: 0.0% (0us) | Total: 0.1% (6.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `ensureMap` (4)
- `ensureMap` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96125` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173342` | Self: 0.0% (0us) | Total: 1.7% (98.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (24)

**Calls:**
- `(anonymous)` (24)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332964` | Self: 0.0% (0us) | Total: 0.0% (4.7ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164675` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 54.5% | 3.06s | `[native code]` |
| 23.7% | 1.33s | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 17.0% | 959.9ms | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 2.6% | 150.8ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 1.2% | 69.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js` |
| 0.3% | 19.1ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.2% | 12.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 1.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js` |
| 0.0% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js` |
| 0.0% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/comparator.js` |
| 0.0% | 1.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js` |
| 0.0% | 1.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/node.js` |
| 0.0% | 1.3ms | `internal:primordials` |
| 0.0% | 1.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/internal/lrucache.js` |
