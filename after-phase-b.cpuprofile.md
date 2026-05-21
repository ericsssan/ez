# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 1.29s | 851 | 1.0ms | 291 |

**Top 10:** `parse` 30.9%, `walkNodes` 4.5%, `_NodeView` 3.2%, `_NodeView_LR` 2.2%, `_nodeViewRaw` 2.0%, `Set` 1.8%, `_buildReference` 1.8%, `_buildScopeVarsAndSet` 1.6%, `walkNodes` 1.6%, `_buildScope` 1.4%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 30.9% | 401.0ms | 30.9% | 401.0ms | `parse` | `[native code]` |
| 4.5% | 59.0ms | 4.5% | 59.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7058` |
| 3.2% | 41.8ms | 3.2% | 41.8ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` |
| 2.2% | 29.2ms | 2.2% | 29.2ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4058` |
| 2.0% | 26.5ms | 8.9% | 116.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 1.8% | 24.5ms | 2.6% | 33.8ms | `Set` | `[native code]` |
| 1.8% | 23.7ms | 2.3% | 30.2ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2901` |
| 1.6% | 21.3ms | 1.8% | 24.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2283` |
| 1.6% | 20.8ms | 1.6% | 20.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6784` |
| 1.4% | 18.2ms | 1.4% | 18.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2161` |
| 1.3% | 18.1ms | 4.3% | 56.1ms | `anonymous` | `[native code]` |
| 1.3% | 17.3ms | 6.5% | 84.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1211` |
| 1.2% | 16.7ms | 1.2% | 16.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2277` |
| 1.1% | 15.4ms | 1.1% | 15.4ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 1.1% | 14.5ms | 1.1% | 14.5ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3207` |
| 1.0% | 14.0ms | 1.3% | 16.8ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1710` |
| 1.0% | 13.9ms | 1.0% | 13.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4110` |
| 0.9% | 12.2ms | 0.9% | 12.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4100` |
| 0.9% | 12.2ms | 0.9% | 12.2ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2751` |
| 0.8% | 10.8ms | 0.8% | 10.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2486` |
| 0.8% | 10.8ms | 0.8% | 10.8ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 0.8% | 10.7ms | 0.8% | 10.7ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` |
| 0.7% | 10.2ms | 0.7% | 10.2ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.7% | 10.0ms | 0.7% | 10.0ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.7% | 9.3ms | 0.7% | 9.3ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:467` |
| 0.7% | 9.3ms | 7.5% | 98.3ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 0.7% | 9.2ms | 1.7% | 22.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2374` |
| 0.7% | 9.1ms | 5.8% | 75.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2141` |
| 0.6% | 8.6ms | 0.6% | 8.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3213` |
| 0.6% | 8.0ms | 0.7% | 9.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1250` |
| 0.5% | 7.6ms | 1.0% | 13.4ms | `arrayIteratorNextHelper` | `[native code]` |
| 0.5% | 7.5ms | 0.5% | 7.5ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4132` |
| 0.5% | 7.3ms | 0.5% | 7.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1191` |
| 0.5% | 6.9ms | 1.2% | 16.0ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2831` |
| 0.4% | 6.4ms | 8.6% | 111.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2883` |
| 0.4% | 6.3ms | 0.4% | 6.3ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:615` |
| 0.4% | 6.3ms | 0.4% | 6.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1317` |
| 0.4% | 6.2ms | 0.4% | 6.2ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` |
| 0.4% | 5.9ms | 0.4% | 5.9ms | `_Variable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:847` |
| 0.4% | 5.9ms | 0.4% | 5.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2482` |
| 0.4% | 5.8ms | 0.4% | 5.8ms | `_Reference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:236` |
| 0.4% | 5.8ms | 0.4% | 5.8ms | `typedArrayViewLength` | `[native code]` |
| 0.4% | 5.6ms | 1.9% | 25.0ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:802` |
| 0.4% | 5.5ms | 0.7% | 10.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 0.3% | 5.0ms | 0.3% | 5.0ms | `test` | `[native code]` |
| 0.3% | 5.0ms | 0.3% | 5.0ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.3% | 4.9ms | 0.4% | 6.3ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` |
| 0.3% | 4.8ms | 0.4% | 6.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` |
| 0.3% | 4.8ms | 0.3% | 4.8ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.3% | 4.7ms | 0.3% | 4.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7229` |
| 0.3% | 4.6ms | 0.3% | 4.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2269` |
| 0.3% | 4.6ms | 0.3% | 4.6ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.3% | 4.6ms | 0.4% | 6.4ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1733` |
| 0.3% | 4.4ms | 0.3% | 4.4ms | `decode` | `[native code]` |
| 0.3% | 4.4ms | 0.3% | 4.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7060` |
| 0.3% | 4.4ms | 0.3% | 4.4ms | `encodeInto` | `[native code]` |
| 0.3% | 4.3ms | 0.8% | 11.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3201` |
| 0.3% | 4.2ms | 0.8% | 11.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2125` |
| 0.3% | 4.2ms | 0.4% | 5.8ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:855` |
| 0.3% | 4.1ms | 0.4% | 5.4ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2934` |
| 0.3% | 4.0ms | 4.1% | 54.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2872` |
| 0.3% | 3.9ms | 0.3% | 3.9ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2752` |
| 0.2% | 3.7ms | 22.8% | 295.9ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:808` |
| 0.2% | 3.4ms | 0.2% | 3.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1261` |
| 0.2% | 3.3ms | 5.4% | 70.8ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2120` |
| 0.2% | 3.3ms | 1.1% | 15.1ms | `next` | `[native code]` |
| 0.2% | 3.3ms | 0.3% | 5.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 3.2ms | 21.1% | 273.9ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `set` | `[native code]` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 3.1ms | 2.3% | 29.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 0.2% | 3.1ms | 0.2% | 3.1ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2647` |
| 0.2% | 3.1ms | 0.2% | 3.1ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3206` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:236` |
| 0.2% | 3.0ms | 0.9% | 11.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2267` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1223` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2156` |
| 0.2% | 3.0ms | 11.4% | 148.4ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4051` |
| 0.2% | 2.9ms | 0.2% | 2.9ms | `DataView` | `[native code]` |
| 0.2% | 2.9ms | 0.5% | 7.3ms | `exec` | `[native code]` |
| 0.2% | 2.9ms | 0.2% | 2.9ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 2.8ms | 0.4% | 5.8ms | `from` | `[native code]` |
| 0.2% | 2.8ms | 0.4% | 6.2ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.2% | 2.8ms | 0.2% | 2.8ms | `getUint32` | `[native code]` |
| 0.2% | 2.7ms | 0.2% | 2.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4111` |
| 0.2% | 2.7ms | 0.6% | 8.5ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:839` |
| 0.2% | 2.6ms | 0.2% | 2.6ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4344` |
| 0.2% | 2.6ms | 2.5% | 33.6ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 0.2% | 2.6ms | 0.2% | 2.6ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6517` |
| 0.2% | 2.6ms | 0.5% | 7.2ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2731` |
| 0.2% | 2.6ms | 0.2% | 2.6ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:565` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1071` |
| 0.1% | 1.7ms | 0.4% | 6.2ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3181` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2107` |
| 0.1% | 1.7ms | 0.2% | 3.5ms | `readFileSync` | `[native code]` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2238` |
| 0.1% | 1.7ms | 0.2% | 3.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1417` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:152` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4343` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3133` |
| 0.1% | 1.7ms | 1.4% | 19.2ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1713` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2994` |
| 0.1% | 1.7ms | 100.0% | 2.68s | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `get start` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:647` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2640` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:540` |
| 0.1% | 1.6ms | 0.4% | 5.9ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2221` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2786` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3225` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2490` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `findIndex` | `[native code]` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3630` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2067` |
| 0.1% | 1.6ms | 2.8% | 36.7ms | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:769` |
| 0.1% | 1.6ms | 0.2% | 3.1ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `async lintSource` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:461` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:614` |
| 0.1% | 1.5ms | 1.1% | 14.8ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2643` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `slice` | `[native code]` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2986` |
| 0.1% | 1.5ms | 0.6% | 8.0ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2802` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4115` |
| 0.1% | 1.5ms | 0.3% | 4.1ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1709` |
| 0.1% | 1.5ms | 0.8% | 10.8ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `getVariableDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:757` |
| 0.1% | 1.4ms | 0.4% | 6.2ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2847` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `push` | `[native code]` |
| 0.1% | 1.4ms | 1.4% | 19.0ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:905` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `hideFromStack` | `internal:shared` |
| 0.1% | 1.4ms | 9.1% | 118.3ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:891` |
| 0.1% | 1.4ms | 0.9% | 12.7ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2821` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `isRead` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:220` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `typedArrayViewIsDetached` | `[native code]` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2069` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `subarray` | `[native code]` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `/^\s*exported\b/` | `[native code]` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:501` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:966` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `RuleContext` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2171` |
| 0.1% | 1.4ms | 0.5% | 7.7ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2929` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:656` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2163` |
| 0.1% | 1.3ms | 0.2% | 3.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1307` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1708` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2042` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `isRead` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.3ms | 5.9% | 77.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2876` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2151` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4998` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2266` |
| 0.1% | 1.3ms | 0.7% | 9.8ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:497` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2826` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_findLine` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:553` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.5% | 7.2ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2782` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2167` |
| 0.0% | 1.2ms | 1.7% | 22.1ms | `_ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:970` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:617` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1735` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 100.0% | 2.68s | 0.1% | 1.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 66.2% | 859.5ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:304` |
| 65.8% | 853.6ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7581` |
| 58.4% | 757.5ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7297` |
| 58.4% | 757.5ms | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4713` |
| 55.6% | 722.0ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` |
| 31.9% | 414.4ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:300` |
| 30.9% | 401.0ms | 30.9% | 401.0ms | `parse` | `[native code]` |
| 30.9% | 401.0ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` |
| 22.8% | 295.9ms | 0.2% | 3.7ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:808` |
| 21.1% | 273.9ms | 0.2% | 3.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 11.4% | 148.4ms | 0.2% | 3.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 11.2% | 146.0ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` |
| 10.0% | 130.8ms | 0.0% | 0us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4137` |
| 9.2% | 119.5ms | 0.0% | 0us | `some` | `[native code]` |
| 9.1% | 118.3ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:999` |
| 9.1% | 118.3ms | 0.1% | 1.4ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:891` |
| 8.9% | 116.1ms | 2.0% | 26.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 8.6% | 111.5ms | 0.4% | 6.4ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2883` |
| 7.5% | 98.3ms | 0.7% | 9.3ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 7.3% | 95.8ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` |
| 7.2% | 94.0ms | 0.0% | 0us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3135` |
| 6.5% | 84.5ms | 1.3% | 17.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1211` |
| 5.9% | 77.6ms | 0.1% | 1.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2876` |
| 5.8% | 75.3ms | 0.7% | 9.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2141` |
| 5.4% | 70.8ms | 0.2% | 3.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2120` |
| 4.5% | 59.0ms | 4.5% | 59.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7058` |
| 4.5% | 58.4ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2240` |
| 4.3% | 56.1ms | 1.3% | 18.1ms | `anonymous` | `[native code]` |
| 4.1% | 54.3ms | 0.3% | 4.0ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2872` |
| 4.0% | 53.1ms | 0.0% | 0us | `bound require` | `[native code]` |
| 3.8% | 49.8ms | 0.0% | 0us | `require` | `[native code]` |
| 3.3% | 43.5ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:752` |
| 3.3% | 43.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` |
| 3.2% | 41.8ms | 3.2% | 41.8ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` |
| 2.8% | 36.7ms | 0.1% | 1.6ms | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:769` |
| 2.6% | 34.8ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` |
| 2.6% | 33.8ms | 1.8% | 24.5ms | `Set` | `[native code]` |
| 2.6% | 33.8ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3177` |
| 2.5% | 33.6ms | 0.2% | 2.6ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 2.3% | 30.2ms | 1.8% | 23.7ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2901` |
| 2.3% | 29.9ms | 0.2% | 3.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 2.2% | 29.6ms | 0.0% | 0us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1947` |
| 2.2% | 29.6ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` |
| 2.2% | 29.2ms | 2.2% | 29.2ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4058` |
| 1.9% | 25.0ms | 0.4% | 5.6ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:802` |
| 1.8% | 24.6ms | 1.6% | 21.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2283` |
| 1.7% | 22.4ms | 0.7% | 9.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2374` |
| 1.7% | 22.1ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1003` |
| 1.7% | 22.1ms | 0.0% | 1.2ms | `_ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:970` |
| 1.6% | 20.8ms | 1.6% | 20.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6784` |
| 1.5% | 20.6ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2727` |
| 1.5% | 19.6ms | 0.0% | 0us | `parseModule` | `[native code]` |
| 1.5% | 19.6ms | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 1.4% | 19.2ms | 0.1% | 1.7ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1713` |
| 1.4% | 19.0ms | 0.1% | 1.4ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:905` |
| 1.4% | 18.2ms | 1.4% | 18.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2161` |
| 1.3% | 16.8ms | 1.0% | 14.0ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1710` |
| 1.2% | 16.7ms | 1.2% | 16.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2277` |
| 1.2% | 16.0ms | 0.5% | 6.9ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2831` |
| 1.1% | 15.4ms | 1.1% | 15.4ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 1.1% | 15.1ms | 0.2% | 3.3ms | `next` | `[native code]` |
| 1.1% | 14.8ms | 0.1% | 1.5ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2643` |
| 1.1% | 14.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` |
| 1.1% | 14.5ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:72` |
| 1.1% | 14.5ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` |
| 1.1% | 14.5ms | 1.1% | 14.5ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3207` |
| 1.1% | 14.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` |
| 1.0% | 13.9ms | 1.0% | 13.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4110` |
| 1.0% | 13.4ms | 0.5% | 7.6ms | `arrayIteratorNextHelper` | `[native code]` |
| 0.9% | 12.7ms | 0.1% | 1.4ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2821` |
| 0.9% | 12.2ms | 0.9% | 12.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4100` |
| 0.9% | 12.2ms | 0.9% | 12.2ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2751` |
| 0.9% | 11.9ms | 0.2% | 3.0ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2267` |
| 0.8% | 11.6ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2276` |
| 0.8% | 11.4ms | 0.3% | 4.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2125` |
| 0.8% | 11.3ms | 0.3% | 4.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3201` |
| 0.8% | 10.8ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2879` |
| 0.8% | 10.8ms | 0.1% | 1.5ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` |
| 0.8% | 10.8ms | 0.8% | 10.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2486` |
| 0.8% | 10.8ms | 0.8% | 10.8ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 0.8% | 10.7ms | 0.8% | 10.7ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` |
| 0.7% | 10.3ms | 0.4% | 5.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 0.7% | 10.2ms | 0.7% | 10.2ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.7% | 10.0ms | 0.7% | 10.0ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.7% | 9.8ms | 0.1% | 1.3ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:497` |
| 0.7% | 9.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` |
| 0.7% | 9.4ms | 0.6% | 8.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1250` |
| 0.7% | 9.3ms | 0.7% | 9.3ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:467` |
| 0.6% | 8.9ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` |
| 0.6% | 8.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` |
| 0.6% | 8.6ms | 0.6% | 8.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3213` |
| 0.6% | 8.5ms | 0.2% | 2.7ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:839` |
| 0.6% | 8.0ms | 0.1% | 1.5ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2802` |
| 0.5% | 7.7ms | 0.1% | 1.4ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2929` |
| 0.5% | 7.5ms | 0.5% | 7.5ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4132` |
| 0.5% | 7.3ms | 0.5% | 7.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1191` |
| 0.5% | 7.3ms | 0.2% | 2.9ms | `exec` | `[native code]` |
| 0.5% | 7.2ms | 0.2% | 2.6ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2731` |
| 0.5% | 7.2ms | 0.0% | 1.2ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2782` |
| 0.4% | 6.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:477` |
| 0.4% | 6.4ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:435` |
| 0.4% | 6.4ms | 0.0% | 0us | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` |
| 0.4% | 6.4ms | 0.3% | 4.6ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1733` |
| 0.4% | 6.3ms | 0.4% | 6.3ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:615` |
| 0.4% | 6.3ms | 0.4% | 6.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1317` |
| 0.4% | 6.3ms | 0.3% | 4.9ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` |
| 0.4% | 6.2ms | 0.0% | 0us | `scope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:764` |
| 0.4% | 6.2ms | 0.1% | 1.4ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2847` |
| 0.4% | 6.2ms | 0.1% | 1.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3181` |
| 0.4% | 6.2ms | 0.3% | 4.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` |
| 0.4% | 6.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` |
| 0.4% | 6.2ms | 0.4% | 6.2ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` |
| 0.4% | 6.2ms | 0.2% | 2.8ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.4% | 6.1ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3211` |
| 0.4% | 5.9ms | 0.1% | 1.6ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2221` |
| 0.4% | 5.9ms | 0.4% | 5.9ms | `_Variable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:847` |
| 0.4% | 5.9ms | 0.4% | 5.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2482` |
| 0.4% | 5.8ms | 0.4% | 5.8ms | `_Reference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:236` |
| 0.4% | 5.8ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2907` |
| 0.4% | 5.8ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3179` |
| 0.4% | 5.8ms | 0.2% | 2.8ms | `from` | `[native code]` |
| 0.4% | 5.8ms | 0.3% | 4.2ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:855` |
| 0.4% | 5.8ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2065` |
| 0.4% | 5.8ms | 0.4% | 5.8ms | `typedArrayViewLength` | `[native code]` |
| 0.4% | 5.7ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:613` |
| 0.4% | 5.6ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:612` |
| 0.4% | 5.4ms | 0.3% | 4.1ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2934` |
| 0.3% | 5.0ms | 0.2% | 3.3ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` |
| 0.3% | 5.0ms | 0.3% | 5.0ms | `test` | `[native code]` |
| 0.3% | 5.0ms | 0.3% | 5.0ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.3% | 4.9ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1013` |
| 0.3% | 4.9ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1018` |
| 0.3% | 4.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.3% | 4.8ms | 0.3% | 4.8ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.3% | 4.7ms | 0.3% | 4.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7229` |
| 0.3% | 4.6ms | 0.3% | 4.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2269` |
| 0.3% | 4.6ms | 0.3% | 4.6ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.3% | 4.4ms | 0.0% | 0us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` |
| 0.3% | 4.4ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7573` |
| 0.3% | 4.4ms | 0.3% | 4.4ms | `decode` | `[native code]` |
| 0.3% | 4.4ms | 0.3% | 4.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7060` |
| 0.3% | 4.4ms | 0.3% | 4.4ms | `encodeInto` | `[native code]` |
| 0.3% | 4.4ms | 0.0% | 0us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:92` |
| 0.3% | 4.4ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:215` |
| 0.3% | 4.3ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:478` |
| 0.3% | 4.1ms | 0.1% | 1.5ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1709` |
| 0.3% | 3.9ms | 0.3% | 3.9ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2752` |
| 0.2% | 3.5ms | 0.1% | 1.7ms | `readFileSync` | `[native code]` |
| 0.2% | 3.4ms | 0.2% | 3.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1261` |
| 0.2% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 3.2ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:776` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `set` | `[native code]` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 3.1ms | 0.1% | 1.6ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` |
| 0.2% | 3.1ms | 0.2% | 3.1ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2647` |
| 0.2% | 3.1ms | 0.2% | 3.1ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3206` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:236` |
| 0.2% | 3.0ms | 0.0% | 0us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1367` |
| 0.2% | 3.0ms | 0.1% | 1.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1223` |
| 0.2% | 3.0ms | 0.1% | 1.3ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2156` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4051` |
| 0.2% | 2.9ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` |
| 0.2% | 2.9ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3946` |
| 0.2% | 2.9ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:286` |
| 0.2% | 2.9ms | 0.2% | 2.9ms | `DataView` | `[native code]` |
| 0.2% | 2.9ms | 0.0% | 0us | `get defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:769` |
| 0.2% | 2.9ms | 0.2% | 2.9ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 2.8ms | 0.2% | 2.8ms | `getUint32` | `[native code]` |
| 0.2% | 2.7ms | 0.2% | 2.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4111` |
| 0.2% | 2.7ms | 0.0% | 0us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2755` |
| 0.2% | 2.6ms | 0.2% | 2.6ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4344` |
| 0.2% | 2.6ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7057` |
| 0.2% | 2.6ms | 0.2% | 2.6ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6517` |
| 0.2% | 2.6ms | 0.2% | 2.6ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:565` |
| 0.1% | 2.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` |
| 0.1% | 2.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.1% | 1.8ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2376` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `_computeNodeType` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1071` |
| 0.1% | 1.8ms | 0.0% | 0us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4106` |
| 0.1% | 1.7ms | 0.0% | 0us | `get identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:775` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2107` |
| 0.1% | 1.7ms | 0.0% | 0us | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:506` |
| 0.1% | 1.7ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:557` |
| 0.1% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:35` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2238` |
| 0.1% | 1.7ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2660` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1417` |
| 0.1% | 1.7ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2135` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:152` |
| 0.1% | 1.7ms | 0.0% | 0us | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:446` |
| 0.1% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4343` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3133` |
| 0.1% | 1.7ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:927` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2994` |
| 0.1% | 1.7ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:144` |
| 0.1% | 1.7ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:54` |
| 0.1% | 1.7ms | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3928` |
| 0.1% | 1.7ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:551` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `get start` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:647` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2640` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:540` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2786` |
| 0.1% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` |
| 0.1% | 1.6ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4165` |
| 0.1% | 1.6ms | 0.0% | 0us | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2949` |
| 0.1% | 1.6ms | 0.0% | 0us | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 0.1% | 1.6ms | 0.0% | 0us | `forEach` | `[native code]` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3225` |
| 0.1% | 1.6ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:901` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2490` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `findIndex` | `[native code]` |
| 0.1% | 1.6ms | 0.0% | 0us | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:822` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3630` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2067` |
| 0.1% | 1.6ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:747` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `async lintSource` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:461` |
| 0.1% | 1.6ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:77` |
| 0.1% | 1.6ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:926` |
| 0.1% | 1.5ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6796` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:614` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `slice` | `[native code]` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2986` |
| 0.1% | 1.5ms | 0.0% | 0us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:689` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4115` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `getVariableDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.1% | 1.5ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1712` |
| 0.1% | 1.5ms | 0.0% | 0us | `getDefinedMessageData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:278` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:757` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `push` | `[native code]` |
| 0.1% | 1.4ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:961` |
| 0.1% | 1.4ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1511` |
| 0.1% | 1.4ms | 0.0% | 0us | `identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:775` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `hideFromStack` | `internal:shared` |
| 0.1% | 1.4ms | 0.0% | 0us | `node:events` | `node:events:9` |
| 0.1% | 1.4ms | 0.0% | 0us | `internal:validators` | `internal:validators:47` |
| 0.1% | 1.4ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.1% | 1.4ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2281` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `typedArrayViewIsDetached` | `[native code]` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `isRead` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:220` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2069` |
| 0.1% | 1.4ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3147` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `subarray` | `[native code]` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `/^\s*exported\b/` | `[native code]` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:501` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:966` |
| 0.1% | 1.4ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7576` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `RuleContext` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2171` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:656` |
| 0.1% | 1.3ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2163` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1307` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1708` |
| 0.1% | 1.3ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1722` |
| 0.1% | 1.3ms | 0.0% | 0us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:688` |
| 0.1% | 1.3ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3165` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2042` |
| 0.1% | 1.3ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2195` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `isRead` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2151` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4998` |
| 0.1% | 1.3ms | 0.0% | 0us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5930` |
| 0.1% | 1.3ms | 0.0% | 0us | `_getOrBuildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5612` |
| 0.1% | 1.3ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6687` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2266` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1736` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2826` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_findLine` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:553` |
| 0.0% | 1.2ms | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3900` |
| 0.0% | 1.2ms | 0.0% | 0us | `getLocFromIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3500` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2167` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:617` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1735` |
| 0.0% | 1.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:22` |

