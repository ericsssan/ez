# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 4.50s | 2826 | 1.0ms | 1294 |

**Top 10:** `getTokensAfter` 9.4%, `parse` 5.1%, `anonymous` 4.9%, `_makeToken` 4.1%, `get flags` 2.9%, `_makeToken` 2.7%, `entries` 2.5%, `getTokensAfter` 2.2%, `getTokenBefore` 2.1%, ``/^\n?([A-Z`\d_][\s\S]*[.?!`\p{RGI_Emoji}]\s*)?$/v`` 2.0%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 9.4% | 427.0ms | 9.6% | 432.7ms | `getTokensAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3566` |
| 5.1% | 230.8ms | 5.1% | 230.8ms | `parse` | `[native code]` |
| 4.9% | 222.0ms | 34.1% | 1.53s | `anonymous` | `[native code]` |
| 4.1% | 188.8ms | 4.1% | 188.8ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1300` |
| 2.9% | 132.1ms | 3.1% | 143.4ms | `get flags` | `[native code]` |
| 2.7% | 125.7ms | 2.7% | 125.7ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1288` |
| 2.5% | 115.5ms | 2.5% | 115.5ms | `entries` | `[native code]` |
| 2.2% | 102.2ms | 2.2% | 102.2ms | `getTokensAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3565` |
| 2.1% | 96.8ms | 14.0% | 634.4ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1673` |
| 2.0% | 92.1ms | 2.0% | 92.1ms | ``/^\n?([A-Z`\d_][\s\S]*[.?!`\p{RGI_Emoji}]\s*)?$/v`` | `[native code]` |
| 1.9% | 86.7ms | 2.2% | 102.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329660` |
| 1.8% | 84.9ms | 2.2% | 100.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328983` |
| 1.8% | 84.0ms | 2.6% | 118.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328988` |
| 1.7% | 80.6ms | 1.7% | 80.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 1.7% | 79.0ms | 2.6% | 117.9ms | `regExpSplitFast` | `[native code]` |
| 1.5% | 70.8ms | 1.5% | 70.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:8` |
| 1.4% | 67.5ms | 1.4% | 67.5ms | `getTokenizers` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318758` |
| 1.4% | 67.4ms | 12.6% | 571.4ms | `filter` | `[native code]` |
| 1.3% | 61.2ms | 2.4% | 111.1ms | `match` | `[native code]` |
| 1.1% | 49.7ms | 1.1% | 49.7ms | `getValidRuntimeIdentifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329080` |
| 1.0% | 49.1ms | 63.3% | 2.85s | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7720` |
| 1.0% | 49.0ms | 1.0% | 49.0ms | `/(?<!\])\{@(?<tag>[^\}\s]+)\s?(?<namepathOrURL>[^\}\s\\|]*)\s*(?<separator>[\s\\|])?\s*(?<text>[^\}]*)\}/dgv` | `[native code]` |
| 0.9% | 44.6ms | 0.9% | 44.6ms | `stringSplitFast` | `[native code]` |
| 0.9% | 41.8ms | 1.3% | 59.3ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1285` |
| 0.8% | 40.1ms | 1.1% | 51.4ms | `[Symbol.match]` | `[native code]` |
| 0.8% | 38.8ms | 0.8% | 38.8ms | `/\r\n\|\r\|\n\|\u2028\|\u2029/` | `[native code]` |
| 0.8% | 36.8ms | 1.5% | 68.8ms | `parseIntermediateType` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314940` |
| 0.7% | 35.7ms | 0.7% | 35.7ms | `[Symbol.matchAll]` | `[native code]` |
| 0.7% | 34.7ms | 0.7% | 34.7ms | `/^\s*globals/v` | `[native code]` |
| 0.7% | 32.3ms | 0.7% | 32.3ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318033` |
| 0.6% | 31.0ms | 21.1% | 951.1ms | `map` | `[native code]` |
| 0.6% | 30.9ms | 0.6% | 30.9ms | `/^\*(?!\*)/v` | `[native code]` |
| 0.6% | 28.7ms | 0.6% | 28.7ms | `Error` | `[native code]` |
| 0.5% | 26.9ms | 0.5% | 26.9ms | `getTokensAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3563` |
| 0.5% | 26.5ms | 1.2% | 54.9ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1975` |
| 0.5% | 25.3ms | 0.5% | 25.3ms | `parseSpec` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318170` |
| 0.5% | 24.8ms | 5.9% | 269.4ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318045` |
| 0.5% | 23.9ms | 0.5% | 23.9ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1260` |
| 0.5% | 22.9ms | 2.5% | 115.0ms | `test` | `[native code]` |
| 0.5% | 22.7ms | 0.5% | 22.7ms | `includes` | `[native code]` |
| 0.4% | 22.0ms | 0.4% | 22.0ms | `Set` | `[native code]` |
| 0.4% | 21.8ms | 0.4% | 21.8ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.4% | 20.5ms | 1.8% | 85.4ms | `performIteration` | `[native code]` |
| 0.4% | 19.7ms | 0.4% | 19.7ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1292` |
| 0.4% | 19.2ms | 2.4% | 110.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.4% | 18.8ms | 0.4% | 18.8ms | `join` | `[native code]` |
| 0.4% | 18.7ms | 0.9% | 40.9ms | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321104` |
| 0.4% | 18.0ms | 0.4% | 18.0ms | `esSpecIsRegExp` | `[native code]` |
| 0.3% | 18.0ms | 0.3% | 18.0ms | `seedTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318081` |
| 0.3% | 16.8ms | 0.3% | 16.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7386` |
| 0.3% | 15.7ms | 0.3% | 15.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:676` |
| 0.3% | 15.0ms | 13.6% | 616.1ms | `bound checkJsdoc` | `[native code]` |
| 0.3% | 15.0ms | 0.3% | 15.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.3% | 14.1ms | 0.3% | 14.1ms | `getText` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1346` |
| 0.3% | 14.0ms | 0.3% | 14.0ms | `copyDataProperties` | `[native code]` |
| 0.3% | 14.0ms | 0.3% | 14.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301190` |
| 0.2% | 13.4ms | 0.2% | 13.4ms | `splitSpace` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318069` |
| 0.2% | 13.4ms | 9.9% | 446.1ms | `_getAllTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1932` |
| 0.2% | 12.2ms | 0.2% | 12.2ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318030` |
| 0.2% | 12.0ms | 0.2% | 12.0ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1264` |
| 0.2% | 12.0ms | 2.4% | 108.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318454` |
| 0.2% | 11.9ms | 0.2% | 11.9ms | `RegExp` | `[native code]` |
| 0.2% | 11.8ms | 0.2% | 11.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4211` |
| 0.2% | 11.3ms | 0.2% | 11.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321193` |
| 0.2% | 11.3ms | 0.2% | 11.3ms | `concat` | `[native code]` |
| 0.2% | 11.0ms | 0.2% | 11.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7855` |
| 0.2% | 10.7ms | 0.3% | 15.0ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320284` |
| 0.2% | 10.6ms | 0.7% | 33.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319475` |
| 0.2% | 10.3ms | 0.2% | 11.7ms | `replace` | `[native code]` |
| 0.2% | 10.2ms | 0.6% | 30.4ms | `getDecorator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317746` |
| 0.2% | 9.3ms | 0.2% | 9.3ms | `_getAllTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1933` |
| 0.2% | 9.0ms | 0.2% | 13.3ms | `parseBlock` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318105` |
| 0.1% | 8.9ms | 0.1% | 8.9ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318149` |
| 0.1% | 8.9ms | 0.1% | 8.9ms | `ensureMap` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319627` |
| 0.1% | 8.8ms | 0.1% | 8.8ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4522` |
| 0.1% | 8.6ms | 0.1% | 8.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7382` |
| 0.1% | 8.5ms | 2.6% | 118.7ms | `parseDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318682` |
| 0.1% | 8.1ms | 0.1% | 8.1ms | `trimStart` | `[native code]` |
| 0.1% | 8.0ms | 1.4% | 64.8ms | `regExpExec` | `[native code]` |
| 0.1% | 7.8ms | 0.1% | 7.8ms | `/(?:\[(?<text>[^\]]+)\])\{@(?<tag>[^\}\s]+)\s?(?<namepathOrURL>[^\}\s\\|]*)\}/dgv` | `[native code]` |
| 0.1% | 7.5ms | 0.1% | 7.5ms | `getOwnPropertyDescriptor` | `[native code]` |
| 0.1% | 7.4ms | 0.1% | 7.4ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1202` |
| 0.1% | 7.4ms | 0.1% | 7.4ms | `endsWith` | `[native code]` |
| 0.1% | 7.3ms | 0.1% | 7.3ms | `trimEnd` | `[native code]` |
| 0.1% | 7.3ms | 0.1% | 7.3ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4094` |
| 0.1% | 7.2ms | 0.1% | 7.2ms | `parse2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316976` |
| 0.1% | 7.2ms | 0.1% | 7.2ms | `Map` | `[native code]` |
| 0.1% | 7.1ms | 0.1% | 7.1ms | `trim` | `[native code]` |
| 0.1% | 7.0ms | 0.1% | 7.0ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:593` |
| 0.1% | 6.4ms | 0.1% | 6.4ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1228` |
| 0.1% | 6.4ms | 0.1% | 6.4ms | `stringIncludesInternal` | `[native code]` |
| 0.1% | 6.3ms | 0.1% | 6.3ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318130` |
| 0.1% | 6.3ms | 0.1% | 6.3ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318148` |
| 0.1% | 6.3ms | 3.6% | 164.1ms | `checkJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321336` |
| 0.1% | 6.2ms | 8.8% | 399.6ms | `parse3` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318646` |
| 0.1% | 6.1ms | 0.2% | 12.4ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1656` |
| 0.1% | 6.0ms | 1.5% | 68.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329226` |
| 0.1% | 6.0ms | 0.1% | 6.0ms | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318441` |
| 0.1% | 6.0ms | 0.1% | 6.0ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318018` |
| 0.1% | 5.7ms | 0.1% | 5.7ms | `parseBlock` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.1% | 5.7ms | 31.8% | 1.43s | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5080` |
| 0.1% | 5.7ms | 0.1% | 5.7ms | `push` | `[native code]` |
| 0.1% | 5.6ms | 0.1% | 5.6ms | `defineProperty` | `[native code]` |
| 0.1% | 5.6ms | 0.1% | 5.6ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318133` |
| 0.1% | 5.6ms | 0.1% | 5.6ms | `maskCodeBlocks` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.1% | 5.5ms | 0.1% | 5.5ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.1% | 5.3ms | 0.1% | 5.3ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318043` |
| 0.1% | 5.0ms | 0.1% | 5.0ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1185` |
| 0.1% | 5.0ms | 3.1% | 140.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328167` |
| 0.1% | 5.0ms | 0.1% | 5.0ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 4.9ms | 0.5% | 25.0ms | `flatIntoArrayWithCallback` | `[native code]` |
| 0.1% | 4.7ms | 0.1% | 4.7ms | `unshift` | `[native code]` |
| 0.1% | 4.6ms | 0.1% | 4.6ms | `preserveJoiner` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318425` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `get hasIndices` | `[native code]` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `Se` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318797` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4210` |
| 0.0% | 4.4ms | 0.6% | 29.4ms | `compactJoiner` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318417` |
| 0.0% | 4.4ms | 8.9% | 402.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329662` |
| 0.0% | 4.4ms | 0.0% | 4.4ms | `/\r+$/` | `[native code]` |
| 0.0% | 4.4ms | 14.0% | 633.5ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317894` |
| 0.0% | 4.4ms | 0.0% | 4.4ms | `replaceAll` | `[native code]` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317513` |
| 0.0% | 4.3ms | 0.2% | 11.8ms | `parslet` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315039` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `/^@[^\s/]+(?=\s\|$)/` | `[native code]` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `ensureMap` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319630` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318015` |
| 0.0% | 4.3ms | 5.9% | 268.4ms | `parseComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318819` |
| 0.0% | 4.2ms | 0.0% | 4.2ms | `decode` | `[native code]` |
| 0.0% | 4.2ms | 34.9% | 1.57s | `iterate` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321062` |
| 0.0% | 4.1ms | 0.0% | 4.1ms | `parseBlock` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318104` |
| 0.0% | 3.9ms | 0.0% | 3.9ms | `/^\s+/` | `[native code]` |
| 0.0% | 3.9ms | 0.0% | 3.9ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318141` |
| 0.0% | 3.9ms | 0.0% | 3.9ms | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318439` |
| 0.0% | 3.6ms | 0.0% | 3.6ms | `onNodeAllNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321182` |
| 0.0% | 3.6ms | 0.0% | 3.6ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1192` |
| 0.0% | 3.6ms | 0.0% | 3.6ms | `getCommentsBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3401` |
| 0.0% | 3.5ms | 0.1% | 5.1ms | `read` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316324` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `tryParslets` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314953` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321102` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `flatIntoArray` | `[native code]` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `getBasicUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320233` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318008` |
| 0.0% | 3.4ms | 2.4% | 108.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317582` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `/^\/\*\*\s/v` | `[native code]` |
| 0.0% | 3.3ms | 4.0% | 182.3ms | `parseDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318683` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `getPreferredTagName` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319509` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318131` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:609` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `getText` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 3.3ms | 0.7% | 32.9ms | `parse` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `arrayIteratorNextHelper` | `[native code]` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `get sticky` | `[native code]` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:1` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318303` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2143` |
| 0.0% | 3.2ms | 1.2% | 57.4ms | `parseSpec` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318169` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `getParser2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318122` |
| 0.0% | 3.1ms | 0.2% | 12.4ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318140` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3634` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `accept` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315363` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `toLocaleLowerCase` | `[native code]` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `read` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316314` |
| 0.0% | 3.1ms | 10.8% | 487.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326239` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `cloneObject` | `[native code]` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `getAncestors` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `getParser3` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318164` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2168` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7680` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318191` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1677` |
| 0.0% | 2.9ms | 0.8% | 40.3ms | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321110` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3708` |
| 0.0% | 2.9ms | 2.1% | 95.7ms | `checkJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321343` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1962` |
| 0.0% | 2.9ms | 0.1% | 8.9ms | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317864` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `getTokensBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3518` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` |
| 0.0% | 2.9ms | 0.7% | 35.0ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5058` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318132` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318152` |
| 0.0% | 2.8ms | 0.0% | 4.3ms | `typeTokenizer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318204` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `accept` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315392` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:717` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318046` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `log` | `[native code]` |
| 0.0% | 2.7ms | 0.0% | 4.2ms | `getParser` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318099` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `search` | `[native code]` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2150` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `preserveJoiner` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318429` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317998` |
| 0.0% | 2.6ms | 0.0% | 4.1ms | `stripEncapsulatingBrackets` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317351` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319492` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:590` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `repeat` | `[native code]` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320461` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317853` |
| 0.0% | 2.5ms | 0.6% | 27.7ms | `some` | `[native code]` |
| 0.0% | 1.8ms | 0.6% | 29.6ms | `Ae` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `get multiline` | `[native code]` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:160397` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109700` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `getJsdocProcessorPlugin` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.8ms | 0.8% | 38.8ms | `_e` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `getTokenizers` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318759` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `hasSchemaOption` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320025` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328151` |
| 0.0% | 1.7ms | 0.0% | 3.0ms | `checkTagName2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334407` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:197793` |
| 0.0% | 1.7ms | 6.7% | 302.8ms | `parseComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318830` |
| 0.0% | 1.7ms | 0.1% | 6.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320796` |
| 0.0% | 1.7ms | 0.0% | 3.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319880` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `preserveJoiner` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318426` |
| 0.0% | 1.7ms | 33.4% | 1.50s | `require` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `parseBlock` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318108` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get declaration` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:335773` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:199296` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `ownKeys` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.7ms | 0.0% | 3.2ms | `exec` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `addInitialSchemas` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `fix10` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330348` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:670` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320846` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `parse2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317010` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getTokensAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3564` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:681` |
| 0.0% | 1.7ms | 0.2% | 13.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318405` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7090` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188300` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320917` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getCommentsBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3400` |
| 0.0% | 1.7ms | 0.1% | 6.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320333` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `uniqueSymbolParslet` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.7ms | 0.0% | 3.4ms | `readFileSync` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318126` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328156` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4163` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `cleanUpLastTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317382` |
| 0.0% | 1.7ms | 0.0% | 2.9ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1653` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318155` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:183987` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getTokenAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1760` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333346` |
| 0.0% | 1.7ms | 0.2% | 12.1ms | `splitCR` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318064` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `join` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318468` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1983` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170686` |
| 0.0% | 1.6ms | 0.1% | 8.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328147` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/dom.js:1798` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `exit` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.6ms | 5.8% | 265.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328985` |
| 0.0% | 1.6ms | 0.1% | 5.9ms | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318444` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `syntacticResult` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `@lazy` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_findLine` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:578` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329219` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getDefaultTagStructureForMode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314424` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7986` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7626` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328624` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `GetIntrinsic` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318770` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3704` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `generateNamedReferences` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321752` |
| 0.0% | 1.6ms | 1.4% | 65.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318453` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328453` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get message` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4110` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `toLocaleUpperCase` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get mainToken` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1166` |
| 0.0% | 1.6ms | 0.8% | 37.8ms | `find` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `createTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332389` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:186755` |
| 0.0% | 1.6ms | 0.6% | 30.2ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317889` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7092` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1230` |
| 0.0% | 1.6ms | 3.4% | 155.3ms | `getPreferredTagName` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319515` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320919` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:175338` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:232340` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `setParamIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332156` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `split` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295589` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318764` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `read` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316312` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `normalizeWord` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326871` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4139` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1739` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get kind` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2692` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7682` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `fill` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get key` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3206` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `looksLikeExport` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317749` |
| 0.0% | 1.5ms | 0.9% | 41.5ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317920` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/index.js:14` |
| 0.0% | 1.5ms | 3.6% | 164.2ms | `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321228` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get dotAll` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7368` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7689` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/useProvidedPrograms.js:5` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `indexOf` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320955` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1302` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:54196` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326168` |
| 0.0% | 1.5ms | 0.0% | 4.0ms | `getIndentAndJSDoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321083` |
| 0.0% | 1.5ms | 9.6% | 434.3ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5035` |
| 0.0% | 1.5ms | 0.1% | 7.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320943` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320638` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `hasObservableSideEffectsForRegExpMatch` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getJoiner` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318264` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 30.1% | 1.35s | `onNodeWithComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321178` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:224879` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getBasicUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320245` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `createTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `values` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:251511` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `save` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/node.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getFencer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318116` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `accept` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315152` |
| 0.0% | 1.4ms | 0.0% | 2.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323704` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `clearBuffer` | `internal:streams/writable` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3682` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:90804` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `encodeInto` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `Parser` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314897` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301184` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320389` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/lib/constants.js:105` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4174` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `RegExpParserState` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `commentParserToESTree` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317363` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `/\}$/v` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get declaration` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3611` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5141` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:724` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isNullSet` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:163634` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:916` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318002` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getBasicUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320228` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1229` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320756` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183916` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320925` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getBasicUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320241` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2827` |
| 0.0% | 1.4ms | 0.0% | 2.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317501` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `invokeHandlersWithNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:656` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318455` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createIsolatedProgram.js:8` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318435` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320801` |
| 0.0% | 1.3ms | 0.1% | 4.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328146` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `TokenType` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:118` |
| 0.0% | 1.3ms | 0.1% | 5.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318396` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `iterate` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321046` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `checkJsDoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:331856` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getTags` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319501` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getAncestors` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3687` |
| 0.0% | 1.3ms | 0.0% | 2.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320895` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4132` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317443` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321103` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4580` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `hasTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319490` |
| 0.0% | 1.3ms | 0.0% | 2.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7692` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332335` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318143` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:464` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318310` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171430` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332415` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `push` | `internal:fixed_queue` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `p` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `/\s*(@(\S+))(\s*)/` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `parse` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 1.3ms | 0.0% | 3.9ms | `reduce` | `[native code]` |
| 0.0% | 1.3ms | 0.4% | 18.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4216` |
| 0.0% | 1.3ms | 2.7% | 123.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318450` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getText` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1333` |
| 0.0% | 1.3ms | 14.8% | 669.7ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318017` |
| 0.0% | 1.2ms | 0.0% | 3.0ms | `validateDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327223` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `checkJsDoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2906` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `P` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1187` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_getSharedCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:745` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:195339` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7389` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334022` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1972` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172176` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `commentParserToESTree` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317400` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getBasicUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320264` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `ge` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2130` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_getAllTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2198` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_normalizeFilter` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1599` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `preserveJoiner` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318424` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `onNodeWithComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321177` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5010` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_rawTokenText` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `nameTokenizer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318276` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_traverse` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/json-schema-traverse/index.js:73` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `commentParserToESTree` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317393` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1977` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 87.6% | 3.95s | 0.0% | 0us | `processTicksAndRejections` | `[native code]` |
| 87.6% | 3.95s | 0.0% | 0us | `(anonymous)` | `[native code]` |
| 81.8% | 3.68s | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:274` |
| 79.7% | 3.59s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8203` |
| 63.3% | 2.85s | 1.0% | 49.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7720` |
| 34.9% | 1.57s | 0.0% | 4.2ms | `iterate` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321062` |
| 34.5% | 1.55s | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:33` |
| 34.1% | 1.53s | 4.9% | 222.0ms | `anonymous` | `[native code]` |
| 33.7% | 1.51s | 0.0% | 0us | `bound require` | `[native code]` |
| 33.4% | 1.50s | 0.0% | 1.7ms | `require` | `[native code]` |
| 31.8% | 1.43s | 0.1% | 5.7ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5080` |
| 30.1% | 1.35s | 0.0% | 0us | `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321231` |
| 30.1% | 1.35s | 0.0% | 1.4ms | `onNodeWithComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321178` |
| 28.2% | 1.27s | 0.0% | 0us | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321140` |
| 24.5% | 1.10s | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5023` |
| 23.2% | 1.04s | 0.0% | 0us | `bound ` | `[native code]` |
| 21.1% | 951.1ms | 0.6% | 31.0ms | `map` | `[native code]` |
| 14.8% | 669.7ms | 0.0% | 1.3ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318017` |
| 14.0% | 634.4ms | 2.1% | 96.8ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1673` |
| 14.0% | 633.5ms | 0.0% | 4.4ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317894` |
| 13.6% | 616.1ms | 0.3% | 15.0ms | `bound checkJsdoc` | `[native code]` |
| 12.6% | 571.4ms | 1.4% | 67.4ms | `filter` | `[native code]` |
| 12.5% | 565.4ms | 0.0% | 0us | `checkNonJsdocAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326214` |
| 12.5% | 565.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326241` |
| 12.5% | 565.4ms | 0.0% | 0us | `getFollowingComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317973` |
| 12.5% | 565.4ms | 0.0% | 0us | `tokenAfterIgnoringSemis` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317970` |
| 12.5% | 563.7ms | 0.0% | 0us | `getTokensAfterIgnoringSemis` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317963` |
| 12.3% | 554.8ms | 0.0% | 0us | `parseModule` | `[native code]` |
| 12.3% | 554.8ms | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 11.9% | 537.5ms | 0.0% | 0us | `bundleRulesFor` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-loader.js:59` |
| 11.9% | 537.5ms | 0.0% | 0us | `(anonymous)` | `/private/tmp/prof_jsdoc.js:7` |
| 11.9% | 537.5ms | 0.0% | 0us | `_loadBundle` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-loader.js:34` |
| 11.2% | 504.8ms | 0.0% | 0us | `checkNonJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326197` |
| 10.8% | 490.1ms | 0.0% | 0us | `getNonJsdocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317952` |
| 10.8% | 487.2ms | 0.0% | 3.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326239` |
| 10.1% | 456.7ms | 0.0% | 0us | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1947` |
| 10.1% | 456.5ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7822` |
| 10.1% | 455.3ms | 0.0% | 0us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6952` |
| 10.0% | 453.9ms | 0.0% | 0us | `invokeHandlersWithNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6890` |
| 9.9% | 446.1ms | 0.2% | 13.4ms | `_getAllTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1932` |
| 9.6% | 434.3ms | 0.0% | 1.5ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5035` |
| 9.6% | 432.7ms | 9.4% | 427.0ms | `getTokensAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3566` |
| 8.9% | 403.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329661` |
| 8.9% | 402.5ms | 0.0% | 4.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329662` |
| 8.8% | 399.6ms | 0.1% | 6.2ms | `parse3` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318646` |
| 7.5% | 341.2ms | 0.0% | 0us | `checkJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321347` |
| 6.7% | 302.8ms | 0.0% | 1.7ms | `parseComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318830` |
| 5.9% | 269.4ms | 0.5% | 24.8ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318045` |
| 5.9% | 268.4ms | 0.0% | 4.3ms | `parseComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318819` |
| 5.8% | 265.4ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328985` |
| 5.8% | 265.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328984` |
| 5.6% | 253.9ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` |
| 5.1% | 230.8ms | 5.1% | 230.8ms | `parse` | `[native code]` |
| 5.0% | 227.9ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` |
| 4.9% | 221.9ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7919` |
| 4.5% | 203.0ms | 0.0% | 0us | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317921` |
| 4.1% | 188.8ms | 4.1% | 188.8ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1300` |
| 4.0% | 182.3ms | 0.0% | 3.3ms | `parseDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318683` |
| 3.7% | 167.9ms | 0.0% | 0us | `matchAll` | `[native code]` |
| 3.6% | 164.2ms | 0.0% | 1.5ms | `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321228` |
| 3.6% | 164.1ms | 0.1% | 6.3ms | `checkJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321336` |
| 3.5% | 161.4ms | 0.0% | 0us | `parseInlineTags` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318702` |
| 3.5% | 157.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328145` |
| 3.5% | 157.9ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321264` |
| 3.4% | 155.3ms | 0.0% | 1.6ms | `getPreferredTagName` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319515` |
| 3.3% | 150.5ms | 0.0% | 0us | `getPreferredTagNameSimple` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319471` |
| 3.2% | 145.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328987` |
| 3.1% | 143.4ms | 2.9% | 132.1ms | `get flags` | `[native code]` |
| 3.1% | 143.2ms | 0.0% | 0us | `forEach` | `[native code]` |
| 3.1% | 141.8ms | 0.0% | 0us | `commentParserToESTree` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317416` |
| 3.1% | 140.5ms | 0.1% | 5.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328167` |
| 3.0% | 139.6ms | 0.0% | 0us | `parseInlineTags` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318705` |
| 2.7% | 126.0ms | 0.0% | 0us | `getIndentAndJSDoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321084` |
| 2.7% | 125.7ms | 2.7% | 125.7ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1288` |
| 2.7% | 123.7ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318450` |
| 2.6% | 121.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328982` |
| 2.6% | 119.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313106` |
| 2.6% | 118.7ms | 1.8% | 84.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328988` |
| 2.6% | 118.7ms | 0.1% | 8.5ms | `parseDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318682` |
| 2.6% | 117.9ms | 1.7% | 79.0ms | `regExpSplitFast` | `[native code]` |
| 2.5% | 115.5ms | 2.5% | 115.5ms | `entries` | `[native code]` |
| 2.5% | 115.0ms | 0.5% | 22.9ms | `test` | `[native code]` |
| 2.5% | 114.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329659` |
| 2.4% | 111.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327234` |
| 2.4% | 111.4ms | 0.0% | 0us | `cleanUpLastTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317375` |
| 2.4% | 111.1ms | 1.3% | 61.2ms | `match` | `[native code]` |
| 2.4% | 110.8ms | 0.4% | 19.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 2.4% | 108.9ms | 0.2% | 12.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318454` |
| 2.4% | 108.5ms | 0.0% | 0us | `validateDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327224` |
| 2.4% | 108.4ms | 0.0% | 3.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317582` |
| 2.2% | 102.5ms | 1.9% | 86.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329660` |
| 2.2% | 102.2ms | 2.2% | 102.2ms | `getTokensAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3565` |
| 2.2% | 101.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173278` |
| 2.2% | 101.2ms | 0.0% | 0us | `forEachPreferredTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319537` |
| 2.2% | 101.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320947` |
| 2.2% | 100.1ms | 1.8% | 84.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328983` |
| 2.1% | 98.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172432` |
| 2.1% | 98.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172574` |
| 2.1% | 98.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173250` |
| 2.1% | 95.7ms | 0.0% | 2.9ms | `checkJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321343` |
| 2.0% | 94.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172350` |
| 2.0% | 94.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171770` |
| 2.0% | 92.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171549` |
| 2.0% | 92.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171395` |
| 2.0% | 92.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/index.js:18` |
| 2.0% | 92.1ms | 2.0% | 92.1ms | ``/^\n?([A-Z`\d_][\s\S]*[.?!`\p{RGI_Emoji}]\s*)?$/v`` | `[native code]` |
| 1.9% | 89.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/clear-caches.js:6` |
| 1.9% | 88.0ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8202` |
| 1.9% | 85.9ms | 0.0% | 0us | `parse2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317017` |
| 1.9% | 85.9ms | 0.0% | 0us | `parseType` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314935` |
| 1.9% | 85.9ms | 0.0% | 0us | `parse` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314928` |
| 1.8% | 85.4ms | 0.4% | 20.5ms | `performIteration` | `[native code]` |
| 1.8% | 82.5ms | 0.0% | 0us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321333` |
| 1.8% | 82.5ms | 0.0% | 0us | `get lines` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3580` |
| 1.7% | 80.6ms | 1.7% | 80.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 1.6% | 76.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:168171` |
| 1.6% | 76.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:168347` |
| 1.6% | 76.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313098` |
| 1.5% | 70.8ms | 1.5% | 70.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:8` |
| 1.5% | 70.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:30` |
| 1.5% | 70.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:16` |
| 1.5% | 70.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:42` |
| 1.5% | 69.3ms | 0.0% | 0us | `parseComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318820` |
| 1.5% | 68.8ms | 0.8% | 36.8ms | `parseIntermediateType` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314940` |
| 1.5% | 68.6ms | 0.1% | 6.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329226` |
| 1.5% | 68.1ms | 0.0% | 0us | `next` | `[native code]` |
| 1.4% | 67.5ms | 1.4% | 67.5ms | `getTokenizers` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318758` |
| 1.4% | 66.8ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4559` |
| 1.4% | 65.3ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318453` |
| 1.4% | 64.8ms | 0.1% | 8.0ms | `regExpExec` | `[native code]` |
| 1.4% | 63.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313084` |
| 1.4% | 63.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164605` |
| 1.3% | 62.6ms | 0.0% | 0us | `Range` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:163502` |
| 1.3% | 62.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164518` |
| 1.3% | 62.3ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321242` |
| 1.3% | 61.2ms | 0.0% | 0us | `Comparator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:163873` |
| 1.3% | 61.2ms | 0.0% | 0us | `parse` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:163894` |
| 1.3% | 61.2ms | 0.0% | 0us | `parseRange` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:163572` |
| 1.3% | 61.2ms | 0.0% | 0us | `SemVer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:162894` |
| 1.3% | 61.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:163572` |
| 1.3% | 59.9ms | 0.0% | 0us | `Pe` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 1.3% | 59.3ms | 0.9% | 41.8ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1285` |
| 1.3% | 58.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320766` |
| 1.2% | 57.4ms | 0.0% | 3.2ms | `parseSpec` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318169` |
| 1.2% | 57.1ms | 0.0% | 0us | `ke` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 1.2% | 57.1ms | 0.0% | 0us | `we` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 1.2% | 54.9ms | 0.5% | 26.5ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1975` |
| 1.1% | 51.4ms | 0.8% | 40.1ms | `[Symbol.match]` | `[native code]` |
| 1.1% | 49.7ms | 1.1% | 49.7ms | `getValidRuntimeIdentifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329080` |
| 1.0% | 49.0ms | 1.0% | 49.0ms | `/(?<!\])\{@(?<tag>[^\}\s]+)\s?(?<namepathOrURL>[^\}\s\\|]*)\s*(?<separator>[\s\\|])?\s*(?<text>[^\}]*)\}/dgv` | `[native code]` |
| 1.0% | 46.2ms | 0.0% | 0us | `onProgramExit` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321194` |
| 0.9% | 44.6ms | 0.9% | 44.6ms | `stringSplitFast` | `[native code]` |
| 0.9% | 43.5ms | 0.0% | 0us | `every` | `[native code]` |
| 0.9% | 43.5ms | 0.0% | 0us | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321131` |
| 0.9% | 43.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321136` |
| 0.9% | 42.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:337705` |
| 0.9% | 42.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290029` |
| 0.9% | 41.5ms | 0.0% | 1.5ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317920` |
| 0.9% | 40.9ms | 0.4% | 18.7ms | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321104` |
| 0.8% | 40.3ms | 0.0% | 2.9ms | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321110` |
| 0.8% | 39.1ms | 0.0% | 0us | `iterate` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321047` |
| 0.8% | 38.8ms | 0.0% | 1.8ms | `_e` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.8% | 38.8ms | 0.8% | 38.8ms | `/\r\n\|\r\|\n\|\u2028\|\u2029/` | `[native code]` |
| 0.8% | 38.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318117` |
| 0.8% | 38.6ms | 0.0% | 0us | `parseBlock` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318110` |
| 0.8% | 38.6ms | 0.0% | 0us | `toggleFence` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318100` |
| 0.8% | 37.8ms | 0.0% | 1.6ms | `find` | `[native code]` |
| 0.7% | 35.7ms | 0.7% | 35.7ms | `[Symbol.matchAll]` | `[native code]` |
| 0.7% | 35.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:293431` |
| 0.7% | 35.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/unsupported-api.js:14` |
| 0.7% | 35.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318449` |
| 0.7% | 35.4ms | 0.0% | 0us | `splitLines` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318072` |
| 0.7% | 35.0ms | 0.0% | 2.9ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5058` |
| 0.7% | 34.7ms | 0.7% | 34.7ms | `/^\s*globals/v` | `[native code]` |
| 0.7% | 34.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317601` |
| 0.7% | 34.2ms | 0.0% | 0us | `g` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.7% | 33.4ms | 0.2% | 10.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319475` |
| 0.7% | 32.9ms | 0.0% | 3.3ms | `parse` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.7% | 32.3ms | 0.7% | 32.3ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318033` |
| 0.7% | 32.0ms | 0.0% | 0us | `_NoParsletFoundError` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314669` |
| 0.6% | 30.9ms | 0.6% | 30.9ms | `/^\*(?!\*)/v` | `[native code]` |
| 0.6% | 30.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327259` |
| 0.6% | 30.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313125` |
| 0.6% | 30.4ms | 0.2% | 10.2ms | `getDecorator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317746` |
| 0.6% | 30.2ms | 0.0% | 1.6ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317889` |
| 0.6% | 29.6ms | 0.0% | 1.8ms | `Ae` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.6% | 29.4ms | 0.0% | 4.4ms | `compactJoiner` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318417` |
| 0.6% | 29.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318456` |
| 0.6% | 28.7ms | 0.6% | 28.7ms | `Error` | `[native code]` |
| 0.6% | 27.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329133` |
| 0.6% | 27.7ms | 0.0% | 2.5ms | `some` | `[native code]` |
| 0.5% | 26.9ms | 0.5% | 26.9ms | `getTokensAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3563` |
| 0.5% | 25.3ms | 0.0% | 0us | `bound checkNonJsdoc` | `[native code]` |
| 0.5% | 25.3ms | 0.5% | 25.3ms | `parseSpec` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318170` |
| 0.5% | 25.1ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4190` |
| 0.5% | 25.0ms | 0.1% | 4.9ms | `flatIntoArrayWithCallback` | `[native code]` |
| 0.5% | 24.6ms | 0.0% | 0us | `Ce` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.5% | 24.5ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` |
| 0.5% | 24.0ms | 0.0% | 0us | `splitSpace` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318068` |
| 0.5% | 23.9ms | 0.5% | 23.9ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1260` |
| 0.5% | 23.6ms | 0.0% | 0us | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317856` |
| 0.5% | 22.7ms | 0.5% | 22.7ms | `includes` | `[native code]` |
| 0.4% | 22.0ms | 0.4% | 22.0ms | `Set` | `[native code]` |
| 0.4% | 21.8ms | 0.4% | 21.8ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.4% | 21.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:44` |
| 0.4% | 20.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322865` |
| 0.4% | 20.3ms | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4161` |
| 0.4% | 19.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:198766` |
| 0.4% | 19.8ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4682` |
| 0.4% | 19.7ms | 0.4% | 19.7ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1292` |
| 0.4% | 18.8ms | 0.4% | 18.8ms | `join` | `[native code]` |
| 0.4% | 18.7ms | 0.0% | 0us | `getAllComments` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3465` |
| 0.4% | 18.7ms | 0.0% | 0us | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1948` |
| 0.4% | 18.1ms | 0.0% | 1.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4216` |
| 0.4% | 18.0ms | 0.4% | 18.0ms | `esSpecIsRegExp` | `[native code]` |
| 0.3% | 18.0ms | 0.3% | 18.0ms | `seedTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318081` |
| 0.3% | 18.0ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318127` |
| 0.3% | 17.7ms | 0.0% | 0us | `parse2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317002` |
| 0.3% | 17.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173277` |
| 0.3% | 17.3ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321034` |
| 0.3% | 17.0ms | 0.0% | 0us | `parseIntermediateType` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314938` |
| 0.3% | 16.8ms | 0.3% | 16.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7386` |
| 0.3% | 16.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/index.js:3` |
| 0.3% | 16.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:20` |
| 0.3% | 16.1ms | 0.0% | 0us | `onProgramExit` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321193` |
| 0.3% | 15.7ms | 0.3% | 15.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:676` |
| 0.3% | 15.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320331` |
| 0.3% | 15.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327245` |
| 0.3% | 15.1ms | 0.0% | 0us | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320280` |
| 0.3% | 15.0ms | 0.3% | 15.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.3% | 15.0ms | 0.2% | 10.7ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320284` |
| 0.3% | 14.7ms | 0.0% | 0us | `getNonJsdocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317951` |
| 0.3% | 14.5ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318129` |
| 0.3% | 14.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:43` |
| 0.3% | 14.1ms | 0.3% | 14.1ms | `getText` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1346` |
| 0.3% | 14.0ms | 0.3% | 14.0ms | `copyDataProperties` | `[native code]` |
| 0.3% | 14.0ms | 0.3% | 14.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301190` |
| 0.3% | 13.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:19` |
| 0.3% | 13.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/apply-disable-directives.js:22` |
| 0.3% | 13.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333757` |
| 0.3% | 13.5ms | 0.0% | 0us | `tryParslets` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314957` |
| 0.2% | 13.4ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318405` |
| 0.2% | 13.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318803` |
| 0.2% | 13.4ms | 0.2% | 13.4ms | `splitSpace` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318069` |
| 0.2% | 13.3ms | 0.2% | 9.0ms | `parseBlock` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318105` |
| 0.2% | 13.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333234` |
| 0.2% | 12.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/Scope.js:38` |
| 0.2% | 12.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/index.js:26` |
| 0.2% | 12.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/index.js:18` |
| 0.2% | 12.4ms | 0.0% | 3.1ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318140` |
| 0.2% | 12.4ms | 0.1% | 6.1ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1656` |
| 0.2% | 12.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317469` |
| 0.2% | 12.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317439` |
| 0.2% | 12.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318181` |
| 0.2% | 12.2ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318134` |
| 0.2% | 12.2ms | 0.2% | 12.2ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318030` |
| 0.2% | 12.1ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318128` |
| 0.2% | 12.1ms | 0.0% | 1.7ms | `splitCR` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318064` |
| 0.2% | 12.1ms | 0.0% | 0us | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317831` |
| 0.2% | 12.1ms | 0.0% | 0us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1261` |
| 0.2% | 12.0ms | 0.2% | 12.0ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1264` |
| 0.2% | 12.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332432` |
| 0.2% | 11.9ms | 0.0% | 0us | `(anonymous)` | `/private/tmp/prof_jsdoc.js:5` |
| 0.2% | 11.9ms | 0.0% | 0us | `maskExcludedContent` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322832` |
| 0.2% | 11.9ms | 0.2% | 11.9ms | `RegExp` | `[native code]` |
| 0.2% | 11.9ms | 0.0% | 0us | `isNameOrNamepathDefiningTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319672` |
| 0.2% | 11.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320242` |
| 0.2% | 11.8ms | 0.2% | 11.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4211` |
| 0.2% | 11.8ms | 0.0% | 4.3ms | `parslet` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315039` |
| 0.2% | 11.7ms | 0.2% | 10.3ms | `replace` | `[native code]` |
| 0.2% | 11.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318800` |
| 0.2% | 11.3ms | 0.2% | 11.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321193` |
| 0.2% | 11.3ms | 0.2% | 11.3ms | `concat` | `[native code]` |
| 0.2% | 11.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/analyze.js:5` |
| 0.2% | 11.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/index.js:4` |
| 0.2% | 11.0ms | 0.2% | 11.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7855` |
| 0.2% | 11.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334099` |
| 0.2% | 10.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333683` |
| 0.2% | 10.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:19` |
| 0.2% | 10.7ms | 0.0% | 0us | `getAncestors` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3698` |
| 0.2% | 10.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328992` |
| 0.2% | 10.3ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:490` |
| 0.2% | 10.2ms | 0.0% | 0us | `hasRejectValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333155` |
| 0.2% | 10.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322864` |
| 0.2% | 9.8ms | 0.0% | 0us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316298` |
| 0.2% | 9.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/convert.js:41` |
| 0.2% | 9.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/ast-converter.js:4` |
| 0.2% | 9.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:12` |
| 0.2% | 9.3ms | 0.2% | 9.3ms | `_getAllTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1933` |
| 0.2% | 9.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301142` |
| 0.2% | 9.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301100` |
| 0.2% | 9.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92697` |
| 0.1% | 9.0ms | 0.0% | 0us | `maskExcludedContent` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322833` |
| 0.1% | 8.9ms | 0.1% | 8.9ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318149` |
| 0.1% | 8.9ms | 0.0% | 2.9ms | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317864` |
| 0.1% | 8.9ms | 0.1% | 8.9ms | `ensureMap` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319627` |
| 0.1% | 8.8ms | 0.1% | 8.8ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4522` |
| 0.1% | 8.8ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1027` |
| 0.1% | 8.8ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:911` |
| 0.1% | 8.6ms | 0.1% | 8.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7382` |
| 0.1% | 8.4ms | 0.0% | 0us | `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321236` |
| 0.1% | 8.1ms | 0.1% | 8.1ms | `trimStart` | `[native code]` |
| 0.1% | 8.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:38` |
| 0.1% | 8.0ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328147` |
| 0.1% | 8.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:277070` |
| 0.1% | 8.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:277094` |
| 0.1% | 8.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289692` |
| 0.1% | 7.9ms | 0.0% | 0us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316300` |
| 0.1% | 7.8ms | 0.1% | 7.8ms | `/(?:\[(?<text>[^\]]+)\])\{@(?<tag>[^\}\s]+)\s?(?<namepathOrURL>[^\}\s\\|]*)\}/dgv` | `[native code]` |
| 0.1% | 7.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:7` |
| 0.1% | 7.7ms | 0.0% | 0us | `commentParserToESTree` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317399` |
| 0.1% | 7.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` |
| 0.1% | 7.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/default-config.js:37` |
| 0.1% | 7.5ms | 0.1% | 7.5ms | `getOwnPropertyDescriptor` | `[native code]` |
| 0.1% | 7.4ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320943` |
| 0.1% | 7.4ms | 0.1% | 7.4ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1202` |
| 0.1% | 7.4ms | 0.0% | 0us | `fixer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332423` |
| 0.1% | 7.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320332` |
| 0.1% | 7.4ms | 0.1% | 7.4ms | `endsWith` | `[native code]` |
| 0.1% | 7.3ms | 0.1% | 7.3ms | `trimEnd` | `[native code]` |
| 0.1% | 7.3ms | 0.1% | 7.3ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4094` |
| 0.1% | 7.2ms | 0.1% | 7.2ms | `parse2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316976` |
| 0.1% | 7.2ms | 0.1% | 7.2ms | `Map` | `[native code]` |
| 0.1% | 7.1ms | 0.1% | 7.1ms | `trim` | `[native code]` |
| 0.1% | 7.0ms | 0.1% | 7.0ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:593` |
| 0.1% | 7.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328993` |
| 0.1% | 7.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328996` |
| 0.1% | 6.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:312910` |
| 0.1% | 6.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333156` |
| 0.1% | 6.6ms | 0.0% | 0us | `shouldReport` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333254` |
| 0.1% | 6.6ms | 0.0% | 0us | `hasRejectValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333152` |
| 0.1% | 6.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333256` |
| 0.1% | 6.6ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320796` |
| 0.1% | 6.5ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320333` |
| 0.1% | 6.5ms | 0.0% | 0us | `getCommentsBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3421` |
| 0.1% | 6.4ms | 0.1% | 6.4ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1228` |
| 0.1% | 6.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318471` |
| 0.1% | 6.4ms | 0.1% | 6.4ms | `stringIncludesInternal` | `[native code]` |
| 0.1% | 6.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332851` |
| 0.1% | 6.3ms | 0.1% | 6.3ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318148` |
| 0.1% | 6.3ms | 0.1% | 6.3ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318130` |
| 0.1% | 6.2ms | 0.0% | 0us | `flatMap` | `[native code]` |
| 0.1% | 6.2ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318144` |
| 0.1% | 6.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-modifiers.js:38` |
| 0.1% | 6.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317602` |
| 0.1% | 6.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:276523` |
| 0.1% | 6.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:11` |
| 0.1% | 6.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:15` |
| 0.1% | 6.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333590` |
| 0.1% | 6.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:20` |
| 0.1% | 6.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328954` |
| 0.1% | 6.1ms | 0.0% | 0us | `get globalScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3938` |
| 0.1% | 6.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/index.js:3` |
| 0.1% | 6.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/index.js:12` |
| 0.1% | 6.0ms | 0.1% | 6.0ms | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318441` |
| 0.1% | 6.0ms | 0.1% | 6.0ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318018` |
| 0.1% | 5.9ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:279` |
| 0.1% | 5.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318417` |
| 0.1% | 5.9ms | 0.0% | 1.6ms | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318444` |
| 0.1% | 5.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320790` |
| 0.1% | 5.8ms | 0.0% | 0us | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317861` |
| 0.1% | 5.8ms | 0.0% | 0us | `FunctionDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332021` |
| 0.1% | 5.7ms | 0.1% | 5.7ms | `parseBlock` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.1% | 5.7ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318396` |
| 0.1% | 5.7ms | 0.1% | 5.7ms | `push` | `[native code]` |
| 0.1% | 5.6ms | 0.1% | 5.6ms | `defineProperty` | `[native code]` |
| 0.1% | 5.6ms | 0.1% | 5.6ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318133` |
| 0.1% | 5.6ms | 0.1% | 5.6ms | `maskCodeBlocks` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.1% | 5.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92521` |
| 0.1% | 5.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92623` |
| 0.1% | 5.5ms | 0.1% | 5.5ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.1% | 5.4ms | 0.0% | 0us | `hasRejectValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333184` |
| 0.1% | 5.4ms | 0.0% | 0us | `getDefaultTagStructureForMode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313577` |
| 0.1% | 5.3ms | 0.1% | 5.3ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318043` |
| 0.1% | 5.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:110317` |
| 0.1% | 5.1ms | 0.0% | 3.5ms | `read` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316324` |
| 0.1% | 5.0ms | 0.1% | 5.0ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1185` |
| 0.1% | 5.0ms | 0.1% | 5.0ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 4.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329668` |
| 0.1% | 4.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329664` |
| 0.1% | 4.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329665` |
| 0.1% | 4.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138699` |
| 0.1% | 4.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313032` |
| 0.1% | 4.8ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7679` |
| 0.1% | 4.8ms | 0.0% | 0us | `onNodeAllNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321189` |
| 0.1% | 4.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320328` |
| 0.1% | 4.7ms | 0.0% | 0us | `camelCase` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295622` |
| 0.1% | 4.7ms | 0.1% | 4.7ms | `unshift` | `[native code]` |
| 0.1% | 4.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:497` |
| 0.1% | 4.7ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:455` |
| 0.1% | 4.7ms | 0.0% | 0us | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321101` |
| 0.1% | 4.7ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328146` |
| 0.1% | 4.7ms | 0.0% | 0us | `getTagStructureForMode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319665` |
| 0.1% | 4.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336921` |
| 0.1% | 4.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336920` |
| 0.1% | 4.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320860` |
| 0.1% | 4.6ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326148` |
| 0.1% | 4.6ms | 0.0% | 0us | `checkNonJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326211` |
| 0.1% | 4.6ms | 0.0% | 0us | `reportings` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326186` |
| 0.1% | 4.6ms | 0.0% | 0us | `read` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316320` |
| 0.1% | 4.6ms | 0.1% | 4.6ms | `preserveJoiner` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318425` |
| 0.1% | 4.5ms | 0.0% | 0us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4251` |
| 0.1% | 4.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/getModifiers.js:39` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `get hasIndices` | `[native code]` |
| 0.1% | 4.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332123` |
| 0.1% | 4.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320742` |
| 0.1% | 4.5ms | 0.0% | 0us | `getFunctionParameterNames` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319364` |
| 0.1% | 4.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319365` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `Se` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318797` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4210` |
| 0.0% | 4.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290133` |
| 0.0% | 4.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12521` |
| 0.0% | 4.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:45765` |
| 0.0% | 4.4ms | 0.0% | 4.4ms | `/\r+$/` | `[native code]` |
| 0.0% | 4.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333359` |
| 0.0% | 4.4ms | 0.0% | 4.4ms | `replaceAll` | `[native code]` |
| 0.0% | 4.4ms | 0.0% | 0us | `maskCodeBlocks` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322840` |
| 0.0% | 4.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320757` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317513` |
| 0.0% | 4.3ms | 0.0% | 0us | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318437` |
| 0.0% | 4.3ms | 0.0% | 2.8ms | `typeTokenizer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318204` |
| 0.0% | 4.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320929` |
| 0.0% | 4.3ms | 0.0% | 0us | `_fromRunnerReport` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:205` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `/^@[^\s/]+(?=\s\|$)/` | `[native code]` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `ensureMap` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319630` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318015` |
| 0.0% | 4.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332924` |
| 0.0% | 4.2ms | 0.0% | 0us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:609` |
| 0.0% | 4.2ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8195` |
| 0.0% | 4.2ms | 0.0% | 4.2ms | `decode` | `[native code]` |
| 0.0% | 4.2ms | 0.0% | 2.7ms | `getParser` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318099` |
| 0.0% | 4.1ms | 0.0% | 4.1ms | `parseBlock` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318104` |
| 0.0% | 4.1ms | 0.0% | 0us | `setTagStructure` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319142` |
| 0.0% | 4.1ms | 0.0% | 0us | `getSettings` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320989` |
| 0.0% | 4.1ms | 0.0% | 0us | `cleanUpLastTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317366` |
| 0.0% | 4.1ms | 0.0% | 2.6ms | `stripEncapsulatingBrackets` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317351` |
| 0.0% | 4.0ms | 0.0% | 0us | `hasATag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319601` |
| 0.0% | 4.0ms | 0.0% | 1.5ms | `getIndentAndJSDoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321083` |
| 0.0% | 3.9ms | 0.0% | 3.9ms | `/^\s+/` | `[native code]` |
| 0.0% | 3.9ms | 0.0% | 1.3ms | `reduce` | `[native code]` |
| 0.0% | 3.9ms | 0.0% | 3.9ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318141` |
| 0.0% | 3.9ms | 0.0% | 3.9ms | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318439` |
| 0.0% | 3.6ms | 0.0% | 3.6ms | `onNodeAllNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321182` |
| 0.0% | 3.6ms | 0.0% | 3.6ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1192` |
| 0.0% | 3.6ms | 0.0% | 0us | `(anonymous)` | `/private/tmp/prof_jsdoc.js:2` |
| 0.0% | 3.6ms | 0.0% | 3.6ms | `getCommentsBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3401` |
| 0.0% | 3.5ms | 0.0% | 0us | `hasThrowValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319879` |
| 0.0% | 3.5ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319880` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `tryParslets` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314953` |
| 0.0% | 3.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330564` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321102` |
| 0.0% | 3.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313079` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `flatIntoArray` | `[native code]` |
| 0.0% | 3.4ms | 0.0% | 1.7ms | `readFileSync` | `[native code]` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `getBasicUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320233` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318008` |
| 0.0% | 3.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329671` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `/^\/\*\*\s/v` | `[native code]` |
| 0.0% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332098` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `getPreferredTagName` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319509` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318131` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:609` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `getText` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `arrayIteratorNextHelper` | `[native code]` |
| 0.0% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318210` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `get sticky` | `[native code]` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301151` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295625` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330138` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:312925` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:1` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318303` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:18` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330698` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/clear-caches.js:5` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/rules.js:3` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:9` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:37` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2143` |
| 0.0% | 3.2ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2480` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:40` |
| 0.0% | 3.2ms | 0.0% | 1.7ms | `exec` | `[native code]` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330547` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `getParser2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318122` |
| 0.0% | 3.2ms | 0.0% | 0us | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318443` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3634` |
| 0.0% | 3.1ms | 0.0% | 0us | `getParamName` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319259` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319260` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `accept` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315363` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138509` |
| 0.0% | 3.1ms | 0.0% | 0us | `validateDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330341` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330450` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `toLocaleLowerCase` | `[native code]` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295642` |
| 0.0% | 3.1ms | 0.0% | 0us | `checkJsDoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:331972` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332757` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `read` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316314` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12515` |
| 0.0% | 3.1ms | 0.0% | 0us | `getRegexFromString` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320047` |
| 0.0% | 3.1ms | 0.0% | 0us | `fix10` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332418` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320367` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `cloneObject` | `[native code]` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:196155` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201907` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334442` |
| 0.0% | 3.0ms | 0.0% | 1.7ms | `checkTagName2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334407` |
| 0.0% | 3.0ms | 0.0% | 1.2ms | `validateDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327223` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `getAncestors` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 3.0ms | 0.0% | 0us | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318445` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `getParser3` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318164` |
| 0.0% | 3.0ms | 0.0% | 0us | `areDocsInformative` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326860` |
| 0.0% | 3.0ms | 0.0% | 0us | `descriptionIsRedundant` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326955` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326977` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:16` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2168` |
| 0.0% | 3.0ms | 0.0% | 0us | `getParamName` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319229` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:53` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/resolveProjectList.js:10` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/tinyglobby/dist/index.cjs:27` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:21` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7680` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:3` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318191` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1677` |
| 0.0% | 2.9ms | 0.0% | 1.7ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1653` |
| 0.0% | 2.9ms | 0.0% | 0us | `fix10` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332411` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:10` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318767` |
| 0.0% | 2.9ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317501` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3708` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332129` |
| 0.0% | 2.9ms | 0.0% | 0us | `y` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317604` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1962` |
| 0.0% | 2.9ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:673` |
| 0.0% | 2.9ms | 0.0% | 0us | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317897` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `getTokensBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3518` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` |
| 0.0% | 2.9ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323704` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318132` |
| 0.0% | 2.9ms | 0.0% | 0us | `getValidRuntimeIdentifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329079` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318152` |
| 0.0% | 2.8ms | 0.0% | 0us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321299` |
| 0.0% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326642` |
| 0.0% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328150` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `accept` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315392` |
| 0.0% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` |
| 0.0% | 2.8ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:674` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:717` |
| 0.0% | 2.8ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2851` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318046` |
| 0.0% | 2.8ms | 0.0% | 0us | `setDeps` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326788` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `log` | `[native code]` |
| 0.0% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326798` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/esquery.js:12` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/source-code-traverser.js:12` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:48` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333231` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:14` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320921` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318358` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `search` | `[native code]` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:324401` |
| 0.0% | 2.7ms | 0.0% | 0us | `findIndex` | `[native code]` |
| 0.0% | 2.7ms | 0.0% | 0us | `addMetaSchema` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:152` |
| 0.0% | 2.7ms | 0.0% | 0us | `addSchema` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:137` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:29` |
| 0.0% | 2.7ms | 0.0% | 0us | `_addSchema` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:309` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2150` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333347` |
| 0.0% | 2.7ms | 0.0% | 0us | `canSkip2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333328` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `preserveJoiner` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318429` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301178` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323797` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317998` |
| 0.0% | 2.6ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2348` |
| 0.0% | 2.6ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7692` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 2.6ms | 0.0% | 0us | `hasTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319491` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319492` |
| 0.0% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319602` |
| 0.0% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320778` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:590` |
| 0.0% | 2.6ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320895` |
| 0.0% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329243` |
| 0.0% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334237` |
| 0.0% | 2.6ms | 0.0% | 0us | `checkTagName` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334199` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `repeat` | `[native code]` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320461` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317853` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109709` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:105264` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:102460` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:106429` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:106842` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `get multiline` | `[native code]` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:104236` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201848` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:169413` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173238` |
| 0.0% | 1.8ms | 0.0% | 0us | `read` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316315` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:245304` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289592` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:242085` |
| 0.0% | 1.8ms | 0.0% | 0us | `hasRejectValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333196` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:242049` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:160397` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161321` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161553` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161607` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161364` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289574` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109700` |
| 0.0% | 1.8ms | 0.0% | 0us | `getDefaultTagStructureForMode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313998` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `getJsdocProcessorPlugin` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:337473` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `getTokenizers` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318759` |
| 0.0% | 1.8ms | 0.0% | 0us | `exemptSpeciaMethods` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320029` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `hasSchemaOption` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320025` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328151` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326159` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:197830` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201916` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:197793` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:197838` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320881` |
| 0.0% | 1.7ms | 0.0% | 0us | `hasThrowValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319876` |
| 0.0% | 1.7ms | 0.0% | 0us | `shouldReport` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334118` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334120` |
| 0.0% | 1.7ms | 0.0% | 0us | `hasThrowValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319893` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290082` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `preserveJoiner` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318426` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:1664` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:562` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:13` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `parseBlock` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318108` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/traverser.js:13` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:263508` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289675` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:293087` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:263612` |
| 0.0% | 1.7ms | 0.0% | 0us | `node:assert/strict` | `node:assert/strict:3` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:263437` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get declaration` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:335773` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201924` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:199307` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:199296` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/node-utils.js:76` |
| 0.0% | 1.7ms | 0.0% | 0us | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2158` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-modifiers.js:39` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `ownKeys` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:192404` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:192394` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201890` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:19` |
| 0.0% | 1.7ms | 0.0% | 0us | `Ajv` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:76` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `addInitialSchemas` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:276524` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330387` |
| 0.0% | 1.7ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330373` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `fix10` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330348` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290126` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:670` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92619` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320846` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `parse2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317010` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getTokensAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3564` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/definition/index.js:22` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:6` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:681` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/visitor-keys/dist/get-keys.js:4` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/visitor-keys/dist/index.js:4` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7090` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/analyze.js:4` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:324241` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201872` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188300` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188336` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188345` |
| 0.0% | 1.7ms | 0.0% | 0us | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:966` |
| 0.0% | 1.7ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1746` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289611` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:249011` |
| 0.0% | 1.7ms | 0.0% | 0us | `node:stream` | `node:stream:2` |
| 0.0% | 1.7ms | 0.0% | 0us | `internal:streams/compose` | `internal:streams/compose:2` |
| 0.0% | 1.7ms | 0.0% | 0us | `internal:fs/streams` | `internal:fs/streams:2` |
| 0.0% | 1.7ms | 0.0% | 0us | `internal:streams/duplex` | `internal:streams/duplex:2` |
| 0.0% | 1.7ms | 0.0% | 0us | `internal:streams/operators` | `internal:streams/operators:2` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12341` |
| 0.0% | 1.7ms | 0.0% | 0us | `internal:streams/pipeline` | `internal:streams/pipeline:2` |
| 0.0% | 1.7ms | 0.0% | 0us | `node:tty` | `node:tty:6` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330455` |
| 0.0% | 1.7ms | 0.0% | 0us | `internal:stream` | `internal:stream:2` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getCommentsBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3400` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320917` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289507` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:220834` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `uniqueSymbolParslet` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:123` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/private/tmp/prof_jsdoc.js:10` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318126` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313376` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290336` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:335667` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4163` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:46` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328156` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `cleanUpLastTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317382` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:128014` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:325968` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318155` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:39` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:183987` |
| 0.0% | 1.7ms | 0.0% | 0us | `getTokensAfterIgnoringSemis` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317961` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326038` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getTokenAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1760` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333346` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `join` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318468` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92620` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/getModifiers.js:4` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/getModifiers.js:38` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/getModifiers.js:30` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1983` |
| 0.0% | 1.7ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:331945` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228067` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289536` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228544` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228442` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228703` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170721` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170730` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172342` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170686` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:133300` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:133286` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138488` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/index.js:17` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/dom.js:1798` |
| 0.0% | 1.6ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2855` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:40084` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332133` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321370` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `exit` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:152793` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:152816` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:152902` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161605` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:29` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301164` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:138248` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `syntacticResult` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `getPreferredTagNameSimple` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319458` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321539` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/cli-engine/lint-result-cache.js:12` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:23` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `@lazy` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/file-entry-cache/cache.js:2` |
| 0.0% | 1.6ms | 0.0% | 0us | `node:crypto` | `node:crypto:39` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_findLine` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:578` |
| 0.0% | 1.6ms | 0.0% | 0us | `getLocFromIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3658` |
| 0.0% | 1.6ms | 0.0% | 0us | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4102` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329219` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329218` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322296` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getDefaultTagStructureForMode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314424` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7986` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295654` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7626` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109087` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:108774` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109002` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109025` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:108970` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:108935` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109710` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328602` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328624` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137246` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `GetIntrinsic` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137203` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137943` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138272` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172347` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96798` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170909` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170953` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:110315` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/dotjs/index.js:27` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170944` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2784` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318770` |
| 0.0% | 1.6ms | 0.0% | 0us | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317911` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3704` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:257726` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:257700` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289655` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321771` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `generateNamedReferences` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321752` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:212974` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322394` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328453` |
| 0.0% | 1.6ms | 0.0% | 0us | `_fromRunnerReport` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:203` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get message` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4110` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `toLocaleUpperCase` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295645` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295653` |
| 0.0% | 1.6ms | 0.0% | 0us | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2945` |
| 0.0% | 1.6ms | 0.0% | 0us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1282` |
| 0.0% | 1.6ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2384` |
| 0.0% | 1.6ms | 0.0% | 0us | `get identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:795` |
| 0.0% | 1.6ms | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:517` |
| 0.0% | 1.6ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1450` |
| 0.0% | 1.6ms | 0.0% | 0us | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get mainToken` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1166` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334432` |
| 0.0% | 1.6ms | 0.0% | 0us | `canSkip6` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334404` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320933` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `createTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332389` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:186764` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201866` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:186755` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:282755` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289715` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:282715` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7092` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:47` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1230` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:94` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320919` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329137` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:175338` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313118` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:175348` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332755` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289551` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236595` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236472` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236367` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:232340` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201898` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:193444` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:193438` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `setParamIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332156` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332162` |
| 0.0% | 1.5ms | 0.0% | 0us | `splitPrefixSuffix` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295678` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318764` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `split` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295589` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301150` |
| 0.0% | 1.5ms | 0.0% | 0us | `camelCase` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295618` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `read` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316312` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201828` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201822` |
| 0.0% | 1.5ms | 0.0% | 0us | `getESLintCoreRule` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:174801` |
| 0.0% | 1.5ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:653` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:180669` |
| 0.0% | 1.5ms | 0.0% | 0us | `splitTextIntoWords` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326876` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `normalizeWord` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326871` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289561` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:238796` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:200894` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:200931` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:200923` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201929` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/dotjs/index.js:7` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4139` |
| 0.0% | 1.5ms | 0.0% | 0us | `isGetter2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320000` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333895` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get kind` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2692` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1739` |
| 0.0% | 1.5ms | 0.0% | 0us | `exemptSpeciaMethods` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320033` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7682` |
| 0.0% | 1.5ms | 0.0% | 0us | `findExpectedIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332183` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `fill` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 0us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4521` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get key` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3206` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `looksLikeExport` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317749` |
| 0.0% | 1.5ms | 0.0% | 0us | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317843` |
| 0.0% | 1.5ms | 0.0% | 0us | `getParamName` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319320` |
| 0.0% | 1.5ms | 0.0% | 0us | `identifierRule` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316676` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336976` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:5923` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316650` |
| 0.0% | 1.5ms | 0.0% | 0us | `tryParsePathIgnoreError` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336765` |
| 0.0% | 1.5ms | 0.0% | 0us | `read` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316318` |
| 0.0% | 1.5ms | 0.0% | 0us | `validNamepathParsing` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336794` |
| 0.0% | 1.5ms | 0.0% | 0us | `parseNamePath` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317061` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:266461` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/minimatch/dist/commonjs/index.js:6` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:266522` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289691` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:46` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/tsconfig-utils/dist/index.js:18` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/getWatchProgramsForProjects.js:45` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/warnAboutTSVersion.js:30` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/warnAboutTSVersion.js:42` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:54` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/warnAboutTSVersion.js:4` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/index.js:27` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/index.js:14` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:128052` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289518` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:223015` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:223097` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get dotAll` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:271957` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7689` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7368` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/useProvidedPrograms.js:30` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/useProvidedPrograms.js:5` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/useProvidedPrograms.js:44` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/scope/index.js:20` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/TypeVisitor.js:6` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/ClassVisitor.js:6` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:18` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:8` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:14` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320955` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `indexOf` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334707` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/index.js:20` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/types/dist/index.js:21` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/predicates.js:5` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-estree.js:6` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:53` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/es2020.js:9` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/es2020.bigint.js:9` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/index.js:16` |
| 0.0% | 1.5ms | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5043` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1302` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329193` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:54196` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:58223` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:296353` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326168` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:21` |
| 0.0% | 1.5ms | 0.0% | 0us | `canSkip` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333224` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334704` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289746` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:288284` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:288465` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:288361` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/index.js:8` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320638` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320734` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332427` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:202779` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313246` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:10` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290261` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:202870` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:29585` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `hasObservableSideEffectsForRegExpMatch` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 0us | `_normalizeIPv4` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js:800` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138274` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/api.js:14` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rule-tester/index.js:3` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rule-tester/rule-tester.js:31` |
| 0.0% | 1.5ms | 0.0% | 0us | `serialize` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js:1031` |
| 0.0% | 1.5ms | 0.0% | 0us | `_recomposeAuthority` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js:960` |
| 0.0% | 1.5ms | 0.0% | 0us | `_getFullPath` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:215` |
| 0.0% | 1.5ms | 0.0% | 0us | `resolveIds` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:235` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getJoiner` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318264` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:224949` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:224879` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:224986` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289528` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getBasicUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320245` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:325988` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `createTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `addPolyfillToken` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301138` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301172` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295624` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:254651` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:254565` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:254636` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289637` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:3` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/index.js:3` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `values` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `getPreferredTagNameSimple` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319452` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289625` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:251511` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:251554` |
| 0.0% | 1.4ms | 0.0% | 0us | `setup` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/common.js:287` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/index.js:9` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/index.js:11` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/lazy-loading-rule-map.js:7` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/node.js:240` |
| 0.0% | 1.4ms | 0.0% | 0us | `enable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/common.js:163` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `save` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/node.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/default-config.js:12` |
| 0.0% | 1.4ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1765` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `hasRejectValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333150` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getFencer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318116` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `accept` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315152` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:285276` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289730` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:231254` |
| 0.0% | 1.4ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:231300` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:285372` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:285349` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:285280` |
| 0.0% | 1.4ms | 0.0% | 0us | `node:fs/promises` | `node:fs/promises:2` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:285267` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289546` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323805` |
| 0.0% | 1.4ms | 0.0% | 0us | `validateParameterNames` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323543` |
| 0.0% | 1.4ms | 0.0% | 0us | `onConstructed` | `internal:streams/writable:168` |
| 0.0% | 1.4ms | 0.0% | 0us | `onConstruct` | `internal:streams/destroy:144` |
| 0.0% | 1.4ms | 0.0% | 0us | `bound onceWrapper` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `internal:streams/writable:197` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `clearBuffer` | `internal:streams/writable` |
| 0.0% | 1.4ms | 0.0% | 0us | `emit` | `node:events:92` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3682` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:90804` |
| 0.0% | 1.4ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318147` |
| 0.0% | 1.4ms | 0.0% | 0us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `encodeInto` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:220` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301184` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `Parser` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314897` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320389` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330427` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/lib/utils.js:8` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/fdir/dist/index.cjs:462` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/index.js:3` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/lib/picomatch.js:3` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/lib/constants.js:105` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/lib/scan.js:3` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4174` |
| 0.0% | 1.4ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:331953` |
| 0.0% | 1.4ms | 0.0% | 0us | `RegExpParser` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:20981` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `RegExpParserState` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:22285` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290190` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `commentParserToESTree` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317363` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `/\}$/v` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get declaration` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3611` |
| 0.0% | 1.4ms | 0.0% | 0us | `exemptSpeciaMethods` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320030` |
| 0.0% | 1.4ms | 0.0% | 0us | `canSkip5` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334196` |
| 0.0% | 1.4ms | 0.0% | 0us | `_getOrBuildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6160` |
| 0.0% | 1.4ms | 0.0% | 0us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6483` |
| 0.0% | 1.4ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7265` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334230` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5141` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:724` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isNullSet` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:163634` |
| 0.0% | 1.4ms | 0.0% | 0us | `parseRange` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:163574` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:916` |
| 0.0% | 1.4ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2137` |
| 0.0% | 1.4ms | 0.0% | 0us | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:900` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318002` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:294930` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:54138` |
| 0.0% | 1.4ms | 0.0% | 0us | `splitTextIntoWords` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326874` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326875` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getBasicUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320228` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1229` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320756` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183916` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201851` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183954` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183945` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320925` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332173` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332174` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getBasicUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320241` |
| 0.0% | 1.4ms | 0.0% | 0us | `findExpectedIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332166` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2827` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `invokeHandlersWithNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:656` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334096` |
| 0.0% | 1.3ms | 0.0% | 0us | `canSkip4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334086` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318455` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createIsolatedProgram.js:41` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createIsolatedProgram.js:30` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:14` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createIsolatedProgram.js:8` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318435` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330922` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320801` |
| 0.0% | 1.3ms | 0.0% | 0us | `getNodeSystem` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:8288` |
| 0.0% | 1.3ms | 0.0% | 0us | `isFileSystemCaseSensitive` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:8495` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:8673` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:8678` |
| 0.0% | 1.3ms | 0.0% | 0us | `swapCase` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:8498` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188820` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201874` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188829` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188785` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:232` |
| 0.0% | 1.3ms | 0.0% | 0us | `extractSentences` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330307` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` |
| 0.0% | 1.3ms | 0.0% | 0us | `kw` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:143` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330342` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `TokenType` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:118` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `iterate` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321046` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `checkJsDoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:331856` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320887` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334023` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getAncestors` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3687` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getTags` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319501` |
| 0.0% | 1.3ms | 0.0% | 0us | `preserveJoiner` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318427` |
| 0.0% | 1.3ms | 0.0% | 0us | `node:util` | `node:util:2` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4132` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12342` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint/config-array/dist/cjs/index.cjs:7` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317443` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332145` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321103` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint/plugin-kit/dist/cjs/index.cjs:3` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:22` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:4` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/parse-string.js:113` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/prelude-ls/lib/index.js:5` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/parse-string.js:4` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4580` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:182072` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:182101` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:182108` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201839` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:271642` |
| 0.0% | 1.3ms | 0.0% | 0us | `getPreferredTagName` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319517` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326177` |
| 0.0% | 1.3ms | 0.0% | 0us | `addComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326206` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333081` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `hasTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319490` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:279762` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:279823` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289699` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332335` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201879` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318143` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190010` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:20` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/timing.js:8` |
| 0.0% | 1.3ms | 0.0% | 0us | `Range` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:42` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:464` |
| 0.0% | 1.3ms | 0.0% | 0us | `satisfies` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/functions/satisfies.js:6` |
| 0.0% | 1.3ms | 0.0% | 0us | `replaceXRanges` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:389` |
| 0.0% | 1.3ms | 0.0% | 0us | `parseComparator` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:264` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:62` |
| 0.0% | 1.3ms | 0.0% | 0us | `parseRange` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:135` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318310` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332415` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171430` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171459` |
| 0.0% | 1.3ms | 0.0% | 0us | `fix10` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332412` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171467` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171551` |
| 0.0% | 1.3ms | 0.0% | 0us | `useColors` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12454` |
| 0.0% | 1.3ms | 0.0% | 0us | `WriteStream` | `internal:fs/streams:245` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `push` | `internal:fixed_queue` |
| 0.0% | 1.3ms | 0.0% | 0us | `Writable` | `internal:streams/writable:196` |
| 0.0% | 1.3ms | 0.0% | 0us | `push` | `internal:fixed_queue:41` |
| 0.0% | 1.3ms | 0.0% | 0us | `createDebug` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12070` |
| 0.0% | 1.3ms | 0.0% | 0us | `nextTick` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `construct` | `internal:streams/destroy:124` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `p` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `/\s*(@(\S+))(\s*)/` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:325960` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:11` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `parse` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:90437` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:90435` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:90441` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91300` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:217672` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:217432` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:217509` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:217317` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289491` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91299` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getText` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1333` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333102` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:47927` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:51143` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290383` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201869` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:51201` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:48398` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:48478` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91298` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:185225` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201859` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `checkJsDoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2906` |
| 0.0% | 1.2ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2357` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `P` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1187` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321660` |
| 0.0% | 1.2ms | 0.0% | 0us | `SourceCode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1093` |
| 0.0% | 1.2ms | 0.0% | 0us | `RuleContext` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4248` |
| 0.0% | 1.2ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8198` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_getSharedCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:745` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:195736` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:195373` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164515` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:195384` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:195339` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164405` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7389` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334022` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173265` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173072` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173080` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173043` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1972` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172176` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313114` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172205` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172354` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172213` |
| 0.0% | 1.2ms | 0.0% | 0us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321162` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320896` |
| 0.0% | 1.2ms | 0.0% | 0us | `filterTags` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319496` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getBasicUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320264` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329246` |
| 0.0% | 1.2ms | 0.0% | 0us | `tagMustHaveTypePosition` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319687` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320815` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319497` |
| 0.0% | 1.2ms | 0.0% | 0us | `tagMightHaveTypePosition` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319691` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `commentParserToESTree` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317400` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `ge` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2130` |
| 0.0% | 1.2ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1549` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_getAllTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6928` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2198` |
| 0.0% | 1.2ms | 0.0% | 0us | `canSkip` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333220` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_normalizeFilter` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1599` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190552` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201883` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190544` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `preserveJoiner` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318424` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190509` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:261101` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260164` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:261167` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260568` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260360` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260470` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289664` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318212` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `onNodeWithComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321177` |
| 0.0% | 1.2ms | 0.0% | 0us | `De` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.2ms | 0.0% | 0us | `be` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5010` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:215829` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:215933` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:215648` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289485` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313039` |
| 0.0% | 1.2ms | 0.0% | 0us | `get kind` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2734` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320754` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_rawTokenText` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `isConstructor` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319997` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326636` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `nameTokenizer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318276` |
| 0.0% | 1.2ms | 0.0% | 0us | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318438` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_traverse` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/json-schema-traverse/index.js:73` |
| 0.0% | 1.2ms | 0.0% | 0us | `resolveIds` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:239` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/json-schema-traverse/index.js:14` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `commentParserToESTree` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317393` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313050` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:144926` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1977` |

