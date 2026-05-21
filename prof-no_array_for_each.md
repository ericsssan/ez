# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 22.78s | 14889 | 1.0ms | 562 |

**Top 10:** `getRange` 26.7%, `isFunctionParametersSafeToFix` 13.6%, `isFunctionParametersSafeToFix` 12.9%, `get range` 11.3%, `source` 8.0%, `get range` 6.5%, `get name` 2.5%, `_nodesFromRange` 2.4%, `get name` 0.9%, `parse` 0.9%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 26.7% | 6.10s | 44.9% | 10.22s | `getRange` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3714` |
| 13.6% | 3.11s | 13.6% | 3.11s | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:301` |
| 12.9% | 2.94s | 25.6% | 5.83s | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:298` |
| 11.3% | 2.57s | 11.3% | 2.57s | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3582` |
| 8.0% | 1.84s | 8.0% | 1.84s | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` |
| 6.5% | 1.49s | 6.6% | 1.50s | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3630` |
| 2.5% | 574.1ms | 2.5% | 574.1ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1347` |
| 2.4% | 547.5ms | 2.5% | 576.8ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:905` |
| 0.9% | 227.0ms | 0.9% | 227.0ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.9% | 218.5ms | 0.9% | 218.5ms | `parse` | `[native code]` |
| 0.8% | 200.9ms | 0.8% | 200.9ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1267` |
| 0.8% | 184.8ms | 45.7% | 10.40s | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:299` |
| 0.7% | 181.5ms | 0.8% | 194.1ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1264` |
| 0.6% | 151.8ms | 0.6% | 151.8ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1354` |
| 0.6% | 143.6ms | 0.6% | 143.6ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1239` |
| 0.5% | 126.1ms | 7.5% | 1.71s | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7181` |
| 0.5% | 122.9ms | 0.5% | 122.9ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:53` |
| 0.5% | 115.2ms | 5.0% | 1.14s | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:55` |
| 0.4% | 105.5ms | 0.4% | 108.2ms | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:309` |
| 0.4% | 100.3ms | 100.0% | 64.02s | `generatorResume` | `[native code]` |
| 0.3% | 89.3ms | 0.3% | 90.6ms | `isIterable` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js:1` |
| 0.3% | 77.3ms | 0.3% | 77.3ms | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:297` |
| 0.3% | 76.6ms | 1.9% | 438.9ms | `anonymous` | `[native code]` |
| 0.3% | 75.1ms | 0.3% | 84.2ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1357` |
| 0.2% | 57.8ms | 0.2% | 57.8ms | `iterateFixOrProblems` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js:17` |
| 0.2% | 48.9ms | 0.2% | 48.9ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` |
| 0.2% | 47.0ms | 0.2% | 47.0ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4058` |
| 0.1% | 43.6ms | 0.1% | 43.6ms | `copyDataProperties` | `[native code]` |
| 0.1% | 37.2ms | 0.1% | 37.2ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 36.7ms | 0.1% | 36.7ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1235` |
| 0.1% | 35.3ms | 0.6% | 143.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 0.1% | 34.4ms | 0.5% | 125.0ms | `iterateFixOrProblems` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js:18` |
| 0.1% | 32.1ms | 0.1% | 32.1ms | `isReferenceIdentifier` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:149` |
| 0.1% | 31.6ms | 0.3% | 89.2ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:3` |
| 0.1% | 26.9ms | 0.1% | 26.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7418` |
| 0.1% | 24.9ms | 0.1% | 24.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6865` |
| 0.1% | 24.2ms | 0.1% | 24.2ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2720` |
| 0.1% | 23.3ms | 0.1% | 23.3ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1271` |
| 0.0% | 21.4ms | 0.0% | 21.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1244` |
| 0.0% | 19.1ms | 95.1% | 21.66s | `iterateFixOrProblems` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js:23` |
| 0.0% | 19.0ms | 0.0% | 19.0ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:54` |
| 0.0% | 19.0ms | 0.0% | 19.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7316` |
| 0.0% | 18.4ms | 0.1% | 39.4ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1926` |
| 0.0% | 17.2ms | 2.7% | 617.5ms | `_getAllTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1883` |
| 0.0% | 17.0ms | 0.0% | 17.0ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 16.5ms | 0.0% | 16.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4095` |
| 0.0% | 16.5ms | 0.0% | 16.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6861` |
| 0.0% | 14.6ms | 100.0% | 22.88s | `(anonymous)` | `[native code]` |
| 0.0% | 14.5ms | 3.2% | 732.3ms | `isReferenceIdentifier` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:158` |
| 0.0% | 13.9ms | 0.0% | 13.9ms | `create` | `[native code]` |
| 0.0% | 13.3ms | 0.0% | 13.3ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4132` |
| 0.0% | 13.2ms | 0.0% | 13.2ms | `_getAllTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1884` |
| 0.0% | 13.2ms | 0.0% | 13.2ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:656` |
| 0.0% | 12.6ms | 0.0% | 12.6ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1369` |
| 0.0% | 12.4ms | 0.0% | 12.4ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:236` |
| 0.0% | 11.7ms | 0.0% | 11.7ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1203` |
| 0.0% | 11.6ms | 0.0% | 17.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7349` |
| 0.0% | 11.0ms | 0.0% | 11.0ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:902` |
| 0.0% | 9.5ms | 0.0% | 9.5ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:810` |
| 0.0% | 9.0ms | 0.0% | 9.0ms | `get mainToken` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1105` |
| 0.0% | 8.9ms | 96.7% | 22.04s | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4775` |
| 0.0% | 8.7ms | 0.0% | 8.7ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 8.6ms | 0.0% | 19.1ms | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:53` |
| 0.0% | 8.3ms | 0.0% | 8.3ms | `get start` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 8.2ms | 3.0% | 705.6ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1624` |
| 0.0% | 8.2ms | 0.0% | 16.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7348` |
| 0.0% | 7.9ms | 0.0% | 7.9ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1177` |
| 0.0% | 7.7ms | 0.0% | 7.7ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 7.7ms | 0.0% | 7.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4111` |
| 0.0% | 7.6ms | 0.0% | 7.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2145` |
| 0.0% | 7.5ms | 0.2% | 45.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2161` |
| 0.0% | 7.5ms | 0.0% | 7.5ms | `get computed` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2011` |
| 0.0% | 7.2ms | 0.0% | 7.2ms | `set` | `[native code]` |
| 0.0% | 6.6ms | 0.0% | 6.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6847` |
| 0.0% | 6.3ms | 0.0% | 6.3ms | `toLocaleLowerCase` | `[native code]` |
| 0.0% | 6.3ms | 0.4% | 95.9ms | `parseModule` | `[native code]` |
| 0.0% | 6.1ms | 89.9% | 20.48s | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7380` |
| 0.0% | 6.1ms | 0.0% | 6.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1191` |
| 0.0% | 5.8ms | 0.0% | 5.8ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4393` |
| 0.0% | 5.7ms | 0.0% | 5.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7143` |
| 0.0% | 5.7ms | 0.0% | 5.7ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:5` |
| 0.0% | 5.5ms | 0.0% | 5.5ms | `get` | `[native code]` |
| 0.0% | 5.4ms | 0.0% | 5.4ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:403` |
| 0.0% | 5.4ms | 0.0% | 5.4ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3583` |
| 0.0% | 5.4ms | 0.0% | 5.4ms | `defineProperty` | `[native code]` |
| 0.0% | 5.0ms | 0.0% | 5.0ms | `removeCallbackParentheses` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:197` |
| 0.0% | 4.9ms | 0.0% | 4.9ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:61` |
| 0.0% | 4.9ms | 0.0% | 4.9ms | `test` | `[native code]` |
| 0.0% | 4.8ms | 0.0% | 4.8ms | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:31` |
| 0.0% | 4.7ms | 0.0% | 4.7ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1913` |
| 0.0% | 4.6ms | 0.0% | 4.6ms | `moduleDeclarationInstantiation` | `[native code]` |
| 0.0% | 4.5ms | 0.0% | 4.5ms | `get start` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1108` |
| 0.0% | 4.5ms | 0.0% | 6.1ms | `from` | `[native code]` |
| 0.0% | 4.5ms | 0.0% | 4.5ms | `resolve` | `[native code]` |
| 0.0% | 4.5ms | 0.0% | 4.5ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:855` |
| 0.0% | 4.5ms | 0.1% | 29.4ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2260` |
| 0.0% | 4.4ms | 0.0% | 4.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7141` |
| 0.0% | 4.4ms | 0.0% | 7.3ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:53` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 4.2ms | 0.0% | 4.2ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js` |
| 0.0% | 4.2ms | 0.3% | 77.6ms | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:46` |
| 0.0% | 4.1ms | 0.0% | 19.0ms | `getSurroundingParentheses` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/iterate-surrounding-parentheses.js:30` |
| 0.0% | 4.1ms | 0.1% | 25.4ms | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:40` |
| 0.0% | 4.0ms | 0.0% | 4.0ms | `getNodeByRangeIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3688` |
| 0.0% | 4.0ms | 0.0% | 4.0ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 3.9ms | 0.0% | 3.9ms | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:16` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `filter` | `[native code]` |
| 0.0% | 3.3ms | 0.0% | 4.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1223` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1205` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `getLocFromIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:617` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `decode` | `[native code]` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4110` |
| 0.0% | 3.1ms | 0.3% | 83.3ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4137` |
| 0.0% | 3.1ms | 0.0% | 4.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7351` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3132` |
| 0.0% | 3.1ms | 0.0% | 4.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7356` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7137` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `arguments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1926` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `isMemberExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:25` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3994` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:87` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:415` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6587` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2794` |
| 0.0% | 2.9ms | 0.1% | 34.7ms | `arguments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1931` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2181` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `ez_ffi_token_idx_at_or_before` | `[native code]` |
| 0.0% | 2.8ms | 0.0% | 9.4ms | `isMemberExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:39` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4156` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1273` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `has` | `[native code]` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `subarray` | `[native code]` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `getNodeByRangeIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3687` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2191` |
| 0.0% | 1.8ms | 0.1% | 36.1ms | `some` | `[native code]` |
| 0.0% | 1.8ms | 0.0% | 8.9ms | `isMemberExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:66` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/node_modules/caniuse-lite/dist/unpacker/agents.js:35` |
| 0.0% | 1.7ms | 0.0% | 4.4ms | `getInnermostScope` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:21` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4094` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2306` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `encodeInto` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get object` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1952` |
| 0.0% | 1.7ms | 3.4% | 781.1ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-rule-fixer.js:37` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 100.0% | 37.52s | `next` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 4.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2297` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get start` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1110` |
| 0.0% | 1.7ms | 0.0% | 6.2ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:434` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `dlopen` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1315` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get key` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3154` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2307` |
| 0.0% | 1.6ms | 2.4% | 567.5ms | `get properties` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3126` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3245` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:663` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1160` |
| 0.0% | 1.6ms | 0.0% | 3.0ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4162` |
| 0.0% | 1.6ms | 0.0% | 11.0ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:16` |
| 0.0% | 1.6ms | 2.3% | 530.1ms | `require` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `slice` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1579` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:261` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/rules/index.js:15` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getFixFunction` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:87` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `dlopen` | `bun:ffi:351` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get optional` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2238` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `typedArrayViewLength` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 17.3ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:612` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2924` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js` |
| 0.0% | 1.6ms | 0.0% | 5.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7153` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getForOfLoopHeadText` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:116` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3953` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:523` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:30` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `removeParentheses` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/fix/remove-parentheses.js:16` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `simpleArraySearchRule` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/shared/simple-array-search-rule.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4116` |
| 0.0% | 1.5ms | 0.0% | 17.8ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:613` |
| 0.0% | 1.5ms | 0.0% | 3.1ms | `readFileSync` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get consequent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1662` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getNodeByRangeIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3697` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1269` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `Map` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1356` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getLocFromIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3561` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3232` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:254` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 3.2ms | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:66` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2775` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1964` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `findVariable` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:53` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7342` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:851` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getInnermostScope` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:13` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get callee` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 6.0ms | `get properties` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3130` |
| 0.0% | 1.4ms | 0.0% | 2.8ms | `toEslintProblem` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-problem.js:18` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2526` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isCallExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:100` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getParentSyntaxOpeningParenthesis` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/get-parent-syntax-opening-parenthesis.js:21` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1371` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1168` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 4.9ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1736` |
| 0.0% | 1.4ms | 0.0% | 6.3ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2776` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getSurroundingParentheses` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/iterate-surrounding-parentheses.js:32` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_scopeForNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:884` |
| 0.0% | 1.4ms | 0.0% | 4.2ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1417` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isArray` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3632` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_rawTokenText` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 2.6ms | `scope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:784` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2979` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1376` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `buildExps` | `/Users/ericsan/node_modules/uri-js/dist/es5/uri.all.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1167` |
| 0.0% | 1.3ms | 0.0% | 5.8ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2866` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7291` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7317` |
| 0.0% | 1.3ms | 0.0% | 17.5ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:220` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:614` |
| 0.0% | 1.3ms | 0.1% | 25.5ms | `map` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `stringSplitFast` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5965` |
| 0.0% | 1.3ms | 0.0% | 2.6ms | `getFixFunction` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:93` |
| 0.0% | 1.3ms | 0.0% | 9.1ms | `findVariable` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:54` |
| 0.0% | 1.3ms | 0.0% | 15.9ms | `findVariable` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:58` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `fill` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `resolveIds` | `/Users/ericsan/node_modules/ajv/lib/compile/resolve.js:269` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getText` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1293` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_rawTokenText` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:831` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `cloneObject` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `Comparator` | `/Users/ericsan/node_modules/semver/classes/comparator.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_isOptionalTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.7% | 162.6ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:431` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1862` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `isFixable` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:352` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get property` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1974` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:518` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3252` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getParentSyntaxOpeningParenthesis` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/get-parent-syntax-opening-parenthesis.js:26` |
| 0.0% | 1.2ms | 0.0% | 2.9ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2088` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getText` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1306` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `iterateSurroundingParentheses` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/iterate-surrounding-parentheses.js:56` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2087` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_fromRunnerReport` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2126` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2527` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2535` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:425` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7636` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get params` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2583` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `stringify` | `/Users/ericsan/node_modules/fast-json-stable-stringify/index.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get key` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3155` |
| 0.0% | 1.0ms | 0.0% | 1.0ms | `get start` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1113` |
| 0.0% | 988us | 0.0% | 988us | `RegExp` | `[native code]` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 100.0% | 64.02s | 0.4% | 100.3ms | `generatorResume` | `[native code]` |
| 100.0% | 37.52s | 0.0% | 1.7ms | `next` | `[native code]` |
| 100.0% | 22.88s | 0.0% | 14.6ms | `(anonymous)` | `[native code]` |
| 99.4% | 22.64s | 0.0% | 0us | `processTicksAndRejections` | `[native code]` |
| 98.4% | 22.41s | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:274` |
| 98.3% | 22.40s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7664` |
| 96.7% | 22.04s | 0.0% | 8.9ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4775` |
| 95.1% | 21.66s | 0.0% | 19.1ms | `iterateFixOrProblems` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js:23` |
| 92.7% | 21.12s | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-listener.js:31` |
| 90.0% | 20.51s | 0.0% | 0us | `iterateFixOrProblems` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js:24` |
| 89.9% | 20.48s | 0.0% | 6.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7380` |
| 86.2% | 19.64s | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:454` |
| 86.1% | 19.61s | 0.0% | 0us | `isFixable` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:360` |
| 45.7% | 10.40s | 0.8% | 184.8ms | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:299` |
| 44.9% | 10.22s | 26.7% | 6.10s | `getRange` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3714` |
| 25.6% | 5.83s | 12.9% | 2.94s | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:298` |
| 13.6% | 3.11s | 13.6% | 3.11s | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:301` |
| 11.3% | 2.57s | 11.3% | 2.57s | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3582` |
| 8.0% | 1.84s | 8.0% | 1.84s | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` |
| 8.0% | 1.83s | 0.0% | 0us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1359` |
| 7.5% | 1.71s | 0.5% | 126.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7181` |
| 6.6% | 1.50s | 6.5% | 1.49s | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3630` |
| 5.0% | 1.14s | 0.5% | 115.2ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:55` |
| 3.4% | 790.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-listener.js:34` |
| 3.4% | 790.6ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4008` |
| 3.4% | 781.1ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-rule-fixer.js:37` |
| 3.4% | 781.1ms | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3978` |
| 3.4% | 779.4ms | 0.0% | 0us | `performIteration` | `[native code]` |
| 3.3% | 764.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:414` |
| 3.2% | 732.3ms | 0.0% | 14.5ms | `isReferenceIdentifier` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:158` |
| 3.1% | 706.9ms | 0.0% | 0us | `fixSpaceAroundKeyword` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/fix/fix-space-around-keywords.js:24` |
| 3.0% | 705.6ms | 0.0% | 8.2ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1624` |
| 2.7% | 630.7ms | 0.0% | 0us | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1898` |
| 2.7% | 617.5ms | 0.0% | 17.2ms | `_getAllTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1883` |
| 2.5% | 576.8ms | 2.4% | 547.5ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:905` |
| 2.5% | 574.1ms | 2.5% | 574.1ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1347` |
| 2.5% | 572.3ms | 0.0% | 0us | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:56` |
| 2.4% | 567.5ms | 0.0% | 1.6ms | `get properties` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3126` |
| 2.3% | 536.4ms | 0.0% | 0us | `bound require` | `[native code]` |
| 2.3% | 530.1ms | 0.0% | 1.6ms | `require` | `[native code]` |
| 1.9% | 438.9ms | 0.3% | 76.6ms | `anonymous` | `[native code]` |
| 0.9% | 227.7ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` |
| 0.9% | 227.0ms | 0.9% | 227.0ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.9% | 218.5ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` |
| 0.9% | 218.5ms | 0.9% | 218.5ms | `parse` | `[native code]` |
| 0.8% | 200.9ms | 0.8% | 200.9ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1267` |
| 0.8% | 194.1ms | 0.7% | 181.5ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1264` |
| 0.7% | 162.6ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:431` |
| 0.6% | 151.8ms | 0.6% | 151.8ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1354` |
| 0.6% | 143.6ms | 0.6% | 143.6ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1239` |
| 0.6% | 143.2ms | 0.1% | 35.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 0.5% | 125.0ms | 0.1% | 34.4ms | `iterateFixOrProblems` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js:18` |
| 0.5% | 122.9ms | 0.5% | 122.9ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:53` |
| 0.5% | 122.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-listener.js:29` |
| 0.5% | 115.8ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:142` |
| 0.5% | 115.8ms | 0.0% | 0us | `loadPlugin` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:89` |
| 0.4% | 108.2ms | 0.4% | 105.5ms | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:309` |
| 0.4% | 95.9ms | 0.0% | 6.3ms | `parseModule` | `[native code]` |
| 0.3% | 90.6ms | 0.3% | 89.3ms | `isIterable` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js:1` |
| 0.3% | 89.2ms | 0.1% | 31.6ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:3` |
| 0.3% | 86.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:405` |
| 0.3% | 84.2ms | 0.3% | 75.1ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1357` |
| 0.3% | 83.3ms | 0.0% | 3.1ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4137` |
| 0.3% | 77.6ms | 0.0% | 4.2ms | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:46` |
| 0.3% | 77.3ms | 0.3% | 77.3ms | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:297` |
| 0.2% | 57.8ms | 0.2% | 57.8ms | `iterateFixOrProblems` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js:17` |
| 0.2% | 48.9ms | 0.2% | 48.9ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` |
| 0.2% | 47.0ms | 0.2% | 47.0ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4058` |
| 0.2% | 45.9ms | 0.0% | 7.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2161` |
| 0.1% | 45.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/unsupported-api.js:14` |
| 0.1% | 43.6ms | 0.1% | 43.6ms | `copyDataProperties` | `[native code]` |
| 0.1% | 39.6ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4165` |
| 0.1% | 39.4ms | 0.0% | 18.4ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1926` |
| 0.1% | 39.4ms | 0.0% | 0us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1211` |
| 0.1% | 37.8ms | 0.0% | 0us | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:62` |
| 0.1% | 37.2ms | 0.1% | 37.2ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 36.8ms | 0.0% | 0us | `moduleEvaluation` | `[native code]` |
| 0.1% | 36.7ms | 0.1% | 36.7ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1235` |
| 0.1% | 36.1ms | 0.0% | 1.8ms | `some` | `[native code]` |
| 0.1% | 34.7ms | 0.0% | 2.9ms | `arguments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1931` |
| 0.1% | 32.1ms | 0.1% | 32.1ms | `isReferenceIdentifier` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:149` |
| 0.1% | 30.2ms | 0.0% | 0us | `isFixable` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:359` |
| 0.1% | 29.7ms | 0.0% | 0us | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:283` |
| 0.1% | 29.7ms | 0.0% | 0us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3180` |
| 0.1% | 29.4ms | 0.0% | 4.5ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2260` |
| 0.1% | 28.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:359` |
| 0.1% | 27.9ms | 0.0% | 0us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1367` |
| 0.1% | 27.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/eslint/eslint.js:44` |
| 0.1% | 26.9ms | 0.0% | 0us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1967` |
| 0.1% | 26.9ms | 0.1% | 26.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7418` |
| 0.1% | 26.6ms | 0.0% | 0us | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:308` |
| 0.1% | 25.5ms | 0.0% | 1.3ms | `map` | `[native code]` |
| 0.1% | 25.4ms | 0.0% | 4.1ms | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:40` |
| 0.1% | 24.9ms | 0.1% | 24.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6865` |
| 0.1% | 24.6ms | 0.0% | 0us | `getParentheses` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/parentheses.js:25` |
| 0.1% | 24.4ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7358` |
| 0.1% | 24.2ms | 0.1% | 24.2ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2720` |
| 0.1% | 23.3ms | 0.1% | 23.3ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1271` |
| 0.0% | 22.3ms | 0.0% | 0us | `getAllComments` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3369` |
| 0.0% | 22.3ms | 0.0% | 0us | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1899` |
| 0.0% | 21.4ms | 0.0% | 21.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1244` |
| 0.0% | 20.5ms | 0.0% | 0us | `iterateSurroundingParentheses` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/iterate-surrounding-parentheses.js:67` |
| 0.0% | 20.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/linter/index.js:3` |
| 0.0% | 20.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:20` |
| 0.0% | 19.1ms | 0.0% | 0us | `isMemberExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:67` |
| 0.0% | 19.1ms | 0.0% | 8.6ms | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:53` |
| 0.0% | 19.0ms | 0.0% | 4.1ms | `getSurroundingParentheses` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/iterate-surrounding-parentheses.js:30` |
| 0.0% | 19.0ms | 0.0% | 19.0ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:54` |
| 0.0% | 19.0ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2772` |
| 0.0% | 19.0ms | 0.0% | 19.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7316` |
| 0.0% | 18.8ms | 0.0% | 0us | `removeParentheses` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/fix/remove-parentheses.js:15` |
| 0.0% | 17.8ms | 0.0% | 1.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:613` |
| 0.0% | 17.7ms | 0.0% | 11.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7349` |
| 0.0% | 17.5ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:220` |
| 0.0% | 17.3ms | 0.0% | 1.6ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:612` |
| 0.0% | 17.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/linter/linter.js:19` |
| 0.0% | 17.0ms | 0.0% | 17.0ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 16.9ms | 0.0% | 0us | `link` | `[native code]` |
| 0.0% | 16.5ms | 0.0% | 16.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4095` |
| 0.0% | 16.5ms | 0.0% | 16.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6861` |
| 0.0% | 16.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/eslint/eslint.js:19` |
| 0.0% | 16.2ms | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 0.0% | 16.1ms | 0.0% | 8.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7348` |
| 0.0% | 15.9ms | 0.0% | 1.3ms | `findVariable` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:58` |
| 0.0% | 15.8ms | 0.0% | 0us | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:42` |
| 0.0% | 15.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/linter/apply-disable-directives.js:22` |
| 0.0% | 14.5ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1713` |
| 0.0% | 14.2ms | 0.0% | 0us | `get property` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1979` |
| 0.0% | 13.9ms | 0.0% | 13.9ms | `create` | `[native code]` |
| 0.0% | 13.3ms | 0.0% | 13.3ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4132` |
| 0.0% | 13.2ms | 0.0% | 13.2ms | `_getAllTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1884` |
| 0.0% | 13.2ms | 0.0% | 13.2ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:656` |
| 0.0% | 13.0ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1020` |
| 0.0% | 13.0ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:911` |
| 0.0% | 12.6ms | 0.0% | 12.6ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1369` |
| 0.0% | 12.4ms | 0.0% | 12.4ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:236` |
| 0.0% | 12.2ms | 0.0% | 0us | `evaluate` | `[native code]` |
| 0.0% | 11.7ms | 0.0% | 11.7ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1203` |
| 0.0% | 11.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:25` |
| 0.0% | 11.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/config/default-config.js:37` |
| 0.0% | 11.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/core-js-compat/index.js:2` |
| 0.0% | 11.0ms | 0.0% | 1.6ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:16` |
| 0.0% | 11.0ms | 0.0% | 11.0ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:902` |
| 0.0% | 10.2ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3210` |
| 0.0% | 10.0ms | 0.0% | 0us | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:8` |
| 0.0% | 9.5ms | 0.0% | 9.5ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:810` |
| 0.0% | 9.4ms | 0.0% | 2.8ms | `isMemberExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:39` |
| 0.0% | 9.3ms | 0.0% | 0us | `(module)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:60` |
| 0.0% | 9.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/core-js-compat/targets-parser.js:2` |
| 0.0% | 9.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/core-js-compat/compat.js:7` |
| 0.0% | 9.1ms | 0.0% | 1.3ms | `findVariable` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:54` |
| 0.0% | 9.0ms | 0.0% | 9.0ms | `get mainToken` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1105` |
| 0.0% | 8.9ms | 0.0% | 1.8ms | `isMemberExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:66` |
| 0.0% | 8.7ms | 0.0% | 8.7ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 8.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/shared/ajv.js:11` |
| 0.0% | 8.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/config/config.js:15` |
| 0.0% | 8.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` |
| 0.0% | 8.3ms | 0.0% | 8.3ms | `get start` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 8.3ms | 0.0% | 0us | `replaceReturnStatement` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:161` |
| 0.0% | 8.3ms | 0.0% | 0us | `needsSemicolon` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/needs-semicolon.js:52` |
| 0.0% | 8.1ms | 0.0% | 0us | `get params` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2584` |
| 0.0% | 7.9ms | 0.0% | 7.9ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1177` |
| 0.0% | 7.7ms | 0.0% | 7.7ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 7.7ms | 0.0% | 7.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4111` |
| 0.0% | 7.6ms | 0.0% | 7.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2145` |
| 0.0% | 7.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/index.js:8` |
| 0.0% | 7.5ms | 0.0% | 0us | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:286` |
| 0.0% | 7.5ms | 0.0% | 7.5ms | `get computed` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2011` |
| 0.0% | 7.3ms | 0.0% | 4.4ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:53` |
| 0.0% | 7.2ms | 0.0% | 7.2ms | `set` | `[native code]` |
| 0.0% | 6.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/languages/js/index.js:12` |
| 0.0% | 6.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/index.js:3` |
| 0.0% | 6.6ms | 0.0% | 6.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6847` |
| 0.0% | 6.3ms | 0.0% | 1.4ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2776` |
| 0.0% | 6.3ms | 0.0% | 6.3ms | `toLocaleLowerCase` | `[native code]` |
| 0.0% | 6.3ms | 0.0% | 0us | `camelCase` | `/Users/ericsan/node_modules/change-case/dist/index.js:68` |
| 0.0% | 6.2ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:434` |
| 0.0% | 6.2ms | 0.0% | 0us | `getForOfLoopHeadText` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:100` |
| 0.0% | 6.1ms | 0.0% | 4.5ms | `from` | `[native code]` |
| 0.0% | 6.1ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3224` |
| 0.0% | 6.1ms | 0.0% | 6.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1191` |
| 0.0% | 6.0ms | 0.0% | 0us | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:784` |
| 0.0% | 6.0ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2085` |
| 0.0% | 6.0ms | 0.0% | 0us | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:839` |
| 0.0% | 6.0ms | 0.0% | 1.4ms | `get properties` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3130` |
| 0.0% | 5.9ms | 0.0% | 0us | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 0.0% | 5.9ms | 0.0% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7153` |
| 0.0% | 5.8ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:478` |
| 0.0% | 5.8ms | 0.0% | 5.8ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4393` |
| 0.0% | 5.8ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` |
| 0.0% | 5.8ms | 0.0% | 1.3ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2866` |
| 0.0% | 5.8ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:455` |
| 0.0% | 5.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:497` |
| 0.0% | 5.7ms | 0.0% | 5.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7143` |
| 0.0% | 5.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:465` |
| 0.0% | 5.7ms | 0.0% | 5.7ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:5` |
| 0.0% | 5.6ms | 0.0% | 0us | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1607` |
| 0.0% | 5.5ms | 0.0% | 5.5ms | `get` | `[native code]` |
| 0.0% | 5.5ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1733` |
| 0.0% | 5.4ms | 0.0% | 5.4ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:403` |
| 0.0% | 5.4ms | 0.0% | 5.4ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3583` |
| 0.0% | 5.4ms | 0.0% | 5.4ms | `defineProperty` | `[native code]` |
| 0.0% | 5.3ms | 0.0% | 0us | `reduce` | `[native code]` |
| 0.0% | 5.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:225` |
| 0.0% | 5.0ms | 0.0% | 5.0ms | `removeCallbackParentheses` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:197` |
| 0.0% | 5.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/config/default-config.js:12` |
| 0.0% | 4.9ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7656` |
| 0.0% | 4.9ms | 0.0% | 4.9ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:61` |
| 0.0% | 4.9ms | 0.0% | 4.9ms | `test` | `[native code]` |
| 0.0% | 4.9ms | 0.0% | 1.4ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1736` |
| 0.0% | 4.8ms | 0.0% | 4.8ms | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:31` |
| 0.0% | 4.8ms | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3962` |
| 0.0% | 4.7ms | 0.0% | 4.7ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1913` |
| 0.0% | 4.6ms | 0.0% | 0us | `linkAndEvaluateModule` | `[native code]` |
| 0.0% | 4.6ms | 0.0% | 4.6ms | `moduleDeclarationInstantiation` | `[native code]` |
| 0.0% | 4.6ms | 0.0% | 3.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1223` |
| 0.0% | 4.6ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2241` |
| 0.0% | 4.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:71` |
| 0.0% | 4.5ms | 0.0% | 0us | `getLastTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3403` |
| 0.0% | 4.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:230` |
| 0.0% | 4.5ms | 0.0% | 4.5ms | `get start` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1108` |
| 0.0% | 4.5ms | 0.0% | 3.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7351` |
| 0.0% | 4.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.0% | 4.5ms | 0.0% | 4.5ms | `resolve` | `[native code]` |
| 0.0% | 4.5ms | 0.0% | 4.5ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:855` |
| 0.0% | 4.4ms | 0.0% | 1.7ms | `getInnermostScope` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:21` |
| 0.0% | 4.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:322` |
| 0.0% | 4.4ms | 0.0% | 3.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7356` |
| 0.0% | 4.4ms | 0.0% | 4.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7141` |
| 0.0% | 4.4ms | 0.0% | 1.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2297` |
| 0.0% | 4.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/config/config.js:14` |
| 0.0% | 4.3ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3275` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 4.2ms | 0.0% | 0us | `getForOfLoopHeadRange` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:127` |
| 0.0% | 4.2ms | 0.0% | 0us | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:52` |
| 0.0% | 4.2ms | 0.0% | 4.2ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js` |
| 0.0% | 4.2ms | 0.0% | 1.4ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1417` |
| 0.0% | 4.2ms | 0.0% | 0us | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:60` |
| 0.0% | 4.1ms | 0.0% | 0us | `wrap` | `bun:ffi:296` |
| 0.0% | 4.1ms | 0.0% | 0us | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1593` |
| 0.0% | 4.0ms | 0.0% | 4.0ms | `getNodeByRangeIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3688` |
| 0.0% | 4.0ms | 0.0% | 4.0ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 3.9ms | 0.0% | 3.9ms | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:16` |
| 0.0% | 3.4ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2140` |
| 0.0% | 3.3ms | 0.0% | 0us | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1576` |
| 0.0% | 3.3ms | 0.0% | 0us | `_getFfi` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:72` |
| 0.0% | 3.3ms | 0.0% | 0us | `isAvailable` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-source-code.js:56` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `filter` | `[native code]` |
| 0.0% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/regexp-tree.js:8` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1205` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `getLocFromIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:617` |
| 0.0% | 3.2ms | 0.0% | 1.5ms | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:66` |
| 0.0% | 3.2ms | 0.0% | 0us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `decode` | `[native code]` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4110` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/browserslist/index.js:3` |
| 0.0% | 3.1ms | 0.0% | 1.5ms | `readFileSync` | `[native code]` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3132` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/ajv.js:9` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/compile/rules.js:3` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7137` |
| 0.0% | 3.0ms | 0.0% | 1.6ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4162` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `arguments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1926` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `isMemberExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:25` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/optimizer/index.js:11` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/regexp-tree.js:10` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/optimizer/transforms/index.js:55` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 3.0ms | 0.0% | 0us | `getParenthesizedRange` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/parentheses.js:44` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3994` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:87` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:415` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:11` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/browserslist/index.js:1` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/linter/source-code-traverser.js:12` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/linter/esquery.js:12` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/linter/linter.js:48` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6587` |
| 0.0% | 2.9ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7140` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2794` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:18` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2181` |
| 0.0% | 2.9ms | 0.0% | 1.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2088` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `ez_ffi_token_idx_at_or_before` | `[native code]` |
| 0.0% | 2.8ms | 0.0% | 0us | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:62` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4156` |
| 0.0% | 2.8ms | 0.0% | 0us | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:822` |
| 0.0% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-listener.js:33` |
| 0.0% | 2.8ms | 0.0% | 1.4ms | `toEslintProblem` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-problem.js:18` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1273` |
| 0.0% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/source-code.js:21` |
| 0.0% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/@eslint/plugin-kit/dist/cjs/index.cjs:3` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `has` | `[native code]` |
| 0.0% | 2.7ms | 0.0% | 0us | `iterateSurroundingParentheses` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/iterate-surrounding-parentheses.js:71` |
| 0.0% | 2.7ms | 0.0% | 0us | `removeCallbackParentheses` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:199` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/@eslint/config-array/dist/cjs/index.cjs:5` |
| 0.0% | 2.7ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3192` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `subarray` | `[native code]` |
| 0.0% | 2.6ms | 0.0% | 0us | `invokeHandlersWithNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6385` |
| 0.0% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/source-code.js:11` |
| 0.0% | 2.6ms | 0.0% | 0us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6447` |
| 0.0% | 2.6ms | 0.0% | 1.4ms | `scope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:784` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `getNodeByRangeIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3687` |
| 0.0% | 2.6ms | 0.0% | 1.3ms | `getFixFunction` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:93` |
| 0.0% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/ajv.js:3` |
| 0.0% | 2.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/config/config.js:16` |
| 0.0% | 2.5ms | 0.0% | 0us | `addSchema` | `/Users/ericsan/node_modules/ajv/lib/ajv.js:137` |
| 0.0% | 2.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/shared/ajv.js:29` |
| 0.0% | 2.5ms | 0.0% | 0us | `addMetaSchema` | `/Users/ericsan/node_modules/ajv/lib/ajv.js:152` |
| 0.0% | 2.5ms | 0.0% | 0us | `node:stream` | `node:stream:2` |
| 0.0% | 2.5ms | 0.0% | 0us | `get ReadStream` | `node:fs:573` |
| 0.0% | 2.5ms | 0.0% | 0us | `internal:fs/streams` | `internal:fs/streams:2` |
| 0.0% | 2.5ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2242` |
| 0.0% | 2.3ms | 0.0% | 0us | `getForOfLoopHeadText` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:96` |
| 0.0% | 2.2ms | 0.0% | 0us | `get params` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2587` |
| 0.0% | 2.2ms | 0.0% | 0us | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:25` |
| 0.0% | 1.8ms | 0.0% | 0us | `_ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:990` |
| 0.0% | 1.8ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1023` |
| 0.0% | 1.8ms | 0.0% | 0us | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2688` |
| 0.0% | 1.8ms | 0.0% | 0us | `getInnermostScope` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:19` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2191` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/languages/js/index.js:16` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/caniuse-lite/dist/unpacker/agents.js:14` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/caniuse-lite/dist/unpacker/agents.js:33` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/node_modules/caniuse-lite/dist/unpacker/agents.js:35` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/caniuse-lite/dist/unpacker/agents.js:16` |
| 0.0% | 1.7ms | 0.0% | 0us | `node:assert/strict` | `node:assert/strict:3` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/compat-transpiler/transforms/index.js:13` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/compat-transpiler/index.js:8` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4094` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:97` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:104` |
| 0.0% | 1.7ms | 0.0% | 0us | `isFunctionParameterVariableReassigned` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:320` |
| 0.0% | 1.7ms | 0.0% | 0us | `addPolyfillToken` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:55` |
| 0.0% | 1.7ms | 0.0% | 0us | `isFunctionSelfUsedInside` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/is-function-self-used-inside.js:21` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2306` |
| 0.0% | 1.7ms | 0.0% | 0us | `isFixable` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:376` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `encodeInto` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:220` |
| 0.0% | 1.7ms | 0.0% | 0us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get object` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1952` |
| 0.0% | 1.7ms | 0.0% | 0us | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:55` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/core-js-compat/compat.js:4` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/rules/utils/lazy-loading-rule-map.js:7` |
| 0.0% | 1.7ms | 0.0% | 0us | `node:util` | `node:util:2` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/debug/src/index.js:9` |
| 0.0% | 1.7ms | 0.0% | 0us | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2876` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/rules/index.js:11` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/debug/src/node.js:6` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `_tryLoad` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-source-code.js:30` |
| 0.0% | 1.7ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3226` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get start` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1110` |
| 0.0% | 1.7ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:267` |
| 0.0% | 1.7ms | 0.0% | 0us | `getTagNames` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:191` |
| 0.0% | 1.7ms | 0.0% | 0us | `loadBinding` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `dlopen` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1315` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get key` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3154` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/dotjs/index.js:10` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:268` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2307` |
| 0.0% | 1.6ms | 0.0% | 0us | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:34` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3245` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:663` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1160` |
| 0.0% | 1.6ms | 0.0% | 0us | `getForOfLoopHeadRange` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:126` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `slice` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1579` |
| 0.0% | 1.6ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:615` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:261` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/rules/index.js:15` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getFixFunction` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:87` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `dlopen` | `bun:ffi:351` |
| 0.0% | 1.6ms | 0.0% | 0us | `_tryLoad` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-source-code.js:44` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:464` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get optional` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2238` |
| 0.0% | 1.6ms | 0.0% | 0us | `arrayIteratorNextHelper` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `typedArrayViewLength` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/browserslist/index.js:1313` |
| 0.0% | 1.6ms | 0.0% | 0us | `normalize` | `/Users/ericsan/node_modules/browserslist/index.js:31` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/browserslist/index.js:1334` |
| 0.0% | 1.6ms | 0.0% | 0us | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:828` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2924` |
| 0.0% | 1.6ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7663` |
| 0.0% | 1.6ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4447` |
| 0.0% | 1.6ms | 0.0% | 0us | `bound onExit` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:409` |
| 0.0% | 1.6ms | 0.0% | 0us | `onExit` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:41` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-create.js:38` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getForOfLoopHeadText` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:116` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3953` |
| 0.0% | 1.6ms | 0.0% | 0us | `get defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:523` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:30` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:14` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `removeParentheses` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/fix/remove-parentheses.js:16` |
| 0.0% | 1.5ms | 0.0% | 0us | `(module)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/prefer-array-index-of.js:3` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `simpleArraySearchRule` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/shared/simple-array-search-rule.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4116` |
| 0.0% | 1.5ms | 0.0% | 0us | `isMemberExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:80` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:28` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get consequent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1662` |
| 0.0% | 1.5ms | 0.0% | 0us | `shouldSwitchReturnStatementToBlockStatement` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:66` |
| 0.0% | 1.5ms | 0.0% | 0us | `replaceReturnStatement` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:158` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getNodeByRangeIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3697` |
| 0.0% | 1.5ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2289` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `Map` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1269` |
| 0.0% | 1.5ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7357` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/compat-transpiler/index.js:9` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/transform/index.js:13` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/parser/index.js:8` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1356` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getLocFromIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3561` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3232` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/node_modules/minimatch/dist/commonjs/index.js:4` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:254` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2775` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1964` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `findVariable` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:53` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7342` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3` |
| 0.0% | 1.5ms | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:545` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:851` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getInnermostScope` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:13` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:447` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get callee` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2526` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getParentSyntaxOpeningParenthesis` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/get-parent-syntax-opening-parenthesis.js:21` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isCallExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:100` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1371` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1168` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/token-store/index.js:13` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/token-store/cursors.js:12` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/levn/lib/index.js:4` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/levn/lib/parse-string.js:113` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/levn/lib/index.js:22` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/levn/lib/parse-string.js:4` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/prelude-ls/lib/index.js:5` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getSurroundingParentheses` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/iterate-surrounding-parentheses.js:32` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_scopeForNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:884` |
| 0.0% | 1.4ms | 0.0% | 0us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1994` |
| 0.0% | 1.4ms | 0.0% | 0us | `getFixFunction` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:89` |
| 0.0% | 1.4ms | 0.0% | 0us | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:83` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isArray` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7447` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/linter/code-path-analysis/code-path-analyzer.js:14` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/source-code.js:16` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3632` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/semver/index.js:31` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_rawTokenText` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/languages/js/index.js:15` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/dotjs/index.js:25` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2979` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1376` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/uri-js/dist/es5/uri.all.js:3` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/uri-js/dist/es5/uri.all.js:148` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/compile/resolve.js:3` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/uri-js/dist/es5/uri.all.js:5` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `buildExps` | `/Users/ericsan/node_modules/uri-js/dist/es5/uri.all.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/compile/index.js:3` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/node_modules/minimatch/dist/commonjs/ast.js:7` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/node_modules/minimatch/dist/commonjs/index.js:6` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1167` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7291` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:17` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7317` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `stringSplitFast` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `isNodeMatches` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/is-node-matches.js:57` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:614` |
| 0.0% | 1.3ms | 0.0% | 0us | `isNodeMatchesNameOrPath` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/is-node-matches.js:9` |
| 0.0% | 1.3ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7353` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/caniuse-lite/dist/unpacker/agents.js:4` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5965` |
| 0.0% | 1.3ms | 0.0% | 0us | `fixSpaceAroundKeyword` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/fix/fix-space-around-keywords.js:28` |
| 0.0% | 1.3ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6744` |
| 0.0% | 1.3ms | 0.0% | 0us | `_getOrBuildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5674` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/@babel/helper-validator-identifier/lib/index.js:54` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/languages/js/index.js:18` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `fill` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7644` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `resolveIds` | `/Users/ericsan/node_modules/ajv/lib/compile/resolve.js:269` |
| 0.0% | 1.3ms | 0.0% | 0us | `_addSchema` | `/Users/ericsan/node_modules/ajv/lib/ajv.js:309` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getText` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1293` |
| 0.0% | 1.3ms | 0.0% | 0us | `internal:stream` | `internal:stream:18` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_rawTokenText` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:831` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `cloneObject` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `getFixFunction` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:91` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `Comparator` | `/Users/ericsan/node_modules/semver/classes/comparator.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/semver/index.js:44` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/semver/ranges/subset.js:73` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_isOptionalTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/ajv.js:10` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1862` |
| 0.0% | 1.3ms | 0.0% | 0us | `replaceReturnStatement` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:151` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `isFixable` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:352` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/config/config-loader.js:14` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/locate-path/index.js:5` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:24` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/find-up/index.js:3` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get property` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1974` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:518` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3252` |
| 0.0% | 1.3ms | 0.0% | 0us | `(module)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/expiring-todo-comments.js:11` |
| 0.0% | 1.3ms | 0.0% | 0us | `node:events` | `node:events:9` |
| 0.0% | 1.3ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.0% | 1.3ms | 0.0% | 0us | `internal:validators` | `internal:validators:47` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/esutils/lib/utils.js:31` |
| 0.0% | 1.3ms | 0.0% | 0us | `hideFromStack` | `internal:shared:19` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/esutils/lib/utils.js:29` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/rules/utils/ast-utils.js:13` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/rules/no-warning-comments.js:9` |
| 0.0% | 1.3ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2328` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getParentSyntaxOpeningParenthesis` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/get-parent-syntax-opening-parenthesis.js:26` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/cli-engine/lint-result-cache.js:12` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:23` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getText` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1306` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/interpreter/finite-automaton/index.js:11` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `iterateSurroundingParentheses` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/iterate-surrounding-parentheses.js:56` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/regexp-tree.js:14` |
| 0.0% | 1.2ms | 0.0% | 0us | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1623` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2087` |
| 0.0% | 1.2ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:279` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_fromRunnerReport` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2527` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2126` |
| 0.0% | 1.2ms | 0.0% | 0us | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2892` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2535` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/@eslint/config-array/node_modules/minimatch/dist/commonjs/index.js:5` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:425` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7636` |
| 0.0% | 1.2ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7283` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get params` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2583` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` |
| 0.0% | 1.2ms | 0.0% | 0us | `_addSchema` | `/Users/ericsan/node_modules/ajv/lib/ajv.js:295` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `stringify` | `/Users/ericsan/node_modules/fast-json-stable-stringify/index.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/compile/index.js:8` |
| 0.0% | 1.2ms | 0.0% | 0us | `internal:streams/end-of-stream` | `internal:streams/end-of-stream:17` |
| 0.0% | 1.2ms | 0.0% | 0us | `internal:streams/operators` | `internal:streams/operators:2` |
| 0.0% | 1.2ms | 0.0% | 0us | `internal:stream` | `internal:stream:2` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get key` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3155` |
| 0.0% | 1.0ms | 0.0% | 0us | `getText` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1292` |
| 0.0% | 1.0ms | 0.0% | 1.0ms | `get start` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1113` |
| 0.0% | 988us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/semver/internal/re.js:173` |
| 0.0% | 988us | 0.0% | 988us | `RegExp` | `[native code]` |
| 0.0% | 988us | 0.0% | 0us | `createToken` | `/Users/ericsan/node_modules/semver/internal/re.js:50` |
| 0.0% | 988us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/semver/index.js:4` |

## Function Details

### `getRange`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3714` | Self: 26.7% (6.10s) | Total: 44.9% (10.22s) | Samples: 3983

