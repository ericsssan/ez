# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 4.03s | 2531 | 1.0ms | 1250 |

**Top 10:** `_makeToken` 6.1%, `parse` 5.6%, `anonymous` 5.5%, `_makeToken` 4.1%, `get flags` 3.3%, `entries` 3.0%, `getTokenBefore` 2.5%, ``/^\n?([A-Z`\d_][\s\S]*[.?!`\p{RGI_Emoji}]\s*)?$/v`` 2.3%, `(anonymous)` 2.3%, `(anonymous)` 2.1%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 6.1% | 247.2ms | 6.1% | 247.2ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1300` |
| 5.6% | 229.0ms | 5.6% | 229.0ms | `parse` | `[native code]` |
| 5.5% | 223.6ms | 37.5% | 1.51s | `anonymous` | `[native code]` |
| 4.1% | 167.5ms | 4.1% | 167.5ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1288` |
| 3.3% | 134.7ms | 3.4% | 139.5ms | `get flags` | `[native code]` |
| 3.0% | 122.5ms | 3.0% | 122.5ms | `entries` | `[native code]` |
| 2.5% | 102.6ms | 18.6% | 754.4ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1673` |
| 2.3% | 95.6ms | 2.3% | 95.6ms | ``/^\n?([A-Z`\d_][\s\S]*[.?!`\p{RGI_Emoji}]\s*)?$/v`` | `[native code]` |
| 2.3% | 95.5ms | 2.3% | 95.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 2.1% | 87.5ms | 2.4% | 97.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328982` |
| 2.0% | 83.8ms | 2.0% | 83.8ms | `seedTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318080` |
| 1.9% | 80.4ms | 1.9% | 80.4ms | `getOwnPropertyDescriptor` | `[native code]` |
| 1.9% | 78.5ms | 1.9% | 78.5ms | `/(?<!\])\{@(?<tag>[^\}\s]+)\s?(?<namepathOrURL>[^\}\s\\|]*)\s*(?<separator>[\s\\|])?\s*(?<text>[^\}]*)\}/dgv` | `[native code]` |
| 1.7% | 71.3ms | 12.9% | 522.1ms | `filter` | `[native code]` |
| 1.7% | 70.9ms | 1.9% | 80.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329659` |
| 1.6% | 67.8ms | 2.6% | 106.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328987` |
| 1.5% | 60.7ms | 59.2% | 2.39s | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7720` |
| 1.3% | 56.3ms | 2.2% | 89.3ms | `regExpSplitFast` | `[native code]` |
| 1.3% | 54.8ms | 1.3% | 54.8ms | `SemVer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:162890` |
| 1.2% | 50.8ms | 1.7% | 69.7ms | `[Symbol.match]` | `[native code]` |
| 1.1% | 48.1ms | 1.1% | 48.1ms | `stringSplitFast` | `[native code]` |
| 1.0% | 43.3ms | 1.0% | 43.3ms | `getValidRuntimeIdentifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329079` |
| 1.0% | 42.8ms | 1.0% | 42.8ms | `Set` | `[native code]` |
| 0.9% | 38.2ms | 0.9% | 38.2ms | `/^\s*globals/v` | `[native code]` |
| 0.9% | 36.3ms | 1.4% | 59.8ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1285` |
| 0.8% | 33.3ms | 0.8% | 33.3ms | `getText` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1346` |
| 0.8% | 33.0ms | 0.8% | 33.0ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1260` |
| 0.8% | 32.9ms | 0.8% | 32.9ms | `/\r\n\|\r\|\n\|\u2028\|\u2029/` | `[native code]` |
| 0.6% | 27.7ms | 3.0% | 123.4ms | `test` | `[native code]` |
| 0.6% | 25.4ms | 1.3% | 53.9ms | `parseIntermediateType` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314939` |
| 0.6% | 25.3ms | 0.6% | 25.3ms | `parseSpec` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318169` |
| 0.5% | 23.6ms | 7.5% | 305.5ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318044` |
| 0.5% | 23.1ms | 20.2% | 817.1ms | `map` | `[native code]` |
| 0.5% | 21.9ms | 1.1% | 48.3ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1975` |
| 0.5% | 21.8ms | 0.5% | 21.8ms | `Error` | `[native code]` |
| 0.5% | 21.0ms | 0.5% | 21.0ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318032` |
| 0.4% | 19.5ms | 0.4% | 19.5ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320879` |
| 0.4% | 19.0ms | 0.4% | 19.0ms | `/^\*(?!\*)/v` | `[native code]` |
| 0.4% | 18.0ms | 1.4% | 58.3ms | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321103` |
| 0.4% | 17.8ms | 0.4% | 17.8ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1292` |
| 0.4% | 16.7ms | 0.4% | 16.7ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318017` |
| 0.4% | 16.7ms | 0.4% | 16.7ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.4% | 16.1ms | 0.4% | 16.1ms | `esSpecIsRegExp` | `[native code]` |
| 0.3% | 15.9ms | 0.3% | 15.9ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:676` |
| 0.3% | 15.7ms | 0.3% | 15.7ms | `join` | `[native code]` |
| 0.3% | 15.5ms | 0.3% | 15.5ms | `[Symbol.matchAll]` | `[native code]` |
| 0.3% | 15.4ms | 0.5% | 20.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328146` |
| 0.3% | 14.6ms | 0.3% | 14.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7386` |
| 0.3% | 14.5ms | 13.8% | 557.7ms | `_getAllTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1932` |
| 0.3% | 13.9ms | 0.3% | 13.9ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1202` |
| 0.3% | 13.8ms | 4.4% | 178.5ms | `parseDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318682` |
| 0.3% | 13.7ms | 0.5% | 20.3ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1656` |
| 0.3% | 13.7ms | 0.5% | 22.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319474` |
| 0.3% | 13.6ms | 0.3% | 13.6ms | `RegExp` | `[native code]` |
| 0.3% | 12.7ms | 0.3% | 12.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.3% | 12.5ms | 0.3% | 12.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301189` |
| 0.2% | 11.9ms | 2.2% | 91.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.2% | 11.8ms | 0.2% | 11.8ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1264` |
| 0.2% | 11.8ms | 0.2% | 11.8ms | `_getAllTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1933` |
| 0.2% | 11.6ms | 2.4% | 98.2ms | `regExpExec` | `[native code]` |
| 0.2% | 11.3ms | 0.2% | 11.3ms | `splitSpace` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318068` |
| 0.2% | 11.1ms | 0.2% | 11.1ms | `trimEnd` | `[native code]` |
| 0.2% | 10.8ms | 0.2% | 10.8ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1977` |
| 0.2% | 10.7ms | 0.2% | 10.7ms | `replace` | `[native code]` |
| 0.2% | 10.6ms | 3.2% | 129.4ms | `parseDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318681` |
| 0.2% | 10.6ms | 0.2% | 12.0ms | `parslet` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315038` |
| 0.2% | 10.3ms | 0.2% | 10.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7855` |
| 0.2% | 9.7ms | 0.4% | 17.4ms | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317830` |
| 0.2% | 9.4ms | 0.2% | 11.0ms | `getCommentsBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3401` |
| 0.2% | 9.4ms | 0.2% | 9.4ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4522` |
| 0.2% | 9.3ms | 0.2% | 9.3ms | `trim` | `[native code]` |
| 0.2% | 9.2ms | 0.2% | 9.2ms | `endsWith` | `[native code]` |
| 0.2% | 9.2ms | 0.2% | 9.2ms | `/\r+$/` | `[native code]` |
| 0.2% | 9.0ms | 0.2% | 9.0ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1677` |
| 0.2% | 9.0ms | 0.2% | 9.0ms | `includes` | `[native code]` |
| 0.2% | 9.0ms | 0.2% | 9.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317512` |
| 0.2% | 9.0ms | 0.2% | 9.0ms | `concat` | `[native code]` |
| 0.2% | 8.9ms | 36.7% | 1.48s | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5080` |
| 0.2% | 8.9ms | 0.2% | 8.9ms | `seedSpec` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318077` |
| 0.2% | 8.9ms | 0.2% | 10.4ms | `parseBlock` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318104` |
| 0.2% | 8.8ms | 0.6% | 28.0ms | `some` | `[native code]` |
| 0.2% | 8.6ms | 0.2% | 8.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7382` |
| 0.2% | 8.1ms | 0.2% | 8.1ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:590` |
| 0.1% | 8.0ms | 0.1% | 8.0ms | `/(?:\[(?<text>[^\]]+)\])\{@(?<tag>[^\}\s]+)\s?(?<namepathOrURL>[^\}\s\\|]*)\}/dgv` | `[native code]` |
| 0.1% | 7.8ms | 0.1% | 7.8ms | `stringIncludesInternal` | `[native code]` |
| 0.1% | 7.6ms | 3.8% | 157.1ms | `checkJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321335` |
| 0.1% | 7.6ms | 0.5% | 22.8ms | `getDecorator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317745` |
| 0.1% | 7.5ms | 0.2% | 10.5ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320283` |
| 0.1% | 7.4ms | 3.0% | 124.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328166` |
| 0.1% | 7.0ms | 0.1% | 7.0ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318129` |
| 0.1% | 6.6ms | 0.1% | 6.6ms | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318440` |
| 0.1% | 6.5ms | 0.1% | 6.5ms | `/^\s+/` | `[native code]` |
| 0.1% | 6.4ms | 0.1% | 6.4ms | `trimStart` | `[native code]` |
| 0.1% | 6.3ms | 19.1% | 774.5ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317893` |
| 0.1% | 6.2ms | 0.1% | 6.2ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318014` |
| 0.1% | 6.2ms | 0.6% | 27.8ms | `compactJoiner` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318416` |
| 0.1% | 6.1ms | 0.1% | 6.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321192` |
| 0.1% | 6.0ms | 0.1% | 6.0ms | `getBasicUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320240` |
| 0.1% | 5.8ms | 0.1% | 5.8ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 0.1% | 5.7ms | 0.1% | 5.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4211` |
| 0.1% | 5.6ms | 0.1% | 5.6ms | `getIndentAndJSDoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321082` |
| 0.1% | 5.6ms | 0.1% | 5.6ms | `unshift` | `[native code]` |
| 0.1% | 5.6ms | 0.1% | 5.6ms | `Ee` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.1% | 5.2ms | 15.2% | 613.4ms | `bound checkJsdoc` | `[native code]` |
| 0.1% | 5.1ms | 0.1% | 5.1ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318029` |
| 0.1% | 4.9ms | 0.1% | 4.9ms | `replaceAll` | `[native code]` |
| 0.1% | 4.9ms | 0.1% | 4.9ms | `maskCodeBlocks` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.1% | 4.9ms | 0.1% | 4.9ms | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321101` |
| 0.1% | 4.9ms | 0.1% | 4.9ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1228` |
| 0.1% | 4.8ms | 0.1% | 6.0ms | `reduce` | `[native code]` |
| 0.1% | 4.7ms | 0.1% | 4.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7682` |
| 0.1% | 4.7ms | 0.1% | 4.7ms | `join` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318467` |
| 0.1% | 4.6ms | 0.1% | 4.6ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4094` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `copyDataProperties` | `[native code]` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318796` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `cloneObject` | `[native code]` |
| 0.1% | 4.4ms | 2.5% | 104.3ms | `performIteration` | `[native code]` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1253` |
| 0.1% | 4.3ms | 11.3% | 456.3ms | `parse3` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318645` |
| 0.1% | 4.3ms | 0.1% | 6.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318458` |
| 0.1% | 4.3ms | 0.1% | 4.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320918` |
| 0.1% | 4.3ms | 0.1% | 4.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7689` |
| 0.1% | 4.1ms | 0.1% | 4.1ms | `/^\/\*\*\s/v` | `[native code]` |
| 0.1% | 4.1ms | 0.1% | 4.1ms | `getTokenizers` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318761` |
| 0.1% | 4.0ms | 0.1% | 5.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317500` |
| 0.0% | 3.8ms | 0.0% | 3.8ms | `encodeInto` | `[native code]` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `[Symbol.iterator]` | `[native code]` |
| 0.0% | 3.4ms | 0.5% | 21.6ms | `flatIntoArrayWithCallback` | `[native code]` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318209` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `parse2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317012` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 3.4ms | 0.2% | 9.3ms | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316299` |
| 0.0% | 3.3ms | 0.9% | 40.1ms | `ke` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `decode` | `[native code]` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317506` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329199` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `tokenToString` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314662` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318454` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `ensureMap` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319626` |
| 0.0% | 3.2ms | 3.7% | 150.0ms | `getPreferredTagName` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319514` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `checkJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321339` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7092` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322295` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1187` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3682` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318042` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `descriptionTokenizer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318401` |
| 0.0% | 3.1ms | 1.0% | 40.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318116` |
| 0.0% | 3.1ms | 0.4% | 18.3ms | `tryParslets` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314956` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:717` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318763` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3673` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1262` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `read` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316330` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:593` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2144` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `freeze` | `[native code]` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1290` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1653` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7368` |
| 0.0% | 2.9ms | 0.5% | 23.2ms | `getNonJsdocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317950` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` |
| 0.0% | 2.8ms | 1.1% | 47.9ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317919` |
| 0.0% | 2.8ms | 1.0% | 40.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318448` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1302` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318007` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321102` |
| 0.0% | 2.8ms | 0.2% | 11.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320942` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1192` |
| 0.0% | 2.7ms | 0.1% | 4.4ms | `read` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316313` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332414` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7680` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `defineProperty` | `[native code]` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `Map` | `[native code]` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `_tokType` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318147` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `isNameOrNamepathDefiningTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319675` |
| 0.0% | 2.6ms | 0.7% | 29.9ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5058` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318434` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `get declaration` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3611` |
| 0.0% | 2.6ms | 0.5% | 22.6ms | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317855` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318140` |
| 0.0% | 1.8ms | 0.0% | 3.6ms | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318442` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318151` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4174` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `toLocaleUpperCase` | `[native code]` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2153` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2150` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `getParser2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318121` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320768` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `unionWith` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/visitor-keys/node_modules/eslint-visitor-keys/dist/eslint-visitor-keys.cjs` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1185` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1230` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:580` |
| 0.0% | 1.7ms | 0.3% | 15.5ms | `splitCR` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318063` |
| 0.0% | 1.7ms | 0.4% | 16.8ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318133` |
| 0.0% | 1.7ms | 0.7% | 28.5ms | `_NoParsletFoundError` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314668` |
| 0.0% | 1.7ms | 0.0% | 3.1ms | `getAncestors` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3687` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get sticky` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318132` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `onNodeWithComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321176` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `commentParserToESTree` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317393` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317570` |
| 0.0% | 1.7ms | 0.5% | 23.1ms | `parse2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317001` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1971` |
| 0.0% | 1.7ms | 38.0% | 1.53s | `iterate` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321061` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `hasReturnValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318844` |
| 0.0% | 1.7ms | 15.0% | 607.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326238` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317997` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2753` |
| 0.0% | 1.7ms | 1.8% | 74.0ms | `parseType` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314934` |
| 0.0% | 1.7ms | 0.0% | 2.9ms | `hasRejectValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333151` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get ignoreCase` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318131` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `preserveJoiner` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318423` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4144` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:183987` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `parse5` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getContexts` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328706` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `nameTokenizer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318275` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getRegexFromString` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320060` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get kind` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2733` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:901` |
| 0.0% | 1.7ms | 0.0% | 3.1ms | `be` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `/\s*(@(\S+))(\s*)/` | `[native code]` |
| 0.0% | 1.7ms | 11.0% | 444.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329661` |
| 0.0% | 1.7ms | 7.7% | 310.8ms | `parseComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318829` |
| 0.0% | 1.7ms | 0.2% | 9.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333233` |
| 0.0% | 1.6ms | 3.2% | 131.8ms | `forEach` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 2.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320920` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `hasSchemaOption` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320025` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/node-utils.js:55` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/getModifiers.js:4` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1312` |
| 0.0% | 1.6ms | 19.9% | 803.5ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318016` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:189166` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `set` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172175` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getBasicUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320244` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:179587` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `__export` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:24` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:609` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `toLocaleLowerCase` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:1` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170720` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `read` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316323` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `setup` | `[native code]` |
| 0.0% | 1.6ms | 0.3% | 14.3ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318139` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `/^\s+/v` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `De` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `ge` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getParser3` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318163` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `canSkip5` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334188` |
| 0.0% | 1.6ms | 0.3% | 14.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4216` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317913` |
| 0.0% | 1.6ms | 2.4% | 99.8ms | `next` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:8` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `splitTextIntoWords` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:559` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2852` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_analyzeHandler` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.1% | 5.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318766` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326167` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4106` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332176` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1283` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8175` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318001` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `specialTypesParslet` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315038` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320907` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2593` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4173` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320804` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getDefaultTagStructureForMode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314049` |
| 0.0% | 1.5ms | 0.0% | 3.1ms | `readFileSync` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322913` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318195` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329071` |
| 0.0% | 1.5ms | 0.3% | 13.3ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320279` |
| 0.0% | 1.5ms | 1.3% | 54.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318452` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92487` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329227` |
| 0.0% | 1.5ms | 3.6% | 145.5ms | `getPreferredTagNameSimple` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319470` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `/^\s*\n\s*/v` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `onNodeWithComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `Parser` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314896` |
| 0.0% | 1.5ms | 0.1% | 4.6ms | `preserveJoiner` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318428` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332100` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getJoiner` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318263` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1945` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `/^@[^\s/]+(?=\s\|$)/` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1675` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:5` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `optionalParslet` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315038` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `normalizeWord` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326869` |
| 0.0% | 1.5ms | 0.7% | 29.0ms | `splitSpace` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318067` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getTokenizers` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318757` |
| 0.0% | 1.4ms | 0.5% | 23.0ms | `parse` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `commentParserToESTree` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317392` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getFencer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getTokensBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3518` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333334` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320809` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327089` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317995` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:232339` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317416` |
| 0.0% | 1.4ms | 0.1% | 4.5ms | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317870` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_toPrimitive` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_normalizeSeverity` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:194` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isGetter2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319999` |
| 0.0% | 1.4ms | 2.4% | 100.3ms | `cleanUpLastTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317374` |
| 0.0% | 1.4ms | 0.2% | 8.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333358` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `accept` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.4ms | 13.5% | 546.2ms | `parseModule` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `parseBlock` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.4ms | 0.0% | 2.9ms | `getParser` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318098` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getDefaultTagStructureForMode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313579` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `log` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `push` | `[native code]` |
| 0.0% | 1.4ms | 0.1% | 4.1ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1282` |
| 0.0% | 1.4ms | 1.3% | 53.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329225` |
| 0.0% | 1.4ms | 0.1% | 7.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334441` |
| 0.0% | 1.4ms | 0.0% | 3.0ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:674` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `createTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332374` |
| 0.0% | 1.4ms | 0.0% | 2.9ms | `typeTokenizer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318203` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7090` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `fix10` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328180` |
| 0.0% | 1.4ms | 2.7% | 109.9ms | `checkJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321342` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:311053` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `ensureMap` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319629` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `cleanUpLastTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317365` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2390` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getParser` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318099` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328288` |
| 0.0% | 1.4ms | 0.4% | 16.9ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318127` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `/^\/(.*)\/([gimyvus]*)$/sv` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getText` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `/^[^ [\],():#!=><~+.]/` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173042` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getLocFromIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3658` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getJsdocTagsDeep` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319379` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:242` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333903` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318045` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183074` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `fix10` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332346` |
| 0.0% | 1.3ms | 0.2% | 8.7ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5043` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:10138` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `read` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316314` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320776` |
| 0.0% | 1.3ms | 15.0% | 607.6ms | `bound ` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `/=(?!>)/` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getParamName` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319257` |
| 0.0% | 1.3ms | 0.1% | 4.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318302` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `addPolyfillToken` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301139` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `fix10` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330353` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/useProgramFromProjectService.js:30` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318190` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318309` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4246` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `cleanUpLastTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317370` |
| 0.0% | 1.3ms | 0.0% | 2.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334119` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318154` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `commentParserToESTree` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317359` |
| 0.0% | 1.3ms | 8.4% | 340.6ms | `parseComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318818` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317882` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319574` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1450` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `stringify` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:5945` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320924` |
| 0.0% | 1.2ms | 8.3% | 337.9ms | `checkJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321346` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:160175` |
| 0.0% | 1.2ms | 0.2% | 10.5ms | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317863` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320637` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 1.7% | 70.9ms | `parseSpec` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318168` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301183` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.1% | 6.2ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4251` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2146` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320845` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:189907` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:335664` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get hasIndices` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getValidRuntimeIdentifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.2ms | 0.0% | 2.8ms | `getCommentsBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3400` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:231297` |
| 0.0% | 1.2ms | 30.9% | 1.24s | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321139` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `hasThrowValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319875` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `commentParserToESTree` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317362` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320822` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `createTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332356` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:724` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `internal:streams/destroy` | `internal:streams/destroy:16` |
| 0.0% | 1.2ms | 0.0% | 2.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2480` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:849` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318025` |
| 0.0% | 1.2ms | 2.9% | 117.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318453` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:335427` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:335309` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4521` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1982` |
| 0.0% | 1.2ms | 2.3% | 95.0ms | `parseInlineTags` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318704` |
| 0.0% | 1.2ms | 0.2% | 8.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1261` |
| 0.0% | 1.1ms | 0.0% | 1.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170986` |
| 0.0% | 1.0ms | 0.0% | 1.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7676` |
| 0.0% | 916us | 0.0% | 916us | `_extractRuleTagBitset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5366` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 86.5% | 3.49s | 0.0% | 0us | `(anonymous)` | `[native code]` |
| 86.4% | 3.48s | 0.0% | 0us | `processTicksAndRejections` | `[native code]` |
| 80.0% | 3.22s | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:274` |
| 78.5% | 3.16s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8203` |
| 59.2% | 2.39s | 1.5% | 60.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7720` |
| 39.9% | 1.61s | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:33` |
| 38.0% | 1.53s | 0.0% | 1.7ms | `iterate` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321061` |
| 37.5% | 1.51s | 5.5% | 223.6ms | `anonymous` | `[native code]` |
| 37.0% | 1.49s | 0.0% | 0us | `bound require` | `[native code]` |
| 36.9% | 1.48s | 0.0% | 0us | `require` | `[native code]` |
| 36.7% | 1.48s | 0.2% | 8.9ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5080` |
| 32.8% | 1.32s | 0.0% | 0us | `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321230` |
| 32.8% | 1.32s | 0.0% | 0us | `onNodeWithComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321177` |
| 30.9% | 1.24s | 0.0% | 1.2ms | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321139` |
| 20.2% | 817.1ms | 0.5% | 23.1ms | `map` | `[native code]` |
| 19.9% | 803.5ms | 0.0% | 1.6ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318016` |
| 19.1% | 774.5ms | 0.1% | 6.3ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317893` |
| 18.6% | 754.4ms | 2.5% | 102.6ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1673` |
| 16.2% | 656.1ms | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5023` |
| 15.5% | 627.0ms | 0.0% | 0us | `checkNonJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326196` |
| 15.2% | 613.4ms | 0.1% | 5.2ms | `bound checkJsdoc` | `[native code]` |
| 15.0% | 607.8ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326238` |
| 15.0% | 607.6ms | 0.0% | 1.3ms | `bound ` | `[native code]` |
| 14.9% | 603.7ms | 0.0% | 0us | `getNonJsdocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317951` |
| 14.1% | 569.5ms | 0.0% | 0us | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1947` |
| 13.8% | 557.7ms | 0.3% | 14.5ms | `_getAllTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1932` |
| 13.5% | 546.2ms | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 13.5% | 546.2ms | 0.0% | 1.4ms | `parseModule` | `[native code]` |
| 13.0% | 527.8ms | 0.0% | 0us | `_loadBundle` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-loader.js:34` |
| 13.0% | 527.8ms | 0.0% | 0us | `(anonymous)` | `/private/tmp/prof_jsdoc.js:7` |
| 13.0% | 527.8ms | 0.0% | 0us | `bundleRulesFor` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-loader.js:59` |
| 12.9% | 522.1ms | 1.7% | 71.3ms | `filter` | `[native code]` |
| 11.7% | 474.5ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7822` |
| 11.6% | 472.0ms | 0.0% | 0us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6952` |
| 11.6% | 472.0ms | 0.0% | 0us | `invokeHandlersWithNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6890` |
| 11.3% | 456.3ms | 0.1% | 4.3ms | `parse3` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318645` |
| 11.0% | 445.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329660` |
| 11.0% | 444.0ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329661` |
| 9.5% | 386.5ms | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5035` |
| 8.4% | 340.6ms | 0.0% | 1.3ms | `parseComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318818` |
| 8.3% | 337.9ms | 0.0% | 1.2ms | `checkJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321346` |
| 7.7% | 310.8ms | 0.0% | 1.7ms | `parseComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318829` |
| 7.5% | 305.5ms | 0.5% | 23.6ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318044` |
| 6.3% | 256.2ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` |
| 6.1% | 247.2ms | 6.1% | 247.2ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1300` |
| 6.0% | 245.2ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7919` |
| 5.7% | 233.9ms | 0.0% | 0us | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317920` |
| 5.6% | 229.0ms | 5.6% | 229.0ms | `parse` | `[native code]` |
| 5.6% | 226.0ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` |
| 5.3% | 214.1ms | 0.0% | 0us | `parseInlineTags` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318701` |
| 5.0% | 204.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328984` |
| 5.0% | 204.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328983` |
| 4.6% | 189.4ms | 0.0% | 0us | `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321227` |
| 4.4% | 179.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318449` |
| 4.4% | 178.5ms | 0.3% | 13.8ms | `parseDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318682` |
| 4.1% | 167.5ms | 4.1% | 167.5ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1288` |
| 4.0% | 163.5ms | 0.0% | 0us | `matchAll` | `[native code]` |
| 3.8% | 157.1ms | 0.1% | 7.6ms | `checkJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321335` |
| 3.8% | 156.9ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321263` |
| 3.8% | 153.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328144` |
| 3.7% | 150.0ms | 0.0% | 3.2ms | `getPreferredTagName` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319514` |
| 3.6% | 146.8ms | 0.0% | 0us | `getIndentAndJSDoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321083` |
| 3.6% | 145.5ms | 0.0% | 1.5ms | `getPreferredTagNameSimple` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319470` |
| 3.4% | 139.5ms | 3.3% | 134.7ms | `get flags` | `[native code]` |
| 3.2% | 131.8ms | 0.0% | 1.6ms | `forEach` | `[native code]` |
| 3.2% | 130.3ms | 0.0% | 0us | `commentParserToESTree` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317415` |
| 3.2% | 129.4ms | 0.2% | 10.6ms | `parseDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318681` |
| 3.0% | 124.4ms | 0.1% | 7.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328166` |
| 3.0% | 123.4ms | 0.6% | 27.7ms | `test` | `[native code]` |
| 3.0% | 122.5ms | 3.0% | 122.5ms | `entries` | `[native code]` |
| 3.0% | 121.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328986` |
| 2.9% | 118.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313105` |
| 2.9% | 117.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318453` |
| 2.8% | 115.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328981` |
| 2.7% | 112.0ms | 0.0% | 0us | `validateDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327223` |
| 2.7% | 112.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327233` |
| 2.7% | 109.9ms | 0.0% | 1.4ms | `checkJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321342` |
| 2.6% | 106.0ms | 1.6% | 67.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328987` |
| 2.5% | 104.3ms | 0.1% | 4.4ms | `performIteration` | `[native code]` |
| 2.4% | 100.3ms | 0.0% | 1.4ms | `cleanUpLastTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317374` |
| 2.4% | 99.8ms | 0.0% | 1.6ms | `next` | `[native code]` |
| 2.4% | 99.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173277` |
| 2.4% | 98.2ms | 0.2% | 11.6ms | `regExpExec` | `[native code]` |
| 2.4% | 97.3ms | 2.1% | 87.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328982` |
| 2.3% | 96.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173249` |
| 2.3% | 96.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172573` |
| 2.3% | 96.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172431` |
| 2.3% | 95.6ms | 2.3% | 95.6ms | ``/^\n?([A-Z`\d_][\s\S]*[.?!`\p{RGI_Emoji}]\s*)?$/v`` | `[native code]` |
| 2.3% | 95.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329658` |
| 2.3% | 95.5ms | 2.3% | 95.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 2.3% | 95.0ms | 0.0% | 1.2ms | `parseInlineTags` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318704` |
| 2.2% | 91.7ms | 0.2% | 11.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 2.2% | 90.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/index.js:18` |
| 2.2% | 90.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171769` |
| 2.2% | 90.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171394` |
| 2.2% | 90.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172349` |
| 2.2% | 90.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171548` |
| 2.2% | 89.3ms | 1.3% | 56.3ms | `regExpSplitFast` | `[native code]` |
| 2.1% | 88.3ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321241` |
| 2.1% | 87.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/clear-caches.js:6` |
| 2.0% | 83.8ms | 2.0% | 83.8ms | `seedTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318080` |
| 2.0% | 83.8ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318126` |
| 2.0% | 81.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317581` |
| 1.9% | 80.4ms | 1.9% | 80.4ms | `getOwnPropertyDescriptor` | `[native code]` |
| 1.9% | 80.1ms | 1.7% | 70.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329659` |
| 1.9% | 80.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320765` |
| 1.9% | 78.5ms | 1.9% | 78.5ms | `/(?<!\])\{@(?<tag>[^\}\s]+)\s?(?<namepathOrURL>[^\}\s\\|]*)\s*(?<separator>[\s\\|])?\s*(?<text>[^\}]*)\}/dgv` | `[native code]` |
| 1.8% | 75.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313097` |
| 1.8% | 75.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:168346` |
| 1.8% | 75.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:168170` |
| 1.8% | 74.0ms | 0.0% | 1.7ms | `parseType` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314934` |
| 1.8% | 74.0ms | 0.0% | 0us | `parse2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317016` |
| 1.8% | 74.0ms | 0.0% | 0us | `parse` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314927` |
| 1.8% | 72.7ms | 0.0% | 0us | `forEachPreferredTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319536` |
| 1.8% | 72.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320946` |
| 1.7% | 70.9ms | 0.0% | 1.2ms | `parseSpec` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318168` |
| 1.7% | 69.7ms | 1.2% | 50.8ms | `[Symbol.match]` | `[native code]` |
| 1.7% | 69.7ms | 0.0% | 0us | `match` | `[native code]` |
| 1.7% | 69.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:30` |
| 1.7% | 69.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:42` |
| 1.7% | 69.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:16` |
| 1.7% | 69.1ms | 0.0% | 0us | `onProgramExit` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321193` |
| 1.6% | 67.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:4` |
| 1.4% | 59.8ms | 0.9% | 36.3ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1285` |
| 1.4% | 58.3ms | 0.4% | 18.0ms | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321103` |
| 1.3% | 56.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164604` |
| 1.3% | 56.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313083` |
| 1.3% | 55.5ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8202` |
| 1.3% | 54.8ms | 0.0% | 0us | `Comparator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:163872` |
| 1.3% | 54.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164269` |
| 1.3% | 54.8ms | 1.3% | 54.8ms | `SemVer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:162890` |
| 1.3% | 54.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164514` |
| 1.3% | 54.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164442` |
| 1.3% | 54.8ms | 0.0% | 0us | `parse` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:163893` |
| 1.3% | 54.4ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318452` |
| 1.3% | 53.9ms | 0.6% | 25.4ms | `parseIntermediateType` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314939` |
| 1.3% | 53.6ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329225` |
| 1.2% | 51.4ms | 0.0% | 0us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321332` |
| 1.2% | 51.4ms | 0.0% | 0us | `get lines` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3580` |
| 1.2% | 51.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329132` |
| 1.2% | 49.1ms | 0.0% | 0us | `iterate` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321046` |
| 1.1% | 48.3ms | 0.5% | 21.9ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1975` |
| 1.1% | 48.1ms | 1.1% | 48.1ms | `stringSplitFast` | `[native code]` |
| 1.1% | 47.9ms | 0.0% | 2.8ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317919` |
| 1.0% | 43.9ms | 0.0% | 0us | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321109` |
| 1.0% | 43.3ms | 1.0% | 43.3ms | `getValidRuntimeIdentifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329079` |
| 1.0% | 42.9ms | 0.0% | 0us | `Pe` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 1.0% | 42.8ms | 1.0% | 42.8ms | `Set` | `[native code]` |
| 1.0% | 42.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290028` |
| 1.0% | 42.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:337704` |
| 1.0% | 40.9ms | 0.0% | 0us | `parseBlock` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318109` |
| 1.0% | 40.9ms | 0.0% | 0us | `toggleFence` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318099` |
| 1.0% | 40.9ms | 0.0% | 3.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318116` |
| 1.0% | 40.7ms | 0.0% | 2.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318448` |
| 0.9% | 40.1ms | 0.0% | 3.3ms | `ke` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.9% | 40.1ms | 0.0% | 0us | `we` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.9% | 38.2ms | 0.9% | 38.2ms | `/^\s*globals/v` | `[native code]` |
| 0.9% | 37.8ms | 0.0% | 0us | `splitLines` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318071` |
| 0.9% | 36.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/unsupported-api.js:14` |
| 0.9% | 36.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:293430` |
| 0.8% | 33.4ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4559` |
| 0.8% | 33.3ms | 0.8% | 33.3ms | `getText` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1346` |
| 0.8% | 33.1ms | 0.0% | 0us | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321130` |
| 0.8% | 33.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321135` |
| 0.8% | 33.1ms | 0.0% | 0us | `every` | `[native code]` |
| 0.8% | 33.0ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4190` |
| 0.8% | 33.0ms | 0.8% | 33.0ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1260` |
| 0.8% | 32.9ms | 0.8% | 32.9ms | `/\r\n\|\r\|\n\|\u2028\|\u2029/` | `[native code]` |
| 0.7% | 31.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313124` |
| 0.7% | 29.9ms | 0.0% | 2.6ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5058` |
| 0.7% | 29.0ms | 0.0% | 1.5ms | `splitSpace` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318067` |
| 0.7% | 28.5ms | 0.0% | 1.7ms | `_NoParsletFoundError` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314668` |
| 0.6% | 28.0ms | 0.2% | 8.8ms | `some` | `[native code]` |
| 0.6% | 27.9ms | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4161` |
| 0.6% | 27.9ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321033` |
| 0.6% | 27.8ms | 0.1% | 6.2ms | `compactJoiner` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318416` |
| 0.6% | 27.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318180` |
| 0.6% | 26.3ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` |
| 0.6% | 25.6ms | 0.0% | 0us | `bound checkNonJsdoc` | `[native code]` |
| 0.6% | 25.3ms | 0.6% | 25.3ms | `parseSpec` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318169` |
| 0.6% | 24.6ms | 0.0% | 0us | `_e` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.6% | 24.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318455` |
| 0.5% | 24.1ms | 0.0% | 0us | `find` | `[native code]` |
| 0.5% | 23.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:44` |
| 0.5% | 23.2ms | 0.0% | 2.9ms | `getNonJsdocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317950` |
| 0.5% | 23.1ms | 0.0% | 1.7ms | `parse2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317001` |
| 0.5% | 23.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317600` |
| 0.5% | 23.0ms | 0.0% | 1.4ms | `parse` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.5% | 23.0ms | 0.0% | 0us | `g` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.5% | 22.8ms | 0.0% | 0us | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317888` |
| 0.5% | 22.8ms | 0.1% | 7.6ms | `getDecorator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317745` |
| 0.5% | 22.8ms | 0.3% | 13.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319474` |
| 0.5% | 22.6ms | 0.0% | 2.6ms | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317855` |
| 0.5% | 22.5ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318128` |
| 0.5% | 21.8ms | 0.5% | 21.8ms | `Error` | `[native code]` |
| 0.5% | 21.6ms | 0.0% | 3.4ms | `flatIntoArrayWithCallback` | `[native code]` |
| 0.5% | 21.5ms | 0.0% | 0us | `Ae` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.5% | 21.2ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4682` |
| 0.5% | 21.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317438` |
| 0.5% | 21.0ms | 0.5% | 21.0ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318032` |
| 0.5% | 20.5ms | 0.3% | 15.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328146` |
| 0.5% | 20.3ms | 0.3% | 13.7ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1656` |
| 0.5% | 20.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322864` |
| 0.5% | 20.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327258` |
| 0.4% | 19.5ms | 0.4% | 19.5ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320879` |
| 0.4% | 19.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320330` |
| 0.4% | 19.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332431` |
| 0.4% | 19.2ms | 0.0% | 0us | `onProgramExit` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321192` |
| 0.4% | 19.0ms | 0.4% | 19.0ms | `/^\*(?!\*)/v` | `[native code]` |
| 0.4% | 18.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173276` |
| 0.4% | 18.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:198766` |
| 0.4% | 18.6ms | 0.0% | 0us | `getAllComments` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3465` |
| 0.4% | 18.6ms | 0.0% | 0us | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1948` |
| 0.4% | 18.3ms | 0.0% | 3.1ms | `tryParslets` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314956` |
| 0.4% | 18.3ms | 0.0% | 0us | `parseIntermediateType` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314937` |
| 0.4% | 18.2ms | 0.0% | 0us | `Ce` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.4% | 17.8ms | 0.4% | 17.8ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1292` |
| 0.4% | 17.4ms | 0.2% | 9.7ms | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317830` |
| 0.4% | 16.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/index.js:3` |
| 0.4% | 16.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:20` |
| 0.4% | 16.9ms | 0.0% | 1.4ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318127` |
| 0.4% | 16.8ms | 0.0% | 1.7ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318133` |
| 0.4% | 16.7ms | 0.4% | 16.7ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318017` |
| 0.4% | 16.7ms | 0.4% | 16.7ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.4% | 16.1ms | 0.4% | 16.1ms | `esSpecIsRegExp` | `[native code]` |
| 0.3% | 15.9ms | 0.3% | 15.9ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:676` |
| 0.3% | 15.7ms | 0.3% | 15.7ms | `join` | `[native code]` |
| 0.3% | 15.5ms | 0.3% | 15.5ms | `[Symbol.matchAll]` | `[native code]` |
| 0.3% | 15.5ms | 0.0% | 1.7ms | `splitCR` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318063` |
| 0.3% | 14.9ms | 0.0% | 1.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4216` |
| 0.3% | 14.6ms | 0.3% | 14.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7386` |
| 0.3% | 14.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318404` |
| 0.3% | 14.3ms | 0.0% | 1.6ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318139` |
| 0.3% | 14.1ms | 0.0% | 0us | `(anonymous)` | `/private/tmp/prof_jsdoc.js:5` |
| 0.3% | 13.9ms | 0.3% | 13.9ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1202` |
| 0.3% | 13.6ms | 0.3% | 13.6ms | `RegExp` | `[native code]` |
| 0.3% | 13.3ms | 0.0% | 1.5ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320279` |
| 0.3% | 13.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/apply-disable-directives.js:22` |
| 0.3% | 13.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:19` |
| 0.3% | 13.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:43` |
| 0.3% | 13.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/index.js:26` |
| 0.3% | 13.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/Scope.js:38` |
| 0.3% | 13.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/index.js:18` |
| 0.3% | 12.7ms | 0.3% | 12.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.3% | 12.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332122` |
| 0.3% | 12.5ms | 0.3% | 12.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301189` |
| 0.3% | 12.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318470` |
| 0.3% | 12.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318799` |
| 0.2% | 12.0ms | 0.2% | 10.6ms | `parslet` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315038` |
| 0.2% | 11.9ms | 0.0% | 0us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316297` |
| 0.2% | 11.8ms | 0.0% | 2.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320942` |
| 0.2% | 11.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320789` |
| 0.2% | 11.8ms | 0.2% | 11.8ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1264` |
| 0.2% | 11.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327244` |
| 0.2% | 11.8ms | 0.2% | 11.8ms | `_getAllTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1933` |
| 0.2% | 11.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320331` |
| 0.2% | 11.6ms | 0.0% | 0us | `fixer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332422` |
| 0.2% | 11.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330137` |
| 0.2% | 11.3ms | 0.2% | 11.3ms | `splitSpace` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318068` |
| 0.2% | 11.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318802` |
| 0.2% | 11.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/index.js:4` |
| 0.2% | 11.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/analyze.js:5` |
| 0.2% | 11.1ms | 0.2% | 11.1ms | `trimEnd` | `[native code]` |
| 0.2% | 11.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` |
| 0.2% | 11.0ms | 0.2% | 9.4ms | `getCommentsBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3401` |
| 0.2% | 10.8ms | 0.2% | 10.8ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1977` |
| 0.2% | 10.7ms | 0.0% | 0us | `maskExcludedContent` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322832` |
| 0.2% | 10.7ms | 0.2% | 10.7ms | `replace` | `[native code]` |
| 0.2% | 10.6ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:490` |
| 0.2% | 10.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92697` |
| 0.2% | 10.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301099` |
| 0.2% | 10.5ms | 0.0% | 1.2ms | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317863` |
| 0.2% | 10.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:12` |
| 0.2% | 10.5ms | 0.1% | 7.5ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320283` |
| 0.2% | 10.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:19` |
| 0.2% | 10.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320756` |
| 0.2% | 10.4ms | 0.2% | 8.9ms | `parseBlock` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318104` |
| 0.2% | 10.3ms | 0.2% | 10.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7855` |
| 0.2% | 10.1ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:911` |
| 0.2% | 10.1ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1027` |
| 0.2% | 9.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322863` |
| 0.2% | 9.8ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333233` |
| 0.2% | 9.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289691` |
| 0.2% | 9.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:277093` |
| 0.2% | 9.5ms | 0.0% | 0us | `maskExcludedContent` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322831` |
| 0.2% | 9.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332850` |
| 0.2% | 9.4ms | 0.2% | 9.4ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4522` |
| 0.2% | 9.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328991` |
| 0.2% | 9.3ms | 0.0% | 3.4ms | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316299` |
| 0.2% | 9.3ms | 0.2% | 9.3ms | `trim` | `[native code]` |
| 0.2% | 9.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318416` |
| 0.2% | 9.2ms | 0.2% | 9.2ms | `endsWith` | `[native code]` |
| 0.2% | 9.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/default-config.js:37` |
| 0.2% | 9.2ms | 0.2% | 9.2ms | `/\r+$/` | `[native code]` |
| 0.2% | 9.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/ast-converter.js:4` |
| 0.2% | 9.0ms | 0.2% | 9.0ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1677` |
| 0.2% | 9.0ms | 0.2% | 9.0ms | `includes` | `[native code]` |
| 0.2% | 9.0ms | 0.2% | 9.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317512` |
| 0.2% | 9.0ms | 0.2% | 9.0ms | `concat` | `[native code]` |
| 0.2% | 8.9ms | 0.0% | 1.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1261` |
| 0.2% | 8.9ms | 0.0% | 0us | `parseSpec` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318166` |
| 0.2% | 8.9ms | 0.2% | 8.9ms | `seedSpec` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318077` |
| 0.2% | 8.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323796` |
| 0.2% | 8.7ms | 0.0% | 1.3ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5043` |
| 0.2% | 8.6ms | 0.0% | 0us | `getAncestors` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3698` |
| 0.2% | 8.6ms | 0.2% | 8.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7382` |
| 0.2% | 8.1ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333358` |
| 0.2% | 8.1ms | 0.2% | 8.1ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:590` |
| 0.1% | 8.0ms | 0.1% | 8.0ms | `/(?:\[(?<text>[^\]]+)\])\{@(?<tag>[^\}\s]+)\s?(?<namepathOrURL>[^\}\s\\|]*)\}/dgv` | `[native code]` |
| 0.1% | 8.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:277069` |
| 0.1% | 7.8ms | 0.1% | 7.8ms | `stringIncludesInternal` | `[native code]` |
| 0.1% | 7.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320332` |
| 0.1% | 7.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320327` |
| 0.1% | 7.7ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334441` |
| 0.1% | 7.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:38` |
| 0.1% | 7.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/convert.js:41` |
| 0.1% | 7.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328992` |
| 0.1% | 7.6ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:455` |
| 0.1% | 7.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:497` |
| 0.1% | 7.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/index.js:3` |
| 0.1% | 7.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/index.js:12` |
| 0.1% | 7.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301141` |
| 0.1% | 7.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:15` |
| 0.1% | 7.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:11` |
| 0.1% | 7.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320241` |
| 0.1% | 7.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320928` |
| 0.1% | 7.2ms | 0.0% | 0us | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317860` |
| 0.1% | 7.0ms | 0.1% | 7.0ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318129` |
| 0.1% | 6.9ms | 0.1% | 4.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318458` |
| 0.1% | 6.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334236` |
| 0.1% | 6.9ms | 0.0% | 0us | `checkTagName` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334198` |
| 0.1% | 6.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:7` |
| 0.1% | 6.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329215` |
| 0.1% | 6.6ms | 0.1% | 6.6ms | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318440` |
| 0.1% | 6.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334095` |
| 0.1% | 6.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:276522` |
| 0.1% | 6.5ms | 0.1% | 6.5ms | `/^\s+/` | `[native code]` |
| 0.1% | 6.4ms | 0.1% | 6.4ms | `trimStart` | `[native code]` |
| 0.1% | 6.3ms | 0.0% | 0us | `checkTagName2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334406` |
| 0.1% | 6.2ms | 0.1% | 6.2ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318014` |
| 0.1% | 6.2ms | 0.0% | 1.2ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4251` |
| 0.1% | 6.1ms | 0.1% | 6.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321192` |
| 0.1% | 6.0ms | 0.1% | 4.8ms | `reduce` | `[native code]` |
| 0.1% | 6.0ms | 0.1% | 6.0ms | `getBasicUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320240` |
| 0.1% | 6.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-modifiers.js:38` |
| 0.1% | 6.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:20` |
| 0.1% | 5.9ms | 0.0% | 0us | `findIndex` | `[native code]` |
| 0.1% | 5.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92623` |
| 0.1% | 5.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92521` |
| 0.1% | 5.8ms | 0.1% | 5.8ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 0.1% | 5.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317603` |
| 0.1% | 5.7ms | 0.1% | 5.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4211` |
| 0.1% | 5.6ms | 0.1% | 5.6ms | `getIndentAndJSDoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321082` |
| 0.1% | 5.6ms | 0.1% | 5.6ms | `unshift` | `[native code]` |
| 0.1% | 5.6ms | 0.1% | 5.6ms | `Ee` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.1% | 5.6ms | 0.0% | 0us | `parseComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318819` |
| 0.1% | 5.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330449` |
| 0.1% | 5.4ms | 0.0% | 0us | `validateDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330340` |
| 0.1% | 5.4ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330372` |
| 0.1% | 5.4ms | 0.1% | 4.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317500` |
| 0.1% | 5.1ms | 0.1% | 5.1ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318029` |
| 0.1% | 5.0ms | 0.0% | 0us | `canSkip4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334089` |
| 0.1% | 5.0ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318766` |
| 0.1% | 5.0ms | 0.0% | 0us | `getESLintCoreRule` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:174800` |
| 0.1% | 5.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329194` |
| 0.1% | 4.9ms | 0.0% | 0us | `maskCodeBlocks` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322839` |
| 0.1% | 4.9ms | 0.1% | 4.9ms | `replaceAll` | `[native code]` |
| 0.1% | 4.9ms | 0.1% | 4.9ms | `maskCodeBlocks` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.1% | 4.9ms | 0.1% | 4.9ms | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321101` |
| 0.1% | 4.9ms | 0.1% | 4.9ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1228` |
| 0.1% | 4.8ms | 0.0% | 0us | `commentParserToESTree` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317398` |
| 0.1% | 4.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320795` |
| 0.1% | 4.7ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318302` |
| 0.1% | 4.7ms | 0.1% | 4.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7682` |
| 0.1% | 4.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333101` |
| 0.1% | 4.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333682` |
| 0.1% | 4.7ms | 0.0% | 0us | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321100` |
| 0.1% | 4.7ms | 0.0% | 0us | `get globalScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3938` |
| 0.1% | 4.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328953` |
| 0.1% | 4.7ms | 0.1% | 4.7ms | `join` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318467` |
| 0.1% | 4.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332756` |
| 0.1% | 4.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334098` |
| 0.1% | 4.6ms | 0.0% | 0us | `isNameOrNamepathDefiningTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319671` |
| 0.1% | 4.6ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7679` |
| 0.1% | 4.6ms | 0.1% | 4.6ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4094` |
| 0.1% | 4.6ms | 0.0% | 1.5ms | `preserveJoiner` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318428` |
| 0.1% | 4.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:312909` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `copyDataProperties` | `[native code]` |
| 0.1% | 4.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317468` |
| 0.1% | 4.5ms | 0.0% | 1.4ms | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317870` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318796` |
| 0.1% | 4.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328149` |
| 0.1% | 4.5ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318146` |
| 0.1% | 4.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330131` |
| 0.1% | 4.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328995` |
| 0.1% | 4.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326641` |
| 0.1% | 4.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330546` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `cloneObject` | `[native code]` |
| 0.1% | 4.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1253` |
| 0.1% | 4.4ms | 0.0% | 2.7ms | `read` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316313` |
| 0.1% | 4.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/getModifiers.js:39` |
| 0.1% | 4.3ms | 0.0% | 0us | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318443` |
| 0.1% | 4.3ms | 0.0% | 0us | `y` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.1% | 4.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313031` |
| 0.1% | 4.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138699` |
| 0.1% | 4.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330697` |
| 0.1% | 4.3ms | 0.0% | 0us | `onNodeAllNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321188` |
| 0.1% | 4.3ms | 0.0% | 0us | `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321235` |
| 0.1% | 4.3ms | 0.1% | 4.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320918` |
| 0.1% | 4.3ms | 0.1% | 4.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7689` |
| 0.1% | 4.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:53` |
| 0.1% | 4.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/resolveProjectList.js:10` |
| 0.1% | 4.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336920` |
| 0.1% | 4.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320859` |
| 0.1% | 4.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336919` |
| 0.1% | 4.2ms | 0.0% | 0us | `getTagStructureForMode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319664` |
| 0.1% | 4.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290132` |
| 0.1% | 4.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:45765` |
| 0.1% | 4.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12521` |
| 0.1% | 4.1ms | 0.1% | 4.1ms | `/^\/\*\*\s/v` | `[native code]` |
| 0.1% | 4.1ms | 0.0% | 1.4ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1282` |
| 0.1% | 4.1ms | 0.1% | 4.1ms | `getTokenizers` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318761` |
| 0.0% | 3.8ms | 0.0% | 0us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` |
| 0.0% | 3.8ms | 0.0% | 3.8ms | `encodeInto` | `[native code]` |
| 0.0% | 3.8ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:220` |
| 0.0% | 3.6ms | 0.0% | 1.8ms | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318442` |
| 0.0% | 3.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:1664` |
| 0.0% | 3.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290081` |
| 0.0% | 3.4ms | 0.0% | 0us | `camelCase` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295621` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `[Symbol.iterator]` | `[native code]` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318209` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `parse2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317012` |
| 0.0% | 3.4ms | 0.0% | 0us | `preserveJoiner` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318429` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 3.3ms | 0.0% | 0us | `isConstructor` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319996` |
| 0.0% | 3.3ms | 0.0% | 0us | `exemptSpeciaMethods` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320029` |
| 0.0% | 3.3ms | 0.0% | 0us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:609` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `decode` | `[native code]` |
| 0.0% | 3.3ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8195` |
| 0.0% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333756` |
| 0.0% | 3.3ms | 0.0% | 0us | `checkNonJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326210` |
| 0.0% | 3.3ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326147` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317506` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329199` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:325987` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `tokenToString` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314662` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318454` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `ensureMap` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319626` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `checkJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321339` |
| 0.0% | 3.2ms | 0.0% | 0us | `fix10` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332410` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332172` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7092` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:312924` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322295` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/clear-caches.js:5` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1187` |
| 0.0% | 3.1ms | 0.0% | 1.5ms | `readFileSync` | `[native code]` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3682` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318042` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `descriptionTokenizer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318401` |
| 0.0% | 3.1ms | 0.0% | 0us | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318438` |
| 0.0% | 3.1ms | 0.0% | 1.7ms | `getAncestors` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3687` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320366` |
| 0.0% | 3.1ms | 0.0% | 0us | `descriptionIsRedundant` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326954` |
| 0.0% | 3.1ms | 0.0% | 0us | `areDocsInformative` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326859` |
| 0.0% | 3.1ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2851` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326976` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:717` |
| 0.0% | 3.1ms | 0.0% | 1.7ms | `be` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318763` |
| 0.0% | 3.1ms | 0.0% | 0us | `addSchema` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:137` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:29` |
| 0.0% | 3.1ms | 0.0% | 0us | `addMetaSchema` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:152` |
| 0.0% | 3.1ms | 0.0% | 0us | `_addSchema` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:309` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320741` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319364` |
| 0.0% | 3.1ms | 0.0% | 0us | `getFunctionParameterNames` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319363` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3673` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92620` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1262` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `read` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316330` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:593` |
| 0.0% | 3.0ms | 0.0% | 1.4ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:674` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:110317` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328182` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333904` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2144` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301177` |
| 0.0% | 2.9ms | 0.0% | 0us | `getValidRuntimeIdentifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329078` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `freeze` | `[native code]` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333255` |
| 0.0% | 2.9ms | 0.0% | 1.7ms | `hasRejectValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333151` |
| 0.0% | 2.9ms | 0.0% | 0us | `shouldReport` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333253` |
| 0.0% | 2.9ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320920` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:40` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:8` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/ClassVisitor.js:6` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1290` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/index.js:3` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:3` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/tinyglobby/dist/index.cjs:27` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91298` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/fdir/dist/index.cjs:462` |
| 0.0% | 2.9ms | 0.0% | 0us | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318436` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/index.js:3` |
| 0.0% | 2.9ms | 0.0% | 1.4ms | `typeTokenizer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318203` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `getReducedASTNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332132` |
| 0.0% | 2.9ms | 0.0% | 1.4ms | `getParser` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318098` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313078` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1653` |
| 0.0% | 2.9ms | 0.0% | 0us | `read` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316319` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334229` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7368` |
| 0.0% | 2.9ms | 0.0% | 0us | `filterTags` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319495` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:21` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` |
| 0.0% | 2.8ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:279` |
| 0.0% | 2.8ms | 0.0% | 0us | `_fromRunnerReport` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:205` |
| 0.0% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329663` |
| 0.0% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329667` |
| 0.0% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329664` |
| 0.0% | 2.8ms | 0.0% | 0us | `Se` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328145` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1302` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318007` |
| 0.0% | 2.8ms | 0.0% | 1.2ms | `getCommentsBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3400` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `callIterator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321102` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1192` |
| 0.0% | 2.7ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:673` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330382` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:10` |
| 0.0% | 2.7ms | 0.0% | 0us | `fix10` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332411` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332414` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:37` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7680` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `defineProperty` | `[native code]` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330386` |
| 0.0% | 2.7ms | 0.0% | 0us | `fix10` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332417` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `_tokType` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 2.7ms | 0.0% | 0us | `getDefaultTagStructureForMode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313576` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `Map` | `[native code]` |
| 0.0% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317601` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318147` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `isNameOrNamepathDefiningTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319675` |
| 0.0% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138509` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318434` |
| 0.0% | 2.6ms | 0.0% | 1.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2480` |
| 0.0% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12515` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `get declaration` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3611` |
| 0.0% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301163` |
| 0.0% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:14` |
| 0.0% | 2.5ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334119` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318140` |
| 0.0% | 2.5ms | 0.0% | 0us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6928` |
| 0.0% | 2.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333589` |
| 0.0% | 2.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333155` |
| 0.0% | 2.4ms | 0.0% | 0us | `hasRejectValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333154` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318151` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4174` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:335666` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `toLocaleUpperCase` | `[native code]` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301150` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295652` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295624` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295644` |
| 0.0% | 1.8ms | 0.0% | 0us | `assign` | `[native code]` |
| 0.0% | 1.8ms | 0.0% | 0us | `loadAssertionError` | `node:assert:28` |
| 0.0% | 1.8ms | 0.0% | 0us | `node:assert` | `node:assert:588` |
| 0.0% | 1.8ms | 0.0% | 0us | `get` | `node:assert:70` |
| 0.0% | 1.8ms | 0.0% | 0us | `node:assert/strict` | `node:assert/strict:3` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:293086` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2153` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2150` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:49` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/file-report.js:13` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:4` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:30` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/getWatchProgramsForProjects.js:45` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:48` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:19` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `getParser2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318121` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320768` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/analyze.js:4` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1230` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1185` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/visitor-keys/dist/visitor-keys.js:194` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/visitor-keys/dist/index.js:6` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `unionWith` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/visitor-keys/node_modules/eslint-visitor-keys/dist/eslint-visitor-keys.cjs` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:580` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:197251` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:197260` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get sticky` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201912` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318132` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:100190` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:198706` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109708` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:100192` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:198714` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:101266` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:101899` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201921` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `onNodeWithComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321176` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:100058` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:101904` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:40084` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `commentParserToESTree` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317393` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321659` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320932` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317570` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:192911` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201893` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:192920` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:192876` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1971` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313017` |
| 0.0% | 1.7ms | 0.0% | 0us | `hasReturnValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318854` |
| 0.0% | 1.7ms | 0.0% | 0us | `shouldReport` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333399` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318855` |
| 0.0% | 1.7ms | 0.0% | 0us | `hasValueOrExecutorHasNonEmptyResolveValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319117` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:325959` |
| 0.0% | 1.7ms | 0.0% | 0us | `hasReturnValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318851` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320865` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319115` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `hasReturnValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318844` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333401` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317997` |
| 0.0% | 1.7ms | 0.0% | 0us | `getParamName` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319228` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2753` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332921` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get ignoreCase` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:48` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/source-code-traverser.js:12` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/esquery.js:12` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318131` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201929` |
| 0.0% | 1.7ms | 0.0% | 0us | `reportings` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326192` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `preserveJoiner` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318423` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4144` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318277` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:183987` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/project-service/dist/createProjectService.js:8` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/project-service/dist/index.js:17` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:42` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:337493` |
| 0.0% | 1.7ms | 0.0% | 0us | `coerce` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:212006` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `parse5` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getContexts` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328706` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321402` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `nameTokenizer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318275` |
| 0.0% | 1.7ms | 0.0% | 0us | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318437` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/token-store/index.js:11` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:11` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint-community/eslint-utils/node_modules/eslint-visitor-keys/dist/eslint-visitor-keys.cjs:315` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint-community/eslint-utils/index.js:5` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:221777` |
| 0.0% | 1.7ms | 0.0% | 0us | `resolveIds` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:235` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getRegexFromString` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320060` |
| 0.0% | 1.7ms | 0.0% | 0us | `serialize` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js:1012` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289510` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323795` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:16` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:221655` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:221585` |
| 0.0% | 1.7ms | 0.0% | 0us | `_getFullPath` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:215` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:221581` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320753` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333582` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get kind` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2733` |
| 0.0% | 1.7ms | 0.0% | 0us | `canSkip3` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333567` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290205` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:901` |
| 0.0% | 1.7ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2137` |
| 0.0% | 1.7ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2348` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:324400` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:218541` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289496` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:218589` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:218473` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322393` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:212998` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327231` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201884` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320415` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190758` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `/\s*(@(\S+))(\s*)/` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201903` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:185313` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201859` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:3` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188335` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188344` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201871` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188300` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332923` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173237` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290285` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `hasSchemaOption` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320025` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:169412` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-modifiers.js:39` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/node-utils.js:55` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:28` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/getModifiers.js:4` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/getModifiers.js:30` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/getModifiers.js:38` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1312` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:18` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301196` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:189166` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:189175` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `set` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201874` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320889` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328331` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172175` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172204` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172212` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172353` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:128023` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:119338` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/index.js:16` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322334` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322336` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getBasicUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320244` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:179625` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `__export` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:24` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:179616` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201823` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:179587` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:38` |
| 0.0% | 1.6ms | 0.0% | 0us | `get kind` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2734` |
| 0.0% | 1.6ms | 0.0% | 0us | `_rawTokenText` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:879` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333346` |
| 0.0% | 1.6ms | 0.0% | 0us | `canSkip2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333327` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:609` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289675` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:263719` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:263751` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301169` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295623` |
| 0.0% | 1.6ms | 0.0% | 0us | `addPolyfillToken` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301137` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `toLocaleLowerCase` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295641` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:1` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:135987` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:136145` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138507` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:136029` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161605` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/lib/picomatch.js:3` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170728` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172341` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170720` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `read` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316323` |
| 0.0% | 1.6ms | 0.0% | 0us | `useColors` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12454` |
| 0.0% | 1.6ms | 0.0% | 0us | `Writable` | `internal:streams/writable:196` |
| 0.0% | 1.6ms | 0.0% | 0us | `WriteStream` | `internal:fs/streams:245` |
| 0.0% | 1.6ms | 0.0% | 0us | `construct` | `internal:streams/destroy:124` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `setup` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `createDebug` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12070` |
| 0.0% | 1.6ms | 0.0% | 0us | `nextTick` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:277071` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `/^\s+/v` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `ge` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `Te` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `De` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.6ms | 0.0% | 0us | `getParser4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318444` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getParser3` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318163` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `canSkip5` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334188` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317913` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:30` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:38` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:8` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:257725` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:257630` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:257626` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289654` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `splitTextIntoWords` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:257699` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:559` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313039` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92619` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2852` |
| 0.0% | 1.6ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7265` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_analyzeHandler` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `_fuseHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4950` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6470` |
| 0.0% | 1.6ms | 0.0% | 0us | `_getOrBuildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6160` |
| 0.0% | 1.6ms | 0.0% | 0us | `findExpectedIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332165` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332173` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:180796` |
| 0.0% | 1.6ms | 0.0% | 0us | `reportings` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326185` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:180831` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201829` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326167` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:180840` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:177189` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201816` |
| 0.0% | 1.6ms | 0.0% | 0us | `findExpectedIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332182` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4106` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332176` |
| 0.0% | 1.5ms | 0.0% | 0us | `fix10` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332396` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1283` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8175` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329060` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329059` |
| 0.0% | 1.5ms | 0.0% | 0us | `getTemplateTags` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329054` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318001` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `specialTypesParslet` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315038` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320907` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2593` |
| 0.0% | 1.5ms | 0.0% | 0us | `preserveJoiner` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318426` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4173` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290350` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320777` |
| 0.0% | 1.5ms | 0.0% | 0us | `hasATag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319600` |
| 0.0% | 1.5ms | 0.0% | 0us | `canSkip4` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334085` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320804` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getDefaultTagStructureForMode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314049` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/private/tmp/prof_jsdoc.js:10` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322913` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:288719` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289747` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:288648` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:288753` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:288644` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318395` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318195` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329071` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96366` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96619` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96674` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96656` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:110315` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96800` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96433` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96638` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96576` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96733` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 0us | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318033` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:241123` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:241055` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:241260` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289570` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318291` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92486` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92489` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92487` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:131289` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:45` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:271689` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323801` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329227` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228443` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228543` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289535` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228702` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:187582` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201868` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:187547` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:22` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/prelude-ls/lib/index.js:5` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint/plugin-kit/dist/cjs/index.cjs:3` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:187590` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:4` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/parse-string.js:113` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/parse-string.js:4` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201925` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `/^\s*\n\s*/v` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 0us | `read` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316311` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `onNodeWithComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289598` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:246598` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `Parser` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314896` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317604` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332100` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/ast-converter.js:7` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330921` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getJoiner` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318263` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:127990` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `/^@[^\s/]+(?=\s\|$)/` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:5` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1945` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1675` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `optionalParslet` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315038` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:182166` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201839` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:182201` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:182210` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `normalizeWord` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326869` |
| 0.0% | 1.5ms | 0.0% | 0us | `splitTextIntoWords` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326875` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:285533` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:285605` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289731` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:285704` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:6` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/semver.js:8` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getTokenizers` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318757` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `commentParserToESTree` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317392` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getFencer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getTokensBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3518` |
| 0.0% | 1.4ms | 0.0% | 0us | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317896` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333334` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327089` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317995` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320809` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289550` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236366` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:232339` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236471` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236594` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317416` |
| 0.0% | 1.4ms | 0.0% | 0us | `read` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316321` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:102` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260290` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260469` |
| 0.0% | 1.4ms | 0.0% | 0us | `fix10` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330347` |
| 0.0% | 1.4ms | 0.0% | 0us | `_toPropertyKey` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260217` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:261100` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260359` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289663` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260567` |
| 0.0% | 1.4ms | 0.0% | 0us | `_objectSpread` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260205` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260206` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:261166` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_toPrimitive` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `_defineProperty` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260214` |
| 0.0% | 1.4ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:123` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_normalizeSeverity` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:194` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:254635` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:254650` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289636` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isGetter2` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319999` |
| 0.0% | 1.4ms | 0.0% | 0us | `exemptSpeciaMethods` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320032` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `accept` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316643` |
| 0.0% | 1.4ms | 0.0% | 0us | `tryParsePathIgnoreError` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336764` |
| 0.0% | 1.4ms | 0.0% | 0us | `read` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316317` |
| 0.0% | 1.4ms | 0.0% | 0us | `parseNamePath` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317060` |
| 0.0% | 1.4ms | 0.0% | 0us | `identifierRule` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316675` |
| 0.0% | 1.4ms | 0.0% | 0us | `validNamepathParsing` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336793` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336975` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `parseBlock` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:56` |
| 0.0% | 1.4ms | 0.0% | 0us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321298` |
| 0.0% | 1.4ms | 0.0% | 0us | `getSettings` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320988` |
| 0.0% | 1.4ms | 0.0% | 0us | `setTagStructure` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319141` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:215830` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:215932` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289484` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getDefaultTagStructureForMode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313579` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326797` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `log` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `push` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301194` |
| 0.0% | 1.4ms | 0.0% | 0us | `setDeps` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326787` |
| 0.0% | 1.4ms | 0.0% | 0us | `fix10` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330344` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `createTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332374` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:9` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/dotjs/index.js:15` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/rules.js:3` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:294929` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:54127` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7090` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `fix10` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328180` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:311053` |
| 0.0% | 1.4ms | 0.0% | 0us | `exec` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289582` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:243782` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:223238` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289518` |
| 0.0% | 1.4ms | 0.0% | 0us | `generateNamedReferences` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321745` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321771` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `ensureMap` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319629` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `cleanUpLastTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317365` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91300` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:90428` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:6` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330474` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/definition/index.js:26` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2390` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getParser` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318099` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328288` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332144` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `/^\/(.*)\/([gimyvus]*)$/sv` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `getRegexFromString` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320046` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getText` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `/^[^ [\],():#!=><~+.]/` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:72` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:272045` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:280656` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289703` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173264` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173079` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173042` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173071` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12342` |
| 0.0% | 1.3ms | 0.0% | 0us | `node:util` | `node:util:2` |
| 0.0% | 1.3ms | 0.0% | 0us | `checkNonJsdoc` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326197` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326198` |
| 0.0% | 1.3ms | 0.0% | 0us | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4103` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getLocFromIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3658` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329192` |
| 0.0% | 1.3ms | 0.0% | 0us | `flatMap` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289531` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getJsdocTagsDeep` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319379` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320762` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:225628` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rule-tester/rule-tester.js:31` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rule-tester/index.js:3` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/json-schema-traverse/index.js:14` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138274` |
| 0.0% | 1.3ms | 0.0% | 0us | `resolveIds` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:239` |
| 0.0% | 1.3ms | 0.0% | 0us | `_traverse` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/json-schema-traverse/index.js:65` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:242` |
| 0.0% | 1.3ms | 0.0% | 0us | `_traverse` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/json-schema-traverse/index.js:76` |
| 0.0% | 1.3ms | 0.0% | 0us | `_traverse` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/json-schema-traverse/index.js:71` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/api.js:14` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint/config-array/dist/cjs/index.cjs:7` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333903` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318045` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201847` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183111` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183074` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183103` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:249343` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289612` |
| 0.0% | 1.3ms | 0.0% | 0us | `getCommentsBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3421` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `Range` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:163501` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164517` |
| 0.0% | 1.3ms | 0.0% | 0us | `parseRange` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:163548` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `fix10` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332346` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290130` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:10138` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:24` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:195733` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201906` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:195056` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:195095` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:196154` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:195085` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `read` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316314` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320776` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330408` |
| 0.0% | 1.3ms | 0.0% | 0us | `getInlineTags` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319558` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320905` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/predicates.js:5` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/index.js:20` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-estree.js:6` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `/=(?!>)/` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318357` |
| 0.0% | 1.3ms | 0.0% | 0us | `search` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:175338` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:175309` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313117` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:175347` |
| 0.0% | 1.3ms | 0.0% | 0us | `getPreferredTagNameSimple` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319457` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getParamName` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319257` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332128` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/es2015.js:15` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/dom.js:9` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301172` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `addPolyfillToken` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301139` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `fix10` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330353` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/useProgramFromProjectService.js:30` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:22` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/useProgramFromProjectService.js:44` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333230` |
| 0.0% | 1.3ms | 0.0% | 0us | `canSkip` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333223` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318190` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318309` |
| 0.0% | 1.3ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318143` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4246` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318154` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `cleanUpLastTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317370` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `commentParserToESTree` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317359` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201850` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183944` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183953` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183909` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/convert.js:30` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/convert.js:40` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/convert.js:4` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/lib/picomatch.js:4` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319574` |
| 0.0% | 1.3ms | 0.0% | 0us | `getAllTags` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319596` |
| 0.0% | 1.3ms | 0.0% | 0us | `getInlineTags` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319573` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320899` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329252` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `findJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317882` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1450` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137945` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137749` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `stringify` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334719` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137882` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138272` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137799` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:5968` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313114` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:5945` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:237921` |
| 0.0% | 1.2ms | 0.0% | 0us | `canSkip5` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334195` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:237894` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:237825` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320924` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289556` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:282898` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330454` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289715` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:39` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/es2018.js:13` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:282864` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161552` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161606` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:160175` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161363` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161317` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320637` |
| 0.0% | 1.2ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7692` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320733` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332426` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313397` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:209129` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301183` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2146` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:146346` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313051` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:146402` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:189907` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:189918` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190009` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201878` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320845` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:335664` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313304` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201865` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get hasIndices` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/default-config.js:12` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getValidRuntimeIdentifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `internal:primordials` | `internal:primordials:50` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289545` |
| 0.0% | 1.2ms | 0.0% | 0us | `createSafeIterator` | `internal:primordials:14` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:231297` |
| 0.0% | 1.2ms | 0.0% | 0us | `internal:validators` | `internal:validators:2` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/private/tmp/prof_jsdoc.js:2` |
| 0.0% | 1.2ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.0% | 1.2ms | 0.0% | 0us | `internal:shared` | `internal:shared:2` |
| 0.0% | 1.2ms | 0.0% | 0us | `node:events` | `node:events:9` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320880` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `hasThrowValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319875` |
| 0.0% | 1.2ms | 0.0% | 0us | `shouldReport` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334117` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:7` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `commentParserToESTree` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317362` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333122` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320822` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `createTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332356` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336922` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320821` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:8` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/scope/index.js:22` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/TypeVisitor.js:6` |
| 0.0% | 1.2ms | 0.0% | 0us | `getPreferredTagName` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319516` |
| 0.0% | 1.2ms | 0.0% | 0us | `hasTag` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319490` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:724` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170804` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170810` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172343` |
| 0.0% | 1.2ms | 0.0% | 0us | `internal:streams/operators` | `internal:streams/operators:2` |
| 0.0% | 1.2ms | 0.0% | 0us | `internal:streams/pipeline` | `internal:streams/pipeline:2` |
| 0.0% | 1.2ms | 0.0% | 0us | `internal:fs/streams` | `internal:fs/streams:2` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `internal:streams/destroy` | `internal:streams/destroy:16` |
| 0.0% | 1.2ms | 0.0% | 0us | `internal:streams/compose` | `internal:streams/compose:2` |
| 0.0% | 1.2ms | 0.0% | 0us | `node:tty` | `node:tty:6` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:324240` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12341` |
| 0.0% | 1.2ms | 0.0% | 0us | `internal:stream` | `internal:stream:2` |
| 0.0% | 1.2ms | 0.0% | 0us | `node:stream` | `node:stream:2` |
| 0.0% | 1.2ms | 0.0% | 0us | `hasRejectValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333180` |
| 0.0% | 1.2ms | 0.0% | 0us | `hasRejectValue` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333201` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333203` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333202` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:16` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:58223` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:296352` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:8673` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:106842` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:8678` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:106430` |
| 0.0% | 1.2ms | 0.0% | 0us | `fix10` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330345` |
| 0.0% | 1.2ms | 0.0% | 0us | `getNodeSystem` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:8278` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109709` |
| 0.0% | 1.2ms | 0.0% | 0us | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:966` |
| 0.0% | 1.2ms | 0.0% | 0us | `_computeIdentifierName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4154` |
| 0.0% | 1.2ms | 0.0% | 0us | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4166` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:849` |
| 0.0% | 1.2ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1544` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getJSDocComment` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318025` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:335396` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:335427` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289625` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:251761` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/comparator.js:143` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:31` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326435` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319496` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320895` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4521` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320894` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:335309` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1982` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290382` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:51143` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:51201` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:48398` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:47927` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:48478` |
| 0.0% | 1.2ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2482` |
| 0.0% | 1.1ms | 0.0% | 1.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170986` |
| 0.0% | 1.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171015` |
| 0.0% | 1.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172348` |
| 0.0% | 1.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171024` |
| 0.0% | 1.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/eslint-utils/index.js:22` |
| 0.0% | 1.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:41` |
| 0.0% | 1.0ms | 0.0% | 1.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7676` |
| 0.0% | 916us | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4697` |
| 0.0% | 916us | 0.0% | 916us | `_extractRuleTagBitset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5366` |

## Function Details

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1300` | Self: 6.1% (247.2ms) | Total: 6.1% (247.2ms) | Samples: 164

**Called by:**
- `_getAllTokens` (164)

### `parse`
`[native code]` | Self: 5.6% (229.0ms) | Total: 5.6% (229.0ms) | Samples: 151

**Called by:**
- `parseSource` (149)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `anonymous`
`[native code]` | Self: 5.5% (223.6ms) | Total: 37.5% (1.51s) | Samples: 148

**Called by:**
- `require` (758)
- `bound require` (4)
- `loadAssertionError` (1)
- `node:util` (1)
- `node:stream` (1)
- `node:assert/strict` (1)
- `internal:shared` (1)
- `node:tty` (1)
- `node:fs` (1)
- `internal:stream` (1)
- `internal:streams/compose` (1)
- `internal:streams/operators` (1)
- `internal:validators` (1)
- `internal:fs/streams` (1)
- `internal:streams/pipeline` (1)
- `node:events` (1)

**Calls:**
- `(anonymous)` (49)
- `(anonymous)` (40)
- `(anonymous)` (28)
- `(anonymous)` (24)
- `(anonymous)` (24)
- `(anonymous)` (21)
- `(anonymous)` (20)
- `(anonymous)` (19)
- `(anonymous)` (15)
- `(anonymous)` (12)
- `(anonymous)` (11)
- `(anonymous)` (11)
- `(anonymous)` (9)
- `(anonymous)` (9)
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
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (7)
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
- `node:assert` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
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
- `internal:streams/destroy` (1)
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
- `internal:shared` (1)
- `(anonymous)` (1)
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
- `internal:streams/compose` (1)
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
- `internal:primordials` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
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
- `(anonymous)` (1)
- `node:tty` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:streams/operators` (1)
- `(anonymous)` (1)
- `internal:validators` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1288` | Self: 4.1% (167.5ms) | Total: 4.1% (167.5ms) | Samples: 110

**Called by:**
- `_getAllTokens` (110)

### `get flags`
`[native code]` | Self: 3.3% (134.7ms) | Total: 3.4% (139.5ms) | Samples: 89

**Called by:**
- `matchAll` (92)

**Calls:**
- `get sticky` (1)
- `get hasIndices` (1)
- `get ignoreCase` (1)

### `entries`
`[native code]` | Self: 3.0% (122.5ms) | Total: 3.0% (122.5ms) | Samples: 79

**Called by:**
- `getPreferredTagNameSimple` (78)
- `getPreferredTagNameSimple` (1)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1673` | Self: 2.5% (102.6ms) | Total: 18.6% (754.4ms) | Samples: 66

**Called by:**
- `findJSDocComment` (486)
- `getReducedASTNode` (9)

**Calls:**
- `_getTokensAndCommentsMerged` (375)
- `_getTokensAndCommentsMerged` (31)
- `_getTokensAndCommentsMerged` (13)
- `_getTokensAndCommentsMerged` (7)
- `_getTokensAndCommentsMerged` (1)
- `_getTokensAndCommentsMerged` (1)
- `_getTokensAndCommentsMerged` (1)

### ``/^\n?([A-Z`\d_][\s\S]*[.?!`\p{RGI_Emoji}]\s*)?$/v``
`[native code]` | Self: 2.3% (95.6ms) | Total: 2.3% (95.6ms) | Samples: 62

**Called by:**
- `test` (62)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 2.3% (95.5ms) | Total: 2.3% (95.5ms) | Samples: 63

**Called by:**
- `(anonymous)` (44)
- `iterate` (3)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
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
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328982` | Self: 2.1% (87.5ms) | Total: 2.4% (97.3ms) | Samples: 57

**Called by:**
- `filter` (63)

**Calls:**
- `/^\*(?!\*)/v` (6)

### `seedTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318080` | Self: 2.0% (83.8ms) | Total: 2.0% (83.8ms) | Samples: 18

**Called by:**
- `parseSource` (18)

### `getOwnPropertyDescriptor`
`[native code]` | Self: 1.9% (80.4ms) | Total: 1.9% (80.4ms) | Samples: 14

**Called by:**
- `(anonymous)` (6)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `/(?<!\])\{@(?<tag>[^\}\s]+)\s?(?<namepathOrURL>[^\}\s\\|]*)\s*(?<separator>[\s\\|])?\s*(?<text>[^\}]*)\}/dgv`
`[native code]` | Self: 1.9% (78.5ms) | Total: 1.9% (78.5ms) | Samples: 52

**Called by:**
- `regExpExec` (52)

### `filter`
`[native code]` | Self: 1.7% (71.3ms) | Total: 12.9% (522.1ms) | Samples: 46

**Called by:**
- `(anonymous)` (100)
- `(anonymous)` (79)
- `(anonymous)` (75)
- `(anonymous)` (63)
- `onProgramExit` (13)
- `(anonymous)` (4)
- `filterTags` (2)
- `(anonymous)` (2)
- `findExpectedIndex` (1)
- `compactJoiner` (1)

**Calls:**
- `(anonymous)` (81)
- `(anonymous)` (69)
- `(anonymous)` (63)
- `(anonymous)` (53)
- `(anonymous)` (13)
- `(anonymous)` (4)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329659` | Self: 1.7% (70.9ms) | Total: 1.9% (80.1ms) | Samples: 47

**Called by:**
- `filter` (53)

**Calls:**
- `/^\*(?!\*)/v` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328987` | Self: 1.6% (67.8ms) | Total: 2.6% (106.0ms) | Samples: 44

**Called by:**
- `filter` (69)

**Calls:**
- `/^\s*globals/v` (25)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7720` | Self: 1.5% (60.7ms) | Total: 59.2% (2.39s) | Samples: 41

**Called by:**
- `runPlugins` (1527)

**Calls:**
- `_invokeFused` (765)
- `_invokeFused` (432)
- `_invokeFused` (255)
- `_invokeFused` (20)
- `_invokeFused` (6)
- `_nodeViewRaw` (5)
- `nodeView` (1)
- `_invokeFused` (1)
- `_nodeViewRaw` (1)

### `regExpSplitFast`
`[native code]` | Self: 1.3% (56.3ms) | Total: 2.2% (89.3ms) | Samples: 35

**Called by:**
- `get lines` (34)
- `splitLines` (23)

**Calls:**
- `/\r\n\|\r\|\n\|\u2028\|\u2029/` (22)

### `SemVer`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:162890` | Self: 1.3% (54.8ms) | Total: 1.3% (54.8ms) | Samples: 2

**Called by:**
- `parse` (2)

### `[Symbol.match]`
`[native code]` | Self: 1.2% (50.8ms) | Total: 1.7% (69.7ms) | Samples: 34

**Called by:**
- `match` (46)

**Calls:**
- `/\r+$/` (6)
- `/^\s+/` (4)
- `/\s*(@(\S+))(\s*)/` (1)
- `/^\/(.*)\/([gimyvus]*)$/sv` (1)

### `stringSplitFast`
`[native code]` | Self: 1.1% (48.1ms) | Total: 1.1% (48.1ms) | Samples: 31

**Called by:**
- `(anonymous)` (24)
- `read` (2)
- `fix10` (1)
- `read` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `generateNamedReferences` (1)

### `getValidRuntimeIdentifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329079` | Self: 1.0% (43.3ms) | Total: 1.0% (43.3ms) | Samples: 29

**Called by:**
- `(anonymous)` (29)

### `Set`
`[native code]` | Self: 1.0% (42.8ms) | Total: 1.0% (42.8ms) | Samples: 27

**Called by:**
- `(anonymous)` (27)

### `/^\s*globals/v`
`[native code]` | Self: 0.9% (38.2ms) | Total: 0.9% (38.2ms) | Samples: 25

**Called by:**
- `(anonymous)` (25)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1285` | Self: 0.9% (36.3ms) | Total: 1.4% (59.8ms) | Samples: 23

**Called by:**
- `_getAllTokens` (38)

**Calls:**
- `_getJsxTextTokFlags` (9)
- `_getJsxTextTokFlags` (2)
- `_getJsxTextTokFlags` (2)
- `_getJsxTextTokFlags` (1)
- `_getJsxTextTokFlags` (1)

### `getText`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1346` | Self: 0.8% (33.3ms) | Total: 0.8% (33.3ms) | Samples: 23

**Called by:**
- `callIterator` (22)
- `(anonymous)` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1260` | Self: 0.8% (33.0ms) | Total: 0.8% (33.0ms) | Samples: 22

**Called by:**
- `_getAllTokens` (22)

### `/\r\n\|\r\|\n\|\u2028\|\u2029/`
`[native code]` | Self: 0.8% (32.9ms) | Total: 0.8% (32.9ms) | Samples: 22

**Called by:**
- `regExpSplitFast` (22)

### `test`
`[native code]` | Self: 0.6% (27.7ms) | Total: 3.0% (123.4ms) | Samples: 18

**Called by:**
- `validateDescription` (72)
- `callIterator` (3)
- `_buildScopeVarsAndSet` (1)
- `(anonymous)` (1)
- `serialize` (1)
- `getReducedASTNode` (1)
- `fix10` (1)

**Calls:**
- ``/^\n?([A-Z`\d_][\s\S]*[.?!`\p{RGI_Emoji}]\s*)?$/v`` (62)

### `parseIntermediateType`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314939` | Self: 0.6% (25.4ms) | Total: 1.3% (53.9ms) | Samples: 17

**Called by:**
- `parseType` (35)

**Calls:**
- `_NoParsletFoundError` (18)

### `parseSpec`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318169` | Self: 0.6% (25.3ms) | Total: 0.6% (25.3ms) | Samples: 16

**Called by:**
- `map` (16)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318044` | Self: 0.5% (23.6ms) | Total: 7.5% (305.5ms) | Samples: 16

**Called by:**
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (123)
- `checkJsdoc` (77)

**Calls:**
- `getJSDocComment` (153)
- `getJSDocComment` (31)

### `map`
`[native code]` | Self: 0.5% (23.1ms) | Total: 20.2% (817.1ms) | Samples: 15

**Called by:**
- `(anonymous)` (251)
- `(anonymous)` (135)
- `(anonymous)` (75)
- `compactJoiner` (7)
- `(anonymous)` (5)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `commentParserToESTree` (3)
- `camelCase` (2)
- `getFunctionParameterNames` (2)
- `_lintSourceOne` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `preserveJoiner` (1)
- `(anonymous)` (1)
- `Range` (1)
- `getInlineTags` (1)

**Calls:**
- `(anonymous)` (250)
- `(anonymous)` (135)
- `parseSpec` (46)
- `parseSpec` (16)
- `parseSpec` (6)
- `(anonymous)` (6)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `_fromRunnerReport` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `parseRange` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1975` | Self: 0.5% (21.9ms) | Total: 1.1% (48.3ms) | Samples: 14

**Called by:**
- `getTokenBefore` (31)

**Calls:**
- `_makeToken` (11)
- `_makeToken` (3)
- `_makeToken` (2)
- `_makeToken` (1)

### `Error`
`[native code]` | Self: 0.5% (21.8ms) | Total: 0.5% (21.8ms) | Samples: 14

**Called by:**
- `_NoParsletFoundError` (14)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318032` | Self: 0.5% (21.0ms) | Total: 0.5% (21.0ms) | Samples: 13

**Called by:**
- `checkJsdoc` (13)

### `getUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320879` | Self: 0.4% (19.5ms) | Total: 0.4% (19.5ms) | Samples: 13

**Called by:**
- `iterate` (13)

### `/^\*(?!\*)/v`
`[native code]` | Self: 0.4% (19.0ms) | Total: 0.4% (19.0ms) | Samples: 12

**Called by:**
- `(anonymous)` (6)
- `(anonymous)` (6)

### `callIterator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321103` | Self: 0.4% (18.0ms) | Total: 1.4% (58.3ms) | Samples: 12

**Called by:**
- `onProgramExit` (39)
- `onNodeWithComment` (1)

**Calls:**
- `getText` (22)
- `test` (3)
- `/^\/\*\*\s/v` (3)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1292` | Self: 0.4% (17.8ms) | Total: 0.4% (17.8ms) | Samples: 12

**Called by:**
- `_getAllTokens` (12)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318017` | Self: 0.4% (16.7ms) | Total: 0.4% (16.7ms) | Samples: 11

**Called by:**
- `getJSDocComment` (9)
- `getNonJsdocComment` (2)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.4% (16.7ms) | Total: 0.4% (16.7ms) | Samples: 11

**Called by:**
- `_getTokensAndCommentsMerged` (11)

### `esSpecIsRegExp`
`[native code]` | Self: 0.4% (16.1ms) | Total: 0.4% (16.1ms) | Samples: 11

**Called by:**
- `matchAll` (11)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:676` | Self: 0.3% (15.9ms) | Total: 0.3% (15.9ms) | Samples: 11

**Called by:**
- `getAllComments` (11)

### `join`
`[native code]` | Self: 0.3% (15.7ms) | Total: 0.3% (15.7ms) | Samples: 10

**Called by:**
- `compactJoiner` (6)
- `(anonymous)` (2)
- `preserveJoiner` (1)
- `(anonymous)` (1)

### `[Symbol.matchAll]`
`[native code]` | Self: 0.3% (15.5ms) | Total: 0.3% (15.5ms) | Samples: 11

**Called by:**
- `parseDescription` (7)
- `parseDescription` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328146` | Self: 0.3% (15.4ms) | Total: 0.5% (20.5ms) | Samples: 10

**Called by:**
- `filter` (13)

**Calls:**
- `trimStart` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7386` | Self: 0.3% (14.6ms) | Total: 0.3% (14.6ms) | Samples: 10

**Called by:**
- `runPlugins` (10)

### `_getAllTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1932` | Self: 0.3% (14.5ms) | Total: 13.8% (557.7ms) | Samples: 9

**Called by:**
- `_getTokensAndCommentsMerged` (367)

**Calls:**
- `_makeToken` (164)
- `_makeToken` (110)
- `_makeToken` (38)
- `_makeToken` (22)
- `_makeToken` (12)
- `_makeToken` (8)
- `_makeToken` (3)
- `_makeToken` (1)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1202` | Self: 0.3% (13.9ms) | Total: 0.3% (13.9ms) | Samples: 9

**Called by:**
- `_makeToken` (9)

### `parseDescription`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318682` | Self: 0.3% (13.8ms) | Total: 4.4% (178.5ms) | Samples: 9

**Called by:**
- `parseInlineTags` (80)
- `parseInlineTags` (38)

**Calls:**
- `performIteration` (56)
- `matchAll` (49)
- `[Symbol.matchAll]` (4)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1656` | Self: 0.3% (13.7ms) | Total: 0.5% (20.3ms) | Samples: 9

**Called by:**
- `findJSDocComment` (11)
- `getReducedASTNode` (2)

**Calls:**
- `get range` (2)
- `get range` (1)
- `get range` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319474` | Self: 0.3% (13.7ms) | Total: 0.5% (22.8ms) | Samples: 9

**Called by:**
- `find` (15)

**Calls:**
- `includes` (6)

### `RegExp`
`[native code]` | Self: 0.3% (13.6ms) | Total: 0.3% (13.6ms) | Samples: 9

**Called by:**
- `maskExcludedContent` (6)
- `(anonymous)` (2)
- `fix10` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` | Self: 0.3% (12.7ms) | Total: 0.3% (12.7ms) | Samples: 8

**Called by:**
- `(anonymous)` (6)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301189` | Self: 0.3% (12.5ms) | Total: 0.3% (12.5ms) | Samples: 8

**Called by:**
- `anonymous` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.2% (11.9ms) | Total: 2.2% (91.7ms) | Samples: 8

**Called by:**
- `(anonymous)` (30)
- `ke` (24)
- `(anonymous)` (4)
- `y` (3)

**Calls:**
- `(anonymous)` (30)
- `Ce` (12)
- `y` (3)
- `Ee` (2)
- `_e` (2)
- `be` (2)
- `De` (1)
- `Te` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1264` | Self: 0.2% (11.8ms) | Total: 0.2% (11.8ms) | Samples: 8

**Called by:**
- `_getAllTokens` (8)

### `_getAllTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1933` | Self: 0.2% (11.8ms) | Total: 0.2% (11.8ms) | Samples: 8

**Called by:**
- `_getTokensAndCommentsMerged` (8)

### `regExpExec`
`[native code]` | Self: 0.2% (11.6ms) | Total: 2.4% (98.2ms) | Samples: 8

**Called by:**
- `next` (65)

**Calls:**
- `/(?<!\])\{@(?<tag>[^\}\s]+)\s?(?<namepathOrURL>[^\}\s\\|]*)\s*(?<separator>[\s\\|])?\s*(?<text>[^\}]*)\}/dgv` (52)
- `/(?:\[(?<text>[^\]]+)\])\{@(?<tag>[^\}\s]+)\s?(?<namepathOrURL>[^\}\s\\|]*)\}/dgv` (5)

### `splitSpace`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318068` | Self: 0.2% (11.3ms) | Total: 0.2% (11.3ms) | Samples: 8

