# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 1.39s | 909 | 1.0ms | 302 |

**Top 10:** `parse` 28.0%, `walkNodes` 3.8%, `_NodeView` 3.7%, `_ensureDeclSymIndex` 3.3%, `_nodeViewRaw` 3.0%, `_NodeView_LR` 2.0%, `_nodeViewRaw` 2.0%, `Set` 1.8%, `_buildScope` 1.3%, `get body` 1.3%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 28.0% | 390.1ms | 28.0% | 390.1ms | `parse` | `[native code]` |
| 3.8% | 53.1ms | 3.8% | 53.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7017` |
| 3.7% | 51.6ms | 3.7% | 51.6ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4042` |
| 3.3% | 46.0ms | 3.4% | 47.6ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2017` |
| 3.0% | 42.1ms | 10.1% | 141.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4120` |
| 2.0% | 29.1ms | 2.0% | 29.1ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4073` |
| 2.0% | 28.1ms | 2.0% | 28.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4115` |
| 1.8% | 25.6ms | 1.8% | 25.6ms | `Set` | `[native code]` |
| 1.3% | 19.3ms | 1.3% | 19.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2107` |
| 1.3% | 18.3ms | 1.6% | 23.3ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1725` |
| 1.2% | 17.2ms | 1.2% | 17.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2229` |
| 1.1% | 15.9ms | 1.2% | 17.2ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3166` |
| 1.1% | 15.9ms | 10.0% | 140.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1226` |
| 1.0% | 15.2ms | 1.0% | 15.2ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 1.0% | 14.6ms | 3.3% | 47.0ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` |
| 1.0% | 14.3ms | 1.2% | 17.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2868` |
| 0.9% | 13.8ms | 0.9% | 13.8ms | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:522` |
| 0.9% | 13.8ms | 0.9% | 13.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6743` |
| 0.9% | 13.3ms | 4.3% | 60.7ms | `anonymous` | `[native code]` |
| 0.8% | 12.4ms | 0.8% | 12.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4126` |
| 0.8% | 12.2ms | 0.8% | 12.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2223` |
| 0.8% | 11.5ms | 0.8% | 11.5ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3172` |
| 0.7% | 10.6ms | 0.7% | 10.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7188` |
| 0.7% | 10.5ms | 0.7% | 10.5ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` |
| 0.7% | 10.4ms | 0.7% | 10.4ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.7% | 10.3ms | 1.2% | 17.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 0.6% | 9.1ms | 0.6% | 9.1ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` |
| 0.6% | 9.1ms | 0.6% | 9.1ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.6% | 9.0ms | 0.6% | 9.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4125` |
| 0.6% | 9.0ms | 0.6% | 9.0ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.6% | 8.6ms | 0.6% | 8.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2846` |
| 0.5% | 8.0ms | 0.5% | 8.0ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1721` |
| 0.5% | 7.9ms | 0.5% | 7.9ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:589` |
| 0.5% | 7.8ms | 0.5% | 7.8ms | `get` | `[native code]` |
| 0.5% | 7.7ms | 23.2% | 324.4ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 0.5% | 7.6ms | 0.5% | 7.6ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` |
| 0.5% | 7.5ms | 0.5% | 7.5ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3146` |
| 0.5% | 7.3ms | 0.5% | 7.3ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.5% | 7.2ms | 0.5% | 7.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1276` |
| 0.5% | 7.1ms | 6.0% | 83.6ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 0.4% | 6.6ms | 0.4% | 6.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1332` |
| 0.4% | 6.1ms | 1.0% | 14.0ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2792` |
| 0.4% | 6.1ms | 0.5% | 7.8ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:829` |
| 0.4% | 6.0ms | 0.4% | 6.0ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.4% | 5.9ms | 0.4% | 5.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1206` |
| 0.4% | 5.9ms | 0.4% | 5.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.4% | 5.9ms | 0.4% | 5.9ms | `getUint32` | `[native code]` |
| 0.4% | 5.8ms | 0.4% | 5.8ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.4% | 5.6ms | 1.2% | 17.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2320` |
| 0.3% | 5.4ms | 0.4% | 6.7ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2168` |
| 0.3% | 5.0ms | 0.3% | 5.0ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2745` |
| 0.3% | 4.9ms | 0.6% | 9.5ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1748` |
| 0.3% | 4.8ms | 1.6% | 22.3ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2763` |
| 0.3% | 4.8ms | 0.3% | 4.8ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2593` |
| 0.3% | 4.7ms | 0.7% | 11.0ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3160` |
| 0.3% | 4.7ms | 5.4% | 75.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2213` |
| 0.3% | 4.7ms | 0.3% | 4.7ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:876` |
| 0.3% | 4.5ms | 0.4% | 5.8ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2840` |
| 0.3% | 4.5ms | 0.3% | 4.5ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2698` |
| 0.3% | 4.5ms | 0.3% | 4.5ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2586` |
| 0.3% | 4.5ms | 0.4% | 6.1ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 0.3% | 4.5ms | 0.3% | 4.5ms | `test` | `[native code]` |
| 0.3% | 4.5ms | 0.3% | 4.5ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4147` |
| 0.3% | 4.4ms | 0.3% | 4.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2738` |
| 0.3% | 4.4ms | 5.1% | 71.3ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2186` |
| 0.3% | 4.4ms | 4.4% | 62.2ms | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 0.3% | 4.3ms | 0.3% | 4.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2018` |
| 0.3% | 4.3ms | 0.3% | 4.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1322` |
| 0.3% | 4.3ms | 0.3% | 4.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2734` |
| 0.3% | 4.1ms | 0.3% | 4.1ms | `decode` | `[native code]` |
| 0.2% | 4.1ms | 0.3% | 5.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2432` |
| 0.2% | 4.1ms | 10.1% | 142.0ms | `some` | `[native code]` |
| 0.2% | 3.8ms | 0.2% | 3.8ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4359` |
| 0.2% | 3.4ms | 0.2% | 3.4ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1034` |
| 0.2% | 3.4ms | 0.8% | 11.9ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1724` |
| 0.2% | 3.3ms | 7.9% | 110.7ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2844` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.2% | 3.2ms | 1.5% | 21.5ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2052` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 3.1ms | 14.9% | 208.1ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:544` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6476` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3671` |
| 0.2% | 2.9ms | 0.2% | 2.9ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6474` |
| 0.2% | 2.9ms | 0.2% | 2.9ms | `set` | `[native code]` |
| 0.2% | 2.8ms | 4.9% | 69.0ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2066` |
| 0.2% | 2.7ms | 1.6% | 22.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4121` |
| 0.1% | 2.7ms | 2.0% | 28.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` |
| 0.1% | 2.7ms | 1.9% | 26.7ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2900` |
| 0.1% | 2.6ms | 0.1% | 2.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2215` |
| 0.1% | 2.6ms | 0.1% | 2.6ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 2.6ms | 0.1% | 2.6ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2969` |
| 0.1% | 2.5ms | 0.2% | 3.8ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2808` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `_mergeRuleOptions` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.8ms | 0.2% | 3.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2815` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `push` | `[native code]` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2015` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3645` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:630` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2020` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2428` |
| 0.1% | 1.7ms | 21.5% | 300.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2674` |
| 0.1% | 1.7ms | 0.3% | 4.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2071` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4149` |
| 0.1% | 1.7ms | 2.3% | 32.9ms | `_ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:924` |
| 0.1% | 1.7ms | 1.4% | 20.4ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2589` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `slice` | `[native code]` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:808` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.6ms | 12.0% | 167.4ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:845` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2109` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2436` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1548` |
| 0.1% | 1.6ms | 1.5% | 21.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `isRead` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3099` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6723` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `internalAll` | `[native code]` |
| 0.1% | 1.6ms | 0.2% | 3.3ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2184` |
| 0.1% | 1.6ms | 3.3% | 47.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2833` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `RegExp` | `[native code]` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `loadBinding` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1017` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2701` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:675` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `fill` | `[native code]` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_expandUnion` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4145` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7019` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `DataView` | `[native code]` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:637` |
| 0.1% | 1.5ms | 0.2% | 3.1ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.1% | 1.5ms | 1.9% | 26.6ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_ensureTagCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:647` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3140` |
| 0.1% | 1.5ms | 0.3% | 4.7ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2677` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `extraArrowData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:687` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2117` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:738` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `toFixed` | `[native code]` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `replace` | `[native code]` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2053` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `get eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:738` |
| 0.1% | 1.4ms | 0.4% | 6.7ms | `exec` | `[native code]` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7192` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2787` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `/^\s*globals?\b/` | `[native code]` |
| 0.0% | 1.3ms | 0.1% | 2.7ms | `readdirSync` | `[native code]` |
| 0.0% | 1.3ms | 0.9% | 12.9ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2727` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:176` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2675` |
| 0.0% | 1.3ms | 8.9% | 124.9ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2837` |
| 0.0% | 1.3ms | 1.0% | 15.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2222` |
| 0.0% | 1.3ms | 0.5% | 7.0ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2167` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:539` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1238` |
| 0.0% | 1.3ms | 0.9% | 13.7ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1037` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:894` |
| 0.0% | 1.3ms | 0.5% | 7.8ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2016` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `map` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3165` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:588` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6585` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `byteLength` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2190` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:887` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 100.0% | 2.69s | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 69.6% | 970.7ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:304` |
| 69.1% | 963.2ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7540` |
| 62.5% | 870.8ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7256` |
| 62.5% | 870.8ms | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4672` |
| 60.1% | 838.2ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` |
| 28.5% | 397.1ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:300` |
| 28.0% | 390.1ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` |
| 28.0% | 390.1ms | 28.0% | 390.1ms | `parse` | `[native code]` |
| 23.2% | 324.4ms | 0.5% | 7.7ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 21.5% | 300.2ms | 0.1% | 1.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 14.9% | 208.1ms | 0.2% | 3.1ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 13.4% | 187.0ms | 0.0% | 0us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4152` |
| 13.3% | 185.5ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` |
| 12.0% | 167.5ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:953` |
| 12.0% | 167.4ms | 0.1% | 1.6ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:845` |
| 10.1% | 142.0ms | 0.2% | 4.1ms | `some` | `[native code]` |
| 10.1% | 141.0ms | 3.0% | 42.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4120` |
| 10.0% | 140.5ms | 1.1% | 15.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1226` |
| 8.9% | 124.9ms | 0.0% | 1.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2837` |
| 7.9% | 110.7ms | 0.2% | 3.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2844` |
| 6.9% | 97.1ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` |
| 6.7% | 94.1ms | 0.0% | 0us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3101` |
| 6.4% | 89.7ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2087` |
| 6.0% | 83.6ms | 0.5% | 7.1ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 5.7% | 79.8ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:752` |
| 5.6% | 78.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` |
| 5.4% | 75.9ms | 0.3% | 4.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2213` |
| 5.1% | 71.3ms | 0.3% | 4.4ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2186` |
| 4.9% | 69.0ms | 0.2% | 2.8ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2066` |
| 4.4% | 62.2ms | 0.3% | 4.4ms | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 4.3% | 60.7ms | 0.9% | 13.3ms | `anonymous` | `[native code]` |
| 3.8% | 53.7ms | 0.0% | 0us | `bound require` | `[native code]` |
| 3.8% | 53.1ms | 3.8% | 53.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7017` |
| 3.7% | 51.6ms | 3.7% | 51.6ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4042` |
| 3.6% | 50.9ms | 0.0% | 0us | `require` | `[native code]` |
| 3.4% | 48.1ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` |
| 3.4% | 47.6ms | 3.3% | 46.0ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2017` |
| 3.3% | 47.3ms | 0.1% | 1.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2833` |
| 3.3% | 47.0ms | 1.0% | 14.6ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` |
| 2.3% | 32.9ms | 0.1% | 1.7ms | `_ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:924` |
| 2.3% | 32.9ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:957` |
| 2.2% | 31.1ms | 0.0% | 0us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1898` |
| 2.2% | 31.1ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` |
| 2.0% | 29.1ms | 2.0% | 29.1ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4073` |
| 2.0% | 28.3ms | 0.1% | 2.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` |
| 2.0% | 28.1ms | 2.0% | 28.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4115` |
| 1.9% | 26.7ms | 0.1% | 2.7ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2900` |
| 1.9% | 26.6ms | 0.1% | 1.5ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 1.8% | 25.6ms | 1.8% | 25.6ms | `Set` | `[native code]` |
| 1.6% | 23.3ms | 0.0% | 0us | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2782` |
| 1.6% | 23.3ms | 1.3% | 18.3ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1725` |
| 1.6% | 22.6ms | 0.2% | 2.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4121` |
| 1.6% | 22.3ms | 0.3% | 4.8ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2763` |
| 1.5% | 21.7ms | 0.1% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 1.5% | 21.5ms | 0.2% | 3.2ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` |
| 1.4% | 20.4ms | 0.1% | 1.7ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2589` |
| 1.4% | 19.9ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2673` |
| 1.3% | 19.3ms | 1.3% | 19.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2107` |
| 1.3% | 19.1ms | 0.0% | 0us | `parseModule` | `[native code]` |
| 1.3% | 19.1ms | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 1.2% | 17.8ms | 0.7% | 10.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 1.2% | 17.5ms | 0.4% | 5.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2320` |
| 1.2% | 17.5ms | 1.0% | 14.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2868` |
| 1.2% | 17.2ms | 1.2% | 17.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2229` |
| 1.2% | 17.2ms | 1.1% | 15.9ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3166` |
| 1.1% | 16.0ms | 0.0% | 0us | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` |
| 1.0% | 15.2ms | 1.0% | 15.2ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 1.0% | 15.2ms | 0.0% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2222` |
| 1.0% | 15.1ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` |
| 1.0% | 15.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` |
| 1.0% | 15.1ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:72` |
| 1.0% | 14.0ms | 0.4% | 6.1ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2792` |
| 0.9% | 13.8ms | 0.9% | 13.8ms | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:522` |
| 0.9% | 13.8ms | 0.9% | 13.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6743` |
| 0.9% | 13.7ms | 0.0% | 1.3ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1037` |
| 0.9% | 12.9ms | 0.0% | 1.3ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 0.8% | 12.4ms | 0.8% | 12.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4126` |
| 0.8% | 12.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` |
| 0.8% | 12.2ms | 0.8% | 12.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2223` |
| 0.8% | 11.9ms | 0.2% | 3.4ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1724` |
| 0.8% | 11.5ms | 0.8% | 11.5ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3172` |
| 0.8% | 11.5ms | 0.0% | 0us | `forEach` | `[native code]` |
| 0.7% | 11.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` |
| 0.7% | 11.0ms | 0.3% | 4.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3160` |
| 0.7% | 10.8ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1728` |
| 0.7% | 10.6ms | 0.7% | 10.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7188` |
| 0.7% | 10.5ms | 0.7% | 10.5ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` |
| 0.7% | 10.5ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` |
| 0.7% | 10.4ms | 0.7% | 10.4ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.7% | 9.8ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2225` |
| 0.6% | 9.5ms | 0.3% | 4.9ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1748` |
| 0.6% | 9.1ms | 0.6% | 9.1ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` |
| 0.6% | 9.1ms | 0.6% | 9.1ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.6% | 9.0ms | 0.6% | 9.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4125` |
| 0.6% | 9.0ms | 0.6% | 9.0ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.6% | 8.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` |
| 0.6% | 8.6ms | 0.6% | 8.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2846` |
| 0.6% | 8.4ms | 0.0% | 0us | `get identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:756` |
| 0.5% | 8.0ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` |
| 0.5% | 8.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:458` |
| 0.5% | 8.0ms | 0.5% | 8.0ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1721` |
| 0.5% | 7.9ms | 0.5% | 7.9ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:589` |
| 0.5% | 7.8ms | 0.0% | 0us | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:879` |
| 0.5% | 7.8ms | 0.5% | 7.8ms | `get` | `[native code]` |
| 0.5% | 7.8ms | 0.0% | 1.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2016` |
| 0.5% | 7.8ms | 0.4% | 6.1ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:829` |
| 0.5% | 7.8ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2029` |
| 0.5% | 7.8ms | 0.0% | 0us | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:813` |
| 0.5% | 7.6ms | 0.5% | 7.6ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` |
| 0.5% | 7.5ms | 0.5% | 7.5ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3146` |
| 0.5% | 7.3ms | 0.5% | 7.3ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.5% | 7.2ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7016` |
| 0.5% | 7.2ms | 0.5% | 7.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1276` |
| 0.5% | 7.1ms | 0.0% | 0us | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2964` |
| 0.5% | 7.0ms | 0.0% | 1.3ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2167` |
| 0.5% | 6.9ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` |
| 0.4% | 6.7ms | 0.3% | 5.4ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2168` |
| 0.4% | 6.7ms | 0.1% | 1.4ms | `exec` | `[native code]` |
| 0.4% | 6.6ms | 0.4% | 6.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1332` |
| 0.4% | 6.5ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:587` |
| 0.4% | 6.1ms | 0.3% | 4.5ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 0.4% | 6.0ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4180` |
| 0.4% | 6.0ms | 0.4% | 6.0ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.4% | 5.9ms | 0.4% | 5.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1206` |
| 0.4% | 5.9ms | 0.4% | 5.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.4% | 5.9ms | 0.4% | 5.9ms | `getUint32` | `[native code]` |
| 0.4% | 5.8ms | 0.3% | 4.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2840` |
| 0.4% | 5.8ms | 0.4% | 5.8ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.4% | 5.6ms | 0.0% | 0us | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2895` |
| 0.4% | 5.6ms | 0.0% | 0us | `scope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:745` |
| 0.3% | 5.5ms | 0.2% | 4.1ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2432` |
| 0.3% | 5.4ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:452` |
| 0.3% | 5.0ms | 0.3% | 5.0ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2745` |
| 0.3% | 4.8ms | 0.3% | 4.8ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2593` |
| 0.3% | 4.7ms | 0.3% | 4.7ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:876` |
| 0.3% | 4.7ms | 0.1% | 1.5ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2677` |
| 0.3% | 4.6ms | 0.0% | 0us | `identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:756` |
| 0.3% | 4.5ms | 0.1% | 1.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2071` |
| 0.3% | 4.5ms | 0.3% | 4.5ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2698` |
| 0.3% | 4.5ms | 0.3% | 4.5ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2586` |
| 0.3% | 4.5ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:972` |
| 0.3% | 4.5ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:967` |
| 0.3% | 4.5ms | 0.3% | 4.5ms | `test` | `[native code]` |
| 0.3% | 4.5ms | 0.3% | 4.5ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4147` |
| 0.3% | 4.4ms | 0.3% | 4.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2738` |
| 0.3% | 4.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` |
| 0.3% | 4.3ms | 0.3% | 4.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2018` |
| 0.3% | 4.3ms | 0.3% | 4.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1322` |
| 0.3% | 4.3ms | 0.3% | 4.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2734` |
| 0.3% | 4.2ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:586` |
| 0.3% | 4.1ms | 0.0% | 0us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:522` |
| 0.3% | 4.1ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7532` |
| 0.3% | 4.1ms | 0.3% | 4.1ms | `decode` | `[native code]` |
| 0.2% | 3.8ms | 0.2% | 3.8ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4359` |
| 0.2% | 3.8ms | 0.1% | 2.5ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2808` |
| 0.2% | 3.4ms | 0.2% | 3.4ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1034` |
| 0.2% | 3.3ms | 0.0% | 0us | `get defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 0.2% | 3.3ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7539` |
| 0.2% | 3.3ms | 0.1% | 1.6ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2184` |
| 0.2% | 3.3ms | 0.0% | 0us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1265` |
| 0.2% | 3.3ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3168` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.2% | 3.2ms | 0.1% | 1.8ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` |
| 0.2% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.2% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2052` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 3.1ms | 0.1% | 1.5ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:544` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6476` |
| 0.2% | 3.0ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1531` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3671` |
| 0.2% | 3.0ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3170` |
| 0.2% | 2.9ms | 0.2% | 2.9ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6474` |
| 0.2% | 2.9ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2081` |
| 0.2% | 2.9ms | 0.2% | 2.9ms | `set` | `[native code]` |
| 0.2% | 2.8ms | 0.0% | 0us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` |
| 0.1% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` |
| 0.1% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` |
| 0.1% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.1% | 2.7ms | 0.0% | 1.3ms | `readdirSync` | `[native code]` |
| 0.1% | 2.7ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2322` |
| 0.1% | 2.7ms | 0.0% | 0us | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3939` |
| 0.1% | 2.7ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4177` |
| 0.1% | 2.6ms | 0.1% | 2.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2215` |
| 0.1% | 2.6ms | 0.1% | 2.6ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` |
| 0.1% | 2.6ms | 0.1% | 2.6ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2969` |
| 0.1% | 2.6ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:747` |
| 0.1% | 1.8ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:855` |
| 0.1% | 1.8ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4317` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `_mergeRuleOptions` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2815` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `push` | `[native code]` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2015` |
| 0.1% | 1.7ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:551` |
| 0.1% | 1.7ms | 0.0% | 0us | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:494` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3645` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:630` |
| 0.1% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:22` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2020` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 1.7ms | 0.0% | 0us | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2964` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2428` |
| 0.1% | 1.7ms | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:519` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2674` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4149` |
| 0.1% | 1.7ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1764` |
| 0.1% | 1.7ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2606` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `slice` | `[native code]` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:808` |
| 0.1% | 1.7ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:776` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2109` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2436` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1548` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `isRead` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3099` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6723` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `internalAll` | `[native code]` |
| 0.1% | 1.6ms | 0.0% | 0us | `(anonymous)` | `[native code]` |
| 0.1% | 1.6ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1540` |
| 0.1% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` |
| 0.1% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` |
| 0.1% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:48` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `RegExp` | `[native code]` |
| 0.1% | 1.6ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:288` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `loadBinding` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` |
| 0.1% | 1.6ms | 0.0% | 0us | `getTagNames` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:186` |
| 0.1% | 1.6ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:561` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1017` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2701` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:675` |
| 0.1% | 1.5ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1747` |
| 0.1% | 1.5ms | 0.0% | 0us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4358` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `fill` | `[native code]` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_expandUnion` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4145` |
| 0.1% | 1.5ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4367` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7019` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.1% | 1.5ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:279` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `DataView` | `[native code]` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:637` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_ensureTagCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.5ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6017` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:647` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3140` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `extraArrowData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:687` |
| 0.1% | 1.5ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1750` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.1% | 1.5ms | 0.0% | 0us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1382` |
| 0.1% | 1.5ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:881` |
| 0.1% | 1.5ms | 0.0% | 0us | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:758` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2117` |
| 0.1% | 1.4ms | 0.0% | 0us | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:738` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `replace` | `[native code]` |
| 0.1% | 1.4ms | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3840` |
| 0.1% | 1.4ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3905` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.4ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` |
| 0.1% | 1.4ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `toFixed` | `[native code]` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2053` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `get eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:738` |
| 0.1% | 1.4ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.1% | 1.4ms | 0.0% | 0us | `node:events` | `node:events:9` |
| 0.1% | 1.4ms | 0.0% | 0us | `internal:validators` | `internal:validators:2` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7192` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2787` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `/^\s*globals?\b/` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2227` |
| 0.0% | 1.3ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:144` |
| 0.0% | 1.3ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:47` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2727` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:176` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2675` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:539` |
| 0.0% | 1.3ms | 0.0% | 0us | `internal:promisify` | `internal:promisify:53` |
| 0.0% | 1.3ms | 0.0% | 0us | `node:fs` | `node:fs:303` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1238` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:894` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `map` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3165` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:588` |
| 0.0% | 1.2ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7251` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6585` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `byteLength` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:37` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2190` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:887` |

## Function Details

### `parse`
`[native code]` | Self: 28.0% (390.1ms) | Total: 28.0% (390.1ms) | Samples: 257

**Called by:**
- `parseSource` (257)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7017` | Self: 3.8% (53.1ms) | Total: 3.8% (53.1ms) | Samples: 35

