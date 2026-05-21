# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 1.53s | 1003 | 1.0ms | 314 |

**Top 10:** `parse` 25.3%, `setPrototypeDirect` 5.2%, `walkNodes` 3.8%, `get parent` 2.9%, `_nodeViewRaw` 2.8%, `_nodeViewRaw` 2.8%, `_nodeViewRaw` 2.6%, `_ensureDeclSymIndex` 2.6%, `_nodeViewRaw` 2.5%, `_nodeViewRaw` 2.2%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 25.3% | 389.4ms | 25.3% | 389.4ms | `parse` | `[native code]` |
| 5.2% | 80.6ms | 5.2% | 80.6ms | `setPrototypeDirect` | `[native code]` |
| 3.8% | 58.4ms | 3.8% | 58.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7017` |
| 2.9% | 45.2ms | 11.8% | 181.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1208` |
| 2.8% | 44.0ms | 2.8% | 44.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4042` |
| 2.8% | 43.9ms | 5.7% | 88.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4037` |
| 2.6% | 40.3ms | 2.6% | 40.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4026` |
| 2.6% | 39.9ms | 2.7% | 41.5ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2017` |
| 2.5% | 38.9ms | 2.5% | 38.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4033` |
| 2.2% | 34.9ms | 2.2% | 34.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4024` |
| 1.7% | 27.6ms | 1.7% | 27.6ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1018` |
| 1.3% | 20.0ms | 1.3% | 20.0ms | `Set` | `[native code]` |
| 1.2% | 19.9ms | 1.2% | 19.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6743` |
| 1.1% | 17.3ms | 1.1% | 17.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3166` |
| 1.0% | 16.7ms | 1.0% | 16.7ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` |
| 1.0% | 15.8ms | 1.0% | 15.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4019` |
| 1.0% | 15.6ms | 3.5% | 55.2ms | `anonymous` | `[native code]` |
| 1.0% | 15.5ms | 1.3% | 21.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 0.9% | 15.0ms | 1.0% | 16.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2868` |
| 0.9% | 14.2ms | 2.4% | 37.7ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` |
| 0.8% | 12.8ms | 0.8% | 12.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1188` |
| 0.8% | 12.3ms | 0.8% | 12.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3172` |
| 0.7% | 11.5ms | 0.7% | 11.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2229` |
| 0.7% | 11.2ms | 0.8% | 12.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2223` |
| 0.7% | 10.9ms | 0.7% | 10.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1241` |
| 0.6% | 9.9ms | 0.6% | 9.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2215` |
| 0.6% | 9.6ms | 0.6% | 9.6ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.6% | 9.3ms | 6.1% | 94.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2087` |
| 0.5% | 8.8ms | 0.5% | 8.8ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.5% | 8.8ms | 0.5% | 8.8ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2846` |
| 0.5% | 8.7ms | 0.5% | 8.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2107` |
| 0.5% | 8.4ms | 0.5% | 8.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2432` |
| 0.5% | 8.1ms | 0.5% | 8.1ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1020` |
| 0.5% | 8.0ms | 0.5% | 8.0ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.5% | 8.0ms | 28.4% | 436.8ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 0.5% | 7.9ms | 0.5% | 7.9ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2840` |
| 0.5% | 7.8ms | 0.5% | 7.8ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:829` |
| 0.4% | 7.6ms | 0.4% | 7.6ms | `get` | `[native code]` |
| 0.4% | 7.3ms | 0.4% | 7.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4036` |
| 0.4% | 7.2ms | 0.4% | 7.2ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1016` |
| 0.4% | 6.9ms | 0.4% | 6.9ms | `decode` | `[native code]` |
| 0.4% | 6.9ms | 0.4% | 6.9ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.4% | 6.9ms | 0.4% | 6.9ms | `test` | `[native code]` |
| 0.4% | 6.8ms | 0.6% | 10.3ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 0.4% | 6.5ms | 0.4% | 6.5ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2745` |
| 0.4% | 6.4ms | 1.0% | 16.8ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2792` |
| 0.4% | 6.4ms | 0.4% | 6.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.4% | 6.3ms | 4.8% | 73.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2213` |
| 0.4% | 6.1ms | 0.4% | 6.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1314` |
| 0.3% | 5.9ms | 0.6% | 10.5ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` |
| 0.3% | 5.9ms | 0.3% | 5.9ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2808` |
| 0.3% | 5.8ms | 0.3% | 5.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2428` |
| 0.3% | 5.3ms | 1.1% | 17.1ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2320` |
| 0.3% | 5.0ms | 0.3% | 5.0ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2727` |
| 0.3% | 4.6ms | 0.9% | 14.4ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3160` |
| 0.3% | 4.6ms | 0.3% | 4.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` |
| 0.2% | 4.5ms | 6.0% | 92.6ms | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 0.2% | 4.5ms | 7.7% | 119.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2844` |
| 0.2% | 4.5ms | 0.6% | 10.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2071` |
| 0.2% | 4.4ms | 0.2% | 4.4ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:589` |
| 0.2% | 4.3ms | 0.2% | 4.3ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4286` |
| 0.2% | 4.3ms | 0.2% | 4.3ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6476` |
| 0.2% | 4.3ms | 0.2% | 4.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2130` |
| 0.2% | 4.2ms | 0.2% | 4.2ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:630` |
| 0.2% | 4.1ms | 0.2% | 4.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4034` |
| 0.2% | 4.0ms | 0.2% | 4.0ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2787` |
| 0.2% | 3.6ms | 1.3% | 20.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2222` |
| 0.2% | 3.4ms | 1.4% | 22.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` |
| 0.2% | 3.4ms | 0.2% | 3.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7019` |
| 0.2% | 3.3ms | 0.2% | 3.3ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2586` |
| 0.2% | 3.3ms | 1.8% | 28.2ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2763` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3921` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `set` | `[native code]` |
| 0.2% | 3.1ms | 0.2% | 3.1ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2734` |
| 0.2% | 3.1ms | 0.2% | 3.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1256` |
| 0.1% | 3.0ms | 1.5% | 23.0ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4035` |
| 0.1% | 2.9ms | 0.3% | 5.9ms | `readdirSync` | `[native code]` |
| 0.1% | 2.9ms | 2.0% | 32.1ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:879` |
| 0.1% | 2.9ms | 0.3% | 4.7ms | `exec` | `[native code]` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 2.9ms | 0.8% | 13.0ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2900` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1220` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4040` |
| 0.1% | 2.9ms | 0.6% | 10.4ms | `scope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:745` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2018` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2052` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:876` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `has` | `[native code]` |
| 0.1% | 2.7ms | 2.0% | 31.4ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` |
| 0.1% | 2.7ms | 5.4% | 83.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4031` |
| 0.1% | 2.7ms | 0.2% | 4.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2698` |
| 0.1% | 2.6ms | 0.1% | 2.6ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.1% | 2.6ms | 0.3% | 5.3ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.1% | 2.5ms | 0.1% | 2.5ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2593` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4053` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `push` | `[native code]` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` |
| 0.1% | 1.7ms | 8.7% | 134.0ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2833` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1367` |
| 0.1% | 1.7ms | 0.7% | 11.3ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2946` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3185` |
| 0.1% | 1.7ms | 0.3% | 4.6ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2677` |
| 0.1% | 1.7ms | 0.2% | 3.1ms | `getUpperFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:134` |
| 0.1% | 1.7ms | 0.2% | 3.2ms | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2946` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3653` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `isReadRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:431` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `DataView` | `[native code]` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:591` |
| 0.1% | 1.7ms | 10.9% | 168.3ms | `some` | `[native code]` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_isStatementTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:76` |
| 0.1% | 1.7ms | 0.5% | 8.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3170` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `async _loadFlatConfig` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:37` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7188` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.6ms | 0.2% | 4.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2020` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `get left` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1257` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2815` |
| 0.1% | 1.6ms | 11.0% | 170.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3086` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2321` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:676` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6474` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1039` |
| 0.1% | 1.5ms | 4.6% | 71.4ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` |
| 0.1% | 1.5ms | 0.2% | 3.1ms | `readFileSync` | `[native code]` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3370` |
| 0.1% | 1.5ms | 0.5% | 8.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:587` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `RegExp` | `[native code]` |
| 0.0% | 1.4ms | 0.2% | 3.1ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2032` |
| 0.0% | 1.4ms | 0.1% | 2.7ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2015` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4107` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2230` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2436` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4041` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:819` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2113` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `dlopen` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3146` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `fetch` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `encodeInto` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:654` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:892` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `/^(?:Function(?:Declaration\|Expression)\|ArrowFunctionExpression)$/u` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1744` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4076` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `assign` | `[native code]` |
| 0.0% | 1.3ms | 6.5% | 100.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2066` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.0% | 1.3ms | 0.6% | 10.6ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:813` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3099` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getUint32` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:887` |
| 0.0% | 1.2ms | 4.4% | 69.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1508` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3102` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:588` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3159` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.8% | 12.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` |
| 0.0% | 1.2ms | 7.2% | 112.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 0.0% | 1.1ms | 0.0% | 1.1ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1522` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 100.0% | 3.32s | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 72.4% | 1.11s | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:304` |
| 71.8% | 1.10s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7540` |
| 65.8% | 1.01s | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4672` |
| 65.8% | 1.01s | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7256` |
| 64.0% | 984.9ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` |
| 28.4% | 436.8ms | 0.5% | 8.0ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 26.0% | 399.5ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 25.7% | 395.6ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:300` |
| 25.3% | 389.4ms | 25.3% | 389.4ms | `parse` | `[native code]` |
| 25.2% | 388.1ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` |
| 13.4% | 206.6ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 11.8% | 181.7ms | 2.9% | 45.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1208` |
| 11.7% | 179.9ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:845` |
| 11.5% | 178.1ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:953` |
| 11.0% | 170.0ms | 0.1% | 1.6ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` |
| 10.9% | 168.3ms | 0.1% | 1.7ms | `some` | `[native code]` |
| 9.0% | 138.3ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2837` |
| 8.7% | 134.0ms | 0.1% | 1.7ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2833` |
| 7.7% | 119.6ms | 0.2% | 4.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2844` |
| 7.2% | 112.0ms | 0.0% | 1.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 6.5% | 100.1ms | 0.0% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2066` |
| 6.1% | 94.9ms | 0.6% | 9.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2087` |
| 6.0% | 93.4ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` |
| 6.0% | 92.6ms | 0.2% | 4.5ms | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 5.7% | 88.4ms | 2.8% | 43.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4037` |
| 5.6% | 87.4ms | 0.0% | 0us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3101` |
| 5.5% | 85.7ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` |
| 5.4% | 83.3ms | 0.1% | 2.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4031` |
| 5.2% | 80.6ms | 5.2% | 80.6ms | `setPrototypeDirect` | `[native code]` |
| 4.8% | 73.9ms | 0.4% | 6.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2213` |
| 4.6% | 71.4ms | 0.1% | 1.5ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 4.6% | 70.7ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:752` |
| 4.4% | 69.0ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` |
| 4.1% | 63.7ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2186` |
| 3.8% | 58.4ms | 3.8% | 58.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7017` |
| 3.5% | 55.2ms | 1.0% | 15.6ms | `anonymous` | `[native code]` |
| 3.5% | 55.0ms | 0.0% | 0us | `bound require` | `[native code]` |
| 3.3% | 50.8ms | 0.0% | 0us | `require` | `[native code]` |
| 2.8% | 44.0ms | 2.8% | 44.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4042` |
| 2.7% | 41.5ms | 2.6% | 39.9ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2017` |
| 2.6% | 40.3ms | 2.6% | 40.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4026` |
| 2.5% | 38.9ms | 2.5% | 38.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4033` |
| 2.5% | 38.8ms | 0.0% | 0us | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2782` |
| 2.4% | 37.7ms | 0.9% | 14.2ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` |
| 2.3% | 36.7ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1710` |
| 2.2% | 34.9ms | 2.2% | 34.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4024` |
| 2.2% | 34.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 2.0% | 32.1ms | 0.1% | 2.9ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:879` |
| 2.0% | 31.4ms | 0.1% | 2.7ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` |
| 1.8% | 28.2ms | 0.2% | 3.3ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2763` |
| 1.7% | 27.6ms | 1.7% | 27.6ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1018` |
| 1.7% | 27.5ms | 0.0% | 0us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1898` |
| 1.7% | 27.5ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` |
| 1.5% | 23.0ms | 0.1% | 3.0ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` |
| 1.4% | 22.8ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2673` |
| 1.4% | 22.8ms | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 1.4% | 22.6ms | 0.2% | 3.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` |
| 1.3% | 21.4ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1730` |
| 1.3% | 21.4ms | 1.0% | 15.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 1.3% | 20.7ms | 0.2% | 3.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2222` |
| 1.3% | 20.0ms | 0.0% | 0us | `parseModule` | `[native code]` |
| 1.3% | 20.0ms | 1.3% | 20.0ms | `Set` | `[native code]` |
| 1.2% | 19.9ms | 1.2% | 19.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6743` |
| 1.2% | 19.6ms | 0.0% | 0us | `_ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:924` |
| 1.2% | 19.6ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:957` |
| 1.1% | 18.0ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` |
| 1.1% | 17.3ms | 1.1% | 17.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3166` |
| 1.1% | 17.1ms | 0.3% | 5.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2320` |
| 1.1% | 17.1ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2167` |
| 1.0% | 16.8ms | 0.4% | 6.4ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2792` |
| 1.0% | 16.7ms | 1.0% | 16.7ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` |
| 1.0% | 16.5ms | 0.9% | 15.0ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2868` |
| 1.0% | 15.9ms | 0.0% | 0us | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` |
| 1.0% | 15.8ms | 1.0% | 15.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4019` |
| 1.0% | 15.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` |
| 1.0% | 15.7ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:72` |
| 1.0% | 15.7ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` |
| 0.9% | 14.6ms | 0.0% | 0us | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 0.9% | 14.6ms | 0.0% | 0us | `forEach` | `[native code]` |
| 0.9% | 14.4ms | 0.3% | 4.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3160` |
| 0.8% | 13.6ms | 0.0% | 0us | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2589` |
| 0.8% | 13.0ms | 0.1% | 2.9ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2900` |
| 0.8% | 12.9ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` |
| 0.8% | 12.8ms | 0.8% | 12.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1188` |
| 0.8% | 12.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` |
| 0.8% | 12.6ms | 0.7% | 11.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2223` |
| 0.8% | 12.3ms | 0.8% | 12.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3172` |
| 0.7% | 12.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` |
| 0.7% | 11.5ms | 0.7% | 11.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2229` |
| 0.7% | 11.3ms | 0.1% | 1.7ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2946` |
| 0.7% | 10.9ms | 0.7% | 10.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1241` |
| 0.6% | 10.6ms | 0.0% | 1.3ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:813` |
| 0.6% | 10.5ms | 0.3% | 5.9ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` |
| 0.6% | 10.4ms | 0.1% | 2.9ms | `scope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:745` |
| 0.6% | 10.4ms | 0.0% | 0us | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2895` |
| 0.6% | 10.3ms | 0.2% | 4.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2071` |
| 0.6% | 10.3ms | 0.4% | 6.8ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 0.6% | 9.9ms | 0.6% | 9.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2215` |
| 0.6% | 9.6ms | 0.6% | 9.6ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.6% | 9.3ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2029` |
| 0.5% | 8.8ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:967` |
| 0.5% | 8.8ms | 0.5% | 8.8ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.5% | 8.8ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:972` |
| 0.5% | 8.8ms | 0.5% | 8.8ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2846` |
| 0.5% | 8.7ms | 0.5% | 8.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2107` |
| 0.5% | 8.5ms | 0.1% | 1.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:587` |
| 0.5% | 8.4ms | 0.5% | 8.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2432` |
| 0.5% | 8.3ms | 0.1% | 1.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3170` |
| 0.5% | 8.1ms | 0.5% | 8.1ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1020` |
| 0.5% | 8.0ms | 0.5% | 8.0ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.5% | 7.9ms | 0.5% | 7.9ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2840` |
| 0.5% | 7.8ms | 0.5% | 7.8ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:829` |
| 0.4% | 7.6ms | 0.4% | 7.6ms | `get` | `[native code]` |
| 0.4% | 7.4ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7532` |
| 0.4% | 7.3ms | 0.4% | 7.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4036` |
| 0.4% | 7.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:458` |
| 0.4% | 7.3ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` |
| 0.4% | 7.2ms | 0.4% | 7.2ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1016` |
| 0.4% | 6.9ms | 0.4% | 6.9ms | `decode` | `[native code]` |
| 0.4% | 6.9ms | 0.0% | 0us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:522` |
| 0.4% | 6.9ms | 0.4% | 6.9ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.4% | 6.9ms | 0.4% | 6.9ms | `test` | `[native code]` |
| 0.4% | 6.9ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:586` |
| 0.4% | 6.5ms | 0.4% | 6.5ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2745` |
| 0.4% | 6.4ms | 0.4% | 6.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.4% | 6.1ms | 0.4% | 6.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1314` |
| 0.3% | 6.1ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` |
| 0.3% | 5.9ms | 0.1% | 2.9ms | `readdirSync` | `[native code]` |
| 0.3% | 5.9ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7016` |
| 0.3% | 5.9ms | 0.3% | 5.9ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2808` |
| 0.3% | 5.8ms | 0.3% | 5.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2428` |
| 0.3% | 5.3ms | 0.1% | 2.6ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.3% | 5.1ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2227` |
| 0.3% | 5.0ms | 0.3% | 5.0ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2727` |
| 0.3% | 4.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.3% | 4.7ms | 0.1% | 2.9ms | `exec` | `[native code]` |
| 0.3% | 4.6ms | 0.1% | 1.7ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2677` |
| 0.3% | 4.6ms | 0.3% | 4.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` |
| 0.2% | 4.4ms | 0.1% | 2.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` |
| 0.2% | 4.4ms | 0.2% | 4.4ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:589` |
| 0.2% | 4.4ms | 0.1% | 1.6ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2020` |
| 0.2% | 4.3ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:452` |
| 0.2% | 4.3ms | 0.2% | 4.3ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4286` |
| 0.2% | 4.3ms | 0.2% | 4.3ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6476` |
| 0.2% | 4.3ms | 0.2% | 4.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2130` |
| 0.2% | 4.2ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2225` |
| 0.2% | 4.2ms | 0.2% | 4.2ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:630` |
| 0.2% | 4.1ms | 0.2% | 4.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4034` |
| 0.2% | 4.0ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2322` |
| 0.2% | 4.0ms | 0.2% | 4.0ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2787` |
| 0.2% | 3.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` |
| 0.2% | 3.4ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1513` |
| 0.2% | 3.4ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2081` |
| 0.2% | 3.4ms | 0.2% | 3.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7019` |
| 0.2% | 3.3ms | 0.2% | 3.3ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2586` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3921` |
| 0.2% | 3.2ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4104` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `set` | `[native code]` |
| 0.2% | 3.2ms | 0.1% | 1.7ms | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2946` |
| 0.2% | 3.1ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2168` |
| 0.2% | 3.1ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2016` |
| 0.2% | 3.1ms | 0.0% | 1.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2032` |
| 0.2% | 3.1ms | 0.0% | 0us | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:506` |
| 0.2% | 3.1ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:557` |
| 0.2% | 3.1ms | 0.0% | 0us | `isInsideOfStorableFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:630` |
| 0.2% | 3.1ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:662` |
| 0.2% | 3.1ms | 0.1% | 1.7ms | `getUpperFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:134` |
| 0.2% | 3.1ms | 0.1% | 1.5ms | `readFileSync` | `[native code]` |
| 0.2% | 3.1ms | 0.2% | 3.1ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2734` |
| 0.2% | 3.1ms | 0.2% | 3.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1256` |
| 0.1% | 3.0ms | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:484` |
| 0.1% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4035` |
| 0.1% | 2.9ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:47` |
| 0.1% | 2.9ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:144` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1220` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4040` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2018` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2052` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:876` |
| 0.1% | 2.8ms | 0.0% | 0us | `(anonymous)` | `[native code]` |
| 0.1% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` |
| 0.1% | 2.7ms | 0.0% | 1.4ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `has` | `[native code]` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2698` |
| 0.1% | 2.7ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1733` |
| 0.1% | 2.6ms | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:519` |
| 0.1% | 2.6ms | 0.1% | 2.6ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.1% | 2.5ms | 0.1% | 2.5ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2593` |
| 0.1% | 2.4ms | 0.0% | 0us | `identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:756` |
| 0.1% | 2.4ms | 0.0% | 0us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1247` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4053` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `push` | `[native code]` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 1.7ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:881` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1367` |
| 0.1% | 1.7ms | 0.0% | 0us | `map` | `[native code]` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3185` |
| 0.1% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3653` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `isReadRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:431` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `DataView` | `[native code]` |
| 0.1% | 1.7ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:279` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:591` |
| 0.1% | 1.7ms | 0.0% | 0us | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3643` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_isStatementTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:76` |
| 0.1% | 1.7ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.1% | 1.7ms | 0.0% | 0us | `async lintSource` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:462` |
| 0.1% | 1.7ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:76` |
| 0.1% | 1.7ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:77` |
| 0.1% | 1.7ms | 0.0% | 0us | `async _resolveConfig` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:68` |
| 0.1% | 1.7ms | 0.0% | 0us | `async lintSource` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:461` |
| 0.1% | 1.7ms | 0.0% | 0us | `async _resolveConfig` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:71` |
| 0.1% | 1.7ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:85` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `async _loadFlatConfig` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:37` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7188` |
| 0.1% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.1% | 1.6ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2869` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` |
| 0.1% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `get left` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 1.6ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:558` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1257` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2815` |
| 0.1% | 1.6ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3168` |
| 0.1% | 1.6ms | 0.0% | 0us | `get identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:756` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3086` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2321` |
| 0.1% | 1.6ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1729` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:676` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6474` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1039` |
| 0.1% | 1.6ms | 0.0% | 0us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4003` |
| 0.1% | 1.5ms | 0.0% | 0us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:689` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` |
| 0.1% | 1.5ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2031` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:35` |
| 0.1% | 1.5ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.1% | 1.5ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2190` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3370` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `RegExp` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 0us | `buildUnicodeData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:3986` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:3999` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` |
| 0.0% | 1.5ms | 0.0% | 0us | `wordsRegexp` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:285` |
| 0.0% | 1.5ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3113` |
| 0.0% | 1.5ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:747` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2015` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4107` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2230` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2436` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4041` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:819` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2113` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `dlopen` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `loadBinding` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` |
| 0.0% | 1.4ms | 0.0% | 0us | `getTagNames` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:186` |
| 0.0% | 1.4ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:288` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3146` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6646` |
| 0.0% | 1.3ms | 0.0% | 0us | `_getOrBuildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5571` |
| 0.0% | 1.3ms | 0.0% | 0us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5889` |
| 0.0% | 1.3ms | 0.0% | 0us | `requestSatisfyUtil` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `fetch` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `requestFetch` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `requestInstantiate` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:215` |
| 0.0% | 1.3ms | 0.0% | 0us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:92` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `encodeInto` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:654` |
| 0.0% | 1.3ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:561` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:892` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `/^(?:Function(?:Declaration\|Expression)\|ArrowFunctionExpression)$/u` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:840` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1744` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4076` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:12` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `assign` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:195` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:880` |
| 0.0% | 1.3ms | 0.0% | 0us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2701` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3099` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getUint32` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:887` |
| 0.0% | 1.2ms | 0.0% | 0us | `tryParse` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:126` |
| 0.0% | 1.2ms | 0.0% | 0us | `_getPlugin` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:60` |
| 0.0% | 1.2ms | 0.0% | 0us | `describeRule` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:30` |
| 0.0% | 1.2ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7539` |
| 0.0% | 1.2ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4332` |
| 0.0% | 1.2ms | 0.0% | 0us | `_loadFromDisk` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:69` |
| 0.0% | 1.2ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:855` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1508` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3102` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:588` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3159` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:22` |
| 0.0% | 1.1ms | 0.0% | 1.1ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1522` |
| 0.0% | 1.1ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7535` |