**Called by:**
- `parseSource` (5)
- `parseSource` (2)
- `parseSource` (1)

### `trimEnd`
`[native code]` | Self: 0.2% (11.1ms) | Total: 0.2% (11.1ms) | Samples: 7

**Called by:**
- `parseSource` (4)
- `parseSource` (3)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1977` | Self: 0.2% (10.8ms) | Total: 0.2% (10.8ms) | Samples: 7

**Called by:**
- `getTokenBefore` (7)

### `replace`
`[native code]` | Self: 0.2% (10.7ms) | Total: 0.2% (10.7ms) | Samples: 7

**Called by:**
- `maskExcludedContent` (7)

### `parseDescription`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318681` | Self: 0.2% (10.6ms) | Total: 3.2% (129.4ms) | Samples: 7

**Called by:**
- `parseInlineTags` (61)
- `parseInlineTags` (25)

**Calls:**
- `matchAll` (59)
- `performIteration` (13)
- `[Symbol.matchAll]` (7)

### `parslet`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315038` | Self: 0.2% (10.6ms) | Total: 0.2% (12.0ms) | Samples: 6

**Called by:**
- `tryParslets` (7)

**Calls:**
- `accept` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7855` | Self: 0.2% (10.3ms) | Total: 0.2% (10.3ms) | Samples: 7

**Called by:**
- `runPlugins` (7)

### `getReducedASTNode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317830` | Self: 0.2% (9.7ms) | Total: 0.4% (17.4ms) | Samples: 6

**Called by:**
- `getJSDocComment` (6)
- `getNonJsdocComment` (5)

**Calls:**
- `get parent` (4)
- `get parent` (1)

### `getCommentsBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3401` | Self: 0.2% (9.4ms) | Total: 0.2% (11.0ms) | Samples: 6

**Called by:**
- `getReducedASTNode` (4)
- `getReducedASTNode` (3)

**Calls:**
- `get range` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4522` | Self: 0.2% (9.4ms) | Total: 0.2% (9.4ms) | Samples: 2