**Called by:**
- `isFunctionParametersSafeToFix` (6680)
- `getForOfLoopHeadRange` (1)
- `fixSpaceAroundKeyword` (1)

**Calls:**
- `get range` (1685)
- `get range` (984)
- `get range` (26)
- `get range` (3)
- `get range` (1)

### `isFunctionParametersSafeToFix`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:301` | Self: 13.6% (3.11s) | Total: 13.6% (3.11s) | Samples: 2029

**Called by:**
- `isFixable` (2029)

### `isFunctionParametersSafeToFix`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:298` | Self: 12.9% (2.94s) | Total: 25.6% (5.83s) | Samples: 1930

**Called by:**
- `isFixable` (3819)

**Calls:**
- `get name` (1200)
- `get name` (374)
- `get name` (143)
- `get name` (100)
- `get name` (51)
- `get name` (12)
- `get name` (8)
- `get name` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3582` | Self: 11.3% (2.57s) | Total: 11.3% (2.57s) | Samples: 1685

**Called by:**
- `getRange` (1685)

### `source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` | Self: 8.0% (1.84s) | Total: 8.0% (1.84s) | Samples: 1204

**Called by:**
- `get name` (1200)
- `_identAt` (4)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3630` | Self: 6.5% (1.49s) | Total: 6.6% (1.50s) | Samples: 975

