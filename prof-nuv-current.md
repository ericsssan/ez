# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 1.86s | 1217 | 1.0ms | 260 |

**Top 10:** `(anonymous)` 12.5%, `walkNodes` 11.0%, `push` 5.9%, `some` 4.6%, `parse` 3.6%, `get parent` 3.5%, `Set` 3.3%, `_computeDeclaredVariables` 3.1%, `getRhsNode` 3.1%, `commentsInRange` 2.8%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 12.5% | 234.0ms | 18.2% | 341.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 11.0% | 206.5ms | 12.7% | 237.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7002` |
| 5.9% | 111.7ms | 5.9% | 111.7ms | `push` | `[native code]` |
| 4.6% | 87.0ms | 32.5% | 607.2ms | `some` | `[native code]` |
| 3.6% | 67.9ms | 3.6% | 67.9ms | `parse` | `[native code]` |
| 3.5% | 66.9ms | 3.5% | 66.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1258` |
| 3.3% | 62.8ms | 3.3% | 62.8ms | `Set` | `[native code]` |
| 3.1% | 59.6ms | 3.1% | 59.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3166` |
| 3.1% | 59.4ms | 3.2% | 60.8ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 2.8% | 53.0ms | 2.8% | 53.0ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:579` |
| 2.7% | 51.2ms | 4.8% | 89.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3168` |
| 2.4% | 45.8ms | 2.4% | 45.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1178` |
| 1.9% | 35.8ms | 1.9% | 35.8ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3172` |
| 1.5% | 28.9ms | 1.5% | 28.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6743` |
| 1.5% | 28.3ms | 1.6% | 29.8ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` |
| 1.3% | 25.9ms | 1.3% | 25.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4008` |
| 1.2% | 23.7ms | 1.2% | 23.7ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4909` |
| 1.0% | 19.6ms | 1.0% | 19.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4011` |
| 1.0% | 19.5ms | 1.0% | 19.5ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.9% | 18.5ms | 0.9% | 18.5ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` |
| 0.8% | 16.6ms | 0.9% | 18.3ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.8% | 15.1ms | 15.7% | 293.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 0.8% | 15.1ms | 0.8% | 15.1ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6478` |
| 0.6% | 12.2ms | 0.6% | 12.2ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` |
| 0.6% | 12.2ms | 1.0% | 19.8ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` |
| 0.6% | 12.0ms | 2.1% | 39.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1192` |
| 0.6% | 11.5ms | 0.6% | 11.5ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:620` |
| 0.6% | 11.3ms | 0.6% | 11.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3146` |
| 0.5% | 10.9ms | 2.0% | 37.7ms | `anonymous` | `[native code]` |
| 0.5% | 10.7ms | 3.1% | 58.9ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3169` |
| 0.5% | 10.4ms | 0.5% | 10.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7171` |
| 0.5% | 10.3ms | 2.7% | 50.8ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 0.5% | 9.9ms | 0.5% | 9.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7001` |
| 0.5% | 9.7ms | 0.7% | 13.0ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` |
| 0.5% | 9.5ms | 0.5% | 9.5ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6476` |
| 0.4% | 8.9ms | 0.4% | 8.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7003` |
| 0.4% | 8.7ms | 0.4% | 8.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` |
| 0.4% | 8.7ms | 1.8% | 33.8ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3170` |
| 0.4% | 8.5ms | 0.4% | 8.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7173` |
| 0.4% | 8.2ms | 0.4% | 8.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4034` |
| 0.4% | 7.6ms | 0.4% | 7.6ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.4% | 7.6ms | 0.4% | 7.6ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.4% | 7.4ms | 0.4% | 7.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2017` |
| 0.3% | 7.4ms | 0.7% | 13.2ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2677` |
| 0.3% | 7.3ms | 0.3% | 7.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6732` |
| 0.3% | 7.1ms | 0.3% | 7.1ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.3% | 7.1ms | 0.5% | 10.4ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` |
| 0.3% | 6.8ms | 0.4% | 8.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4024` |
| 0.3% | 6.6ms | 0.3% | 6.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1225` |
| 0.3% | 6.2ms | 5.0% | 93.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 0.3% | 6.1ms | 3.7% | 69.0ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` |
| 0.3% | 6.1ms | 0.4% | 7.5ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3160` |
| 0.3% | 5.9ms | 0.3% | 5.9ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3102` |
| 0.3% | 5.9ms | 0.3% | 5.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4033` |
| 0.3% | 5.8ms | 0.6% | 11.8ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` |
| 0.3% | 5.8ms | 0.3% | 5.8ms | `get eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:738` |
| 0.2% | 5.1ms | 0.2% | 5.1ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2868` |
| 0.2% | 5.1ms | 0.5% | 9.5ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.2% | 4.9ms | 0.4% | 9.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.2% | 4.7ms | 0.2% | 4.7ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2929` |
| 0.2% | 4.6ms | 100.0% | 4.53s | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 0.2% | 4.6ms | 22.8% | 427.1ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 0.2% | 3.9ms | 0.2% | 3.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1240` |
| 0.2% | 3.9ms | 0.2% | 3.9ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` |
| 0.1% | 3.5ms | 0.1% | 3.5ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3099` |
| 0.1% | 3.4ms | 1.3% | 25.0ms | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2787` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:682` |
| 0.1% | 3.2ms | 0.7% | 14.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` |
| 0.1% | 3.1ms | 0.4% | 7.6ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.1% | 3.1ms | 4.7% | 87.9ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 0.1% | 3.1ms | 12.7% | 237.1ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1241` |
| 0.1% | 3.1ms | 0.2% | 4.4ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2792` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4272` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `/^\s*exported\b/` | `[native code]` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6744` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2052` |
| 0.1% | 2.9ms | 1.0% | 19.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2087` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2734` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `performProxyObjectGet` | `[native code]` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4026` |
| 0.1% | 2.7ms | 0.4% | 9.1ms | `forEach` | `[native code]` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `getUpperFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:134` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `test` | `[native code]` |
| 0.0% | 1.8ms | 1.1% | 21.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2229` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:173` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6854` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4003` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2430` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1231` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.2% | 4.7ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2895` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `extraClassData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:671` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6007` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1008` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:759` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2223` |
| 0.0% | 1.7ms | 1.9% | 35.8ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:953` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1298` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1691` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:803` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2015` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3354` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6549` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1179` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:655` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 1.6% | 30.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2697` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4084` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 1.3% | 24.9ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2844` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4030` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:581` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:479` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2006` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `has` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2738` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2215` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6469` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs` |
| 0.0% | 1.4ms | 0.3% | 7.4ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:576` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2432` |
| 0.0% | 1.4ms | 0.2% | 4.5ms | `exec` | `[native code]` |
| 0.0% | 1.4ms | 0.1% | 3.1ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:484` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2113` |
| 0.0% | 1.3ms | 0.4% | 7.8ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2846` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:959` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:776` |
| 0.0% | 1.3ms | 0.2% | 4.3ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2167` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2097` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2727` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2107` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3165` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `join` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3138` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3611` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3093` |
| 0.0% | 1.3ms | 25.1% | 469.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2130` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.6% | 12.2ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2071` |
| 0.0% | 1.2ms | 0.1% | 2.5ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:494` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get kind` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2686` |
| 0.0% | 1.2ms | 0.1% | 2.3ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:803` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7172` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.1ms | 0.0% | 1.1ms | `slice` | `[native code]` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 100.0% | 4.53s | 0.2% | 4.6ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 100.0% | 1.86s | 0.0% | 0us | `parseModule` | `[native code]` |
| 100.0% | 1.86s | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 99.8% | 1.86s | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` |
| 99.8% | 1.86s | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` |
| 95.0% | 1.77s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7522` |
| 82.7% | 1.54s | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:66` |
| 76.3% | 1.42s | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7238` |
| 76.3% | 1.42s | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4672` |
| 71.7% | 1.33s | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` |
| 32.5% | 607.2ms | 4.6% | 87.0ms | `some` | `[native code]` |
| 25.1% | 469.2ms | 0.0% | 1.3ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` |
| 22.8% | 427.1ms | 0.2% | 4.6ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 22.5% | 419.8ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` |
| 21.8% | 407.2ms | 0.0% | 0us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3101` |
| 18.2% | 341.0ms | 12.5% | 234.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 15.7% | 293.0ms | 0.8% | 15.1ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 12.7% | 237.4ms | 11.0% | 206.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7002` |
| 12.7% | 237.1ms | 0.1% | 3.1ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 12.3% | 231.3ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:62` |
| 5.9% | 111.7ms | 5.9% | 111.7ms | `push` | `[native code]` |
| 5.0% | 93.3ms | 0.3% | 6.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 4.8% | 89.6ms | 2.7% | 51.2ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3168` |
| 4.7% | 87.9ms | 0.1% | 3.1ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 4.5% | 84.7ms | 0.0% | 0us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1898` |
| 4.5% | 84.7ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` |
| 3.9% | 73.6ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:59` |
| 3.8% | 71.5ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2673` |
| 3.7% | 69.0ms | 0.3% | 6.1ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` |
| 3.6% | 67.9ms | 3.6% | 67.9ms | `parse` | `[native code]` |
| 3.6% | 67.9ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` |
| 3.5% | 66.9ms | 3.5% | 66.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1258` |
| 3.3% | 62.8ms | 3.3% | 62.8ms | `Set` | `[native code]` |
| 3.2% | 60.8ms | 3.1% | 59.4ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 3.1% | 59.6ms | 3.1% | 59.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3166` |
| 3.1% | 58.9ms | 0.5% | 10.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3169` |
| 2.8% | 53.0ms | 2.8% | 53.0ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:579` |
| 2.7% | 50.8ms | 0.5% | 10.3ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 2.4% | 45.8ms | 2.4% | 45.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1178` |
| 2.1% | 39.3ms | 0.6% | 12.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1192` |
| 2.0% | 37.7ms | 0.5% | 10.9ms | `anonymous` | `[native code]` |
| 1.9% | 36.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` |
| 1.9% | 35.8ms | 0.0% | 1.7ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:953` |
| 1.9% | 35.8ms | 1.9% | 35.8ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3172` |
| 1.9% | 35.7ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:845` |
| 1.8% | 34.1ms | 0.0% | 0us | `bound require` | `[native code]` |
| 1.8% | 33.8ms | 0.4% | 8.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3170` |
| 1.6% | 30.8ms | 0.0% | 0us | `require` | `[native code]` |
| 1.6% | 30.7ms | 0.0% | 1.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` |
| 1.6% | 30.5ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2833` |
| 1.6% | 29.8ms | 1.5% | 28.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` |
| 1.5% | 28.9ms | 1.5% | 28.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6743` |
| 1.4% | 27.4ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7000` |
| 1.3% | 25.9ms | 1.3% | 25.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4008` |
| 1.3% | 25.0ms | 0.1% | 3.4ms | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 1.3% | 24.9ms | 0.0% | 1.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2844` |
| 1.2% | 23.7ms | 1.2% | 23.7ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4909` |
| 1.2% | 22.8ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2837` |
| 1.1% | 21.1ms | 0.0% | 1.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` |
| 1.0% | 19.8ms | 0.0% | 0us | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` |
| 1.0% | 19.8ms | 0.6% | 12.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` |
| 1.0% | 19.7ms | 0.1% | 2.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2087` |
| 1.0% | 19.6ms | 1.0% | 19.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4011` |
| 1.0% | 19.5ms | 1.0% | 19.5ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 1.0% | 19.2ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:752` |
| 0.9% | 18.5ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` |
| 0.9% | 18.5ms | 0.9% | 18.5ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` |
| 0.9% | 18.3ms | 0.8% | 16.6ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.9% | 17.7ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2066` |
| 0.8% | 15.5ms | 0.0% | 0us | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2782` |
| 0.8% | 15.1ms | 0.8% | 15.1ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6478` |
| 0.7% | 14.5ms | 0.1% | 3.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` |
| 0.7% | 13.2ms | 0.3% | 7.4ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2677` |
| 0.7% | 13.0ms | 0.5% | 9.7ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` |
| 0.6% | 12.2ms | 0.6% | 12.2ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` |
| 0.6% | 12.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` |
| 0.6% | 12.2ms | 0.0% | 1.2ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 0.6% | 11.8ms | 0.3% | 5.8ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` |
| 0.6% | 11.5ms | 0.6% | 11.5ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:620` |
| 0.6% | 11.3ms | 0.6% | 11.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3146` |
| 0.5% | 10.8ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2186` |
| 0.5% | 10.4ms | 0.5% | 10.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7171` |
| 0.5% | 10.4ms | 0.3% | 7.1ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` |
| 0.5% | 10.2ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2213` |
| 0.5% | 9.9ms | 0.5% | 9.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7001` |
| 0.5% | 9.5ms | 0.2% | 5.1ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.5% | 9.5ms | 0.5% | 9.5ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6476` |
| 0.5% | 9.4ms | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` |
| 0.4% | 9.1ms | 0.1% | 2.7ms | `forEach` | `[native code]` |
| 0.4% | 9.0ms | 0.2% | 4.9ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.4% | 8.9ms | 0.4% | 8.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7003` |
| 0.4% | 8.7ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:46` |
| 0.4% | 8.7ms | 0.4% | 8.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` |
| 0.4% | 8.5ms | 0.3% | 6.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4024` |
| 0.4% | 8.5ms | 0.4% | 8.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7173` |
| 0.4% | 8.3ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2222` |
| 0.4% | 8.2ms | 0.4% | 8.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4034` |
| 0.4% | 7.8ms | 0.0% | 1.3ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` |
| 0.4% | 7.6ms | 0.4% | 7.6ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.4% | 7.6ms | 0.4% | 7.6ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.4% | 7.6ms | 0.1% | 3.1ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.4% | 7.5ms | 0.0% | 0us | `get defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 0.4% | 7.5ms | 0.3% | 6.1ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3160` |
| 0.4% | 7.4ms | 0.4% | 7.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2017` |
| 0.3% | 7.4ms | 0.0% | 1.4ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:576` |
| 0.3% | 7.3ms | 0.3% | 7.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6732` |
| 0.3% | 7.1ms | 0.3% | 7.1ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.3% | 7.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:458` |
| 0.3% | 6.6ms | 0.3% | 6.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1225` |
| 0.3% | 5.9ms | 0.3% | 5.9ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3102` |
| 0.3% | 5.9ms | 0.3% | 5.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4033` |
| 0.3% | 5.8ms | 0.0% | 0us | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2763` |
| 0.3% | 5.8ms | 0.3% | 5.8ms | `get eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:738` |
| 0.3% | 5.6ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` |
| 0.2% | 5.5ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` |
| 0.2% | 5.1ms | 0.2% | 5.1ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2868` |
| 0.2% | 4.8ms | 0.0% | 0us | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:869` |
| 0.2% | 4.8ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1694` |
| 0.2% | 4.7ms | 0.0% | 1.7ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2895` |
| 0.2% | 4.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` |
| 0.2% | 4.7ms | 0.2% | 4.7ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2929` |
| 0.2% | 4.5ms | 0.0% | 1.4ms | `exec` | `[native code]` |
| 0.2% | 4.5ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2320` |
| 0.2% | 4.4ms | 0.1% | 3.1ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2792` |
| 0.2% | 4.3ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` |
| 0.2% | 4.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.2% | 4.3ms | 0.0% | 1.3ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2167` |
| 0.2% | 3.9ms | 0.2% | 3.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1240` |
| 0.2% | 3.9ms | 0.2% | 3.9ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` |
| 0.1% | 3.5ms | 0.1% | 3.5ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3099` |
| 0.1% | 3.4ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:45` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2787` |
| 0.1% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:682` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1241` |
| 0.1% | 3.1ms | 0.0% | 1.4ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:484` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4272` |
| 0.1% | 3.1ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:442` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `/^\s*exported\b/` | `[native code]` |
| 0.1% | 3.0ms | 0.0% | 0us | `_ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:924` |
| 0.1% | 3.0ms | 0.0% | 0us | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2589` |
| 0.1% | 3.0ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:957` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6744` |
| 0.1% | 3.0ms | 0.0% | 0us | `scope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:745` |
| 0.1% | 3.0ms | 0.0% | 0us | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2808` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2052` |
| 0.1% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.1% | 2.8ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:661` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2734` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `performProxyObjectGet` | `[native code]` |
| 0.1% | 2.8ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:543` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4026` |
| 0.1% | 2.7ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1714` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `getUpperFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:134` |
| 0.1% | 2.7ms | 0.0% | 0us | `isInsideOfStorableFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:630` |
| 0.1% | 2.7ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:662` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `test` | `[native code]` |
| 0.1% | 2.5ms | 0.0% | 1.2ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:494` |
| 0.1% | 2.3ms | 0.0% | 1.2ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:803` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2229` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:173` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6854` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:558` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4003` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2430` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1231` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `internal:promisify` | `internal:promisify:53` |
| 0.0% | 1.7ms | 0.0% | 0us | `node:fs` | `node:fs:303` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `extraClassData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:671` |
| 0.0% | 1.7ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:776` |
| 0.0% | 1.7ms | 0.0% | 0us | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2287` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6007` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1008` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:759` |
| 0.0% | 1.7ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2225` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2223` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1298` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1691` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7521` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:803` |
| 0.0% | 1.6ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:747` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2015` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3354` |
| 0.0% | 1.6ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2190` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6549` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1179` |
| 0.0% | 1.6ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1717` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:655` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2900` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2697` |
| 0.0% | 1.5ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:967` |
| 0.0% | 1.5ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:972` |
| 0.0% | 1.5ms | 0.0% | 0us | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2930` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4084` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4030` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:581` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:479` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2006` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `has` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:506` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2738` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2215` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6469` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:1267` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2432` |
| 0.0% | 1.4ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2227` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2113` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:959` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:776` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2846` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` |
| 0.0% | 1.3ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:53` |
| 0.0% | 1.3ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:54` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2097` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2727` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2107` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3165` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `join` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:221` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:29` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3138` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3611` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3093` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2130` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2071` |
| 0.0% | 1.2ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:551` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get kind` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2686` |
| 0.0% | 1.2ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:887` |
| 0.0% | 1.2ms | 0.0% | 0us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2701` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7172` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.1ms | 0.0% | 0us | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:819` |
| 0.0% | 1.1ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2029` |
| 0.0% | 1.1ms | 0.0% | 1.1ms | `slice` | `[native code]` |