**Called by:**
- `runPlugins` (35)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4042` | Self: 3.7% (51.6ms) | Total: 3.7% (51.6ms) | Samples: 33

**Called by:**
- `_nodeViewRaw` (33)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2017` | Self: 3.3% (46.0ms) | Total: 3.4% (47.6ms) | Samples: 30

**Called by:**
- `_buildScopeVarsAndSet` (31)

**Calls:**
- `set` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4120` | Self: 3.0% (42.1ms) | Total: 10.1% (141.0ms) | Samples: 28

**Called by:**
- `nodeView` (87)
- `get parent` (2)
- `get body` (2)
- `nodeViewChain` (1)

**Calls:**
- `_NodeView` (33)
- `_NodeView_LR` (19)
- `_NodeView_LR` (6)
- `_NodeView` (6)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4073` | Self: 2.0% (29.1ms) | Total: 2.0% (29.1ms) | Samples: 19

**Called by:**
- `_nodeViewRaw` (19)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4115` | Self: 2.0% (28.1ms) | Total: 2.0% (28.1ms) | Samples: 18

**Called by:**
- `nodeView` (11)
- `get parent` (3)
- `_buildReference` (3)
- `get body` (1)

### `Set`
`[native code]` | Self: 1.8% (25.6ms) | Total: 1.8% (25.6ms) | Samples: 17

**Called by:**
- `_computeDeclaredVariables` (17)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2107` | Self: 1.3% (19.3ms) | Total: 1.3% (19.3ms) | Samples: 12