**Called by:**
- `AstView` (2)

### `trim`
`[native code]` | Self: 0.2% (9.3ms) | Total: 0.2% (9.3ms) | Samples: 6

**Called by:**
- `(anonymous)` (6)

### `endsWith`
`[native code]` | Self: 0.2% (9.2ms) | Total: 0.2% (9.2ms) | Samples: 6

**Called by:**
- `parseSource` (4)
- `(anonymous)` (1)
- `preserveJoiner` (1)

### `/\r+$/`
`[native code]` | Self: 0.2% (9.2ms) | Total: 0.2% (9.2ms) | Samples: 6

**Called by:**
- `[Symbol.match]` (6)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1677` | Self: 0.2% (9.0ms) | Total: 0.2% (9.0ms) | Samples: 6

**Called by:**
- `findJSDocComment` (5)
- `getReducedASTNode` (1)

### `includes`
`[native code]` | Self: 0.2% (9.0ms) | Total: 0.2% (9.0ms) | Samples: 6

**Called by:**
- `(anonymous)` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317512` | Self: 0.2% (9.0ms) | Total: 0.2% (9.0ms) | Samples: 6

**Called by:**
- `forEach` (6)

### `concat`
`[native code]` | Self: 0.2% (9.0ms) | Total: 0.2% (9.0ms) | Samples: 6