## Function Details

### `parse`
`[native code]` | Self: 30.9% (401.0ms) | Total: 30.9% (401.0ms) | Samples: 265

**Called by:**
- `parseSource` (265)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7058` | Self: 4.5% (59.0ms) | Total: 4.5% (59.0ms) | Samples: 39

**Called by:**
- `runPlugins` (39)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` | Self: 3.2% (41.8ms) | Total: 3.2% (41.8ms) | Samples: 27

**Called by:**
- `_nodeViewRaw` (27)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4058` | Self: 2.2% (29.2ms) | Total: 2.2% (29.2ms) | Samples: 20

**Called by:**
- `_nodeViewRaw` (20)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` | Self: 2.0% (26.5ms) | Total: 8.9% (116.1ms) | Samples: 18

**Called by:**
- `nodeView` (71)
- `_buildReference` (3)
- `get parent` (2)
- `_nodesFromRange` (1)

**Calls:**
- `_NodeView` (27)
- `_NodeView_LR` (20)
- `_NodeView_LR` (10)
- `_NodeView_LRN` (2)

### `Set`
`[native code]` | Self: 1.8% (24.5ms) | Total: 2.6% (33.8ms) | Samples: 15

**Called by:**
- `_computeDeclaredVariables` (21)

**Calls:**
- `next` (4)
- `arrayIteratorNextHelper` (2)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2901` | Self: 1.8% (23.7ms) | Total: 2.3% (30.2ms) | Samples: 16

**Called by:**
- `get references` (20)

**Calls:**
- `get parent` (3)
- `get parent` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2283` | Self: 1.6% (21.3ms) | Total: 1.8% (24.6ms) | Samples: 14

