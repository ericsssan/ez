# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 4.13s | 2635 | 1.0ms | 1247 |

**Top 10:** `anonymous` 5.7%, `parse` 5.5%, `_makeToken` 5.2%, `get flags` 3.3%, `_makeToken` 2.8%, `entries` 2.8%, ``/^\n?([A-Z`\d_][\s\S]*[.?!`\p{RGI_Emoji}]\s*)?$/v`` 2.4%, `(anonymous)` 2.1%, `(anonymous)` 2.1%, `getOwnPropertyDescriptor` 2.0%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 5.7% | 239.8ms | 37.4% | 1.55s | `anonymous` | `[native code]` |
| 5.5% | 229.3ms | 5.5% | 229.3ms | `parse` | `[native code]` |
| 5.2% | 219.3ms | 5.2% | 219.3ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1302` |
| 3.3% | 137.0ms | 3.3% | 138.5ms | `get flags` | `[native code]` |
| 2.8% | 119.3ms | 2.8% | 119.3ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1290` |
| 2.8% | 117.1ms | 2.8% | 117.1ms | `entries` | `[native code]` |
| 2.4% | 100.3ms | 2.4% | 100.3ms | ``/^\n?([A-Z`\d_][\s\S]*[.?!`\p{RGI_Emoji}]\s*)?$/v`` | `[native code]` |
| 2.1% | 90.3ms | 2.1% | 90.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 2.1% | 87.9ms | 2.3% | 96.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329659` |
| 2.0% | 83.1ms | 2.0% | 83.1ms | `getOwnPropertyDescriptor` | `[native code]` |
| 1.9% | 81.3ms | 2.8% | 116.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328987` |
| 1.9% | 80.4ms | 2.2% | 92.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328982` |
| 1.9% | 78.6ms | 1.9% | 78.6ms | `/(?<!\])\{@(?<tag>[^\}\s]+)\s?(?<namepathOrURL>[^\}\s\\|]*)\s*(?<separator>[\s\\|])?\s*(?<text>[^\}]*)\}/dgv` | `[native code]` |
| 1.5% | 65.4ms | 13.3% | 550.9ms | `filter` | `[native code]` |
| 1.5% | 63.9ms | 2.3% | 95.3ms | `regExpSplitFast` | `[native code]` |
| 1.4% | 59.4ms | 58.7% | 2.42s | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7847` |
| 1.4% | 58.5ms | 1.4% | 58.5ms | `getAncestors` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3795` |
| 1.2% | 53.4ms | 1.2% | 53.4ms | `getValidRuntimeIdentifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329079` |
| 1.2% | 52.6ms | 1.2% | 52.6ms | `SemVer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:162890` |
| 1.2% | 52.2ms | 1.2% | 52.2ms | `stringSplitFast` | `[native code]` |
| 1.1% | 47.7ms | 1.1% | 47.7ms | `Set` | `[native code]` |
| 0.9% | 41.3ms | 1.6% | 70.0ms | `parseIntermediateType` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314939` |
| 0.9% | 37.7ms | 1.4% | 58.8ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2102` |
| 0.8% | 35.8ms | 0.8% | 35.8ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318029` |
| 0.8% | 35.3ms | 0.8% | 35.3ms | `/^\s*globals/v` | `[native code]` |
| 0.8% | 34.2ms | 1.0% | 44.5ms | `[Symbol.match]` | `[native code]` |
| 0.8% | 33.8ms | 1.1% | 47.3ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1287` |
| 0.7% | 31.4ms | 0.7% | 31.4ms | `/\r\n\|\r\|\n\|\u2028\|\u2029/` | `[native code]` |
| 0.7% | 31.1ms | 0.7% | 31.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7661` |
| 0.7% | 30.3ms | 0.7% | 30.3ms | `_getMergedIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2014` |
| 0.7% | 29.1ms | 0.7% | 29.1ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1262` |
| 0.6% | 27.2ms | 0.6% | 27.2ms | `Error` | `[native code]` |
| 0.6% | 26.7ms | 3.2% | 134.2ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1677` |
| 0.6% | 26.5ms | 18.4% | 762.2ms | `map` | `[native code]` |
| 0.5% | 24.2ms | 0.5% | 24.2ms | `getParser2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318121` |
| 0.5% | 23.8ms | 3.5% | 146.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.5% | 23.3ms | 0.5% | 23.3ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318032` |
| 0.5% | 23.3ms | 0.5% | 24.7ms | `_getMergedIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2022` |
| 0.5% | 21.1ms | 0.5% | 21.1ms | `parseSpec` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318169` |
| 0.4% | 20.2ms | 2.9% | 120.5ms | `test` | `[native code]` |
| 0.4% | 19.8ms | 0.4% | 19.8ms | `getText` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1348` |
| 0.4% | 18.0ms | 0.4% | 18.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7982` |
| 0.4% | 17.9ms | 0.4% | 17.9ms | `esSpecIsRegExp` | `[native code]` |
| 0.4% | 17.8ms | 17.2% | 713.6ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318044` |
| 0.4% | 17.2ms | 0.4% | 17.2ms | `trimStart` | `[native code]` |
| 0.4% | 17.1ms | 0.8% | 37.0ms | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321103` |
| 0.4% | 16.6ms | 10.9% | 452.7ms | `_getAllTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1944` |
| 0.4% | 16.5ms | 0.4% | 16.5ms | `/^\*(?!\*)/v` | `[native code]` |
| 0.3% | 15.5ms | 0.3% | 15.5ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1294` |
| 0.3% | 15.5ms | 0.3% | 15.5ms | `[Symbol.matchAll]` | `[native code]` |
| 0.3% | 15.3ms | 0.3% | 15.3ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.3% | 14.5ms | 0.3% | 14.5ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2109` |
| 0.3% | 14.2ms | 0.3% | 14.2ms | `getParser2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318123` |
| 0.3% | 14.0ms | 0.3% | 14.0ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.3% | 13.4ms | 0.3% | 13.4ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318132` |
| 0.3% | 13.3ms | 0.3% | 13.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7513` |
| 0.3% | 13.1ms | 0.3% | 13.1ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318017` |
| 0.3% | 13.1ms | 0.3% | 13.1ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1230` |
| 0.3% | 13.1ms | 0.3% | 13.1ms | `RegExp` | `[native code]` |
| 0.3% | 13.0ms | 0.3% | 13.0ms | `seedTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318080` |
| 0.3% | 13.0ms | 0.3% | 13.0ms | `stringIncludesInternal` | `[native code]` |
| 0.3% | 12.9ms | 0.3% | 12.9ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1266` |
| 0.3% | 12.7ms | 0.3% | 12.7ms | `includes` | `[native code]` |
| 0.3% | 12.4ms | 0.3% | 12.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301189` |
| 0.2% | 12.2ms | 0.2% | 12.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4211` |
| 0.2% | 12.2ms | 0.2% | 12.2ms | `splitSpace` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318068` |
| 0.2% | 12.1ms | 0.6% | 27.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328146` |
| 0.2% | 11.6ms | 0.2% | 11.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.2% | 11.3ms | 0.2% | 11.3ms | `concat` | `[native code]` |
| 0.2% | 10.8ms | 0.2% | 10.8ms | `replace` | `[native code]` |
| 0.2% | 10.6ms | 0.5% | 23.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319474` |
| 0.2% | 10.5ms | 0.2% | 10.5ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1204` |
| 0.2% | 10.3ms | 0.2% | 12.0ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320283` |
| 0.2% | 10.1ms | 0.2% | 10.1ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4094` |
| 0.2% | 10.0ms | 0.2% | 10.0ms | `_getAllTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1945` |
| 0.2% | 10.0ms | 36.0% | 1.49s | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5207` |
| 0.2% | 9.9ms | 0.2% | 9.9ms | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318434` |
| 0.2% | 9.8ms | 0.2% | 9.8ms | `join` | `[native code]` |
| 0.2% | 9.5ms | 0.2% | 9.5ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318014` |
| 0.2% | 9.5ms | 0.2% | 9.5ms | `copyDataProperties` | `[native code]` |
| 0.2% | 9.4ms | 2.5% | 104.9ms | `performIteration` | `[native code]` |
| 0.2% | 9.3ms | 0.2% | 9.3ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2146` |
| 0.2% | 9.2ms | 0.2% | 9.2ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4522` |
| 0.2% | 9.1ms | 0.2% | 10.7ms | `getCommentsBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3528` |
| 0.2% | 8.9ms | 0.2% | 8.9ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1681` |
| 0.2% | 8.7ms | 4.4% | 186.1ms | `parseDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318682` |
| 0.2% | 8.7ms | 0.2% | 8.7ms | `/(?:\[(?<text>[^\]]+)\])\{@(?<tag>[^\}\s]+)\s?(?<namepathOrURL>[^\}\s\\|]*)\}/dgv` | `[native code]` |
| 0.2% | 8.7ms | 0.2% | 8.7ms | `unshift` | `[native code]` |
| 0.2% | 8.5ms | 0.2% | 8.5ms | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318440` |
| 0.1% | 8.2ms | 0.1% | 8.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317512` |
| 0.1% | 8.1ms | 0.5% | 24.8ms | `some` | `[native code]` |
| 0.1% | 8.0ms | 0.1% | 8.0ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318131` |
| 0.1% | 8.0ms | 2.3% | 95.5ms | `regExpExec` | `[native code]` |
| 0.1% | 7.7ms | 2.8% | 115.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328166` |
| 0.1% | 7.5ms | 0.3% | 16.3ms | `at` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2050` |
| 0.1% | 7.5ms | 4.2% | 177.1ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317893` |
| 0.1% | 7.4ms | 0.1% | 7.4ms | `/\r+$/` | `[native code]` |
| 0.1% | 7.3ms | 0.1% | 7.3ms | `_getMergedIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2024` |
| 0.1% | 7.0ms | 0.1% | 7.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7509` |
| 0.1% | 6.9ms | 0.7% | 32.4ms | `getDecorator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317745` |
| 0.1% | 6.8ms | 17.3% | 718.7ms | `checkJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321335` |
| 0.1% | 6.7ms | 0.1% | 6.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7809` |
| 0.1% | 6.6ms | 0.1% | 6.6ms | `_getMergedIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2033` |
| 0.1% | 6.5ms | 0.2% | 8.3ms | `parseBlock` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318104` |
| 0.1% | 6.4ms | 0.1% | 6.4ms | `endsWith` | `[native code]` |
| 0.1% | 6.3ms | 0.1% | 6.3ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:590` |
| 0.1% | 6.3ms | 13.2% | 546.6ms | `getTokensBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3645` |
| 0.1% | 6.2ms | 0.2% | 9.2ms | `parslet` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315038` |
| 0.1% | 6.1ms | 0.1% | 6.1ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 6.1ms | 0.1% | 6.1ms | `Map` | `[native code]` |
| 0.1% | 6.1ms | 0.1% | 6.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318796` |
| 0.1% | 6.0ms | 0.1% | 6.0ms | `isNameOrNamepathDefiningTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319675` |
| 0.1% | 6.0ms | 0.1% | 6.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321192` |
| 0.1% | 6.0ms | 0.1% | 6.0ms | `Se` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.1% | 6.0ms | 0.1% | 6.0ms | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:609` |
| 0.1% | 6.0ms | 0.1% | 6.0ms | `maskCodeBlocks` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.1% | 5.9ms | 0.1% | 5.9ms | `/^\/\*(?!\*)/v` | `[native code]` |
| 0.1% | 5.8ms | 0.1% | 5.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7807` |
| 0.1% | 5.8ms | 0.1% | 5.8ms | `seedSpec` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318077` |
| 0.1% | 5.7ms | 2.3% | 98.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318453` |
| 0.1% | 5.7ms | 0.1% | 5.7ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 5.6ms | 0.1% | 5.6ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318147` |
| 0.1% | 5.4ms | 0.1% | 5.4ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` |
| 0.1% | 5.1ms | 2.8% | 119.1ms | `parseDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318681` |
| 0.1% | 5.1ms | 0.2% | 11.4ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1660` |
| 0.1% | 5.0ms | 0.1% | 5.0ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:676` |
| 0.1% | 4.9ms | 0.1% | 4.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4238` |
| 0.1% | 4.9ms | 29.2% | 1.20s | `bound checkJsdoc` | `[native code]` |
| 0.1% | 4.9ms | 0.1% | 4.9ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318148` |
| 0.1% | 4.9ms | 0.1% | 4.9ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3634` |
| 0.1% | 4.8ms | 1.2% | 52.6ms | `parseSpec` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318168` |
| 0.1% | 4.7ms | 0.1% | 4.7ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318154` |
| 0.1% | 4.7ms | 0.1% | 4.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:656` |
| 0.1% | 4.6ms | 0.1% | 4.6ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318140` |
| 0.1% | 4.6ms | 0.1% | 6.0ms | `replaceAll` | `[native code]` |
| 0.1% | 4.5ms | 1.6% | 68.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318452` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317870` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318190` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:649` |
| 0.1% | 4.4ms | 0.4% | 17.7ms | `compactJoiner` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318416` |
| 0.1% | 4.3ms | 0.1% | 4.3ms | `getCommentsBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3527` |
| 0.1% | 4.3ms | 0.1% | 4.3ms | `toLocaleLowerCase` | `[native code]` |
| 0.1% | 4.3ms | 0.1% | 4.3ms | `_getMergedIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 4.1ms | 0.1% | 5.9ms | `getParser` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318098` |
| 0.0% | 3.6ms | 0.6% | 28.0ms | `splitSpace` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318067` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `Parser` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314896` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `/^\/\*\*\s/v` | `[native code]` |
| 0.0% | 3.3ms | 0.9% | 37.3ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317919` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:593` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7217` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `substr` | `[native code]` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `cloneObject` | `[native code]` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `Ee` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 3.2ms | 0.2% | 10.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318458` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `commentParserToESTree` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317393` |
| 0.0% | 3.2ms | 0.6% | 25.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4216` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318025` |
| 0.0% | 3.1ms | 0.8% | 35.5ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317888` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `search` | `[native code]` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `hasTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319489` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3708` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `trimEnd` | `[native code]` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318021` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7803` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2827` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318129` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `defineProperty` | `[native code]` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `preserveJoiner` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318428` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `read` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316313` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1262` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `exit` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_getMergedIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2039` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `parseBlock` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 3.0ms | 12.1% | 501.8ms | `invokeHandlersWithNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7017` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1194` |
| 0.0% | 3.0ms | 0.3% | 14.5ms | `getAncestors` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3825` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `log` | `[native code]` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.0% | 3.0ms | 1.6% | 69.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329225` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7219` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `trim` | `[native code]` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `getTokenizers` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318761` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `join` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318467` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318042` |
| 0.0% | 2.9ms | 0.1% | 7.8ms | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317830` |
| 0.0% | 2.9ms | 0.2% | 10.3ms | `c` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `parseBlock` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318103` |
| 0.0% | 2.8ms | 1.7% | 71.9ms | `ke` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4106` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `checkJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321339` |
| 0.0% | 2.7ms | 0.4% | 19.8ms | `getNonJsdocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317950` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:678` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `getIndentAndJSDoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321082` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327552` |
| 0.0% | 2.5ms | 0.9% | 41.0ms | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318442` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320918` |
| 0.0% | 2.4ms | 0.0% | 2.4ms | `getParser3` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318163` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1302` |
| 0.0% | 1.8ms | 0.2% | 9.4ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1027` |
| 0.0% | 1.8ms | 2.3% | 97.3ms | `next` | `[native code]` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318007` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `toReversed` | `[native code]` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3973` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:187857` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:916` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `getLocFromIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318026` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `internal:fs/streams` | `internal:fs/streams:158` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_fromRunnerReport` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:207` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333077` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:325967` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `SemVer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `values` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2979` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `/^@[^\s/]+(?=\s\|$)/` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getFencer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318115` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320771` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171429` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/eslint-utils/astUtilities.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getDefaultTagStructureForMode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313939` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/private/tmp/prof_jsdoc.js:9` |
| 0.0% | 1.7ms | 2.9% | 122.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318449` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323790` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318769` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `typeTokenizer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318203` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:670` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `Parser` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314910` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4130` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3692` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320627` |
| 0.0% | 1.7ms | 0.2% | 9.4ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318139` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `flatten` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1252` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318045` |
| 0.0% | 1.7ms | 1.0% | 45.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318448` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317852` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:266364` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `preserveJoiner` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318427` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2150` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318130` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_getMergedIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1973` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321101` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getBasicUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320240` |
| 0.0% | 1.7ms | 3.5% | 145.5ms | `getPreferredTagName` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319514` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get declaration` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3611` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301183` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `parse2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316975` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170488` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318151` |
| 0.0% | 1.7ms | 3.6% | 150.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326238` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_isStatementTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320575` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_Lexer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316303` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `descriptionTokenizer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318401` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320814` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1136` |
| 0.0% | 1.6ms | 0.0% | 2.9ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:675` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:232339` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get lexer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314924` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318763` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_getMergedIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2017` |
| 0.0% | 1.6ms | 0.0% | 3.2ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1284` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327824` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `read` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316323` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `accept` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315083` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `useColors` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12454` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:200893` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `be` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.6ms | 2.0% | 85.7ms | `parse2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317016` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_tokType` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317456` |
| 0.0% | 1.6ms | 0.0% | 2.8ms | `isConstructor` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319996` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `nameTokenizer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318275` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317913` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320889` |
| 0.0% | 1.6ms | 0.0% | 3.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320762` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2144` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `encodeInto` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:659` |
| 0.0% | 1.6ms | 0.1% | 6.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320795` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8302` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `ensureMap` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319626` |
| 0.0% | 1.6ms | 0.0% | 3.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:42213` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `inverseMap` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:46720` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `ge` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `validateDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330339` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `generateNamedReferences` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321757` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `onNodeWithComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321176` |
| 0.0% | 1.5ms | 0.0% | 3.2ms | `exemptSpeciaMethods` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320029` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_applySchemaDefaults` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:181` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:186753` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get kind` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2738` |
| 0.0% | 1.5ms | 2.0% | 85.3ms | `parse` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314927` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 3.3ms | `createTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332392` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get multiline` | `[native code]` |
| 0.0% | 1.5ms | 1.9% | 80.3ms | `checkJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321342` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `predicateParslet` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315038` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:54196` |
| 0.0% | 1.5ms | 3.6% | 150.3ms | `bound ` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `setPrototypeOf` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317566` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getTokenizers` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.5ms | 0.0% | 2.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320391` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328176` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:335666` |
| 0.0% | 1.5ms | 0.2% | 10.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328149` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `read` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316311` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/scope/CatchScope.js:5` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171719` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320882` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320941` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:595` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:199268` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320314` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:181748` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `hasTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319490` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332160` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `registerCodeFix` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:155874` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `canSkip6` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334400` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getPreferredTagNameSimple` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319448` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317416` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:337181` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329671` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `cleanUpLastTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.4ms | 0.3% | 15.5ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318128` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326447` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `createTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332388` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/type-check/lib/parse-type.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328781` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | ````/([ \t]+\*)[ \t]```[^\n]*?([\w\\|\W]*?\n)(?=[ \t]*\*(?:[ \t]*(?:```\|@\w+\s)\|\/))/gv```` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7819` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `fix10` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332349` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330138` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getContexts` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328706` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2325` |
| 0.0% | 1.4ms | 2.8% | 118.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327233` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getDefaultTagStructureForMode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313699` |
| 0.0% | 1.4ms | 13.7% | 570.2ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5185` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183909` |
| 0.0% | 1.4ms | 32.6% | 1.35s | `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321230` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `checkJsDoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:331855` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321102` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `regExpMatchFast` | `[native code]` |
| 0.0% | 1.4ms | 0.1% | 4.8ms | `reduce` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `charCodeAt` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2753` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `stripEncapsulatingBrackets` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317350` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `at` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getJsdocTagsDeep` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319372` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336984` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `__export` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:23` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `fetch` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318454` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:211438` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320460` |
| 0.0% | 1.4ms | 18.4% | 763.6ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318016` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_getAllTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1948` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:681` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `accept` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.4ms | 0.1% | 7.1ms | `checkTagName` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334198` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `preserveJoiner` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318424` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `emit` | `node:events` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `addComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326204` |
| 0.0% | 1.3ms | 0.4% | 18.4ms | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317863` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `Boolean` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `linkAndEvaluateModule` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 2.9ms | `camelCase` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295617` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `/^\s+/` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `/\s*(@(\S+))(\s*)/` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_computeIdentifierName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.2% | 9.7ms | `splitCR` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318063` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4827` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318209` |
| 0.0% | 1.3ms | 1.7% | 73.3ms | `we` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334429` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328150` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4210` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326519` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4158` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2089` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `[Symbol.split]` | `[native code]` |
| 0.0% | 1.3ms | 1.8% | 74.7ms | `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321227` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `createNamedRule` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/eslint-utils/RuleCreator.js:18` |
| 0.0% | 1.3ms | 7.4% | 306.6ms | `parseComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318829` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `ensureMap` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319629` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getPreferredTagName` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319508` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:717` |
| 0.0% | 1.3ms | 4.1% | 170.9ms | `matchAll` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317477` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317536` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6578` |
| 0.0% | 1.3ms | 0.0% | 2.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318395` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `at` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2054` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2104` |
| 0.0% | 1.3ms | 0.1% | 7.4ms | `f` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7495` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `fix10` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330343` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `hasRejectValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333143` |
| 0.0% | 1.2ms | 0.4% | 17.7ms | `flatIntoArrayWithCallback` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_mkGlobalVar` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:709` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_findLine` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:573` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1540` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `add` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:183987` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `checkJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321336` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getParser` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318099` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3682` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318445` |
| 0.0% | 1.2ms | 3.5% | 146.5ms | `getNonJsdocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317951` |
| 0.0% | 1.2ms | 0.4% | 20.3ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1680` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301198` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332144` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317921` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `toString` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320404` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `parslet` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315039` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get kind` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2734` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `push` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/node.js:12` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333240` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `/^\s+$/` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170800` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318035` |
| 0.0% | 1.1ms | 0.0% | 1.1ms | `cleanUpLastTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317370` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 86.6% | 3.58s | 0.0% | 0us | `(anonymous)` | `[native code]` |
| 86.6% | 3.58s | 0.0% | 0us | `processTicksAndRejections` | `[native code]` |
| 80.3% | 3.32s | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:274` |
| 78.8% | 3.26s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8330` |
| 58.7% | 2.42s | 1.4% | 59.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7847` |
| 40.5% | 1.67s | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:33` |
| 37.4% | 1.55s | 5.7% | 239.8ms | `anonymous` | `[native code]` |
| 37.2% | 1.54s | 0.0% | 0us | `bound require` | `[native code]` |
| 37.0% | 1.53s | 0.0% | 0us | `require` | `[native code]` |
| 36.7% | 1.52s | 0.0% | 0us | `iterate` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321061` |
| 36.0% | 1.49s | 0.2% | 10.0ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5207` |
| 32.6% | 1.35s | 0.0% | 1.4ms | `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321230` |
| 32.5% | 1.34s | 0.0% | 0us | `onNodeWithComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321177` |
| 29.2% | 1.21s | 0.0% | 0us | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321139` |
| 29.2% | 1.20s | 0.1% | 4.9ms | `bound checkJsdoc` | `[native code]` |
| 18.4% | 763.6ms | 0.0% | 1.4ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318016` |
| 18.4% | 762.2ms | 0.6% | 26.5ms | `map` | `[native code]` |
| 17.3% | 718.7ms | 0.1% | 6.8ms | `checkJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321335` |
| 17.2% | 713.6ms | 0.4% | 17.8ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318044` |
| 15.8% | 657.0ms | 0.0% | 0us | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317920` |
| 13.7% | 570.2ms | 0.0% | 1.4ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5185` |
| 13.3% | 554.5ms | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 13.3% | 551.6ms | 0.0% | 0us | `parseModule` | `[native code]` |
| 13.3% | 550.9ms | 1.5% | 65.4ms | `filter` | `[native code]` |
| 13.2% | 546.6ms | 0.1% | 6.3ms | `getTokensBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3645` |
| 13.2% | 546.6ms | 0.0% | 0us | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317896` |
| 12.9% | 534.4ms | 0.0% | 0us | `_loadBundle` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-loader.js:34` |
| 12.9% | 534.4ms | 0.0% | 0us | `bundleRulesFor` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-loader.js:59` |
| 12.9% | 534.4ms | 0.0% | 0us | `(anonymous)` | `/private/tmp/prof_jsdoc.js:7` |
| 12.3% | 509.3ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7949` |
| 12.1% | 501.8ms | 0.0% | 3.0ms | `invokeHandlersWithNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7017` |
| 12.1% | 501.8ms | 0.0% | 0us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7079` |
| 11.2% | 464.2ms | 0.0% | 0us | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2074` |
| 10.9% | 452.7ms | 0.4% | 16.6ms | `_getAllTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1944` |
| 10.5% | 435.5ms | 0.0% | 0us | `parse3` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318645` |
| 9.7% | 401.7ms | 0.0% | 0us | `checkJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321346` |
| 9.0% | 376.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329661` |
| 9.0% | 376.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329660` |
| 8.9% | 372.4ms | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5162` |
| 7.9% | 327.3ms | 0.0% | 0us | `parseComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318818` |
| 7.4% | 306.6ms | 0.0% | 1.3ms | `parseComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318829` |
| 6.1% | 253.8ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` |
| 5.6% | 235.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328983` |
| 5.6% | 232.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328984` |
| 5.5% | 229.3ms | 5.5% | 229.3ms | `parse` | `[native code]` |
| 5.4% | 226.2ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` |
| 5.4% | 224.1ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8046` |
| 5.2% | 219.3ms | 5.2% | 219.3ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1302` |
| 5.1% | 214.9ms | 0.0% | 0us | `parseInlineTags` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318701` |
| 4.4% | 186.1ms | 0.2% | 8.7ms | `parseDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318682` |
| 4.2% | 177.1ms | 0.1% | 7.5ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317893` |
| 4.1% | 170.9ms | 0.0% | 1.3ms | `matchAll` | `[native code]` |
| 4.0% | 168.0ms | 0.0% | 0us | `getIndentAndJSDoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321083` |
| 4.0% | 166.4ms | 0.0% | 0us | `checkNonJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326196` |
| 3.9% | 162.4ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321263` |
| 3.8% | 160.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328144` |
| 3.6% | 150.3ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326238` |
| 3.6% | 150.3ms | 0.0% | 1.5ms | `bound ` | `[native code]` |
| 3.5% | 146.8ms | 0.5% | 23.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 3.5% | 146.5ms | 0.0% | 1.2ms | `getNonJsdocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317951` |
| 3.5% | 145.5ms | 0.0% | 1.7ms | `getPreferredTagName` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319514` |
| 3.3% | 140.5ms | 0.0% | 0us | `getPreferredTagNameSimple` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319470` |
| 3.3% | 139.4ms | 0.0% | 0us | `forEach` | `[native code]` |
| 3.3% | 139.4ms | 0.0% | 0us | `commentParserToESTree` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317415` |
| 3.3% | 138.5ms | 3.3% | 137.0ms | `get flags` | `[native code]` |
| 3.2% | 134.2ms | 0.6% | 26.7ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1677` |
| 3.2% | 132.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328986` |
| 3.0% | 124.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313105` |
| 2.9% | 122.5ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318449` |
| 2.9% | 122.0ms | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5150` |
| 2.9% | 120.5ms | 0.4% | 20.2ms | `test` | `[native code]` |
| 2.8% | 119.3ms | 2.8% | 119.3ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1290` |
| 2.8% | 119.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328981` |
| 2.8% | 119.1ms | 0.1% | 5.1ms | `parseDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318681` |
| 2.8% | 118.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327233` |
| 2.8% | 117.1ms | 2.8% | 117.1ms | `entries` | `[native code]` |
| 2.8% | 116.7ms | 1.9% | 81.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328987` |
| 2.8% | 115.9ms | 0.1% | 7.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328166` |
| 2.7% | 115.5ms | 0.0% | 0us | `validateDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327223` |
| 2.6% | 109.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329658` |
| 2.5% | 105.5ms | 0.0% | 0us | `cleanUpLastTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317374` |
| 2.5% | 105.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173277` |
| 2.5% | 104.9ms | 0.2% | 9.4ms | `performIteration` | `[native code]` |
| 2.4% | 103.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172573` |
| 2.4% | 103.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173249` |
| 2.4% | 101.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172431` |
| 2.4% | 100.3ms | 2.4% | 100.3ms | ``/^\n?([A-Z`\d_][\s\S]*[.?!`\p{RGI_Emoji}]\s*)?$/v`` | `[native code]` |
| 2.3% | 98.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172349` |
| 2.3% | 98.1ms | 0.1% | 5.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318453` |
| 2.3% | 97.3ms | 0.0% | 1.8ms | `next` | `[native code]` |
| 2.3% | 97.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171769` |
| 2.3% | 96.0ms | 2.1% | 87.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329659` |
| 2.3% | 95.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317581` |
| 2.3% | 95.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171548` |
| 2.3% | 95.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/index.js:18` |
| 2.3% | 95.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171394` |
| 2.3% | 95.5ms | 0.1% | 8.0ms | `regExpExec` | `[native code]` |
| 2.3% | 95.3ms | 1.5% | 63.9ms | `regExpSplitFast` | `[native code]` |
| 2.2% | 92.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/clear-caches.js:6` |
| 2.2% | 92.1ms | 1.9% | 80.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328982` |
| 2.2% | 91.8ms | 0.0% | 0us | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321109` |
| 2.2% | 91.1ms | 0.0% | 0us | `iterate` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321046` |
| 2.1% | 90.3ms | 0.0% | 0us | `parseInlineTags` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318704` |
| 2.1% | 90.3ms | 2.1% | 90.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 2.1% | 88.2ms | 0.0% | 0us | `forEachPreferredTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319536` |
| 2.1% | 88.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320946` |
| 2.0% | 85.7ms | 0.0% | 1.6ms | `parse2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317016` |
| 2.0% | 85.3ms | 0.0% | 1.5ms | `parse` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314927` |
| 2.0% | 83.7ms | 0.0% | 0us | `parseType` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314934` |
| 2.0% | 83.1ms | 2.0% | 83.1ms | `getOwnPropertyDescriptor` | `[native code]` |
| 1.9% | 80.3ms | 0.0% | 1.5ms | `checkJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321342` |
| 1.9% | 78.6ms | 1.9% | 78.6ms | `/(?<!\])\{@(?<tag>[^\}\s]+)\s?(?<namepathOrURL>[^\}\s\\|]*)\s*(?<separator>[\s\\|])?\s*(?<text>[^\}]*)\}/dgv` | `[native code]` |
| 1.8% | 77.9ms | 0.0% | 0us | `Pe` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 1.8% | 76.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313097` |
| 1.8% | 76.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:168346` |
| 1.8% | 74.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:168170` |
| 1.8% | 74.7ms | 0.0% | 1.3ms | `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321227` |
| 1.7% | 73.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:30` |
| 1.7% | 73.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:16` |
| 1.7% | 73.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:42` |
| 1.7% | 73.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:4` |
| 1.7% | 73.3ms | 0.0% | 1.3ms | `we` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 1.7% | 73.1ms | 0.0% | 0us | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320279` |
| 1.7% | 71.9ms | 0.0% | 2.8ms | `ke` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 1.6% | 70.0ms | 0.9% | 41.3ms | `parseIntermediateType` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314939` |
| 1.6% | 69.1ms | 0.0% | 3.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329225` |
| 1.6% | 68.0ms | 0.1% | 4.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318452` |
| 1.4% | 61.7ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321241` |
| 1.4% | 60.7ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8329` |
| 1.4% | 58.8ms | 0.9% | 37.7ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2102` |
| 1.4% | 58.5ms | 1.4% | 58.5ms | `getAncestors` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3795` |
| 1.4% | 58.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320765` |
| 1.3% | 57.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321135` |
| 1.3% | 57.3ms | 0.0% | 0us | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321130` |
| 1.3% | 57.3ms | 0.0% | 0us | `every` | `[native code]` |
| 1.3% | 56.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164514` |
| 1.3% | 56.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164604` |
| 1.3% | 56.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313083` |
| 1.3% | 54.3ms | 0.0% | 0us | `Comparator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:163872` |
| 1.3% | 54.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164269` |
| 1.3% | 54.3ms | 0.0% | 0us | `parse` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:163893` |
| 1.3% | 54.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164442` |
| 1.3% | 53.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329132` |
| 1.2% | 53.4ms | 1.2% | 53.4ms | `getValidRuntimeIdentifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329079` |
| 1.2% | 53.1ms | 0.0% | 0us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321332` |
| 1.2% | 53.1ms | 0.0% | 0us | `get lines` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3707` |
| 1.2% | 52.6ms | 0.1% | 4.8ms | `parseSpec` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318168` |
| 1.2% | 52.6ms | 1.2% | 52.6ms | `SemVer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:162890` |
| 1.2% | 52.2ms | 1.2% | 52.2ms | `stringSplitFast` | `[native code]` |
| 1.2% | 51.2ms | 0.0% | 0us | `_e` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 1.1% | 49.2ms | 0.0% | 0us | `parseBlock` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318109` |
| 1.1% | 49.2ms | 0.0% | 0us | `toggleFence` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318099` |
| 1.1% | 49.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318116` |
| 1.1% | 47.9ms | 0.0% | 0us | `onProgramExit` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321193` |
| 1.1% | 47.7ms | 1.1% | 47.7ms | `Set` | `[native code]` |
| 1.1% | 47.3ms | 0.8% | 33.8ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1287` |
| 1.0% | 45.2ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318448` |
| 1.0% | 44.5ms | 0.0% | 0us | `match` | `[native code]` |
| 1.0% | 44.5ms | 0.8% | 34.2ms | `[Symbol.match]` | `[native code]` |
| 1.0% | 43.5ms | 0.0% | 0us | `splitLines` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318071` |
| 1.0% | 42.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:337704` |
| 1.0% | 42.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290028` |
| 1.0% | 42.2ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4686` |
| 0.9% | 41.0ms | 0.0% | 2.5ms | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318442` |
| 0.9% | 40.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317600` |
| 0.9% | 40.6ms | 0.0% | 0us | `parse` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.9% | 40.6ms | 0.0% | 0us | `Ae` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.9% | 40.6ms | 0.0% | 0us | `g` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.9% | 37.3ms | 0.0% | 3.3ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317919` |
| 0.8% | 37.0ms | 0.4% | 17.1ms | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321103` |
| 0.8% | 35.8ms | 0.8% | 35.8ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318029` |
| 0.8% | 35.5ms | 0.0% | 3.1ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317888` |
| 0.8% | 35.3ms | 0.8% | 35.3ms | `/^\s*globals/v` | `[native code]` |
| 0.8% | 35.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/unsupported-api.js:14` |
| 0.8% | 35.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:293430` |
| 0.7% | 32.4ms | 0.1% | 6.9ms | `getDecorator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317745` |
| 0.7% | 31.4ms | 0.7% | 31.4ms | `/\r\n\|\r\|\n\|\u2028\|\u2029/` | `[native code]` |
| 0.7% | 31.1ms | 0.7% | 31.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7661` |
| 0.7% | 30.3ms | 0.7% | 30.3ms | `_getMergedIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2014` |
| 0.7% | 29.1ms | 0.7% | 29.1ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1262` |
| 0.7% | 29.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313124` |
| 0.6% | 28.1ms | 0.0% | 0us | `Ce` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.6% | 28.0ms | 0.0% | 3.6ms | `splitSpace` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318067` |
| 0.6% | 27.3ms | 0.2% | 12.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328146` |
| 0.6% | 27.2ms | 0.0% | 0us | `_NoParsletFoundError` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314668` |
| 0.6% | 27.2ms | 0.6% | 27.2ms | `Error` | `[native code]` |
| 0.6% | 26.1ms | 0.0% | 0us | `getAllComments` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3592` |
| 0.6% | 26.1ms | 0.0% | 0us | `_getMergedIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1978` |
| 0.6% | 25.9ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` |
| 0.6% | 25.2ms | 0.0% | 3.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4216` |
| 0.5% | 24.8ms | 0.1% | 8.1ms | `some` | `[native code]` |
| 0.5% | 24.7ms | 0.5% | 23.3ms | `_getMergedIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2022` |
| 0.5% | 24.2ms | 0.5% | 24.2ms | `getParser2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318121` |
| 0.5% | 23.3ms | 0.5% | 23.3ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318032` |
| 0.5% | 23.3ms | 0.2% | 10.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319474` |
| 0.5% | 23.3ms | 0.0% | 0us | `find` | `[native code]` |
| 0.5% | 22.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:44` |
| 0.5% | 22.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327258` |
| 0.5% | 21.1ms | 0.5% | 21.1ms | `parseSpec` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318169` |
| 0.5% | 21.1ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4317` |
| 0.5% | 20.8ms | 0.0% | 0us | `bound checkNonJsdoc` | `[native code]` |
| 0.4% | 20.3ms | 0.0% | 1.2ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1680` |
| 0.4% | 19.8ms | 0.0% | 2.7ms | `getNonJsdocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317950` |
| 0.4% | 19.8ms | 0.4% | 19.8ms | `getText` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1348` |
| 0.4% | 19.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327244` |
| 0.4% | 19.7ms | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4288` |
| 0.4% | 19.7ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321033` |
| 0.4% | 19.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322864` |
| 0.4% | 19.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:198766` |
| 0.4% | 18.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173276` |
| 0.4% | 18.4ms | 0.0% | 1.3ms | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317863` |
| 0.4% | 18.0ms | 0.4% | 18.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7982` |
| 0.4% | 18.0ms | 0.0% | 0us | `parse2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317001` |
| 0.4% | 17.9ms | 0.4% | 17.9ms | `esSpecIsRegExp` | `[native code]` |
| 0.4% | 17.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318455` |
| 0.4% | 17.7ms | 0.1% | 4.4ms | `compactJoiner` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318416` |
| 0.4% | 17.7ms | 0.0% | 1.2ms | `flatIntoArrayWithCallback` | `[native code]` |
| 0.4% | 17.2ms | 0.4% | 17.2ms | `trimStart` | `[native code]` |
| 0.4% | 17.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320330` |
| 0.4% | 16.5ms | 0.4% | 16.5ms | `/^\*(?!\*)/v` | `[native code]` |
| 0.3% | 16.3ms | 0.1% | 7.5ms | `at` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2050` |
| 0.3% | 16.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/index.js:3` |
| 0.3% | 16.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:20` |
| 0.3% | 15.6ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4809` |
| 0.3% | 15.5ms | 0.3% | 15.5ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1294` |
| 0.3% | 15.5ms | 0.3% | 15.5ms | `[Symbol.matchAll]` | `[native code]` |
| 0.3% | 15.5ms | 0.0% | 1.4ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318128` |
| 0.3% | 15.3ms | 0.3% | 15.3ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.3% | 14.5ms | 0.0% | 3.0ms | `getAncestors` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3825` |
| 0.3% | 14.5ms | 0.3% | 14.5ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2109` |
| 0.3% | 14.2ms | 0.3% | 14.2ms | `getParser2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318123` |
| 0.3% | 14.0ms | 0.3% | 14.0ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.3% | 13.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317438` |
| 0.3% | 13.7ms | 0.0% | 0us | `onProgramExit` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321192` |
| 0.3% | 13.7ms | 0.0% | 0us | `parseIntermediateType` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314937` |
| 0.3% | 13.7ms | 0.0% | 0us | `tryParslets` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314956` |
| 0.3% | 13.6ms | 0.0% | 0us | `(anonymous)` | `/private/tmp/prof_jsdoc.js:5` |
| 0.3% | 13.6ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318143` |
| 0.3% | 13.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/Scope.js:38` |
| 0.3% | 13.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/index.js:26` |
| 0.3% | 13.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:43` |
| 0.3% | 13.4ms | 0.3% | 13.4ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318132` |
| 0.3% | 13.3ms | 0.3% | 13.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7513` |
| 0.3% | 13.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:19` |
| 0.3% | 13.1ms | 0.3% | 13.1ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318017` |
| 0.3% | 13.1ms | 0.3% | 13.1ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1230` |
| 0.3% | 13.1ms | 0.3% | 13.1ms | `RegExp` | `[native code]` |
| 0.3% | 13.0ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318126` |
| 0.3% | 13.0ms | 0.3% | 13.0ms | `seedTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318080` |
| 0.3% | 13.0ms | 0.3% | 13.0ms | `stringIncludesInternal` | `[native code]` |
| 0.3% | 12.9ms | 0.3% | 12.9ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1266` |
| 0.3% | 12.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320331` |
| 0.3% | 12.7ms | 0.3% | 12.7ms | `includes` | `[native code]` |
| 0.3% | 12.4ms | 0.3% | 12.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301189` |
| 0.2% | 12.2ms | 0.0% | 0us | `getCommentsBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3548` |
| 0.2% | 12.2ms | 0.2% | 12.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4211` |
| 0.2% | 12.2ms | 0.2% | 12.2ms | `splitSpace` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318068` |
| 0.2% | 12.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322863` |
| 0.2% | 12.0ms | 0.2% | 10.3ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320283` |
| 0.2% | 11.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/analyze.js:5` |
| 0.2% | 11.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/index.js:4` |
| 0.2% | 11.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/index.js:18` |
| 0.2% | 11.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318180` |
| 0.2% | 11.6ms | 0.2% | 11.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.2% | 11.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/apply-disable-directives.js:22` |
| 0.2% | 11.4ms | 0.1% | 5.1ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1660` |
| 0.2% | 11.3ms | 0.2% | 11.3ms | `concat` | `[native code]` |
| 0.2% | 11.2ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318133` |
| 0.2% | 11.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333233` |
| 0.2% | 10.9ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328149` |
| 0.2% | 10.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332431` |
| 0.2% | 10.8ms | 0.2% | 10.8ms | `replace` | `[native code]` |
| 0.2% | 10.7ms | 0.2% | 9.1ms | `getCommentsBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3528` |
| 0.2% | 10.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318404` |
| 0.2% | 10.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318802` |
| 0.2% | 10.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` |
| 0.2% | 10.5ms | 0.2% | 10.5ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1204` |
| 0.2% | 10.3ms | 0.0% | 0us | `maskExcludedContent` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322831` |
| 0.2% | 10.3ms | 0.0% | 0us | `checkTagName2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334406` |
| 0.2% | 10.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334441` |
| 0.2% | 10.3ms | 0.0% | 0us | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317860` |
| 0.2% | 10.3ms | 0.0% | 2.9ms | `c` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.2% | 10.1ms | 0.0% | 3.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318458` |
| 0.2% | 10.1ms | 0.2% | 10.1ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4094` |
| 0.2% | 10.0ms | 0.2% | 10.0ms | `_getAllTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1945` |
| 0.2% | 10.0ms | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5170` |
| 0.2% | 9.9ms | 0.2% | 9.9ms | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318434` |
| 0.2% | 9.8ms | 0.2% | 9.8ms | `join` | `[native code]` |
| 0.2% | 9.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:12` |
| 0.2% | 9.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/convert.js:41` |
| 0.2% | 9.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/ast-converter.js:4` |
| 0.2% | 9.7ms | 0.0% | 1.3ms | `splitCR` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318063` |
| 0.2% | 9.7ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318127` |
| 0.2% | 9.5ms | 0.2% | 9.5ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318014` |
| 0.2% | 9.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317468` |
| 0.2% | 9.5ms | 0.2% | 9.5ms | `copyDataProperties` | `[native code]` |
| 0.2% | 9.5ms | 0.0% | 0us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4251` |
| 0.2% | 9.4ms | 0.0% | 1.8ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1027` |
| 0.2% | 9.4ms | 0.0% | 1.7ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318139` |
| 0.2% | 9.4ms | 0.0% | 0us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316299` |
| 0.2% | 9.4ms | 0.0% | 0us | `fixer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332422` |
| 0.2% | 9.3ms | 0.2% | 9.3ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2146` |
| 0.2% | 9.2ms | 0.1% | 6.2ms | `parslet` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315038` |
| 0.2% | 9.2ms | 0.2% | 9.2ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4522` |
| 0.2% | 9.2ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:490` |
| 0.2% | 9.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:19` |
| 0.2% | 9.2ms | 0.0% | 0us | `maskExcludedContent` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322832` |
| 0.2% | 9.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317603` |
| 0.2% | 9.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332923` |
| 0.2% | 9.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301141` |
| 0.2% | 9.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320241` |
| 0.2% | 8.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:7` |
| 0.2% | 8.9ms | 0.2% | 8.9ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1681` |
| 0.2% | 8.7ms | 0.2% | 8.7ms | `/(?:\[(?<text>[^\]]+)\])\{@(?<tag>[^\}\s]+)\s?(?<namepathOrURL>[^\}\s\\|]*)\}/dgv` | `[native code]` |
| 0.2% | 8.7ms | 0.2% | 8.7ms | `unshift` | `[native code]` |
| 0.2% | 8.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318799` |
| 0.2% | 8.5ms | 0.2% | 8.5ms | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318440` |
| 0.2% | 8.4ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:674` |
| 0.2% | 8.3ms | 0.1% | 6.5ms | `parseBlock` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318104` |
| 0.1% | 8.2ms | 0.1% | 8.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317512` |
| 0.1% | 8.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:38` |
| 0.1% | 8.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92697` |
| 0.1% | 8.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301099` |
| 0.1% | 8.0ms | 0.1% | 8.0ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318131` |
| 0.1% | 7.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/index.js:12` |
| 0.1% | 7.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/default-config.js:37` |
| 0.1% | 7.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/index.js:3` |
| 0.1% | 7.9ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:455` |
| 0.1% | 7.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:497` |
| 0.1% | 7.8ms | 0.0% | 2.9ms | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317830` |
| 0.1% | 7.7ms | 0.0% | 0us | `onNodeAllNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321188` |
| 0.1% | 7.7ms | 0.0% | 0us | `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321235` |
| 0.1% | 7.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289691` |
| 0.1% | 7.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:277093` |
| 0.1% | 7.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:277069` |
| 0.1% | 7.6ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:911` |
| 0.1% | 7.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320789` |
| 0.1% | 7.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317601` |
| 0.1% | 7.4ms | 0.1% | 7.4ms | `/\r+$/` | `[native code]` |
| 0.1% | 7.4ms | 0.0% | 1.3ms | `f` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.1% | 7.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:15` |
| 0.1% | 7.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:11` |
| 0.1% | 7.3ms | 0.1% | 7.3ms | `_getMergedIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2024` |
| 0.1% | 7.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320756` |
| 0.1% | 7.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323796` |
| 0.1% | 7.1ms | 0.0% | 0us | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318443` |
| 0.1% | 7.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334236` |
| 0.1% | 7.1ms | 0.0% | 1.4ms | `checkTagName` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334198` |
| 0.1% | 7.0ms | 0.1% | 7.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7509` |
| 0.1% | 6.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326641` |
| 0.1% | 6.8ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:673` |
| 0.1% | 6.8ms | 0.0% | 0us | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317855` |
| 0.1% | 6.7ms | 0.1% | 6.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7809` |
| 0.1% | 6.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332850` |
| 0.1% | 6.6ms | 0.1% | 6.6ms | `_getMergedIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2033` |
| 0.1% | 6.4ms | 0.1% | 6.4ms | `endsWith` | `[native code]` |
| 0.1% | 6.3ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320795` |
| 0.1% | 6.3ms | 0.1% | 6.3ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:590` |
| 0.1% | 6.2ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7806` |
| 0.1% | 6.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:276522` |
| 0.1% | 6.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333358` |
| 0.1% | 6.2ms | 0.0% | 0us | `getESLintCoreRule` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:174800` |
| 0.1% | 6.1ms | 0.1% | 6.1ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 6.1ms | 0.1% | 6.1ms | `Map` | `[native code]` |
| 0.1% | 6.1ms | 0.1% | 6.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318796` |
| 0.1% | 6.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332128` |
| 0.1% | 6.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320741` |
| 0.1% | 6.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319364` |
| 0.1% | 6.1ms | 0.0% | 0us | `getParamName` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319228` |
| 0.1% | 6.1ms | 0.0% | 0us | `getFunctionParameterNames` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319363` |
| 0.1% | 6.0ms | 0.0% | 0us | `maskCodeBlocks` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322839` |
| 0.1% | 6.0ms | 0.1% | 4.6ms | `replaceAll` | `[native code]` |
| 0.1% | 6.0ms | 0.1% | 6.0ms | `isNameOrNamepathDefiningTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319675` |
| 0.1% | 6.0ms | 0.1% | 6.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321192` |
| 0.1% | 6.0ms | 0.1% | 6.0ms | `Se` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.1% | 6.0ms | 0.1% | 6.0ms | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:609` |
| 0.1% | 6.0ms | 0.1% | 6.0ms | `maskCodeBlocks` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.1% | 5.9ms | 0.1% | 5.9ms | `/^\/\*(?!\*)/v` | `[native code]` |
| 0.1% | 5.9ms | 0.0% | 4.1ms | `getParser` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318098` |
| 0.1% | 5.8ms | 0.0% | 0us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7055` |
| 0.1% | 5.8ms | 0.1% | 5.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7807` |
| 0.1% | 5.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320942` |
| 0.1% | 5.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:20` |
| 0.1% | 5.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318470` |
| 0.1% | 5.8ms | 0.1% | 5.8ms | `seedSpec` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318077` |
| 0.1% | 5.8ms | 0.0% | 0us | `parseSpec` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318166` |
| 0.1% | 5.7ms | 0.1% | 5.7ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 5.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332756` |
| 0.1% | 5.6ms | 0.1% | 5.6ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318147` |
| 0.1% | 5.4ms | 0.1% | 5.4ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` |
| 0.1% | 5.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330137` |
| 0.1% | 5.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/getModifiers.js:39` |
| 0.1% | 5.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-modifiers.js:38` |
| 0.1% | 5.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328145` |
| 0.1% | 5.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12521` |
| 0.1% | 5.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290132` |
| 0.1% | 5.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:45765` |
| 0.1% | 5.0ms | 0.1% | 5.0ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:676` |
| 0.1% | 4.9ms | 0.1% | 4.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4238` |
| 0.1% | 4.9ms | 0.0% | 0us | `y` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.1% | 4.9ms | 0.0% | 0us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1261` |
| 0.1% | 4.9ms | 0.1% | 4.9ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318148` |
| 0.1% | 4.9ms | 0.1% | 4.9ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3634` |
| 0.1% | 4.8ms | 0.0% | 1.4ms | `reduce` | `[native code]` |
| 0.1% | 4.8ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:279` |
| 0.1% | 4.8ms | 0.0% | 0us | `fix10` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332417` |
| 0.1% | 4.8ms | 0.0% | 0us | `read` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316314` |
| 0.1% | 4.7ms | 0.1% | 4.7ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318154` |
| 0.1% | 4.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333255` |
| 0.1% | 4.7ms | 0.0% | 0us | `hasRejectValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333151` |
| 0.1% | 4.7ms | 0.0% | 0us | `hasRejectValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333154` |
| 0.1% | 4.7ms | 0.0% | 0us | `shouldReport` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333253` |
| 0.1% | 4.7ms | 0.1% | 4.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:656` |
| 0.1% | 4.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333682` |
| 0.1% | 4.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320859` |
| 0.1% | 4.7ms | 0.0% | 0us | `getTagStructureForMode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319664` |
| 0.1% | 4.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336920` |
| 0.1% | 4.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336919` |
| 0.1% | 4.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328953` |
| 0.1% | 4.7ms | 0.0% | 0us | `get globalScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4065` |
| 0.1% | 4.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319259` |
| 0.1% | 4.6ms | 0.0% | 0us | `getParamName` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319258` |
| 0.1% | 4.6ms | 0.1% | 4.6ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318140` |
| 0.1% | 4.6ms | 0.0% | 0us | `setTagStructure` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319141` |
| 0.1% | 4.6ms | 0.0% | 0us | `getSettings` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320988` |
| 0.1% | 4.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.1% | 4.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330563` |
| 0.1% | 4.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:312909` |
| 0.1% | 4.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329664` |
| 0.1% | 4.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329663` |
| 0.1% | 4.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329667` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317870` |
| 0.1% | 4.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333589` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318190` |
| 0.1% | 4.4ms | 0.0% | 0us | `parseComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318819` |
| 0.1% | 4.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328995` |
| 0.1% | 4.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328992` |
| 0.1% | 4.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328991` |
| 0.1% | 4.4ms | 0.0% | 0us | `preserveJoiner` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318429` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:649` |
| 0.1% | 4.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329215` |
| 0.1% | 4.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329194` |
| 0.1% | 4.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301149` |
| 0.1% | 4.3ms | 0.1% | 4.3ms | `getCommentsBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3527` |
| 0.1% | 4.3ms | 0.0% | 0us | `camelCase` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295621` |
| 0.1% | 4.3ms | 0.1% | 4.3ms | `toLocaleLowerCase` | `[native code]` |
| 0.1% | 4.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295623` |
| 0.1% | 4.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295641` |
| 0.1% | 4.3ms | 0.1% | 4.3ms | `_getMergedIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 4.3ms | 0.0% | 0us | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:966` |
| 0.1% | 4.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320928` |
| 0.1% | 4.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330449` |
| 0.1% | 4.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92623` |
| 0.1% | 4.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92521` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `Parser` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314896` |
| 0.0% | 3.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:37` |
| 0.0% | 3.4ms | 0.0% | 0us | `parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1261` |
| 0.0% | 3.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12515` |
| 0.0% | 3.4ms | 0.0% | 0us | `node:tty` | `node:tty:6` |
| 0.0% | 3.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12341` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `/^\/\*\*\s/v` | `[native code]` |
| 0.0% | 3.3ms | 0.0% | 0us | `getValidRuntimeIdentifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329078` |
| 0.0% | 3.3ms | 0.0% | 1.5ms | `createTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332392` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:593` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7217` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `substr` | `[native code]` |
| 0.0% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:11` |
| 0.0% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317500` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `cloneObject` | `[native code]` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `Ee` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 3.2ms | 0.0% | 1.6ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1284` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:40` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:110317` |
| 0.0% | 3.2ms | 0.0% | 0us | `addPolyfillToken` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301137` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301177` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/clear-caches.js:5` |
| 0.0% | 3.2ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1549` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138699` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313031` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138509` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `commentParserToESTree` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317393` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:18` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333346` |
| 0.0% | 3.2ms | 0.0% | 0us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321161` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333122` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318025` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330697` |
| 0.0% | 3.2ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:42213` |
| 0.0% | 3.2ms | 0.0% | 1.5ms | `exemptSpeciaMethods` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320029` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333894` |
| 0.0% | 3.1ms | 0.0% | 0us | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2158` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `search` | `[native code]` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318357` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `hasTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319489` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3708` |
| 0.0% | 3.1ms | 0.0% | 0us | `getDefaultTagStructureForMode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313576` |
| 0.0% | 3.1ms | 0.0% | 0us | `fix10` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332410` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332132` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `trimEnd` | `[native code]` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318021` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7803` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2827` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333155` |
| 0.0% | 3.0ms | 0.0% | 0us | `_fromRunnerReport` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:205` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318129` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `defineProperty` | `[native code]` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `read` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316313` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `preserveJoiner` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318428` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1262` |
| 0.0% | 3.0ms | 0.0% | 0us | `FunctionDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332020` |
| 0.0% | 3.0ms | 0.0% | 0us | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321150` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `exit` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_getMergedIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2039` |
| 0.0% | 3.0ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320762` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:21` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:22` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint/plugin-kit/dist/cjs/index.cjs:3` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-modifiers.js:39` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `parseBlock` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333904` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1194` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326797` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `log` | `[native code]` |
| 0.0% | 3.0ms | 0.0% | 0us | `setDeps` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326787` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/rules.js:3` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:9` |
| 0.0% | 3.0ms | 0.0% | 0us | `exec` | `[native code]` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.0% | 3.0ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2607` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320780` |
| 0.0% | 2.9ms | 0.0% | 1.3ms | `camelCase` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295617` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7219` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318416` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `trim` | `[native code]` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `getTokenizers` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318761` |
| 0.0% | 2.9ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2978` |
| 0.0% | 2.9ms | 0.0% | 0us | `isNameOrNamepathDefiningTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319671` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320327` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320332` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `join` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318467` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329199` |
| 0.0% | 2.9ms | 0.0% | 1.6ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:675` |
| 0.0% | 2.9ms | 0.0% | 0us | `commentParserToESTree` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317398` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318042` |
| 0.0% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/index.js:3` |
| 0.0% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:3` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `parseBlock` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318103` |
| 0.0% | 2.8ms | 0.0% | 1.6ms | `isConstructor` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319996` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4106` |
| 0.0% | 2.7ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320391` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330151` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334431` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `checkJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321339` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:14` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:312924` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:53` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/resolveProjectList.js:10` |
| 0.0% | 2.7ms | 0.0% | 0us | `canSkip` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333223` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333230` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:678` |
| 0.0% | 2.7ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1544` |
| 0.0% | 2.6ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318395` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `getIndentAndJSDoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321082` |
| 0.0% | 2.6ms | 0.0% | 0us | `validateDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330340` |
| 0.0% | 2.6ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330372` |
| 0.0% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91298` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327552` |
| 0.0% | 2.5ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7392` |
| 0.0% | 2.5ms | 0.0% | 0us | `_getOrBuildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6287` |
| 0.0% | 2.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313078` |
| 0.0% | 2.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92620` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320918` |
| 0.0% | 2.4ms | 0.0% | 0us | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318444` |
| 0.0% | 2.4ms | 0.0% | 2.4ms | `getParser3` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318163` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:241938` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:241731` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289572` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1302` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:271668` |
| 0.0% | 1.8ms | 0.0% | 0us | `findIndex` | `[native code]` |
| 0.0% | 1.8ms | 0.0% | 0us | `findExpectedIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332165` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332173` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332172` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:312911` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318007` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320920` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330131` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `toReversed` | `[native code]` |
| 0.0% | 1.8ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4276` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3973` |
| 0.0% | 1.8ms | 0.0% | 0us | `hasRejectValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333180` |
| 0.0% | 1.8ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2264` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:187895` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:187857` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:187886` |
| 0.0% | 1.8ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2475` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201869` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:916` |
| 0.0% | 1.8ms | 0.0% | 0us | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:900` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `getLocFromIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:166639` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:168014` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:168169` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:168154` |
| 0.0% | 1.8ms | 0.0% | 0us | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4229` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:166697` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313289` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318026` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330921` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `internal:fs/streams` | `internal:fs/streams:158` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:21` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_fromRunnerReport` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:207` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333077` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:325967` |
| 0.0% | 1.7ms | 0.0% | 0us | `parse` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:53159` |
| 0.0% | 1.7ms | 0.0% | 0us | `Comparator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:53138` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:53535` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `SemVer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:53708` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:294928` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/dotjs/index.js:17` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `values` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `getPreferredTagNameSimple` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319451` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/private/tmp/prof_jsdoc.js:2` |
| 0.0% | 1.7ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201881` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190380` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190337` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190372` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:23` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2979` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/cli-engine/lint-result-cache.js:12` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `/^@[^\s/]+(?=\s\|$)/` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getFencer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318115` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320771` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171466` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171429` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171458` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171550` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/eslint-utils/astUtilities.js:37` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/index.js:17` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/eslint-utils/astUtilities.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/eslint-utils/index.js:17` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getDefaultTagStructureForMode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313939` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:10` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/dom.js:9` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/es2015.js:8` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:182911` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201846` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/private/tmp/prof_jsdoc.js:9` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323790` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318769` |
| 0.0% | 1.7ms | 0.0% | 0us | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318436` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `typeTokenizer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318203` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:670` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228441` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289535` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228050` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228702` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228543` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4130` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `Parser` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314910` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313417` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:146402` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:146346` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313051` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320720` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332426` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320627` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3692` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:54` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:169412` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173237` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201918` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:198158` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:198166` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1252` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:22610` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `flatten` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138272` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:136510` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137941` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326023` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318045` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:266521` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:266460` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317852` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:266364` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:266391` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289690` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `preserveJoiner` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318427` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2150` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:44` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318130` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_getMergedIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1973` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:20` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164402` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321101` |
| 0.0% | 1.7ms | 0.0% | 0us | `checkNonJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326197` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326198` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:223096` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289517` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getBasicUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320240` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get declaration` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3611` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301183` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `parse2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316975` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318151` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170533` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170488` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172340` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170517` |
| 0.0% | 1.7ms | 0.0% | 0us | `SemVer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:162913` |
| 0.0% | 1.6ms | 0.0% | 0us | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3662` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_isStatementTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316301` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_Lexer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316303` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320575` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330565` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:45` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290098` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `descriptionTokenizer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318401` |
| 0.0% | 1.6ms | 0.0% | 0us | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318438` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320814` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1136` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320895` |
| 0.0% | 1.6ms | 0.0% | 0us | `filterTags` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319495` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320894` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329242` |
| 0.0% | 1.6ms | 0.0% | 0us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4217` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329245` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319496` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236594` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236471` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:232339` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289550` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236366` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289727` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:285032` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:285117` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:284960` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/getWatchProgramsForProjects.js:30` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/getWatchProgramsForProjects.js:43` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/getWatchProgramsForProjects.js:4` |
| 0.0% | 1.6ms | 0.0% | 0us | `camelCase` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295625` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301171` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get lexer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314924` |
| 0.0% | 1.6ms | 0.0% | 0us | `uniqueSymbolParslet` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316850` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109700` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:97042` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:97097` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:123` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319601` |
| 0.0% | 1.6ms | 0.0% | 0us | `canSkip2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333320` |
| 0.0% | 1.6ms | 0.0% | 0us | `hasATag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319600` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320777` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318763` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:24` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/find-up/index.js:4` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config-loader.js:14` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_getMergedIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2017` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:178969` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201820` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:178318` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:178599` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:178990` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327824` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `read` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316323` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `accept` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315083` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334119` |
| 0.0% | 1.6ms | 0.0% | 0us | `shouldReport` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334117` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `useColors` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12454` |
| 0.0% | 1.6ms | 0.0% | 0us | `createDebug` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12070` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:200893` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:200931` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:200922` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290081` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:1664` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201928` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:560` |
| 0.0% | 1.6ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1746` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/code-path-analysis/code-path.js:12` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:288208` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:288245` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/code-path-analysis/code-path-analyzer.js:14` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289744` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:16` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/code-path-analysis/code-path-segment.js:12` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/code-path-analysis/code-path-state.js:12` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `be` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_tokType` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317456` |
| 0.0% | 1.6ms | 0.0% | 0us | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318437` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `nameTokenizer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318275` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334229` |
| 0.0% | 1.6ms | 0.0% | 0us | `canSkip5` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334195` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317913` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322295` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328784` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320889` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2144` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289698` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:279822` |
| 0.0% | 1.6ms | 0.0% | 0us | `splitPrefixSuffix` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295677` |
| 0.0% | 1.6ms | 0.0% | 0us | `split` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295588` |
| 0.0% | 1.6ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:331944` |
| 0.0% | 1.6ms | 0.0% | 0us | `checkJsDoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:331971` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `encodeInto` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:220` |
| 0.0% | 1.6ms | 0.0% | 0us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:659` |
| 0.0% | 1.6ms | 0.0% | 0us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316297` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8302` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91300` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:90428` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `ensureMap` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319626` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:192911` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:192920` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201893` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:192882` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:105264` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:106429` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109709` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:106842` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320427` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:335471` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:335474` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/dot-notation.js:12` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313120` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:176119` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:263291` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:263207` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289673` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301172` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290382` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:48478` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:47927` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:47620` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:46468` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:48398` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:51201` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `inverseMap` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:46720` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:51143` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:4` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:48` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:30` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/getWatchProgramsForProjects.js:45` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `ge` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:325987` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `validateDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330339` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321771` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `generateNamedReferences` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321757` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `onNodeWithComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321176` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_applySchemaDefaults` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:181` |
| 0.0% | 1.5ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4777` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201865` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:186753` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:186763` |
| 0.0% | 1.5ms | 0.0% | 0us | `flatMap` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.0% | 0us | `canSkip2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333327` |
| 0.0% | 1.5ms | 0.0% | 0us | `isGetter2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319999` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get kind` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2738` |
| 0.0% | 1.5ms | 0.0% | 0us | `exemptSpeciaMethods` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320032` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:335396` |
| 0.0% | 1.5ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2485` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get multiline` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:4` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/parse-string.js:113` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/parse-string.js:4` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/prelude-ls/lib/index.js:4` |
| 0.0% | 1.5ms | 0.0% | 0us | `getDefaultTagStructureForMode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313867` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `predicateParslet` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315038` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:244143` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:244045` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:244113` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289584` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172409` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172433` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172374` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:58223` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:54196` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:296352` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317566` |
| 0.0% | 1.5ms | 0.0% | 0us | `_NoParsletFoundError` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314670` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `setPrototypeOf` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getTokenizers` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328176` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290248` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:335666` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:14` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createIsolatedProgram.js:42` |
| 0.0% | 1.5ms | 0.0% | 0us | `_getMergedIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1979` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `read` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316311` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/TypeVisitor.js:6` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:8` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:128050` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:123501` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:122926` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/scope/CatchScope.js:5` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:122919` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/ClassVisitor.js:6` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:123490` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/scope/index.js:18` |
| 0.0% | 1.5ms | 0.0% | 0us | `canSkip4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334089` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320932` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334095` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:249445` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/source-code-traverser.js:12` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/esquery.js:12` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:249533` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289613` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:48` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:261166` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260359` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260167` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:261100` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260469` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171766` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171719` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171756` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260567` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289663` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:230592` |
| 0.0% | 1.5ms | 0.0% | 0us | `get key` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3213` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:230635` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289542` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329198` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/token-store/cursors.js:11` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/token-store/index.js:13` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/token-store/backward-token-comment-cursor.js:11` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320882` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138274` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/api.js:14` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rule-tester/index.js:3` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320941` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313036` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:199268` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:199297` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint/config-array/dist/cjs/index.cjs:4` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201923` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:595` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:199306` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:180363` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:180328` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:180372` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201826` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320314` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201837` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:181785` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:181748` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:181777` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332097` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `hasTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319490` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332160` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `registerCodeFix` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:155874` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/types/dist/index.js:23` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/index.js:20` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:162742` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-estree.js:6` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/predicates.js:5` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getPreferredTagNameSimple` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319448` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `canSkip6` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334400` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:5` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317416` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201859` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:185313` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318291` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:337181` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329670` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329671` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `cleanUpLastTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326447` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `createTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332388` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/type-check/lib/index.js:16` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/type-check/lib/index.js:5` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/type-check/lib/parse-type.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:5` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/type-check/lib/parse-type.js:198` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/cast.js:4` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/cast.js:327` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328781` |
| 0.0% | 1.4ms | 0.0% | 0us | `splitTextIntoWords` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326873` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | ````/([ \t]+\*)[ \t]```[^\n]*?([\w\\|\W]*?\n)(?=[ \t]*\*(?:[ \t]*(?:```\|@\w+\s)\|\/))/gv```` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326976` |
| 0.0% | 1.4ms | 0.0% | 0us | `descriptionIsRedundant` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326954` |
| 0.0% | 1.4ms | 0.0% | 0us | `areDocsInformative` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326859` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326874` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/minimatch/dist/commonjs/index.js:6` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201908` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:196453` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:196461` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:196424` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7819` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `fix10` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332349` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333756` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330138` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321402` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getContexts` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328706` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2325` |
| 0.0% | 1.4ms | 0.0% | 0us | `getDefaultTagStructureForMode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314084` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328155` |
| 0.0% | 1.4ms | 0.0% | 0us | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2340` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getDefaultTagStructureForMode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313699` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183953` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183909` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:8` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183944` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201850` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `checkJsDoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:331855` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321102` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289651` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:257157` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:257153` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:257227` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:257284` |
| 0.0% | 1.4ms | 0.0% | 0us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321298` |
| 0.0% | 1.4ms | 0.0% | 0us | `parse` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js:906` |
| 0.0% | 1.4ms | 0.0% | 0us | `addSchema` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:137` |
| 0.0% | 1.4ms | 0.0% | 0us | `_normalizeIPv6` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js:812` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:29` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:16` |
| 0.0% | 1.4ms | 0.0% | 0us | `addMetaSchema` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:152` |
| 0.0% | 1.4ms | 0.0% | 0us | `resolveIds` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:235` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `regExpMatchFast` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `_addSchema` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:309` |
| 0.0% | 1.4ms | 0.0% | 0us | `getFullPath` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:209` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318277` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `charCodeAt` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2753` |
| 0.0% | 1.4ms | 0.0% | 0us | `cleanUpLastTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317365` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `stripEncapsulatingBrackets` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317350` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getJsdocTagsDeep` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319372` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `at` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:293086` |
| 0.0% | 1.4ms | 0.0% | 0us | `assign` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `get` | `node:assert:575` |
| 0.0% | 1.4ms | 0.0% | 0us | `node:assert/strict` | `node:assert/strict:3` |
| 0.0% | 1.4ms | 0.0% | 0us | `node:assert` | `node:assert:588` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336984` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:38` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `__export` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:23` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289524` |
| 0.0% | 1.4ms | 0.0% | 0us | `requestInstantiate` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `fetch` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `requestSatisfyUtil` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `requestFetch` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318454` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332122` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:212973` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322393` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:211438` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320460` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_getAllTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1948` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:681` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `accept` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `preserveJoiner` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318424` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `emit` | `node:events` |
| 0.0% | 1.4ms | 0.0% | 0us | `onConstruct` | `internal:streams/destroy:144` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:215932` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:276523` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:215647` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289484` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:215828` |
| 0.0% | 1.3ms | 0.0% | 0us | `reportings` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326185` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `addComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326204` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326176` |
| 0.0% | 1.3ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326147` |
| 0.0% | 1.3ms | 0.0% | 0us | `checkNonJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326210` |
| 0.0% | 1.3ms | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4291` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `Boolean` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317498` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `linkAndEvaluateModule` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `async loadAndEvaluateModule` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `validateDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327222` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320366` |
| 0.0% | 1.3ms | 0.0% | 0us | `getRegexFromString` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320063` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `/^\s+/` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301150` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289711` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:282301` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:42` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:282222` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:42` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/es2017.js:15` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/project-service/dist/createProjectService.js:8` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:30` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/project-service/dist/index.js:17` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `reportings` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326192` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326240` |
| 0.0% | 1.3ms | 0.0% | 0us | `checkNonJsdocAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326230` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:43023` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290353` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `/\s*(@(\S+))(\s*)/` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330382` |
| 0.0% | 1.3ms | 0.0% | 0us | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4166` |
| 0.0% | 1.3ms | 0.0% | 0us | `fix10` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330347` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_computeIdentifierName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2334` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4827` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290300` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318766` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318209` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334429` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313115` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201900` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201884` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328150` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190758` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4210` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326519` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201906` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:196154` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:325959` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4158` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2089` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `[Symbol.split]` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:17` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173278` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `createNamedRule` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/eslint-utils/RuleCreator.js:18` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:238154` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289557` |
| 0.0% | 1.3ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:653` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/node-utils.js:76` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:69` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `ensureMap` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319629` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getPreferredTagName` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319508` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334098` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:717` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317477` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317536` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6578` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289597` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:246440` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:246288` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:246242` |
| 0.0% | 1.3ms | 0.0% | 0us | `findExpectedIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332182` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:246361` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `at` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2054` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2104` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7495` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92619` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289636` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:254650` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:254632` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:254474` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:94790` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96799` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:94742` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:110315` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:272045` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:159496` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161552` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161606` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161302` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161363` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `fix10` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330343` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330386` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `hasRejectValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333143` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329007` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:6125` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:18` |
| 0.0% | 1.2ms | 0.0% | 0us | `getLocFromIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3785` |
| 0.0% | 1.2ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2543` |
| 0.0% | 1.2ms | 0.0% | 0us | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4230` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_findLine` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:573` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_mkGlobalVar` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:709` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1540` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289501` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:219660` |
| 0.0% | 1.2ms | 0.0% | 0us | `canSkip6` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334403` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:99` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201875` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `add` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301200` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:17596` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290169` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313027` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:183987` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188471` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188462` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201872` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188427` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `checkJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321336` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:217508` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:217671` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289490` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getParser` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318099` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3682` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318445` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301198` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332144` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:152815` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161604` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:152901` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317921` |
| 0.0% | 1.2ms | 0.0% | 0us | `_fuseHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5077` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `toString` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 0us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6590` |
| 0.0% | 1.2ms | 0.0% | 0us | `_analyzeHandler` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4982` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320404` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333582` |
| 0.0% | 1.2ms | 0.0% | 0us | `parseNamePath` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317060` |
| 0.0% | 1.2ms | 0.0% | 0us | `validNamepathParsing` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336793` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get kind` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2734` |
| 0.0% | 1.2ms | 0.0% | 0us | `tryParsePathIgnoreError` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336764` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320753` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336975` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `parslet` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315039` |
| 0.0% | 1.2ms | 0.0% | 0us | `canSkip3` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333567` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/dotjs/index.js:31` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `push` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/lazy-loading-rule-map.js:7` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/default-config.js:12` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/index.js:9` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/index.js:11` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/node.js:12` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:128005` |
| 0.0% | 1.2ms | 0.0% | 0us | `isSpace` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318060` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `/^\s+$/` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333240` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318303` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/index.js:3` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/fdir/dist/index.cjs:462` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/tinyglobby/dist/index.cjs:27` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170810` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172343` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170800` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289625` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:251761` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:251668` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318035` |
| 0.0% | 1.1ms | 0.0% | 1.1ms | `cleanUpLastTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317370` |
| 0.0% | 977us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:324400` |

## Function Details

### `anonymous`
`[native code]` | Self: 5.7% (239.8ms) | Total: 37.4% (1.55s) | Samples: 156

**Called by:**
- `require` (755)
- `bound require` (5)
- `node:tty` (2)
- `node:assert/strict` (1)
- `get` (1)
- `node:fs` (1)

**Calls:**
- `(anonymous)` (50)
- `(anonymous)` (38)
- `(anonymous)` (28)
- `(anonymous)` (23)
- `(anonymous)` (23)
- `(anonymous)` (19)
- `(anonymous)` (19)
- `(anonymous)` (17)
- `(anonymous)` (15)
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
- `(anonymous)` (8)
- `(anonymous)` (8)
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
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `node:tty` (2)
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
- `node:assert` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:fs/streams` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
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
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
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
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `parse`
`[native code]` | Self: 5.5% (229.3ms) | Total: 5.5% (229.3ms) | Samples: 155

