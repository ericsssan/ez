# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 1.46s | 951 | 1.0ms | 310 |

**Top 10:** `parse` 26.5%, `walkNodes` 3.7%, `setPrototypeDirect` 3.7%, `_computeNodeType` 3.3%, `_ensureDeclSymIndex` 2.4%, `_computeNodeType` 1.9%, `_nodeViewRaw` 1.8%, `_computeNodeType` 1.7%, `get parent` 1.7%, `get parent` 1.7%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 26.5% | 388.0ms | 26.5% | 388.0ms | `parse` | `[native code]` |
| 3.7% | 55.0ms | 3.7% | 55.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7017` |
| 3.7% | 54.8ms | 3.7% | 54.8ms | `setPrototypeDirect` | `[native code]` |
| 3.3% | 48.9ms | 3.3% | 48.9ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1020` |
| 2.4% | 35.3ms | 2.5% | 36.8ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2017` |
| 1.9% | 28.1ms | 1.9% | 28.1ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 1.8% | 27.3ms | 8.6% | 126.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4061` |
| 1.7% | 25.8ms | 1.7% | 25.8ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1018` |
| 1.7% | 25.5ms | 9.3% | 136.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1208` |
| 1.7% | 24.8ms | 1.7% | 24.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1188` |
| 1.5% | 22.7ms | 1.5% | 22.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4051` |
| 1.3% | 20.1ms | 1.3% | 20.1ms | `Set` | `[native code]` |
| 1.3% | 19.9ms | 3.5% | 52.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4069` |
| 1.3% | 19.9ms | 1.4% | 21.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2223` |
| 1.2% | 18.3ms | 1.3% | 19.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2229` |
| 1.2% | 18.3ms | 1.2% | 18.3ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4024` |
| 1.2% | 18.1ms | 4.1% | 60.4ms | `anonymous` | `[native code]` |
| 1.1% | 16.2ms | 1.1% | 16.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6743` |
| 1.0% | 15.4ms | 1.0% | 15.4ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` |
| 0.9% | 14.0ms | 0.9% | 14.0ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3166` |
| 0.8% | 12.8ms | 0.8% | 12.8ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.8% | 12.3ms | 0.8% | 12.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4046` |
| 0.8% | 11.7ms | 1.2% | 18.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 0.7% | 10.6ms | 4.9% | 72.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2087` |
| 0.7% | 10.2ms | 25.9% | 378.4ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 0.6% | 9.2ms | 0.6% | 9.2ms | `get` | `[native code]` |
| 0.6% | 9.0ms | 0.6% | 9.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1241` |
| 0.5% | 8.1ms | 1.1% | 16.2ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` |
| 0.5% | 7.3ms | 4.2% | 62.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4063` |
| 0.5% | 7.3ms | 0.5% | 7.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` |
| 0.4% | 7.2ms | 0.4% | 7.2ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:539` |
| 0.4% | 7.0ms | 0.4% | 7.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.4% | 6.7ms | 1.7% | 25.0ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` |
| 0.4% | 6.7ms | 0.4% | 6.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2428` |
| 0.4% | 6.6ms | 0.4% | 6.6ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1016` |
| 0.4% | 6.4ms | 0.4% | 6.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2117` |
| 0.4% | 6.4ms | 0.6% | 9.7ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2840` |
| 0.4% | 6.3ms | 0.5% | 7.9ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` |
| 0.4% | 6.3ms | 0.4% | 6.3ms | `decode` | `[native code]` |
| 0.4% | 6.2ms | 0.4% | 6.2ms | `set` | `[native code]` |
| 0.4% | 6.2ms | 0.4% | 6.2ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2846` |
| 0.4% | 6.1ms | 0.4% | 6.1ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.4% | 6.1ms | 0.4% | 6.1ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2745` |
| 0.4% | 6.1ms | 0.4% | 6.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2130` |
| 0.4% | 6.1ms | 2.2% | 32.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2222` |
| 0.4% | 6.1ms | 0.4% | 6.1ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2215` |
| 0.4% | 6.1ms | 0.6% | 9.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3172` |
| 0.4% | 6.1ms | 3.9% | 57.6ms | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 0.4% | 6.0ms | 0.4% | 6.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4085` |
| 0.4% | 6.0ms | 0.4% | 6.0ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2698` |
| 0.4% | 5.9ms | 11.9% | 174.2ms | `some` | `[native code]` |
| 0.4% | 5.8ms | 0.4% | 5.8ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 0.3% | 5.7ms | 0.7% | 11.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2868` |
| 0.3% | 5.7ms | 0.3% | 5.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4068` |
| 0.3% | 5.5ms | 0.4% | 7.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2071` |
| 0.3% | 5.2ms | 0.5% | 8.5ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` |
| 0.3% | 5.1ms | 1.4% | 21.3ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` |
| 0.3% | 5.1ms | 0.3% | 5.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1256` |
| 0.3% | 5.0ms | 0.3% | 5.0ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2808` |
| 0.3% | 4.9ms | 0.3% | 4.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2107` |
| 0.3% | 4.8ms | 0.3% | 4.8ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2032` |
| 0.3% | 4.8ms | 0.8% | 12.0ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:813` |
| 0.3% | 4.7ms | 0.3% | 4.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2697` |
| 0.3% | 4.7ms | 0.3% | 4.7ms | `getUint32` | `[native code]` |
| 0.3% | 4.7ms | 3.3% | 49.4ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2186` |
| 0.3% | 4.6ms | 0.3% | 4.6ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2734` |
| 0.3% | 4.6ms | 0.4% | 7.2ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:829` |
| 0.3% | 4.5ms | 0.5% | 7.7ms | `exec` | `[native code]` |
| 0.3% | 4.5ms | 24.2% | 354.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 0.3% | 4.4ms | 0.3% | 4.4ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6474` |
| 0.3% | 4.4ms | 0.3% | 4.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4065` |
| 0.3% | 4.3ms | 0.3% | 4.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2018` |
| 0.2% | 4.3ms | 8.5% | 125.0ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2837` |
| 0.2% | 4.2ms | 0.6% | 10.2ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2792` |
| 0.2% | 4.1ms | 6.6% | 97.4ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2844` |
| 0.2% | 3.5ms | 0.2% | 3.5ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 3.3ms | 0.2% | 3.3ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2787` |
| 0.2% | 3.3ms | 0.2% | 3.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2738` |
| 0.2% | 3.2ms | 4.9% | 72.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2213` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `encodeInto` | `[native code]` |
| 0.2% | 3.1ms | 0.2% | 3.1ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2015` |
| 0.2% | 3.1ms | 0.2% | 3.1ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:591` |
| 0.2% | 3.1ms | 0.2% | 3.1ms | `range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3627` |
| 0.2% | 3.1ms | 0.2% | 3.1ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4319` |
| 0.2% | 3.1ms | 0.2% | 3.1ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:846` |
| 0.2% | 3.1ms | 0.2% | 3.1ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3099` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:589` |
| 0.2% | 3.0ms | 0.6% | 9.2ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3627` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` |
| 0.2% | 3.0ms | 0.5% | 8.5ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.2% | 3.0ms | 2.4% | 35.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 0.2% | 3.0ms | 0.4% | 6.2ms | `scope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:745` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 2.9ms | 0.2% | 2.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2113` |
| 0.2% | 2.9ms | 0.2% | 2.9ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:630` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6744` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2727` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3165` |
| 0.1% | 2.7ms | 0.2% | 4.2ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3170` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` |
| 0.1% | 2.6ms | 0.1% | 2.6ms | `test` | `[native code]` |
| 0.1% | 2.6ms | 0.1% | 2.6ms | `slice` | `[native code]` |
| 0.1% | 2.4ms | 0.1% | 2.4ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1059` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.8ms | 1.3% | 19.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2320` |
| 0.1% | 1.7ms | 0.6% | 9.9ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2900` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2586` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `/^(?:Function(?:Declaration\|Expression)\|ArrowFunctionExpression)$/u` | `[native code]` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `fill` | `[native code]` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1690` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `get operator` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1326` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_isOptionalTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3881` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2190` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7019` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2102` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1703` |
| 0.1% | 1.6ms | 0.2% | 2.9ms | `map` | `[native code]` |
| 0.1% | 1.6ms | 0.2% | 3.4ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2677` |
| 0.1% | 1.6ms | 1.2% | 18.2ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2589` |
| 0.1% | 1.6ms | 0.2% | 4.0ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2322` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:637` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `isRead` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:220` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:588` |
| 0.1% | 1.6ms | 0.4% | 6.4ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:494` |
| 0.1% | 1.6ms | 0.5% | 8.2ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2167` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6745` |
| 0.1% | 1.6ms | 100.0% | 3.05s | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 0.1% | 1.5ms | 15.2% | 222.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2674` |
| 0.1% | 1.5ms | 0.2% | 2.9ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6476` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `/^\s*globals?\b/` | `[native code]` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:593` |
| 0.1% | 1.5ms | 0.5% | 7.9ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:586` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `extraClassData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2822` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2747` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2676` |
| 0.1% | 1.4ms | 1.3% | 19.5ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2763` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `fetch` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 4.8% | 71.1ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3101` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:654` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3102` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7192` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.3% | 5.8ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:587` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2212` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:808` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1219` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1026` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2699` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3148` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `filter` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1189` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7188` |
| 0.0% | 1.3ms | 1.4% | 21.4ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` |
| 0.0% | 1.3ms | 0.1% | 2.6ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2168` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2226` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2137` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3655` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:881` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:879` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2011` |
| 0.0% | 1.2ms | 0.2% | 2.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1220` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:876` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2031` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_fromRunnerReport` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:225` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2078` |
| 0.0% | 1.2ms | 13.1% | 191.7ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:845` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2028` |
| 0.0% | 1.1ms | 0.0% | 1.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6747` |
| 0.0% | 956us | 0.0% | 956us | `DataView` | `[native code]` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 100.0% | 3.05s | 0.1% | 1.6ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 71.1% | 1.03s | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:304` |
| 70.5% | 1.03s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7540` |
| 64.2% | 938.3ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7256` |
| 64.2% | 938.3ms | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4672` |
| 62.1% | 907.0ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` |
| 27.2% | 398.4ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:300` |
| 26.5% | 388.0ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` |
| 26.5% | 388.0ms | 26.5% | 388.0ms | `parse` | `[native code]` |
| 25.9% | 378.4ms | 0.7% | 10.2ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 24.2% | 354.7ms | 0.3% | 4.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 15.2% | 222.0ms | 0.1% | 1.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 13.3% | 194.8ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:953` |
| 13.1% | 191.7ms | 0.0% | 1.2ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:845` |
| 11.9% | 174.2ms | 0.4% | 5.9ms | `some` | `[native code]` |
| 9.7% | 142.7ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` |
| 9.3% | 136.8ms | 1.7% | 25.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1208` |
| 8.6% | 126.4ms | 1.8% | 27.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4061` |
| 8.6% | 125.8ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 8.5% | 125.0ms | 0.2% | 4.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2837` |
| 7.9% | 116.8ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2833` |
| 6.6% | 97.4ms | 0.2% | 4.1ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2844` |
| 5.1% | 75.6ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` |
| 5.1% | 75.2ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2066` |
| 4.9% | 72.6ms | 0.7% | 10.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2087` |
| 4.9% | 72.6ms | 0.2% | 3.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2213` |
| 4.8% | 71.1ms | 0.0% | 1.4ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3101` |
| 4.2% | 62.2ms | 0.5% | 7.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4063` |
| 4.1% | 60.4ms | 1.2% | 18.1ms | `anonymous` | `[native code]` |
| 4.0% | 58.4ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:752` |
| 3.9% | 57.6ms | 0.4% | 6.1ms | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 3.9% | 56.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` |
| 3.7% | 55.0ms | 3.7% | 55.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7017` |
| 3.7% | 54.8ms | 3.7% | 54.8ms | `setPrototypeDirect` | `[native code]` |
| 3.6% | 53.9ms | 0.0% | 0us | `bound require` | `[native code]` |
| 3.5% | 52.0ms | 1.3% | 19.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4069` |
| 3.5% | 51.1ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` |
| 3.4% | 50.6ms | 0.0% | 0us | `require` | `[native code]` |
| 3.3% | 49.4ms | 0.3% | 4.7ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2186` |
| 3.3% | 48.9ms | 3.3% | 48.9ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1020` |
| 2.6% | 38.2ms | 0.0% | 0us | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 2.5% | 36.8ms | 2.4% | 35.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2017` |
| 2.4% | 35.4ms | 0.2% | 3.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 2.3% | 34.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` |
| 2.2% | 32.6ms | 0.4% | 6.1ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2222` |
| 2.0% | 29.6ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` |
| 2.0% | 29.6ms | 0.0% | 0us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1898` |
| 1.9% | 28.1ms | 1.9% | 28.1ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 1.7% | 25.8ms | 1.7% | 25.8ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1018` |
| 1.7% | 25.0ms | 0.4% | 6.7ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` |
| 1.7% | 24.8ms | 1.7% | 24.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1188` |
| 1.5% | 23.0ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2673` |
| 1.5% | 22.7ms | 1.5% | 22.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4051` |
| 1.5% | 22.2ms | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 1.4% | 21.5ms | 1.3% | 19.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2223` |
| 1.4% | 21.4ms | 0.0% | 1.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` |
| 1.4% | 21.3ms | 0.3% | 5.1ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` |
| 1.4% | 21.3ms | 0.0% | 0us | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2782` |
| 1.3% | 20.1ms | 1.3% | 20.1ms | `Set` | `[native code]` |
| 1.3% | 20.0ms | 0.0% | 0us | `_ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:924` |
| 1.3% | 20.0ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:957` |
| 1.3% | 19.9ms | 1.2% | 18.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2229` |
| 1.3% | 19.5ms | 0.1% | 1.4ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2763` |
| 1.3% | 19.2ms | 0.0% | 0us | `parseModule` | `[native code]` |
| 1.3% | 19.2ms | 0.1% | 1.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2320` |
| 1.2% | 18.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` |
| 1.2% | 18.3ms | 1.2% | 18.3ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4024` |
| 1.2% | 18.2ms | 0.1% | 1.6ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2589` |
| 1.2% | 18.2ms | 0.8% | 11.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 1.2% | 18.0ms | 0.0% | 0us | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:879` |
| 1.1% | 16.7ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1710` |
| 1.1% | 16.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` |
| 1.1% | 16.3ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` |
| 1.1% | 16.2ms | 1.1% | 16.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6743` |
| 1.1% | 16.2ms | 0.5% | 8.1ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` |
| 1.0% | 15.4ms | 1.0% | 15.4ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` |
| 1.0% | 15.4ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` |
| 1.0% | 14.9ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:72` |
| 0.9% | 14.0ms | 0.9% | 14.0ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3166` |
| 0.9% | 13.8ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1730` |
| 0.8% | 12.8ms | 0.8% | 12.8ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.8% | 12.3ms | 0.8% | 12.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4046` |
| 0.8% | 12.2ms | 0.0% | 0us | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` |
| 0.8% | 12.0ms | 0.3% | 4.8ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:813` |
| 0.7% | 11.3ms | 0.3% | 5.7ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2868` |
| 0.7% | 10.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` |
| 0.6% | 10.2ms | 0.2% | 4.2ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2792` |
| 0.6% | 9.9ms | 0.1% | 1.7ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2900` |
| 0.6% | 9.7ms | 0.4% | 6.4ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2840` |
| 0.6% | 9.3ms | 0.4% | 6.1ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3172` |
| 0.6% | 9.2ms | 0.6% | 9.2ms | `get` | `[native code]` |
| 0.6% | 9.2ms | 0.2% | 3.0ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 0.6% | 9.0ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7016` |
| 0.6% | 9.0ms | 0.6% | 9.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1241` |
| 0.6% | 8.7ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2029` |
| 0.5% | 8.5ms | 0.2% | 3.0ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.5% | 8.5ms | 0.3% | 5.2ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` |
| 0.5% | 8.2ms | 0.1% | 1.6ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2167` |
| 0.5% | 7.9ms | 0.4% | 6.3ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` |
| 0.5% | 7.9ms | 0.1% | 1.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:586` |
| 0.5% | 7.7ms | 0.3% | 4.5ms | `exec` | `[native code]` |
| 0.5% | 7.6ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2016` |
| 0.5% | 7.3ms | 0.5% | 7.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` |
| 0.4% | 7.2ms | 0.3% | 4.6ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:829` |
| 0.4% | 7.2ms | 0.0% | 0us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4109` |
| 0.4% | 7.2ms | 0.4% | 7.2ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:539` |
| 0.4% | 7.1ms | 0.3% | 5.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2071` |
| 0.4% | 7.0ms | 0.4% | 7.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.4% | 6.7ms | 0.4% | 6.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2428` |
| 0.4% | 6.6ms | 0.4% | 6.6ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1016` |
| 0.4% | 6.5ms | 0.0% | 0us | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2895` |
| 0.4% | 6.4ms | 0.1% | 1.6ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:494` |
| 0.4% | 6.4ms | 0.4% | 6.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2117` |
| 0.4% | 6.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:458` |
| 0.4% | 6.3ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` |
| 0.4% | 6.3ms | 0.4% | 6.3ms | `decode` | `[native code]` |
| 0.4% | 6.3ms | 0.0% | 0us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:522` |
| 0.4% | 6.2ms | 0.4% | 6.2ms | `set` | `[native code]` |
| 0.4% | 6.2ms | 0.4% | 6.2ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2846` |
| 0.4% | 6.2ms | 0.2% | 3.0ms | `scope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:745` |
| 0.4% | 6.1ms | 0.4% | 6.1ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.4% | 6.1ms | 0.4% | 6.1ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2745` |
| 0.4% | 6.1ms | 0.4% | 6.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2130` |
| 0.4% | 6.1ms | 0.4% | 6.1ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2215` |
| 0.4% | 6.1ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:747` |
| 0.4% | 6.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` |
| 0.4% | 6.1ms | 0.0% | 0us | `forEach` | `[native code]` |
| 0.4% | 6.0ms | 0.4% | 6.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4085` |
| 0.4% | 6.0ms | 0.4% | 6.0ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2698` |
| 0.4% | 5.8ms | 0.4% | 5.8ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 0.3% | 5.8ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` |
| 0.3% | 5.8ms | 0.0% | 1.3ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:587` |
| 0.3% | 5.7ms | 0.3% | 5.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4068` |
| 0.3% | 5.5ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1733` |
| 0.3% | 5.5ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:967` |
| 0.3% | 5.5ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:972` |
| 0.3% | 5.5ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3160` |
| 0.3% | 5.2ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7532` |
| 0.3% | 5.1ms | 0.3% | 5.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1256` |
| 0.3% | 5.1ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:551` |
| 0.3% | 5.0ms | 0.3% | 5.0ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2808` |
| 0.3% | 4.9ms | 0.3% | 4.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2107` |
| 0.3% | 4.8ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:452` |
| 0.3% | 4.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.3% | 4.8ms | 0.3% | 4.8ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2032` |
| 0.3% | 4.7ms | 0.3% | 4.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2697` |
| 0.3% | 4.7ms | 0.3% | 4.7ms | `getUint32` | `[native code]` |
| 0.3% | 4.6ms | 0.3% | 4.6ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2734` |
| 0.3% | 4.6ms | 0.0% | 0us | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2946` |
| 0.3% | 4.4ms | 0.3% | 4.4ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6474` |
| 0.3% | 4.4ms | 0.3% | 4.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4065` |
| 0.3% | 4.3ms | 0.3% | 4.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2018` |
| 0.2% | 4.2ms | 0.1% | 2.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3170` |
| 0.2% | 4.0ms | 0.1% | 1.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2322` |
| 0.2% | 3.8ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2081` |
| 0.2% | 3.5ms | 0.2% | 3.5ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 3.4ms | 0.1% | 1.6ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2677` |
| 0.2% | 3.3ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.2% | 3.3ms | 0.2% | 3.3ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2787` |
| 0.2% | 3.3ms | 0.2% | 3.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2738` |
| 0.2% | 3.3ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2227` |
| 0.2% | 3.2ms | 0.0% | 0us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2701` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` |
| 0.2% | 3.2ms | 0.0% | 0us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:92` |
| 0.2% | 3.2ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:215` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `encodeInto` | `[native code]` |
| 0.2% | 3.1ms | 0.2% | 3.1ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2015` |
| 0.2% | 3.1ms | 0.2% | 3.1ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:591` |
| 0.2% | 3.1ms | 0.0% | 0us | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:803` |
| 0.2% | 3.1ms | 0.2% | 3.1ms | `range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3627` |
| 0.2% | 3.1ms | 0.2% | 3.1ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4319` |
| 0.2% | 3.1ms | 0.2% | 3.1ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:846` |
| 0.2% | 3.1ms | 0.2% | 3.1ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3099` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:589` |
| 0.2% | 3.0ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:661` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3627` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` |
| 0.2% | 3.0ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:557` |
| 0.2% | 3.0ms | 0.0% | 0us | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:506` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 2.9ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.2% | 2.9ms | 0.2% | 2.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2113` |
| 0.2% | 2.9ms | 0.0% | 1.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1220` |
| 0.2% | 2.9ms | 0.1% | 1.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` |
| 0.2% | 2.9ms | 0.0% | 0us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:688` |
| 0.2% | 2.9ms | 0.2% | 2.9ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:630` |
| 0.2% | 2.9ms | 0.1% | 1.6ms | `map` | `[native code]` |
| 0.2% | 2.9ms | 0.0% | 0us | `get defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6744` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2727` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3165` |
| 0.1% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` |
| 0.1% | 2.6ms | 0.1% | 2.6ms | `test` | `[native code]` |
| 0.1% | 2.6ms | 0.0% | 1.3ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2168` |
| 0.1% | 2.6ms | 0.1% | 2.6ms | `slice` | `[native code]` |
| 0.1% | 2.5ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1508` |
| 0.1% | 2.4ms | 0.1% | 2.4ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1059` |
| 0.1% | 1.8ms | 0.0% | 0us | `get identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:756` |
| 0.1% | 1.8ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3168` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.1% | 1.7ms | 0.0% | 0us | `get scope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:745` |
| 0.1% | 1.7ms | 0.0% | 0us | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` |
| 0.1% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` |
| 0.1% | 1.7ms | 0.0% | 0us | `isRead` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2586` |
| 0.1% | 1.7ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:662` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `/^(?:Function(?:Declaration\|Expression)\|ArrowFunctionExpression)$/u` | `[native code]` |
| 0.1% | 1.7ms | 0.0% | 0us | `isInsideOfStorableFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:630` |
| 0.1% | 1.7ms | 0.0% | 0us | `getUpperFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:134` |
| 0.1% | 1.7ms | 0.0% | 0us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4318` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `fill` | `[native code]` |
| 0.1% | 1.7ms | 0.0% | 0us | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1690` |
| 0.1% | 1.7ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:656` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `get operator` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1326` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_isOptionalTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3881` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2190` |
| 0.1% | 1.7ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7251` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7019` |
| 0.1% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` |
| 0.1% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:14` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2102` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1703` |
| 0.1% | 1.6ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3184` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:637` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `isRead` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:220` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:588` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6745` |
| 0.1% | 1.6ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.1% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` |
| 0.1% | 1.6ms | 0.0% | 0us | `internal:validators` | `internal:validators:2` |
| 0.1% | 1.6ms | 0.0% | 0us | `node:events` | `node:events:9` |
| 0.1% | 1.6ms | 0.0% | 0us | `internal:shared` | `internal:shared:2` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2674` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6476` |
| 0.1% | 1.5ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:543` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `/^\s*globals?\b/` | `[native code]` |
| 0.1% | 1.5ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:144` |
| 0.1% | 1.5ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:54` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:593` |
| 0.1% | 1.5ms | 0.0% | 0us | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2946` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:12` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `extraClassData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 1.4ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:776` |
| 0.1% | 1.4ms | 0.0% | 0us | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2303` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2822` |
| 0.1% | 1.4ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:880` |
| 0.1% | 1.4ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4137` |
| 0.1% | 1.4ms | 0.0% | 0us | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3921` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2747` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2676` |
| 0.0% | 1.4ms | 0.0% | 0us | `requestSatisfyUtil` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `requestFetch` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `fetch` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `requestInstantiate` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:654` |
| 0.0% | 1.4ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2225` |
| 0.0% | 1.4ms | 0.0% | 0us | `identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:756` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3102` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7192` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2212` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:808` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1219` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1026` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2699` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3148` |
| 0.0% | 1.3ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4344` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `filter` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7539` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:21` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1189` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7188` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2226` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:21` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2137` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 1.3ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1513` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3655` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:881` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:879` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2011` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:876` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_fromRunnerReport` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:225` |
| 0.0% | 1.2ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:309` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2031` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2078` |
| 0.0% | 1.2ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1719` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2028` |
| 0.0% | 1.1ms | 0.0% | 1.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6747` |
| 0.0% | 1.1ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7535` |
| 0.0% | 1.0ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` |
| 0.0% | 956us | 0.0% | 956us | `DataView` | `[native code]` |
| 0.0% | 956us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:279` |