**Called by:**
- `_ensureVarsSet` (16)

**Calls:**
- `set` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6784` | Self: 1.6% (20.8ms) | Total: 1.6% (20.8ms) | Samples: 14

**Called by:**
- `runPlugins` (14)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2161` | Self: 1.4% (18.2ms) | Total: 1.4% (18.2ms) | Samples: 12

**Called by:**
- `_buildReference` (8)
- `_computeVarScope` (2)
- `_buildScope` (1)
- `_buildScopeChildren` (1)

### `anonymous`
`[native code]` | Self: 1.3% (18.1ms) | Total: 4.3% (56.1ms) | Samples: 12

**Called by:**
- `require` (33)
- `bound require` (2)
- `node:fs` (1)
- `node:events` (1)

**Calls:**
- `(anonymous)` (6)
- `(anonymous)` (4)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:fs` (1)
- `internal:validators` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:events` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1211` | Self: 1.3% (17.3ms) | Total: 6.5% (84.5ms) | Samples: 11

**Called by:**
- `_buildReference` (44)
- `_computeVarDefs` (4)
- `_findDefNode` (4)
- `_computeIsStrict` (2)
- `isUnusedExpression` (1)

**Calls:**
- `nodeView` (38)
- `_nodeViewRaw` (2)
- `nodeView` (2)
- `_nodeViewRaw` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2277` | Self: 1.2% (16.7ms) | Total: 1.2% (16.7ms) | Samples: 11

