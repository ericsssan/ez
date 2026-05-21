# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 2.24s | 1477 | 1.0ms | 342 |

**Top 10:** `parse` 32.4%, `walkNodes` 4.3%, `_nodeViewRaw` 3.1%, `_NodeView_LR` 2.5%, `_NodeView` 2.5%, `Set` 1.7%, `_buildScope` 1.6%, `walkNodes` 1.5%, `_computeDeclaredVariables` 1.5%, `_buildReference` 1.5%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 32.4% | 727.8ms | 32.4% | 727.8ms | `parse` | `[native code]` |
| 4.3% | 97.4ms | 4.3% | 97.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7058` |
| 3.1% | 70.6ms | 9.2% | 207.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 2.5% | 57.7ms | 2.5% | 57.7ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4058` |
| 2.5% | 56.1ms | 2.5% | 56.1ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` |
| 1.7% | 39.8ms | 2.4% | 54.9ms | `Set` | `[native code]` |
| 1.6% | 37.1ms | 1.6% | 37.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2161` |
| 1.5% | 35.3ms | 1.5% | 35.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6784` |
| 1.5% | 34.0ms | 1.5% | 34.0ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3207` |
| 1.5% | 33.8ms | 2.0% | 45.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2901` |
| 1.2% | 28.9ms | 1.4% | 31.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 1.1% | 26.8ms | 6.6% | 149.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1211` |
| 1.1% | 25.9ms | 1.1% | 25.9ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 1.1% | 25.4ms | 1.3% | 31.3ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1710` |
| 1.0% | 24.3ms | 1.0% | 24.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4100` |
| 0.9% | 21.7ms | 2.5% | 56.3ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:802` |
| 0.8% | 19.2ms | 0.8% | 19.2ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:615` |
| 0.8% | 19.1ms | 0.8% | 19.1ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2277` |
| 0.8% | 18.0ms | 0.8% | 18.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4111` |
| 0.7% | 17.6ms | 0.7% | 17.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1317` |
| 0.7% | 17.6ms | 6.0% | 134.8ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2141` |
| 0.7% | 17.3ms | 0.7% | 17.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4110` |
| 0.7% | 16.5ms | 0.7% | 16.5ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.6% | 15.6ms | 0.6% | 15.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2283` |
| 0.6% | 14.8ms | 0.6% | 14.8ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3213` |
| 0.6% | 14.8ms | 0.6% | 14.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.6% | 14.7ms | 0.7% | 17.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1250` |
| 0.6% | 14.5ms | 0.7% | 15.8ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 0.6% | 13.9ms | 0.6% | 13.9ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:855` |
| 0.6% | 13.6ms | 0.6% | 13.6ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:467` |
| 0.6% | 13.5ms | 22.1% | 497.1ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:808` |
| 0.5% | 13.2ms | 0.5% | 13.2ms | `_Reference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:236` |
| 0.5% | 12.6ms | 0.6% | 14.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2269` |
| 0.5% | 12.3ms | 0.5% | 12.3ms | `getUint32` | `[native code]` |
| 0.5% | 12.3ms | 8.2% | 184.9ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2883` |
| 0.5% | 11.7ms | 0.5% | 11.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2482` |
| 0.5% | 11.7ms | 0.8% | 19.6ms | `arrayIteratorNextHelper` | `[native code]` |
| 0.5% | 11.4ms | 0.5% | 11.4ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` |
| 0.4% | 11.1ms | 0.4% | 11.1ms | `decode` | `[native code]` |
| 0.4% | 9.9ms | 0.4% | 9.9ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2640` |
| 0.4% | 9.8ms | 0.4% | 9.8ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:902` |
| 0.4% | 9.6ms | 0.4% | 9.6ms | `typedArrayViewIsDetached` | `[native code]` |
| 0.4% | 9.5ms | 0.4% | 9.5ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.4% | 9.2ms | 0.4% | 9.2ms | `_Variable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:847` |
| 0.4% | 9.1ms | 0.4% | 9.1ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2826` |
| 0.4% | 9.0ms | 0.4% | 9.0ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2106` |
| 0.4% | 8.9ms | 2.5% | 56.7ms | `anonymous` | `[native code]` |
| 0.3% | 8.6ms | 0.6% | 14.5ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2934` |
| 0.3% | 8.2ms | 3.9% | 88.8ms | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:769` |
| 0.3% | 8.1ms | 0.3% | 8.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7233` |
| 0.3% | 7.8ms | 0.3% | 7.8ms | `typedArrayViewLength` | `[native code]` |
| 0.3% | 7.8ms | 0.3% | 7.8ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.3% | 7.8ms | 0.3% | 7.8ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.3% | 7.8ms | 0.4% | 10.8ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.3% | 7.7ms | 0.3% | 7.7ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.3% | 7.6ms | 0.3% | 7.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3187` |
| 0.3% | 7.4ms | 1.0% | 24.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2267` |
| 0.3% | 7.4ms | 0.3% | 7.4ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.3% | 7.3ms | 0.8% | 18.2ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2831` |
| 0.3% | 7.3ms | 1.4% | 33.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2374` |
| 0.3% | 7.1ms | 0.3% | 7.1ms | `subarray` | `[native code]` |
| 0.2% | 6.4ms | 0.2% | 6.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2486` |
| 0.2% | 6.4ms | 0.2% | 6.4ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:570` |
| 0.2% | 6.4ms | 0.2% | 6.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2751` |
| 0.2% | 6.3ms | 0.8% | 19.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2125` |
| 0.2% | 6.2ms | 0.2% | 6.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2171` |
| 0.2% | 6.1ms | 0.2% | 6.1ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2752` |
| 0.2% | 6.0ms | 0.5% | 12.1ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2847` |
| 0.2% | 5.9ms | 0.5% | 12.4ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2879` |
| 0.2% | 5.8ms | 1.3% | 30.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2276` |
| 0.2% | 5.8ms | 0.2% | 5.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1191` |
| 0.2% | 5.8ms | 0.2% | 5.8ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3206` |
| 0.2% | 5.7ms | 0.2% | 5.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:614` |
| 0.2% | 5.7ms | 21.5% | 483.3ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 0.2% | 5.1ms | 0.2% | 5.1ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3881` |
| 0.2% | 5.0ms | 1.4% | 33.1ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:497` |
| 0.2% | 4.9ms | 0.2% | 4.9ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 4.9ms | 0.2% | 4.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7060` |
| 0.2% | 4.8ms | 4.3% | 97.0ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2872` |
| 0.2% | 4.7ms | 0.2% | 4.7ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6515` |
| 0.2% | 4.7ms | 5.4% | 122.2ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2876` |
| 0.2% | 4.7ms | 0.2% | 6.4ms | `test` | `[native code]` |
| 0.2% | 4.6ms | 0.3% | 7.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.2% | 4.5ms | 6.2% | 139.9ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1736` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4132` |
| 0.1% | 4.3ms | 0.6% | 15.4ms | `from` | `[native code]` |
| 0.1% | 3.9ms | 0.1% | 3.9ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3136` |
| 0.1% | 3.8ms | 0.1% | 3.8ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6517` |
| 0.1% | 3.5ms | 0.1% | 3.5ms | `/^\s*exported\b/` | `[native code]` |
| 0.1% | 3.4ms | 0.1% | 3.4ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `encodeInto` | `[native code]` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:656` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `push` | `[native code]` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2375` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `extraArrowData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:713` |
| 0.1% | 3.2ms | 0.4% | 9.4ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1709` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `map` | `[native code]` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4344` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2266` |
| 0.1% | 3.1ms | 0.2% | 4.9ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3924` |
| 0.1% | 3.1ms | 0.2% | 4.4ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 3.0ms | 0.3% | 8.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2279` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `isRead` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:220` |
| 0.1% | 3.0ms | 0.8% | 19.8ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2802` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3672` |
| 0.1% | 3.0ms | 0.4% | 8.9ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1249` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3133` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `DataView` | `[native code]` |
| 0.1% | 2.9ms | 1.7% | 38.5ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2643` |
| 0.1% | 2.9ms | 0.2% | 4.6ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2222` |
| 0.1% | 2.9ms | 2.6% | 60.5ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `isRead` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4051` |
| 0.1% | 2.8ms | 12.1% | 272.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` |
| 0.1% | 2.8ms | 8.0% | 181.5ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:891` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2954` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7229` |
| 0.1% | 2.5ms | 2.3% | 52.7ms | `_ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:970` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2284` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2647` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:659` |
| 0.0% | 1.7ms | 0.1% | 3.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` |
| 0.0% | 1.7ms | 0.1% | 3.5ms | `readdirSync` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:109` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `dlopen` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:309` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3630` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get operator` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1339` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2151` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3630` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1074` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `Map` | `[native code]` |
| 0.0% | 1.6ms | 0.1% | 3.3ms | `readFileSync` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `join` | `[native code]` |
| 0.0% | 1.6ms | 0.1% | 3.4ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2244` |
| 0.0% | 1.6ms | 0.6% | 15.6ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:839` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3165` |
| 0.0% | 1.6ms | 0.2% | 6.2ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3181` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:479` |
| 0.0% | 1.6ms | 10.9% | 244.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn-jsx/xhtml.js:1` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_isStatementTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 2.3% | 51.9ms | `require` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1525` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7234` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3143` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1223` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2854` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2199` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2042` |
| 0.0% | 1.5ms | 0.2% | 6.4ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2902` |
| 0.0% | 1.5ms | 1.3% | 30.8ms | `next` | `[native code]` |
| 0.0% | 1.5ms | 5.2% | 118.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2120` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3171` |
| 0.0% | 1.5ms | 1.7% | 38.2ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2821` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4115` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `extraMethodData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:732` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:655` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:890` |
| 0.0% | 1.4ms | 7.5% | 170.3ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2376` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3047` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1732` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:653` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `existsSync` | `[native code]` |
| 0.0% | 1.4ms | 1.1% | 25.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1261` |
| 0.0% | 1.4ms | 0.2% | 5.4ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1733` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:236` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3026` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:617` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4044` |
| 0.0% | 1.3ms | 1.1% | 26.5ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` |
| 0.0% | 1.3ms | 0.6% | 15.0ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` |
| 0.0% | 1.3ms | 0.5% | 13.2ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2949` |
| 0.0% | 1.3ms | 8.0% | 181.1ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:999` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get right` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1821` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2943` |
| 0.0% | 1.2ms | 0.1% | 2.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.0% | 1.2ms | 0.4% | 9.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:613` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `internal:primordials` |
| 0.0% | 1.2ms | 100.0% | 4.52s | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 0.0% | 1.2ms | 0.1% | 4.1ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` |
| 0.0% | 1.2ms | 0.1% | 4.4ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2948` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4108` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `fill` | `[native code]` |
| 0.0% | 1.2ms | 0.2% | 4.8ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:776` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:810` |
| 0.0% | 1.2ms | 0.1% | 4.2ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3211` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4156` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 100.0% | 4.52s | 0.0% | 1.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 65.8% | 1.47s | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:304` |
| 65.1% | 1.46s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7581` |
| 58.0% | 1.30s | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4713` |
| 58.0% | 1.30s | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7297` |
| 55.6% | 1.24s | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` |
| 32.9% | 739.0ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:300` |
| 32.4% | 727.8ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` |
| 32.4% | 727.8ms | 32.4% | 727.8ms | `parse` | `[native code]` |
| 22.1% | 497.1ms | 0.6% | 13.5ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:808` |
| 21.5% | 483.3ms | 0.2% | 5.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 12.1% | 272.7ms | 0.1% | 2.8ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` |
| 11.0% | 247.5ms | 0.0% | 0us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4137` |
| 10.9% | 244.7ms | 0.0% | 1.6ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 9.2% | 207.0ms | 3.1% | 70.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 9.0% | 202.2ms | 0.0% | 0us | `some` | `[native code]` |
| 8.2% | 184.9ms | 0.5% | 12.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2883` |
| 8.0% | 181.5ms | 0.1% | 2.8ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:891` |
| 8.0% | 181.1ms | 0.0% | 1.3ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:999` |
| 7.5% | 170.3ms | 0.0% | 1.4ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` |
| 7.0% | 158.8ms | 0.0% | 0us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3135` |
| 6.6% | 149.9ms | 1.1% | 26.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1211` |
| 6.2% | 139.9ms | 0.2% | 4.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 6.0% | 134.8ms | 0.7% | 17.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2141` |
| 5.4% | 122.2ms | 0.2% | 4.7ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2876` |
| 5.2% | 118.9ms | 0.0% | 1.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2120` |
| 4.3% | 97.4ms | 4.3% | 97.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7058` |
| 4.3% | 97.0ms | 0.2% | 4.8ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2872` |
| 4.2% | 95.0ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2240` |
| 3.9% | 88.8ms | 0.3% | 8.2ms | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:769` |
| 3.9% | 88.7ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:752` |
| 3.9% | 88.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` |
| 3.5% | 79.5ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` |
| 2.6% | 60.5ms | 0.1% | 2.9ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 2.5% | 57.7ms | 2.5% | 57.7ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4058` |
| 2.5% | 56.7ms | 0.4% | 8.9ms | `anonymous` | `[native code]` |
| 2.5% | 56.3ms | 0.9% | 21.7ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:802` |
| 2.5% | 56.1ms | 2.5% | 56.1ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` |
| 2.4% | 55.0ms | 0.0% | 0us | `bound require` | `[native code]` |
| 2.4% | 54.9ms | 1.7% | 39.8ms | `Set` | `[native code]` |
| 2.4% | 54.9ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3177` |
| 2.3% | 52.7ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1003` |
| 2.3% | 52.7ms | 0.1% | 2.5ms | `_ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:970` |
| 2.3% | 51.9ms | 0.0% | 1.6ms | `require` | `[native code]` |
| 2.1% | 48.8ms | 0.0% | 0us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1947` |
| 2.1% | 48.8ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` |
| 2.0% | 45.5ms | 1.5% | 33.8ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2901` |
| 1.8% | 40.5ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2727` |
| 1.7% | 38.5ms | 0.1% | 2.9ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2643` |
| 1.7% | 38.2ms | 0.0% | 1.5ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2821` |
| 1.6% | 37.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 1.6% | 37.1ms | 1.6% | 37.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2161` |
| 1.5% | 35.3ms | 1.5% | 35.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6784` |
| 1.5% | 34.0ms | 1.5% | 34.0ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3207` |
| 1.5% | 33.9ms | 0.0% | 0us | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` |
| 1.4% | 33.2ms | 0.3% | 7.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2374` |
| 1.4% | 33.1ms | 0.2% | 5.0ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:497` |
| 1.4% | 31.8ms | 1.2% | 28.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 1.3% | 31.3ms | 1.1% | 25.4ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1710` |
| 1.3% | 30.8ms | 0.0% | 1.5ms | `next` | `[native code]` |
| 1.3% | 30.7ms | 0.2% | 5.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2276` |
| 1.2% | 28.2ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1713` |
| 1.1% | 26.5ms | 0.0% | 1.3ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 1.1% | 26.4ms | 0.0% | 0us | `forEach` | `[native code]` |
| 1.1% | 25.9ms | 1.1% | 25.9ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 1.1% | 25.6ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` |
| 1.0% | 24.3ms | 0.3% | 7.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2267` |
| 1.0% | 24.3ms | 1.0% | 24.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4100` |
| 0.8% | 19.8ms | 0.1% | 3.0ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2802` |
| 0.8% | 19.7ms | 0.0% | 0us | `parseModule` | `[native code]` |
| 0.8% | 19.7ms | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 0.8% | 19.6ms | 0.5% | 11.7ms | `arrayIteratorNextHelper` | `[native code]` |
| 0.8% | 19.2ms | 0.8% | 19.2ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:615` |
| 0.8% | 19.1ms | 0.8% | 19.1ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2277` |
| 0.8% | 19.1ms | 0.2% | 6.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2125` |
| 0.8% | 19.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` |
| 0.8% | 18.3ms | 0.0% | 0us | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:905` |
| 0.8% | 18.2ms | 0.3% | 7.3ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2831` |
| 0.8% | 18.0ms | 0.8% | 18.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4111` |
| 0.7% | 17.8ms | 0.6% | 14.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1250` |
| 0.7% | 17.6ms | 0.7% | 17.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1317` |
| 0.7% | 17.3ms | 0.7% | 17.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4110` |
| 0.7% | 16.5ms | 0.7% | 16.5ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.7% | 15.8ms | 0.6% | 14.5ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 0.6% | 15.6ms | 0.6% | 15.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2283` |
| 0.6% | 15.6ms | 0.0% | 1.6ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:839` |
| 0.6% | 15.4ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3179` |
| 0.6% | 15.4ms | 0.1% | 4.3ms | `from` | `[native code]` |
| 0.6% | 15.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` |
| 0.6% | 15.1ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` |
| 0.6% | 15.0ms | 0.0% | 1.3ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` |
| 0.6% | 15.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` |
| 0.6% | 14.8ms | 0.6% | 14.8ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3213` |
| 0.6% | 14.8ms | 0.6% | 14.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.6% | 14.5ms | 0.3% | 8.6ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2934` |
| 0.6% | 14.3ms | 0.5% | 12.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2269` |
| 0.6% | 14.0ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2221` |
| 0.6% | 13.9ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2065` |
| 0.6% | 13.9ms | 0.6% | 13.9ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:855` |
| 0.6% | 13.7ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:72` |
| 0.6% | 13.6ms | 0.6% | 13.6ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:467` |
| 0.5% | 13.2ms | 0.0% | 1.3ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2949` |
| 0.5% | 13.2ms | 0.5% | 13.2ms | `_Reference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:236` |
| 0.5% | 13.2ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2907` |
| 0.5% | 12.4ms | 0.2% | 5.9ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2879` |
| 0.5% | 12.3ms | 0.5% | 12.3ms | `getUint32` | `[native code]` |
| 0.5% | 12.1ms | 0.0% | 0us | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2929` |
| 0.5% | 12.1ms | 0.2% | 6.0ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2847` |
| 0.5% | 11.7ms | 0.5% | 11.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2482` |
| 0.5% | 11.4ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7573` |
| 0.5% | 11.4ms | 0.5% | 11.4ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` |
| 0.4% | 11.1ms | 0.4% | 11.1ms | `decode` | `[native code]` |
| 0.4% | 11.1ms | 0.0% | 0us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` |
| 0.4% | 10.8ms | 0.3% | 7.8ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.4% | 10.7ms | 0.0% | 0us | `scope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:764` |
| 0.4% | 10.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` |
| 0.4% | 9.9ms | 0.4% | 9.9ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2640` |
| 0.4% | 9.8ms | 0.4% | 9.8ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:902` |
| 0.4% | 9.7ms | 0.0% | 1.2ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:613` |
| 0.4% | 9.6ms | 0.4% | 9.6ms | `typedArrayViewIsDetached` | `[native code]` |
| 0.4% | 9.5ms | 0.4% | 9.5ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.4% | 9.4ms | 0.1% | 3.2ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1709` |
| 0.4% | 9.2ms | 0.4% | 9.2ms | `_Variable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:847` |
| 0.4% | 9.2ms | 0.0% | 0us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2782` |
| 0.4% | 9.1ms | 0.4% | 9.1ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2826` |
| 0.4% | 9.0ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1013` |
| 0.4% | 9.0ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1018` |
| 0.4% | 9.0ms | 0.4% | 9.0ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2106` |
| 0.4% | 8.9ms | 0.1% | 3.0ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` |
| 0.3% | 8.8ms | 0.1% | 3.0ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2279` |
| 0.3% | 8.6ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7057` |
| 0.3% | 8.2ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2731` |
| 0.3% | 8.1ms | 0.3% | 8.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7233` |
| 0.3% | 7.8ms | 0.3% | 7.8ms | `typedArrayViewLength` | `[native code]` |
| 0.3% | 7.8ms | 0.3% | 7.8ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.3% | 7.8ms | 0.3% | 7.8ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.3% | 7.7ms | 0.2% | 4.6ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.3% | 7.7ms | 0.3% | 7.7ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.3% | 7.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:477` |
| 0.3% | 7.6ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:435` |
| 0.3% | 7.6ms | 0.3% | 7.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3187` |
| 0.3% | 7.4ms | 0.3% | 7.4ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.3% | 7.1ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3147` |
| 0.3% | 7.1ms | 0.3% | 7.1ms | `subarray` | `[native code]` |
| 0.2% | 6.4ms | 0.2% | 6.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2486` |
| 0.2% | 6.4ms | 0.2% | 6.4ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:570` |
| 0.2% | 6.4ms | 0.2% | 4.7ms | `test` | `[native code]` |
| 0.2% | 6.4ms | 0.0% | 1.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` |
| 0.2% | 6.4ms | 0.2% | 6.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2751` |
| 0.2% | 6.2ms | 0.0% | 1.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3181` |
| 0.2% | 6.2ms | 0.2% | 6.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2171` |
| 0.2% | 6.1ms | 0.2% | 6.1ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2752` |
| 0.2% | 6.1ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` |
| 0.2% | 5.8ms | 0.2% | 5.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1191` |
| 0.2% | 5.8ms | 0.2% | 5.8ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3206` |
| 0.2% | 5.7ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4165` |
| 0.2% | 5.7ms | 0.2% | 5.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:614` |
| 0.2% | 5.4ms | 0.0% | 1.4ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1733` |
| 0.2% | 5.1ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3946` |
| 0.2% | 5.1ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` |
| 0.2% | 5.1ms | 0.2% | 5.1ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3881` |
| 0.2% | 5.0ms | 0.0% | 0us | `get identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:775` |
| 0.2% | 4.9ms | 0.2% | 4.9ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 4.9ms | 0.0% | 0us | `get defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:769` |
| 0.2% | 4.9ms | 0.1% | 3.1ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3924` |
| 0.2% | 4.9ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4162` |
| 0.2% | 4.9ms | 0.2% | 4.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7060` |
| 0.2% | 4.8ms | 0.0% | 1.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:776` |
| 0.2% | 4.7ms | 0.2% | 4.7ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6515` |
| 0.2% | 4.6ms | 0.1% | 2.9ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2222` |
| 0.2% | 4.4ms | 0.1% | 3.1ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1736` |
| 0.1% | 4.4ms | 0.0% | 0us | `identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:775` |
| 0.1% | 4.4ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:612` |
| 0.1% | 4.4ms | 0.0% | 1.2ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2948` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4132` |
| 0.1% | 4.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.1% | 4.2ms | 0.0% | 1.2ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3211` |
| 0.1% | 4.2ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2281` |
| 0.1% | 4.1ms | 0.0% | 1.2ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` |
| 0.1% | 4.1ms | 0.0% | 0us | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:506` |
| 0.1% | 4.1ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:557` |
| 0.1% | 3.9ms | 0.1% | 3.9ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3136` |
| 0.1% | 3.8ms | 0.1% | 3.8ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6517` |
| 0.1% | 3.5ms | 0.0% | 1.7ms | `readdirSync` | `[native code]` |
| 0.1% | 3.5ms | 0.1% | 3.5ms | `/^\s*exported\b/` | `[native code]` |
| 0.1% | 3.5ms | 0.0% | 1.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` |
| 0.1% | 3.4ms | 0.0% | 1.6ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2244` |
| 0.1% | 3.4ms | 0.1% | 3.4ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 3.3ms | 0.0% | 1.6ms | `readFileSync` | `[native code]` |
| 0.1% | 3.3ms | 0.0% | 0us | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:822` |
| 0.1% | 3.3ms | 0.0% | 0us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:92` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `encodeInto` | `[native code]` |
| 0.1% | 3.3ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:215` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:656` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `push` | `[native code]` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2375` |
| 0.1% | 3.2ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1735` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `extraArrowData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:713` |
| 0.1% | 3.2ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:144` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `map` | `[native code]` |
| 0.1% | 3.1ms | 0.0% | 0us | `exec` | `[native code]` |
| 0.1% | 3.1ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:478` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4344` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2266` |
| 0.1% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` |
| 0.1% | 3.0ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2135` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `isRead` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:220` |
| 0.1% | 3.0ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1516` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3672` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1249` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3133` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` |
| 0.1% | 2.9ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:286` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `DataView` | `[native code]` |
| 0.1% | 2.9ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:747` |
| 0.1% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `isRead` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4051` |
| 0.1% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2954` |
| 0.1% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7229` |
| 0.1% | 2.6ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:927` |
| 0.1% | 2.6ms | 0.0% | 0us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1367` |
| 0.1% | 2.5ms | 0.0% | 1.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2284` |
| 0.0% | 1.8ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:901` |
| 0.0% | 1.8ms | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:538` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2647` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:659` |
| 0.0% | 1.7ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:47` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:109` |
| 0.0% | 1.7ms | 0.0% | 0us | `loadBinding` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` |
| 0.0% | 1.7ms | 0.0% | 0us | `getTagNames` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:186` |
| 0.0% | 1.7ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:288` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `dlopen` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:309` |
| 0.0% | 1.7ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3225` |
| 0.0% | 1.7ms | 0.0% | 0us | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3378` |
| 0.0% | 1.7ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3201` |
| 0.0% | 1.7ms | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:503` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3630` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get operator` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1339` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:656` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2151` |
| 0.0% | 1.7ms | 0.0% | 0us | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:494` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3630` |
| 0.0% | 1.7ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:661` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js:133` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` |
| 0.0% | 1.7ms | 0.0% | 0us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4106` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1074` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3209` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:35` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `Map` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `join` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:221` |
| 0.0% | 1.6ms | 0.0% | 0us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2755` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3165` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:479` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn-jsx/xhtml.js:1` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn-jsx/index.js:3` |
| 0.0% | 1.6ms | 0.0% | 0us | `range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3610` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_isStatementTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1525` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7234` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3143` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1223` |
| 0.0% | 1.5ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:543` |
| 0.0% | 1.5ms | 0.0% | 0us | `performProxyObjectGet` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2854` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2199` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2042` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2902` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3171` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4115` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `extraMethodData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:732` |
| 0.0% | 1.5ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1507` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:655` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:890` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3047` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2376` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1732` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:653` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `existsSync` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:42` |
| 0.0% | 1.4ms | 0.0% | 0us | `existsSync` | `node:fs:273` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1261` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:236` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3026` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:617` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2067` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4044` |
| 0.0% | 1.4ms | 0.0% | 0us | `get scope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:764` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `async _resolveConfig` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:71` |
| 0.0% | 1.3ms | 0.0% | 0us | `async _resolveConfig` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:68` |
| 0.0% | 1.3ms | 0.0% | 0us | `async lintSource` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:461` |
| 0.0% | 1.3ms | 0.0% | 0us | `async lintSource` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:462` |
| 0.0% | 1.3ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:76` |
| 0.0% | 1.3ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:74` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` |
| 0.0% | 1.3ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:926` |
| 0.0% | 1.3ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:662` |
| 0.0% | 1.3ms | 0.0% | 0us | `getUpperFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:132` |
| 0.0% | 1.3ms | 0.0% | 0us | `isInsideOfStorableFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:630` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get right` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1821` |
| 0.0% | 1.3ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:561` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2943` |
| 0.0% | 1.2ms | 0.0% | 0us | `internal:shared` | `internal:shared:2` |
| 0.0% | 1.2ms | 0.0% | 0us | `node:events` | `node:events:9` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `internal:primordials` |
| 0.0% | 1.2ms | 0.0% | 0us | `makeSafe` | `internal:primordials:30` |
| 0.0% | 1.2ms | 0.0% | 0us | `internal:primordials` | `internal:primordials:71` |
| 0.0% | 1.2ms | 0.0% | 0us | `internal:validators` | `internal:validators:2` |
| 0.0% | 1.2ms | 0.0% | 0us | `bound call` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4108` |
| 0.0% | 1.2ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7561` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `fill` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:810` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4156` |
| 0.0% | 1.1ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7576` |

## Function Details

### `parse`
`[native code]` | Self: 32.4% (727.8ms) | Total: 32.4% (727.8ms) | Samples: 480

**Called by:**
- `parseSource` (480)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7058` | Self: 4.3% (97.4ms) | Total: 4.3% (97.4ms) | Samples: 64