## Function Details

### `parse`
`[native code]` | Self: 26.5% (388.0ms) | Total: 26.5% (388.0ms) | Samples: 252

**Called by:**
- `parseSource` (252)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7017` | Self: 3.7% (55.0ms) | Total: 3.7% (55.0ms) | Samples: 36

**Called by:**
- `runPlugins` (36)

### `setPrototypeDirect`
`[native code]` | Self: 3.7% (54.8ms) | Total: 3.7% (54.8ms) | Samples: 36

**Called by:**
- `_nodeViewRaw` (36)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1020` | Self: 3.3% (48.9ms) | Total: 3.3% (48.9ms) | Samples: 32

**Called by:**
- `_nodeViewRaw` (32)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2017` | Self: 2.4% (35.3ms) | Total: 2.5% (36.8ms) | Samples: 23

**Called by:**
- `_buildScopeVarsAndSet` (24)

**Calls:**
- `set` (1)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 1.9% (28.1ms) | Total: 1.9% (28.1ms) | Samples: 19

**Called by:**
- `_nodeViewRaw` (12)
- `_nodeViewRaw` (7)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4061` | Self: 1.8% (27.3ms) | Total: 8.6% (126.4ms) | Samples: 18

**Called by:**
- `get parent` (52)
- `_buildReference` (10)
- `get body` (8)
- `_nodesFromRange` (7)
- `get body` (2)
- `init` (2)
- `_computeVariableSynthRefs` (1)
- `_buildScope` (1)