## Function Details

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` | Self: 12.5% (234.0ms) | Total: 18.2% (341.0ms) | Samples: 154

**Called by:**
- `some` (225)

**Calls:**
- `get parent` (43)
- `get parent` (22)
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7002` | Self: 11.0% (206.5ms) | Total: 12.7% (237.4ms) | Samples: 134

**Called by:**
- `runPlugins` (154)

**Calls:**
- `get allSkipped` (15)
- `get allSkipped` (5)

### `push`
`[native code]` | Self: 5.9% (111.7ms) | Total: 5.9% (111.7ms) | Samples: 68

**Called by:**
- `_computeDeclaredVariables` (26)
- `_computeDeclaredVariables` (25)
- `_computeDeclaredVariables` (17)

### `some`
`[native code]` | Self: 4.6% (87.0ms) | Total: 32.5% (607.2ms) | Samples: 57

**Called by:**
- `collectUnusedVariables` (225)
- `isUsedVariable` (148)
- `collectUnusedVariables` (13)
- `isAfterLastUsedArg` (12)

**Calls:**
- `(anonymous)` (225)
- `(anonymous)` (60)
- `(anonymous)` (24)
- `(anonymous)` (14)
- `(anonymous)` (9)
- `(anonymous)` (8)
- `(anonymous)` (1)