**Called by:**
- `_buildReference` (11)
- `_computeVarScope` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1725` | Self: 1.3% (18.3ms) | Total: 1.6% (23.3ms) | Samples: 12

**Called by:**
- `_computeIsStrict` (15)

**Calls:**
- `nodeRhs` (2)
- `getUint32` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2229` | Self: 1.2% (17.2ms) | Total: 1.2% (17.2ms) | Samples: 11

**Called by:**
- `_ensureVarsSet` (11)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3166` | Self: 1.1% (15.9ms) | Total: 1.2% (17.2ms) | Samples: 10

**Called by:**
- `getDeclaredVariables` (11)

**Calls:**
- `get` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1226` | Self: 1.1% (15.9ms) | Total: 10.0% (140.5ms) | Samples: 10

**Called by:**
- `_buildReference` (74)
- `_findDefNode` (9)
- `_computeVarDefs` (4)
- `_computeIsStrict` (3)
- `isForInOfRef` (1)

**Calls:**
- `nodeView` (65)
- `nodeView` (9)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (2)
- `nodeView` (1)
- `_nodeViewRaw` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 1.0% (15.2ms) | Total: 1.0% (15.2ms) | Samples: 10

**Called by:**
- `get parent` (9)
- `_buildReference` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` | Self: 1.0% (14.6ms) | Total: 3.3% (47.0ms) | Samples: 10

**Called by:**
- `collectUnusedVariables` (16)
- `(anonymous)` (15)
- `_computeDeclaredVariables` (1)

**Calls:**
- `_computeVariableSynthRefs` (18)
- `_computeVariableSynthRefs` (4)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2868` | Self: 1.0% (14.3ms) | Total: 1.2% (17.5ms) | Samples: 9

