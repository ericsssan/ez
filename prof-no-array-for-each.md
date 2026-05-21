# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 2.13s | 1386 | 1.0ms | 466 |

**Top 10:** `parse` 10.3%, `_makeToken` 10.3%, `indexedByProp` 5.1%, `_makeToken` 4.8%, `walkNodes` 3.8%, `anonymous` 3.3%, `isFunctionParametersSafeToFix` 2.3%, `copyDataProperties` 1.9%, `isNotReference` 1.9%, `_makeToken` 1.8%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 10.3% | 220.0ms | 10.3% | 220.0ms | `parse` | `[native code]` |
| 10.3% | 219.7ms | 10.3% | 219.7ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1300` |
| 5.1% | 110.4ms | 5.2% | 111.7ms | `indexedByProp` | `/Users/ericsan/Development/OpenSource/Ez/js/rewrite-helpers.js:95` |
| 4.8% | 104.0ms | 4.8% | 104.0ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1288` |
| 3.8% | 82.3ms | 33.3% | 710.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7568` |
| 3.3% | 70.7ms | 19.1% | 407.1ms | `anonymous` | `[native code]` |
| 2.3% | 50.3ms | 2.3% | 50.3ms | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:302` |
| 1.9% | 41.5ms | 1.9% | 41.5ms | `copyDataProperties` | `[native code]` |
| 1.9% | 41.1ms | 3.6% | 77.7ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:3` |
| 1.8% | 39.8ms | 2.5% | 54.3ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1285` |
| 1.8% | 39.1ms | 1.8% | 39.1ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4045` |
| 1.6% | 36.1ms | 1.6% | 36.1ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:241` |
| 1.6% | 35.0ms | 1.6% | 35.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7703` |
| 1.5% | 33.5ms | 1.5% | 33.5ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1260` |
| 1.4% | 31.6ms | 1.4% | 31.6ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4109` |
| 1.3% | 28.1ms | 1.3% | 28.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7230` |
| 1.2% | 25.9ms | 1.2% | 25.9ms | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:560` |
| 1.1% | 25.3ms | 2.2% | 47.9ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1975` |
| 1.1% | 24.4ms | 1.1% | 24.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7805` |
| 1.1% | 24.2ms | 1.1% | 24.2ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1292` |
| 1.0% | 22.9ms | 1.0% | 22.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7234` |
| 1.0% | 22.0ms | 63.7% | 1.35s | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:73` |
| 0.9% | 20.7ms | 0.9% | 20.7ms | `isReferenceIdentifier` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:149` |
| 0.9% | 20.6ms | 100.0% | 2.24s | `(anonymous)` | `[native code]` |
| 0.9% | 20.5ms | 0.9% | 20.5ms | `_computeIdentifierName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.8% | 18.9ms | 8.2% | 176.8ms | `isReferenceIdentifier` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:158` |
| 0.8% | 18.5ms | 0.8% | 18.5ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4111` |
| 0.8% | 17.9ms | 12.3% | 263.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4167` |
| 0.8% | 17.8ms | 5.5% | 119.3ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4117` |
| 0.7% | 15.2ms | 0.7% | 15.2ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1228` |
| 0.6% | 14.4ms | 0.6% | 14.4ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:822` |
| 0.6% | 14.4ms | 0.6% | 14.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4157` |
| 0.6% | 14.0ms | 0.6% | 14.0ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1264` |
| 0.6% | 13.6ms | 21.6% | 462.3ms | `_getAllTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1932` |
| 0.5% | 12.5ms | 0.5% | 12.5ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2704` |
| 0.5% | 12.2ms | 0.5% | 12.2ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:668` |
| 0.5% | 11.7ms | 0.5% | 11.7ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.5% | 11.3ms | 2.2% | 47.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2213` |
| 0.5% | 11.0ms | 0.5% | 12.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:627` |
| 0.4% | 10.4ms | 0.4% | 10.4ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4056` |
| 0.4% | 10.3ms | 0.4% | 10.3ms | `indexedByProp` | `/Users/ericsan/Development/OpenSource/Ez/js/rewrite-helpers.js:96` |
| 0.4% | 10.3ms | 0.4% | 10.3ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:867` |
| 0.4% | 9.9ms | 0.4% | 9.9ms | `create` | `[native code]` |
| 0.4% | 9.8ms | 0.4% | 9.8ms | `defineProperty` | `[native code]` |
| 0.4% | 9.7ms | 0.4% | 9.7ms | `getRange` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3834` |
| 0.4% | 9.5ms | 0.4% | 9.5ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1977` |
| 0.4% | 8.5ms | 0.4% | 8.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:626` |
| 0.3% | 8.4ms | 0.3% | 8.4ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4200` |
| 0.3% | 8.2ms | 0.3% | 8.2ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1202` |
| 0.3% | 7.9ms | 1.3% | 27.7ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:917` |
| 0.3% | 7.9ms | 0.3% | 7.9ms | `_getAllTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1933` |
| 0.3% | 7.8ms | 0.3% | 7.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7530` |
| 0.3% | 7.7ms | 0.3% | 7.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1203` |
| 0.3% | 7.7ms | 0.3% | 7.7ms | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:31` |
| 0.3% | 7.7ms | 0.3% | 7.7ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.3% | 7.5ms | 8.9% | 190.2ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:434` |
| 0.3% | 7.5ms | 1.4% | 30.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1212` |
| 0.3% | 7.2ms | 0.3% | 7.2ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:406` |
| 0.3% | 7.2ms | 0.3% | 7.2ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:629` |
| 0.3% | 7.2ms | 0.5% | 11.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7735` |
| 0.3% | 6.9ms | 0.3% | 6.9ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4057` |
| 0.3% | 6.5ms | 2.5% | 54.1ms | `get arguments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1915` |
| 0.2% | 6.1ms | 0.2% | 6.1ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4205` |
| 0.2% | 6.0ms | 4.3% | 92.4ms | `parseModule` | `[native code]` |
| 0.2% | 5.9ms | 0.2% | 5.9ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4461` |
| 0.2% | 5.7ms | 0.2% | 5.7ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 5.5ms | 0.2% | 5.5ms | `decode` | `[native code]` |
| 0.2% | 5.5ms | 0.2% | 5.5ms | `moduleDeclarationInstantiation` | `[native code]` |
| 0.2% | 4.9ms | 39.8% | 848.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7767` |
| 0.2% | 4.9ms | 0.2% | 4.9ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4081` |
| 0.2% | 4.9ms | 0.4% | 10.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7736` |
| 0.2% | 4.9ms | 0.3% | 6.4ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:55` |
| 0.2% | 4.7ms | 0.2% | 4.7ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 4.7ms | 0.8% | 17.3ms | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:42` |
| 0.2% | 4.6ms | 0.2% | 4.6ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 4.6ms | 0.3% | 8.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7740` |
| 0.2% | 4.5ms | 0.2% | 4.5ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1230` |
| 0.2% | 4.5ms | 0.2% | 4.5ms | `get params` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2581` |
| 0.2% | 4.4ms | 0.2% | 4.4ms | `isMemberExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:16` |
| 0.2% | 4.4ms | 0.2% | 4.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1204` |
| 0.2% | 4.3ms | 0.2% | 4.3ms | `get` | `[native code]` |
| 0.1% | 3.4ms | 0.1% | 3.4ms | `get arguments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1904` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `encodeInto` | `[native code]` |
| 0.1% | 3.3ms | 0.6% | 13.0ms | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:303` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `getNodeByRangeIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3796` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1213` |
| 0.1% | 3.2ms | 0.2% | 4.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7540` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `getTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1414` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `indexedByProp` | `/Users/ericsan/Development/OpenSource/Ez/js/rewrite-helpers.js:94` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js` |
| 0.1% | 3.1ms | 0.2% | 4.6ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:60` |
| 0.1% | 3.0ms | 1.4% | 31.6ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2321` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2178` |
| 0.1% | 3.0ms | 0.2% | 4.5ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:52` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `_computeIdentifierName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4096` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4180` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `test` | `[native code]` |
| 0.1% | 2.9ms | 0.3% | 7.3ms | `isMemberExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:66` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 2.8ms | 6.0% | 128.1ms | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:299` |
| 0.1% | 2.8ms | 0.2% | 6.0ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1717` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1401` |
| 0.1% | 2.7ms | 85.5% | 1.82s | `generatorResume` | `[native code]` |
| 0.1% | 2.7ms | 0.1% | 4.0ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2855` |
| 0.1% | 2.5ms | 0.1% | 2.5ms | `getNodeByRangeIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3806` |
| 0.1% | 2.5ms | 0.4% | 9.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7738` |
| 0.1% | 2.4ms | 0.1% | 2.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7528` |
| 0.0% | 1.8ms | 0.1% | 3.2ms | `camelCase` | `/Users/ericsan/node_modules/change-case/dist/index.js:60` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/compat-transpiler/runtime/index.js` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `stringSplitFast` | `[native code]` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2854` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `isMemberExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:67` |
| 0.0% | 1.8ms | 0.1% | 3.5ms | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:310` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get key` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3158` |
| 0.0% | 1.7ms | 2.0% | 42.7ms | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:53` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `RegExp` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:610` |
| 0.0% | 1.7ms | 0.1% | 3.3ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1187` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get end` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3271` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7731` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2239` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `arrayIteratorNextHelper` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2778` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:418` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.2% | 5.1ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:53` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_tokType` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `extendFixRange` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/fix/extend-fix-range.js:9` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `join` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `slice` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_tokType` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:602` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getNodeByRangeIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3797` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isMemberExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:25` |
| 0.0% | 1.6ms | 0.6% | 14.2ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:624` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getForOfLoopHeadText` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:101` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get key` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3159` |
| 0.0% | 1.6ms | 0.6% | 13.0ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:625` |
| 0.0% | 1.6ms | 0.4% | 9.7ms | `isMemberExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:39` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7834` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:66` |
| 0.0% | 1.6ms | 0.7% | 15.2ms | `removeParentheses` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/fix/remove-parentheses.js:15` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1864` |
| 0.0% | 1.6ms | 0.1% | 2.8ms | `replaceReturnStatement` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:133` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1192` |
| 0.0% | 1.5ms | 0.1% | 2.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7806` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4083` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/node_modules/debug/src/node.js:124` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.1% | 3.1ms | `readFileSync` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getLocFromIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3649` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get arguments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1910` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:429` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:914` |
| 0.0% | 1.5ms | 0.1% | 3.0ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2197` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `ez_ffi_token_idx_at_or_before` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `Uint8Array` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:87` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(module)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:119` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `[Symbol.split]` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:34` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `isMemberExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:43` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `ReadStream` | `internal:fs/streams` |
| 0.0% | 1.5ms | 0.4% | 9.3ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:56` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get computed` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1995` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_isOptionalTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:428` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `at` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `fixSpaceAroundKeyword` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/fix/fix-space-around-keywords.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:72` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:62` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `charCodeAt` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isFixable` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:335` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 4.1% | 88.2ms | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:46` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2233` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:25` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:5` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2229` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6954` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_rangeOf` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4009` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4927` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/node_modules/change-case/dist/index.js:179` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6956` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2779` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `split` | `/Users/ericsan/node_modules/change-case/dist/index.js:20` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1971` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2325` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get callee` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `Symbol.iterator` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2323` |
| 0.0% | 1.3ms | 2.9% | 61.9ms | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:62` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `isReferenceIdentifier` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `/[\\/]eslint-plugin-unicorn[\\/]rules[\\/]rule[\\/]unicorn-listeners\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-switch\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-json-parse-buffer\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]consistent-empty-array-spread\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]consistent-assert\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-useless-switch-case\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-object-from-entries\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-export-from\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-import-meta-properties\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-thenable\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-array-reduce\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-process-exit\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-single-call\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-array-callback-reference\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-string-slice\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-nested-ternary\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-console-spaces\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-global-this\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]consistent-existence-index-check\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-array-flat\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-prototype-methods\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-invalid-fetch-options\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-array-for-each\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-await-in-promise-methods\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-useless-length-check\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-modern-math-apis\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-abusive-eslint-disable\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-regexp-test\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-date-now\.js$/` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/index.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1962` |
| 0.0% | 1.3ms | 0.7% | 15.1ms | `map` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get arguments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1927` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(module)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/filename-case.js:20` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:800` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1193` |
| 0.0% | 1.2ms | 25.8% | 550.6ms | `next` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/node_modules/caniuse-lite/data/agents.js:1` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:607` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `toLocaleLowerCase` | `[native code]` |
| 0.0% | 1.2ms | 0.2% | 5.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2192` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `addPolyfillToken` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:47` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3339` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_isStatementTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:72` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `dlopen` | `[native code]` |
| 0.0% | 1.1ms | 0.0% | 1.1ms | `_intern` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:382` |
| 0.0% | 1.0ms | 3.7% | 79.0ms | `isCallExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:100` |
| 0.0% | 1.0ms | 0.0% | 1.0ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4112` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 100.0% | 2.24s | 0.9% | 20.6ms | `(anonymous)` | `[native code]` |
| 93.7% | 1.99s | 0.0% | 0us | `processTicksAndRejections` | `[native code]` |
| 85.5% | 1.82s | 0.1% | 2.7ms | `generatorResume` | `[native code]` |
| 82.9% | 1.76s | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:274` |
| 82.5% | 1.76s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8051` |
| 63.8% | 1.36s | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4940` |
| 63.7% | 1.35s | 1.0% | 22.0ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:73` |
| 39.8% | 848.5ms | 0.2% | 4.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7767` |
| 33.3% | 710.2ms | 3.8% | 82.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7568` |
| 28.5% | 608.6ms | 0.0% | 0us | `_drainAndReport` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:84` |
| 28.5% | 608.6ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4132` |
| 28.5% | 608.6ms | 0.0% | 0us | `_drainAndReport` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:92` |
| 28.4% | 606.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-rule-fixer.js:37` |
| 28.4% | 606.0ms | 0.0% | 0us | `iterateFixOrProblems` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js:23` |
| 28.4% | 606.0ms | 0.0% | 0us | `performIteration` | `[native code]` |
| 28.4% | 606.0ms | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4100` |
| 28.0% | 598.2ms | 0.0% | 0us | `iterateFixOrProblems` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js:24` |
| 26.5% | 565.0ms | 0.0% | 0us | `fixSpaceAroundKeyword` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/fix/fix-space-around-keywords.js:24` |
| 26.5% | 565.0ms | 0.0% | 0us | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1673` |
| 25.8% | 550.6ms | 0.0% | 1.2ms | `next` | `[native code]` |
| 23.8% | 509.4ms | 0.0% | 0us | `bound require` | `[native code]` |
| 23.8% | 507.6ms | 0.0% | 0us | `require` | `[native code]` |
| 22.0% | 470.3ms | 0.0% | 0us | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1947` |
| 21.6% | 462.3ms | 0.6% | 13.6ms | `_getAllTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1932` |
| 19.1% | 407.1ms | 3.3% | 70.7ms | `anonymous` | `[native code]` |
| 12.3% | 263.0ms | 0.8% | 17.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4167` |
| 10.8% | 231.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:458` |
| 10.7% | 229.4ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` |
| 10.3% | 220.0ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` |
| 10.3% | 220.0ms | 10.3% | 220.0ms | `parse` | `[native code]` |
| 10.3% | 219.7ms | 10.3% | 219.7ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1300` |
| 10.0% | 214.5ms | 0.0% | 0us | `isFixable` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:363` |
| 9.3% | 198.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:417` |
| 8.9% | 190.2ms | 0.3% | 7.5ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:434` |
| 8.2% | 176.8ms | 0.8% | 18.9ms | `isReferenceIdentifier` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:158` |
| 6.0% | 128.1ms | 0.1% | 2.8ms | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:299` |
| 5.5% | 119.3ms | 0.8% | 17.8ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4117` |
| 5.4% | 115.7ms | 0.0% | 0us | `loadPlugin` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:95` |
| 5.4% | 115.7ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:142` |
| 5.2% | 111.7ms | 5.1% | 110.4ms | `indexedByProp` | `/Users/ericsan/Development/OpenSource/Ez/js/rewrite-helpers.js:95` |
| 4.8% | 104.0ms | 4.8% | 104.0ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1288` |
| 4.3% | 92.4ms | 0.2% | 6.0ms | `parseModule` | `[native code]` |
| 4.2% | 91.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:408` |
| 4.1% | 88.2ms | 0.0% | 1.4ms | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:46` |
| 3.7% | 79.0ms | 0.0% | 1.0ms | `isCallExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:100` |
| 3.6% | 77.7ms | 1.9% | 41.1ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:3` |
| 2.9% | 61.9ms | 0.0% | 1.3ms | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:62` |
| 2.5% | 54.3ms | 1.8% | 39.8ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1285` |
| 2.5% | 54.1ms | 0.3% | 6.5ms | `get arguments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1915` |
| 2.4% | 51.9ms | 0.0% | 0us | `_computeIdentifierName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 2.3% | 50.3ms | 2.3% | 50.3ms | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:302` |
| 2.2% | 47.9ms | 1.1% | 25.3ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1975` |
| 2.2% | 47.3ms | 0.5% | 11.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2213` |
| 2.0% | 42.7ms | 0.0% | 1.7ms | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:53` |
| 1.9% | 41.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/unsupported-api.js:14` |
| 1.9% | 41.5ms | 1.9% | 41.5ms | `copyDataProperties` | `[native code]` |
| 1.8% | 39.1ms | 1.8% | 39.1ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4045` |
| 1.6% | 36.1ms | 1.6% | 36.1ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:241` |
| 1.6% | 36.1ms | 0.0% | 0us | `moduleEvaluation` | `[native code]` |
| 1.6% | 35.0ms | 1.6% | 35.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7703` |
| 1.6% | 34.4ms | 0.0% | 0us | `getAllComments` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3457` |
| 1.6% | 34.4ms | 0.0% | 0us | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1948` |
| 1.5% | 33.5ms | 1.5% | 33.5ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1260` |
| 1.5% | 33.3ms | 0.0% | 0us | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:8` |
| 1.4% | 31.9ms | 0.0% | 0us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2019` |
| 1.4% | 31.6ms | 1.4% | 31.6ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4109` |
| 1.4% | 31.6ms | 0.1% | 3.0ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2321` |
| 1.4% | 30.5ms | 0.3% | 7.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1212` |
| 1.3% | 28.1ms | 1.3% | 28.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7230` |
| 1.3% | 27.7ms | 0.3% | 7.9ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:917` |
| 1.2% | 25.9ms | 1.2% | 25.9ms | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:560` |
| 1.2% | 25.9ms | 0.0% | 0us | `_computeIdentifierName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4098` |
| 1.1% | 25.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/eslint/eslint.js:44` |
| 1.1% | 24.4ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2851` |
| 1.1% | 24.4ms | 1.1% | 24.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7805` |
| 1.1% | 24.2ms | 1.1% | 24.2ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1292` |
| 1.0% | 22.9ms | 1.0% | 22.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7234` |
| 0.9% | 20.8ms | 0.0% | 0us | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:40` |
| 0.9% | 20.7ms | 0.9% | 20.7ms | `isReferenceIdentifier` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:149` |
| 0.9% | 20.5ms | 0.9% | 20.5ms | `_computeIdentifierName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.8% | 18.5ms | 0.8% | 18.5ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4111` |
| 0.8% | 18.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/linter/index.js:3` |
| 0.8% | 18.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:20` |
| 0.8% | 17.7ms | 0.0% | 0us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3259` |
| 0.8% | 17.7ms | 0.0% | 0us | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:284` |
| 0.8% | 17.5ms | 0.0% | 0us | `some` | `[native code]` |
| 0.8% | 17.3ms | 0.2% | 4.7ms | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:42` |
| 0.8% | 17.1ms | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 0.7% | 16.1ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7745` |
| 0.7% | 15.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:362` |
| 0.7% | 15.6ms | 0.0% | 0us | `isFixable` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:362` |
| 0.7% | 15.5ms | 0.0% | 0us | `link` | `[native code]` |
| 0.7% | 15.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/linter/linter.js:19` |
| 0.7% | 15.2ms | 0.7% | 15.2ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1228` |
| 0.7% | 15.2ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1697` |
| 0.7% | 15.2ms | 0.0% | 1.6ms | `removeParentheses` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/fix/remove-parentheses.js:15` |
| 0.7% | 15.1ms | 0.0% | 1.3ms | `map` | `[native code]` |
| 0.6% | 14.4ms | 0.6% | 14.4ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:822` |
| 0.6% | 14.4ms | 0.6% | 14.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4157` |
| 0.6% | 14.2ms | 0.0% | 1.6ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:624` |
| 0.6% | 14.0ms | 0.6% | 14.0ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1264` |
| 0.6% | 13.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/linter/apply-disable-directives.js:22` |
| 0.6% | 13.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:25` |
| 0.6% | 13.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/eslint/eslint.js:19` |
| 0.6% | 13.6ms | 0.0% | 0us | `iterateSurroundingParentheses` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/iterate-surrounding-parentheses.js:67` |
| 0.6% | 13.6ms | 0.0% | 0us | `getParentheses` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/parentheses.js:25` |
| 0.6% | 13.6ms | 0.0% | 0us | `getSurroundingParentheses` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/iterate-surrounding-parentheses.js:30` |
| 0.6% | 13.0ms | 0.0% | 1.6ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:625` |
| 0.6% | 13.0ms | 0.1% | 3.3ms | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:303` |
| 0.6% | 12.9ms | 0.0% | 0us | `evaluate` | `[native code]` |
| 0.5% | 12.7ms | 0.5% | 11.0ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:627` |
| 0.5% | 12.5ms | 0.5% | 12.5ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2704` |
| 0.5% | 12.2ms | 0.5% | 12.2ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:668` |
| 0.5% | 11.7ms | 0.5% | 11.7ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.5% | 11.7ms | 0.3% | 7.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7735` |
| 0.4% | 10.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/core-js-compat/index.js:2` |
| 0.4% | 10.4ms | 0.4% | 10.4ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4056` |
| 0.4% | 10.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/config/default-config.js:37` |
| 0.4% | 10.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` |
| 0.4% | 10.4ms | 0.2% | 4.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7736` |
| 0.4% | 10.3ms | 0.4% | 10.3ms | `indexedByProp` | `/Users/ericsan/Development/OpenSource/Ez/js/rewrite-helpers.js:96` |
| 0.4% | 10.3ms | 0.0% | 0us | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:851` |
| 0.4% | 10.3ms | 0.4% | 10.3ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:867` |
| 0.4% | 10.3ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3289` |
| 0.4% | 10.3ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2137` |
| 0.4% | 9.9ms | 0.4% | 9.9ms | `create` | `[native code]` |
| 0.4% | 9.8ms | 0.4% | 9.8ms | `defineProperty` | `[native code]` |
| 0.4% | 9.7ms | 0.4% | 9.7ms | `getRange` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3834` |
| 0.4% | 9.7ms | 0.0% | 1.6ms | `isMemberExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:39` |
| 0.4% | 9.5ms | 0.4% | 9.5ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1977` |
| 0.4% | 9.3ms | 0.0% | 1.5ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:56` |
| 0.4% | 9.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/core-js-compat/targets-parser.js:2` |
| 0.4% | 9.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/core-js-compat/compat.js:7` |
| 0.4% | 9.1ms | 0.0% | 0us | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1647` |
| 0.4% | 9.0ms | 0.1% | 2.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7738` |
| 0.4% | 8.7ms | 0.0% | 0us | `(module)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:60` |
| 0.4% | 8.5ms | 0.4% | 8.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:626` |
| 0.3% | 8.4ms | 0.3% | 8.4ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4200` |
| 0.3% | 8.2ms | 0.3% | 8.2ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1202` |
| 0.3% | 8.0ms | 0.2% | 4.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7740` |
| 0.3% | 7.9ms | 0.3% | 7.9ms | `_getAllTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1933` |
| 0.3% | 7.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/index.js:8` |
| 0.3% | 7.8ms | 0.3% | 7.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7530` |
| 0.3% | 7.7ms | 0.3% | 7.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1203` |
| 0.3% | 7.7ms | 0.3% | 7.7ms | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:31` |
| 0.3% | 7.7ms | 0.3% | 7.7ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.3% | 7.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/config/config.js:15` |
| 0.3% | 7.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/shared/ajv.js:11` |
| 0.3% | 7.5ms | 0.0% | 0us | `needsSemicolon` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/needs-semicolon.js:52` |
| 0.3% | 7.5ms | 0.0% | 0us | `replaceReturnStatement` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:162` |
| 0.3% | 7.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/languages/js/index.js:12` |
| 0.3% | 7.3ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7670` |
| 0.3% | 7.3ms | 0.1% | 2.9ms | `isMemberExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:66` |
| 0.3% | 7.2ms | 0.3% | 7.2ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:406` |
| 0.3% | 7.2ms | 0.3% | 7.2ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:629` |
| 0.3% | 7.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:104` |
| 0.3% | 7.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:497` |
| 0.3% | 7.1ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:455` |
| 0.3% | 6.9ms | 0.3% | 6.9ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4057` |
| 0.3% | 6.4ms | 0.2% | 4.9ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:55` |
| 0.2% | 6.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/index.js:3` |
| 0.2% | 6.1ms | 0.2% | 6.1ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4205` |
| 0.2% | 6.0ms | 0.1% | 2.8ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1717` |
| 0.2% | 5.9ms | 0.0% | 0us | `addPolyfillToken` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:55` |
| 0.2% | 5.9ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:490` |
| 0.2% | 5.9ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` |
| 0.2% | 5.9ms | 0.2% | 5.9ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4461` |
| 0.2% | 5.9ms | 0.0% | 1.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2192` |
| 0.2% | 5.9ms | 0.0% | 0us | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:16` |
| 0.2% | 5.9ms | 0.0% | 0us | `get params` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2568` |
| 0.2% | 5.7ms | 0.2% | 5.7ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 5.6ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1720` |
| 0.2% | 5.5ms | 0.0% | 0us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:560` |
| 0.2% | 5.5ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8043` |
| 0.2% | 5.5ms | 0.2% | 5.5ms | `decode` | `[native code]` |
| 0.2% | 5.5ms | 0.2% | 5.5ms | `moduleDeclarationInstantiation` | `[native code]` |
| 0.2% | 5.5ms | 0.0% | 0us | `linkAndEvaluateModule` | `[native code]` |
| 0.2% | 5.1ms | 0.0% | 1.7ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:53` |
| 0.2% | 4.9ms | 0.2% | 4.9ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4081` |
| 0.2% | 4.7ms | 0.2% | 4.7ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 4.7ms | 0.1% | 3.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7540` |
| 0.2% | 4.6ms | 0.2% | 4.6ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 4.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/config/config.js:14` |
| 0.2% | 4.6ms | 0.1% | 3.1ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:60` |
| 0.2% | 4.5ms | 0.2% | 4.5ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1230` |
| 0.2% | 4.5ms | 0.1% | 3.0ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:52` |
| 0.2% | 4.5ms | 0.2% | 4.5ms | `get params` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2581` |
| 0.2% | 4.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:97` |
| 0.2% | 4.5ms | 0.0% | 0us | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:25` |
| 0.2% | 4.4ms | 0.2% | 4.4ms | `isMemberExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:16` |
| 0.2% | 4.4ms | 0.2% | 4.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1204` |
| 0.2% | 4.3ms | 0.2% | 4.3ms | `get` | `[native code]` |
| 0.2% | 4.3ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7527` |
| 0.1% | 4.2ms | 0.0% | 0us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6792` |
| 0.1% | 4.0ms | 0.1% | 2.7ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2855` |
| 0.1% | 3.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/source-code.js:21` |
| 0.1% | 3.5ms | 0.0% | 1.8ms | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:310` |
| 0.1% | 3.5ms | 0.0% | 0us | `get properties` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3125` |
| 0.1% | 3.4ms | 0.1% | 3.4ms | `get arguments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1904` |
| 0.1% | 3.4ms | 0.0% | 0us | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1282` |
| 0.1% | 3.3ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:220` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `encodeInto` | `[native code]` |
| 0.1% | 3.3ms | 0.0% | 0us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` |
| 0.1% | 3.3ms | 0.0% | 1.7ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1187` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `getNodeByRangeIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3796` |
| 0.1% | 3.2ms | 0.0% | 1.8ms | `camelCase` | `/Users/ericsan/node_modules/change-case/dist/index.js:60` |
| 0.1% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/ajv.js:3` |
| 0.1% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/@eslint/config-array/dist/cjs/index.cjs:5` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1213` |
| 0.1% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/rules/index.js:11` |
| 0.1% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/rules/utils/lazy-loading-rule-map.js:7` |
| 0.1% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/config/default-config.js:12` |
| 0.1% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:231` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `getTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1414` |
| 0.1% | 3.2ms | 0.0% | 0us | `getLastTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3491` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `indexedByProp` | `/Users/ericsan/Development/OpenSource/Ez/js/rewrite-helpers.js:94` |
| 0.1% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:221` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js` |
| 0.1% | 3.1ms | 0.0% | 1.5ms | `readFileSync` | `[native code]` |
| 0.1% | 3.0ms | 0.0% | 1.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2197` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2178` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `_computeIdentifierName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4096` |
| 0.1% | 3.0ms | 0.0% | 0us | `Set` | `[native code]` |
| 0.1% | 3.0ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3301` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4180` |
| 0.1% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/regexp-tree.js:10` |
| 0.1% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/optimizer/index.js:11` |
| 0.1% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/browserslist/index.js:1` |
| 0.1% | 2.9ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1495` |
| 0.1% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/compat-transpiler/index.js:9` |
| 0.1% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/regexp-tree.js:8` |
| 0.1% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/browserslist/index.js:3` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `test` | `[native code]` |
| 0.1% | 2.9ms | 0.0% | 0us | `isAvailable` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-source-code.js:56` |
| 0.1% | 2.9ms | 0.0% | 0us | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1616` |
| 0.1% | 2.9ms | 0.0% | 0us | `_getFfi` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:72` |
| 0.1% | 2.8ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7806` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 2.8ms | 0.0% | 0us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4168` |
| 0.1% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/linter/linter.js:48` |
| 0.1% | 2.8ms | 0.0% | 1.6ms | `replaceReturnStatement` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:133` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1401` |
| 0.1% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/compile/rules.js:3` |
| 0.1% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/ajv.js:9` |
| 0.1% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:98` |
| 0.1% | 2.6ms | 0.0% | 0us | `camelCase` | `/Users/ericsan/node_modules/change-case/dist/index.js:68` |
| 0.1% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:18` |
| 0.1% | 2.5ms | 0.1% | 2.5ms | `getNodeByRangeIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3806` |
| 0.1% | 2.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.1% | 2.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.1% | 2.4ms | 0.1% | 2.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7528` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/compat-transpiler/runtime/index.js:118` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/regexp-tree.js:16` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:437` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `stringSplitFast` | `[native code]` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/compat-transpiler/runtime/index.js` |
| 0.0% | 1.8ms | 0.0% | 0us | `isNodeMatchesNameOrPath` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/is-node-matches.js:9` |
| 0.0% | 1.8ms | 0.0% | 0us | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:61` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-create.js:35` |
| 0.0% | 1.8ms | 0.0% | 0us | `UnicornListeners` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:42` |
| 0.0% | 1.8ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4599` |
| 0.0% | 1.8ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8050` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:11` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2854` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `isMemberExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:67` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get key` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3158` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/semver/internal/re.js:158` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `RegExp` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/semver/index.js:4` |
| 0.0% | 1.7ms | 0.0% | 0us | `createToken` | `/Users/ericsan/node_modules/semver/internal/re.js:49` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:610` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/@eslint/plugin-kit/dist/cjs/index.cjs:3` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/prelude-ls/lib/index.js:6` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/levn/lib/parse-string.js:4` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/levn/lib/parse-string.js:113` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/levn/lib/index.js:4` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/levn/lib/index.js:22` |
| 0.0% | 1.7ms | 0.0% | 0us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6795` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get end` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3271` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7731` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2239` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `arrayIteratorNextHelper` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2778` |
| 0.0% | 1.7ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7744` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:418` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:911` |
| 0.0% | 1.7ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1028` |
| 0.0% | 1.7ms | 0.0% | 0us | `findVariable` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:58` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/keyword.js:5` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/ajv.js:29` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_tokType` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/compile/index.js:3` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/compile/resolve.js:3` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `extendFixRange` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/fix/extend-fix-range.js:9` |
| 0.0% | 1.7ms | 0.0% | 0us | `_tryLoad` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-source-code.js:34` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `join` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `bound join` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `slice` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_tokType` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:602` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js:133` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getNodeByRangeIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3797` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:23` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/cli-engine/lint-result-cache.js:12` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isMemberExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:25` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getForOfLoopHeadText` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:101` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/caniuse-lite/dist/unpacker/browsers.js:1` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/caniuse-lite/dist/unpacker/agents.js:3` |
| 0.0% | 1.6ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1733` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get key` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3159` |
| 0.0% | 1.6ms | 0.0% | 0us | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2955` |
| 0.0% | 1.6ms | 0.0% | 0us | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 0.0% | 1.6ms | 0.0% | 0us | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:287` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7834` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/languages/js/index.js:16` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:66` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1864` |
| 0.0% | 1.6ms | 0.0% | 0us | `replaceReturnStatement` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:139` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/transform/index.js:12` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1192` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4083` |
| 0.0% | 1.5ms | 0.0% | 0us | `addMetaSchema` | `/Users/ericsan/node_modules/ajv/lib/ajv.js:152` |
| 0.0% | 1.5ms | 0.0% | 0us | `serialize` | `/Users/ericsan/node_modules/uri-js/dist/es5/uri.all.js:1012` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/config/config.js:16` |
| 0.0% | 1.5ms | 0.0% | 0us | `_getFullPath` | `/Users/ericsan/node_modules/ajv/lib/compile/resolve.js:215` |
| 0.0% | 1.5ms | 0.0% | 0us | `_addSchema` | `/Users/ericsan/node_modules/ajv/lib/ajv.js:309` |
| 0.0% | 1.5ms | 0.0% | 0us | `addSchema` | `/Users/ericsan/node_modules/ajv/lib/ajv.js:137` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/shared/ajv.js:29` |
| 0.0% | 1.5ms | 0.0% | 0us | `resolveIds` | `/Users/ericsan/node_modules/ajv/lib/compile/resolve.js:235` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/debug/src/index.js:9` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/node_modules/debug/src/node.js:124` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:28` |
| 0.0% | 1.5ms | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4085` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getLocFromIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3649` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get arguments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1910` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:429` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:914` |
| 0.0% | 1.5ms | 0.0% | 0us | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1633` |
| 0.0% | 1.5ms | 0.0% | 0us | `wrap` | `bun:ffi:296` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `ez_ffi_token_idx_at_or_before` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `Uint8Array` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:87` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(module)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:119` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `[Symbol.split]` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/semver/index.js:44` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/semver/ranges/subset.js:73` |
| 0.0% | 1.5ms | 0.0% | 0us | `Comparator` | `/Users/ericsan/node_modules/semver/classes/comparator.js:21` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/compile/index.js:5` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:34` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `isMemberExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:43` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `ReadStream` | `internal:fs/streams` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:20` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/browserslist/index.js:9` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/browserslist/node.js:2` |
| 0.0% | 1.5ms | 0.0% | 0us | `get ReadStream` | `node:fs:573` |
| 0.0% | 1.5ms | 0.0% | 0us | `internal:streams/operators` | `internal:streams/operators:2` |
| 0.0% | 1.5ms | 0.0% | 0us | `node:stream` | `node:stream:2` |
| 0.0% | 1.5ms | 0.0% | 0us | `internal:streams/pipeline` | `internal:streams/pipeline:2` |
| 0.0% | 1.5ms | 0.0% | 0us | `internal:streams/compose` | `internal:streams/compose:2` |
| 0.0% | 1.5ms | 0.0% | 0us | `internal:fs/streams` | `internal:fs/streams:2` |
| 0.0% | 1.5ms | 0.0% | 0us | `internal:stream` | `internal:stream:2` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/@eslint/config-array/node_modules/minimatch/dist/commonjs/ast.js:7` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get computed` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1995` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/@eslint/config-array/node_modules/minimatch/dist/commonjs/index.js:6` |
| 0.0% | 1.5ms | 0.0% | 0us | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3924` |
| 0.0% | 1.5ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4230` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_isOptionalTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `at` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:428` |
| 0.0% | 1.4ms | 0.0% | 0us | `getForOfLoopHeadRange` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:128` |
| 0.0% | 1.4ms | 0.0% | 0us | `getParenthesizedRange` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/parentheses.js:46` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `fixSpaceAroundKeyword` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/fix/fix-space-around-keywords.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2302` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:72` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:62` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isFixable` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:335` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `charCodeAt` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1290` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/linter/esquery.js:12` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/linter/source-code-traverser.js:12` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2233` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/dotjs/index.js:22` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:25` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:5` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_rangeOf` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4009` |
| 0.0% | 1.4ms | 0.0% | 0us | `insertTextAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4038` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6954` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2229` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:259` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4927` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/node_modules/change-case/dist/index.js:179` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6956` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2779` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `split` | `/Users/ericsan/node_modules/change-case/dist/index.js:20` |
| 0.0% | 1.4ms | 0.0% | 0us | `splitPrefixSuffix` | `/Users/ericsan/node_modules/change-case/dist/index.js:205` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1971` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2325` |
| 0.0% | 1.3ms | 0.0% | 0us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6816` |
| 0.0% | 1.3ms | 0.0% | 0us | `invokeHandlersWithNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6754` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get callee` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `Symbol.iterator` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3303` |
| 0.0% | 1.3ms | 0.0% | 0us | `from` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/token-store/index.js:11` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/source-code.js:11` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2323` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/parser/index.js:8` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/transform/index.js:13` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/semver/index.js:29` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/languages/js/index.js:15` |
| 0.0% | 1.3ms | 0.0% | 0us | `_getOrBuildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6040` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7113` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/node_modules/minimatch/dist/commonjs/ast.js:6` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/node_modules/minimatch/dist/commonjs/index.js:6` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `isReferenceIdentifier` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/optimizer/transforms/index.js:55` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `/[\\/]eslint-plugin-unicorn[\\/]rules[\\/]rule[\\/]unicorn-listeners\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-switch\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-json-parse-buffer\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]consistent-empty-array-spread\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]consistent-assert\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-useless-switch-case\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-object-from-entries\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-export-from\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-import-meta-properties\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-thenable\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-array-reduce\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-process-exit\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-single-call\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-array-callback-reference\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-string-slice\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-nested-ternary\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-console-spaces\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-global-this\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]consistent-existence-index-check\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-array-flat\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-prototype-methods\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-invalid-fetch-options\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-array-for-each\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-await-in-promise-methods\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-useless-length-check\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-modern-math-apis\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-abusive-eslint-disable\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-regexp-test\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-date-now\.js$/` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/eslint/eslint.js:20` |
| 0.0% | 1.3ms | 0.0% | 0us | `(module)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/index.js:31` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/index.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1962` |
| 0.0% | 1.3ms | 0.0% | 0us | `get properties` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3131` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get arguments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1927` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(module)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/filename-case.js:20` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:800` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1193` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/core-js-compat/compat.js:4` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:24` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/config/config-loader.js:14` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/find-up/index.js:3` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/globals/index.js:2` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/node_modules/minimatch/dist/commonjs/index.js:4` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/caniuse-lite/dist/unpacker/agents.js:5` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/node_modules/caniuse-lite/data/agents.js:1` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/source-code.js:13` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/dotjs/index.js:5` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:607` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/cli-engine/hash.js:12` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:17` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `toLocaleLowerCase` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `addPolyfillToken` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:47` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3339` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_isStatementTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:72` |
| 0.0% | 1.2ms | 0.0% | 0us | `getFirstToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1455` |
| 0.0% | 1.2ms | 0.0% | 0us | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3613` |
| 0.0% | 1.2ms | 0.0% | 0us | `dlopen` | `bun:ffi:345` |
| 0.0% | 1.2ms | 0.0% | 0us | `_tryLoad` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-source-code.js:44` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `dlopen` | `[native code]` |
| 0.0% | 1.1ms | 0.0% | 1.1ms | `_intern` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:382` |
| 0.0% | 1.1ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8012` |
| 0.0% | 1.0ms | 0.0% | 1.0ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4112` |