**Called by:**
- `runPlugins` (64)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` | Self: 3.1% (70.6ms) | Total: 9.2% (207.0ms) | Samples: 47

**Called by:**
- `nodeView` (133)
- `get parent` (2)
- `nodeViewChain` (2)
- `_nodesFromRange` (1)

**Calls:**
- `_NodeView` (39)
- `_NodeView_LR` (37)
- `_NodeView_LR` (11)
- `_NodeView_LRN` (2)
- `_NodeView` (2)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4058` | Self: 2.5% (57.7ms) | Total: 2.5% (57.7ms) | Samples: 37

**Called by:**
- `_nodeViewRaw` (37)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` | Self: 2.5% (56.1ms) | Total: 2.5% (56.1ms) | Samples: 39

**Called by:**
- `_nodeViewRaw` (39)

### `Set`
`[native code]` | Self: 1.7% (39.8ms) | Total: 2.4% (54.9ms) | Samples: 26

**Called by:**
- `_computeDeclaredVariables` (36)

**Calls:**
- `next` (10)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2161` | Self: 1.6% (37.1ms) | Total: 1.6% (37.1ms) | Samples: 25

**Called by:**
- `_buildReference` (21)
- `_computeVarScope` (3)
- `_buildScopeChildren` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6784` | Self: 1.5% (35.3ms) | Total: 1.5% (35.3ms) | Samples: 23

**Called by:**
- `runPlugins` (23)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3207` | Self: 1.5% (34.0ms) | Total: 1.5% (34.0ms) | Samples: 23

