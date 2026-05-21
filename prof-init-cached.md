# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 2.78s | 1827 | 1.0ms | 273 |

**Top 10:** `(anonymous)` 19.4%, `walkNodes` 7.4%, `get parent` 7.3%, `push` 6.2%, `getDeclaredVariables` 5.9%, `some` 5.0%, `Set` 3.9%, `getDeclaredVariables` 3.5%, `get parent` 3.1%, `parse` 2.6%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 19.4% | 541.3ms | 29.9% | 831.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 7.4% | 207.7ms | 8.3% | 233.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6950` |
| 7.3% | 203.3ms | 7.3% | 203.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1203` |
| 6.2% | 172.6ms | 6.2% | 172.6ms | `push` | `[native code]` |
| 5.9% | 166.1ms | 5.9% | 166.1ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3133` |
| 5.0% | 139.2ms | 40.1% | 1.11s | `some` | `[native code]` |
| 3.9% | 110.8ms | 3.9% | 110.8ms | `Set` | `[native code]` |
| 3.5% | 99.8ms | 4.7% | 131.9ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3135` |
| 3.1% | 88.6ms | 3.1% | 88.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1178` |
| 2.6% | 74.3ms | 2.6% | 74.3ms | `parse` | `[native code]` |
| 2.5% | 70.2ms | 2.6% | 73.6ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3139` |
| 1.9% | 53.8ms | 1.9% | 53.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6706` |
| 1.8% | 51.2ms | 1.9% | 53.0ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:579` |
| 1.6% | 45.0ms | 1.6% | 45.0ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 1.5% | 42.7ms | 1.5% | 44.3ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3087` |
| 1.3% | 37.3ms | 4.9% | 138.0ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` |
| 1.3% | 36.9ms | 1.3% | 36.9ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3113` |
| 1.0% | 29.8ms | 1.0% | 29.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3997` |
| 0.7% | 21.9ms | 0.9% | 26.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` |
| 0.7% | 19.7ms | 2.0% | 58.1ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3136` |
| 0.5% | 15.6ms | 0.5% | 15.6ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4876` |
| 0.5% | 14.7ms | 0.9% | 25.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3132` |
| 0.5% | 14.5ms | 2.1% | 59.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 0.5% | 14.2ms | 0.5% | 14.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3106` |
| 0.4% | 13.0ms | 1.5% | 41.9ms | `anonymous` | `[native code]` |
| 0.4% | 12.9ms | 4.4% | 123.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` |
| 0.4% | 12.8ms | 0.4% | 12.8ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` |
| 0.4% | 12.7ms | 0.4% | 12.7ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:620` |
| 0.4% | 12.4ms | 9.9% | 275.6ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 0.4% | 11.4ms | 0.4% | 13.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4000` |
| 0.3% | 11.0ms | 0.7% | 21.5ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2673` |
| 0.3% | 10.4ms | 0.3% | 10.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7118` |
| 0.3% | 10.1ms | 0.5% | 14.2ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.3% | 9.7ms | 0.3% | 9.7ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.3% | 9.3ms | 0.3% | 10.9ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.3% | 9.1ms | 0.3% | 9.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4022` |
| 0.3% | 9.1ms | 0.3% | 9.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1225` |
| 0.2% | 8.1ms | 0.2% | 8.1ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1008` |
| 0.2% | 8.1ms | 0.2% | 8.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7117` |
| 0.2% | 7.9ms | 0.3% | 9.6ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.2% | 7.7ms | 0.2% | 7.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2013` |
| 0.2% | 7.7ms | 0.2% | 7.7ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.2% | 7.7ms | 2.6% | 74.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 0.2% | 7.6ms | 0.6% | 17.1ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` |
| 0.2% | 7.3ms | 0.3% | 10.6ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.2% | 7.3ms | 11.9% | 332.8ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 0.2% | 7.0ms | 0.2% | 7.0ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6445` |
| 0.2% | 7.0ms | 0.2% | 7.0ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6443` |
| 0.2% | 6.4ms | 0.2% | 6.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6949` |
| 0.2% | 6.3ms | 1.3% | 37.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1192` |
| 0.2% | 6.2ms | 0.2% | 6.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 6.1ms | 0.2% | 6.1ms | `/^\s*exported\b/` | `[native code]` |
| 0.2% | 6.1ms | 0.2% | 6.1ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` |
| 0.2% | 6.0ms | 0.2% | 6.0ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.2% | 6.0ms | 0.2% | 6.0ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3121` |
| 0.2% | 5.9ms | 0.2% | 5.9ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2730` |
| 0.2% | 5.8ms | 0.4% | 11.9ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` |
| 0.2% | 5.7ms | 0.4% | 13.5ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` |
| 0.2% | 5.7ms | 0.3% | 10.1ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` |
| 0.2% | 5.6ms | 0.2% | 5.6ms | `test` | `[native code]` |
| 0.1% | 5.0ms | 0.1% | 5.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6951` |
| 0.1% | 4.7ms | 0.1% | 4.7ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 4.6ms | 0.4% | 12.1ms | `forEach` | `[native code]` |
| 0.1% | 4.5ms | 32.8% | 914.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 0.1% | 4.2ms | 0.1% | 4.2ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4260` |
| 0.1% | 3.5ms | 0.1% | 3.5ms | `slice` | `[native code]` |
| 0.1% | 3.4ms | 0.1% | 3.4ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` |
| 0.1% | 3.4ms | 0.1% | 3.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6695` |
| 0.1% | 3.4ms | 0.1% | 3.4ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 3.4ms | 0.1% | 4.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.1% | 3.4ms | 0.1% | 3.4ms | `set` | `[native code]` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4019` |
| 0.1% | 3.3ms | 0.5% | 14.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4013` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3894` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:665` |
| 0.1% | 2.9ms | 0.1% | 4.3ms | `map` | `[native code]` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2589` |
| 0.1% | 2.8ms | 0.2% | 7.2ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:869` |
| 0.1% | 2.8ms | 0.1% | 4.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `get eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:738` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:647` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1179` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1185` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2693` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2225` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3130` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1006` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4050` |
| 0.0% | 1.7ms | 0.1% | 3.2ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:782` |
| 0.0% | 1.7ms | 0.1% | 3.4ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2864` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2670` |
| 0.0% | 1.7ms | 0.1% | 3.5ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2582` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:512` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:581` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 31.0% | 863.9ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2742` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6710` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1230` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `encodeInto` | `[native code]` |
| 0.0% | 1.6ms | 1.2% | 35.0ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:953` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2219` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2723` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6436` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1188` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:803` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.2% | 8.0ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2778` |
| 0.0% | 1.6ms | 100.0% | 6.39s | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_getTypeProto` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6910` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3807` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1288` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2426` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.0% | 1.5ms | 0.4% | 13.7ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3892` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1993` |
| 0.0% | 1.5ms | 0.1% | 3.3ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2788` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:752` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.1% | 2.9ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:744` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:425` |
| 0.0% | 1.4ms | 0.1% | 4.4ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:561` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2428` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1298` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2211` |
| 0.0% | 1.4ms | 0.8% | 23.2ms | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6817` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:846` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2098` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `scope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:745` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2743` |
| 0.0% | 1.4ms | 0.1% | 3.0ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2221` |
| 0.0% | 1.4ms | 100.0% | 2.78s | `parseModule` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:226` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isRead` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:867` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3992` |
| 0.0% | 1.3ms | 0.2% | 5.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3151` |
| 0.0% | 1.3ms | 0.1% | 3.2ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:819` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3600` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2208` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1010` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3123` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` |
| 0.0% | 1.3ms | 0.0% | 2.7ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:972` |
| 0.0% | 1.3ms | 0.8% | 24.1ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2840` |
| 0.0% | 1.3ms | 0.4% | 12.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2209` |
| 0.0% | 1.2ms | 0.1% | 2.8ms | `exec` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 2.5ms | `readFileSync` | `[native code]` |
| 0.0% | 1.2ms | 0.8% | 24.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get kind` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.1ms | 0.0% | 1.1ms | `decode` | `[native code]` |
| 0.0% | 1.0ms | 0.0% | 1.0ms | `_ensureTagCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5607` |
| 0.0% | 913us | 0.0% | 913us | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3553` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 100.0% | 6.39s | 0.0% | 1.6ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 100.0% | 2.78s | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 100.0% | 2.78s | 0.0% | 1.4ms | `parseModule` | `[native code]` |
| 99.8% | 2.77s | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` |
| 99.8% | 2.77s | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` |
| 96.3% | 2.68s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7468` |
| 88.0% | 2.44s | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:66` |
| 84.0% | 2.33s | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4639` |
| 84.0% | 2.33s | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7184` |
| 80.6% | 2.24s | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` |
| 40.1% | 1.11s | 5.0% | 139.2ms | `some` | `[native code]` |
| 32.8% | 914.5ms | 0.1% | 4.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 31.0% | 863.9ms | 0.0% | 1.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` |
| 30.3% | 843.5ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` |
| 29.9% | 831.5ms | 19.4% | 541.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 11.9% | 332.8ms | 0.2% | 7.3ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 9.9% | 275.6ms | 0.4% | 12.4ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 8.4% | 234.2ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:62` |
| 8.3% | 233.1ms | 7.4% | 207.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6950` |
| 7.3% | 203.3ms | 7.3% | 203.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1203` |
| 6.2% | 172.6ms | 6.2% | 172.6ms | `push` | `[native code]` |
| 5.9% | 166.1ms | 5.9% | 166.1ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3133` |
| 4.9% | 138.0ms | 1.3% | 37.3ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` |
| 4.7% | 131.9ms | 3.5% | 99.8ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3135` |
| 4.4% | 123.7ms | 0.4% | 12.9ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` |
| 3.9% | 110.8ms | 3.9% | 110.8ms | `Set` | `[native code]` |
| 3.3% | 93.4ms | 0.0% | 0us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1894` |
| 3.3% | 93.4ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` |
| 3.1% | 88.6ms | 3.1% | 88.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1178` |
| 2.9% | 80.9ms | 0.0% | 0us | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 2.8% | 78.6ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:59` |
| 2.6% | 74.3ms | 0.2% | 7.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 2.6% | 74.3ms | 2.6% | 74.3ms | `parse` | `[native code]` |
| 2.6% | 73.6ms | 2.5% | 70.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3139` |
| 2.6% | 72.6ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` |
| 2.5% | 70.1ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2669` |
| 2.1% | 59.7ms | 0.5% | 14.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 2.0% | 58.1ms | 0.7% | 19.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3136` |
| 1.9% | 53.8ms | 1.9% | 53.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6706` |
| 1.9% | 53.0ms | 1.8% | 51.2ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:579` |
| 1.6% | 45.0ms | 1.6% | 45.0ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 1.5% | 44.3ms | 1.5% | 42.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3087` |
| 1.5% | 41.9ms | 0.4% | 13.0ms | `anonymous` | `[native code]` |
| 1.3% | 37.7ms | 0.2% | 6.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1192` |
| 1.3% | 37.4ms | 0.0% | 0us | `bound require` | `[native code]` |
| 1.3% | 36.9ms | 1.3% | 36.9ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3113` |
| 1.2% | 35.2ms | 0.0% | 0us | `require` | `[native code]` |
| 1.2% | 35.0ms | 0.0% | 1.6ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:953` |
| 1.1% | 32.5ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2833` |
| 1.1% | 31.9ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:845` |
| 1.0% | 29.8ms | 1.0% | 29.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3997` |
| 0.9% | 27.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` |
| 0.9% | 26.0ms | 0.7% | 21.9ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` |
| 0.9% | 25.7ms | 0.5% | 14.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3132` |
| 0.8% | 24.5ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` |
| 0.8% | 24.1ms | 0.0% | 1.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2840` |
| 0.8% | 23.2ms | 0.0% | 1.4ms | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 0.8% | 22.2ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2829` |
| 0.7% | 21.5ms | 0.3% | 11.0ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2673` |
| 0.7% | 21.4ms | 0.0% | 0us | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` |
| 0.6% | 18.2ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2083` |
| 0.6% | 17.1ms | 0.2% | 7.6ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` |
| 0.5% | 16.1ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2062` |
| 0.5% | 15.7ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6948` |
| 0.5% | 15.6ms | 0.5% | 15.6ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4876` |
| 0.5% | 15.1ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2182` |
| 0.5% | 14.6ms | 0.1% | 3.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4013` |
| 0.5% | 14.2ms | 0.3% | 10.1ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.5% | 14.2ms | 0.5% | 14.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3106` |
| 0.4% | 13.7ms | 0.0% | 1.5ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 0.4% | 13.5ms | 0.2% | 5.7ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` |
| 0.4% | 13.0ms | 0.4% | 11.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4000` |
| 0.4% | 12.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` |
| 0.4% | 12.8ms | 0.4% | 12.8ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` |
| 0.4% | 12.7ms | 0.4% | 12.7ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:620` |
| 0.4% | 12.2ms | 0.0% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2209` |
| 0.4% | 12.1ms | 0.1% | 4.6ms | `forEach` | `[native code]` |
| 0.4% | 11.9ms | 0.2% | 5.8ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` |
| 0.3% | 10.9ms | 0.3% | 9.3ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.3% | 10.6ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:46` |
| 0.3% | 10.6ms | 0.2% | 7.3ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.3% | 10.5ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1683` |
| 0.3% | 10.4ms | 0.3% | 10.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7118` |
| 0.3% | 10.3ms | 0.0% | 0us | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2759` |
| 0.3% | 10.1ms | 0.2% | 5.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` |
| 0.3% | 9.7ms | 0.3% | 9.7ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.3% | 9.6ms | 0.2% | 7.9ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.3% | 9.1ms | 0.3% | 9.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4022` |
| 0.3% | 9.1ms | 0.3% | 9.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1225` |
| 0.3% | 9.0ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` |
| 0.2% | 8.1ms | 0.2% | 8.1ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1008` |
| 0.2% | 8.1ms | 0.2% | 8.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7117` |
| 0.2% | 8.0ms | 0.0% | 1.6ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2778` |
| 0.2% | 7.7ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:752` |
| 0.2% | 7.7ms | 0.2% | 7.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2013` |
| 0.2% | 7.7ms | 0.2% | 7.7ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.2% | 7.5ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` |
| 0.2% | 7.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:458` |
| 0.2% | 7.3ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:957` |
| 0.2% | 7.3ms | 0.0% | 0us | `_ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:924` |
| 0.2% | 7.2ms | 0.1% | 2.8ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:869` |
| 0.2% | 7.0ms | 0.2% | 7.0ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6445` |
| 0.2% | 7.0ms | 0.2% | 7.0ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6443` |
| 0.2% | 6.4ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:576` |
| 0.2% | 6.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` |
| 0.2% | 6.4ms | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` |
| 0.2% | 6.4ms | 0.2% | 6.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6949` |
| 0.2% | 6.2ms | 0.2% | 6.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 6.2ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` |
| 0.2% | 6.1ms | 0.2% | 6.1ms | `/^\s*exported\b/` | `[native code]` |
| 0.2% | 6.1ms | 0.2% | 6.1ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` |
| 0.2% | 6.0ms | 0.2% | 6.0ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.2% | 6.0ms | 0.2% | 6.0ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3121` |
| 0.2% | 5.9ms | 0.2% | 5.9ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2730` |
| 0.2% | 5.7ms | 0.0% | 1.3ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3151` |
| 0.2% | 5.6ms | 0.2% | 5.6ms | `test` | `[native code]` |
| 0.1% | 5.0ms | 0.1% | 5.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6951` |
| 0.1% | 4.7ms | 0.1% | 3.4ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.1% | 4.7ms | 0.1% | 4.7ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 4.5ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4078` |
| 0.1% | 4.5ms | 0.1% | 2.8ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` |
| 0.1% | 4.4ms | 0.0% | 1.4ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:561` |
| 0.1% | 4.3ms | 0.1% | 2.9ms | `map` | `[native code]` |
| 0.1% | 4.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.1% | 4.2ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:442` |
| 0.1% | 4.2ms | 0.1% | 4.2ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4260` |
| 0.1% | 4.2ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` |
| 0.1% | 3.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` |
| 0.1% | 3.5ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:551` |
| 0.1% | 3.5ms | 0.0% | 1.7ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` |
| 0.1% | 3.5ms | 0.1% | 3.5ms | `slice` | `[native code]` |
| 0.1% | 3.4ms | 0.1% | 3.4ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` |
| 0.1% | 3.4ms | 0.1% | 3.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6695` |
| 0.1% | 3.4ms | 0.0% | 1.7ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2864` |
| 0.1% | 3.4ms | 0.1% | 3.4ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 3.4ms | 0.1% | 3.4ms | `set` | `[native code]` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4019` |
| 0.1% | 3.3ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2067` |
| 0.1% | 3.3ms | 0.0% | 1.5ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2788` |
| 0.1% | 3.2ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` |
| 0.1% | 3.2ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3872` |
| 0.1% | 3.2ms | 0.0% | 0us | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2919` |
| 0.1% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` |
| 0.1% | 3.2ms | 0.0% | 1.3ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:819` |
| 0.1% | 3.2ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2025` |
| 0.1% | 3.2ms | 0.0% | 0us | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:803` |
| 0.1% | 3.2ms | 0.0% | 1.7ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` |
| 0.1% | 3.1ms | 0.0% | 0us | `get identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:756` |
| 0.1% | 3.1ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2218` |
| 0.1% | 3.0ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2163` |
| 0.1% | 3.0ms | 0.0% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2221` |
| 0.1% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3894` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` |
| 0.1% | 2.9ms | 0.0% | 0us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1340` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:665` |
| 0.1% | 2.9ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1702` |
| 0.1% | 2.9ms | 0.0% | 1.5ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2589` |
| 0.1% | 2.8ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2316` |
| 0.1% | 2.8ms | 0.0% | 1.2ms | `exec` | `[native code]` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `get eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:738` |
| 0.0% | 2.7ms | 0.0% | 1.3ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:972` |
| 0.0% | 2.7ms | 0.0% | 0us | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2585` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:647` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1179` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1185` |
| 0.0% | 2.5ms | 0.0% | 1.2ms | `readFileSync` | `[native code]` |
| 0.0% | 2.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` |
| 0.0% | 2.1ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2693` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2225` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1006` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3130` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4050` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:782` |
| 0.0% | 1.7ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2670` |
| 0.0% | 1.7ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:45` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2582` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:512` |
| 0.0% | 1.7ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:655` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:581` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2742` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6710` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1230` |
| 0.0% | 1.7ms | 0.0% | 0us | `describeRule` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:30` |
| 0.0% | 1.7ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4299` |
| 0.0% | 1.7ms | 0.0% | 0us | `_getPlugin` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:60` |
| 0.0% | 1.7ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7467` |
| 0.0% | 1.7ms | 0.0% | 0us | `_loadFromDisk` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:69` |
| 0.0% | 1.7ms | 0.0% | 0us | `tryParse` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:126` |
| 0.0% | 1.6ms | 0.0% | 0us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:92` |
| 0.0% | 1.6ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:215` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `encodeInto` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2219` |
| 0.0% | 1.6ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:51` |
| 0.0% | 1.6ms | 0.0% | 0us | `computeGlobals` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:298` |
| 0.0% | 1.6ms | 0.0% | 0us | `_filteredBuiltins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:280` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2723` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1188` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6436` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:803` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_getTypeProto` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6910` |
| 0.0% | 1.6ms | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3807` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3807` |
| 0.0% | 1.6ms | 0.0% | 0us | `replace` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1288` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2426` |
| 0.0% | 1.5ms | 0.0% | 0us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1231` |
| 0.0% | 1.5ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1481` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3892` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1993` |
| 0.0% | 1.5ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:776` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` |
| 0.0% | 1.5ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2137` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:752` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:744` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:425` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2428` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1298` |
| 0.0% | 1.4ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:880` |
| 0.0% | 1.4ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:967` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2211` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6817` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:846` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2098` |
| 0.0% | 1.4ms | 0.0% | 0us | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2891` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `scope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:745` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2743` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:226` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3152` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isRead` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:867` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3992` |
| 0.0% | 1.3ms | 0.0% | 0us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:689` |
| 0.0% | 1.3ms | 0.0% | 0us | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:494` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3600` |
| 0.0% | 1.3ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:661` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2208` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1010` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3123` |
| 0.0% | 1.3ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2318` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` |
| 0.0% | 1.2ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1703` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn-jsx/index.js:3` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:35` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get kind` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:887` |
| 0.0% | 1.1ms | 0.0% | 0us | `node:fs/promises` | `node:fs/promises:2` |
| 0.0% | 1.1ms | 0.0% | 0us | `internal:fs/glob` | `internal:fs/glob:2` |
| 0.0% | 1.1ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7463` |
| 0.0% | 1.1ms | 0.0% | 1.1ms | `decode` | `[native code]` |
| 0.0% | 1.1ms | 0.0% | 0us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:512` |
| 0.0% | 1.0ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5984` |
| 0.0% | 1.0ms | 0.0% | 1.0ms | `_ensureTagCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5607` |
| 0.0% | 913us | 0.0% | 913us | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3553` |
| 0.0% | 913us | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1485` |
| 0.0% | 913us | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2077` |