**Called by:**
- `parseSource` (153)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1302` | Self: 5.2% (219.3ms) | Total: 5.2% (219.3ms) | Samples: 145

**Called by:**
- `_getAllTokens` (143)
- `_getTokensAndCommentsMerged` (2)

### `get flags`
`[native code]` | Self: 3.3% (137.0ms) | Total: 3.3% (138.5ms) | Samples: 87

**Called by:**
- `matchAll` (88)

**Calls:**
- `get multiline` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1290` | Self: 2.8% (119.3ms) | Total: 2.8% (119.3ms) | Samples: 78

**Called by:**
- `_getAllTokens` (75)
- `_getTokensAndCommentsMerged` (3)

### `entries`
`[native code]` | Self: 2.8% (117.1ms) | Total: 2.8% (117.1ms) | Samples: 77

**Called by:**
- `getPreferredTagNameSimple` (77)

### ``/^\n?([A-Z`\d_][\s\S]*[.?!`\p{RGI_Emoji}]\s*)?$/v``
`[native code]` | Self: 2.4% (100.3ms) | Total: 2.4% (100.3ms) | Samples: 65

**Called by:**
- `test` (65)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 2.1% (90.3ms) | Total: 2.1% (90.3ms) | Samples: 60

**Called by:**
- `(anonymous)` (48)
- `iterate` (2)
- `some` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `shouldReport` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329659` | Self: 2.1% (87.9ms) | Total: 2.3% (96.0ms) | Samples: 57

**Called by:**
- `filter` (62)

**Calls:**
- `/^\*(?!\*)/v` (4)
- `test` (1)

### `getOwnPropertyDescriptor`
`[native code]` | Self: 2.0% (83.1ms) | Total: 2.0% (83.1ms) | Samples: 11

**Called by:**
- `(anonymous)` (5)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328987` | Self: 1.9% (81.3ms) | Total: 2.8% (116.7ms) | Samples: 53