**Called by:**
- `getDeclaredVariables` (23)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2901` | Self: 1.5% (33.8ms) | Total: 2.0% (45.5ms) | Samples: 22

**Called by:**
- `get references` (30)

**Calls:**
- `get parent` (7)
- `get parent` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` | Self: 1.2% (28.9ms) | Total: 1.4% (31.8ms) | Samples: 19

**Called by:**
- `some` (21)

**Calls:**
- `get parent` (2)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1211` | Self: 1.1% (26.8ms) | Total: 6.6% (149.9ms) | Samples: 17

**Called by:**
- `_buildReference` (72)
- `_findDefNode` (11)
- `_computeIsStrict` (7)
- `isUnusedExpression` (3)
- `_computeVarDefs` (3)
- `getUpperFunction` (1)
- `isForInOfRef` (1)
- `_computeIsStrict` (1)
- `_findDefNode` (1)
- `_findDefNode` (1)

**Calls:**
- `nodeView` (80)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)
- `nodeView` (1)

### `/\/\*([\s\S]*?)\*\//g`
`[native code]` | Self: 1.1% (25.9ms) | Total: 1.1% (25.9ms) | Samples: 17

**Called by:**
- `_buildScopeVarsAndSet` (15)
- `exec` (2)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1710` | Self: 1.1% (25.4ms) | Total: 1.3% (31.3ms) | Samples: 18

**Called by:**
- `_computeIsStrict` (22)

**Calls:**
- `nodeRhs` (3)
- `getUint32` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4100` | Self: 1.0% (24.3ms) | Total: 1.0% (24.3ms) | Samples: 17