**Called by:**
- `_ensureVarsSet` (11)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 1.1% (15.4ms) | Total: 1.1% (15.4ms) | Samples: 10

**Called by:**
- `_nodeViewRaw` (10)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3207` | Self: 1.1% (14.5ms) | Total: 1.1% (14.5ms) | Samples: 9

**Called by:**
- `getDeclaredVariables` (9)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1710` | Self: 1.0% (14.0ms) | Total: 1.3% (16.8ms) | Samples: 9

**Called by:**
- `_computeIsStrict` (10)
- `isForInOfRef` (1)

**Calls:**
- `getUint32` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4110` | Self: 1.0% (13.9ms) | Total: 1.0% (13.9ms) | Samples: 8

**Called by:**
- `nodeView` (7)
- `nodeViewChain` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4100` | Self: 0.9% (12.2ms) | Total: 0.9% (12.2ms) | Samples: 8

**Called by:**
- `nodeView` (5)
- `get parent` (2)
- `_buildScope` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2751` | Self: 0.9% (12.2ms) | Total: 0.9% (12.2ms) | Samples: 8

**Called by:**
- `_buildReference` (5)
- `_computeDeclaredVariables` (3)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2486` | Self: 0.8% (10.8ms) | Total: 0.8% (10.8ms) | Samples: 7

**Called by:**
- `_ensureVarsSet` (7)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` | Self: 0.8% (10.8ms) | Total: 0.8% (10.8ms) | Samples: 7

**Called by:**
- `(anonymous)` (7)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` | Self: 0.8% (10.7ms) | Total: 0.8% (10.7ms) | Samples: 7

**Called by:**
- `_computeIsStrict` (7)

### `/\/\*([\s\S]*?)\*\//g`
`[native code]` | Self: 0.7% (10.2ms) | Total: 0.7% (10.2ms) | Samples: 7

**Called by:**
- `_buildScopeVarsAndSet` (4)
- `exec` (3)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.7% (10.0ms) | Total: 0.7% (10.0ms) | Samples: 7

**Called by:**
- `commentsInRange` (4)
- `commentsInRange` (3)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:467` | Self: 0.7% (9.3ms) | Total: 0.7% (9.3ms) | Samples: 6

**Called by:**
- `getRhsNode` (6)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` | Self: 0.7% (9.3ms) | Total: 7.5% (98.3ms) | Samples: 6

**Called by:**
- `collectUnusedVariables` (56)
- `Program:exit` (6)

**Calls:**
- `some` (28)
- `isUsedVariable` (22)
- `isUsedVariable` (4)
- `isUsedVariable` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2374` | Self: 0.7% (9.2ms) | Total: 1.7% (22.4ms) | Samples: 6

**Called by:**
- `_ensureVarsSet` (15)

**Calls:**
- `exec` (5)
- `/\/\*([\s\S]*?)\*\//g` (4)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2141` | Self: 0.7% (9.1ms) | Total: 5.8% (75.3ms) | Samples: 6

**Called by:**
- `_buildScope` (28)
- `_buildReference` (13)
- `_buildScopeChildren` (6)
- `_precomputeScopes` (1)

**Calls:**
- `_computeIsStrict` (37)
- `_computeIsStrict` (4)
- `_computeIsStrict` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3213` | Self: 0.6% (8.6ms) | Total: 0.6% (8.6ms) | Samples: 6

**Called by:**
- `getDeclaredVariables` (6)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1250` | Self: 0.6% (8.0ms) | Total: 0.7% (9.4ms) | Samples: 5

**Called by:**
- `_buildReference` (4)
- `_findDefNode` (2)

**Calls:**
- `get value` (1)

### `arrayIteratorNextHelper`
`[native code]` | Self: 0.5% (7.6ms) | Total: 1.0% (13.4ms) | Samples: 5

**Called by:**
- `next` (7)
- `Set` (2)

**Calls:**
- `typedArrayViewLength` (4)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4132` | Self: 0.5% (7.5ms) | Total: 0.5% (7.5ms) | Samples: 5

**Called by:**
- `get parent` (2)
- `get body` (1)
- `_buildScope` (1)
- `get body` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1191` | Self: 0.5% (7.3ms) | Total: 0.5% (7.3ms) | Samples: 5

**Called by:**
- `(anonymous)` (1)
- `isReadForItself` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)
- `_buildReference` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2831` | Self: 0.5% (6.9ms) | Total: 1.2% (16.0ms) | Samples: 5

**Called by:**
- `defs` (10)
- `get defs` (1)

**Calls:**
- `get parent` (4)
- `get parent` (1)
- `get parent` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2883` | Self: 0.4% (6.4ms) | Total: 8.6% (111.5ms) | Samples: 4

**Called by:**
- `get references` (70)
- `_ensureVarsSet` (1)

**Calls:**
- `_buildScope` (34)
- `_buildScope` (13)
- `_buildScope` (8)
- `_buildScope` (5)
- `_buildScope` (2)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:615` | Self: 0.4% (6.3ms) | Total: 0.4% (6.3ms) | Samples: 4

**Called by:**
- `_precomputeScopes` (4)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1317` | Self: 0.4% (6.3ms) | Total: 0.4% (6.3ms) | Samples: 4

**Called by:**
- `_buildReference` (3)
- `isReadForItself` (1)

### `isSelfReference`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` | Self: 0.4% (6.2ms) | Total: 0.4% (6.2ms) | Samples: 4

**Called by:**
- `(anonymous)` (4)

### `_Variable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:847` | Self: 0.4% (5.9ms) | Total: 0.4% (5.9ms) | Samples: 4