## Function Details

### `parse`
`[native code]` | Self: 25.3% (389.4ms) | Total: 25.3% (389.4ms) | Samples: 255

**Called by:**
- `parseSource` (254)
- `tryParse` (1)

### `setPrototypeDirect`
`[native code]` | Self: 5.2% (80.6ms) | Total: 5.2% (80.6ms) | Samples: 54

**Called by:**
- `_nodeViewRaw` (54)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7017` | Self: 3.8% (58.4ms) | Total: 3.8% (58.4ms) | Samples: 38

**Called by:**
- `runPlugins` (38)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1208` | Self: 2.9% (45.2ms) | Total: 11.8% (181.7ms) | Samples: 29

**Called by:**
- `_buildReference` (84)
- `_findDefNode` (13)
- `_computeVarDefs` (7)
- `_computeIsStrict` (7)
- `isUnusedExpression` (2)
- `isForInOfRef` (2)
- `_findDefNode` (2)
- `(anonymous)` (1)
- `_findDefNode` (1)

**Calls:**
- `_nodeViewRaw` (25)
- `_nodeViewRaw` (15)
- `_nodeViewRaw` (15)
- `_nodeViewRaw` (10)
- `_nodeViewRaw` (8)
- `_nodeViewRaw` (6)
- `_nodeViewRaw` (5)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `nodeView` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4042` | Self: 2.8% (44.0ms) | Total: 2.8% (44.0ms) | Samples: 28

**Called by:**
- `_buildReference` (17)
- `get parent` (8)
- `_buildScope` (1)
- `init` (1)
- `_computeVarDefs` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4037` | Self: 2.8% (43.9ms) | Total: 5.7% (88.4ms) | Samples: 29