## Function Details

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` | Self: 19.4% (541.3ms) | Total: 29.9% (831.5ms) | Samples: 357

**Called by:**
- `some` (549)

**Calls:**
- `get parent` (134)
- `get parent` (52)
- `get parent` (3)
- `get parent` (2)
- `get parent` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6950` | Self: 7.4% (207.7ms) | Total: 8.3% (233.1ms) | Samples: 138

**Called by:**
- `runPlugins` (154)

**Calls:**
- `get allSkipped` (10)
- `get allSkipped` (6)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1203` | Self: 7.3% (203.3ms) | Total: 7.3% (203.3ms) | Samples: 134

**Called by:**
- `(anonymous)` (134)

### `push`
`[native code]` | Self: 6.2% (172.6ms) | Total: 6.2% (172.6ms) | Samples: 111

**Called by:**
- `getDeclaredVariables` (63)
- `getDeclaredVariables` (26)
- `getDeclaredVariables` (21)
- `_filteredBuiltins` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3133` | Self: 5.9% (166.1ms) | Total: 5.9% (166.1ms) | Samples: 109

**Called by:**
- `isAfterLastUsedArg` (109)

### `some`
`[native code]` | Self: 5.0% (139.2ms) | Total: 40.1% (1.11s) | Samples: 95