**Called by:**
- `filter` (76)

**Calls:**
- `/^\s*globals/v` (23)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328982` | Self: 1.9% (80.4ms) | Total: 2.2% (92.1ms) | Samples: 53

**Called by:**
- `filter` (61)

**Calls:**
- `/^\*(?!\*)/v` (7)
- `test` (1)

### `/(?<!\])\{@(?<tag>[^\}\s]+)\s?(?<namepathOrURL>[^\}\s\\|]*)\s*(?<separator>[\s\\|])?\s*(?<text>[^\}]*)\}/dgv`
`[native code]` | Self: 1.9% (78.6ms) | Total: 1.9% (78.6ms) | Samples: 52

**Called by:**
- `regExpExec` (52)

### `filter`
`[native code]` | Self: 1.5% (65.4ms) | Total: 13.3% (550.9ms) | Samples: 43

**Called by:**
- `(anonymous)` (105)
- `(anonymous)` (87)
- `(anonymous)` (79)
- `(anonymous)` (70)
- `onProgramExit` (9)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `findExpectedIndex` (1)
- `filterTags` (1)
- `(anonymous)` (1)
- `_execReport` (1)

**Calls:**
- `(anonymous)` (76)
- `(anonymous)` (76)
- `(anonymous)` (62)
- `(anonymous)` (61)
- `(anonymous)` (18)
- `(anonymous)` (7)
- `(anonymous)` (4)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `Boolean` (1)

### `regExpSplitFast`
`[native code]` | Self: 1.5% (63.9ms) | Total: 2.3% (95.3ms) | Samples: 43

**Called by:**
- `get lines` (35)
- `splitLines` (28)

**Calls:**
- `/\r\n\|\r\|\n\|\u2028\|\u2029/` (20)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7847` | Self: 1.4% (59.4ms) | Total: 58.7% (2.42s) | Samples: 40