## Function Details

### `parse`
`[native code]` | Self: 10.3% (220.0ms) | Total: 10.3% (220.0ms) | Samples: 144

**Called by:**
- `parseSource` (144)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1300` | Self: 10.3% (219.7ms) | Total: 10.3% (219.7ms) | Samples: 139

**Called by:**
- `_getAllTokens` (139)

### `indexedByProp`
`/Users/ericsan/Development/OpenSource/Ez/js/rewrite-helpers.js:95` | Self: 5.1% (110.4ms) | Total: 5.2% (111.7ms) | Samples: 71

**Called by:**
- `isFunctionParametersSafeToFix` (72)

**Calls:**
- `get` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1288` | Self: 4.8% (104.0ms) | Total: 4.8% (104.0ms) | Samples: 67

**Called by:**
- `_getAllTokens` (67)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7568` | Self: 3.8% (82.3ms) | Total: 33.3% (710.2ms) | Samples: 55

**Called by:**
- `runPlugins` (462)

**Calls:**
- `_invokeFused` (325)
- `_nodeViewRaw` (66)
- `_nodeViewRaw` (4)
- `nodeView` (4)
- `nodeView` (4)
- `_invokeFused` (3)
- `_invokeFused` (1)

### `anonymous`
`[native code]` | Self: 3.3% (70.7ms) | Total: 19.1% (407.1ms) | Samples: 47

**Called by:**
- `require` (260)
- `node:stream` (1)
- `internal:stream` (1)
- `internal:streams/operators` (1)
- `internal:streams/compose` (1)
- `get ReadStream` (1)
- `wrap` (1)
- `bound require` (1)
- `internal:fs/streams` (1)
- `internal:streams/pipeline` (1)

**Calls:**
- `(anonymous)` (17)
- `(anonymous)` (12)
- `(anonymous)` (12)
- `(anonymous)` (10)
- `(anonymous)` (9)
- `(anonymous)` (9)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
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
- `ez_ffi_token_idx_at_or_before` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:streams/compose` (1)
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
- `internal:streams/pipeline` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:stream` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `/[\\/]eslint-plugin-unicorn[\\/]rules[\\/]rule[\\/]unicorn-listeners\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-switch\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-json-parse-buffer\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]consistent-empty-array-spread\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]consistent-assert\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-useless-switch-case\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-object-from-entries\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-export-from\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-import-meta-properties\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-thenable\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-array-reduce\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-process-exit\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-single-call\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-array-callback-reference\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-string-slice\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-nested-ternary\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-console-spaces\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-global-this\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]consistent-existence-index-check\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-array-flat\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-prototype-methods\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-invalid-fetch-options\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-array-for-each\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-await-in-promise-methods\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-useless-length-check\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-modern-math-apis\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-abusive-eslint-disable\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-regexp-test\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-date-now\.js$/` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:streams/operators` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `isFunctionParametersSafeToFix`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:302` | Self: 2.3% (50.3ms) | Total: 2.3% (50.3ms) | Samples: 33

**Called by:**
- `isFixable` (33)

### `copyDataProperties`
`[native code]` | Self: 1.9% (41.5ms) | Total: 1.9% (41.5ms) | Samples: 27

**Called by:**
- `create` (14)
- `isMethodCall` (8)
- `isMemberExpression` (5)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:3` | Self: 1.9% (41.1ms) | Total: 3.6% (77.7ms) | Samples: 26