**Called by:**
- `collectUnusedVariables` (551)
- `isUsedVariable` (172)
- `collectUnusedVariables` (12)
- `isAfterLastUsedArg` (5)

**Calls:**
- `(anonymous)` (549)
- `(anonymous)` (49)
- `(anonymous)` (18)
- `(anonymous)` (17)
- `(anonymous)` (8)
- `(anonymous)` (4)

### `Set`
`[native code]` | Self: 3.9% (110.8ms) | Total: 3.9% (110.8ms) | Samples: 70

**Called by:**
- `getDeclaredVariables` (70)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3135` | Self: 3.5% (99.8ms) | Total: 4.7% (131.9ms) | Samples: 66

**Called by:**
- `isAfterLastUsedArg` (87)

**Calls:**
- `push` (21)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1178` | Self: 3.1% (88.6ms) | Total: 3.1% (88.6ms) | Samples: 59

**Called by:**
- `(anonymous)` (52)
- `collectUnusedVariables` (2)
- `isReadForItself` (1)
- `collectUnusedVariables` (1)
- `isForInOfRef` (1)
- `collectUnusedVariables` (1)
- `_buildReference` (1)

### `parse`
`[native code]` | Self: 2.6% (74.3ms) | Total: 2.6% (74.3ms) | Samples: 50