### `parse`
`[native code]` | Self: 3.6% (67.9ms) | Total: 3.6% (67.9ms) | Samples: 44

**Called by:**
- `parseSource` (44)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1258` | Self: 3.5% (66.9ms) | Total: 3.5% (66.9ms) | Samples: 44

**Called by:**
- `(anonymous)` (43)
- `_buildReference` (1)

### `Set`
`[native code]` | Self: 3.3% (62.8ms) | Total: 3.3% (62.8ms) | Samples: 40

**Called by:**
- `_computeDeclaredVariables` (40)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3166` | Self: 3.1% (59.6ms) | Total: 3.1% (59.6ms) | Samples: 40

**Called by:**
- `getDeclaredVariables` (40)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` | Self: 3.1% (59.4ms) | Total: 3.2% (60.8ms) | Samples: 38

**Called by:**
- `(anonymous)` (39)

**Calls:**
- `get parent` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:579` | Self: 2.8% (53.0ms) | Total: 2.8% (53.0ms) | Samples: 35

**Called by:**
- `_precomputeScopes` (35)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3168` | Self: 2.7% (51.2ms) | Total: 4.8% (89.6ms) | Samples: 33

**Called by:**
- `getDeclaredVariables` (58)

**Calls:**
- `push` (25)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1178` | Self: 2.4% (45.8ms) | Total: 2.4% (45.8ms) | Samples: 31

