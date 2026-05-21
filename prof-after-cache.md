# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 1.87s | 1217 | 1.0ms | 282 |

**Top 10:** `(anonymous)` 10.3%, `walkNodes` 10.1%, `push` 6.8%, `_computeDeclaredVariables` 5.0%, `some` 4.2%, `_computeDeclaredVariables` 4.2%, `get parent` 4.1%, `getRhsNode` 3.8%, `parse` 3.6%, `Set` 2.8%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 10.3% | 193.8ms | 16.1% | 301.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 10.1% | 190.9ms | 12.1% | 227.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6975` |
| 6.8% | 128.8ms | 6.8% | 128.8ms | `push` | `[native code]` |
| 5.0% | 94.0ms | 7.8% | 146.4ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3160` |
| 4.2% | 80.1ms | 30.4% | 569.5ms | `some` | `[native code]` |
| 4.2% | 78.6ms | 4.2% | 80.1ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3158` |
| 4.1% | 76.9ms | 4.1% | 76.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1258` |
| 3.8% | 72.6ms | 4.0% | 75.1ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 3.6% | 68.4ms | 3.6% | 68.4ms | `parse` | `[native code]` |
| 2.8% | 53.5ms | 2.8% | 53.5ms | `Set` | `[native code]` |
| 2.8% | 52.4ms | 2.8% | 52.4ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` |
| 2.7% | 51.8ms | 2.7% | 51.8ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:579` |
| 1.8% | 35.4ms | 1.8% | 35.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1178` |
| 1.8% | 35.2ms | 1.8% | 35.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6731` |
| 1.4% | 26.2ms | 1.5% | 29.0ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3164` |
| 1.3% | 24.3ms | 1.3% | 24.3ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4901` |
| 1.0% | 20.4ms | 1.0% | 20.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3997` |
| 0.9% | 17.7ms | 0.9% | 17.7ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.8% | 15.6ms | 0.8% | 15.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7143` |
| 0.8% | 15.1ms | 0.8% | 15.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6976` |
| 0.7% | 14.7ms | 3.1% | 58.9ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 0.7% | 13.7ms | 0.7% | 13.7ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` |
| 0.6% | 13.0ms | 0.6% | 13.0ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.6% | 12.5ms | 0.6% | 12.5ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` |
| 0.6% | 12.2ms | 0.6% | 12.2ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:620` |
| 0.6% | 11.9ms | 0.6% | 11.9ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.5% | 11.0ms | 0.8% | 15.6ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` |
| 0.5% | 10.8ms | 0.5% | 10.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6974` |
| 0.5% | 10.8ms | 0.9% | 17.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.5% | 10.6ms | 0.5% | 10.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3146` |
| 0.5% | 10.4ms | 0.8% | 15.4ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 0.5% | 9.9ms | 0.5% | 9.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4000` |
| 0.5% | 9.7ms | 2.1% | 39.5ms | `anonymous` | `[native code]` |
| 0.5% | 9.7ms | 0.9% | 17.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4013` |
| 0.5% | 9.7ms | 20.5% | 385.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 0.5% | 9.4ms | 16.2% | 304.9ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 0.4% | 9.3ms | 0.4% | 9.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1225` |
| 0.4% | 8.9ms | 13.7% | 257.9ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 0.4% | 8.8ms | 0.5% | 10.6ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` |
| 0.4% | 8.8ms | 2.6% | 48.9ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3162` |
| 0.4% | 8.7ms | 0.4% | 8.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2017` |
| 0.4% | 8.4ms | 0.4% | 8.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.4% | 8.0ms | 0.4% | 8.0ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6470` |
| 0.4% | 7.8ms | 0.4% | 9.3ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.4% | 7.7ms | 0.4% | 7.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3102` |
| 0.4% | 7.6ms | 0.4% | 7.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6720` |
| 0.3% | 7.3ms | 0.7% | 14.0ms | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 0.3% | 7.1ms | 0.6% | 11.6ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` |
| 0.3% | 6.9ms | 0.5% | 11.1ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` |
| 0.3% | 6.7ms | 0.5% | 9.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` |
| 0.3% | 6.5ms | 0.4% | 8.1ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` |
| 0.3% | 6.4ms | 0.3% | 6.4ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:581` |
| 0.3% | 6.3ms | 0.4% | 9.1ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2677` |
| 0.3% | 6.2ms | 0.3% | 6.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4022` |
| 0.3% | 6.0ms | 0.3% | 6.0ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6468` |
| 0.2% | 5.0ms | 0.2% | 5.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1187` |
| 0.2% | 4.9ms | 0.2% | 4.9ms | `isRead` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:220` |
| 0.2% | 4.8ms | 0.2% | 4.8ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1008` |
| 0.2% | 4.7ms | 0.4% | 7.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3157` |
| 0.2% | 4.7ms | 0.4% | 8.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.2% | 4.3ms | 3.0% | 57.9ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` |
| 0.2% | 4.3ms | 0.2% | 4.3ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 4.0ms | 0.2% | 4.0ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2734` |
| 0.1% | 3.5ms | 0.1% | 3.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7142` |
| 0.1% | 3.4ms | 0.2% | 5.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:887` |
| 0.1% | 3.3ms | 0.2% | 4.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2071` |
| 0.1% | 3.3ms | 0.3% | 6.0ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3156` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4260` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3099` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2229` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `get` | `[native code]` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2593` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2846` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.1% | 3.0ms | 2.1% | 39.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3161` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `getUint32` | `[native code]` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `get eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:738` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `set` | `[native code]` |
| 0.1% | 2.7ms | 1.4% | 26.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1192` |
| 0.1% | 2.5ms | 0.1% | 2.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1179` |
| 0.0% | 1.8ms | 0.1% | 3.2ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:540` |
| 0.0% | 1.7ms | 0.7% | 14.3ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3556` |
| 0.0% | 1.7ms | 0.2% | 4.9ms | `forEach` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `symbolToStringify` | `node:os` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `slice` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.1% | 3.4ms | `performProxyObjectGet` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3992` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2815` |
| 0.0% | 1.7ms | 0.1% | 3.1ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2840` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `fill` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.1% | 3.1ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2792` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4053` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1522` |
| 0.0% | 1.6ms | 0.2% | 5.1ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` |
| 0.0% | 1.6ms | 100.0% | 4.66s | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:583` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3123` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `dlopen` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getUpperFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:134` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2868` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1240` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2113` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1676` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1188` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1477` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6735` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.2% | 4.6ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:803` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:738` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `RegExp` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `error` | `[native code]` |
| 0.0% | 1.5ms | 4.4% | 82.4ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2815` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:846` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1189` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:774` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` |
| 0.0% | 1.4ms | 0.2% | 4.4ms | `exec` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isExported` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:358` |
| 0.0% | 1.4ms | 0.1% | 3.2ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2763` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1230` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `/^\s*exported\b/` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2054` |
| 0.0% | 1.3ms | 28.3% | 530.8ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_nodeEndPos` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:881` |
| 0.0% | 1.3ms | 0.1% | 3.0ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2223` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1706` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.1% | 3.0ms | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7485` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `test` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:654` |
| 0.0% | 1.3ms | 25.8% | 484.8ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3101` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.1% | 3.1ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:819` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:37` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:647` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:226` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1491` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:622` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:152` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `freeze` | `[native code]` |
| 0.0% | 1.2ms | 5.2% | 99.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js` |
| 0.0% | 1.0ms | 0.0% | 1.0ms | `decode` | `[native code]` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 100.0% | 4.66s | 0.0% | 1.6ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 100.0% | 1.87s | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 100.0% | 1.87s | 0.0% | 0us | `parseModule` | `[native code]` |
| 99.7% | 1.86s | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` |
| 99.7% | 1.86s | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` |
| 94.8% | 1.77s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7493` |
| 83.1% | 1.55s | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:66` |
| 76.7% | 1.43s | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7209` |
| 76.7% | 1.43s | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4664` |
| 72.0% | 1.34s | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` |
| 30.4% | 569.5ms | 4.2% | 80.1ms | `some` | `[native code]` |
| 28.3% | 530.8ms | 0.0% | 1.3ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` |
| 26.6% | 498.5ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` |
| 25.8% | 484.8ms | 0.0% | 1.3ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3101` |
| 20.5% | 385.0ms | 0.5% | 9.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 16.2% | 304.9ms | 0.5% | 9.4ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 16.1% | 301.6ms | 10.3% | 193.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 13.7% | 257.9ms | 0.4% | 8.9ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 12.1% | 227.2ms | 10.1% | 190.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6975` |
| 11.9% | 224.5ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:62` |
| 7.8% | 146.4ms | 5.0% | 94.0ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3160` |
| 6.8% | 128.8ms | 6.8% | 128.8ms | `push` | `[native code]` |
| 5.2% | 99.0ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 4.5% | 84.2ms | 0.0% | 0us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1898` |
| 4.5% | 84.2ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` |
| 4.4% | 82.4ms | 0.0% | 1.5ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 4.2% | 80.1ms | 4.2% | 78.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3158` |
| 4.1% | 76.9ms | 4.1% | 76.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1258` |
| 4.0% | 75.1ms | 3.8% | 72.6ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 4.0% | 75.1ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2673` |
| 3.8% | 73.0ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:59` |
| 3.6% | 68.4ms | 3.6% | 68.4ms | `parse` | `[native code]` |
| 3.5% | 66.9ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` |
| 3.1% | 58.9ms | 0.7% | 14.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 3.0% | 57.9ms | 0.2% | 4.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` |
| 2.8% | 53.5ms | 2.8% | 53.5ms | `Set` | `[native code]` |
| 2.8% | 52.4ms | 2.8% | 52.4ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` |
| 2.7% | 51.8ms | 2.7% | 51.8ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:579` |
| 2.6% | 48.9ms | 0.4% | 8.8ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3162` |
| 2.1% | 39.5ms | 0.5% | 9.7ms | `anonymous` | `[native code]` |
| 2.1% | 39.3ms | 0.1% | 3.0ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3161` |
| 2.0% | 37.8ms | 0.0% | 0us | `bound require` | `[native code]` |
| 1.8% | 35.4ms | 1.8% | 35.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1178` |
| 1.8% | 35.2ms | 1.8% | 35.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6731` |
| 1.8% | 33.8ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2837` |
| 1.7% | 33.1ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:953` |
| 1.7% | 32.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` |
| 1.6% | 31.1ms | 0.0% | 0us | `require` | `[native code]` |
| 1.6% | 30.3ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:845` |
| 1.5% | 29.0ms | 1.4% | 26.2ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3164` |
| 1.4% | 26.9ms | 0.1% | 2.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1192` |
| 1.3% | 25.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` |
| 1.3% | 24.3ms | 1.3% | 24.3ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4901` |
| 1.1% | 22.4ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2844` |
| 1.0% | 20.4ms | 1.0% | 20.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3997` |
| 0.9% | 18.5ms | 0.0% | 0us | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` |
| 0.9% | 18.3ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6973` |
| 0.9% | 18.1ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2833` |
| 0.9% | 17.7ms | 0.9% | 17.7ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.9% | 17.3ms | 0.5% | 9.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4013` |
| 0.9% | 17.2ms | 0.5% | 10.8ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.8% | 16.3ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2087` |
| 0.8% | 15.6ms | 0.8% | 15.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7143` |
| 0.8% | 15.6ms | 0.5% | 11.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` |
| 0.8% | 15.4ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2066` |
| 0.8% | 15.4ms | 0.5% | 10.4ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 0.8% | 15.1ms | 0.8% | 15.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6976` |
| 0.7% | 14.3ms | 0.0% | 1.7ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` |
| 0.7% | 14.0ms | 0.3% | 7.3ms | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 0.7% | 13.7ms | 0.7% | 13.7ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` |
| 0.7% | 13.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` |
| 0.7% | 13.1ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2186` |
| 0.6% | 13.0ms | 0.6% | 13.0ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.6% | 12.5ms | 0.6% | 12.5ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` |
| 0.6% | 12.2ms | 0.6% | 12.2ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:620` |
| 0.6% | 11.9ms | 0.6% | 11.9ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.6% | 11.8ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2213` |
| 0.6% | 11.6ms | 0.3% | 7.1ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` |
| 0.5% | 11.1ms | 0.3% | 6.9ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` |
| 0.5% | 10.8ms | 0.5% | 10.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6974` |
| 0.5% | 10.6ms | 0.4% | 8.8ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` |
| 0.5% | 10.6ms | 0.5% | 10.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3146` |
| 0.5% | 9.9ms | 0.5% | 9.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4000` |
| 0.5% | 9.8ms | 0.3% | 6.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` |
| 0.5% | 9.6ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:957` |
| 0.5% | 9.6ms | 0.0% | 0us | `_ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:924` |
| 0.4% | 9.3ms | 0.4% | 7.8ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.4% | 9.3ms | 0.4% | 9.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1225` |
| 0.4% | 9.1ms | 0.3% | 6.3ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2677` |
| 0.4% | 9.1ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:46` |
| 0.4% | 8.7ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:576` |
| 0.4% | 8.7ms | 0.4% | 8.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2017` |
| 0.4% | 8.4ms | 0.4% | 8.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.4% | 8.1ms | 0.3% | 6.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` |
| 0.4% | 8.0ms | 0.2% | 4.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.4% | 8.0ms | 0.4% | 8.0ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6470` |
| 0.4% | 7.7ms | 0.4% | 7.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3102` |
| 0.4% | 7.7ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:752` |
| 0.4% | 7.6ms | 0.2% | 4.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3157` |
| 0.4% | 7.6ms | 0.4% | 7.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6720` |
| 0.3% | 7.3ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:747` |
| 0.3% | 6.5ms | 0.0% | 0us | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2589` |
| 0.3% | 6.4ms | 0.3% | 6.4ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:581` |
| 0.3% | 6.3ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` |
| 0.3% | 6.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` |
| 0.3% | 6.2ms | 0.3% | 6.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4022` |
| 0.3% | 6.0ms | 0.3% | 6.0ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6468` |
| 0.3% | 6.0ms | 0.1% | 3.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3156` |
| 0.2% | 5.6ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` |
| 0.2% | 5.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:458` |
| 0.2% | 5.1ms | 0.0% | 1.6ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` |
| 0.2% | 5.1ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1703` |
| 0.2% | 5.0ms | 0.2% | 5.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1187` |
| 0.2% | 5.0ms | 0.1% | 3.4ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:887` |
| 0.2% | 4.9ms | 0.1% | 3.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2071` |
| 0.2% | 4.9ms | 0.0% | 1.7ms | `forEach` | `[native code]` |
| 0.2% | 4.9ms | 0.2% | 4.9ms | `isRead` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:220` |
| 0.2% | 4.8ms | 0.2% | 4.8ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1008` |
| 0.2% | 4.8ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` |
| 0.2% | 4.6ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2081` |
| 0.2% | 4.6ms | 0.0% | 1.5ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:803` |
| 0.2% | 4.4ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2320` |
| 0.2% | 4.4ms | 0.0% | 1.4ms | `exec` | `[native code]` |
| 0.2% | 4.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.2% | 4.3ms | 0.2% | 4.3ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 4.0ms | 0.2% | 4.0ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2734` |
| 0.1% | 3.5ms | 0.1% | 3.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7142` |
| 0.1% | 3.4ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:543` |
| 0.1% | 3.4ms | 0.0% | 1.7ms | `performProxyObjectGet` | `[native code]` |
| 0.1% | 3.3ms | 0.0% | 0us | `get identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:756` |
| 0.1% | 3.3ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2225` |
| 0.1% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.1% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` |
| 0.1% | 3.2ms | 0.0% | 1.8ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4260` |
| 0.1% | 3.2ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:442` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2229` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3099` |
| 0.1% | 3.2ms | 0.0% | 1.4ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2763` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.1% | 3.1ms | 0.0% | 1.7ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2792` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `get` | `[native code]` |
| 0.1% | 3.1ms | 0.0% | 0us | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2919` |
| 0.1% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` |
| 0.1% | 3.1ms | 0.0% | 1.7ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2840` |
| 0.1% | 3.1ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2167` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2593` |
| 0.1% | 3.1ms | 0.0% | 1.3ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:819` |
| 0.1% | 3.1ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2029` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2846` |
| 0.1% | 3.0ms | 0.0% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2223` |
| 0.1% | 3.0ms | 0.0% | 1.3ms | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7485` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `getUint32` | `[native code]` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `get eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:738` |
| 0.1% | 2.7ms | 0.0% | 0us | `map` | `[native code]` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.1% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3177` |
| 0.1% | 2.7ms | 0.0% | 0us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1340` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `set` | `[native code]` |
| 0.1% | 2.5ms | 0.1% | 2.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1179` |
| 0.0% | 1.8ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:45` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 1.8ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:540` |
| 0.0% | 1.7ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1485` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3556` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` |
| 0.0% | 1.7ms | 0.0% | 0us | `node:child_process` | `node:child_process:2` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:14` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `symbolToStringify` | `node:os` |
| 0.0% | 1.7ms | 0.0% | 0us | `node:os` | `node:os:111` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `slice` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3992` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2815` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `fill` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1040` |
| 0.0% | 1.7ms | 0.0% | 0us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3995` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4053` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` |
| 0.0% | 1.6ms | 0.0% | 0us | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2782` |
| 0.0% | 1.6ms | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` |
| 0.0% | 1.6ms | 0.0% | 0us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1231` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1522` |
| 0.0% | 1.6ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:558` |
| 0.0% | 1.6ms | 0.0% | 0us | `get left` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1759` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:583` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3123` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `loadBinding` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` |
| 0.0% | 1.6ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:50` |
| 0.0% | 1.6ms | 0.0% | 0us | `getTagNames` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:186` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `dlopen` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getUpperFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:134` |
| 0.0% | 1.6ms | 0.0% | 0us | `isInsideOfStorableFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:630` |
| 0.0% | 1.6ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:662` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2868` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1240` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2113` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1676` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1188` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1477` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6735` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2222` |
| 0.0% | 1.5ms | 0.0% | 0us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2701` |
| 0.0% | 1.5ms | 0.0% | 0us | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:738` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `RegExp` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:49` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `error` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:70` |
| 0.0% | 1.5ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.0% | 1.4ms | 0.0% | 0us | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2895` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2815` |
| 0.0% | 1.4ms | 0.0% | 0us | `scope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:745` |
| 0.0% | 1.4ms | 0.0% | 0us | `_loadFromDisk` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:69` |
| 0.0% | 1.4ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7492` |
| 0.0% | 1.4ms | 0.0% | 0us | `_getPlugin` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:60` |
| 0.0% | 1.4ms | 0.0% | 0us | `describeRule` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:30` |
| 0.0% | 1.4ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4324` |
| 0.0% | 1.4ms | 0.0% | 0us | `tryParse` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:126` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:846` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1189` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:774` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isExported` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:358` |
| 0.0% | 1.4ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:954` |
| 0.0% | 1.4ms | 0.0% | 0us | `get defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `/^\s*exported\b/` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1230` |
| 0.0% | 1.4ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:880` |
| 0.0% | 1.4ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:972` |
| 0.0% | 1.4ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:967` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2054` |
| 0.0% | 1.3ms | 0.0% | 0us | `isReadRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:431` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_nodeEndPos` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:881` |
| 0.0% | 1.3ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3897` |
| 0.0% | 1.3ms | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3843` |
| 0.0% | 1.3ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1706` |
| 0.0% | 1.3ms | 0.0% | 0us | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3894` |
| 0.0% | 1.3ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4078` |
| 0.0% | 1.3ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:561` |
| 0.0% | 1.3ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1683` |
| 0.0% | 1.3ms | 0.0% | 0us | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:869` |
| 0.0% | 1.3ms | 0.0% | 0us | `_getOrBuildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5563` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6634` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `test` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:654` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:37` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:647` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:226` |
| 0.0% | 1.3ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3176` |
| 0.0% | 1.2ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2227` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1491` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:622` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:152` |
| 0.0% | 1.2ms | 0.0% | 0us | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:427` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:12` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `freeze` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/eslint-visitor-keys/dist/eslint-visitor-keys.cjs:116` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:215` |
| 0.0% | 1.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` |
| 0.0% | 1.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn-jsx/index.js:3` |
| 0.0% | 1.0ms | 0.0% | 1.0ms | `decode` | `[native code]` |
| 0.0% | 1.0ms | 0.0% | 0us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:512` |
| 0.0% | 1.0ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7488` |

