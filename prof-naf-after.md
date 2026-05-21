# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 21.10s | 13801 | 1.0ms | 569 |

**Top 10:** `isFunctionParametersSafeToFix` 35.3%, `isFunctionParametersSafeToFix` 26.1%, `get name` 14.9%, `_nodesFromRange` 3.0%, `get name` 2.3%, `getRange` 1.3%, `parse` 1.0%, `isFunctionParametersSafeToFix` 1.0%, `get name` 0.9%, `_makeToken` 0.9%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 35.3% | 7.46s | 54.0% | 11.39s | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:298` |
| 26.1% | 5.51s | 26.1% | 5.51s | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:301` |
| 14.9% | 3.14s | 14.9% | 3.14s | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 3.0% | 637.8ms | 3.1% | 668.7ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:905` |
| 2.3% | 487.1ms | 2.3% | 487.1ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1347` |
| 1.3% | 281.8ms | 1.3% | 281.8ms | `getRange` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3725` |
| 1.0% | 220.3ms | 1.0% | 220.3ms | `parse` | `[native code]` |
| 1.0% | 219.7ms | 2.8% | 590.7ms | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:299` |
| 0.9% | 205.3ms | 0.9% | 205.3ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1354` |
| 0.9% | 192.1ms | 0.9% | 192.1ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1267` |
| 0.8% | 174.3ms | 0.9% | 192.0ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1264` |
| 0.7% | 161.9ms | 0.7% | 161.9ms | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:297` |
| 0.6% | 131.0ms | 0.6% | 131.0ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1239` |
| 0.6% | 130.3ms | 8.6% | 1.83s | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7194` |
| 0.6% | 127.8ms | 0.6% | 133.5ms | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:309` |
| 0.5% | 111.8ms | 100.0% | 58.93s | `generatorResume` | `[native code]` |
| 0.4% | 100.4ms | 0.4% | 100.4ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:53` |
| 0.4% | 89.0ms | 5.9% | 1.25s | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:55` |
| 0.3% | 76.9ms | 2.0% | 422.6ms | `anonymous` | `[native code]` |
| 0.3% | 76.8ms | 0.3% | 76.8ms | `isIterable` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js:1` |
| 0.3% | 70.7ms | 0.3% | 76.8ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1357` |
| 0.2% | 62.6ms | 0.2% | 62.6ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` |
| 0.2% | 61.8ms | 0.2% | 61.8ms | `iterateFixOrProblems` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js:17` |
| 0.2% | 60.9ms | 0.2% | 60.9ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4058` |
| 0.2% | 56.5ms | 0.6% | 133.3ms | `iterateFixOrProblems` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js:18` |
| 0.2% | 49.6ms | 0.2% | 60.2ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3630` |
| 0.2% | 45.8ms | 0.2% | 45.8ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1235` |
| 0.2% | 43.8ms | 0.2% | 43.8ms | `copyDataProperties` | `[native code]` |
| 0.1% | 32.8ms | 0.8% | 177.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 0.1% | 26.7ms | 0.1% | 26.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6878` |
| 0.1% | 23.7ms | 0.1% | 23.7ms | `_getAllTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1884` |
| 0.1% | 23.3ms | 0.1% | 23.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1244` |
| 0.1% | 22.4ms | 0.1% | 22.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7431` |
| 0.1% | 21.5ms | 0.4% | 98.4ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:3` |
| 0.0% | 20.8ms | 0.0% | 20.8ms | `getRange` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3724` |
| 0.0% | 20.6ms | 0.0% | 20.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7329` |
| 0.0% | 20.4ms | 0.0% | 20.4ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1271` |
| 0.0% | 20.1ms | 4.0% | 859.5ms | `isReferenceIdentifier` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:158` |
| 0.0% | 19.4ms | 100.0% | 21.21s | `(anonymous)` | `[native code]` |
| 0.0% | 18.8ms | 0.0% | 18.8ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:54` |
| 0.0% | 18.6ms | 0.0% | 18.6ms | `isReferenceIdentifier` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:149` |
| 0.0% | 17.9ms | 0.0% | 17.9ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:902` |
| 0.0% | 17.9ms | 0.0% | 17.9ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 15.8ms | 0.0% | 15.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4095` |
| 0.0% | 15.6ms | 0.0% | 15.6ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:403` |
| 0.0% | 14.3ms | 0.0% | 14.3ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 14.2ms | 0.0% | 14.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6874` |
| 0.0% | 14.1ms | 0.0% | 14.1ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:810` |
| 0.0% | 13.9ms | 2.8% | 598.4ms | `_getAllTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1883` |
| 0.0% | 13.4ms | 0.3% | 71.2ms | `getRange` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3726` |
| 0.0% | 12.4ms | 0.0% | 12.4ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:656` |
| 0.0% | 12.2ms | 0.0% | 12.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1191` |
| 0.0% | 10.9ms | 0.1% | 32.7ms | `some` | `[native code]` |
| 0.0% | 10.9ms | 0.0% | 10.9ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 10.5ms | 0.0% | 10.5ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4132` |
| 0.0% | 10.0ms | 0.1% | 39.1ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1926` |
| 0.0% | 9.8ms | 0.0% | 9.8ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1177` |
| 0.0% | 9.6ms | 0.0% | 9.6ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2720` |
| 0.0% | 9.2ms | 0.1% | 41.6ms | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:53` |
| 0.0% | 8.8ms | 0.0% | 8.8ms | `get start` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1108` |
| 0.0% | 8.8ms | 0.0% | 8.8ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1203` |
| 0.0% | 8.7ms | 0.0% | 8.7ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1369` |
| 0.0% | 8.5ms | 0.0% | 8.5ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1273` |
| 0.0% | 8.5ms | 0.0% | 8.5ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:5` |
| 0.0% | 8.4ms | 0.0% | 8.4ms | `create` | `[native code]` |
| 0.0% | 7.9ms | 0.0% | 7.9ms | `defineProperty` | `[native code]` |
| 0.0% | 7.9ms | 0.0% | 7.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7154` |
| 0.0% | 7.7ms | 0.0% | 7.7ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3583` |
| 0.0% | 7.5ms | 0.0% | 7.5ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:236` |
| 0.0% | 7.3ms | 0.0% | 7.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7156` |
| 0.0% | 7.3ms | 0.0% | 7.3ms | `get mainToken` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1105` |
| 0.0% | 6.8ms | 94.7% | 19.99s | `iterateFixOrProblems` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js:23` |
| 0.0% | 6.8ms | 0.2% | 46.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2161` |
| 0.0% | 6.4ms | 0.1% | 31.5ms | `arguments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1931` |
| 0.0% | 6.4ms | 0.0% | 6.4ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4051` |
| 0.0% | 6.3ms | 0.0% | 6.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4111` |
| 0.0% | 6.1ms | 0.0% | 6.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6860` |
| 0.0% | 6.0ms | 3.3% | 696.2ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1624` |
| 0.0% | 6.0ms | 0.0% | 17.2ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:16` |
| 0.0% | 6.0ms | 0.0% | 6.0ms | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:16` |
| 0.0% | 5.9ms | 0.0% | 5.9ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1205` |
| 0.0% | 5.8ms | 0.0% | 5.8ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4393` |
| 0.0% | 5.6ms | 0.0% | 5.6ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:207` |
| 0.0% | 4.9ms | 0.1% | 30.4ms | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:40` |
| 0.0% | 4.9ms | 0.0% | 4.9ms | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:31` |
| 0.0% | 4.9ms | 0.0% | 4.9ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 4.8ms | 0.0% | 9.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7364` |
| 0.0% | 4.8ms | 0.0% | 4.8ms | `moduleDeclarationInstantiation` | `[native code]` |
| 0.0% | 4.8ms | 0.0% | 4.8ms | `get key` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3155` |
| 0.0% | 4.7ms | 0.0% | 4.7ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:855` |
| 0.0% | 4.7ms | 0.0% | 4.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7150` |
| 0.0% | 4.6ms | 0.0% | 4.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7330` |
| 0.0% | 4.6ms | 0.0% | 4.6ms | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:30` |
| 0.0% | 4.6ms | 0.0% | 4.6ms | `getNodeByRangeIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3688` |
| 0.0% | 4.6ms | 0.0% | 4.6ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1913` |
| 0.0% | 4.6ms | 0.0% | 8.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7362` |
| 0.0% | 4.5ms | 0.4% | 91.4ms | `parseModule` | `[native code]` |
| 0.0% | 4.4ms | 0.0% | 4.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2145` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6598` |
| 0.0% | 4.1ms | 96.4% | 20.35s | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4788` |
| 0.0% | 4.0ms | 88.6% | 18.69s | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7393` |
| 0.0% | 3.9ms | 0.8% | 181.0ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:431` |
| 0.0% | 3.9ms | 0.0% | 3.9ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `dlopen` | `[native code]` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `decode` | `[native code]` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2191` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3582` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `slice` | `[native code]` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1223` |
| 0.0% | 3.3ms | 0.1% | 21.9ms | `getSurroundingParentheses` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/iterate-surrounding-parentheses.js:30` |
| 0.0% | 3.3ms | 0.0% | 6.3ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1733` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:701` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2176` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `get callee` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1906` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `get` | `[native code]` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `resolve` | `[native code]` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1356` |
| 0.0% | 3.0ms | 0.0% | 5.8ms | `isMemberExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:66` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3132` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1167` |
| 0.0% | 2.9ms | 0.0% | 6.1ms | `findVariable` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:58` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `get computed` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2011` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2126` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `isCallExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:100` |
| 0.0% | 2.8ms | 0.0% | 16.2ms | `getForOfLoopHeadRange` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:127` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `getParentheses` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/parentheses.js:30` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `Set` | `[native code]` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:617` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 2.6ms | 0.0% | 4.3ms | `scope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:784` |
| 0.0% | 2.5ms | 0.0% | 17.0ms | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:42` |
| 0.0% | 2.4ms | 0.0% | 15.8ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:8` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `get properties` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3123` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2086` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `isMemberExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:16` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6441` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `get params` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2597` |
| 0.0% | 1.7ms | 0.0% | 14.9ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:613` |
| 0.0% | 1.7ms | 0.0% | 3.0ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:55` |
| 0.0% | 1.7ms | 0.0% | 4.7ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2847` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:614` |
| 0.0% | 1.7ms | 0.0% | 3.1ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:62` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1591` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2087` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2329` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:61` |
| 0.0% | 1.7ms | 84.6% | 17.84s | `isFixable` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:360` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7305` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3626` |
| 0.0% | 1.7ms | 0.0% | 3.3ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1593` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `stringSplitFast` | `[native code]` |
| 0.0% | 1.7ms | 3.1% | 669.9ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:56` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2892` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2724` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get left` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1789` |
| 0.0% | 1.7ms | 0.0% | 3.4ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:61` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getNodeByRangeIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3687` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `/^\s*exported\b/` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1486` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2079` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `/[./-]/u` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getParenthesizedRange` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/parentheses.js:45` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1376` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2916` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getForOfLoopHeadText` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:116` |
| 0.0% | 1.6ms | 0.0% | 5.6ms | `isMemberExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:39` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:620` |
| 0.0% | 1.6ms | 0.3% | 74.0ms | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:46` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7354` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4116` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_isStatementTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:72` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `filter` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get start` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 6.9ms | `getInnermostScope` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:19` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:415` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2871` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isFixable` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:341` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2187` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7166` |
| 0.0% | 1.6ms | 0.0% | 3.2ms | `readFileSync` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4003` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getParentSyntaxOpeningParenthesis` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/get-parent-syntax-opening-parenthesis.js:21` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `ez_ffi_token_idx_at_or_before` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_findLine` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3632` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:521` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2794` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:518` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:477` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_getSharedCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:746` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:619` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3646` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getParentSyntaxOpeningParenthesis` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/get-parent-syntax-opening-parenthesis.js:24` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_normalizeComponentEncoding` | `/Users/ericsan/node_modules/uri-js/dist/es5/uri.all.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get elements` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3039` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getFixFunction` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:86` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:784` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1931` |
| 0.0% | 1.5ms | 0.0% | 7.4ms | `getParenthesizedRange` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/parentheses.js:44` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:254` |
| 0.0% | 1.5ms | 0.0% | 2.9ms | `performProxyObjectGet` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3271` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `findVariable` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:57` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `extraArrowData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2876` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3586` |
| 0.0% | 1.5ms | 0.0% | 3.3ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:615` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3131` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7249` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2211` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `isFunctionSelfUsedInside` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/is-function-self-used-inside.js:17` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4115` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isArrowFunctionBody` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-arrow-function-body.js:2` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `entries` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/node_modules/glob-parent/index.js:5` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:66` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2238` |
| 0.0% | 1.4ms | 0.0% | 3.0ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1735` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get properties` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:83` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4775` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `toLocaleLowerCase` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 4.2ms | `(anonymous)` | `/Users/ericsan/node_modules/baseline-browser-mapping/dist/index.cjs:1` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `has` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 7.3ms | `getForOfLoopHeadText` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:100` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `toEslintRuleFixer` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-rule-fixer.js:29` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1374` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4392` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3967` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2276` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `encodeInto` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1708` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-context.js:25` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 3.6% | 780.3ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-listener.js:34` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1162` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get key` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3156` |
| 0.0% | 1.3ms | 0.0% | 7.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2140` |
| 0.0% | 1.3ms | 0.0% | 16.6ms | `map` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `stripChainExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:47` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get arguments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1920` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getForOfLoopHeadText` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:96` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `fill` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6600` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:87` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getParentSyntaxOpeningParenthesis` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/get-parent-syntax-opening-parenthesis.js:25` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `EventEmitter` | `node:events:11` |
| 0.0% | 1.3ms | 0.0% | 4.2ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:52` |
| 0.0% | 1.3ms | 0.0% | 3.0ms | `getFirstSegment` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:30` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `isReferenceIdentifier` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:153` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4110` |
| 0.0% | 1.2ms | 0.0% | 5.3ms | `_ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:990` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1862` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:594` |
| 0.0% | 1.2ms | 0.0% | 12.0ms | `evaluate` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1525` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getTokenAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1713` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `fillUsage` | `/Users/ericsan/node_modules/browserslist/index.js:79` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getFixFunction` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `Function` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2204` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `@lazy` | `[native code]` |
| 0.0% | 917us | 0.0% | 917us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2946` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 100.0% | 58.93s | 0.5% | 111.8ms | `generatorResume` | `[native code]` |
| 100.0% | 34.41s | 0.0% | 0us | `next` | `[native code]` |
| 100.0% | 21.21s | 0.0% | 19.4ms | `(anonymous)` | `[native code]` |
| 99.3% | 20.96s | 0.0% | 0us | `processTicksAndRejections` | `[native code]` |
| 98.2% | 20.73s | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:274` |
| 98.2% | 20.72s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7677` |
| 96.4% | 20.35s | 0.0% | 4.1ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4788` |
| 94.7% | 19.99s | 0.0% | 6.8ms | `iterateFixOrProblems` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js:23` |
| 92.3% | 19.47s | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-listener.js:31` |
| 88.8% | 18.73s | 0.0% | 0us | `iterateFixOrProblems` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js:24` |
| 88.6% | 18.69s | 0.0% | 4.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7393` |
| 84.7% | 17.87s | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:454` |
| 84.6% | 17.84s | 0.0% | 1.7ms | `isFixable` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:360` |
| 54.0% | 11.39s | 35.3% | 7.46s | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:298` |
| 26.1% | 5.51s | 26.1% | 5.51s | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:301` |
| 14.9% | 3.14s | 14.9% | 3.14s | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 8.6% | 1.83s | 0.6% | 130.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7194` |
| 5.9% | 1.25s | 0.4% | 89.0ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:55` |
| 4.1% | 879.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:414` |
| 4.0% | 859.5ms | 0.0% | 20.1ms | `isReferenceIdentifier` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:158` |
| 3.6% | 780.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-listener.js:34` |
| 3.6% | 779.0ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4021` |
| 3.6% | 774.3ms | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3991` |
| 3.6% | 768.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-rule-fixer.js:37` |
| 3.6% | 768.7ms | 0.0% | 0us | `performIteration` | `[native code]` |
| 3.3% | 696.2ms | 0.0% | 0us | `fixSpaceAroundKeyword` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/fix/fix-space-around-keywords.js:24` |
| 3.3% | 696.2ms | 0.0% | 6.0ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1624` |
| 3.1% | 669.9ms | 0.0% | 1.7ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:56` |
| 3.1% | 668.7ms | 3.0% | 637.8ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:905` |
| 3.1% | 660.3ms | 0.0% | 0us | `get properties` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3126` |
| 2.9% | 622.1ms | 0.0% | 0us | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1898` |
| 2.8% | 598.4ms | 0.0% | 13.9ms | `_getAllTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1883` |
| 2.8% | 590.7ms | 1.0% | 219.7ms | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:299` |
| 2.4% | 523.4ms | 0.0% | 0us | `bound require` | `[native code]` |
| 2.4% | 516.9ms | 0.0% | 0us | `require` | `[native code]` |
| 2.3% | 487.1ms | 2.3% | 487.1ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1347` |
| 2.0% | 422.6ms | 0.3% | 76.9ms | `anonymous` | `[native code]` |
| 1.3% | 281.8ms | 1.3% | 281.8ms | `getRange` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3725` |
| 1.0% | 230.5ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` |
| 1.0% | 220.3ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` |
| 1.0% | 220.3ms | 1.0% | 220.3ms | `parse` | `[native code]` |
| 0.9% | 205.3ms | 0.9% | 205.3ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1354` |
| 0.9% | 192.1ms | 0.9% | 192.1ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1267` |
| 0.9% | 192.0ms | 0.8% | 174.3ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1264` |
| 0.8% | 181.0ms | 0.0% | 3.9ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:431` |
| 0.8% | 177.8ms | 0.1% | 32.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 0.7% | 161.9ms | 0.7% | 161.9ms | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:297` |
| 0.6% | 133.5ms | 0.6% | 127.8ms | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:309` |
| 0.6% | 133.3ms | 0.2% | 56.5ms | `iterateFixOrProblems` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js:18` |
| 0.6% | 131.0ms | 0.6% | 131.0ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1239` |
| 0.5% | 114.9ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:142` |
| 0.5% | 114.9ms | 0.0% | 0us | `loadPlugin` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:89` |
| 0.4% | 100.4ms | 0.4% | 100.4ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:53` |
| 0.4% | 100.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-listener.js:29` |
| 0.4% | 98.4ms | 0.1% | 21.5ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:3` |
| 0.4% | 92.0ms | 0.0% | 0us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4137` |
| 0.4% | 91.4ms | 0.0% | 4.5ms | `parseModule` | `[native code]` |
| 0.4% | 85.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:405` |
| 0.3% | 76.8ms | 0.3% | 70.7ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1357` |
| 0.3% | 76.8ms | 0.3% | 76.8ms | `isIterable` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js:1` |
| 0.3% | 74.0ms | 0.0% | 1.6ms | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:46` |
| 0.3% | 71.2ms | 0.0% | 13.4ms | `getRange` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3726` |
| 0.2% | 62.6ms | 0.2% | 62.6ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` |
| 0.2% | 61.8ms | 0.2% | 61.8ms | `iterateFixOrProblems` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js:17` |
| 0.2% | 60.9ms | 0.2% | 60.9ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4058` |
| 0.2% | 60.2ms | 0.2% | 49.6ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3630` |
| 0.2% | 51.7ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4165` |
| 0.2% | 47.0ms | 0.0% | 0us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1211` |
| 0.2% | 46.2ms | 0.0% | 6.8ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2161` |
| 0.2% | 45.8ms | 0.2% | 45.8ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1235` |
| 0.2% | 43.8ms | 0.2% | 43.8ms | `copyDataProperties` | `[native code]` |
| 0.1% | 42.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/unsupported-api.js:14` |
| 0.1% | 41.6ms | 0.0% | 9.2ms | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:53` |
| 0.1% | 39.1ms | 0.0% | 10.0ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1926` |
| 0.1% | 36.1ms | 0.0% | 0us | `moduleEvaluation` | `[native code]` |
| 0.1% | 32.7ms | 0.0% | 10.9ms | `some` | `[native code]` |
| 0.1% | 32.1ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2260` |
| 0.1% | 31.5ms | 0.0% | 0us | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:62` |
| 0.1% | 31.5ms | 0.0% | 6.4ms | `arguments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1931` |
| 0.1% | 30.4ms | 0.0% | 4.9ms | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:40` |
| 0.1% | 29.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:220` |
| 0.1% | 26.7ms | 0.1% | 26.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6878` |
| 0.1% | 26.2ms | 0.0% | 0us | `getParentheses` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/parentheses.js:25` |
| 0.1% | 25.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/eslint/eslint.js:44` |
| 0.1% | 24.1ms | 0.0% | 0us | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:308` |
| 0.1% | 23.8ms | 0.0% | 0us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1967` |
| 0.1% | 23.7ms | 0.1% | 23.7ms | `_getAllTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1884` |
| 0.1% | 23.3ms | 0.1% | 23.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1244` |
| 0.1% | 23.2ms | 0.0% | 0us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1367` |
| 0.1% | 22.5ms | 0.0% | 0us | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1899` |
| 0.1% | 22.5ms | 0.0% | 0us | `getAllComments` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3369` |
| 0.1% | 22.4ms | 0.1% | 22.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7431` |
| 0.1% | 22.1ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2772` |
| 0.1% | 21.9ms | 0.0% | 3.3ms | `getSurroundingParentheses` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/iterate-surrounding-parentheses.js:30` |
| 0.1% | 21.9ms | 0.0% | 0us | `iterateSurroundingParentheses` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/iterate-surrounding-parentheses.js:67` |
| 0.1% | 21.4ms | 0.0% | 0us | `isMemberExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:67` |
| 0.0% | 20.8ms | 0.0% | 20.8ms | `getRange` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3724` |
| 0.0% | 20.6ms | 0.0% | 20.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7329` |
| 0.0% | 20.4ms | 0.0% | 20.4ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1271` |
| 0.0% | 19.3ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7371` |
| 0.0% | 18.8ms | 0.0% | 18.8ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:54` |
| 0.0% | 18.6ms | 0.0% | 18.6ms | `isReferenceIdentifier` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:149` |
| 0.0% | 18.4ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1713` |
| 0.0% | 18.1ms | 0.0% | 0us | `link` | `[native code]` |
| 0.0% | 17.9ms | 0.0% | 17.9ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:902` |
| 0.0% | 17.9ms | 0.0% | 17.9ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 17.8ms | 0.0% | 0us | `findVariable` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:54` |
| 0.0% | 17.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:20` |
| 0.0% | 17.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/linter/index.js:3` |
| 0.0% | 17.2ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:612` |
| 0.0% | 17.2ms | 0.0% | 6.0ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:16` |
| 0.0% | 17.0ms | 0.0% | 2.5ms | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:42` |
| 0.0% | 16.6ms | 0.0% | 1.3ms | `map` | `[native code]` |
| 0.0% | 16.2ms | 0.0% | 2.8ms | `getForOfLoopHeadRange` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:127` |
| 0.0% | 16.1ms | 0.0% | 0us | `get property` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1979` |
| 0.0% | 16.1ms | 0.0% | 0us | `isFixable` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:359` |
| 0.0% | 16.0ms | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 0.0% | 15.9ms | 0.0% | 0us | `removeParentheses` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/fix/remove-parentheses.js:15` |
| 0.0% | 15.8ms | 0.0% | 2.4ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:8` |
| 0.0% | 15.8ms | 0.0% | 15.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4095` |
| 0.0% | 15.8ms | 0.0% | 0us | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:283` |
| 0.0% | 15.8ms | 0.0% | 0us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3180` |
| 0.0% | 15.6ms | 0.0% | 15.6ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:403` |
| 0.0% | 14.9ms | 0.0% | 1.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:613` |
| 0.0% | 14.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/eslint/eslint.js:19` |
| 0.0% | 14.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/linter/apply-disable-directives.js:22` |
| 0.0% | 14.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/linter/linter.js:19` |
| 0.0% | 14.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:359` |
| 0.0% | 14.3ms | 0.0% | 14.3ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 14.2ms | 0.0% | 14.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6874` |
| 0.0% | 14.1ms | 0.0% | 14.1ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:810` |
| 0.0% | 13.5ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7296` |
| 0.0% | 12.4ms | 0.0% | 12.4ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:656` |
| 0.0% | 12.2ms | 0.0% | 12.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1191` |
| 0.0% | 12.0ms | 0.0% | 1.2ms | `evaluate` | `[native code]` |
| 0.0% | 11.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/core-js-compat/index.js:2` |
| 0.0% | 11.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:25` |
| 0.0% | 11.4ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3210` |
| 0.0% | 11.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/config/default-config.js:37` |
| 0.0% | 10.9ms | 0.0% | 0us | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:286` |
| 0.0% | 10.9ms | 0.0% | 10.9ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 10.5ms | 0.0% | 10.5ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4132` |
| 0.0% | 10.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/core-js-compat/targets-parser.js:2` |
| 0.0% | 10.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/core-js-compat/compat.js:7` |
| 0.0% | 9.8ms | 0.0% | 9.8ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1177` |
| 0.0% | 9.7ms | 0.0% | 4.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7364` |
| 0.0% | 9.6ms | 0.0% | 9.6ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2720` |
| 0.0% | 9.2ms | 0.0% | 0us | `(module)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:60` |
| 0.0% | 9.1ms | 0.0% | 0us | `getInnermostScope` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:21` |
| 0.0% | 9.0ms | 0.0% | 0us | `isFixable` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:372` |
| 0.0% | 8.8ms | 0.0% | 8.8ms | `get start` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1108` |
| 0.0% | 8.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:465` |
| 0.0% | 8.8ms | 0.0% | 4.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7362` |
| 0.0% | 8.8ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` |
| 0.0% | 8.8ms | 0.0% | 8.8ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1203` |
| 0.0% | 8.7ms | 0.0% | 8.7ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1369` |
| 0.0% | 8.5ms | 0.0% | 8.5ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1273` |
| 0.0% | 8.5ms | 0.0% | 8.5ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:5` |
| 0.0% | 8.4ms | 0.0% | 8.4ms | `create` | `[native code]` |
| 0.0% | 8.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` |
| 0.0% | 8.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/languages/js/index.js:12` |
| 0.0% | 8.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/index.js:3` |
| 0.0% | 7.9ms | 0.0% | 0us | `get params` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2584` |
| 0.0% | 7.9ms | 0.0% | 7.9ms | `defineProperty` | `[native code]` |
| 0.0% | 7.9ms | 0.0% | 0us | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 0.0% | 7.9ms | 0.0% | 0us | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:53` |
| 0.0% | 7.9ms | 0.0% | 7.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7154` |
| 0.0% | 7.7ms | 0.0% | 7.7ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3583` |
| 0.0% | 7.5ms | 0.0% | 7.5ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:236` |
| 0.0% | 7.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/index.js:8` |
| 0.0% | 7.4ms | 0.0% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2140` |
| 0.0% | 7.4ms | 0.0% | 1.5ms | `getParenthesizedRange` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/parentheses.js:44` |
| 0.0% | 7.3ms | 0.0% | 7.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7156` |
| 0.0% | 7.3ms | 0.0% | 0us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6436` |
| 0.0% | 7.3ms | 0.0% | 7.3ms | `get mainToken` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1105` |
| 0.0% | 7.3ms | 0.0% | 0us | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1607` |
| 0.0% | 7.3ms | 0.0% | 0us | `iterateSurroundingParentheses` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/iterate-surrounding-parentheses.js:71` |
| 0.0% | 7.3ms | 0.0% | 0us | `removeCallbackParentheses` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:199` |
| 0.0% | 7.3ms | 0.0% | 1.4ms | `getForOfLoopHeadText` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:100` |
| 0.0% | 7.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/config/config.js:15` |
| 0.0% | 7.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/shared/ajv.js:11` |
| 0.0% | 7.2ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:478` |
| 0.0% | 6.9ms | 0.0% | 1.6ms | `getInnermostScope` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:19` |
| 0.0% | 6.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:497` |
| 0.0% | 6.4ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:455` |
| 0.0% | 6.4ms | 0.0% | 6.4ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4051` |
| 0.0% | 6.3ms | 0.0% | 0us | `needsSemicolon` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/needs-semicolon.js:52` |
| 0.0% | 6.3ms | 0.0% | 0us | `replaceReturnStatement` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:161` |
| 0.0% | 6.3ms | 0.0% | 6.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4111` |
| 0.0% | 6.3ms | 0.0% | 3.3ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1733` |
| 0.0% | 6.1ms | 0.0% | 2.9ms | `findVariable` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:58` |
| 0.0% | 6.1ms | 0.0% | 6.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6860` |
| 0.0% | 6.0ms | 0.0% | 6.0ms | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:16` |
| 0.0% | 5.9ms | 0.0% | 0us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6460` |
| 0.0% | 5.9ms | 0.0% | 0us | `invokeHandlersWithNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6398` |
| 0.0% | 5.9ms | 0.0% | 5.9ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1205` |
| 0.0% | 5.8ms | 0.0% | 5.8ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4393` |
| 0.0% | 5.8ms | 0.0% | 3.0ms | `isMemberExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:66` |
| 0.0% | 5.6ms | 0.0% | 5.6ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:207` |
| 0.0% | 5.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-rule-fixer.js:32` |
| 0.0% | 5.6ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7153` |
| 0.0% | 5.6ms | 0.0% | 1.6ms | `isMemberExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:39` |
| 0.0% | 5.3ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1023` |
| 0.0% | 5.3ms | 0.0% | 1.2ms | `_ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:990` |
| 0.0% | 4.9ms | 0.0% | 4.9ms | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:31` |
| 0.0% | 4.9ms | 0.0% | 4.9ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 4.8ms | 0.0% | 4.8ms | `moduleDeclarationInstantiation` | `[native code]` |
| 0.0% | 4.8ms | 0.0% | 0us | `linkAndEvaluateModule` | `[native code]` |
| 0.0% | 4.8ms | 0.0% | 4.8ms | `get key` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3155` |
| 0.0% | 4.7ms | 0.0% | 1.7ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2847` |
| 0.0% | 4.7ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2085` |
| 0.0% | 4.7ms | 0.0% | 4.7ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:855` |
| 0.0% | 4.7ms | 0.0% | 0us | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:839` |
| 0.0% | 4.7ms | 0.0% | 4.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7150` |
| 0.0% | 4.6ms | 0.0% | 4.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7330` |
| 0.0% | 4.6ms | 0.0% | 4.6ms | `isMethodCall` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:30` |
| 0.0% | 4.6ms | 0.0% | 4.6ms | `getNodeByRangeIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3688` |
| 0.0% | 4.6ms | 0.0% | 4.6ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1913` |
| 0.0% | 4.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/browserslist/index.js:1` |
| 0.0% | 4.6ms | 0.0% | 0us | `get properties` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3130` |
| 0.0% | 4.4ms | 0.0% | 4.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2145` |
| 0.0% | 4.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/config/config.js:14` |
| 0.0% | 4.3ms | 0.0% | 2.6ms | `scope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:784` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6598` |
| 0.0% | 4.2ms | 0.0% | 0us | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:828` |
| 0.0% | 4.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:322` |
| 0.0% | 4.2ms | 0.0% | 1.3ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:52` |
| 0.0% | 4.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/regexp-tree.js:8` |
| 0.0% | 4.2ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/node_modules/baseline-browser-mapping/dist/index.cjs:1` |
| 0.0% | 4.2ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7361` |
| 0.0% | 4.0ms | 0.0% | 0us | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2688` |
| 0.0% | 3.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.0% | 3.9ms | 0.0% | 3.9ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `dlopen` | `[native code]` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `decode` | `[native code]` |
| 0.0% | 3.5ms | 0.0% | 0us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2191` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3582` |
| 0.0% | 3.4ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:61` |
| 0.0% | 3.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/rules/utils/lazy-loading-rule-map.js:7` |
| 0.0% | 3.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/config/default-config.js:12` |
| 0.0% | 3.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/debug/src/index.js:9` |
| 0.0% | 3.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/rules/index.js:11` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 3.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/@eslint/plugin-kit/dist/cjs/index.cjs:3` |
| 0.0% | 3.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/source-code.js:21` |
| 0.0% | 3.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/levn/lib/index.js:22` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `slice` | `[native code]` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1223` |
| 0.0% | 3.3ms | 0.0% | 1.7ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1593` |
| 0.0% | 3.3ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7669` |
| 0.0% | 3.3ms | 0.0% | 1.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:615` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` |
| 0.0% | 3.2ms | 0.0% | 1.6ms | `readFileSync` | `[native code]` |
| 0.0% | 3.2ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7460` |
| 0.0% | 3.2ms | 0.0% | 0us | `get params` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2583` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:701` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2176` |
| 0.0% | 3.2ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1515` |
| 0.0% | 3.1ms | 0.0% | 0us | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:25` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `get callee` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1906` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `get` | `[native code]` |
| 0.0% | 3.1ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1020` |
| 0.0% | 3.1ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:911` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `resolve` | `[native code]` |
| 0.0% | 3.1ms | 0.0% | 1.7ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:62` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1356` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3132` |
| 0.0% | 3.0ms | 0.0% | 0us | `getLastTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3403` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:230` |
| 0.0% | 3.0ms | 0.0% | 1.7ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:55` |
| 0.0% | 3.0ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2241` |
| 0.0% | 3.0ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7366` |
| 0.0% | 3.0ms | 0.0% | 1.4ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1735` |
| 0.0% | 3.0ms | 0.0% | 0us | `get defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 0.0% | 3.0ms | 0.0% | 0us | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2866` |
| 0.0% | 3.0ms | 0.0% | 0us | `isParenthesized` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/parentheses.js:74` |
| 0.0% | 3.0ms | 0.0% | 0us | `getForOfLoopHeadText` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:106` |
| 0.0% | 3.0ms | 0.0% | 0us | `isAvailable` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-source-code.js:56` |
| 0.0% | 3.0ms | 0.0% | 0us | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1576` |
| 0.0% | 3.0ms | 0.0% | 0us | `_getFfi` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:72` |
| 0.0% | 3.0ms | 0.0% | 0us | `_tryLoad` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-source-code.js:44` |
| 0.0% | 3.0ms | 0.0% | 0us | `addPolyfillToken` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:53` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:104` |
| 0.0% | 3.0ms | 0.0% | 1.3ms | `getFirstSegment` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:30` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:98` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/ajv.js:3` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/compile/index.js:3` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1167` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/compat-transpiler/index.js:9` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:11` |
| 0.0% | 2.9ms | 0.0% | 0us | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:60` |
| 0.0% | 2.9ms | 0.0% | 1.5ms | `performProxyObjectGet` | `[native code]` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `get computed` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2011` |
| 0.0% | 2.8ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1736` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2126` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `isCallExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:100` |
| 0.0% | 2.8ms | 0.0% | 0us | `getFixFunction` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:93` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `getParentheses` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/parentheses.js:30` |
| 0.0% | 2.8ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3222` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `Set` | `[native code]` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:617` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/@eslint/config-array/dist/cjs/index.cjs:5` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/ajv.js:9` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `get properties` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3123` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2086` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `isMemberExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:16` |
| 0.0% | 1.8ms | 0.0% | 0us | `getFixFunction` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:89` |
| 0.0% | 1.8ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7672` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6441` |
| 0.0% | 1.8ms | 0.0% | 0us | `isNodeMatches` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/is-node-matches.js:57` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:434` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `get params` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2597` |
| 0.0% | 1.8ms | 0.0% | 0us | `getTagNames` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:191` |
| 0.0% | 1.8ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:267` |
| 0.0% | 1.8ms | 0.0% | 0us | `loadBinding` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:614` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2087` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1591` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/@babel/helper-validator-identifier/lib/index.js:54` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:61` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2329` |
| 0.0% | 1.7ms | 0.0% | 0us | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1594` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7305` |
| 0.0% | 1.7ms | 0.0% | 0us | `dlopen` | `bun:ffi:345` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/token-store/index.js:12` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/source-code.js:11` |
| 0.0% | 1.7ms | 0.0% | 0us | `getLastToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1518` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3626` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:249` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `stringSplitFast` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/levn/lib/parse-string.js:113` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/levn/lib/parse-string.js:4` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/levn/lib/index.js:4` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2892` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/semver/index.js:4` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2724` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/eslint/eslint.js:16` |
| 0.0% | 1.7ms | 0.0% | 0us | `get key` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3165` |
| 0.0% | 1.7ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7318` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get left` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1789` |
| 0.0% | 1.7ms | 0.0% | 0us | `getInnermostScope` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:13` |
| 0.0% | 1.7ms | 0.0% | 0us | `test` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2776` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getNodeByRangeIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3687` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `/^\s*exported\b/` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1486` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/node_modules/minimatch/dist/commonjs/index.js:4` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:18` |
| 0.0% | 1.7ms | 0.0% | 0us | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:295` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2079` |
| 0.0% | 1.7ms | 0.0% | 0us | `regExpSplitFast` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `/[./-]/u` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/debug/src/node.js:240` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/locate-path/index.js:5` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/config/config-loader.js:14` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/find-up/index.js:3` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:24` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/p-locate/index.js:2` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getParenthesizedRange` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/parentheses.js:45` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1376` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/interpreter/finite-automaton/nfa/nfa-from-regexp.js:12` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/levn/lib/cast.js:327` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/regexp-tree.js:14` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/interpreter/finite-automaton/index.js:11` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/levn/lib/index.js:5` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/levn/lib/cast.js:4` |
| 0.0% | 1.6ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2921` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2916` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/traverse/index.js:8` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/transform/index.js:14` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getForOfLoopHeadText` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:116` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:620` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7354` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4116` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_isStatementTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:72` |
| 0.0% | 1.6ms | 0.0% | 0us | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3610` |
| 0.0% | 1.6ms | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3996` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `filter` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/@eslint/config-array/dist/cjs/index.cjs:3` |
| 0.0% | 1.6ms | 0.0% | 0us | `node:stream` | `node:stream:2` |
| 0.0% | 1.6ms | 0.0% | 0us | `internal:fs/streams` | `internal:fs/streams:2` |
| 0.0% | 1.6ms | 0.0% | 0us | `internal:stream` | `internal:stream:2` |
| 0.0% | 1.6ms | 0.0% | 0us | `internal:streams/duplex` | `internal:streams/duplex:2` |
| 0.0% | 1.6ms | 0.0% | 0us | `internal:streams/operators` | `internal:streams/operators:2` |
| 0.0% | 1.6ms | 0.0% | 0us | `internal:streams/compose` | `internal:streams/compose:2` |
| 0.0% | 1.6ms | 0.0% | 0us | `get ReadStream` | `node:fs:573` |
| 0.0% | 1.6ms | 0.0% | 0us | `internal:streams/pipeline` | `internal:streams/pipeline:2` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get start` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `isFunctionParametersSafeToFix` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:296` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/ajv.js:28` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:415` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2871` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/espree/dist/espree.cjs:4` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isFixable` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:341` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/languages/js/index.js:15` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/languages/js/index.js:16` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-scope/dist/eslint-scope.cjs:3` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:28` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2187` |
| 0.0% | 1.6ms | 0.0% | 0us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6435` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7166` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4003` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getParentSyntaxOpeningParenthesis` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/get-parent-syntax-opening-parenthesis.js:21` |
| 0.0% | 1.6ms | 0.0% | 0us | `wrap` | `bun:ffi:296` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `ez_ffi_token_idx_at_or_before` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1257` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_findLine` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `isFunctionParameterVariableReassigned` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:319` |
| 0.0% | 1.6ms | 0.0% | 0us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3178` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:521` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3632` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:518` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2794` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/compile/resolve.js:7` |
| 0.0% | 1.6ms | 0.0% | 0us | `isReturnStatementInContinueAbleNodes` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:52` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:477` |
| 0.0% | 1.6ms | 0.0% | 0us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4119` |
| 0.0% | 1.6ms | 0.0% | 0us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1098` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_getSharedCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:746` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:619` |
| 0.0% | 1.5ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1516` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3646` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getParentSyntaxOpeningParenthesis` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/get-parent-syntax-opening-parenthesis.js:24` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/shared/ajv.js:29` |
| 0.0% | 1.5ms | 0.0% | 0us | `getFullPath` | `/Users/ericsan/node_modules/ajv/lib/compile/resolve.js:209` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/config/config.js:16` |
| 0.0% | 1.5ms | 0.0% | 0us | `resolveIds` | `/Users/ericsan/node_modules/ajv/lib/compile/resolve.js:235` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/regexp-tree.js:10` |
| 0.0% | 1.5ms | 0.0% | 0us | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:69` |
| 0.0% | 1.5ms | 0.0% | 0us | `_addSchema` | `/Users/ericsan/node_modules/ajv/lib/ajv.js:309` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/optimizer/transforms/index.js:40` |
| 0.0% | 1.5ms | 0.0% | 0us | `addMetaSchema` | `/Users/ericsan/node_modules/ajv/lib/ajv.js:152` |
| 0.0% | 1.5ms | 0.0% | 0us | `addSchema` | `/Users/ericsan/node_modules/ajv/lib/ajv.js:137` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_normalizeComponentEncoding` | `/Users/ericsan/node_modules/uri-js/dist/es5/uri.all.js` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/optimizer/index.js:11` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get elements` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3039` |
| 0.0% | 1.5ms | 0.0% | 0us | `parse` | `/Users/ericsan/node_modules/uri-js/dist/es5/uri.all.js:936` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:784` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getFixFunction` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:86` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_getTokensAndCommentsMerged` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1931` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:254` |
| 0.0% | 1.5ms | 0.0% | 0us | `getParenthesizedRange` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/parentheses.js:46` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/linter/esquery.js:12` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/linter/source-code-traverser.js:12` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/linter/linter.js:48` |
| 0.0% | 1.5ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7369` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3271` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `findVariable` | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:57` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `extraArrowData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2876` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3586` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3131` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/esutils/lib/utils.js:31` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/esutils/lib/utils.js:30` |
| 0.0% | 1.5ms | 0.0% | 0us | `(module)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/expiring-todo-comments.js:11` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/rules/utils/ast-utils.js:13` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/rules/no-warning-comments.js:9` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7249` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2211` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/source-code.js:16` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/browserslist/index.js:3` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/caniuse-lite/dist/unpacker/agents.js:5` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `isFunctionSelfUsedInside` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/is-function-self-used-inside.js:17` |
| 0.0% | 1.5ms | 0.0% | 0us | `isFixable` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:376` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4115` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isArrowFunctionBody` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-arrow-function-body.js:2` |
| 0.0% | 1.4ms | 0.0% | 0us | `isFixable` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:335` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/semver/index.js:18` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `entries` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `assertToken` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/assert-token.js:13` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/assert-token.js:14` |
| 0.0% | 1.4ms | 0.0% | 0us | `replaceReturnStatement` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:133` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/node_modules/glob-parent/index.js:5` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:19` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get typeAnnotation` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/browserslist/index.js:4` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `create` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:66` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2238` |
| 0.0% | 1.4ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2242` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get properties` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isNotReference` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:83` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4775` |
| 0.0% | 1.4ms | 0.0% | 0us | `camelCase` | `/Users/ericsan/node_modules/change-case/dist/index.js:68` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `toLocaleLowerCase` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:70` |
| 0.0% | 1.4ms | 0.0% | 0us | `getTokenAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1731` |
| 0.0% | 1.4ms | 0.0% | 0us | `forEach` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` |
| 0.0% | 1.4ms | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:545` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `has` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/linter/linter.js:45` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `toEslintRuleFixer` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-rule-fixer.js:29` |
| 0.0% | 1.3ms | 0.0% | 0us | `toEslintProblem` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-problem.js:21` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-listener.js:33` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `get params` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2587` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getTokens` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1374` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4392` |
| 0.0% | 1.3ms | 0.0% | 0us | `getParentSyntaxOpeningParenthesis` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/get-parent-syntax-opening-parenthesis.js:26` |
| 0.0% | 1.3ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4162` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3967` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2276` |
| 0.0% | 1.3ms | 0.0% | 0us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `encodeInto` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1708` |
| 0.0% | 1.3ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:220` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-context.js:25` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/dotjs/index.js:15` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/ajv/lib/compile/rules.js:3` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1162` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:22` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get key` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3156` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/semver/index.js:36` |
| 0.0% | 1.3ms | 0.0% | 0us | `isFixable` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:332` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `stripChainExpression` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:47` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get arguments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1920` |
| 0.0% | 1.3ms | 0.0% | 0us | `getFixFunction` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:87` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getForOfLoopHeadText` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:96` |
| 0.0% | 1.3ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7657` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `fill` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6600` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/core-js-compat/compat.js:3` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:87` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getParentSyntaxOpeningParenthesis` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/get-parent-syntax-opening-parenthesis.js:25` |
| 0.0% | 1.3ms | 0.0% | 0us | `Readable` | `internal:streams/readable:160` |
| 0.0% | 1.3ms | 0.0% | 0us | `ReadStream` | `internal:fs/streams:86` |
| 0.0% | 1.3ms | 0.0% | 0us | `Stream` | `internal:streams/legacy:4` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `EventEmitter` | `node:events:11` |
| 0.0% | 1.3ms | 0.0% | 0us | `fixSpaceAroundKeyword` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/fix/fix-space-around-keywords.js:28` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `isReferenceIdentifier` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:153` |
| 0.0% | 1.2ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1511` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4110` |
| 0.0% | 1.2ms | 0.0% | 0us | `replaceReturnStatement` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:152` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/parser/index.js:8` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1862` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/transform/index.js:13` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:594` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/compat-transpiler/transforms/index.js:10` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp-tree/dist/compat-transpiler/index.js:8` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1525` |
| 0.0% | 1.2ms | 0.0% | 0us | `getText` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1292` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getTokenAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1713` |
| 0.0% | 1.2ms | 0.0% | 0us | `fixSpaceAroundKeyword` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/fix/fix-space-around-keywords.js:34` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/browserslist/index.js:1316` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/browserslist/index.js:1334` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `fillUsage` | `/Users/ericsan/node_modules/browserslist/index.js:79` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getFixFunction` | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `dlopen` | `bun:ffi:351` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `Function` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 0us | `FFIBuilder` | `bun:ffi:283` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2204` |
| 0.0% | 1.2ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1417` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/@eslint/config-array/node_modules/minimatch/dist/commonjs/index.js:7` |
| 0.0% | 1.2ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.0% | 1.2ms | 0.0% | 0us | `node:fs/promises` | `node:fs/promises:2` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `@lazy` | `[native code]` |
| 0.0% | 917us | 0.0% | 917us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2946` |

## Function Details

### `isFunctionParametersSafeToFix`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:298` | Self: 35.3% (7.46s) | Total: 54.0% (11.39s) | Samples: 4886