**Called by:**
- `isReferenceIdentifier` (50)

**Calls:**
- `get parent` (17)
- `get parent` (3)
- `get parent` (3)
- `get parent` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1285` | Self: 1.8% (39.8ms) | Total: 2.5% (54.3ms) | Samples: 26

**Called by:**
- `_getAllTokens` (32)
- `getTokenBefore` (4)

**Calls:**
- `_getJsxTextTokFlags` (6)
- `_getJsxTextTokFlags` (2)
- `_getJsxTextTokFlags` (1)
- `_getJsxTextTokFlags` (1)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4045` | Self: 1.8% (39.1ms) | Total: 1.8% (39.1ms) | Samples: 25

**Called by:**
- `_nodeViewRaw` (25)

### `_resolveUnicodeEscapes`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:241` | Self: 1.6% (36.1ms) | Total: 1.6% (36.1ms) | Samples: 22

**Called by:**
- `_computeIdentifierName` (22)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7703` | Self: 1.6% (35.0ms) | Total: 1.6% (35.0ms) | Samples: 23

**Called by:**
- `runPlugins` (23)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1260` | Self: 1.5% (33.5ms) | Total: 1.5% (33.5ms) | Samples: 22

**Called by:**
- `_getAllTokens` (22)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4109` | Self: 1.4% (31.6ms) | Total: 1.4% (31.6ms) | Samples: 21

**Called by:**
- `_nodeViewRaw` (21)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7230` | Self: 1.3% (28.1ms) | Total: 1.3% (28.1ms) | Samples: 19