## Function Details

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` | Self: 10.3% (193.8ms) | Total: 16.1% (301.6ms) | Samples: 130

**Called by:**
- `some` (201)

**Calls:**
- `get parent` (50)
- `get parent` (15)
- `get parent` (2)
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6975` | Self: 10.1% (190.9ms) | Total: 12.1% (227.2ms) | Samples: 127

**Called by:**
- `runPlugins` (151)

**Calls:**
- `get allSkipped` (16)
- `get allSkipped` (8)

### `push`
`[native code]` | Self: 6.8% (128.8ms) | Total: 6.8% (128.8ms) | Samples: 74

**Called by:**
- `_computeDeclaredVariables` (29)
- `_computeDeclaredVariables` (23)
- `_computeDeclaredVariables` (22)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3160` | Self: 5.0% (94.0ms) | Total: 7.8% (146.4ms) | Samples: 62

**Called by:**
- `getDeclaredVariables` (91)

**Calls:**
- `push` (29)

### `some`
`[native code]` | Self: 4.2% (80.1ms) | Total: 30.4% (569.5ms) | Samples: 53

**Called by:**
- `collectUnusedVariables` (201)
- `isUsedVariable` (160)
- `collectUnusedVariables` (11)
- `isAfterLastUsedArg` (5)

**Calls:**
- `(anonymous)` (201)
- `(anonymous)` (65)
- `(anonymous)` (21)
- `(anonymous)` (17)
- `(anonymous)` (10)
- `(anonymous)` (6)
- `(anonymous)` (4)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3158` | Self: 4.2% (78.6ms) | Total: 4.2% (80.1ms) | Samples: 52