**Called by:**
- `(anonymous)` (3)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5080` | Self: 0.2% (8.9ms) | Total: 36.7% (1.48s) | Samples: 6

**Called by:**
- `walkNodes` (765)
- `walkNodes` (162)

**Calls:**
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (663)
- `Program:exit` (102)
- `bound checkJsdoc` (85)
- `Program:exit` (60)
- `bound checkNonJsdoc` (7)
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (2)
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (2)

### `seedSpec`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318077` | Self: 0.2% (8.9ms) | Total: 0.2% (8.9ms) | Samples: 6

**Called by:**
- `parseSpec` (6)

### `parseBlock`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318104` | Self: 0.2% (8.9ms) | Total: 0.2% (10.4ms) | Samples: 5

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `/^@[^\s/]+(?=\s\|$)/` (1)

### `some`
`[native code]` | Self: 0.2% (8.8ms) | Total: 0.6% (28.0ms) | Samples: 6

**Called by:**
- `validateDescription` (4)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `hasRejectValue` (2)
- `checkNonJsdoc` (1)
- `hasTag` (1)
- `hasReturnValue` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `hasRejectValue` (1)
- `(anonymous)` (1)
- `hasATag` (1)

**Calls:**
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

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7382` | Self: 0.2% (8.6ms) | Total: 0.2% (8.6ms) | Samples: 6

**Called by:**
- `runPlugins` (6)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:590` | Self: 0.2% (8.1ms) | Total: 0.2% (8.1ms) | Samples: 5

**Called by:**
- `parseSource` (5)

### `/(?:\[(?<text>[^\]]+)\])\{@(?<tag>[^\}\s]+)\s?(?<namepathOrURL>[^\}\s\\|]*)\}/dgv`
`[native code]` | Self: 0.1% (8.0ms) | Total: 0.1% (8.0ms) | Samples: 5

**Called by:**
- `regExpExec` (5)

### `stringIncludesInternal`
`[native code]` | Self: 0.1% (7.8ms) | Total: 0.1% (7.8ms) | Samples: 5

**Called by:**
- `matchAll` (5)

### `checkJsdoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321335` | Self: 0.1% (7.6ms) | Total: 3.8% (157.1ms) | Samples: 5

**Called by:**
- `bound checkJsdoc` (101)

**Calls:**
- `getJSDocComment` (77)
- `getJSDocComment` (13)
- `getJSDocComment` (3)
- `getJSDocComment` (1)
- `getJSDocComment` (1)
- `getJSDocComment` (1)

### `getDecorator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317745` | Self: 0.1% (7.6ms) | Total: 0.5% (22.8ms) | Samples: 5

**Called by:**
- `findJSDocComment` (15)

**Calls:**
- `get declaration` (2)
- `get decorators` (2)
- `get decorators` (2)
- `get parent` (1)
- `get decorators` (1)
- `get decorators` (1)
- `get decorators` (1)

### `getUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320283` | Self: 0.1% (7.5ms) | Total: 0.2% (10.5ms) | Samples: 5

**Called by:**
- `iterate` (7)

**Calls:**
- `getBasicUtils` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328166` | Self: 0.1% (7.4ms) | Total: 3.0% (124.4ms) | Samples: 5

**Called by:**
- `filter` (81)

**Calls:**
- `parse3` (76)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318129` | Self: 0.1% (7.0ms) | Total: 0.1% (7.0ms) | Samples: 5