**Called by:**
- `isFixable` (7458)

**Calls:**
- `get name` (2060)
- `get name` (318)
- `get name` (132)
- `get name` (41)
- `get name` (13)
- `get name` (6)
- `get name` (2)

### `isFunctionParametersSafeToFix`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:301` | Self: 26.1% (5.51s) | Total: 26.1% (5.51s) | Samples: 3592

**Called by:**
- `isFixable` (3592)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 14.9% (3.14s) | Total: 14.9% (3.14s) | Samples: 2060

**Called by:**
- `isFunctionParametersSafeToFix` (2060)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:905` | Self: 3.0% (637.8ms) | Total: 3.1% (668.7ms) | Samples: 420

**Called by:**
- `get properties` (426)
- `get body` (10)
- `get params` (3)
- `get value` (1)

**Calls:**
- `nodeView` (16)
- `_nodeViewRaw` (2)
- `nodeView` (2)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1347` | Self: 2.3% (487.1ms) | Total: 2.3% (487.1ms) | Samples: 321

**Called by:**
- `isFunctionParametersSafeToFix` (318)
- `isMemberExpression` (3)

### `getRange`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3725` | Self: 1.3% (281.8ms) | Total: 1.3% (281.8ms) | Samples: 187

**Called by:**
- `isFunctionParametersSafeToFix` (186)
- `fixSpaceAroundKeyword` (1)