**Called by:**
- `_buildReference` (24)
- `get parent` (15)
- `_computeVarDefs` (6)
- `_nodesFromRange` (6)
- `get body` (3)
- `_computeVariableSynthRefs` (1)
- `getRhsNode` (1)
- `_buildScope` (1)
- `init` (1)

**Calls:**
- `_computeNodeType` (18)
- `_computeNodeType` (5)
- `_computeNodeType` (5)
- `_computeNodeType` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4026` | Self: 2.6% (40.3ms) | Total: 2.6% (40.3ms) | Samples: 26

**Called by:**
- `_buildReference` (10)
- `get parent` (5)
- `_computeVarDefs` (5)
- `_nodesFromRange` (2)
- `_computeVariableSynthRefs` (1)
- `get body` (1)
- `_buildScope` (1)
- `init` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2017` | Self: 2.6% (39.9ms) | Total: 2.7% (41.5ms) | Samples: 27

**Called by:**
- `_buildScopeVarsAndSet` (28)

**Calls:**
- `set` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4033` | Self: 2.5% (38.9ms) | Total: 2.5% (38.9ms) | Samples: 26

**Called by:**
- `get parent` (25)
- `_computeVariableSynthRefs` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4024` | Self: 2.2% (34.9ms) | Total: 2.2% (34.9ms) | Samples: 23