## Function Details

### `getTokensAfter`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3566` | Self: 9.4% (427.0ms) | Total: 9.6% (432.7ms) | Samples: 281

**Called by:**
- `getTokensAfterIgnoringSemis` (285)

**Calls:**
- `push` (4)

### `parse`
`[native code]` | Self: 5.1% (230.8ms) | Total: 5.1% (230.8ms) | Samples: 150

**Called by:**
- `parseSource` (148)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `anonymous`
`[native code]` | Self: 4.9% (222.0ms) | Total: 34.1% (1.53s) | Samples: 144

**Called by:**
- `require` (731)
- `bound require` (8)
- `node:assert/strict` (1)
- `node:stream` (1)
- `node:tty` (1)
- `node:fs` (1)
- `internal:streams/duplex` (1)
- `node:fs/promises` (1)
- `internal:stream` (1)
- `internal:streams/operators` (1)
- `internal:streams/compose` (1)
- `node:util` (1)
- `internal:streams/pipeline` (1)
- `internal:fs/streams` (1)

**Calls:**
- `(anonymous)` (51)
- `(anonymous)` (36)
- `(anonymous)` (27)
- `(anonymous)` (23)
- `(anonymous)` (23)
- `(anonymous)` (20)
- `(anonymous)` (19)
- `(anonymous)` (17)
- `(anonymous)` (14)
- `(anonymous)` (13)
- `(anonymous)` (11)
- `(anonymous)` (11)
- `(anonymous)` (9)
- `(anonymous)` (9)
- `(anonymous)` (9)
- `(anonymous)` (9)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
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
- `internal:streams/duplex` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
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
- `node:assert/strict` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
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
- `internal:fs/streams` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:util` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
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
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:crypto` (1)
- `internal:streams/pipeline` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:stream` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:tty` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:fs/promises` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:streams/operators` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1300` | Self: 4.1% (188.8ms) | Total: 4.1% (188.8ms) | Samples: 125

**Called by:**
- `_getAllTokens` (125)

### `get flags`
`[native code]` | Self: 2.9% (132.1ms) | Total: 3.1% (143.4ms) | Samples: 88

**Called by:**
- `matchAll` (94)

**Calls:**
- `get hasIndices` (3)
- `get dotAll` (1)
- `get multiline` (1)
- `get sticky` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1288` | Self: 2.7% (125.7ms) | Total: 2.7% (125.7ms) | Samples: 81