### `parse`
`[native code]` | Self: 1.0% (220.3ms) | Total: 1.0% (220.3ms) | Samples: 142

**Called by:**
- `parseSource` (142)

### `isFunctionParametersSafeToFix`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:299` | Self: 1.0% (219.7ms) | Total: 2.8% (590.7ms) | Samples: 145

**Called by:**
- `isFixable` (391)

**Calls:**
- `getRange` (186)
- `getRange` (46)
- `getRange` (14)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1354` | Self: 0.9% (205.3ms) | Total: 0.9% (205.3ms) | Samples: 132

**Called by:**
- `isFunctionParametersSafeToFix` (132)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1267` | Self: 0.9% (192.1ms) | Total: 0.9% (192.1ms) | Samples: 128

**Called by:**
- `_getAllTokens` (128)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1264` | Self: 0.8% (174.3ms) | Total: 0.9% (192.0ms) | Samples: 115

**Called by:**
- `_getAllTokens` (124)
- `getTokenBefore` (3)

**Calls:**
- `_getJsxTextTokFlags` (7)
- `_getJsxTextTokFlags` (2)
- `_getJsxTextTokFlags` (2)
- `_getJsxTextTokFlags` (1)

### `isFunctionParametersSafeToFix`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:297` | Self: 0.7% (161.9ms) | Total: 0.7% (161.9ms) | Samples: 107