**Called by:**
- `getRange` (984)
- `getInnermostScope` (1)
- `getText` (1)

**Calls:**
- `get start` (6)
- `get start` (3)
- `get start` (1)
- `get start` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1347` | Self: 2.5% (574.1ms) | Total: 2.5% (574.1ms) | Samples: 375

**Called by:**
- `isFunctionParametersSafeToFix` (374)
- `isMemberExpression` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:905` | Self: 2.4% (547.5ms) | Total: 2.5% (576.8ms) | Samples: 358

**Called by:**
- `get properties` (363)
- `get body` (9)
- `get params` (4)
- `get params` (2)

**Calls:**
- `nodeView` (14)
- `nodeView` (5)
- `_nodeViewRaw` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.9% (227.0ms) | Total: 0.9% (227.0ms) | Samples: 145

**Called by:**
- `isFunctionParametersSafeToFix` (143)
- `isMemberExpression` (2)

### `parse`
`[native code]` | Self: 0.9% (218.5ms) | Total: 0.9% (218.5ms) | Samples: 143

**Called by:**
- `parseSource` (143)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1267` | Self: 0.8% (200.9ms) | Total: 0.8% (200.9ms) | Samples: 133

**Called by:**
- `_getAllTokens` (133)

### `isFunctionParametersSafeToFix`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:299` | Self: 0.8% (184.8ms) | Total: 45.7% (10.40s) | Samples: 120