**Called by:**
- `parseSource` (49)
- `tryParse` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3139` | Self: 2.5% (70.2ms) | Total: 2.6% (73.6ms) | Samples: 47

**Called by:**
- `isAfterLastUsedArg` (48)
- `isAfterLastUsedArg` (1)

**Calls:**
- `set` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6706` | Self: 1.9% (53.8ms) | Total: 1.9% (53.8ms) | Samples: 34

**Called by:**
- `runPlugins` (34)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:579` | Self: 1.8% (51.2ms) | Total: 1.9% (53.0ms) | Samples: 34

**Called by:**
- `_precomputeScopes` (35)

**Calls:**
- `slice` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` | Self: 1.6% (45.0ms) | Total: 1.6% (45.0ms) | Samples: 30

**Called by:**
- `(anonymous)` (30)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3087` | Self: 1.5% (42.7ms) | Total: 1.5% (44.3ms) | Samples: 27

**Called by:**
- `isAfterLastUsedArg` (28)

**Calls:**
- `_ensureDeclSymIndex` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` | Self: 1.3% (37.3ms) | Total: 4.9% (138.0ms) | Samples: 25

**Called by:**
- `isAfterLastUsedArg` (88)

**Calls:**
- `push` (63)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3113` | Self: 1.3% (36.9ms) | Total: 1.3% (36.9ms) | Samples: 25

**Called by:**
- `isAfterLastUsedArg` (25)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3997` | Self: 1.0% (29.8ms) | Total: 1.0% (29.8ms) | Samples: 19

**Called by:**
- `get parent` (11)
- `_buildReference` (5)
- `get body` (1)
- `get body` (1)
- `_computeVarDefs` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` | Self: 0.7% (21.9ms) | Total: 0.9% (26.0ms) | Samples: 15

**Called by:**
- `collectUnusedVariables` (18)

**Calls:**
- `get eslintUsed` (2)
- `get eslintUsed` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3136` | Self: 0.7% (19.7ms) | Total: 2.0% (58.1ms) | Samples: 13

**Called by:**
- `isAfterLastUsedArg` (39)

**Calls:**
- `push` (26)

### `get allSkipped`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4876` | Self: 0.5% (15.6ms) | Total: 0.5% (15.6ms) | Samples: 10

**Called by:**
- `walkNodes` (10)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3132` | Self: 0.5% (14.7ms) | Total: 0.9% (25.7ms) | Samples: 10

**Called by:**
- `isAfterLastUsedArg` (17)

**Calls:**
- `defs` (7)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` | Self: 0.5% (14.5ms) | Total: 2.1% (59.7ms) | Samples: 9

**Called by:**
- `collectUnusedVariables` (27)
- `Program:exit` (12)

**Calls:**
- `get` (23)
- `get` (5)
- `get` (2)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3106` | Self: 0.5% (14.2ms) | Total: 0.5% (14.2ms) | Samples: 9

**Called by:**
- `isAfterLastUsedArg` (9)

### `anonymous`
`[native code]` | Self: 0.4% (13.0ms) | Total: 1.5% (41.9ms) | Samples: 9

**Called by:**
- `require` (23)
- `bound require` (2)
- `node:fs` (2)
- `internal:fs/glob` (1)
- `node:fs/promises` (1)

**Calls:**
- `(anonymous)` (5)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `node:fs` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:fs/promises` (1)
- `internal:fs/glob` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` | Self: 0.4% (12.9ms) | Total: 4.4% (123.7ms) | Samples: 8

**Called by:**
- `isAfterLastUsedArg` (78)

**Calls:**
- `Set` (70)

### `isSelfReference`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` | Self: 0.4% (12.8ms) | Total: 0.4% (12.8ms) | Samples: 8

**Called by:**
- `(anonymous)` (8)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:620` | Self: 0.4% (12.7ms) | Total: 0.4% (12.7ms) | Samples: 8

**Called by:**
- `commentsInRange` (4)
- `commentsInRange` (4)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` | Self: 0.4% (12.4ms) | Total: 9.9% (275.6ms) | Samples: 8

**Called by:**
- `collectUnusedVariables` (185)

**Calls:**
- `some` (172)
- `get references` (3)
- `get references` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4000` | Self: 0.4% (11.4ms) | Total: 0.4% (13.0ms) | Samples: 8

**Called by:**
- `_buildReference` (5)
- `_computeVarDefs` (2)
- `get parent` (1)
- `_nodesFromRange` (1)

**Calls:**
- `_getTypeProto` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2673` | Self: 0.3% (11.0ms) | Total: 0.7% (21.5ms) | Samples: 7

**Called by:**
- `getScope` (14)

**Calls:**
- `/^\s*exported\b/` (4)
- `test` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7118` | Self: 0.3% (10.4ms) | Total: 0.3% (10.4ms) | Samples: 7

**Called by:**
- `runPlugins` (7)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` | Self: 0.3% (10.1ms) | Total: 0.5% (14.2ms) | Samples: 7

**Called by:**
- `(anonymous)` (10)

**Calls:**
- `get parent` (2)
- `get parent` (1)

### `get allSkipped`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.3% (9.7ms) | Total: 0.3% (9.7ms) | Samples: 6

**Called by:**
- `walkNodes` (6)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` | Self: 0.3% (9.3ms) | Total: 0.3% (10.9ms) | Samples: 6

**Called by:**
- `collectUnusedVariables` (7)

**Calls:**
- `getDeclaredVariables` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4022` | Self: 0.3% (9.1ms) | Total: 0.3% (9.1ms) | Samples: 6

**Called by:**
- `get parent` (2)
- `_buildReference` (1)
- `_buildScope` (1)
- `_computeVarDefs` (1)
- `_nodesFromRange` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1225` | Self: 0.3% (9.1ms) | Total: 0.3% (9.1ms) | Samples: 6

**Called by:**
- `isForInOfRef` (3)
- `isReadForItself` (2)
- `isForInOfRef` (1)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1008` | Self: 0.2% (8.1ms) | Total: 0.2% (8.1ms) | Samples: 5