**Called by:**
- `runPlugins` (1589)

**Calls:**
- `_invokeFused` (825)
- `_invokeFused` (376)
- `_invokeFused` (243)
- `_invokeFused` (82)
- `_nodeViewRaw` (12)
- `_invokeFused` (6)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `getAncestors`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3795` | Self: 1.4% (58.5ms) | Total: 1.4% (58.5ms) | Samples: 39

**Called by:**
- `getUtils` (39)

### `getValidRuntimeIdentifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329079` | Self: 1.2% (53.4ms) | Total: 1.2% (53.4ms) | Samples: 35

**Called by:**
- `(anonymous)` (35)

### `SemVer`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:162890` | Self: 1.2% (52.6ms) | Total: 1.2% (52.6ms) | Samples: 2

**Called by:**
- `parse` (2)

### `stringSplitFast`
`[native code]` | Self: 1.2% (52.2ms) | Total: 1.2% (52.2ms) | Samples: 34

**Called by:**
- `(anonymous)` (32)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `Set`
`[native code]` | Self: 1.1% (47.7ms) | Total: 1.1% (47.7ms) | Samples: 31

**Called by:**
- `(anonymous)` (31)

### `parseIntermediateType`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314939` | Self: 0.9% (41.3ms) | Total: 1.6% (70.0ms) | Samples: 27

**Called by:**
- `parseType` (45)

**Calls:**
- `_NoParsletFoundError` (17)
- `_NoParsletFoundError` (1)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2102` | Self: 0.9% (37.7ms) | Total: 1.4% (58.8ms) | Samples: 24

**Called by:**
- `getTokensBefore` (38)

**Calls:**
- `_makeToken` (5)
- `_makeToken` (4)
- `_makeToken` (3)
- `_makeToken` (2)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318029` | Self: 0.8% (35.8ms) | Total: 0.8% (35.8ms) | Samples: 24

**Called by:**
- `checkJsdoc` (24)

### `/^\s*globals/v`
`[native code]` | Self: 0.8% (35.3ms) | Total: 0.8% (35.3ms) | Samples: 23

**Called by:**
- `(anonymous)` (23)

### `[Symbol.match]`
`[native code]` | Self: 0.8% (34.2ms) | Total: 1.0% (44.5ms) | Samples: 22

**Called by:**
- `match` (29)

**Calls:**
- `/\r+$/` (5)
- `/\s*(@(\S+))(\s*)/` (1)
- `/^\s+/` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1287` | Self: 0.8% (33.8ms) | Total: 1.1% (47.3ms) | Samples: 23

**Called by:**
- `_getAllTokens` (30)
- `at` (2)

**Calls:**
- `_getJsxTextTokFlags` (7)
- `_getJsxTextTokFlags` (2)

### `/\r\n\|\r\|\n\|\u2028\|\u2029/`
`[native code]` | Self: 0.7% (31.4ms) | Total: 0.7% (31.4ms) | Samples: 20

**Called by:**
- `regExpSplitFast` (20)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7661` | Self: 0.7% (31.1ms) | Total: 0.7% (31.1ms) | Samples: 21

**Called by:**
- `runPlugins` (21)

### `_getMergedIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2014` | Self: 0.7% (30.3ms) | Total: 0.7% (30.3ms) | Samples: 21

**Called by:**
- `getTokenBefore` (21)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1262` | Self: 0.7% (29.1ms) | Total: 0.7% (29.1ms) | Samples: 19

**Called by:**
- `_getAllTokens` (19)

### `Error`
`[native code]` | Self: 0.6% (27.2ms) | Total: 0.6% (27.2ms) | Samples: 17

**Called by:**
- `_NoParsletFoundError` (17)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1677` | Self: 0.6% (26.7ms) | Total: 3.2% (134.2ms) | Samples: 17

**Called by:**
- `findJSDocComment` (87)
- `getReducedASTNode` (2)

**Calls:**
- `_getMergedIndex` (21)
- `_getMergedIndex` (18)
- `_getMergedIndex` (16)
- `_getMergedIndex` (5)
- `_getMergedIndex` (4)
- `_getMergedIndex` (3)
- `_getMergedIndex` (2)
- `_getMergedIndex` (1)
- `_getMergedIndex` (1)
- `_getMergedIndex` (1)

### `map`
`[native code]` | Self: 0.6% (26.5ms) | Total: 18.4% (762.2ms) | Samples: 18

**Called by:**
- `(anonymous)` (242)
- `(anonymous)` (155)
- `(anonymous)` (61)
- `compactJoiner` (6)
- `(anonymous)` (6)
- `f` (4)
- `getFunctionParameterNames` (4)
- `(anonymous)` (3)
- `getParamName` (3)
- `camelCase` (3)
- `_lintSourceOne` (3)
- `(anonymous)` (2)
- `commentParserToESTree` (2)
- `preserveJoiner` (1)
- `(anonymous)` (1)
- `SemVer` (1)

**Calls:**
- `(anonymous)` (242)
- `(anonymous)` (153)
- `parseSpec` (35)
- `parseSpec` (14)
- `parseSpec` (4)
- `(anonymous)` (4)
- `c` (4)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `_fromRunnerReport` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `_fromRunnerReport` (1)
- `(anonymous)` (1)

### `getParser2`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318121` | Self: 0.5% (24.2ms) | Total: 0.5% (24.2ms) | Samples: 16

**Called by:**
- `getParser4` (16)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.5% (23.8ms) | Total: 3.5% (146.8ms) | Samples: 15

**Called by:**
- `ke` (44)
- `(anonymous)` (40)
- `(anonymous)` (6)
- `y` (3)

**Calls:**
- `(anonymous)` (40)
- `Ce` (18)
- `_e` (7)
- `y` (3)
- `c` (3)
- `substr` (2)
- `Ee` (2)
- `be` (1)
- `(anonymous)` (1)
- `ge` (1)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318032` | Self: 0.5% (23.3ms) | Total: 0.5% (23.3ms) | Samples: 15

**Called by:**
- `checkJsdoc` (13)
- `(anonymous)` (1)
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (1)

### `_getMergedIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2022` | Self: 0.5% (23.3ms) | Total: 0.5% (24.7ms) | Samples: 15

**Called by:**
- `getTokenBefore` (16)

**Calls:**
- `charCodeAt` (1)

### `parseSpec`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318169` | Self: 0.5% (21.1ms) | Total: 0.5% (21.1ms) | Samples: 14

**Called by:**
- `map` (14)

### `test`
`[native code]` | Self: 0.4% (20.2ms) | Total: 2.9% (120.5ms) | Samples: 13

**Called by:**
- `validateDescription` (75)
- `callIterator` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- ``/^\n?([A-Z`\d_][\s\S]*[.?!`\p{RGI_Emoji}]\s*)?$/v`` (65)

### `getText`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1348` | Self: 0.4% (19.8ms) | Total: 0.4% (19.8ms) | Samples: 13

**Called by:**
- `callIterator` (10)
- `(anonymous)` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7982` | Self: 0.4% (18.0ms) | Total: 0.4% (18.0ms) | Samples: 11

**Called by:**
- `runPlugins` (11)

### `esSpecIsRegExp`
`[native code]` | Self: 0.4% (17.9ms) | Total: 0.4% (17.9ms) | Samples: 12

**Called by:**
- `matchAll` (12)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318044` | Self: 0.4% (17.8ms) | Total: 17.2% (713.6ms) | Samples: 12

**Called by:**
- `checkJsdoc` (427)
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (44)

**Calls:**
- `getJSDocComment` (434)
- `getJSDocComment` (24)
- `getJSDocComment` (1)

### `trimStart`
`[native code]` | Self: 0.4% (17.2ms) | Total: 0.4% (17.2ms) | Samples: 11

**Called by:**
- `(anonymous)` (7)
- `read` (3)
- `(anonymous)` (1)

### `callIterator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321103` | Self: 0.4% (17.1ms) | Total: 0.8% (37.0ms) | Samples: 11

**Called by:**
- `onProgramExit` (24)

**Calls:**
- `getText` (10)
- `/^\/\*\*\s/v` (2)
- `test` (1)

### `_getAllTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1944` | Self: 0.4% (16.6ms) | Total: 10.9% (452.7ms) | Samples: 11

**Called by:**
- `_getTokensAndCommentsMerged` (299)

**Calls:**
- `_makeToken` (143)
- `_makeToken` (75)
- `_makeToken` (30)
- `_makeToken` (19)
- `_makeToken` (10)
- `_makeToken` (9)
- `_makeToken` (2)

### `/^\*(?!\*)/v`
`[native code]` | Self: 0.4% (16.5ms) | Total: 0.4% (16.5ms) | Samples: 11

**Called by:**
- `(anonymous)` (7)
- `(anonymous)` (4)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1294` | Self: 0.3% (15.5ms) | Total: 0.3% (15.5ms) | Samples: 10

**Called by:**
- `_getAllTokens` (10)

### `[Symbol.matchAll]`
`[native code]` | Self: 0.3% (15.5ms) | Total: 0.3% (15.5ms) | Samples: 10

**Called by:**
- `parseDescription` (6)
- `parseDescription` (4)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.3% (15.3ms) | Total: 0.3% (15.3ms) | Samples: 10

**Called by:**
- `getJSDocComment` (8)
- `getNonJsdocComment` (1)
- `findJSDocComment` (1)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2109` | Self: 0.3% (14.5ms) | Total: 0.3% (14.5ms) | Samples: 10

**Called by:**
- `getTokensBefore` (10)

### `getParser2`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318123` | Self: 0.3% (14.2ms) | Total: 0.3% (14.2ms) | Samples: 9

**Called by:**
- `getParser4` (9)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.3% (14.0ms) | Total: 0.3% (14.0ms) | Samples: 10

**Called by:**
- `commentsInRange` (5)
- `commentsInRange` (5)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318132` | Self: 0.3% (13.4ms) | Total: 0.3% (13.4ms) | Samples: 9

**Called by:**
- `(anonymous)` (9)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7513` | Self: 0.3% (13.3ms) | Total: 0.3% (13.3ms) | Samples: 9

**Called by:**
- `runPlugins` (9)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318017` | Self: 0.3% (13.1ms) | Total: 0.3% (13.1ms) | Samples: 9

**Called by:**
- `getJSDocComment` (6)
- `getNonJsdocComment` (3)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1230` | Self: 0.3% (13.1ms) | Total: 0.3% (13.1ms) | Samples: 9

**Called by:**
- `_getTokensAndCommentsMerged` (5)
- `at` (4)

### `RegExp`
`[native code]` | Self: 0.3% (13.1ms) | Total: 0.3% (13.1ms) | Samples: 9

**Called by:**
- `maskExcludedContent` (7)
- `getRegexFromString` (1)
- `fix10` (1)

### `seedTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318080` | Self: 0.3% (13.0ms) | Total: 0.3% (13.0ms) | Samples: 8

**Called by:**
- `parseSource` (8)

### `stringIncludesInternal`
`[native code]` | Self: 0.3% (13.0ms) | Total: 0.3% (13.0ms) | Samples: 9

**Called by:**
- `matchAll` (9)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1266` | Self: 0.3% (12.9ms) | Total: 0.3% (12.9ms) | Samples: 9

**Called by:**
- `_getAllTokens` (9)

### `includes`
`[native code]` | Self: 0.3% (12.7ms) | Total: 0.3% (12.7ms) | Samples: 9

**Called by:**
- `(anonymous)` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301189` | Self: 0.3% (12.4ms) | Total: 0.3% (12.4ms) | Samples: 8

**Called by:**
- `anonymous` (8)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4211` | Self: 0.2% (12.2ms) | Total: 0.2% (12.2ms) | Samples: 8

**Called by:**
- `walkNodes` (3)
- `getAncestors` (2)
- `get parent` (2)
- `_nodesFromRange` (1)

### `splitSpace`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318068` | Self: 0.2% (12.2ms) | Total: 0.2% (12.2ms) | Samples: 8

**Called by:**
- `parseSource` (4)
- `parseSource` (3)
- `parseSource` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328146` | Self: 0.2% (12.1ms) | Total: 0.6% (27.3ms) | Samples: 8

**Called by:**
- `filter` (18)

**Calls:**
- `trimStart` (7)
- `/^\/\*(?!\*)/v` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` | Self: 0.2% (11.6ms) | Total: 0.2% (11.6ms) | Samples: 8

**Called by:**
- `(anonymous)` (7)
- `(anonymous)` (1)

### `concat`
`[native code]` | Self: 0.2% (11.3ms) | Total: 0.2% (11.3ms) | Samples: 6

**Called by:**
- `(anonymous)` (4)
- `(anonymous)` (2)

### `replace`
`[native code]` | Self: 0.2% (10.8ms) | Total: 0.2% (10.8ms) | Samples: 7

**Called by:**
- `maskExcludedContent` (6)
- `split` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319474` | Self: 0.2% (10.6ms) | Total: 0.5% (23.3ms) | Samples: 7

**Called by:**
- `find` (16)

**Calls:**
- `includes` (9)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1204` | Self: 0.2% (10.5ms) | Total: 0.2% (10.5ms) | Samples: 7

**Called by:**
- `_makeToken` (7)

### `getUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320283` | Self: 0.2% (10.3ms) | Total: 0.2% (12.0ms) | Samples: 7

**Called by:**
- `iterate` (8)

**Calls:**
- `getBasicUtils` (1)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4094` | Self: 0.2% (10.1ms) | Total: 0.2% (10.1ms) | Samples: 6

**Called by:**
- `_nodeViewRaw` (6)

### `_getAllTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1945` | Self: 0.2% (10.0ms) | Total: 0.2% (10.0ms) | Samples: 7

**Called by:**
- `_getTokensAndCommentsMerged` (7)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5207` | Self: 0.2% (10.0ms) | Total: 36.0% (1.49s) | Samples: 7

**Called by:**
- `walkNodes` (825)
- `walkNodes` (146)

**Calls:**
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (702)
- `Program:exit` (106)
- `bound checkJsdoc` (102)
- `Program:exit` (40)
- `bound checkNonJsdoc` (9)
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (5)

### `getParser4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318434` | Self: 0.2% (9.9ms) | Total: 0.2% (9.9ms) | Samples: 7

**Called by:**
- `parse3` (7)

### `join`
`[native code]` | Self: 0.2% (9.8ms) | Total: 0.2% (9.8ms) | Samples: 6

**Called by:**
- `compactJoiner` (3)
- `preserveJoiner` (2)
- `camelCase` (1)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318014` | Self: 0.2% (9.5ms) | Total: 0.2% (9.5ms) | Samples: 6

**Called by:**
- `getNonJsdocComment` (3)
- `getJSDocComment` (3)

### `copyDataProperties`
`[native code]` | Self: 0.2% (9.5ms) | Total: 0.2% (9.5ms) | Samples: 6

**Called by:**
- `(anonymous)` (6)

### `performIteration`
`[native code]` | Self: 0.2% (9.4ms) | Total: 2.5% (104.9ms) | Samples: 6

**Called by:**
- `parseDescription` (57)
- `parseDescription` (12)

**Calls:**
- `next` (63)

### `get decorators`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2146` | Self: 0.2% (9.3ms) | Total: 0.2% (9.3ms) | Samples: 6

**Called by:**
- `getDecorator` (6)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4522` | Self: 0.2% (9.2ms) | Total: 0.2% (9.2ms) | Samples: 2

**Called by:**
- `AstView` (2)

### `getCommentsBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3528` | Self: 0.2% (9.1ms) | Total: 0.2% (10.7ms) | Samples: 6

**Called by:**
- `getReducedASTNode` (5)
- `getReducedASTNode` (2)

**Calls:**
- `get range` (1)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1681` | Self: 0.2% (8.9ms) | Total: 0.2% (8.9ms) | Samples: 6

**Called by:**
- `findJSDocComment` (5)
- `getReducedASTNode` (1)

### `parseDescription`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318682` | Self: 0.2% (8.7ms) | Total: 4.4% (186.1ms) | Samples: 6

**Called by:**
- `parseInlineTags` (94)
- `parseInlineTags` (27)

**Calls:**
- `performIteration` (57)
- `matchAll` (54)
- `[Symbol.matchAll]` (4)

### `/(?:\[(?<text>[^\]]+)\])\{@(?<tag>[^\}\s]+)\s?(?<namepathOrURL>[^\}\s\\|]*)\}/dgv`
`[native code]` | Self: 0.2% (8.7ms) | Total: 0.2% (8.7ms) | Samples: 6

**Called by:**
- `regExpExec` (6)

### `unshift`
`[native code]` | Self: 0.2% (8.7ms) | Total: 0.2% (8.7ms) | Samples: 6

**Called by:**
- `getAncestors` (6)

### `getParser4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318440` | Self: 0.2% (8.5ms) | Total: 0.2% (8.5ms) | Samples: 6

**Called by:**
- `parse3` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317512` | Self: 0.1% (8.2ms) | Total: 0.1% (8.2ms) | Samples: 5

**Called by:**
- `forEach` (5)

### `some`
`[native code]` | Self: 0.1% (8.1ms) | Total: 0.5% (24.8ms) | Samples: 5

**Called by:**
- `(anonymous)` (6)
- `hasRejectValue` (2)
- `validateDescription` (2)
- `(anonymous)` (1)
- `checkNonJsdoc` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `hasATag` (1)

**Calls:**
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318131` | Self: 0.1% (8.0ms) | Total: 0.1% (8.0ms) | Samples: 5

**Called by:**
- `(anonymous)` (5)

### `regExpExec`
`[native code]` | Self: 0.1% (8.0ms) | Total: 2.3% (95.5ms) | Samples: 5

**Called by:**
- `next` (63)

**Calls:**
- `/(?<!\])\{@(?<tag>[^\}\s]+)\s?(?<namepathOrURL>[^\}\s\\|]*)\s*(?<separator>[\s\\|])?\s*(?<text>[^\}]*)\}/dgv` (52)
- `/(?:\[(?<text>[^\]]+)\])\{@(?<tag>[^\}\s]+)\s?(?<namepathOrURL>[^\}\s\\|]*)\}/dgv` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328166` | Self: 0.1% (7.7ms) | Total: 2.8% (115.9ms) | Samples: 5

**Called by:**
- `filter` (76)

**Calls:**
- `parse3` (71)

### `at`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2050` | Self: 0.1% (7.5ms) | Total: 0.3% (16.3ms) | Samples: 5

**Called by:**
- `getTokenBefore` (11)

**Calls:**
- `_makeToken` (4)
- `_makeToken` (2)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317893` | Self: 0.1% (7.5ms) | Total: 4.2% (177.1ms) | Samples: 5

**Called by:**
- `findJSDocComment` (118)

**Calls:**
- `getTokenBefore` (87)
- `getTokenBefore` (14)
- `getTokenBefore` (6)
- `getTokenBefore` (5)
- `getTokenBefore` (1)

### `/\r+$/`
`[native code]` | Self: 0.1% (7.4ms) | Total: 0.1% (7.4ms) | Samples: 5

**Called by:**
- `[Symbol.match]` (5)

### `_getMergedIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2024` | Self: 0.1% (7.3ms) | Total: 0.1% (7.3ms) | Samples: 5

**Called by:**
- `getTokenBefore` (5)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7509` | Self: 0.1% (7.0ms) | Total: 0.1% (7.0ms) | Samples: 5