**Calls:**
- `_computeNodeType` (32)
- `_NodeView` (12)
- `_computeNodeType` (9)
- `_computeNodeType` (7)
- `_computeNodeType` (4)
- `_computeNodeType` (1)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1018` | Self: 1.7% (25.8ms) | Total: 1.7% (25.8ms) | Samples: 17

**Called by:**
- `_nodeViewRaw` (9)
- `_nodeViewRaw` (8)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1208` | Self: 1.7% (25.5ms) | Total: 9.3% (136.8ms) | Samples: 16

**Called by:**
- `_buildReference` (76)
- `_findDefNode` (7)
- `isForInOfRef` (3)
- `isUnusedExpression` (1)
- `_computeVarDefs` (1)
- `_computeIsStrict` (1)

**Calls:**
- `_nodeViewRaw` (52)
- `_nodeViewRaw` (9)
- `nodeView` (5)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1188` | Self: 1.7% (24.8ms) | Total: 1.7% (24.8ms) | Samples: 16

**Called by:**
- `(anonymous)` (4)
- `_buildReference` (3)
- `isReadForItself` (2)
- `collectUnusedVariables` (2)
- `isForInOfRef` (2)
- `isUnusedExpression` (1)
- `isForInOfRef` (1)
- `_computeIsStrict` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4051` | Self: 1.5% (22.7ms) | Total: 1.5% (22.7ms) | Samples: 15