**Called by:**
- `(anonymous)` (5)

### `getParser4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318440` | Self: 0.1% (6.6ms) | Total: 0.1% (6.6ms) | Samples: 4

**Called by:**
- `parse3` (4)

### `/^\s+/`
`[native code]` | Self: 0.1% (6.5ms) | Total: 0.1% (6.5ms) | Samples: 4

**Called by:**
- `[Symbol.match]` (4)

### `trimStart`
`[native code]` | Self: 0.1% (6.4ms) | Total: 0.1% (6.4ms) | Samples: 4

**Called by:**
- `(anonymous)` (3)
- `(anonymous)` (1)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317893` | Self: 0.1% (6.3ms) | Total: 19.1% (774.5ms) | Samples: 4

**Called by:**
- `findJSDocComment` (508)

**Calls:**
- `getTokenBefore` (486)
- `getTokenBefore` (11)
- `getTokenBefore` (5)
- `getTokenBefore` (1)
- `getTokenBefore` (1)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318014` | Self: 0.1% (6.2ms) | Total: 0.1% (6.2ms) | Samples: 4

**Called by:**
- `getNonJsdocComment` (3)
- `getJSDocComment` (1)

### `compactJoiner`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318416` | Self: 0.1% (6.2ms) | Total: 0.6% (27.8ms) | Samples: 4

**Called by:**
- `(anonymous)` (16)
- `(anonymous)` (2)

**Calls:**
- `map` (7)
- `join` (6)
- `filter` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321192` | Self: 0.1% (6.1ms) | Total: 0.1% (6.1ms) | Samples: 4

**Called by:**
- `filter` (4)

### `getBasicUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320240` | Self: 0.1% (6.0ms) | Total: 0.1% (6.0ms) | Samples: 4

**Called by:**
- `callIterator` (2)
- `getUtils` (2)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` | Self: 0.1% (5.8ms) | Total: 0.1% (5.8ms) | Samples: 4

**Called by:**
- `_nodeViewRaw` (4)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4211` | Self: 0.1% (5.7ms) | Total: 0.1% (5.7ms) | Samples: 4

**Called by:**
- `getAncestors` (2)
- `get parent` (1)
- `walkNodes` (1)

### `getIndentAndJSDoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321082` | Self: 0.1% (5.6ms) | Total: 0.1% (5.6ms) | Samples: 4

**Called by:**
- `checkJsdoc` (4)

### `unshift`
`[native code]` | Self: 0.1% (5.6ms) | Total: 0.1% (5.6ms) | Samples: 4

**Called by:**
- `getAncestors` (4)

### `Ee`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.1% (5.6ms) | Total: 0.1% (5.6ms) | Samples: 4

**Called by:**
- `Se` (2)
- `(anonymous)` (2)

### `bound checkJsdoc`
`[native code]` | Self: 0.1% (5.2ms) | Total: 15.2% (613.4ms) | Samples: 3

**Called by:**
- `invokeHandlersWithNode` (302)
- `_invokeFused` (85)
- `_invokeFused` (9)

**Calls:**
- `checkJsdoc` (219)
- `checkJsdoc` (101)
- `checkJsdoc` (71)
- `checkJsdoc` (2)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318029` | Self: 0.1% (5.1ms) | Total: 0.1% (5.1ms) | Samples: 3

**Called by:**
- `checkJsdoc` (3)

### `replaceAll`
`[native code]` | Self: 0.1% (4.9ms) | Total: 0.1% (4.9ms) | Samples: 3

**Called by:**
- `maskCodeBlocks` (3)

### `maskCodeBlocks`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.1% (4.9ms) | Total: 0.1% (4.9ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `callIterator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321101` | Self: 0.1% (4.9ms) | Total: 0.1% (4.9ms) | Samples: 3

**Called by:**
- `onProgramExit` (2)
- `onNodeWithComment` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1228` | Self: 0.1% (4.9ms) | Total: 0.1% (4.9ms) | Samples: 3

**Called by:**
- `_getTokensAndCommentsMerged` (3)

### `reduce`
`[native code]` | Self: 0.1% (4.8ms) | Total: 0.1% (6.0ms) | Samples: 3

**Called by:**
- `preserveJoiner` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7682` | Self: 0.1% (4.7ms) | Total: 0.1% (4.7ms) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `join`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318467` | Self: 0.1% (4.7ms) | Total: 0.1% (4.7ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4094` | Self: 0.1% (4.6ms) | Total: 0.1% (4.6ms) | Samples: 3

**Called by:**
- `_nodeViewRaw` (3)