**Called by:**
- `_getAllTokens` (81)

### `entries`
`[native code]` | Self: 2.5% (115.5ms) | Total: 2.5% (115.5ms) | Samples: 74

**Called by:**
- `getPreferredTagNameSimple` (74)

### `getTokensAfter`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3565` | Self: 2.2% (102.2ms) | Total: 2.2% (102.2ms) | Samples: 68

**Called by:**
- `getTokensAfterIgnoringSemis` (68)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1673` | Self: 2.1% (96.8ms) | Total: 14.0% (634.4ms) | Samples: 64

**Called by:**
- `findJSDocComment` (403)
- `getReducedASTNode` (13)

**Calls:**
- `_getTokensAndCommentsMerged` (299)
- `_getTokensAndCommentsMerged` (36)
- `_getTokensAndCommentsMerged` (12)
- `_getTokensAndCommentsMerged` (2)
- `_getTokensAndCommentsMerged` (1)
- `_getTokensAndCommentsMerged` (1)
- `_getTokensAndCommentsMerged` (1)

### ``/^\n?([A-Z`\d_][\s\S]*[.?!`\p{RGI_Emoji}]\s*)?$/v``
`[native code]` | Self: 2.0% (92.1ms) | Total: 2.0% (92.1ms) | Samples: 60

**Called by:**
- `test` (60)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329660` | Self: 1.9% (86.7ms) | Total: 2.2% (102.5ms) | Samples: 55

**Called by:**
- `filter` (64)

**Calls:**
- `/^\*(?!\*)/v` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328983` | Self: 1.8% (84.9ms) | Total: 2.2% (100.1ms) | Samples: 55

**Called by:**
- `filter` (65)

**Calls:**
- `/^\*(?!\*)/v` (10)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328988` | Self: 1.8% (84.0ms) | Total: 2.6% (118.7ms) | Samples: 55

**Called by:**
- `filter` (78)

**Calls:**
- `/^\s*globals/v` (23)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 1.7% (80.6ms) | Total: 1.7% (80.6ms) | Samples: 52

**Called by:**
- `(anonymous)` (47)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `forEach` (1)

### `regExpSplitFast`
`[native code]` | Self: 1.7% (79.0ms) | Total: 2.6% (117.9ms) | Samples: 52

**Called by:**
- `get lines` (54)
- `splitLines` (24)

**Calls:**
- `/\r\n\|\r\|\n\|\u2028\|\u2029/` (26)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:8` | Self: 1.5% (70.8ms) | Total: 1.5% (70.8ms) | Samples: 5

**Called by:**
- `(anonymous)` (5)

### `getTokenizers`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318758` | Self: 1.4% (67.5ms) | Total: 1.4% (67.5ms) | Samples: 10

**Called by:**
- `parseComment` (10)

### `filter`
`[native code]` | Self: 1.4% (67.4ms) | Total: 12.6% (571.4ms) | Samples: 44

**Called by:**
- `(anonymous)` (104)
- `(anonymous)` (96)
- `(anonymous)` (78)
- `(anonymous)` (72)
- `onProgramExit` (10)
- `(anonymous)` (5)
- `(anonymous)` (3)
- `findExpectedIndex` (1)
- `filterTags` (1)
- `compactJoiner` (1)

**Calls:**
- `(anonymous)` (93)
- `(anonymous)` (78)
- `(anonymous)` (65)
- `(anonymous)` (64)
- `(anonymous)` (7)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `match`
`[native code]` | Self: 1.3% (61.2ms) | Total: 2.4% (111.1ms) | Samples: 2

**Called by:**
- `splitSpace` (16)
- `(anonymous)` (8)
- `splitCR` (7)
- `SemVer` (2)
- `getRegexFromString` (2)

**Calls:**
- `[Symbol.match]` (33)

### `getValidRuntimeIdentifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329080` | Self: 1.1% (49.7ms) | Total: 1.1% (49.7ms) | Samples: 34

**Called by:**
- `(anonymous)` (34)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7720` | Self: 1.0% (49.1ms) | Total: 63.3% (2.85s) | Samples: 32

**Called by:**
- `runPlugins` (1836)

**Calls:**
- `_invokeFused` (787)
- `_invokeFused` (727)
- `_invokeFused` (255)
- `_invokeFused` (22)
- `_nodeViewRaw` (6)
- `_nodeViewRaw` (4)
- `_invokeFused` (1)
- `_nodeViewRaw` (1)
- `_invokeFused` (1)

### `/(?<!\])\{@(?<tag>[^\}\s]+)\s?(?<namepathOrURL>[^\}\s\\|]*)\s*(?<separator>[\s\\|])?\s*(?<text>[^\}]*)\}/dgv`
`[native code]` | Self: 1.0% (49.0ms) | Total: 1.0% (49.0ms) | Samples: 31

**Called by:**
- `regExpExec` (31)

### `stringSplitFast`
`[native code]` | Self: 0.9% (44.6ms) | Total: 0.9% (44.6ms) | Samples: 27

**Called by:**
- `(anonymous)` (23)
- `read` (3)
- `(anonymous)` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1285` | Self: 0.9% (41.8ms) | Total: 1.3% (59.3ms) | Samples: 27