**Called by:**
- `runPlugins` (19)

### `source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:560` | Self: 1.2% (25.9ms) | Total: 1.2% (25.9ms) | Samples: 16

**Called by:**
- `_computeIdentifierName` (16)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1975` | Self: 1.1% (25.3ms) | Total: 2.2% (47.9ms) | Samples: 17

**Called by:**
- `getTokenBefore` (32)

**Calls:**
- `_makeToken` (8)
- `_makeToken` (4)
- `_makeToken` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7805` | Self: 1.1% (24.4ms) | Total: 1.1% (24.4ms) | Samples: 17

**Called by:**
- `runPlugins` (17)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1292` | Self: 1.1% (24.2ms) | Total: 1.1% (24.2ms) | Samples: 17

**Called by:**
- `_getAllTokens` (17)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7234` | Self: 1.0% (22.9ms) | Total: 1.0% (22.9ms) | Samples: 15

**Called by:**
- `runPlugins` (15)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:73` | Self: 1.0% (22.0ms) | Total: 63.7% (1.35s) | Samples: 14

**Called by:**
- `_invokeFused` (879)
- `invokeHandlersWithNode` (1)

**Calls:**
- `_drainAndReport` (395)
- `(anonymous)` (149)
- `(anonymous)` (129)
- `(anonymous)` (121)
- `(anonymous)` (61)
- `(anonymous)` (5)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `isReferenceIdentifier`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:149` | Self: 0.9% (20.7ms) | Total: 0.9% (20.7ms) | Samples: 13

**Called by:**
- `(anonymous)` (13)

### `(anonymous)`
`[native code]` | Self: 0.9% (20.6ms) | Total: 100.0% (2.24s) | Samples: 14

**Called by:**
- `processTicksAndRejections` (1297)
- `(anonymous)` (91)
- `require` (77)
- `parseModule` (1)

**Calls:**
- `_lintSourceOne` (1150)
- `_lintSourceOne` (147)
- `(anonymous)` (91)
- `parseModule` (50)
- `moduleEvaluation` (9)
- `linkAndEvaluateModule` (4)
- `ReadStream` (1)

### `_computeIdentifierName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.9% (20.5ms) | Total: 0.9% (20.5ms) | Samples: 14

**Called by:**
- `_NodeView_LR` (14)

### `isReferenceIdentifier`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:158` | Self: 0.8% (18.9ms) | Total: 8.2% (176.8ms) | Samples: 13

**Called by:**
- `(anonymous)` (115)

**Calls:**
- `isNotReference` (50)
- `isNotReference` (22)
- `isNotReference` (6)
- `isNotReference` (4)
- `isNotReference` (4)
- `isNotReference` (3)
- `isNotReference` (3)
- `isNotReference` (3)
- `isNotReference` (3)
- `isNotReference` (1)
- `isNotReference` (1)
- `isNotReference` (1)
- `isNotReference` (1)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4111` | Self: 0.8% (18.5ms) | Total: 0.8% (18.5ms) | Samples: 12

**Called by:**
- `_nodeViewRaw` (12)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4167` | Self: 0.8% (17.9ms) | Total: 12.3% (263.0ms) | Samples: 12

**Called by:**
- `walkNodes` (66)
- `get arguments` (28)
- `isMethodCall` (23)
- `isNotReference` (21)
- `get parent` (13)
- `_nodesFromRange` (12)
- `get body` (4)
- `isMemberExpression` (3)
- `get body` (1)

**Calls:**
- `_NodeView_LR` (77)
- `_NodeView` (25)
- `_NodeView_LR` (21)
- `_NodeView_LR` (12)
- `_NodeView` (7)
- `_NodeView` (5)
- `_NodeView_LR` (5)
- `_NodeView_LRN` (3)
- `_NodeView` (3)
- `_NodeView_LRN` (1)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4117` | Self: 0.8% (17.8ms) | Total: 5.5% (119.3ms) | Samples: 12

**Called by:**
- `_nodeViewRaw` (77)

**Calls:**
- `_computeIdentifierName` (33)
- `_computeIdentifierName` (16)
- `_computeIdentifierName` (14)
- `_computeIdentifierName` (2)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1228` | Self: 0.7% (15.2ms) | Total: 0.7% (15.2ms) | Samples: 10

**Called by:**
- `_getTokensAndCommentsMerged` (8)
- `getTokenBefore` (2)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:822` | Self: 0.6% (14.4ms) | Total: 0.6% (14.4ms) | Samples: 10

**Called by:**
- `_computeIdentifierName` (10)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4157` | Self: 0.6% (14.4ms) | Total: 0.6% (14.4ms) | Samples: 8

**Called by:**
- `walkNodes` (4)
- `_buildScope` (1)
- `get arguments` (1)
- `isMethodCall` (1)
- `_nodesFromRange` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1264` | Self: 0.6% (14.0ms) | Total: 0.6% (14.0ms) | Samples: 9

**Called by:**
- `_getAllTokens` (9)

### `_getAllTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1932` | Self: 0.6% (13.6ms) | Total: 21.6% (462.3ms) | Samples: 9

**Called by:**
- `_getTokensAndCommentsMerged` (298)

**Calls:**
- `_makeToken` (139)
- `_makeToken` (67)
- `_makeToken` (32)
- `_makeToken` (22)
- `_makeToken` (17)
- `_makeToken` (9)
- `_makeToken` (2)
- `_makeToken` (1)

### `get typeAnnotation`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2704` | Self: 0.5% (12.5ms) | Total: 0.5% (12.5ms) | Samples: 8

**Called by:**
- `(anonymous)` (8)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:668` | Self: 0.5% (12.2ms) | Total: 0.5% (12.2ms) | Samples: 8

**Called by:**
- `commentsInRange` (5)
- `commentsInRange` (3)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.5% (11.7ms) | Total: 0.5% (11.7ms) | Samples: 8

**Called by:**
- `commentsInRange` (5)
- `commentsInRange` (3)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2213` | Self: 0.5% (11.3ms) | Total: 2.2% (47.3ms) | Samples: 8

**Called by:**
- `(anonymous)` (31)
- `_buildScope` (1)

**Calls:**
- `_computeIsStrict` (21)
- `_computeIsStrict` (1)
- `_computeIsStrict` (1)
- `_computeIsStrict` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:627` | Self: 0.5% (11.0ms) | Total: 0.5% (12.7ms) | Samples: 7

**Called by:**
- `_precomputeScopes` (5)
- `getAllComments` (3)

**Calls:**
- `slice` (1)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4056` | Self: 0.4% (10.4ms) | Total: 0.4% (10.4ms) | Samples: 7

**Called by:**
- `_nodeViewRaw` (7)

### `indexedByProp`
`/Users/ericsan/Development/OpenSource/Ez/js/rewrite-helpers.js:96` | Self: 0.4% (10.3ms) | Total: 0.4% (10.3ms) | Samples: 7

**Called by:**
- `isFunctionParametersSafeToFix` (7)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:867` | Self: 0.4% (10.3ms) | Total: 0.4% (10.3ms) | Samples: 6

**Called by:**
- `_symName` (6)

### `create`
`[native code]` | Self: 0.4% (9.9ms) | Total: 0.4% (9.9ms) | Samples: 7

**Called by:**
- `walkNodes` (4)
- `walkNodes` (3)

### `defineProperty`
`[native code]` | Self: 0.4% (9.8ms) | Total: 0.4% (9.8ms) | Samples: 6

**Called by:**
- `walkNodes` (4)
- `walkNodes` (2)

### `getRange`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3834` | Self: 0.4% (9.7ms) | Total: 0.4% (9.7ms) | Samples: 6

**Called by:**
- `isFunctionParametersSafeToFix` (6)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1977` | Self: 0.4% (9.5ms) | Total: 0.4% (9.5ms) | Samples: 6

**Called by:**
- `getTokenBefore` (6)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:626` | Self: 0.4% (8.5ms) | Total: 0.4% (8.5ms) | Samples: 6