**Called by:**
- `(anonymous)` (22)
- `isReadForItself` (2)
- `collectUnusedVariables` (2)
- `isForInOfRef` (2)
- `getRhsNode` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3172` | Self: 1.9% (35.8ms) | Total: 1.9% (35.8ms) | Samples: 24

**Called by:**
- `getDeclaredVariables` (24)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6743` | Self: 1.5% (28.9ms) | Total: 1.5% (28.9ms) | Samples: 18

**Called by:**
- `runPlugins` (18)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` | Self: 1.5% (28.3ms) | Total: 1.6% (29.8ms) | Samples: 19

**Called by:**
- `getDeclaredVariables` (20)

**Calls:**
- `_ensureDeclSymIndex` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4008` | Self: 1.3% (25.9ms) | Total: 1.3% (25.9ms) | Samples: 17

**Called by:**
- `_buildReference` (8)
- `get parent` (5)
- `_computeVarDefs` (2)
- `get body` (1)
- `get body` (1)

### `get allSkipped`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4909` | Self: 1.2% (23.7ms) | Total: 1.2% (23.7ms) | Samples: 15

**Called by:**
- `walkNodes` (15)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4011` | Self: 1.0% (19.6ms) | Total: 1.0% (19.6ms) | Samples: 13

**Called by:**
- `_buildReference` (6)
- `get parent` (4)
- `_computeVarDefs` (2)
- `get body` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` | Self: 1.0% (19.5ms) | Total: 1.0% (19.5ms) | Samples: 13

**Called by:**
- `collectUnusedVariables` (13)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` | Self: 0.9% (18.5ms) | Total: 0.9% (18.5ms) | Samples: 12

**Called by:**
- `getRhsNode` (12)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` | Self: 0.8% (16.6ms) | Total: 0.9% (18.3ms) | Samples: 11

**Called by:**
- `(anonymous)` (12)

**Calls:**
- `get parent` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` | Self: 0.8% (15.1ms) | Total: 15.7% (293.0ms) | Samples: 10

**Called by:**
- `collectUnusedVariables` (186)
- `Program:exit` (5)

**Calls:**
- `isUsedVariable` (154)
- `some` (13)
- `isUsedVariable` (13)
- `isUsedVariable` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6478` | Self: 0.8% (15.1ms) | Total: 0.8% (15.1ms) | Samples: 10

**Called by:**
- `walkNodes` (10)

### `isSelfReference`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` | Self: 0.6% (12.2ms) | Total: 0.6% (12.2ms) | Samples: 8

**Called by:**
- `(anonymous)` (8)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` | Self: 0.6% (12.2ms) | Total: 1.0% (19.8ms) | Samples: 8

**Called by:**
- `collectUnusedVariables` (13)

**Calls:**
- `get eslintUsed` (4)
- `get eslintUsed` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1192` | Self: 0.6% (12.0ms) | Total: 2.1% (39.3ms) | Samples: 8

**Called by:**
- `_buildReference` (14)
- `_findDefNode` (5)
- `_computeIsStrict` (2)
- `collectUnusedVariables` (1)
- `_computeVarDefs` (1)
- `_findDefNode` (1)
- `isForInOfRef` (1)
- `collectUnusedVariables` (1)

**Calls:**
- `_nodeViewRaw` (5)
- `_nodeViewRaw` (5)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:620` | Self: 0.6% (11.5ms) | Total: 0.6% (11.5ms) | Samples: 8

**Called by:**
- `commentsInRange` (4)
- `commentsInRange` (4)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3146` | Self: 0.6% (11.3ms) | Total: 0.6% (11.3ms) | Samples: 7

**Called by:**
- `getDeclaredVariables` (7)

### `anonymous`
`[native code]` | Self: 0.5% (10.9ms) | Total: 2.0% (37.7ms) | Samples: 7

**Called by:**
- `require` (21)
- `bound require` (2)
- `internal:promisify` (1)
- `node:fs` (1)

**Calls:**
- `(anonymous)` (5)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:promisify` (1)
- `node:fs` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3169` | Self: 0.5% (10.7ms) | Total: 3.1% (58.9ms) | Samples: 7

**Called by:**
- `getDeclaredVariables` (33)

**Calls:**
- `push` (26)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7171` | Self: 0.5% (10.4ms) | Total: 0.5% (10.4ms) | Samples: 7

**Called by:**
- `runPlugins` (7)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` | Self: 0.5% (10.3ms) | Total: 2.7% (50.8ms) | Samples: 7

**Called by:**
- `collectUnusedVariables` (22)
- `Program:exit` (12)

**Calls:**
- `get` (24)
- `get` (2)
- `get` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7001` | Self: 0.5% (9.9ms) | Total: 0.5% (9.9ms) | Samples: 7

**Called by:**
- `runPlugins` (7)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` | Self: 0.5% (9.7ms) | Total: 0.7% (13.0ms) | Samples: 7

**Called by:**
- `(anonymous)` (9)

**Calls:**
- `get parent` (2)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6476` | Self: 0.5% (9.5ms) | Total: 0.5% (9.5ms) | Samples: 6

**Called by:**
- `walkNodes` (6)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7003` | Self: 0.4% (8.9ms) | Total: 0.4% (8.9ms) | Samples: 6

**Called by:**
- `runPlugins` (6)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` | Self: 0.4% (8.7ms) | Total: 0.4% (8.7ms) | Samples: 6

**Called by:**
- `getDeclaredVariables` (6)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3170` | Self: 0.4% (8.7ms) | Total: 1.8% (33.8ms) | Samples: 6

**Called by:**
- `getDeclaredVariables` (23)

**Calls:**
- `push` (17)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7173` | Self: 0.4% (8.5ms) | Total: 0.4% (8.5ms) | Samples: 6

**Called by:**
- `runPlugins` (6)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4034` | Self: 0.4% (8.2ms) | Total: 0.4% (8.2ms) | Samples: 5