**Called by:**
- `get references` (11)

**Calls:**
- `get parent` (1)
- `get parent` (1)

### `source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:522` | Self: 0.9% (13.8ms) | Total: 0.9% (13.8ms) | Samples: 9

**Called by:**
- `_computeNodeType` (8)
- `_identAt` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6743` | Self: 0.9% (13.8ms) | Total: 0.9% (13.8ms) | Samples: 9

**Called by:**
- `runPlugins` (9)

### `anonymous`
`[native code]` | Self: 0.9% (13.3ms) | Total: 4.3% (60.7ms) | Samples: 9

**Called by:**
- `require` (33)
- `bound require` (2)
- `node:events` (1)
- `internal:validators` (1)
- `internal:promisify` (1)
- `node:fs` (1)
- `node:fs` (1)

**Calls:**
- `(anonymous)` (7)
- `(anonymous)` (5)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:fs` (1)
- `node:fs` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:validators` (1)
- `internal:promisify` (1)
- `node:events` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4126` | Self: 0.8% (12.4ms) | Total: 0.8% (12.4ms) | Samples: 8

**Called by:**
- `nodeView` (8)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2223` | Self: 0.8% (12.2ms) | Total: 0.8% (12.2ms) | Samples: 8

**Called by:**
- `_ensureVarsSet` (8)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3172` | Self: 0.8% (11.5ms) | Total: 0.8% (11.5ms) | Samples: 7

**Called by:**
- `getDeclaredVariables` (7)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7188` | Self: 0.7% (10.6ms) | Total: 0.7% (10.6ms) | Samples: 7

**Called by:**
- `runPlugins` (7)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` | Self: 0.7% (10.5ms) | Total: 0.7% (10.5ms) | Samples: 7

**Called by:**
- `getRhsNode` (7)

### `/\/\*([\s\S]*?)\*\//g`
`[native code]` | Self: 0.7% (10.4ms) | Total: 0.7% (10.4ms) | Samples: 6

**Called by:**
- `_buildScopeVarsAndSet` (3)
- `exec` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` | Self: 0.7% (10.3ms) | Total: 1.2% (17.8ms) | Samples: 7

**Called by:**
- `some` (12)

**Calls:**
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` | Self: 0.6% (9.1ms) | Total: 0.6% (9.1ms) | Samples: 6

**Called by:**
- `getDeclaredVariables` (6)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.6% (9.1ms) | Total: 0.6% (9.1ms) | Samples: 6

**Called by:**
- `_nodeViewRaw` (6)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4125` | Self: 0.6% (9.0ms) | Total: 0.6% (9.0ms) | Samples: 6

**Called by:**
- `nodeView` (3)
- `nodeViewChain` (3)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.6% (9.0ms) | Total: 0.6% (9.0ms) | Samples: 6

**Called by:**
- `_nodeViewRaw` (6)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2846` | Self: 0.6% (8.6ms) | Total: 0.6% (8.6ms) | Samples: 6

**Called by:**
- `get references` (6)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1721` | Self: 0.5% (8.0ms) | Total: 0.5% (8.0ms) | Samples: 5

**Called by:**
- `_computeIsStrict` (5)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:589` | Self: 0.5% (7.9ms) | Total: 0.5% (7.9ms) | Samples: 5

**Called by:**
- `_precomputeScopes` (5)

### `get`
`[native code]` | Self: 0.5% (7.8ms) | Total: 0.5% (7.8ms) | Samples: 5

**Called by:**
- `_ensureDeclSymIndex` (4)
- `_computeDeclaredVariables` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` | Self: 0.5% (7.7ms) | Total: 23.2% (324.4ms) | Samples: 5

**Called by:**
- `collectUnusedVariables` (167)
- `(anonymous)` (33)
- `isUsedVariable` (9)
- `_buildScopeVarsAndSet` (1)
- `_computeDeclaredVariables` (1)

**Calls:**
- `_buildReference` (82)
- `_buildReference` (71)
- `_buildReference` (31)
- `_buildReference` (11)
- `_buildReference` (6)
- `_buildReference` (4)
- `_buildReference` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` | Self: 0.5% (7.6ms) | Total: 0.5% (7.6ms) | Samples: 5

**Called by:**
- `(anonymous)` (5)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3146` | Self: 0.5% (7.5ms) | Total: 0.5% (7.5ms) | Samples: 5

**Called by:**
- `getDeclaredVariables` (5)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.5% (7.3ms) | Total: 0.5% (7.3ms) | Samples: 5

**Called by:**
- `commentsInRange` (3)
- `commentsInRange` (2)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1276` | Self: 0.5% (7.2ms) | Total: 0.5% (7.2ms) | Samples: 5

**Called by:**
- `_buildReference` (4)
- `(anonymous)` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` | Self: 0.5% (7.1ms) | Total: 6.0% (83.6ms) | Samples: 5

**Called by:**
- `collectUnusedVariables` (46)
- `Program:exit` (10)

**Calls:**
- `some` (21)
- `isUsedVariable` (18)
- `isUsedVariable` (11)
- `isUsedVariable` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1332` | Self: 0.4% (6.6ms) | Total: 0.4% (6.6ms) | Samples: 4

**Called by:**
- `isReadForItself` (1)
- `getRhsNode` (1)
- `_buildReference` (1)
- `_findDefNode` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2792` | Self: 0.4% (6.1ms) | Total: 1.0% (14.0ms) | Samples: 4

**Called by:**
- `defs` (9)

**Calls:**
- `get parent` (4)
- `get parent` (1)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:829` | Self: 0.4% (6.1ms) | Total: 0.5% (7.8ms) | Samples: 4

**Called by:**
- `_symName` (5)

**Calls:**
- `slice` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` | Self: 0.4% (6.0ms) | Total: 0.4% (6.0ms) | Samples: 4

**Called by:**
- `collectUnusedVariables` (4)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1206` | Self: 0.4% (5.9ms) | Total: 0.4% (5.9ms) | Samples: 4