**Called by:**
- `getDeclaredVariables` (53)

**Calls:**
- `get` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1258` | Self: 4.1% (76.9ms) | Total: 4.1% (76.9ms) | Samples: 50

**Called by:**
- `(anonymous)` (50)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` | Self: 3.8% (72.6ms) | Total: 4.0% (75.1ms) | Samples: 48

**Called by:**
- `(anonymous)` (50)

**Calls:**
- `get parent` (1)
- `get parent` (1)

### `parse`
`[native code]` | Self: 3.6% (68.4ms) | Total: 3.6% (68.4ms) | Samples: 45

**Called by:**
- `parseSource` (44)
- `tryParse` (1)

### `Set`
`[native code]` | Self: 2.8% (53.5ms) | Total: 2.8% (53.5ms) | Samples: 35

**Called by:**
- `_computeDeclaredVariables` (35)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` | Self: 2.8% (52.4ms) | Total: 2.8% (52.4ms) | Samples: 33

**Called by:**
- `getDeclaredVariables` (33)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:579` | Self: 2.7% (51.8ms) | Total: 2.7% (51.8ms) | Samples: 33

**Called by:**
- `_precomputeScopes` (33)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1178` | Self: 1.8% (35.4ms) | Total: 1.8% (35.4ms) | Samples: 24

**Called by:**
- `(anonymous)` (15)
- `isForInOfRef` (2)
- `collectUnusedVariables` (2)
- `isReadForItself` (1)
- `collectUnusedVariables` (1)
- `getRhsNode` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6731` | Self: 1.8% (35.2ms) | Total: 1.8% (35.2ms) | Samples: 23