**Called by:**
- `isFixable` (107)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1239` | Self: 0.6% (131.0ms) | Total: 0.6% (131.0ms) | Samples: 86

**Called by:**
- `_getAllTokens` (86)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7194` | Self: 0.6% (130.3ms) | Total: 8.6% (1.83s) | Samples: 85

**Called by:**
- `runPlugins` (1204)

**Calls:**
- `_invokeFused` (1077)
- `_nodeViewRaw` (25)
- `_nodeViewRaw` (8)
- `nodeView` (4)
- `_invokeFused` (3)
- `_invokeFused` (1)
- `_nodeViewRaw` (1)

### `isFunctionParametersSafeToFix`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:309` | Self: 0.6% (127.8ms) | Total: 0.6% (133.5ms) | Samples: 84

**Called by:**
- `isFixable` (88)

**Calls:**
- `scope` (3)
- `findVariable` (1)

### `generatorResume`
`[native code]` | Self: 0.5% (111.8ms) | Total: 100.0% (58.93s) | Samples: 72

**Called by:**
- `next` (22529)
- `(anonymous)` (11542)
- `iterateFixOrProblems` (1990)
- `iterateFixOrProblems` (1975)
- `performIteration` (504)
- `getParentheses` (14)
- `isParenthesized` (2)

**Calls:**
- `iterateFixOrProblems` (13084)
- `iterateFixOrProblems` (12252)
- `(anonymous)` (11692)
- `(anonymous)` (827)
- `fixSpaceAroundKeyword` (460)
- `iterateFixOrProblems` (86)
- `(anonymous)` (19)
- `iterateSurroundingParentheses` (14)
- `(anonymous)` (12)
- `removeParentheses` (10)
- `(anonymous)` (6)
- `removeCallbackParentheses` (5)
- `iterateSurroundingParentheses` (5)
- `replaceReturnStatement` (4)
- `(anonymous)` (2)
- `fixSpaceAroundKeyword` (1)
- `(anonymous)` (1)
- `fixSpaceAroundKeyword` (1)
- `(anonymous)` (1)
- `replaceReturnStatement` (1)
- `replaceReturnStatement` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:53` | Self: 0.4% (100.4ms) | Total: 0.4% (100.4ms) | Samples: 66

**Called by:**
- `(anonymous)` (66)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:55` | Self: 0.4% (89.0ms) | Total: 5.9% (1.25s) | Samples: 60

**Called by:**
- `generatorResume` (827)

**Calls:**
- `(anonymous)` (578)
- `(anonymous)` (118)
- `(anonymous)` (57)
- `(anonymous)` (11)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `anonymous`
`[native code]` | Self: 0.3% (76.9ms) | Total: 2.0% (422.6ms) | Samples: 50

**Called by:**
- `require` (264)
- `bound require` (3)
- `node:stream` (1)
- `wrap` (1)
- `node:fs` (1)
- `internal:streams/duplex` (1)
- `internal:stream` (1)
- `internal:streams/operators` (1)
- `internal:streams/compose` (1)
- `get ReadStream` (1)
- `internal:streams/pipeline` (1)
- `internal:fs/streams` (1)

**Calls:**
- `(anonymous)` (17)
- `(anonymous)` (12)
- `(anonymous)` (12)
- `(anonymous)` (10)
- `(anonymous)` (10)
- `(anonymous)` (9)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (6)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
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
- `(anonymous)` (1)
- `(anonymous)` (1)
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
- `ez_ffi_token_idx_at_or_before` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:streams/compose` (1)
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
- `node:fs` (1)
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
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:fs/promises` (1)
- `internal:streams/operators` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `isIterable`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js:1` | Self: 0.3% (76.8ms) | Total: 0.3% (76.8ms) | Samples: 51

**Called by:**
- `iterateFixOrProblems` (51)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1357` | Self: 0.3% (70.7ms) | Total: 0.3% (76.8ms) | Samples: 46

**Called by:**
- `isFunctionParametersSafeToFix` (41)
- `isMemberExpression` (8)
- `isFunctionParametersSafeToFix` (1)

**Calls:**
- `get mainToken` (4)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` | Self: 0.2% (62.6ms) | Total: 0.2% (62.6ms) | Samples: 40

**Called by:**
- `_nodeViewRaw` (40)

### `iterateFixOrProblems`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js:17` | Self: 0.2% (61.8ms) | Total: 0.2% (61.8ms) | Samples: 40

**Called by:**
- `iterateFixOrProblems` (28)
- `(anonymous)` (12)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4058` | Self: 0.2% (60.9ms) | Total: 0.2% (60.9ms) | Samples: 41

**Called by:**
- `_nodeViewRaw` (41)

### `iterateFixOrProblems`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js:18` | Self: 0.2% (56.5ms) | Total: 0.6% (133.3ms) | Samples: 35

**Called by:**
- `generatorResume` (86)

**Calls:**
- `isIterable` (51)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3630` | Self: 0.2% (49.6ms) | Total: 0.2% (60.2ms) | Samples: 32

**Called by:**
- `getRange` (33)
- `getInnermostScope` (2)
- `get value` (2)
- `getTokenBefore` (1)
- `getText` (1)
- `getTokenAfter` (1)

**Calls:**
- `get start` (7)
- `get start` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1235` | Self: 0.2% (45.8ms) | Total: 0.2% (45.8ms) | Samples: 31

**Called by:**
- `_getAllTokens` (30)
- `getTokenBefore` (1)

### `copyDataProperties`
`[native code]` | Self: 0.2% (43.8ms) | Total: 0.2% (43.8ms) | Samples: 30

**Called by:**
- `create` (17)
- `isMethodCall` (10)
- `isMemberExpression` (3)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` | Self: 0.1% (32.8ms) | Total: 0.8% (177.8ms) | Samples: 22

**Called by:**
- `nodeView` (56)
- `nodeViewChain` (31)
- `walkNodes` (25)
- `arguments` (2)
- `get body` (1)
- `isMethodCall` (1)
- `invokeMethodFnHandlers` (1)

**Calls:**
- `_NodeView_LR` (41)
- `_NodeView` (40)
- `_NodeView` (7)
- `_NodeView_LRN` (4)
- `_NodeView_LR` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6878` | Self: 0.1% (26.7ms) | Total: 0.1% (26.7ms) | Samples: 18

**Called by:**
- `runPlugins` (18)

### `_getAllTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1884` | Self: 0.1% (23.7ms) | Total: 0.1% (23.7ms) | Samples: 16

**Called by:**
- `_getTokensAndCommentsMerged` (16)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1244` | Self: 0.1% (23.3ms) | Total: 0.1% (23.3ms) | Samples: 15

**Called by:**
- `isNotReference` (14)
- `isNotReference` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7431` | Self: 0.1% (22.4ms) | Total: 0.1% (22.4ms) | Samples: 15

**Called by:**
- `runPlugins` (15)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:3` | Self: 0.1% (21.5ms) | Total: 0.4% (98.4ms) | Samples: 14

**Called by:**
- `isReferenceIdentifier` (64)

**Calls:**
- `get parent` (31)
- `get parent` (14)
- `get parent` (4)
- `get parent` (1)

### `getRange`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3724` | Self: 0.0% (20.8ms) | Total: 0.0% (20.8ms) | Samples: 14

**Called by:**
- `isFunctionParametersSafeToFix` (14)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7329` | Self: 0.0% (20.6ms) | Total: 0.0% (20.6ms) | Samples: 14

**Called by:**
- `runPlugins` (14)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1271` | Self: 0.0% (20.4ms) | Total: 0.0% (20.4ms) | Samples: 13

**Called by:**
- `_getAllTokens` (12)
- `getTokenBefore` (1)

### `isReferenceIdentifier`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:158` | Self: 0.0% (20.1ms) | Total: 4.0% (859.5ms) | Samples: 13

**Called by:**
- `(anonymous)` (564)

**Calls:**
- `isNotReference` (440)
- `isNotReference` (64)
- `isNotReference` (11)
- `isNotReference` (11)
- `isNotReference` (6)
- `isNotReference` (5)
- `isNotReference` (3)
- `isNotReference` (2)
- `isNotReference` (2)
- `isNotReference` (2)
- `isNotReference` (2)
- `isNotReference` (1)
- `isNotReference` (1)
- `isNotReference` (1)

### `(anonymous)`
`[native code]` | Self: 0.0% (19.4ms) | Total: 100.0% (21.21s) | Samples: 13

**Called by:**
- `processTicksAndRejections` (13715)
- `(anonymous)` (88)
- `require` (75)
- `bound require` (1)
- `parseModule` (1)

**Calls:**
- `_lintSourceOne` (13568)
- `_lintSourceOne` (146)
- `(anonymous)` (88)
- `parseModule` (49)
- `moduleEvaluation` (8)
- `linkAndEvaluateModule` (3)
- `resolve` (2)
- `_lintSourceOne` (1)
- `ReadStream` (1)
- `dlopen` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js:54` | Self: 0.0% (18.8ms) | Total: 0.0% (18.8ms) | Samples: 12

**Called by:**
- `generatorResume` (12)

### `isReferenceIdentifier`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:149` | Self: 0.0% (18.6ms) | Total: 0.0% (18.6ms) | Samples: 13

**Called by:**
- `(anonymous)` (13)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:902` | Self: 0.0% (17.9ms) | Total: 0.0% (17.9ms) | Samples: 11

**Called by:**
- `get properties` (6)
- `get body` (2)
- `get params` (2)
- `get params` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (17.9ms) | Total: 0.0% (17.9ms) | Samples: 12

**Called by:**
- `commentsInRange` (7)
- `commentsInRange` (5)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4095` | Self: 0.0% (15.8ms) | Total: 0.0% (15.8ms) | Samples: 10

**Called by:**
- `walkNodes` (8)
- `_nodesFromRange` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:403` | Self: 0.0% (15.6ms) | Total: 0.0% (15.6ms) | Samples: 11

**Called by:**
- `(anonymous)` (11)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (14.3ms) | Total: 0.0% (14.3ms) | Samples: 9

**Called by:**
- `_getTokensAndCommentsMerged` (9)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6874` | Self: 0.0% (14.2ms) | Total: 0.0% (14.2ms) | Samples: 10

**Called by:**
- `runPlugins` (10)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:810` | Self: 0.0% (14.1ms) | Total: 0.0% (14.1ms) | Samples: 9

**Called by:**
- `get name` (9)

### `_getAllTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1883` | Self: 0.0% (13.9ms) | Total: 2.8% (598.4ms) | Samples: 9

**Called by:**
- `_getTokensAndCommentsMerged` (396)

**Calls:**
- `_makeToken` (128)
- `_makeToken` (124)
- `_makeToken` (86)
- `_makeToken` (30)
- `_makeToken` (12)
- `_makeToken` (6)
- `_makeToken` (1)

### `getRange`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3726` | Self: 0.0% (13.4ms) | Total: 0.3% (71.2ms) | Samples: 9

**Called by:**
- `isFunctionParametersSafeToFix` (46)
- `isFunctionParametersSafeToFix` (1)

**Calls:**
- `get range` (33)
- `get range` (3)
- `get range` (1)
- `get range` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:656` | Self: 0.0% (12.4ms) | Total: 0.0% (12.4ms) | Samples: 8

**Called by:**
- `commentsInRange` (6)
- `commentsInRange` (2)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1191` | Self: 0.0% (12.2ms) | Total: 0.0% (12.2ms) | Samples: 8

**Called by:**
- `isNotReference` (4)
- `_computeIsStrict` (2)
- `_buildReference` (1)
- `_computeIsStrict` (1)

### `some`
`[native code]` | Self: 0.0% (10.9ms) | Total: 0.1% (32.7ms) | Samples: 7

**Called by:**
- `isFixable` (10)
- `isFixable` (6)
- `getForOfLoopHeadText` (3)
- `isNodeMatches` (1)
- `assertToken` (1)