**Called by:**
- `_getAllTokens` (39)

**Calls:**
- `_getJsxTextTokFlags` (5)
- `_getJsxTextTokFlags` (3)
- `_getJsxTextTokFlags` (3)
- `_getJsxTextTokFlags` (1)

### `[Symbol.match]`
`[native code]` | Self: 0.8% (40.1ms) | Total: 1.1% (51.4ms) | Samples: 26

**Called by:**
- `match` (33)
- `_normalizeIPv4` (1)

**Calls:**
- `/\r+$/` (3)
- `/^\s+/` (3)
- `/\s*(@(\S+))(\s*)/` (1)
- `hasObservableSideEffectsForRegExpMatch` (1)

### `/\r\n\|\r\|\n\|\u2028\|\u2029/`
`[native code]` | Self: 0.8% (38.8ms) | Total: 0.8% (38.8ms) | Samples: 26

**Called by:**
- `regExpSplitFast` (26)

### `parseIntermediateType`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314940` | Self: 0.8% (36.8ms) | Total: 1.5% (68.8ms) | Samples: 24

**Called by:**
- `parseType` (45)

**Calls:**
- `_NoParsletFoundError` (21)

### `[Symbol.matchAll]`
`[native code]` | Self: 0.7% (35.7ms) | Total: 0.7% (35.7ms) | Samples: 24

**Called by:**
- `parseDescription` (21)
- `parseDescription` (3)

### `/^\s*globals/v`
`[native code]` | Self: 0.7% (34.7ms) | Total: 0.7% (34.7ms) | Samples: 23

**Called by:**
- `(anonymous)` (23)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318033` | Self: 0.7% (32.3ms) | Total: 0.7% (32.3ms) | Samples: 21

**Called by:**
- `checkJsdoc` (20)
- `(anonymous)` (1)

### `map`
`[native code]` | Self: 0.6% (31.0ms) | Total: 21.1% (951.1ms) | Samples: 21

**Called by:**
- `(anonymous)` (265)
- `(anonymous)` (137)
- `(anonymous)` (65)
- `(anonymous)` (6)
- `compactJoiner` (6)
- `commentParserToESTree` (5)
- `_lintSourceOne` (4)
- `camelCase` (3)
- `Range` (3)
- `getFunctionParameterNames` (3)
- `(anonymous)` (3)
- `parseRange` (2)
- `(anonymous)` (2)
- `getParamName` (2)
- `replaceXRanges` (1)
- `extractSentences` (1)
- `(anonymous)` (1)
- `Range` (1)
- `parseRange` (1)
- `getPreferredTagNameSimple` (1)

**Calls:**
- `(anonymous)` (264)
- `(anonymous)` (137)
- `parseSpec` (38)
- `parseSpec` (17)
- `(anonymous)` (4)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `_fromRunnerReport` (3)
- `parseRange` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `parseRange` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `parseComparator` (1)
- `_fromRunnerReport` (1)
- `(anonymous)` (1)
- `replace` (1)
- `(anonymous)` (1)
- `parseRange` (1)

### `/^\*(?!\*)/v`
`[native code]` | Self: 0.6% (30.9ms) | Total: 0.6% (30.9ms) | Samples: 19

**Called by:**
- `(anonymous)` (10)
- `(anonymous)` (9)

### `Error`
`[native code]` | Self: 0.6% (28.7ms) | Total: 0.6% (28.7ms) | Samples: 19

**Called by:**
- `_NoParsletFoundError` (19)

### `getTokensAfter`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3563` | Self: 0.5% (26.9ms) | Total: 0.5% (26.9ms) | Samples: 17

**Called by:**
- `getTokensAfterIgnoringSemis` (17)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1975` | Self: 0.5% (26.5ms) | Total: 1.2% (54.9ms) | Samples: 17

**Called by:**
- `getTokenBefore` (36)

**Calls:**
- `_makeToken` (15)
- `_makeToken` (3)
- `_makeToken` (1)

### `parseSpec`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318170` | Self: 0.5% (25.3ms) | Total: 0.5% (25.3ms) | Samples: 17

**Called by:**
- `map` (17)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318045` | Self: 0.5% (24.8ms) | Total: 5.9% (269.4ms) | Samples: 17

**Called by:**
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (101)
- `checkJsdoc` (76)

**Calls:**
- `getJSDocComment` (132)
- `getJSDocComment` (28)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1260` | Self: 0.5% (23.9ms) | Total: 0.5% (23.9ms) | Samples: 16

**Called by:**
- `_getAllTokens` (16)

### `test`
`[native code]` | Self: 0.5% (22.9ms) | Total: 2.5% (115.0ms) | Samples: 15

**Called by:**
- `validateDescription` (71)
- `callIterator` (2)
- `(anonymous)` (1)
- `_precomputeScopes` (1)

**Calls:**
- ``/^\n?([A-Z`\d_][\s\S]*[.?!`\p{RGI_Emoji}]\s*)?$/v`` (60)

### `includes`
`[native code]` | Self: 0.5% (22.7ms) | Total: 0.5% (22.7ms) | Samples: 15

**Called by:**
- `(anonymous)` (15)

### `Set`
`[native code]` | Self: 0.4% (22.0ms) | Total: 0.4% (22.0ms) | Samples: 14

**Called by:**
- `(anonymous)` (14)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.4% (21.8ms) | Total: 0.4% (21.8ms) | Samples: 15

**Called by:**
- `_getTokensAndCommentsMerged` (15)

### `performIteration`
`[native code]` | Self: 0.4% (20.5ms) | Total: 1.8% (85.4ms) | Samples: 15

**Called by:**
- `parseDescription` (34)
- `parseDescription` (22)

**Calls:**
- `next` (41)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1292` | Self: 0.4% (19.7ms) | Total: 0.4% (19.7ms) | Samples: 12

**Called by:**
- `_getAllTokens` (12)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.4% (19.2ms) | Total: 2.4% (110.8ms) | Samples: 12

**Called by:**
- `ke` (37)
- `(anonymous)` (32)
- `(anonymous)` (2)
- `y` (2)

**Calls:**
- `(anonymous)` (32)
- `Ce` (16)
- `_e` (7)
- `y` (2)
- `De` (1)
- `p` (1)
- `P` (1)
- `ge` (1)

### `join`
`[native code]` | Self: 0.4% (18.8ms) | Total: 0.4% (18.8ms) | Samples: 13

**Called by:**
- `compactJoiner` (10)
- `be` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `callIterator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321104` | Self: 0.4% (18.7ms) | Total: 0.9% (40.9ms) | Samples: 12

**Called by:**
- `onProgramExit` (24)
- `onNodeWithComment` (2)

**Calls:**
- `getText` (9)
- `test` (2)
- `/^\/\*\*\s/v` (2)
- `getText` (1)

### `esSpecIsRegExp`
`[native code]` | Self: 0.4% (18.0ms) | Total: 0.4% (18.0ms) | Samples: 12

**Called by:**
- `matchAll` (12)

### `seedTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318081` | Self: 0.3% (18.0ms) | Total: 0.3% (18.0ms) | Samples: 12

**Called by:**
- `parseSource` (12)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7386` | Self: 0.3% (16.8ms) | Total: 0.3% (16.8ms) | Samples: 11

**Called by:**
- `runPlugins` (11)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:676` | Self: 0.3% (15.7ms) | Total: 0.3% (15.7ms) | Samples: 10

**Called by:**
- `getAllComments` (10)

### `bound checkJsdoc`
`[native code]` | Self: 0.3% (15.0ms) | Total: 13.6% (616.1ms) | Samples: 10

**Called by:**
- `invokeHandlersWithNode` (291)
- `_invokeFused` (99)
- `_invokeFused` (12)

**Calls:**
- `checkJsdoc` (221)
- `checkJsdoc` (109)
- `checkJsdoc` (62)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` | Self: 0.3% (15.0ms) | Total: 0.3% (15.0ms) | Samples: 10

**Called by:**
- `(anonymous)` (8)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `getText`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1346` | Self: 0.3% (14.1ms) | Total: 0.3% (14.1ms) | Samples: 9

**Called by:**
- `callIterator` (9)

### `copyDataProperties`
`[native code]` | Self: 0.3% (14.0ms) | Total: 0.3% (14.0ms) | Samples: 8

**Called by:**
- `(anonymous)` (7)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301190` | Self: 0.3% (14.0ms) | Total: 0.3% (14.0ms) | Samples: 9

**Called by:**
- `anonymous` (9)

### `splitSpace`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318069` | Self: 0.2% (13.4ms) | Total: 0.2% (13.4ms) | Samples: 9

**Called by:**
- `parseSource` (3)
- `parseSource` (3)
- `parseSource` (2)
- `(anonymous)` (1)

### `_getAllTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1932` | Self: 0.2% (13.4ms) | Total: 9.9% (446.1ms) | Samples: 9

**Called by:**
- `_getTokensAndCommentsMerged` (292)

**Calls:**
- `_makeToken` (125)
- `_makeToken` (81)
- `_makeToken` (39)
- `_makeToken` (16)
- `_makeToken` (12)
- `_makeToken` (8)
- `_makeToken` (1)
- `_makeToken` (1)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318030` | Self: 0.2% (12.2ms) | Total: 0.2% (12.2ms) | Samples: 8

**Called by:**
- `checkJsdoc` (7)
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1264` | Self: 0.2% (12.0ms) | Total: 0.2% (12.0ms) | Samples: 8

**Called by:**
- `_getAllTokens` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318454` | Self: 0.2% (12.0ms) | Total: 2.4% (108.9ms) | Samples: 7

**Called by:**
- `parse3` (72)

**Calls:**
- `map` (65)

### `RegExp`
`[native code]` | Self: 0.2% (11.9ms) | Total: 0.2% (11.9ms) | Samples: 8

**Called by:**
- `maskExcludedContent` (8)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4211` | Self: 0.2% (11.8ms) | Total: 0.2% (11.8ms) | Samples: 8

**Called by:**
- `walkNodes` (4)
- `getAncestors` (3)
- `get parent` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321193` | Self: 0.2% (11.3ms) | Total: 0.2% (11.3ms) | Samples: 7

**Called by:**
- `filter` (7)

### `concat`
`[native code]` | Self: 0.2% (11.3ms) | Total: 0.2% (11.3ms) | Samples: 7

**Called by:**
- `(anonymous)` (5)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7855` | Self: 0.2% (11.0ms) | Total: 0.2% (11.0ms) | Samples: 7

**Called by:**
- `runPlugins` (7)

### `getUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320284` | Self: 0.2% (10.7ms) | Total: 0.3% (15.0ms) | Samples: 7

**Called by:**
- `iterate` (10)

**Calls:**
- `getBasicUtils` (1)
- `getBasicUtils` (1)
- `getBasicUtils` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319475` | Self: 0.2% (10.6ms) | Total: 0.7% (33.4ms) | Samples: 7

**Called by:**
- `find` (22)

**Calls:**
- `includes` (15)

### `replace`
`[native code]` | Self: 0.2% (10.3ms) | Total: 0.2% (11.7ms) | Samples: 7

**Called by:**
- `maskExcludedContent` (6)
- `map` (1)
- `swapCase` (1)

**Calls:**
- `(anonymous)` (1)

### `getDecorator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317746` | Self: 0.2% (10.2ms) | Total: 0.6% (30.4ms) | Samples: 7

**Called by:**
- `findJSDocComment` (19)
- `(anonymous)` (1)

**Calls:**
- `get decorators` (2)
- `get decorators` (2)
- `get decorators` (2)
- `get decorators` (2)
- `get decorators` (1)
- `get declaration` (1)
- `get decorators` (1)
- `get declaration` (1)
- `get parent` (1)

### `_getAllTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1933` | Self: 0.2% (9.3ms) | Total: 0.2% (9.3ms) | Samples: 6

**Called by:**
- `_getTokensAndCommentsMerged` (6)

### `parseBlock`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318105` | Self: 0.2% (9.0ms) | Total: 0.2% (13.3ms) | Samples: 6

**Called by:**
- `(anonymous)` (9)

**Calls:**
- `/^@[^\s/]+(?=\s\|$)/` (3)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318149` | Self: 0.1% (8.9ms) | Total: 0.1% (8.9ms) | Samples: 6

**Called by:**
- `(anonymous)` (6)

### `ensureMap`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319627` | Self: 0.1% (8.9ms) | Total: 0.1% (8.9ms) | Samples: 6

**Called by:**
- `isNameOrNamepathDefiningTag` (6)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4522` | Self: 0.1% (8.8ms) | Total: 0.1% (8.8ms) | Samples: 2

**Called by:**
- `AstView` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7382` | Self: 0.1% (8.6ms) | Total: 0.1% (8.6ms) | Samples: 6

**Called by:**
- `runPlugins` (6)

### `parseDescription`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318682` | Self: 0.1% (8.5ms) | Total: 2.6% (118.7ms) | Samples: 5

**Called by:**
- `parseInlineTags` (42)
- `parseInlineTags` (37)

**Calls:**
- `matchAll` (49)
- `performIteration` (22)
- `[Symbol.matchAll]` (3)

### `trimStart`
`[native code]` | Self: 0.1% (8.1ms) | Total: 0.1% (8.1ms) | Samples: 5

**Called by:**
- `(anonymous)` (4)
- `read` (1)

### `regExpExec`
`[native code]` | Self: 0.1% (8.0ms) | Total: 1.4% (64.8ms) | Samples: 5

**Called by:**
- `next` (41)

**Calls:**
- `/(?<!\])\{@(?<tag>[^\}\s]+)\s?(?<namepathOrURL>[^\}\s\\|]*)\s*(?<separator>[\s\\|])?\s*(?<text>[^\}]*)\}/dgv` (31)
- `/(?:\[(?<text>[^\]]+)\])\{@(?<tag>[^\}\s]+)\s?(?<namepathOrURL>[^\}\s\\|]*)\}/dgv` (5)

### `/(?:\[(?<text>[^\]]+)\])\{@(?<tag>[^\}\s]+)\s?(?<namepathOrURL>[^\}\s\\|]*)\}/dgv`
`[native code]` | Self: 0.1% (7.8ms) | Total: 0.1% (7.8ms) | Samples: 5

**Called by:**
- `regExpExec` (5)

### `getOwnPropertyDescriptor`
`[native code]` | Self: 0.1% (7.5ms) | Total: 0.1% (7.5ms) | Samples: 5

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1202` | Self: 0.1% (7.4ms) | Total: 0.1% (7.4ms) | Samples: 5

**Called by:**
- `_makeToken` (5)

### `endsWith`
`[native code]` | Self: 0.1% (7.4ms) | Total: 0.1% (7.4ms) | Samples: 5

**Called by:**
- `parseSource` (3)
- `(anonymous)` (1)
- `preserveJoiner` (1)

### `trimEnd`
`[native code]` | Self: 0.1% (7.3ms) | Total: 0.1% (7.3ms) | Samples: 5

**Called by:**
- `parseSource` (3)
- `addComment` (1)
- `parseSource` (1)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4094` | Self: 0.1% (7.3ms) | Total: 0.1% (7.3ms) | Samples: 5

**Called by:**
- `_nodeViewRaw` (5)

### `parse2`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316976` | Self: 0.1% (7.2ms) | Total: 0.1% (7.2ms) | Samples: 5

**Called by:**
- `cleanUpLastTag` (5)

### `Map`
`[native code]` | Self: 0.1% (7.2ms) | Total: 0.1% (7.2ms) | Samples: 5

**Called by:**
- `getDefaultTagStructureForMode` (4)
- `getDefaultTagStructureForMode` (1)

### `trim`
`[native code]` | Self: 0.1% (7.1ms) | Total: 0.1% (7.1ms) | Samples: 5

**Called by:**
- `(anonymous)` (4)
- `(anonymous)` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:593` | Self: 0.1% (7.0ms) | Total: 0.1% (7.0ms) | Samples: 5

**Called by:**
- `parseSource` (5)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1228` | Self: 0.1% (6.4ms) | Total: 0.1% (6.4ms) | Samples: 4

**Called by:**
- `_getTokensAndCommentsMerged` (3)
- `_getAllTokens` (1)

### `stringIncludesInternal`
`[native code]` | Self: 0.1% (6.4ms) | Total: 0.1% (6.4ms) | Samples: 4

**Called by:**
- `matchAll` (4)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318130` | Self: 0.1% (6.3ms) | Total: 0.1% (6.3ms) | Samples: 4

**Called by:**
- `(anonymous)` (4)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318148` | Self: 0.1% (6.3ms) | Total: 0.1% (6.3ms) | Samples: 4

**Called by:**
- `(anonymous)` (4)

### `checkJsdoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321336` | Self: 0.1% (6.3ms) | Total: 3.6% (164.1ms) | Samples: 4

**Called by:**
- `bound checkJsdoc` (109)

**Calls:**
- `getJSDocComment` (76)
- `getJSDocComment` (20)
- `getJSDocComment` (7)
- `getJSDocComment` (2)

### `parse3`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318646` | Self: 0.1% (6.2ms) | Total: 8.8% (399.6ms) | Samples: 4

**Called by:**
- `parseComment` (173)
- `(anonymous)` (90)

**Calls:**
- `(anonymous)` (82)
- `(anonymous)` (72)
- `(anonymous)` (41)
- `(anonymous)` (24)
- `(anonymous)` (20)
- `getParser4` (4)
- `getParser4` (4)
- `getParser4` (3)
- `getParser4` (2)
- `getParser4` (2)
- `getParser4` (2)
- `(anonymous)` (1)
- `getParser4` (1)
- `getParser4` (1)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1656` | Self: 0.1% (6.1ms) | Total: 0.2% (12.4ms) | Samples: 4

**Called by:**
- `findJSDocComment` (6)
- `getReducedASTNode` (2)

**Calls:**
- `get range` (2)
- `get range` (1)
- `get range` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329226` | Self: 0.1% (6.0ms) | Total: 1.5% (68.6ms) | Samples: 3