**Called by:**
- `get parent` (15)
- `_buildReference` (4)
- `_computeVariableSynthRefs` (3)
- `_buildScope` (1)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1018` | Self: 1.7% (27.6ms) | Total: 1.7% (27.6ms) | Samples: 18

**Called by:**
- `_nodeViewRaw` (18)

### `Set`
`[native code]` | Self: 1.3% (20.0ms) | Total: 1.3% (20.0ms) | Samples: 13

**Called by:**
- `_computeDeclaredVariables` (13)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6743` | Self: 1.2% (19.9ms) | Total: 1.2% (19.9ms) | Samples: 14

**Called by:**
- `runPlugins` (14)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3166` | Self: 1.1% (17.3ms) | Total: 1.1% (17.3ms) | Samples: 12

**Called by:**
- `getDeclaredVariables` (12)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` | Self: 1.0% (16.7ms) | Total: 1.0% (16.7ms) | Samples: 11

**Called by:**
- `getRhsNode` (11)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4019` | Self: 1.0% (15.8ms) | Total: 1.0% (15.8ms) | Samples: 10

**Called by:**
- `get parent` (6)
- `_nodesFromRange` (3)
- `get body` (1)

### `anonymous`
`[native code]` | Self: 1.0% (15.6ms) | Total: 3.5% (55.2ms) | Samples: 10

**Called by:**
- `require` (33)
- `bound require` (2)
- `node:fs` (1)

**Calls:**
- `(anonymous)` (8)
- `(anonymous)` (5)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:fs` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` | Self: 1.0% (15.5ms) | Total: 1.3% (21.4ms) | Samples: 9

**Called by:**
- `some` (13)

**Calls:**
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2868` | Self: 0.9% (15.0ms) | Total: 1.0% (16.5ms) | Samples: 10

**Called by:**
- `get references` (11)

**Calls:**
- `get parent` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` | Self: 0.9% (14.2ms) | Total: 2.4% (37.7ms) | Samples: 8

**Called by:**
- `collectUnusedVariables` (11)
- `(anonymous)` (8)
- `_computeDeclaredVariables` (2)
- `_buildScopeVarsAndSet` (1)
- `isUsedVariable` (1)

**Calls:**
- `_computeVariableSynthRefs` (9)
- `_computeVariableSynthRefs` (6)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1188` | Self: 0.8% (12.8ms) | Total: 0.8% (12.8ms) | Samples: 8

**Called by:**
- `(anonymous)` (2)
- `_findDefNode` (2)
- `isReadForItself` (1)
- `getRhsNode` (1)
- `_buildReference` (1)
- `_buildReference` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3172` | Self: 0.8% (12.3ms) | Total: 0.8% (12.3ms) | Samples: 8

**Called by:**
- `getDeclaredVariables` (8)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2229` | Self: 0.7% (11.5ms) | Total: 0.7% (11.5ms) | Samples: 8

**Called by:**
- `_ensureVarsSet` (8)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2223` | Self: 0.7% (11.2ms) | Total: 0.8% (12.6ms) | Samples: 7

**Called by:**
- `_ensureVarsSet` (8)

**Calls:**
- `get` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1241` | Self: 0.7% (10.9ms) | Total: 0.7% (10.9ms) | Samples: 7

**Called by:**
- `_computeIsStrict` (3)
- `_buildReference` (3)
- `isReadForItself` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2215` | Self: 0.6% (9.9ms) | Total: 0.6% (9.9ms) | Samples: 7

**Called by:**
- `_ensureVarsSet` (7)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.6% (9.6ms) | Total: 0.6% (9.6ms) | Samples: 7

**Called by:**
- `commentsInRange` (4)
- `commentsInRange` (3)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2087` | Self: 0.6% (9.3ms) | Total: 6.1% (94.9ms) | Samples: 6

**Called by:**
- `_buildScope` (34)
- `_buildReference` (21)
- `_buildScopeChildren` (8)

**Calls:**
- `_computeIsStrict` (43)
- `_computeIsStrict` (11)
- `_computeIsStrict` (2)
- `_computeIsStrict` (1)

### `/\/\*([\s\S]*?)\*\//g`
`[native code]` | Self: 0.5% (8.8ms) | Total: 0.5% (8.8ms) | Samples: 6

**Called by:**
- `_buildScopeVarsAndSet` (5)
- `exec` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2846` | Self: 0.5% (8.8ms) | Total: 0.5% (8.8ms) | Samples: 6

**Called by:**
- `get references` (6)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2107` | Self: 0.5% (8.7ms) | Total: 0.5% (8.7ms) | Samples: 6

**Called by:**
- `_buildReference` (3)
- `_buildScope` (3)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2432` | Self: 0.5% (8.4ms) | Total: 0.5% (8.4ms) | Samples: 5

**Called by:**
- `_ensureVarsSet` (5)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1020` | Self: 0.5% (8.1ms) | Total: 0.5% (8.1ms) | Samples: 5

**Called by:**
- `_nodeViewRaw` (5)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.5% (8.0ms) | Total: 0.5% (8.0ms) | Samples: 5

**Called by:**
- `_computeDeclaredVariables` (3)
- `_buildScopeVarsAndSet` (2)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` | Self: 0.5% (8.0ms) | Total: 28.4% (436.8ms) | Samples: 5

**Called by:**
- `collectUnusedVariables` (236)
- `(anonymous)` (35)
- `isUsedVariable` (10)
- `_buildScopeVarsAndSet` (2)
- `_computeDeclaredVariables` (1)

**Calls:**
- `_buildReference` (89)
- `_buildReference` (85)
- `_buildReference` (80)
- `_buildReference` (11)
- `_buildReference` (6)
- `_buildReference` (5)
- `_buildReference` (2)
- `_buildReference` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2840` | Self: 0.5% (7.9ms) | Total: 0.5% (7.9ms) | Samples: 5

**Called by:**
- `get references` (5)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:829` | Self: 0.5% (7.8ms) | Total: 0.5% (7.8ms) | Samples: 5

**Called by:**
- `_symName` (5)

### `get`
`[native code]` | Self: 0.4% (7.6ms) | Total: 0.4% (7.6ms) | Samples: 5

**Called by:**
- `_ensureDeclSymIndex` (2)
- `_ensureDeclSymIndex` (1)
- `_computeDeclaredVariables` (1)
- `_buildScopeVarsAndSet` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4036` | Self: 0.4% (7.3ms) | Total: 0.4% (7.3ms) | Samples: 5

**Called by:**
- `get parent` (3)
- `_buildReference` (2)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1016` | Self: 0.4% (7.2ms) | Total: 0.4% (7.2ms) | Samples: 5

**Called by:**
- `_nodeViewRaw` (5)

### `decode`
`[native code]` | Self: 0.4% (6.9ms) | Total: 0.4% (6.9ms) | Samples: 5

**Called by:**
- `get source` (5)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` | Self: 0.4% (6.9ms) | Total: 0.4% (6.9ms) | Samples: 5

**Called by:**
- `(anonymous)` (5)

### `test`
`[native code]` | Self: 0.4% (6.9ms) | Total: 0.4% (6.9ms) | Samples: 5

**Called by:**
- `_buildScopeVarsAndSet` (3)
- `_precomputeScopes` (2)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` | Self: 0.4% (6.8ms) | Total: 0.6% (10.3ms) | Samples: 4

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `get parent` (1)
- `get parent` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2745` | Self: 0.4% (6.5ms) | Total: 0.4% (6.5ms) | Samples: 4