**Called by:**
- `nodeView` (9)
- `_buildReference` (4)
- `get body` (2)
- `_buildScope` (1)
- `get parent` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:802` | Self: 0.9% (21.7ms) | Total: 2.5% (56.3ms) | Samples: 15

**Called by:**
- `collectUnusedVariables` (24)
- `(anonymous)` (12)
- `_buildScopeVarsAndSet` (1)
- `isUsedVariable` (1)

**Calls:**
- `_computeVariableSynthRefs` (10)
- `_computeVariableSynthRefs` (8)
- `_computeVariableSynthRefs` (3)
- `_computeVariableSynthRefs` (1)
- `_computeVariableSynthRefs` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:615` | Self: 0.8% (19.2ms) | Total: 0.8% (19.2ms) | Samples: 13

**Called by:**
- `_precomputeScopes` (13)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2277` | Self: 0.8% (19.1ms) | Total: 0.8% (19.1ms) | Samples: 13

**Called by:**
- `_ensureVarsSet` (13)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4111` | Self: 0.8% (18.0ms) | Total: 0.8% (18.0ms) | Samples: 11

**Called by:**
- `nodeView` (11)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1317` | Self: 0.7% (17.6ms) | Total: 0.7% (17.6ms) | Samples: 12

**Called by:**
- `_buildReference` (7)
- `_findDefNode` (2)
- `_computeVarDefs` (1)
- `isReadForItself` (1)
- `getRhsNode` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2141` | Self: 0.7% (17.6ms) | Total: 6.0% (134.8ms) | Samples: 12

**Called by:**
- `_buildReference` (45)
- `_buildScope` (28)
- `_buildScopeChildren` (18)

**Calls:**
- `_computeIsStrict` (65)
- `_computeIsStrict` (9)
- `_computeIsStrict` (3)
- `_computeIsStrict` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4110` | Self: 0.7% (17.3ms) | Total: 0.7% (17.3ms) | Samples: 12

**Called by:**
- `nodeView` (10)
- `nodeViewChain` (2)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.7% (16.5ms) | Total: 0.7% (16.5ms) | Samples: 11

**Called by:**
- `_nodeViewRaw` (11)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2283` | Self: 0.6% (15.6ms) | Total: 0.6% (15.6ms) | Samples: 11

**Called by:**
- `_ensureVarsSet` (11)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3213` | Self: 0.6% (14.8ms) | Total: 0.6% (14.8ms) | Samples: 9

**Called by:**
- `getDeclaredVariables` (9)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.6% (14.8ms) | Total: 0.6% (14.8ms) | Samples: 10

**Called by:**
- `_computeVarDefs` (3)
- `_computeIsStrict` (2)
- `_findDefNode` (2)
- `collectUnusedVariables` (1)
- `isForInOfRef` (1)
- `isForInOfRef` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1250` | Self: 0.6% (14.7ms) | Total: 0.7% (17.8ms) | Samples: 10

**Called by:**
- `_buildReference` (8)
- `(anonymous)` (2)
- `_findDefNode` (2)

**Calls:**
- `get value` (2)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` | Self: 0.6% (14.5ms) | Total: 0.7% (15.8ms) | Samples: 10

**Called by:**
- `(anonymous)` (11)

**Calls:**
- `get parent` (1)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:855` | Self: 0.6% (13.9ms) | Total: 0.6% (13.9ms) | Samples: 9

**Called by:**
- `_symName` (9)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:467` | Self: 0.6% (13.6ms) | Total: 0.6% (13.6ms) | Samples: 9

**Called by:**
- `getRhsNode` (9)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:808` | Self: 0.6% (13.5ms) | Total: 22.1% (497.1ms) | Samples: 9

**Called by:**
- `collectUnusedVariables` (271)
- `(anonymous)` (46)
- `isUsedVariable` (10)
- `_buildScopeVarsAndSet` (2)
- `_computeDeclaredVariables` (1)

**Calls:**
- `_buildReference` (124)
- `_buildReference` (82)
- `_buildReference` (62)
- `_buildReference` (30)
- `_buildReference` (9)
- `_buildReference` (8)
- `_buildReference` (5)
- `_buildReference` (1)

### `_Reference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:236` | Self: 0.5% (13.2ms) | Total: 0.5% (13.2ms) | Samples: 9

**Called by:**
- `_buildReference` (9)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2269` | Self: 0.5% (12.6ms) | Total: 0.6% (14.3ms) | Samples: 8

**Called by:**
- `_ensureVarsSet` (9)

**Calls:**
- `Map` (1)

### `getUint32`
`[native code]` | Self: 0.5% (12.3ms) | Total: 0.5% (12.3ms) | Samples: 8

**Called by:**
- `get body` (4)
- `_isChainNode` (1)
- `get directive` (1)
- `init` (1)
- `get body` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2883` | Self: 0.5% (12.3ms) | Total: 8.2% (184.9ms) | Samples: 8

**Called by:**
- `get references` (124)

**Calls:**
- `_buildScope` (45)
- `_buildScope` (39)
- `_buildScope` (21)
- `_buildScope` (8)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2482` | Self: 0.5% (11.7ms) | Total: 0.5% (11.7ms) | Samples: 7

**Called by:**
- `_ensureVarsSet` (7)

### `arrayIteratorNextHelper`
`[native code]` | Self: 0.5% (11.7ms) | Total: 0.8% (19.6ms) | Samples: 8

**Called by:**
- `next` (13)

**Calls:**
- `typedArrayViewLength` (5)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` | Self: 0.5% (11.4ms) | Total: 0.5% (11.4ms) | Samples: 8

**Called by:**
- `_computeIsStrict` (8)

### `decode`
`[native code]` | Self: 0.4% (11.1ms) | Total: 0.4% (11.1ms) | Samples: 7

**Called by:**
- `get source` (7)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2640` | Self: 0.4% (9.9ms) | Total: 0.4% (9.9ms) | Samples: 6

**Called by:**
- `_ensureChildren` (6)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:902` | Self: 0.4% (9.8ms) | Total: 0.4% (9.8ms) | Samples: 7

**Called by:**
- `get body` (7)

### `typedArrayViewIsDetached`
`[native code]` | Self: 0.4% (9.6ms) | Total: 0.4% (9.6ms) | Samples: 7

**Called by:**
- `next` (7)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.4% (9.5ms) | Total: 0.4% (9.5ms) | Samples: 6

**Called by:**
- `_buildScopeVarsAndSet` (5)
- `_computeDeclaredVariables` (1)

### `_Variable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:847` | Self: 0.4% (9.2ms) | Total: 0.4% (9.2ms) | Samples: 6

**Called by:**
- `_buildVariable` (6)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2826` | Self: 0.4% (9.1ms) | Total: 0.4% (9.1ms) | Samples: 6

**Called by:**
- `defs` (6)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2106` | Self: 0.4% (9.0ms) | Total: 0.4% (9.0ms) | Samples: 6

**Called by:**
- `_buildScope` (4)
- `_computeVarScope` (1)
- `_buildScopeChildren` (1)

### `anonymous`
`[native code]` | Self: 0.4% (8.9ms) | Total: 2.5% (56.7ms) | Samples: 6

**Called by:**
- `require` (33)
- `internal:shared` (1)
- `internal:validators` (1)
- `bound require` (1)
- `node:fs` (1)
- `node:events` (1)

**Calls:**
- `(anonymous)` (7)
- `(anonymous)` (5)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `internal:shared` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:fs` (1)
- `internal:primordials` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:validators` (1)
- `node:events` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2934` | Self: 0.3% (8.6ms) | Total: 0.6% (14.5ms) | Samples: 6

**Called by:**
- `get references` (10)

**Calls:**
- `nodeView` (3)
- `nodeView` (1)

### `defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:769` | Self: 0.3% (8.2ms) | Total: 3.9% (88.8ms) | Samples: 5

**Called by:**
- `collectUnusedVariables` (51)
- `identifiers` (3)
- `isAfterLastUsedArg` (2)
- `_ensureVarsSet` (1)
- `get identifiers` (1)

**Calls:**
- `_computeVarDefs` (24)
- `_computeVarDefs` (13)
- `_computeVarDefs` (10)
- `_computeVarDefs` (6)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7233` | Self: 0.3% (8.1ms) | Total: 0.3% (8.1ms) | Samples: 5

**Called by:**
- `runPlugins` (5)

### `typedArrayViewLength`
`[native code]` | Self: 0.3% (7.8ms) | Total: 0.3% (7.8ms) | Samples: 5