**Called by:**
- `iterate` (45)

**Calls:**
- `getValidRuntimeIdentifiers` (34)
- `concat` (5)
- `getValidRuntimeIdentifiers` (2)
- `(anonymous)` (1)

### `getParser4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318441` | Self: 0.1% (6.0ms) | Total: 0.1% (6.0ms) | Samples: 4

**Called by:**
- `parse3` (4)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318018` | Self: 0.1% (6.0ms) | Total: 0.1% (6.0ms) | Samples: 4

**Called by:**
- `getJSDocComment` (2)
- `getNonJsdocComment` (2)

### `parseBlock`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.1% (5.7ms) | Total: 0.1% (5.7ms) | Samples: 4

**Called by:**
- `(anonymous)` (4)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5080` | Self: 0.1% (5.7ms) | Total: 31.8% (1.43s) | Samples: 4

**Called by:**
- `walkNodes` (787)
- `walkNodes` (144)

**Calls:**
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (669)
- `Program:exit` (104)
- `bound checkJsdoc` (99)
- `Program:exit` (39)
- `bound checkNonJsdoc` (11)
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (3)
- `(anonymous)` (1)
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (1)

### `push`
`[native code]` | Self: 0.1% (5.7ms) | Total: 0.1% (5.7ms) | Samples: 4

**Called by:**
- `getTokensAfter` (4)

### `defineProperty`
`[native code]` | Self: 0.1% (5.6ms) | Total: 0.1% (5.6ms) | Samples: 4

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318133` | Self: 0.1% (5.6ms) | Total: 0.1% (5.6ms) | Samples: 4

**Called by:**
- `(anonymous)` (4)

### `maskCodeBlocks`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.1% (5.6ms) | Total: 0.1% (5.6ms) | Samples: 4

**Called by:**
- `(anonymous)` (4)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.1% (5.5ms) | Total: 0.1% (5.5ms) | Samples: 4

**Called by:**
- `getJSDocComment` (2)
- `getNonJsdocComment` (2)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318043` | Self: 0.1% (5.3ms) | Total: 0.1% (5.3ms) | Samples: 4

**Called by:**
- `checkJsdoc` (2)
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (2)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1185` | Self: 0.1% (5.0ms) | Total: 0.1% (5.0ms) | Samples: 3

**Called by:**
- `_makeToken` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328167` | Self: 0.1% (5.0ms) | Total: 3.1% (140.5ms) | Samples: 3

**Called by:**
- `filter` (93)

**Calls:**
- `parse3` (90)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (5.0ms) | Total: 0.1% (5.0ms) | Samples: 3

**Called by:**
- `_nodeViewRaw` (3)

### `flatIntoArrayWithCallback`
`[native code]` | Self: 0.1% (4.9ms) | Total: 0.5% (25.0ms) | Samples: 3

**Called by:**
- `flatMap` (4)
- `(anonymous)` (4)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `splitTextIntoWords` (1)
- `(anonymous)` (1)
- `splitTextIntoWords` (1)
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (5)
- `(anonymous)` (3)
- `flatIntoArray` (2)
- `(anonymous)` (1)
- `normalizeWord` (1)
- `(anonymous)` (1)

### `unshift`
`[native code]` | Self: 0.1% (4.7ms) | Total: 0.1% (4.7ms) | Samples: 3

**Called by:**
- `getAncestors` (3)

### `preserveJoiner`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318425` | Self: 0.1% (4.6ms) | Total: 0.1% (4.6ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `get hasIndices`
`[native code]` | Self: 0.1% (4.5ms) | Total: 0.1% (4.5ms) | Samples: 3

**Called by:**
- `get flags` (3)

### `Se`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.1% (4.5ms) | Total: 0.1% (4.5ms) | Samples: 3

**Called by:**
- `Pe` (2)
- `Ce` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318797` | Self: 0.1% (4.5ms) | Total: 0.1% (4.5ms) | Samples: 3

**Called by:**
- `parseSpec` (3)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4210` | Self: 0.1% (4.5ms) | Total: 0.1% (4.5ms) | Samples: 3

**Called by:**
- `get parent` (1)
- `walkNodes` (1)
- `getAncestors` (1)

### `compactJoiner`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318417` | Self: 0.0% (4.4ms) | Total: 0.6% (29.4ms) | Samples: 3

**Called by:**
- `(anonymous)` (20)

**Calls:**
- `join` (10)
- `map` (6)
- `filter` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329662` | Self: 0.0% (4.4ms) | Total: 8.9% (402.5ms) | Samples: 3

**Called by:**
- `map` (264)

**Calls:**
- `parseComment` (101)
- `commentParserToESTree` (87)
- `parseComment` (66)
- `commentParserToESTree` (4)
- `commentParserToESTree` (1)
- `commentParserToESTree` (1)
- `commentParserToESTree` (1)

### `/\r+$/`
`[native code]` | Self: 0.0% (4.4ms) | Total: 0.0% (4.4ms) | Samples: 3

**Called by:**
- `[Symbol.match]` (3)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317894` | Self: 0.0% (4.4ms) | Total: 14.0% (633.5ms) | Samples: 3

**Called by:**
- `findJSDocComment` (415)

**Calls:**
- `getTokenBefore` (403)
- `getTokenBefore` (6)
- `getTokenBefore` (2)
- `getTokenBefore` (1)

### `replaceAll`
`[native code]` | Self: 0.0% (4.4ms) | Total: 0.0% (4.4ms) | Samples: 3

**Called by:**
- `maskCodeBlocks` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317513` | Self: 0.0% (4.3ms) | Total: 0.0% (4.3ms) | Samples: 3

**Called by:**
- `forEach` (3)

### `parslet`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315039` | Self: 0.0% (4.3ms) | Total: 0.2% (11.8ms) | Samples: 3

**Called by:**
- `tryParslets` (8)

**Calls:**
- `accept` (2)
- `accept` (2)
- `accept` (1)

### `/^@[^\s/]+(?=\s\|$)/`
`[native code]` | Self: 0.0% (4.3ms) | Total: 0.0% (4.3ms) | Samples: 3

**Called by:**
- `parseBlock` (3)

### `ensureMap`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319630` | Self: 0.0% (4.3ms) | Total: 0.0% (4.3ms) | Samples: 3

**Called by:**
- `isNameOrNamepathDefiningTag` (2)
- `tagMustHaveTypePosition` (1)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318015` | Self: 0.0% (4.3ms) | Total: 0.0% (4.3ms) | Samples: 3

**Called by:**
- `getNonJsdocComment` (3)

### `parseComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318819` | Self: 0.0% (4.3ms) | Total: 5.9% (268.4ms) | Samples: 3

**Called by:**
- `(anonymous)` (66)
- `(anonymous)` (66)
- `getIndentAndJSDoc` (44)

**Calls:**
- `parse3` (173)

### `decode`
`[native code]` | Self: 0.0% (4.2ms) | Total: 0.0% (4.2ms) | Samples: 3

**Called by:**
- `get source` (3)

### `iterate`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321062` | Self: 0.0% (4.2ms) | Total: 34.9% (1.57s) | Samples: 3

**Called by:**
- `callIterator` (788)
- `checkJsdoc` (201)

**Calls:**
- `(anonymous)` (265)
- `(anonymous)` (137)
- `(anonymous)` (96)
- `(anonymous)` (78)
- `(anonymous)` (73)
- `(anonymous)` (72)
- `(anonymous)` (45)
- `(anonymous)` (20)
- `(anonymous)` (18)
- `(anonymous)` (14)
- `(anonymous)` (10)
- `(anonymous)` (9)
- `(anonymous)` (9)
- `(anonymous)` (8)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (6)
- `(anonymous)` (6)
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

### `parseBlock`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318104` | Self: 0.0% (4.1ms) | Total: 0.0% (4.1ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `/^\s+/`
`[native code]` | Self: 0.0% (3.9ms) | Total: 0.0% (3.9ms) | Samples: 3

**Called by:**
- `[Symbol.match]` (3)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318141` | Self: 0.0% (3.9ms) | Total: 0.0% (3.9ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `getParser4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318439` | Self: 0.0% (3.9ms) | Total: 0.0% (3.9ms) | Samples: 3

**Called by:**
- `parse3` (3)

### `onNodeAllNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321182` | Self: 0.0% (3.6ms) | Total: 0.0% (3.6ms) | Samples: 1

**Called by:**
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (1)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1192` | Self: 0.0% (3.6ms) | Total: 0.0% (3.6ms) | Samples: 3

**Called by:**
- `_makeToken` (3)

### `getCommentsBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3401` | Self: 0.0% (3.6ms) | Total: 0.0% (3.6ms) | Samples: 3

**Called by:**
- `getReducedASTNode` (2)
- `getReducedASTNode` (1)

### `read`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316324` | Self: 0.0% (3.5ms) | Total: 0.1% (5.1ms) | Samples: 2

**Called by:**
- `create` (2)
- `create` (1)

**Calls:**
- `cloneObject` (1)

### `get decorators`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (3.5ms) | Total: 0.0% (3.5ms) | Samples: 2

**Called by:**
- `getDecorator` (2)

### `tryParslets`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314953` | Self: 0.0% (3.5ms) | Total: 0.0% (3.5ms) | Samples: 1

**Called by:**
- `parseIntermediateType` (1)

### `callIterator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321102` | Self: 0.0% (3.5ms) | Total: 0.0% (3.5ms) | Samples: 2

**Called by:**
- `onProgramExit` (2)

### `flatIntoArray`
`[native code]` | Self: 0.0% (3.4ms) | Total: 0.0% (3.4ms) | Samples: 2

**Called by:**
- `flatIntoArrayWithCallback` (2)

### `getBasicUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320233` | Self: 0.0% (3.4ms) | Total: 0.0% (3.4ms) | Samples: 2

**Called by:**
- `callIterator` (1)
- `getUtils` (1)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318008` | Self: 0.0% (3.4ms) | Total: 0.0% (3.4ms) | Samples: 2

**Called by:**
- `getJSDocComment` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317582` | Self: 0.0% (3.4ms) | Total: 2.4% (108.4ms) | Samples: 2

**Called by:**
- `forEach` (69)

**Calls:**
- `cleanUpLastTag` (63)
- `cleanUpLastTag` (3)
- `cleanUpLastTag` (1)

### `/^\/\*\*\s/v`
`[native code]` | Self: 0.0% (3.4ms) | Total: 0.0% (3.4ms) | Samples: 2

**Called by:**
- `callIterator` (2)

### `parseDescription`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318683` | Self: 0.0% (3.3ms) | Total: 4.0% (182.3ms) | Samples: 2

**Called by:**
- `parseInlineTags` (67)
- `parseInlineTags` (51)

**Calls:**
- `matchAll` (61)
- `performIteration` (34)
- `[Symbol.matchAll]` (21)

### `getPreferredTagName`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319509` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `forEachPreferredTag` (1)
- `(anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318131` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:609` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `get decorators` (1)
- `commentsInRange` (1)

### `getText`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `parse`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (3.3ms) | Total: 0.7% (32.9ms) | Samples: 2

**Called by:**
- `g` (21)

**Calls:**
- `Ae` (19)

### `arrayIteratorNextHelper`
`[native code]` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `next` (2)

### `get sticky`
`[native code]` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 1

**Called by:**
- `get flags` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:1` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `_NoParsletFoundError` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318303` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `get decorators`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2143` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `getDecorator` (2)

### `parseSpec`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318169` | Self: 0.0% (3.2ms) | Total: 1.2% (57.4ms) | Samples: 2

**Called by:**
- `map` (38)

**Calls:**
- `(anonymous)` (9)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `getParser2`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318122` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `getParser4` (2)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318140` | Self: 0.0% (3.1ms) | Total: 0.2% (12.4ms) | Samples: 2

**Called by:**
- `(anonymous)` (8)

**Calls:**
- `trimEnd` (3)
- `endsWith` (3)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3634` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `getTokenBefore` (2)

### `accept`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315363` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `parslet` (2)

### `toLocaleLowerCase`
`[native code]` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `read`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316314` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `create` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326239` | Self: 0.0% (3.1ms) | Total: 10.8% (487.2ms) | Samples: 2

**Called by:**
- `bound ` (319)
- `_invokeFused` (2)

**Calls:**
- `checkNonJsdoc` (319)

### `cloneObject`
`[native code]` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `read` (1)
- `(anonymous)` (1)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `_nodeViewRaw` (2)

### `getAncestors`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 1

**Called by:**
- `getUtils` (1)

### `getParser3`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318164` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `getParser4` (2)

### `get decorators`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2168` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `getDecorator` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7680` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318191` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `parseSpec` (2)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1677` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `findJSDocComment` (2)

### `callIterator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321110` | Self: 0.0% (2.9ms) | Total: 0.8% (40.3ms) | Samples: 2

**Called by:**
- `onNodeWithComment` (26)
- `onNodeAllNodes` (1)

**Calls:**
- `getIndentAndJSDoc` (25)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3708` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `report` (1)
- `get value` (1)

### `checkJsdoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321343` | Self: 0.0% (2.9ms) | Total: 2.1% (95.7ms) | Samples: 2

**Called by:**
- `bound checkJsdoc` (62)

**Calls:**
- `getIndentAndJSDoc` (57)
- `getIndentAndJSDoc` (3)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1962` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `getTokenBefore` (2)

### `getReducedASTNode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317864` | Self: 0.0% (2.9ms) | Total: 0.1% (8.9ms) | Samples: 2

**Called by:**
- `getNonJsdocComment` (3)
- `getJSDocComment` (3)

**Calls:**
- `getCommentsBefore` (3)
- `getCommentsBefore` (1)

### `getTokensBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3518` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `findJSDocComment` (2)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `parseSource` (2)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5058` | Self: 0.0% (2.9ms) | Total: 0.7% (35.0ms) | Samples: 2

**Called by:**
- `walkNodes` (22)

**Calls:**
- `bound checkJsdoc` (12)
- `FunctionDeclaration` (4)
- `bound checkNonJsdoc` (3)
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318132` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318152` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `typeTokenizer`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318204` | Self: 0.0% (2.8ms) | Total: 0.0% (4.3ms) | Samples: 1

**Called by:**
- `getParser4` (2)

**Calls:**
- `getJoiner` (1)

### `accept`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315392` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `parslet` (2)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:717` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `commentsInRange` (1)
- `commentsInRange` (1)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318046` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (2)

### `log`
`[native code]` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `setDeps` (2)

### `getParser`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318099` | Self: 0.0% (2.7ms) | Total: 0.0% (4.2ms) | Samples: 2

**Called by:**
- `getParser4` (3)

**Calls:**
- `getFencer` (1)

### `search`
`[native code]` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `get decorators`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2150` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `getDecorator` (2)

### `preserveJoiner`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318429` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317998` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `getJSDocComment` (1)
- `getNonJsdocComment` (1)

### `stripEncapsulatingBrackets`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317351` | Self: 0.0% (2.6ms) | Total: 0.0% (4.1ms) | Samples: 2

**Called by:**
- `cleanUpLastTag` (3)

**Calls:**
- `/\}$/v` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (2.6ms) | Total: 0.0% (2.6ms) | Samples: 2

**Called by:**
- `_fromRunnerReport` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319492` | Self: 0.0% (2.6ms) | Total: 0.0% (2.6ms) | Samples: 2

**Called by:**
- `some` (2)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:590` | Self: 0.0% (2.6ms) | Total: 0.0% (2.6ms) | Samples: 2

**Called by:**
- `parseSource` (2)

### `repeat`
`[native code]` | Self: 0.0% (2.5ms) | Total: 0.0% (2.5ms) | Samples: 2

**Called by:**
- `getIndentAndJSDoc` (2)

### `getUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320461` | Self: 0.0% (2.5ms) | Total: 0.0% (2.5ms) | Samples: 2

**Called by:**
- `iterate` (2)

### `getReducedASTNode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317853` | Self: 0.0% (2.5ms) | Total: 0.0% (2.5ms) | Samples: 2

**Called by:**
- `getNonJsdocComment` (1)
- `getJSDocComment` (1)

### `some`
`[native code]` | Self: 0.0% (2.5ms) | Total: 0.6% (27.7ms) | Samples: 2

**Called by:**
- `hasRejectValue` (4)
- `hasATag` (3)
- `hasTag` (2)
- `validateDescription` (2)
- `hasThrowValue` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `validateParameterNames` (1)

**Calls:**
- `(anonymous)` (4)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `Ae`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (1.8ms) | Total: 0.6% (29.6ms) | Samples: 1

**Called by:**
- `parse` (19)

**Calls:**
- `_e` (18)

### `get multiline`
`[native code]` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `get flags` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:160397` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get argument`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `hasRejectValue` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109700` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getJsdocProcessorPlugin`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_e`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (1.8ms) | Total: 0.8% (38.8ms) | Samples: 1

**Called by:**
- `Ae` (18)
- `(anonymous)` (7)

**Calls:**
- `Pe` (24)

### `getTokenizers`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318759` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `parseComment` (1)

### `hasSchemaOption`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320025` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `exemptSpeciaMethods` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328151` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `some` (1)