**Called by:**
- `getAllComments` (6)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4200` | Self: 0.3% (8.4ms) | Total: 0.3% (8.4ms) | Samples: 6

**Called by:**
- `walkNodes` (4)
- `get parent` (1)
- `walkNodes` (1)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1202` | Self: 0.3% (8.2ms) | Total: 0.3% (8.2ms) | Samples: 6

**Called by:**
- `_makeToken` (6)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:917` | Self: 0.3% (7.9ms) | Total: 1.3% (27.7ms) | Samples: 4

**Called by:**
- `get body` (9)
- `get params` (4)
- `get properties` (2)
- `get value` (1)
- `get body` (1)

**Calls:**
- `_nodeViewRaw` (12)
- `_nodeViewRaw` (1)

### `_getAllTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1933` | Self: 0.3% (7.9ms) | Total: 0.3% (7.9ms) | Samples: 5

**Called by:**
- `_getTokensAndCommentsMerged` (5)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7530` | Self: 0.3% (7.8ms) | Total: 0.3% (7.8ms) | Samples: 5

**Called by:**
- `runPlugins` (5)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1203` | Self: 0.3% (7.7ms) | Total: 0.3% (7.7ms) | Samples: 5

**Called by:**
- `isNotReference` (3)
- `isNotReference` (1)
- `isNotReference` (1)

### `isMethodCall`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:31` | Self: 0.3% (7.7ms) | Total: 0.3% (7.7ms) | Samples: 5

**Called by:**
- `(anonymous)` (5)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.3% (7.7ms) | Total: 0.3% (7.7ms) | Samples: 5

**Called by:**
- `_nodeViewRaw` (5)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:434` | Self: 0.3% (7.5ms) | Total: 8.9% (190.2ms) | Samples: 5

**Called by:**
- `(anonymous)` (121)

**Calls:**
- `isMethodCall` (57)
- `isMethodCall` (27)
- `isMethodCall` (11)
- `isMemberExpression` (6)
- `isMethodCall` (5)
- `isMemberExpression` (5)
- `isMemberExpression` (2)
- `isMemberExpression` (1)
- `isMemberExpression` (1)
- `isMemberExpression` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1212` | Self: 0.3% (7.5ms) | Total: 1.4% (30.5ms) | Samples: 5

**Called by:**
- `isNotReference` (17)
- `isNotReference` (1)
- `_computeVarDefs` (1)
- `isNotReference` (1)

**Calls:**
- `_nodeViewRaw` (13)
- `_nodeViewRaw` (1)
- `nodeView` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:406` | Self: 0.3% (7.2ms) | Total: 0.3% (7.2ms) | Samples: 5

**Called by:**
- `(anonymous)` (5)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:629` | Self: 0.3% (7.2ms) | Total: 0.3% (7.2ms) | Samples: 5

**Called by:**
- `getAllComments` (3)
- `_precomputeScopes` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7735` | Self: 0.3% (7.2ms) | Total: 0.5% (11.7ms) | Samples: 5

**Called by:**
- `runPlugins` (8)

**Calls:**
- `create` (3)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4057` | Self: 0.3% (6.9ms) | Total: 0.3% (6.9ms) | Samples: 5

**Called by:**
- `_nodeViewRaw` (5)

### `get arguments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1915` | Self: 0.3% (6.5ms) | Total: 2.5% (54.1ms) | Samples: 4

**Called by:**
- `create` (34)

**Calls:**
- `_nodeViewRaw` (28)
- `nodeViewChain` (1)
- `_nodeViewRaw` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4205` | Self: 0.2% (6.1ms) | Total: 0.2% (6.1ms) | Samples: 4

**Called by:**
- `walkNodes` (4)

### `parseModule`
`[native code]` | Self: 0.2% (6.0ms) | Total: 4.3% (92.4ms) | Samples: 4

**Called by:**
- `(anonymous)` (50)
- `async (anonymous)` (11)

**Calls:**
- `(anonymous)` (28)
- `(anonymous)` (9)
- `(anonymous)` (7)
- `(anonymous)` (5)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `get ReadStream` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4461` | Self: 0.2% (5.9ms) | Total: 0.2% (5.9ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.2% (5.7ms) | Total: 0.2% (5.7ms) | Samples: 4

**Called by:**
- `_getTokensAndCommentsMerged` (4)

### `decode`
`[native code]` | Self: 0.2% (5.5ms) | Total: 0.2% (5.5ms) | Samples: 4

**Called by:**
- `get source` (4)

### `moduleDeclarationInstantiation`
`[native code]` | Self: 0.2% (5.5ms) | Total: 0.2% (5.5ms) | Samples: 4

**Called by:**
- `link` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7767` | Self: 0.2% (4.9ms) | Total: 39.8% (848.5ms) | Samples: 3

**Called by:**
- `runPlugins` (549)

**Calls:**
- `_invokeFused` (545)
- `nodeView` (1)

### `_NodeView_LRN`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4081` | Self: 0.2% (4.9ms) | Total: 0.2% (4.9ms) | Samples: 3

**Called by:**
- `_nodeViewRaw` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7736` | Self: 0.2% (4.9ms) | Total: 0.4% (10.4ms) | Samples: 3

**Called by:**
- `runPlugins` (7)

**Calls:**
- `create` (4)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:55` | Self: 0.2% (4.9ms) | Total: 0.3% (6.4ms) | Samples: 3

**Called by:**
- `isReferenceIdentifier` (4)

**Calls:**
- `get parent` (1)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.2% (4.7ms) | Total: 0.2% (4.7ms) | Samples: 3

**Called by:**
- `_nodeViewRaw` (3)

### `isMethodCall`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:42` | Self: 0.2% (4.7ms) | Total: 0.8% (17.3ms) | Samples: 3

**Called by:**
- `(anonymous)` (11)

**Calls:**
- `copyDataProperties` (8)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.2% (4.6ms) | Total: 0.2% (4.6ms) | Samples: 3

**Called by:**
- `walkNodes` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7740` | Self: 0.2% (4.6ms) | Total: 0.3% (8.0ms) | Samples: 3

**Called by:**
- `runPlugins` (5)

**Calls:**
- `defineProperty` (2)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1230` | Self: 0.2% (4.5ms) | Total: 0.2% (4.5ms) | Samples: 3

**Called by:**
- `_getTokensAndCommentsMerged` (3)

### `get params`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2581` | Self: 0.2% (4.5ms) | Total: 0.2% (4.5ms) | Samples: 3

**Called by:**
- `isNotReference` (3)

### `isMemberExpression`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:16` | Self: 0.2% (4.4ms) | Total: 0.2% (4.4ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1204` | Self: 0.2% (4.4ms) | Total: 0.2% (4.4ms) | Samples: 3

**Called by:**
- `isNotReference` (3)

### `get`
`[native code]` | Self: 0.2% (4.3ms) | Total: 0.2% (4.3ms) | Samples: 3

**Called by:**
- `indexedByProp` (1)
- `walkNodes` (1)
- `walkNodes` (1)

### `get arguments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1904` | Self: 0.1% (3.4ms) | Total: 0.1% (3.4ms) | Samples: 2

**Called by:**
- `create` (2)

### `encodeInto`
`[native code]` | Self: 0.1% (3.3ms) | Total: 0.1% (3.3ms) | Samples: 2

**Called by:**
- `_encodeSource` (2)

### `isFunctionParametersSafeToFix`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:303` | Self: 0.1% (3.3ms) | Total: 0.6% (13.0ms) | Samples: 2

**Called by:**
- `isFixable` (8)

**Calls:**
- `getRange` (6)

### `getNodeByRangeIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3796` | Self: 0.1% (3.2ms) | Total: 0.1% (3.2ms) | Samples: 2

**Called by:**
- `needsSemicolon` (2)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1213` | Self: 0.1% (3.2ms) | Total: 0.1% (3.2ms) | Samples: 2

**Called by:**
- `isNotReference` (1)
- `_computeIsStrict` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7540` | Self: 0.1% (3.2ms) | Total: 0.2% (4.7ms) | Samples: 2

**Called by:**
- `runPlugins` (3)

**Calls:**
- `_resolveHandlers` (1)

### `getTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1414` | Self: 0.1% (3.2ms) | Total: 0.1% (3.2ms) | Samples: 2

**Called by:**
- `getLastTokens` (2)

### `indexedByProp`
`/Users/ericsan/Development/OpenSource/Ez/js/rewrite-helpers.js:94` | Self: 0.1% (3.1ms) | Total: 0.1% (3.1ms) | Samples: 2

**Called by:**
- `isFunctionParametersSafeToFix` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js` | Self: 0.1% (3.1ms) | Total: 0.1% (3.1ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:60` | Self: 0.1% (3.1ms) | Total: 0.2% (4.6ms) | Samples: 2

**Called by:**
- `isReferenceIdentifier` (3)

**Calls:**
- `get value` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2321` | Self: 0.1% (3.0ms) | Total: 1.4% (31.6ms) | Samples: 2

**Called by:**
- `_buildScope` (21)

**Calls:**
- `get body` (10)
- `get body` (4)
- `get body` (4)
- `get body` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2178` | Self: 0.1% (3.0ms) | Total: 0.1% (3.0ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:52` | Self: 0.1% (3.0ms) | Total: 0.2% (4.5ms) | Samples: 2

**Called by:**
- `isReferenceIdentifier` (3)

**Calls:**
- `get computed` (1)

### `_computeIdentifierName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4096` | Self: 0.1% (3.0ms) | Total: 0.1% (3.0ms) | Samples: 2

**Called by:**
- `_NodeView_LR` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4180` | Self: 0.1% (3.0ms) | Total: 0.1% (3.0ms) | Samples: 2

**Called by:**
- `isNotReference` (1)
- `get body` (1)

### `test`
`[native code]` | Self: 0.1% (2.9ms) | Total: 0.1% (2.9ms) | Samples: 2

**Called by:**
- `serialize` (1)
- `_precomputeScopes` (1)

### `isMemberExpression`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:66` | Self: 0.1% (2.9ms) | Total: 0.3% (7.3ms) | Samples: 2

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `_nodeViewRaw` (3)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (2.8ms) | Total: 0.1% (2.8ms) | Samples: 2

**Called by:**
- `_nodeViewRaw` (2)

### `isFunctionParametersSafeToFix`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:299` | Self: 0.1% (2.8ms) | Total: 6.0% (128.1ms) | Samples: 2

**Called by:**
- `isFixable` (83)

**Calls:**
- `indexedByProp` (72)
- `indexedByProp` (7)
- `indexedByProp` (2)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1717` | Self: 0.1% (2.8ms) | Total: 0.2% (6.0ms) | Samples: 2

**Called by:**
- `_computeIsStrict` (4)

**Calls:**
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1401` | Self: 0.1% (2.7ms) | Total: 0.1% (2.7ms) | Samples: 2

**Called by:**
- `invokeMethodFnHandlers` (1)
- `isNotReference` (1)

### `generatorResume`
`[native code]` | Self: 0.1% (2.7ms) | Total: 85.5% (1.82s) | Samples: 2

**Called by:**
- `performIteration` (393)
- `next` (353)
- `iterateFixOrProblems` (216)
- `iterateFixOrProblems` (212)
- `getParentheses` (9)

**Calls:**
- `iterateFixOrProblems` (393)
- `iterateFixOrProblems` (388)
- `fixSpaceAroundKeyword` (366)
- `removeParentheses` (10)
- `iterateSurroundingParentheses` (9)
- `replaceReturnStatement` (5)
- `(anonymous)` (2)
- `replaceReturnStatement` (2)
- `(anonymous)` (2)
- `fixSpaceAroundKeyword` (1)
- `replaceReturnStatement` (1)
- `extendFixRange` (1)
- `(anonymous)` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2855` | Self: 0.1% (2.7ms) | Total: 0.1% (4.0ms) | Samples: 2

**Called by:**
- `getScope` (3)

**Calls:**
- `test` (1)

### `getNodeByRangeIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3806` | Self: 0.1% (2.5ms) | Total: 0.1% (2.5ms) | Samples: 2

**Called by:**
- `needsSemicolon` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7738` | Self: 0.1% (2.5ms) | Total: 0.4% (9.0ms) | Samples: 2

**Called by:**
- `runPlugins` (6)

**Calls:**
- `defineProperty` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7528` | Self: 0.1% (2.4ms) | Total: 0.1% (2.4ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `camelCase`
`/Users/ericsan/node_modules/change-case/dist/index.js:60` | Self: 0.0% (1.8ms) | Total: 0.1% (3.2ms) | Samples: 1

**Called by:**
- `addPolyfillToken` (2)

**Calls:**
- `splitPrefixSuffix` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/compat-transpiler/runtime/index.js` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `stringSplitFast`
`[native code]` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `isNodeMatchesNameOrPath` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `UnicornListeners` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2854` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `getScope` (1)

### `isMemberExpression`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:67` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `isFunctionParametersSafeToFix`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:310` | Self: 0.0% (1.8ms) | Total: 0.1% (3.5ms) | Samples: 1

**Called by:**
- `isFixable` (2)

**Calls:**
- `findVariable` (1)

### `get key`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3158` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `isNotReference` (1)

### `isMethodCall`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:53` | Self: 0.0% (1.7ms) | Total: 2.0% (42.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (27)

**Calls:**
- `_nodeViewRaw` (23)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `get callee` (1)

### `RegExp`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `createToken` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:610` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getAllComments` (1)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1187` | Self: 0.0% (1.7ms) | Total: 0.1% (3.3ms) | Samples: 1

**Called by:**
- `_makeToken` (2)

**Calls:**
- `Uint8Array` (1)

### `get end`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `invokeMethodFnHandlers` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3271` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7731` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2239` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `arrayIteratorNextHelper`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `Set` (1)

### `get typeAnnotation`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2778` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:418` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:53` | Self: 0.0% (1.7ms) | Total: 0.2% (5.1ms) | Samples: 1

**Called by:**
- `isReferenceIdentifier` (3)

**Calls:**
- `get key` (1)
- `get key` (1)

### `_tokType`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_makeToken` (1)

### `extendFixRange`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/fix/extend-fix-range.js:9` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `generatorResume` (1)

### `join`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `bound join` (1)

### `slice`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `commentsInRange` (1)

### `_tokType`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:602` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_makeToken` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getNodeByRangeIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3797` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `needsSemicolon` (1)

### `isMemberExpression`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:25` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:624` | Self: 0.0% (1.6ms) | Total: 0.6% (14.2ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (5)
- `getAllComments` (4)

**Calls:**
- `_findLineIdx` (5)
- `_findLineIdx` (3)

### `getForOfLoopHeadText`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:101` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get key`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3159` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `isNotReference` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:625` | Self: 0.0% (1.6ms) | Total: 0.6% (13.0ms) | Samples: 1

**Called by:**
- `getAllComments` (5)
- `_precomputeScopes` (4)

**Calls:**
- `_findLineIdx` (5)
- `_findLineIdx` (3)

### `isMemberExpression`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:39` | Self: 0.0% (1.6ms) | Total: 0.4% (9.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `copyDataProperties` (5)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7834` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `create`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:66` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `isCallExpression` (1)

### `removeParentheses`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/fix/remove-parentheses.js:15` | Self: 0.0% (1.6ms) | Total: 0.7% (15.2ms) | Samples: 1

**Called by:**
- `generatorResume` (10)

**Calls:**
- `getParentheses` (9)

### `get argument`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1864` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `replaceReturnStatement` (1)

### `replaceReturnStatement`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:133` | Self: 0.0% (1.6ms) | Total: 0.1% (2.8ms) | Samples: 1

**Called by:**
- `generatorResume` (2)

**Calls:**
- `getFirstToken` (1)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1192` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_makeToken` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7806` | Self: 0.0% (1.5ms) | Total: 0.1% (2.8ms) | Samples: 1

**Called by:**
- `runPlugins` (2)

**Calls:**
- `get` (1)

### `_NodeView_LRN`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4083` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/debug/src/node.js:124` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `getScope` (1)

### `readFileSync`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.1% (3.1ms) | Samples: 1

**Called by:**
- `readFileSync` (1)
- `(anonymous)` (1)

**Calls:**
- `readFileSync` (1)

### `getLocFromIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3649` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_execReport` (1)

### `get arguments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1910` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `create` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:429` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:914` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `get body` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2197` | Self: 0.0% (1.5ms) | Total: 0.1% (3.0ms) | Samples: 1

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `_nodeViewRaw` (1)

### `ez_ffi_token_idx_at_or_before`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `Uint8Array`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_getJsxTextTokFlags` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:87` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `map` (1)

### `(module)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:119` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `evaluate` (1)

### `[Symbol.split]`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `Comparator` (1)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:34` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `isReferenceIdentifier` (1)

### `isMemberExpression`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:43` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `ReadStream`
`internal:fs/streams` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:56` | Self: 0.0% (1.5ms) | Total: 0.4% (9.3ms) | Samples: 1

**Called by:**
- `isReferenceIdentifier` (6)

**Calls:**
- `get properties` (2)
- `get parent` (1)
- `get properties` (1)
- `get parent` (1)

### `get computed`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1995` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `isNotReference` (1)

### `_isOptionalTag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_isChainNode` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:428` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `at`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getParenthesizedRange` (1)

### `fixSpaceAroundKeyword`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/fix/fix-space-around-keywords.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `generatorResume` (1)

### `_resolveHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:72` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:62` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `isReferenceIdentifier` (1)

### `charCodeAt`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_makeToken` (1)

### `isFixable`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:335` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `isMethodCall`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:46` | Self: 0.0% (1.4ms) | Total: 4.1% (88.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (57)

**Calls:**
- `isCallExpression` (52)
- `create` (3)
- `create` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2233` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `create`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:25` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `isCallExpression` (1)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:5` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `isReferenceIdentifier` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2229` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6954` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_rangeOf`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4009` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `insertTextAfter` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4927` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/change-case/dist/index.js:179` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `map` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6956` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `get typeAnnotation`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2779` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `split`
`/Users/ericsan/node_modules/change-case/dist/index.js:20` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `splitPrefixSuffix` (1)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1971` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getTokenBefore` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2325` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `get callee`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `isMethodCall` (1)

### `Symbol.iterator`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `from` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2323` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `create`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:62` | Self: 0.0% (1.3ms) | Total: 2.9% (61.9ms) | Samples: 1

**Called by:**
- `isCallExpression` (36)
- `isMethodCall` (3)

**Calls:**
- `get arguments` (34)
- `get arguments` (2)
- `get arguments` (1)
- `get arguments` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_getOrBuildPlan` (1)

### `isReferenceIdentifier`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `/[\\/]eslint-plugin-unicorn[\\/]rules[\\/]rule[\\/]unicorn-listeners\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-switch\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-json-parse-buffer\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]consistent-empty-array-spread\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]consistent-assert\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-useless-switch-case\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-object-from-entries\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-export-from\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-import-meta-properties\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-thenable\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-array-reduce\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-process-exit\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-single-call\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-array-callback-reference\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-string-slice\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-nested-ternary\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-console-spaces\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-global-this\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]consistent-existence-index-check\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-array-flat\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-prototype-methods\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-invalid-fetch-options\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-array-for-each\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-await-in-promise-methods\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-useless-length-check\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-modern-math-apis\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]no-abusive-eslint-disable\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-regexp-test\.js$\|[\\/]eslint-plugin-unicorn[\\/]rules[\\/]prefer-date-now\.js$/`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/index.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `map` (1)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1962` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getTokenBefore` (1)

### `map`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.7% (15.1ms) | Samples: 1

**Called by:**
- `(module)` (6)
- `camelCase` (2)
- `get properties` (1)
- `(module)` (1)
- `runPlugins` (1)

**Calls:**
- `(anonymous)` (5)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `toLocaleLowerCase` (1)
- `_intern` (1)

### `get arguments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1927` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `create` (1)

### `(module)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/filename-case.js:20` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `evaluate` (1)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:800` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_computeIdentifierName` (1)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1193` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_makeToken` (1)

### `next`
`[native code]` | Self: 0.0% (1.2ms) | Total: 25.8% (550.6ms) | Samples: 1

**Called by:**
- `iterateFixOrProblems` (177)
- `iterateFixOrProblems` (176)
- `Set` (1)

**Calls:**
- `generatorResume` (353)

### `(anonymous)`
`/Users/ericsan/node_modules/caniuse-lite/data/agents.js:1` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:607` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `getAllComments` (1)