**Called by:**
- `runPlugins` (23)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3164` | Self: 1.4% (26.2ms) | Total: 1.5% (29.0ms) | Samples: 17

**Called by:**
- `getDeclaredVariables` (19)

**Calls:**
- `set` (2)

### `get allSkipped`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4901` | Self: 1.3% (24.3ms) | Total: 1.3% (24.3ms) | Samples: 16

**Called by:**
- `walkNodes` (16)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3997` | Self: 1.0% (20.4ms) | Total: 1.0% (20.4ms) | Samples: 14

**Called by:**
- `get parent` (6)
- `_buildReference` (3)
- `get body` (1)
- `get init` (1)
- `_buildScope` (1)
- `get body` (1)
- `_computeVarDefs` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` | Self: 0.9% (17.7ms) | Total: 0.9% (17.7ms) | Samples: 11

**Called by:**
- `(anonymous)` (11)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7143` | Self: 0.8% (15.6ms) | Total: 0.8% (15.6ms) | Samples: 10

**Called by:**
- `runPlugins` (10)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6976` | Self: 0.8% (15.1ms) | Total: 0.8% (15.1ms) | Samples: 10

**Called by:**
- `runPlugins` (10)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` | Self: 0.7% (14.7ms) | Total: 3.1% (58.9ms) | Samples: 9

**Called by:**
- `collectUnusedVariables` (25)
- `Program:exit` (13)

**Calls:**
- `get` (22)
- `get` (6)
- `get` (1)

### `isSelfReference`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` | Self: 0.7% (13.7ms) | Total: 0.7% (13.7ms) | Samples: 10

**Called by:**
- `(anonymous)` (10)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` | Self: 0.6% (13.0ms) | Total: 0.6% (13.0ms) | Samples: 8

**Called by:**
- `collectUnusedVariables` (8)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` | Self: 0.6% (12.5ms) | Total: 0.6% (12.5ms) | Samples: 8

**Called by:**
- `getRhsNode` (8)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:620` | Self: 0.6% (12.2ms) | Total: 0.6% (12.2ms) | Samples: 8

**Called by:**
- `commentsInRange` (5)
- `commentsInRange` (3)

### `get allSkipped`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.6% (11.9ms) | Total: 0.6% (11.9ms) | Samples: 8

**Called by:**
- `walkNodes` (8)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` | Self: 0.5% (11.0ms) | Total: 0.8% (15.6ms) | Samples: 7

**Called by:**
- `collectUnusedVariables` (10)

**Calls:**
- `get eslintUsed` (2)
- `get eslintUsed` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6974` | Self: 0.5% (10.8ms) | Total: 0.5% (10.8ms) | Samples: 7

**Called by:**
- `runPlugins` (7)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` | Self: 0.5% (10.8ms) | Total: 0.9% (17.2ms) | Samples: 7

**Called by:**
- `collectUnusedVariables` (11)

**Calls:**
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3146` | Self: 0.5% (10.6ms) | Total: 0.5% (10.6ms) | Samples: 7

**Called by:**
- `getDeclaredVariables` (7)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` | Self: 0.5% (10.4ms) | Total: 0.8% (15.4ms) | Samples: 7

**Called by:**
- `isUsedVariable` (10)

**Calls:**
- `forEach` (3)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4000` | Self: 0.5% (9.9ms) | Total: 0.5% (9.9ms) | Samples: 6

**Called by:**
- `_buildReference` (4)
- `get parent` (2)

### `anonymous`
`[native code]` | Self: 0.5% (9.7ms) | Total: 2.1% (39.5ms) | Samples: 6

**Called by:**
- `require` (21)
- `bound require` (3)
- `node:child_process` (1)
- `node:fs` (1)

**Calls:**
- `(anonymous)` (4)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:fs` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:child_process` (1)
- `node:os` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4013` | Self: 0.5% (9.7ms) | Total: 0.9% (17.3ms) | Samples: 6

**Called by:**
- `get parent` (5)
- `_buildReference` (4)
- `get body` (1)
- `get body` (1)

**Calls:**
- `_computeNodeType` (3)
- `_computeNodeType` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` | Self: 0.5% (9.7ms) | Total: 20.5% (385.0ms) | Samples: 6

**Called by:**
- `collectUnusedVariables` (255)

**Calls:**
- `some` (201)
- `get references` (45)
- `get references` (2)
- `get references` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` | Self: 0.5% (9.4ms) | Total: 16.2% (304.9ms) | Samples: 6

**Called by:**
- `collectUnusedVariables` (195)
- `Program:exit` (5)

**Calls:**
- `isUsedVariable` (170)
- `isUsedVariable` (12)
- `some` (11)
- `isUsedVariable` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1225` | Self: 0.4% (9.3ms) | Total: 0.4% (9.3ms) | Samples: 6

**Called by:**
- `(anonymous)` (2)
- `_computeIsStrict` (1)
- `getRhsNode` (1)
- `isForInOfRef` (1)
- `collectUnusedVariables` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` | Self: 0.4% (8.9ms) | Total: 13.7% (257.9ms) | Samples: 6

**Called by:**
- `collectUnusedVariables` (170)

**Calls:**
- `some` (160)
- `get references` (4)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` | Self: 0.4% (8.8ms) | Total: 0.5% (10.6ms) | Samples: 6

**Called by:**
- `(anonymous)` (7)

**Calls:**
- `isRead` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3162` | Self: 0.4% (8.8ms) | Total: 2.6% (48.9ms) | Samples: 6

**Called by:**
- `getDeclaredVariables` (29)