**Called by:**
- `get parent` (9)
- `_buildReference` (2)
- `get body` (1)
- `get init` (1)
- `get body` (1)
- `_nodesFromRange` (1)

### `Set`
`[native code]` | Self: 1.3% (20.1ms) | Total: 1.3% (20.1ms) | Samples: 14

**Called by:**
- `_computeDeclaredVariables` (14)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4069` | Self: 1.3% (19.9ms) | Total: 3.5% (52.0ms) | Samples: 12

**Called by:**
- `_buildReference` (26)
- `_computeVarDefs` (5)
- `get parent` (1)
- `_computeVariableSynthRefs` (1)

**Calls:**
- `_computeNodeType` (12)
- `_computeNodeType` (8)
- `_computeNodeType` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2223` | Self: 1.3% (19.9ms) | Total: 1.4% (21.5ms) | Samples: 13

**Called by:**
- `_ensureVarsSet` (14)

**Calls:**
- `get` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2229` | Self: 1.2% (18.3ms) | Total: 1.3% (19.9ms) | Samples: 12

**Called by:**
- `_ensureVarsSet` (13)

**Calls:**
- `set` (1)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4024` | Self: 1.2% (18.3ms) | Total: 1.2% (18.3ms) | Samples: 12

**Called by:**
- `_nodeViewRaw` (12)

### `anonymous`
`[native code]` | Self: 1.2% (18.1ms) | Total: 4.1% (60.4ms) | Samples: 12

**Called by:**
- `require` (33)
- `bound require` (2)
- `internal:shared` (1)
- `internal:validators` (1)
- `node:fs` (1)
- `node:events` (1)

**Calls:**
- `(anonymous)` (7)
- `(anonymous)` (4)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:events` (1)
- `internal:shared` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:fs` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:validators` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6743` | Self: 1.1% (16.2ms) | Total: 1.1% (16.2ms) | Samples: 11

**Called by:**
- `runPlugins` (11)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` | Self: 1.0% (15.4ms) | Total: 1.0% (15.4ms) | Samples: 10

**Called by:**
- `getRhsNode` (10)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3166` | Self: 0.9% (14.0ms) | Total: 0.9% (14.0ms) | Samples: 9

**Called by:**
- `getDeclaredVariables` (9)

### `/\/\*([\s\S]*?)\*\//g`
`[native code]` | Self: 0.8% (12.8ms) | Total: 0.8% (12.8ms) | Samples: 8

**Called by:**
- `_buildScopeVarsAndSet` (6)
- `exec` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4046` | Self: 0.8% (12.3ms) | Total: 0.8% (12.3ms) | Samples: 8

**Called by:**
- `_nodesFromRange` (3)
- `_computeVarDefs` (2)
- `get body` (1)
- `get parent` (1)
- `get body` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` | Self: 0.8% (11.7ms) | Total: 1.2% (18.2ms) | Samples: 8

**Called by:**
- `some` (12)

**Calls:**
- `get parent` (4)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2087` | Self: 0.7% (10.6ms) | Total: 4.9% (72.6ms) | Samples: 7

**Called by:**
- `_buildScope` (22)
- `_buildReference` (18)
- `_buildScopeChildren` (7)

**Calls:**
- `_computeIsStrict` (32)
- `_computeIsStrict` (5)
- `_computeIsStrict` (2)
- `_computeIsStrict` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` | Self: 0.7% (10.2ms) | Total: 25.9% (378.4ms) | Samples: 7

**Called by:**
- `collectUnusedVariables` (206)
- `(anonymous)` (31)
- `isUsedVariable` (8)
- `_buildScopeVarsAndSet` (2)
- `_computeDeclaredVariables` (1)

**Calls:**
- `_buildReference` (82)
- `_buildReference` (76)
- `_buildReference` (64)
- `_buildReference` (8)
- `_buildReference` (6)
- `_buildReference` (4)
- `_buildReference` (1)

### `get`
`[native code]` | Self: 0.6% (9.2ms) | Total: 0.6% (9.2ms) | Samples: 6

**Called by:**
- `_ensureDeclSymIndex` (5)
- `_buildScopeVarsAndSet` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1241` | Self: 0.6% (9.0ms) | Total: 0.6% (9.0ms) | Samples: 6

**Called by:**
- `_findDefNode` (1)
- `isForInOfRef` (1)
- `_computeIsStrict` (1)
- `isRead` (1)
- `isForInOfRef` (1)
- `_buildReference` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` | Self: 0.5% (8.1ms) | Total: 1.1% (16.2ms) | Samples: 5

**Called by:**
- `(anonymous)` (10)

**Calls:**
- `get parent` (3)
- `get parent` (1)
- `get parent` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4063` | Self: 0.5% (7.3ms) | Total: 4.2% (62.2ms) | Samples: 5

**Called by:**
- `_buildReference` (31)
- `_computeVarDefs` (4)
- `_computeVariableSynthRefs` (3)
- `get parent` (2)
- `_nodesFromRange` (1)

**Calls:**
- `setPrototypeDirect` (36)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` | Self: 0.5% (7.3ms) | Total: 0.5% (7.3ms) | Samples: 5

**Called by:**
- `getDeclaredVariables` (5)

### `nodeLhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:539` | Self: 0.4% (7.2ms) | Total: 0.4% (7.2ms) | Samples: 5

**Called by:**
- `nodeView` (5)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.4% (7.0ms) | Total: 0.4% (7.0ms) | Samples: 5

**Called by:**
- `_computeVarDefs` (2)
- `_computeIsStrict` (1)
- `_findDefNode` (1)
- `collectUnusedVariables` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` | Self: 0.4% (6.7ms) | Total: 1.7% (25.0ms) | Samples: 4

**Called by:**
- `collectUnusedVariables` (9)
- `(anonymous)` (7)

**Calls:**
- `_computeVariableSynthRefs` (7)
- `_computeVariableSynthRefs` (4)
- `_computeVariableSynthRefs` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2428` | Self: 0.4% (6.7ms) | Total: 0.4% (6.7ms) | Samples: 4

**Called by:**
- `_ensureVarsSet` (4)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1016` | Self: 0.4% (6.6ms) | Total: 0.4% (6.6ms) | Samples: 4

**Called by:**
- `_nodeViewRaw` (4)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2117` | Self: 0.4% (6.4ms) | Total: 0.4% (6.4ms) | Samples: 4

**Called by:**
- `_buildScope` (2)
- `_buildReference` (1)
- `_buildScopeChildren` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2840` | Self: 0.4% (6.4ms) | Total: 0.6% (9.7ms) | Samples: 4

**Called by:**
- `get references` (6)

**Calls:**
- `_buildVariable` (2)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` | Self: 0.4% (6.3ms) | Total: 0.5% (7.9ms) | Samples: 4

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `isRead` (1)

### `decode`
`[native code]` | Self: 0.4% (6.3ms) | Total: 0.4% (6.3ms) | Samples: 4

**Called by:**
- `get source` (4)

### `set`
`[native code]` | Self: 0.4% (6.2ms) | Total: 0.4% (6.2ms) | Samples: 4

**Called by:**
- `_computeDeclaredVariables` (2)
- `_buildScopeVarsAndSet` (1)
- `_ensureDeclSymIndex` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2846` | Self: 0.4% (6.2ms) | Total: 0.4% (6.2ms) | Samples: 4

**Called by:**
- `get references` (4)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.4% (6.1ms) | Total: 0.4% (6.1ms) | Samples: 4

**Called by:**
- `commentsInRange` (2)
- `commentsInRange` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2745` | Self: 0.4% (6.1ms) | Total: 0.4% (6.1ms) | Samples: 4