**Called by:**
- `get parent` (5)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` | Self: 0.4% (7.6ms) | Total: 0.4% (7.6ms) | Samples: 5

**Called by:**
- `collectUnusedVariables` (5)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` | Self: 0.4% (7.6ms) | Total: 0.4% (7.6ms) | Samples: 5

**Called by:**
- `isUsedVariable` (5)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2017` | Self: 0.4% (7.4ms) | Total: 0.4% (7.4ms) | Samples: 5

**Called by:**
- `_buildScopeVarsAndSet` (5)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2677` | Self: 0.3% (7.4ms) | Total: 0.7% (13.2ms) | Samples: 5

**Called by:**
- `getScope` (9)

**Calls:**
- `test` (2)
- `/^\s*exported\b/` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6732` | Self: 0.3% (7.3ms) | Total: 0.3% (7.3ms) | Samples: 5

**Called by:**
- `runPlugins` (5)

### `get allSkipped`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.3% (7.1ms) | Total: 0.3% (7.1ms) | Samples: 5

**Called by:**
- `walkNodes` (5)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` | Self: 0.3% (7.1ms) | Total: 0.5% (10.4ms) | Samples: 5

**Called by:**
- `collectUnusedVariables` (7)

**Calls:**
- `get parent` (1)
- `get parent` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4024` | Self: 0.3% (6.8ms) | Total: 0.4% (8.5ms) | Samples: 4

**Called by:**
- `_buildReference` (2)
- `_nodesFromRange` (2)
- `get parent` (1)

**Calls:**
- `_computeNodeType` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1225` | Self: 0.3% (6.6ms) | Total: 0.3% (6.6ms) | Samples: 4

**Called by:**
- `(anonymous)` (1)
- `isReadForItself` (1)
- `_findDefNode` (1)
- `collectUnusedVariables` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` | Self: 0.3% (6.2ms) | Total: 5.0% (93.3ms) | Samples: 4

**Called by:**
- `some` (60)

**Calls:**
- `getRhsNode` (39)
- `getRhsNode` (12)
- `getRhsNode` (2)
- `getRhsNode` (1)
- `getRhsNode` (1)
- `getRhsNode` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` | Self: 0.3% (6.1ms) | Total: 3.7% (69.0ms) | Samples: 4

**Called by:**
- `getDeclaredVariables` (44)

**Calls:**
- `Set` (40)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3160` | Self: 0.3% (6.1ms) | Total: 0.4% (7.5ms) | Samples: 4

**Called by:**
- `getDeclaredVariables` (5)

**Calls:**
- `_buildVariable` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3102` | Self: 0.3% (5.9ms) | Total: 0.3% (5.9ms) | Samples: 4

**Called by:**
- `isAfterLastUsedArg` (4)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4033` | Self: 0.3% (5.9ms) | Total: 0.3% (5.9ms) | Samples: 4

**Called by:**
- `_buildReference` (2)
- `get parent` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` | Self: 0.3% (5.8ms) | Total: 0.6% (11.8ms) | Samples: 4

**Called by:**
- `collectUnusedVariables` (8)

**Calls:**
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `get eslintUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:738` | Self: 0.3% (5.8ms) | Total: 0.3% (5.8ms) | Samples: 4