**Called by:**
- `_buildScopeVarsAndSet` (2)
- `_computeDeclaredVariables` (2)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2792` | Self: 0.4% (6.4ms) | Total: 1.0% (16.8ms) | Samples: 4

**Called by:**
- `defs` (11)

**Calls:**
- `get parent` (7)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.4% (6.4ms) | Total: 0.4% (6.4ms) | Samples: 4

**Called by:**
- `(anonymous)` (1)
- `collectUnusedVariables` (1)
- `getRhsNode` (1)
- `_findDefNode` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2213` | Self: 0.4% (6.3ms) | Total: 4.8% (73.9ms) | Samples: 4

**Called by:**
- `_ensureVarsSet` (49)

**Calls:**
- `_ensureDeclSymIndex` (28)
- `_ensureDeclSymIndex` (6)
- `_ensureDeclSymIndex` (3)
- `_ensureDeclSymIndex` (2)
- `_ensureDeclSymIndex` (2)
- `_ensureDeclSymIndex` (2)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1314` | Self: 0.4% (6.1ms) | Total: 0.4% (6.1ms) | Samples: 4

**Called by:**
- `_buildReference` (1)
- `_findDefNode` (1)
- `_findDefNode` (1)
- `isForInOfRef` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` | Self: 0.3% (5.9ms) | Total: 0.6% (10.5ms) | Samples: 3

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `get parent` (2)
- `get parent` (1)

### `_computeVarScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2808` | Self: 0.3% (5.9ms) | Total: 0.3% (5.9ms) | Samples: 3

**Called by:**
- `scope` (3)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2428` | Self: 0.3% (5.8ms) | Total: 0.3% (5.8ms) | Samples: 4

**Called by:**
- `_ensureVarsSet` (4)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2320` | Self: 0.3% (5.3ms) | Total: 1.1% (17.1ms) | Samples: 4

**Called by:**
- `_ensureVarsSet` (12)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (5)
- `exec` (3)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2727` | Self: 0.3% (5.0ms) | Total: 0.3% (5.0ms) | Samples: 3

**Called by:**
- `_buildScopeVarsAndSet` (2)
- `_computeDeclaredVariables` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3160` | Self: 0.3% (4.6ms) | Total: 0.9% (14.4ms) | Samples: 3

**Called by:**
- `getDeclaredVariables` (9)

**Calls:**
- `_buildVariable` (3)
- `_buildVariable` (2)
- `_buildVariable` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` | Self: 0.3% (4.6ms) | Total: 0.3% (4.6ms) | Samples: 3

**Called by:**
- `getDeclaredVariables` (3)

### `defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` | Self: 0.2% (4.5ms) | Total: 6.0% (92.6ms) | Samples: 3

**Called by:**
- `collectUnusedVariables` (58)
- `identifiers` (2)
- `_ensureVarsSet` (1)
- `get identifiers` (1)
- `isAfterLastUsedArg` (1)

**Calls:**
- `_computeVarDefs` (27)
- `_computeVarDefs` (19)
- `_computeVarDefs` (11)
- `_computeVarDefs` (3)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2844` | Self: 0.2% (4.5ms) | Total: 7.7% (119.6ms) | Samples: 3

**Called by:**
- `get references` (80)

**Calls:**
- `_buildScope` (45)
- `_buildScope` (21)
- `_buildScope` (4)
- `_buildScope` (3)
- `_buildScope` (3)
- `_buildScope` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2071` | Self: 0.2% (4.5ms) | Total: 0.6% (10.3ms) | Samples: 3

**Called by:**
- `_buildReference` (4)
- `_buildScope` (2)
- `_buildScopeChildren` (1)

**Calls:**
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:589` | Self: 0.2% (4.4ms) | Total: 0.2% (4.4ms) | Samples: 3

**Called by:**
- `_precomputeScopes` (3)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4286` | Self: 0.2% (4.3ms) | Total: 0.2% (4.3ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6476` | Self: 0.2% (4.3ms) | Total: 0.2% (4.3ms) | Samples: 3

**Called by:**
- `walkNodes` (3)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2130` | Self: 0.2% (4.3ms) | Total: 0.2% (4.3ms) | Samples: 3

**Called by:**
- `_buildReference` (3)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:630` | Self: 0.2% (4.2ms) | Total: 0.2% (4.2ms) | Samples: 3

**Called by:**
- `commentsInRange` (2)
- `commentsInRange` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4034` | Self: 0.2% (4.1ms) | Total: 0.2% (4.1ms) | Samples: 3

**Called by:**
- `_buildReference` (3)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2787` | Self: 0.2% (4.0ms) | Total: 0.2% (4.0ms) | Samples: 3

**Called by:**
- `defs` (3)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2222` | Self: 0.2% (3.6ms) | Total: 1.3% (20.7ms) | Samples: 2

**Called by:**
- `_ensureVarsSet` (13)

**Calls:**
- `_buildVariable` (2)
- `_buildVariable` (2)
- `_buildVariable` (2)
- `_buildVariable` (2)
- `_buildVariable` (2)
- `_buildVariable` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` | Self: 0.2% (3.4ms) | Total: 1.4% (22.6ms) | Samples: 2

**Called by:**
- `some` (14)

**Calls:**
- `isForInOfRef` (6)
- `isForInOfRef` (5)
- `isForInOfRef` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7019` | Self: 0.2% (3.4ms) | Total: 0.2% (3.4ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2586` | Self: 0.2% (3.3ms) | Total: 0.2% (3.3ms) | Samples: 2

**Called by:**
- `_ensureChildren` (2)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2763` | Self: 0.2% (3.3ms) | Total: 1.8% (28.2ms) | Samples: 2

**Called by:**
- `defs` (19)

**Calls:**
- `_nodeViewRaw` (6)
- `_nodeViewRaw` (5)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `_isChainNode`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3921` | Self: 0.2% (3.2ms) | Total: 0.2% (3.2ms) | Samples: 2