**Called by:**
- `_nodeViewRaw` (5)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7117` | Self: 0.2% (8.1ms) | Total: 0.2% (8.1ms) | Samples: 5

**Called by:**
- `runPlugins` (5)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` | Self: 0.2% (7.9ms) | Total: 0.3% (9.6ms) | Samples: 5

**Called by:**
- `collectUnusedVariables` (6)

**Calls:**
- `get parent` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2013` | Self: 0.2% (7.7ms) | Total: 0.2% (7.7ms) | Samples: 5

**Called by:**
- `_buildScopeVarsAndSet` (5)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` | Self: 0.2% (7.7ms) | Total: 0.2% (7.7ms) | Samples: 5

**Called by:**
- `isUsedVariable` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` | Self: 0.2% (7.7ms) | Total: 2.6% (74.3ms) | Samples: 5

**Called by:**
- `some` (49)

**Calls:**
- `getRhsNode` (30)
- `getRhsNode` (8)
- `getRhsNode` (3)
- `getRhsNode` (2)
- `getRhsNode` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` | Self: 0.2% (7.6ms) | Total: 0.6% (17.1ms) | Samples: 5

**Called by:**
- `isAfterLastUsedArg` (11)

**Calls:**
- `_buildVariable` (4)
- `_buildVariable` (1)
- `_buildVariable` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` | Self: 0.2% (7.3ms) | Total: 0.3% (10.6ms) | Samples: 5

**Called by:**
- `(anonymous)` (7)

**Calls:**
- `get parent` (1)
- `get parent` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` | Self: 0.2% (7.3ms) | Total: 11.9% (332.8ms) | Samples: 5

**Called by:**
- `collectUnusedVariables` (219)
- `Program:exit` (3)

**Calls:**
- `isUsedVariable` (185)
- `isUsedVariable` (14)
- `some` (12)
- `isUsedVariable` (4)
- `isUsedVariable` (2)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6445` | Self: 0.2% (7.0ms) | Total: 0.2% (7.0ms) | Samples: 5

**Called by:**
- `walkNodes` (5)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6443` | Self: 0.2% (7.0ms) | Total: 0.2% (7.0ms) | Samples: 5

**Called by:**
- `walkNodes` (5)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6949` | Self: 0.2% (6.4ms) | Total: 0.2% (6.4ms) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1192` | Self: 0.2% (6.3ms) | Total: 1.3% (37.7ms) | Samples: 4

**Called by:**
- `_buildReference` (18)
- `_findDefNode` (3)
- `_computeIsStrict` (2)
- `isForInOfRef` (1)

**Calls:**
- `_nodeViewRaw` (11)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (2)
- `nodeView` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `nodeView` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.2% (6.2ms) | Total: 0.2% (6.2ms) | Samples: 4

**Called by:**
- `(anonymous)` (3)
- `_computeVarDefs` (1)

### `/^\s*exported\b/`
`[native code]` | Self: 0.2% (6.1ms) | Total: 0.2% (6.1ms) | Samples: 4

**Called by:**
- `_precomputeScopes` (4)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` | Self: 0.2% (6.1ms) | Total: 0.2% (6.1ms) | Samples: 4

**Called by:**
- `getRhsNode` (4)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` | Self: 0.2% (6.0ms) | Total: 0.2% (6.0ms) | Samples: 4

**Called by:**
- `collectUnusedVariables` (4)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3121` | Self: 0.2% (6.0ms) | Total: 0.2% (6.0ms) | Samples: 4

**Called by:**
- `isAfterLastUsedArg` (4)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2730` | Self: 0.2% (5.9ms) | Total: 0.2% (5.9ms) | Samples: 4

**Called by:**
- `getDeclaredVariables` (4)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` | Self: 0.2% (5.8ms) | Total: 0.4% (11.9ms) | Samples: 4

**Called by:**
- `(anonymous)` (8)

**Calls:**
- `isInLoop` (4)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` | Self: 0.2% (5.7ms) | Total: 0.4% (13.5ms) | Samples: 4

**Called by:**
- `(anonymous)` (9)

**Calls:**
- `get parent` (3)
- `get parent` (1)
- `get parent` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` | Self: 0.2% (5.7ms) | Total: 0.3% (10.1ms) | Samples: 4

**Called by:**
- `collectUnusedVariables` (7)

**Calls:**
- `get parent` (2)
- `isFunction` (1)

### `test`
`[native code]` | Self: 0.2% (5.6ms) | Total: 0.2% (5.6ms) | Samples: 4

**Called by:**
- `_precomputeScopes` (3)
- `_buildScopeVarsAndSet` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6951` | Self: 0.1% (5.0ms) | Total: 0.1% (5.0ms) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (4.7ms) | Total: 0.1% (4.7ms) | Samples: 3

**Called by:**
- `isUsedVariable` (3)

### `forEach`
`[native code]` | Self: 0.1% (4.6ms) | Total: 0.4% (12.1ms) | Samples: 3

**Called by:**
- `getFunctionDefinitions` (8)