**Called by:**
- `(anonymous)` (1)
- `_buildReference` (1)
- `isForInOfRef` (1)
- `_buildReference` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.4% (5.9ms) | Total: 0.4% (5.9ms) | Samples: 4

**Called by:**
- `(anonymous)` (2)
- `_computeIsStrict` (1)
- `_computeVarDefs` (1)

### `getUint32`
`[native code]` | Self: 0.4% (5.9ms) | Total: 0.4% (5.9ms) | Samples: 4

**Called by:**
- `_isChainNode` (2)
- `get body` (1)
- `get body` (1)

### `nodeLhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.4% (5.8ms) | Total: 0.4% (5.8ms) | Samples: 4

**Called by:**
- `get body` (4)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2320` | Self: 0.4% (5.6ms) | Total: 1.2% (17.5ms) | Samples: 4

**Called by:**
- `_ensureVarsSet` (11)

**Calls:**
- `exec` (4)
- `/\/\*([\s\S]*?)\*\//g` (3)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2168` | Self: 0.3% (5.4ms) | Total: 0.4% (6.7ms) | Samples: 3

**Called by:**
- `_buildScope` (4)

**Calls:**
- `get parent` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2745` | Self: 0.3% (5.0ms) | Total: 0.3% (5.0ms) | Samples: 3

**Called by:**
- `_buildScopeVarsAndSet` (3)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1748` | Self: 0.3% (4.9ms) | Total: 0.6% (9.5ms) | Samples: 3

**Called by:**
- `_computeIsStrict` (6)

**Calls:**
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2763` | Self: 0.3% (4.8ms) | Total: 1.6% (22.3ms) | Samples: 3

**Called by:**
- `defs` (13)
- `get defs` (1)

**Calls:**
- `nodeView` (11)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2593` | Self: 0.3% (4.8ms) | Total: 0.3% (4.8ms) | Samples: 3

**Called by:**
- `_ensureChildren` (3)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3160` | Self: 0.3% (4.7ms) | Total: 0.7% (11.0ms) | Samples: 3

**Called by:**
- `getDeclaredVariables` (7)

**Calls:**
- `_buildVariable` (2)
- `_buildVariable` (1)
- `_buildVariable` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2213` | Self: 0.3% (4.7ms) | Total: 5.4% (75.9ms) | Samples: 3

**Called by:**
- `_ensureVarsSet` (49)

**Calls:**
- `_ensureDeclSymIndex` (31)
- `_ensureDeclSymIndex` (5)
- `_ensureDeclSymIndex` (5)
- `_ensureDeclSymIndex` (3)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:876` | Self: 0.3% (4.7ms) | Total: 0.3% (4.7ms) | Samples: 3

**Called by:**
- `get body` (2)
- `get body` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2840` | Self: 0.3% (4.5ms) | Total: 0.4% (5.8ms) | Samples: 3

**Called by:**
- `get references` (4)

**Calls:**
- `_buildVariable` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2698` | Self: 0.3% (4.5ms) | Total: 0.3% (4.5ms) | Samples: 3

**Called by:**
- `_buildScopeVarsAndSet` (2)
- `_computeDeclaredVariables` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2586` | Self: 0.3% (4.5ms) | Total: 0.3% (4.5ms) | Samples: 3

**Called by:**
- `_ensureChildren` (3)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` | Self: 0.3% (4.5ms) | Total: 0.4% (6.1ms) | Samples: 3

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `get parent` (1)

### `test`
`[native code]` | Self: 0.3% (4.5ms) | Total: 0.3% (4.5ms) | Samples: 3

**Called by:**
- `_precomputeScopes` (2)
- `_buildScopeVarsAndSet` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4147` | Self: 0.3% (4.5ms) | Total: 0.3% (4.5ms) | Samples: 3

**Called by:**
- `_buildScope` (2)
- `get parent` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2738` | Self: 0.3% (4.4ms) | Total: 0.3% (4.4ms) | Samples: 3

**Called by:**
- `_buildReference` (1)
- `_buildScopeVarsAndSet` (1)
- `_computeDeclaredVariables` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2186` | Self: 0.3% (4.4ms) | Total: 5.1% (71.3ms) | Samples: 3

**Called by:**
- `_buildScope` (46)

**Calls:**
- `get body` (15)
- `get body` (8)
- `get body` (7)
- `get body` (6)
- `get body` (5)
- `get body` (1)
- `get body` (1)

### `defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` | Self: 0.3% (4.4ms) | Total: 4.4% (62.2ms) | Samples: 3

**Called by:**
- `collectUnusedVariables` (29)
- `get identifiers` (4)
- `identifiers` (3)
- `isAfterLastUsedArg` (2)
- `_ensureVarsSet` (1)

**Calls:**
- `_computeVarDefs` (13)
- `_computeVarDefs` (13)
- `_computeVarDefs` (9)
- `_computeVarDefs` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2018` | Self: 0.3% (4.3ms) | Total: 0.3% (4.3ms) | Samples: 3

**Called by:**
- `_buildScopeVarsAndSet` (3)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1322` | Self: 0.3% (4.3ms) | Total: 0.3% (4.3ms) | Samples: 3

**Called by:**
- `_buildReference` (2)
- `(anonymous)` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2734` | Self: 0.3% (4.3ms) | Total: 0.3% (4.3ms) | Samples: 3

**Called by:**
- `_computeDeclaredVariables` (2)
- `_buildScopeVarsAndSet` (1)

### `decode`
`[native code]` | Self: 0.3% (4.1ms) | Total: 0.3% (4.1ms) | Samples: 3

**Called by:**
- `get source` (3)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2432` | Self: 0.2% (4.1ms) | Total: 0.3% (5.5ms) | Samples: 3

**Called by:**
- `_ensureVarsSet` (4)

**Calls:**
- `set` (1)

### `some`
`[native code]` | Self: 0.2% (4.1ms) | Total: 10.1% (142.0ms) | Samples: 3

**Called by:**
- `isAfterLastUsedArg` (51)
- `collectUnusedVariables` (21)
- `collectUnusedVariables` (13)
- `isUsedVariable` (7)

**Calls:**
- `(anonymous)` (50)
- `(anonymous)` (14)
- `(anonymous)` (12)
- `(anonymous)` (8)
- `(anonymous)` (3)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4359` | Self: 0.2% (3.8ms) | Total: 0.2% (3.8ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1034` | Self: 0.2% (3.4ms) | Total: 0.2% (3.4ms) | Samples: 2

**Called by:**
- `_nodeViewRaw` (2)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1724` | Self: 0.2% (3.4ms) | Total: 0.8% (11.9ms) | Samples: 2

**Called by:**
- `_computeIsStrict` (8)

**Calls:**
- `nodeLhs` (4)
- `nodeLhs` (1)
- `getUint32` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2844` | Self: 0.2% (3.3ms) | Total: 7.9% (110.7ms) | Samples: 2

**Called by:**
- `get references` (71)

**Calls:**
- `_buildScope` (29)
- `_buildScope` (26)
- `_buildScope` (11)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` | Self: 0.2% (3.2ms) | Total: 0.2% (3.2ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (2)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` | Self: 0.2% (3.2ms) | Total: 1.5% (21.5ms) | Samples: 2

**Called by:**
- `_computeVarDefs` (13)