**Calls:**
- `push` (23)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2017` | Self: 0.4% (8.7ms) | Total: 0.4% (8.7ms) | Samples: 6

**Called by:**
- `_buildScopeVarsAndSet` (6)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.4% (8.4ms) | Total: 0.4% (8.4ms) | Samples: 5

**Called by:**
- `(anonymous)` (2)
- `collectUnusedVariables` (1)
- `_buildReference` (1)
- `collectUnusedVariables` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6470` | Self: 0.4% (8.0ms) | Total: 0.4% (8.0ms) | Samples: 5

**Called by:**
- `walkNodes` (5)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` | Self: 0.4% (7.8ms) | Total: 0.4% (9.3ms) | Samples: 5

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `get parent` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3102` | Self: 0.4% (7.7ms) | Total: 0.4% (7.7ms) | Samples: 5

**Called by:**
- `isAfterLastUsedArg` (5)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6720` | Self: 0.4% (7.6ms) | Total: 0.4% (7.6ms) | Samples: 5

**Called by:**
- `runPlugins` (5)

### `defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` | Self: 0.3% (7.3ms) | Total: 0.7% (14.0ms) | Samples: 5

**Called by:**
- `isAfterLastUsedArg` (5)
- `get identifiers` (2)
- `_computeDeclaredVariables` (1)
- `collectUnusedVariables` (1)

**Calls:**
- `_computeVarDefs` (2)
- `_computeVarDefs` (1)
- `_computeVarDefs` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` | Self: 0.3% (7.1ms) | Total: 0.6% (11.6ms) | Samples: 5

**Called by:**
- `(anonymous)` (8)

**Calls:**
- `get parent` (2)
- `get parent` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` | Self: 0.3% (6.9ms) | Total: 0.5% (11.1ms) | Samples: 5

**Called by:**
- `collectUnusedVariables` (8)

**Calls:**
- `get parent` (1)
- `isFunction` (1)
- `get parent` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` | Self: 0.3% (6.7ms) | Total: 0.5% (9.8ms) | Samples: 4

**Called by:**
- `some` (6)

**Calls:**
- `isRead` (1)
- `isReadRef` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` | Self: 0.3% (6.5ms) | Total: 0.4% (8.1ms) | Samples: 4

**Called by:**
- `collectUnusedVariables` (5)

**Calls:**
- `get parent` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:581` | Self: 0.3% (6.4ms) | Total: 0.3% (6.4ms) | Samples: 4

**Called by:**
- `_precomputeScopes` (4)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2677` | Self: 0.3% (6.3ms) | Total: 0.4% (9.1ms) | Samples: 4

**Called by:**
- `getScope` (6)

**Calls:**
- `test` (1)
- `/^\s*exported\b/` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4022` | Self: 0.3% (6.2ms) | Total: 0.3% (6.2ms) | Samples: 4

**Called by:**
- `get parent` (1)
- `get body` (1)
- `_buildReference` (1)
- `_nodesFromRange` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6468` | Self: 0.3% (6.0ms) | Total: 0.3% (6.0ms) | Samples: 4

**Called by:**
- `walkNodes` (4)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1187` | Self: 0.2% (5.0ms) | Total: 0.2% (5.0ms) | Samples: 4

**Called by:**
- `_buildReference` (4)

### `isRead`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:220` | Self: 0.2% (4.9ms) | Total: 0.2% (4.9ms) | Samples: 3

**Called by:**
- `isReadRef` (1)
- `(anonymous)` (1)
- `isReadForItself` (1)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1008` | Self: 0.2% (4.8ms) | Total: 0.2% (4.8ms) | Samples: 3

**Called by:**
- `_nodeViewRaw` (3)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3157` | Self: 0.2% (4.7ms) | Total: 0.4% (7.6ms) | Samples: 3

**Called by:**
- `getDeclaredVariables` (5)

**Calls:**
- `get defs` (1)
- `defs` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` | Self: 0.2% (4.7ms) | Total: 0.4% (8.0ms) | Samples: 3

**Called by:**
- `collectUnusedVariables` (5)

**Calls:**
- `get parent` (1)
- `get parent` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` | Self: 0.2% (4.3ms) | Total: 3.0% (57.9ms) | Samples: 3

**Called by:**
- `getDeclaredVariables` (38)

**Calls:**
- `Set` (35)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.2% (4.3ms) | Total: 0.2% (4.3ms) | Samples: 3