**Called by:**
- `runPlugins` (5)

### `getDecorator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317745` | Self: 0.1% (6.9ms) | Total: 0.7% (32.4ms) | Samples: 5

**Called by:**
- `findJSDocComment` (21)

**Calls:**
- `get decorators` (6)
- `get decorators` (4)
- `get decorators` (2)
- `get declaration` (1)
- `get decorators` (1)
- `get decorators` (1)
- `get parent` (1)

### `checkJsdoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321335` | Self: 0.1% (6.8ms) | Total: 17.3% (718.7ms) | Samples: 5

**Called by:**
- `bound checkJsdoc` (475)

**Calls:**
- `getJSDocComment` (427)
- `getJSDocComment` (24)
- `getJSDocComment` (13)
- `getJSDocComment` (2)
- `getJSDocComment` (2)
- `getJSDocComment` (1)
- `getJSDocComment` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7809` | Self: 0.1% (6.7ms) | Total: 0.1% (6.7ms) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `_getMergedIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2033` | Self: 0.1% (6.6ms) | Total: 0.1% (6.6ms) | Samples: 4

**Called by:**
- `getTokenBefore` (4)

### `parseBlock`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318104` | Self: 0.1% (6.5ms) | Total: 0.2% (8.3ms) | Samples: 4

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `/^@[^\s/]+(?=\s\|$)/` (1)

### `endsWith`
`[native code]` | Self: 0.1% (6.4ms) | Total: 0.1% (6.4ms) | Samples: 4

**Called by:**
- `parseSource` (3)
- `(anonymous)` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:590` | Self: 0.1% (6.3ms) | Total: 0.1% (6.3ms) | Samples: 4

**Called by:**
- `parseSource` (4)

### `getTokensBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3645` | Self: 0.1% (6.3ms) | Total: 13.2% (546.6ms) | Samples: 4

**Called by:**
- `findJSDocComment` (361)

**Calls:**
- `_getTokensAndCommentsMerged` (307)
- `_getTokensAndCommentsMerged` (38)
- `_getTokensAndCommentsMerged` (10)
- `_getTokensAndCommentsMerged` (1)
- `_getTokensAndCommentsMerged` (1)

### `parslet`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315038` | Self: 0.1% (6.2ms) | Total: 0.2% (9.2ms) | Samples: 4

**Called by:**
- `tryParslets` (6)

**Calls:**
- `accept` (1)
- `accept` (1)

### `get decorators`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (6.1ms) | Total: 0.1% (6.1ms) | Samples: 4

**Called by:**
- `getDecorator` (4)

### `Map`
`[native code]` | Self: 0.1% (6.1ms) | Total: 0.1% (6.1ms) | Samples: 4

**Called by:**
- `getDefaultTagStructureForMode` (2)
- `getDefaultTagStructureForMode` (1)
- `getDefaultTagStructureForMode` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318796` | Self: 0.1% (6.1ms) | Total: 0.1% (6.1ms) | Samples: 4

**Called by:**
- `parseSpec` (4)

### `isNameOrNamepathDefiningTag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319675` | Self: 0.1% (6.0ms) | Total: 0.1% (6.0ms) | Samples: 4

**Called by:**
- `(anonymous)` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321192` | Self: 0.1% (6.0ms) | Total: 0.1% (6.0ms) | Samples: 4

**Called by:**
- `filter` (4)

### `Se`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.1% (6.0ms) | Total: 0.1% (6.0ms) | Samples: 4

**Called by:**
- `Pe` (3)
- `Ce` (1)

### `source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:609` | Self: 0.1% (6.0ms) | Total: 0.1% (6.0ms) | Samples: 4

**Called by:**
- `get decorators` (2)
- `commentsInRange` (1)
- `_getMergedIndex` (1)

### `maskCodeBlocks`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.1% (6.0ms) | Total: 0.1% (6.0ms) | Samples: 4

**Called by:**
- `(anonymous)` (4)

### `/^\/\*(?!\*)/v`
`[native code]` | Self: 0.1% (5.9ms) | Total: 0.1% (5.9ms) | Samples: 4

**Called by:**
- `(anonymous)` (3)
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7807` | Self: 0.1% (5.8ms) | Total: 0.1% (5.8ms) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `seedSpec`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318077` | Self: 0.1% (5.8ms) | Total: 0.1% (5.8ms) | Samples: 4

**Called by:**
- `parseSpec` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318453` | Self: 0.1% (5.7ms) | Total: 2.3% (98.1ms) | Samples: 4

**Called by:**
- `parse3` (65)

**Calls:**
- `map` (61)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (5.7ms) | Total: 0.1% (5.7ms) | Samples: 4

**Called by:**
- `_getTokensAndCommentsMerged` (4)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318147` | Self: 0.1% (5.6ms) | Total: 0.1% (5.6ms) | Samples: 4

**Called by:**
- `(anonymous)` (4)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` | Self: 0.1% (5.4ms) | Total: 0.1% (5.4ms) | Samples: 4

**Called by:**
- `parseSource` (4)

### `parseDescription`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318681` | Self: 0.1% (5.1ms) | Total: 2.8% (119.1ms) | Samples: 4

**Called by:**
- `parseInlineTags` (46)
- `parseInlineTags` (32)

**Calls:**
- `matchAll` (56)
- `performIteration` (12)
- `[Symbol.matchAll]` (6)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1660` | Self: 0.1% (5.1ms) | Total: 0.2% (11.4ms) | Samples: 3

**Called by:**
- `findJSDocComment` (6)
- `getReducedASTNode` (1)

**Calls:**
- `get range` (2)
- `get range` (1)
- `get range` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:676` | Self: 0.1% (5.0ms) | Total: 0.1% (5.0ms) | Samples: 3