**Called by:**
- `isFixable` (6800)

**Calls:**
- `getRange` (6680)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1264` | Self: 0.7% (181.5ms) | Total: 0.8% (194.1ms) | Samples: 119

**Called by:**
- `_getAllTokens` (125)
- `getTokenBefore` (2)

**Calls:**
- `_getJsxTextTokFlags` (5)
- `_getJsxTextTokFlags` (1)
- `_getJsxTextTokFlags` (1)
- `_getJsxTextTokFlags` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1354` | Self: 0.6% (151.8ms) | Total: 0.6% (151.8ms) | Samples: 100

**Called by:**
- `isFunctionParametersSafeToFix` (100)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1239` | Self: 0.6% (143.6ms) | Total: 0.6% (143.6ms) | Samples: 96

**Called by:**
- `_getAllTokens` (96)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7181` | Self: 0.5% (126.1ms) | Total: 7.5% (1.71s) | Samples: 81

**Called by:**
- `runPlugins` (1126)

**Calls:**
- `_invokeFused` (1007)
- `_nodeViewRaw` (22)
- `_nodeViewRaw` (8)
- `nodeView` (4)
- `_invokeFused` (2)
- `nodeView` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:53` | Self: 0.5% (122.9ms) | Total: 0.5% (122.9ms) | Samples: 81

**Called by:**
- `(anonymous)` (81)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:55` | Self: 0.5% (115.2ms) | Total: 5.0% (1.14s) | Samples: 76

**Called by:**
- `generatorResume` (757)

**Calls:**
- `(anonymous)` (502)
- `(anonymous)` (108)
- `(anonymous)` (57)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (1)

### `isFunctionParametersSafeToFix`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:309` | Self: 0.4% (105.5ms) | Total: 0.4% (108.2ms) | Samples: 70

**Called by:**
- `isFixable` (72)

**Calls:**
- `scope` (2)

### `generatorResume`
`[native code]` | Self: 0.4% (100.3ms) | Total: 100.0% (64.02s) | Samples: 66

**Called by:**
- `next` (24548)
- `(anonymous)` (12643)
- `iterateFixOrProblems` (2136)
- `iterateFixOrProblems` (2081)
- `performIteration` (433)
- `getParentheses` (14)

**Calls:**
- `iterateFixOrProblems` (14167)
- `iterateFixOrProblems` (13403)
- `(anonymous)` (12835)
- `(anonymous)` (757)
- `fixSpaceAroundKeyword` (464)
- `iterateFixOrProblems` (81)
- `iterateSurroundingParentheses` (14)
- `removeParentheses` (13)
- `(anonymous)` (13)
- `(anonymous)` (12)
- `replaceReturnStatement` (6)
- `(anonymous)` (4)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `removeCallbackParentheses` (2)
- `iterateSurroundingParentheses` (2)
- `replaceReturnStatement` (1)
- `(anonymous)` (1)
- `iterateSurroundingParentheses` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `removeParentheses` (1)
- `fixSpaceAroundKeyword` (1)
- `(anonymous)` (1)
- `replaceReturnStatement` (1)

### `isIterable`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js:1` | Self: 0.3% (89.3ms) | Total: 0.3% (90.6ms) | Samples: 57

**Called by:**
- `iterateFixOrProblems` (58)

**Calls:**
- `getFixFunction` (1)

### `isFunctionParametersSafeToFix`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:297` | Self: 0.3% (77.3ms) | Total: 0.3% (77.3ms) | Samples: 51

**Called by:**
- `isFixable` (51)

### `anonymous`
`[native code]` | Self: 0.3% (76.6ms) | Total: 1.9% (438.9ms) | Samples: 51

**Called by:**
- `require` (278)
- `wrap` (3)
- `bound require` (3)
- `node:stream` (2)
- `get ReadStream` (2)
- `internal:fs/streams` (2)
- `node:fs` (1)
- `internal:stream` (1)
- `internal:streams/operators` (1)
- `internal:streams/end-of-stream` (1)
- `node:assert/strict` (1)
- `node:util` (1)
- `node:events` (1)

**Calls:**
- `(anonymous)` (19)
- `(anonymous)` (14)
- `(anonymous)` (14)
- `(anonymous)` (12)
- `(anonymous)` (11)
- `(anonymous)` (11)
- `(anonymous)` (8)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (4)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `ez_ffi_token_idx_at_or_before` (2)
- `internal:fs/streams` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `node:stream` (2)
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
- `internal:stream` (1)
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
- `node:util` (1)
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
- `internal:streams/end-of-stream` (1)
- `(anonymous)` (1)
- `node:events` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:validators` (1)
- `(anonymous)` (1)
- `internal:streams/operators` (1)
- `(anonymous)` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1357` | Self: 0.3% (75.1ms) | Total: 0.3% (84.2ms) | Samples: 49

**Called by:**
- `isFunctionParametersSafeToFix` (51)
- `isMemberExpression` (4)

**Calls:**
- `get mainToken` (6)

### `iterateFixOrProblems`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js:17` | Self: 0.2% (57.8ms) | Total: 0.2% (57.8ms) | Samples: 35

**Called by:**
- `iterateFixOrProblems` (24)
- `(anonymous)` (11)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` | Self: 0.2% (48.9ms) | Total: 0.2% (48.9ms) | Samples: 32

**Called by:**
- `_nodeViewRaw` (32)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4058` | Self: 0.2% (47.0ms) | Total: 0.2% (47.0ms) | Samples: 32

**Called by:**
- `_nodeViewRaw` (32)

### `copyDataProperties`
`[native code]` | Self: 0.1% (43.6ms) | Total: 0.1% (43.6ms) | Samples: 29

**Called by:**
- `create` (14)
- `isMethodCall` (11)
- `isMemberExpression` (4)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (37.2ms) | Total: 0.1% (37.2ms) | Samples: 26

**Called by:**
- `getRange` (26)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1235` | Self: 0.1% (36.7ms) | Total: 0.1% (36.7ms) | Samples: 23

**Called by:**
- `_getAllTokens` (23)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` | Self: 0.1% (35.3ms) | Total: 0.6% (143.2ms) | Samples: 24

**Called by:**
- `nodeView` (49)
- `nodeViewChain` (23)
- `walkNodes` (22)
- `get parent` (1)
- `arguments` (1)

**Calls:**
- `_NodeView` (32)
- `_NodeView_LR` (32)
- `_NodeView` (5)
- `_NodeView_LR` (3)

### `iterateFixOrProblems`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js:18` | Self: 0.1% (34.4ms) | Total: 0.5% (125.0ms) | Samples: 23

**Called by:**
- `generatorResume` (81)

**Calls:**
- `isIterable` (58)

### `isReferenceIdentifier`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:149` | Self: 0.1% (32.1ms) | Total: 0.1% (32.1ms) | Samples: 21

**Called by:**
- `(anonymous)` (21)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:3` | Self: 0.1% (31.6ms) | Total: 0.3% (89.2ms) | Samples: 21

**Called by:**
- `isReferenceIdentifier` (59)

**Calls:**
- `get parent` (23)
- `get parent` (11)
- `get parent` (3)
- `get parent` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7418` | Self: 0.1% (26.9ms) | Total: 0.1% (26.9ms) | Samples: 18

**Called by:**
- `runPlugins` (18)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6865` | Self: 0.1% (24.9ms) | Total: 0.1% (24.9ms) | Samples: 17

**Called by:**
- `runPlugins` (17)

### `get typeAnnotation`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2720` | Self: 0.1% (24.2ms) | Total: 0.1% (24.2ms) | Samples: 15

**Called by:**
- `(anonymous)` (15)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1271` | Self: 0.1% (23.3ms) | Total: 0.1% (23.3ms) | Samples: 15

**Called by:**
- `_getAllTokens` (15)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1244` | Self: 0.0% (21.4ms) | Total: 0.0% (21.4ms) | Samples: 14

**Called by:**
- `isNotReference` (11)
- `_computeIsStrict` (2)
- `_computeIsStrict` (1)

### `iterateFixOrProblems`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js:23` | Self: 0.0% (19.1ms) | Total: 95.1% (21.66s) | Samples: 13

**Called by:**
- `generatorResume` (14167)

**Calls:**
- `next` (12018)
- `generatorResume` (2136)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:54` | Self: 0.0% (19.0ms) | Total: 0.0% (19.0ms) | Samples: 13

**Called by:**
- `generatorResume` (13)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7316` | Self: 0.0% (19.0ms) | Total: 0.0% (19.0ms) | Samples: 13

**Called by:**
- `runPlugins` (13)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1926` | Self: 0.0% (18.4ms) | Total: 0.1% (39.4ms) | Samples: 12

**Called by:**
- `getTokenBefore` (26)

**Calls:**
- `_makeToken` (6)
- `_makeToken` (6)
- `_makeToken` (2)

### `_getAllTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1883` | Self: 0.0% (17.2ms) | Total: 2.7% (617.5ms) | Samples: 12

**Called by:**
- `_getTokensAndCommentsMerged` (407)

**Calls:**
- `_makeToken` (133)
- `_makeToken` (125)
- `_makeToken` (96)
- `_makeToken` (23)
- `_makeToken` (15)
- `_makeToken` (2)
- `_makeToken` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (17.0ms) | Total: 0.0% (17.0ms) | Samples: 10

**Called by:**
- `commentsInRange` (5)
- `commentsInRange` (5)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4095` | Self: 0.0% (16.5ms) | Total: 0.0% (16.5ms) | Samples: 11

**Called by:**
- `walkNodes` (8)
- `_nodesFromRange` (1)
- `getFixFunction` (1)
- `get parent` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6861` | Self: 0.0% (16.5ms) | Total: 0.0% (16.5ms) | Samples: 11

**Called by:**
- `runPlugins` (11)

### `(anonymous)`
`[native code]` | Self: 0.0% (14.6ms) | Total: 100.0% (22.88s) | Samples: 10

**Called by:**
- `processTicksAndRejections` (14801)
- `(anonymous)` (86)
- `require` (77)
- `bound require` (1)

**Calls:**
- `_lintSourceOne` (14653)
- `_lintSourceOne` (146)
- `(anonymous)` (86)
- `parseModule` (53)
- `moduleEvaluation` (8)
- `resolve` (3)
- `linkAndEvaluateModule` (3)
- `_lintSourceOne` (1)
- `dlopen` (1)
- `_lintSourceOne` (1)

### `isReferenceIdentifier`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:158` | Self: 0.0% (14.5ms) | Total: 3.2% (732.3ms) | Samples: 10

**Called by:**
- `(anonymous)` (481)

**Calls:**
- `isNotReference` (374)
- `isNotReference` (59)
- `isNotReference` (7)
- `isNotReference` (7)
- `isNotReference` (5)
- `isNotReference` (4)
- `isNotReference` (3)
- `isNotReference` (3)
- `isNotReference` (3)
- `isNotReference` (2)
- `isNotReference` (2)
- `isNotReference` (1)
- `isNotReference` (1)

### `create`
`[native code]` | Self: 0.0% (13.9ms) | Total: 0.0% (13.9ms) | Samples: 9