**Called by:**
- `nodeViewChain` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` | Self: 0.2% (3.2ms) | Total: 0.2% (3.2ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (2)

### `set`
`[native code]` | Self: 0.2% (3.2ms) | Total: 0.2% (3.2ms) | Samples: 2

**Called by:**
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2734` | Self: 0.2% (3.1ms) | Total: 0.2% (3.1ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1256` | Self: 0.2% (3.1ms) | Total: 0.2% (3.1ms) | Samples: 2

**Called by:**
- `_computeIsStrict` (1)
- `_buildReference` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` | Self: 0.1% (3.0ms) | Total: 1.5% (23.0ms) | Samples: 2

**Called by:**
- `getDeclaredVariables` (15)

**Calls:**
- `Set` (13)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4035` | Self: 0.1% (3.0ms) | Total: 0.1% (3.0ms) | Samples: 2

**Called by:**
- `get parent` (1)
- `_computeVarDefs` (1)

### `readdirSync`
`[native code]` | Self: 0.1% (2.9ms) | Total: 0.3% (5.9ms) | Samples: 2

**Called by:**
- `readdirSync` (2)
- `loadCoreRules` (2)

**Calls:**
- `readdirSync` (2)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:879` | Self: 0.1% (2.9ms) | Total: 2.0% (32.1ms) | Samples: 2

**Called by:**
- `get body` (21)

**Calls:**
- `_nodeViewRaw` (6)
- `_nodeViewRaw` (5)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `nodeView` (1)

### `exec`
`[native code]` | Self: 0.1% (2.9ms) | Total: 0.3% (4.7ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (3)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (2.9ms) | Total: 0.1% (2.9ms) | Samples: 2

**Called by:**
- `get references` (2)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2900` | Self: 0.1% (2.9ms) | Total: 0.8% (13.0ms) | Samples: 2

**Called by:**
- `get references` (9)

**Calls:**
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` | Self: 0.1% (2.9ms) | Total: 0.1% (2.9ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (2)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1220` | Self: 0.1% (2.9ms) | Total: 0.1% (2.9ms) | Samples: 2

**Called by:**
- `_computeIsStrict` (1)
- `_findDefNode` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4040` | Self: 0.1% (2.9ms) | Total: 0.1% (2.9ms) | Samples: 2

**Called by:**
- `_buildReference` (1)
- `_nodesFromRange` (1)

### `scope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:745` | Self: 0.1% (2.9ms) | Total: 0.6% (10.4ms) | Samples: 2

**Called by:**
- `_computeVariableSynthRefs` (6)

**Calls:**
- `_computeVarScope` (3)
- `_computeVarScope` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2018` | Self: 0.1% (2.9ms) | Total: 0.1% (2.9ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2052` | Self: 0.1% (2.8ms) | Total: 0.1% (2.8ms) | Samples: 2

**Called by:**
- `_buildScope` (2)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:876` | Self: 0.1% (2.8ms) | Total: 0.1% (2.8ms) | Samples: 2

**Called by:**
- `get body` (2)

### `has`
`[native code]` | Self: 0.1% (2.7ms) | Total: 0.1% (2.7ms) | Samples: 2

**Called by:**
- `_ensureDeclSymIndex` (2)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` | Self: 0.1% (2.7ms) | Total: 2.0% (31.4ms) | Samples: 2

**Called by:**
- `_computeVarDefs` (22)

**Calls:**
- `get parent` (13)
- `get parent` (2)
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4031` | Self: 0.1% (2.7ms) | Total: 5.4% (83.3ms) | Samples: 2

**Called by:**
- `_buildReference` (24)
- `get body` (11)
- `get parent` (10)
- `_nodesFromRange` (5)
- `_computeVarDefs` (4)
- `get body` (1)
- `_computeVariableSynthRefs` (1)

**Calls:**
- `setPrototypeDirect` (54)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` | Self: 0.1% (2.7ms) | Total: 0.2% (4.4ms) | Samples: 2

**Called by:**
- `some` (3)

**Calls:**
- `isReadRef` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2698` | Self: 0.1% (2.7ms) | Total: 0.1% (2.7ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` | Self: 0.1% (2.6ms) | Total: 0.1% (2.6ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` | Self: 0.1% (2.6ms) | Total: 0.3% (5.3ms) | Samples: 2

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `get parent` (1)
- `get parent` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2593` | Self: 0.1% (2.5ms) | Total: 0.1% (2.5ms) | Samples: 2

**Called by:**
- `_ensureChildren` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4053` | Self: 0.1% (1.8ms) | Total: 0.1% (1.8ms) | Samples: 1

**Called by:**
- `_nodesFromRange` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (1.8ms) | Total: 0.1% (1.8ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `push`
`[native code]` | Self: 0.1% (1.8ms) | Total: 0.1% (1.8ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2833` | Self: 0.1% (1.7ms) | Total: 8.7% (134.0ms) | Samples: 1

**Called by:**
- `get references` (85)
- `_ensureVarsSet` (1)

**Calls:**
- `_nodeViewRaw` (24)
- `_nodeViewRaw` (24)
- `_nodeViewRaw` (17)
- `_nodeViewRaw` (10)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `get body` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1367` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2946` | Self: 0.1% (1.7ms) | Total: 0.7% (11.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (7)

**Calls:**
- `nodeViewChain` (2)
- `_nodeViewRaw` (1)
- `nodeViewChain` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3185` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `map` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2677` | Self: 0.1% (1.7ms) | Total: 0.3% (4.6ms) | Samples: 1

**Called by:**
- `getScope` (3)

**Calls:**
- `test` (2)

### `getUpperFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:134` | Self: 0.1% (1.7ms) | Total: 0.2% (3.1ms) | Samples: 1

**Called by:**
- `isInsideOfStorableFunction` (2)

**Calls:**
- `/^(?:Function(?:Declaration\|Expression)\|ArrowFunctionExpression)$/u` (1)

### `get init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2946` | Self: 0.1% (1.7ms) | Total: 0.2% (3.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `nodeViewChain` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3653` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `get value` (1)

### `isReadRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:431` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `DataView`
`[native code]` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:591` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `some`
`[native code]` | Self: 0.1% (1.7ms) | Total: 10.9% (168.3ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (45)
- `isUsedVariable` (34)
- `collectUnusedVariables` (15)
- `collectUnusedVariables` (13)

**Calls:**
- `(anonymous)` (44)
- `(anonymous)` (22)
- `(anonymous)` (14)
- `(anonymous)` (13)
- `(anonymous)` (9)
- `(anonymous)` (3)
- `(anonymous)` (1)

### `_isStatementTag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:76` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `get loc` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3170` | Self: 0.1% (1.7ms) | Total: 0.5% (8.3ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (4)

**Calls:**
- `get references` (2)
- `get references` (1)

### `async _loadFlatConfig`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:37` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `async _resolveConfigImpl` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7188` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `_computeVarDefs` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2020` | Self: 0.1% (1.6ms) | Total: 0.2% (4.4ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (3)

**Calls:**
- `has` (2)

### `isSelfReference`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get left`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `getRhsNode` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1257` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `_computeVarScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2815` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `scope` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` | Self: 0.1% (1.6ms) | Total: 11.0% (170.0ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (108)

**Calls:**
- `isAfterLastUsedArg` (60)
- `isAfterLastUsedArg` (45)
- `isAfterLastUsedArg` (1)
- `isAfterLastUsedArg` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3086` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2321` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `extraFnData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:676` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `get body` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6474` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1039` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `reset` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` | Self: 0.1% (1.5ms) | Total: 4.6% (71.4ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (46)

**Calls:**
- `some` (34)
- `get references` (10)
- `get references` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `readFileSync`
`[native code]` | Self: 0.1% (1.5ms) | Total: 0.2% (3.1ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)
- `readFileSync` (1)

**Calls:**
- `readFileSync` (1)

### `get directive`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3370` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:587` | Self: 0.1% (1.5ms) | Total: 0.5% (8.5ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (6)

**Calls:**
- `_findLineIdx` (3)
- `_findLineIdx` (2)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `RegExp`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `wordsRegexp` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2032` | Self: 0.0% (1.4ms) | Total: 0.2% (3.1ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (2)

**Calls:**
- `set` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` | Self: 0.0% (1.4ms) | Total: 0.1% (2.7ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (2)

**Calls:**
- `getUint32` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2015` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4107` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get init` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2230` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2436` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4041` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get parent` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_nodesFromRange` (1)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:819` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_symName` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2113` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `dlopen`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3146` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildPlan` (1)

### `fetch`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `requestFetch` (1)

### `encodeInto`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_encodeSource` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:654` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:892` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `/^(?:Function(?:Declaration\|Expression)\|ArrowFunctionExpression)$/u`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getUpperFunction` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1744` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4076` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `get parent` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `assign`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2066` | Self: 0.0% (1.3ms) | Total: 6.5% (100.1ms) | Samples: 1

**Called by:**
- `_buildReference` (45)
- `_buildScope` (23)

**Calls:**
- `_buildScope` (34)
- `_buildScope` (23)
- `_buildScope` (3)
- `_buildScope` (2)
- `_buildScope` (2)
- `_buildScope` (2)
- `_buildScope` (1)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getRhsNode` (1)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `isUsedVariable` (1)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:813` | Self: 0.0% (1.3ms) | Total: 0.6% (10.6ms) | Samples: 1

**Called by:**
- `_ensureDeclSymIndex` (6)
- `_buildVariable` (1)

**Calls:**
- `_buildSymNameCache` (5)
- `_buildSymNameCache` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3099` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `getUint32`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `get body` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:887` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` | Self: 0.0% (1.2ms) | Total: 4.4% (69.0ms) | Samples: 1

**Called by:**
- `some` (44)

**Calls:**
- `get references` (35)
- `get references` (8)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1508` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `get parent` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3102` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:588` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3159` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `init` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` | Self: 0.0% (1.2ms) | Total: 0.8% (12.9ms) | Samples: 1

**Called by:**
- `some` (9)

**Calls:**
- `isReadForItself` (4)
- `isReadForItself` (2)
- `isReadForItself` (1)
- `isReadForItself` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` | Self: 0.0% (1.2ms) | Total: 7.2% (112.0ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (62)
- `Program:exit` (10)

**Calls:**
- `isUsedVariable` (46)
- `some` (15)
- `isUsedVariable` (10)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1522` | Self: 0.0% (1.1ms) | Total: 0.0% (1.1ms) | Samples: 1

**Called by:**
- `get parent` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:304` | Self: 0.0% (0us) | Total: 72.4% (1.11s) | Samples: 0

**Calls:**
- `runPlugins` (721)
- `runPlugins` (5)
- `runPlugins` (1)
- `runPlugins` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:558` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get left` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:972` | Self: 0.0% (0us) | Total: 0.5% (8.8ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (6)

**Calls:**
- `_ensureVarsSet` (6)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4003` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `reset` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:484` | Self: 0.0% (0us) | Total: 0.1% (3.0ms) | Samples: 0

**Called by:**
- `_computeVarDefs` (2)

**Calls:**
- `get parent` (2)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:47` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (2)

**Calls:**
- `readdirSync` (2)

### `requestFetch`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `fetch` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:662` | Self: 0.0% (0us) | Total: 0.2% (3.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `isInsideOfStorableFunction` (2)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2168` | Self: 0.0% (0us) | Total: 0.2% (3.1ms) | Samples: 0

**Called by:**
- `_buildScope` (2)

**Calls:**
- `get parent` (1)
- `get parent` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6646` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_getOrBuildPlan` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:195` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `assign` (1)

### `map`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `isAfterLastUsedArg` (1)

**Calls:**
- `(anonymous)` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2837` | Self: 0.0% (0us) | Total: 9.0% (138.3ms) | Samples: 0

**Called by:**
- `get references` (89)

**Calls:**
- `get parent` (84)
- `get parent` (3)
- `get parent` (1)
- `get parent` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `some` (1)

**Calls:**
- `isSelfReference` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

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

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:144` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Calls:**
- `loadCoreRules` (2)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:300` | Self: 0.0% (0us) | Total: 25.7% (395.6ms) | Samples: 0

**Calls:**
- `parseSource` (254)
- `parseSource` (2)
- `parseSource` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:880` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `_buildReference` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:881` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `get name` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5889` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_getOrBuildPlan` (1)

**Calls:**
- `_extractFileLevelRules` (1)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` | Self: 0.0% (0us) | Total: 0.9% (14.6ms) | Samples: 0

**Called by:**
- `isUsedVariable` (9)

**Calls:**
- `forEach` (9)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1730` | Self: 0.0% (0us) | Total: 1.3% (21.4ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (15)

**Calls:**
- `_nodeViewRaw` (11)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (1)

### `describeRule`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (1)

**Calls:**
- `_getPlugin` (1)

### `async lintSource`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:462` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `async lintSource` (1)

**Calls:**
- `async _resolveConfig` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7016` | Self: 0.0% (0us) | Total: 0.3% (5.9ms) | Samples: 0

**Called by:**
- `runPlugins` (4)

**Calls:**
- `getDFSEvents` (3)
- `getDFSEvents` (1)

### `async _resolveConfig`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:71` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `async _resolveConfig` (1)

**Calls:**
- `async _resolveConfigImpl` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` | Self: 0.0% (0us) | Total: 13.4% (206.6ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (72)
- `Program:exit` (65)

**Calls:**
- `get` (118)
- `get` (13)
- `get` (6)

### `wordsRegexp`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:285` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `buildUnicodeData` (1)

**Calls:**
- `RegExp` (1)

### `identifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:756` | Self: 0.0% (0us) | Total: 0.1% (2.4ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (2)

**Calls:**
- `defs` (2)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:77` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Calls:**
- `async lintSource` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2225` | Self: 0.0% (0us) | Total: 0.2% (4.2ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (3)

**Calls:**
- `identifiers` (2)
- `push` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:22` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:967` | Self: 0.0% (0us) | Total: 0.5% (8.8ms) | Samples: 0

**Called by:**
- `get` (6)

**Calls:**
- `_ensureVarsSet` (1)
- `_ensureVarsSet` (1)
- `_ensureVarsSet` (1)
- `_ensureVarsSet` (1)
- `_ensureVarsSet` (1)
- `_ensureVarsSet` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:840` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `get body` (1)

### `async lintSource`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:461` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `async lintSource` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:586` | Self: 0.0% (0us) | Total: 0.4% (6.9ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (5)

**Calls:**
- `_findLineIdx` (4)
- `_findLineIdx` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7540` | Self: 0.0% (0us) | Total: 71.8% (1.10s) | Samples: 0

**Called by:**
- `_lintSourceOne` (721)

**Calls:**
- `walkNodes` (661)
- `walkNodes` (38)
- `walkNodes` (14)
- `walkNodes` (4)
- `walkNodes` (2)
- `walkNodes` (1)
- `walkNodes` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:557` | Self: 0.0% (0us) | Total: 0.2% (3.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `isUnusedExpression` (2)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` | Self: 0.0% (0us) | Total: 0.4% (7.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `bound require` (5)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` | Self: 0.0% (0us) | Total: 1.7% (27.5ms) | Samples: 0

**Called by:**
- `_invokeFused` (19)

**Calls:**
- `getScope` (19)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2227` | Self: 0.0% (0us) | Total: 0.3% (5.1ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (3)

**Calls:**
- `get references` (2)
- `get references` (1)

### `async _resolveConfig`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:68` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `async lintSource` (1)

**Calls:**
- `async _resolveConfig` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:519` | Self: 0.0% (0us) | Total: 0.1% (2.6ms) | Samples: 0

**Called by:**
- `_computeVarDefs` (2)

**Calls:**
- `get parent` (1)
- `get parent` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1247` | Self: 0.0% (0us) | Total: 0.1% (2.4ms) | Samples: 0

**Called by:**
- `_findDefNode` (2)

**Calls:**
- `get value` (1)
- `get value` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7256` | Self: 0.0% (0us) | Total: 65.8% (1.01s) | Samples: 0

**Called by:**
- `runPlugins` (661)

**Calls:**
- `_invokeFused` (661)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:35` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `readFileSync` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:85` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (1)

**Calls:**
- `async _loadFlatConfig` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` | Self: 0.0% (0us) | Total: 26.0% (399.5ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (260)

**Calls:**
- `get references` (236)
- `some` (13)
- `get references` (11)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4672` | Self: 0.0% (0us) | Total: 65.8% (1.01s) | Samples: 0

**Called by:**
- `walkNodes` (661)

**Calls:**
- `Program:exit` (642)
- `Program:exit` (19)

### `_loadFromDisk`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:69` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_getPlugin` (1)

**Calls:**
- `tryParse` (1)

### `forEach`
`[native code]` | Self: 0.0% (0us) | Total: 0.9% (14.6ms) | Samples: 0

**Called by:**
- `getFunctionDefinitions` (9)

**Calls:**
- `(anonymous)` (8)
- `(anonymous)` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:452` | Self: 0.0% (0us) | Total: 0.2% (4.3ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `CfgGraph` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7535` | Self: 0.0% (0us) | Total: 0.0% (1.1ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `get source` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3643` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `get value` (1)

**Calls:**
- `_isStatementTag` (1)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 3.3% (50.8ms) | Samples: 0

**Called by:**
- `bound require` (33)

**Calls:**
- `anonymous` (33)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2701` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `_symName` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:752` | Self: 0.0% (0us) | Total: 4.6% (70.7ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (45)

**Calls:**
- `some` (45)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 1.4% (22.8ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)
- `requestInstantiate` (1)

**Calls:**
- `parseModule` (13)
- `async (anonymous)` (1)
- `requestFetch` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2673` | Self: 0.0% (0us) | Total: 1.4% (22.8ms) | Samples: 0

**Called by:**
- `getScope` (16)

**Calls:**
- `commentsInRange` (6)
- `commentsInRange` (5)
- `commentsInRange` (3)
- `commentsInRange` (1)
- `commentsInRange` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` | Self: 0.0% (0us) | Total: 64.0% (984.9ms) | Samples: 0

**Called by:**
- `_invokeFused` (642)

**Calls:**
- `collectUnusedVariables` (567)
- `collectUnusedVariables` (65)
- `collectUnusedVariables` (10)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` | Self: 0.0% (0us) | Total: 2.2% (34.4ms) | Samples: 0

**Called by:**
- `some` (22)

**Calls:**
- `getRhsNode` (12)
- `getRhsNode` (6)
- `getRhsNode` (2)
- `getRhsNode` (1)
- `getRhsNode` (1)

### `loadBinding`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `getTagNames` (1)

**Calls:**
- `bound require` (1)

### `isInsideOfStorableFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:630` | Self: 0.0% (0us) | Total: 0.2% (3.1ms) | Samples: 0

**Called by:**
- `isReadForItself` (2)

**Calls:**
- `getUpperFunction` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:458` | Self: 0.0% (0us) | Total: 0.4% (7.3ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `patchAstUtils` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` | Self: 0.0% (0us) | Total: 0.1% (2.8ms) | Samples: 0

**Called by:**
- `parseModule` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` | Self: 0.0% (0us) | Total: 0.2% (3.6ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` | Self: 0.0% (0us) | Total: 1.0% (15.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (10)

**Calls:**
- `async (anonymous)` (10)

### `_getOrBuildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5571` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_buildPlan` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1733` | Self: 0.0% (0us) | Total: 0.1% (2.7ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (2)

**Calls:**
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4104` | Self: 0.0% (0us) | Total: 0.2% (3.2ms) | Samples: 0

**Called by:**
- `init` (2)

**Calls:**
- `_isChainNode` (2)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:92` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `encodeInto` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:215` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `_encodeSource` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` | Self: 0.0% (0us) | Total: 100.0% (3.32s) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1588)
- `Program:exit` (567)

**Calls:**
- `collectUnusedVariables` (1588)
- `collectUnusedVariables` (260)
- `collectUnusedVariables` (108)
- `collectUnusedVariables` (72)
- `collectUnusedVariables` (62)
- `collectUnusedVariables` (58)
- `collectUnusedVariables` (2)
- `collectUnusedVariables` (2)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:522` | Self: 0.0% (0us) | Total: 0.4% (6.9ms) | Samples: 0

**Called by:**
- `runPlugins` (4)
- `runPlugins` (1)

**Calls:**
- `decode` (5)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:747` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `defs` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1710` | Self: 0.0% (0us) | Total: 2.3% (36.7ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (23)
- `isForInOfRef` (1)

**Calls:**
- `_nodesFromRange` (21)
- `_nodesFromRange` (2)
- `_nodesFromRange` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:72` | Self: 0.0% (0us) | Total: 1.0% (15.7ms) | Samples: 0

**Called by:**
- `async (anonymous)` (10)

**Calls:**
- `bound require` (10)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.1% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` | Self: 0.0% (0us) | Total: 1.0% (15.9ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (10)

**Calls:**
- `getFunctionDefinitions` (9)
- `getFunctionDefinitions` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7539` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `buildVisitorMap` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3113` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (1)

**Calls:**
- `get` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `get parent` (1)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1898` | Self: 0.0% (0us) | Total: 1.7% (27.5ms) | Samples: 0

**Called by:**
- `Program:exit` (19)

**Calls:**
- `_precomputeScopes` (16)
- `_precomputeScopes` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `forEach` (1)

**Calls:**
- `get init` (1)

### `_ensureChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:924` | Self: 0.0% (0us) | Total: 1.2% (19.6ms) | Samples: 0

**Called by:**
- `get` (13)

**Calls:**
- `_buildScopeChildren` (9)
- `_buildScopeChildren` (2)
- `_buildScopeChildren` (2)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 3.5% (55.0ms) | Samples: 0

**Called by:**
- `async (anonymous)` (10)
- `(anonymous)` (8)
- `patchAstUtils` (5)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `loadBinding` (1)
- `(anonymous)` (1)

**Calls:**
- `require` (33)
- `anonymous` (2)
- `(anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` | Self: 0.0% (0us) | Total: 25.2% (388.1ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (254)

**Calls:**
- `parse` (254)

### `requestInstantiate`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `requestSatisfyUtil` (1)

**Calls:**
- `async (anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` | Self: 0.0% (0us) | Total: 0.7% (12.0ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2869` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `get references` (1)

**Calls:**
- `get parent` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2081` | Self: 0.0% (0us) | Total: 0.2% (3.4ms) | Samples: 0

**Called by:**
- `_buildScope` (2)

**Calls:**
- `get value` (2)

### `tryParse`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:126` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_loadFromDisk` (1)

**Calls:**
- `parse` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:279` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `DataView` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.3% (4.7ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3101` | Self: 0.0% (0us) | Total: 5.6% (87.4ms) | Samples: 0

**Called by:**
- `isAfterLastUsedArg` (56)

**Calls:**
- `_computeDeclaredVariables` (15)
- `_computeDeclaredVariables` (12)
- `_computeDeclaredVariables` (9)
- `_computeDeclaredVariables` (8)
- `_computeDeclaredVariables` (4)
- `_computeDeclaredVariables` (3)
- `_computeDeclaredVariables` (1)
- `_computeDeclaredVariables` (1)
- `_computeDeclaredVariables` (1)
- `_computeDeclaredVariables` (1)
- `_computeDeclaredVariables` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` | Self: 0.0% (0us) | Total: 5.5% (85.7ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (58)

**Calls:**
- `defs` (58)

### `get identifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:756` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `_computeDeclaredVariables` (1)

**Calls:**
- `defs` (1)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:855` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `defs` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4332` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `describeRule` (1)

### `getTagNames`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:186` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `loadBinding` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2895` | Self: 0.0% (0us) | Total: 0.6% (10.4ms) | Samples: 0

**Called by:**
- `get references` (6)

**Calls:**
- `scope` (6)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:957` | Self: 0.0% (0us) | Total: 1.2% (19.6ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (13)

**Calls:**
- `_ensureChildren` (13)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` | Self: 0.0% (0us) | Total: 6.0% (93.4ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (60)

**Calls:**
- `getDeclaredVariables` (56)
- `getDeclaredVariables` (1)
- `getDeclaredVariables` (1)
- `getDeclaredVariables` (1)
- `map` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2782` | Self: 0.0% (0us) | Total: 2.5% (38.8ms) | Samples: 0

**Called by:**
- `defs` (27)

**Calls:**
- `_findDefNode` (22)
- `_findDefNode` (2)
- `_findDefNode` (2)
- `_findDefNode` (1)

### `(anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (2.8ms) | Samples: 0

**Called by:**
- `bound require` (1)

**Calls:**
- `requestSatisfyUtil` (1)
- `dlopen` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3168` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (1)

**Calls:**
- `get identifiers` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2031` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `get` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:845` | Self: 0.0% (0us) | Total: 11.7% (179.9ms) | Samples: 0

**Called by:**
- `get` (118)
- `_ensureVarsSet` (1)

**Calls:**
- `_buildScopeVarsAndSet` (49)
- `_buildScopeVarsAndSet` (13)
- `_buildScopeVarsAndSet` (12)
- `_buildScopeVarsAndSet` (8)
- `_buildScopeVarsAndSet` (8)
- `_buildScopeVarsAndSet` (7)
- `_buildScopeVarsAndSet` (5)
- `_buildScopeVarsAndSet` (4)
- `_buildScopeVarsAndSet` (3)
- `_buildScopeVarsAndSet` (3)
- `_buildScopeVarsAndSet` (3)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)

### `parseModule`
`[native code]` | Self: 0.0% (0us) | Total: 1.3% (20.0ms) | Samples: 0

**Called by:**
- `async (anonymous)` (13)

**Calls:**
- `(anonymous)` (10)
- `(anonymous)` (2)
- `(anonymous)` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2589` | Self: 0.0% (0us) | Total: 0.8% (13.6ms) | Samples: 0

**Called by:**
- `_ensureChildren` (9)

**Calls:**
- `_buildScope` (8)
- `_buildScope` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:76` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `async _resolveConfig` (1)

**Calls:**
- `async _resolveConfigImpl` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2322` | Self: 0.0% (0us) | Total: 0.2% (4.0ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (3)

**Calls:**
- `test` (3)

### `requestSatisfyUtil`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `requestInstantiate` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2190` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `_buildScope` (1)

**Calls:**
- `get directive` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2167` | Self: 0.0% (0us) | Total: 1.1% (17.1ms) | Samples: 0

**Called by:**
- `_buildScope` (11)

**Calls:**
- `get parent` (7)
- `get parent` (3)
- `get parent` (1)

### `_getPlugin`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:60` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `describeRule` (1)

**Calls:**
- `_loadFromDisk` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2016` | Self: 0.0% (0us) | Total: 0.2% (3.1ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (2)

**Calls:**
- `get` (2)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:689` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get body` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2186` | Self: 0.0% (0us) | Total: 4.1% (63.7ms) | Samples: 0

**Called by:**
- `_buildScope` (43)

**Calls:**
- `get body` (23)
- `get body` (15)
- `get body` (2)
- `get body` (2)
- `get body` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:3999` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `buildUnicodeData` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:953` | Self: 0.0% (0us) | Total: 11.5% (178.1ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (118)

**Calls:**
- `_ensureVarsSet` (118)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1513` | Self: 0.0% (0us) | Total: 0.2% (3.4ms) | Samples: 0

**Called by:**
- `_buildScope` (2)

**Calls:**
- `get loc` (1)
- `get loc` (1)

### `isUnusedExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:506` | Self: 0.0% (0us) | Total: 0.2% (3.1ms) | Samples: 0

**Called by:**
- `getRhsNode` (2)

**Calls:**
- `get parent` (2)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` | Self: 0.0% (0us) | Total: 1.1% (18.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (12)

**Calls:**
- `isInLoop` (11)
- `isInLoop` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` | Self: 0.0% (0us) | Total: 1.0% (15.7ms) | Samples: 0

**Called by:**
- `parseModule` (10)

**Calls:**
- `async (anonymous)` (10)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:288` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Calls:**
- `getTagNames` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` | Self: 0.0% (0us) | Total: 0.8% (12.8ms) | Samples: 0

**Called by:**
- `forEach` (8)

**Calls:**
- `init` (7)
- `get init` (1)

### `buildUnicodeData`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:3986` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `wordsRegexp` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:561` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7532` | Self: 0.0% (0us) | Total: 0.4% (7.4ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (5)

**Calls:**
- `get source` (4)
- `reset` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1729` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `extraFnData` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2029` | Self: 0.0% (0us) | Total: 0.6% (9.3ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (6)

**Calls:**
- `_symName` (6)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` | Self: 0.0% (0us) | Total: 0.3% (6.1ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (2)

**Calls:**
- `AstView` (1)
- `AstView` (1)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 36.7% | 564.7ms | `[native code]` |
| 29.2% | 450.1ms | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 29.1% | 448.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 4.5% | 69.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.1% | 1.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js` |
| 0.1% | 1.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/api.js` |