**Called by:**
- `_buildVariable` (4)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2482` | Self: 0.4% (5.9ms) | Total: 0.4% (5.9ms) | Samples: 4

**Called by:**
- `_ensureVarsSet` (4)

### `_Reference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:236` | Self: 0.4% (5.8ms) | Total: 0.4% (5.8ms) | Samples: 4

**Called by:**
- `_buildReference` (4)

### `typedArrayViewLength`
`[native code]` | Self: 0.4% (5.8ms) | Total: 0.4% (5.8ms) | Samples: 4

**Called by:**
- `arrayIteratorNextHelper` (4)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:802` | Self: 0.4% (5.6ms) | Total: 1.9% (25.0ms) | Samples: 4

**Called by:**
- `collectUnusedVariables` (13)
- `(anonymous)` (3)
- `_computeDeclaredVariables` (1)

**Calls:**
- `_computeVariableSynthRefs` (5)
- `_computeVariableSynthRefs` (4)
- `_computeVariableSynthRefs` (2)
- `_computeVariableSynthRefs` (1)
- `_computeVariableSynthRefs` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` | Self: 0.4% (5.5ms) | Total: 0.7% (10.3ms) | Samples: 4

**Called by:**
- `some` (7)

**Calls:**
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `test`
`[native code]` | Self: 0.3% (5.0ms) | Total: 0.3% (5.0ms) | Samples: 3

**Called by:**
- `_precomputeScopes` (2)
- `_buildScopeVarsAndSet` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` | Self: 0.3% (5.0ms) | Total: 0.3% (5.0ms) | Samples: 3

**Called by:**
- `collectUnusedVariables` (3)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` | Self: 0.3% (4.9ms) | Total: 0.4% (6.3ms) | Samples: 3

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `isRead` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` | Self: 0.3% (4.8ms) | Total: 0.4% (6.2ms) | Samples: 3

**Called by:**
- `some` (4)