**Called by:**
- `_buildScopeVarsAndSet` (4)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2130` | Self: 0.4% (6.1ms) | Total: 0.4% (6.1ms) | Samples: 4

**Called by:**
- `_buildReference` (4)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2222` | Self: 0.4% (6.1ms) | Total: 2.2% (32.6ms) | Samples: 4

**Called by:**
- `_ensureVarsSet` (21)

**Calls:**
- `_buildVariable` (4)
- `_buildVariable` (3)
- `_buildVariable` (3)
- `_buildVariable` (3)
- `_buildVariable` (2)
- `_buildVariable` (1)
- `_buildVariable` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2215` | Self: 0.4% (6.1ms) | Total: 0.4% (6.1ms) | Samples: 4

**Called by:**
- `_ensureVarsSet` (4)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3172` | Self: 0.4% (6.1ms) | Total: 0.6% (9.3ms) | Samples: 4

**Called by:**
- `getDeclaredVariables` (6)

**Calls:**
- `set` (2)

### `defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` | Self: 0.4% (6.1ms) | Total: 3.9% (57.6ms) | Samples: 4

**Called by:**
- `collectUnusedVariables` (30)
- `isAfterLastUsedArg` (4)
- `identifiers` (1)
- `get identifiers` (1)

**Calls:**
- `_computeVarDefs` (12)
- `_computeVarDefs` (12)
- `_computeVarDefs` (6)
- `_computeVarDefs` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4085` | Self: 0.4% (6.0ms) | Total: 0.4% (6.0ms) | Samples: 4

**Called by:**
- `get parent` (3)
- `_computeVariableSynthRefs` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2698` | Self: 0.4% (6.0ms) | Total: 0.4% (6.0ms) | Samples: 4

**Called by:**
- `_buildScopeVarsAndSet` (3)
- `_computeDeclaredVariables` (1)

### `some`
`[native code]` | Self: 0.4% (5.9ms) | Total: 11.9% (174.2ms) | Samples: 4

**Called by:**
- `collectUnusedVariables` (48)
- `isAfterLastUsedArg` (39)
- `isUsedVariable` (15)
- `collectUnusedVariables` (12)

**Calls:**
- `(anonymous)` (38)
- `(anonymous)` (23)
- `(anonymous)` (22)
- `(anonymous)` (12)
- `(anonymous)` (12)
- `(anonymous)` (2)
- `(anonymous)` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` | Self: 0.4% (5.8ms) | Total: 0.4% (5.8ms) | Samples: 4

**Called by:**
- `(anonymous)` (4)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2868` | Self: 0.3% (5.7ms) | Total: 0.7% (11.3ms) | Samples: 4

**Called by:**
- `get references` (8)

**Calls:**
- `get parent` (3)
- `get parent` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4068` | Self: 0.3% (5.7ms) | Total: 0.3% (5.7ms) | Samples: 4

**Called by:**
- `_buildReference` (4)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2071` | Self: 0.3% (5.5ms) | Total: 0.4% (7.1ms) | Samples: 4

**Called by:**
- `_buildReference` (3)
- `_buildScope` (2)

**Calls:**
- `_nodeViewRaw` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` | Self: 0.3% (5.2ms) | Total: 0.5% (8.5ms) | Samples: 3

**Called by:**
- `_computeIsStrict` (4)
- `isForInOfRef` (1)

**Calls:**
- `getUint32` (2)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` | Self: 0.3% (5.1ms) | Total: 1.4% (21.3ms) | Samples: 3

**Called by:**
- `_computeVarDefs` (13)

**Calls:**
- `get parent` (7)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1256` | Self: 0.3% (5.1ms) | Total: 0.3% (5.1ms) | Samples: 3

**Called by:**
- `_buildReference` (2)
- `_findDefNode` (1)

### `_computeVarScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2808` | Self: 0.3% (5.0ms) | Total: 0.3% (5.0ms) | Samples: 3

**Called by:**
- `scope` (2)
- `get scope` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2107` | Self: 0.3% (4.9ms) | Total: 0.3% (4.9ms) | Samples: 3

**Called by:**
- `_buildReference` (3)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2032` | Self: 0.3% (4.8ms) | Total: 0.3% (4.8ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:813` | Self: 0.3% (4.8ms) | Total: 0.8% (12.0ms) | Samples: 3

**Called by:**
- `_ensureDeclSymIndex` (6)
- `_buildVariable` (2)

**Calls:**
- `_buildSymNameCache` (5)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2697` | Self: 0.3% (4.7ms) | Total: 0.3% (4.7ms) | Samples: 3

**Called by:**
- `_buildScopeVarsAndSet` (3)

### `getUint32`
`[native code]` | Self: 0.3% (4.7ms) | Total: 0.3% (4.7ms) | Samples: 3

**Called by:**
- `get body` (2)
- `_isChainNode` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2186` | Self: 0.3% (4.7ms) | Total: 3.3% (49.4ms) | Samples: 3

**Called by:**
- `_buildScope` (32)

**Calls:**
- `get body` (11)
- `get body` (9)
- `get body` (4)
- `get body` (4)
- `get body` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2734` | Self: 0.3% (4.6ms) | Total: 0.3% (4.6ms) | Samples: 3

**Called by:**
- `_buildScopeVarsAndSet` (3)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:829` | Self: 0.3% (4.6ms) | Total: 0.4% (7.2ms) | Samples: 3

**Called by:**
- `_symName` (5)

**Calls:**
- `slice` (2)

### `exec`
`[native code]` | Self: 0.3% (4.5ms) | Total: 0.5% (7.7ms) | Samples: 3

**Called by:**
- `_buildScopeVarsAndSet` (5)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` | Self: 0.3% (4.5ms) | Total: 24.2% (354.7ms) | Samples: 3

**Called by:**
- `collectUnusedVariables` (231)
- `Program:exit` (1)

**Calls:**
- `get references` (206)
- `some` (12)
- `get references` (9)
- `get references` (2)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6474` | Self: 0.3% (4.4ms) | Total: 0.3% (4.4ms) | Samples: 3

**Called by:**
- `walkNodes` (3)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4065` | Self: 0.3% (4.4ms) | Total: 0.3% (4.4ms) | Samples: 3

**Called by:**
- `_buildReference` (3)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2018` | Self: 0.3% (4.3ms) | Total: 0.3% (4.3ms) | Samples: 3

**Called by:**
- `_buildScopeVarsAndSet` (3)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2837` | Self: 0.2% (4.3ms) | Total: 8.5% (125.0ms) | Samples: 3

**Called by:**
- `get references` (82)

**Calls:**
- `get parent` (76)
- `get parent` (2)
- `get parent` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2792` | Self: 0.2% (4.2ms) | Total: 0.6% (10.2ms) | Samples: 3

**Called by:**
- `defs` (6)
- `get defs` (1)

**Calls:**
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2844` | Self: 0.2% (4.1ms) | Total: 6.6% (97.4ms) | Samples: 3

**Called by:**
- `get references` (64)

**Calls:**
- `_buildScope` (29)
- `_buildScope` (18)
- `_buildScope` (4)
- `_buildScope` (3)
- `_buildScope` (3)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.2% (3.5ms) | Total: 0.2% (3.5ms) | Samples: 2

**Called by:**
- `isInside` (1)
- `isInside` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2787` | Self: 0.2% (3.3ms) | Total: 0.2% (3.3ms) | Samples: 2

**Called by:**
- `defs` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2738` | Self: 0.2% (3.3ms) | Total: 0.2% (3.3ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2213` | Self: 0.2% (3.2ms) | Total: 4.9% (72.6ms) | Samples: 2

**Called by:**
- `_ensureVarsSet` (47)