**Called by:**
- `walkNodes` (5)
- `walkNodes` (4)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4132` | Self: 0.0% (13.3ms) | Total: 0.0% (13.3ms) | Samples: 9

**Called by:**
- `_nodesFromRange` (5)
- `walkNodes` (4)

### `_getAllTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1884` | Self: 0.0% (13.2ms) | Total: 0.0% (13.2ms) | Samples: 9

**Called by:**
- `_getTokensAndCommentsMerged` (9)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:656` | Self: 0.0% (13.2ms) | Total: 0.0% (13.2ms) | Samples: 8

**Called by:**
- `commentsInRange` (4)
- `commentsInRange` (4)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1369` | Self: 0.0% (12.6ms) | Total: 0.0% (12.6ms) | Samples: 8

**Called by:**
- `isFunctionParametersSafeToFix` (8)

### `_resolveUnicodeEscapes`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:236` | Self: 0.0% (12.4ms) | Total: 0.0% (12.4ms) | Samples: 8

**Called by:**
- `get name` (8)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1203` | Self: 0.0% (11.7ms) | Total: 0.0% (11.7ms) | Samples: 8

**Called by:**
- `_getTokensAndCommentsMerged` (6)
- `getTokenBefore` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7349` | Self: 0.0% (11.6ms) | Total: 0.0% (17.7ms) | Samples: 8

**Called by:**
- `runPlugins` (12)

**Calls:**
- `create` (4)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:902` | Self: 0.0% (11.0ms) | Total: 0.0% (11.0ms) | Samples: 7

**Called by:**
- `get properties` (5)
- `get body` (1)
- `get params` (1)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:810` | Self: 0.0% (9.5ms) | Total: 0.0% (9.5ms) | Samples: 6

**Called by:**
- `get name` (6)

### `get mainToken`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1105` | Self: 0.0% (9.0ms) | Total: 0.0% (9.0ms) | Samples: 6

**Called by:**
- `get name` (6)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4775` | Self: 0.0% (8.9ms) | Total: 96.7% (22.04s) | Samples: 6

**Called by:**
- `walkNodes` (13386)
- `walkNodes` (1007)
- `walkNodes` (17)

**Calls:**
- `(anonymous)` (13801)
- `(anonymous)` (520)
- `(anonymous)` (81)
- `(anonymous)` (2)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (8.7ms) | Total: 0.0% (8.7ms) | Samples: 6

**Called by:**
- `_getTokensAndCommentsMerged` (6)

### `isMethodCall`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:53` | Self: 0.0% (8.6ms) | Total: 0.0% (19.1ms) | Samples: 6

**Called by:**
- `(anonymous)` (13)

**Calls:**
- `nodeViewChain` (7)

### `get start`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (8.3ms) | Total: 0.0% (8.3ms) | Samples: 6

**Called by:**
- `get range` (6)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1624` | Self: 0.0% (8.2ms) | Total: 3.0% (705.6ms) | Samples: 5

**Called by:**
- `fixSpaceAroundKeyword` (463)

**Calls:**
- `_getTokensAndCommentsMerged` (416)
- `_getTokensAndCommentsMerged` (26)
- `_getTokensAndCommentsMerged` (13)
- `_getTokensAndCommentsMerged` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7348` | Self: 0.0% (8.2ms) | Total: 0.0% (16.1ms) | Samples: 5

**Called by:**
- `runPlugins` (10)

**Calls:**
- `create` (5)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1177` | Self: 0.0% (7.9ms) | Total: 0.0% (7.9ms) | Samples: 5

**Called by:**
- `_makeToken` (5)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (7.7ms) | Total: 0.0% (7.7ms) | Samples: 5

**Called by:**
- `_nodeViewRaw` (5)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4111` | Self: 0.0% (7.7ms) | Total: 0.0% (7.7ms) | Samples: 5

**Called by:**
- `nodeView` (4)
- `nodeViewChain` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2145` | Self: 0.0% (7.6ms) | Total: 0.0% (7.6ms) | Samples: 5

**Called by:**
- `(anonymous)` (4)
- `_buildScopeChildren` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2161` | Self: 0.0% (7.5ms) | Total: 0.2% (45.9ms) | Samples: 5

**Called by:**
- `(anonymous)` (29)
- `_buildScope` (2)

**Calls:**
- `_computeIsStrict` (20)
- `_computeIsStrict` (3)
- `_computeIsStrict` (2)
- `_computeIsStrict` (1)

### `get computed`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2011` | Self: 0.0% (7.5ms) | Total: 0.0% (7.5ms) | Samples: 5

**Called by:**
- `isNotReference` (3)
- `isNotReference` (1)
- `isMemberExpression` (1)

### `set`
`[native code]` | Self: 0.0% (7.2ms) | Total: 0.0% (7.2ms) | Samples: 5

**Called by:**
- `_computeDeclaredVariables` (3)
- `_ensureDeclSymIndex` (1)
- `_buildScopeVarsAndSet` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6847` | Self: 0.0% (6.6ms) | Total: 0.0% (6.6ms) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `toLocaleLowerCase`
`[native code]` | Self: 0.0% (6.3ms) | Total: 0.0% (6.3ms) | Samples: 4

**Called by:**
- `map` (4)

### `parseModule`
`[native code]` | Self: 0.0% (6.3ms) | Total: 0.4% (95.9ms) | Samples: 4

**Called by:**
- `(anonymous)` (53)
- `async (anonymous)` (11)

**Calls:**
- `(anonymous)` (31)
- `(anonymous)` (8)
- `(anonymous)` (7)
- `(anonymous)` (4)
- `get ReadStream` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:assert/strict` (1)
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7380` | Self: 0.0% (6.1ms) | Total: 89.9% (20.48s) | Samples: 4

**Called by:**
- `runPlugins` (13390)

**Calls:**
- `_invokeFused` (13386)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1191` | Self: 0.0% (6.1ms) | Total: 0.0% (6.1ms) | Samples: 4

**Called by:**
- `_computeVarDefs` (1)
- `isNotReference` (1)
- `(anonymous)` (1)
- `_computeIsStrict` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4393` | Self: 0.0% (5.8ms) | Total: 0.0% (5.8ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7143` | Self: 0.0% (5.7ms) | Total: 0.0% (5.7ms) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:5` | Self: 0.0% (5.7ms) | Total: 0.0% (5.7ms) | Samples: 4

**Called by:**
- `isReferenceIdentifier` (4)

### `get`
`[native code]` | Self: 0.0% (5.5ms) | Total: 0.0% (5.5ms) | Samples: 4

**Called by:**
- `_buildScopeVarsAndSet` (2)
- `walkNodes` (1)
- `walkNodes` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:403` | Self: 0.0% (5.4ms) | Total: 0.0% (5.4ms) | Samples: 4