**Called by:**
- `collectUnusedVariables` (4)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2868` | Self: 0.2% (5.1ms) | Total: 0.2% (5.1ms) | Samples: 3

**Called by:**
- `get references` (3)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` | Self: 0.2% (5.1ms) | Total: 0.5% (9.5ms) | Samples: 3

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `get parent` (2)
- `get parent` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` | Self: 0.2% (4.9ms) | Total: 0.4% (9.0ms) | Samples: 3

**Called by:**
- `collectUnusedVariables` (6)

**Calls:**
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2929` | Self: 0.2% (4.7ms) | Total: 0.2% (4.7ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` | Self: 0.2% (4.6ms) | Total: 100.0% (4.53s) | Samples: 3

**Called by:**
- `collectUnusedVariables` (2094)
- `Program:exit` (855)

**Calls:**
- `collectUnusedVariables` (2094)
- `collectUnusedVariables` (302)
- `collectUnusedVariables` (281)
- `collectUnusedVariables` (186)
- `collectUnusedVariables` (22)
- `collectUnusedVariables` (19)
- `collectUnusedVariables` (13)
- `collectUnusedVariables` (8)
- `collectUnusedVariables` (7)
- `collectUnusedVariables` (6)
- `collectUnusedVariables` (5)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` | Self: 0.2% (4.6ms) | Total: 22.8% (427.1ms) | Samples: 3

**Called by:**
- `collectUnusedVariables` (281)

**Calls:**
- `some` (225)
- `get references` (46)
- `get references` (5)
- `get references` (1)
- `get references` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1240` | Self: 0.2% (3.9ms) | Total: 0.2% (3.9ms) | Samples: 3

**Called by:**
- `(anonymous)` (2)
- `collectUnusedVariables` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` | Self: 0.2% (3.9ms) | Total: 0.2% (3.9ms) | Samples: 3

**Called by:**
- `_precomputeScopes` (3)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3099` | Self: 0.1% (3.5ms) | Total: 0.1% (3.5ms) | Samples: 2

**Called by:**
- `isAfterLastUsedArg` (2)

### `defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` | Self: 0.1% (3.4ms) | Total: 1.3% (25.0ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (14)
- `isAfterLastUsedArg` (1)
- `getFunctionDefinitions` (1)

**Calls:**
- `_computeVarDefs` (7)
- `_computeVarDefs` (4)
- `_computeVarDefs` (2)
- `_computeVarDefs` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2787` | Self: 0.1% (3.3ms) | Total: 0.1% (3.3ms) | Samples: 2

**Called by:**
- `get defs` (1)
- `defs` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:682` | Self: 0.1% (3.2ms) | Total: 0.1% (3.2ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` | Self: 0.1% (3.2ms) | Total: 0.7% (14.5ms) | Samples: 2

**Called by:**
- `some` (9)

**Calls:**
- `get references` (7)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` | Self: 0.1% (3.1ms) | Total: 0.4% (7.6ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (5)

**Calls:**
- `get parent` (2)
- `get parent` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` | Self: 0.1% (3.1ms) | Total: 4.7% (87.9ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (46)
- `(anonymous)` (7)
- `isUsedVariable` (3)
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `_buildReference` (19)
- `_buildReference` (17)
- `_buildReference` (15)
- `_buildReference` (3)
- `_buildReference` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` | Self: 0.1% (3.1ms) | Total: 12.7% (237.1ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (154)

**Calls:**
- `some` (148)
- `get references` (3)
- `get references` (1)

### `/\/\*([\s\S]*?)\*\//g`
`[native code]` | Self: 0.1% (3.1ms) | Total: 0.1% (3.1ms) | Samples: 2

**Called by:**
- `exec` (2)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1241` | Self: 0.1% (3.1ms) | Total: 0.1% (3.1ms) | Samples: 2

**Called by:**
- `(anonymous)` (1)
- `collectUnusedVariables` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2792` | Self: 0.1% (3.1ms) | Total: 0.2% (4.4ms) | Samples: 2

**Called by:**
- `defs` (2)
- `get defs` (1)

**Calls:**
- `get parent` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4272` | Self: 0.1% (3.1ms) | Total: 0.1% (3.1ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `/^\s*exported\b/`
`[native code]` | Self: 0.1% (3.0ms) | Total: 0.1% (3.0ms) | Samples: 2

**Called by:**
- `_precomputeScopes` (2)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (3.0ms) | Total: 0.1% (3.0ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6744` | Self: 0.1% (3.0ms) | Total: 0.1% (3.0ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2052` | Self: 0.1% (3.0ms) | Total: 0.1% (3.0ms) | Samples: 2

**Called by:**
- `_computeVarScope` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2087` | Self: 0.1% (2.9ms) | Total: 1.0% (19.7ms) | Samples: 2

**Called by:**
- `_buildReference` (6)
- `_buildScope` (5)
- `_buildScopeChildren` (2)

**Calls:**
- `_computeIsStrict` (7)
- `_computeIsStrict` (3)
- `_computeIsStrict` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2734` | Self: 0.1% (2.8ms) | Total: 0.1% (2.8ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (1)
- `_computeDeclaredVariables` (1)

### `performProxyObjectGet`
`[native code]` | Self: 0.1% (2.8ms) | Total: 0.1% (2.8ms) | Samples: 2

**Called by:**
- `getRhsNode` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4026` | Self: 0.1% (2.8ms) | Total: 0.1% (2.8ms) | Samples: 2

**Called by:**
- `get parent` (1)
- `_nodesFromRange` (1)

### `forEach`
`[native code]` | Self: 0.1% (2.7ms) | Total: 0.4% (9.1ms) | Samples: 2

**Called by:**
- `getFunctionDefinitions` (6)

**Calls:**
- `(anonymous)` (3)
- `(anonymous)` (1)

### `getUpperFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:134` | Self: 0.1% (2.7ms) | Total: 0.1% (2.7ms) | Samples: 2

**Called by:**
- `isInsideOfStorableFunction` (2)

### `test`
`[native code]` | Self: 0.1% (2.7ms) | Total: 0.1% (2.7ms) | Samples: 2

**Called by:**
- `_precomputeScopes` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` | Self: 0.0% (1.8ms) | Total: 1.1% (21.1ms) | Samples: 1

**Called by:**
- `some` (14)

**Calls:**
- `isReadForItself` (6)
- `isReadForItself` (2)
- `isReadForItself` (2)
- `isReadForItself` (1)
- `isReadForItself` (1)
- `isReadForItself` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2229` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:173` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6854` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get eslintUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4003` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getRhsNode` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2430` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1231` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2895` | Self: 0.0% (1.7ms) | Total: 0.2% (4.7ms) | Samples: 1

**Called by:**
- `get references` (3)

**Calls:**
- `scope` (2)

### `extraClassData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:671` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `get id` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6007` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1008` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `get identifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:759` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2223` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:953` | Self: 0.0% (1.7ms) | Total: 1.9% (35.8ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (24)

**Calls:**
- `_ensureVarsSet` (23)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1298` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1691` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:803` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2015` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `get directive`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3354` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6549` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1179` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:655` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_computeVariableSynthRefs` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` | Self: 0.0% (1.5ms) | Total: 1.6% (30.7ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (19)
- `Program:exit` (1)

**Calls:**
- `defs` (14)
- `get defs` (5)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2697` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4084` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `get init` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2844` | Self: 0.0% (1.5ms) | Total: 1.3% (24.9ms) | Samples: 1

**Called by:**
- `get references` (17)

**Calls:**
- `_buildScope` (8)
- `_buildScope` (6)
- `_buildScope` (1)
- `_buildScope` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4030` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:581` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `isInside`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `isReadForItself` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:479` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_computeVarDefs` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2006` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_computeDeclaredVariables` (1)

### `has`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_findDefNode` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2738` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2215` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6469` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:576` | Self: 0.0% (1.4ms) | Total: 0.3% (7.4ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (5)

**Calls:**
- `_findLineIdx` (4)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2432` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `exec`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.2% (4.5ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (3)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (2)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:484` | Self: 0.0% (1.4ms) | Total: 0.1% (3.1ms) | Samples: 1

**Called by:**
- `_computeVarDefs` (2)

**Calls:**
- `get parent` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2113` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` | Self: 0.0% (1.3ms) | Total: 0.4% (7.8ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (5)

**Calls:**
- `_computeVariableSynthRefs` (3)
- `_computeVariableSynthRefs` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2846` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `get references` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:959` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:776` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `isUsedVariable` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2167` | Self: 0.0% (1.3ms) | Total: 0.2% (4.3ms) | Samples: 1

**Called by:**
- `_buildScope` (3)

**Calls:**
- `get parent` (2)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2097` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2727` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2107` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3165` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `join`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `parseSource` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3138` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `some` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3611` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `isInside` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3093` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` | Self: 0.0% (1.3ms) | Total: 25.1% (469.2ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (302)

**Calls:**
- `isAfterLastUsedArg` (270)
- `isAfterLastUsedArg` (13)
- `isAfterLastUsedArg` (12)
- `isAfterLastUsedArg` (5)
- `isAfterLastUsedArg` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2130` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `parseSource` (1)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` | Self: 0.0% (1.2ms) | Total: 0.6% (12.2ms) | Samples: 1

**Called by:**
- `isUsedVariable` (8)

**Calls:**
- `forEach` (6)
- `defs` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2071` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `isInside`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:494` | Self: 0.0% (1.2ms) | Total: 0.1% (2.5ms) | Samples: 1

**Called by:**
- `getRhsNode` (1)
- `isReadForItself` (1)

**Calls:**
- `get range` (1)

### `get kind`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2686` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:803` | Self: 0.0% (1.2ms) | Total: 0.1% (2.3ms) | Samples: 1

**Called by:**
- `_buildVariable` (1)
- `_ensureDeclSymIndex` (1)

**Calls:**
- `_buildSymNameCache` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7172` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `slice`
`[native code]` | Self: 0.0% (1.1ms) | Total: 0.0% (1.1ms) | Samples: 1

**Called by:**
- `_buildSymNameCache` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` | Self: 0.0% (0us) | Total: 99.8% (1.86s) | Samples: 0

**Called by:**
- `parseModule` (1215)

**Calls:**
- `async (anonymous)` (1215)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:46` | Self: 0.0% (0us) | Total: 0.4% (8.7ms) | Samples: 0

**Called by:**
- `async (anonymous)` (6)

**Calls:**
- `bound require` (6)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2225` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `get identifiers` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:442` | Self: 0.0% (0us) | Total: 0.1% (3.1ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `CfgGraph` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` | Self: 0.0% (0us) | Total: 0.5% (9.4ms) | Samples: 0

**Called by:**
- `_computeVarDefs` (6)

**Calls:**
- `get parent` (5)
- `get parent` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` | Self: 0.0% (0us) | Total: 4.5% (84.7ms) | Samples: 0

**Called by:**
- `_invokeFused` (57)

**Calls:**
- `getScope` (57)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:661` | Self: 0.0% (0us) | Total: 0.1% (2.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `isInside` (1)
- `isInside` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:62` | Self: 0.0% (0us) | Total: 12.3% (231.3ms) | Samples: 0

**Called by:**
- `async (anonymous)` (152)

**Calls:**
- `runPlugins` (151)
- `runPlugins` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:972` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `_ensureVarsSet` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:53` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `loadCoreRules` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:1267` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `get id`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2287` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `extraClassData` (1)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` | Self: 0.0% (0us) | Total: 0.3% (5.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `bound require` (4)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4672` | Self: 0.0% (0us) | Total: 76.3% (1.42s) | Samples: 0

**Called by:**
- `walkNodes` (930)

**Calls:**
- `Program:exit` (873)
- `Program:exit` (57)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7000` | Self: 0.0% (0us) | Total: 1.4% (27.4ms) | Samples: 0

**Called by:**
- `runPlugins` (18)

**Calls:**
- `getDFSEvents` (10)
- `getDFSEvents` (6)
- `getDFSEvents` (1)
- `getDFSEvents` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2320` | Self: 0.0% (0us) | Total: 0.2% (4.5ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (3)

**Calls:**
- `exec` (3)

### `_computeVarScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2808` | Self: 0.0% (0us) | Total: 0.1% (3.0ms) | Samples: 0

**Called by:**
- `scope` (2)

**Calls:**
- `_buildScope` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:887` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `get kind` (1)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:819` | Self: 0.0% (0us) | Total: 0.0% (1.1ms) | Samples: 0

**Called by:**
- `_symName` (1)

**Calls:**
- `slice` (1)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:54` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `bound require` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:558` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2701` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `_symName` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:752` | Self: 0.0% (0us) | Total: 1.0% (19.2ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (12)

**Calls:**
- `some` (12)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:66` | Self: 0.0% (0us) | Total: 82.7% (1.54s) | Samples: 0

**Called by:**
- `async (anonymous)` (1007)

**Calls:**
- `runPlugins` (1007)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1717` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2673` | Self: 0.0% (0us) | Total: 3.8% (71.5ms) | Samples: 0

**Called by:**
- `getScope` (48)

**Calls:**
- `commentsInRange` (35)
- `commentsInRange` (5)
- `commentsInRange` (4)
- `commentsInRange` (3)
- `commentsInRange` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:662` | Self: 0.0% (0us) | Total: 0.1% (2.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `isInsideOfStorableFunction` (2)

### `internal:promisify`
`internal:promisify:53` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:221` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `join` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7238` | Self: 0.0% (0us) | Total: 76.3% (1.42s) | Samples: 0

**Called by:**
- `runPlugins` (930)

**Calls:**
- `_invokeFused` (930)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:458` | Self: 0.0% (0us) | Total: 0.3% (7.0ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `patchAstUtils` (4)
- `patchAstUtils` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2837` | Self: 0.0% (0us) | Total: 1.2% (22.8ms) | Samples: 0

**Called by:**
- `get references` (15)

**Calls:**
- `get parent` (14)
- `get parent` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` | Self: 0.0% (0us) | Total: 99.8% (1.86s) | Samples: 0

**Called by:**
- `(anonymous)` (1215)

**Calls:**
- `async (anonymous)` (1007)
- `async (anonymous)` (152)
- `async (anonymous)` (47)
- `async (anonymous)` (6)
- `async (anonymous)` (2)
- `async (anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` | Self: 0.0% (0us) | Total: 0.2% (4.3ms) | Samples: 0

**Called by:**
- `async (anonymous)` (2)

**Calls:**
- `AstView` (1)
- `AstView` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` | Self: 0.0% (0us) | Total: 0.2% (4.7ms) | Samples: 0

**Called by:**
- `forEach` (3)

**Calls:**
- `init` (3)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2222` | Self: 0.0% (0us) | Total: 0.4% (8.3ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (6)

**Calls:**
- `_buildVariable` (1)
- `_buildVariable` (1)
- `_buildVariable` (1)
- `_buildVariable` (1)
- `_buildVariable` (1)
- `_buildVariable` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` | Self: 0.0% (0us) | Total: 1.9% (36.5ms) | Samples: 0

**Called by:**
- `some` (24)

**Calls:**
- `isForInOfRef` (12)
- `isForInOfRef` (9)
- `isForInOfRef` (2)
- `isForInOfRef` (1)

### `isInsideOfStorableFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:630` | Self: 0.0% (0us) | Total: 0.1% (2.7ms) | Samples: 0

**Called by:**
- `isReadForItself` (2)

**Calls:**
- `getUpperFunction` (2)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:967` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `get` (1)

**Calls:**
- `_ensureVarsSet` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2213` | Self: 0.0% (0us) | Total: 0.5% (10.2ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (7)

**Calls:**
- `_ensureDeclSymIndex` (5)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2763` | Self: 0.0% (0us) | Total: 0.3% (5.8ms) | Samples: 0

**Called by:**
- `defs` (4)

**Calls:**
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (2)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:869` | Self: 0.0% (0us) | Total: 0.2% (4.8ms) | Samples: 0

**Called by:**
- `get body` (3)

**Calls:**
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2227` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `get references` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:776` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `get id` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7521` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `buildVisitorMap` (1)

### `node:fs`
`node:fs:303` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1898` | Self: 0.0% (0us) | Total: 4.5% (84.7ms) | Samples: 0

**Called by:**
- `Program:exit` (57)

**Calls:**
- `_precomputeScopes` (48)
- `_precomputeScopes` (9)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` | Self: 0.0% (0us) | Total: 0.2% (5.5ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (4)

**Calls:**
- `_findLineIdx` (4)

### `_ensureChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:924` | Self: 0.0% (0us) | Total: 0.1% (3.0ms) | Samples: 0

**Called by:**
- `get` (2)

**Calls:**
- `_buildScopeChildren` (2)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1714` | Self: 0.0% (0us) | Total: 0.1% (2.7ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (2)

**Calls:**
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 1.8% (34.1ms) | Samples: 0

**Called by:**
- `async (anonymous)` (6)
- `patchAstUtils` (4)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `async (anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `loadCoreRules` (1)

**Calls:**
- `require` (21)
- `anonymous` (2)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` | Self: 0.0% (0us) | Total: 3.6% (67.9ms) | Samples: 0

**Called by:**
- `async (anonymous)` (44)

**Calls:**
- `parse` (44)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:59` | Self: 0.0% (0us) | Total: 3.9% (73.6ms) | Samples: 0

**Called by:**
- `async (anonymous)` (47)

**Calls:**
- `parseSource` (44)
- `parseSource` (2)
- `parseSource` (1)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 1.6% (30.8ms) | Samples: 0

**Called by:**
- `bound require` (21)

**Calls:**
- `anonymous` (21)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1694` | Self: 0.0% (0us) | Total: 0.2% (4.8ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (3)

**Calls:**
- `_nodesFromRange` (3)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 100.0% (1.86s) | Samples: 0

**Calls:**
- `parseModule` (1217)

### `scope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:745` | Self: 0.0% (0us) | Total: 0.1% (3.0ms) | Samples: 0

**Called by:**
- `_computeVariableSynthRefs` (2)

**Calls:**
- `_computeVarScope` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2066` | Self: 0.0% (0us) | Total: 0.9% (17.7ms) | Samples: 0

**Called by:**
- `_buildReference` (8)
- `_buildScope` (4)

**Calls:**
- `_buildScope` (5)
- `_buildScope` (4)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` | Self: 0.0% (0us) | Total: 71.7% (1.33s) | Samples: 0

**Called by:**
- `_invokeFused` (873)

**Calls:**
- `collectUnusedVariables` (855)
- `collectUnusedVariables` (12)
- `collectUnusedVariables` (5)
- `collectUnusedVariables` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:543` | Self: 0.0% (0us) | Total: 0.1% (2.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `performProxyObjectGet` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` | Self: 0.0% (0us) | Total: 0.1% (3.3ms) | Samples: 0

**Called by:**
- `parseModule` (2)

**Calls:**
- `bound require` (2)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:506` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_computeVarDefs` (1)

**Calls:**
- `has` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7522` | Self: 0.0% (0us) | Total: 95.0% (1.77s) | Samples: 0

**Called by:**
- `async (anonymous)` (1007)
- `async (anonymous)` (151)

**Calls:**
- `walkNodes` (930)
- `walkNodes` (154)
- `walkNodes` (18)
- `walkNodes` (18)
- `walkNodes` (7)
- `walkNodes` (7)
- `walkNodes` (6)
- `walkNodes` (6)
- `walkNodes` (5)
- `walkNodes` (2)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:747` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `defs` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.1% (2.8ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` | Self: 0.0% (0us) | Total: 1.0% (19.8ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (13)

**Calls:**
- `getFunctionDefinitions` (8)
- `getFunctionDefinitions` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.2% (4.3ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:845` | Self: 0.0% (0us) | Total: 1.9% (35.7ms) | Samples: 0

**Called by:**
- `get` (23)
- `_ensureVarsSet` (1)

**Calls:**
- `_buildScopeVarsAndSet` (7)
- `_buildScopeVarsAndSet` (6)
- `_buildScopeVarsAndSet` (3)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)

### `parseModule`
`[native code]` | Self: 0.0% (0us) | Total: 100.0% (1.86s) | Samples: 0

**Called by:**
- `async (anonymous)` (1217)

**Calls:**
- `(anonymous)` (1215)
- `(anonymous)` (2)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3101` | Self: 0.0% (0us) | Total: 21.8% (407.2ms) | Samples: 0

**Called by:**
- `isAfterLastUsedArg` (262)

**Calls:**
- `_computeDeclaredVariables` (58)
- `_computeDeclaredVariables` (44)
- `_computeDeclaredVariables` (40)
- `_computeDeclaredVariables` (33)
- `_computeDeclaredVariables` (24)
- `_computeDeclaredVariables` (23)
- `_computeDeclaredVariables` (20)
- `_computeDeclaredVariables` (7)
- `_computeDeclaredVariables` (6)
- `_computeDeclaredVariables` (5)
- `_computeDeclaredVariables` (1)
- `_computeDeclaredVariables` (1)

### `get defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` | Self: 0.0% (0us) | Total: 0.4% (7.5ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (5)

**Calls:**
- `_computeVarDefs` (3)
- `_computeVarDefs` (1)
- `_computeVarDefs` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:45` | Self: 0.0% (0us) | Total: 0.1% (3.4ms) | Samples: 0

**Called by:**
- `async (anonymous)` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `forEach` (1)

**Calls:**
- `get init` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:957` | Self: 0.0% (0us) | Total: 0.1% (3.0ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (2)

**Calls:**
- `_ensureChildren` (2)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` | Self: 0.0% (0us) | Total: 22.5% (419.8ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (270)

**Calls:**
- `getDeclaredVariables` (262)
- `getDeclaredVariables` (4)
- `getDeclaredVariables` (2)
- `_computeDeclaredVariables` (1)
- `getDeclaredVariables` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2782` | Self: 0.0% (0us) | Total: 0.8% (15.5ms) | Samples: 0

**Called by:**
- `defs` (7)
- `get defs` (3)

**Calls:**
- `_findDefNode` (6)
- `_findDefNode` (2)
- `_findDefNode` (1)
- `_findDefNode` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2186` | Self: 0.0% (0us) | Total: 0.5% (10.8ms) | Samples: 0

**Called by:**
- `_buildScope` (7)

**Calls:**
- `get body` (3)
- `get body` (2)
- `get body` (1)
- `get body` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2589` | Self: 0.0% (0us) | Total: 0.1% (3.0ms) | Samples: 0

**Called by:**
- `_ensureChildren` (2)

**Calls:**
- `_buildScope` (2)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2900` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `get references` (1)

**Calls:**
- `nodeView` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` | Self: 0.0% (0us) | Total: 0.9% (18.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (12)

**Calls:**
- `isInLoop` (12)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:29` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2190` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_buildScope` (1)

**Calls:**
- `get directive` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2833` | Self: 0.0% (0us) | Total: 1.6% (30.5ms) | Samples: 0

**Called by:**
- `get references` (19)

**Calls:**
- `_nodeViewRaw` (8)
- `_nodeViewRaw` (6)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:551` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isInside` (1)

### `get init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2930` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `nodeViewChain` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2029` | Self: 0.0% (0us) | Total: 0.0% (1.1ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `_symName` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` | Self: 0.0% (0us) | Total: 0.6% (12.2ms) | Samples: 0

**Called by:**
- `some` (8)

**Calls:**
- `isSelfReference` (8)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 37.8% | 706.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 25.5% | 477.1ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 19.3% | 360.3ms | `[native code]` |
| 16.9% | 315.9ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 2.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js` |
| 0.0% | 1.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs` |
| 0.0% | 1.2ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