**Called by:**
- `arrayIteratorNextHelper` (5)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.3% (7.8ms) | Total: 0.3% (7.8ms) | Samples: 5

**Called by:**
- `get references` (5)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` | Self: 0.3% (7.8ms) | Total: 0.3% (7.8ms) | Samples: 5

**Called by:**
- `collectUnusedVariables` (5)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` | Self: 0.3% (7.8ms) | Total: 0.4% (10.8ms) | Samples: 5

**Called by:**
- `(anonymous)` (7)

**Calls:**
- `get parent` (1)
- `get parent` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.3% (7.7ms) | Total: 0.3% (7.7ms) | Samples: 5

**Called by:**
- `commentsInRange` (3)
- `commentsInRange` (2)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3187` | Self: 0.3% (7.6ms) | Total: 0.3% (7.6ms) | Samples: 5

**Called by:**
- `getDeclaredVariables` (5)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2267` | Self: 0.3% (7.4ms) | Total: 1.0% (24.3ms) | Samples: 5

**Called by:**
- `_ensureVarsSet` (16)

**Calls:**
- `_ensureDeclSymIndex` (9)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` | Self: 0.3% (7.4ms) | Total: 0.3% (7.4ms) | Samples: 5

**Called by:**
- `isUsedVariable` (5)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2831` | Self: 0.3% (7.3ms) | Total: 0.8% (18.2ms) | Samples: 5

**Called by:**
- `defs` (10)
- `get defs` (2)

**Calls:**
- `get parent` (3)
- `get parent` (3)
- `get parent` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2374` | Self: 0.3% (7.3ms) | Total: 1.4% (33.2ms) | Samples: 5

**Called by:**
- `_ensureVarsSet` (22)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (15)
- `exec` (2)

### `subarray`
`[native code]` | Self: 0.3% (7.1ms) | Total: 0.3% (7.1ms) | Samples: 5

**Called by:**
- `_computeDeclaredVariables` (5)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2486` | Self: 0.2% (6.4ms) | Total: 0.2% (6.4ms) | Samples: 4

**Called by:**
- `_ensureVarsSet` (4)

### `nodeRhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:570` | Self: 0.2% (6.4ms) | Total: 0.2% (6.4ms) | Samples: 4

**Called by:**
- `get body` (3)
- `init` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2751` | Self: 0.2% (6.4ms) | Total: 0.2% (6.4ms) | Samples: 4

**Called by:**
- `_buildReference` (3)
- `_buildScopeVarsAndSet` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2125` | Self: 0.2% (6.3ms) | Total: 0.8% (19.1ms) | Samples: 4

**Called by:**
- `_buildReference` (8)
- `_buildScope` (4)
- `_buildScopeChildren` (1)

**Calls:**
- `nodeView` (6)
- `nodeView` (2)
- `_nodeViewRaw` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2171` | Self: 0.2% (6.2ms) | Total: 0.2% (6.2ms) | Samples: 4

**Called by:**
- `_buildScopeChildren` (2)
- `_buildScope` (1)
- `_buildReference` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2752` | Self: 0.2% (6.1ms) | Total: 0.2% (6.1ms) | Samples: 4

**Called by:**
- `_buildScopeVarsAndSet` (4)

### `_computeVarScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2847` | Self: 0.2% (6.0ms) | Total: 0.5% (12.1ms) | Samples: 4

**Called by:**
- `scope` (7)
- `get scope` (1)

**Calls:**
- `_buildScope` (3)
- `_buildScope` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2879` | Self: 0.2% (5.9ms) | Total: 0.5% (12.4ms) | Samples: 4

**Called by:**
- `get references` (8)

**Calls:**
- `_buildVariable` (3)
- `_buildVariable` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2276` | Self: 0.2% (5.8ms) | Total: 1.3% (30.7ms) | Samples: 4

**Called by:**
- `_ensureVarsSet` (20)

**Calls:**
- `_buildVariable` (6)
- `_buildVariable` (5)
- `_buildVariable` (4)
- `_buildVariable` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1191` | Self: 0.2% (5.8ms) | Total: 0.2% (5.8ms) | Samples: 4

**Called by:**
- `_findDefNode` (2)
- `collectUnusedVariables` (1)
- `_buildReference` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3206` | Self: 0.2% (5.8ms) | Total: 0.2% (5.8ms) | Samples: 4

**Called by:**
- `getDeclaredVariables` (4)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:614` | Self: 0.2% (5.7ms) | Total: 0.2% (5.7ms) | Samples: 4

**Called by:**
- `_precomputeScopes` (4)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` | Self: 0.2% (5.7ms) | Total: 21.5% (483.3ms) | Samples: 4

**Called by:**
- `collectUnusedVariables` (321)

**Calls:**
- `get references` (271)
- `get references` (24)
- `some` (21)
- `get references` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3881` | Self: 0.2% (5.1ms) | Total: 0.2% (5.1ms) | Samples: 3

**Called by:**
- `report` (3)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:497` | Self: 0.2% (5.0ms) | Total: 1.4% (33.1ms) | Samples: 3

**Called by:**
- `_computeVarDefs` (22)

**Calls:**
- `get parent` (11)
- `get parent` (2)
- `get parent` (2)
- `get parent` (2)
- `get parent` (2)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.2% (4.9ms) | Total: 0.2% (4.9ms) | Samples: 3

**Called by:**
- `get references` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7060` | Self: 0.2% (4.9ms) | Total: 0.2% (4.9ms) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2872` | Self: 0.2% (4.8ms) | Total: 4.3% (97.0ms) | Samples: 3

**Called by:**
- `get references` (62)

**Calls:**
- `nodeView` (54)
- `_nodeViewRaw` (4)
- `nodeView` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6515` | Self: 0.2% (4.7ms) | Total: 0.2% (4.7ms) | Samples: 3

**Called by:**
- `walkNodes` (3)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2876` | Self: 0.2% (4.7ms) | Total: 5.4% (122.2ms) | Samples: 3

**Called by:**
- `get references` (82)
- `_ensureVarsSet` (1)

**Calls:**
- `get parent` (72)
- `get parent` (8)

### `test`
`[native code]` | Self: 0.2% (4.7ms) | Total: 0.2% (6.4ms) | Samples: 3

**Called by:**
- `_precomputeScopes` (4)

**Calls:**
- `/^\s*exported\b/` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` | Self: 0.2% (4.6ms) | Total: 0.3% (7.7ms) | Samples: 3

**Called by:**
- `collectUnusedVariables` (5)

**Calls:**
- `get parent` (1)
- `get parent` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` | Self: 0.2% (4.5ms) | Total: 6.2% (139.9ms) | Samples: 3

**Called by:**
- `collectUnusedVariables` (82)
- `Program:exit` (11)

**Calls:**
- `isUsedVariable` (40)
- `some` (27)
- `isUsedVariable` (23)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1736` | Self: 0.1% (4.4ms) | Total: 0.1% (4.4ms) | Samples: 3

**Called by:**
- `_computeIsStrict` (3)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4132` | Self: 0.1% (4.4ms) | Total: 0.1% (4.4ms) | Samples: 3

**Called by:**
- `_buildScope` (2)
- `get parent` (1)

### `from`
`[native code]` | Self: 0.1% (4.3ms) | Total: 0.6% (15.4ms) | Samples: 3

**Called by:**
- `_computeDeclaredVariables` (11)