**Calls:**
- `_ensureDeclSymIndex` (24)
- `_ensureDeclSymIndex` (6)
- `_ensureDeclSymIndex` (5)
- `_ensureDeclSymIndex` (3)
- `_ensureDeclSymIndex` (2)
- `_ensureDeclSymIndex` (2)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` | Self: 0.2% (3.2ms) | Total: 0.2% (3.2ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `encodeInto`
`[native code]` | Self: 0.2% (3.2ms) | Total: 0.2% (3.2ms) | Samples: 2

**Called by:**
- `_encodeSource` (2)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2015` | Self: 0.2% (3.1ms) | Total: 0.2% (3.1ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:591` | Self: 0.2% (3.1ms) | Total: 0.2% (3.1ms) | Samples: 2

**Called by:**
- `_precomputeScopes` (2)

### `range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3627` | Self: 0.2% (3.1ms) | Total: 0.2% (3.1ms) | Samples: 2

**Called by:**
- `get references` (2)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4319` | Self: 0.2% (3.1ms) | Total: 0.2% (3.1ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:846` | Self: 0.2% (3.1ms) | Total: 0.2% (3.1ms) | Samples: 2

**Called by:**
- `get` (2)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3099` | Self: 0.2% (3.1ms) | Total: 0.2% (3.1ms) | Samples: 2

**Called by:**
- `isAfterLastUsedArg` (2)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` | Self: 0.2% (3.0ms) | Total: 0.2% (3.0ms) | Samples: 2

**Called by:**
- `isUsedVariable` (2)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:589` | Self: 0.2% (3.0ms) | Total: 0.2% (3.0ms) | Samples: 2

**Called by:**
- `_precomputeScopes` (2)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` | Self: 0.2% (3.0ms) | Total: 0.6% (9.2ms) | Samples: 1

**Called by:**
- `isUsedVariable` (5)

**Calls:**
- `forEach` (4)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3627` | Self: 0.2% (3.0ms) | Total: 0.2% (3.0ms) | Samples: 2

**Called by:**
- `isInside` (2)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` | Self: 0.2% (3.0ms) | Total: 0.2% (3.0ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` | Self: 0.2% (3.0ms) | Total: 0.5% (8.5ms) | Samples: 2

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` | Self: 0.2% (3.0ms) | Total: 2.4% (35.4ms) | Samples: 2

**Called by:**
- `some` (23)

**Calls:**
- `getRhsNode` (10)
- `getRhsNode` (4)
- `getRhsNode` (3)
- `getRhsNode` (2)
- `getRhsNode` (1)
- `getRhsNode` (1)

### `scope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:745` | Self: 0.2% (3.0ms) | Total: 0.4% (6.2ms) | Samples: 2

**Called by:**
- `_computeVariableSynthRefs` (3)
- `getRhsNode` (1)

**Calls:**
- `_computeVarScope` (2)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.2% (3.0ms) | Total: 0.2% (3.0ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2113` | Self: 0.2% (2.9ms) | Total: 0.2% (2.9ms) | Samples: 2

**Called by:**
- `_buildReference` (1)
- `_buildScopeChildren` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:630` | Self: 0.2% (2.9ms) | Total: 0.2% (2.9ms) | Samples: 2

**Called by:**
- `commentsInRange` (1)
- `commentsInRange` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6744` | Self: 0.1% (2.9ms) | Total: 0.1% (2.9ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2727` | Self: 0.1% (2.8ms) | Total: 0.1% (2.8ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (1)
- `_computeDeclaredVariables` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3165` | Self: 0.1% (2.8ms) | Total: 0.1% (2.8ms) | Samples: 2

**Called by:**
- `getDeclaredVariables` (2)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3170` | Self: 0.1% (2.7ms) | Total: 0.2% (4.2ms) | Samples: 2

**Called by:**
- `getDeclaredVariables` (3)

**Calls:**
- `get references` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` | Self: 0.1% (2.7ms) | Total: 0.1% (2.7ms) | Samples: 2

**Called by:**
- `some` (2)

### `test`
`[native code]` | Self: 0.1% (2.6ms) | Total: 0.1% (2.6ms) | Samples: 2

**Called by:**
- `_precomputeScopes` (1)
- `_buildScopeVarsAndSet` (1)

### `slice`
`[native code]` | Self: 0.1% (2.6ms) | Total: 0.1% (2.6ms) | Samples: 2

**Called by:**
- `_buildSymNameCache` (2)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` | Self: 0.1% (2.4ms) | Total: 0.1% (2.4ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (2)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1059` | Self: 0.1% (1.8ms) | Total: 0.1% (1.8ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` | Self: 0.1% (1.8ms) | Total: 0.1% (1.8ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (1.8ms) | Total: 0.1% (1.8ms) | Samples: 1

**Called by:**
- `get references` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2320` | Self: 0.1% (1.8ms) | Total: 1.3% (19.2ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (12)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (6)
- `exec` (5)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2900` | Self: 0.1% (1.7ms) | Total: 0.6% (9.9ms) | Samples: 1

**Called by:**
- `get references` (7)

**Calls:**
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2586` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `_ensureChildren` (1)

### `/^(?:Function(?:Declaration\|Expression)\|ArrowFunctionExpression)$/u`
`[native code]` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `getUpperFunction` (1)

### `fill`
`[native code]` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `CfgGraph` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1690` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `get operator`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1326` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `isReadForItself` (1)

### `_isOptionalTag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3881` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `get parent` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2190` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7019` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2102` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1703` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `map`
`[native code]` | Self: 0.1% (1.6ms) | Total: 0.2% (2.9ms) | Samples: 1

**Called by:**
- `_computeDeclaredVariables` (1)
- `_lintSourceOne` (1)

**Calls:**
- `_fromRunnerReport` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2677` | Self: 0.1% (1.6ms) | Total: 0.2% (3.4ms) | Samples: 1

**Called by:**
- `getScope` (2)

**Calls:**
- `test` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2589` | Self: 0.1% (1.6ms) | Total: 1.2% (18.2ms) | Samples: 1

**Called by:**
- `_ensureChildren` (12)

**Calls:**
- `_buildScope` (7)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2322` | Self: 0.1% (1.6ms) | Total: 0.2% (4.0ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (3)

**Calls:**
- `test` (1)
- `/^\s*globals?\b/` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:637` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `commentsInRange` (1)

### `isRead`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:220` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `isReadForItself` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:588` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `isInside`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:494` | Self: 0.1% (1.6ms) | Total: 0.4% (6.4ms) | Samples: 1

**Called by:**
- `getRhsNode` (2)
- `isReadForItself` (2)

**Calls:**
- `get range` (2)
- `get range` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2167` | Self: 0.1% (1.6ms) | Total: 0.5% (8.2ms) | Samples: 1

**Called by:**
- `_buildScope` (5)

**Calls:**
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6745` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` | Self: 0.1% (1.6ms) | Total: 100.0% (3.05s) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1474)
- `Program:exit` (520)

**Calls:**
- `collectUnusedVariables` (1474)
- `collectUnusedVariables` (231)
- `collectUnusedVariables` (96)
- `collectUnusedVariables` (82)
- `collectUnusedVariables` (72)
- `collectUnusedVariables` (32)
- `collectUnusedVariables` (2)
- `collectUnusedVariables` (2)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` | Self: 0.1% (1.5ms) | Total: 15.2% (222.0ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (82)
- `Program:exit` (62)

**Calls:**
- `get` (126)
- `get` (13)
- `get` (4)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2674` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `getScope` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` | Self: 0.1% (1.5ms) | Total: 0.2% (2.9ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (2)

**Calls:**
- `get eslintUsed` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6476` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `get references` (1)

### `/^\s*globals?\b/`
`[native code]` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:593` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:586` | Self: 0.1% (1.5ms) | Total: 0.5% (7.9ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (5)

**Calls:**
- `_findLineIdx` (2)
- `_findLineIdx` (1)
- `_findLineIdx` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `get` (1)

### `extraClassData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `get id` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2822` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2747` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2676` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `getScope` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2763` | Self: 0.1% (1.4ms) | Total: 1.3% (19.5ms) | Samples: 1

**Called by:**
- `defs` (12)

**Calls:**
- `_nodeViewRaw` (5)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (2)

### `fetch`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `requestFetch` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3101` | Self: 0.0% (1.4ms) | Total: 4.8% (71.1ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (48)

**Calls:**
- `_computeDeclaredVariables` (15)
- `_computeDeclaredVariables` (9)
- `_computeDeclaredVariables` (6)
- `_computeDeclaredVariables` (5)
- `_computeDeclaredVariables` (4)
- `_computeDeclaredVariables` (3)
- `_computeDeclaredVariables` (2)
- `_computeDeclaredVariables` (1)
- `_computeDeclaredVariables` (1)
- `_computeDeclaredVariables` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:654` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3102` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7192` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_computeDeclaredVariables` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get eslintUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:587` | Self: 0.0% (1.3ms) | Total: 0.3% (5.8ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (4)

**Calls:**
- `_findLineIdx` (2)
- `_findLineIdx` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2212` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:808` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `isUsedVariable` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1219` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_lintSourceOne` (1)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1026` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2699` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_computeDeclaredVariables` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3148` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `filter`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1189` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `isForInOfRef` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `async (anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7188` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` | Self: 0.0% (1.3ms) | Total: 1.4% (21.4ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (15)

**Calls:**
- `Set` (14)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2168` | Self: 0.0% (1.3ms) | Total: 0.1% (2.6ms) | Samples: 1

**Called by:**
- `_buildScope` (2)

**Calls:**
- `get parent` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2226` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2137` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3655` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `get value` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:881` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:879` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2011` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1220` | Self: 0.0% (1.2ms) | Total: 0.2% (2.9ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)
- `_computeVarDefs` (1)

**Calls:**
- `_isOptionalTag` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:876` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `get value` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2031` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_fromRunnerReport`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:225` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `map` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2078` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:845` | Self: 0.0% (1.2ms) | Total: 13.1% (191.7ms) | Samples: 1

**Called by:**
- `get` (123)
- `_ensureVarsSet` (1)

**Calls:**
- `_buildScopeVarsAndSet` (47)
- `_buildScopeVarsAndSet` (21)
- `_buildScopeVarsAndSet` (14)
- `_buildScopeVarsAndSet` (13)
- `_buildScopeVarsAndSet` (12)
- `_buildScopeVarsAndSet` (4)
- `_buildScopeVarsAndSet` (4)
- `_buildScopeVarsAndSet` (3)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2028` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6747` | Self: 0.0% (1.1ms) | Total: 0.0% (1.1ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `DataView`
`[native code]` | Self: 0.0% (956us) | Total: 0.0% (956us) | Samples: 1

**Called by:**
- `AstView` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2673` | Self: 0.0% (0us) | Total: 1.5% (23.0ms) | Samples: 0

**Called by:**
- `getScope` (15)

**Calls:**
- `commentsInRange` (5)
- `commentsInRange` (4)
- `commentsInRange` (2)
- `commentsInRange` (2)
- `commentsInRange` (1)
- `commentsInRange` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:543` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `scope` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:144` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Calls:**
- `loadCoreRules` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:300` | Self: 0.0% (0us) | Total: 27.2% (398.4ms) | Samples: 0

**Calls:**
- `parseSource` (252)
- `parseSource` (3)
- `parseSource` (2)
- `parseSource` (1)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:54` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (1)

**Calls:**
- `bound require` (1)

### `requestInstantiate`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `requestSatisfyUtil` (1)

**Calls:**
- `async (anonymous)` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` | Self: 0.0% (0us) | Total: 8.6% (125.8ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (72)
- `Program:exit` (8)

**Calls:**
- `some` (48)
- `isUsedVariable` (24)
- `isUsedVariable` (7)
- `isUsedVariable` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2701` | Self: 0.0% (0us) | Total: 0.2% (3.2ms) | Samples: 0

**Called by:**
- `_buildReference` (2)

**Calls:**
- `_symName` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7016` | Self: 0.0% (0us) | Total: 0.6% (9.0ms) | Samples: 0

**Called by:**
- `runPlugins` (6)

**Calls:**
- `getDFSEvents` (3)
- `getDFSEvents` (2)
- `getDFSEvents` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1508` | Self: 0.0% (0us) | Total: 0.1% (2.5ms) | Samples: 0

**Called by:**
- `_buildScope` (2)

**Calls:**
- `_nodesFromRange` (1)
- `_nodesFromRange` (1)

### `get identifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:756` | Self: 0.0% (0us) | Total: 0.1% (1.8ms) | Samples: 0

**Called by:**
- `_computeDeclaredVariables` (1)

**Calls:**
- `defs` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1730` | Self: 0.0% (0us) | Total: 0.9% (13.8ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (9)

**Calls:**
- `_nodeViewRaw` (8)
- `_nodeViewRaw` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1719` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `isForInOfRef` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `getUpperFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:134` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `isInsideOfStorableFunction` (1)

**Calls:**
- `/^(?:Function(?:Declaration\|Expression)\|ArrowFunctionExpression)$/u` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:14` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `some` (1)

**Calls:**
- `isSelfReference` (1)

### `requestFetch`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `fetch` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2225` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `identifiers` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:662` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isInsideOfStorableFunction` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:279` | Self: 0.0% (0us) | Total: 0.0% (956us) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `DataView` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:309` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Calls:**
- `map` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:880` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `_buildReference` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` | Self: 0.0% (0us) | Total: 2.3% (34.0ms) | Samples: 0

**Called by:**
- `some` (22)

**Calls:**
- `isForInOfRef` (10)
- `isForInOfRef` (6)
- `isForInOfRef` (2)
- `isForInOfRef` (2)
- `isForInOfRef` (2)

### `identifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:756` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `defs` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4109` | Self: 0.0% (0us) | Total: 0.4% (7.2ms) | Samples: 0

**Called by:**
- `get parent` (5)

**Calls:**
- `nodeLhs` (5)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:967` | Self: 0.0% (0us) | Total: 0.3% (5.5ms) | Samples: 0

**Called by:**
- `get` (4)

**Calls:**
- `_ensureVarsSet` (1)
- `_ensureVarsSet` (1)
- `_ensureVarsSet` (1)
- `_ensureVarsSet` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:803` | Self: 0.0% (0us) | Total: 0.2% (3.1ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (2)

**Calls:**
- `range` (2)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` | Self: 0.0% (0us) | Total: 2.0% (29.6ms) | Samples: 0

**Called by:**
- `_invokeFused` (19)

**Calls:**
- `getScope` (19)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7540` | Self: 0.0% (0us) | Total: 70.5% (1.03s) | Samples: 0

**Called by:**
- `_lintSourceOne` (672)

**Calls:**
- `walkNodes` (611)
- `walkNodes` (36)
- `walkNodes` (11)
- `walkNodes` (6)
- `walkNodes` (2)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3168` | Self: 0.0% (0us) | Total: 0.1% (1.8ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (1)

**Calls:**
- `get identifiers` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2227` | Self: 0.0% (0us) | Total: 0.2% (3.3ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (2)

**Calls:**
- `get references` (2)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:661` | Self: 0.0% (0us) | Total: 0.2% (3.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `isInside` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7256` | Self: 0.0% (0us) | Total: 64.2% (938.3ms) | Samples: 0

**Called by:**
- `runPlugins` (611)

**Calls:**
- `_invokeFused` (611)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:776` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `get id` (1)

### `forEach`
`[native code]` | Self: 0.0% (0us) | Total: 0.4% (6.1ms) | Samples: 0

**Called by:**
- `getFunctionDefinitions` (4)

**Calls:**
- `(anonymous)` (4)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:452` | Self: 0.0% (0us) | Total: 0.3% (4.8ms) | Samples: 0

**Called by:**
- `parseSource` (2)

**Calls:**
- `CfgGraph` (1)
- `CfgGraph` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4672` | Self: 0.0% (0us) | Total: 64.2% (938.3ms) | Samples: 0

**Called by:**
- `walkNodes` (611)

**Calls:**
- `Program:exit` (591)
- `Program:exit` (19)
- `Program:exit` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3184` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (1)

**Calls:**
- `map` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:879` | Self: 0.0% (0us) | Total: 1.2% (18.0ms) | Samples: 0

**Called by:**
- `get body` (11)
- `get value` (1)

**Calls:**
- `_nodeViewRaw` (7)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 3.4% (50.6ms) | Samples: 0

**Called by:**
- `bound require` (33)

**Calls:**
- `anonymous` (33)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 1.5% (22.2ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)
- `requestInstantiate` (1)

**Calls:**
- `parseModule` (13)
- `async (anonymous)` (1)
- `requestFetch` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7535` | Self: 0.0% (0us) | Total: 0.0% (1.1ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `get source` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4344` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `create` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4137` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `init` (1)

**Calls:**
- `_isChainNode` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` | Self: 0.0% (0us) | Total: 62.1% (907.0ms) | Samples: 0

**Called by:**
- `_invokeFused` (591)

**Calls:**
- `collectUnusedVariables` (520)
- `collectUnusedVariables` (62)
- `collectUnusedVariables` (8)
- `collectUnusedVariables` (1)

### `get init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2946` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:752` | Self: 0.0% (0us) | Total: 4.0% (58.4ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (39)

**Calls:**
- `some` (39)

### `get scope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:745` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `_computeVariableSynthRefs` (1)

**Calls:**
- `_computeVarScope` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:21` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:557` | Self: 0.0% (0us) | Total: 0.2% (3.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `isUnusedExpression` (2)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:972` | Self: 0.0% (0us) | Total: 0.3% (5.5ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (4)

**Calls:**
- `_ensureVarsSet` (4)

### `isInsideOfStorableFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:630` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `isReadForItself` (1)

**Calls:**
- `getUpperFunction` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:215` | Self: 0.0% (0us) | Total: 0.2% (3.2ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (2)

**Calls:**
- `_encodeSource` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:458` | Self: 0.0% (0us) | Total: 0.4% (6.3ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `patchAstUtils` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` | Self: 0.0% (0us) | Total: 0.1% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` | Self: 0.0% (0us) | Total: 1.1% (16.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (11)

**Calls:**
- `async (anonymous)` (10)
- `async (anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` | Self: 0.0% (0us) | Total: 0.3% (5.8ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (3)

**Calls:**
- `AstView` (2)
- `AstView` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1733` | Self: 0.0% (0us) | Total: 0.3% (5.5ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (4)

**Calls:**
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` | Self: 0.0% (0us) | Total: 0.2% (2.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `get parent` (2)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:92` | Self: 0.0% (0us) | Total: 0.2% (3.2ms) | Samples: 0

**Called by:**
- `parseSource` (2)

**Calls:**
- `encodeInto` (2)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3160` | Self: 0.0% (0us) | Total: 0.3% (5.5ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (4)

**Calls:**
- `_buildVariable` (1)
- `_buildVariable` (1)
- `_buildVariable` (1)
- `_buildVariable` (1)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:522` | Self: 0.0% (0us) | Total: 0.4% (6.3ms) | Samples: 0

**Called by:**
- `runPlugins` (3)
- `runPlugins` (1)

**Calls:**
- `decode` (4)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:688` | Self: 0.0% (0us) | Total: 0.2% (2.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `get body` (1)
- `get body` (1)

### `_isChainNode`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3921` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `nodeViewChain` (1)

**Calls:**
- `getUint32` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:747` | Self: 0.0% (0us) | Total: 0.4% (6.1ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (4)

**Calls:**
- `defs` (4)

### `get id`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2303` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `extraClassData` (1)

### `isSelfReference`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isRead` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7539` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `buildVisitorMap` (1)

### `isRead`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `isSelfReference` (1)

**Calls:**
- `get parent` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1710` | Self: 0.0% (0us) | Total: 1.1% (16.7ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (11)

**Calls:**
- `_nodesFromRange` (11)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` | Self: 0.0% (0us) | Total: 9.7% (142.7ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (96)

**Calls:**
- `isAfterLastUsedArg` (51)
- `isAfterLastUsedArg` (39)
- `isAfterLastUsedArg` (4)
- `isAfterLastUsedArg` (2)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1898` | Self: 0.0% (0us) | Total: 2.0% (29.6ms) | Samples: 0

**Called by:**
- `Program:exit` (19)

**Calls:**
- `_precomputeScopes` (15)
- `_precomputeScopes` (2)
- `_precomputeScopes` (1)
- `_precomputeScopes` (1)

### `_ensureChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:924` | Self: 0.0% (0us) | Total: 1.3% (20.0ms) | Samples: 0

**Called by:**
- `get` (13)

**Calls:**
- `_buildScopeChildren` (12)
- `_buildScopeChildren` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` | Self: 0.0% (0us) | Total: 2.6% (38.2ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (24)

**Calls:**
- `some` (15)
- `get references` (8)
- `get references` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:72` | Self: 0.0% (0us) | Total: 1.0% (14.9ms) | Samples: 0

**Called by:**
- `async (anonymous)` (10)

**Calls:**
- `bound require` (10)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 3.6% (53.9ms) | Samples: 0

**Called by:**
- `async (anonymous)` (10)
- `(anonymous)` (7)
- `patchAstUtils` (4)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `loadCoreRules` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `require` (33)
- `anonymous` (2)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` | Self: 0.0% (0us) | Total: 26.5% (388.0ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (252)

**Calls:**
- `parse` (252)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` | Self: 0.0% (0us) | Total: 3.5% (51.1ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (32)

**Calls:**
- `defs` (30)
- `get defs` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` | Self: 0.0% (0us) | Total: 0.7% (10.9ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2081` | Self: 0.0% (0us) | Total: 0.2% (3.8ms) | Samples: 0

**Called by:**
- `_buildScope` (2)
- `_buildReference` (1)

**Calls:**
- `get value` (2)
- `get value` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.1% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2066` | Self: 0.0% (0us) | Total: 5.1% (75.2ms) | Samples: 0

**Called by:**
- `_buildReference` (29)
- `_buildScope` (20)

**Calls:**
- `_buildScope` (22)
- `_buildScope` (20)
- `_buildScope` (2)
- `_buildScope` (2)
- `_buildScope` (2)
- `_buildScope` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:656` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get operator` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` | Self: 0.0% (0us) | Total: 0.8% (12.2ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (7)

**Calls:**
- `getFunctionDefinitions` (5)
- `getFunctionDefinitions` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` | Self: 0.0% (0us) | Total: 0.2% (3.3ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (2)

**Calls:**
- `get parent` (2)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:304` | Self: 0.0% (0us) | Total: 71.1% (1.03s) | Samples: 0

**Calls:**
- `runPlugins` (672)
- `runPlugins` (3)
- `runPlugins` (1)
- `runPlugins` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.3% (4.8ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` | Self: 0.0% (0us) | Total: 1.2% (18.9ms) | Samples: 0

**Called by:**
- `some` (12)

**Calls:**
- `isReadForItself` (5)
- `isReadForItself` (2)
- `isReadForItself` (2)
- `isReadForItself` (1)
- `isReadForItself` (1)
- `isReadForItself` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2895` | Self: 0.0% (0us) | Total: 0.4% (6.5ms) | Samples: 0

**Called by:**
- `get references` (4)

**Calls:**
- `scope` (3)
- `get scope` (1)

### `get defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` | Self: 0.0% (0us) | Total: 0.2% (2.9ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (2)

**Calls:**
- `_computeVarDefs` (1)
- `_computeVarDefs` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:957` | Self: 0.0% (0us) | Total: 1.3% (20.0ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (13)

**Calls:**
- `_ensureChildren` (13)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` | Self: 0.0% (0us) | Total: 5.1% (75.6ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (51)

**Calls:**
- `getDeclaredVariables` (48)
- `getDeclaredVariables` (2)
- `getDeclaredVariables` (1)

### `internal:shared`
`internal:shared:2` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `node:events`
`node:events:9` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2782` | Self: 0.0% (0us) | Total: 1.4% (21.3ms) | Samples: 0

**Called by:**
- `defs` (12)
- `get defs` (1)

**Calls:**
- `_findDefNode` (13)

### `parseModule`
`[native code]` | Self: 0.0% (0us) | Total: 1.3% (19.2ms) | Samples: 0

**Called by:**
- `async (anonymous)` (13)

**Calls:**
- `(anonymous)` (11)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Calls:**
- `requestSatisfyUtil` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` | Self: 0.0% (0us) | Total: 0.4% (6.1ms) | Samples: 0

**Called by:**
- `forEach` (4)

**Calls:**
- `init` (3)
- `get init` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` | Self: 0.0% (0us) | Total: 0.0% (1.0ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `get parent` (1)

### `requestSatisfyUtil`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `requestInstantiate` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:12` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7251` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_fireCfgEvents` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2833` | Self: 0.0% (0us) | Total: 7.9% (116.8ms) | Samples: 0

**Called by:**
- `get references` (76)

**Calls:**
- `_nodeViewRaw` (31)
- `_nodeViewRaw` (26)
- `_nodeViewRaw` (10)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (2)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4318` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `AstView` (1)

**Calls:**
- `fill` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:953` | Self: 0.0% (0us) | Total: 13.3% (194.8ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (126)

**Calls:**
- `_ensureVarsSet` (123)
- `_ensureVarsSet` (2)
- `_ensureVarsSet` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2016` | Self: 0.0% (0us) | Total: 0.5% (7.6ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (5)

**Calls:**
- `get` (5)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` | Self: 0.0% (0us) | Total: 1.0% (15.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (10)

**Calls:**
- `isInLoop` (10)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:21` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `filter` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1513` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_buildScope` (1)

**Calls:**
- `get loc` (1)

### `isUnusedExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:506` | Self: 0.0% (0us) | Total: 0.2% (3.0ms) | Samples: 0

**Called by:**
- `getRhsNode` (2)

**Calls:**
- `get parent` (1)
- `get parent` (1)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2946` | Self: 0.0% (0us) | Total: 0.3% (4.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `_nodeViewRaw` (2)
- `nodeViewChain` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7532` | Self: 0.0% (0us) | Total: 0.3% (5.2ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (3)

**Calls:**
- `get source` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` | Self: 0.0% (0us) | Total: 1.1% (16.3ms) | Samples: 0

**Called by:**
- `parseModule` (11)

**Calls:**
- `async (anonymous)` (11)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` | Self: 0.0% (0us) | Total: 3.9% (56.9ms) | Samples: 0

**Called by:**
- `some` (38)

**Calls:**
- `get references` (31)
- `get references` (7)

### `isInside`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `getRhsNode` (1)

**Calls:**
- `get range` (1)

### `internal:validators`
`internal:validators:2` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:551` | Self: 0.0% (0us) | Total: 0.3% (5.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `isInside` (2)
- `isInside` (1)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` | Self: 0.0% (0us) | Total: 0.4% (6.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `bound require` (4)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2029` | Self: 0.0% (0us) | Total: 0.6% (8.7ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (6)

**Calls:**
- `_symName` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 37.6% | 550.1ms | `[native code]` |
| 30.9% | 451.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 26.0% | 379.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 5.1% | 74.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.0% | 1.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/index.js` |
| 0.0% | 1.3ms | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js` |
| 0.0% | 1.2ms | `/Users/ericsan/Development/OpenSource/Ez/js/api.js` |