**Called by:**
- `walkNodes` (3)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2734` | Self: 0.2% (4.0ms) | Total: 0.2% (4.0ms) | Samples: 3

**Called by:**
- `_computeDeclaredVariables` (2)
- `_buildReference` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7142` | Self: 0.1% (3.5ms) | Total: 0.1% (3.5ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:887` | Self: 0.1% (3.4ms) | Total: 0.2% (5.0ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (3)

**Calls:**
- `get parent` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2071` | Self: 0.1% (3.3ms) | Total: 0.2% (4.9ms) | Samples: 2

**Called by:**
- `_buildReference` (2)
- `_buildScope` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3156` | Self: 0.1% (3.3ms) | Total: 0.3% (6.0ms) | Samples: 2

**Called by:**
- `getDeclaredVariables` (4)

**Calls:**
- `_buildVariable` (2)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4260` | Self: 0.1% (3.2ms) | Total: 0.1% (3.2ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3099` | Self: 0.1% (3.2ms) | Total: 0.1% (3.2ms) | Samples: 2

**Called by:**
- `isAfterLastUsedArg` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2229` | Self: 0.1% (3.2ms) | Total: 0.1% (3.2ms) | Samples: 2

**Called by:**
- `_ensureVarsSet` (2)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` | Self: 0.1% (3.2ms) | Total: 0.1% (3.2ms) | Samples: 2

**Called by:**
- `getDeclaredVariables` (2)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` | Self: 0.1% (3.1ms) | Total: 0.1% (3.1ms) | Samples: 2

**Called by:**
- `isUsedVariable` (2)

### `get`
`[native code]` | Self: 0.1% (3.1ms) | Total: 0.1% (3.1ms) | Samples: 2

**Called by:**
- `_computeDeclaredVariables` (1)
- `_buildScopeVarsAndSet` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2593` | Self: 0.1% (3.1ms) | Total: 0.1% (3.1ms) | Samples: 2

**Called by:**
- `_ensureChildren` (2)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2846` | Self: 0.1% (3.0ms) | Total: 0.1% (3.0ms) | Samples: 2

**Called by:**
- `get references` (2)

### `/\/\*([\s\S]*?)\*\//g`
`[native code]` | Self: 0.1% (3.0ms) | Total: 0.1% (3.0ms) | Samples: 2

**Called by:**
- `exec` (2)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3161` | Self: 0.1% (3.0ms) | Total: 2.1% (39.3ms) | Samples: 2

**Called by:**
- `getDeclaredVariables` (24)

**Calls:**
- `push` (22)

### `getUint32`
`[native code]` | Self: 0.1% (3.0ms) | Total: 0.1% (3.0ms) | Samples: 2

**Called by:**
- `_isChainNode` (1)
- `get left` (1)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (2.8ms) | Total: 0.1% (2.8ms) | Samples: 2

**Called by:**
- `_nodeViewRaw` (2)

### `get eslintUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:738` | Self: 0.1% (2.8ms) | Total: 0.1% (2.8ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (2)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` | Self: 0.1% (2.7ms) | Total: 0.1% (2.7ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (2)

### `set`
`[native code]` | Self: 0.1% (2.7ms) | Total: 0.1% (2.7ms) | Samples: 2

**Called by:**
- `_computeDeclaredVariables` (2)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1192` | Self: 0.1% (2.7ms) | Total: 1.4% (26.9ms) | Samples: 2

**Called by:**
- `_buildReference` (16)
- `_computeIsStrict` (1)
- `_computeVarDefs` (1)

**Calls:**
- `_nodeViewRaw` (6)
- `_nodeViewRaw` (5)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)
- `nodeView` (1)
- `_nodeViewRaw` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1179` | Self: 0.1% (2.5ms) | Total: 0.1% (2.5ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` | Self: 0.0% (1.8ms) | Total: 0.1% (3.2ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (2)

**Calls:**
- `_computeVariableSynthRefs` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:540` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` | Self: 0.0% (1.7ms) | Total: 0.7% (14.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (9)

**Calls:**
- `isInLoop` (8)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3556` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `get value` (1)

### `forEach`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.2% (4.9ms) | Samples: 1

**Called by:**
- `getFunctionDefinitions` (3)

**Calls:**
- `(anonymous)` (2)

### `symbolToStringify`
`node:os` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `node:os` (1)

### `slice`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_buildSymNameCache` (1)

### `get eslintUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `performProxyObjectGet`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.1% (3.4ms) | Samples: 1

**Called by:**
- `getRhsNode` (2)

**Calls:**
- `get` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3992` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `get parent` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2815` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `performProxyObjectGet` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2840` | Self: 0.0% (1.7ms) | Total: 0.1% (3.1ms) | Samples: 1

**Called by:**
- `get references` (2)

**Calls:**
- `_buildVariable` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `fill`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `reset` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2792` | Self: 0.0% (1.7ms) | Total: 0.1% (3.1ms) | Samples: 1

**Called by:**
- `defs` (2)

**Calls:**
- `get parent` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4053` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `get parent` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1522` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `get parent` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` | Self: 0.0% (1.6ms) | Total: 0.2% (5.1ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (3)

**Calls:**
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` | Self: 0.0% (1.6ms) | Total: 100.0% (4.66s) | Samples: 1

**Called by:**
- `collectUnusedVariables` (2162)
- `Program:exit` (857)

**Calls:**
- `collectUnusedVariables` (2162)
- `collectUnusedVariables` (337)
- `collectUnusedVariables` (255)
- `collectUnusedVariables` (195)
- `collectUnusedVariables` (25)
- `collectUnusedVariables` (11)
- `collectUnusedVariables` (10)
- `collectUnusedVariables` (8)
- `collectUnusedVariables` (5)
- `collectUnusedVariables` (5)
- `collectUnusedVariables` (3)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:583` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3123` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `dlopen`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getUpperFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:134` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `isInsideOfStorableFunction` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `commentsInRange` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2868` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `get references` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1240` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2113` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1676` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1188` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1477` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6735` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `parseSource` (1)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:803` | Self: 0.0% (1.5ms) | Total: 0.2% (4.6ms) | Samples: 1

**Called by:**
- `_ensureDeclSymIndex` (2)
- `_buildVariable` (1)

**Calls:**
- `_buildSymNameCache` (2)

### `eslintUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:738` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `isUsedVariable` (1)

### `RegExp`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `error`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `async (anonymous)` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` | Self: 0.0% (1.5ms) | Total: 4.4% (82.4ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (45)
- `(anonymous)` (4)
- `isUsedVariable` (4)
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `_buildReference` (22)
- `_buildReference` (14)
- `_buildReference` (12)
- `_buildReference` (2)
- `_buildReference` (2)
- `_buildReference` (1)

### `_computeVarScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2815` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `scope` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:846` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1189` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:774` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get name` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get init` (1)

### `exec`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.2% (4.4ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (3)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (2)

### `isExported`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:358` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2763` | Self: 0.0% (1.4ms) | Total: 0.1% (3.2ms) | Samples: 1

**Called by:**
- `get defs` (1)
- `defs` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1230` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `/^\s*exported\b/`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2054` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` | Self: 0.0% (1.3ms) | Total: 28.3% (530.8ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (337)

**Calls:**
- `isAfterLastUsedArg` (316)
- `isAfterLastUsedArg` (8)
- `isAfterLastUsedArg` (5)
- `isAfterLastUsedArg` (5)
- `isAfterLastUsedArg` (2)

### `_nodeEndPos`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:881` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_execReport` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2223` | Self: 0.0% (1.3ms) | Total: 0.1% (3.0ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (2)

**Calls:**
- `get` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1706` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_getOrBuildPlan` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7485` | Self: 0.0% (1.3ms) | Total: 0.1% (3.0ms) | Samples: 1

**Called by:**
- `async (anonymous)` (2)

**Calls:**
- `reset` (1)

### `test`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:654` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3101` | Self: 0.0% (1.3ms) | Total: 25.8% (484.8ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (307)

**Calls:**
- `_computeDeclaredVariables` (91)
- `_computeDeclaredVariables` (53)
- `_computeDeclaredVariables` (38)
- `_computeDeclaredVariables` (33)
- `_computeDeclaredVariables` (29)
- `_computeDeclaredVariables` (24)
- `_computeDeclaredVariables` (19)
- `_computeDeclaredVariables` (7)
- `_computeDeclaredVariables` (5)
- `_computeDeclaredVariables` (4)
- `_computeDeclaredVariables` (2)
- `_computeDeclaredVariables` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `get` (1)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:819` | Self: 0.0% (1.3ms) | Total: 0.1% (3.1ms) | Samples: 1

**Called by:**
- `_symName` (2)

**Calls:**
- `slice` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:37` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `parseModule` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:647` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_resolveUnicodeEscapes`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:226` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `get name` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1491` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:622` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `commentsInRange` (1)

### `isFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:152` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `isFunction` (1)

### `freeze`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` | Self: 0.0% (1.2ms) | Total: 5.2% (99.0ms) | Samples: 1

**Called by:**
- `some` (65)

**Calls:**
- `getRhsNode` (50)
- `getRhsNode` (9)
- `getRhsNode` (2)
- `getRhsNode` (1)
- `getRhsNode` (1)
- `getRhsNode` (1)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `parseSource` (1)

### `decode`
`[native code]` | Self: 0.0% (1.0ms) | Total: 0.0% (1.0ms) | Samples: 1

**Called by:**
- `get source` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2844` | Self: 0.0% (0us) | Total: 1.1% (22.4ms) | Samples: 0

**Called by:**
- `get references` (14)

**Calls:**
- `_buildScope` (6)
- `_buildScope` (5)
- `_buildScope` (2)
- `_buildScope` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:46` | Self: 0.0% (0us) | Total: 0.4% (9.1ms) | Samples: 0

**Called by:**
- `async (anonymous)` (6)

**Calls:**
- `bound require` (6)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2701` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `_symName` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:972` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `_ensureVarsSet` (1)

### `get identifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:756` | Self: 0.0% (0us) | Total: 0.1% (3.3ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (2)

**Calls:**
- `defs` (2)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:62` | Self: 0.0% (0us) | Total: 11.9% (224.5ms) | Samples: 0

**Called by:**
- `async (anonymous)` (147)

**Calls:**
- `runPlugins` (145)
- `runPlugins` (1)
- `runPlugins` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:66` | Self: 0.0% (0us) | Total: 83.1% (1.55s) | Samples: 0

**Called by:**
- `async (anonymous)` (1011)

**Calls:**
- `runPlugins` (1009)
- `runPlugins` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:662` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isInsideOfStorableFunction` (1)

### `node:os`
`node:os:111` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `symbolToStringify` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` | Self: 0.0% (0us) | Total: 0.7% (13.7ms) | Samples: 0

**Called by:**
- `some` (10)

**Calls:**
- `isSelfReference` (10)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `map`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (2.7ms) | Samples: 0

**Called by:**
- `isAfterLastUsedArg` (1)
- `_computeDeclaredVariables` (1)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` | Self: 0.0% (0us) | Total: 0.0% (1.0ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `eslintUsed` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2225` | Self: 0.0% (0us) | Total: 0.1% (3.3ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (2)

**Calls:**
- `get identifiers` (2)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:50` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `getTagNames` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7492` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `buildVisitorMap` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2837` | Self: 0.0% (0us) | Total: 1.8% (33.8ms) | Samples: 0

**Called by:**
- `get references` (22)
- `_ensureVarsSet` (1)

**Calls:**
- `get parent` (16)
- `get parent` (4)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2222` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `_buildVariable` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:880` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `_buildReference` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` | Self: 0.0% (0us) | Total: 1.7% (32.8ms) | Samples: 0

**Called by:**
- `some` (21)

**Calls:**
- `isForInOfRef` (11)
- `isForInOfRef` (8)
- `isForInOfRef` (1)
- `isForInOfRef` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3176` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `isAfterLastUsedArg` (1)

**Calls:**
- `map` (1)

### `describeRule`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (1)

**Calls:**
- `_getPlugin` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:954` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `isExported` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:561` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `nodeViewChain` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:442` | Self: 0.0% (0us) | Total: 0.1% (3.2ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `CfgGraph` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_computeVarDefs` (1)

**Calls:**
- `get parent` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:967` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `get` (1)

**Calls:**
- `_ensureVarsSet` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1040` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `reset` (1)

**Calls:**
- `fill` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` | Self: 0.0% (0us) | Total: 4.5% (84.2ms) | Samples: 0

**Called by:**
- `_invokeFused` (54)

**Calls:**
- `getScope` (54)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1340` | Self: 0.0% (0us) | Total: 0.1% (2.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `_identAt` (1)
- `_resolveUnicodeEscapes` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2213` | Self: 0.0% (0us) | Total: 0.6% (11.8ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (8)

**Calls:**
- `_ensureDeclSymIndex` (6)
- `_ensureDeclSymIndex` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6973` | Self: 0.0% (0us) | Total: 0.9% (18.3ms) | Samples: 0

**Called by:**
- `runPlugins` (12)

**Calls:**
- `getDFSEvents` (5)
- `getDFSEvents` (4)
- `getDFSEvents` (3)

### `get left`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1759` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `getRhsNode` (1)

**Calls:**
- `getUint32` (1)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` | Self: 0.0% (0us) | Total: 0.2% (5.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `bound require` (4)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1703` | Self: 0.0% (0us) | Total: 0.2% (5.1ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (3)

**Calls:**
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3897` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `Program:exit` (1)

**Calls:**
- `_execReport` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:869` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `get body` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2227` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `get references` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `node:child_process`
`node:child_process:2` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `get init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2919` | Self: 0.0% (0us) | Total: 0.1% (3.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:558` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get left` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1231` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_findDefNode` (1)

**Calls:**
- `get value` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:752` | Self: 0.0% (0us) | Total: 0.4% (7.7ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (5)

**Calls:**
- `some` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3177` | Self: 0.0% (0us) | Total: 0.1% (2.7ms) | Samples: 0

**Called by:**
- `map` (2)

**Calls:**
- `get name` (2)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2673` | Self: 0.0% (0us) | Total: 4.0% (75.1ms) | Samples: 0

**Called by:**
- `getScope` (48)

**Calls:**
- `commentsInRange` (33)
- `commentsInRange` (6)
- `commentsInRange` (4)
- `commentsInRange` (4)
- `commentsInRange` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2087` | Self: 0.0% (0us) | Total: 0.8% (16.3ms) | Samples: 0

**Called by:**
- `_buildReference` (5)
- `_buildScope` (4)
- `_buildScopeChildren` (1)

**Calls:**
- `_computeIsStrict` (8)
- `_computeIsStrict` (2)

### `_loadFromDisk`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:69` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_getPlugin` (1)

**Calls:**
- `tryParse` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `report` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:215` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `_encodeSource` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1485` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_buildScope` (1)

**Calls:**
- `get range` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:458` | Self: 0.0% (0us) | Total: 0.2% (5.6ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `patchAstUtils` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7209` | Self: 0.0% (0us) | Total: 76.7% (1.43s) | Samples: 0

**Called by:**
- `runPlugins` (931)

**Calls:**
- `_invokeFused` (931)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` | Self: 0.0% (0us) | Total: 99.7% (1.86s) | Samples: 0

**Called by:**
- `(anonymous)` (1214)

**Calls:**
- `async (anonymous)` (1011)
- `async (anonymous)` (147)
- `async (anonymous)` (47)
- `async (anonymous)` (6)
- `async (anonymous)` (1)
- `async (anonymous)` (1)
- `async (anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` | Self: 0.0% (0us) | Total: 0.2% (4.8ms) | Samples: 0

**Called by:**
- `async (anonymous)` (2)

**Calls:**
- `AstView` (1)
- `AstView` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` | Self: 0.0% (0us) | Total: 0.3% (6.3ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (4)

**Calls:**
- `_findLineIdx` (3)
- `_findLineIdx` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:59` | Self: 0.0% (0us) | Total: 3.8% (73.0ms) | Samples: 0

**Called by:**
- `async (anonymous)` (47)

**Calls:**
- `parseSource` (44)
- `parseSource` (2)
- `parseSource` (1)

### `isInsideOfStorableFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:630` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `isReadForItself` (1)

**Calls:**
- `getUpperFunction` (1)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 1.6% (31.1ms) | Samples: 0

**Called by:**
- `bound require` (21)

**Calls:**
- `anonymous` (21)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 100.0% (1.87s) | Samples: 0

**Calls:**
- `parseModule` (1217)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3995` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `reset` (1)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:512` | Self: 0.0% (0us) | Total: 0.0% (1.0ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `decode` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` | Self: 0.0% (0us) | Total: 72.0% (1.34s) | Samples: 0

**Called by:**
- `_invokeFused` (875)

**Calls:**
- `collectUnusedVariables` (857)
- `collectUnusedVariables` (13)
- `collectUnusedVariables` (5)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4664` | Self: 0.0% (0us) | Total: 76.7% (1.43s) | Samples: 0

**Called by:**
- `walkNodes` (931)

**Calls:**
- `Program:exit` (875)
- `Program:exit` (54)
- `Program:exit` (1)
- `Program:exit` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4078` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `getRhsNode` (1)

**Calls:**
- `_isChainNode` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:543` | Self: 0.0% (0us) | Total: 0.1% (3.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `performProxyObjectGet` (2)

### `loadBinding`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `getTagNames` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` | Self: 0.0% (0us) | Total: 0.1% (3.3ms) | Samples: 0

**Called by:**
- `parseModule` (2)

**Calls:**
- `bound require` (2)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1898` | Self: 0.0% (0us) | Total: 4.5% (84.2ms) | Samples: 0

**Called by:**
- `Program:exit` (54)

**Calls:**
- `_precomputeScopes` (48)
- `_precomputeScopes` (6)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4324` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `describeRule` (1)

### `isReadRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:431` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isRead` (1)

### `_ensureChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:924` | Self: 0.0% (0us) | Total: 0.5% (9.6ms) | Samples: 0

**Called by:**
- `get` (6)

**Calls:**
- `_buildScopeChildren` (4)
- `_buildScopeChildren` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` | Self: 0.0% (0us) | Total: 0.3% (6.3ms) | Samples: 0

**Called by:**
- `some` (4)

**Calls:**
- `get references` (4)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7493` | Self: 0.0% (0us) | Total: 94.8% (1.77s) | Samples: 0

**Called by:**
- `async (anonymous)` (1009)
- `async (anonymous)` (145)

**Calls:**
- `walkNodes` (931)
- `walkNodes` (151)
- `walkNodes` (23)
- `walkNodes` (12)
- `walkNodes` (10)
- `walkNodes` (10)
- `walkNodes` (7)
- `walkNodes` (5)
- `walkNodes` (2)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 2.0% (37.8ms) | Samples: 0

**Called by:**
- `async (anonymous)` (6)
- `patchAstUtils` (4)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `loadBinding` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `async (anonymous)` (1)

**Calls:**
- `require` (21)
- `anonymous` (3)
- `(anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` | Self: 0.0% (0us) | Total: 3.5% (66.9ms) | Samples: 0

**Called by:**
- `async (anonymous)` (44)

**Calls:**
- `parse` (44)

### `_isChainNode`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3894` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `nodeViewChain` (1)

**Calls:**
- `getUint32` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:70` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `error` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1683` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `_nodesFromRange` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:747` | Self: 0.0% (0us) | Total: 0.3% (7.3ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (5)

**Calls:**
- `defs` (5)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2081` | Self: 0.0% (0us) | Total: 0.2% (4.6ms) | Samples: 0

**Called by:**
- `_buildScopeChildren` (2)
- `_buildReference` (1)

**Calls:**
- `get value` (1)
- `get value` (1)
- `get value` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3843` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `report` (1)

**Calls:**
- `_nodeEndPos` (1)

### `isFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:427` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `isFunction` (1)

### `tryParse`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:126` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_loadFromDisk` (1)

**Calls:**
- `parse` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2066` | Self: 0.0% (0us) | Total: 0.8% (15.4ms) | Samples: 0

**Called by:**
- `_buildReference` (6)
- `_buildScope` (4)

**Calls:**
- `_buildScope` (4)
- `_buildScope` (4)
- `_buildScope` (1)
- `_buildScope` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.1% (3.3ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `scope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:745` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_computeVariableSynthRefs` (1)

**Calls:**
- `_computeVarScope` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `defs` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` | Self: 0.0% (0us) | Total: 0.9% (18.5ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (12)

**Calls:**
- `getFunctionDefinitions` (10)
- `getFunctionDefinitions` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/eslint-visitor-keys/dist/eslint-visitor-keys.cjs:116` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `freeze` (1)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.2% (4.3ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` | Self: 0.0% (0us) | Total: 99.7% (1.86s) | Samples: 0

**Called by:**
- `parseModule` (1214)

**Calls:**
- `async (anonymous)` (1214)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2320` | Self: 0.0% (0us) | Total: 0.2% (4.4ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (3)

**Calls:**
- `exec` (3)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2895` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `get references` (1)

**Calls:**
- `scope` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` | Self: 0.0% (0us) | Total: 1.3% (25.9ms) | Samples: 0

**Called by:**
- `some` (17)

**Calls:**
- `isReadForItself` (7)
- `isReadForItself` (6)
- `isReadForItself` (1)
- `isReadForItself` (1)
- `isReadForItself` (1)
- `isReadForItself` (1)

### `getTagNames`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:186` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `loadBinding` (1)

### `get defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_computeDeclaredVariables` (1)

**Calls:**
- `_computeVarDefs` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:49` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `RegExp` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:45` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `bound require` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:957` | Self: 0.0% (0us) | Total: 0.5% (9.6ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (6)

**Calls:**
- `_ensureChildren` (6)

### `parseModule`
`[native code]` | Self: 0.0% (0us) | Total: 100.0% (1.87s) | Samples: 0

**Called by:**
- `async (anonymous)` (1217)

**Calls:**
- `(anonymous)` (1214)
- `(anonymous)` (2)
- `(anonymous)` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` | Self: 0.0% (0us) | Total: 26.6% (498.5ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (316)

**Calls:**
- `getDeclaredVariables` (307)
- `getDeclaredVariables` (5)
- `getDeclaredVariables` (2)
- `_computeDeclaredVariables` (1)
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2782` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `defs` (1)

**Calls:**
- `_findDefNode` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:845` | Self: 0.0% (0us) | Total: 1.6% (30.3ms) | Samples: 0

**Called by:**
- `get` (20)

**Calls:**
- `_buildScopeVarsAndSet` (8)
- `_buildScopeVarsAndSet` (3)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn-jsx/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.0ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` | Self: 0.0% (0us) | Total: 0.1% (3.1ms) | Samples: 0

**Called by:**
- `forEach` (2)

**Calls:**
- `get init` (2)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2167` | Self: 0.0% (0us) | Total: 0.1% (3.1ms) | Samples: 0

**Called by:**
- `_buildScope` (2)

**Calls:**
- `get parent` (1)
- `get parent` (1)

### `_getPlugin`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:60` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `describeRule` (1)

**Calls:**
- `_loadFromDisk` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2186` | Self: 0.0% (0us) | Total: 0.7% (13.1ms) | Samples: 0

**Called by:**
- `_buildScope` (8)

**Calls:**
- `get body` (3)
- `get body` (3)
- `get body` (1)
- `get body` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:953` | Self: 0.0% (0us) | Total: 1.7% (33.1ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (22)

**Calls:**
- `_ensureVarsSet` (20)
- `_ensureVarsSet` (1)
- `_ensureVarsSet` (1)

### `(anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `bound require` (1)

**Calls:**
- `dlopen` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2589` | Self: 0.0% (0us) | Total: 0.3% (6.5ms) | Samples: 0

**Called by:**
- `_ensureChildren` (4)

**Calls:**
- `_buildScope` (2)
- `_buildScope` (1)
- `_buildScope` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7488` | Self: 0.0% (0us) | Total: 0.0% (1.0ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `get source` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2833` | Self: 0.0% (0us) | Total: 0.9% (18.1ms) | Samples: 0

**Called by:**
- `get references` (12)

**Calls:**
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (1)

### `_getOrBuildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5563` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_buildPlan` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6634` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_getOrBuildPlan` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2029` | Self: 0.0% (0us) | Total: 0.1% (3.1ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (2)

**Calls:**
- `_symName` (2)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:576` | Self: 0.0% (0us) | Total: 0.4% (8.7ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (6)

**Calls:**
- `_findLineIdx` (5)
- `_findLineIdx` (1)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 38.9% | 729.5ms | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 24.7% | 462.9ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 19.8% | 370.8ms | `[native code]` |
| 16.1% | 302.0ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 2.8ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js` |
| 0.0% | 1.7ms | `node:os` |
| 0.0% | 1.3ms | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js` |
| 0.0% | 1.2ms | `/Users/ericsan/Development/OpenSource/Ez/js/index.js` |