**Calls:**
- `isRead` (1)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` | Self: 0.3% (4.8ms) | Total: 0.3% (4.8ms) | Samples: 3

**Called by:**
- `isUsedVariable` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7229` | Self: 0.3% (4.7ms) | Total: 0.3% (4.7ms) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2269` | Self: 0.3% (4.6ms) | Total: 0.3% (4.6ms) | Samples: 3

**Called by:**
- `_ensureVarsSet` (3)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` | Self: 0.3% (4.6ms) | Total: 0.3% (4.6ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1733` | Self: 0.3% (4.6ms) | Total: 0.4% (6.4ms) | Samples: 3

**Called by:**
- `_computeIsStrict` (4)

**Calls:**
- `nodeView` (1)

### `decode`
`[native code]` | Self: 0.3% (4.4ms) | Total: 0.3% (4.4ms) | Samples: 3

**Called by:**
- `get source` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7060` | Self: 0.3% (4.4ms) | Total: 0.3% (4.4ms) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `encodeInto`
`[native code]` | Self: 0.3% (4.4ms) | Total: 0.3% (4.4ms) | Samples: 3

**Called by:**
- `_encodeSource` (3)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3201` | Self: 0.3% (4.3ms) | Total: 0.8% (11.3ms) | Samples: 3

**Called by:**
- `getDeclaredVariables` (8)

**Calls:**
- `_buildVariable` (3)
- `_buildVariable` (1)
- `_buildVariable` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2125` | Self: 0.3% (4.2ms) | Total: 0.8% (11.4ms) | Samples: 3

**Called by:**
- `_buildReference` (5)
- `_buildScope` (2)

**Calls:**
- `nodeView` (2)
- `_nodeViewRaw` (1)
- `nodeView` (1)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:855` | Self: 0.3% (4.2ms) | Total: 0.4% (5.8ms) | Samples: 3

**Called by:**
- `_symName` (4)

**Calls:**
- `slice` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2934` | Self: 0.3% (4.1ms) | Total: 0.4% (5.4ms) | Samples: 3

**Called by:**
- `get references` (4)

**Calls:**
- `nodeView` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2872` | Self: 0.3% (4.0ms) | Total: 4.1% (54.3ms) | Samples: 3

**Called by:**
- `get references` (37)

**Calls:**
- `nodeView` (31)
- `_nodeViewRaw` (3)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2752` | Self: 0.3% (3.9ms) | Total: 0.3% (3.9ms) | Samples: 3

**Called by:**
- `_buildScopeVarsAndSet` (3)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:808` | Self: 0.2% (3.7ms) | Total: 22.8% (295.9ms) | Samples: 3

**Called by:**
- `collectUnusedVariables` (158)
- `(anonymous)` (25)
- `isUsedVariable` (6)
- `_computeDeclaredVariables` (3)
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `_buildReference` (70)
- `_buildReference` (50)
- `_buildReference` (37)
- `_buildReference` (20)
- `_buildReference` (7)
- `_buildReference` (4)
- `_buildReference` (2)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1261` | Self: 0.2% (3.4ms) | Total: 0.2% (3.4ms) | Samples: 2

**Called by:**
- `(anonymous)` (1)
- `collectUnusedVariables` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2120` | Self: 0.2% (3.3ms) | Total: 5.4% (70.8ms) | Samples: 2

**Called by:**
- `_buildReference` (34)
- `_buildScope` (11)

**Calls:**
- `_buildScope` (28)
- `_buildScope` (11)
- `_buildScope` (2)
- `_buildScope` (1)
- `_buildScope` (1)

### `next`
`[native code]` | Self: 0.2% (3.3ms) | Total: 1.1% (15.1ms) | Samples: 2

**Called by:**
- `Set` (4)
- `_computeDeclaredVariables` (3)
- `from` (2)
- `walkNodes` (1)

**Calls:**
- `arrayIteratorNextHelper` (7)
- `typedArrayViewIsDetached` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` | Self: 0.2% (3.3ms) | Total: 0.3% (5.0ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (3)

**Calls:**
- `isFunction` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.2% (3.2ms) | Total: 0.2% (3.2ms) | Samples: 2

**Called by:**
- `(anonymous)` (1)
- `_computeVarDefs` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` | Self: 0.2% (3.2ms) | Total: 21.1% (273.9ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (179)
- `Program:exit` (1)

**Calls:**
- `get references` (158)
- `get references` (13)
- `some` (7)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.2% (3.2ms) | Total: 0.2% (3.2ms) | Samples: 2

**Called by:**
- `get references` (2)

### `set`
`[native code]` | Self: 0.2% (3.2ms) | Total: 0.2% (3.2ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.2% (3.2ms) | Total: 0.2% (3.2ms) | Samples: 2

**Called by:**
- `_computeVarScope` (1)
- `_buildScopeChildren` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` | Self: 0.2% (3.1ms) | Total: 2.3% (29.9ms) | Samples: 2

**Called by:**
- `some` (19)

**Calls:**
- `getRhsNode` (7)
- `getRhsNode` (7)
- `getRhsNode` (1)
- `getRhsNode` (1)
- `getRhsNode` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2647` | Self: 0.2% (3.1ms) | Total: 0.2% (3.1ms) | Samples: 2

**Called by:**
- `_ensureChildren` (2)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3206` | Self: 0.2% (3.1ms) | Total: 0.2% (3.1ms) | Samples: 2

**Called by:**
- `getDeclaredVariables` (2)

### `_resolveUnicodeEscapes`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:236` | Self: 0.2% (3.0ms) | Total: 0.2% (3.0ms) | Samples: 2

**Called by:**
- `get name` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2267` | Self: 0.2% (3.0ms) | Total: 0.9% (11.9ms) | Samples: 2

**Called by:**
- `_ensureVarsSet` (8)

**Calls:**
- `_ensureDeclSymIndex` (4)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1223` | Self: 0.2% (3.0ms) | Total: 0.2% (3.0ms) | Samples: 2

**Called by:**
- `_computeIsStrict` (1)
- `_buildReference` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2156` | Self: 0.2% (3.0ms) | Total: 0.2% (3.0ms) | Samples: 2

**Called by:**
- `_buildReference` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` | Self: 0.2% (3.0ms) | Total: 11.4% (148.4ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (74)
- `Program:exit` (24)

**Calls:**
- `get` (78)
- `get` (15)
- `get` (3)

### `_NodeView_LRN`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4051` | Self: 0.2% (3.0ms) | Total: 0.2% (3.0ms) | Samples: 2

**Called by:**
- `_nodeViewRaw` (2)

### `DataView`
`[native code]` | Self: 0.2% (2.9ms) | Total: 0.2% (2.9ms) | Samples: 2

**Called by:**
- `AstView` (2)

### `exec`
`[native code]` | Self: 0.2% (2.9ms) | Total: 0.5% (7.3ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (5)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (3)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.2% (2.9ms) | Total: 0.2% (2.9ms) | Samples: 2

**Called by:**
- `get references` (2)

### `from`
`[native code]` | Self: 0.2% (2.8ms) | Total: 0.4% (5.8ms) | Samples: 2

**Called by:**
- `_computeDeclaredVariables` (4)

**Calls:**
- `next` (2)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` | Self: 0.2% (2.8ms) | Total: 0.4% (6.2ms) | Samples: 2

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `get parent` (1)
- `get parent` (1)

### `getUint32`
`[native code]` | Self: 0.2% (2.8ms) | Total: 0.2% (2.8ms) | Samples: 2

**Called by:**
- `get body` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4111` | Self: 0.2% (2.7ms) | Total: 0.2% (2.7ms) | Samples: 2

**Called by:**
- `nodeView` (2)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:839` | Self: 0.2% (2.7ms) | Total: 0.6% (8.5ms) | Samples: 2

**Called by:**
- `_ensureDeclSymIndex` (4)
- `_buildVariable` (2)

**Calls:**
- `_buildSymNameCache` (4)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4344` | Self: 0.2% (2.6ms) | Total: 0.2% (2.6ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` | Self: 0.2% (2.6ms) | Total: 2.5% (33.6ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (22)

**Calls:**
- `some` (13)
- `get references` (6)
- `get references` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6517` | Self: 0.2% (2.6ms) | Total: 0.2% (2.6ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2731` | Self: 0.2% (2.6ms) | Total: 0.5% (7.2ms) | Samples: 2

**Called by:**
- `getScope` (5)

**Calls:**
- `test` (2)
- `/^\s*exported\b/` (1)

### `nodeLhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:565` | Self: 0.2% (2.6ms) | Total: 0.2% (2.6ms) | Samples: 1

**Called by:**
- `get body` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (1.8ms) | Total: 0.1% (1.8ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `_computeNodeType`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1071` | Self: 0.1% (1.8ms) | Total: 0.1% (1.8ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3181` | Self: 0.1% (1.7ms) | Total: 0.4% (6.2ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (4)

**Calls:**
- `next` (3)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2107` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `readFileSync`
`[native code]` | Self: 0.1% (1.7ms) | Total: 0.2% (3.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)
- `readFileSync` (1)

**Calls:**
- `readFileSync` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2238` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` | Self: 0.1% (1.7ms) | Total: 0.2% (3.0ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (2)

**Calls:**
- `get parent` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1417` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `isFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:152` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `isFunction` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4343` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3133` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1713` | Self: 0.1% (1.7ms) | Total: 1.4% (19.2ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (12)

**Calls:**
- `_nodesFromRange` (11)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2994` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `get references` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` | Self: 0.1% (1.7ms) | Total: 100.0% (2.68s) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1309)
- `Program:exit` (439)

**Calls:**
- `collectUnusedVariables` (1309)
- `collectUnusedVariables` (179)
- `collectUnusedVariables` (94)
- `collectUnusedVariables` (74)
- `collectUnusedVariables` (56)
- `collectUnusedVariables` (24)
- `collectUnusedVariables` (3)
- `collectUnusedVariables` (2)
- `collectUnusedVariables` (2)
- `collectUnusedVariables` (2)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)

### `get start`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `_execReport` (1)

### `isInside`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `getRhsNode` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:647` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2640` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `_ensureChildren` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:540` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2221` | Self: 0.1% (1.6ms) | Total: 0.4% (5.9ms) | Samples: 1

**Called by:**
- `_buildScope` (4)

**Calls:**
- `get parent` (2)
- `get parent` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2786` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3225` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2490` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `findIndex`
`[native code]` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3630` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `get references` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2067` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:769` | Self: 0.1% (1.6ms) | Total: 2.8% (36.7ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (22)
- `isAfterLastUsedArg` (1)
- `get identifiers` (1)
- `identifiers` (1)

**Calls:**
- `_computeVarDefs` (10)
- `_computeVarDefs` (9)
- `_computeVarDefs` (4)
- `_computeVarDefs` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` | Self: 0.1% (1.6ms) | Total: 0.2% (3.1ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (2)

**Calls:**
- `eslintUsed` (1)

### `async lintSource`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:461` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `async (anonymous)` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:614` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2643` | Self: 0.1% (1.5ms) | Total: 1.1% (14.8ms) | Samples: 1

**Called by:**
- `_ensureChildren` (10)

**Calls:**
- `_buildScope` (6)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `slice`
`[native code]` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `_buildSymNameCache` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `parseSource` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2986` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `get references` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2802` | Self: 0.1% (1.5ms) | Total: 0.6% (8.0ms) | Samples: 1

**Called by:**
- `defs` (4)
- `get defs` (1)

**Calls:**
- `nodeView` (4)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4115` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `nodeView` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1709` | Self: 0.1% (1.5ms) | Total: 0.3% (4.1ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (2)

**Calls:**
- `nodeLhs` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` | Self: 0.1% (1.5ms) | Total: 0.8% (10.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (7)

**Calls:**
- `isInLoop` (6)

### `getVariableDescription`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `getDefinedMessageData` (1)

### `eslintUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:757` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `isUsedVariable` (1)

### `_computeVarScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2847` | Self: 0.1% (1.4ms) | Total: 0.4% (6.2ms) | Samples: 1

**Called by:**
- `scope` (4)

**Calls:**
- `_buildScope` (2)
- `_buildScope` (1)

### `push`
`[native code]` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:905` | Self: 0.1% (1.4ms) | Total: 1.4% (19.0ms) | Samples: 1

**Called by:**
- `get body` (11)
- `get value` (1)

**Calls:**
- `nodeView` (9)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `hideFromStack`
`internal:shared` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `internal:validators` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:891` | Self: 0.1% (1.4ms) | Total: 9.1% (118.3ms) | Samples: 1

**Called by:**
- `get` (78)

**Calls:**
- `_buildScopeVarsAndSet` (16)
- `_buildScopeVarsAndSet` (15)
- `_buildScopeVarsAndSet` (11)
- `_buildScopeVarsAndSet` (8)
- `_buildScopeVarsAndSet` (8)
- `_buildScopeVarsAndSet` (7)
- `_buildScopeVarsAndSet` (4)
- `_buildScopeVarsAndSet` (3)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2821` | Self: 0.1% (1.4ms) | Total: 0.9% (12.7ms) | Samples: 1

**Called by:**
- `defs` (9)

**Calls:**
- `_findDefNode` (7)
- `_findDefNode` (1)

### `isRead`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:220` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `isReadForItself` (1)

### `typedArrayViewIsDetached`
`[native code]` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `next` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2069` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `subarray`
`[native code]` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `_computeDeclaredVariables` (1)

### `/^\s*exported\b/`
`[native code]` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:501` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `_computeVarDefs` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:966` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `RuleContext`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2171` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2929` | Self: 0.1% (1.4ms) | Total: 0.5% (7.7ms) | Samples: 1

**Called by:**
- `get references` (5)

**Calls:**
- `scope` (4)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:656` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `commentsInRange` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2163` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` | Self: 0.1% (1.3ms) | Total: 0.2% (3.0ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (2)

**Calls:**
- `get parent` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1307` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 1

**Called by:**
- `_computeVarDefs` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1708` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2042` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 1

**Called by:**
- `_computeDeclaredVariables` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `isRead`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2876` | Self: 0.1% (1.3ms) | Total: 5.9% (77.6ms) | Samples: 1

**Called by:**
- `get references` (50)

**Calls:**
- `get parent` (44)
- `get parent` (4)
- `get parent` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2151` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4998` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 1

**Called by:**
- `_buildPlan` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2266` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:497` | Self: 0.1% (1.3ms) | Total: 0.7% (9.8ms) | Samples: 1

**Called by:**
- `_computeVarDefs` (7)

**Calls:**
- `get parent` (4)
- `get parent` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2826` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `defs` (1)

### `_findLine`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:553` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `getLocFromIndex` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_ensureChildren` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2782` | Self: 0.0% (1.2ms) | Total: 0.5% (7.2ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (4)
- `_computeDeclaredVariables` (1)

**Calls:**
- `_Variable` (4)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2167` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `_ensureChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:970` | Self: 0.0% (1.2ms) | Total: 1.7% (22.1ms) | Samples: 1

**Called by:**
- `get` (15)

**Calls:**
- `_buildScopeChildren` (10)
- `_buildScopeChildren` (2)
- `_buildScopeChildren` (1)
- `_buildScopeChildren` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:617` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1735` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3946` | Self: 0.0% (0us) | Total: 0.2% (2.9ms) | Samples: 0

**Called by:**
- `Program:exit` (2)

**Calls:**
- `_execReport` (1)
- `_execReport` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:612` | Self: 0.0% (0us) | Total: 0.4% (5.6ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (4)

**Calls:**
- `_findLineIdx` (4)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:478` | Self: 0.0% (0us) | Total: 0.3% (4.3ms) | Samples: 0

**Called by:**
- `parseSource` (2)

**Calls:**
- `CfgGraph` (1)
- `CfgGraph` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:477` | Self: 0.0% (0us) | Total: 0.4% (6.4ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `patchAstUtils` (4)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2660` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `getScope` (1)

**Calls:**
- `_buildScope` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:999` | Self: 0.0% (0us) | Total: 9.1% (118.3ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (78)

**Calls:**
- `_ensureVarsSet` (78)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3165` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (1)

**Calls:**
- `_ensureDeclSymIndex` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:557` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isUnusedExpression` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` | Self: 0.0% (0us) | Total: 3.3% (43.5ms) | Samples: 0

**Called by:**
- `some` (28)

**Calls:**
- `get references` (25)
- `get references` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` | Self: 0.0% (0us) | Total: 1.1% (14.5ms) | Samples: 0

**Called by:**
- `parseModule` (10)

**Calls:**
- `async (anonymous)` (10)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` | Self: 0.0% (0us) | Total: 0.4% (6.2ms) | Samples: 0

**Called by:**
- `some` (4)

**Calls:**
- `isSelfReference` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.1% (2.5ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:144` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Calls:**
- `loadCoreRules` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:300` | Self: 0.0% (0us) | Total: 31.9% (414.4ms) | Samples: 0

**Calls:**
- `parseSource` (265)
- `parseSource` (5)
- `parseSource` (3)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `isUsedVariable` (1)

**Calls:**
- `forEach` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `get parent` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4137` | Self: 0.0% (0us) | Total: 10.0% (130.8ms) | Samples: 0

**Called by:**
- `get parent` (38)
- `_buildReference` (31)
- `_nodesFromRange` (9)
- `_computeVarDefs` (4)
- `_buildScope` (2)
- `get body` (1)
- `_computeVariableSynthRefs` (1)

**Calls:**
- `_nodeViewRaw` (71)
- `_nodeViewRaw` (7)
- `_nodeViewRaw` (5)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:926` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `_buildReference` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3135` | Self: 0.0% (0us) | Total: 7.2% (94.0ms) | Samples: 0

**Called by:**
- `isAfterLastUsedArg` (61)

**Calls:**
- `_computeDeclaredVariables` (21)
- `_computeDeclaredVariables` (9)
- `_computeDeclaredVariables` (8)
- `_computeDeclaredVariables` (6)
- `_computeDeclaredVariables` (4)
- `_computeDeclaredVariables` (4)
- `_computeDeclaredVariables` (4)
- `_computeDeclaredVariables` (2)
- `_computeDeclaredVariables` (1)
- `_computeDeclaredVariables` (1)
- `_computeDeclaredVariables` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3147` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (1)

**Calls:**
- `subarray` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:304` | Self: 0.0% (0us) | Total: 66.2% (859.5ms) | Samples: 0

**Calls:**
- `runPlugins` (559)
- `runPlugins` (3)
- `runPlugins` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3211` | Self: 0.0% (0us) | Total: 0.4% (6.1ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (4)

**Calls:**
- `get references` (3)
- `get references` (1)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` | Self: 0.0% (0us) | Total: 0.3% (4.4ms) | Samples: 0

**Called by:**
- `runPlugins` (3)

**Calls:**
- `decode` (3)

### `internal:validators`
`internal:validators:47` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `hideFromStack` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2879` | Self: 0.0% (0us) | Total: 0.8% (10.8ms) | Samples: 0

**Called by:**
- `get references` (7)

**Calls:**
- `_buildVariable` (5)
- `_buildVariable` (1)
- `_buildVariable` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3900` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `report` (1)

**Calls:**
- `getLocFromIndex` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2727` | Self: 0.0% (0us) | Total: 1.5% (20.6ms) | Samples: 0

**Called by:**
- `getScope` (14)

**Calls:**
- `commentsInRange` (4)
- `commentsInRange` (4)
- `commentsInRange` (4)
- `commentsInRange` (1)
- `commentsInRange` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` | Self: 0.0% (0us) | Total: 2.2% (29.6ms) | Samples: 0

**Called by:**
- `_invokeFused` (20)

**Calls:**
- `getScope` (20)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:927` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `get name` (1)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:54` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (1)

**Calls:**
- `bound require` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2755` | Self: 0.0% (0us) | Total: 0.2% (2.7ms) | Samples: 0

**Called by:**
- `_buildReference` (1)
- `_computeDeclaredVariables` (1)

**Calls:**
- `_symName` (2)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1511` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `get parent` (1)

**Calls:**
- `_nodesFromRange` (1)

### `some`
`[native code]` | Self: 0.0% (0us) | Total: 9.2% (119.5ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (28)
- `isAfterLastUsedArg` (28)
- `isUsedVariable` (13)
- `collectUnusedVariables` (7)

**Calls:**
- `(anonymous)` (28)
- `(anonymous)` (19)
- `(anonymous)` (9)
- `(anonymous)` (7)
- `(anonymous)` (5)
- `(anonymous)` (4)
- `(anonymous)` (4)

### `isFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:446` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `isFunction` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7057` | Self: 0.0% (0us) | Total: 0.2% (2.6ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `getDFSEvents` (2)

### `scope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:764` | Self: 0.0% (0us) | Total: 0.4% (6.2ms) | Samples: 0

**Called by:**
- `_computeVariableSynthRefs` (4)

**Calls:**
- `_computeVarScope` (4)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1722` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `isForInOfRef` (1)

**Calls:**
- `nodeView` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7576` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `RuleContext` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4713` | Self: 0.0% (0us) | Total: 58.4% (757.5ms) | Samples: 0

**Called by:**
- `walkNodes` (495)

**Calls:**
- `Program:exit` (471)
- `Program:exit` (20)
- `Program:exit` (2)
- `Program:exit` (1)
- `Program:exit` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1736` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `nodeView` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:752` | Self: 0.0% (0us) | Total: 3.3% (43.5ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (28)

**Calls:**
- `some` (28)

### `getLocFromIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3500` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_execReport` (1)

**Calls:**
- `_findLine` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7573` | Self: 0.0% (0us) | Total: 0.3% (4.4ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (3)

**Calls:**
- `get source` (3)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1367` | Self: 0.0% (0us) | Total: 0.2% (3.0ms) | Samples: 0

**Called by:**
- `_buildScope` (1)
- `_ensureVarsSet` (1)

**Calls:**
- `_resolveUnicodeEscapes` (2)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:901` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `findIndex` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` | Self: 0.0% (0us) | Total: 0.6% (8.9ms) | Samples: 0

**Called by:**
- `some` (5)

**Calls:**
- `isForInOfRef` (2)
- `isForInOfRef` (1)
- `isForInOfRef` (1)
- `isForInOfRef` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:215` | Self: 0.0% (0us) | Total: 0.3% (4.4ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (3)

**Calls:**
- `_encodeSource` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` | Self: 0.0% (0us) | Total: 0.1% (2.5ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:77` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Calls:**
- `async lintSource` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` | Self: 0.0% (0us) | Total: 1.1% (14.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (10)

**Calls:**
- `async (anonymous)` (10)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:92` | Self: 0.0% (0us) | Total: 0.3% (4.4ms) | Samples: 0

**Called by:**
- `parseSource` (3)

**Calls:**
- `encodeInto` (3)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5930` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `_getOrBuildPlan` (1)

**Calls:**
- `_extractFileLevelRules` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` | Self: 0.0% (0us) | Total: 0.6% (8.9ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (5)

**Calls:**
- `AstView` (2)
- `AstView` (2)
- `AstView` (1)

### `identifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:775` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `defs` (1)

### `get identifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:775` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `defs` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7297` | Self: 0.0% (0us) | Total: 58.4% (757.5ms) | Samples: 0

**Called by:**
- `runPlugins` (495)

**Calls:**
- `_invokeFused` (495)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:35` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `readFileSync` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1003` | Self: 0.0% (0us) | Total: 1.7% (22.1ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (15)

**Calls:**
- `_ensureChildren` (15)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:776` | Self: 0.0% (0us) | Total: 0.2% (3.2ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (2)

**Calls:**
- `identifiers` (1)
- `get identifiers` (1)

### `_getOrBuildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5612` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_buildPlan` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6796` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `next` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` | Self: 0.0% (0us) | Total: 0.2% (2.9ms) | Samples: 0

**Called by:**
- `_invokeFused` (2)

**Calls:**
- `report` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2376` | Self: 0.0% (0us) | Total: 0.1% (1.8ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `test` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:822` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `isUsedVariable` (1)

**Calls:**
- `range` (1)

### `forEach`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `getFunctionDefinitions` (1)

**Calls:**
- `(anonymous)` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1018` | Self: 0.0% (0us) | Total: 0.3% (4.9ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (3)

**Calls:**
- `_ensureVarsSet` (3)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 3.8% (49.8ms) | Samples: 0

**Called by:**
- `bound require` (33)

**Calls:**
- `anonymous` (33)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6687` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_getOrBuildPlan` (1)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 4.0% (53.1ms) | Samples: 0

**Called by:**
- `async (anonymous)` (10)
- `(anonymous)` (6)
- `patchAstUtils` (4)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `loadCoreRules` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `require` (33)
- `anonymous` (2)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` | Self: 0.0% (0us) | Total: 30.9% (401.0ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (265)

**Calls:**
- `parse` (265)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2195` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `_buildReference` (1)

**Calls:**
- `get name` (1)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 1.5% (19.6ms) | Samples: 0

**Calls:**
- `parseModule` (13)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` | Self: 0.0% (0us) | Total: 0.7% (9.7ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1013` | Self: 0.0% (0us) | Total: 0.3% (4.9ms) | Samples: 0

**Called by:**
- `get` (3)

**Calls:**
- `_ensureVarsSet` (1)
- `_ensureVarsSet` (1)
- `_ensureVarsSet` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3177` | Self: 0.0% (0us) | Total: 2.6% (33.8ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (21)

**Calls:**
- `Set` (21)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` | Self: 0.0% (0us) | Total: 55.6% (722.0ms) | Samples: 0

**Called by:**
- `_invokeFused` (471)

**Calls:**
- `collectUnusedVariables` (439)
- `collectUnusedVariables` (24)
- `collectUnusedVariables` (6)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2907` | Self: 0.0% (0us) | Total: 0.4% (5.8ms) | Samples: 0

**Called by:**
- `get references` (4)

**Calls:**
- `_Reference` (4)

### `getDefinedMessageData`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:278` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `Program:exit` (1)

**Calls:**
- `getVariableDescription` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` | Self: 0.0% (0us) | Total: 2.6% (34.8ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (24)

**Calls:**
- `defs` (22)
- `get defs` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2135` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `_buildReference` (1)

**Calls:**
- `get value` (1)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` | Self: 0.0% (0us) | Total: 0.2% (3.3ms) | Samples: 0

**Called by:**
- `parseModule` (2)

**Calls:**
- `bound require` (2)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:689` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get body` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:22` | Self: 0.0% (0us) | Total: 0.0% (1.1ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:688` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get body` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2240` | Self: 0.0% (0us) | Total: 4.5% (58.4ms) | Samples: 0

**Called by:**
- `_buildScope` (37)

**Calls:**
- `get body` (12)
- `get body` (10)
- `get body` (7)
- `get body` (4)
- `get body` (2)
- `get body` (1)
- `get body` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4165` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `init` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3928` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `report` (1)

**Calls:**
- `get start` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:747` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `defs` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` | Self: 0.0% (0us) | Total: 11.2% (146.0ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (94)

**Calls:**
- `isAfterLastUsedArg` (62)
- `isAfterLastUsedArg` (28)
- `isAfterLastUsedArg` (3)
- `isAfterLastUsedArg` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:72` | Self: 0.0% (0us) | Total: 1.1% (14.5ms) | Samples: 0

**Called by:**
- `async (anonymous)` (10)

**Calls:**
- `bound require` (10)

### `parseModule`
`[native code]` | Self: 0.0% (0us) | Total: 1.5% (19.6ms) | Samples: 0

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

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` | Self: 0.0% (0us) | Total: 0.4% (6.4ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (4)

**Calls:**
- `getFunctionDefinitions` (3)
- `getFunctionDefinitions` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `forEach` (1)

**Calls:**
- `init` (1)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1947` | Self: 0.0% (0us) | Total: 2.2% (29.6ms) | Samples: 0

**Called by:**
- `Program:exit` (20)

**Calls:**
- `_precomputeScopes` (14)
- `_precomputeScopes` (5)
- `_precomputeScopes` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2281` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `get references` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.3% (4.8ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` | Self: 0.0% (0us) | Total: 1.1% (14.2ms) | Samples: 0

**Called by:**
- `some` (9)

**Calls:**
- `isReadForItself` (4)
- `isReadForItself` (4)
- `isReadForItself` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4106` | Self: 0.0% (0us) | Total: 0.1% (1.8ms) | Samples: 0

**Called by:**
- `_nodesFromRange` (1)

**Calls:**
- `_computeNodeType` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:961` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `Program:exit` (1)

**Calls:**
- `push` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2276` | Self: 0.0% (0us) | Total: 0.8% (11.6ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (8)

**Calls:**
- `_buildVariable` (4)
- `_buildVariable` (3)
- `_buildVariable` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` | Self: 0.0% (0us) | Total: 7.3% (95.8ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (62)

**Calls:**
- `getDeclaredVariables` (61)
- `getDeclaredVariables` (1)

### `get defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:769` | Self: 0.0% (0us) | Total: 0.2% (2.9ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (2)

**Calls:**
- `_computeVarDefs` (1)
- `_computeVarDefs` (1)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2949` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `nodeViewChain` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1712` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `getDefinedMessageData` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2065` | Self: 0.0% (0us) | Total: 0.4% (5.8ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (4)

**Calls:**
- `_symName` (4)

### `isUnusedExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:506` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `getRhsNode` (1)

**Calls:**
- `get parent` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:613` | Self: 0.0% (0us) | Total: 0.4% (5.7ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (4)

**Calls:**
- `_findLineIdx` (3)
- `_findLineIdx` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3179` | Self: 0.0% (0us) | Total: 0.4% (5.8ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (4)

**Calls:**
- `from` (4)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:551` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isInside` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:286` | Self: 0.0% (0us) | Total: 0.2% (2.9ms) | Samples: 0

**Called by:**
- `parseSource` (2)

**Calls:**
- `DataView` (2)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7581` | Self: 0.0% (0us) | Total: 65.8% (853.6ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (559)

**Calls:**
- `walkNodes` (495)
- `walkNodes` (39)
- `walkNodes` (14)
- `walkNodes` (3)
- `walkNodes` (3)
- `walkNodes` (2)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:435` | Self: 0.0% (0us) | Total: 0.4% (6.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `bound require` (4)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 39.3% | 510.4ms | `[native code]` |
| 31.0% | 402.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 22.0% | 286.1ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 7.1% | 93.2ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.1% | 1.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js` |
| 0.1% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/api.js` |
| 0.1% | 1.4ms | `internal:shared` |