**Called by:**
- `(anonymous)` (4)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3583` | Self: 0.0% (5.4ms) | Total: 0.0% (5.4ms) | Samples: 4

**Called by:**
- `getRange` (3)
- `getInnermostScope` (1)

### `defineProperty`
`[native code]` | Self: 0.0% (5.4ms) | Total: 0.0% (5.4ms) | Samples: 4

**Called by:**
- `walkNodes` (1)
- `walkNodes` (1)
- `hideFromStack` (1)
- `internal:stream` (1)

### `removeCallbackParentheses`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:197` | Self: 0.0% (5.0ms) | Total: 0.0% (5.0ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:61` | Self: 0.0% (4.9ms) | Total: 0.0% (4.9ms) | Samples: 3

**Called by:**
- `isReferenceIdentifier` (3)

### `test`
`[native code]` | Self: 0.0% (4.9ms) | Total: 0.0% (4.9ms) | Samples: 3

**Called by:**
- `_precomputeScopes` (3)

### `isMethodCall`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:31` | Self: 0.0% (4.8ms) | Total: 0.0% (4.8ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1913` | Self: 0.0% (4.7ms) | Total: 0.0% (4.7ms) | Samples: 3

**Called by:**
- `getTokenBefore` (3)

### `moduleDeclarationInstantiation`
`[native code]` | Self: 0.0% (4.6ms) | Total: 0.0% (4.6ms) | Samples: 3

**Called by:**
- `link` (3)

### `get start`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1108` | Self: 0.0% (4.5ms) | Total: 0.0% (4.5ms) | Samples: 3

**Called by:**
- `get range` (3)

### `from`
`[native code]` | Self: 0.0% (4.5ms) | Total: 0.0% (6.1ms) | Samples: 3

**Called by:**
- `_computeDeclaredVariables` (4)

**Calls:**
- `arrayIteratorNextHelper` (1)

### `resolve`
`[native code]` | Self: 0.0% (4.5ms) | Total: 0.0% (4.5ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:855` | Self: 0.0% (4.5ms) | Total: 0.0% (4.5ms) | Samples: 3

**Called by:**
- `_symName` (3)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2260` | Self: 0.0% (4.5ms) | Total: 0.1% (29.4ms) | Samples: 3

**Called by:**
- `_buildScope` (20)

**Calls:**
- `get body` (10)
- `get body` (4)
- `get body` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7141` | Self: 0.0% (4.4ms) | Total: 0.0% (4.4ms) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:53` | Self: 0.0% (4.4ms) | Total: 0.0% (7.3ms) | Samples: 3

**Called by:**
- `isReferenceIdentifier` (5)

**Calls:**
- `get key` (1)
- `get key` (1)

### `_resolveHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (4.3ms) | Total: 0.0% (4.3ms) | Samples: 3

**Called by:**
- `walkNodes` (3)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js` | Self: 0.0% (4.2ms) | Total: 0.0% (4.2ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `isMethodCall`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:46` | Self: 0.0% (4.2ms) | Total: 0.3% (77.6ms) | Samples: 3

**Called by:**
- `(anonymous)` (52)

**Calls:**
- `create` (25)
- `create` (17)
- `create` (3)
- `create` (2)
- `isCallExpression` (1)
- `create` (1)

### `getSurroundingParentheses`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/iterate-surrounding-parentheses.js:30` | Self: 0.0% (4.1ms) | Total: 0.0% (19.0ms) | Samples: 3

**Called by:**
- `iterateSurroundingParentheses` (13)

**Calls:**
- `getTokenBefore` (4)
- `getTokenBefore` (3)
- `getTokenBefore` (2)
- `getTokenBefore` (1)

### `create`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:40` | Self: 0.0% (4.1ms) | Total: 0.1% (25.4ms) | Samples: 3

**Called by:**
- `isMethodCall` (17)

**Calls:**
- `copyDataProperties` (14)

### `getNodeByRangeIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3688` | Self: 0.0% (4.0ms) | Total: 0.0% (4.0ms) | Samples: 3

**Called by:**
- `needsSemicolon` (3)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (4.0ms) | Total: 0.0% (4.0ms) | Samples: 3

**Called by:**
- `_nodeViewRaw` (3)

### `create`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:16` | Self: 0.0% (3.9ms) | Total: 0.0% (3.9ms) | Samples: 3

**Called by:**
- `isMethodCall` (3)

### `filter`
`[native code]` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `isFunctionParameterVariableReassigned` (1)
- `normalize` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1223` | Self: 0.0% (3.3ms) | Total: 0.0% (4.6ms) | Samples: 2

**Called by:**
- `isNotReference` (3)

**Calls:**
- `_isOptionalTag` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1205` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `_getTokensAndCommentsMerged` (2)

### `getLocFromIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `_execReport` (2)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:617` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `getAllComments` (2)

### `decode`
`[native code]` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `get source` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4110` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `nodeViewChain` (2)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4137` | Self: 0.0% (3.1ms) | Total: 0.3% (83.3ms) | Samples: 2

**Called by:**
- `get parent` (24)
- `_nodesFromRange` (14)
- `get property` (10)
- `get body` (4)
- `get body` (2)
- `walkNodes` (2)

**Calls:**
- `_nodeViewRaw` (49)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7351` | Self: 0.0% (3.1ms) | Total: 0.0% (4.5ms) | Samples: 2

**Called by:**
- `runPlugins` (3)

**Calls:**
- `defineProperty` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3132` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `map` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7356` | Self: 0.0% (3.1ms) | Total: 0.0% (4.4ms) | Samples: 2

**Called by:**
- `runPlugins` (3)

**Calls:**
- `get` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7137` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `arguments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1926` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `create` (2)

### `isMemberExpression`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:25` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `get properties` (2)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3994` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `report` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:87` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `map` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:415` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6587` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `get typeAnnotation`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2794` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `arguments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1931` | Self: 0.0% (2.9ms) | Total: 0.1% (34.7ms) | Samples: 2

**Called by:**
- `create` (23)

**Calls:**
- `nodeViewChain` (18)
- `nodeViewChain` (2)
- `_nodeViewRaw` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2181` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `ez_ffi_token_idx_at_or_before`
`[native code]` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `anonymous` (2)

### `isMemberExpression`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:39` | Self: 0.0% (2.8ms) | Total: 0.0% (9.4ms) | Samples: 2

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `copyDataProperties` (4)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4156` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `getFixFunction` (1)
- `(anonymous)` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1273` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `_getAllTokens` (2)

### `has`
`[native code]` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `getTokenBefore` (1)
- `_findDefNode` (1)

### `subarray`
`[native code]` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `_computeDeclaredVariables` (2)

### `getNodeByRangeIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3687` | Self: 0.0% (2.6ms) | Total: 0.0% (2.6ms) | Samples: 2

**Called by:**
- `needsSemicolon` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2191` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `some`
`[native code]` | Self: 0.0% (1.8ms) | Total: 0.1% (36.1ms) | Samples: 1

**Called by:**
- `isFixable` (19)
- `getForOfLoopHeadText` (3)
- `isNodeMatches` (1)

**Calls:**
- `(anonymous)` (18)
- `(anonymous)` (3)
- `isNodeMatchesNameOrPath` (1)

### `isMemberExpression`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:66` | Self: 0.0% (1.8ms) | Total: 0.0% (8.9ms) | Samples: 1

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `get property` (5)

### `(anonymous)`
`/Users/ericsan/node_modules/caniuse-lite/dist/unpacker/agents.js:35` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `reduce` (1)

### `getInnermostScope`
`/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:21` | Self: 0.0% (1.7ms) | Total: 0.0% (4.4ms) | Samples: 1

**Called by:**
- `findVariable` (3)

**Calls:**
- `get range` (1)
- `get range` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4094` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `get id`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2306` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `isFunctionSelfUsedInside` (1)

### `encodeInto`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_encodeSource` (1)

### `get object`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1952` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-rule-fixer.js:37` | Self: 0.0% (1.7ms) | Total: 3.4% (781.1ms) | Samples: 1

**Called by:**
- `_execReport` (514)

**Calls:**
- `performIteration` (513)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `next`
`[native code]` | Self: 0.0% (1.7ms) | Total: 100.0% (37.52s) | Samples: 1

**Called by:**
- `iterateFixOrProblems` (12018)
- `iterateFixOrProblems` (11298)
- `(anonymous)` (1149)
- `performIteration` (80)
- `getParentheses` (3)
- `_computeDeclaredVariables` (1)

**Calls:**
- `generatorResume` (24548)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2297` | Self: 0.0% (1.7ms) | Total: 0.0% (4.4ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (3)

**Calls:**
- `get` (2)

### `get start`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1110` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `get range` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:434` | Self: 0.0% (1.7ms) | Total: 0.0% (6.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `isNodeMatches` (1)
- `get object` (1)
- `nodeViewChain` (1)

### `dlopen`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1315` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getLastTokens` (1)

### `get key`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3154` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `isNotReference` (1)

### `get id`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2307` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `isNotReference` (1)

### `get properties`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3126` | Self: 0.0% (1.6ms) | Total: 2.4% (567.5ms) | Samples: 1

**Called by:**
- `isNotReference` (370)
- `isNotReference` (1)

**Calls:**
- `_nodesFromRange` (363)
- `_nodesFromRange` (5)
- `_nodesFromRange` (2)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3245` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:663` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `commentsInRange` (1)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1160` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_makeToken` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4162` | Self: 0.0% (1.6ms) | Total: 0.0% (3.0ms) | Samples: 1

**Called by:**
- `arguments` (2)

**Calls:**
- `_isChainNode` (1)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:16` | Self: 0.0% (1.6ms) | Total: 0.0% (11.0ms) | Samples: 1

**Called by:**
- `isReferenceIdentifier` (7)

**Calls:**
- `get params` (5)
- `get params` (1)

### `require`
`[native code]` | Self: 0.0% (1.6ms) | Total: 2.3% (530.1ms) | Samples: 1

**Called by:**
- `bound require` (356)

**Calls:**
- `anonymous` (278)
- `(anonymous)` (77)

### `slice`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `commentsInRange` (1)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1579` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `getSurroundingParentheses` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:261` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `generatorResume` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/rules/index.js:15` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `getFixFunction`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:87` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `dlopen`
`bun:ffi:351` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_tryLoad` (1)

### `get optional`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2238` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `typedArrayViewLength`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `arrayIteratorNextHelper` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:612` | Self: 0.0% (1.6ms) | Total: 0.0% (17.3ms) | Samples: 1

**Called by:**
- `getAllComments` (6)
- `_precomputeScopes` (4)

**Calls:**
- `_findLineIdx` (5)
- `_findLineIdx` (4)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_lintSourceOne` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2924` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `get references` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `map` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7153` | Self: 0.0% (1.6ms) | Total: 0.0% (5.9ms) | Samples: 1

**Called by:**
- `runPlugins` (4)

**Calls:**
- `_resolveHandlers` (3)

### `getForOfLoopHeadText`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:116` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3953` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `report` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:523` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_computeVarDefs` (1)

### `isMethodCall`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:30` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `removeParentheses`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/fix/remove-parentheses.js:16` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `generatorResume` (1)

### `simpleArraySearchRule`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/shared/simple-array-search-rule.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(module)` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4116` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `nodeView` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:613` | Self: 0.0% (1.5ms) | Total: 0.0% (17.8ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (7)
- `getAllComments` (4)

**Calls:**
- `_findLineIdx` (5)
- `_findLineIdx` (4)
- `_findLineIdx` (1)

### `readFileSync`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (3.1ms) | Samples: 1

**Called by:**
- `readFileSync` (1)
- `(anonymous)` (1)

**Calls:**
- `readFileSync` (1)

### `get consequent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1662` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `shouldSwitchReturnStatementToBlockStatement` (1)

### `getNodeByRangeIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3697` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `needsSemicolon` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1269` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_getAllTokens` (1)

### `Map`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1356` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `isFunctionParametersSafeToFix` (1)

### `getLocFromIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3561` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_execReport` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3232` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:254` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `generatorResume` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `findVariable` (1)

### `create`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:66` | Self: 0.0% (1.5ms) | Total: 0.0% (3.2ms) | Samples: 1

**Called by:**
- `isMethodCall` (2)

**Calls:**
- `nodeViewChain` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2775` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `getScope` (1)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1964` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `findVariable`
`/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:53` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `isFunctionParametersSafeToFix` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7342` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:851` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_symName` (1)

### `getInnermostScope`
`/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:13` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `findVariable` (1)

### `get callee`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get properties`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3130` | Self: 0.0% (1.4ms) | Total: 0.0% (6.0ms) | Samples: 1

**Called by:**
- `isNotReference` (3)
- `isNotReference` (1)

**Calls:**
- `map` (3)

### `toEslintProblem`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-problem.js:18` | Self: 0.0% (1.4ms) | Total: 0.0% (2.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `cloneObject` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2526` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `isCallExpression`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:100` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `isMethodCall` (1)

### `getParentSyntaxOpeningParenthesis`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/get-parent-syntax-opening-parenthesis.js:21` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `iterateSurroundingParentheses` (1)

### `getTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1371` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getLastTokens` (1)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1168` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_makeToken` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get references` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1736` | Self: 0.0% (1.4ms) | Total: 0.0% (4.9ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (3)

**Calls:**
- `nodeView` (2)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2776` | Self: 0.0% (1.4ms) | Total: 0.0% (6.3ms) | Samples: 1

**Called by:**
- `getScope` (4)

**Calls:**
- `test` (3)

### `getSurroundingParentheses`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/iterate-surrounding-parentheses.js:32` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `iterateSurroundingParentheses` (1)

### `_scopeForNode`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:884` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getScope` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1417` | Self: 0.0% (1.4ms) | Total: 0.0% (4.2ms) | Samples: 1

**Called by:**
- `isNotReference` (3)

**Calls:**
- `_rawTokenText` (1)
- `_rawTokenText` (1)

### `isArray`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `create` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3632` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getRange` (1)

### `_rawTokenText`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get value` (1)

### `scope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:784` | Self: 0.0% (1.4ms) | Total: 0.0% (2.6ms) | Samples: 1

**Called by:**
- `isFunctionParametersSafeToFix` (2)

**Calls:**
- `_computeVarScope` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2979` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get references` (1)

### `getTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1376` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getLastTokens` (1)

### `_isChainNode`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `nodeViewChain` (1)

### `buildExps`
`/Users/ericsan/node_modules/uri-js/dist/es5/uri.all.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1167` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_makeToken` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2866` | Self: 0.0% (1.3ms) | Total: 0.0% (5.8ms) | Samples: 1

**Called by:**
- `defs` (3)
- `get defs` (1)

**Calls:**
- `_findDefNode` (1)
- `_findDefNode` (1)
- `_findDefNode` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7291` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7317` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:220` | Self: 0.0% (1.3ms) | Total: 0.0% (17.5ms) | Samples: 1

**Called by:**
- `generatorResume` (12)

**Calls:**
- `getForOfLoopHeadText` (4)
- `getForOfLoopHeadRange` (3)
- `getForOfLoopHeadText` (2)
- `getForOfLoopHeadRange` (1)
- `getForOfLoopHeadText` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:614` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `map`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.1% (25.5ms) | Samples: 1

**Called by:**
- `(module)` (6)
- `camelCase` (4)
- `get properties` (3)
- `getForOfLoopHeadText` (2)
- `onExit` (1)
- `_lintSourceOne` (1)

**Calls:**
- `toLocaleLowerCase` (4)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `getText` (1)
- `getText` (1)
- `_fromRunnerReport` (1)
- `(anonymous)` (1)

### `stringSplitFast`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `isNodeMatchesNameOrPath` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5965` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_getOrBuildPlan` (1)

### `getFixFunction`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:93` | Self: 0.0% (1.3ms) | Total: 0.0% (2.6ms) | Samples: 1

**Called by:**
- `isIterable` (1)
- `(anonymous)` (1)

**Calls:**
- `getText` (1)

### `findVariable`
`/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:54` | Self: 0.0% (1.3ms) | Total: 0.0% (9.1ms) | Samples: 1

**Called by:**
- `isFunctionParametersSafeToFix` (6)

**Calls:**
- `getInnermostScope` (3)
- `getInnermostScope` (1)
- `getInnermostScope` (1)

### `findVariable`
`/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:58` | Self: 0.0% (1.3ms) | Total: 0.0% (15.9ms) | Samples: 1

**Called by:**
- `isFunctionParametersSafeToFix` (11)

**Calls:**
- `get` (9)
- `get` (1)

### `fill`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `resolveIds`
`/Users/ericsan/node_modules/ajv/lib/compile/resolve.js:269` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_addSchema` (1)

### `getText`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1293` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `map` (1)

### `_rawTokenText`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:831` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `get value` (1)

### `cloneObject`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `toEslintProblem` (1)

### `Comparator`
`/Users/ericsan/node_modules/semver/classes/comparator.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_isOptionalTag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `get parent` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:431` | Self: 0.0% (1.3ms) | Total: 0.7% (162.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (108)

**Calls:**
- `isMethodCall` (52)
- `isMethodCall` (13)
- `isMemberExpression` (13)
- `isMethodCall` (11)
- `isMemberExpression` (6)
- `isMemberExpression` (6)
- `isMethodCall` (3)
- `isMemberExpression` (1)
- `isMemberExpression` (1)
- `isMethodCall` (1)

### `get argument`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1862` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `replaceReturnStatement` (1)

### `isFixable`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:352` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get property`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1974` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `isNotReference` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:518` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_computeVarDefs` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3252` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `getParentSyntaxOpeningParenthesis`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/get-parent-syntax-opening-parenthesis.js:26` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `iterateSurroundingParentheses` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2088` | Self: 0.0% (1.2ms) | Total: 0.0% (2.9ms) | Samples: 1

**Called by:**
- `_computeDeclaredVariables` (2)

**Calls:**
- `set` (1)

### `getText`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1306` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `getFixFunction` (1)

### `iterateSurroundingParentheses`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/iterate-surrounding-parentheses.js:56` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `generatorResume` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2087` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_computeDeclaredVariables` (1)

### `_fromRunnerReport`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `map` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2126` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_computeVarScope` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2527` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2535` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:425` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get typeAnnotation`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7636` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_lintSourceOne` (1)

### `get params`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2583` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `isNotReference` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `getForOfLoopHeadRange` (1)

### `stringify`
`/Users/ericsan/node_modules/fast-json-stable-stringify/index.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_addSchema` (1)

### `get key`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3155` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `isNotReference` (1)

### `get start`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1113` | Self: 0.0% (1.0ms) | Total: 0.0% (1.0ms) | Samples: 1

**Called by:**
- `get range` (1)

### `RegExp`
`[native code]` | Self: 0.0% (988us) | Total: 0.0% (988us) | Samples: 1

**Called by:**
- `createToken` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:454` | Self: 0.0% (0us) | Total: 86.2% (19.64s) | Samples: 0

**Called by:**
- `generatorResume` (12835)

**Calls:**
- `isFixable` (12814)
- `isFixable` (19)
- `isFixable` (1)
- `isFixable` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/rules/utils/lazy-loading-rule-map.js:7` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1713` | Self: 0.0% (0us) | Total: 0.0% (14.5ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (10)

**Calls:**
- `_nodesFromRange` (9)
- `_nodesFromRange` (1)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `encodeInto` (1)

### `isFunctionParametersSafeToFix`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:283` | Self: 0.0% (0us) | Total: 0.1% (29.7ms) | Samples: 0

**Called by:**
- `isFixable` (20)

**Calls:**
- `getDeclaredVariables` (20)

### `_ensureChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:990` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `get` (1)

**Calls:**
- `_buildScopeChildren` (1)

### `onExit`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:41` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `bound onExit` (1)

**Calls:**
- `map` (1)

### `linkAndEvaluateModule`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (4.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `link` (3)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/config/default-config.js:37` | Self: 0.0% (0us) | Total: 0.0% (11.4ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 2.3% (536.4ms) | Samples: 0

**Called by:**
- `loadPlugin` (77)
- `(anonymous)` (31)
- `(anonymous)` (19)
- `(anonymous)` (14)
- `(anonymous)` (14)
- `(anonymous)` (12)
- `(anonymous)` (11)
- `(anonymous)` (11)
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
- `(anonymous)` (4)
- `patchAstUtils` (4)
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
- `loadBinding` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `_tryLoad` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(module)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
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
- `require` (356)
- `anonymous` (3)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `camelCase`
`/Users/ericsan/node_modules/change-case/dist/index.js:68` | Self: 0.0% (0us) | Total: 0.0% (6.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)
- `addPolyfillToken` (1)

**Calls:**
- `map` (4)

### `node:events`
`node:events:9` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:268` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `generatorResume` (1)

**Calls:**
- `get parent` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/semver/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (988us) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `bound require` (1)

### `isAvailable`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-source-code.js:56` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `_getFfi` (2)

**Calls:**
- `_tryLoad` (1)
- `_tryLoad` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/transform/index.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:60` | Self: 0.0% (0us) | Total: 0.0% (4.2ms) | Samples: 0

**Called by:**
- `isReferenceIdentifier` (3)

**Calls:**
- `get value` (3)

### `getLastTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3403` | Self: 0.0% (0us) | Total: 0.0% (4.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `getTokens` (1)
- `getTokens` (1)
- `getTokens` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/debug/src/node.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `create`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:62` | Self: 0.0% (0us) | Total: 0.1% (37.8ms) | Samples: 0

**Called by:**
- `isMethodCall` (25)

**Calls:**
- `arguments` (23)
- `arguments` (2)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:34` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `isReferenceIdentifier` (1)

**Calls:**
- `get id` (1)

### `_tryLoad`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-source-code.js:44` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `isAvailable` (1)

**Calls:**
- `dlopen` (1)

### `create`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:83` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `isMethodCall` (1)

**Calls:**
- `isArray` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1367` | Self: 0.0% (0us) | Total: 0.1% (27.9ms) | Samples: 0

**Called by:**
- `isFunctionParametersSafeToFix` (12)
- `isMemberExpression` (6)

**Calls:**
- `_resolveUnicodeEscapes` (8)
- `_identAt` (6)
- `_identAt` (4)

### `replaceReturnStatement`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:158` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `generatorResume` (1)

**Calls:**
- `shouldSwitchReturnStatementToBlockStatement` (1)

### `(module)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:60` | Self: 0.0% (0us) | Total: 0.0% (9.3ms) | Samples: 0

**Called by:**
- `evaluate` (6)

**Calls:**
- `map` (6)

### `addPolyfillToken`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:55` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `camelCase` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/config/config.js:16` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/levn/lib/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/node_modules/minimatch/dist/commonjs/ast.js:7` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/core-js-compat/compat.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:24` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:52` | Self: 0.0% (0us) | Total: 0.0% (4.2ms) | Samples: 0

**Called by:**
- `isReferenceIdentifier` (3)

**Calls:**
- `get computed` (3)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2876` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `defs` (1)

**Calls:**
- `get parent` (1)

### `(module)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/expiring-todo-comments.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `evaluate` (1)

**Calls:**
- `bound require` (1)

### `getParentheses`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/parentheses.js:25` | Self: 0.0% (0us) | Total: 0.1% (24.6ms) | Samples: 0

**Called by:**
- `removeParentheses` (13)
- `getParenthesizedRange` (2)
- `removeCallbackParentheses` (2)

**Calls:**
- `generatorResume` (14)
- `next` (3)

### `isFixable`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:359` | Self: 0.0% (0us) | Total: 0.1% (30.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (19)

**Calls:**
- `some` (19)

### `isFunctionSelfUsedInside`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/is-function-self-used-inside.js:21` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `isFixable` (1)

**Calls:**
- `get id` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/regexp-tree.js:8` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/levn/lib/parse-string.js:113` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7664` | Self: 0.0% (0us) | Total: 98.3% (22.40s) | Samples: 0

**Called by:**
- `_lintSourceOne` (14647)

**Calls:**
- `walkNodes` (13390)
- `walkNodes` (1126)
- `walkNodes` (18)
- `walkNodes` (17)
- `walkNodes` (17)
- `walkNodes` (13)
- `walkNodes` (12)
- `walkNodes` (11)
- `walkNodes` (10)
- `walkNodes` (4)
- `walkNodes` (4)
- `walkNodes` (4)
- `walkNodes` (3)
- `walkNodes` (3)
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

### `getForOfLoopHeadRange`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:127` | Self: 0.0% (0us) | Total: 0.0% (4.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `getParenthesizedRange` (2)
- `get body` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/compat-transpiler/index.js:9` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/caniuse-lite/dist/unpacker/agents.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `reduce` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/config/config.js:15` | Self: 0.0% (0us) | Total: 0.0% (8.6ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:828` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `_buildReference` (1)

### `addSchema`
`/Users/ericsan/node_modules/ajv/lib/ajv.js:137` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `addMetaSchema` (2)

**Calls:**
- `_addSchema` (1)
- `_addSchema` (1)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1623` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `fixSpaceAroundKeyword` (1)

**Calls:**
- `has` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3226` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (1)

**Calls:**
- `next` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/esutils/lib/utils.js:29` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/debug/src/index.js:9` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `reduce`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (5.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/compat-transpiler/index.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/rules/no-warning-comments.js:9` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:464` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `generatorResume` (1)

**Calls:**
- `get optional` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7283` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `invokeMethodFnHandlers` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/linter/linter.js:48` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6447` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `walkNodes` (1)
- `walkNodes` (1)

**Calls:**
- `invokeHandlersWithNode` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/linter/apply-disable-directives.js:22` | Self: 0.0% (0us) | Total: 0.0% (15.6ms) | Samples: 0

**Called by:**
- `anonymous` (11)

**Calls:**
- `bound require` (11)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/ajv.js:9` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/linter/linter.js:19` | Self: 0.0% (0us) | Total: 0.0% (17.2ms) | Samples: 0

**Called by:**
- `anonymous` (12)

**Calls:**
- `bound require` (12)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:414` | Self: 0.0% (0us) | Total: 3.3% (764.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (502)

**Calls:**
- `isReferenceIdentifier` (481)
- `isReferenceIdentifier` (21)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.0% (4.5ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:322` | Self: 0.0% (0us) | Total: 0.0% (4.4ms) | Samples: 0

**Called by:**
- `some` (3)

**Calls:**
- `get references` (2)
- `get references` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/browserslist/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `iterateSurroundingParentheses`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/iterate-surrounding-parentheses.js:67` | Self: 0.0% (0us) | Total: 0.0% (20.5ms) | Samples: 0

**Called by:**
- `generatorResume` (14)

**Calls:**
- `getSurroundingParentheses` (13)
- `getSurroundingParentheses` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2085` | Self: 0.0% (0us) | Total: 0.0% (6.0ms) | Samples: 0

**Called by:**
- `_computeDeclaredVariables` (4)

**Calls:**
- `_symName` (4)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` | Self: 0.0% (0us) | Total: 0.9% (218.5ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (143)

**Calls:**
- `parse` (143)

### `iterateFixOrProblems`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js:24` | Self: 0.0% (0us) | Total: 90.0% (20.51s) | Samples: 0

**Called by:**
- `generatorResume` (13403)

**Calls:**
- `next` (11298)
- `generatorResume` (2081)
- `iterateFixOrProblems` (24)

### `_addSchema`
`/Users/ericsan/node_modules/ajv/lib/ajv.js:295` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `addSchema` (1)

**Calls:**
- `stringify` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2688` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `_ensureChildren` (1)

**Calls:**
- `_buildScope` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/source-code.js:11` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4165` | Self: 0.0% (0us) | Total: 0.1% (39.6ms) | Samples: 0

**Called by:**
- `arguments` (18)
- `isMethodCall` (7)
- `create` (1)

**Calls:**
- `_nodeViewRaw` (23)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:8` | Self: 0.0% (0us) | Total: 0.0% (10.0ms) | Samples: 0

**Called by:**
- `isReferenceIdentifier` (7)

**Calls:**
- `get property` (5)
- `get computed` (1)
- `get property` (1)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1576` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `getSurroundingParentheses` (2)

**Calls:**
- `_getFfi` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/languages/js/index.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/@eslint/config-array/dist/cjs/index.cjs:5` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:274` | Self: 0.0% (0us) | Total: 98.4% (22.41s) | Samples: 0

**Called by:**
- `(anonymous)` (14653)

**Calls:**
- `runPlugins` (14647)
- `runPlugins` (3)
- `runPlugins` (1)
- `runPlugins` (1)
- `runPlugins` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/interpreter/finite-automaton/index.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/index.js:8` | Self: 0.0% (0us) | Total: 0.0% (7.6ms) | Samples: 0

**Called by:**
- `parseModule` (4)

**Calls:**
- `bound require` (4)

### `(anonymous)`
`/Users/ericsan/node_modules/uri-js/dist/es5/uri.all.js:148` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `buildExps` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/languages/js/index.js:18` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/semver/index.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `bound require` (1)

### `getText`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1292` | Self: 0.0% (0us) | Total: 0.0% (1.0ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `get range` (1)

### `wrap`
`bun:ffi:296` | Self: 0.0% (0us) | Total: 0.0% (4.1ms) | Samples: 0

**Called by:**
- `getTokenBefore` (3)

**Calls:**
- `anonymous` (3)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4008` | Self: 0.0% (0us) | Total: 3.4% (790.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (520)

**Calls:**
- `_execReport` (514)
- `_execReport` (3)
- `_execReport` (2)
- `_execReport` (1)

### `loadPlugin`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:89` | Self: 0.0% (0us) | Total: 0.5% (115.8ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (77)

**Calls:**
- `bound require` (77)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:18` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `_getFfi`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:72` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `getTokenBefore` (2)

**Calls:**
- `isAvailable` (2)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1020` | Self: 0.0% (0us) | Total: 0.0% (13.0ms) | Samples: 0

**Called by:**
- `findVariable` (9)

**Calls:**
- `_ensureVarsSet` (9)

### `getAllComments`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3369` | Self: 0.0% (0us) | Total: 0.0% (22.3ms) | Samples: 0

**Called by:**
- `_getTokensAndCommentsMerged` (13)

**Calls:**
- `commentsInRange` (6)
- `commentsInRange` (4)
- `commentsInRange` (2)
- `commentsInRange` (1)

### `node:util`
`node:util:2` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-listener.js:34` | Self: 0.0% (0us) | Total: 3.4% (790.6ms) | Samples: 0

**Called by:**
- `_invokeFused` (520)

**Calls:**
- `report` (520)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2772` | Self: 0.0% (0us) | Total: 0.0% (19.0ms) | Samples: 0

**Called by:**
- `getScope` (12)

**Calls:**
- `commentsInRange` (7)
- `commentsInRange` (4)
- `commentsInRange` (1)

### `internal:stream`
`internal:stream:2` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (16.2ms) | Samples: 0

**Calls:**
- `parseModule` (11)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:142` | Self: 0.0% (0us) | Total: 0.5% (115.8ms) | Samples: 0

**Calls:**
- `loadPlugin` (77)

### `isMethodCall`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:42` | Self: 0.0% (0us) | Total: 0.0% (15.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (11)

**Calls:**
- `copyDataProperties` (11)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1967` | Self: 0.0% (0us) | Total: 0.1% (26.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (17)

**Calls:**
- `_precomputeScopes` (12)
- `_precomputeScopes` (4)
- `_precomputeScopes` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/parser/index.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-listener.js:31` | Self: 0.0% (0us) | Total: 92.7% (21.12s) | Samples: 0

**Called by:**
- `_invokeFused` (13801)
- `invokeHandlersWithNode` (2)

**Calls:**
- `generatorResume` (12643)
- `next` (1149)
- `iterateFixOrProblems` (11)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` | Self: 0.0% (0us) | Total: 0.0% (5.8ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `AstView` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:20` | Self: 0.0% (0us) | Total: 0.0% (20.2ms) | Samples: 0

**Called by:**
- `anonymous` (14)

**Calls:**
- `bound require` (14)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/source-code.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:455` | Self: 0.0% (0us) | Total: 0.0% (5.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `bound require` (4)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` | Self: 0.0% (0us) | Total: 0.9% (227.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (146)

**Calls:**
- `parseSource` (143)
- `parseSource` (1)
- `parseSource` (1)
- `parseSource` (1)

### `iterateSurroundingParentheses`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/iterate-surrounding-parentheses.js:71` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `generatorResume` (2)

**Calls:**
- `getParentSyntaxOpeningParenthesis` (1)
- `getParentSyntaxOpeningParenthesis` (1)

### `fixSpaceAroundKeyword`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/fix/fix-space-around-keywords.js:28` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `generatorResume` (1)

**Calls:**
- `getRange` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/@babel/helper-validator-identifier/lib/index.js:54` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `bound require` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:615` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `getAllComments` (1)

**Calls:**
- `slice` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:71` | Self: 0.0% (0us) | Total: 0.0% (4.6ms) | Samples: 0

**Called by:**
- `map` (3)

**Calls:**
- `camelCase` (3)

### `getParenthesizedRange`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/parentheses.js:44` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `getForOfLoopHeadRange` (2)

**Calls:**
- `getParentheses` (2)

### `_getOrBuildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5674` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_buildPlan` (1)

### `performIteration`
`[native code]` | Self: 0.0% (0us) | Total: 3.4% (779.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (513)

**Calls:**
- `generatorResume` (433)
- `next` (80)

### `internal:streams/operators`
`internal:streams/operators:2` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `internal:validators`
`internal:validators:47` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `hideFromStack` (1)

### `get defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `isFunctionParametersSafeToFix` (1)

**Calls:**
- `_computeVarDefs` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/browserslist/index.js:1313` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `normalize` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4447` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/config/config-loader.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3180` | Self: 0.0% (0us) | Total: 0.1% (29.7ms) | Samples: 0

**Called by:**
- `isFunctionParametersSafeToFix` (20)

**Calls:**
- `_computeDeclaredVariables` (7)
- `_computeDeclaredVariables` (4)
- `_computeDeclaredVariables` (3)
- `_computeDeclaredVariables` (2)
- `_computeDeclaredVariables` (1)
- `_computeDeclaredVariables` (1)
- `_computeDeclaredVariables` (1)
- `_computeDeclaredVariables` (1)

### `replaceReturnStatement`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:151` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `generatorResume` (1)

**Calls:**
- `get argument` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:911` | Self: 0.0% (0us) | Total: 0.0% (13.0ms) | Samples: 0

**Called by:**
- `get` (9)

**Calls:**
- `_buildScopeVarsAndSet` (3)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/optimizer/index.js:11` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/source-code.js:21` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:97` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `addPolyfillToken` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/core-js-compat/index.js:2` | Self: 0.0% (0us) | Total: 0.0% (11.0ms) | Samples: 0

**Called by:**
- `parseModule` (7)

**Calls:**
- `bound require` (7)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:23` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/ajv.js:3` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `get ReadStream`
`node:fs:573` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `parseModule` (2)

**Calls:**
- `anonymous` (2)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:784` | Self: 0.0% (0us) | Total: 0.0% (6.0ms) | Samples: 0

**Called by:**
- `get name` (4)

**Calls:**
- `source` (4)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/compile/rules.js:3` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `isMemberExpression`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:67` | Self: 0.0% (0us) | Total: 0.0% (19.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (13)

**Calls:**
- `get name` (6)
- `get name` (4)
- `get name` (2)
- `get name` (1)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:25` | Self: 0.0% (0us) | Total: 0.0% (2.2ms) | Samples: 0

**Called by:**
- `isReferenceIdentifier` (2)

**Calls:**
- `get params` (2)

### `getForOfLoopHeadText`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:96` | Self: 0.0% (0us) | Total: 0.0% (2.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `map` (2)

### `arrayIteratorNextHelper`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `from` (1)

**Calls:**
- `typedArrayViewLength` (1)

### `processTicksAndRejections`
`[native code]` | Self: 0.0% (0us) | Total: 99.4% (22.64s) | Samples: 0

**Calls:**
- `(anonymous)` (14801)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/dotjs/index.js:25` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1898` | Self: 0.0% (0us) | Total: 2.7% (630.7ms) | Samples: 0

**Called by:**
- `getTokenBefore` (416)

**Calls:**
- `_getAllTokens` (407)
- `_getAllTokens` (9)

### `getFixFunction`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:91` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-create.js:38` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (1)

**Calls:**
- `create` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/languages/js/index.js:12` | Self: 0.0% (0us) | Total: 0.0% (6.9ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:497` | Self: 0.0% (0us) | Total: 0.0% (5.8ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `patchAstUtils` (4)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7656` | Self: 0.0% (0us) | Total: 0.0% (4.9ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (3)

**Calls:**
- `get source` (2)
- `reset` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/eslint/eslint.js:19` | Self: 0.0% (0us) | Total: 0.0% (16.5ms) | Samples: 0

**Called by:**
- `anonymous` (11)

**Calls:**
- `bound require` (11)

### `(anonymous)`
`/Users/ericsan/node_modules/uri-js/dist/es5/uri.all.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/prelude-ls/lib/index.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3210` | Self: 0.0% (0us) | Total: 0.0% (10.2ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (7)

**Calls:**
- `_ensureDeclSymIndex` (4)
- `_ensureDeclSymIndex` (2)
- `_ensureDeclSymIndex` (1)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1593` | Self: 0.0% (0us) | Total: 0.0% (4.1ms) | Samples: 0

**Called by:**
- `getSurroundingParentheses` (3)

**Calls:**
- `wrap` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:28` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `readFileSync` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/uri-js/dist/es5/uri.all.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1607` | Self: 0.0% (0us) | Total: 0.0% (5.6ms) | Samples: 0

**Called by:**
- `getSurroundingParentheses` (4)

**Calls:**
- `_makeToken` (2)
- `_makeToken` (2)

### `isMemberExpression`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:80` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get computed` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3192` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (2)

**Calls:**
- `subarray` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/compile/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/locate-path/index.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/browserslist/index.js:1` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `bound onExit`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `create` (1)

**Calls:**
- `onExit` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:545` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_computeVarDefs` (1)

**Calls:**
- `has` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7357` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `get` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/config/config.js:14` | Self: 0.0% (0us) | Total: 0.0% (4.4ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/node_modules/@eslint/config-array/node_modules/minimatch/dist/commonjs/index.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7353` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `defineProperty` (1)

### `replaceReturnStatement`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:161` | Self: 0.0% (0us) | Total: 0.0% (8.3ms) | Samples: 0

**Called by:**
- `generatorResume` (6)

**Calls:**
- `needsSemicolon` (6)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/linter/esquery.js:12` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `isFunctionParametersSafeToFix`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:286` | Self: 0.0% (0us) | Total: 0.0% (7.5ms) | Samples: 0

**Called by:**
- `isFixable` (5)

**Calls:**
- `defs` (4)
- `get defs` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/compile/resolve.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `decode` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:17` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(module)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/prefer-array-index-of.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `evaluate` (1)

**Calls:**
- `simpleArraySearchRule` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7140` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `getDFSEvents` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:25` | Self: 0.0% (0us) | Total: 0.0% (11.6ms) | Samples: 0

**Called by:**
- `parseModule` (8)

**Calls:**
- `bound require` (8)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7644` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `fill` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1211` | Self: 0.0% (0us) | Total: 0.1% (39.4ms) | Samples: 0

**Called by:**
- `isNotReference` (23)
- `_computeIsStrict` (1)
- `isNotReference` (1)
- `isNotReference` (1)

**Calls:**
- `nodeView` (24)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:267` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getTagNames` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/rules/utils/ast-utils.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `isFunctionParameterVariableReassigned`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:320` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `getForOfLoopHeadText` (1)

**Calls:**
- `filter` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/semver/internal/re.js:173` | Self: 0.0% (0us) | Total: 0.0% (988us) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `createToken` (1)

### `internal:fs/streams`
`internal:fs/streams:2` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `anonymous` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/@eslint/plugin-kit/dist/cjs/index.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `node:assert/strict`
`node:assert/strict:3` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `anonymous` (1)

### `getFixFunction`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:89` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `nodeViewChain` (1)

### `isNodeMatches`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/is-node-matches.js:57` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `some` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/browserslist/index.js:1334` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/eslint/eslint.js:44` | Self: 0.0% (0us) | Total: 0.1% (27.1ms) | Samples: 0

**Called by:**
- `anonymous` (19)

**Calls:**
- `bound require` (19)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:56` | Self: 0.0% (0us) | Total: 2.5% (572.3ms) | Samples: 0

**Called by:**
- `isReferenceIdentifier` (374)

**Calls:**
- `get properties` (370)
- `get properties` (3)
- `get parent` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:405` | Self: 0.0% (0us) | Total: 0.3% (86.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (57)

**Calls:**
- `_buildScope` (29)
- `getScope` (17)
- `_buildScope` (4)
- `_buildScope` (2)
- `_buildScope` (2)
- `getScope` (1)
- `getScope` (1)
- `_buildScope` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:478` | Self: 0.0% (0us) | Total: 0.0% (5.8ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `CfgGraph` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7447` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `invokeMethodFnHandlers` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/semver/ranges/subset.js:73` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `Comparator` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2242` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `_buildScope` (2)

**Calls:**
- `get parent` (1)
- `get parent` (1)

### `fixSpaceAroundKeyword`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/fix/fix-space-around-keywords.js:24` | Self: 0.0% (0us) | Total: 3.1% (706.9ms) | Samples: 0

**Called by:**
- `generatorResume` (464)

**Calls:**
- `getTokenBefore` (463)
- `getTokenBefore` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2328` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `set` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:279` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `map` (1)

### `moduleEvaluation`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (36.8ms) | Samples: 0

**Called by:**
- `moduleEvaluation` (16)
- `(anonymous)` (8)

**Calls:**
- `moduleEvaluation` (16)
- `evaluate` (8)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:55` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `isReferenceIdentifier` (1)

**Calls:**
- `get parent` (1)

### `isNodeMatchesNameOrPath`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/is-node-matches.js:9` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `some` (1)

**Calls:**
- `stringSplitFast` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `isFunctionParametersSafeToFix`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:308` | Self: 0.0% (0us) | Total: 0.1% (26.6ms) | Samples: 0

**Called by:**
- `isFixable` (18)

**Calls:**
- `findVariable` (11)
- `findVariable` (6)
- `findVariable` (1)

### `_computeVarScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2892` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `scope` (1)

**Calls:**
- `_buildScope` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1023` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `getInnermostScope` (1)

**Calls:**
- `_ensureChildren` (1)

### `shouldSwitchReturnStatementToBlockStatement`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:66` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `replaceReturnStatement` (1)

**Calls:**
- `get consequent` (1)

### `getForOfLoopHeadRange`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:126` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getRange` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:104` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:359` | Self: 0.0% (0us) | Total: 0.1% (28.4ms) | Samples: 0

**Called by:**
- `some` (18)

**Calls:**
- `get typeAnnotation` (15)
- `get typeAnnotation` (2)
- `get typeAnnotation` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/core-js-compat/compat.js:7` | Self: 0.0% (0us) | Total: 0.0% (9.3ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2289` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `Map` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3275` | Self: 0.0% (0us) | Total: 0.0% (4.3ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (3)

**Calls:**
- `set` (3)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7663` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `buildVisitorMap` (1)

### `getForOfLoopHeadText`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:100` | Self: 0.0% (0us) | Total: 0.0% (6.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `some` (3)
- `isFunctionParameterVariableReassigned` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/cli-engine/lint-result-cache.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `getInnermostScope`
`/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:19` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `findVariable` (1)

**Calls:**
- `get` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/linter/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (20.2ms) | Samples: 0

**Called by:**
- `anonymous` (14)

**Calls:**
- `bound require` (14)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3978` | Self: 0.0% (0us) | Total: 3.4% (781.1ms) | Samples: 0

**Called by:**
- `report` (514)

**Calls:**
- `(anonymous)` (514)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2140` | Self: 0.0% (0us) | Total: 0.0% (3.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `_buildScope` (2)

### `loadBinding`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `getTagNames` (1)

**Calls:**
- `bound require` (1)

### `evaluate`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (12.2ms) | Samples: 0

**Called by:**
- `moduleEvaluation` (8)

**Calls:**
- `(module)` (6)
- `(module)` (1)
- `(module)` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3962` | Self: 0.0% (0us) | Total: 0.0% (4.8ms) | Samples: 0

**Called by:**
- `report` (3)

**Calls:**
- `getLocFromIndex` (2)
- `getLocFromIndex` (1)

### `_tryLoad`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-source-code.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `isAvailable` (1)

**Calls:**
- `bound require` (1)

### `needsSemicolon`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/needs-semicolon.js:52` | Self: 0.0% (0us) | Total: 0.0% (8.3ms) | Samples: 0

**Called by:**
- `replaceReturnStatement` (6)

**Calls:**
- `getNodeByRangeIndex` (3)
- `getNodeByRangeIndex` (2)
- `getNodeByRangeIndex` (1)

### `removeParentheses`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/fix/remove-parentheses.js:15` | Self: 0.0% (0us) | Total: 0.0% (18.8ms) | Samples: 0

**Called by:**
- `generatorResume` (13)

**Calls:**
- `getParentheses` (13)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/rules/index.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `get params`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2587` | Self: 0.0% (0us) | Total: 0.0% (2.2ms) | Samples: 0

**Called by:**
- `isNotReference` (2)

**Calls:**
- `_nodesFromRange` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (6.9ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/node_modules/levn/lib/index.js:22` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `_addSchema`
`/Users/ericsan/node_modules/ajv/lib/ajv.js:309` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `addSchema` (1)

**Calls:**
- `resolveIds` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/ajv.js:10` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `link`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (16.9ms) | Samples: 0

**Called by:**
- `link` (8)
- `linkAndEvaluateModule` (3)

**Calls:**
- `link` (8)
- `moduleDeclarationInstantiation` (3)

### `create`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:409` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound onExit` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:220` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `_encodeSource` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/compile/index.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

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
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:11` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `parseModule` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/shared/ajv.js:11` | Self: 0.0% (0us) | Total: 0.0% (8.6ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `normalize`
`/Users/ericsan/node_modules/browserslist/index.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `filter` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/find-up/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/linter/code-path-analysis/code-path-analyzer.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/caniuse-lite/dist/unpacker/agents.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` | Self: 0.0% (0us) | Total: 0.0% (5.9ms) | Samples: 0

**Called by:**
- `isFunctionParametersSafeToFix` (4)

**Calls:**
- `_computeVarDefs` (3)
- `_computeVarDefs` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/token-store/index.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1359` | Self: 0.0% (0us) | Total: 8.0% (1.83s) | Samples: 0

**Called by:**
- `isFunctionParametersSafeToFix` (1200)

**Calls:**
- `source` (1200)

### `(anonymous)`
`/Users/ericsan/node_modules/levn/lib/parse-string.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:822` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `_computeVariableSynthRefs` (1)
- `_computeVariableSynthRefs` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/optimizer/transforms/index.js:55` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1733` | Self: 0.0% (0us) | Total: 0.0% (5.5ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (4)

**Calls:**
- `nodeView` (4)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:465` | Self: 0.0% (0us) | Total: 0.0% (5.7ms) | Samples: 0

**Called by:**
- `generatorResume` (4)

**Calls:**
- `getFixFunction` (1)
- `getFixFunction` (1)
- `getFixFunction` (1)
- `getFixFunction` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `getTagNames`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:191` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `loadBinding` (1)

### `internal:stream`
`internal:stream:18` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `defineProperty` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/unsupported-api.js:14` | Self: 0.0% (0us) | Total: 0.1% (45.1ms) | Samples: 0

**Called by:**
- `parseModule` (31)

**Calls:**
- `bound require` (31)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/config/default-config.js:12` | Self: 0.0% (0us) | Total: 0.0% (5.0ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `addMetaSchema`
`/Users/ericsan/node_modules/ajv/lib/ajv.js:152` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `addSchema` (2)

### `get params`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2584` | Self: 0.0% (0us) | Total: 0.0% (8.1ms) | Samples: 0

**Called by:**
- `isNotReference` (5)

**Calls:**
- `_nodesFromRange` (4)
- `_nodesFromRange` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/core-js-compat/targets-parser.js:2` | Self: 0.0% (0us) | Total: 0.0% (9.3ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1994` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `_scopeForNode` (1)

### `get property`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1979` | Self: 0.0% (0us) | Total: 0.0% (14.2ms) | Samples: 0

**Called by:**
- `isNotReference` (5)
- `isMemberExpression` (5)

**Calls:**
- `nodeView` (10)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1899` | Self: 0.0% (0us) | Total: 0.0% (22.3ms) | Samples: 0

**Called by:**
- `getTokenBefore` (13)

**Calls:**
- `getAllComments` (13)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3224` | Self: 0.0% (0us) | Total: 0.0% (6.1ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (4)

**Calls:**
- `from` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` | Self: 0.0% (0us) | Total: 0.0% (8.6ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:62` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `isReferenceIdentifier` (2)

**Calls:**
- `get properties` (1)
- `get properties` (1)

### `isFixable`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:360` | Self: 0.0% (0us) | Total: 86.1% (19.61s) | Samples: 0

**Called by:**
- `(anonymous)` (12814)

**Calls:**
- `isFunctionParametersSafeToFix` (6800)
- `isFunctionParametersSafeToFix` (3819)
- `isFunctionParametersSafeToFix` (2029)
- `isFunctionParametersSafeToFix` (72)
- `isFunctionParametersSafeToFix` (51)
- `isFunctionParametersSafeToFix` (20)
- `isFunctionParametersSafeToFix` (18)
- `isFunctionParametersSafeToFix` (5)

### `isFixable`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:376` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isFunctionSelfUsedInside` (1)

### `removeCallbackParentheses`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:199` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `generatorResume` (2)

**Calls:**
- `getParentheses` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/regexp-tree.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/esutils/lib/utils.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:839` | Self: 0.0% (0us) | Total: 0.0% (6.0ms) | Samples: 0

**Called by:**
- `_ensureDeclSymIndex` (4)

**Calls:**
- `_buildSymNameCache` (3)
- `_buildSymNameCache` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/caniuse-lite/dist/unpacker/agents.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `reduce` (1)

**Calls:**
- `reduce` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:230` | Self: 0.0% (0us) | Total: 0.0% (4.5ms) | Samples: 0

**Called by:**
- `generatorResume` (3)

**Calls:**
- `getLastTokens` (3)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:225` | Self: 0.0% (0us) | Total: 0.0% (5.0ms) | Samples: 0

**Called by:**
- `generatorResume` (3)

**Calls:**
- `removeCallbackParentheses` (3)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/linter/source-code-traverser.js:12` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `hideFromStack`
`internal:shared:19` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `internal:validators` (1)

**Calls:**
- `defineProperty` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/caniuse-lite/dist/unpacker/agents.js:33` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `reduce` (1)

**Calls:**
- `reduce` (1)

### `internal:streams/end-of-stream`
`internal:streams/end-of-stream:17` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:447` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `generatorResume` (1)

**Calls:**
- `get callee` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6744` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_getOrBuildPlan` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2241` | Self: 0.0% (0us) | Total: 0.0% (4.6ms) | Samples: 0

**Called by:**
- `_buildScope` (3)

**Calls:**
- `get parent` (2)
- `get parent` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/regexp-tree.js:10` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/shared/ajv.js:29` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `addMetaSchema` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/node_modules/minimatch/dist/commonjs/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/semver/index.js:44` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/dotjs/index.js:10` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-listener.js:33` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `_invokeFused` (2)

**Calls:**
- `toEslintProblem` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/languages/js/index.js:15` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-listener.js:29` | Self: 0.0% (0us) | Total: 0.5% (122.9ms) | Samples: 0

**Called by:**
- `_invokeFused` (81)

**Calls:**
- `(anonymous)` (81)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7358` | Self: 0.0% (0us) | Total: 0.1% (24.4ms) | Samples: 0

**Called by:**
- `runPlugins` (17)

**Calls:**
- `_invokeFused` (17)

### `invokeHandlersWithNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6385` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/token-store/cursors.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `createToken`
`/Users/ericsan/node_modules/semver/internal/re.js:50` | Self: 0.0% (0us) | Total: 0.0% (988us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `RegExp` (1)

### `node:stream`
`node:stream:2` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `anonymous` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/compat-transpiler/transforms/index.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 34.9% | 7.95s | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 31.4% | 7.16s | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 28.3% | 6.45s | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js` |
| 2.4% | 555.5ms | `[native code]` |
| 1.1% | 258.8ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js` |
| 0.8% | 200.8ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js` |
| 0.4% | 95.1ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js` |
| 0.0% | 19.3ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js` |
| 0.0% | 11.1ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js` |
| 0.0% | 7.7ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js` |
| 0.0% | 7.5ms | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs` |
| 0.0% | 6.9ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/iterate-surrounding-parentheses.js` |
| 0.0% | 2.9ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js` |
| 0.0% | 2.7ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/get-parent-syntax-opening-parenthesis.js` |
| 0.0% | 1.7ms | `/Users/ericsan/node_modules/caniuse-lite/dist/unpacker/agents.js` |
| 0.0% | 1.7ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-rule-fixer.js` |
| 0.0% | 1.6ms | `/Users/ericsan/node_modules/eslint/lib/rules/index.js` |
| 0.0% | 1.6ms | `bun:ffi` |
| 0.0% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/index.js` |
| 0.0% | 1.5ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/fix/remove-parentheses.js` |
| 0.0% | 1.5ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/shared/simple-array-search-rule.js` |
| 0.0% | 1.4ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-problem.js` |
| 0.0% | 1.3ms | `/Users/ericsan/node_modules/uri-js/dist/es5/uri.all.js` |
| 0.0% | 1.3ms | `/Users/ericsan/node_modules/ajv/lib/compile/resolve.js` |
| 0.0% | 1.3ms | `/Users/ericsan/node_modules/semver/classes/comparator.js` |
| 0.0% | 1.2ms | `/Users/ericsan/Development/OpenSource/Ez/js/api.js` |
| 0.0% | 1.2ms | `/Users/ericsan/node_modules/fast-json-stable-stringify/index.js` |