### `copyDataProperties`
`[native code]` | Self: 0.1% (4.5ms) | Total: 0.1% (4.5ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318796` | Self: 0.1% (4.5ms) | Total: 0.1% (4.5ms) | Samples: 3

**Called by:**
- `parseSpec` (3)

### `cloneObject`
`[native code]` | Self: 0.1% (4.4ms) | Total: 0.1% (4.4ms) | Samples: 3

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `performIteration`
`[native code]` | Self: 0.1% (4.4ms) | Total: 2.5% (104.3ms) | Samples: 3

**Called by:**
- `parseDescription` (56)
- `parseDescription` (13)

**Calls:**
- `next` (66)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1253` | Self: 0.1% (4.4ms) | Total: 0.1% (4.4ms) | Samples: 3

**Called by:**
- `getAncestors` (1)
- `getDecorator` (1)
- `getReducedASTNode` (1)

### `parse3`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318645` | Self: 0.1% (4.3ms) | Total: 11.3% (456.3ms) | Samples: 3

**Called by:**
- `parseComment` (182)
- `(anonymous)` (76)

**Calls:**
- `(anonymous)` (81)
- `(anonymous)` (76)
- `(anonymous)` (34)
- `(anonymous)` (25)
- `(anonymous)` (16)
- `getParser4` (4)
- `(anonymous)` (4)
- `getParser4` (3)
- `getParser4` (2)
- `getParser4` (2)
- `(anonymous)` (2)
- `getParser4` (2)
- `getParser4` (2)
- `getParser4` (1)
- `getParser4` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318458` | Self: 0.1% (4.3ms) | Total: 0.1% (6.9ms) | Samples: 3

**Called by:**
- `parse3` (4)
- `reduce` (1)

**Calls:**
- `concat` (1)
- `reduce` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320918` | Self: 0.1% (4.3ms) | Total: 0.1% (4.3ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7689` | Self: 0.1% (4.3ms) | Total: 0.1% (4.3ms) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `/^\/\*\*\s/v`
`[native code]` | Self: 0.1% (4.1ms) | Total: 0.1% (4.1ms) | Samples: 3

**Called by:**
- `callIterator` (3)

### `getTokenizers`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318761` | Self: 0.1% (4.1ms) | Total: 0.1% (4.1ms) | Samples: 2

**Called by:**
- `parseComment` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317500` | Self: 0.1% (4.0ms) | Total: 0.1% (5.4ms) | Samples: 3

**Called by:**
- `forEach` (4)

**Calls:**
- `cloneObject` (1)

### `encodeInto`
`[native code]` | Self: 0.0% (3.8ms) | Total: 0.0% (3.8ms) | Samples: 3

**Called by:**
- `_encodeSource` (3)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (3.4ms) | Total: 0.0% (3.4ms) | Samples: 2

**Called by:**
- `getNonJsdocComment` (1)
- `getJSDocComment` (1)

### `[Symbol.iterator]`
`[native code]` | Self: 0.0% (3.4ms) | Total: 0.0% (3.4ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `flatIntoArrayWithCallback`
`[native code]` | Self: 0.0% (3.4ms) | Total: 0.5% (21.6ms) | Samples: 2

**Called by:**
- `(anonymous)` (5)
- `(anonymous)` (3)
- `(anonymous)` (1)
- `flatMap` (1)
- `splitTextIntoWords` (1)
- `(anonymous)` (1)
- `getInlineTags` (1)

**Calls:**
- `(anonymous)` (4)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `normalizeWord` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318209` | Self: 0.0% (3.4ms) | Total: 0.0% (3.4ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `parse2`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317012` | Self: 0.0% (3.4ms) | Total: 0.0% (3.4ms) | Samples: 2

**Called by:**
- `cleanUpLastTag` (2)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (3.4ms) | Total: 0.0% (3.4ms) | Samples: 2

**Called by:**
- `getCommentsBefore` (1)
- `getTokenBefore` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316299` | Self: 0.0% (3.4ms) | Total: 0.2% (9.3ms) | Samples: 2

**Called by:**
- `parse2` (6)

**Calls:**
- `read` (1)
- `read` (1)
- `read` (1)
- `read` (1)

### `ke`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (3.3ms) | Total: 0.9% (40.1ms) | Samples: 2

**Called by:**
- `we` (26)

**Calls:**
- `(anonymous)` (24)

### `decode`
`[native code]` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `get source` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317506` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 1

**Called by:**
- `forEach` (1)

### `get decorators`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `getDecorator` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329199` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `flatIntoArrayWithCallback` (2)

### `tokenToString`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314662` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `_NoParsletFoundError` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318454` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `parse3` (2)

### `ensureMap`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319626` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `isNameOrNamepathDefiningTag` (2)

### `getPreferredTagName`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319514` | Self: 0.0% (3.2ms) | Total: 3.7% (150.0ms) | Samples: 2

**Called by:**
- `(anonymous)` (51)
- `forEachPreferredTag` (46)

**Calls:**
- `getPreferredTagNameSimple` (94)
- `getPreferredTagNameSimple` (1)

### `checkJsdoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321339` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `bound checkJsdoc` (2)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7092` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322295` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1187` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `_makeToken` (2)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3682` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `getTokenBefore` (2)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318042` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `(anonymous)` (1)
- `checkJsdoc` (1)

### `descriptionTokenizer`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318401` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `getParser4` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318116` | Self: 0.0% (3.1ms) | Total: 1.0% (40.9ms) | Samples: 2

**Called by:**
- `toggleFence` (26)

**Calls:**
- `stringSplitFast` (24)

### `tryParslets`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314956` | Self: 0.0% (3.1ms) | Total: 0.4% (18.3ms) | Samples: 2

**Called by:**
- `parseIntermediateType` (11)

**Calls:**
- `parslet` (7)
- `optionalParslet` (1)
- `specialTypesParslet` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:717` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `commentsInRange` (1)
- `commentsInRange` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318763` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `parseSpec` (2)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3673` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `getCommentsBefore` (1)
- `getTokenBefore` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1262` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `getReducedASTNode` (2)

### `read`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316330` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `create` (1)
- `create` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:593` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `parseSource` (2)

### `get decorators`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2144` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `getDecorator` (2)

### `freeze`
`[native code]` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `createSafeIterator` (1)
- `(anonymous)` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1290` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `_getTokensAndCommentsMerged` (2)

### `getReducedASTNode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `getNonJsdocComment` (2)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1653` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `findJSDocComment` (1)
- `getReducedASTNode` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7368` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `getNonJsdocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317950` | Self: 0.0% (2.9ms) | Total: 0.5% (23.2ms) | Samples: 2

**Called by:**
- `checkNonJsdoc` (16)

**Calls:**
- `getReducedASTNode` (5)
- `getReducedASTNode` (3)
- `getReducedASTNode` (2)
- `getReducedASTNode` (2)
- `getReducedASTNode` (1)
- `getReducedASTNode` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `parseSource` (2)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317919` | Self: 0.0% (2.8ms) | Total: 1.1% (47.9ms) | Samples: 2

**Called by:**
- `getJSDocComment` (31)

**Calls:**
- `getReducedASTNode` (14)
- `getReducedASTNode` (6)
- `getReducedASTNode` (4)
- `getReducedASTNode` (4)
- `getReducedASTNode` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318448` | Self: 0.0% (2.8ms) | Total: 1.0% (40.7ms) | Samples: 2

**Called by:**
- `parse3` (25)

**Calls:**
- `splitLines` (23)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1302` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `_invokeFused` (2)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318007` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `getJSDocComment` (2)

### `callIterator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321102` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `onProgramExit` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320942` | Self: 0.0% (2.8ms) | Total: 0.2% (11.8ms) | Samples: 2

**Called by:**
- `(anonymous)` (8)

**Calls:**
- `(anonymous)` (5)
- `(anonymous)` (1)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1192` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `_makeToken` (2)

### `read`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316313` | Self: 0.0% (2.7ms) | Total: 0.1% (4.4ms) | Samples: 2

**Called by:**
- `create` (3)

**Calls:**
- `/^\s+/v` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332414` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `findIndex` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7680` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `defineProperty`
`[native code]` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `Map`
`[native code]` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `getDefaultTagStructureForMode` (2)

### `_tokType`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `_makeToken` (2)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318147` | Self: 0.0% (2.6ms) | Total: 0.0% (2.6ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `isNameOrNamepathDefiningTag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319675` | Self: 0.0% (2.6ms) | Total: 0.0% (2.6ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5058` | Self: 0.0% (2.6ms) | Total: 0.7% (29.9ms) | Samples: 2

**Called by:**
- `walkNodes` (20)

**Calls:**
- `bound checkJsdoc` (9)
- `bound checkNonJsdoc` (9)

### `getParser4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318434` | Self: 0.0% (2.6ms) | Total: 0.0% (2.6ms) | Samples: 2

**Called by:**
- `parse3` (2)

### `get declaration`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3611` | Self: 0.0% (2.6ms) | Total: 0.0% (2.6ms) | Samples: 2

**Called by:**
- `getDecorator` (2)

### `getReducedASTNode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317855` | Self: 0.0% (2.6ms) | Total: 0.5% (22.6ms) | Samples: 2

**Called by:**
- `getJSDocComment` (14)
- `getNonJsdocComment` (1)

**Calls:**
- `getTokenBefore` (9)
- `getTokenBefore` (2)
- `getTokenBefore` (1)
- `getTokenBefore` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318140` | Self: 0.0% (2.5ms) | Total: 0.0% (2.5ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `getParser4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318442` | Self: 0.0% (1.8ms) | Total: 0.0% (3.6ms) | Samples: 1

**Called by:**
- `parse3` (2)

**Calls:**
- `getParser2` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318151` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4174` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `report` (1)

### `toLocaleUpperCase`
`[native code]` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get decorators`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2153` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `getDecorator` (1)

### `get decorators`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2150` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `getDecorator` (1)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `_makeToken` (1)

### `getParser2`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318121` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `getParser4` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320768` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `unionWith`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/visitor-keys/node_modules/eslint-visitor-keys/dist/eslint-visitor-keys.cjs` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1185` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `_makeToken` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1230` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `_getTokensAndCommentsMerged` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:580` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `splitCR`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318063` | Self: 0.0% (1.7ms) | Total: 0.3% (15.5ms) | Samples: 1

**Called by:**
- `parseSource` (10)

**Calls:**
- `match` (9)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318133` | Self: 0.0% (1.7ms) | Total: 0.4% (16.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (11)

**Calls:**
- `splitSpace` (5)
- `splitSpace` (5)

### `_NoParsletFoundError`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314668` | Self: 0.0% (1.7ms) | Total: 0.7% (28.5ms) | Samples: 1

**Called by:**
- `parseIntermediateType` (18)

**Calls:**
- `Error` (14)
- `tokenToString` (2)
- `(anonymous)` (1)

### `getAncestors`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3687` | Self: 0.0% (1.7ms) | Total: 0.0% (3.1ms) | Samples: 1

**Called by:**
- `getUtils` (2)

**Calls:**
- `get parent` (1)

### `get sticky`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `get flags` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318132` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `onNodeWithComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321176` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (1)

### `commentParserToESTree`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317393` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317570` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `forEach` (1)

### `parse2`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317001` | Self: 0.0% (1.7ms) | Total: 0.5% (23.1ms) | Samples: 1

**Called by:**
- `cleanUpLastTag` (14)
- `(anonymous)` (1)

**Calls:**
- `create` (7)
- `create` (6)
- `Parser` (1)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1971` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getTokenBefore` (1)

### `iterate`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321061` | Self: 0.0% (1.7ms) | Total: 38.0% (1.53s) | Samples: 1

**Called by:**
- `callIterator` (755)
- `checkJsdoc` (206)

**Calls:**
- `(anonymous)` (251)
- `(anonymous)` (135)
- `(anonymous)` (79)
- `(anonymous)` (75)
- `(anonymous)` (72)
- `(anonymous)` (63)
- `(anonymous)` (36)
- `(anonymous)` (33)
- `(anonymous)` (13)
- `(anonymous)` (13)
- `(anonymous)` (13)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (6)
- `(anonymous)` (6)
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

### `hasReturnValue`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318844` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326238` | Self: 0.0% (1.7ms) | Total: 15.0% (607.8ms) | Samples: 1

**Called by:**
- `bound ` (398)
- `_invokeFused` (1)

**Calls:**
- `checkNonJsdoc` (398)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317997` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getJSDocComment` (1)

### `get typeAnnotation`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2753` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getParamName` (1)

### `parseType`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314934` | Self: 0.0% (1.7ms) | Total: 1.8% (74.0ms) | Samples: 1

**Called by:**
- `parse` (47)

**Calls:**
- `parseIntermediateType` (35)
- `parseIntermediateType` (11)

### `hasRejectValue`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333151` | Self: 0.0% (1.7ms) | Total: 0.0% (2.9ms) | Samples: 1

**Called by:**
- `shouldReport` (2)

**Calls:**
- `hasRejectValue` (1)

### `get ignoreCase`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `get flags` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318131` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `preserveJoiner`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318423` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4144` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `report` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:183987` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `parse5`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `coerce` (1)

### `getContexts`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328706` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `nameTokenizer`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318275` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getParser4` (1)

### `getRegexFromString`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320060` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get kind`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2733` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `isConstructor` (1)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:901` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_ensureDeclSymIndex` (1)

### `be`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (1.7ms) | Total: 0.0% (3.1ms) | Samples: 1

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `/^[^ [\],():#!=><~+.]/` (1)

### `/\s*(@(\S+))(\s*)/`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `[Symbol.match]` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329661` | Self: 0.0% (1.7ms) | Total: 11.0% (444.0ms) | Samples: 1

**Called by:**
- `map` (250)

**Calls:**
- `commentParserToESTree` (81)
- `parseComment` (80)
- `parseComment` (80)
- `commentParserToESTree` (3)
- `commentParserToESTree` (1)
- `commentParserToESTree` (1)
- `commentParserToESTree` (1)
- `parseComment` (1)
- `commentParserToESTree` (1)

### `parseComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318829` | Self: 0.0% (1.7ms) | Total: 7.7% (310.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (80)
- `(anonymous)` (77)
- `getIndentAndJSDoc` (49)

**Calls:**
- `parseInlineTags` (141)
- `parseInlineTags` (64)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333233` | Self: 0.0% (1.7ms) | Total: 0.2% (9.8ms) | Samples: 1

**Called by:**
- `iterate` (6)

**Calls:**
- `(anonymous)` (4)
- `(anonymous)` (1)

### `forEach`
`[native code]` | Self: 0.0% (1.6ms) | Total: 3.2% (131.8ms) | Samples: 1

**Called by:**
- `commentParserToESTree` (83)
- `_objectSpread` (1)

**Calls:**
- `(anonymous)` (52)
- `(anonymous)` (14)
- `(anonymous)` (6)
- `(anonymous)` (4)
- `(anonymous)` (3)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320920` | Self: 0.0% (1.6ms) | Total: 0.0% (2.9ms) | Samples: 1

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `find` (1)

### `hasSchemaOption`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320025` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `exemptSpeciaMethods` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/node-utils.js:55` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/getModifiers.js:4` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1312` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_getAllTokens` (1)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318016` | Self: 0.0% (1.6ms) | Total: 19.9% (803.5ms) | Samples: 1

**Called by:**
- `getNonJsdocComment` (390)
- `getJSDocComment` (137)

**Calls:**
- `findJSDocComment` (508)
- `findJSDocComment` (15)
- `findJSDocComment` (1)
- `findJSDocComment` (1)
- `findJSDocComment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:189166` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `set`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172175` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getBasicUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320244` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `callIterator` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:179587` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `__export`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:24` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:609` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_rawTokenText` (1)

### `toLocaleLowerCase`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:1` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_NoParsletFoundError` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170720` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `read`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316323` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `create` (1)

### `setup`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `nextTick` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318139` | Self: 0.0% (1.6ms) | Total: 0.3% (14.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (9)

**Calls:**
- `trimEnd` (4)
- `endsWith` (4)

### `/^\s+/v`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `read` (1)

### `De`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `ge`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `Te` (1)

### `getParser3`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318163` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `getParser4` (1)

### `canSkip5`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334188` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4216` | Self: 0.0% (1.6ms) | Total: 0.3% (14.9ms) | Samples: 1

**Called by:**
- `walkNodes` (5)
- `nodeView` (3)
- `_nodesFromRange` (1)
- `hasRejectValue` (1)

**Calls:**
- `_NodeView` (4)
- `_NodeView` (3)
- `_NodeView_LR` (1)
- `_NodeView` (1)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317913` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `findJSDocComment` (1)

### `next`
`[native code]` | Self: 0.0% (1.6ms) | Total: 2.4% (99.8ms) | Samples: 1

**Called by:**
- `performIteration` (66)

**Calls:**
- `regExpExec` (65)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:8` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `splitTextIntoWords`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `areDocsInformative` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:559` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `parseSource` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2852` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `get globalScope` (1)

### `_analyzeHandler`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_fuseHandlers` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318766` | Self: 0.0% (1.6ms) | Total: 0.1% (5.0ms) | Samples: 1

**Called by:**
- `parseSpec` (3)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326167` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_execReport` (1)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4106` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332176` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `some` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1283` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8175` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_lintSourceOne` (1)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318001` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `getJSDocComment` (1)

### `specialTypesParslet`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315038` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `tryParslets` (1)

### `getUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320907` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2593` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4173` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `report` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320804` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `canSkip4` (1)

### `getDefaultTagStructureForMode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314049` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `getTagStructureForMode` (1)

### `readFileSync`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (3.1ms) | Samples: 1

**Called by:**
- `readFileSync` (1)
- `(anonymous)` (1)

**Calls:**
- `readFileSync` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322913` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318195` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `parseSpec` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329071` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `getUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320279` | Self: 0.0% (1.5ms) | Total: 0.3% (13.3ms) | Samples: 1

**Called by:**
- `iterate` (9)

**Calls:**
- `getAncestors` (6)
- `getAncestors` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318452` | Self: 0.0% (1.5ms) | Total: 1.3% (54.4ms) | Samples: 1

**Called by:**
- `parse3` (34)

**Calls:**
- `parseBlock` (26)
- `parseBlock` (6)
- `parseBlock` (1)

### `get`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `getJSDocComment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92487` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329227` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `getPreferredTagNameSimple`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319470` | Self: 0.0% (1.5ms) | Total: 3.6% (145.5ms) | Samples: 1

**Called by:**
- `getPreferredTagName` (94)

**Calls:**
- `entries` (78)
- `find` (15)

### `/^\s*\n\s*/v`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `read` (1)

### `onNodeWithComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (1)

### `Parser`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314896` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `parse2` (1)

### `preserveJoiner`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318428` | Self: 0.0% (1.5ms) | Total: 0.1% (4.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `reduce` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332100` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `getJoiner`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318263` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `typeTokenizer` (1)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1945` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `getTokenBefore` (1)

### `/^@[^\s/]+(?=\s\|$)/`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `parseBlock` (1)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1675` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `findJSDocComment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:5` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `optionalParslet`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:315038` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `tryParslets` (1)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `checkJsdoc` (1)

### `normalizeWord`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326869` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `flatIntoArrayWithCallback` (1)

### `splitSpace`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318067` | Self: 0.0% (1.5ms) | Total: 0.7% (29.0ms) | Samples: 1

**Called by:**
- `parseSource` (13)
- `parseSource` (5)
- `(anonymous)` (1)

**Calls:**
- `match` (18)

### `getTokenizers`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318757` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `parseComment` (1)

### `parse`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (1.4ms) | Total: 0.5% (23.0ms) | Samples: 1

**Called by:**
- `g` (15)

**Calls:**
- `Ae` (14)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_fromRunnerReport` (1)

### `commentParserToESTree`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317392` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getFencer`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getParser` (1)

### `getTokensBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3518` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `findJSDocComment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333334` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `getUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320809` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327089` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317995` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getJSDocComment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:232339` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317416` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `forEach` (1)

### `getReducedASTNode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317870` | Self: 0.0% (1.4ms) | Total: 0.1% (4.5ms) | Samples: 1

**Called by:**
- `getNonJsdocComment` (2)
- `getJSDocComment` (1)

**Calls:**
- `get parent` (2)

### `_toPrimitive`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_toPropertyKey` (1)

### `_normalizeSeverity`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:194` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `async _resolveConfigImpl` (1)

### `isGetter2`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319999` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `exemptSpeciaMethods` (1)

### `cleanUpLastTag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317374` | Self: 0.0% (1.4ms) | Total: 2.4% (100.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (51)
- `(anonymous)` (13)

**Calls:**
- `parse2` (47)
- `parse2` (14)
- `parse2` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333358` | Self: 0.0% (1.4ms) | Total: 0.2% (8.1ms) | Samples: 1

**Called by:**
- `iterate` (5)

**Calls:**
- `(anonymous)` (4)

### `accept`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `parslet` (1)

### `parseModule`
`[native code]` | Self: 0.0% (1.4ms) | Total: 13.5% (546.2ms) | Samples: 1

**Called by:**
- `async (anonymous)` (287)

**Calls:**
- `(anonymous)` (275)
- `(anonymous)` (9)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `parseBlock`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getParser`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318098` | Self: 0.0% (1.4ms) | Total: 0.0% (2.9ms) | Samples: 1

**Called by:**
- `getParser4` (2)

**Calls:**
- `getFencer` (1)

### `getDefaultTagStructureForMode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313579` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getTagStructureForMode` (1)

### `log`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `setDeps` (1)

### `push`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1282` | Self: 0.0% (1.4ms) | Total: 0.1% (4.1ms) | Samples: 1

**Called by:**
- `_getAllTokens` (3)

**Calls:**
- `_tokType` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329225` | Self: 0.0% (1.4ms) | Total: 1.3% (53.6ms) | Samples: 1

**Called by:**
- `iterate` (36)

**Calls:**
- `getValidRuntimeIdentifiers` (29)
- `concat` (3)
- `getValidRuntimeIdentifiers` (2)
- `getValidRuntimeIdentifiers` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334441` | Self: 0.0% (1.4ms) | Total: 0.1% (7.7ms) | Samples: 1

**Called by:**
- `iterate` (5)

**Calls:**
- `checkTagName2` (4)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:674` | Self: 0.0% (1.4ms) | Total: 0.0% (3.0ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)
- `getAllComments` (1)

**Calls:**
- `_findLineIdx` (1)

### `createTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332374` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `fix10` (1)

### `typeTokenizer`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318203` | Self: 0.0% (1.4ms) | Total: 0.0% (2.9ms) | Samples: 1

**Called by:**
- `getParser4` (2)

**Calls:**
- `getJoiner` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7090` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `fix10`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328180` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_execReport` (1)

### `checkJsdoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321342` | Self: 0.0% (1.4ms) | Total: 2.7% (109.9ms) | Samples: 1

**Called by:**
- `bound checkJsdoc` (71)

**Calls:**
- `getIndentAndJSDoc` (66)
- `getIndentAndJSDoc` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:311053` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `/\/\*([\s\S]*?)\*\//g`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `exec` (1)

### `ensureMap`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319629` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `isNameOrNamepathDefiningTag` (1)

### `cleanUpLastTag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317365` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2390` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `getParser`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318099` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getParser4` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328288` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318127` | Self: 0.0% (1.4ms) | Total: 0.4% (16.9ms) | Samples: 1

**Called by:**
- `(anonymous)` (11)

**Calls:**
- `splitCR` (10)

### `/^\/(.*)\/([gimyvus]*)$/sv`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `[Symbol.match]` (1)

### `getText`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `/^[^ [\],():#!=><~+.]/`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `be` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173042` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getLocFromIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3658` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `get loc` (1)

### `getJsdocTagsDeep`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319379` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:242` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_traverse` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333903` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318045` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183074` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getCommentsBefore` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `parseRange` (1)

### `fix10`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332346` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `fixer` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5043` | Self: 0.0% (1.3ms) | Total: 0.2% (8.7ms) | Samples: 1

**Called by:**
- `walkNodes` (6)

**Calls:**
- `get parent` (2)
- `get parent` (2)
- `get parent` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:10138` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `read`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316314` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `create` (1)

### `getUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320776` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `bound `
`[native code]` | Self: 0.0% (1.3ms) | Total: 15.0% (607.6ms) | Samples: 1

**Called by:**
- `_invokeFused` (358)
- `_invokeFused` (41)

**Calls:**
- `(anonymous)` (398)

### `/=(?!>)/`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `search` (1)

### `getParamName`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319257` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318302` | Self: 0.0% (1.3ms) | Total: 0.1% (4.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `[Symbol.iterator]` (2)

### `addPolyfillToken`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301139` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `fix10`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330353` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_execReport` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/useProgramFromProjectService.js:30` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318190` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `parseSpec` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318309` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4246` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `cleanUpLastTag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317370` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334119` | Self: 0.0% (1.3ms) | Total: 0.0% (2.5ms) | Samples: 1

**Called by:**
- `iterate` (2)

**Calls:**
- `shouldReport` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318154` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `commentParserToESTree`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317359` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `parseComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318818` | Self: 0.0% (1.3ms) | Total: 8.4% (340.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (80)
- `(anonymous)` (58)
- `getIndentAndJSDoc` (44)
- `getTemplateTags` (1)

**Calls:**
- `parse3` (182)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317882` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `findJSDocComment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319574` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `flatIntoArrayWithCallback` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1450` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `invokeMethodFnHandlers` (1)

### `stringify`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:5945` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320924` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `find` (1)

### `checkJsdoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321346` | Self: 0.0% (1.2ms) | Total: 8.3% (337.9ms) | Samples: 1

**Called by:**
- `bound checkJsdoc` (219)

**Calls:**
- `iterate` (206)
- `iterate` (12)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:160175` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getReducedASTNode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317863` | Self: 0.0% (1.2ms) | Total: 0.2% (10.5ms) | Samples: 1

**Called by:**
- `getJSDocComment` (4)
- `getNonJsdocComment` (3)

**Calls:**
- `getCommentsBefore` (4)
- `test` (1)
- `getCommentsBefore` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320637` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_resolveHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `parseSpec`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318168` | Self: 0.0% (1.2ms) | Total: 1.7% (70.9ms) | Samples: 1

**Called by:**
- `map` (46)

**Calls:**
- `(anonymous)` (18)
- `(anonymous)` (8)
- `(anonymous)` (7)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301183` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4251` | Self: 0.0% (1.2ms) | Total: 0.1% (6.2ms) | Samples: 1

**Called by:**
- `get parent` (4)

**Calls:**
- `_nodeViewRaw` (3)

### `get decorators`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2146` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `getDecorator` (1)

### `getUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320845` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:189907` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:335664` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `get hasIndices`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `get flags` (1)

### `getValidRuntimeIdentifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getCommentsBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3400` | Self: 0.0% (1.2ms) | Total: 0.0% (2.8ms) | Samples: 1

**Called by:**
- `getReducedASTNode` (2)

**Calls:**
- `get range` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:231297` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `callIterator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321139` | Self: 0.0% (1.2ms) | Total: 30.9% (1.24s) | Samples: 1

**Called by:**
- `onNodeWithComment` (770)
- `onProgramExit` (4)
- `onNodeAllNodes` (3)

**Calls:**
- `iterate` (755)
- `iterate` (21)

### `hasThrowValue`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319875` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `commentParserToESTree`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317362` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320822` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `some` (1)

### `createTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332356` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `fix10` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:724` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `commentsInRange` (1)

### `internal:streams/destroy`
`internal:streams/destroy:16` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2480` | Self: 0.0% (1.2ms) | Total: 0.0% (2.6ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (2)

**Calls:**
- `exec` (1)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:849` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_computeIdentifierName` (1)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318025` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `checkJsdoc` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318453` | Self: 0.0% (1.2ms) | Total: 2.9% (117.2ms) | Samples: 1

**Called by:**
- `parse3` (76)

**Calls:**
- `map` (75)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:335427` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `some` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:335309` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `iterate` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4521` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1982` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `getTokenBefore` (1)

### `parseInlineTags`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318704` | Self: 0.0% (1.2ms) | Total: 2.3% (95.0ms) | Samples: 1

**Called by:**
- `parseComment` (64)

**Calls:**
- `parseDescription` (38)
- `parseDescription` (25)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1261` | Self: 0.0% (1.2ms) | Total: 0.2% (8.9ms) | Samples: 1

**Called by:**
- `getReducedASTNode` (4)
- `_invokeFused` (2)

**Calls:**
- `nodeView` (4)
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170986` | Self: 0.0% (1.1ms) | Total: 0.0% (1.1ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7676` | Self: 0.0% (1.0ms) | Total: 0.0% (1.0ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_extractRuleTagBitset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5366` | Self: 0.0% (916us) | Total: 0.0% (916us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201912` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137749` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:49` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:241123` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333756` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201823` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getParser4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318436` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `parse3` (2)

**Calls:**
- `typeTokenizer` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290285` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318470` | Self: 0.0% (0us) | Total: 0.3% (12.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)
- `map` (3)

**Calls:**
- `join` (3)
- `map` (3)
- `join` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321033` | Self: 0.0% (0us) | Total: 0.6% (27.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (13)
- `report` (4)
- `(anonymous)` (2)

**Calls:**
- `report` (19)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint/plugin-kit/dist/cjs/index.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `maskCodeBlocks`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322839` | Self: 0.0% (0us) | Total: 0.1% (4.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `replaceAll` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/scope/index.js:22` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320905` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getInlineTags` (1)

### `addMetaSchema`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:152` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `addSchema` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/esquery.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `exemptSpeciaMethods`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320032` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isGetter2` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96656` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138509` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:40084` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7679` | Self: 0.0% (0us) | Total: 0.1% (4.6ms) | Samples: 0

**Called by:**
- `runPlugins` (3)

**Calls:**
- `getDFSEvents` (2)
- `getDFSEvents` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:168346` | Self: 0.0% (0us) | Total: 1.8% (75.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (49)

**Calls:**
- `(anonymous)` (49)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301194` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `push` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:175309` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `defineProperty` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:325959` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `_rawTokenText`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:879` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `get kind` (1)

**Calls:**
- `source` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318455` | Self: 0.0% (0us) | Total: 0.6% (24.6ms) | Samples: 0

**Called by:**
- `parse3` (16)

**Calls:**
- `compactJoiner` (16)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:221777` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289496` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:274` | Self: 0.0% (0us) | Total: 80.0% (3.22s) | Samples: 0

**Called by:**
- `(anonymous)` (2076)

**Calls:**
- `runPlugins` (2036)
- `runPlugins` (37)
- `runPlugins` (2)
- `runPlugins` (1)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289715` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326797` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `setDeps` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301172` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `addPolyfillToken` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96366` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161317` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `assign`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `node:assert` (1)

**Calls:**
- `get` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330921` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:257626` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/index.js:4` | Self: 0.0% (0us) | Total: 0.2% (11.2ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:43` | Self: 0.0% (0us) | Total: 0.3% (13.0ms) | Samples: 0

**Called by:**
- `anonymous` (9)

**Calls:**
- `bound require` (9)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` | Self: 0.0% (0us) | Total: 0.6% (26.3ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (13)

**Calls:**
- `AstView` (5)
- `AstView` (3)
- `AstView` (2)
- `AstView` (2)
- `AstView` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334236` | Self: 0.0% (0us) | Total: 0.1% (6.9ms) | Samples: 0

**Called by:**
- `iterate` (4)

**Calls:**
- `checkTagName` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330697` | Self: 0.0% (0us) | Total: 0.1% (4.3ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:312924` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/dotjs/index.js:15` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `hasValueOrExecutorHasNonEmptyResolveValue`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319117` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint/config-array/dist/cjs/index.cjs:7` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317604` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `cloneObject` (1)

### `commentParserToESTree`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317415` | Self: 0.0% (0us) | Total: 3.2% (130.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (81)
- `(anonymous)` (2)

**Calls:**
- `forEach` (83)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328145` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `filter` (2)

**Calls:**
- `getText` (1)
- `getText` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:215932` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328144` | Self: 0.0% (0us) | Total: 3.8% (153.9ms) | Samples: 0

**Called by:**
- `Program:exit` (100)

**Calls:**
- `filter` (100)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318404` | Self: 0.0% (0us) | Total: 0.3% (14.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (7)
- `parseSpec` (2)

**Calls:**
- `preserveJoiner` (3)
- `compactJoiner` (2)
- `preserveJoiner` (2)
- `preserveJoiner` (1)
- `preserveJoiner` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317600` | Self: 0.0% (0us) | Total: 0.5% (23.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (15)

**Calls:**
- `g` (15)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:131289` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330386` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `some` (2)

**Calls:**
- `report` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318799` | Self: 0.0% (0us) | Total: 0.3% (12.3ms) | Samples: 0

**Called by:**
- `parseSpec` (8)

**Calls:**
- `(anonymous)` (3)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:37` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `node:assert`
`node:assert:588` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `assign` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:8` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `fix10`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332411` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `fixer` (2)

**Calls:**
- `findIndex` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/json-schema-traverse/index.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `resolveIds` (1)

**Calls:**
- `_traverse` (1)

### `fix10`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332396` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `fixer` (1)

**Calls:**
- `findIndex` (1)

### `onProgramExit`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321193` | Self: 0.0% (0us) | Total: 1.7% (69.1ms) | Samples: 0

**Called by:**
- `Program:exit` (47)

**Calls:**
- `callIterator` (39)
- `callIterator` (4)
- `callIterator` (2)
- `callIterator` (2)

### `getESLintCoreRule`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:174800` | Self: 0.0% (0us) | Total: 0.1% (5.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333904` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/definition/index.js:26` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `getSettings`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320988` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `create` (1)

**Calls:**
- `setTagStructure` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:196154` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326147` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `reportings` (1)
- `reportings` (1)

**Calls:**
- `report` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/token-store/index.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/analyze.js:5` | Self: 0.0% (0us) | Total: 0.2% (11.2ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7822` | Self: 0.0% (0us) | Total: 11.7% (474.5ms) | Samples: 0

**Called by:**
- `runPlugins` (307)

**Calls:**
- `invokeMethodFnHandlers` (305)
- `invokeMethodFnHandlers` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:38` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332923` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/clear-caches.js:5` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289518` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `findIndex`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (5.9ms) | Samples: 0

**Called by:**
- `fix10` (2)
- `findExpectedIndex` (1)
- `fix10` (1)

**Calls:**
- `(anonymous)` (2)
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332128` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:102` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:277093` | Self: 0.0% (0us) | Total: 0.2% (9.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `(anonymous)` (6)

### `WriteStream`
`internal:fs/streams:245` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `Writable` (1)

### `canSkip3`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333567` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318416` | Self: 0.0% (0us) | Total: 0.2% (9.3ms) | Samples: 0

**Called by:**
- `map` (6)

**Calls:**
- `trim` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328991` | Self: 0.0% (0us) | Total: 0.2% (9.3ms) | Samples: 0

**Called by:**
- `iterate` (5)

**Calls:**
- `flatIntoArrayWithCallback` (5)

### `callIterator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321130` | Self: 0.0% (0us) | Total: 0.8% (33.1ms) | Samples: 0

**Called by:**
- `onNodeWithComment` (22)

**Calls:**
- `every` (22)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161606` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321659` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `parse2` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332850` | Self: 0.0% (0us) | Total: 0.2% (9.4ms) | Samples: 0

**Called by:**
- `iterate` (6)

**Calls:**
- `(anonymous)` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:280656` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:218473` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321230` | Self: 0.0% (0us) | Total: 32.8% (1.32s) | Samples: 0

**Called by:**
- `_invokeFused` (663)
- `_invokeFused` (164)
- `invokeHandlersWithNode` (1)

**Calls:**
- `onNodeWithComment` (826)
- `onNodeWithComment` (1)
- `onNodeWithComment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96674` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320366` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `getRegexFromString` (1)
- `getRegexFromString` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326641` | Self: 0.0% (0us) | Total: 0.1% (4.4ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:182166` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289545` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `createDebug`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12070` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `useColors` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333122` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:135987` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318855` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `some` (1)

**Calls:**
- `hasReturnValue` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:212998` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170804` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `bound checkNonJsdoc`
`[native code]` | Self: 0.0% (0us) | Total: 0.6% (25.6ms) | Samples: 0

**Called by:**
- `_invokeFused` (9)
- `_invokeFused` (7)
- `invokeHandlersWithNode` (1)

**Calls:**
- `checkNonJsdoc` (14)
- `checkNonJsdoc` (2)
- `checkNonJsdoc` (1)

### `(anonymous)`
`/private/tmp/prof_jsdoc.js:5` | Self: 0.0% (0us) | Total: 0.3% (14.1ms) | Samples: 0

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

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172204` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289691` | Self: 0.0% (0us) | Total: 0.2% (9.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `(anonymous)` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332144` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:41` | Self: 0.0% (0us) | Total: 0.0% (1.1ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336919` | Self: 0.0% (0us) | Total: 0.1% (4.2ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `map` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/TypeVisitor.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:187547` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321241` | Self: 0.0% (0us) | Total: 2.1% (88.3ms) | Samples: 0

**Called by:**
- `_invokeFused` (60)

**Calls:**
- `onProgramExit` (47)
- `onProgramExit` (13)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:4` | Self: 0.0% (0us) | Total: 1.6% (67.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `getOwnPropertyDescriptor` (6)

### `resolveIds`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:235` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_addSchema` (1)

**Calls:**
- `_getFullPath` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320332` | Self: 0.0% (0us) | Total: 0.1% (7.7ms) | Samples: 0

**Called by:**
- `_execReport` (5)

**Calls:**
- `(anonymous)` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/index.js:20` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164604` | Self: 0.0% (0us) | Total: 1.3% (56.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:198766` | Self: 0.0% (0us) | Total: 0.4% (18.6ms) | Samples: 0

**Called by:**
- `anonymous` (12)

**Calls:**
- `(anonymous)` (6)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `internal:fs/streams`
`internal:fs/streams:2` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `commentParserToESTree`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317398` | Self: 0.0% (0us) | Total: 0.1% (4.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `map` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171024` | Self: 0.0% (0us) | Total: 0.0% (1.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `Comparator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:163872` | Self: 0.0% (0us) | Total: 1.3% (54.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `parse` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `parseRange`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:163548` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `get` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318395` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `splitSpace` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313031` | Self: 0.0% (0us) | Total: 0.1% (4.3ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `(anonymous)` (3)

### `getParser4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318443` | Self: 0.0% (0us) | Total: 0.1% (4.3ms) | Samples: 0

**Called by:**
- `parse3` (3)

**Calls:**
- `getParser` (2)
- `getParser` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:294929` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:179616` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `node:assert/strict`
`node:assert/strict:3` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322393` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `generateNamedReferences`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321745` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `stringSplitFast` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295652` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `get`
`node:assert:70` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `assign` (1)

**Calls:**
- `loadAssertionError` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:195056` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `defineProperty` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:312909` | Self: 0.0% (0us) | Total: 0.1% (4.5ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `(anonymous)` (3)

### `parseInlineTags`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318701` | Self: 0.0% (0us) | Total: 5.3% (214.1ms) | Samples: 0

**Called by:**
- `parseComment` (141)

**Calls:**
- `parseDescription` (80)
- `parseDescription` (61)

### `hasReturnValue`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318851` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `hasReturnValue` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:19` | Self: 0.0% (0us) | Total: 0.2% (10.5ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138274` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `canSkip2`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333327` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:45` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:279` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `map` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137799` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:221655` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328331` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `coerce`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:212006` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `parse5` (1)

### `_traverse`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/json-schema-traverse/index.js:71` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_traverse` (1)

**Calls:**
- `_traverse` (1)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1948` | Self: 0.0% (0us) | Total: 0.4% (18.6ms) | Samples: 0

**Called by:**
- `getTokenBefore` (13)

**Calls:**
- `getAllComments` (13)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/ast-converter.js:7` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-estree.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_objectSpread`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260205` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `forEach` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4697` | Self: 0.0% (0us) | Total: 0.0% (916us) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_extractRuleTagBitset` (1)

### `addPolyfillToken`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301137` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `camelCase` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/resolveProjectList.js:10` | Self: 0.0% (0us) | Total: 0.1% (4.2ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `camelCase`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295621` | Self: 0.0% (0us) | Total: 0.0% (3.4ms) | Samples: 0

**Called by:**
- `addPolyfillToken` (1)
- `(anonymous)` (1)

**Calls:**
- `map` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:182201` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329059` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `flatIntoArrayWithCallback` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201871` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `setTagStructure`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319141` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `getSettings` (1)

**Calls:**
- `getDefaultTagStructureForMode` (1)

### `splitLines`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318071` | Self: 0.0% (0us) | Total: 0.9% (37.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (23)

**Calls:**
- `regExpSplitFast` (23)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317468` | Self: 0.0% (0us) | Total: 0.1% (4.5ms) | Samples: 0

**Called by:**
- `forEach` (3)

**Calls:**
- `copyDataProperties` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332173` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `some` (1)

**Calls:**
- `endsWith` (1)

### `tryParsePathIgnoreError`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336764` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `validNamepathParsing` (1)

**Calls:**
- `parseNamePath` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:285533` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2137` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `_symName` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320880` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `shouldReport` (1)

**Calls:**
- `hasThrowValue` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:257630` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333582` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `canSkip3` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332122` | Self: 0.0% (0us) | Total: 0.3% (12.7ms) | Samples: 0

**Called by:**
- `iterate` (8)

**Calls:**
- `(anonymous)` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333155` | Self: 0.0% (0us) | Total: 0.0% (2.4ms) | Samples: 0

**Called by:**
- `some` (2)

**Calls:**
- `hasRejectValue` (1)
- `hasRejectValue` (1)

### `parseNamePath`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317060` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `tryParsePathIgnoreError` (1)

**Calls:**
- `create` (1)

### `getIndentAndJSDoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321083` | Self: 0.0% (0us) | Total: 3.6% (146.8ms) | Samples: 0

**Called by:**
- `checkJsdoc` (66)
- `callIterator` (29)

**Calls:**
- `parseComment` (49)
- `parseComment` (44)
- `parseComment` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336922` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-modifiers.js:39` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `getInlineTags`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319558` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290081` | Self: 0.0% (0us) | Total: 0.0% (3.5ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (2)

### `Range`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:163501` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/index.js:18` | Self: 0.0% (0us) | Total: 0.3% (13.0ms) | Samples: 0

**Called by:**
- `anonymous` (9)

**Calls:**
- `bound require` (9)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4161` | Self: 0.0% (0us) | Total: 0.6% (27.9ms) | Samples: 0

**Called by:**
- `report` (19)

**Calls:**
- `(anonymous)` (8)
- `(anonymous)` (5)
- `fix10` (1)
- `fix10` (1)
- `fix10` (1)
- `(anonymous)` (1)
- `fix10` (1)
- `fix10` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332426` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12341` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:16` | Self: 0.0% (0us) | Total: 1.7% (69.3ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/semver.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:187582` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:169412` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `loadAssertionError`
`node:assert:28` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `get` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `parseSpec`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318166` | Self: 0.0% (0us) | Total: 0.2% (8.9ms) | Samples: 0

**Called by:**
- `map` (6)

**Calls:**
- `seedSpec` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317896` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `findJSDocComment` (1)

**Calls:**
- `getTokensBefore` (1)

### `filterTags`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319495` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `filter` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:101266` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333230` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `canSkip` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320327` | Self: 0.0% (0us) | Total: 0.1% (7.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `(anonymous)` (5)

### `forEachPreferredTag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319536` | Self: 0.0% (0us) | Total: 1.8% (72.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (47)

**Calls:**
- `getPreferredTagName` (46)
- `getPreferredTagName` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328995` | Self: 0.0% (0us) | Total: 0.1% (4.4ms) | Samples: 0

**Called by:**
- `filter` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/apply-disable-directives.js:22` | Self: 0.0% (0us) | Total: 0.3% (13.3ms) | Samples: 0

**Called by:**
- `anonymous` (9)

**Calls:**
- `bound require` (9)

### `getAllTags`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319596` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getInlineTags` (1)

### `_getOrBuildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6160` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_buildPlan` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329660` | Self: 0.0% (0us) | Total: 11.0% (445.4ms) | Samples: 0

**Called by:**
- `iterate` (251)

**Calls:**
- `map` (251)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:609` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `decode` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/fdir/dist/index.cjs:462` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:106842` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173277` | Self: 0.0% (0us) | Total: 2.4% (99.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (27)

**Calls:**
- `(anonymous)` (27)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236366` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/convert.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289675` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `canSkip5`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334195` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `findExpectedIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332182` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `fix10` (1)

**Calls:**
- `filter` (1)

### `validNamepathParsing`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336793` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `tryParsePathIgnoreError` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332172` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `findIndex` (2)

**Calls:**
- `some` (2)

### `flatMap`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `flatIntoArrayWithCallback` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:241055` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:28` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:324400` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329194` | Self: 0.0% (0us) | Total: 0.1% (5.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `flatIntoArrayWithCallback` (3)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318126` | Self: 0.0% (0us) | Total: 2.0% (83.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (18)

**Calls:**
- `seedTokens` (18)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:197251` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260206` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `forEach` (1)

**Calls:**
- `_defineProperty` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201906` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328986` | Self: 0.0% (0us) | Total: 3.0% (121.6ms) | Samples: 0

**Called by:**
- `iterate` (79)

**Calls:**
- `filter` (79)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:14` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313078` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getReducedASTNode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317860` | Self: 0.0% (0us) | Total: 0.1% (7.2ms) | Samples: 0

**Called by:**
- `getJSDocComment` (4)
- `getNonJsdocComment` (1)

**Calls:**
- `getCommentsBefore` (3)
- `getCommentsBefore` (2)

### `parseBlock`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318109` | Self: 0.0% (0us) | Total: 1.0% (40.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (26)

**Calls:**
- `toggleFence` (26)

### `shouldReport`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334117` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:285605` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/unsupported-api.js:14` | Self: 0.0% (0us) | Total: 0.9% (36.6ms) | Samples: 0

**Called by:**
- `anonymous` (24)

**Calls:**
- `bound require` (24)

### `getCommentsBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3421` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `getReducedASTNode` (1)

**Calls:**
- `commentsInRange` (1)

### `node:tty`
`node:tty:6` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:246598` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

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
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/source-code-traverser.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313397` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323795` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228702` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:42` | Self: 0.0% (0us) | Total: 1.7% (69.3ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `(anonymous)` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313124` | Self: 0.0% (0us) | Total: 0.7% (31.7ms) | Samples: 0

**Called by:**
- `anonymous` (20)

**Calls:**
- `(anonymous)` (20)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319364` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `map` (2)

**Calls:**
- `getParamName` (1)
- `getParamName` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:48` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:136145` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/index.js:26` | Self: 0.0% (0us) | Total: 0.3% (13.0ms) | Samples: 0

**Called by:**
- `anonymous` (9)

**Calls:**
- `bound require` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295644` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `toLocaleUpperCase` (1)

### `_fuseHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4950` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_buildPlan` (1)

**Calls:**
- `_analyzeHandler` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332756` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201921` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301141` | Self: 0.0% (0us) | Total: 0.1% (7.4ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `map` (5)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4103` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_fromRunnerReport` (1)

**Calls:**
- `getLocFromIndex` (1)

### `checkNonJsdoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326197` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `bound checkNonJsdoc` (1)

**Calls:**
- `some` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289598` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6470` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_getOrBuildPlan` (1)

**Calls:**
- `_fuseHandlers` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333203` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `some` (1)

**Calls:**
- `hasRejectValue` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172573` | Self: 0.0% (0us) | Total: 2.3% (96.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (25)

**Calls:**
- `(anonymous)` (25)

### `checkTagName`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334198` | Self: 0.0% (0us) | Total: 0.1% (6.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `(anonymous)` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:8673` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getNodeSystem` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-modifiers.js:38` | Self: 0.0% (0us) | Total: 0.1% (6.0ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `bound require` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190009` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333101` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `(anonymous)` (3)

### `_loadBundle`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-loader.js:34` | Self: 0.0% (0us) | Total: 13.0% (527.8ms) | Samples: 0

**Called by:**
- `bundleRulesFor` (275)

**Calls:**
- `bound require` (275)

### `getTemplateTags`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329054` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `parseComment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/eslint-utils/index.js:22` | Self: 0.0% (0us) | Total: 0.0% (1.1ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260469` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317438` | Self: 0.0% (0us) | Total: 0.5% (21.1ms) | Samples: 0

**Called by:**
- `forEach` (14)

**Calls:**
- `cleanUpLastTag` (13)
- `cleanUpLastTag` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329667` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `filter` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:146346` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `onProgramExit`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321192` | Self: 0.0% (0us) | Total: 0.4% (19.2ms) | Samples: 0

**Called by:**
- `Program:exit` (13)

**Calls:**
- `filter` (13)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260290` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `_objectSpread` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321298` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (1)

**Calls:**
- `getSettings` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91298` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/useProgramFromProjectService.js:44` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `parse`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:163893` | Self: 0.0% (0us) | Total: 1.3% (54.8ms) | Samples: 0

**Called by:**
- `Comparator` (2)

**Calls:**
- `SemVer` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:282864` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:12` | Self: 0.0% (0us) | Total: 0.2% (10.5ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201859` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320795` | Self: 0.0% (0us) | Total: 0.1% (4.8ms) | Samples: 0

**Called by:**
- `canSkip4` (1)
- `canSkip2` (1)
- `(anonymous)` (1)

**Calls:**
- `exemptSpeciaMethods` (2)
- `exemptSpeciaMethods` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201868` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `every`
`[native code]` | Self: 0.0% (0us) | Total: 0.8% (33.1ms) | Samples: 0

**Called by:**
- `callIterator` (22)

**Calls:**
- `(anonymous)` (22)

### `read`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316321` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `create` (1)

**Calls:**
- `stringSplitFast` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326435` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172212` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:106430` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:8678` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289550` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316643` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `identifierRule` (1)

**Calls:**
- `test` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:241260` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320777` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `canSkip4` (1)

**Calls:**
- `hasATag` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173276` | Self: 0.0% (0us) | Total: 0.4% (18.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (13)

**Calls:**
- `bound require` (13)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173264` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:100190` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320932` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getJSDocComment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92486` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:100058` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327233` | Self: 0.0% (0us) | Total: 2.7% (112.0ms) | Samples: 0

**Called by:**
- `iterate` (72)

**Calls:**
- `validateDescription` (72)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290350` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `hasTag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319490` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `getPreferredTagName` (1)

**Calls:**
- `some` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:21` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327244` | Self: 0.0% (0us) | Total: 0.2% (11.8ms) | Samples: 0

**Called by:**
- `iterate` (8)

**Calls:**
- `(anonymous)` (8)

### `parseIntermediateType`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314937` | Self: 0.0% (0us) | Total: 0.4% (18.3ms) | Samples: 0

**Called by:**
- `parseType` (11)

**Calls:**
- `tryParslets` (11)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:45765` | Self: 0.0% (0us) | Total: 0.1% (4.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289703` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317581` | Self: 0.0% (0us) | Total: 2.0% (81.9ms) | Samples: 0

**Called by:**
- `forEach` (52)

**Calls:**
- `cleanUpLastTag` (51)
- `cleanUpLastTag` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201893` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137882` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_addSchema`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:309` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `addSchema` (2)

**Calls:**
- `resolveIds` (1)
- `resolveIds` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332431` | Self: 0.0% (0us) | Total: 0.4% (19.4ms) | Samples: 0

**Called by:**
- `iterate` (13)

**Calls:**
- `(anonymous)` (13)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96619` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 37.0% (1.49s) | Samples: 0

**Called by:**
- `_loadBundle` (275)
- `(anonymous)` (49)
- `(anonymous)` (24)
- `(anonymous)` (24)
- `(anonymous)` (21)
- `(anonymous)` (21)
- `(anonymous)` (19)
- `(anonymous)` (15)
- `(anonymous)` (13)
- `(anonymous)` (11)
- `(anonymous)` (11)
- `(anonymous)` (9)
- `(anonymous)` (9)
- `(anonymous)` (9)
- `(anonymous)` (9)
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
- `(anonymous)` (5)
- `(anonymous)` (5)
- `patchAstUtils` (5)
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
- `getESLintCoreRule` (3)
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
- `getNodeSystem` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `require` (758)
- `anonymous` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:24` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172341` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164269` | Self: 0.0% (0us) | Total: 1.3% (54.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `Comparator` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:10` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `createSafeIterator`
`internal:primordials:14` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `internal:primordials` (1)

**Calls:**
- `freeze` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:237894` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/lib/picomatch.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290130` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:243782` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `fix10`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330345` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_execReport` (1)

**Calls:**
- `stringSplitFast` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318143` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `splitSpace` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:180796` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:277071` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/project-service/dist/index.js:17` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:192911` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4559` | Self: 0.0% (0us) | Total: 0.8% (33.4ms) | Samples: 0

**Called by:**
- `runPlugins` (22)

**Calls:**
- `create` (22)

### `_defineProperty`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260214` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `_toPropertyKey` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:195733` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320765` | Self: 0.0% (0us) | Total: 1.9% (80.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (7)
- `(anonymous)` (4)
- `checkTagName2` (4)
- `checkTagName` (4)
- `(anonymous)` (4)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `getPreferredTagName` (51)
- `cloneObject` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/visitor-keys/dist/visitor-keys.js:194` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `unionWith` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12521` | Self: 0.0% (0us) | Total: 0.1% (4.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `(anonymous)` (2)
- `createDebug` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint-community/eslint-utils/index.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91300` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:263719` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8202` | Self: 0.0% (0us) | Total: 1.3% (55.5ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (37)

**Calls:**
- `buildVisitorMap` (22)
- `buildVisitorMap` (14)
- `buildVisitorMap` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301099` | Self: 0.0% (0us) | Total: 0.2% (10.6ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `(anonymous)` (7)

### `parse`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:314927` | Self: 0.0% (0us) | Total: 1.8% (74.0ms) | Samples: 0

**Called by:**
- `parse2` (47)

**Calls:**
- `parseType` (47)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329060` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `flatIntoArrayWithCallback` (1)

**Calls:**
- `getTemplateTags` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336975` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `validNamepathParsing` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320889` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `filterTags` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322334` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:19` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `getParser4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318444` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `parse3` (1)

**Calls:**
- `getParser3` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201839` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164517` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `Range` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321771` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `generateNamedReferences` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321332` | Self: 0.0% (0us) | Total: 1.2% (51.4ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (22)
- `buildVisitorMap` (12)

**Calls:**
- `get lines` (34)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:673` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (1)
- `getAllComments` (1)

**Calls:**
- `_findLineIdx` (1)
- `_findLineIdx` (1)

### `nextTick`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `construct` (1)

**Calls:**
- `setup` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201903` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4682` | Self: 0.0% (0us) | Total: 0.5% (21.2ms) | Samples: 0

**Called by:**
- `runPlugins` (14)

**Calls:**
- `create` (12)
- `create` (1)
- `create` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/index.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/clear-caches.js:6` | Self: 0.0% (0us) | Total: 2.1% (87.3ms) | Samples: 0

**Called by:**
- `anonymous` (19)

**Calls:**
- `bound require` (19)

### `descriptionIsRedundant`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326954` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `areDocsInformative` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327231` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.1% (4.4ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `matchAll`
`[native code]` | Self: 0.0% (0us) | Total: 4.0% (163.5ms) | Samples: 0

**Called by:**
- `parseDescription` (59)
- `parseDescription` (49)

**Calls:**
- `get flags` (92)
- `esSpecIsRegExp` (11)
- `stringIncludesInternal` (5)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2348` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `_ensureDeclSymIndex` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330408` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318277` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `reduce` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96733` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317601` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `commentParserToESTree` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289654` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:223238` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330137` | Self: 0.0% (0us) | Total: 0.2% (11.5ms) | Samples: 0

**Called by:**
- `iterate` (8)

**Calls:**
- `(anonymous)` (8)

### `checkNonJsdoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326210` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `bound checkNonJsdoc` (2)

**Calls:**
- `reportings` (1)
- `reportings` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:288644` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328984` | Self: 0.0% (0us) | Total: 5.0% (204.9ms) | Samples: 0

**Called by:**
- `map` (135)

**Calls:**
- `parseComment` (77)
- `parseComment` (58)

### `Te`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `ge` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/index.js:3` | Self: 0.0% (0us) | Total: 0.1% (7.5ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `hasRejectValue`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333180` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:29` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `addMetaSchema` (2)

### `internal:streams/pipeline`
`internal:streams/pipeline:2` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289510` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322864` | Self: 0.0% (0us) | Total: 0.5% (20.2ms) | Samples: 0

**Called by:**
- `iterate` (13)

**Calls:**
- `maskExcludedContent` (7)
- `maskExcludedContent` (6)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:123` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `_normalizeSeverity` (1)

### `parse2`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317016` | Self: 0.0% (0us) | Total: 1.8% (74.0ms) | Samples: 0

**Called by:**
- `cleanUpLastTag` (47)

**Calls:**
- `parse` (47)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:237825` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

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

### `resolveIds`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:239` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_addSchema` (1)

**Calls:**
- `(anonymous)` (1)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:455` | Self: 0.0% (0us) | Total: 0.1% (7.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:128023` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228443` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `read`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316319` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `create` (1)
- `create` (1)

**Calls:**
- `stringSplitFast` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:198714` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `splitTextIntoWords`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326875` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `areDocsInformative` (1)

**Calls:**
- `flatIntoArrayWithCallback` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313114` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `get globalScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3938` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `_precomputeScopes` (2)
- `_precomputeScopes` (1)

### `reportings`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326192` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `checkNonJsdoc` (1)

**Calls:**
- `report` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289531` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/project-service/dist/createProjectService.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164442` | Self: 0.0% (0us) | Total: 1.3% (54.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:282898` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329215` | Self: 0.0% (0us) | Total: 0.1% (6.7ms) | Samples: 0

**Called by:**
- `iterate` (4)

**Calls:**
- `(anonymous)` (3)
- `concat` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138699` | Self: 0.0% (0us) | Total: 0.1% (4.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320821` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `some` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:293086` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183909` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `callIterator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321109` | Self: 0.0% (0us) | Total: 1.0% (43.9ms) | Samples: 0

**Called by:**
- `onNodeWithComment` (29)

**Calls:**
- `getIndentAndJSDoc` (29)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:48` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:195085` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:101899` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:325987` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12515` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `validateDescription`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330340` | Self: 0.0% (0us) | Total: 0.1% (5.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `some` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:7` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:288719` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getParser4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318438` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `parse3` (2)

**Calls:**
- `descriptionTokenizer` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:19` | Self: 0.0% (0us) | Total: 0.3% (13.3ms) | Samples: 0

**Called by:**
- `anonymous` (9)

**Calls:**
- `bound require` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332132` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/comparator.js:143` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164514` | Self: 0.0% (0us) | Total: 1.3% (54.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rule-tester/rule-tester.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/es2015.js:15` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301150` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `camelCase` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/parse-string.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1947` | Self: 0.0% (0us) | Total: 14.1% (569.5ms) | Samples: 0

**Called by:**
- `getTokenBefore` (375)

**Calls:**
- `_getAllTokens` (367)
- `_getAllTokens` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301177` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `map` (2)

**Calls:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329192` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `concat` (1)

### `Ae`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.5% (21.5ms) | Samples: 0

**Called by:**
- `parse` (14)

**Calls:**
- `_e` (14)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330454` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289570` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getParser4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318437` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `parse3` (1)

**Calls:**
- `nameTokenizer` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:336920` | Self: 0.0% (0us) | Total: 0.1% (4.2ms) | Samples: 0

**Called by:**
- `map` (3)

**Calls:**
- `(anonymous)` (3)

### `hasRejectValue`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333201` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `some` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92620` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320762` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getJsdocTagsDeep` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:127990` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320928` | Self: 0.0% (0us) | Total: 0.1% (7.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `(anonymous)` (3)
- `(anonymous)` (2)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330372` | Self: 0.0% (0us) | Total: 0.1% (5.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)
- `(anonymous)` (2)

**Calls:**
- `report` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:110317` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320241` | Self: 0.0% (0us) | Total: 0.1% (7.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)
- `(anonymous)` (2)

**Calls:**
- `isNameOrNamepathDefiningTag` (3)
- `isNameOrNamepathDefiningTag` (2)

### `validateDescription`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327223` | Self: 0.0% (0us) | Total: 2.7% (112.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (72)

**Calls:**
- `test` (72)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328149` | Self: 0.0% (0us) | Total: 0.1% (4.5ms) | Samples: 0

**Called by:**
- `filter` (3)

**Calls:**
- `some` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171015` | Self: 0.0% (0us) | Total: 0.0% (1.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329132` | Self: 0.0% (0us) | Total: 1.2% (51.4ms) | Samples: 0

**Called by:**
- `iterate` (33)

**Calls:**
- `Set` (27)
- `get` (5)
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333255` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `shouldReport` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318357` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `search` (1)

### `internal:stream`
`internal:stream:2` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:288648` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201865` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `fixer`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332422` | Self: 0.0% (0us) | Total: 0.2% (11.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (8)

**Calls:**
- `fix10` (2)
- `fix10` (2)
- `fix10` (2)
- `fix10` (1)
- `fix10` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322863` | Self: 0.0% (0us) | Total: 0.2% (9.9ms) | Samples: 0

**Called by:**
- `iterate` (6)

**Calls:**
- `maskCodeBlocks` (3)
- `maskCodeBlocks` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:100192` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/tinyglobby/dist/index.cjs:27` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:20` | Self: 0.0% (0us) | Total: 0.1% (6.0ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `bound require` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint-community/eslint-utils/node_modules/eslint-visitor-keys/dist/eslint-visitor-keys.cjs:315` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `freeze` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:48478` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `find`
`[native code]` | Self: 0.0% (0us) | Total: 0.5% (24.1ms) | Samples: 0

**Called by:**
- `getPreferredTagNameSimple` (15)
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (15)
- `(anonymous)` (1)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317920` | Self: 0.0% (0us) | Total: 5.7% (233.9ms) | Samples: 0

**Called by:**
- `getJSDocComment` (153)

**Calls:**
- `findJSDocComment` (137)
- `findJSDocComment` (9)
- `findJSDocComment` (2)
- `findJSDocComment` (1)
- `findJSDocComment` (1)
- `findJSDocComment` (1)
- `findJSDocComment` (1)
- `findJSDocComment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333401` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `shouldReport` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289612` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `match`
`[native code]` | Self: 0.0% (0us) | Total: 1.7% (69.7ms) | Samples: 0

**Called by:**
- `splitSpace` (18)
- `(anonymous)` (18)
- `splitCR` (9)
- `getRegexFromString` (1)

**Calls:**
- `[Symbol.match]` (46)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:42` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:276522` | Self: 0.0% (0us) | Total: 0.1% (6.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `(anonymous)` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320753` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `canSkip3` (1)

**Calls:**
- `isConstructor` (1)

### `hasRejectValue`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333154` | Self: 0.0% (0us) | Total: 0.0% (2.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)
- `hasRejectValue` (1)

**Calls:**
- `some` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333202` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `some` (1)

**Calls:**
- `some` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/prelude-ls/lib/index.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321402` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `getContexts` (1)

### `_e`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.6% (24.6ms) | Samples: 0

**Called by:**
- `Ae` (14)
- `(anonymous)` (2)

**Calls:**
- `Pe` (16)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:220` | Self: 0.0% (0us) | Total: 0.0% (3.8ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (3)

**Calls:**
- `_encodeSource` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:324240` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `read`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316317` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `create` (1)

**Calls:**
- `identifierRule` (1)

### `exec`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (1)

### `maskExcludedContent`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322832` | Self: 0.0% (0us) | Total: 0.2% (10.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (7)

**Calls:**
- `replace` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290028` | Self: 0.0% (0us) | Total: 1.0% (42.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (28)

**Calls:**
- `(anonymous)` (28)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289484` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/default-config.js:37` | Self: 0.0% (0us) | Total: 0.2% (9.2ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183944` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getInlineTags`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319573` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `getAllTags` (1)

**Calls:**
- `flatIntoArrayWithCallback` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313097` | Self: 0.0% (0us) | Total: 1.8% (75.3ms) | Samples: 0

**Called by:**
- `anonymous` (49)

**Calls:**
- `(anonymous)` (49)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:285704` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173071` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `onNodeWithComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321177` | Self: 0.0% (0us) | Total: 32.8% (1.32s) | Samples: 0

**Called by:**
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (826)

**Calls:**
- `callIterator` (770)
- `callIterator` (29)
- `callIterator` (22)
- `callIterator` (3)
- `callIterator` (1)
- `callIterator` (1)

### `search`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `/=(?!>)/` (1)

### `getParamName`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319228` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get typeAnnotation` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` | Self: 0.0% (0us) | Total: 0.2% (11.1ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:254635` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301196` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `set` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92619` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `findExpectedIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332165` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `fix10` (1)

**Calls:**
- `findIndex` (1)

### `hasReturnValue`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318854` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `hasReturnValue` (1)

**Calls:**
- `some` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334098` | Self: 0.0% (0us) | Total: 0.1% (4.6ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92697` | Self: 0.0% (0us) | Total: 0.2% (10.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (7)

**Calls:**
- `(anonymous)` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318180` | Self: 0.0% (0us) | Total: 0.6% (27.0ms) | Samples: 0

**Called by:**
- `parseSpec` (18)

**Calls:**
- `match` (18)

### `getValidRuntimeIdentifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329078` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `get` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:33` | Self: 0.0% (0us) | Total: 39.9% (1.61s) | Samples: 0

**Called by:**
- `(anonymous)` (49)
- `(anonymous)` (49)
- `(anonymous)` (40)
- `(anonymous)` (28)
- `(anonymous)` (28)
- `(anonymous)` (27)
- `(anonymous)` (25)
- `(anonymous)` (25)
- `(anonymous)` (25)
- `(anonymous)` (21)
- `(anonymous)` (21)
- `(anonymous)` (21)
- `(anonymous)` (20)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (6)
- `(anonymous)` (6)
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
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
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
- `(anonymous)` (44)
- `(anonymous)` (28)
- `(anonymous)` (27)
- `(anonymous)` (25)
- `(anonymous)` (25)
- `(anonymous)` (25)
- `(anonymous)` (21)
- `(anonymous)` (21)
- `(anonymous)` (21)
- `(anonymous)` (21)
- `(anonymous)` (13)
- `(anonymous)` (7)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (5)
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
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `internal:validators`
`internal:validators:2` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320895` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getNodeSystem`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:8278` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:58223` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8195` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (2)

**Calls:**
- `get source` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161363` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316297` | Self: 0.0% (0us) | Total: 0.2% (11.9ms) | Samples: 0

**Called by:**
- `parse2` (7)
- `parseNamePath` (1)

**Calls:**
- `read` (3)
- `read` (1)
- `read` (1)
- `read` (1)
- `read` (1)
- `read` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313083` | Self: 0.0% (0us) | Total: 1.3% (56.2ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:185313` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getESLintCoreRule` (1)

### `preserveJoiner`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318429` | Self: 0.0% (0us) | Total: 0.0% (3.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `join` (1)
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/getModifiers.js:38` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:38` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `__export` (1)

### `getDefaultTagStructureForMode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313576` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `getTagStructureForMode` (1)
- `setTagStructure` (1)

**Calls:**
- `Map` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:30` | Self: 0.0% (0us) | Total: 1.7% (69.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (7)

**Calls:**
- `(anonymous)` (6)
- `(anonymous)` (1)

### `_toPropertyKey`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260217` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_defineProperty` (1)

**Calls:**
- `_toPrimitive` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:257725` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `exemptSpeciaMethods`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320029` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `isConstructor` (1)
- `hasSchemaOption` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/convert.js:41` | Self: 0.0% (0us) | Total: 0.1% (7.7ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201929` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7692` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_resolveHandlers` (1)

### `getAncestors`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3698` | Self: 0.0% (0us) | Total: 0.2% (8.6ms) | Samples: 0

**Called by:**
- `getUtils` (6)

**Calls:**
- `unshift` (4)
- `_nodeViewRaw` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/convert.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329664` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `flatIntoArrayWithCallback` (2)

**Calls:**
- `filter` (2)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321263` | Self: 0.0% (0us) | Total: 3.8% (156.9ms) | Samples: 0

**Called by:**
- `_invokeFused` (102)

**Calls:**
- `(anonymous)` (100)
- `(anonymous)` (2)

### `checkNonJsdoc`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326196` | Self: 0.0% (0us) | Total: 15.5% (627.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (398)
- `bound checkNonJsdoc` (14)

**Calls:**
- `getNonJsdocComment` (396)
- `getNonJsdocComment` (16)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171769` | Self: 0.0% (0us) | Total: 2.2% (90.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (21)

**Calls:**
- `(anonymous)` (21)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:11` | Self: 0.0% (0us) | Total: 0.1% (7.3ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172431` | Self: 0.0% (0us) | Total: 2.3% (96.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (25)

**Calls:**
- `(anonymous)` (25)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173237` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getNonJsdocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317951` | Self: 0.0% (0us) | Total: 14.9% (603.7ms) | Samples: 0

**Called by:**
- `checkNonJsdoc` (396)

**Calls:**
- `findJSDocComment` (390)
- `findJSDocComment` (3)
- `findJSDocComment` (2)
- `findJSDocComment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:263751` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328992` | Self: 0.0% (0us) | Total: 0.1% (7.6ms) | Samples: 0

**Called by:**
- `flatIntoArrayWithCallback` (4)

**Calls:**
- `filter` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/es2018.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:40` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7919` | Self: 0.0% (0us) | Total: 6.0% (245.2ms) | Samples: 0

**Called by:**
- `runPlugins` (162)

**Calls:**
- `_invokeFused` (162)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236471` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:215830` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:189175` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `Ce`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.4% (18.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (12)

**Calls:**
- `Pe` (12)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:221581` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329658` | Self: 0.0% (0us) | Total: 2.3% (95.6ms) | Samples: 0

**Called by:**
- `iterate` (63)

**Calls:**
- `filter` (63)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320756` | Self: 0.0% (0us) | Total: 0.2% (10.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:237921` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328981` | Self: 0.0% (0us) | Total: 2.8% (115.0ms) | Samples: 0

**Called by:**
- `iterate` (75)

**Calls:**
- `filter` (75)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323796` | Self: 0.0% (0us) | Total: 0.2% (8.8ms) | Samples: 0

**Called by:**
- `iterate` (6)

**Calls:**
- `(anonymous)` (5)
- `(anonymous)` (1)

### `getPreferredTagNameSimple`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319457` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `getPreferredTagName` (1)

**Calls:**
- `entries` (1)

### `identifierRule`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316675` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `read` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:38` | Self: 0.0% (0us) | Total: 0.1% (7.7ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/index.js:18` | Self: 0.0% (0us) | Total: 2.2% (90.5ms) | Samples: 0

**Called by:**
- `anonymous` (21)

**Calls:**
- `bound require` (21)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/lib/picomatch.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `getTagStructureForMode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319664` | Self: 0.0% (0us) | Total: 0.1% (4.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `getDefaultTagStructureForMode` (1)
- `getDefaultTagStructureForMode` (1)
- `getDefaultTagStructureForMode` (1)

### `get kind`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2734` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `isConstructor` (1)

**Calls:**
- `_rawTokenText` (1)

### `setDeps`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326787` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `log` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330449` | Self: 0.0% (0us) | Total: 0.1% (5.4ms) | Samples: 0

**Called by:**
- `iterate` (4)

**Calls:**
- `validateDescription` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183953` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319115` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `hasValueOrExecutorHasNonEmptyResolveValue` (1)

**Calls:**
- `hasReturnValue` (1)

### `node:stream`
`node:stream:2` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318802` | Self: 0.0% (0us) | Total: 0.2% (11.3ms) | Samples: 0

**Called by:**
- `parseSpec` (7)

**Calls:**
- `(anonymous)` (7)

### `Se`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `Pe` (2)

**Calls:**
- `Ee` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326198` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `some` (1)

**Calls:**
- `trimStart` (1)

### `node:events`
`node:events:9` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170810` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_computeIdentifierName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4154` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_NodeView_LR` (1)

**Calls:**
- `_identAt` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92521` | Self: 0.0% (0us) | Total: 0.1% (5.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `(anonymous)` (4)

### `hasATag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319600` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `some` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:261166` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201829` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:177189` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getESLintCoreRule` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/default-config.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:209129` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getAllComments`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3465` | Self: 0.0% (0us) | Total: 0.4% (18.6ms) | Samples: 0

**Called by:**
- `_getTokensAndCommentsMerged` (13)

**Calls:**
- `commentsInRange` (11)
- `commentsInRange` (1)
- `commentsInRange` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188344` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:249343` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:497` | Self: 0.0% (0us) | Total: 0.1% (7.6ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `patchAstUtils` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:44` | Self: 0.0% (0us) | Total: 0.5% (23.4ms) | Samples: 0

**Called by:**
- `anonymous` (15)

**Calls:**
- `bound require` (15)

### `(anonymous)`
`/private/tmp/prof_jsdoc.js:7` | Self: 0.0% (0us) | Total: 13.0% (527.8ms) | Samples: 0

**Called by:**
- `parseModule` (275)

**Calls:**
- `bundleRulesFor` (275)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:53` | Self: 0.0% (0us) | Total: 0.1% (4.2ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `processTicksAndRejections`
`[native code]` | Self: 0.0% (0us) | Total: 86.4% (3.48s) | Samples: 0

**Calls:**
- `(anonymous)` (2244)

### `isNameOrNamepathDefiningTag`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319671` | Self: 0.0% (0us) | Total: 0.1% (4.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `ensureMap` (2)
- `ensureMap` (1)

### `y`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.1% (4.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `(anonymous)` (3)

### `internal:streams/compose`
`internal:streams/compose:2` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:22` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228543` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201884` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:271689` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `parse` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2482` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `test` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295641` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `toLocaleLowerCase` (1)

### `internal:streams/operators`
`internal:streams/operators:2` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:54127` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/Scope.js:38` | Self: 0.0% (0us) | Total: 0.3% (13.0ms) | Samples: 0

**Called by:**
- `anonymous` (9)

**Calls:**
- `bound require` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334229` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `canSkip5` (1)
- `canSkip5` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `findJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317888` | Self: 0.0% (0us) | Total: 0.5% (22.8ms) | Samples: 0

**Called by:**
- `findJSDocComment` (15)

**Calls:**
- `getDecorator` (15)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:22` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:180840` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320415` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `join` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:335666` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `report` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320789` | Self: 0.0% (0us) | Total: 0.2% (11.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)
- `(anonymous)` (2)
- `canSkip` (1)
- `canSkip4` (1)
- `canSkip5` (1)

**Calls:**
- `(anonymous)` (8)

### `internal:primordials`
`internal:primordials:50` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `createSafeIterator` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318449` | Self: 0.0% (0us) | Total: 4.4% (179.2ms) | Samples: 0

**Called by:**
- `parse3` (81)

**Calls:**
- `parseSource` (18)
- `parseSource` (15)
- `parseSource` (11)
- `parseSource` (11)
- `parseSource` (9)
- `parseSource` (5)
- `parseSource` (3)
- `parseSource` (2)
- `parseSource` (2)
- `parseSource` (1)
- `parseSource` (1)
- `parseSource` (1)
- `parseSource` (1)
- `parseSource` (1)

### `node:util`
`node:util:2` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:192876` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321235` | Self: 0.0% (0us) | Total: 0.1% (4.3ms) | Samples: 0

**Called by:**
- `_invokeFused` (2)
- `_invokeFused` (1)

**Calls:**
- `onNodeAllNodes` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:15` | Self: 0.0% (0us) | Total: 0.1% (7.3ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:966` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `get value` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `reportings`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326185` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `checkNonJsdoc` (1)

**Calls:**
- `report` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/file-report.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96638` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `Writable`
`internal:streams/writable:196` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `WriteStream` (1)

**Calls:**
- `construct` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290205` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` | Self: 0.0% (0us) | Total: 5.6% (226.0ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (149)

**Calls:**
- `parse` (149)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320741` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `getFunctionParameterNames` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330382` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `some` (2)

**Calls:**
- `report` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172353` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `isConstructor`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319996` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `exemptSpeciaMethods` (1)
- `(anonymous)` (1)

**Calls:**
- `get kind` (1)
- `get kind` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201874` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109708` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:288753` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2851` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `get globalScope` (2)

**Calls:**
- `commentsInRange` (1)
- `commentsInRange` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289625` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320865` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `shouldReport` (1)

**Calls:**
- `hasValueOrExecutorHasNonEmptyResolveValue` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:20` | Self: 0.0% (0us) | Total: 0.4% (16.9ms) | Samples: 0

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

### `(anonymous)`
`/private/tmp/prof_jsdoc.js:10` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `readFileSync` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313051` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:175347` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:51201` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/getWatchProgramsForProjects.js:45` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318291` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `stringSplitFast` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:490` | Self: 0.0% (0us) | Total: 0.2% (10.6ms) | Samples: 0

**Called by:**
- `parseSource` (3)

**Calls:**
- `CfgGraph` (2)
- `CfgGraph` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/visitor-keys/dist/index.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:197260` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320733` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289636` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334095` | Self: 0.0% (0us) | Total: 0.1% (6.6ms) | Samples: 0

**Called by:**
- `iterate` (4)

**Calls:**
- `canSkip4` (3)
- `canSkip4` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96576` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `toggleFence`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318099` | Self: 0.0% (0us) | Total: 1.0% (40.9ms) | Samples: 0

**Called by:**
- `parseBlock` (26)

**Calls:**
- `(anonymous)` (26)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:72` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330546` | Self: 0.0% (0us) | Total: 0.1% (4.4ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `(anonymous)` (2)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290132` | Self: 0.0% (0us) | Total: 0.1% (4.2ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:272045` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `parse` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:198706` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:218589` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/getModifiers.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/ast-converter.js:4` | Self: 0.0% (0us) | Total: 0.2% (9.0ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171394` | Self: 0.0% (0us) | Total: 2.2% (90.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (21)

**Calls:**
- `bound require` (21)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:195095` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289556` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5023` | Self: 0.0% (0us) | Total: 16.2% (656.1ms) | Samples: 0

**Called by:**
- `walkNodes` (432)

**Calls:**
- `bound ` (358)
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (74)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328182` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `Program:exit` (2)

**Calls:**
- `report` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/rules.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321227` | Self: 0.0% (0us) | Total: 4.6% (189.4ms) | Samples: 0

**Called by:**
- `_invokeFused` (74)
- `_invokeFused` (48)
- `_invokeFused` (2)
- `invokeHandlersWithNode` (1)

**Calls:**
- `getJSDocComment` (123)
- `getJSDocComment` (1)
- `getJSDocComment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:187590` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getRegexFromString`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320046` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `match` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201925` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` | Self: 0.0% (0us) | Total: 0.0% (3.8ms) | Samples: 0

**Called by:**
- `parseSource` (3)

**Calls:**
- `encodeInto` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330474` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `some` (1)

### `fix10`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332417` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `fixer` (2)

**Calls:**
- `createTokens` (1)
- `createTokens` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318146` | Self: 0.0% (0us) | Total: 0.1% (4.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `trimEnd` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:168170` | Self: 0.0% (0us) | Total: 1.8% (75.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (49)

**Calls:**
- `bound require` (49)

### `preserveJoiner`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318426` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `endsWith` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236594` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/dom.js:9` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:254650` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/getModifiers.js:39` | Self: 0.0% (0us) | Total: 0.1% (4.3ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `fix10`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332410` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `fixer` (2)

**Calls:**
- `findExpectedIndex` (1)
- `findExpectedIndex` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92623` | Self: 0.0% (0us) | Total: 0.1% (5.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `(anonymous)` (4)

### `getFunctionParameterNames`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319363` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `map` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:332921` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:146402` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320330` | Self: 0.0% (0us) | Total: 0.4% (19.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (13)

**Calls:**
- `report` (13)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289747` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `fix10`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330344` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_execReport` (1)

**Calls:**
- `test` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201850` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161605` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:136029` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/ClassVisitor.js:6` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320331` | Self: 0.0% (0us) | Total: 0.2% (11.6ms) | Samples: 0

**Called by:**
- `_execReport` (8)

**Calls:**
- `fixer` (8)

### `fix10`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330347` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_execReport` (1)

**Calls:**
- `RegExp` (1)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4166` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_nodeViewRaw` (1)

**Calls:**
- `_computeIdentifierName` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:9` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289535` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` | Self: 0.0% (0us) | Total: 6.3% (256.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (165)

**Calls:**
- `parseSource` (149)
- `parseSource` (13)
- `parseSource` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7265` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_getOrBuildPlan` (1)

### `areDocsInformative`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326859` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `descriptionIsRedundant` (2)

**Calls:**
- `splitTextIntoWords` (1)
- `splitTextIntoWords` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:5968` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:7` | Self: 0.0% (0us) | Total: 0.1% (6.9ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `canSkip4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334089` | Self: 0.0% (0us) | Total: 0.1% (5.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161552` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:180831` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12342` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188300` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `get lines`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3580` | Self: 0.0% (0us) | Total: 1.2% (51.4ms) | Samples: 0

**Called by:**
- `create` (34)

**Calls:**
- `regExpSplitFast` (34)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:327258` | Self: 0.0% (0us) | Total: 0.5% (20.2ms) | Samples: 0

**Called by:**
- `iterate` (13)

**Calls:**
- `(anonymous)` (13)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:911` | Self: 0.0% (0us) | Total: 0.2% (10.1ms) | Samples: 0

**Called by:**
- `get` (7)

**Calls:**
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:90428` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96800` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109709` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301163` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `map` (2)

**Calls:**
- `RegExp` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:323801` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `checkTagName2`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334406` | Self: 0.0% (0us) | Total: 0.1% (6.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `(anonymous)` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rule-tester/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 13.5% (546.2ms) | Samples: 0

**Calls:**
- `parseModule` (287)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320894` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `filterTags` (1)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 36.9% (1.48s) | Samples: 0

**Called by:**
- `bound require` (758)

**Calls:**
- `anonymous` (758)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173079` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:51143` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:326976` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `descriptionIsRedundant` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:218541` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173249` | Self: 0.0% (0us) | Total: 2.3% (96.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (25)

**Calls:**
- `(anonymous)` (25)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295623` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/api.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329252` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190758` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getESLintCoreRule` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:189918` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172348` | Self: 0.0% (0us) | Total: 0.0% (1.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:182210` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/analyze.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260567` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:56` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:1664` | Self: 0.0% (0us) | Total: 0.0% (3.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334719` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `stringify` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6952` | Self: 0.0% (0us) | Total: 11.6% (472.0ms) | Samples: 0

**Called by:**
- `walkNodes` (305)

**Calls:**
- `invokeHandlersWithNode` (305)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:277069` | Self: 0.0% (0us) | Total: 0.1% (8.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `(anonymous)` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:257699` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313304` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:48398` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320859` | Self: 0.0% (0us) | Total: 0.1% (4.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `getTagStructureForMode` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:296352` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6928` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `walkNodes` (2)

**Calls:**
- `get value` (1)
- `get value` (1)

### `useColors`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12454` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `createDebug` (1)

**Calls:**
- `(anonymous)` (1)

### `_traverse`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/json-schema-traverse/index.js:65` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_traverse` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:101904` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `maskExcludedContent`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322831` | Self: 0.0% (0us) | Total: 0.2% (9.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `RegExp` (6)

### `shouldReport`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333399` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172349` | Self: 0.0% (0us) | Total: 2.2% (90.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (21)

**Calls:**
- `(anonymous)` (21)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260359` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:322336` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `stringSplitFast` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313039` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295624` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:47927` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313017` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:221585` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289731` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `g`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.5% (23.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (15)

**Calls:**
- `parse` (15)

### `construct`
`internal:streams/destroy:124` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `Writable` (1)

**Calls:**
- `nextTick` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170728` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333682` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `(anonymous)` (2)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289582` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201847` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201816` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `internal:shared`
`internal:shared:2` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301169` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `addPolyfillToken` (1)

### `shouldReport`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333253` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `hasRejectValue` (2)

### `Pe`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 1.0% (42.9ms) | Samples: 0

**Called by:**
- `_e` (16)
- `Ce` (12)

**Calls:**
- `we` (26)
- `Se` (2)

### `getPreferredTagName`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319516` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `forEachPreferredTag` (1)

**Calls:**
- `hasTag` (1)

### `_fromRunnerReport`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:205` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `map` (2)

**Calls:**
- `get loc` (1)
- `get loc` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:188335` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/convert.js:40` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:335396` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `some` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321135` | Self: 0.0% (0us) | Total: 0.8% (33.1ms) | Samples: 0

**Called by:**
- `every` (22)

**Calls:**
- `(anonymous)` (15)
- `(anonymous)` (4)
- `(anonymous)` (2)
- `(anonymous)` (1)

### `parseComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318819` | Self: 0.0% (0us) | Total: 0.1% (5.6ms) | Samples: 0

**Called by:**
- `getIndentAndJSDoc` (2)
- `(anonymous)` (1)

**Calls:**
- `getTokenizers` (2)
- `getTokenizers` (1)

### `addSchema`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:137` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `addMetaSchema` (2)

**Calls:**
- `_addSchema` (2)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4190` | Self: 0.0% (0us) | Total: 0.8% (33.0ms) | Samples: 0

**Called by:**
- `report` (19)
- `report` (2)
- `(anonymous)` (1)

**Calls:**
- `_execReport` (19)
- `_execReport` (1)
- `_execReport` (1)
- `_execReport` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138507` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313105` | Self: 0.0% (0us) | Total: 2.9% (118.0ms) | Samples: 0

**Called by:**
- `anonymous` (40)

**Calls:**
- `(anonymous)` (40)

### `bundleRulesFor`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-loader.js:59` | Self: 0.0% (0us) | Total: 13.0% (527.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (275)

**Calls:**
- `_loadBundle` (275)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:119338` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `iterate`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321046` | Self: 0.0% (0us) | Total: 1.2% (49.1ms) | Samples: 0

**Called by:**
- `callIterator` (21)
- `checkJsdoc` (12)

**Calls:**
- `getUtils` (13)
- `getUtils` (9)
- `getUtils` (7)
- `getUtils` (1)
- `getUtils` (1)
- `getUtils` (1)
- `getUtils` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_traverse`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/json-schema-traverse/index.js:76` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `_traverse` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:175338` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320899` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getAllTags` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171548` | Self: 0.0% (0us) | Total: 2.2% (90.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (21)

**Calls:**
- `(anonymous)` (21)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:39` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:319496` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `filter` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:137945` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/parse-string.js:113` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:225628` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96433` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183111` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290382` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:337493` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `coerce` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1027` | Self: 0.0% (0us) | Total: 0.2% (10.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)
- `getValidRuntimeIdentifiers` (2)

**Calls:**
- `_ensureVarsSet` (7)

### `callIterator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321100` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `onNodeWithComment` (3)

**Calls:**
- `getBasicUtils` (2)
- `getBasicUtils` (1)

### `we`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.9% (40.1ms) | Samples: 0

**Called by:**
- `Pe` (26)

**Calls:**
- `ke` (26)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333589` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:110315` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:18` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183103` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8203` | Self: 0.0% (0us) | Total: 78.5% (3.16s) | Samples: 0

**Called by:**
- `_lintSourceOne` (2036)

**Calls:**
- `walkNodes` (1527)
- `walkNodes` (307)
- `walkNodes` (162)
- `walkNodes` (10)
- `walkNodes` (7)
- `walkNodes` (6)
- `walkNodes` (3)
- `walkNodes` (3)
- `walkNodes` (3)
- `walkNodes` (2)
- `walkNodes` (2)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:320946` | Self: 0.0% (0us) | Total: 1.8% (72.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (13)
- `(anonymous)` (8)
- `(anonymous)` (6)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `forEachPreferredTag` (47)

### `invokeHandlersWithNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6890` | Self: 0.0% (0us) | Total: 11.6% (472.0ms) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (305)

**Calls:**
- `bound checkJsdoc` (302)
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (1)
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (1)
- `bound checkNonJsdoc` (1)

### `getJSDocComment`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318033` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (1)

**Calls:**
- `get` (1)

### `(anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 86.5% (3.49s) | Samples: 0

**Called by:**
- `processTicksAndRejections` (2244)
- `useColors` (1)

**Calls:**
- `_lintSourceOne` (2076)
- `_lintSourceOne` (165)
- `_lintSourceOne` (2)
- `async _resolveConfigImpl` (1)
- `WriteStream` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:317603` | Self: 0.0% (0us) | Total: 0.1% (5.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `(anonymous)` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/index.js:12` | Self: 0.0% (0us) | Total: 0.1% (7.5ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/predicates.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313117` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:328983` | Self: 0.0% (0us) | Total: 5.0% (204.9ms) | Samples: 0

**Called by:**
- `iterate` (135)

**Calls:**
- `map` (135)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:330131` | Self: 0.0% (0us) | Total: 0.1% (4.5ms) | Samples: 0

**Called by:**
- `iterate` (3)

**Calls:**
- `(anonymous)` (3)

### `onNodeAllNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321188` | Self: 0.0% (0us) | Total: 0.1% (4.3ms) | Samples: 0

**Called by:**
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (3)

**Calls:**
- `callIterator` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:261100` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201878` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_getFullPath`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:215` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `resolveIds` (1)

**Calls:**
- `serialize` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333346` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `iterate` (1)

**Calls:**
- `canSkip2` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172343` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `canSkip4`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:334085` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1544` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (1)

**Calls:**
- `_nodesFromRange` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289663` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:293430` | Self: 0.0% (0us) | Total: 0.9% (36.6ms) | Samples: 0

**Called by:**
- `anonymous` (24)

**Calls:**
- `bound require` (24)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5035` | Self: 0.0% (0us) | Total: 9.5% (386.5ms) | Samples: 0

**Called by:**
- `walkNodes` (255)

**Calls:**
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (164)
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (48)
- `bound ` (41)
- `(anonymous)` (1)
- `ClassDeclaration, ClassExpression, FunctionDeclaration, FunctionExpression, ArrowFunctionExpression, MethodDefinition, PropertyDefinition, AccessorProperty, Property, VariableDeclaration, ExportNamedDeclaration, ExportDefaultDeclaration, ExportAllDeclaration, ExportSpecifier, ImportDeclaration, ObjectExpression, ExpressionStatement, AssignmentPattern, ReturnStatement, ObjectProperty, ClassProperty, TSInterfaceDeclaration, TSTypeAliasDeclaration, TSEnumDeclaration, TSEnumMember, TSDeclareFunction, TSEmptyBodyFunctionExpression, TSFunctionType, TSPropertySignature, TSMethodSignature, TSCallSignatureDeclaration, TSConstructSignatureDeclaration, TSIndexSignature, TSAbstractMethodDefinition, TSAbstractPropertyDefinition, TSAbstractAccessorProperty, TSModuleDeclaration` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:318128` | Self: 0.0% (0us) | Total: 0.5% (22.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (15)

**Calls:**
- `splitSpace` (13)
- `splitSpace` (2)

### `read`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:316311` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `create` (1)

**Calls:**
- `/^\s*\n\s*/v` (1)

### `(anonymous)`
`/private/tmp/prof_jsdoc.js:2` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:192920` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `serialize`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js:1012` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_getFullPath` (1)

**Calls:**
- `test` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:179625` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `canSkip`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:333223` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138272` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:337704` | Self: 0.0% (0us) | Total: 1.0% (42.1ms) | Samples: 0

**Called by:**
- `anonymous` (28)

**Calls:**
- `(anonymous)` (28)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/index.js:3` | Self: 0.0% (0us) | Total: 0.4% (16.9ms) | Samples: 0

**Called by:**
- `anonymous` (11)

**Calls:**
- `bound require` (11)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:329663` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `iterate` (2)

**Calls:**
- `flatMap` (1)
- `flatIntoArrayWithCallback` (1)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 41.4% | 1.67s | `[native code]` |
| 30.2% | 1.22s | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 23.8% | 963.5ms | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 2.9% | 117.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.6% | 27.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.4% | 17.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.0% | 1.8ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/visitor-keys/node_modules/eslint-visitor-keys/dist/eslint-visitor-keys.cjs` |
| 0.0% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/node-utils.js` |
| 0.0% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/getModifiers.js` |
| 0.0% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js` |
| 0.0% | 1.5ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.5ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js` |
| 0.0% | 1.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/api.js` |
| 0.0% | 1.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js` |
| 0.0% | 1.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/useProgramFromProjectService.js` |
| 0.0% | 1.2ms | `internal:streams/destroy` |