### `checkTagName2`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334407` | Self: 0.0% (1.7ms) | Total: 0.0% (3.0ms) | Samples: 1

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:197793` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `parseComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318830` | Self: 0.0% (1.7ms) | Total: 6.7% (302.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (101)
- `(anonymous)` (59)
- `getIndentAndJSDoc` (38)

**Calls:**
- `parseInlineTags` (104)
- `parseInlineTags` (93)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320796` | Self: 0.0% (1.7ms) | Total: 0.1% (6.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `canSkip5` (1)

**Calls:**
- `exemptSpeciaMethods` (1)
- `exemptSpeciaMethods` (1)
- `exemptSpeciaMethods` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319880` | Self: 0.0% (1.7ms) | Total: 0.0% (3.5ms) | Samples: 1

**Called by:**
- `some` (2)

**Calls:**
- `hasThrowValue` (1)

### `preserveJoiner`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318426` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `require`
`[native code]` | Self: 0.0% (1.7ms) | Total: 33.4% (1.50s) | Samples: 1

**Called by:**
- `bound require` (732)

**Calls:**
- `anonymous` (731)

### `parseBlock`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318108` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get declaration`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getDecorator` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:335773` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:199296` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `ownKeys`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `exec`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (3.2ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (2)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (1)

### `addInitialSchemas`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `Ajv` (1)

### `fix10`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330348` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_execReport` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:670` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getCommentsBefore` (1)

### `getUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320846` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `parse2`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317010` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `cleanUpLastTag` (1)

### `getTokensAfter`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3564` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getTokensAfterIgnoringSemis` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:681` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getCommentsBefore` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318405` | Self: 0.0% (1.7ms) | Total: 0.2% (13.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (9)

**Calls:**
- `preserveJoiner` (3)
- `preserveJoiner` (2)
- `preserveJoiner` (1)
- `preserveJoiner` (1)
- `preserveJoiner` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7090` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188300` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320917` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `getCommentsBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3400` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getReducedASTNode` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320333` | Self: 0.0% (1.7ms) | Total: 0.1% (6.5ms) | Samples: 1

**Called by:**
- `_execReport` (4)

**Calls:**
- `(anonymous)` (3)

### `uniqueSymbolParslet`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `tryParslets` (1)

### `readFileSync`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (3.4ms) | Samples: 1

**Called by:**
- `readFileSync` (1)
- `(anonymous)` (1)

**Calls:**
- `readFileSync` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318126` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328156` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `filter` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4163` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `report` (1)

### `cleanUpLastTag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317382` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1653` | Self: 0.0% (1.7ms) | Total: 0.0% (2.9ms) | Samples: 1

**Called by:**
- `getReducedASTNode` (1)
- `findJSDocComment` (1)

**Calls:**
- `_normalizeFilter` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318155` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:183987` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getTokenAfter`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1760` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getTokensAfterIgnoringSemis` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333346` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `splitCR`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318064` | Self: 0.0% (1.7ms) | Total: 0.2% (12.1ms) | Samples: 1

**Called by:**
- `parseSource` (8)

**Calls:**
- `match` (7)

### `join`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318468` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1983` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getTokenBefore` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170686` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328147` | Self: 0.0% (1.6ms) | Total: 0.1% (8.0ms) | Samples: 1

**Called by:**
- `filter` (5)

**Calls:**
- `trimStart` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/dom.js:1798` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `exit`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328985` | Self: 0.0% (1.6ms) | Total: 5.8% (265.4ms) | Samples: 1

**Called by:**
- `map` (137)

**Calls:**
- `parseComment` (66)
- `parseComment` (59)
- `parseComment` (11)

### `getParser4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318444` | Self: 0.0% (1.6ms) | Total: 0.1% (5.9ms) | Samples: 1

**Called by:**
- `parse3` (4)

**Calls:**
- `getParser` (3)

### `syntacticResult`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `@lazy`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `node:crypto` (1)

### `_findLine`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:578` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `getLocFromIndex` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329219` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `flatIntoArrayWithCallback` (1)

### `getDefaultTagStructureForMode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314424` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `getTagStructureForMode` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7986` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7626` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328624` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `some` (1)

### `GetIntrinsic`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318770` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `parseSpec` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3704` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `findJSDocComment` (1)

### `generateNamedReferences`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321752` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318453` | Self: 0.0% (1.6ms) | Total: 1.4% (65.3ms) | Samples: 1

**Called by:**
- `parse3` (41)

**Calls:**
- `parseBlock` (23)
- `parseBlock` (9)
- `parseBlock` (4)
- `parseBlock` (3)
- `parseBlock` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328453` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `get message`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4110` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_fromRunnerReport` (1)

### `toLocaleUpperCase`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get mainToken`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1166` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `get value` (1)

### `find`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.8% (37.8ms) | Samples: 1

**Called by:**
- `getPreferredTagNameSimple` (23)
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (22)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `createTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332389` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `fix10` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:186755` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317889` | Self: 0.0% (1.6ms) | Total: 0.6% (30.2ms) | Samples: 1

**Called by:**
- `findJSDocComment` (20)

**Calls:**
- `getDecorator` (19)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7092` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1230` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_getTokensAndCommentsMerged` (1)

### `getPreferredTagName`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319515` | Self: 0.0% (1.6ms) | Total: 3.4% (155.3ms) | Samples: 1

**Called by:**
- `forEachPreferredTag` (63)
- `(anonymous)` (37)

**Calls:**
- `getPreferredTagNameSimple` (97)
- `getPreferredTagNameSimple` (1)
- `getPreferredTagNameSimple` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320919` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:175338` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get typeAnnotation`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `getParamName` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:232340` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `setParamIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332156` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `split`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295589` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `splitPrefixSuffix` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `getTokenBefore` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318764` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `parseSpec` (1)

### `read`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316312` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `create` (1)

### `normalizeWord`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326871` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `flatIntoArrayWithCallback` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4139` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `report` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1739` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `hasRejectValue` (1)

### `get kind`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2692` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `isGetter2` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7682` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `fill`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `CfgGraph` (1)

### `get key`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3206` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `getParamName` (1)

### `looksLikeExport`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317749` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `getReducedASTNode` (1)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317920` | Self: 0.0% (1.5ms) | Total: 0.9% (41.5ms) | Samples: 1

**Called by:**
- `getJSDocComment` (28)

**Calls:**
- `getReducedASTNode` (16)
- `getReducedASTNode` (5)
- `getReducedASTNode` (3)
- `getReducedASTNode` (2)
- `getReducedASTNode` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/index.js:14` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321228` | Self: 0.0% (1.5ms) | Total: 3.6% (164.2ms) | Samples: 1

**Called by:**
- `_invokeFused` (69)
- `_invokeFused` (37)
- `_invokeFused` (1)

**Calls:**
- `getJSDocComment` (101)
- `getJSDocComment` (2)
- `getJSDocComment` (2)
- `getJSDocComment` (1)

### `get dotAll`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `get flags` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7368` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7689` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/useProvidedPrograms.js:5` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `indexOf`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320955` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1302` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:54196` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `parseSource` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326168` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_execReport` (1)

### `getIndentAndJSDoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321083` | Self: 0.0% (1.5ms) | Total: 0.0% (4.0ms) | Samples: 1

**Called by:**
- `checkJsdoc` (3)

**Calls:**
- `repeat` (2)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5035` | Self: 0.0% (1.5ms) | Total: 9.6% (434.3ms) | Samples: 1

**Called by:**
- `walkNodes` (255)

**Calls:**
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (182)
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (37)
- `bound ` (33)
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320943` | Self: 0.0% (1.5ms) | Total: 0.1% (7.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (4)
- `canSkip6` (1)

**Calls:**
- `(anonymous)` (3)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320638` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `commentsInRange` (1)

### `hasObservableSideEffectsForRegExpMatch`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `[Symbol.match]` (1)

### `getJoiner`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318264` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `typeTokenizer` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_lintSourceOne` (1)

### `onNodeWithComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321178` | Self: 0.0% (1.4ms) | Total: 30.1% (1.35s) | Samples: 1

**Called by:**
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (850)

**Calls:**
- `callIterator` (790)
- `callIterator` (28)
- `callIterator` (26)
- `callIterator` (3)
- `callIterator` (2)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get parent` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:224879` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getBasicUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320245` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `callIterator` (1)

### `createTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `fix10` (1)

### `values`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getPreferredTagNameSimple` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:251511` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `save`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/node.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `enable` (1)

### `extraFnData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get body` (1)

### `getFencer`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318116` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getParser` (1)

### `accept`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315152` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `parslet` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323704` | Self: 0.0% (1.4ms) | Total: 0.0% (2.9ms) | Samples: 1

**Called by:**
- `some` (1)
- `map` (1)

**Calls:**
- `map` (1)

### `clearBuffer`
`internal:streams/writable` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `onConstructed` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3682` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getTokenBefore` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:90804` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `encodeInto`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_encodeSource` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `Parser`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314897` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `parse2` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301184` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320389` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/lib/constants.js:105` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `/\/\*([\s\S]*?)\*\//g`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `exec` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4174` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `report` (1)

### `RegExpParserState`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `RegExpParser` (1)

### `commentParserToESTree`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317363` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `/\}$/v`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `stripEncapsulatingBrackets` (1)

### `get declaration`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3611` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getDecorator` (1)

### `_extractBatchScannable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5141` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildPlan` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:724` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `commentsInRange` (1)

### `isNullSet`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:163634` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `parseRange` (1)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:916` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_symName` (1)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318002` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getJSDocComment` (1)

### `getBasicUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320228` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `callIterator` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1229` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_getAllTokens` (1)

### `getUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320756` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getDecorator` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183916` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320925` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `find` (1)

### `getBasicUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320241` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getUtils` (1)

### `get typeAnnotation`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2827` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getParamName` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317501` | Self: 0.0% (1.4ms) | Total: 0.0% (2.9ms) | Samples: 1

**Called by:**
- `forEach` (2)

**Calls:**
- `cloneObject` (1)

### `invokeHandlersWithNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `invokeMethodFnHandlers` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:656` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getCommentsBefore` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318455` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `parse3` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createIsolatedProgram.js:8` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getParser4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318435` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `parse3` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320801` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `canSkip2` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328146` | Self: 0.0% (1.3ms) | Total: 0.1% (4.7ms) | Samples: 1

**Called by:**
- `filter` (3)

**Calls:**
- `getText` (2)

### `TokenType`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:118` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `kw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318396` | Self: 0.0% (1.3ms) | Total: 0.1% (5.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (3)
- `parseSpec` (1)

**Calls:**
- `splitSpace` (2)
- `splitSpace` (1)

### `iterate`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321046` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `callIterator` (1)

### `checkJsDoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:331856` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `FunctionDeclaration` (1)

### `getTags`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319501` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getAncestors`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3687` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getUtils` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320895` | Self: 0.0% (1.3ms) | Total: 0.0% (2.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `filterTags` (1)

### `_NodeView_LRN`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4132` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317443` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `forEach` (1)

### `callIterator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321103` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `onProgramExit` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4580` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `hasTag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319490` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getPreferredTagName` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7692` | Self: 0.0% (1.3ms) | Total: 0.0% (2.6ms) | Samples: 1

**Called by:**
- `runPlugins` (2)

**Calls:**
- `_resolveHandlers` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332335` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `find` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318143` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:464` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `replace` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318310` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171430` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332415` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `findIndex` (1)

### `push`
`internal:fixed_queue` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `push` (1)

### `p`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_resolveHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `/\s*(@(\S+))(\s*)/`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `[Symbol.match]` (1)

### `parse`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `g` (1)

### `reduce`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (3.9ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4216` | Self: 0.0% (1.3ms) | Total: 0.4% (18.1ms) | Samples: 1

**Called by:**
- `walkNodes` (6)
- `nodeView` (3)
- `get parent` (2)
- `_nodesFromRange` (1)

**Calls:**
- `_NodeView` (5)
- `_NodeView` (3)
- `_NodeView` (2)
- `_NodeView_LRN` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318450` | Self: 0.0% (1.3ms) | Total: 2.7% (123.7ms) | Samples: 1

**Called by:**
- `parse3` (82)

**Calls:**
- `parseSource` (12)
- `parseSource` (10)
- `parseSource` (8)
- `parseSource` (8)
- `parseSource` (8)
- `parseSource` (6)
- `parseSource` (4)
- `parseSource` (4)
- `parseSource` (4)
- `parseSource` (4)
- `parseSource` (3)
- `parseSource` (2)
- `parseSource` (2)
- `parseSource` (2)
- `parseSource` (1)
- `parseSource` (1)
- `parseSource` (1)
- `parseSource` (1)

### `getText`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1333` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `callIterator` (1)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318017` | Self: 0.0% (1.3ms) | Total: 14.8% (669.7ms) | Samples: 1

**Called by:**
- `getNonJsdocComment` (315)
- `getJSDocComment` (124)

**Calls:**
- `findJSDocComment` (415)
- `findJSDocComment` (20)
- `findJSDocComment` (2)
- `findJSDocComment` (1)

### `validateDescription`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327223` | Self: 0.0% (1.2ms) | Total: 0.0% (3.0ms) | Samples: 1

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (1)

### `checkJsDoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `FunctionDeclaration` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2906` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `P`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1187` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_makeToken` (1)

### `_getSharedCaches`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:745` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `SourceCode` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:195339` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7389` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334022` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1972` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `getTokenBefore` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172176` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `commentParserToESTree`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317400` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getBasicUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320264` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `getUtils` (1)

### `ge`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2130` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_getAllTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_getTokensAndCommentsMerged` (1)

### `get decorators`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2198` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `getDecorator` (1)

### `_normalizeFilter`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1599` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `getTokenBefore` (1)

### `preserveJoiner`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318424` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `onNodeWithComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321177` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5010` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_rawTokenText`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `get kind` (1)

### `nameTokenizer`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318276` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `getParser4` (1)

### `_traverse`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/json-schema-traverse/index.js:73` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `commentParserToESTree`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317393` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1977` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `getTokenBefore` (1)

### `De`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `be` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:39` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323805` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `validateParameterNames` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138509` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:40084` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `addMetaSchema`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:152` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `addSchema` (2)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330373` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `report` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7679` | Self: 0.0% (0us) | Total: 0.1% (4.8ms) | Samples: 0

**Called by:**
- `runPlugins` (3)

**Calls:**
- `getDFSEvents` (1)
- `getDFSEvents` (1)
- `getDFSEvents` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333231` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `canSkip` (1)
- `canSkip` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170944` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `maskCodeBlocks`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322840` | Self: 0.0% (0us) | Total: 0.0% (4.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `replaceAll` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319260` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `map` (2)

**Calls:**
- `getParamName` (1)
- `getParamName` (1)

### `Ajv`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:76` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `addInitialSchemas` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330138` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createIsolatedProgram.js:41` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321539` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `copyDataProperties` (1)

### `validateParameterNames`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323543` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `some` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:133286` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `hasThrowValue`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319893` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `hasThrowValue` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289715` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289592` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `canSkip5`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334196` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getNonJsdocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317952` | Self: 0.0% (0us) | Total: 10.8% (490.1ms) | Samples: 0

**Called by:**
- `checkNonJsdoc` (323)

**Calls:**
- `findJSDocComment` (315)
- `findJSDocComment` (3)
- `findJSDocComment` (2)
- `findJSDocComment` (2)
- `findJSDocComment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint/plugin-kit/dist/cjs/index.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109002` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getTokensAfterIgnoringSemis`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317961` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `tokenAfterIgnoringSemis` (1)

**Calls:**
- `getTokenAfter` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:105264` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171395` | Self: 0.0% (0us) | Total: 2.0% (92.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (19)

**Calls:**
- `bound require` (19)

### `_recomposeAuthority`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js:960` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `serialize` (1)

**Calls:**
- `_normalizeIPv4` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:10` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:249011` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183945` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:200894` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `defineProperty` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327245` | Self: 0.0% (0us) | Total: 0.3% (15.2ms) | Samples: 0

**Called by:**
- `iterate` (10)

**Calls:**
- `(anonymous)` (10)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332133` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `parseIntermediateType`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314938` | Self: 0.0% (0us) | Total: 0.3% (17.0ms) | Samples: 0

**Called by:**
- `parseType` (10)

**Calls:**
- `tryParslets` (9)
- `tryParslets` (1)

### `commentParserToESTree`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317399` | Self: 0.0% (0us) | Total: 0.1% (7.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)
- `(anonymous)` (1)

**Calls:**
- `map` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330342` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `some` (1)

**Calls:**
- `extractSentences` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint/config-array/dist/cjs/index.cjs:7` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317604` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:29` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:193444` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/esquery.js:12` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `parse2`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317017` | Self: 0.0% (0us) | Total: 1.9% (85.9ms) | Samples: 0

**Called by:**
- `cleanUpLastTag` (54)
- `(anonymous)` (1)

**Calls:**
- `parse` (55)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320860` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `getTagStructureForMode` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:186764` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:37` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `tryParsePathIgnoreError`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336765` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `validNamepathParsing` (1)

**Calls:**
- `parseNamePath` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171770` | Self: 0.0% (0us) | Total: 2.0% (94.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (20)

**Calls:**
- `(anonymous)` (20)

### `fix10`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332411` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `fixer` (2)

**Calls:**
- `findExpectedIndex` (1)
- `findExpectedIndex` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317469` | Self: 0.0% (0us) | Total: 0.2% (12.3ms) | Samples: 0

**Called by:**
- `forEach` (7)

**Calls:**
- `copyDataProperties` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/json-schema-traverse/index.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `resolveIds` (1)

**Calls:**
- `_traverse` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:263612` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:312925` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (2)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:274` | Self: 0.0% (0us) | Total: 81.8% (3.68s) | Samples: 0

**Called by:**
- `(anonymous)` (2378)

**Calls:**
- `runPlugins` (2315)
- `runPlugins` (58)
- `runPlugins` (3)
- `runPlugins` (1)
- `runPlugins` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:53` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `onProgramExit`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321193` | Self: 0.0% (0us) | Total: 0.3% (16.1ms) | Samples: 0

**Called by:**
- `Program:exit` (10)

**Calls:**
- `filter` (10)

### `exemptSpeciaMethods`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320033` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isGetter2` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170909` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301172` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `addPolyfillToken` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190552` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `getPreferredTagName`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319517` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `forEachPreferredTag` (1)

**Calls:**
- `hasTag` (1)

### `splitPrefixSuffix`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295678` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `camelCase` (1)

**Calls:**
- `split` (1)

### `descriptionIsRedundant`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326955` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `areDocsInformative` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/analyze.js:5` | Self: 0.0% (0us) | Total: 0.2% (11.1ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:168171` | Self: 0.0% (0us) | Total: 1.6% (76.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (51)

**Calls:**
- `bound require` (51)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301164` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `join` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:108970` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/clear-caches.js:5` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289518` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `findIndex`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `findExpectedIndex` (1)
- `fix10` (1)

**Calls:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `onConstruct`
`internal:streams/destroy:144` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `processTicksAndRejections` (1)

**Calls:**
- `emit` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318800` | Self: 0.0% (0us) | Total: 0.2% (11.6ms) | Samples: 0

**Called by:**
- `parseSpec` (8)

**Calls:**
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:263508` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320896` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `WriteStream`
`internal:fs/streams:245` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `Writable` (1)

### `forEach`
`[native code]` | Self: 0.0% (0us) | Total: 3.1% (143.2ms) | Samples: 0

**Called by:**
- `commentParserToESTree` (90)
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (69)
- `(anonymous)` (8)
- `(anonymous)` (7)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `canSkip2`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333328` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:23` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/index.js:4` | Self: 0.0% (0us) | Total: 0.2% (11.1ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1282` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_findDefNode` (1)

**Calls:**
- `get value` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321264` | Self: 0.0% (0us) | Total: 3.5% (157.9ms) | Samples: 0

**Called by:**
- `_invokeFused` (104)

**Calls:**
- `(anonymous)` (104)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:168347` | Self: 0.0% (0us) | Total: 1.6% (76.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (51)

**Calls:**
- `(anonymous)` (51)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:43` | Self: 0.0% (0us) | Total: 0.3% (14.4ms) | Samples: 0

**Called by:**
- `anonymous` (9)

**Calls:**
- `bound require` (9)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` | Self: 0.0% (0us) | Total: 0.5% (24.5ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (13)

**Calls:**
- `AstView` (5)
- `AstView` (3)
- `AstView` (2)
- `AstView` (2)
- `AstView` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:245304` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `addPolyfillToken`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301138` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `camelCase` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/definition/index.js:22` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1746` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `hasRejectValue` (1)

**Calls:**
- `_nodesFromRange` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201916` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328145` | Self: 0.0% (0us) | Total: 3.5% (157.9ms) | Samples: 0

**Called by:**
- `Program:exit` (104)

**Calls:**
- `filter` (104)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188336` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:123` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173265` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321136` | Self: 0.0% (0us) | Total: 0.9% (43.5ms) | Samples: 0

**Called by:**
- `every` (28)

**Calls:**
- `(anonymous)` (22)
- `(anonymous)` (4)
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190544` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:325988` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/traverser.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201883` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:108935` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326241` | Self: 0.0% (0us) | Total: 12.5% (565.4ms) | Samples: 0

**Called by:**
- `bound ` (372)

**Calls:**
- `checkNonJsdocAfter` (372)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7822` | Self: 0.0% (0us) | Total: 10.1% (456.5ms) | Samples: 0

**Called by:**
- `runPlugins` (296)

**Calls:**
- `invokeMethodFnHandlers` (295)
- `invokeMethodFnHandlers` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329665` | Self: 0.0% (0us) | Total: 0.1% (4.9ms) | Samples: 0

**Called by:**
- `flatIntoArrayWithCallback` (3)

**Calls:**
- `filter` (3)

### `getTagStructureForMode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319665` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `getDefaultTagStructureForMode` (1)
- `getDefaultTagStructureForMode` (1)
- `getDefaultTagStructureForMode` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330547` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `bound checkNonJsdoc`
`[native code]` | Self: 0.0% (0us) | Total: 0.5% (25.3ms) | Samples: 0

**Called by:**
- `_invokeFused` (11)
- `invokeHandlersWithNode` (3)
- `_invokeFused` (3)

**Calls:**
- `checkNonJsdoc` (14)
- `checkNonJsdoc` (3)

### `getParamName`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319229` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `get typeAnnotation` (1)
- `get typeAnnotation` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:196155` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/private/tmp/prof_jsdoc.js:5` | Self: 0.0% (0us) | Total: 0.2% (11.9ms) | Samples: 0

**Called by:**
- `parseModule` (8)

**Calls:**
- `bound require` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170721` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236367` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317602` | Self: 0.0% (0us) | Total: 0.1% (6.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `commentParserToESTree` (3)
- `commentParserToESTree` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320242` | Self: 0.0% (0us) | Total: 0.2% (11.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)
- `(anonymous)` (3)

**Calls:**
- `isNameOrNamepathDefiningTag` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289691` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:261167` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/TypeVisitor.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228067` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:22285` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `RegExpParser` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318127` | Self: 0.0% (0us) | Total: 0.3% (18.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (12)

**Calls:**
- `seedTokens` (12)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320332` | Self: 0.0% (0us) | Total: 0.1% (7.4ms) | Samples: 0

**Called by:**
- `_execReport` (5)

**Calls:**
- `fixer` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/index.js:20` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/dotjs/index.js:7` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:254651` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:198766` | Self: 0.0% (0us) | Total: 0.4% (19.8ms) | Samples: 0

**Called by:**
- `anonymous` (13)

**Calls:**
- `(anonymous)` (8)
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

### `getSettings`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320989` | Self: 0.0% (0us) | Total: 0.0% (4.1ms) | Samples: 0

**Called by:**
- `create` (2)
- `create` (1)

**Calls:**
- `setTagStructure` (3)

### `getParser4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318445` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `parse3` (2)

**Calls:**
- `getParser3` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201851` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289692` | Self: 0.0% (0us) | Total: 0.1% (8.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `(anonymous)` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:54` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `createDebug`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12070` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `useColors` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172342` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320815` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `tagMightHaveTypePosition` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:674` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (1)
- `getAllComments` (1)

**Calls:**
- `_findLineIdx` (1)
- `_findLineIdx` (1)

### `parseRange`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:163574` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `isNullSet` (1)

### `parseRange`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:163572` | Self: 0.0% (0us) | Total: 1.3% (61.2ms) | Samples: 0

**Called by:**
- `map` (2)

**Calls:**
- `map` (2)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:331945` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `checkJsDoc` (1)

**Calls:**
- `get loc` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320367` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `validateDescription` (1)
- `(anonymous)` (1)

**Calls:**
- `getRegexFromString` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:324401` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:19` | Self: 0.0% (0us) | Total: 0.2% (10.9ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `parseInlineTags`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318702` | Self: 0.0% (0us) | Total: 3.5% (161.4ms) | Samples: 0

**Called by:**
- `parseComment` (104)

**Calls:**
- `parseDescription` (67)
- `parseDescription` (37)

### `filterTags`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319496` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `filter` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138274` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201869` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333359` | Self: 0.0% (0us) | Total: 0.0% (4.4ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332129` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/scope/index.js:20` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313246` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170730` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:182108` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:152902` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-estree.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301100` | Self: 0.0% (0us) | Total: 0.2% (9.0ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `(anonymous)` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:325968` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:202779` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96798` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329133` | Self: 0.0% (0us) | Total: 0.6% (27.9ms) | Samples: 0

**Called by:**
- `iterate` (18)

**Calls:**
- `Set` (14)
- `get` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332173` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `findIndex` (1)

**Calls:**
- `some` (1)

### `get identifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:795` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `defs` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/cli-engine/lint-result-cache.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `forEachPreferredTag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319537` | Self: 0.0% (0us) | Total: 2.2% (101.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (65)

**Calls:**
- `getPreferredTagName` (63)
- `getPreferredTagName` (1)
- `getPreferredTagName` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332757` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334120` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `shouldReport` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2137` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `_symName` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326148` | Self: 0.0% (0us) | Total: 0.1% (4.6ms) | Samples: 0

**Called by:**
- `reportings` (3)

**Calls:**
- `report` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289574` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:46` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327259` | Self: 0.0% (0us) | Total: 0.6% (30.8ms) | Samples: 0

**Called by:**
- `iterate` (20)

**Calls:**
- `(anonymous)` (20)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/useProvidedPrograms.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-modifiers.js:39` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_NoParsletFoundError`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314669` | Self: 0.0% (0us) | Total: 0.7% (32.0ms) | Samples: 0

**Called by:**
- `parseIntermediateType` (21)

**Calls:**
- `Error` (19)
- `(anonymous)` (2)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1765` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `hasRejectValue` (1)

**Calls:**
- `extraFnData` (1)

### `node:crypto`
`node:crypto:39` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `@lazy` (1)

### `parseComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318820` | Self: 0.0% (0us) | Total: 1.5% (69.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (11)

**Calls:**
- `getTokenizers` (10)
- `getTokenizers` (1)

### `reportings`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326186` | Self: 0.0% (0us) | Total: 0.1% (4.6ms) | Samples: 0

**Called by:**
- `checkNonJsdoc` (3)

**Calls:**
- `report` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172213` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/index.js:18` | Self: 0.0% (0us) | Total: 0.2% (12.8ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4161` | Self: 0.0% (0us) | Total: 0.4% (20.3ms) | Samples: 0

**Called by:**
- `report` (13)

**Calls:**
- `(anonymous)` (5)
- `(anonymous)` (4)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `fix10` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290383` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12341` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:16` | Self: 0.0% (0us) | Total: 1.5% (70.8ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createIsolatedProgram.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `Range`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:42` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `satisfies` (1)

**Calls:**
- `map` (1)

### `get decorators`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2158` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `getDecorator` (1)

**Calls:**
- `source` (1)

### `onConstructed`
`internal:streams/writable:168` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `clearBuffer` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201898` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `resolveIds`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:235` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_addSchema` (1)

**Calls:**
- `_getFullPath` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/index.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/file-entry-cache/cache.js:2` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:46` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334099` | Self: 0.0% (0us) | Total: 0.2% (11.0ms) | Samples: 0

**Called by:**
- `iterate` (6)

**Calls:**
- `(anonymous)` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/dotjs/index.js:27` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/index.js:3` | Self: 0.0% (0us) | Total: 0.3% (16.5ms) | Samples: 0

**Called by:**
- `anonymous` (11)

**Calls:**
- `bound require` (11)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/apply-disable-directives.js:22` | Self: 0.0% (0us) | Total: 0.3% (13.7ms) | Samples: 0

**Called by:**
- `anonymous` (9)

**Calls:**
- `bound require` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295642` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `toLocaleLowerCase` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:288284` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getParser4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318443` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `parse3` (2)

**Calls:**
- `getParser2` (2)

### `_getOrBuildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6160` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_buildPlan` (1)

### `node:assert/strict`
`node:assert/strict:3` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `isGetter2`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320000` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `exemptSpeciaMethods` (1)

**Calls:**
- `get kind` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190010` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:94` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295645` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `toLocaleUpperCase` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228442` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/fdir/dist/index.cjs:462` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6483` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_getOrBuildPlan` (1)

**Calls:**
- `_extractBatchScannable` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:106842` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313084` | Self: 0.0% (0us) | Total: 1.4% (63.9ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `(anonymous)` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161364` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289746` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:279762` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321034` | Self: 0.0% (0us) | Total: 0.3% (17.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (10)
- `report` (1)

**Calls:**
- `report` (11)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173278` | Self: 0.0% (0us) | Total: 2.2% (101.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (25)

**Calls:**
- `(anonymous)` (25)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289675` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320887` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getTags` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:108774` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/private/tmp/prof_jsdoc.js:2` | Self: 0.0% (0us) | Total: 0.0% (3.6ms) | Samples: 0

**Called by:**
- `parseModule` (2)

**Calls:**
- `bound require` (2)

### `setup`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/common.js:287` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `enable` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:285267` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `defineProperty` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330427` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260470` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:279823` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164405` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289551` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:279` | Self: 0.0% (0us) | Total: 0.1% (5.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `map` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:266522` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `tagMustHaveTypePosition`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319687` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `tagMightHaveTypePosition` (1)

**Calls:**
- `ensureMap` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289485` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `setTagStructure`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319142` | Self: 0.0% (0us) | Total: 0.0% (4.1ms) | Samples: 0

**Called by:**
- `getSettings` (3)

**Calls:**
- `getDefaultTagStructureForMode` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109710` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201872` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/warnAboutTSVersion.js:42` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323797` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:19` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `Ajv` (1)

### `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321231` | Self: 0.0% (0us) | Total: 30.1% (1.35s) | Samples: 0

**Called by:**
- `_invokeFused` (669)
- `_invokeFused` (182)

**Calls:**
- `onNodeWithComment` (850)
- `onNodeWithComment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334432` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `canSkip6` (1)

### `getCommentsBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3421` | Self: 0.0% (0us) | Total: 0.1% (6.5ms) | Samples: 0

**Called by:**
- `getReducedASTNode` (3)
- `getReducedASTNode` (1)

**Calls:**
- `commentsInRange` (1)
- `commentsInRange` (1)
- `commentsInRange` (1)
- `commentsInRange` (1)

### `fix10`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332418` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `fixer` (2)

**Calls:**
- `createTokens` (1)
- `createTokens` (1)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1948` | Self: 0.0% (0us) | Total: 0.4% (18.7ms) | Samples: 0

**Called by:**
- `getTokenBefore` (12)

**Calls:**
- `getAllComments` (12)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/resolveProjectList.js:10` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:282715` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:254565` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:42` | Self: 0.0% (0us) | Total: 1.5% (70.8ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `(anonymous)` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:217672` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173080` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173043` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `defineProperty` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313118` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `hasRejectValue`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333184` | Self: 0.0% (0us) | Total: 0.1% (5.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `hasRejectValue` (2)
- `hasRejectValue` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260568` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161607` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171459` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:271957` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `parse` (1)

### `checkNonJsdoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326197` | Self: 0.0% (0us) | Total: 11.2% (504.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (319)
- `bound checkNonJsdoc` (14)

**Calls:**
- `getNonJsdocComment` (323)
- `getNonJsdocComment` (10)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:217432` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:609` | Self: 0.0% (0us) | Total: 0.0% (4.2ms) | Samples: 0

**Called by:**
- `runPlugins` (3)

**Calls:**
- `decode` (3)

### `read`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316320` | Self: 0.0% (0us) | Total: 0.1% (4.6ms) | Samples: 0

**Called by:**
- `create` (2)
- `create` (1)

**Calls:**
- `stringSplitFast` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201890` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173277` | Self: 0.0% (0us) | Total: 0.3% (17.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (11)

**Calls:**
- `bound require` (11)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:193438` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326875` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `flatIntoArrayWithCallback` (1)

**Calls:**
- `stringSplitFast` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `parseComparator`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:264` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `replaceXRanges` (1)

### `flatMap`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (6.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)
- `(anonymous)` (1)

**Calls:**
- `flatIntoArrayWithCallback` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-modifiers.js:38` | Self: 0.0% (0us) | Total: 0.1% (6.2ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `bound require` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:263437` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4102` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_fromRunnerReport` (1)

**Calls:**
- `getLocFromIndex` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172432` | Self: 0.0% (0us) | Total: 2.1% (98.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (23)

**Calls:**
- `(anonymous)` (23)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289699` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228544` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201848` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:14` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326636` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:199307` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172574` | Self: 0.0% (0us) | Total: 2.1% (98.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (23)

**Calls:**
- `(anonymous)` (23)

### `read`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316318` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `create` (1)

**Calls:**
- `identifierRule` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:220834` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326977` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `descriptionIsRedundant` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329668` | Self: 0.0% (0us) | Total: 0.1% (4.9ms) | Samples: 0

**Called by:**
- `filter` (3)

**Calls:**
- `(anonymous)` (3)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316300` | Self: 0.0% (0us) | Total: 0.1% (7.9ms) | Samples: 0

**Called by:**
- `parse2` (5)

**Calls:**
- `read` (2)
- `read` (2)
- `read` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:285349` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295653` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/index.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

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

### `splitSpace`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318068` | Self: 0.0% (0us) | Total: 0.5% (24.0ms) | Samples: 0

**Called by:**
- `parseSource` (7)
- `parseSource` (6)
- `(anonymous)` (2)
- `parseSource` (1)

**Calls:**
- `match` (16)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330450` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `validateDescription` (2)

### `parse2`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317002` | Self: 0.0% (0us) | Total: 0.3% (17.7ms) | Samples: 0

**Called by:**
- `cleanUpLastTag` (11)

**Calls:**
- `create` (5)
- `create` (5)
- `Parser` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:8678` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201879` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334230` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `canSkip5` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/unsupported-api.js:14` | Self: 0.0% (0us) | Total: 0.7% (35.4ms) | Samples: 0

**Called by:**
- `anonymous` (23)

**Calls:**
- `bound require` (23)

### `extractSentences`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330307` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `map` (1)

### `checkTagName`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334199` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173238` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138488` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326798` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `setDeps` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320328` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329659` | Self: 0.0% (0us) | Total: 2.5% (114.6ms) | Samples: 0

**Called by:**
- `iterate` (72)

**Calls:**
- `filter` (72)

### `findExpectedIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332183` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `fix10` (1)

**Calls:**
- `filter` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161321` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289536` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295654` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `node:tty`
`node:tty:6` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:21` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320754` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isConstructor` (1)

### `hasThrowValue`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319876` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `hasThrowValue` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:182072` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `defineProperty` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326038` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2357` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `_buildVariable` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333895` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:45765` | Self: 0.0% (0us) | Total: 0.0% (4.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:312910` | Self: 0.0% (0us) | Total: 0.1% (6.9ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `(anonymous)` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/index.js:17` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/source-code-traverser.js:12` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:182101` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `Range`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:163502` | Self: 0.0% (0us) | Total: 1.3% (62.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `map` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:324241` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/node-utils.js:76` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `parse`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314928` | Self: 0.0% (0us) | Total: 1.9% (85.9ms) | Samples: 0

**Called by:**
- `parse2` (55)

**Calls:**
- `parseType` (55)

### `_addSchema`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:309` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `addSchema` (2)

**Calls:**
- `resolveIds` (1)
- `resolveIds` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333081` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318417` | Self: 0.0% (0us) | Total: 0.1% (5.9ms) | Samples: 0

**Called by:**
- `map` (4)

**Calls:**
- `trim` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:325960` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313125` | Self: 0.0% (0us) | Total: 0.6% (30.6ms) | Samples: 0

**Called by:**
- `anonymous` (20)

**Calls:**
- `(anonymous)` (20)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 33.7% (1.51s) | Samples: 0

**Called by:**
- `_loadBundle` (270)
- `(anonymous)` (51)
- `(anonymous)` (23)
- `(anonymous)` (23)
- `(anonymous)` (19)
- `(anonymous)` (19)
- `(anonymous)` (17)
- `(anonymous)` (14)
- `(anonymous)` (11)
- `(anonymous)` (11)
- `(anonymous)` (11)
- `(anonymous)` (9)
- `(anonymous)` (9)
- `(anonymous)` (9)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (3)
- `patchAstUtils` (3)
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
- `getESLintCoreRule` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
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
- `require` (732)
- `anonymous` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318210` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)
- `parseSpec` (1)

**Calls:**
- `next` (2)

### `getLocFromIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3658` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `get loc` (1)

**Calls:**
- `_findLine` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:104236` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:10` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/index.js:26` | Self: 0.0% (0us) | Total: 0.2% (12.8ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `onProgramExit`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321194` | Self: 0.0% (0us) | Total: 1.0% (46.2ms) | Samples: 0

**Called by:**
- `Program:exit` (29)

**Calls:**
- `callIterator` (24)
- `callIterator` (2)
- `callIterator` (2)
- `callIterator` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313079` | Self: 0.0% (0us) | Total: 0.0% (3.4ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333683` | Self: 0.0% (0us) | Total: 0.2% (10.9ms) | Samples: 0

**Called by:**
- `iterate` (6)

**Calls:**
- `(anonymous)` (6)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4559` | Self: 0.0% (0us) | Total: 1.4% (66.8ms) | Samples: 0

**Called by:**
- `runPlugins` (43)

**Calls:**
- `create` (43)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171467` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12521` | Self: 0.0% (0us) | Total: 0.0% (4.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `(anonymous)` (2)
- `createDebug` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5043` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `get parent` (1)

### `hasRejectValue`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333150` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get body` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228703` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91300` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getDefaultTagStructureForMode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313577` | Self: 0.0% (0us) | Total: 0.1% (5.4ms) | Samples: 0

**Called by:**
- `setTagStructure` (3)
- `getTagStructureForMode` (1)

**Calls:**
- `Map` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:8673` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getNodeSystem` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333102` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `emit`
`node:events:92` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `onConstruct` (1)

**Calls:**
- `bound onceWrapper` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319365` | Self: 0.0% (0us) | Total: 0.1% (4.5ms) | Samples: 0

**Called by:**
- `map` (3)

**Calls:**
- `getParamName` (2)
- `getParamName` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8202` | Self: 0.0% (0us) | Total: 1.9% (88.0ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (58)

**Calls:**
- `buildVisitorMap` (43)
- `buildVisitorMap` (14)
- `buildVisitorMap` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:90441` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `reduce` (1)

**Calls:**
- `reduce` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:215829` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332098` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333234` | Self: 0.0% (0us) | Total: 0.2% (13.3ms) | Samples: 0

**Called by:**
- `iterate` (9)

**Calls:**
- `(anonymous)` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164515` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/types/dist/index.js:21` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `hasTag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319491` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `some` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201839` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_loadBundle`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-loader.js:34` | Self: 0.0% (0us) | Total: 11.9% (537.5ms) | Samples: 0

**Called by:**
- `bundleRulesFor` (270)

**Calls:**
- `bound require` (270)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:47` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:673` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (1)
- `getAllComments` (1)

**Calls:**
- `_findLineIdx` (1)
- `_findLineIdx` (1)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317911` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `findJSDocComment` (1)

**Calls:**
- `get loc` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319497` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `filter` (1)

**Calls:**
- `(anonymous)` (1)

### `nextTick`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `construct` (1)

**Calls:**
- `push` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4682` | Self: 0.0% (0us) | Total: 0.4% (19.8ms) | Samples: 0

**Called by:**
- `runPlugins` (14)

**Calls:**
- `create` (11)
- `create` (2)
- `create` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201828` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/index.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/clear-caches.js:6` | Self: 0.0% (0us) | Total: 1.9% (89.6ms) | Samples: 0

**Called by:**
- `anonymous` (17)

**Calls:**
- `bound require` (17)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `matchAll`
`[native code]` | Self: 0.0% (0us) | Total: 3.7% (167.9ms) | Samples: 0

**Called by:**
- `parseDescription` (61)
- `parseDescription` (49)

**Calls:**
- `get flags` (94)
- `esSpecIsRegExp` (12)
- `stringIncludesInternal` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172205` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `read`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316315` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `create` (1)

**Calls:**
- `trimStart` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2348` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (2)

**Calls:**
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/index.js:27` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4251` | Self: 0.0% (0us) | Total: 0.1% (4.5ms) | Samples: 0

**Called by:**
- `get parent` (3)

**Calls:**
- `_nodeViewRaw` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317601` | Self: 0.0% (0us) | Total: 0.7% (34.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (22)

**Calls:**
- `g` (22)

### `getESLintCoreRule`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:174801` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318471` | Self: 0.0% (0us) | Total: 0.1% (6.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)
- `map` (1)

**Calls:**
- `map` (2)
- `join` (1)
- `join` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137246` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91298` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:276524` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328954` | Self: 0.0% (0us) | Total: 0.1% (6.1ms) | Samples: 0

**Called by:**
- `iterate` (4)

**Calls:**
- `get globalScope` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:12` | Self: 0.0% (0us) | Total: 0.2% (9.7ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:277070` | Self: 0.0% (0us) | Total: 0.1% (8.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `(anonymous)` (5)

### `SemVer`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:162894` | Self: 0.0% (0us) | Total: 1.3% (61.2ms) | Samples: 0

**Called by:**
- `parse` (2)

**Calls:**
- `match` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201859` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/index.js:3` | Self: 0.0% (0us) | Total: 0.1% (6.1ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `bound require` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321370` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `exit` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:29` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `addMetaSchema` (2)

### `parse`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:163894` | Self: 0.0% (0us) | Total: 1.3% (61.2ms) | Samples: 0

**Called by:**
- `Comparator` (2)

**Calls:**
- `SemVer` (2)

### `every`
`[native code]` | Self: 0.0% (0us) | Total: 0.9% (43.5ms) | Samples: 0

**Called by:**
- `callIterator` (28)

**Calls:**
- `(anonymous)` (28)

### `preserveJoiner`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318427` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `endsWith` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:202870` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getNodeSystem`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:8288` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isFileSystemCaseSensitive` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322864` | Self: 0.0% (0us) | Total: 0.2% (10.0ms) | Samples: 0

**Called by:**
- `iterate` (7)

**Calls:**
- `maskCodeBlocks` (4)
- `maskCodeBlocks` (3)

### `canSkip`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333220` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332924` | Self: 0.0% (0us) | Total: 0.0% (4.2ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `(anonymous)` (3)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318147` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `trimEnd` (1)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:455` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/lazy-loading-rule-map.js:7` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164605` | Self: 0.0% (0us) | Total: 1.4% (63.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `(anonymous)` (4)

### `toggleFence`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318100` | Self: 0.0% (0us) | Total: 0.8% (38.6ms) | Samples: 0

**Called by:**
- `parseBlock` (23)

**Calls:**
- `(anonymous)` (23)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290029` | Self: 0.0% (0us) | Total: 0.9% (42.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (27)

**Calls:**
- `(anonymous)` (27)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290133` | Self: 0.0% (0us) | Total: 0.0% (4.4ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `(anonymous)` (3)

### `get globalScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3938` | Self: 0.0% (0us) | Total: 0.1% (6.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `_precomputeScopes` (2)
- `_precomputeScopes` (1)
- `_precomputeScopes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172354` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:254636` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:231254` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:337705` | Self: 0.0% (0us) | Total: 0.9% (42.1ms) | Samples: 0

**Called by:**
- `anonymous` (27)

**Calls:**
- `(anonymous)` (27)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:238796` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `checkJsDoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:331972` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `FunctionDeclaration` (2)

**Calls:**
- `report` (1)
- `report` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138699` | Self: 0.0% (0us) | Total: 0.1% (4.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172347` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `canSkip4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334086` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332174` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `some` (1)

**Calls:**
- `endsWith` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:180669` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getESLintCoreRule` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/warnAboutTSVersion.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12515` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `bound onceWrapper`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `emit` (1)

**Calls:**
- `(anonymous)` (1)

### `getUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320280` | Self: 0.0% (0us) | Total: 0.3% (15.1ms) | Samples: 0

**Called by:**
- `iterate` (9)

**Calls:**
- `getAncestors` (7)
- `getAncestors` (1)
- `getAncestors` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322296` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `callIterator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321101` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `onNodeWithComment` (3)

**Calls:**
- `getBasicUtils` (1)
- `getBasicUtils` (1)
- `getBasicUtils` (1)

### `getParser4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318438` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `parse3` (1)

**Calls:**
- `nameTokenizer` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/warnAboutTSVersion.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301150` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `camelCase` (1)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1947` | Self: 0.0% (0us) | Total: 10.1% (456.7ms) | Samples: 0

**Called by:**
- `getTokenBefore` (299)

**Calls:**
- `_getAllTokens` (292)
- `_getAllTokens` (6)
- `_getAllTokens` (1)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317897` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `findJSDocComment` (2)

**Calls:**
- `getTokensBefore` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:175348` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289491` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `node:fs/promises`
`node:fs/promises:2` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/es2020.js:9` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313032` | Self: 0.0% (0us) | Total: 0.1% (4.8ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `(anonymous)` (3)

### `cleanUpLastTag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317375` | Self: 0.0% (0us) | Total: 2.4% (111.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (63)
- `(anonymous)` (8)

**Calls:**
- `parse2` (54)
- `parse2` (11)
- `parse2` (5)
- `parse2` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321771` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `generateNamedReferences` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:212974` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `checkJsdoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321347` | Self: 0.0% (0us) | Total: 7.5% (341.2ms) | Samples: 0

**Called by:**
- `bound checkJsdoc` (221)

**Calls:**
- `iterate` (201)
- `iterate` (20)

### `enable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/common.js:163` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `setup` (1)

**Calls:**
- `save` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321242` | Self: 0.0% (0us) | Total: 1.3% (62.3ms) | Samples: 0

**Called by:**
- `_invokeFused` (39)

**Calls:**
- `onProgramExit` (29)
- `onProgramExit` (10)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336920` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `map` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290190` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171549` | Self: 0.0% (0us) | Total: 2.0% (92.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (19)

**Calls:**
- `(anonymous)` (19)

### `validateDescription`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330341` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `some` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92620` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `onNodeAllNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321189` | Self: 0.0% (0us) | Total: 0.1% (4.8ms) | Samples: 0

**Called by:**
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (3)

**Calls:**
- `callIterator` (2)
- `callIterator` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318767` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `parseSpec` (2)

**Calls:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:217317` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:195736` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:21` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:110317` | Self: 0.0% (0us) | Total: 0.1% (5.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `(anonymous)` (3)

### `ke`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 1.2% (57.1ms) | Samples: 0

**Called by:**
- `we` (37)

**Calls:**
- `(anonymous)` (37)

### `findExpectedIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332166` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `fix10` (1)

**Calls:**
- `findIndex` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334096` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `canSkip4` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2480` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (2)

**Calls:**
- `exec` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328984` | Self: 0.0% (0us) | Total: 5.8% (265.4ms) | Samples: 0

**Called by:**
- `iterate` (137)

**Calls:**
- `map` (137)

### `canSkip6`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334404` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:271642` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `parse` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333347` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `canSkip2` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:16` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:192394` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `ownKeys` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1261` | Self: 0.0% (0us) | Total: 0.2% (12.1ms) | Samples: 0

**Called by:**
- `getReducedASTNode` (8)

**Calls:**
- `nodeView` (3)
- `_nodeViewRaw` (2)
- `nodeView` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326642` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328150` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `filter` (2)

**Calls:**
- `some` (2)

### `getParamName`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319320` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get key` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289528` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/tinyglobby/dist/index.cjs:27` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:20` | Self: 0.0% (0us) | Total: 0.1% (6.1ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `bound require` (4)

### `internal:streams/pipeline`
`internal:streams/pipeline:2` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `resolveIds`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:239` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_addSchema` (1)

**Calls:**
- `(anonymous)` (1)

### `getReducedASTNode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317831` | Self: 0.0% (0us) | Total: 0.2% (12.1ms) | Samples: 0

**Called by:**
- `getJSDocComment` (5)
- `getNonJsdocComment` (3)

**Calls:**
- `get parent` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109025` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `parseInlineTags`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318705` | Self: 0.0% (0us) | Total: 3.0% (139.6ms) | Samples: 0

**Called by:**
- `parseComment` (93)

**Calls:**
- `parseDescription` (51)
- `parseDescription` (42)

### `getPreferredTagNameSimple`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319458` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `getPreferredTagName` (1)

**Calls:**
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332851` | Self: 0.0% (0us) | Total: 0.1% (6.3ms) | Samples: 0

**Called by:**
- `iterate` (4)

**Calls:**
- `(anonymous)` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320790` | Self: 0.0% (0us) | Total: 0.1% (5.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)
- `canSkip` (1)
- `(anonymous)` (1)
- `canSkip2` (1)

**Calls:**
- `(anonymous)` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:288465` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301151` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `map` (2)

**Calls:**
- `camelCase` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320742` | Self: 0.0% (0us) | Total: 0.1% (4.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)
- `(anonymous)` (1)

**Calls:**
- `getFunctionParameterNames` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295625` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `map` (2)

**Calls:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `shouldReport`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333254` | Self: 0.0% (0us) | Total: 0.1% (6.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `hasRejectValue` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/prelude-ls/lib/index.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:220` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `_encodeSource` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329661` | Self: 0.0% (0us) | Total: 8.9% (403.8ms) | Samples: 0

**Called by:**
- `iterate` (265)

**Calls:**
- `map` (265)

### `isConstructor`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319997` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get kind` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313114` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `areDocsInformative`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326860` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `descriptionIsRedundant` (2)

**Calls:**
- `splitTextIntoWords` (1)
- `splitTextIntoWords` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:48` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322394` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:223015` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `maskExcludedContent`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322832` | Self: 0.0% (0us) | Total: 0.2% (11.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (8)

**Calls:**
- `RegExp` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320921` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `find` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/default-config.js:37` | Self: 0.0% (0us) | Total: 0.1% (7.6ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320757` | Self: 0.0% (0us) | Total: 0.0% (4.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (3)

### `defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `get identifiers` (1)

**Calls:**
- `_computeVarDefs` (1)

### `exemptSpeciaMethods`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320030` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `hasATag` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318117` | Self: 0.0% (0us) | Total: 0.8% (38.6ms) | Samples: 0

**Called by:**
- `toggleFence` (23)

**Calls:**
- `stringSplitFast` (23)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2784` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `get globalScope` (1)

**Calls:**
- `_buildScope` (1)

### `next`
`[native code]` | Self: 0.0% (0us) | Total: 1.5% (68.1ms) | Samples: 0

**Called by:**
- `performIteration` (41)
- `(anonymous)` (2)

**Calls:**
- `regExpExec` (41)
- `arrayIteratorNextHelper` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333590` | Self: 0.0% (0us) | Total: 0.1% (6.2ms) | Samples: 0

**Called by:**
- `iterate` (4)

**Calls:**
- `(anonymous)` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:19` | Self: 0.0% (0us) | Total: 0.3% (13.7ms) | Samples: 0

**Called by:**
- `anonymous` (9)

**Calls:**
- `bound require` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201822` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` | Self: 0.0% (0us) | Total: 0.1% (7.6ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:20` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:133300` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109087` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `checkNonJsdoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326211` | Self: 0.0% (0us) | Total: 0.1% (4.6ms) | Samples: 0

**Called by:**
- `bound checkNonJsdoc` (3)

**Calls:**
- `reportings` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rule-tester/rule-tester.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92619` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/parse-string.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:195384` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getParser4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318437` | Self: 0.0% (0us) | Total: 0.0% (4.3ms) | Samples: 0

**Called by:**
- `parse3` (2)

**Calls:**
- `typeTokenizer` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:231300` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92697` | Self: 0.0% (0us) | Total: 0.2% (9.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `(anonymous)` (6)

### `splitLines`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318072` | Self: 0.0% (0us) | Total: 0.7% (35.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (24)

**Calls:**
- `regExpSplitFast` (24)

### `internal:stream`
`internal:stream:2` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:261101` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:33` | Self: 0.0% (0us) | Total: 34.5% (1.55s) | Samples: 0

**Called by:**
- `(anonymous)` (51)
- `(anonymous)` (51)
- `(anonymous)` (36)
- `(anonymous)` (27)
- `(anonymous)` (27)
- `(anonymous)` (25)
- `(anonymous)` (23)
- `(anonymous)` (23)
- `(anonymous)` (23)
- `(anonymous)` (20)
- `(anonymous)` (20)
- `(anonymous)` (20)
- `(anonymous)` (19)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (4)
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
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
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
- `(anonymous)` (51)
- `(anonymous)` (51)
- `(anonymous)` (47)
- `(anonymous)` (27)
- `(anonymous)` (25)
- `(anonymous)` (23)
- `(anonymous)` (23)
- `(anonymous)` (23)
- `(anonymous)` (20)
- `(anonymous)` (20)
- `(anonymous)` (19)
- `(anonymous)` (19)
- `(anonymous)` (11)
- `(anonymous)` (6)
- `(anonymous)` (5)
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

### `hasRejectValue`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333155` | Self: 0.0% (0us) | Total: 0.2% (10.2ms) | Samples: 0

**Called by:**
- `hasRejectValue` (4)
- `hasRejectValue` (2)

**Calls:**
- `some` (4)
- `get body` (1)
- `get body` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201924` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:195373` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320766` | Self: 0.0% (0us) | Total: 1.3% (58.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (9)
- `(anonymous)` (6)
- `(anonymous)` (4)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `checkTagName` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `checkTagName2` (1)
- `(anonymous)` (1)

**Calls:**
- `getPreferredTagName` (37)
- `getPreferredTagName` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:257726` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289637` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:58223` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:266461` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:29585` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `getDefaultTagStructureForMode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313998` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `getTagStructureForMode` (1)

**Calls:**
- `Map` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2855` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `get globalScope` (1)

**Calls:**
- `test` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:48478` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313106` | Self: 0.0% (0us) | Total: 2.6% (119.6ms) | Samples: 0

**Called by:**
- `anonymous` (36)

**Calls:**
- `(anonymous)` (36)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/getModifiers.js:38` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:30` | Self: 0.0% (0us) | Total: 1.5% (70.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `(anonymous)` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:242085` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:197838` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `exemptSpeciaMethods`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320029` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `hasSchemaOption` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289611` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319602` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `some` (2)

**Calls:**
- `hasTag` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/convert.js:41` | Self: 0.0% (0us) | Total: 0.2% (9.7ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201929` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getPreferredTagNameSimple`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319471` | Self: 0.0% (0us) | Total: 3.3% (150.5ms) | Samples: 0

**Called by:**
- `getPreferredTagName` (97)

**Calls:**
- `entries` (74)
- `find` (23)

### `tagMightHaveTypePosition`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319691` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `tagMustHaveTypePosition` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333156` | Self: 0.0% (0us) | Total: 0.1% (6.9ms) | Samples: 0

**Called by:**
- `some` (4)

**Calls:**
- `hasRejectValue` (3)
- `hasRejectValue` (1)

### `push`
`internal:fixed_queue:41` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `nextTick` (1)

**Calls:**
- `push` (1)

### `parseNamePath`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317061` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `tryParsePathIgnoreError` (1)

**Calls:**
- `create` (1)

### `commentParserToESTree`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317416` | Self: 0.0% (0us) | Total: 3.1% (141.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (87)
- `(anonymous)` (3)

**Calls:**
- `forEach` (90)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329664` | Self: 0.0% (0us) | Total: 0.1% (4.9ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `flatIntoArrayWithCallback` (2)
- `flatMap` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330564` | Self: 0.0% (0us) | Total: 0.0% (3.5ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `(anonymous)` (2)

### `validateDescription`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327224` | Self: 0.0% (0us) | Total: 2.4% (108.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (71)

**Calls:**
- `test` (71)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:11` | Self: 0.0% (0us) | Total: 0.1% (6.2ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `bound require` (4)

### `tryParslets`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314957` | Self: 0.0% (0us) | Total: 0.3% (13.5ms) | Samples: 0

**Called by:**
- `parseIntermediateType` (9)

**Calls:**
- `parslet` (8)
- `uniqueSymbolParslet` (1)

### `getNonJsdocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317951` | Self: 0.0% (0us) | Total: 0.3% (14.7ms) | Samples: 0

**Called by:**
- `checkNonJsdoc` (10)

**Calls:**
- `getReducedASTNode` (3)
- `getReducedASTNode` (3)
- `getReducedASTNode` (2)
- `getReducedASTNode` (1)
- `getReducedASTNode` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:138248` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `syntacticResult` (1)

### `bound `
`[native code]` | Self: 0.0% (0us) | Total: 23.2% (1.04s) | Samples: 0

**Called by:**
- `_invokeFused` (658)
- `_invokeFused` (33)

**Calls:**
- `(anonymous)` (372)
- `(anonymous)` (319)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328992` | Self: 0.0% (0us) | Total: 0.2% (10.4ms) | Samples: 0

**Called by:**
- `iterate` (7)

**Calls:**
- `flatIntoArrayWithCallback` (4)
- `flatMap` (3)

### `splitTextIntoWords`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326874` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `areDocsInformative` (1)

**Calls:**
- `flatIntoArrayWithCallback` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:40` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318181` | Self: 0.0% (0us) | Total: 0.2% (12.3ms) | Samples: 0

**Called by:**
- `parseSpec` (8)

**Calls:**
- `match` (8)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7919` | Self: 0.0% (0us) | Total: 4.9% (221.9ms) | Samples: 0

**Called by:**
- `runPlugins` (144)

**Calls:**
- `_invokeFused` (144)

### `satisfies`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/functions/satisfies.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `Range` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/timing.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:90437` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `reduce` (1)

**Calls:**
- `reduce` (1)

### `Ce`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.5% (24.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (16)

**Calls:**
- `Pe` (15)
- `Se` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318803` | Self: 0.0% (0us) | Total: 0.2% (13.4ms) | Samples: 0

**Called by:**
- `parseSpec` (9)

**Calls:**
- `(anonymous)` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:5923` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8195` | Self: 0.0% (0us) | Total: 0.0% (4.2ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (3)

**Calls:**
- `get source` (3)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2945` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `defs` (1)

**Calls:**
- `_findDefNode` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/useProvidedPrograms.js:44` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `fix10`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332412` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `fixer` (1)

**Calls:**
- `findIndex` (1)

### `callIterator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321131` | Self: 0.0% (0us) | Total: 0.9% (43.5ms) | Samples: 0

**Called by:**
- `onNodeWithComment` (28)

**Calls:**
- `every` (28)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:38` | Self: 0.0% (0us) | Total: 0.1% (8.0ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `shouldReport`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334118` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/lib/picomatch.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `get kind`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2734` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `isConstructor` (1)

**Calls:**
- `_rawTokenText` (1)

### `getAncestors`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3698` | Self: 0.0% (0us) | Total: 0.2% (10.7ms) | Samples: 0

**Called by:**
- `getUtils` (7)

**Calls:**
- `unshift` (3)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (1)

### `getFollowingComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317973` | Self: 0.0% (0us) | Total: 12.5% (565.4ms) | Samples: 0

**Called by:**
- `checkNonJsdocAfter` (372)

**Calls:**
- `tokenAfterIgnoringSemis` (372)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289655` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:128052` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4521` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `AstView` (1)

**Calls:**
- `fill` (1)

### `callIterator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321140` | Self: 0.0% (0us) | Total: 28.2% (1.27s) | Samples: 0

**Called by:**
- `onNodeWithComment` (790)
- `onNodeAllNodes` (2)
- `onProgramExit` (2)

**Calls:**
- `iterate` (788)
- `iterate` (5)
- `iterate` (1)

### `checkNonJsdocAfter`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326214` | Self: 0.0% (0us) | Total: 12.5% (565.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (372)

**Calls:**
- `getFollowingComment` (372)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321660` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `parse2` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290336` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92521` | Self: 0.0% (0us) | Total: 0.1% (5.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `(anonymous)` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:62` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `satisfies` (1)

### `cleanUpLastTag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317366` | Self: 0.0% (0us) | Total: 0.0% (4.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `stripEncapsulatingBrackets` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322865` | Self: 0.0% (0us) | Total: 0.4% (20.9ms) | Samples: 0

**Called by:**
- `iterate` (14)

**Calls:**
- `maskExcludedContent` (8)
- `maskExcludedContent` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172350` | Self: 0.0% (0us) | Total: 2.0% (94.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (20)

**Calls:**
- `(anonymous)` (20)

### `getReducedASTNode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317861` | Self: 0.0% (0us) | Total: 0.1% (5.8ms) | Samples: 0

**Called by:**
- `getNonJsdocComment` (2)
- `getJSDocComment` (2)

**Calls:**
- `getCommentsBefore` (2)
- `getCommentsBefore` (1)
- `getCommentsBefore` (1)

### `getAllComments`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3465` | Self: 0.0% (0us) | Total: 0.4% (18.7ms) | Samples: 0

**Called by:**
- `_getTokensAndCommentsMerged` (12)

**Calls:**
- `commentsInRange` (10)
- `commentsInRange` (1)
- `commentsInRange` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:497` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `patchAstUtils` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:44` | Self: 0.0% (0us) | Total: 0.4% (21.4ms) | Samples: 0

**Called by:**
- `anonymous` (14)

**Calls:**
- `bound require` (14)

### `(anonymous)`
`/private/tmp/prof_jsdoc.js:7` | Self: 0.0% (0us) | Total: 11.9% (537.5ms) | Samples: 0

**Called by:**
- `parseModule` (270)

**Calls:**
- `bundleRulesFor` (270)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:53` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `processTicksAndRejections`
`[native code]` | Self: 0.0% (0us) | Total: 87.6% (3.95s) | Samples: 0

**Calls:**
- `(anonymous)` (2544)
- `onConstruct` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328996` | Self: 0.0% (0us) | Total: 0.1% (7.0ms) | Samples: 0

**Called by:**
- `filter` (5)

**Calls:**
- `(anonymous)` (5)

### `y`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:185225` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/index.js:18` | Self: 0.0% (0us) | Total: 2.0% (92.9ms) | Samples: 0

**Called by:**
- `anonymous` (19)

**Calls:**
- `bound require` (19)

### `node:stream`
`node:stream:2` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:22` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330387` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `some` (1)

**Calls:**
- `report` (1)

### `getIndentAndJSDoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321084` | Self: 0.0% (0us) | Total: 2.7% (126.0ms) | Samples: 0

**Called by:**
- `checkJsdoc` (57)
- `callIterator` (25)

**Calls:**
- `parseComment` (44)
- `parseComment` (38)

### `identifierRule`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316676` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `read` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `hasThrowValue`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319879` | Self: 0.0% (0us) | Total: 0.0% (3.5ms) | Samples: 0

**Called by:**
- `hasThrowValue` (1)
- `hasThrowValue` (1)

**Calls:**
- `some` (2)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1549` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (1)

**Calls:**
- `get loc` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320933` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getJSDocComment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201866` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334707` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `indexOf` (1)

### `FunctionDeclaration`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332021` | Self: 0.0% (0us) | Total: 0.1% (5.8ms) | Samples: 0

**Called by:**
- `_invokeFused` (4)

**Calls:**
- `checkJsDoc` (2)
- `checkJsDoc` (1)
- `checkJsDoc` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201907` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `internal:streams/operators`
`internal:streams/operators:2` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `iterate`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321047` | Self: 0.0% (0us) | Total: 0.8% (39.1ms) | Samples: 0

**Called by:**
- `checkJsdoc` (20)
- `callIterator` (5)

**Calls:**
- `getUtils` (10)
- `getUtils` (9)
- `getUtils` (2)
- `getUtils` (1)
- `getUtils` (1)
- `getUtils` (1)
- `getUtils` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/Scope.js:38` | Self: 0.0% (0us) | Total: 0.2% (12.8ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:285280` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/minimatch/dist/commonjs/index.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190509` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `serialize`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js:1031` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_getFullPath` (1)

**Calls:**
- `_recomposeAuthority` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318449` | Self: 0.0% (0us) | Total: 0.7% (35.4ms) | Samples: 0

**Called by:**
- `parse3` (24)

**Calls:**
- `splitLines` (24)

### `node:util`
`node:util:2` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:15` | Self: 0.0% (0us) | Total: 0.1% (6.2ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `bound require` (4)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:966` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `get body` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `hasATag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319601` | Self: 0.0% (0us) | Total: 0.0% (4.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)
- `exemptSpeciaMethods` (1)

**Calls:**
- `some` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320929` | Self: 0.0% (0us) | Total: 0.0% (4.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `(anonymous)` (2)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188785` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:900` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_ensureDeclSymIndex` (1)

**Calls:**
- `_buildSymNameCache` (1)

### `(anonymous)`
`internal:streams/writable:197` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `bound onceWrapper` (1)

**Calls:**
- `onConstructed` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/default-config.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `Writable`
`internal:streams/writable:196` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `WriteStream` (1)

**Calls:**
- `construct` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:285276` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` | Self: 0.0% (0us) | Total: 5.0% (227.9ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (148)

**Calls:**
- `parse` (148)

### `RuleContext`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4248` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `SourceCode` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:215648` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `internal:streams/compose`
`internal:streams/compose:2` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2851` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

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

### `swapCase`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:8498` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `isFileSystemCaseSensitive` (1)

**Calls:**
- `replace` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:20` | Self: 0.0% (0us) | Total: 0.3% (16.5ms) | Samples: 0

**Called by:**
- `anonymous` (11)

**Calls:**
- `bound require` (11)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:3` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318129` | Self: 0.0% (0us) | Total: 0.3% (14.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (10)

**Calls:**
- `splitSpace` (7)
- `splitSpace` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:276523` | Self: 0.0% (0us) | Total: 0.1% (6.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `(anonymous)` (4)

### `getParamName`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319259` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `map` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236472` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318212` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `trim` (1)

### `kw`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:143` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `TokenType` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:51201` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `fixer`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332423` | Self: 0.0% (0us) | Total: 0.1% (7.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `fix10` (2)
- `fix10` (2)
- `fix10` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/getWatchProgramsForProjects.js:45` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317439` | Self: 0.0% (0us) | Total: 0.2% (12.3ms) | Samples: 0

**Called by:**
- `forEach` (8)

**Calls:**
- `cleanUpLastTag` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:192404` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318144` | Self: 0.0% (0us) | Total: 0.1% (6.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `splitSpace` (3)
- `splitSpace` (1)

### `_fromRunnerReport`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:203` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `get message` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260360` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/lib/scan.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290082` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188829` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:102460` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `parseType`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314935` | Self: 0.0% (0us) | Total: 1.9% (85.9ms) | Samples: 0

**Called by:**
- `parse` (55)

**Calls:**
- `parseIntermediateType` (45)
- `parseIntermediateType` (10)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:106429` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336921` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `map` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:152793` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332432` | Self: 0.0% (0us) | Total: 0.2% (12.0ms) | Samples: 0

**Called by:**
- `iterate` (8)

**Calls:**
- `(anonymous)` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334442` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `checkTagName2` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201874` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/getModifiers.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329218` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `flatIntoArrayWithCallback` (1)

### `getValidRuntimeIdentifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329079` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `get` (2)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5023` | Self: 0.0% (0us) | Total: 24.5% (1.10s) | Samples: 0

**Called by:**
- `walkNodes` (727)

**Calls:**
- `bound ` (658)
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (69)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/rules.js:3` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:293431` | Self: 0.0% (0us) | Total: 0.7% (35.4ms) | Samples: 0

**Called by:**
- `anonymous` (23)

**Calls:**
- `bound require` (23)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `encodeInto` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330922` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332427` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334704` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `flatIntoArrayWithCallback` (1)

### `(anonymous)`
`/private/tmp/prof_jsdoc.js:10` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `readFileSync` (1)

### `parseModule`
`[native code]` | Self: 0.0% (0us) | Total: 12.3% (554.8ms) | Samples: 0

**Called by:**
- `async (anonymous)` (281)

**Calls:**
- `(anonymous)` (270)
- `(anonymous)` (8)
- `(anonymous)` (2)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173072` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:18` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336976` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `validNamepathParsing` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332145` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:144926` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:490` | Self: 0.0% (0us) | Total: 0.2% (10.3ms) | Samples: 0

**Called by:**
- `parseSource` (3)

**Calls:**
- `CfgGraph` (2)
- `CfgGraph` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/getModifiers.js:39` | Self: 0.0% (0us) | Total: 0.1% (4.5ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92623` | Self: 0.0% (0us) | Total: 0.1% (5.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `(anonymous)` (4)

### `parseRange`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:135` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328602` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `some` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137943` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289546` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321236` | Self: 0.0% (0us) | Total: 0.1% (8.4ms) | Samples: 0

**Called by:**
- `_invokeFused` (3)
- `_invokeFused` (1)

**Calls:**
- `onNodeAllNodes` (3)
- `onNodeAllNodes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316650` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `identifierRule` (1)

**Calls:**
- `test` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332755` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/visitor-keys/dist/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161605` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `splitTextIntoWords`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326876` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `areDocsInformative` (1)

**Calls:**
- `flatIntoArrayWithCallback` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289664` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `maskExcludedContent`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322833` | Self: 0.0% (0us) | Total: 0.1% (9.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `replace` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334023` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/ClassVisitor.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320331` | Self: 0.0% (0us) | Total: 0.3% (15.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (8)
- `(anonymous)` (2)

**Calls:**
- `report` (10)

### `be`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `De` (1)

**Calls:**
- `join` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/ast-converter.js:4` | Self: 0.0% (0us) | Total: 0.2% (9.7ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:224986` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329137` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `concat` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321299` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (2)

**Calls:**
- `getSettings` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:232` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `kw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326177` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_execReport` (1)

**Calls:**
- `addComment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:197830` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7265` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_getOrBuildPlan` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318456` | Self: 0.0% (0us) | Total: 0.6% (29.4ms) | Samples: 0

**Called by:**
- `parse3` (20)

**Calls:**
- `compactJoiner` (20)

### `getFunctionParameterNames`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319364` | Self: 0.0% (0us) | Total: 0.1% (4.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `map` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:7` | Self: 0.0% (0us) | Total: 0.1% (7.8ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329193` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `concat` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12342` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `getReducedASTNode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317843` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `getNonJsdocComment` (1)

**Calls:**
- `looksLikeExport` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:217509` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328993` | Self: 0.0% (0us) | Total: 0.1% (7.0ms) | Samples: 0

**Called by:**
- `flatIntoArrayWithCallback` (5)

**Calls:**
- `filter` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/lib/utils.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/es2020.bigint.js:9` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332123` | Self: 0.0% (0us) | Total: 0.1% (4.5ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:9` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rule-tester/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `replaceXRanges`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js:389` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `parseComparator` (1)

**Calls:**
- `map` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` | Self: 0.0% (0us) | Total: 5.6% (253.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (162)

**Calls:**
- `parseSource` (148)
- `parseSource` (13)
- `parseSource` (1)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 12.3% (554.8ms) | Samples: 0

**Calls:**
- `parseModule` (281)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164518` | Self: 0.0% (0us) | Total: 1.3% (62.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `Range` (3)

### `canSkip`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333224` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8198` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `RuleContext` (1)

### `getRegexFromString`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320047` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `match` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:51143` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91299` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:163572` | Self: 0.0% (0us) | Total: 1.3% (61.2ms) | Samples: 0

**Called by:**
- `map` (2)

**Calls:**
- `Comparator` (2)

### `getPreferredTagNameSimple`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319452` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `getPreferredTagName` (1)

**Calls:**
- `values` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/api.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188345` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2384` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `get identifiers` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313050` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `setDeps`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326788` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `log` (2)

### `getTokensAfterIgnoringSemis`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317963` | Self: 0.0% (0us) | Total: 12.5% (563.7ms) | Samples: 0

**Called by:**
- `tokenAfterIgnoringSemis` (371)

**Calls:**
- `getTokensAfter` (285)
- `getTokensAfter` (68)
- `getTokensAfter` (17)
- `getTokensAfter` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329671` | Self: 0.0% (0us) | Total: 0.0% (3.4ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `flatIntoArrayWithCallback` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/analyze.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `tokenAfterIgnoringSemis`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317970` | Self: 0.0% (0us) | Total: 12.5% (565.4ms) | Samples: 0

**Called by:**
- `getFollowingComment` (372)

**Calls:**
- `getTokensAfterIgnoringSemis` (371)
- `getTokensAfterIgnoringSemis` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173250` | Self: 0.0% (0us) | Total: 2.1% (98.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (23)

**Calls:**
- `(anonymous)` (23)

### `get lines`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3580` | Self: 0.0% (0us) | Total: 1.8% (82.5ms) | Samples: 0

**Called by:**
- `create` (54)

**Calls:**
- `regExpSplitFast` (54)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:911` | Self: 0.0% (0us) | Total: 0.1% (8.8ms) | Samples: 0

**Called by:**
- `get` (6)

**Calls:**
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290126` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/visitor-keys/dist/get-keys.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:200931` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:331953` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `checkJsDoc` (1)

**Calls:**
- `report` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321162` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (1)

**Calls:**
- `getSettings` (1)

### `_normalizeIPv4`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js:800` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_recomposeAuthority` (1)

**Calls:**
- `[Symbol.match]` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:48398` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109709` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:128014` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320947` | Self: 0.0% (0us) | Total: 2.2% (101.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (20)
- `(anonymous)` (10)
- `(anonymous)` (9)
- `(anonymous)` (6)
- `(anonymous)` (4)
- `(anonymous)` (3)
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

**Calls:**
- `forEachPreferredTag` (65)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289561` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `useColors`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12454` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `createDebug` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:215933` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326159` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_execReport` (1)

**Calls:**
- `getDecorator` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6928` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `get value` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:54138` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `forEach` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188820` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `SourceCode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1093` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `RuleContext` (1)

**Calls:**
- `_getSharedCaches` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/node.js:240` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `setup` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:653` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `getCommentsBefore` (1)

**Calls:**
- `source` (1)

### `validNamepathParsing`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336794` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `tryParsePathIgnoreError` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:1664` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6952` | Self: 0.0% (0us) | Total: 10.1% (455.3ms) | Samples: 0

**Called by:**
- `walkNodes` (295)

**Calls:**
- `invokeHandlersWithNode` (294)
- `invokeHandlersWithNode` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/getModifiers.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313376` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320881` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `shouldReport` (1)

**Calls:**
- `hasThrowValue` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313039` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317921` | Self: 0.0% (0us) | Total: 4.5% (203.0ms) | Samples: 0

**Called by:**
- `getJSDocComment` (132)

**Calls:**
- `findJSDocComment` (124)
- `findJSDocComment` (2)
- `findJSDocComment` (2)
- `findJSDocComment` (2)
- `findJSDocComment` (1)
- `findJSDocComment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295624` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183954` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/tsconfig-utils/dist/index.js:18` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `getReducedASTNode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317856` | Self: 0.0% (0us) | Total: 0.5% (23.6ms) | Samples: 0

**Called by:**
- `getJSDocComment` (16)

**Calls:**
- `getTokenBefore` (13)
- `getTokenBefore` (2)
- `getTokenBefore` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:47927` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `g`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.7% (34.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (22)

**Calls:**
- `parse` (21)
- `parse` (1)

### `hasRejectValue`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333152` | Self: 0.0% (0us) | Total: 0.1% (6.6ms) | Samples: 0

**Called by:**
- `shouldReport` (4)

**Calls:**
- `hasRejectValue` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333256` | Self: 0.0% (0us) | Total: 0.1% (6.6ms) | Samples: 0

**Called by:**
- `iterate` (4)

**Calls:**
- `shouldReport` (4)

### `construct`
`internal:streams/destroy:124` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `Writable` (1)

**Calls:**
- `nextTick` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:296353` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328987` | Self: 0.0% (0us) | Total: 3.2% (145.5ms) | Samples: 0

**Called by:**
- `iterate` (96)

**Calls:**
- `filter` (96)

### `camelCase`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295618` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `splitPrefixSuffix` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170953` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:90435` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `reduce` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:152816` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301178` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `map` (2)

**Calls:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260164` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334237` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `checkTagName` (2)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316298` | Self: 0.0% (0us) | Total: 0.2% (9.8ms) | Samples: 0

**Called by:**
- `parse2` (5)
- `parseNamePath` (1)

**Calls:**
- `read` (2)
- `read` (1)
- `read` (1)
- `read` (1)
- `read` (1)

### `parseBlock`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318110` | Self: 0.0% (0us) | Total: 0.8% (38.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (23)

**Calls:**
- `toggleFence` (23)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289507` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4190` | Self: 0.0% (0us) | Total: 0.5% (25.1ms) | Samples: 0

**Called by:**
- `report` (11)
- `report` (3)
- `(anonymous)` (1)
- `report` (1)

**Calls:**
- `_execReport` (13)
- `_execReport` (1)
- `_execReport` (1)
- `_execReport` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329243` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318358` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `search` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171551` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328982` | Self: 0.0% (0us) | Total: 2.6% (121.0ms) | Samples: 0

**Called by:**
- `iterate` (78)

**Calls:**
- `filter` (78)

### `Pe`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 1.3% (59.9ms) | Samples: 0

**Called by:**
- `_e` (24)
- `Ce` (15)

**Calls:**
- `we` (37)
- `Se` (2)

### `bundleRulesFor`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-loader.js:59` | Self: 0.0% (0us) | Total: 11.9% (537.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (270)

**Calls:**
- `_loadBundle` (270)

### `_fromRunnerReport`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:205` | Self: 0.0% (0us) | Total: 0.0% (4.3ms) | Samples: 0

**Called by:**
- `map` (3)

**Calls:**
- `get loc` (2)
- `get loc` (1)

### `isFileSystemCaseSensitive`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:8495` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `getNodeSystem` (1)

**Calls:**
- `swapCase` (1)

### `camelCase`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295622` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)
- `addPolyfillToken` (1)

**Calls:**
- `map` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:224949` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:251554` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330455` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330698` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:223097` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320734` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236595` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `addSchema`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:137` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `addMetaSchema` (2)

**Calls:**
- `_addSchema` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329246` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137203` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `GetIntrinsic` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:242049` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `internal:streams/duplex`
`internal:streams/duplex:2` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318134` | Self: 0.0% (0us) | Total: 0.2% (12.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (8)

**Calls:**
- `splitSpace` (6)
- `splitSpace` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332162` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `setParamIndex` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:200923` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:562` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1027` | Self: 0.0% (0us) | Total: 0.1% (8.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)
- `getValidRuntimeIdentifiers` (2)

**Calls:**
- `_ensureVarsSet` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313098` | Self: 0.0% (0us) | Total: 1.6% (76.2ms) | Samples: 0

**Called by:**
- `anonymous` (51)

**Calls:**
- `(anonymous)` (51)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290261` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `we`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 1.2% (57.1ms) | Samples: 0

**Called by:**
- `Pe` (37)

**Calls:**
- `ke` (37)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:277094` | Self: 0.0% (0us) | Total: 0.1% (8.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `(anonymous)` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333757` | Self: 0.0% (0us) | Total: 0.3% (13.7ms) | Samples: 0

**Called by:**
- `iterate` (9)

**Calls:**
- `(anonymous)` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:337473` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `getJsdocProcessorPlugin` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:110315` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301142` | Self: 0.0% (0us) | Total: 0.2% (9.2ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `map` (6)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8203` | Self: 0.0% (0us) | Total: 79.7% (3.59s) | Samples: 0

**Called by:**
- `_lintSourceOne` (2315)

**Calls:**
- `walkNodes` (1836)
- `walkNodes` (296)
- `walkNodes` (144)
- `walkNodes` (11)
- `walkNodes` (7)
- `walkNodes` (6)
- `walkNodes` (3)
- `walkNodes` (2)
- `walkNodes` (2)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)

### `isNameOrNamepathDefiningTag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319672` | Self: 0.0% (0us) | Total: 0.2% (11.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (8)

**Calls:**
- `ensureMap` (6)
- `ensureMap` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:282755` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `invokeHandlersWithNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6890` | Self: 0.0% (0us) | Total: 10.0% (453.9ms) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (294)

**Calls:**
- `bound checkJsdoc` (291)
- `bound checkNonJsdoc` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/parse-string.js:113` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321333` | Self: 0.0% (0us) | Total: 1.8% (82.5ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (43)
- `buildVisitorMap` (11)

**Calls:**
- `get lines` (54)

### `hasRejectValue`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333196` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `hasRejectValue` (1)

**Calls:**
- `get argument` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/index.js:9` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161553` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `addComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326206` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `trimEnd` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/index.js:12` | Self: 0.0% (0us) | Total: 0.1% (6.1ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `bound require` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/predicates.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289730` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:285372` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1450` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `get parent` (1)

**Calls:**
- `get mainToken` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:517` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_computeVarDefs` (1)

**Calls:**
- `get parent` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:18` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:335667` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `report` (1)

### `_getFullPath`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:215` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `resolveIds` (1)

**Calls:**
- `serialize` (1)

### `(anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 87.6% (3.95s) | Samples: 0

**Called by:**
- `processTicksAndRejections` (2544)
- `useColors` (1)

**Calls:**
- `_lintSourceOne` (2378)
- `_lintSourceOne` (162)
- `_lintSourceOne` (4)
- `WriteStream` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327234` | Self: 0.0% (0us) | Total: 2.4% (111.5ms) | Samples: 0

**Called by:**
- `iterate` (73)

**Calls:**
- `validateDescription` (71)
- `validateDescription` (2)

### `Comparator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:163873` | Self: 0.0% (0us) | Total: 1.3% (61.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `parse` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:257700` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320778` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `canSkip4` (1)
- `canSkip` (1)

**Calls:**
- `hasATag` (2)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318128` | Self: 0.0% (0us) | Total: 0.2% (12.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (8)

**Calls:**
- `splitCR` (8)

### `RegExpParser`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:20981` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `RegExpParserState` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:169413` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:288361` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:294930` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138272` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:293087` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 37.5% | 1.69s | `[native code]` |
| 30.1% | 1.35s | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 26.0% | 1.17s | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 2.9% | 134.9ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 1.5% | 70.8ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js` |
| 0.7% | 35.9ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.4% | 18.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.0% | 1.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js` |
| 0.0% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/dom.js` |
| 0.0% | 1.5ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/index.js` |
| 0.0% | 1.5ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/useProvidedPrograms.js` |
| 0.0% | 1.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/node.js` |
| 0.0% | 1.4ms | `internal:streams/writable` |
| 0.0% | 1.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/lib/constants.js` |
| 0.0% | 1.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createIsolatedProgram.js` |
| 0.0% | 1.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/range.js` |
| 0.0% | 1.3ms | `internal:fixed_queue` |
| 0.0% | 1.2ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/json-schema-traverse/index.js` |