**Calls:**
- `next` (8)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3136` | Self: 0.1% (3.9ms) | Total: 0.1% (3.9ms) | Samples: 2

**Called by:**
- `isAfterLastUsedArg` (2)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6517` | Self: 0.1% (3.8ms) | Total: 0.1% (3.8ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `/^\s*exported\b/`
`[native code]` | Self: 0.1% (3.5ms) | Total: 0.1% (3.5ms) | Samples: 2

**Called by:**
- `test` (1)
- `_precomputeScopes` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (3.4ms) | Total: 0.1% (3.4ms) | Samples: 2

**Called by:**
- `_computeVariableSynthRefs` (1)
- `_buildReference` (1)

### `encodeInto`
`[native code]` | Self: 0.1% (3.3ms) | Total: 0.1% (3.3ms) | Samples: 2

**Called by:**
- `_encodeSource` (2)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:656` | Self: 0.1% (3.3ms) | Total: 0.1% (3.3ms) | Samples: 2

**Called by:**
- `commentsInRange` (2)

### `push`
`[native code]` | Self: 0.1% (3.2ms) | Total: 0.1% (3.2ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (1)
- `_computeDeclaredVariables` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2375` | Self: 0.1% (3.2ms) | Total: 0.1% (3.2ms) | Samples: 2

**Called by:**
- `_ensureVarsSet` (2)

### `extraArrowData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:713` | Self: 0.1% (3.2ms) | Total: 0.1% (3.2ms) | Samples: 2

**Called by:**
- `get body` (2)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1709` | Self: 0.1% (3.2ms) | Total: 0.4% (9.4ms) | Samples: 2

**Called by:**
- `_computeIsStrict` (6)

**Calls:**
- `getUint32` (4)

### `map`
`[native code]` | Self: 0.1% (3.1ms) | Total: 0.1% (3.1ms) | Samples: 2

**Called by:**
- `isAfterLastUsedArg` (1)
- `_computeDeclaredVariables` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4344` | Self: 0.1% (3.1ms) | Total: 0.1% (3.1ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2266` | Self: 0.1% (3.1ms) | Total: 0.1% (3.1ms) | Samples: 2

**Called by:**
- `_ensureVarsSet` (2)

### `_isChainNode`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3924` | Self: 0.1% (3.1ms) | Total: 0.2% (4.9ms) | Samples: 2

**Called by:**
- `nodeViewChain` (3)

**Calls:**
- `getUint32` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` | Self: 0.1% (3.1ms) | Total: 0.2% (4.4ms) | Samples: 2

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `get parent` (1)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (3.0ms) | Total: 0.1% (3.0ms) | Samples: 2

**Called by:**
- `_nodeViewRaw` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2279` | Self: 0.1% (3.0ms) | Total: 0.3% (8.8ms) | Samples: 2

**Called by:**
- `_ensureVarsSet` (6)

**Calls:**
- `identifiers` (2)
- `get identifiers` (1)
- `push` (1)

### `isRead`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:220` | Self: 0.1% (3.0ms) | Total: 0.1% (3.0ms) | Samples: 2

**Called by:**
- `isReadForItself` (2)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2802` | Self: 0.1% (3.0ms) | Total: 0.8% (19.8ms) | Samples: 2

**Called by:**
- `defs` (13)

**Calls:**
- `nodeView` (11)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3672` | Self: 0.1% (3.0ms) | Total: 0.1% (3.0ms) | Samples: 2

**Called by:**
- `get value` (2)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` | Self: 0.1% (3.0ms) | Total: 0.4% (8.9ms) | Samples: 1

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `isRead` (2)
- `isRead` (2)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1249` | Self: 0.1% (3.0ms) | Total: 0.1% (3.0ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3133` | Self: 0.1% (3.0ms) | Total: 0.1% (3.0ms) | Samples: 2

**Called by:**
- `isAfterLastUsedArg` (2)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` | Self: 0.1% (2.9ms) | Total: 0.1% (2.9ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `DataView`
`[native code]` | Self: 0.1% (2.9ms) | Total: 0.1% (2.9ms) | Samples: 2

**Called by:**
- `AstView` (2)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2643` | Self: 0.1% (2.9ms) | Total: 1.7% (38.5ms) | Samples: 2

**Called by:**
- `_ensureChildren` (26)

**Calls:**
- `_buildScope` (18)
- `_buildScope` (2)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2222` | Self: 0.1% (2.9ms) | Total: 0.2% (4.6ms) | Samples: 2

**Called by:**
- `_buildScope` (3)

**Calls:**
- `get parent` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` | Self: 0.1% (2.9ms) | Total: 2.6% (60.5ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (40)

**Calls:**
- `some` (27)
- `get references` (10)
- `get references` (1)

### `isRead`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (2.8ms) | Total: 0.1% (2.8ms) | Samples: 2

**Called by:**
- `isReadForItself` (2)

### `_NodeView_LRN`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4051` | Self: 0.1% (2.8ms) | Total: 0.1% (2.8ms) | Samples: 2

**Called by:**
- `_nodeViewRaw` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` | Self: 0.1% (2.8ms) | Total: 12.1% (272.7ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (180)

**Calls:**
- `isAfterLastUsedArg` (112)
- `isAfterLastUsedArg` (59)
- `isAfterLastUsedArg` (5)
- `isAfterLastUsedArg` (2)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:891` | Self: 0.1% (2.8ms) | Total: 8.0% (181.5ms) | Samples: 2

**Called by:**
- `get` (117)
- `_ensureVarsSet` (2)

**Calls:**
- `_buildScopeVarsAndSet` (22)
- `_buildScopeVarsAndSet` (20)
- `_buildScopeVarsAndSet` (16)
- `_buildScopeVarsAndSet` (13)
- `_buildScopeVarsAndSet` (11)
- `_buildScopeVarsAndSet` (9)
- `_buildScopeVarsAndSet` (7)
- `_buildScopeVarsAndSet` (6)
- `_buildScopeVarsAndSet` (4)
- `_buildScopeVarsAndSet` (3)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2954` | Self: 0.1% (2.7ms) | Total: 0.1% (2.7ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7229` | Self: 0.1% (2.7ms) | Total: 0.1% (2.7ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `_ensureChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:970` | Self: 0.1% (2.5ms) | Total: 2.3% (52.7ms) | Samples: 2

**Called by:**
- `get` (35)

**Calls:**
- `_buildScopeChildren` (26)
- `_buildScopeChildren` (6)
- `_buildScopeChildren` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2284` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2647` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `_ensureChildren` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:659` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `commentsInRange` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` | Self: 0.0% (1.7ms) | Total: 0.1% (3.5ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (2)

**Calls:**
- `get eslintUsed` (1)

### `readdirSync`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.1% (3.5ms) | Samples: 1

**Called by:**
- `readdirSync` (1)
- `loadCoreRules` (1)

**Calls:**
- `readdirSync` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:109` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

### `dlopen`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:309` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

### `range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3630` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `get references` (1)

### `get eslintUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `get operator`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1339` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `isReadForItself` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2151` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3630` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `isInside` (1)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1074` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `Map`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `readFileSync`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.1% (3.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)
- `readFileSync` (1)

**Calls:**
- `readFileSync` (1)

### `join`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `parseSource` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2244` | Self: 0.0% (1.6ms) | Total: 0.1% (3.4ms) | Samples: 1

**Called by:**
- `_buildScope` (2)

**Calls:**
- `get directive` (1)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:839` | Self: 0.0% (1.6ms) | Total: 0.6% (15.6ms) | Samples: 1

**Called by:**
- `_ensureDeclSymIndex` (9)
- `_buildVariable` (1)

**Calls:**
- `_buildSymNameCache` (9)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `isFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3165` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3181` | Self: 0.0% (1.6ms) | Total: 0.2% (6.2ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (4)

**Calls:**
- `next` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:479` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `forEach` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` | Self: 0.0% (1.6ms) | Total: 10.9% (244.7ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (120)
- `Program:exit` (41)

**Calls:**
- `get` (119)
- `get` (35)
- `get` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn-jsx/xhtml.js:1` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `_isStatementTag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `range` (1)

### `require`
`[native code]` | Self: 0.0% (1.6ms) | Total: 2.3% (51.9ms) | Samples: 1

**Called by:**
- `bound require` (34)

**Calls:**
- `anonymous` (33)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `forEach` (1)

### `isSelfReference`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1525` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7234` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3143` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1223` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `isForInOfRef` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2854` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `performProxyObjectGet` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2199` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2042` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` | Self: 0.0% (1.5ms) | Total: 0.2% (6.4ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (4)

**Calls:**
- `get parent` (1)
- `get parent` (1)
- `isFunction` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2902` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `get references` (1)

### `next`
`[native code]` | Self: 0.0% (1.5ms) | Total: 1.3% (30.8ms) | Samples: 1

**Called by:**
- `Set` (10)
- `from` (8)
- `_computeDeclaredVariables` (3)

**Calls:**
- `arrayIteratorNextHelper` (13)
- `typedArrayViewIsDetached` (7)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2120` | Self: 0.0% (1.5ms) | Total: 5.2% (118.9ms) | Samples: 1

**Called by:**
- `_buildScope` (40)
- `_buildReference` (39)

**Calls:**
- `_buildScope` (40)
- `_buildScope` (28)
- `_buildScope` (4)
- `_buildScope` (4)
- `_buildScope` (1)
- `_buildScope` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3171` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2821` | Self: 0.0% (1.5ms) | Total: 1.7% (38.2ms) | Samples: 1

**Called by:**
- `defs` (24)
- `get defs` (1)

**Calls:**
- `_findDefNode` (22)
- `_findDefNode` (1)
- `_findDefNode` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4115` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `nodeView` (1)

### `extraMethodData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:732` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `get value` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:655` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:890` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` | Self: 0.0% (1.4ms) | Total: 7.5% (170.3ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (112)

**Calls:**
- `getDeclaredVariables` (105)
- `getDeclaredVariables` (2)
- `getDeclaredVariables` (2)
- `_computeDeclaredVariables` (1)
- `map` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2376` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3047` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get references` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1732` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:653` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `existsSync`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `existsSync` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` | Self: 0.0% (1.4ms) | Total: 1.1% (25.6ms) | Samples: 1

**Called by:**
- `some` (16)

**Calls:**
- `isReadForItself` (5)
- `isReadForItself` (3)
- `isReadForItself` (2)
- `isReadForItself` (1)
- `isReadForItself` (1)
- `isReadForItself` (1)
- `isReadForItself` (1)
- `isReadForItself` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1261` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1733` | Self: 0.0% (1.4ms) | Total: 0.2% (5.4ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (4)

**Calls:**
- `_nodeViewRaw` (2)
- `nodeView` (1)

### `_resolveUnicodeEscapes`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:236` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get name` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3026` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get references` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:617` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `get`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_ensureDeclSymIndex` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4044` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` | Self: 0.0% (1.3ms) | Total: 1.1% (26.5ms) | Samples: 1

**Called by:**
- `isUsedVariable` (18)

**Calls:**
- `forEach` (17)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `async _resolveConfigImpl` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `some` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` | Self: 0.0% (1.3ms) | Total: 0.6% (15.0ms) | Samples: 1

**Called by:**
- `(anonymous)` (10)

**Calls:**
- `isInLoop` (9)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2949` | Self: 0.0% (1.3ms) | Total: 0.5% (13.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (9)

**Calls:**
- `nodeViewChain` (4)
- `nodeViewChain` (3)
- `nodeViewChain` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:999` | Self: 0.0% (1.3ms) | Total: 8.0% (181.1ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (119)

**Calls:**
- `_ensureVarsSet` (117)
- `_ensureVarsSet` (1)

### `get right`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1821` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getRhsNode` (1)

### `get init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2943` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` | Self: 0.0% (1.2ms) | Total: 0.1% (2.5ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (2)

**Calls:**
- `get parent` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:613` | Self: 0.0% (1.2ms) | Total: 0.4% (9.7ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (6)

**Calls:**
- `_findLineIdx` (2)
- `_findLineIdx` (2)
- `_findLineIdx` (1)

### `(anonymous)`
`internal:primordials` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `forEach` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` | Self: 0.0% (1.2ms) | Total: 100.0% (4.52s) | Samples: 1

**Called by:**
- `collectUnusedVariables` (2211)
- `Program:exit` (773)

**Calls:**
- `collectUnusedVariables` (2211)
- `collectUnusedVariables` (321)
- `collectUnusedVariables` (180)
- `collectUnusedVariables` (120)
- `collectUnusedVariables` (82)
- `collectUnusedVariables` (52)
- `collectUnusedVariables` (5)
- `collectUnusedVariables` (4)
- `collectUnusedVariables` (3)
- `collectUnusedVariables` (2)
- `collectUnusedVariables` (2)
- `collectUnusedVariables` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` | Self: 0.0% (1.2ms) | Total: 0.1% (4.1ms) | Samples: 1

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `get parent` (1)
- `get parent` (1)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2948` | Self: 0.0% (1.2ms) | Total: 0.1% (4.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `nodeRhs` (1)
- `getUint32` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4108` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `nodeView` (1)

### `fill`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:776` | Self: 0.0% (1.2ms) | Total: 0.2% (4.8ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (3)

**Calls:**
- `identifiers` (1)
- `get identifiers` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:810` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `get name` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3211` | Self: 0.0% (1.2ms) | Total: 0.1% (4.2ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (3)

**Calls:**
- `get references` (1)
- `push` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4156` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `init` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:926` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `_buildReference` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3946` | Self: 0.0% (0us) | Total: 0.2% (5.1ms) | Samples: 0

**Called by:**
- `Program:exit` (3)

**Calls:**
- `_execReport` (3)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:435` | Self: 0.0% (0us) | Total: 0.3% (7.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `bound require` (5)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:503` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_computeVarDefs` (1)

**Calls:**
- `get parent` (1)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:47` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (1)

**Calls:**
- `readdirSync` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:478` | Self: 0.0% (0us) | Total: 0.1% (3.1ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `CfgGraph` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:661` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isInside` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` | Self: 0.0% (0us) | Total: 3.9% (88.7ms) | Samples: 0

**Called by:**
- `some` (59)

**Calls:**
- `get references` (46)
- `get references` (12)
- `get references` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:477` | Self: 0.0% (0us) | Total: 0.3% (7.6ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `patchAstUtils` (5)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7561` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `fill` (1)

### `internal:shared`
`internal:shared:2` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `some` (1)

**Calls:**
- `isSelfReference` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:300` | Self: 0.0% (0us) | Total: 32.9% (739.0ms) | Samples: 0

**Calls:**
- `parseSource` (480)
- `parseSource` (3)
- `parseSource` (2)
- `parseSource` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:561` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get right` (1)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:42` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (1)

**Calls:**
- `existsSync` (1)

### `makeSafe`
`internal:primordials:30` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `internal:primordials` (1)

**Calls:**
- `bound call` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:144` | Self: 0.0% (0us) | Total: 0.1% (3.2ms) | Samples: 0

**Calls:**
- `loadCoreRules` (1)
- `loadCoreRules` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:557` | Self: 0.0% (0us) | Total: 0.1% (4.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `isUnusedExpression` (3)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1507` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_buildScope` (1)

**Calls:**
- `extraMethodData` (1)

### `async lintSource`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:462` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `async lintSource` (1)

**Calls:**
- `async _resolveConfig` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2929` | Self: 0.0% (0us) | Total: 0.5% (12.1ms) | Samples: 0

**Called by:**
- `get references` (8)

**Calls:**
- `scope` (7)
- `get scope` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:905` | Self: 0.0% (0us) | Total: 0.8% (18.3ms) | Samples: 0

**Called by:**
- `get body` (12)

**Calls:**
- `nodeView` (10)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3147` | Self: 0.0% (0us) | Total: 0.3% (7.1ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (5)

**Calls:**
- `subarray` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` | Self: 0.0% (0us) | Total: 0.6% (15.1ms) | Samples: 0

**Called by:**
- `parseModule` (10)

**Calls:**
- `async (anonymous)` (10)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:612` | Self: 0.0% (0us) | Total: 0.1% (4.4ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (3)

**Calls:**
- `_findLineIdx` (3)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3135` | Self: 0.0% (0us) | Total: 7.0% (158.8ms) | Samples: 0

**Called by:**
- `isAfterLastUsedArg` (105)

**Calls:**
- `_computeDeclaredVariables` (36)
- `_computeDeclaredVariables` (23)
- `_computeDeclaredVariables` (11)
- `_computeDeclaredVariables` (9)
- `_computeDeclaredVariables` (5)
- `_computeDeclaredVariables` (5)
- `_computeDeclaredVariables` (4)
- `_computeDeclaredVariables` (4)
- `_computeDeclaredVariables` (3)
- `_computeDeclaredVariables` (1)
- `_computeDeclaredVariables` (1)
- `_computeDeclaredVariables` (1)
- `_computeDeclaredVariables` (1)
- `_computeDeclaredVariables` (1)

### `async lintSource`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:461` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `async lintSource` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:304` | Self: 0.0% (0us) | Total: 65.8% (1.47s) | Samples: 0

**Calls:**
- `runPlugins` (964)
- `runPlugins` (7)
- `runPlugins` (1)
- `runPlugins` (1)

### `internal:primordials`
`internal:primordials:71` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `makeSafe` (1)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` | Self: 0.0% (0us) | Total: 0.4% (11.1ms) | Samples: 0

**Called by:**
- `runPlugins` (6)
- `runPlugins` (1)

**Calls:**
- `decode` (7)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2731` | Self: 0.0% (0us) | Total: 0.3% (8.2ms) | Samples: 0

**Called by:**
- `getScope` (5)

**Calls:**
- `test` (4)
- `/^\s*exported\b/` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2067` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `get` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2727` | Self: 0.0% (0us) | Total: 1.8% (40.5ms) | Samples: 0

**Called by:**
- `getScope` (27)

**Calls:**
- `commentsInRange` (13)
- `commentsInRange` (6)
- `commentsInRange` (4)
- `commentsInRange` (3)
- `commentsInRange` (1)

### `some`
`[native code]` | Self: 0.0% (0us) | Total: 9.0% (202.2ms) | Samples: 0

**Called by:**
- `isAfterLastUsedArg` (59)
- `collectUnusedVariables` (27)
- `isUsedVariable` (27)
- `collectUnusedVariables` (21)

**Calls:**
- `(anonymous)` (59)
- `(anonymous)` (26)
- `(anonymous)` (21)
- `(anonymous)` (16)
- `(anonymous)` (10)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` | Self: 0.0% (0us) | Total: 2.1% (48.8ms) | Samples: 0

**Called by:**
- `_invokeFused` (32)

**Calls:**
- `getScope` (32)

### `async _resolveConfig`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:68` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `async lintSource` (1)

**Calls:**
- `async _resolveConfig` (1)

### `bound call`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `makeSafe` (1)

**Calls:**
- `forEach` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:927` | Self: 0.0% (0us) | Total: 0.1% (2.6ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (2)

**Calls:**
- `get name` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2755` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_buildReference` (1)

**Calls:**
- `_symName` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7057` | Self: 0.0% (0us) | Total: 0.3% (8.6ms) | Samples: 0

**Called by:**
- `runPlugins` (5)

**Calls:**
- `getDFSEvents` (3)
- `getDFSEvents` (2)

### `scope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:764` | Self: 0.0% (0us) | Total: 0.4% (10.7ms) | Samples: 0

**Called by:**
- `_computeVariableSynthRefs` (7)

**Calls:**
- `_computeVarScope` (7)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4713` | Self: 0.0% (0us) | Total: 58.0% (1.30s) | Samples: 0

**Called by:**
- `walkNodes` (860)

**Calls:**
- `Program:exit` (825)
- `Program:exit` (32)
- `Program:exit` (3)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:662` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isInsideOfStorableFunction` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:538` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `_computeVarDefs` (1)

**Calls:**
- `get parent` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7576` | Self: 0.0% (0us) | Total: 0.0% (1.1ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `get source` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:221` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `join` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:752` | Self: 0.0% (0us) | Total: 3.9% (88.7ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (59)

**Calls:**
- `some` (59)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js:133` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:901` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `defs` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1367` | Self: 0.0% (0us) | Total: 0.1% (2.6ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (2)

**Calls:**
- `_identAt` (1)
- `_resolveUnicodeEscapes` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7573` | Self: 0.0% (0us) | Total: 0.5% (11.4ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (7)

**Calls:**
- `get source` (6)
- `reset` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` | Self: 0.0% (0us) | Total: 0.6% (15.0ms) | Samples: 0

**Called by:**
- `some` (10)

**Calls:**
- `isForInOfRef` (7)
- `isForInOfRef` (3)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:215` | Self: 0.0% (0us) | Total: 0.1% (3.3ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (2)

**Calls:**
- `_encodeSource` (2)

### `async _resolveConfig`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:71` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `async _resolveConfig` (1)

**Calls:**
- `async _resolveConfigImpl` (1)

### `isInsideOfStorableFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:630` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `isReadForItself` (1)

**Calls:**
- `getUpperFunction` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` | Self: 0.0% (0us) | Total: 0.1% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` | Self: 0.0% (0us) | Total: 0.6% (15.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (10)

**Calls:**
- `async (anonymous)` (9)
- `async (anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` | Self: 0.0% (0us) | Total: 0.2% (6.1ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (3)

**Calls:**
- `AstView` (2)
- `AstView` (1)

### `get directive`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3378` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `getUint32` (1)

### `existsSync`
`node:fs:273` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `loadCoreRules` (1)

**Calls:**
- `existsSync` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` | Self: 0.0% (0us) | Total: 0.1% (2.7ms) | Samples: 0

**Called by:**
- `forEach` (2)

**Calls:**
- `init` (2)

### `identifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:775` | Self: 0.0% (0us) | Total: 0.1% (4.4ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (2)
- `collectUnusedVariables` (1)

**Calls:**
- `defs` (3)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3201` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (1)

**Calls:**
- `_buildVariable` (1)

### `get identifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:775` | Self: 0.0% (0us) | Total: 0.2% (5.0ms) | Samples: 0

**Called by:**
- `_computeDeclaredVariables` (1)
- `_buildScopeVarsAndSet` (1)
- `collectUnusedVariables` (1)

**Calls:**
- `get defs` (2)
- `defs` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7297` | Self: 0.0% (0us) | Total: 58.0% (1.30s) | Samples: 0

**Called by:**
- `runPlugins` (860)

**Calls:**
- `_invokeFused` (860)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1003` | Self: 0.0% (0us) | Total: 2.3% (52.7ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (35)

**Calls:**
- `_ensureChildren` (35)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:35` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `readFileSync` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` | Self: 0.0% (0us) | Total: 0.2% (5.1ms) | Samples: 0

**Called by:**
- `_invokeFused` (3)

**Calls:**
- `report` (3)

### `forEach`
`[native code]` | Self: 0.0% (0us) | Total: 1.1% (26.4ms) | Samples: 0

**Called by:**
- `getFunctionDefinitions` (17)
- `bound call` (1)

**Calls:**
- `(anonymous)` (13)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1018` | Self: 0.0% (0us) | Total: 0.4% (9.0ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (6)

**Calls:**
- `_ensureVarsSet` (6)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:74` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `async lintSource` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:822` | Self: 0.0% (0us) | Total: 0.1% (3.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)
- `collectUnusedVariables` (1)

**Calls:**
- `range` (1)
- `range` (1)

### `getUpperFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:132` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `isInsideOfStorableFunction` (1)

**Calls:**
- `get parent` (1)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.8% (19.7ms) | Samples: 0

**Calls:**
- `parseModule` (13)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1013` | Self: 0.0% (0us) | Total: 0.4% (9.0ms) | Samples: 0

**Called by:**
- `get` (6)

**Calls:**
- `_ensureVarsSet` (2)
- `_ensureVarsSet` (2)
- `_ensureVarsSet` (1)
- `_ensureVarsSet` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` | Self: 0.0% (0us) | Total: 55.6% (1.24s) | Samples: 0

**Called by:**
- `_invokeFused` (825)

**Calls:**
- `collectUnusedVariables` (773)
- `collectUnusedVariables` (41)
- `collectUnusedVariables` (11)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1516` | Self: 0.0% (0us) | Total: 0.1% (3.0ms) | Samples: 0

**Called by:**
- `get parent` (2)

**Calls:**
- `get loc` (2)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4162` | Self: 0.0% (0us) | Total: 0.2% (4.9ms) | Samples: 0

**Called by:**
- `init` (3)

**Calls:**
- `_isChainNode` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` | Self: 0.0% (0us) | Total: 1.6% (37.9ms) | Samples: 0

**Called by:**
- `some` (26)

**Calls:**
- `getRhsNode` (11)
- `getRhsNode` (10)
- `getRhsNode` (3)
- `getRhsNode` (1)
- `getRhsNode` (1)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 2.4% (55.0ms) | Samples: 0

**Called by:**
- `async (anonymous)` (9)
- `(anonymous)` (7)
- `patchAstUtils` (5)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `loadBinding` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `require` (34)
- `(anonymous)` (1)
- `anonymous` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` | Self: 0.0% (0us) | Total: 32.4% (727.8ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (480)

**Calls:**
- `parse` (480)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2907` | Self: 0.0% (0us) | Total: 0.5% (13.2ms) | Samples: 0

**Called by:**
- `get references` (9)

**Calls:**
- `_Reference` (9)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` | Self: 0.0% (0us) | Total: 3.5% (79.5ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (52)

**Calls:**
- `defs` (51)
- `get defs` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` | Self: 0.0% (0us) | Total: 0.4% (10.6ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2135` | Self: 0.0% (0us) | Total: 0.1% (3.0ms) | Samples: 0

**Called by:**
- `_buildScope` (1)
- `_buildReference` (1)

**Calls:**
- `get value` (1)
- `get value` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1713` | Self: 0.0% (0us) | Total: 1.2% (28.2ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (19)

**Calls:**
- `_nodesFromRange` (12)
- `_nodesFromRange` (7)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3177` | Self: 0.0% (0us) | Total: 2.4% (54.9ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (36)

**Calls:**
- `Set` (36)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:543` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `performProxyObjectGet` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:656` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get operator` (1)

### `loadBinding`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `getTagNames` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `parseModule` (2)

**Calls:**
- `bound require` (2)

### `performProxyObjectGet`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `getRhsNode` (1)

**Calls:**
- `get` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2782` | Self: 0.0% (0us) | Total: 0.4% (9.2ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (6)

**Calls:**
- `_Variable` (6)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2240` | Self: 0.0% (0us) | Total: 4.2% (95.0ms) | Samples: 0

**Called by:**
- `_buildScope` (65)

**Calls:**
- `get body` (22)
- `get body` (19)
- `get body` (8)
- `get body` (6)
- `get body` (4)
- `get body` (3)
- `get body` (2)
- `get body` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4165` | Self: 0.0% (0us) | Total: 0.2% (5.7ms) | Samples: 0

**Called by:**
- `init` (4)

**Calls:**
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (2)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:747` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (2)

**Calls:**
- `defs` (2)

### `exec`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (3.1ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (2)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (2)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:72` | Self: 0.0% (0us) | Total: 0.6% (13.7ms) | Samples: 0

**Called by:**
- `async (anonymous)` (9)

**Calls:**
- `bound require` (9)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3225` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (1)

**Calls:**
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.1% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` | Self: 0.0% (0us) | Total: 1.5% (33.9ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (23)

**Calls:**
- `getFunctionDefinitions` (18)
- `getFunctionDefinitions` (5)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3209` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (1)

**Calls:**
- `get identifiers` (1)

### `get scope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:764` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_computeVariableSynthRefs` (1)

**Calls:**
- `_computeVarScope` (1)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1947` | Self: 0.0% (0us) | Total: 2.1% (48.8ms) | Samples: 0

**Called by:**
- `Program:exit` (32)

**Calls:**
- `_precomputeScopes` (27)
- `_precomputeScopes` (5)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2281` | Self: 0.0% (0us) | Total: 0.1% (4.2ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (3)

**Calls:**
- `get references` (2)
- `get references` (1)

### `parseModule`
`[native code]` | Self: 0.0% (0us) | Total: 0.8% (19.7ms) | Samples: 0

**Called by:**
- `async (anonymous)` (13)

**Calls:**
- `(anonymous)` (10)
- `(anonymous)` (2)
- `(anonymous)` (1)

### `node:events`
`node:events:9` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:76` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `async _resolveConfig` (1)

**Calls:**
- `async _resolveConfigImpl` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.1% (4.4ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `getTagNames`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:186` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `loadBinding` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` | Self: 0.0% (0us) | Total: 0.8% (19.0ms) | Samples: 0

**Called by:**
- `forEach` (13)

**Calls:**
- `init` (9)
- `init` (3)
- `get init` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2221` | Self: 0.0% (0us) | Total: 0.6% (14.0ms) | Samples: 0

**Called by:**
- `_buildScope` (9)

**Calls:**
- `get parent` (7)
- `get parent` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn-jsx/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4106` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_nodesFromRange` (1)

**Calls:**
- `_computeNodeType` (1)

### `(anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `bound require` (1)

**Calls:**
- `dlopen` (1)

### `range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3610` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `get references` (1)

**Calls:**
- `_isStatementTag` (1)

### `get defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:769` | Self: 0.0% (0us) | Total: 0.2% (4.9ms) | Samples: 0

**Called by:**
- `get identifiers` (2)
- `collectUnusedVariables` (1)

**Calls:**
- `_computeVarDefs` (2)
- `_computeVarDefs` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:286` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `parseSource` (2)

**Calls:**
- `DataView` (2)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:288` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Calls:**
- `getTagNames` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2065` | Self: 0.0% (0us) | Total: 0.6% (13.9ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (9)

**Calls:**
- `_symName` (9)

### `isUnusedExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:506` | Self: 0.0% (0us) | Total: 0.1% (4.1ms) | Samples: 0

**Called by:**
- `getRhsNode` (3)

**Calls:**
- `get parent` (3)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1735` | Self: 0.0% (0us) | Total: 0.1% (3.2ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (2)

**Calls:**
- `extraArrowData` (2)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3179` | Self: 0.0% (0us) | Total: 0.6% (15.4ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (11)

**Calls:**
- `from` (11)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `internal:validators`
`internal:validators:2` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7581` | Self: 0.0% (0us) | Total: 65.1% (1.46s) | Samples: 0

**Called by:**
- `_lintSourceOne` (964)

**Calls:**
- `walkNodes` (860)
- `walkNodes` (64)
- `walkNodes` (23)
- `walkNodes` (5)
- `walkNodes` (5)
- `walkNodes` (3)
- `walkNodes` (2)
- `walkNodes` (1)
- `walkNodes` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4137` | Self: 0.0% (0us) | Total: 11.0% (247.5ms) | Samples: 0

**Called by:**
- `get parent` (80)
- `_buildReference` (54)
- `_computeVarDefs` (11)
- `_nodesFromRange` (10)
- `_buildScope` (6)
- `_computeVariableSynthRefs` (3)
- `get body` (1)

**Calls:**
- `_nodeViewRaw` (133)
- `_nodeViewRaw` (11)
- `_nodeViewRaw` (10)
- `_nodeViewRaw` (9)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `isInside`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:494` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `isReadForItself` (1)

**Calls:**
- `get range` (1)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:92` | Self: 0.0% (0us) | Total: 0.1% (3.3ms) | Samples: 0

**Called by:**
- `parseSource` (2)

**Calls:**
- `encodeInto` (2)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 40.2% | 903.9ms | `[native code]` |
| 30.5% | 686.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 23.1% | 519.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 5.4% | 122.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.2% | 4.9ms | `/Users/ericsan/Development/OpenSource/Ez/js/api.js` |
| 0.0% | 1.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` |
| 0.0% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn-jsx/xhtml.js` |
| 0.0% | 1.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.2ms | `internal:primordials` |