**Calls:**
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` | Self: 0.1% (4.5ms) | Total: 32.8% (914.5ms) | Samples: 3

**Called by:**
- `collectUnusedVariables` (604)

**Calls:**
- `some` (551)
- `get references` (47)
- `get references` (2)
- `get references` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4260` | Self: 0.1% (4.2ms) | Total: 0.1% (4.2ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `slice`
`[native code]` | Self: 0.1% (3.5ms) | Total: 0.1% (3.5ms) | Samples: 2

**Called by:**
- `_buildSymNameCache` (1)
- `commentsInRange` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` | Self: 0.1% (3.4ms) | Total: 0.1% (3.4ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6695` | Self: 0.1% (3.4ms) | Total: 0.1% (3.4ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (3.4ms) | Total: 0.1% (3.4ms) | Samples: 2

**Called by:**
- `get body` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` | Self: 0.1% (3.4ms) | Total: 0.1% (4.7ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (3)

**Calls:**
- `get parent` (1)

### `set`
`[native code]` | Self: 0.1% (3.4ms) | Total: 0.1% (3.4ms) | Samples: 2

**Called by:**
- `getDeclaredVariables` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4019` | Self: 0.1% (3.3ms) | Total: 0.1% (3.3ms) | Samples: 3

**Called by:**
- `_buildReference` (2)
- `_nodesFromRange` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4013` | Self: 0.1% (3.3ms) | Total: 0.5% (14.6ms) | Samples: 2

**Called by:**
- `_computeVarDefs` (3)
- `_buildReference` (2)
- `get parent` (2)
- `get init` (1)
- `_buildScope` (1)

**Calls:**
- `_computeNodeType` (5)
- `_computeNodeType` (1)
- `_computeNodeType` (1)

### `_isChainNode`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3894` | Self: 0.1% (3.0ms) | Total: 0.1% (3.0ms) | Samples: 2

**Called by:**
- `nodeViewChain` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` | Self: 0.1% (2.9ms) | Total: 0.1% (2.9ms) | Samples: 2

**Called by:**
- `forEach` (2)

### `extraFnData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:665` | Self: 0.1% (2.9ms) | Total: 0.1% (2.9ms) | Samples: 2

**Called by:**
- `get body` (2)

### `map`
`[native code]` | Self: 0.1% (2.9ms) | Total: 0.1% (4.3ms) | Samples: 2

**Called by:**
- `getDeclaredVariables` (3)

**Calls:**
- `(anonymous)` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2589` | Self: 0.1% (2.9ms) | Total: 0.1% (2.9ms) | Samples: 2

**Called by:**
- `_ensureChildren` (2)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:869` | Self: 0.1% (2.8ms) | Total: 0.2% (7.2ms) | Samples: 2

**Called by:**
- `get body` (4)
- `get value` (1)

**Calls:**
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` | Self: 0.1% (2.8ms) | Total: 0.1% (4.5ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (3)

**Calls:**
- `get parent` (1)

### `get eslintUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:738` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (2)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:647` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1179` | Self: 0.0% (2.6ms) | Total: 0.0% (2.6ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` | Self: 0.0% (2.6ms) | Total: 0.0% (2.6ms) | Samples: 2

**Called by:**
- `_precomputeScopes` (2)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1185` | Self: 0.0% (2.6ms) | Total: 0.0% (2.6ms) | Samples: 2

**Called by:**
- `(anonymous)` (1)
- `_buildReference` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2693` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2225` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3130` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1006` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `isInside` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4050` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `get parent` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` | Self: 0.0% (1.7ms) | Total: 0.1% (3.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `isRead` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:782` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2864` | Self: 0.0% (1.7ms) | Total: 0.1% (3.4ms) | Samples: 1

**Called by:**
- `get references` (2)

**Calls:**
- `get parent` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2670` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getScope` (1)

### `isInside`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` | Self: 0.0% (1.7ms) | Total: 0.1% (3.5ms) | Samples: 1

**Called by:**
- `getRhsNode` (2)

**Calls:**
- `get range` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2582` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_ensureChildren` (1)

### `isUnusedExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:512` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `isReadForItself` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:581` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `get parent` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` | Self: 0.0% (1.7ms) | Total: 31.0% (863.9ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (562)

**Calls:**
- `isAfterLastUsedArg` (549)
- `isAfterLastUsedArg` (7)
- `isAfterLastUsedArg` (5)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2742` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6710` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1230` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `encodeInto`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_encodeSource` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:953` | Self: 0.0% (1.6ms) | Total: 1.2% (35.0ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (23)

**Calls:**
- `_ensureVarsSet` (21)
- `_ensureVarsSet` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2219` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2723` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6436` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1188` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:803` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `report` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2778` | Self: 0.0% (1.6ms) | Total: 0.2% (8.0ms) | Samples: 1

**Called by:**
- `defs` (5)

**Calls:**
- `_findDefNode` (4)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` | Self: 0.0% (1.6ms) | Total: 100.0% (6.39s) | Samples: 1

**Called by:**
- `collectUnusedVariables` (2724)
- `Program:exit` (1459)

**Calls:**
- `collectUnusedVariables` (2724)
- `collectUnusedVariables` (604)
- `collectUnusedVariables` (562)
- `collectUnusedVariables` (219)
- `collectUnusedVariables` (27)
- `collectUnusedVariables` (18)
- `collectUnusedVariables` (7)
- `collectUnusedVariables` (6)
- `collectUnusedVariables` (6)
- `collectUnusedVariables` (3)
- `collectUnusedVariables` (3)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)

### `_getTypeProto`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6910` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3807` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `replace` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1288` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2426` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `/\/\*([\s\S]*?)\*\//g`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `exec` (1)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` | Self: 0.0% (1.5ms) | Total: 0.4% (13.7ms) | Samples: 1

**Called by:**
- `isUsedVariable` (9)

**Calls:**
- `forEach` (8)

### `_isChainNode`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3892` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `nodeViewChain` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1993` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2788` | Self: 0.0% (1.5ms) | Total: 0.1% (3.3ms) | Samples: 1

**Called by:**
- `defs` (2)

**Calls:**
- `get parent` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:752` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `get name` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `get parent` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` | Self: 0.0% (1.5ms) | Total: 0.1% (2.9ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (2)

**Calls:**
- `_computeVariableSynthRefs` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:744` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `isFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:425` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:561` | Self: 0.0% (1.4ms) | Total: 0.1% (4.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `nodeViewChain` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2428` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1298` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `isForInOfRef` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2211` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` | Self: 0.0% (1.4ms) | Total: 0.8% (23.2ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (7)
- `collectUnusedVariables` (6)
- `get identifiers` (2)

**Calls:**
- `_computeVarDefs` (7)
- `_computeVarDefs` (5)
- `_computeVarDefs` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6817` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:846` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2098` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `scope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:745` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_computeVariableSynthRefs` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2743` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2221` | Self: 0.0% (1.4ms) | Total: 0.1% (3.0ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (2)

**Calls:**
- `get identifiers` (1)

### `parseModule`
`[native code]` | Self: 0.0% (1.4ms) | Total: 100.0% (2.78s) | Samples: 1

**Called by:**
- `async (anonymous)` (1827)

**Calls:**
- `(anonymous)` (1823)
- `(anonymous)` (2)
- `(anonymous)` (1)

### `_resolveUnicodeEscapes`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:226` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get name` (1)

### `isRead`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `isReadForItself` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:867` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get body` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3992` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get parent` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3151` | Self: 0.0% (1.3ms) | Total: 0.2% (5.7ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (4)

**Calls:**
- `map` (3)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:819` | Self: 0.0% (1.3ms) | Total: 0.1% (3.2ms) | Samples: 1

**Called by:**
- `_symName` (2)

**Calls:**
- `slice` (1)

### `range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3600` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `isInside` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2208` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1010` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3123` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `get eslintUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `forEach` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:972` | Self: 0.0% (1.3ms) | Total: 0.0% (2.7ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (2)

**Calls:**
- `_ensureVarsSet` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2840` | Self: 0.0% (1.3ms) | Total: 0.8% (24.1ms) | Samples: 1

**Called by:**
- `get references` (16)

**Calls:**
- `_buildScope` (8)
- `_buildScope` (4)
- `_buildScope` (2)
- `_buildScope` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2209` | Self: 0.0% (1.3ms) | Total: 0.4% (12.2ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (8)

**Calls:**
- `_ensureDeclSymIndex` (5)
- `_ensureDeclSymIndex` (2)

### `exec`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.1% (2.8ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (2)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (1)

### `readFileSync`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (2.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)
- `readFileSync` (1)

**Calls:**
- `readFileSync` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` | Self: 0.0% (1.2ms) | Total: 0.8% (24.5ms) | Samples: 1

**Called by:**
- `some` (17)

**Calls:**
- `isReadForItself` (10)
- `isReadForItself` (2)
- `isReadForItself` (2)
- `isReadForItself` (1)
- `isReadForItself` (1)

### `get kind`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `decode`
`[native code]` | Self: 0.0% (1.1ms) | Total: 0.0% (1.1ms) | Samples: 1

**Called by:**
- `get source` (1)

### `_ensureTagCaches`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5607` | Self: 0.0% (1.0ms) | Total: 0.0% (1.0ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3553` | Self: 0.0% (913us) | Total: 0.0% (913us) | Samples: 1

**Called by:**
- `get value` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:46` | Self: 0.0% (0us) | Total: 0.3% (10.6ms) | Samples: 0

**Called by:**
- `async (anonymous)` (7)

**Calls:**
- `bound require` (7)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:576` | Self: 0.0% (0us) | Total: 0.2% (6.4ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (4)

**Calls:**
- `_findLineIdx` (4)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` | Self: 0.0% (0us) | Total: 0.2% (7.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `bound require` (5)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7184` | Self: 0.0% (0us) | Total: 84.0% (2.33s) | Samples: 0

**Called by:**
- `runPlugins` (1537)

**Calls:**
- `_invokeFused` (1537)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` | Self: 0.0% (0us) | Total: 0.2% (6.4ms) | Samples: 0

**Called by:**
- `some` (4)

**Calls:**
- `get references` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` | Self: 0.0% (0us) | Total: 99.8% (2.77s) | Samples: 0

**Called by:**
- `parseModule` (1823)

**Calls:**
- `async (anonymous)` (1823)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:442` | Self: 0.0% (0us) | Total: 0.1% (4.2ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `CfgGraph` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` | Self: 0.0% (0us) | Total: 0.2% (6.4ms) | Samples: 0

**Called by:**
- `_computeVarDefs` (4)

**Calls:**
- `get parent` (3)
- `get parent` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1481` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `get parent` (1)

**Calls:**
- `_nodesFromRange` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4078` | Self: 0.0% (0us) | Total: 0.1% (4.5ms) | Samples: 0

**Called by:**
- `getRhsNode` (2)
- `get init` (1)

**Calls:**
- `_isChainNode` (2)
- `_isChainNode` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` | Self: 0.0% (0us) | Total: 3.3% (93.4ms) | Samples: 0

**Called by:**
- `_invokeFused` (61)

**Calls:**
- `getScope` (61)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1340` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `_buildScope` (1)
- `(anonymous)` (1)

**Calls:**
- `_identAt` (1)
- `_resolveUnicodeEscapes` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7468` | Self: 0.0% (0us) | Total: 96.3% (2.68s) | Samples: 0

**Called by:**
- `async (anonymous)` (1609)
- `async (anonymous)` (152)

**Calls:**
- `walkNodes` (1537)
- `walkNodes` (154)
- `walkNodes` (34)
- `walkNodes` (11)
- `walkNodes` (7)
- `walkNodes` (5)
- `walkNodes` (4)
- `walkNodes` (3)
- `walkNodes` (2)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2077` | Self: 0.0% (0us) | Total: 0.0% (913us) | Samples: 0

**Called by:**
- `_buildScope` (1)

**Calls:**
- `get value` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4639` | Self: 0.0% (0us) | Total: 84.0% (2.33s) | Samples: 0

**Called by:**
- `walkNodes` (1537)

**Calls:**
- `Program:exit` (1474)
- `Program:exit` (61)
- `Program:exit` (2)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:51` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `computeGlobals` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2829` | Self: 0.0% (0us) | Total: 0.8% (22.2ms) | Samples: 0

**Called by:**
- `get references` (14)
- `_ensureVarsSet` (1)

**Calls:**
- `_nodeViewRaw` (5)
- `_nodeViewRaw` (5)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1703` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `node:fs/promises`
`node:fs/promises:2` | Self: 0.0% (0us) | Total: 0.0% (1.1ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4299` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `describeRule` (1)

### `get identifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:756` | Self: 0.0% (0us) | Total: 0.1% (3.1ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)
- `collectUnusedVariables` (1)

**Calls:**
- `defs` (2)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` | Self: 0.0% (0us) | Total: 2.9% (80.9ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (47)
- `(anonymous)` (4)
- `isUsedVariable` (2)

**Calls:**
- `_buildReference` (21)
- `_buildReference` (16)
- `_buildReference` (14)
- `_buildReference` (2)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:66` | Self: 0.0% (0us) | Total: 88.0% (2.44s) | Samples: 0

**Called by:**
- `async (anonymous)` (1609)

**Calls:**
- `runPlugins` (1609)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:887` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `get kind` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2067` | Self: 0.0% (0us) | Total: 0.1% (3.3ms) | Samples: 0

**Called by:**
- `_buildReference` (2)

**Calls:**
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` | Self: 0.0% (0us) | Total: 0.9% (27.0ms) | Samples: 0

**Called by:**
- `some` (18)

**Calls:**
- `isForInOfRef` (9)
- `isForInOfRef` (7)
- `isForInOfRef` (1)
- `isForInOfRef` (1)

### `get init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2919` | Self: 0.0% (0us) | Total: 0.1% (3.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `_nodeViewRaw` (1)
- `nodeViewChain` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:880` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `_buildReference` (1)

### `replace`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_execReport` (1)

**Calls:**
- `(anonymous)` (1)

### `describeRule`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (1)

**Calls:**
- `_getPlugin` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2316` | Self: 0.0% (0us) | Total: 0.1% (2.8ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (2)

**Calls:**
- `exec` (2)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:62` | Self: 0.0% (0us) | Total: 8.4% (234.2ms) | Samples: 0

**Called by:**
- `async (anonymous)` (154)

**Calls:**
- `runPlugins` (152)
- `runPlugins` (1)
- `runPlugins` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:752` | Self: 0.0% (0us) | Total: 0.2% (7.7ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (5)

**Calls:**
- `some` (5)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:661` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isInside` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:215` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `_encodeSource` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2137` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_buildReference` (1)

**Calls:**
- `get name` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:458` | Self: 0.0% (0us) | Total: 0.2% (7.5ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `patchAstUtils` (5)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3872` | Self: 0.0% (0us) | Total: 0.1% (3.2ms) | Samples: 0

**Called by:**
- `Program:exit` (2)

**Calls:**
- `_execReport` (1)
- `_execReport` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:967` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `get` (1)

**Calls:**
- `_ensureVarsSet` (1)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1894` | Self: 0.0% (0us) | Total: 3.3% (93.4ms) | Samples: 0

**Called by:**
- `Program:exit` (61)

**Calls:**
- `_precomputeScopes` (46)
- `_precomputeScopes` (14)
- `_precomputeScopes` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` | Self: 0.0% (0us) | Total: 99.8% (2.77s) | Samples: 0

**Called by:**
- `(anonymous)` (1823)

**Calls:**
- `async (anonymous)` (1609)
- `async (anonymous)` (154)
- `async (anonymous)` (51)
- `async (anonymous)` (7)
- `async (anonymous)` (1)
- `async (anonymous)` (1)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:92` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `encodeInto` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2163` | Self: 0.0% (0us) | Total: 0.1% (3.0ms) | Samples: 0

**Called by:**
- `_buildScope` (2)

**Calls:**
- `get parent` (2)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` | Self: 0.0% (0us) | Total: 0.1% (4.2ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `AstView` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2083` | Self: 0.0% (0us) | Total: 0.6% (18.2ms) | Samples: 0

**Called by:**
- `_buildScope` (6)
- `_buildReference` (4)
- `_buildScopeChildren` (2)

**Calls:**
- `_computeIsStrict` (10)
- `_computeIsStrict` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1231` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_findDefNode` (1)

**Calls:**
- `get value` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1702` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (2)

**Calls:**
- `extraFnData` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:35` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `readFileSync` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:776` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `get identifiers` (1)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:512` | Self: 0.0% (0us) | Total: 0.0% (1.1ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `decode` (1)

### `_loadFromDisk`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:69` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_getPlugin` (1)

**Calls:**
- `tryParse` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` | Self: 0.0% (0us) | Total: 0.1% (3.2ms) | Samples: 0

**Called by:**
- `_invokeFused` (2)

**Calls:**
- `report` (2)

### `internal:fs/glob`
`internal:fs/glob:2` | Self: 0.0% (0us) | Total: 0.0% (1.1ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1485` | Self: 0.0% (0us) | Total: 0.0% (913us) | Samples: 0

**Called by:**
- `_buildScope` (1)

**Calls:**
- `get range` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` | Self: 0.0% (0us) | Total: 0.2% (6.2ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (4)

**Calls:**
- `_findLineIdx` (4)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:59` | Self: 0.0% (0us) | Total: 2.8% (78.6ms) | Samples: 0

**Called by:**
- `async (anonymous)` (51)

**Calls:**
- `parseSource` (49)
- `parseSource` (1)
- `parseSource` (1)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 1.2% (35.2ms) | Samples: 0

**Called by:**
- `bound require` (23)

**Calls:**
- `anonymous` (23)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 100.0% (2.78s) | Samples: 0

**Calls:**
- `parseModule` (1827)

### `_ensureChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:924` | Self: 0.0% (0us) | Total: 0.2% (7.3ms) | Samples: 0

**Called by:**
- `get` (5)

**Calls:**
- `_buildScopeChildren` (2)
- `_buildScopeChildren` (2)
- `_buildScopeChildren` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2062` | Self: 0.0% (0us) | Total: 0.5% (16.1ms) | Samples: 0

**Called by:**
- `_buildReference` (8)
- `_buildScope` (3)

**Calls:**
- `_buildScope` (6)
- `_buildScope` (3)
- `_buildScope` (1)
- `_buildScope` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` | Self: 0.0% (0us) | Total: 2.6% (72.6ms) | Samples: 0

**Called by:**
- `async (anonymous)` (49)

**Calls:**
- `parse` (49)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 1.3% (37.4ms) | Samples: 0

**Called by:**
- `async (anonymous)` (7)
- `patchAstUtils` (5)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `async (anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `require` (23)
- `anonymous` (2)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` | Self: 0.0% (0us) | Total: 80.6% (2.24s) | Samples: 0

**Called by:**
- `_invokeFused` (1474)

**Calls:**
- `collectUnusedVariables` (1459)
- `collectUnusedVariables` (12)
- `collectUnusedVariables` (3)

### `_filteredBuiltins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:280` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `computeGlobals` (1)

**Calls:**
- `push` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1683` | Self: 0.0% (0us) | Total: 0.3% (10.5ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (6)
- `isForInOfRef` (1)

**Calls:**
- `_nodesFromRange` (4)
- `_nodesFromRange` (2)
- `_nodesFromRange` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` | Self: 0.0% (0us) | Total: 0.0% (2.1ms) | Samples: 0

**Called by:**
- `parseModule` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` | Self: 0.0% (0us) | Total: 0.4% (12.8ms) | Samples: 0

**Called by:**
- `some` (8)

**Calls:**
- `isSelfReference` (8)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3807` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `report` (1)

**Calls:**
- `replace` (1)

### `tryParse`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:126` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_loadFromDisk` (1)

**Calls:**
- `parse` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.1% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` | Self: 0.0% (0us) | Total: 0.3% (9.0ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (6)

**Calls:**
- `defs` (6)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:689` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get body` (1)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.0% (2.1ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `anonymous` (2)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7463` | Self: 0.0% (0us) | Total: 0.0% (1.1ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `get source` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` | Self: 0.0% (0us) | Total: 0.7% (21.4ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (14)

**Calls:**
- `getFunctionDefinitions` (9)
- `getFunctionDefinitions` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3152` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `get name` (1)

### `computeGlobals`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:298` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `_filteredBuiltins` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2759` | Self: 0.0% (0us) | Total: 0.3% (10.3ms) | Samples: 0

**Called by:**
- `defs` (7)

**Calls:**
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2891` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `get references` (1)

**Calls:**
- `scope` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5984` | Self: 0.0% (0us) | Total: 0.0% (1.0ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_ensureTagCaches` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2585` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `_ensureChildren` (2)

**Calls:**
- `_buildScope` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.1% (4.3ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:845` | Self: 0.0% (0us) | Total: 1.1% (31.9ms) | Samples: 0

**Called by:**
- `get` (21)

**Calls:**
- `_buildScopeVarsAndSet` (8)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:45` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `bound require` (1)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:803` | Self: 0.0% (0us) | Total: 0.1% (3.2ms) | Samples: 0

**Called by:**
- `_ensureDeclSymIndex` (2)

**Calls:**
- `_buildSymNameCache` (2)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:957` | Self: 0.0% (0us) | Total: 0.2% (7.3ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (5)

**Calls:**
- `_ensureChildren` (5)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2025` | Self: 0.0% (0us) | Total: 0.1% (3.2ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (2)

**Calls:**
- `_symName` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` | Self: 0.0% (0us) | Total: 0.1% (3.2ms) | Samples: 0

**Called by:**
- `forEach` (2)

**Calls:**
- `get init` (2)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` | Self: 0.0% (0us) | Total: 30.3% (843.5ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (549)

**Calls:**
- `getDeclaredVariables` (109)
- `getDeclaredVariables` (88)
- `getDeclaredVariables` (87)
- `getDeclaredVariables` (78)
- `getDeclaredVariables` (48)
- `getDeclaredVariables` (39)
- `getDeclaredVariables` (28)
- `getDeclaredVariables` (25)
- `getDeclaredVariables` (17)
- `getDeclaredVariables` (11)
- `getDeclaredVariables` (9)
- `getDeclaredVariables` (4)
- `getDeclaredVariables` (4)
- `getDeclaredVariables` (1)
- `getDeclaredVariables` (1)

### `_getPlugin`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:60` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `describeRule` (1)

**Calls:**
- `_loadFromDisk` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn-jsx/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2669` | Self: 0.0% (0us) | Total: 2.5% (70.1ms) | Samples: 0

**Called by:**
- `getScope` (46)

**Calls:**
- `commentsInRange` (35)
- `commentsInRange` (4)
- `commentsInRange` (4)
- `commentsInRange` (2)
- `commentsInRange` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2318` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `test` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2833` | Self: 0.0% (0us) | Total: 1.1% (32.5ms) | Samples: 0

**Called by:**
- `get references` (21)

**Calls:**
- `get parent` (18)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:655` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isUnusedExpression` (1)

### `isInside`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:494` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `isReadForItself` (1)

**Calls:**
- `range` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2218` | Self: 0.0% (0us) | Total: 0.1% (3.1ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (2)

**Calls:**
- `_buildVariable` (1)
- `_buildVariable` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` | Self: 0.0% (0us) | Total: 0.1% (3.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)
- `bound require` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:551` | Self: 0.0% (0us) | Total: 0.1% (3.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `isInside` (2)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2182` | Self: 0.0% (0us) | Total: 0.5% (15.1ms) | Samples: 0

**Called by:**
- `_buildScope` (10)

**Calls:**
- `get body` (6)
- `get body` (2)
- `get body` (1)
- `get body` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6948` | Self: 0.0% (0us) | Total: 0.5% (15.7ms) | Samples: 0

**Called by:**
- `runPlugins` (11)

**Calls:**
- `getDFSEvents` (5)
- `getDFSEvents` (5)
- `getDFSEvents` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7467` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `buildVisitorMap` (1)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 34.7% | 966.2ms | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 27.6% | 768.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 19.5% | 544.9ms | `[native code]` |
| 17.9% | 499.8ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