**Calls:**
- `get parent` (9)
- `get parent` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2052` | Self: 0.2% (3.2ms) | Total: 0.2% (3.2ms) | Samples: 2

**Called by:**
- `_buildScope` (2)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.2% (3.2ms) | Total: 0.2% (3.2ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` | Self: 0.2% (3.1ms) | Total: 14.9% (208.1ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (73)
- `Program:exit` (61)

**Calls:**
- `get` (108)
- `get` (21)
- `get` (3)

### `nodeRhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:544` | Self: 0.2% (3.0ms) | Total: 0.2% (3.0ms) | Samples: 2

**Called by:**
- `get body` (2)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` | Self: 0.2% (3.0ms) | Total: 0.2% (3.0ms) | Samples: 2

**Called by:**
- `isUsedVariable` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` | Self: 0.2% (3.0ms) | Total: 0.2% (3.0ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (2)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6476` | Self: 0.2% (3.0ms) | Total: 0.2% (3.0ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3671` | Self: 0.2% (3.0ms) | Total: 0.2% (3.0ms) | Samples: 2

**Called by:**
- `get value` (2)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6474` | Self: 0.2% (2.9ms) | Total: 0.2% (2.9ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `set`
`[native code]` | Self: 0.2% (2.9ms) | Total: 0.2% (2.9ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (1)
- `_ensureDeclSymIndex` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2066` | Self: 0.2% (2.8ms) | Total: 4.9% (69.0ms) | Samples: 2

**Called by:**
- `_buildReference` (29)
- `_buildScope` (16)

**Calls:**
- `_buildScope` (20)
- `_buildScope` (16)
- `_buildScope` (2)
- `_buildScope` (2)
- `_buildScope` (2)
- `_buildScope` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4121` | Self: 0.2% (2.7ms) | Total: 1.6% (22.6ms) | Samples: 2

**Called by:**
- `nodeView` (13)
- `get parent` (1)
- `_buildReference` (1)

**Calls:**
- `_computeNodeType` (9)
- `_computeNodeType` (2)
- `_computeNodeType` (2)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` | Self: 0.1% (2.7ms) | Total: 2.0% (28.3ms) | Samples: 2

**Called by:**
- `getDeclaredVariables` (19)

**Calls:**
- `Set` (17)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2900` | Self: 0.1% (2.7ms) | Total: 1.9% (26.7ms) | Samples: 2

**Called by:**
- `get references` (18)

**Calls:**
- `nodeView` (16)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2215` | Self: 0.1% (2.6ms) | Total: 0.1% (2.6ms) | Samples: 2

**Called by:**
- `_ensureVarsSet` (2)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (2.6ms) | Total: 0.1% (2.6ms) | Samples: 2

**Called by:**
- `_nodeViewRaw` (2)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2969` | Self: 0.1% (2.6ms) | Total: 0.1% (2.6ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `_computeVarScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2808` | Self: 0.1% (2.5ms) | Total: 0.2% (3.8ms) | Samples: 2

**Called by:**
- `scope` (3)

**Calls:**
- `_buildScope` (1)

### `_mergeRuleOptions`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (1.8ms) | Total: 0.1% (1.8ms) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` | Self: 0.1% (1.8ms) | Total: 0.2% (3.2ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (2)

**Calls:**
- `get eslintUsed` (1)

### `_computeVarScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2815` | Self: 0.1% (1.8ms) | Total: 0.1% (1.8ms) | Samples: 1

**Called by:**
- `scope` (1)

### `push`
`[native code]` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2015` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3645` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `isInside` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:630` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `commentsInRange` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2020` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `get init` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2428` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` | Self: 0.1% (1.7ms) | Total: 21.5% (300.2ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (197)

**Calls:**
- `get references` (167)
- `get references` (16)
- `some` (13)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2674` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `getScope` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2071` | Self: 0.1% (1.7ms) | Total: 0.3% (4.5ms) | Samples: 1

**Called by:**
- `_buildScope` (2)
- `_buildReference` (1)

**Calls:**
- `nodeView` (2)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4149` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `_ensureChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:924` | Self: 0.1% (1.7ms) | Total: 2.3% (32.9ms) | Samples: 1

**Called by:**
- `get` (21)

**Calls:**
- `_buildScopeChildren` (13)
- `_buildScopeChildren` (3)
- `_buildScopeChildren` (3)
- `_buildScopeChildren` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2589` | Self: 0.1% (1.7ms) | Total: 1.4% (20.4ms) | Samples: 1

**Called by:**
- `_ensureChildren` (13)

**Calls:**
- `_buildScope` (11)
- `_buildScope` (1)

### `slice`
`[native code]` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `_buildSymNameCache` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:808` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `isUsedVariable` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:845` | Self: 0.1% (1.6ms) | Total: 12.0% (167.4ms) | Samples: 1

**Called by:**
- `get` (107)
- `_ensureVarsSet` (1)

**Calls:**
- `_buildScopeVarsAndSet` (49)
- `_buildScopeVarsAndSet` (11)
- `_buildScopeVarsAndSet` (11)
- `_buildScopeVarsAndSet` (10)
- `_buildScopeVarsAndSet` (8)
- `_buildScopeVarsAndSet` (6)
- `_buildScopeVarsAndSet` (4)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2109` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2436` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1548` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` | Self: 0.1% (1.6ms) | Total: 1.5% (21.7ms) | Samples: 1

**Called by:**
- `some` (14)

**Calls:**
- `getRhsNode` (7)
- `getRhsNode` (4)
- `getRhsNode` (1)
- `getRhsNode` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `get references` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `getScope` (1)

### `isRead`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3099` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6723` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `internalAll`
`[native code]` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2184` | Self: 0.1% (1.6ms) | Total: 0.2% (3.3ms) | Samples: 1

**Called by:**
- `_buildScope` (2)

**Calls:**
- `get body` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2833` | Self: 0.1% (1.6ms) | Total: 3.3% (47.3ms) | Samples: 1

**Called by:**
- `get references` (31)

**Calls:**
- `nodeView` (24)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (1)
- `nodeView` (1)
- `nodeView` (1)

### `RegExp`
`[native code]` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `loadBinding`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `getTagNames` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1017` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2701` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `extraFnData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:675` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `get body` (1)

### `fill`
`[native code]` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `CfgGraph` (1)

### `_expandUnion`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4145` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7019` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `DataView`
`[native code]` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:637` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `commentsInRange` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` | Self: 0.1% (1.5ms) | Total: 0.2% (3.1ms) | Samples: 1

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `get parent` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` | Self: 0.1% (1.5ms) | Total: 1.9% (26.6ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (18)

**Calls:**
- `get references` (9)
- `some` (7)
- `get references` (1)

### `_ensureTagCaches`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:647` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3140` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2677` | Self: 0.1% (1.5ms) | Total: 0.3% (4.7ms) | Samples: 1

**Called by:**
- `getScope` (3)

**Calls:**
- `test` (2)

### `extraArrowData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:687` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `get body` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `some` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2117` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `eslintUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:738` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `isUsedVariable` (1)

### `toFixed`
`[native code]` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `async (anonymous)` (1)

### `replace`
`[native code]` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `_execReport` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `_ensureChildren` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2053` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `get eslintUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:738` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `exec`
`[native code]` | Self: 0.1% (1.4ms) | Total: 0.4% (6.7ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (4)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7192` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2787` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `defs` (1)

### `/^\s*globals?\b/`
`[native code]` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `readdirSync`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.1% (2.7ms) | Samples: 1

**Called by:**
- `readdirSync` (1)
- `loadCoreRules` (1)

**Calls:**
- `readdirSync` (1)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` | Self: 0.0% (1.3ms) | Total: 0.9% (12.9ms) | Samples: 1

**Called by:**
- `isUsedVariable` (9)

**Calls:**
- `forEach` (8)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2727` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:176` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2675` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getScope` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2837` | Self: 0.0% (1.3ms) | Total: 8.9% (124.9ms) | Samples: 1

**Called by:**
- `get references` (82)

**Calls:**
- `get parent` (74)
- `get parent` (4)
- `get parent` (2)
- `get parent` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2222` | Self: 0.0% (1.3ms) | Total: 1.0% (15.2ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (10)

**Calls:**
- `_buildVariable` (3)
- `_buildVariable` (2)
- `_buildVariable` (1)
- `_buildVariable` (1)
- `_buildVariable` (1)
- `_buildVariable` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2167` | Self: 0.0% (1.3ms) | Total: 0.5% (7.0ms) | Samples: 1

**Called by:**
- `_buildScope` (5)

**Calls:**
- `get parent` (3)
- `get parent` (1)

### `nodeLhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:539` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `get body` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1238` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1037` | Self: 0.0% (1.3ms) | Total: 0.9% (13.7ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (9)

**Calls:**
- `source` (8)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:894` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2016` | Self: 0.0% (1.3ms) | Total: 0.5% (7.8ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (5)

**Calls:**
- `get` (4)

### `map`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3165` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:588` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6585` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `byteLength`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2190` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:887` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` | Self: 0.0% (0us) | Total: 2.2% (31.1ms) | Samples: 0

**Called by:**
- `_invokeFused` (20)

**Calls:**
- `getScope` (20)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:881` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `get name` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:587` | Self: 0.0% (0us) | Total: 0.4% (6.5ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (4)

**Calls:**
- `_findLineIdx` (2)
- `_findLineIdx` (1)
- `_findLineIdx` (1)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2964` | Self: 0.0% (0us) | Total: 0.5% (7.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `nodeViewChain` (3)
- `nodeViewChain` (2)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1728` | Self: 0.0% (0us) | Total: 0.7% (10.8ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (7)

**Calls:**
- `_nodesFromRange` (5)
- `_nodesFromRange` (2)

### `node:fs`
`node:fs:303` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `identifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:756` | Self: 0.0% (0us) | Total: 0.3% (4.6ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (2)
- `_computeDeclaredVariables` (1)

**Calls:**
- `defs` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.1% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:144` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Calls:**
- `loadCoreRules` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:300` | Self: 0.0% (0us) | Total: 28.5% (397.1ms) | Samples: 0

**Calls:**
- `parseSource` (257)
- `parseSource` (3)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4152` | Self: 0.0% (0us) | Total: 13.4% (187.0ms) | Samples: 0

**Called by:**
- `get parent` (65)
- `_buildReference` (24)
- `_computeVariableSynthRefs` (16)
- `_computeVarDefs` (11)
- `_nodesFromRange` (5)
- `get value` (1)

**Calls:**
- `_nodeViewRaw` (87)
- `_nodeViewRaw` (13)
- `_nodeViewRaw` (11)
- `_nodeViewRaw` (8)
- `_nodeViewRaw` (3)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:452` | Self: 0.0% (0us) | Total: 0.3% (5.4ms) | Samples: 0

**Called by:**
- `parseSource` (2)

**Calls:**
- `CfgGraph` (1)
- `CfgGraph` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:879` | Self: 0.0% (0us) | Total: 0.5% (7.8ms) | Samples: 0

**Called by:**
- `get body` (5)

**Calls:**
- `nodeView` (5)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:972` | Self: 0.0% (0us) | Total: 0.3% (4.5ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (3)

**Calls:**
- `_ensureVarsSet` (3)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 3.6% (50.9ms) | Samples: 0

**Called by:**
- `bound require` (33)

**Calls:**
- `anonymous` (33)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 1.3% (19.1ms) | Samples: 0

**Calls:**
- `parseModule` (13)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1531` | Self: 0.0% (0us) | Total: 0.2% (3.0ms) | Samples: 0

**Called by:**
- `_buildScope` (1)
- `get parent` (1)

**Calls:**
- `get loc` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2225` | Self: 0.0% (0us) | Total: 0.7% (9.8ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (6)

**Calls:**
- `get identifiers` (3)
- `identifiers` (2)
- `push` (1)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:47` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (1)

**Calls:**
- `readdirSync` (1)

### `forEach`
`[native code]` | Self: 0.0% (0us) | Total: 0.8% (11.5ms) | Samples: 0

**Called by:**
- `getFunctionDefinitions` (8)

**Calls:**
- `(anonymous)` (6)
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:22` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` | Self: 0.0% (0us) | Total: 60.1% (838.2ms) | Samples: 0

**Called by:**
- `_invokeFused` (545)

**Calls:**
- `collectUnusedVariables` (474)
- `collectUnusedVariables` (61)
- `collectUnusedVariables` (10)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3905` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `Program:exit` (1)

**Calls:**
- `_execReport` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1747` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `extraFnData` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:586` | Self: 0.0% (0us) | Total: 0.3% (4.2ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (3)

**Calls:**
- `_findLineIdx` (3)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` | Self: 0.0% (0us) | Total: 0.5% (8.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `bound require` (5)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2087` | Self: 0.0% (0us) | Total: 6.4% (89.7ms) | Samples: 0

**Called by:**
- `_buildReference` (26)
- `_buildScope` (20)
- `_buildScopeChildren` (11)
- `_precomputeScopes` (1)

**Calls:**
- `_computeIsStrict` (46)
- `_computeIsStrict` (5)
- `_computeIsStrict` (4)
- `_computeIsStrict` (2)
- `_computeIsStrict` (1)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:813` | Self: 0.0% (0us) | Total: 0.5% (7.8ms) | Samples: 0

**Called by:**
- `_ensureDeclSymIndex` (5)

**Calls:**
- `_buildSymNameCache` (5)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:776` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `get identifiers` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` | Self: 0.0% (0us) | Total: 5.6% (78.3ms) | Samples: 0

**Called by:**
- `some` (50)

**Calls:**
- `get references` (33)
- `get references` (15)
- `get references` (2)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `report` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:519` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `_computeVarDefs` (1)

**Calls:**
- `get parent` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` | Self: 0.0% (0us) | Total: 0.1% (2.7ms) | Samples: 0

**Called by:**
- `parseModule` (2)

**Calls:**
- `bound require` (2)

### `_isChainNode`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3939` | Self: 0.0% (0us) | Total: 0.1% (2.7ms) | Samples: 0

**Called by:**
- `nodeViewChain` (2)

**Calls:**
- `getUint32` (2)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Calls:**
- `toFixed` (1)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:522` | Self: 0.0% (0us) | Total: 0.3% (4.1ms) | Samples: 0

**Called by:**
- `runPlugins` (3)

**Calls:**
- `decode` (3)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4672` | Self: 0.0% (0us) | Total: 62.5% (870.8ms) | Samples: 0

**Called by:**
- `walkNodes` (566)

**Calls:**
- `Program:exit` (545)
- `Program:exit` (20)
- `Program:exit` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4177` | Self: 0.0% (0us) | Total: 0.1% (2.7ms) | Samples: 0

**Called by:**
- `init` (2)

**Calls:**
- `_isChainNode` (2)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:747` | Self: 0.0% (0us) | Total: 0.1% (2.6ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (2)

**Calls:**
- `defs` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` | Self: 0.0% (0us) | Total: 1.0% (15.1ms) | Samples: 0

**Called by:**
- `parseModule` (10)

**Calls:**
- `async (anonymous)` (10)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:48` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `RegExp` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3170` | Self: 0.0% (0us) | Total: 0.2% (3.0ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (2)

**Calls:**
- `get references` (1)
- `get references` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3840` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `report` (1)

**Calls:**
- `replace` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7256` | Self: 0.0% (0us) | Total: 62.5% (870.8ms) | Samples: 0

**Called by:**
- `runPlugins` (566)

**Calls:**
- `_invokeFused` (566)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2673` | Self: 0.0% (0us) | Total: 1.4% (19.9ms) | Samples: 0

**Called by:**
- `getScope` (13)

**Calls:**
- `commentsInRange` (5)
- `commentsInRange` (4)
- `commentsInRange` (3)
- `commentsInRange` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2227` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `get references` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:752` | Self: 0.0% (0us) | Total: 5.7% (79.8ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (51)

**Calls:**
- `some` (51)

### `internal:promisify`
`internal:promisify:53` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1540` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `get parent` (1)

**Calls:**
- `nodeView` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:458` | Self: 0.0% (0us) | Total: 0.5% (8.0ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `patchAstUtils` (5)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` | Self: 0.0% (0us) | Total: 13.3% (185.5ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (120)

**Calls:**
- `isAfterLastUsedArg` (63)
- `isAfterLastUsedArg` (51)
- `isAfterLastUsedArg` (4)
- `isAfterLastUsedArg` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` | Self: 0.0% (0us) | Total: 0.1% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` | Self: 0.0% (0us) | Total: 1.0% (15.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (10)

**Calls:**
- `async (anonymous)` (10)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` | Self: 0.0% (0us) | Total: 0.5% (6.9ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (3)

**Calls:**
- `AstView` (2)
- `AstView` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` | Self: 0.0% (0us) | Total: 0.1% (2.6ms) | Samples: 0

**Called by:**
- `forEach` (2)

**Calls:**
- `init` (2)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7540` | Self: 0.0% (0us) | Total: 69.1% (963.2ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (627)

**Calls:**
- `walkNodes` (566)
- `walkNodes` (35)
- `walkNodes` (9)
- `walkNodes` (7)
- `walkNodes` (5)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` | Self: 0.0% (0us) | Total: 100.0% (2.69s) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1280)
- `Program:exit` (474)

**Calls:**
- `collectUnusedVariables` (1280)
- `collectUnusedVariables` (197)
- `collectUnusedVariables` (120)
- `collectUnusedVariables` (73)
- `collectUnusedVariables` (46)
- `collectUnusedVariables` (30)
- `collectUnusedVariables` (2)
- `collectUnusedVariables` (2)
- `collectUnusedVariables` (2)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:72` | Self: 0.0% (0us) | Total: 1.0% (15.1ms) | Samples: 0

**Called by:**
- `async (anonymous)` (10)

**Calls:**
- `bound require` (10)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4317` | Self: 0.0% (0us) | Total: 0.1% (1.8ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_mergeRuleOptions` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:967` | Self: 0.0% (0us) | Total: 0.3% (4.5ms) | Samples: 0

**Called by:**
- `get` (3)

**Calls:**
- `_ensureVarsSet` (1)
- `_ensureVarsSet` (1)
- `_ensureVarsSet` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.2% (3.2ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` | Self: 0.0% (0us) | Total: 1.1% (16.0ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (11)

**Calls:**
- `getFunctionDefinitions` (9)
- `getFunctionDefinitions` (2)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7539` | Self: 0.0% (0us) | Total: 0.2% (3.3ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (2)

**Calls:**
- `buildVisitorMap` (1)
- `buildVisitorMap` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2606` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `getScope` (1)

**Calls:**
- `_buildScope` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:304` | Self: 0.0% (0us) | Total: 69.6% (970.7ms) | Samples: 0

**Calls:**
- `runPlugins` (627)
- `runPlugins` (3)
- `runPlugins` (2)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4358` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `AstView` (1)

**Calls:**
- `fill` (1)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1898` | Self: 0.0% (0us) | Total: 2.2% (31.1ms) | Samples: 0

**Called by:**
- `Program:exit` (20)

**Calls:**
- `_precomputeScopes` (13)
- `_precomputeScopes` (3)
- `_precomputeScopes` (1)
- `_precomputeScopes` (1)
- `_precomputeScopes` (1)
- `_precomputeScopes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` | Self: 0.0% (0us) | Total: 0.8% (12.3ms) | Samples: 0

**Called by:**
- `some` (8)

**Calls:**
- `isReadForItself` (5)
- `isReadForItself` (2)
- `isReadForItself` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.2% (3.2ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3101` | Self: 0.0% (0us) | Total: 6.7% (94.1ms) | Samples: 0

**Called by:**
- `isAfterLastUsedArg` (61)

**Calls:**
- `_computeDeclaredVariables` (19)
- `_computeDeclaredVariables` (11)
- `_computeDeclaredVariables` (7)
- `_computeDeclaredVariables` (7)
- `_computeDeclaredVariables` (6)
- `_computeDeclaredVariables` (5)
- `_computeDeclaredVariables` (2)
- `_computeDeclaredVariables` (2)
- `_computeDeclaredVariables` (1)
- `_computeDeclaredVariables` (1)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 3.8% (53.7ms) | Samples: 0

**Called by:**
- `async (anonymous)` (10)
- `(anonymous)` (7)
- `patchAstUtils` (5)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `require` (33)
- `anonymous` (2)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` | Self: 0.0% (0us) | Total: 28.0% (390.1ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (257)

**Calls:**
- `parse` (257)

### `getTagNames`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:186` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `loadBinding` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` | Self: 0.0% (0us) | Total: 3.4% (48.1ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (30)

**Calls:**
- `defs` (29)
- `get defs` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` | Self: 0.0% (0us) | Total: 0.7% (11.0ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `get defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` | Self: 0.0% (0us) | Total: 0.2% (3.3ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)
- `get identifiers` (1)

**Calls:**
- `_computeVarDefs` (1)
- `_computeVarDefs` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2081` | Self: 0.0% (0us) | Total: 0.2% (2.9ms) | Samples: 0

**Called by:**
- `_buildScope` (2)

**Calls:**
- `get value` (1)
- `get value` (1)

### `scope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:745` | Self: 0.0% (0us) | Total: 0.4% (5.6ms) | Samples: 0

**Called by:**
- `_computeVariableSynthRefs` (4)

**Calls:**
- `_computeVarScope` (3)
- `_computeVarScope` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:957` | Self: 0.0% (0us) | Total: 2.3% (32.9ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (21)

**Calls:**
- `_ensureChildren` (21)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2322` | Self: 0.0% (0us) | Total: 0.1% (2.7ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (2)

**Calls:**
- `test` (1)
- `/^\s*globals?\b/` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` | Self: 0.0% (0us) | Total: 6.9% (97.1ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (63)

**Calls:**
- `getDeclaredVariables` (61)
- `getDeclaredVariables` (1)
- `map` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2782` | Self: 0.0% (0us) | Total: 1.6% (23.3ms) | Samples: 0

**Called by:**
- `defs` (13)
- `get defs` (1)

**Calls:**
- `_findDefNode` (13)
- `_findDefNode` (1)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1382` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `_identAt` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2895` | Self: 0.0% (0us) | Total: 0.4% (5.6ms) | Samples: 0

**Called by:**
- `get references` (4)

**Calls:**
- `scope` (4)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1764` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `_nodesFromRange` (1)

### `(anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Calls:**
- `internalAll` (1)

### `get init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2964` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `nodeViewChain` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:37` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `byteLength` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4367` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_expandUnion` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:561` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `nodeViewChain` (1)

### `parseModule`
`[native code]` | Self: 0.0% (0us) | Total: 1.3% (19.1ms) | Samples: 0

**Called by:**
- `async (anonymous)` (13)

**Calls:**
- `(anonymous)` (10)
- `(anonymous)` (2)
- `(anonymous)` (1)

### `node:events`
`node:events:9` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4180` | Self: 0.0% (0us) | Total: 0.4% (6.0ms) | Samples: 0

**Called by:**
- `init` (3)
- `getRhsNode` (1)

**Calls:**
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1265` | Self: 0.0% (0us) | Total: 0.2% (3.3ms) | Samples: 0

**Called by:**
- `_findDefNode` (2)

**Calls:**
- `get value` (1)
- `get value` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3168` | Self: 0.0% (0us) | Total: 0.2% (3.3ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (2)

**Calls:**
- `identifiers` (1)
- `get identifiers` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` | Self: 0.0% (0us) | Total: 0.3% (4.4ms) | Samples: 0

**Called by:**
- `some` (3)

**Calls:**
- `isForInOfRef` (2)
- `isForInOfRef` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `some` (1)

**Calls:**
- `isRead` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` | Self: 0.0% (0us) | Total: 0.6% (8.9ms) | Samples: 0

**Called by:**
- `forEach` (6)

**Calls:**
- `init` (5)
- `get init` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `eslintUsed` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` | Self: 0.0% (0us) | Total: 0.2% (2.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `get parent` (1)
- `get parent` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7251` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_fireCfgEvents` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:855` | Self: 0.0% (0us) | Total: 0.1% (1.8ms) | Samples: 0

**Called by:**
- `get` (1)

**Calls:**
- `defs` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:279` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `DataView` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:953` | Self: 0.0% (0us) | Total: 12.0% (167.5ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (108)

**Calls:**
- `_ensureVarsSet` (107)
- `_ensureVarsSet` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1750` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `extraArrowData` (1)

### `get identifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:756` | Self: 0.0% (0us) | Total: 0.6% (8.4ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (3)
- `_computeDeclaredVariables` (1)
- `collectUnusedVariables` (1)

**Calls:**
- `defs` (4)
- `get defs` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` | Self: 0.0% (0us) | Total: 0.7% (10.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (7)

**Calls:**
- `isInLoop` (7)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7532` | Self: 0.0% (0us) | Total: 0.3% (4.1ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (3)

**Calls:**
- `get source` (3)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:288` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Calls:**
- `getTagNames` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7016` | Self: 0.0% (0us) | Total: 0.5% (7.2ms) | Samples: 0

**Called by:**
- `runPlugins` (5)

**Calls:**
- `getDFSEvents` (2)
- `getDFSEvents` (2)
- `getDFSEvents` (1)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:758` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `get name` (1)

**Calls:**
- `source` (1)

### `isInside`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:494` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `getRhsNode` (1)

**Calls:**
- `get range` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `internal:validators`
`internal:validators:2` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:551` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isInside` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6017` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_ensureTagCaches` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2029` | Self: 0.0% (0us) | Total: 0.5% (7.8ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (5)

**Calls:**
- `_symName` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 35.0% | 488.8ms | `[native code]` |
| 33.0% | 460.0ms | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 27.1% | 378.8ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 4.5% | 63.8ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.1% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/index.js` |