### `toLocaleLowerCase`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `map` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2192` | Self: 0.0% (1.2ms) | Total: 0.2% (5.9ms) | Samples: 1

**Called by:**
- `(anonymous)` (2)
- `_buildScope` (2)

**Calls:**
- `_buildScope` (2)
- `_buildScope` (1)

### `addPolyfillToken`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:47` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3339` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `_isStatementTag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:72` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `get range` (1)

### `dlopen`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `dlopen` (1)

### `_intern`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:382` | Self: 0.0% (1.1ms) | Total: 0.0% (1.1ms) | Samples: 1

**Called by:**
- `map` (1)

### `isCallExpression`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:100` | Self: 0.0% (1.0ms) | Total: 3.7% (79.0ms) | Samples: 1

**Called by:**
- `isMethodCall` (52)

**Calls:**
- `create` (36)
- `create` (13)
- `create` (1)
- `create` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4112` | Self: 0.0% (1.0ms) | Total: 0.0% (1.0ms) | Samples: 1

**Called by:**
- `report` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8043` | Self: 0.0% (0us) | Total: 0.2% (5.5ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (4)

**Calls:**
- `get source` (4)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/rules/utils/lazy-loading-rule-map.js:7` | Self: 0.0% (0us) | Total: 0.1% (3.2ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_tryLoad`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-source-code.js:44` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `isAvailable` (1)

**Calls:**
- `dlopen` (1)

### `serialize`
`/Users/ericsan/node_modules/uri-js/dist/es5/uri.all.js:1012` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_getFullPath` (1)

**Calls:**
- `test` (1)

### `_getFullPath`
`/Users/ericsan/node_modules/ajv/lib/compile/resolve.js:215` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `resolveIds` (1)

**Calls:**
- `serialize` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:362` | Self: 0.0% (0us) | Total: 0.7% (15.6ms) | Samples: 0

**Called by:**
- `some` (10)

**Calls:**
- `get typeAnnotation` (8)
- `get typeAnnotation` (1)
- `get typeAnnotation` (1)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2019` | Self: 0.0% (0us) | Total: 1.4% (31.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (21)

**Calls:**
- `_precomputeScopes` (16)
- `_precomputeScopes` (3)
- `_precomputeScopes` (1)
- `_precomputeScopes` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3259` | Self: 0.0% (0us) | Total: 0.8% (17.7ms) | Samples: 0

**Called by:**
- `isFunctionParametersSafeToFix` (11)

**Calls:**
- `_computeDeclaredVariables` (6)
- `_computeDeclaredVariables` (2)
- `_computeDeclaredVariables` (1)
- `_computeDeclaredVariables` (1)
- `_computeDeclaredVariables` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:98` | Self: 0.0% (0us) | Total: 0.1% (2.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `addPolyfillToken` (2)

### `(module)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:60` | Self: 0.0% (0us) | Total: 0.4% (8.7ms) | Samples: 0

**Called by:**
- `evaluate` (6)

**Calls:**
- `map` (6)

### `internal:streams/compose`
`internal:streams/compose:2` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 23.8% (509.4ms) | Samples: 0

**Called by:**
- `loadPlugin` (78)
- `(anonymous)` (28)
- `(anonymous)` (17)
- `(anonymous)` (12)
- `(anonymous)` (12)
- `(anonymous)` (10)
- `(anonymous)` (9)
- `(anonymous)` (9)
- `(anonymous)` (9)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (5)
- `patchAstUtils` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
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

**Calls:**
- `require` (337)
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/config/default-config.js:37` | Self: 0.0% (0us) | Total: 0.4% (10.4ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `resolveIds`
`/Users/ericsan/node_modules/ajv/lib/compile/resolve.js:235` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_addSchema` (1)

**Calls:**
- `_getFullPath` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1697` | Self: 0.0% (0us) | Total: 0.7% (15.2ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (10)

**Calls:**
- `_nodesFromRange` (9)
- `_nodesFromRange` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1290` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_getAllTokens` (1)

**Calls:**
- `charCodeAt` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/dotjs/index.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4132` | Self: 0.0% (0us) | Total: 28.5% (608.6ms) | Samples: 0

**Called by:**
- `_drainAndReport` (395)

**Calls:**
- `_execReport` (393)
- `_execReport` (1)
- `_execReport` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/levn/lib/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `invokeHandlersWithNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6754` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:24` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/regexp-tree.js:8` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` | Self: 0.0% (0us) | Total: 0.1% (3.3ms) | Samples: 0

**Called by:**
- `parseSource` (2)

**Calls:**
- `encodeInto` (2)

### `loadPlugin`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:95` | Self: 0.0% (0us) | Total: 5.4% (115.7ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (78)

**Calls:**
- `bound require` (78)

### `splitPrefixSuffix`
`/Users/ericsan/node_modules/change-case/dist/index.js:205` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `camelCase` (1)

**Calls:**
- `split` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:490` | Self: 0.0% (0us) | Total: 0.2% (5.9ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `CfgGraph` (1)

### `linkAndEvaluateModule`
`[native code]` | Self: 0.0% (0us) | Total: 0.2% (5.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `link` (4)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8012` | Self: 0.0% (0us) | Total: 0.0% (1.1ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `map` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6795` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `get end` (1)

### `camelCase`
`/Users/ericsan/node_modules/change-case/dist/index.js:68` | Self: 0.0% (0us) | Total: 0.1% (2.6ms) | Samples: 0

**Called by:**
- `addPolyfillToken` (2)

**Calls:**
- `map` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/debug/src/index.js:9` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `node:stream`
`node:stream:2` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `isAvailable`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-source-code.js:56` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `_getFfi` (2)

**Calls:**
- `_tryLoad` (1)
- `_tryLoad` (1)

### `findVariable`
`/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:58` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `isFunctionParametersSafeToFix` (1)

**Calls:**
- `get` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8050` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `buildVisitorMap` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/compile/index.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/transform/index.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1495` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (1)

**Calls:**
- `_nodesFromRange` (1)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1633` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `getSurroundingParentheses` (1)

**Calls:**
- `wrap` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7527` | Self: 0.0% (0us) | Total: 0.2% (4.3ms) | Samples: 0

**Called by:**
- `runPlugins` (3)

**Calls:**
- `getDFSEvents` (1)
- `getDFSEvents` (1)
- `getDFSEvents` (1)

### `isFixable`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:363` | Self: 0.0% (0us) | Total: 10.0% (214.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (138)

**Calls:**
- `isFunctionParametersSafeToFix` (83)
- `isFunctionParametersSafeToFix` (33)
- `isFunctionParametersSafeToFix` (11)
- `isFunctionParametersSafeToFix` (8)
- `isFunctionParametersSafeToFix` (2)
- `isFunctionParametersSafeToFix` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/ajv.js:29` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/linter/linter.js:48` | Self: 0.0% (0us) | Total: 0.1% (2.8ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `addPolyfillToken`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:55` | Self: 0.0% (0us) | Total: 0.2% (5.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)
- `(anonymous)` (2)

**Calls:**
- `camelCase` (2)
- `camelCase` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/config/config.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7745` | Self: 0.0% (0us) | Total: 0.7% (16.1ms) | Samples: 0

**Called by:**
- `runPlugins` (10)

**Calls:**
- `_invokeFused` (10)

### `(anonymous)`
`/Users/ericsan/node_modules/core-js-compat/compat.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1028` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `findVariable` (1)

**Calls:**
- `_ensureVarsSet` (1)

### `isFixable`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:362` | Self: 0.0% (0us) | Total: 0.7% (15.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (10)

**Calls:**
- `some` (10)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3303` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (1)

**Calls:**
- `from` (1)

### `getParentheses`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/parentheses.js:25` | Self: 0.0% (0us) | Total: 0.6% (13.6ms) | Samples: 0

**Called by:**
- `removeParentheses` (9)

**Calls:**
- `generatorResume` (9)

### `(anonymous)`
`/Users/ericsan/node_modules/levn/lib/parse-string.js:113` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/compat-transpiler/index.js:9` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `addSchema`
`/Users/ericsan/node_modules/ajv/lib/ajv.js:137` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `addMetaSchema` (1)

**Calls:**
- `_addSchema` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/config/config.js:15` | Self: 0.0% (0us) | Total: 0.3% (7.6ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `get properties`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3131` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `isNotReference` (1)

**Calls:**
- `map` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/browserslist/node.js:2` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2851` | Self: 0.0% (0us) | Total: 1.1% (24.4ms) | Samples: 0

**Called by:**
- `getScope` (16)

**Calls:**
- `commentsInRange` (5)
- `commentsInRange` (5)
- `commentsInRange` (4)
- `commentsInRange` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/linter/apply-disable-directives.js:22` | Self: 0.0% (0us) | Total: 0.6% (13.9ms) | Samples: 0

**Called by:**
- `anonymous` (9)

**Calls:**
- `bound require` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/linter/linter.js:19` | Self: 0.0% (0us) | Total: 0.7% (15.5ms) | Samples: 0

**Called by:**
- `anonymous` (10)

**Calls:**
- `bound require` (10)

### `_drainAndReport`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:92` | Self: 0.0% (0us) | Total: 28.5% (608.6ms) | Samples: 0

**Called by:**
- `_drainAndReport` (395)

**Calls:**
- `report` (395)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/ajv.js:9` | Self: 0.0% (0us) | Total: 0.1% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `getSurroundingParentheses`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/iterate-surrounding-parentheses.js:30` | Self: 0.0% (0us) | Total: 0.6% (13.6ms) | Samples: 0

**Called by:**
- `iterateSurroundingParentheses` (9)

**Calls:**
- `getTokenBefore` (6)
- `getTokenBefore` (2)
- `getTokenBefore` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/browserslist/index.js:3` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `iterateSurroundingParentheses`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/iterate-surrounding-parentheses.js:67` | Self: 0.0% (0us) | Total: 0.6% (13.6ms) | Samples: 0

**Called by:**
- `generatorResume` (9)

**Calls:**
- `getSurroundingParentheses` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.1% (2.5ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:408` | Self: 0.0% (0us) | Total: 4.2% (91.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (61)

**Calls:**
- `_buildScope` (31)
- `getScope` (21)
- `_buildScope` (2)
- `_buildScope` (2)
- `_buildScope` (2)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` | Self: 0.0% (0us) | Total: 10.3% (220.0ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (144)

**Calls:**
- `parse` (144)

### `iterateFixOrProblems`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js:24` | Self: 0.0% (0us) | Total: 28.0% (598.2ms) | Samples: 0

**Called by:**
- `generatorResume` (388)

**Calls:**
- `generatorResume` (212)
- `next` (176)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:274` | Self: 0.0% (0us) | Total: 82.9% (1.76s) | Samples: 0

**Called by:**
- `(anonymous)` (1150)

**Calls:**
- `runPlugins` (1144)
- `runPlugins` (4)
- `runPlugins` (1)
- `runPlugins` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/source-code.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:8` | Self: 0.0% (0us) | Total: 1.5% (33.3ms) | Samples: 0

**Called by:**
- `isReferenceIdentifier` (22)

**Calls:**
- `_nodeViewRaw` (21)
- `_nodeViewRaw` (1)

### `getLastTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3491` | Self: 0.0% (0us) | Total: 0.1% (3.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `getTokens` (2)

### `wrap`
`bun:ffi:296` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `getTokenBefore` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/languages/js/index.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/@eslint/config-array/dist/cjs/index.cjs:5` | Self: 0.0% (0us) | Total: 0.1% (3.2ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/browserslist/index.js:9` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/index.js:8` | Self: 0.0% (0us) | Total: 0.3% (7.8ms) | Samples: 0

**Called by:**
- `parseModule` (5)

**Calls:**
- `bound require` (5)

### `_drainAndReport`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:84` | Self: 0.0% (0us) | Total: 28.5% (608.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (395)

**Calls:**
- `_drainAndReport` (395)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:18` | Self: 0.0% (0us) | Total: 0.1% (2.6ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `_getFfi`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:72` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `getTokenBefore` (2)

**Calls:**
- `isAvailable` (2)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3613` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `getFirstToken` (1)

**Calls:**
- `_isStatementTag` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/cli-engine/hash.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `replaceReturnStatement`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:139` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `generatorResume` (1)

**Calls:**
- `get argument` (1)

### `_computeIdentifierName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4098` | Self: 0.0% (0us) | Total: 1.2% (25.9ms) | Samples: 0

**Called by:**
- `_NodeView_LR` (16)

**Calls:**
- `source` (16)

### `isFunctionParametersSafeToFix`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:284` | Self: 0.0% (0us) | Total: 0.8% (17.7ms) | Samples: 0

**Called by:**
- `isFixable` (11)

**Calls:**
- `getDeclaredVariables` (11)

### `from`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_computeDeclaredVariables` (1)

**Calls:**
- `Symbol.iterator` (1)

### `internal:stream`
`internal:stream:2` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/parser/index.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.8% (17.1ms) | Samples: 0

**Calls:**
- `parseModule` (11)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:142` | Self: 0.0% (0us) | Total: 5.4% (115.7ms) | Samples: 0

**Calls:**
- `loadPlugin` (78)

### `getFirstToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1455` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `replaceReturnStatement` (1)

**Calls:**
- `get range` (1)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 23.8% (507.6ms) | Samples: 0

**Called by:**
- `bound require` (337)

**Calls:**
- `anonymous` (260)
- `(anonymous)` (77)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/keyword.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4940` | Self: 0.0% (0us) | Total: 63.8% (1.36s) | Samples: 0

**Called by:**
- `walkNodes` (545)
- `walkNodes` (325)
- `walkNodes` (10)

**Calls:**
- `(anonymous)` (879)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:20` | Self: 0.0% (0us) | Total: 0.8% (18.4ms) | Samples: 0

**Called by:**
- `anonymous` (12)

**Calls:**
- `bound require` (12)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:20` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:455` | Self: 0.0% (0us) | Total: 0.3% (7.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/source-code.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` | Self: 0.0% (0us) | Total: 0.2% (5.9ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `AstView` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1720` | Self: 0.0% (0us) | Total: 0.2% (5.6ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (4)

**Calls:**
- `_nodeViewRaw` (4)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` | Self: 0.0% (0us) | Total: 10.7% (229.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (147)

**Calls:**
- `parseSource` (144)
- `parseSource` (2)
- `parseSource` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/dotjs/index.js:22` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `internal:streams/operators`
`internal:streams/operators:2` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4230` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `get arguments` (1)

**Calls:**
- `_isChainNode` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/token-store/index.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/compat-transpiler/runtime/index.js:118` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:259` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `generatorResume` (1)

**Calls:**
- `insertTextAfter` (1)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:61` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `isReferenceIdentifier` (1)

**Calls:**
- `get parent` (1)

### `get properties`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3125` | Self: 0.0% (0us) | Total: 0.1% (3.5ms) | Samples: 0

**Called by:**
- `isNotReference` (2)

**Calls:**
- `_nodesFromRange` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:97` | Self: 0.0% (0us) | Total: 0.2% (4.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `addPolyfillToken` (2)
- `addPolyfillToken` (1)

### `performIteration`
`[native code]` | Self: 0.0% (0us) | Total: 28.4% (606.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (393)

**Calls:**
- `generatorResume` (393)

### `Comparator`
`/Users/ericsan/node_modules/semver/classes/comparator.js:21` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `[Symbol.split]` (1)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:851` | Self: 0.0% (0us) | Total: 0.4% (10.3ms) | Samples: 0

**Called by:**
- `_ensureDeclSymIndex` (6)

**Calls:**
- `_buildSymNameCache` (6)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/config/config-loader.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `some`
`[native code]` | Self: 0.0% (0us) | Total: 0.8% (17.5ms) | Samples: 0

**Called by:**
- `isFixable` (10)
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (10)
- `isNodeMatchesNameOrPath` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:911` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `get` (1)

**Calls:**
- `_buildScopeVarsAndSet` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:23` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(module)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/index.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `evaluate` (1)

**Calls:**
- `map` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/optimizer/index.js:11` | Self: 0.0% (0us) | Total: 0.1% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/source-code.js:21` | Self: 0.0% (0us) | Total: 0.1% (3.5ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/core-js-compat/index.js:2` | Self: 0.0% (0us) | Total: 0.4% (10.4ms) | Samples: 0

**Called by:**
- `parseModule` (7)

**Calls:**
- `bound require` (7)

### `_tryLoad`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-source-code.js:34` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `isAvailable` (1)

**Calls:**
- `bound join` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/ajv.js:3` | Self: 0.0% (0us) | Total: 0.1% (3.2ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `get ReadStream`
`node:fs:573` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/semver/internal/re.js:158` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `createToken` (1)

### `_getOrBuildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6040` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_buildPlan` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:458` | Self: 0.0% (0us) | Total: 10.8% (231.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (149)

**Calls:**
- `isFixable` (138)
- `isFixable` (10)
- `isFixable` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/compile/rules.js:3` | Self: 0.0% (0us) | Total: 0.1% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:437` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `some` (1)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:25` | Self: 0.0% (0us) | Total: 0.2% (4.5ms) | Samples: 0

**Called by:**
- `isReferenceIdentifier` (3)

**Calls:**
- `get params` (3)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/languages/js/index.js:12` | Self: 0.0% (0us) | Total: 0.3% (7.4ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js:133` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4085` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `report` (1)

**Calls:**
- `getLocFromIndex` (1)

### `internal:streams/pipeline`
`internal:streams/pipeline:2` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7113` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_getOrBuildPlan` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/transform/index.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1947` | Self: 0.0% (0us) | Total: 22.0% (470.3ms) | Samples: 0

**Called by:**
- `getTokenBefore` (303)

**Calls:**
- `_getAllTokens` (298)
- `_getAllTokens` (5)

### `processTicksAndRejections`
`[native code]` | Self: 0.0% (0us) | Total: 93.7% (1.99s) | Samples: 0

**Calls:**
- `(anonymous)` (1297)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-rule-fixer.js:37` | Self: 0.0% (0us) | Total: 28.4% (606.0ms) | Samples: 0

**Called by:**
- `_execReport` (393)

**Calls:**
- `performIteration` (393)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6792` | Self: 0.0% (0us) | Total: 0.1% (4.2ms) | Samples: 0

**Called by:**
- `walkNodes` (2)

**Calls:**
- `get value` (1)
- `get value` (1)

### `_isChainNode`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3924` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `nodeViewChain` (1)

**Calls:**
- `_isOptionalTag` (1)

### `get params`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2568` | Self: 0.0% (0us) | Total: 0.2% (5.9ms) | Samples: 0

**Called by:**
- `isNotReference` (4)

**Calls:**
- `_nodesFromRange` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:497` | Self: 0.0% (0us) | Total: 0.3% (7.1ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `patchAstUtils` (5)

### `(anonymous)`
`/Users/ericsan/node_modules/browserslist/index.js:1` | Self: 0.0% (0us) | Total: 0.1% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/eslint/eslint.js:19` | Self: 0.0% (0us) | Total: 0.6% (13.6ms) | Samples: 0

**Called by:**
- `anonymous` (9)

**Calls:**
- `bound require` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:28` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `readFileSync` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/@eslint/config-array/node_modules/minimatch/dist/commonjs/index.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/regexp-tree.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/linter/esquery.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:17` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `insertTextAfter`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4038` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `_rangeOf` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/compile/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `UnicornListeners`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:42` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `internal:fs/streams`
`internal:fs/streams:2` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/@eslint/plugin-kit/dist/cjs/index.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-create.js:35` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (1)

**Calls:**
- `UnicornListeners` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/config/config.js:14` | Self: 0.0% (0us) | Total: 0.2% (4.6ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `create`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:40` | Self: 0.0% (0us) | Total: 0.9% (20.8ms) | Samples: 0

**Called by:**
- `isCallExpression` (13)
- `isMethodCall` (1)

**Calls:**
- `copyDataProperties` (14)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3289` | Self: 0.0% (0us) | Total: 0.4% (10.3ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (6)

**Calls:**
- `_ensureDeclSymIndex` (6)

### `(anonymous)`
`/Users/ericsan/node_modules/prelude-ls/lib/index.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/compile/resolve.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:25` | Self: 0.0% (0us) | Total: 0.6% (13.8ms) | Samples: 0

**Called by:**
- `parseModule` (9)

**Calls:**
- `bound require` (9)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/eslint/eslint.js:44` | Self: 0.0% (0us) | Total: 1.1% (25.2ms) | Samples: 0

**Called by:**
- `anonymous` (17)

**Calls:**
- `bound require` (17)

### `(anonymous)`
`/Users/ericsan/node_modules/semver/index.js:29` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/semver/ranges/subset.js:73` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `Comparator` (1)

### `bound join`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_tryLoad` (1)

**Calls:**
- `join` (1)

### `fixSpaceAroundKeyword`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/fix/fix-space-around-keywords.js:24` | Self: 0.0% (0us) | Total: 26.5% (565.0ms) | Samples: 0

**Called by:**
- `generatorResume` (366)

**Calls:**
- `getTokenBefore` (366)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `moduleEvaluation`
`[native code]` | Self: 0.0% (0us) | Total: 1.6% (36.1ms) | Samples: 0

**Called by:**
- `moduleEvaluation` (16)
- `(anonymous)` (9)

**Calls:**
- `moduleEvaluation` (16)
- `evaluate` (9)

### `(anonymous)`
`/Users/ericsan/node_modules/@eslint/config-array/node_modules/minimatch/dist/commonjs/ast.js:7` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2955` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `defs` (1)

**Calls:**
- `get parent` (1)

### `isNodeMatchesNameOrPath`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/is-node-matches.js:9` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `some` (1)

**Calls:**
- `stringSplitFast` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/cli-engine/lint-result-cache.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3301` | Self: 0.0% (0us) | Total: 0.1% (3.0ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (2)

**Calls:**
- `Set` (2)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1948` | Self: 0.0% (0us) | Total: 1.6% (34.4ms) | Samples: 0

**Called by:**
- `getTokenBefore` (23)

**Calls:**
- `getAllComments` (23)

### `(anonymous)`
`/Users/ericsan/node_modules/caniuse-lite/dist/unpacker/browsers.js:1` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/globals/index.js:2` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:104` | Self: 0.0% (0us) | Total: 0.3% (7.1ms) | Samples: 0

**Called by:**
- `map` (5)

**Calls:**
- `(anonymous)` (3)
- `(anonymous)` (2)

### `needsSemicolon`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/needs-semicolon.js:52` | Self: 0.0% (0us) | Total: 0.3% (7.5ms) | Samples: 0

**Called by:**
- `replaceReturnStatement` (5)

**Calls:**
- `getNodeByRangeIndex` (2)
- `getNodeByRangeIndex` (2)
- `getNodeByRangeIndex` (1)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1616` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `getSurroundingParentheses` (2)

**Calls:**
- `_getFfi` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/core-js-compat/compat.js:7` | Self: 0.0% (0us) | Total: 0.4% (9.1ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/linter/index.js:3` | Self: 0.0% (0us) | Total: 0.8% (18.4ms) | Samples: 0

**Called by:**
- `anonymous` (12)

**Calls:**
- `bound require` (12)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/rules/index.js:11` | Self: 0.0% (0us) | Total: 0.1% (3.2ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `evaluate`
`[native code]` | Self: 0.0% (0us) | Total: 0.6% (12.9ms) | Samples: 0

**Called by:**
- `moduleEvaluation` (9)

**Calls:**
- `(module)` (6)
- `(module)` (1)
- `(module)` (1)
- `(module)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/index.js:3` | Self: 0.0% (0us) | Total: 0.2% (6.1ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `bound require` (4)

### `link`
`[native code]` | Self: 0.0% (0us) | Total: 0.7% (15.5ms) | Samples: 0

**Called by:**
- `link` (7)
- `linkAndEvaluateModule` (4)

**Calls:**
- `link` (7)
- `moduleDeclarationInstantiation` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `bound require` (1)

### `getAllComments`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3457` | Self: 0.0% (0us) | Total: 1.6% (34.4ms) | Samples: 0

**Called by:**
- `_getTokensAndCommentsMerged` (23)

**Calls:**
- `commentsInRange` (6)
- `commentsInRange` (5)
- `commentsInRange` (4)
- `commentsInRange` (3)
- `commentsInRange` (3)
- `commentsInRange` (1)
- `commentsInRange` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:417` | Self: 0.0% (0us) | Total: 9.3% (198.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (129)

**Calls:**
- `isReferenceIdentifier` (115)
- `isReferenceIdentifier` (13)
- `isReferenceIdentifier` (1)

### `replaceReturnStatement`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:162` | Self: 0.0% (0us) | Total: 0.3% (7.5ms) | Samples: 0

**Called by:**
- `generatorResume` (5)

**Calls:**
- `needsSemicolon` (5)

### `createToken`
`/Users/ericsan/node_modules/semver/internal/re.js:49` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `RegExp` (1)

### `Set`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (3.0ms) | Samples: 0

**Called by:**
- `_computeDeclaredVariables` (2)

**Calls:**
- `arrayIteratorNextHelper` (1)
- `next` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/find-up/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1673` | Self: 0.0% (0us) | Total: 26.5% (565.0ms) | Samples: 0

**Called by:**
- `fixSpaceAroundKeyword` (366)

**Calls:**
- `_getTokensAndCommentsMerged` (303)
- `_getTokensAndCommentsMerged` (32)
- `_getTokensAndCommentsMerged` (23)
- `_getTokensAndCommentsMerged` (6)
- `_getTokensAndCommentsMerged` (1)
- `_getTokensAndCommentsMerged` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/shared/ajv.js:11` | Self: 0.0% (0us) | Total: 0.3% (7.6ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/node_modules/caniuse-lite/dist/unpacker/agents.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/levn/lib/index.js:22` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `_addSchema`
`/Users/ericsan/node_modules/ajv/lib/ajv.js:309` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `addSchema` (1)

**Calls:**
- `resolveIds` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:220` | Self: 0.0% (0us) | Total: 0.1% (3.3ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (2)

**Calls:**
- `_encodeSource` (2)

### `getParenthesizedRange`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/parentheses.js:46` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `getForOfLoopHeadRange` (1)

**Calls:**
- `at` (1)

### `iterateFixOrProblems`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js:23` | Self: 0.0% (0us) | Total: 28.4% (606.0ms) | Samples: 0

**Called by:**
- `generatorResume` (393)

**Calls:**
- `generatorResume` (216)
- `next` (177)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/optimizer/transforms/index.js:55` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/node_modules/minimatch/dist/commonjs/index.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.1% (2.5ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `_computeIdentifierName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` | Self: 0.0% (0us) | Total: 2.4% (51.9ms) | Samples: 0

**Called by:**
- `_NodeView_LR` (33)

**Calls:**
- `_resolveUnicodeEscapes` (22)
- `_identAt` (10)
- `_identAt` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:231` | Self: 0.0% (0us) | Total: 0.1% (3.2ms) | Samples: 0

**Called by:**
- `generatorResume` (2)

**Calls:**
- `getLastTokens` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/node_modules/minimatch/dist/commonjs/ast.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1733` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `_nodesFromRange` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4168` | Self: 0.0% (0us) | Total: 0.1% (2.8ms) | Samples: 0

**Called by:**
- `get parent` (1)
- `isMethodCall` (1)

**Calls:**
- `_computeNodeType` (2)

### `defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `isFunctionParametersSafeToFix` (1)

**Calls:**
- `_computeVarDefs` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/unsupported-api.js:14` | Self: 0.0% (0us) | Total: 1.9% (41.8ms) | Samples: 0

**Called by:**
- `parseModule` (28)

**Calls:**
- `bound require` (28)

### `(anonymous)`
`/Users/ericsan/node_modules/levn/lib/parse-string.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/caniuse-lite/dist/unpacker/agents.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `getForOfLoopHeadRange`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:128` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getParenthesizedRange` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/config/default-config.js:12` | Self: 0.0% (0us) | Total: 0.1% (3.2ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7670` | Self: 0.0% (0us) | Total: 0.3% (7.3ms) | Samples: 0

**Called by:**
- `runPlugins` (4)

**Calls:**
- `invokeMethodFnHandlers` (2)
- `invokeMethodFnHandlers` (1)
- `invokeMethodFnHandlers` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4599` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `(anonymous)` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2302` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_buildScope` (1)

**Calls:**
- `get parent` (1)

### `addMetaSchema`
`/Users/ericsan/node_modules/ajv/lib/ajv.js:152` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `addSchema` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2137` | Self: 0.0% (0us) | Total: 0.4% (10.3ms) | Samples: 0

**Called by:**
- `_computeDeclaredVariables` (6)

**Calls:**
- `_symName` (6)

### `(anonymous)`
`/Users/ericsan/node_modules/core-js-compat/targets-parser.js:2` | Self: 0.0% (0us) | Total: 0.4% (9.1ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:560` | Self: 0.0% (0us) | Total: 0.2% (5.5ms) | Samples: 0

**Called by:**
- `runPlugins` (4)

**Calls:**
- `decode` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` | Self: 0.0% (0us) | Total: 0.4% (10.4ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:16` | Self: 0.0% (0us) | Total: 0.2% (5.9ms) | Samples: 0

**Called by:**
- `isReferenceIdentifier` (4)

**Calls:**
- `get params` (4)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6816` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `invokeHandlersWithNode` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4100` | Self: 0.0% (0us) | Total: 28.4% (606.0ms) | Samples: 0

**Called by:**
- `report` (393)

**Calls:**
- `(anonymous)` (393)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:221` | Self: 0.0% (0us) | Total: 0.1% (3.1ms) | Samples: 0

**Called by:**
- `generatorResume` (2)

**Calls:**
- `getForOfLoopHeadText` (1)
- `getForOfLoopHeadRange` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/linter/source-code-traverser.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7744` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `get` (1)

### `dlopen`
`bun:ffi:345` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_tryLoad` (1)

**Calls:**
- `dlopen` (1)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1647` | Self: 0.0% (0us) | Total: 0.4% (9.1ms) | Samples: 0

**Called by:**
- `getSurroundingParentheses` (6)

**Calls:**
- `_makeToken` (4)
- `_makeToken` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/regexp-tree.js:10` | Self: 0.0% (0us) | Total: 0.1% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/node_modules/minimatch/dist/commonjs/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/shared/ajv.js:29` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `addMetaSchema` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/semver/index.js:44` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `bound require` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8051` | Self: 0.0% (0us) | Total: 82.5% (1.76s) | Samples: 0

**Called by:**
- `_lintSourceOne` (1144)

**Calls:**
- `walkNodes` (549)
- `walkNodes` (462)
- `walkNodes` (23)
- `walkNodes` (19)
- `walkNodes` (17)
- `walkNodes` (15)
- `walkNodes` (10)
- `walkNodes` (8)
- `walkNodes` (7)
- `walkNodes` (6)
- `walkNodes` (5)
- `walkNodes` (5)
- `walkNodes` (4)
- `walkNodes` (3)
- `walkNodes` (3)
- `walkNodes` (2)
- `walkNodes` (2)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)

### `isFunctionParametersSafeToFix`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:287` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `isFixable` (1)

**Calls:**
- `defs` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/languages/js/index.js:15` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/semver/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `bound require` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1282` | Self: 0.0% (0us) | Total: 0.1% (3.4ms) | Samples: 0

**Called by:**
- `_getAllTokens` (2)

**Calls:**
- `_tokType` (1)
- `_tokType` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/eslint/eslint.js:20` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 39.8% | 849.9ms | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 21.3% | 455.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 20.1% | 429.2ms | `[native code]` |
| 5.8% | 124.0ms | `/Users/ericsan/Development/OpenSource/Ez/js/rewrite-helpers.js` |
| 4.7% | 100.9ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js` |
| 4.0% | 85.9ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js` |
| 1.1% | 25.3ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js` |
| 0.7% | 15.7ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js` |
| 0.6% | 13.9ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js` |
| 0.2% | 5.4ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js` |
| 0.2% | 4.7ms | `/Users/ericsan/node_modules/change-case/dist/index.js` |
| 0.2% | 4.3ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js` |
| 0.0% | 1.8ms | `/Users/ericsan/node_modules/regexp-tree/dist/compat-transpiler/runtime/index.js` |
| 0.0% | 1.7ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/fix/extend-fix-range.js` |
| 0.0% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` |
| 0.0% | 1.6ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/fix/remove-parentheses.js` |
| 0.0% | 1.5ms | `/Users/ericsan/node_modules/debug/src/node.js` |
| 0.0% | 1.5ms | `internal:fs/streams` |
| 0.0% | 1.4ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/fix/fix-space-around-keywords.js` |
| 0.0% | 1.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.3ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/index.js` |
| 0.0% | 1.3ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/filename-case.js` |
| 0.0% | 1.2ms | `/Users/ericsan/node_modules/caniuse-lite/data/agents.js` |