**Called by:**
- `getAllComments` (2)
- `_precomputeScopes` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4238` | Self: 0.1% (4.9ms) | Total: 0.1% (4.9ms) | Samples: 3

**Called by:**
- `nodeView` (3)

### `bound checkJsdoc`
`[native code]` | Self: 0.1% (4.9ms) | Total: 29.2% (1.20s) | Samples: 3

**Called by:**
- `_invokeFused` (370)
- `invokeHandlersWithNode` (327)
- `_invokeFused` (102)

**Calls:**
- `checkJsdoc` (475)
- `checkJsdoc` (265)
- `checkJsdoc` (53)
- `checkJsdoc` (2)
- `checkJsdoc` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318148` | Self: 0.1% (4.9ms) | Total: 0.1% (4.9ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3634` | Self: 0.1% (4.9ms) | Total: 0.1% (4.9ms) | Samples: 3

**Called by:**
- `getTokenBefore` (2)
- `getCommentsBefore` (1)

### `parseSpec`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318168` | Self: 0.1% (4.8ms) | Total: 1.2% (52.6ms) | Samples: 3

**Called by:**
- `map` (35)

**Calls:**
- `(anonymous)` (8)
- `(anonymous)` (7)
- `(anonymous)` (6)
- `(anonymous)` (4)
- `(anonymous)` (3)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318154` | Self: 0.1% (4.7ms) | Total: 0.1% (4.7ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:656` | Self: 0.1% (4.7ms) | Total: 0.1% (4.7ms) | Samples: 3

**Called by:**
- `getCommentsBefore` (3)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318140` | Self: 0.1% (4.6ms) | Total: 0.1% (4.6ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `replaceAll`
`[native code]` | Self: 0.1% (4.6ms) | Total: 0.1% (6.0ms) | Samples: 3

**Called by:**
- `maskCodeBlocks` (4)

**Calls:**
- ````/([ \t]+\*)[ \t]```[^\n]*?([\w\\|\W]*?\n)(?=[ \t]*\*(?:[ \t]*(?:```\|@\w+\s)\|\/))/gv```` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318452` | Self: 0.1% (4.5ms) | Total: 1.6% (68.0ms) | Samples: 3

**Called by:**
- `parse3` (44)

**Calls:**
- `parseBlock` (32)
- `parseBlock` (5)
- `parseBlock` (2)
- `parseBlock` (2)

### `getReducedASTNode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317870` | Self: 0.1% (4.5ms) | Total: 0.1% (4.5ms) | Samples: 3

**Called by:**
- `getNonJsdocComment` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318190` | Self: 0.1% (4.5ms) | Total: 0.1% (4.5ms) | Samples: 3

**Called by:**
- `parseSpec` (3)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:649` | Self: 0.1% (4.4ms) | Total: 0.1% (4.4ms) | Samples: 3

**Called by:**
- `getCommentsBefore` (3)

### `compactJoiner`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318416` | Self: 0.1% (4.4ms) | Total: 0.4% (17.7ms) | Samples: 3

**Called by:**
- `(anonymous)` (12)

**Calls:**
- `map` (6)
- `join` (3)

### `getCommentsBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3527` | Self: 0.1% (4.3ms) | Total: 0.1% (4.3ms) | Samples: 3

**Called by:**
- `getReducedASTNode` (2)
- `getReducedASTNode` (1)

### `toLocaleLowerCase`
`[native code]` | Self: 0.1% (4.3ms) | Total: 0.1% (4.3ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `_getMergedIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (4.3ms) | Total: 0.1% (4.3ms) | Samples: 3

**Called by:**
- `getTokenBefore` (3)

### `getParser`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318098` | Self: 0.0% (4.1ms) | Total: 0.1% (5.9ms) | Samples: 3

**Called by:**
- `getParser4` (4)

**Calls:**
- `getFencer` (1)

### `splitSpace`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318067` | Self: 0.0% (3.6ms) | Total: 0.6% (28.0ms) | Samples: 2

**Called by:**
- `parseSource` (6)
- `parseSource` (6)
- `parseSource` (4)
- `(anonymous)` (1)

**Calls:**
- `match` (15)

### `Parser`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314896` | Self: 0.0% (3.5ms) | Total: 0.0% (3.5ms) | Samples: 1

**Called by:**
- `parse2` (1)

### `/^\/\*\*\s/v`
`[native code]` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `callIterator` (2)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317919` | Self: 0.0% (3.3ms) | Total: 0.9% (37.3ms) | Samples: 2

**Called by:**
- `getJSDocComment` (24)

**Calls:**
- `getReducedASTNode` (9)
- `getReducedASTNode` (4)
- `getReducedASTNode` (4)
- `getReducedASTNode` (4)
- `getReducedASTNode` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:593` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `parseSource` (2)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7217` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `substr`
`[native code]` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `cloneObject`
`[native code]` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `Ee`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318458` | Self: 0.0% (3.2ms) | Total: 0.2% (10.1ms) | Samples: 2

**Called by:**
- `parse3` (4)
- `reduce` (2)

**Calls:**
- `concat` (2)
- `reduce` (2)

### `commentParserToESTree`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317393` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4216` | Self: 0.0% (3.2ms) | Total: 0.6% (25.2ms) | Samples: 2

**Called by:**
- `walkNodes` (12)
- `nodeView` (3)
- `_nodesFromRange` (1)

**Calls:**
- `_NodeView` (6)
- `_NodeView` (2)
- `_NodeView` (2)
- `_NodeView_LRN` (1)
- `_NodeView_LR` (1)
- `_NodeView_LR` (1)
- `_NodeView` (1)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318025` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `checkJsdoc` (2)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317888` | Self: 0.0% (3.1ms) | Total: 0.8% (35.5ms) | Samples: 2

**Called by:**
- `findJSDocComment` (23)

**Calls:**
- `getDecorator` (21)

### `search`
`[native code]` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `_nodeViewRaw` (2)

### `hasTag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319489` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3708` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `get value` (1)
- `report` (1)

### `trimEnd`
`[native code]` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `parseSource` (2)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318021` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `checkJsdoc` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7803` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `get typeAnnotation`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2827` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `getParamName` (2)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318129` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `defineProperty`
`[native code]` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `preserveJoiner`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318428` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `read`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316313` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `create` (2)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1262` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `_invokeFused` (2)

### `exit`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `callIterator` (2)

### `_getMergedIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2039` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `getTokenBefore` (2)

### `parseBlock`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `invokeHandlersWithNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7017` | Self: 0.0% (3.0ms) | Total: 12.1% (501.8ms) | Samples: 2

**Called by:**
- `invokeMethodFnHandlers` (331)

**Calls:**
- `bound checkJsdoc` (327)
- `bound checkNonJsdoc` (2)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1194` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `_makeToken` (2)

### `getAncestors`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3825` | Self: 0.0% (3.0ms) | Total: 0.3% (14.5ms) | Samples: 2

**Called by:**
- `getUtils` (10)

**Calls:**
- `unshift` (6)
- `_nodeViewRaw` (2)

### `log`
`[native code]` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `setDeps` (2)

### `/\/\*([\s\S]*?)\*\//g`
`[native code]` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `exec` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329225` | Self: 0.0% (3.0ms) | Total: 1.6% (69.1ms) | Samples: 2

**Called by:**
- `iterate` (44)

**Calls:**
- `getValidRuntimeIdentifiers` (35)
- `concat` (4)
- `getValidRuntimeIdentifiers` (2)
- `_buildScope` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7219` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `trim`
`[native code]` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `getTokenizers`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318761` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `parseComment` (2)

### `join`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318467` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318042` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (1)
- `checkJsdoc` (1)

### `getReducedASTNode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317830` | Self: 0.0% (2.9ms) | Total: 0.1% (7.8ms) | Samples: 2

**Called by:**
- `getJSDocComment` (4)
- `getNonJsdocComment` (1)

**Calls:**
- `get parent` (3)

### `c`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (2.9ms) | Total: 0.2% (10.3ms) | Samples: 2

**Called by:**
- `map` (4)
- `(anonymous)` (3)

**Calls:**
- `f` (5)

### `parseBlock`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318103` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `ke`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (2.8ms) | Total: 1.7% (71.9ms) | Samples: 2

**Called by:**
- `we` (46)

**Calls:**
- `(anonymous)` (44)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4106` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `_nodeViewRaw` (2)

### `checkJsdoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321339` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `bound checkJsdoc` (2)

### `getNonJsdocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317950` | Self: 0.0% (2.7ms) | Total: 0.4% (19.8ms) | Samples: 2

**Called by:**
- `checkNonJsdoc` (13)

**Calls:**
- `getReducedASTNode` (3)
- `getReducedASTNode` (3)
- `getReducedASTNode` (3)
- `getReducedASTNode` (1)
- `getReducedASTNode` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:678` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `getAllComments` (2)

### `getIndentAndJSDoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321082` | Self: 0.0% (2.6ms) | Total: 0.0% (2.6ms) | Samples: 2

**Called by:**
- `checkJsdoc` (1)
- `callIterator` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327552` | Self: 0.0% (2.5ms) | Total: 0.0% (2.5ms) | Samples: 2

**Called by:**
- `iterate` (2)

### `getParser4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318442` | Self: 0.0% (2.5ms) | Total: 0.9% (41.0ms) | Samples: 2

**Called by:**
- `parse3` (27)

**Calls:**
- `getParser2` (16)
- `getParser2` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320918` | Self: 0.0% (2.5ms) | Total: 0.0% (2.5ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `getParser3`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318163` | Self: 0.0% (2.4ms) | Total: 0.0% (2.4ms) | Samples: 1

**Called by:**
- `getParser4` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1302` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1027` | Self: 0.0% (1.8ms) | Total: 0.2% (9.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (4)
- `getValidRuntimeIdentifiers` (2)

**Calls:**
- `_ensureVarsSet` (5)

### `next`
`[native code]` | Self: 0.0% (1.8ms) | Total: 2.3% (97.3ms) | Samples: 1

**Called by:**
- `performIteration` (63)
- `createTokens` (1)

**Calls:**
- `regExpExec` (63)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318007` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `getNonJsdocComment` (1)

### `toReversed`
`[native code]` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_isChainNode`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3973` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `nodeViewChain` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:187857` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:916` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `_symName` (1)

### `getLocFromIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `get loc` (1)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318026` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (1)

### `internal:fs/streams`
`internal:fs/streams:158` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `_fromRunnerReport`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:207` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333077` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:325967` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `SemVer`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `parse` (1)

### `values`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getPreferredTagNameSimple` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2979` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `get globalScope` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `/^@[^\s/]+(?=\s\|$)/`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `parseBlock` (1)

### `getFencer`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318115` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getParser` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320771` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171429` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/eslint-utils/astUtilities.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getDefaultTagStructureForMode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313939` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `setTagStructure` (1)

### `(anonymous)`
`/private/tmp/prof_jsdoc.js:9` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `parseModule` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318449` | Self: 0.0% (1.7ms) | Total: 2.9% (122.5ms) | Samples: 1

**Called by:**
- `parse3` (78)

**Calls:**
- `parseSource` (9)
- `parseSource` (9)
- `parseSource` (9)
- `parseSource` (8)
- `parseSource` (7)
- `parseSource` (7)
- `parseSource` (6)
- `parseSource` (5)
- `parseSource` (4)
- `parseSource` (3)
- `parseSource` (3)
- `parseSource` (3)
- `parseSource` (2)
- `parseSource` (1)
- `parseSource` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323790` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318769` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `parseSpec` (1)

### `typeTokenizer`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318203` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getParser4` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:670` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getCommentsBefore` (1)

### `Parser`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314910` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `parse2` (1)

### `_NodeView_LRN`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4130` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3692` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `get value` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320627` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318139` | Self: 0.0% (1.7ms) | Total: 0.2% (9.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `endsWith` (3)
- `trimEnd` (2)

### `flatten`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1252` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318045` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318448` | Self: 0.0% (1.7ms) | Total: 1.0% (45.2ms) | Samples: 1

**Called by:**
- `parse3` (30)

**Calls:**
- `splitLines` (29)

### `getReducedASTNode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317852` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getNonJsdocComment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:266364` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `preserveJoiner`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318427` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get decorators`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2150` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getDecorator` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318130` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_getMergedIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1973` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getTokenBefore` (1)

### `callIterator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321101` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `onProgramExit` (1)

### `getBasicUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320240` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getUtils` (1)

### `getPreferredTagName`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319514` | Self: 0.0% (1.7ms) | Total: 3.5% (145.5ms) | Samples: 1

**Called by:**
- `forEachPreferredTag` (58)
- `(anonymous)` (38)

**Calls:**
- `getPreferredTagNameSimple` (93)
- `getPreferredTagNameSimple` (1)
- `getPreferredTagNameSimple` (1)

### `get declaration`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3611` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getDecorator` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301183` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `parse2`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316975` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `cleanUpLastTag` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170488` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318151` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326238` | Self: 0.0% (1.7ms) | Total: 3.6% (150.3ms) | Samples: 1

**Called by:**
- `bound ` (97)
- `_invokeFused` (2)

**Calls:**
- `checkNonJsdoc` (98)

### `_isStatementTag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `get range` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `getDecorator` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320575` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_Lexer`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316303` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `create` (1)

### `descriptionTokenizer`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318401` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `getParser4` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320814` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1136` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:675` | Self: 0.0% (1.6ms) | Total: 0.0% (2.9ms) | Samples: 1

**Called by:**
- `getAllComments` (2)

**Calls:**
- `push` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:232339` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get lexer`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314924` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `uniqueSymbolParslet` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318763` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `parseSpec` (1)

### `_getMergedIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2017` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `getTokenBefore` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1284` | Self: 0.0% (1.6ms) | Total: 0.0% (3.2ms) | Samples: 1

**Called by:**
- `_getAllTokens` (2)

**Calls:**
- `_tokType` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327824` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `read`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316323` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `create` (1)

### `accept`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315083` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `parslet` (1)

### `useColors`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12454` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `createDebug` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:200893` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `be`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `parse2`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317016` | Self: 0.0% (1.6ms) | Total: 2.0% (85.7ms) | Samples: 1

**Called by:**
- `cleanUpLastTag` (55)

**Calls:**
- `parse` (54)

### `_tokType`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_makeToken` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317456` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `forEach` (1)

### `isConstructor`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319996` | Self: 0.0% (1.6ms) | Total: 0.0% (2.8ms) | Samples: 1

**Called by:**
- `exemptSpeciaMethods` (1)
- `(anonymous)` (1)

**Calls:**
- `get kind` (1)

### `nameTokenizer`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318275` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `getParser4` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317913` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `findJSDocComment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320889` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320762` | Self: 0.0% (1.6ms) | Total: 0.0% (3.0ms) | Samples: 1

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `getJsdocTagsDeep` (1)

### `get decorators`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2144` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `getDecorator` (1)

### `encodeInto`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_encodeSource` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:659` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `getAllComments` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320795` | Self: 0.0% (1.6ms) | Total: 0.1% (6.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (2)
- `canSkip2` (1)
- `canSkip5` (1)

**Calls:**
- `exemptSpeciaMethods` (2)
- `exemptSpeciaMethods` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8302` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_lintSourceOne` (1)

### `ensureMap`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319626` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `isNameOrNamepathDefiningTag` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:42213` | Self: 0.0% (1.6ms) | Total: 0.0% (3.2ms) | Samples: 1

**Called by:**
- `filter` (1)
- `(anonymous)` (1)

**Calls:**
- `filter` (1)

### `inverseMap`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:46720` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `ge`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `validateDescription`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330339` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `generateNamedReferences`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321757` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `onNodeWithComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321176` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (1)

### `exemptSpeciaMethods`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320029` | Self: 0.0% (1.5ms) | Total: 0.0% (3.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `isConstructor` (1)

### `_applySchemaDefaults`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:181` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:186753` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get typeAnnotation`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `getParamName` (1)

### `get kind`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2738` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `isGetter2` (1)

### `parse`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314927` | Self: 0.0% (1.5ms) | Total: 2.0% (85.3ms) | Samples: 1

**Called by:**
- `parse2` (54)
- `parseNamePath` (1)

**Calls:**
- `parseType` (54)

### `get`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `createTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332392` | Self: 0.0% (1.5ms) | Total: 0.0% (3.3ms) | Samples: 1

**Called by:**
- `fix10` (2)

**Calls:**
- `next` (1)

### `get multiline`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `get flags` (1)

### `checkJsdoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321342` | Self: 0.0% (1.5ms) | Total: 1.9% (80.3ms) | Samples: 1

**Called by:**
- `bound checkJsdoc` (53)

**Calls:**
- `getIndentAndJSDoc` (51)
- `getIndentAndJSDoc` (1)

### `predicateParslet`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315038` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `tryParslets` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:54196` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `bound `
`[native code]` | Self: 0.0% (1.5ms) | Total: 3.6% (150.3ms) | Samples: 1

**Called by:**
- `_invokeFused` (71)
- `_invokeFused` (28)

**Calls:**
- `(anonymous)` (97)
- `(anonymous)` (1)

### `setPrototypeOf`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_NoParsletFoundError` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317566` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `forEach` (1)

### `getTokenizers`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `parseComment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320391` | Self: 0.0% (1.5ms) | Total: 0.0% (2.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `some` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328176` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `Program:exit` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:335666` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328149` | Self: 0.0% (1.5ms) | Total: 0.2% (10.9ms) | Samples: 1

**Called by:**
- `filter` (7)

**Calls:**
- `some` (6)

### `read`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316311` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `create` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/scope/CatchScope.js:5` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171719` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320882` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `getUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320941` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:595` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `parseSource` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:199268` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320314` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:181748` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `hasTag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319490` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332160` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `registerCodeFix`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:155874` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `canSkip6`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334400` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getPreferredTagNameSimple`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319448` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `getPreferredTagName` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317416` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `forEach` (1)

### `getReducedASTNode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getJSDocComment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:337181` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329671` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `flatIntoArrayWithCallback` (1)

### `cleanUpLastTag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318128` | Self: 0.0% (1.4ms) | Total: 0.3% (15.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (9)

**Calls:**
- `splitSpace` (4)
- `splitSpace` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326447` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `createTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332388` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `fix10` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/type-check/lib/parse-type.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328781` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `iterate` (1)

### ````/([ \t]+\*)[ \t]```[^\n]*?([\w\\|\W]*?\n)(?=[ \t]*\*(?:[ \t]*(?:```\|@\w+\s)\|\/))/gv````
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `replaceAll` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7819` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `fix10`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332349` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `fixer` (1)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330138` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `getContexts`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328706` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get id`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2325` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327233` | Self: 0.0% (1.4ms) | Total: 2.8% (118.4ms) | Samples: 1

**Called by:**
- `iterate` (77)

**Calls:**
- `validateDescription` (75)
- `validateDescription` (1)

### `getDefaultTagStructureForMode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313699` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getTagStructureForMode` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5185` | Self: 0.0% (1.4ms) | Total: 13.7% (570.2ms) | Samples: 1

**Called by:**
- `walkNodes` (376)

**Calls:**
- `bound checkJsdoc` (370)
- `bound checkNonJsdoc` (3)
- `FunctionDeclaration` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183909` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321230` | Self: 0.0% (1.4ms) | Total: 32.6% (1.35s) | Samples: 1

**Called by:**
- `_invokeFused` (702)
- `_invokeFused` (175)

**Calls:**
- `onNodeWithComment` (875)
- `onNodeWithComment` (1)

### `checkJsDoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:331855` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `FunctionDeclaration` (1)

### `callIterator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321102` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `onProgramExit` (1)

### `regExpMatchFast`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_normalizeIPv6` (1)

### `reduce`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.1% (4.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (2)
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (2)

### `charCodeAt`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_getMergedIndex` (1)

### `get typeAnnotation`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2753` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getParamName` (1)

### `stripEncapsulatingBrackets`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317350` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `cleanUpLastTag` (1)

### `at`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getTokenBefore` (1)

### `getJsdocTagsDeep`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319372` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336984` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `__export`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:23` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `fetch`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `requestFetch` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318454` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `parse3` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:211438` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320460` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318016` | Self: 0.0% (1.4ms) | Total: 18.4% (763.6ms) | Samples: 1

**Called by:**
- `getJSDocComment` (417)
- `getNonJsdocComment` (88)

**Calls:**
- `findJSDocComment` (361)
- `findJSDocComment` (118)
- `findJSDocComment` (23)
- `findJSDocComment` (1)
- `findJSDocComment` (1)

### `_getAllTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1948` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_getTokensAndCommentsMerged` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:681` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getAllComments` (1)

### `accept`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `parslet` (1)

### `checkTagName`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334198` | Self: 0.0% (1.4ms) | Total: 0.1% (7.1ms) | Samples: 1

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `(anonymous)` (4)

### `preserveJoiner`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318424` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `emit`
`node:events` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `onConstruct` (1)

### `addComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326204` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getReducedASTNode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317863` | Self: 0.0% (1.3ms) | Total: 0.4% (18.4ms) | Samples: 1

**Called by:**
- `getJSDocComment` (9)
- `getNonJsdocComment` (3)

**Calls:**
- `getCommentsBefore` (5)
- `getCommentsBefore` (4)
- `getCommentsBefore` (2)

### `Boolean`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `filter` (1)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `findJSDocComment` (1)

### `linkAndEvaluateModule`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `async loadAndEvaluateModule` (1)

### `camelCase`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295617` | Self: 0.0% (1.3ms) | Total: 0.0% (2.9ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `splitPrefixSuffix` (1)

### `/^\s+/`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `[Symbol.match]` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `reportings` (1)

### `/\s*(@(\S+))(\s*)/`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `[Symbol.match]` (1)

### `_computeIdentifierName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_NodeView_LR` (1)

### `splitCR`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318063` | Self: 0.0% (1.3ms) | Total: 0.2% (9.7ms) | Samples: 1

**Called by:**
- `parseSource` (7)

**Calls:**
- `match` (6)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4827` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318209` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `we`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (1.3ms) | Total: 1.7% (73.3ms) | Samples: 1

**Called by:**
- `Pe` (47)

**Calls:**
- `ke` (46)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334429` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328150` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `some` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4210` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326519` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4158` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2089` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getTokensBefore` (1)

### `[Symbol.split]`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `splitLines` (1)

### `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321227` | Self: 0.0% (1.3ms) | Total: 1.8% (74.7ms) | Samples: 1

**Called by:**
- `_invokeFused` (38)
- `_invokeFused` (11)

**Calls:**
- `getJSDocComment` (44)
- `getJSDocComment` (1)
- `getJSDocComment` (1)
- `getJSDocComment` (1)
- `getJSDocComment` (1)

### `createNamedRule`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/eslint-utils/RuleCreator.js:18` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `parseComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318829` | Self: 0.0% (1.3ms) | Total: 7.4% (306.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (83)
- `(anonymous)` (66)
- `getIndentAndJSDoc` (51)

**Calls:**
- `parseInlineTags` (140)
- `parseInlineTags` (59)

### `ensureMap`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319629` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `isNameOrNamepathDefiningTag` (1)

### `getPreferredTagName`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319508` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:717` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `commentsInRange` (1)

### `matchAll`
`[native code]` | Self: 0.0% (1.3ms) | Total: 4.1% (170.9ms) | Samples: 1

**Called by:**
- `parseDescription` (56)
- `parseDescription` (54)

**Calls:**
- `get flags` (88)
- `esSpecIsRegExp` (12)
- `stringIncludesInternal` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317477` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `forEach` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317536` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `forEach` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6578` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_getOrBuildPlan` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318395` | Self: 0.0% (1.3ms) | Total: 0.0% (2.6ms) | Samples: 1

**Called by:**
- `parseSpec` (1)
- `(anonymous)` (1)

**Calls:**
- `splitSpace` (1)

### `at`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2054` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getTokenBefore` (1)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2104` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getTokensBefore` (1)

### `f`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (1.3ms) | Total: 0.1% (7.4ms) | Samples: 1

**Called by:**
- `c` (5)

**Calls:**
- `map` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7495` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `fix10`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330343` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_execReport` (1)

### `hasRejectValue`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333143` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `flatIntoArrayWithCallback`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.4% (17.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `splitTextIntoWords` (1)
- `(anonymous)` (1)
- `flatMap` (1)

**Calls:**
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `_mkGlobalVar`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:709` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_findLine`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:573` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `getLocFromIndex` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1540` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `invokeMethodFnHandlers` (1)

### `add`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:183987` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `checkJsdoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321336` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `bound checkJsdoc` (1)

### `getParser`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318099` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `getParser4` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3682` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `getTokenBefore` (1)

### `getParser4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318445` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `parse3` (1)

### `getNonJsdocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317951` | Self: 0.0% (1.2ms) | Total: 3.5% (146.5ms) | Samples: 1

**Called by:**
- `checkNonJsdoc` (97)

**Calls:**
- `findJSDocComment` (88)
- `findJSDocComment` (3)
- `findJSDocComment` (3)
- `findJSDocComment` (1)
- `findJSDocComment` (1)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1680` | Self: 0.0% (1.2ms) | Total: 0.4% (20.3ms) | Samples: 1

**Called by:**
- `findJSDocComment` (14)

**Calls:**
- `at` (11)
- `at` (1)
- `at` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301198` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332144` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317921` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `getJSDocComment` (1)

### `toString`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_analyzeHandler` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320404` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `some` (1)

### `parslet`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315039` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `tryParslets` (1)

### `get kind`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2734` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `isConstructor` (1)

### `push`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `commentsInRange` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/node.js:12` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333240` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `/^\s+$/`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `isSpace` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170800` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318035` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `checkJsdoc` (1)

### `cleanUpLastTag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317370` | Self: 0.0% (1.1ms) | Total: 0.0% (1.1ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `findExpectedIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332182` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `fix10` (1)

**Calls:**
- `filter` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:337704` | Self: 0.0% (0us) | Total: 1.0% (42.3ms) | Samples: 0

**Called by:**
- `anonymous` (28)

**Calls:**
- `(anonymous)` (28)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:215932` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328144` | Self: 0.0% (0us) | Total: 3.8% (160.8ms) | Samples: 0

**Called by:**
- `Program:exit` (105)

**Calls:**
- `filter` (105)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:17596` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `getFullPath`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:209` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `resolveIds` (1)

**Calls:**
- `parse` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201923` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330386` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `some` (1)

**Calls:**
- `report` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:37` | Self: 0.0% (0us) | Total: 0.0% (3.5ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:285032` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:312924` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330697` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328784` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `camelCase`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295625` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `addPolyfillToken` (1)

**Calls:**
- `join` (1)

### `onProgramExit`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321193` | Self: 0.0% (0us) | Total: 1.1% (47.9ms) | Samples: 0

**Called by:**
- `Program:exit` (31)

**Calls:**
- `callIterator` (24)
- `callIterator` (3)
- `callIterator` (2)
- `callIterator` (1)
- `callIterator` (1)

### `getESLintCoreRule`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:174800` | Self: 0.0% (0us) | Total: 0.1% (6.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `bound require` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333904` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `(anonymous)` (2)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4809` | Self: 0.0% (0us) | Total: 0.3% (15.6ms) | Samples: 0

**Called by:**
- `runPlugins` (10)

**Calls:**
- `create` (9)
- `create` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/eslint-utils/index.js:17` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290098` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:196154` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326147` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `reportings` (1)

**Calls:**
- `report` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:196424` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `defineProperty` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/analyze.js:5` | Self: 0.0% (0us) | Total: 0.2% (11.7ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316299` | Self: 0.0% (0us) | Total: 0.2% (9.4ms) | Samples: 0

**Called by:**
- `parse2` (6)

**Calls:**
- `read` (2)
- `read` (2)
- `read` (1)
- `read` (1)

### `getPreferredTagNameSimple`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319470` | Self: 0.0% (0us) | Total: 3.3% (140.5ms) | Samples: 0

**Called by:**
- `getPreferredTagName` (93)

**Calls:**
- `entries` (77)
- `find` (16)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332923` | Self: 0.0% (0us) | Total: 0.2% (9.1ms) | Samples: 0

**Called by:**
- `iterate` (6)

**Calls:**
- `(anonymous)` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/clear-caches.js:5` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `findIndex`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `findExpectedIndex` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334236` | Self: 0.0% (0us) | Total: 0.1% (7.1ms) | Samples: 0

**Called by:**
- `iterate` (5)

**Calls:**
- `checkTagName` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190372` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `onConstruct`
`internal:streams/destroy:144` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `processTicksAndRejections` (1)

**Calls:**
- `emit` (1)

### `_getOrBuildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6287` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `walkNodes` (2)

**Calls:**
- `_buildPlan` (1)
- `_buildPlan` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332128` | Self: 0.0% (0us) | Total: 0.1% (6.1ms) | Samples: 0

**Called by:**
- `iterate` (4)

**Calls:**
- `(anonymous)` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:277093` | Self: 0.0% (0us) | Total: 0.1% (7.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `(anonymous)` (5)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5170` | Self: 0.0% (0us) | Total: 0.2% (10.0ms) | Samples: 0

**Called by:**
- `walkNodes` (6)

**Calls:**
- `parent` (2)
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)

### `forEach`
`[native code]` | Self: 0.0% (0us) | Total: 3.3% (139.4ms) | Samples: 0

**Called by:**
- `commentParserToESTree` (88)

**Calls:**
- `(anonymous)` (60)
- `(anonymous)` (9)
- `(anonymous)` (6)
- `(anonymous)` (5)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330921` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `getDefaultTagStructureForMode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314084` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `setTagStructure` (1)

**Calls:**
- `Map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:335474` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint/config-array/dist/cjs/index.cjs:4` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:23` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:46468` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `inverseMap` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328991` | Self: 0.0% (0us) | Total: 0.1% (4.4ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `flatIntoArrayWithCallback` (3)

### `callIterator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321130` | Self: 0.0% (0us) | Total: 1.3% (57.3ms) | Samples: 0

**Called by:**
- `onNodeWithComment` (37)

**Calls:**
- `every` (37)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137941` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290248` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326797` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `setDeps` (2)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/types/dist/index.js:23` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:136510` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4777` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_applySchemaDefaults` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1746` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `hasRejectValue` (1)

**Calls:**
- `_nodesFromRange` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201918` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318455` | Self: 0.0% (0us) | Total: 0.4% (17.7ms) | Samples: 0

**Called by:**
- `parse3` (12)

**Calls:**
- `compactJoiner` (12)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:123` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326641` | Self: 0.0% (0us) | Total: 0.1% (6.9ms) | Samples: 0

**Called by:**
- `iterate` (4)

**Calls:**
- `(anonymous)` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:263207` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:325959` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313417` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326023` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172409` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7079` | Self: 0.0% (0us) | Total: 12.1% (501.8ms) | Samples: 0

**Called by:**
- `walkNodes` (331)

**Calls:**
- `invokeHandlersWithNode` (331)

### `uniqueSymbolParslet`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316850` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `tryParslets` (1)

**Calls:**
- `get lexer` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:180328` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322295` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `bound checkNonJsdoc`
`[native code]` | Self: 0.0% (0us) | Total: 0.5% (20.8ms) | Samples: 0

**Called by:**
- `_invokeFused` (9)
- `_invokeFused` (3)
- `invokeHandlersWithNode` (2)

**Calls:**
- `checkNonJsdoc` (12)
- `checkNonJsdoc` (1)
- `checkNonJsdoc` (1)

### `(anonymous)`
`/private/tmp/prof_jsdoc.js:5` | Self: 0.0% (0us) | Total: 0.3% (13.6ms) | Samples: 0

**Called by:**
- `parseModule` (9)

**Calls:**
- `bound require` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328953` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `get globalScope` (3)

### `get globalScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4065` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `_precomputeScopes` (2)
- `_precomputeScopes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317498` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `forEach` (1)

**Calls:**
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289691` | Self: 0.0% (0us) | Total: 0.1% (7.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `(anonymous)` (5)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2475` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `_ensureDeclSymIndex` (1)

### `_getMergedIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1979` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `getTokenBefore` (1)

**Calls:**
- `source` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3662` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `getTokenBefore` (1)

**Calls:**
- `_isStatementTag` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336919` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `map` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/TypeVisitor.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321241` | Self: 0.0% (0us) | Total: 1.4% (61.7ms) | Samples: 0

**Called by:**
- `_invokeFused` (40)

**Calls:**
- `onProgramExit` (31)
- `onProgramExit` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:257157` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318127` | Self: 0.0% (0us) | Total: 0.2% (9.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (7)

**Calls:**
- `splitCR` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320332` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `_execReport` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/index.js:20` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:44` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138509` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:198766` | Self: 0.0% (0us) | Total: 0.4% (19.1ms) | Samples: 0

**Called by:**
- `anonymous` (13)

**Calls:**
- `(anonymous)` (7)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:43023` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `commentParserToESTree`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317398` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `map` (2)

### `checkNonJsdocAfter`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326230` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `reportings` (1)

### `Comparator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:163872` | Self: 0.0% (0us) | Total: 1.3% (54.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `parse` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:54` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `addMetaSchema`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:152` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `addSchema` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint/plugin-kit/dist/cjs/index.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321033` | Self: 0.0% (0us) | Total: 0.4% (19.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (11)
- `report` (2)

**Calls:**
- `report` (13)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318470` | Self: 0.0% (0us) | Total: 0.1% (5.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)
- `map` (2)

**Calls:**
- `join` (2)
- `map` (2)

### `hasRejectValue`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333151` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `shouldReport` (3)

**Calls:**
- `hasRejectValue` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:244045` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:674` | Self: 0.0% (0us) | Total: 0.2% (8.4ms) | Samples: 0

**Called by:**
- `getAllComments` (5)
- `_precomputeScopes` (1)

**Calls:**
- `_findLineIdx` (5)
- `_findLineIdx` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322393` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:178990` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:312909` | Self: 0.0% (0us) | Total: 0.1% (4.5ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:105264` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getParser4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318436` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `parse3` (1)

**Calls:**
- `typeTokenizer` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:19` | Self: 0.0% (0us) | Total: 0.2% (9.2ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333756` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138274` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201869` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `canSkip2`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333327` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:45` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188471` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321161` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (1)
- `buildVisitorMap` (1)

**Calls:**
- `getSettings` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188462` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `maskCodeBlocks`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322839` | Self: 0.0% (0us) | Total: 0.1% (6.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `replaceAll` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333233` | Self: 0.0% (0us) | Total: 0.2% (11.0ms) | Samples: 0

**Called by:**
- `iterate` (7)

**Calls:**
- `(anonymous)` (6)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290300` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-estree.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `cleanUpLastTag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317365` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `stripEncapsulatingBrackets` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201908` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/esquery.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `addPolyfillToken`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301137` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `camelCase` (1)
- `camelCase` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2607` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (2)

**Calls:**
- `exec` (2)

### `camelCase`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295621` | Self: 0.0% (0us) | Total: 0.1% (4.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)
- `addPolyfillToken` (1)

**Calls:**
- `map` (3)

### `exemptSpeciaMethods`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320032` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isGetter2` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201820` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `setTagStructure`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319141` | Self: 0.0% (0us) | Total: 0.1% (4.6ms) | Samples: 0

**Called by:**
- `getSettings` (3)

**Calls:**
- `getDefaultTagStructureForMode` (1)
- `getDefaultTagStructureForMode` (1)
- `getDefaultTagStructureForMode` (1)

### `splitLines`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318071` | Self: 0.0% (0us) | Total: 1.0% (43.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (29)

**Calls:**
- `regExpSplitFast` (28)
- `[Symbol.split]` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:230592` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317468` | Self: 0.0% (0us) | Total: 0.2% (9.5ms) | Samples: 0

**Called by:**
- `forEach` (6)

**Calls:**
- `copyDataProperties` (6)

### `parse`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js:906` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `getFullPath` (1)

**Calls:**
- `_normalizeIPv6` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332173` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `some` (1)

**Calls:**
- `endsWith` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:168346` | Self: 0.0% (0us) | Total: 1.8% (76.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (50)

**Calls:**
- `(anonymous)` (50)

### `tryParsePathIgnoreError`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336764` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `validNamepathParsing` (1)

**Calls:**
- `parseNamePath` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/cli-engine/lint-result-cache.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:274` | Self: 0.0% (0us) | Total: 80.3% (3.32s) | Samples: 0

**Called by:**
- `(anonymous)` (2177)

**Calls:**
- `runPlugins` (2136)
- `runPlugins` (40)
- `runPlugins` (1)

### `_normalizeIPv6`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js:812` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `parse` (1)

**Calls:**
- `regExpMatchFast` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301172` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `addPolyfillToken` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/scope/index.js:18` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313120` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333155` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `some` (2)

**Calls:**
- `hasRejectValue` (1)
- `hasRejectValue` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332122` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `parseNamePath`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317060` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `tryParsePathIgnoreError` (1)

**Calls:**
- `parse` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289651` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getIndentAndJSDoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321083` | Self: 0.0% (0us) | Total: 4.0% (168.0ms) | Samples: 0

**Called by:**
- `callIterator` (57)
- `checkJsdoc` (51)

**Calls:**
- `parseComment` (57)
- `parseComment` (51)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326240` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `bound ` (1)

**Calls:**
- `checkNonJsdocAfter` (1)

### `isSpace`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318060` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `/^\s+$/` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-modifiers.js:39` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:230635` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190380` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290081` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `assign`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `node:assert` (1)

**Calls:**
- `get` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/index.js:4` | Self: 0.0% (0us) | Total: 0.2% (11.7ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289727` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/index.js:18` | Self: 0.0% (0us) | Total: 0.2% (11.7ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:43` | Self: 0.0% (0us) | Total: 0.3% (13.5ms) | Samples: 0

**Called by:**
- `anonymous` (9)

**Calls:**
- `bound require` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12341` | Self: 0.0% (0us) | Total: 0.0% (3.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:16` | Self: 0.0% (0us) | Total: 1.7% (73.7ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `get decorators`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2158` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `getDecorator` (2)

**Calls:**
- `source` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:94790` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:169412` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328145` | Self: 0.0% (0us) | Total: 0.1% (5.1ms) | Samples: 0

**Called by:**
- `filter` (3)

**Calls:**
- `getText` (3)

### `parseSpec`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318166` | Self: 0.0% (0us) | Total: 0.1% (5.8ms) | Samples: 0

**Called by:**
- `map` (4)

**Calls:**
- `seedSpec` (4)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` | Self: 0.0% (0us) | Total: 0.6% (25.9ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (13)

**Calls:**
- `AstView` (4)
- `AstView` (4)
- `AstView` (2)
- `AstView` (2)
- `AstView` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317896` | Self: 0.0% (0us) | Total: 13.2% (546.6ms) | Samples: 0

**Called by:**
- `findJSDocComment` (361)

**Calls:**
- `getTokensBefore` (361)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:166639` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:11` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `commentParserToESTree`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317415` | Self: 0.0% (0us) | Total: 3.3% (139.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (83)
- `(anonymous)` (5)

**Calls:**
- `forEach` (88)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320327` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317600` | Self: 0.0% (0us) | Total: 0.9% (40.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (26)

**Calls:**
- `g` (26)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/index.js:3` | Self: 0.0% (0us) | Total: 0.3% (16.1ms) | Samples: 0

**Called by:**
- `anonymous` (11)

**Calls:**
- `bound require` (11)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/apply-disable-directives.js:22` | Self: 0.0% (0us) | Total: 0.2% (11.5ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/dotjs/index.js:17` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289557` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318133` | Self: 0.0% (0us) | Total: 0.2% (11.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (7)

**Calls:**
- `splitSpace` (6)
- `splitSpace` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329660` | Self: 0.0% (0us) | Total: 9.0% (376.1ms) | Samples: 0

**Called by:**
- `iterate` (242)

**Calls:**
- `map` (242)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `get`
`node:assert:575` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `assign` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/fdir/dist/index.cjs:462` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:106842` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318799` | Self: 0.0% (0us) | Total: 0.2% (8.7ms) | Samples: 0

**Called by:**
- `parseSpec` (6)

**Calls:**
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236366` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173278` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `createNamedRule` (1)

### `canSkip5`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334195` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:282301` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319601` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `some` (1)

**Calls:**
- `hasTag` (1)

### `tryParslets`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314956` | Self: 0.0% (0us) | Total: 0.3% (13.7ms) | Samples: 0

**Called by:**
- `parseIntermediateType` (9)

**Calls:**
- `parslet` (6)
- `uniqueSymbolParslet` (1)
- `predicateParslet` (1)
- `parslet` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8046` | Self: 0.0% (0us) | Total: 5.4% (224.1ms) | Samples: 0

**Called by:**
- `runPlugins` (146)

**Calls:**
- `_invokeFused` (146)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7055` | Self: 0.0% (0us) | Total: 0.1% (5.8ms) | Samples: 0

**Called by:**
- `walkNodes` (4)

**Calls:**
- `get value` (2)
- `get value` (1)
- `get value` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332172` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `findIndex` (1)

**Calls:**
- `some` (1)

### `node:assert`
`node:assert:588` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `assign` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:128005` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/cast.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329194` | Self: 0.0% (0us) | Total: 0.1% (4.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `flatIntoArrayWithCallback` (3)

### `getSettings`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320988` | Self: 0.0% (0us) | Total: 0.1% (4.6ms) | Samples: 0

**Called by:**
- `create` (2)
- `create` (1)

**Calls:**
- `setTagStructure` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318416` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `map` (2)

**Calls:**
- `trim` (2)

### `canSkip3`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333567` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161606` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201906` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328986` | Self: 0.0% (0us) | Total: 3.2% (132.7ms) | Samples: 0

**Called by:**
- `iterate` (87)

**Calls:**
- `filter` (87)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190337` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:244143` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332850` | Self: 0.0% (0us) | Total: 0.1% (6.7ms) | Samples: 0

**Called by:**
- `iterate` (5)

**Calls:**
- `(anonymous)` (5)

### `parseBlock`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318109` | Self: 0.0% (0us) | Total: 1.1% (49.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (32)

**Calls:**
- `toggleFence` (32)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320366` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `validateDescription` (1)

**Calls:**
- `getRegexFromString` (1)

### `createDebug`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12070` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `useColors` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:215828` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `shouldReport`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334117` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `SemVer`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:162913` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `parse` (1)

**Calls:**
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333122` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:4` | Self: 0.0% (0us) | Total: 1.7% (73.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `getOwnPropertyDescriptor` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172433` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:249533` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:123501` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `resolveIds`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:235` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_addSchema` (1)

**Calls:**
- `getFullPath` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313289` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164604` | Self: 0.0% (0us) | Total: 1.3% (56.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `(anonymous)` (4)

### `checkJsdoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321346` | Self: 0.0% (0us) | Total: 9.7% (401.7ms) | Samples: 0

**Called by:**
- `bound checkJsdoc` (265)

**Calls:**
- `iterate` (209)
- `iterate` (56)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createIsolatedProgram.js:42` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:42` | Self: 0.0% (0us) | Total: 1.7% (73.7ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `(anonymous)` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313124` | Self: 0.0% (0us) | Total: 0.7% (29.1ms) | Samples: 0

**Called by:**
- `anonymous` (19)

**Calls:**
- `(anonymous)` (19)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7806` | Self: 0.0% (0us) | Total: 0.1% (6.2ms) | Samples: 0

**Called by:**
- `runPlugins` (4)

**Calls:**
- `getDFSEvents` (2)
- `getDFSEvents` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313031` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config-loader.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319364` | Self: 0.0% (0us) | Total: 0.1% (6.1ms) | Samples: 0

**Called by:**
- `map` (4)

**Calls:**
- `getParamName` (3)
- `getParamName` (1)

### `getParser4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318443` | Self: 0.0% (0us) | Total: 0.1% (7.1ms) | Samples: 0

**Called by:**
- `parse3` (5)

**Calls:**
- `getParser` (4)
- `getParser` (1)

### `node:assert/strict`
`node:assert/strict:3` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109700` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:122926` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332756` | Self: 0.0% (0us) | Total: 0.1% (5.6ms) | Samples: 0

**Called by:**
- `iterate` (4)

**Calls:**
- `(anonymous)` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/type-check/lib/parse-type.js:198` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:254632` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301141` | Self: 0.0% (0us) | Total: 0.2% (9.0ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `map` (6)

### `parseInlineTags`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318701` | Self: 0.0% (0us) | Total: 5.1% (214.9ms) | Samples: 0

**Called by:**
- `parseComment` (140)

**Calls:**
- `parseDescription` (94)
- `parseDescription` (46)

### `checkNonJsdoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326197` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `bound checkNonJsdoc` (1)

**Calls:**
- `some` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:199297` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:279` | Self: 0.0% (0us) | Total: 0.1% (4.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `map` (3)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8329` | Self: 0.0% (0us) | Total: 1.4% (60.7ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (40)

**Calls:**
- `buildVisitorMap` (28)
- `buildVisitorMap` (10)
- `buildVisitorMap` (1)
- `buildVisitorMap` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201826` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-modifiers.js:38` | Self: 0.0% (0us) | Total: 0.1% (5.1ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:47620` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:279822` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201872` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:123490` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:22610` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `flatten` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260469` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329198` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `flatIntoArrayWithCallback` (1)

**Calls:**
- `get key` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317438` | Self: 0.0% (0us) | Total: 0.3% (13.9ms) | Samples: 0

**Called by:**
- `forEach` (9)

**Calls:**
- `cleanUpLastTag` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329667` | Self: 0.0% (0us) | Total: 0.1% (4.5ms) | Samples: 0

**Called by:**
- `filter` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:146346` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `onProgramExit`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321192` | Self: 0.0% (0us) | Total: 0.3% (13.7ms) | Samples: 0

**Called by:**
- `Program:exit` (9)

**Calls:**
- `filter` (9)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321298` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (1)

**Calls:**
- `getSettings` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:560` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `parse`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:163893` | Self: 0.0% (0us) | Total: 1.3% (54.3ms) | Samples: 0

**Called by:**
- `Comparator` (3)

**Calls:**
- `SemVer` (2)
- `SemVer` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334431` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `canSkip6` (1)
- `canSkip6` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:53708` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

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
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333582` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `canSkip3` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/index.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

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
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332426` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:263291` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332097` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:180372` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `filterTags`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319495` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `filter` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333230` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `canSkip` (2)

### `forEachPreferredTag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319536` | Self: 0.0% (0us) | Total: 2.1% (88.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (58)

**Calls:**
- `getPreferredTagName` (58)

### `get id`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2340` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `nodeView` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328995` | Self: 0.0% (0us) | Total: 0.1% (4.4ms) | Samples: 0

**Called by:**
- `filter` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320777` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `canSkip2` (1)

**Calls:**
- `hasATag` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:122919` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320720` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173276` | Self: 0.0% (0us) | Total: 0.4% (18.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (12)

**Calls:**
- `bound require` (12)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173277` | Self: 0.0% (0us) | Total: 2.5% (105.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (25)

**Calls:**
- `(anonymous)` (25)

### `validNamepathParsing`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336793` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `tryParsePathIgnoreError` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320932` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getJSDocComment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/type-check/lib/index.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `flatMap`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `flatIntoArrayWithCallback` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:266460` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_fuseHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5077` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_buildPlan` (1)

**Calls:**
- `_analyzeHandler` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318116` | Self: 0.0% (0us) | Total: 1.1% (49.2ms) | Samples: 0

**Called by:**
- `toggleFence` (32)

**Calls:**
- `stringSplitFast` (32)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:21` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334441` | Self: 0.0% (0us) | Total: 0.2% (10.3ms) | Samples: 0

**Called by:**
- `iterate` (7)

**Calls:**
- `checkTagName2` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:246361` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:45765` | Self: 0.0% (0us) | Total: 0.1% (5.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:324400` | Self: 0.0% (0us) | Total: 0.0% (977us) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329007` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `flatIntoArrayWithCallback` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:14` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `cleanUpLastTag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317374` | Self: 0.0% (0us) | Total: 2.5% (105.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (57)
- `(anonymous)` (9)

**Calls:**
- `parse2` (55)
- `parse2` (10)
- `parse2` (1)

### `_addSchema`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:309` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `addSchema` (1)

**Calls:**
- `resolveIds` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4230` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_fromRunnerReport` (1)

**Calls:**
- `getLocFromIndex` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/cast.js:327` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332431` | Self: 0.0% (0us) | Total: 0.2% (10.8ms) | Samples: 0

**Called by:**
- `iterate` (7)

**Calls:**
- `(anonymous)` (7)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 37.2% (1.54s) | Samples: 0

**Called by:**
- `_loadBundle` (274)
- `(anonymous)` (49)
- `(anonymous)` (23)
- `(anonymous)` (23)
- `(anonymous)` (19)
- `(anonymous)` (19)
- `(anonymous)` (17)
- `(anonymous)` (15)
- `(anonymous)` (12)
- `(anonymous)` (11)
- `(anonymous)` (11)
- `(anonymous)` (9)
- `(anonymous)` (9)
- `(anonymous)` (9)
- `(anonymous)` (9)
- `(anonymous)` (9)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (8)
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
- `patchAstUtils` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (4)
- `getESLintCoreRule` (4)
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
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
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
- `require` (755)
- `anonymous` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:24` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164269` | Self: 0.0% (0us) | Total: 1.3% (54.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `Comparator` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:10` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313078` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (2)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318126` | Self: 0.0% (0us) | Total: 0.3% (13.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (8)

**Calls:**
- `seedTokens` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:284960` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getReducedASTNode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317860` | Self: 0.0% (0us) | Total: 0.2% (10.3ms) | Samples: 0

**Called by:**
- `getJSDocComment` (4)
- `getNonJsdocComment` (3)

**Calls:**
- `getCommentsBefore` (4)
- `getCommentsBefore` (2)
- `getCommentsBefore` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/project-service/dist/index.js:17` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:192911` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/unsupported-api.js:14` | Self: 0.0% (0us) | Total: 0.8% (35.1ms) | Samples: 0

**Called by:**
- `anonymous` (23)

**Calls:**
- `bound require` (23)

### `node:tty`
`node:tty:6` | Self: 0.0% (0us) | Total: 0.0% (3.4ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `anonymous` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:187895` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12521` | Self: 0.0% (0us) | Total: 0.1% (5.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `(anonymous)` (2)
- `createDebug` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/index.js:17` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91300` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/source-code-traverser.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301099` | Self: 0.0% (0us) | Total: 0.1% (8.0ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `(anonymous)` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228702` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:17` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `parse`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:53159` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `Comparator` (1)

**Calls:**
- `SemVer` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/node-utils.js:76` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:48` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `get lines`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3707` | Self: 0.0% (0us) | Total: 1.2% (53.1ms) | Samples: 0

**Called by:**
- `create` (35)

**Calls:**
- `regExpSplitFast` (35)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/index.js:26` | Self: 0.0% (0us) | Total: 0.3% (13.5ms) | Samples: 0

**Called by:**
- `anonymous` (9)

**Calls:**
- `bound require` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:162742` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `registerCodeFix` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:673` | Self: 0.0% (0us) | Total: 0.1% (6.8ms) | Samples: 0

**Called by:**
- `getAllComments` (5)

**Calls:**
- `_findLineIdx` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:241731` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/clear-caches.js:6` | Self: 0.0% (0us) | Total: 2.2% (92.2ms) | Samples: 0

**Called by:**
- `anonymous` (17)

**Calls:**
- `bound require` (17)

### `descriptionIsRedundant`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326954` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `areDocsInformative` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.1% (4.6ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172573` | Self: 0.0% (0us) | Total: 2.4% (103.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (24)

**Calls:**
- `(anonymous)` (24)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/find-up/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4251` | Self: 0.0% (0us) | Total: 0.2% (9.5ms) | Samples: 0

**Called by:**
- `parent` (2)
- `_nodesFromRange` (1)
- `get parent` (1)
- `get id` (1)
- `get key` (1)

**Calls:**
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317601` | Self: 0.0% (0us) | Total: 0.1% (7.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `commentParserToESTree` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318277` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `reduce` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:249445` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164402` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/code-path-analysis/code-path-state.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330137` | Self: 0.0% (0us) | Total: 0.1% (5.1ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `(anonymous)` (3)

### `checkNonJsdoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326210` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `bound checkNonJsdoc` (1)

**Calls:**
- `reportings` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:21` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `canSkip2`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333320` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/index.js:3` | Self: 0.0% (0us) | Total: 0.1% (7.9ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `hasRejectValue`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333180` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `nodeViewChain` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:29` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `addMetaSchema` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228441` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_loadBundle`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-loader.js:34` | Self: 0.0% (0us) | Total: 12.9% (534.4ms) | Samples: 0

**Called by:**
- `bundleRulesFor` (274)

**Calls:**
- `bound require` (274)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:200922` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:186763` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322864` | Self: 0.0% (0us) | Total: 0.4% (19.6ms) | Samples: 0

**Called by:**
- `iterate` (13)

**Calls:**
- `maskExcludedContent` (7)
- `maskExcludedContent` (6)

### `getParamName`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319258` | Self: 0.0% (0us) | Total: 0.1% (4.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `map` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289572` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:251761` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91298` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:12` | Self: 0.0% (0us) | Total: 0.2% (9.7ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:455` | Self: 0.0% (0us) | Total: 0.1% (7.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/lazy-loading-rule-map.js:7` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201859` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `every`
`[native code]` | Self: 0.0% (0us) | Total: 1.3% (57.3ms) | Samples: 0

**Called by:**
- `callIterator` (37)

**Calls:**
- `(anonymous)` (37)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170517` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260167` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320780` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `hasTag` (1)
- `hasTag` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289550` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96799` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `reportings`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326192` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `checkNonJsdocAfter` (1)

**Calls:**
- `report` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/project-service/dist/createProjectService.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:42` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:223096` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301149` | Self: 0.0% (0us) | Total: 0.1% (4.4ms) | Samples: 0

**Called by:**
- `map` (3)

**Calls:**
- `camelCase` (2)
- `camelCase` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327244` | Self: 0.0% (0us) | Total: 0.4% (19.7ms) | Samples: 0

**Called by:**
- `iterate` (13)

**Calls:**
- `(anonymous)` (13)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329215` | Self: 0.0% (0us) | Total: 0.1% (4.4ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138699` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:293086` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `parseIntermediateType`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314937` | Self: 0.0% (0us) | Total: 0.3% (13.7ms) | Samples: 0

**Called by:**
- `parseType` (9)

**Calls:**
- `tryParslets` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:198158` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_NoParsletFoundError`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314668` | Self: 0.0% (0us) | Total: 0.6% (27.2ms) | Samples: 0

**Called by:**
- `parseIntermediateType` (17)

**Calls:**
- `Error` (17)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328155` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `filter` (1)

**Calls:**
- `/^\/\*(?!\*)/v` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317581` | Self: 0.0% (0us) | Total: 2.3% (95.6ms) | Samples: 0

**Called by:**
- `forEach` (60)

**Calls:**
- `cleanUpLastTag` (57)
- `cleanUpLastTag` (1)
- `cleanUpLastTag` (1)
- `cleanUpLastTag` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201893` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:325987` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:166697` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12515` | Self: 0.0% (0us) | Total: 0.0% (3.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `parse`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.9% (40.6ms) | Samples: 0

**Called by:**
- `g` (26)

**Calls:**
- `Ae` (26)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/dotjs/index.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329663` | Self: 0.0% (0us) | Total: 0.1% (4.5ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `flatIntoArrayWithCallback` (2)
- `flatMap` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4291` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `report` (1)

**Calls:**
- `filter` (1)

### `getParser4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318438` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `parse3` (1)

**Calls:**
- `descriptionTokenizer` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332132` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289597` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8330` | Self: 0.0% (0us) | Total: 78.8% (3.26s) | Samples: 0

**Called by:**
- `_lintSourceOne` (2136)

**Calls:**
- `walkNodes` (1589)
- `walkNodes` (336)
- `walkNodes` (146)
- `walkNodes` (21)
- `walkNodes` (11)
- `walkNodes` (9)
- `walkNodes` (5)
- `walkNodes` (4)
- `walkNodes` (4)
- `walkNodes` (4)
- `walkNodes` (2)
- `walkNodes` (2)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170533` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171756` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333358` | Self: 0.0% (0us) | Total: 0.1% (6.2ms) | Samples: 0

**Called by:**
- `iterate` (4)

**Calls:**
- `(anonymous)` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301150` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `camelCase` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318143` | Self: 0.0% (0us) | Total: 0.3% (13.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (9)

**Calls:**
- `splitSpace` (6)
- `splitSpace` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301177` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `map` (2)

**Calls:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320765` | Self: 0.0% (0us) | Total: 1.4% (58.5ms) | Samples: 0

**Called by:**
- `checkTagName2` (7)
- `(anonymous)` (6)
- `(anonymous)` (5)
- `(anonymous)` (4)
- `checkTagName` (4)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `getPreferredTagName` (38)
- `getPreferredTagName` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201875` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `Ae`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.9% (40.6ms) | Samples: 0

**Called by:**
- `parse` (26)

**Calls:**
- `_e` (26)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/code-path-analysis/code-path.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336975` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `validNamepathParsing` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313115` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336920` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `map` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `split`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295588` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `splitPrefixSuffix` (1)

**Calls:**
- `replace` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:331944` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `checkJsDoc` (1)

**Calls:**
- `get loc` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92620` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `getParser4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318444` | Self: 0.0% (0us) | Total: 0.0% (2.4ms) | Samples: 0

**Called by:**
- `parse3` (1)

**Calls:**
- `getParser3` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321771` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `generateNamedReferences` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:110317` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318404` | Self: 0.0% (0us) | Total: 0.2% (10.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (7)

**Calls:**
- `preserveJoiner` (3)
- `preserveJoiner` (2)
- `preserveJoiner` (1)
- `preserveJoiner` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321332` | Self: 0.0% (0us) | Total: 1.2% (53.1ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (26)
- `buildVisitorMap` (9)

**Calls:**
- `get lines` (35)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2264` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `_symName` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289690` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328984` | Self: 0.0% (0us) | Total: 5.6% (232.3ms) | Samples: 0

**Called by:**
- `map` (153)

**Calls:**
- `parseComment` (85)
- `parseComment` (66)
- `parseComment` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:99` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329132` | Self: 0.0% (0us) | Total: 1.3% (53.8ms) | Samples: 0

**Called by:**
- `iterate` (35)

**Calls:**
- `Set` (31)
- `get` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:246242` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301200` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `add` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333255` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `shouldReport` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318357` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `search` (2)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5162` | Self: 0.0% (0us) | Total: 8.9% (372.4ms) | Samples: 0

**Called by:**
- `walkNodes` (243)

**Calls:**
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (175)
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (38)
- `bound ` (28)
- `(anonymous)` (2)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1261` | Self: 0.0% (0us) | Total: 0.1% (4.9ms) | Samples: 0

**Called by:**
- `getReducedASTNode` (3)

**Calls:**
- `_nodeViewRaw` (2)
- `nodeView` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318303` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isSpace` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201865` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322863` | Self: 0.0% (0us) | Total: 0.2% (12.0ms) | Samples: 0

**Called by:**
- `iterate` (8)

**Calls:**
- `maskCodeBlocks` (4)
- `maskCodeBlocks` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/tinyglobby/dist/index.cjs:27` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:20` | Self: 0.0% (0us) | Total: 0.1% (5.8ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `bound require` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/getWatchProgramsForProjects.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `find`
`[native code]` | Self: 0.0% (0us) | Total: 0.5% (23.3ms) | Samples: 0

**Called by:**
- `getPreferredTagNameSimple` (16)

**Calls:**
- `(anonymous)` (16)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317920` | Self: 0.0% (0us) | Total: 15.8% (657.0ms) | Samples: 0

**Called by:**
- `getJSDocComment` (434)

**Calls:**
- `findJSDocComment` (417)
- `findJSDocComment` (8)
- `findJSDocComment` (6)
- `findJSDocComment` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/dot-notation.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `match`
`[native code]` | Self: 0.0% (0us) | Total: 1.0% (44.5ms) | Samples: 0

**Called by:**
- `splitSpace` (15)
- `(anonymous)` (8)
- `splitCR` (6)

**Calls:**
- `[Symbol.match]` (29)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:276522` | Self: 0.0% (0us) | Total: 0.1% (6.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `(anonymous)` (4)

### `hasRejectValue`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333154` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `hasRejectValue` (3)

**Calls:**
- `some` (2)
- `get body` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/es2015.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164442` | Self: 0.0% (0us) | Total: 1.3% (54.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `(anonymous)` (3)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:220` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `_encodeSource` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329661` | Self: 0.0% (0us) | Total: 9.0% (376.1ms) | Samples: 0

**Called by:**
- `map` (242)

**Calls:**
- `commentParserToESTree` (83)
- `parseComment` (83)
- `parseComment` (71)
- `commentParserToESTree` (2)
- `commentParserToESTree` (2)
- `parseComment` (1)

### `_e`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 1.2% (51.2ms) | Samples: 0

**Called by:**
- `Ae` (26)
- `(anonymous)` (7)

**Calls:**
- `Pe` (33)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326874` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `flatIntoArrayWithCallback` (1)

**Calls:**
- `stringSplitFast` (1)

### `callIterator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321109` | Self: 0.0% (0us) | Total: 2.2% (91.8ms) | Samples: 0

**Called by:**
- `onNodeWithComment` (55)
- `onNodeAllNodes` (3)

**Calls:**
- `getIndentAndJSDoc` (57)
- `getIndentAndJSDoc` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:48` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:182911` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getESLintCoreRule` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290353` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `maskExcludedContent`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322832` | Self: 0.0% (0us) | Total: 0.2% (9.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `replace` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289484` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/default-config.js:37` | Self: 0.0% (0us) | Total: 0.1% (7.9ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:168169` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320427` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `some` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313097` | Self: 0.0% (0us) | Total: 1.8% (76.7ms) | Samples: 0

**Called by:**
- `anonymous` (50)

**Calls:**
- `(anonymous)` (50)

### `validateDescription`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330340` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `some` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201846` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `onNodeWithComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321177` | Self: 0.0% (0us) | Total: 32.5% (1.34s) | Samples: 0

**Called by:**
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (875)

**Calls:**
- `callIterator` (783)
- `callIterator` (55)
- `callIterator` (37)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:19` | Self: 0.0% (0us) | Total: 0.3% (13.2ms) | Samples: 0

**Called by:**
- `anonymous` (9)

**Calls:**
- `bound require` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164514` | Self: 0.0% (0us) | Total: 1.3% (56.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `(anonymous)` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317500` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `forEach` (2)

**Calls:**
- `cloneObject` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/parse-string.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` | Self: 0.0% (0us) | Total: 0.2% (10.5ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:20` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:6125` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:152901` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getParser4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318437` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `parse3` (1)

**Calls:**
- `nameTokenizer` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320928` | Self: 0.0% (0us) | Total: 0.1% (4.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `(anonymous)` (2)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92619` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171458` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330372` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `report` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334098` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92697` | Self: 0.0% (0us) | Total: 0.1% (8.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `(anonymous)` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318180` | Self: 0.0% (0us) | Total: 0.2% (11.6ms) | Samples: 0

**Called by:**
- `parseSpec` (8)

**Calls:**
- `match` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289613` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getValidRuntimeIdentifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329078` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `get` (2)

### `parse3`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318645` | Self: 0.0% (0us) | Total: 10.5% (435.5ms) | Samples: 0

**Called by:**
- `parseComment` (213)
- `(anonymous)` (71)

**Calls:**
- `(anonymous)` (78)
- `(anonymous)` (65)
- `(anonymous)` (44)
- `(anonymous)` (30)
- `getParser4` (27)
- `(anonymous)` (12)
- `getParser4` (7)
- `getParser4` (6)
- `getParser4` (5)
- `(anonymous)` (4)
- `getParser4` (1)
- `getParser4` (1)
- `getParser4` (1)
- `getParser4` (1)
- `(anonymous)` (1)
- `getParser4` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:33` | Self: 0.0% (0us) | Total: 40.5% (1.67s) | Samples: 0

**Called by:**
- `(anonymous)` (50)
- `(anonymous)` (50)
- `(anonymous)` (38)
- `(anonymous)` (28)
- `(anonymous)` (28)
- `(anonymous)` (25)
- `(anonymous)` (24)
- `(anonymous)` (24)
- `(anonymous)` (23)
- `(anonymous)` (21)
- `(anonymous)` (20)
- `(anonymous)` (19)
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
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
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
- `(anonymous)` (50)
- `(anonymous)` (49)
- `(anonymous)` (48)
- `(anonymous)` (28)
- `(anonymous)` (25)
- `(anonymous)` (24)
- `(anonymous)` (24)
- `(anonymous)` (23)
- `(anonymous)` (21)
- `(anonymous)` (20)
- `(anonymous)` (19)
- `(anonymous)` (19)
- `(anonymous)` (12)
- `(anonymous)` (6)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
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
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `validateDescription`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327223` | Self: 0.0% (0us) | Total: 2.7% (115.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (75)

**Calls:**
- `test` (75)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:335471` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5150` | Self: 0.0% (0us) | Total: 2.9% (122.0ms) | Samples: 0

**Called by:**
- `walkNodes` (82)

**Calls:**
- `bound ` (71)
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (11)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4317` | Self: 0.0% (0us) | Total: 0.5% (21.1ms) | Samples: 0

**Called by:**
- `report` (13)
- `report` (1)

**Calls:**
- `_execReport` (13)
- `_execReport` (1)

### `fixer`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332422` | Self: 0.0% (0us) | Total: 0.2% (9.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `fix10` (3)
- `fix10` (2)
- `fix10` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:48478` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

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

### `read`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316314` | Self: 0.0% (0us) | Total: 0.1% (4.8ms) | Samples: 0

**Called by:**
- `create` (2)
- `create` (1)

**Calls:**
- `trimStart` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172374` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `preserveJoiner`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318429` | Self: 0.0% (0us) | Total: 0.1% (4.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `join` (2)
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313083` | Self: 0.0% (0us) | Total: 1.3% (56.0ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `(anonymous)` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:185313` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getESLintCoreRule` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:42` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316297` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `parse2` (1)

**Calls:**
- `read` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:30` | Self: 0.0% (0us) | Total: 1.7% (73.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `(anonymous)` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:38` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `__export` (1)

### `getDefaultTagStructureForMode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313576` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `getTagStructureForMode` (1)
- `setTagStructure` (1)

**Calls:**
- `Map` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320753` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `canSkip3` (1)

**Calls:**
- `isConstructor` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321402` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `getContexts` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:128050` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/convert.js:41` | Self: 0.0% (0us) | Total: 0.2% (9.7ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `exec`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (2)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290028` | Self: 0.0% (0us) | Total: 1.0% (42.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (28)

**Calls:**
- `(anonymous)` (28)

### `parseType`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314934` | Self: 0.0% (0us) | Total: 2.0% (83.7ms) | Samples: 0

**Called by:**
- `parse` (54)

**Calls:**
- `parseIntermediateType` (45)
- `parseIntermediateType` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329664` | Self: 0.0% (0us) | Total: 0.1% (4.5ms) | Samples: 0

**Called by:**
- `flatIntoArrayWithCallback` (3)

**Calls:**
- `filter` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183944` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321263` | Self: 0.0% (0us) | Total: 3.9% (162.4ms) | Samples: 0

**Called by:**
- `_invokeFused` (106)

**Calls:**
- `(anonymous)` (105)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289490` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320920` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `toReversed` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:11` | Self: 0.0% (0us) | Total: 0.1% (7.3ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172431` | Self: 0.0% (0us) | Total: 2.4% (101.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (23)

**Calls:**
- `(anonymous)` (23)

### `getParamName`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319228` | Self: 0.0% (0us) | Total: 0.1% (6.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)
- `(anonymous)` (1)

**Calls:**
- `get typeAnnotation` (2)
- `get typeAnnotation` (1)
- `get typeAnnotation` (1)

### `findExpectedIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332165` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `fix10` (1)

**Calls:**
- `findIndex` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:251668` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328992` | Self: 0.0% (0us) | Total: 0.1% (4.4ms) | Samples: 0

**Called by:**
- `flatIntoArrayWithCallback` (3)

**Calls:**
- `filter` (3)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4276` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `hasRejectValue` (1)

**Calls:**
- `_isChainNode` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:40` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `Ce`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.6% (28.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (18)

**Calls:**
- `Pe` (17)
- `Se` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320895` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:97042` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161363` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `requestSatisfyUtil`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `requestInstantiate` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319259` | Self: 0.0% (0us) | Total: 0.1% (4.6ms) | Samples: 0

**Called by:**
- `map` (3)

**Calls:**
- `getParamName` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:178318` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323796` | Self: 0.0% (0us) | Total: 0.1% (7.2ms) | Samples: 0

**Called by:**
- `iterate` (5)

**Calls:**
- `(anonymous)` (3)
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:38` | Self: 0.0% (0us) | Total: 0.1% (8.1ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:181785` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getTagStructureForMode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319664` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `getDefaultTagStructureForMode` (1)
- `getDefaultTagStructureForMode` (1)
- `getDefaultTagStructureForMode` (1)

### `_analyzeHandler`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4982` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_fuseHandlers` (1)

**Calls:**
- `toString` (1)

### `setDeps`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326787` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `log` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330449` | Self: 0.0% (0us) | Total: 0.1% (4.2ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `validateDescription` (2)
- `validateDescription` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:241938` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `checkNonJsdoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326196` | Self: 0.0% (0us) | Total: 4.0% (166.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (98)
- `bound checkNonJsdoc` (12)

**Calls:**
- `getNonJsdocComment` (97)
- `getNonJsdocComment` (13)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:312911` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:285117` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:219660` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `parseInlineTags`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318704` | Self: 0.0% (0us) | Total: 2.1% (90.3ms) | Samples: 0

**Called by:**
- `parseComment` (59)

**Calls:**
- `parseDescription` (32)
- `parseDescription` (27)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318802` | Self: 0.0% (0us) | Total: 0.2% (10.6ms) | Samples: 0

**Called by:**
- `parseSpec` (7)

**Calls:**
- `(anonymous)` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/token-store/cursors.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326198` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `some` (1)

**Calls:**
- `trimStart` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4686` | Self: 0.0% (0us) | Total: 1.0% (42.2ms) | Samples: 0

**Called by:**
- `runPlugins` (28)

**Calls:**
- `create` (26)
- `create` (1)
- `create` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:257284` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170810` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/type-check/lib/index.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92521` | Self: 0.0% (0us) | Total: 0.1% (4.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `hasATag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319600` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `some` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171769` | Self: 0.0% (0us) | Total: 2.3% (97.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (20)

**Calls:**
- `(anonymous)` (20)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:199306` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173237` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:152815` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236471` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329658` | Self: 0.0% (0us) | Total: 2.6% (109.3ms) | Samples: 0

**Called by:**
- `iterate` (70)

**Calls:**
- `filter` (70)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:497` | Self: 0.0% (0us) | Total: 0.1% (7.9ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `patchAstUtils` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:44` | Self: 0.0% (0us) | Total: 0.5% (22.8ms) | Samples: 0

**Called by:**
- `anonymous` (15)

**Calls:**
- `bound require` (15)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6590` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_getOrBuildPlan` (1)

**Calls:**
- `_fuseHandlers` (1)

### `(anonymous)`
`/private/tmp/prof_jsdoc.js:7` | Self: 0.0% (0us) | Total: 12.9% (534.4ms) | Samples: 0

**Called by:**
- `parseModule` (274)

**Calls:**
- `bundleRulesFor` (274)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:53` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `processTicksAndRejections`
`[native code]` | Self: 0.0% (0us) | Total: 86.6% (3.58s) | Samples: 0

**Calls:**
- `(anonymous)` (2348)
- `onConstruct` (1)

### `y`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.1% (4.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329199` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `flatIntoArrayWithCallback` (2)

**Calls:**
- `get id` (1)
- `get id` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:22` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320756` | Self: 0.0% (0us) | Total: 0.1% (7.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:97097` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328981` | Self: 0.0% (0us) | Total: 2.8% (119.3ms) | Samples: 0

**Called by:**
- `iterate` (79)

**Calls:**
- `filter` (79)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/prelude-ls/lib/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201837` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1549` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (2)

**Calls:**
- `get loc` (1)
- `get loc` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/Scope.js:38` | Self: 0.0% (0us) | Total: 0.3% (13.5ms) | Samples: 0

**Called by:**
- `anonymous` (9)

**Calls:**
- `bound require` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/index.js:18` | Self: 0.0% (0us) | Total: 2.3% (95.5ms) | Samples: 0

**Called by:**
- `anonymous` (19)

**Calls:**
- `bound require` (19)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:271668` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `parse` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301171` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `addPolyfillToken` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183953` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `callIterator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321139` | Self: 0.0% (0us) | Total: 29.2% (1.21s) | Samples: 0

**Called by:**
- `onNodeWithComment` (783)
- `onProgramExit` (3)
- `onNodeAllNodes` (2)

**Calls:**
- `iterate` (783)
- `iterate` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/minimatch/dist/commonjs/index.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320789` | Self: 0.0% (0us) | Total: 0.1% (7.5ms) | Samples: 0

**Called by:**
- `canSkip` (2)
- `(anonymous)` (1)
- `canSkip4` (1)
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (3)
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:246288` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:261166` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/code-path-analysis/code-path-segment.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2074` | Self: 0.0% (0us) | Total: 11.2% (464.2ms) | Samples: 0

**Called by:**
- `getTokensBefore` (307)

**Calls:**
- `_getAllTokens` (299)
- `_getAllTokens` (7)
- `_getAllTokens` (1)

### `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321235` | Self: 0.0% (0us) | Total: 0.1% (7.7ms) | Samples: 0

**Called by:**
- `_invokeFused` (5)

**Calls:**
- `onNodeAllNodes` (5)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4288` | Self: 0.0% (0us) | Total: 0.4% (19.7ms) | Samples: 0

**Called by:**
- `report` (13)

**Calls:**
- `(anonymous)` (8)
- `(anonymous)` (2)
- `fix10` (1)
- `(anonymous)` (1)
- `fix10` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:15` | Self: 0.0% (0us) | Total: 0.1% (7.3ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:966` | Self: 0.0% (0us) | Total: 0.1% (4.3ms) | Samples: 0

**Called by:**
- `get value` (2)
- `get body` (1)

**Calls:**
- `nodeView` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:178969` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `reportings`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326185` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `checkNonJsdoc` (1)

**Calls:**
- `report` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:168154` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:900` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `_ensureDeclSymIndex` (1)

**Calls:**
- `_buildSymNameCache` (1)

### `canSkip6`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334403` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` | Self: 0.0% (0us) | Total: 5.4% (226.2ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (153)

**Calls:**
- `parse` (153)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/getWatchProgramsForProjects.js:43` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7392` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `_getOrBuildPlan` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289698` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330382` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `some` (1)

**Calls:**
- `report` (1)

### `getUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320279` | Self: 0.0% (0us) | Total: 1.7% (73.1ms) | Samples: 0

**Called by:**
- `iterate` (49)

**Calls:**
- `getAncestors` (39)
- `getAncestors` (10)

### `_getMergedIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1978` | Self: 0.0% (0us) | Total: 0.6% (26.1ms) | Samples: 0

**Called by:**
- `getTokenBefore` (18)

**Calls:**
- `getAllComments` (18)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/default-config.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:294928` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `isNameOrNamepathDefiningTag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319671` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `ensureMap` (1)
- `ensureMap` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228543` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188427` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289625` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:20` | Self: 0.0% (0us) | Total: 0.3% (16.1ms) | Samples: 0

**Called by:**
- `anonymous` (11)

**Calls:**
- `bound require` (11)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201884` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:3` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313051` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:276523` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:51201` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/getWatchProgramsForProjects.js:45` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295641` | Self: 0.0% (0us) | Total: 0.1% (4.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `toLocaleLowerCase` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:181777` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318291` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `stringSplitFast` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/token-store/backward-token-comment-cursor.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:106429` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334229` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `canSkip5` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333894` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `(anonymous)` (2)

### `isGetter2`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319999` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `exemptSpeciaMethods` (1)

**Calls:**
- `get kind` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:238154` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326176` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_execReport` (1)

**Calls:**
- `addComment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320741` | Self: 0.0% (0us) | Total: 0.1% (6.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `getFunctionParameterNames` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289524` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:490` | Self: 0.0% (0us) | Total: 0.2% (9.2ms) | Samples: 0

**Called by:**
- `parseSource` (2)

**Calls:**
- `CfgGraph` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289636` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334095` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `canSkip4` (1)

### `parse2`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317001` | Self: 0.0% (0us) | Total: 0.4% (18.0ms) | Samples: 0

**Called by:**
- `cleanUpLastTag` (10)

**Calls:**
- `create` (6)
- `create` (1)
- `Parser` (1)
- `Parser` (1)
- `create` (1)

### `toggleFence`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318099` | Self: 0.0% (0us) | Total: 1.1% (49.2ms) | Samples: 0

**Called by:**
- `parseBlock` (32)

**Calls:**
- `(anonymous)` (32)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:244113` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290132` | Self: 0.0% (0us) | Total: 0.1% (5.0ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289517` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:272045` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `parse` (1)

### `iterate`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321061` | Self: 0.0% (0us) | Total: 36.7% (1.52s) | Samples: 0

**Called by:**
- `callIterator` (783)
- `checkJsdoc` (209)

**Calls:**
- `(anonymous)` (242)
- `(anonymous)` (155)
- `(anonymous)` (87)
- `(anonymous)` (79)
- `(anonymous)` (77)
- `(anonymous)` (70)
- `(anonymous)` (44)
- `(anonymous)` (35)
- `(anonymous)` (15)
- `(anonymous)` (13)
- `(anonymous)` (13)
- `(anonymous)` (8)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (7)
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
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
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
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/ast-converter.js:4` | Self: 0.0% (0us) | Total: 0.2% (9.7ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171394` | Self: 0.0% (0us) | Total: 2.3% (95.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (19)

**Calls:**
- `bound require` (19)

### `FunctionDeclaration`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332020` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `_invokeFused` (2)

**Calls:**
- `checkJsDoc` (1)
- `checkJsDoc` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2978` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `get globalScope` (2)

**Calls:**
- `commentsInRange` (1)
- `commentsInRange` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/rules.js:3` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201900` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334119` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `shouldReport` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330151` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:257153` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `encodeInto` (1)

### `_NoParsletFoundError`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314670` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `parseIntermediateType` (1)

**Calls:**
- `setPrototypeOf` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:212973` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getCommentsBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3548` | Self: 0.0% (0us) | Total: 0.2% (12.2ms) | Samples: 0

**Called by:**
- `getReducedASTNode` (4)
- `getReducedASTNode` (4)

**Calls:**
- `commentsInRange` (3)
- `commentsInRange` (3)
- `commentsInRange` (1)
- `commentsInRange` (1)

### `fix10`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332417` | Self: 0.0% (0us) | Total: 0.1% (4.8ms) | Samples: 0

**Called by:**
- `fixer` (3)

**Calls:**
- `createTokens` (2)
- `createTokens` (1)

### `getReducedASTNode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317855` | Self: 0.0% (0us) | Total: 0.1% (6.8ms) | Samples: 0

**Called by:**
- `getJSDocComment` (4)

**Calls:**
- `getTokenBefore` (2)
- `getTokenBefore` (1)
- `getTokenBefore` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/code-path-analysis/code-path-analyzer.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:178599` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `parseModule`
`[native code]` | Self: 0.0% (0us) | Total: 13.3% (551.6ms) | Samples: 0

**Called by:**
- `async (anonymous)` (285)

**Calls:**
- `(anonymous)` (274)
- `(anonymous)` (9)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/dom.js:9` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4217` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_computeNodeType` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:18` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:257227` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:168170` | Self: 0.0% (0us) | Total: 1.8% (74.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (49)

**Calls:**
- `bound require` (49)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:254650` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/getModifiers.js:39` | Self: 0.0% (0us) | Total: 0.1% (5.1ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `getPreferredTagNameSimple`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319451` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `getPreferredTagName` (1)

**Calls:**
- `values` (1)

### `fix10`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332410` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `fixer` (2)

**Calls:**
- `findExpectedIndex` (1)
- `findExpectedIndex` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290169` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92623` | Self: 0.0% (0us) | Total: 0.1% (4.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `(anonymous)` (3)

### `getFunctionParameterNames`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319363` | Self: 0.0% (0us) | Total: 0.1% (6.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `map` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236594` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:146402` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320330` | Self: 0.0% (0us) | Total: 0.4% (17.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (7)
- `(anonymous)` (3)
- `(anonymous)` (1)

**Calls:**
- `report` (11)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313027` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201850` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289673` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289744` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/ClassVisitor.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320331` | Self: 0.0% (0us) | Total: 0.3% (12.7ms) | Samples: 0

**Called by:**
- `_execReport` (8)

**Calls:**
- `fixer` (6)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/getWatchProgramsForProjects.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `getLocFromIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3785` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `get loc` (1)

**Calls:**
- `_findLine` (1)

### `fix10`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330347` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_execReport` (1)

**Calls:**
- `RegExp` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161302` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `validateDescription`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327222` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4166` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_nodeViewRaw` (1)

**Calls:**
- `_computeIdentifierName` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171466` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330565` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289535` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:288245` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:9` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `getDefaultTagStructureForMode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313867` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `getTagStructureForMode` (1)

**Calls:**
- `Map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:217508` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289711` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289542` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:7` | Self: 0.0% (0us) | Total: 0.2% (8.9ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `canSkip4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334089` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171766` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/token-store/index.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161552` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` | Self: 0.0% (0us) | Total: 6.1% (253.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (167)

**Calls:**
- `parseSource` (153)
- `parseSource` (13)
- `parseSource` (1)

### `areDocsInformative`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326859` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `descriptionIsRedundant` (1)

**Calls:**
- `splitTextIntoWords` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327258` | Self: 0.0% (0us) | Total: 0.5% (22.4ms) | Samples: 0

**Called by:**
- `iterate` (15)

**Calls:**
- `(anonymous)` (15)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:254474` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/eslint-utils/astUtilities.js:37` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:90428` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:196453` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `parseComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318818` | Self: 0.0% (0us) | Total: 7.9% (327.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (85)
- `(anonymous)` (71)
- `getIndentAndJSDoc` (57)

**Calls:**
- `parse3` (213)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:200931` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2334` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get value` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:911` | Self: 0.0% (0us) | Total: 0.1% (7.6ms) | Samples: 0

**Called by:**
- `get` (5)

**Calls:**
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201928` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `checkTagName2`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334406` | Self: 0.0% (0us) | Total: 0.2% (10.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (7)

**Calls:**
- `(anonymous)` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rule-tester/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 13.3% (554.5ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)
- `requestInstantiate` (1)

**Calls:**
- `parseModule` (285)
- `async (anonymous)` (1)
- `requestFetch` (1)

### `requestInstantiate`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `requestSatisfyUtil` (1)

**Calls:**
- `async (anonymous)` (1)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 37.0% (1.53s) | Samples: 0

**Called by:**
- `bound require` (755)

**Calls:**
- `anonymous` (755)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109709` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `requestFetch`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `fetch` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:51143` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326976` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `descriptionIsRedundant` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320894` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `filterTags` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295623` | Self: 0.0% (0us) | Total: 0.1% (4.3ms) | Samples: 0

**Called by:**
- `map` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:53535` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `Comparator` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/api.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173249` | Self: 0.0% (0us) | Total: 2.4% (103.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (24)

**Calls:**
- `(anonymous)` (24)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190758` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getESLintCoreRule` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330563` | Self: 0.0% (0us) | Total: 0.1% (4.6ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:215647` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329242` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `getRegexFromString`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320063` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `RegExp` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260567` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:653` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `getCommentsBefore` (1)

**Calls:**
- `source` (1)

### `getAllComments`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3592` | Self: 0.0% (0us) | Total: 0.6% (26.1ms) | Samples: 0

**Called by:**
- `_getMergedIndex` (18)

**Calls:**
- `commentsInRange` (5)
- `commentsInRange` (5)
- `commentsInRange` (2)
- `commentsInRange` (2)
- `commentsInRange` (2)
- `commentsInRange` (1)
- `commentsInRange` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:1664` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `splitTextIntoWords`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326873` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `areDocsInformative` (1)

**Calls:**
- `flatIntoArrayWithCallback` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:266391` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:48398` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320859` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `getTagStructureForMode` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:296352` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:277069` | Self: 0.0% (0us) | Total: 0.1% (7.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `(anonymous)` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:282222` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `checkJsDoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:331971` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `FunctionDeclaration` (1)

**Calls:**
- `report` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:94742` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316301` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `parse2` (1)

**Calls:**
- `_Lexer` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:266521` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172349` | Self: 0.0% (0us) | Total: 2.3% (98.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (21)

**Calls:**
- `(anonymous)` (21)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:288208` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2485` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `get` (1)

### `get key`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3213` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `nodeView` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:246440` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `maskExcludedContent`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322831` | Self: 0.0% (0us) | Total: 0.2% (10.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (7)

**Calls:**
- `RegExp` (7)

### `splitPrefixSuffix`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295677` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `camelCase` (1)

**Calls:**
- `split` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:47927` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:198166` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260359` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `g`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.9% (40.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (26)

**Calls:**
- `parse` (26)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:69` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333682` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `(anonymous)` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7949` | Self: 0.0% (0us) | Total: 12.3% (509.3ms) | Samples: 0

**Called by:**
- `runPlugins` (336)

**Calls:**
- `invokeMethodFnHandlers` (331)
- `invokeMethodFnHandlers` (4)
- `invokeMethodFnHandlers` (1)

### `shouldReport`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333253` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `hasRejectValue` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:217671` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `Pe`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 1.8% (77.9ms) | Samples: 0

**Called by:**
- `_e` (33)
- `Ce` (17)

**Calls:**
- `we` (47)
- `Se` (3)

### `_fromRunnerReport`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:205` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `map` (2)

**Calls:**
- `get loc` (1)
- `get loc` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:187886` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201881` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `callIterator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321150` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `onProgramExit` (2)

**Calls:**
- `exit` (2)

### `parseComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318819` | Self: 0.0% (0us) | Total: 0.1% (4.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)
- `(anonymous)` (1)

**Calls:**
- `getTokenizers` (2)
- `getTokenizers` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329670` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `flatIntoArrayWithCallback` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321135` | Self: 0.0% (0us) | Total: 1.3% (57.3ms) | Samples: 0

**Called by:**
- `every` (37)

**Calls:**
- `(anonymous)` (26)
- `(anonymous)` (6)
- `(anonymous)` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:335396` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `some` (1)

### `parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1261` | Self: 0.0% (0us) | Total: 0.0% (3.4ms) | Samples: 0

**Called by:**
- `_invokeFused` (2)

**Calls:**
- `nodeView` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289501` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `addSchema`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:137` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `addMetaSchema` (1)

**Calls:**
- `_addSchema` (1)

### `bundleRulesFor`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-loader.js:59` | Self: 0.0% (0us) | Total: 12.9% (534.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (274)

**Calls:**
- `_loadBundle` (274)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320942` | Self: 0.0% (0us) | Total: 0.1% (5.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)
- `canSkip6` (1)

**Calls:**
- `(anonymous)` (3)
- `(anonymous)` (1)

### `iterate`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321046` | Self: 0.0% (0us) | Total: 2.2% (91.1ms) | Samples: 0

**Called by:**
- `checkJsdoc` (56)
- `callIterator` (5)

**Calls:**
- `getUtils` (49)
- `getUtils` (8)
- `getUtils` (1)
- `getUtils` (1)
- `getUtils` (1)
- `getUtils` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:168014` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `Comparator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:53138` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `parse` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313105` | Self: 0.0% (0us) | Total: 3.0% (124.8ms) | Samples: 0

**Called by:**
- `anonymous` (38)

**Calls:**
- `(anonymous)` (38)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319496` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `filter` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329245` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313036` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289584` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171548` | Self: 0.0% (0us) | Total: 2.3% (95.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (19)

**Calls:**
- `(anonymous)` (19)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:176119` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getESLintCoreRule` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2543` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `_mkGlobalVar` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4229` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `_fromRunnerReport` (1)

**Calls:**
- `getLocFromIndex` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/parse-string.js:113` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318766` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `parseSpec` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:159496` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172340` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228050` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290382` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171550` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161604` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:18` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333589` | Self: 0.0% (0us) | Total: 0.1% (4.5ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 86.6% (3.58s) | Samples: 0

**Called by:**
- `processTicksAndRejections` (2348)

**Calls:**
- `_lintSourceOne` (2177)
- `_lintSourceOne` (167)
- `_lintSourceOne` (3)
- `requestSatisfyUtil` (1)
- `async loadAndEvaluateModule` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:110315` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317603` | Self: 0.0% (0us) | Total: 0.2% (9.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `(anonymous)` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:196461` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320946` | Self: 0.0% (0us) | Total: 2.1% (88.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (15)
- `(anonymous)` (13)
- `(anonymous)` (6)
- `(anonymous)` (5)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `forEachPreferredTag` (58)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:192882` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `defineProperty` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/index.js:9` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/index.js:12` | Self: 0.0% (0us) | Total: 0.1% (7.9ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/predicates.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330131` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328983` | Self: 0.0% (0us) | Total: 5.6% (235.1ms) | Samples: 0

**Called by:**
- `iterate` (155)

**Calls:**
- `map` (155)

### `onNodeAllNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321188` | Self: 0.0% (0us) | Total: 0.1% (7.7ms) | Samples: 0

**Called by:**
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (5)

**Calls:**
- `callIterator` (3)
- `callIterator` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:261100` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/es2017.js:15` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333346` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `canSkip2` (1)
- `canSkip2` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172343` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1544` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `_buildScope` (1)
- `invokeMethodFnHandlers` (1)

**Calls:**
- `_nodesFromRange` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289663` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:192920` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:293430` | Self: 0.0% (0us) | Total: 0.8% (35.1ms) | Samples: 0

**Called by:**
- `anonymous` (23)

**Calls:**
- `bound require` (23)

### `(anonymous)`
`/private/tmp/prof_jsdoc.js:2` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `bound require` (1)

### `async loadAndEvaluateModule`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `linkAndEvaluateModule` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:180363` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `canSkip`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333223` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138272` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320241` | Self: 0.0% (0us) | Total: 0.2% (9.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)
- `(anonymous)` (3)

**Calls:**
- `isNameOrNamepathDefiningTag` (4)
- `isNameOrNamepathDefiningTag` (2)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 40.7% | 1.68s | `[native code]` |
| 29.7% | 1.23s | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 23.3% | 968.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 4.1% | 173.2ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 1.1% | 46.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.4% | 19.1ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.0% | 1.7ms | `internal:fs/streams` |
| 0.0% | 1.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/api.js` |
| 0.0% | 1.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/eslint-utils/astUtilities.js` |
| 0.0% | 1.7ms | `/private/tmp/prof_jsdoc.js` |
| 0.0% | 1.5ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/scope/CatchScope.js` |
| 0.0% | 1.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/type-check/lib/parse-type.js` |
| 0.0% | 1.4ms | `node:events` |
| 0.0% | 1.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/eslint-utils/RuleCreator.js` |
| 0.0% | 1.2ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/debug/src/node.js` |