**Calls:**
- `(anonymous)` (9)
- `(anonymous)` (3)
- `isReturnStatementInContinueAbleNodes` (1)
- `(anonymous)` (1)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (10.9ms) | Total: 0.0% (10.9ms) | Samples: 7

**Called by:**
- `_nodeViewRaw` (7)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4132` | Self: 0.0% (10.5ms) | Total: 0.0% (10.5ms) | Samples: 7

**Called by:**
- `walkNodes` (4)
- `_nodesFromRange` (2)
- `_computeVarDefs` (1)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1926` | Self: 0.0% (10.0ms) | Total: 0.1% (39.1ms) | Samples: 7

**Called by:**
- `getTokenBefore` (26)

**Calls:**
- `_makeToken` (9)
- `_makeToken` (6)
- `_makeToken` (4)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1177` | Self: 0.0% (9.8ms) | Total: 0.0% (9.8ms) | Samples: 7

**Called by:**
- `_makeToken` (7)

### `get typeAnnotation`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2720` | Self: 0.0% (9.6ms) | Total: 0.0% (9.6ms) | Samples: 6

**Called by:**
- `(anonymous)` (6)

### `isMethodCall`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:53` | Self: 0.0% (9.2ms) | Total: 0.1% (41.6ms) | Samples: 6

**Called by:**
- `(anonymous)` (27)

**Calls:**
- `nodeViewChain` (20)
- `_nodeViewRaw` (1)

### `get start`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1108` | Self: 0.0% (8.8ms) | Total: 0.0% (8.8ms) | Samples: 7

**Called by:**
- `get range` (7)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1203` | Self: 0.0% (8.8ms) | Total: 0.0% (8.8ms) | Samples: 6

**Called by:**
- `_getTokensAndCommentsMerged` (6)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1369` | Self: 0.0% (8.7ms) | Total: 0.0% (8.7ms) | Samples: 6

**Called by:**
- `isFunctionParametersSafeToFix` (6)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1273` | Self: 0.0% (8.5ms) | Total: 0.0% (8.5ms) | Samples: 6

**Called by:**
- `_getAllTokens` (6)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:5` | Self: 0.0% (8.5ms) | Total: 0.0% (8.5ms) | Samples: 6

**Called by:**
- `isReferenceIdentifier` (6)

### `create`
`[native code]` | Self: 0.0% (8.4ms) | Total: 0.0% (8.4ms) | Samples: 6

**Called by:**
- `walkNodes` (3)
- `walkNodes` (3)

### `defineProperty`
`[native code]` | Self: 0.0% (7.9ms) | Total: 0.0% (7.9ms) | Samples: 5

**Called by:**
- `walkNodes` (3)
- `walkNodes` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7154` | Self: 0.0% (7.9ms) | Total: 0.0% (7.9ms) | Samples: 5

**Called by:**
- `runPlugins` (5)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3583` | Self: 0.0% (7.7ms) | Total: 0.0% (7.7ms) | Samples: 5

**Called by:**
- `getRange` (3)
- `getInnermostScope` (2)

### `_resolveUnicodeEscapes`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:236` | Self: 0.0% (7.5ms) | Total: 0.0% (7.5ms) | Samples: 5

**Called by:**
- `get name` (5)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7156` | Self: 0.0% (7.3ms) | Total: 0.0% (7.3ms) | Samples: 5

**Called by:**
- `runPlugins` (5)

### `get mainToken`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1105` | Self: 0.0% (7.3ms) | Total: 0.0% (7.3ms) | Samples: 5

**Called by:**
- `get name` (4)
- `get value` (1)

### `iterateFixOrProblems`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js:23` | Self: 0.0% (6.8ms) | Total: 94.7% (19.99s) | Samples: 4

**Called by:**
- `generatorResume` (13084)

**Calls:**
- `next` (11105)
- `generatorResume` (1975)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2161` | Self: 0.0% (6.8ms) | Total: 0.2% (46.2ms) | Samples: 5

**Called by:**
- `(anonymous)` (30)
- `_buildScopeChildren` (1)

**Calls:**
- `_computeIsStrict` (21)
- `_computeIsStrict` (2)
- `_computeIsStrict` (1)
- `_computeIsStrict` (1)
- `_computeIsStrict` (1)

### `arguments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1931` | Self: 0.0% (6.4ms) | Total: 0.1% (31.5ms) | Samples: 4

**Called by:**
- `create` (20)

**Calls:**
- `nodeViewChain` (13)
- `_nodeViewRaw` (2)
- `nodeViewChain` (1)

### `_NodeView_LRN`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4051` | Self: 0.0% (6.4ms) | Total: 0.0% (6.4ms) | Samples: 4

**Called by:**
- `_nodeViewRaw` (4)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4111` | Self: 0.0% (6.3ms) | Total: 0.0% (6.3ms) | Samples: 4

**Called by:**
- `nodeView` (2)
- `nodeViewChain` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6860` | Self: 0.0% (6.1ms) | Total: 0.0% (6.1ms) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1624` | Self: 0.0% (6.0ms) | Total: 3.3% (696.2ms) | Samples: 4

**Called by:**
- `fixSpaceAroundKeyword` (460)

**Calls:**
- `_getTokensAndCommentsMerged` (412)
- `_getTokensAndCommentsMerged` (26)
- `_getTokensAndCommentsMerged` (14)
- `_getTokensAndCommentsMerged` (3)
- `_getTokensAndCommentsMerged` (1)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:16` | Self: 0.0% (6.0ms) | Total: 0.0% (17.2ms) | Samples: 4

**Called by:**
- `isReferenceIdentifier` (11)

**Calls:**
- `get params` (5)
- `get params` (2)

### `create`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:16` | Self: 0.0% (6.0ms) | Total: 0.0% (6.0ms) | Samples: 4

**Called by:**
- `isMethodCall` (4)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1205` | Self: 0.0% (5.9ms) | Total: 0.0% (5.9ms) | Samples: 4

**Called by:**
- `_getTokensAndCommentsMerged` (4)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4393` | Self: 0.0% (5.8ms) | Total: 0.0% (5.8ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:207` | Self: 0.0% (5.6ms) | Total: 0.0% (5.6ms) | Samples: 4

**Called by:**
- `(anonymous)` (4)

### `create`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:40` | Self: 0.0% (4.9ms) | Total: 0.1% (30.4ms) | Samples: 3

**Called by:**
- `isMethodCall` (20)

**Calls:**
- `copyDataProperties` (17)

### `isMethodCall`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:31` | Self: 0.0% (4.9ms) | Total: 0.0% (4.9ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (4.9ms) | Total: 0.0% (4.9ms) | Samples: 3

**Called by:**
- `walkNodes` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7364` | Self: 0.0% (4.8ms) | Total: 0.0% (9.7ms) | Samples: 3

**Called by:**
- `runPlugins` (6)

**Calls:**
- `defineProperty` (3)

### `moduleDeclarationInstantiation`
`[native code]` | Self: 0.0% (4.8ms) | Total: 0.0% (4.8ms) | Samples: 3

**Called by:**
- `link` (3)

### `get key`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3155` | Self: 0.0% (4.8ms) | Total: 0.0% (4.8ms) | Samples: 3

**Called by:**
- `isNotReference` (3)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:855` | Self: 0.0% (4.7ms) | Total: 0.0% (4.7ms) | Samples: 3

**Called by:**
- `_symName` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7150` | Self: 0.0% (4.7ms) | Total: 0.0% (4.7ms) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7330` | Self: 0.0% (4.6ms) | Total: 0.0% (4.6ms) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `isMethodCall`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:30` | Self: 0.0% (4.6ms) | Total: 0.0% (4.6ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `getNodeByRangeIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3688` | Self: 0.0% (4.6ms) | Total: 0.0% (4.6ms) | Samples: 3

**Called by:**
- `needsSemicolon` (3)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1913` | Self: 0.0% (4.6ms) | Total: 0.0% (4.6ms) | Samples: 3

**Called by:**
- `getTokenBefore` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7362` | Self: 0.0% (4.6ms) | Total: 0.0% (8.8ms) | Samples: 3

**Called by:**
- `runPlugins` (6)

**Calls:**
- `create` (3)

### `parseModule`
`[native code]` | Self: 0.0% (4.5ms) | Total: 0.4% (91.4ms) | Samples: 3

**Called by:**
- `(anonymous)` (49)
- `async (anonymous)` (11)

**Calls:**
- `(anonymous)` (27)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (5)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `get ReadStream` (1)
- `(anonymous)` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2145` | Self: 0.0% (4.4ms) | Total: 0.0% (4.4ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6598` | Self: 0.0% (4.3ms) | Total: 0.0% (4.3ms) | Samples: 3

**Called by:**
- `walkNodes` (3)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4788` | Self: 0.0% (4.1ms) | Total: 96.4% (20.35s) | Samples: 3

**Called by:**
- `walkNodes` (12228)
- `walkNodes` (1077)
- `walkNodes` (13)
- `walkNodes` (1)

**Calls:**
- `(anonymous)` (12736)
- `(anonymous)` (515)
- `(anonymous)` (64)
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7393` | Self: 0.0% (4.0ms) | Total: 88.6% (18.69s) | Samples: 3

**Called by:**
- `runPlugins` (12231)

**Calls:**
- `_invokeFused` (12228)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:431` | Self: 0.0% (3.9ms) | Total: 0.8% (181.0ms) | Samples: 3

**Called by:**
- `(anonymous)` (118)

**Calls:**
- `isMethodCall` (48)
- `isMethodCall` (27)
- `isMemberExpression` (13)
- `isMethodCall` (12)
- `isMemberExpression` (4)
- `isMemberExpression` (4)
- `isMethodCall` (3)
- `isMethodCall` (3)
- `isMemberExpression` (1)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (3.9ms) | Total: 0.0% (3.9ms) | Samples: 3

**Called by:**
- `_nodeViewRaw` (3)

### `dlopen`
`[native code]` | Self: 0.0% (3.5ms) | Total: 0.0% (3.5ms) | Samples: 2

**Called by:**
- `dlopen` (1)
- `(anonymous)` (1)

### `decode`
`[native code]` | Self: 0.0% (3.5ms) | Total: 0.0% (3.5ms) | Samples: 2

**Called by:**
- `get source` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2191` | Self: 0.0% (3.5ms) | Total: 0.0% (3.5ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3582` | Self: 0.0% (3.5ms) | Total: 0.0% (3.5ms) | Samples: 2

**Called by:**
- `getInnermostScope` (1)
- `getInnermostScope` (1)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (3.4ms) | Total: 0.0% (3.4ms) | Samples: 2

**Called by:**
- `_makeToken` (2)

### `slice`
`[native code]` | Self: 0.0% (3.4ms) | Total: 0.0% (3.4ms) | Samples: 2

**Called by:**
- `getFixFunction` (1)
- `commentsInRange` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1223` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `isReturnStatementInContinueAbleNodes` (1)
- `isNotReference` (1)

### `getSurroundingParentheses`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/iterate-surrounding-parentheses.js:30` | Self: 0.0% (3.3ms) | Total: 0.1% (21.9ms) | Samples: 2

**Called by:**
- `iterateSurroundingParentheses` (14)

**Calls:**
- `getTokenBefore` (5)
- `getTokenBefore` (2)
- `getTokenBefore` (2)
- `getTokenBefore` (1)
- `performProxyObjectGet` (1)
- `getTokenBefore` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1733` | Self: 0.0% (3.3ms) | Total: 0.0% (6.3ms) | Samples: 2

**Called by:**
- `_computeIsStrict` (4)

**Calls:**
- `nodeView` (2)

### `extraFnData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:701` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `get params` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2176` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `_buildScope` (2)

### `get callee`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1906` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `getParentSyntaxOpeningParenthesis` (1)
- `getFixFunction` (1)

### `get`
`[native code]` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `walkNodes` (1)
- `getDeclaredVariables` (1)

### `resolve`
`[native code]` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1356` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `isFunctionParametersSafeToFix` (2)

### `isMemberExpression`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:66` | Self: 0.0% (3.0ms) | Total: 0.0% (5.8ms) | Samples: 2

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `get property` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3132` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `map` (2)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1167` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `_makeToken` (2)

### `findVariable`
`/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:58` | Self: 0.0% (2.9ms) | Total: 0.0% (6.1ms) | Samples: 2

**Called by:**
- `isFunctionParametersSafeToFix` (3)
- `isFunctionParametersSafeToFix` (1)

**Calls:**
- `get` (2)

### `get computed`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2011` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `isNotReference` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2126` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `_buildScope` (1)
- `_buildScopeChildren` (1)

### `isCallExpression`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:100` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `isMethodCall` (2)

### `getForOfLoopHeadRange`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:127` | Self: 0.0% (2.8ms) | Total: 0.0% (16.2ms) | Samples: 2

**Called by:**
- `(anonymous)` (10)

**Calls:**
- `getParenthesizedRange` (4)
- `getParenthesizedRange` (1)
- `get body` (1)
- `get body` (1)
- `getParenthesizedRange` (1)

### `getParentheses`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/parentheses.js:30` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 1

**Called by:**
- `getParenthesizedRange` (1)

### `Set`
`[native code]` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `_computeDeclaredVariables` (2)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:617` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `getAllComments` (1)
- `_precomputeScopes` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `get properties` (2)

### `scope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:784` | Self: 0.0% (2.6ms) | Total: 0.0% (4.3ms) | Samples: 2

**Called by:**
- `isFunctionParametersSafeToFix` (3)

**Calls:**
- `_computeVarScope` (1)

### `isMethodCall`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:42` | Self: 0.0% (2.5ms) | Total: 0.0% (17.0ms) | Samples: 2

**Called by:**
- `(anonymous)` (12)

**Calls:**
- `copyDataProperties` (10)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:8` | Self: 0.0% (2.4ms) | Total: 0.0% (15.8ms) | Samples: 2

**Called by:**
- `isReferenceIdentifier` (11)

**Calls:**
- `get property` (9)

### `get properties`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3123` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `isNotReference` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2086` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `_computeDeclaredVariables` (1)

### `isMemberExpression`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:16` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6441` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `get params`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2597` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `isNotReference` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:613` | Self: 0.0% (1.7ms) | Total: 0.0% (14.9ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (8)
- `getAllComments` (2)

**Calls:**
- `_findLineIdx` (7)
- `_findLineIdx` (2)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:55` | Self: 0.0% (1.7ms) | Total: 0.0% (3.0ms) | Samples: 1

**Called by:**
- `isReferenceIdentifier` (2)

**Calls:**
- `get parent` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2847` | Self: 0.0% (1.7ms) | Total: 0.0% (4.7ms) | Samples: 1

**Called by:**
- `defs` (3)

**Calls:**
- `nodeView` (1)
- `nodeView` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:614` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getAllComments` (1)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:62` | Self: 0.0% (1.7ms) | Total: 0.0% (3.1ms) | Samples: 1

**Called by:**
- `isReferenceIdentifier` (2)

**Calls:**
- `map` (1)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1591` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getSurroundingParentheses` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2087` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_computeDeclaredVariables` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2329` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:61` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `isReferenceIdentifier` (1)

### `isFixable`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:360` | Self: 0.0% (1.7ms) | Total: 84.6% (17.84s) | Samples: 1

**Called by:**
- `(anonymous)` (11672)

**Calls:**
- `isFunctionParametersSafeToFix` (7458)
- `isFunctionParametersSafeToFix` (3592)
- `isFunctionParametersSafeToFix` (391)
- `isFunctionParametersSafeToFix` (107)
- `isFunctionParametersSafeToFix` (88)
- `isFunctionParametersSafeToFix` (16)
- `isFunctionParametersSafeToFix` (10)
- `isFunctionParametersSafeToFix` (7)
- `isFunctionParametersSafeToFix` (1)
- `isFunctionParametersSafeToFix` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7305` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3626` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getLastToken` (1)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1593` | Self: 0.0% (1.7ms) | Total: 0.0% (3.3ms) | Samples: 1

**Called by:**
- `getSurroundingParentheses` (2)

**Calls:**
- `wrap` (1)

### `stringSplitFast`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:56` | Self: 0.0% (1.7ms) | Total: 3.1% (669.9ms) | Samples: 1

**Called by:**
- `isReferenceIdentifier` (440)

**Calls:**
- `get properties` (434)
- `get properties` (3)
- `get properties` (1)
- `get properties` (1)

### `_computeVarScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2892` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `scope` (1)

### `get typeAnnotation`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2724` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get left`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1789` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `get key` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:61` | Self: 0.0% (1.7ms) | Total: 0.0% (3.4ms) | Samples: 1

**Called by:**
- `map` (2)

**Calls:**
- `stringSplitFast` (1)

### `getNodeByRangeIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3687` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `needsSemicolon` (1)

### `/^\s*exported\b/`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `test` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1486` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `isNotReference` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2079` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_computeDeclaredVariables` (1)

### `/[./-]/u`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `regExpSplitFast` (1)

### `getParenthesizedRange`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/parentheses.js:45` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `getForOfLoopHeadRange` (1)

### `getTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1376` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `getLastTokens` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2916` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `get references` (1)

### `getForOfLoopHeadText`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:116` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `isMemberExpression`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:39` | Self: 0.0% (1.6ms) | Total: 0.0% (5.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `copyDataProperties` (3)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:620` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `isMethodCall`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js:46` | Self: 0.0% (1.6ms) | Total: 0.3% (74.0ms) | Samples: 1

**Called by:**
- `(anonymous)` (48)

**Calls:**
- `create` (20)
- `create` (20)
- `create` (4)
- `isCallExpression` (2)
- `create` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7354` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4116` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `nodeView` (1)

### `_isStatementTag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:72` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `get range` (1)

### `filter`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_execReport` (1)

### `get start`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `get range` (1)

### `getInnermostScope`
`/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:19` | Self: 0.0% (1.6ms) | Total: 0.0% (6.9ms) | Samples: 1

**Called by:**
- `findVariable` (5)

**Calls:**
- `get` (4)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:415` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2871` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `defs` (1)

### `isFixable`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:341` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2187` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7166` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `readFileSync`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (3.2ms) | Samples: 1

**Called by:**
- `readFileSync` (1)
- `(anonymous)` (1)

**Calls:**
- `readFileSync` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4003` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `report` (1)

### `getParentSyntaxOpeningParenthesis`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/get-parent-syntax-opening-parenthesis.js:21` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `iterateSurroundingParentheses` (1)

### `ez_ffi_token_idx_at_or_before`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `_findLine`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_makeToken` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3632` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `getRange` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:521` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `get typeAnnotation`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2794` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:518` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_computeVarDefs` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:477` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `parseSource` (1)

### `_getSharedCaches`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:746` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `reset` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:619` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3646` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `get value` (1)

### `getParentSyntaxOpeningParenthesis`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/get-parent-syntax-opening-parenthesis.js:24` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `iterateSurroundingParentheses` (1)

### `_normalizeComponentEncoding`
`/Users/ericsan/node_modules/uri-js/dist/es5/uri.all.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `parse` (1)

### `get elements`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3039` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `isNotReference` (1)

### `getFixFunction`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:86` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:784` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `get name` (1)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1931` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `getTokenBefore` (1)

### `getParenthesizedRange`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/parentheses.js:44` | Self: 0.0% (1.5ms) | Total: 0.0% (7.4ms) | Samples: 1

**Called by:**
- `getForOfLoopHeadRange` (4)

**Calls:**
- `getParentheses` (2)
- `getParentheses` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:254` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `generatorResume` (1)

### `performProxyObjectGet`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (2.9ms) | Samples: 1

**Called by:**
- `getParenthesizedRange` (1)
- `getSurroundingParentheses` (1)

**Calls:**
- `get` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3271` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `findVariable`
`/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:57` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `isFunctionParametersSafeToFix` (1)

### `extraArrowData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `get body` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2876` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `defs` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3586` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `getInnermostScope` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:615` | Self: 0.0% (1.5ms) | Total: 0.0% (3.3ms) | Samples: 1

**Called by:**
- `getAllComments` (2)

**Calls:**
- `slice` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_computeVarDefs` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3131` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `map` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7249` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2211` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `isFunctionSelfUsedInside`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/is-function-self-used-inside.js:17` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `isFixable` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4115` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `nodeView` (1)

### `isArrowFunctionBody`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-arrow-function-body.js:2` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `isFixable` (1)

### `entries`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/glob-parent/index.js:5` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `get typeAnnotation`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `create`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:66` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `isMethodCall` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2238` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1735` | Self: 0.0% (1.4ms) | Total: 0.0% (3.0ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (2)

**Calls:**
- `extraArrowData` (1)

### `get properties`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `isNotReference` (1)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:83` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `isReferenceIdentifier` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4775` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `toLocaleLowerCase`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `map` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/baseline-browser-mapping/dist/index.cjs:1` | Self: 0.0% (1.4ms) | Total: 0.0% (4.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)
- `anonymous` (1)
- `forEach` (1)

**Calls:**
- `(anonymous)` (1)
- `forEach` (1)

### `has`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_findDefNode` (1)

### `getForOfLoopHeadText`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:100` | Self: 0.0% (1.4ms) | Total: 0.0% (7.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `some` (3)
- `isFunctionParameterVariableReassigned` (1)

### `toEslintRuleFixer`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-rule-fixer.js:29` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `toEslintProblem` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `getTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1374` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getLastTokens` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getForOfLoopHeadRange` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4392` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `_isChainNode`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `nodeViewChain` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3967` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `report` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_computeDeclaredVariables` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2276` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `encodeInto`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_encodeSource` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1708` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `get`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-context.js:25` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `performProxyObjectGet` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-listener.js:34` | Self: 0.0% (1.3ms) | Total: 3.6% (780.3ms) | Samples: 1

**Called by:**
- `_invokeFused` (515)

**Calls:**
- `report` (514)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1162` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_makeToken` (1)

### `get key`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3156` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `isNotReference` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2140` | Self: 0.0% (1.3ms) | Total: 0.0% (7.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (4)
- `_buildScope` (1)

**Calls:**
- `_buildScope` (2)
- `_buildScope` (1)
- `_buildScope` (1)

### `map`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (16.6ms) | Samples: 1

**Called by:**
- `(module)` (6)
- `get properties` (3)
- `camelCase` (1)
- `isNotReference` (1)

**Calls:**
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `toLocaleLowerCase` (1)
- `(anonymous)` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getForOfLoopHeadRange` (1)

### `stripChainExpression`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:47` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `isFixable` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get arguments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1920` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getFixFunction` (1)

### `getForOfLoopHeadText`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:96` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `fill`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6600` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:87` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `map` (1)

### `getParentSyntaxOpeningParenthesis`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/get-parent-syntax-opening-parenthesis.js:25` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `iterateSurroundingParentheses` (1)

### `EventEmitter`
`node:events:11` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `Stream` (1)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:52` | Self: 0.0% (1.3ms) | Total: 0.0% (4.2ms) | Samples: 1

**Called by:**
- `isReferenceIdentifier` (3)

**Calls:**
- `get computed` (2)

### `getFirstSegment`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:30` | Self: 0.0% (1.3ms) | Total: 0.0% (3.0ms) | Samples: 1

**Called by:**
- `addPolyfillToken` (2)

**Calls:**
- `regExpSplitFast` (1)

### `isReferenceIdentifier`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:153` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4110` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `nodeView` (1)

### `_ensureChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:990` | Self: 0.0% (1.2ms) | Total: 0.0% (5.3ms) | Samples: 1

**Called by:**
- `get` (4)

**Calls:**
- `_buildScopeChildren` (3)

### `get argument`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1862` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `replaceReturnStatement` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:594` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `getAllComments` (1)

### `evaluate`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (12.0ms) | Samples: 1

**Called by:**
- `moduleEvaluation` (8)

**Calls:**
- `(module)` (6)
- `(module)` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1525` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `invokeMethodFnHandlers` (1)

### `getTokenAfter`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1713` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `fixSpaceAroundKeyword` (1)

### `fillUsage`
`/Users/ericsan/node_modules/browserslist/index.js:79` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getFixFunction`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `Function`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `FFIBuilder` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2204` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `@lazy`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `node:fs/promises` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2946` | Self: 0.0% (917us) | Total: 0.0% (917us) | Samples: 1

**Called by:**
- `get references` (1)

### `getParentSyntaxOpeningParenthesis`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/get-parent-syntax-opening-parenthesis.js:26` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `iterateSurroundingParentheses` (1)

**Calls:**
- `get callee` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/rules/utils/lazy-loading-rule-map.js:7` | Self: 0.0% (0us) | Total: 0.0% (3.4ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/esutils/lib/utils.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `camelCase`
`/Users/ericsan/node_modules/change-case/dist/index.js:68` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `map` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3996` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `report` (1)

**Calls:**
- `filter` (1)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `encodeInto` (1)

### `node:stream`
`node:stream:2` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `isAvailable`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-source-code.js:56` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `_getFfi` (2)

**Calls:**
- `_tryLoad` (2)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/traverse/index.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6436` | Self: 0.0% (0us) | Total: 0.0% (7.3ms) | Samples: 0

**Called by:**
- `walkNodes` (5)

**Calls:**
- `get value` (2)
- `get value` (1)
- `get value` (1)
- `get value` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/transform/index.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `isFunctionParametersSafeToFix`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:295` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `isFixable` (1)

**Calls:**
- `get name` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1713` | Self: 0.0% (0us) | Total: 0.0% (18.4ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (12)

**Calls:**
- `_nodesFromRange` (10)
- `_nodesFromRange` (2)

### `isFunctionParametersSafeToFix`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:283` | Self: 0.0% (0us) | Total: 0.0% (15.8ms) | Samples: 0

**Called by:**
- `isFixable` (10)

**Calls:**
- `getDeclaredVariables` (10)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/config/default-config.js:37` | Self: 0.0% (0us) | Total: 0.0% (11.3ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `resolveIds`
`/Users/ericsan/node_modules/ajv/lib/compile/resolve.js:235` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_addSchema` (1)

**Calls:**
- `getFullPath` (1)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 2.4% (523.4ms) | Samples: 0

**Called by:**
- `loadPlugin` (75)
- `(anonymous)` (27)
- `(anonymous)` (17)
- `(anonymous)` (12)
- `(anonymous)` (12)
- `(anonymous)` (10)
- `(anonymous)` (10)
- `(anonymous)` (9)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (6)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `patchAstUtils` (5)
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
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `require` (339)
- `anonymous` (3)
- `(anonymous)` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4162` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `arguments` (1)

**Calls:**
- `_isChainNode` (1)

### `internal:streams/compose`
`internal:streams/compose:2` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:60` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `isReferenceIdentifier` (2)

**Calls:**
- `get value` (1)
- `get value` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:98` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `addPolyfillToken` (2)

### `getLastTokens`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3403` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `getTokens` (1)
- `getTokens` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/ajv.js:28` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/config/config.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `getForOfLoopHeadText`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:106` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `isParenthesized` (2)

### `create`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js:62` | Self: 0.0% (0us) | Total: 0.1% (31.5ms) | Samples: 0

**Called by:**
- `isMethodCall` (20)

**Calls:**
- `arguments` (20)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4119` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `reset` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7460` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `invokeMethodFnHandlers` (2)

### `_tryLoad`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-source-code.js:44` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `isAvailable` (2)

**Calls:**
- `dlopen` (1)
- `dlopen` (1)

### `(module)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/expiring-todo-comments.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `evaluate` (1)

**Calls:**
- `bound require` (1)

### `getParentheses`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/parentheses.js:25` | Self: 0.0% (0us) | Total: 0.1% (26.2ms) | Samples: 0

**Called by:**
- `removeParentheses` (10)
- `removeCallbackParentheses` (5)
- `getParenthesizedRange` (2)

**Calls:**
- `generatorResume` (14)
- `next` (3)

### `isFixable`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:359` | Self: 0.0% (0us) | Total: 0.0% (16.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (10)

**Calls:**
- `some` (10)

### `assertToken`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/assert-token.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `replaceReturnStatement` (1)

**Calls:**
- `some` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/levn/lib/parse-string.js:113` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/compat-transpiler/index.js:9` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

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
`/Users/ericsan/node_modules/eslint/lib/config/config.js:15` | Self: 0.0% (0us) | Total: 0.0% (7.2ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1367` | Self: 0.0% (0us) | Total: 0.1% (23.2ms) | Samples: 0

**Called by:**
- `isFunctionParametersSafeToFix` (13)
- `isMemberExpression` (2)

**Calls:**
- `_identAt` (9)
- `_resolveUnicodeEscapes` (5)
- `_identAt` (1)

### `(module)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:60` | Self: 0.0% (0us) | Total: 0.0% (9.2ms) | Samples: 0

**Called by:**
- `evaluate` (6)

**Calls:**
- `map` (6)

### `(anonymous)`
`/Users/ericsan/node_modules/levn/lib/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/compat-transpiler/index.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:24` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1098` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `reset` (1)

**Calls:**
- `_getSharedCaches` (1)

### `replaceReturnStatement`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:133` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `generatorResume` (1)

**Calls:**
- `assertToken` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/regexp-tree.js:8` | Self: 0.0% (0us) | Total: 0.0% (4.2ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `getFixFunction`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:87` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get arguments` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/ajv.js:9` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-rule-fixer.js:32` | Self: 0.0% (0us) | Total: 0.0% (5.6ms) | Samples: 0

**Called by:**
- `_execReport` (4)

**Calls:**
- `(anonymous)` (4)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:414` | Self: 0.0% (0us) | Total: 4.1% (879.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (578)

**Calls:**
- `isReferenceIdentifier` (564)
- `isReferenceIdentifier` (13)
- `isReferenceIdentifier` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-scope/dist/eslint-scope.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6460` | Self: 0.0% (0us) | Total: 0.0% (5.9ms) | Samples: 0

**Called by:**
- `walkNodes` (2)
- `walkNodes` (2)

**Calls:**
- `invokeHandlersWithNode` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.0% (3.9ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:322` | Self: 0.0% (0us) | Total: 0.0% (4.2ms) | Samples: 0

**Called by:**
- `some` (3)

**Calls:**
- `get references` (3)

### `replaceReturnStatement`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:152` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `generatorResume` (1)

**Calls:**
- `get argument` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/levn/lib/cast.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `iterateFixOrProblems`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js:24` | Self: 0.0% (0us) | Total: 88.8% (18.73s) | Samples: 0

**Called by:**
- `generatorResume` (12252)

**Calls:**
- `next` (10234)
- `generatorResume` (1990)
- `iterateFixOrProblems` (28)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:828` | Self: 0.0% (0us) | Total: 0.0% (4.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `_buildReference` (1)
- `_buildReference` (1)
- `_buildReference` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/debug/src/index.js:9` | Self: 0.0% (0us) | Total: 0.0% (3.4ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7361` | Self: 0.0% (0us) | Total: 0.0% (4.2ms) | Samples: 0

**Called by:**
- `runPlugins` (3)

**Calls:**
- `create` (3)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/source-code.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4165` | Self: 0.0% (0us) | Total: 0.2% (51.7ms) | Samples: 0

**Called by:**
- `isMethodCall` (20)
- `arguments` (13)

**Calls:**
- `_nodeViewRaw` (31)
- `_nodeViewRaw` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/rules/no-warning-comments.js:9` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1576` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `getSurroundingParentheses` (2)

**Calls:**
- `_getFfi` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/languages/js/index.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

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

### `Readable`
`internal:streams/readable:160` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `ReadStream` (1)

**Calls:**
- `Stream` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/linter/linter.js:48` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/index.js:8` | Self: 0.0% (0us) | Total: 0.0% (7.5ms) | Samples: 0

**Called by:**
- `parseModule` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/node_modules/browserslist/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/linter/apply-disable-directives.js:22` | Self: 0.0% (0us) | Total: 0.0% (14.6ms) | Samples: 0

**Called by:**
- `anonymous` (10)

**Calls:**
- `bound require` (10)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/linter/linter.js:19` | Self: 0.0% (0us) | Total: 0.0% (14.6ms) | Samples: 0

**Called by:**
- `anonymous` (10)

**Calls:**
- `bound require` (10)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3610` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `getRange` (1)

**Calls:**
- `_isStatementTag` (1)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:53` | Self: 0.0% (0us) | Total: 0.0% (7.9ms) | Samples: 0

**Called by:**
- `isReferenceIdentifier` (5)

**Calls:**
- `get key` (3)
- `get key` (1)
- `get key` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:22` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:18` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_getFfi`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:72` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `getTokenBefore` (2)

**Calls:**
- `isAvailable` (2)

### `isFixable`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:332` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `stripChainExpression` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1020` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `findVariable` (2)

**Calls:**
- `_ensureVarsSet` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/browserslist/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/@eslint/config-array/dist/cjs/index.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `fixSpaceAroundKeyword`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/fix/fix-space-around-keywords.js:34` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `generatorResume` (1)

**Calls:**
- `getTokenAfter` (1)

### `iterateSurroundingParentheses`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/iterate-surrounding-parentheses.js:67` | Self: 0.0% (0us) | Total: 0.1% (21.9ms) | Samples: 0

**Called by:**
- `generatorResume` (14)

**Calls:**
- `getSurroundingParentheses` (14)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2085` | Self: 0.0% (0us) | Total: 0.0% (4.7ms) | Samples: 0

**Called by:**
- `_computeDeclaredVariables` (3)

**Calls:**
- `_symName` (3)

### `internal:stream`
`internal:stream:2` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` | Self: 0.0% (0us) | Total: 1.0% (220.3ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (142)

**Calls:**
- `parse` (142)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (16.0ms) | Samples: 0

**Calls:**
- `parseModule` (11)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2688` | Self: 0.0% (0us) | Total: 0.0% (4.0ms) | Samples: 0

**Called by:**
- `_ensureChildren` (3)

**Calls:**
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:142` | Self: 0.0% (0us) | Total: 0.5% (114.9ms) | Samples: 0

**Calls:**
- `loadPlugin` (75)

### `isFunctionParameterVariableReassigned`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:319` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `getForOfLoopHeadText` (1)

**Calls:**
- `getDeclaredVariables` (1)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 2.4% (516.9ms) | Samples: 0

**Called by:**
- `bound require` (339)

**Calls:**
- `anonymous` (264)
- `(anonymous)` (75)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:274` | Self: 0.0% (0us) | Total: 98.2% (20.73s) | Samples: 0

**Called by:**
- `(anonymous)` (13568)

**Calls:**
- `runPlugins` (13564)
- `runPlugins` (2)
- `runPlugins` (1)
- `runPlugins` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/interpreter/finite-automaton/index.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-listener.js:31` | Self: 0.0% (0us) | Total: 92.3% (19.47s) | Samples: 0

**Called by:**
- `_invokeFused` (12736)
- `invokeHandlersWithNode` (2)

**Calls:**
- `generatorResume` (11542)
- `next` (1184)
- `iterateFixOrProblems` (12)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:20` | Self: 0.0% (0us) | Total: 0.0% (17.6ms) | Samples: 0

**Called by:**
- `anonymous` (12)

**Calls:**
- `bound require` (12)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:455` | Self: 0.0% (0us) | Total: 0.0% (6.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `bound require` (5)

### `isFixable`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:372` | Self: 0.0% (0us) | Total: 0.0% (9.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `some` (6)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:220` | Self: 0.0% (0us) | Total: 0.1% (29.6ms) | Samples: 0

**Called by:**
- `generatorResume` (19)

**Calls:**
- `getForOfLoopHeadRange` (10)
- `getForOfLoopHeadText` (5)
- `getForOfLoopHeadText` (2)
- `getForOfLoopHeadText` (1)
- `getForOfLoopHeadText` (1)

### `getFixFunction`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:93` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `slice` (1)
- `getText` (1)

### `getText`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1292` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `getFixFunction` (1)

**Calls:**
- `get range` (1)

### `forEach`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/@babel/helper-validator-identifier/lib/index.js:54` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `bound require` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7657` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `fill` (1)

### `wrap`
`bun:ffi:296` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `getTokenBefore` (1)

**Calls:**
- `anonymous` (1)

### `get properties`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3126` | Self: 0.0% (0us) | Total: 3.1% (660.3ms) | Samples: 0

**Called by:**
- `isNotReference` (434)

**Calls:**
- `_nodesFromRange` (426)
- `_nodesFromRange` (6)
- `_nodesFromRange` (2)

### `getAllComments`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3369` | Self: 0.0% (0us) | Total: 0.1% (22.5ms) | Samples: 0

**Called by:**
- `_getTokensAndCommentsMerged` (14)

**Calls:**
- `commentsInRange` (7)
- `commentsInRange` (2)
- `commentsInRange` (2)
- `commentsInRange` (1)
- `commentsInRange` (1)
- `commentsInRange` (1)

### `performIteration`
`[native code]` | Self: 0.0% (0us) | Total: 3.6% (768.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (507)

**Calls:**
- `generatorResume` (504)
- `next` (3)

### `loadPlugin`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:89` | Self: 0.0% (0us) | Total: 0.5% (114.9ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (75)

**Calls:**
- `bound require` (75)

### `get defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `isFunctionParametersSafeToFix` (2)

**Calls:**
- `_computeVarDefs` (2)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3178` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `isFunctionParameterVariableReassigned` (1)

**Calls:**
- `get` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/config/config-loader.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/token-store/index.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7669` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (2)

**Calls:**
- `get source` (1)
- `reset` (1)

### `get properties`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3130` | Self: 0.0% (0us) | Total: 0.0% (4.6ms) | Samples: 0

**Called by:**
- `isNotReference` (3)

**Calls:**
- `map` (3)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2772` | Self: 0.0% (0us) | Total: 0.1% (22.1ms) | Samples: 0

**Called by:**
- `getScope` (15)

**Calls:**
- `commentsInRange` (8)
- `commentsInRange` (4)
- `commentsInRange` (1)
- `commentsInRange` (1)
- `commentsInRange` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/optimizer/index.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/semver/index.js:18` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/source-code.js:21` | Self: 0.0% (0us) | Total: 0.0% (3.4ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1967` | Self: 0.0% (0us) | Total: 0.1% (23.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (16)

**Calls:**
- `_precomputeScopes` (15)
- `_precomputeScopes` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/parser/index.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4137` | Self: 0.0% (0us) | Total: 0.4% (92.0ms) | Samples: 0

**Called by:**
- `get parent` (31)
- `_nodesFromRange` (16)
- `get property` (11)
- `get body` (2)
- `get body` (1)

**Calls:**
- `_nodeViewRaw` (56)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/ajv.js:3` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `get ReadStream`
`node:fs:573` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/p-locate/index.js:2` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` | Self: 0.0% (0us) | Total: 0.0% (8.8ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (3)

**Calls:**
- `AstView` (2)
- `AstView` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/eslint/eslint.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:70` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `camelCase` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/source-code.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` | Self: 0.0% (0us) | Total: 1.0% (230.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (146)

**Calls:**
- `parseSource` (142)
- `parseSource` (3)
- `parseSource` (1)

### `fixSpaceAroundKeyword`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/fix/fix-space-around-keywords.js:28` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `generatorResume` (1)

**Calls:**
- `getRange` (1)

### `iterateSurroundingParentheses`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/iterate-surrounding-parentheses.js:71` | Self: 0.0% (0us) | Total: 0.0% (7.3ms) | Samples: 0

**Called by:**
- `generatorResume` (5)

**Calls:**
- `getParentSyntaxOpeningParenthesis` (1)
- `getTokenAfter` (1)
- `getParentSyntaxOpeningParenthesis` (1)
- `getParentSyntaxOpeningParenthesis` (1)
- `getParentSyntaxOpeningParenthesis` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/languages/js/index.js:12` | Self: 0.0% (0us) | Total: 0.0% (8.0ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1736` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (2)

**Calls:**
- `nodeView` (1)
- `_nodeViewRaw` (1)

### `FFIBuilder`
`bun:ffi:283` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `dlopen` (1)

**Calls:**
- `Function` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3210` | Self: 0.0% (0us) | Total: 0.0% (11.4ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (7)

**Calls:**
- `_ensureDeclSymIndex` (3)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)

### `internal:streams/pipeline`
`internal:streams/pipeline:2` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/dotjs/index.js:15` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `internal:streams/operators`
`internal:streams/operators:2` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `getFullPath`
`/Users/ericsan/node_modules/ajv/lib/compile/resolve.js:209` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `resolveIds` (1)

**Calls:**
- `parse` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1511` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (1)

**Calls:**
- `_nodesFromRange` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-rule-fixer.js:37` | Self: 0.0% (0us) | Total: 3.6% (768.7ms) | Samples: 0

**Called by:**
- `_execReport` (507)

**Calls:**
- `performIteration` (507)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3222` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (2)

**Calls:**
- `Set` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/eslint/eslint-helpers.js:19` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3180` | Self: 0.0% (0us) | Total: 0.0% (15.8ms) | Samples: 0

**Called by:**
- `isFunctionParametersSafeToFix` (10)

**Calls:**
- `_computeDeclaredVariables` (7)
- `_computeDeclaredVariables` (2)
- `_computeDeclaredVariables` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/locate-path/index.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/browserslist/index.js:1` | Self: 0.0% (0us) | Total: 0.0% (4.6ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `linkAndEvaluateModule`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (4.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `link` (3)

### `getInnermostScope`
`/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:21` | Self: 0.0% (0us) | Total: 0.0% (9.1ms) | Samples: 0

**Called by:**
- `findVariable` (6)

**Calls:**
- `get range` (2)
- `get range` (2)
- `get range` (1)
- `get range` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/core-js-compat/index.js:2` | Self: 0.0% (0us) | Total: 0.0% (11.8ms) | Samples: 0

**Called by:**
- `parseModule` (8)

**Calls:**
- `bound require` (8)

### `node:fs/promises`
`node:fs/promises:2` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `@lazy` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:545` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_computeVarDefs` (1)

**Calls:**
- `has` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/compile/rules.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `isMemberExpression`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js:67` | Self: 0.0% (0us) | Total: 0.1% (21.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (13)

**Calls:**
- `get name` (8)
- `get name` (3)
- `get name` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/linter/esquery.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:25` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `isReferenceIdentifier` (2)

**Calls:**
- `get params` (1)
- `get params` (1)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` | Self: 0.0% (0us) | Total: 0.0% (3.5ms) | Samples: 0

**Called by:**
- `runPlugins` (1)
- `runPlugins` (1)

**Calls:**
- `decode` (2)

### `test`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (1)

**Calls:**
- `/^\s*exported\b/` (1)

### `processTicksAndRejections`
`[native code]` | Self: 0.0% (0us) | Total: 99.3% (20.96s) | Samples: 0

**Calls:**
- `(anonymous)` (13715)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1898` | Self: 0.0% (0us) | Total: 2.9% (622.1ms) | Samples: 0

**Called by:**
- `getTokenBefore` (412)

**Calls:**
- `_getAllTokens` (396)
- `_getAllTokens` (16)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:612` | Self: 0.0% (0us) | Total: 0.0% (17.2ms) | Samples: 0

**Called by:**
- `getAllComments` (7)
- `_precomputeScopes` (4)

**Calls:**
- `_findLineIdx` (6)
- `_findLineIdx` (5)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1607` | Self: 0.0% (0us) | Total: 0.0% (7.3ms) | Samples: 0

**Called by:**
- `getSurroundingParentheses` (5)

**Calls:**
- `_makeToken` (3)
- `_makeToken` (1)
- `_makeToken` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:267` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getTagNames` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/rules/utils/ast-utils.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `isReturnStatementInContinueAbleNodes`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:52` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `some` (1)

**Calls:**
- `get parent` (1)

### `parse`
`/Users/ericsan/node_modules/uri-js/dist/es5/uri.all.js:936` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `getFullPath` (1)

**Calls:**
- `_normalizeComponentEncoding` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:497` | Self: 0.0% (0us) | Total: 0.0% (6.4ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `patchAstUtils` (5)

### `internal:fs/streams`
`internal:fs/streams:2` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/@eslint/plugin-kit/dist/cjs/index.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (3.4ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/eslint/eslint.js:19` | Self: 0.0% (0us) | Total: 0.0% (14.8ms) | Samples: 0

**Called by:**
- `anonymous` (9)

**Calls:**
- `bound require` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:28` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `readFileSync` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3991` | Self: 0.0% (0us) | Total: 3.6% (774.3ms) | Samples: 0

**Called by:**
- `report` (511)

**Calls:**
- `(anonymous)` (507)
- `(anonymous)` (4)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/transform/index.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/compile/resolve.js:7` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/ajv/lib/compile/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/browserslist/index.js:1334` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `addPolyfillToken`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:53` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `getFirstSegment` (2)

### `isFunctionParametersSafeToFix`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:296` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `isFixable` (1)

**Calls:**
- `getRange` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/config/config.js:14` | Self: 0.0% (0us) | Total: 0.0% (4.4ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/assert-token.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `some` (1)

**Calls:**
- `entries` (1)

### `replaceReturnStatement`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:161` | Self: 0.0% (0us) | Total: 0.0% (6.3ms) | Samples: 0

**Called by:**
- `generatorResume` (4)

**Calls:**
- `needsSemicolon` (4)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:478` | Self: 0.0% (0us) | Total: 0.0% (7.2ms) | Samples: 0

**Called by:**
- `parseSource` (2)

**Calls:**
- `CfgGraph` (1)
- `CfgGraph` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/levn/lib/cast.js:327` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/levn/lib/index.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1594` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `getSurroundingParentheses` (1)

**Calls:**
- `get range` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2242` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_buildScope` (1)

**Calls:**
- `get parent` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7677` | Self: 0.0% (0us) | Total: 98.2% (20.72s) | Samples: 0

**Called by:**
- `_lintSourceOne` (13564)

**Calls:**
- `walkNodes` (12231)
- `walkNodes` (1204)
- `walkNodes` (18)
- `walkNodes` (15)
- `walkNodes` (14)
- `walkNodes` (13)
- `walkNodes` (10)
- `walkNodes` (9)
- `walkNodes` (6)
- `walkNodes` (6)
- `walkNodes` (5)
- `walkNodes` (5)
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

### `isFunctionParametersSafeToFix`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:286` | Self: 0.0% (0us) | Total: 0.0% (10.9ms) | Samples: 0

**Called by:**
- `isFixable` (7)

**Calls:**
- `defs` (5)
- `get defs` (2)

### `fixSpaceAroundKeyword`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/fix/fix-space-around-keywords.js:24` | Self: 0.0% (0us) | Total: 3.3% (696.2ms) | Samples: 0

**Called by:**
- `generatorResume` (460)

**Calls:**
- `getTokenBefore` (460)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:25` | Self: 0.0% (0us) | Total: 0.0% (11.5ms) | Samples: 0

**Called by:**
- `parseModule` (8)

**Calls:**
- `bound require` (8)

### `regExpSplitFast`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `getFirstSegment` (1)

**Calls:**
- `/[./-]/u` (1)

### `moduleEvaluation`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (36.1ms) | Samples: 0

**Called by:**
- `moduleEvaluation` (16)
- `(anonymous)` (8)

**Calls:**
- `moduleEvaluation` (16)
- `evaluate` (8)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1211` | Self: 0.0% (0us) | Total: 0.2% (47.0ms) | Samples: 0

**Called by:**
- `isNotReference` (31)

**Calls:**
- `nodeView` (31)

### `(anonymous)`
`/Users/ericsan/node_modules/browserslist/index.js:1316` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `fillUsage` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7318` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_invokeFused` (1)

### `getFixFunction`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:89` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get callee` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7296` | Self: 0.0% (0us) | Total: 0.0% (13.5ms) | Samples: 0

**Called by:**
- `runPlugins` (9)

**Calls:**
- `invokeMethodFnHandlers` (5)
- `invokeMethodFnHandlers` (2)
- `invokeMethodFnHandlers` (1)
- `invokeMethodFnHandlers` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `ReadStream`
`internal:fs/streams:86` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `Readable` (1)

### `isFunctionParametersSafeToFix`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:308` | Self: 0.0% (0us) | Total: 0.1% (24.1ms) | Samples: 0

**Called by:**
- `isFixable` (16)

**Calls:**
- `findVariable` (12)
- `findVariable` (3)
- `findVariable` (1)

### `toEslintProblem`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-problem.js:21` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `toEslintRuleFixer` (1)

### `isNodeMatches`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/is-node-matches.js:57` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `some` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1023` | Self: 0.0% (0us) | Total: 0.0% (5.3ms) | Samples: 0

**Called by:**
- `getInnermostScope` (4)

**Calls:**
- `_ensureChildren` (4)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:249` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `generatorResume` (1)

**Calls:**
- `getLastToken` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js:104` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `map` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:359` | Self: 0.0% (0us) | Total: 0.0% (14.4ms) | Samples: 0

**Called by:**
- `some` (9)

**Calls:**
- `get typeAnnotation` (6)
- `get typeAnnotation` (1)
- `get typeAnnotation` (1)
- `get typeAnnotation` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/eslint/eslint.js:44` | Self: 0.0% (0us) | Total: 0.1% (25.5ms) | Samples: 0

**Called by:**
- `anonymous` (17)

**Calls:**
- `bound require` (17)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:405` | Self: 0.0% (0us) | Total: 0.4% (85.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (57)

**Calls:**
- `_buildScope` (30)
- `getScope` (16)
- `_buildScope` (4)
- `_buildScope` (3)
- `_buildScope` (2)
- `_buildScope` (1)
- `_buildScope` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7366` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `defineProperty` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/core-js-compat/compat.js:7` | Self: 0.0% (0us) | Total: 0.0% (10.5ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7369` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `get` (1)

### `isNotReference`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js:69` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `isReferenceIdentifier` (1)

**Calls:**
- `get elements` (1)

### `internal:streams/duplex`
`internal:streams/duplex:2` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/linter/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (17.6ms) | Samples: 0

**Called by:**
- `anonymous` (12)

**Calls:**
- `bound require` (12)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2866` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `get defs` (2)

**Calls:**
- `_findDefNode` (1)
- `_findDefNode` (1)

### `loadBinding`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `getTagNames` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/semver/index.js:36` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/linter/linter.js:45` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2776` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `getScope` (1)

**Calls:**
- `test` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1257` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_getAllTokens` (1)

**Calls:**
- `_findLine` (1)

### `removeParentheses`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/fix/remove-parentheses.js:15` | Self: 0.0% (0us) | Total: 0.0% (15.9ms) | Samples: 0

**Called by:**
- `generatorResume` (10)

**Calls:**
- `getParentheses` (10)

### `needsSemicolon`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/needs-semicolon.js:52` | Self: 0.0% (0us) | Total: 0.0% (6.3ms) | Samples: 0

**Called by:**
- `replaceReturnStatement` (4)

**Calls:**
- `getNodeByRangeIndex` (3)
- `getNodeByRangeIndex` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/rules/index.js:11` | Self: 0.0% (0us) | Total: 0.0% (3.4ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/languages/js/source-code/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (8.0ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `isParenthesized`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/parentheses.js:74` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `getForOfLoopHeadText` (2)

**Calls:**
- `generatorResume` (2)

### `link`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (18.1ms) | Samples: 0

**Called by:**
- `link` (8)
- `linkAndEvaluateModule` (3)

**Calls:**
- `link` (8)
- `moduleDeclarationInstantiation` (3)

### `(anonymous)`
`/Users/ericsan/node_modules/levn/lib/index.js:22` | Self: 0.0% (0us) | Total: 0.0% (3.4ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `_addSchema`
`/Users/ericsan/node_modules/ajv/lib/ajv.js:309` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `addSchema` (1)

**Calls:**
- `resolveIds` (1)

### `get params`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2587` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `isNotReference` (1)

**Calls:**
- `_nodesFromRange` (1)

### `invokeHandlersWithNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6398` | Self: 0.0% (0us) | Total: 0.0% (5.9ms) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (4)

**Calls:**
- `(anonymous)` (2)
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/@eslint/config-array/node_modules/minimatch/dist/commonjs/index.js:7` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/espree/dist/espree.cjs:4` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

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

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:220` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `_encodeSource` (1)

### `get params`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2583` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `isNotReference` (2)

**Calls:**
- `extraFnData` (2)

### `getTokenAfter`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1731` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `iterateSurroundingParentheses` (1)

**Calls:**
- `get range` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/find-up/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/shared/ajv.js:11` | Self: 0.0% (0us) | Total: 0.0% (7.2ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `getInnermostScope`
`/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:13` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `findVariable` (1)

**Calls:**
- `get range` (1)

### `getParenthesizedRange`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/parentheses.js:46` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `getForOfLoopHeadRange` (1)

**Calls:**
- `performProxyObjectGet` (1)

### `isFixable`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:335` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isArrowFunctionBody` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4021` | Self: 0.0% (0us) | Total: 3.6% (779.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (514)

**Calls:**
- `_execReport` (511)
- `_execReport` (1)
- `_execReport` (1)
- `_execReport` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/unsupported-api.js:14` | Self: 0.0% (0us) | Total: 0.1% (42.0ms) | Samples: 0

**Called by:**
- `parseModule` (27)

**Calls:**
- `bound require` (27)

### `(anonymous)`
`/Users/ericsan/node_modules/caniuse-lite/dist/unpacker/agents.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/levn/lib/parse-string.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` | Self: 0.0% (0us) | Total: 0.0% (7.9ms) | Samples: 0

**Called by:**
- `isFunctionParametersSafeToFix` (5)

**Calls:**
- `_computeVarDefs` (3)
- `_computeVarDefs` (1)
- `_computeVarDefs` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:465` | Self: 0.0% (0us) | Total: 0.0% (8.8ms) | Samples: 0

**Called by:**
- `generatorResume` (6)

**Calls:**
- `getFixFunction` (2)
- `getFixFunction` (1)
- `getFixFunction` (1)
- `getFixFunction` (1)
- `getFixFunction` (1)

### `addMetaSchema`
`/Users/ericsan/node_modules/ajv/lib/ajv.js:152` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `addSchema` (1)

### `getTagNames`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:191` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `loadBinding` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/optimizer/transforms/index.js:40` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1417` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `isNotReference` (1)

**Calls:**
- `get mainToken` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1515` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (2)

**Calls:**
- `get range` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/config/default-config.js:12` | Self: 0.0% (0us) | Total: 0.0% (3.4ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `next`
`[native code]` | Self: 0.0% (0us) | Total: 100.0% (34.41s) | Samples: 0

**Called by:**
- `iterateFixOrProblems` (11105)
- `iterateFixOrProblems` (10234)
- `(anonymous)` (1184)
- `performIteration` (3)
- `getParentheses` (3)

**Calls:**
- `generatorResume` (22529)

### `get params`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2584` | Self: 0.0% (0us) | Total: 0.0% (7.9ms) | Samples: 0

**Called by:**
- `isNotReference` (5)

**Calls:**
- `_nodesFromRange` (3)
- `_nodesFromRange` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/compat-transpiler/transforms/index.js:10` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1516` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (1)

**Calls:**
- `get loc` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/interpreter/finite-automaton/nfa/nfa-from-regexp.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/core-js-compat/targets-parser.js:2` | Self: 0.0% (0us) | Total: 0.0% (10.5ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2260` | Self: 0.0% (0us) | Total: 0.1% (32.1ms) | Samples: 0

**Called by:**
- `_buildScope` (21)

**Calls:**
- `get body` (12)
- `get body` (4)
- `get body` (2)
- `get body` (2)
- `get body` (1)

### `get property`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1979` | Self: 0.0% (0us) | Total: 0.0% (16.1ms) | Samples: 0

**Called by:**
- `isNotReference` (9)
- `isMemberExpression` (2)

**Calls:**
- `nodeView` (11)

### `_getTokensAndCommentsMerged`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1899` | Self: 0.0% (0us) | Total: 0.1% (22.5ms) | Samples: 0

**Called by:**
- `getTokenBefore` (14)

**Calls:**
- `getAllComments` (14)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` | Self: 0.0% (0us) | Total: 0.0% (8.2ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `get key`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3165` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `isNotReference` (1)

**Calls:**
- `get left` (1)

### `removeCallbackParentheses`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:199` | Self: 0.0% (0us) | Total: 0.0% (7.3ms) | Samples: 0

**Called by:**
- `generatorResume` (5)

**Calls:**
- `getParentheses` (5)

### `isFixable`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:376` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isFunctionSelfUsedInside` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:434` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isNodeMatches` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7153` | Self: 0.0% (0us) | Total: 0.0% (5.6ms) | Samples: 0

**Called by:**
- `runPlugins` (4)

**Calls:**
- `getDFSEvents` (3)
- `getDFSEvents` (1)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:839` | Self: 0.0% (0us) | Total: 0.0% (4.7ms) | Samples: 0

**Called by:**
- `_ensureDeclSymIndex` (3)

**Calls:**
- `_buildSymNameCache` (3)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/regexp-tree.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/esutils/lib/utils.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:230` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `generatorResume` (2)

**Calls:**
- `getLastTokens` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp-tree/dist/regexp-tree.js:10` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/linter/source-code-traverser.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `dlopen`
`bun:ffi:345` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_tryLoad` (1)

**Calls:**
- `dlopen` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2241` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `_buildScope` (2)

**Calls:**
- `get parent` (2)

### `dlopen`
`bun:ffi:351` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_tryLoad` (1)

**Calls:**
- `FFIBuilder` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/node_modules/minimatch/dist/commonjs/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7371` | Self: 0.0% (0us) | Total: 0.0% (19.3ms) | Samples: 0

**Called by:**
- `runPlugins` (13)

**Calls:**
- `_invokeFused` (13)

### `(anonymous)`
`/Users/ericsan/node_modules/core-js-compat/compat.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

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
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-listener.js:29` | Self: 0.0% (0us) | Total: 0.4% (100.4ms) | Samples: 0

**Called by:**
- `_invokeFused` (64)
- `invokeHandlersWithNode` (2)

**Calls:**
- `(anonymous)` (66)

### `(anonymous)`
`/Users/ericsan/node_modules/debug/src/node.js:240` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `getLastToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1518` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get range` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js:454` | Self: 0.0% (0us) | Total: 84.7% (17.87s) | Samples: 0

**Called by:**
- `generatorResume` (11692)

**Calls:**
- `isFixable` (11672)
- `isFixable` (10)
- `isFixable` (6)
- `isFixable` (1)
- `isFixable` (1)
- `isFixable` (1)
- `isFixable` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint/lib/languages/js/index.js:15` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-listener.js:33` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `toEslintProblem` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6435` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `findVariable`
`/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs:54` | Self: 0.0% (0us) | Total: 0.0% (17.8ms) | Samples: 0

**Called by:**
- `isFunctionParametersSafeToFix` (12)

**Calls:**
- `getInnermostScope` (6)
- `getInnermostScope` (5)
- `getInnermostScope` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7672` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `get source` (1)

### `Stream`
`internal:streams/legacy:4` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `Readable` (1)

**Calls:**
- `EventEmitter` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/semver/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `bound require` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2921` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `get references` (1)

**Calls:**
- `get parent` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:911` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `get` (2)

**Calls:**
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 64.1% | 13.53s | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-array-for-each.js` |
| 24.0% | 5.07s | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 6.4% | 1.35s | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 2.6% | 552.7ms | `[native code]` |
| 0.9% | 208.4ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-listeners.js` |
| 0.9% | 202.0ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/utilities.js` |
| 0.4% | 88.5ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-reference-identifier.js` |
| 0.1% | 23.0ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-method-call.js` |
| 0.0% | 15.3ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/call-or-new-expression.js` |
| 0.0% | 6.5ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-member-expression.js` |
| 0.0% | 6.1ms | `/Users/ericsan/node_modules/@eslint-community/eslint-utils/index.mjs` |
| 0.0% | 6.1ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/parentheses.js` |
| 0.0% | 4.5ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/get-parent-syntax-opening-parenthesis.js` |
| 0.0% | 4.3ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/no-unnecessary-polyfills.js` |
| 0.0% | 3.3ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/parentheses/iterate-surrounding-parentheses.js` |
| 0.0% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/index.js` |
| 0.0% | 1.5ms | `/Users/ericsan/node_modules/uri-js/dist/es5/uri.all.js` |
| 0.0% | 1.5ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/utils/is-function-self-used-inside.js` |
| 0.0% | 1.4ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/ast/is-arrow-function-body.js` |
| 0.0% | 1.4ms | `/Users/ericsan/node_modules/glob-parent/index.js` |
| 0.0% | 1.4ms | `/Users/ericsan/node_modules/baseline-browser-mapping/dist/index.cjs` |
| 0.0% | 1.3ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-rule-fixer.js` |
| 0.0% | 1.3ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/unicorn-context.js` |
| 0.0% | 1.3ms | `/Users/ericsan/node_modules/eslint-plugin-unicorn/rules/rule/to-eslint-listener.js` |
| 0.0% | 1.3ms | `node:events` |
| 0.0% | 1.2ms | `/Users/ericsan/node_modules/browserslist/index.js` |
