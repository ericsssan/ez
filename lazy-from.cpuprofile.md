# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 1.33s | 879 | 1.0ms | 307 |

**Top 10:** `parse` 30.9%, `walkNodes` 4.0%, `_nodeViewRaw` 3.6%, `_NodeView` 3.4%, `_NodeView_LR` 3.3%, `Set` 1.9%, `walkNodes` 1.6%, `get references` 1.6%, `_buildReference` 1.6%, `_nodeViewRaw` 1.5%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 30.9% | 413.1ms | 30.9% | 413.1ms | `parse` | `[native code]` |
| 4.0% | 54.2ms | 4.0% | 54.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7080` |
| 3.6% | 48.5ms | 11.0% | 147.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 3.4% | 46.3ms | 3.4% | 46.3ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` |
| 3.3% | 44.1ms | 3.3% | 44.1ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4058` |
| 1.9% | 25.4ms | 2.4% | 33.1ms | `Set` | `[native code]` |
| 1.6% | 22.6ms | 1.6% | 22.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6806` |
| 1.6% | 21.8ms | 3.0% | 41.0ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:823` |
| 1.6% | 21.6ms | 1.7% | 23.2ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2923` |
| 1.5% | 20.0ms | 1.5% | 20.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4100` |
| 1.5% | 20.0ms | 1.5% | 20.0ms | `_Reference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:255` |
| 1.2% | 16.0ms | 1.4% | 19.0ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3235` |
| 1.1% | 15.5ms | 1.1% | 15.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 1.1% | 15.5ms | 1.1% | 15.5ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 1.1% | 15.1ms | 1.2% | 16.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2298` |
| 1.0% | 13.8ms | 1.0% | 13.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1317` |
| 1.0% | 13.7ms | 1.7% | 23.5ms | `arrayIteratorNextHelper` | `[native code]` |
| 1.0% | 13.6ms | 1.0% | 13.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2304` |
| 0.8% | 11.6ms | 0.8% | 11.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3229` |
| 0.8% | 11.1ms | 0.8% | 11.1ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` |
| 0.7% | 10.6ms | 1.2% | 16.8ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1710` |
| 0.7% | 9.8ms | 0.7% | 9.8ms | `typedArrayViewLength` | `[native code]` |
| 0.7% | 9.5ms | 0.7% | 9.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:615` |
| 0.7% | 9.4ms | 0.7% | 9.4ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.6% | 8.8ms | 0.6% | 8.8ms | `_Variable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:868` |
| 0.6% | 8.7ms | 3.7% | 50.5ms | `anonymous` | `[native code]` |
| 0.6% | 8.3ms | 0.6% | 8.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7251` |
| 0.5% | 7.9ms | 3.2% | 42.9ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:542` |
| 0.5% | 7.1ms | 0.5% | 7.1ms | `subarray` | `[native code]` |
| 0.5% | 7.0ms | 0.5% | 7.0ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2182` |
| 0.4% | 6.4ms | 0.5% | 7.8ms | `test` | `[native code]` |
| 0.4% | 6.4ms | 1.6% | 22.4ms | `from` | `[native code]` |
| 0.4% | 6.3ms | 0.4% | 6.3ms | `isRead` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.4% | 6.1ms | 0.5% | 7.5ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` |
| 0.4% | 6.1ms | 1.5% | 21.0ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2288` |
| 0.4% | 6.0ms | 0.4% | 6.0ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2661` |
| 0.4% | 6.0ms | 0.4% | 6.0ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2772` |
| 0.4% | 5.6ms | 11.8% | 158.2ms | `some` | `[native code]` |
| 0.4% | 5.6ms | 0.4% | 5.6ms | `decode` | `[native code]` |
| 0.4% | 5.5ms | 0.4% | 5.5ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.4% | 5.5ms | 0.5% | 6.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 0.3% | 4.9ms | 0.3% | 4.9ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.3% | 4.8ms | 0.7% | 9.8ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:855` |
| 0.3% | 4.7ms | 13.5% | 181.2ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:829` |
| 0.3% | 4.6ms | 1.0% | 14.5ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:839` |
| 0.3% | 4.5ms | 2.2% | 29.8ms | `next` | `[native code]` |
| 0.3% | 4.4ms | 5.4% | 72.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2162` |
| 0.3% | 4.3ms | 9.2% | 122.8ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 0.3% | 4.3ms | 4.2% | 56.2ms | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:790` |
| 0.3% | 4.3ms | 0.3% | 4.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2290` |
| 0.3% | 4.2ms | 0.4% | 5.8ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.3% | 4.2ms | 0.3% | 4.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2507` |
| 0.3% | 4.1ms | 0.3% | 4.1ms | `getUint32` | `[native code]` |
| 0.3% | 4.1ms | 0.3% | 4.1ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6537` |
| 0.3% | 4.1ms | 0.3% | 4.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1191` |
| 0.3% | 4.0ms | 0.6% | 8.7ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2900` |
| 0.3% | 4.0ms | 0.8% | 11.6ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2956` |
| 0.2% | 3.9ms | 0.2% | 3.9ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 3.5ms | 0.2% | 3.5ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:911` |
| 0.2% | 3.4ms | 0.2% | 3.4ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:614` |
| 0.2% | 3.4ms | 0.2% | 3.4ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:442` |
| 0.2% | 3.3ms | 0.2% | 3.3ms | `typedArrayViewIsDetached` | `[native code]` |
| 0.2% | 3.3ms | 0.2% | 3.3ms | `slice` | `[native code]` |
| 0.2% | 3.3ms | 0.2% | 3.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2773` |
| 0.2% | 3.3ms | 1.0% | 14.2ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2842` |
| 0.2% | 3.3ms | 0.2% | 3.3ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:570` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4344` |
| 0.2% | 3.2ms | 0.4% | 6.5ms | `readdirSync` | `[native code]` |
| 0.2% | 3.2ms | 0.6% | 8.0ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` |
| 0.2% | 3.1ms | 1.5% | 20.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2395` |
| 0.2% | 3.1ms | 0.2% | 3.1ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:488` |
| 0.2% | 3.1ms | 0.2% | 3.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4095` |
| 0.2% | 3.0ms | 4.2% | 56.1ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2261` |
| 0.2% | 3.0ms | 0.3% | 4.6ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2868` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6539` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `set` | `[native code]` |
| 0.2% | 2.9ms | 0.2% | 2.9ms | `get eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:778` |
| 0.2% | 2.9ms | 0.2% | 2.9ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 2.9ms | 1.2% | 16.3ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:905` |
| 0.2% | 2.9ms | 100.0% | 2.86s | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 0.2% | 2.9ms | 0.2% | 2.9ms | `get from` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:232` |
| 0.2% | 2.8ms | 0.3% | 4.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1223` |
| 0.2% | 2.7ms | 0.7% | 10.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3203` |
| 0.2% | 2.7ms | 0.2% | 2.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` |
| 0.2% | 2.7ms | 0.2% | 2.7ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1736` |
| 0.2% | 2.7ms | 0.2% | 2.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4111` |
| 0.2% | 2.6ms | 0.2% | 2.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2177` |
| 0.1% | 2.6ms | 0.1% | 2.6ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.1% | 2.6ms | 4.6% | 61.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 0.1% | 2.4ms | 0.5% | 7.4ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2752` |
| 0.1% | 2.1ms | 1.3% | 18.2ms | `parseModule` | `[native code]` |
| 0.1% | 1.8ms | 0.4% | 6.5ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` |
| 0.1% | 1.8ms | 0.2% | 3.6ms | `readFileSync` | `[native code]` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2503` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3952` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:810` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:617` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `get eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3193` |
| 0.1% | 1.7ms | 0.2% | 3.0ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1733` |
| 0.1% | 1.7ms | 0.2% | 3.4ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1516` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2089` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `push` | `[native code]` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2847` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:913` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2063` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2999` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3656` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1735` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:430` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 1.6ms | 0.3% | 4.9ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:506` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2243` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `get` | `[native code]` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3228` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.5ms | 0.2% | 3.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` |
| 0.1% | 1.5ms | 0.4% | 5.9ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2949` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `dlopen` | `[native code]` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 1.5ms | 0.2% | 2.9ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1709` |
| 0.1% | 1.5ms | 0.4% | 6.2ms | `exec` | `[native code]` |
| 0.1% | 1.5ms | 0.4% | 6.3ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `TokenType` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:117` |
| 0.1% | 1.5ms | 0.2% | 3.2ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1722` |
| 0.1% | 1.5ms | 2.5% | 34.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3199` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2668` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `getUpperFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:134` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `/^\s*exported\b/` | `[native code]` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `DataView` | `[native code]` |
| 0.1% | 1.5ms | 0.2% | 3.0ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:922` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:484` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.5ms | 1.7% | 23.9ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3201` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2287` |
| 0.1% | 1.4ms | 1.3% | 17.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2297` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2263` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1708` |
| 0.1% | 1.4ms | 0.6% | 8.5ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3169` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2239` |
| 0.1% | 1.4ms | 9.2% | 123.3ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1020` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3903` |
| 0.1% | 1.4ms | 1.2% | 16.5ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2852` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2213` |
| 0.1% | 1.4ms | 0.9% | 13.1ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 0.1% | 1.3ms | 0.2% | 3.2ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 0.1% | 1.3ms | 0.2% | 2.7ms | `map` | `[native code]` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:1280` |
| 0.1% | 1.3ms | 0.7% | 10.4ms | `forEach` | `[native code]` |
| 0.1% | 1.3ms | 0.4% | 5.9ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3223` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `/^\s*globals?\b/` | `[native code]` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:887` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4110` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2205` |
| 0.1% | 1.3ms | 1.7% | 23.8ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2807` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3165` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_applyLanguageOptions` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 1.1% | 14.7ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1713` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `indexOf` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3248` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:465` |
| 0.0% | 1.3ms | 13.1% | 175.4ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7082` |
| 0.0% | 1.2ms | 14.6% | 196.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_isOptionalTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3885` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `extraForInOfData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:690` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `ownKeys` | `[native code]` |
| 0.0% | 1.2ms | 0.9% | 12.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.0% | 1.2ms | 56.1% | 749.3ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.5% | 7.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2300` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3429` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.4% | 6.1ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:557` |
| 0.0% | 1.0ms | 0.0% | 1.0ms | `_getSharedCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:747` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 100.0% | 2.86s | 0.2% | 2.9ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 66.6% | 889.9ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:304` |
| 66.2% | 883.6ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7603` |
| 58.9% | 787.1ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7319` |
| 58.9% | 787.1ms | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4735` |
| 56.1% | 749.3ms | 0.0% | 1.2ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` |
| 31.5% | 421.3ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:300` |
| 30.9% | 413.1ms | 30.9% | 413.1ms | `parse` | `[native code]` |
| 30.9% | 413.1ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` |
| 14.6% | 196.0ms | 0.0% | 1.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 13.9% | 186.2ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 13.5% | 181.2ms | 0.3% | 4.7ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:829` |
| 13.1% | 175.4ms | 0.0% | 1.3ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` |
| 11.8% | 158.2ms | 0.4% | 5.6ms | `some` | `[native code]` |
| 11.0% | 147.6ms | 3.6% | 48.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 9.8% | 131.9ms | 0.0% | 0us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4137` |
| 9.2% | 123.3ms | 0.1% | 1.4ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1020` |
| 9.2% | 122.8ms | 0.3% | 4.3ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 9.1% | 122.0ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` |
| 9.0% | 120.7ms | 0.0% | 0us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3157` |
| 8.6% | 115.1ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:912` |
| 5.4% | 72.5ms | 0.3% | 4.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2162` |
| 5.3% | 71.6ms | 0.0% | 0us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1211` |
| 5.3% | 71.0ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2897` |
| 4.8% | 65.0ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1024` |
| 4.8% | 65.0ms | 0.0% | 0us | `_ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:991` |
| 4.6% | 61.4ms | 0.1% | 2.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 4.3% | 57.4ms | 0.0% | 0us | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2664` |
| 4.2% | 56.2ms | 0.3% | 4.3ms | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:790` |
| 4.2% | 56.1ms | 0.2% | 3.0ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2261` |
| 4.0% | 54.2ms | 4.0% | 54.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7080` |
| 3.8% | 51.1ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2893` |
| 3.7% | 50.5ms | 0.6% | 8.7ms | `anonymous` | `[native code]` |
| 3.6% | 48.6ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` |
| 3.5% | 47.0ms | 0.0% | 0us | `bound require` | `[native code]` |
| 3.4% | 46.3ms | 3.4% | 46.3ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` |
| 3.4% | 45.6ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:752` |
| 3.4% | 45.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` |
| 3.3% | 44.3ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2141` |
| 3.3% | 44.1ms | 3.3% | 44.1ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4058` |
| 3.3% | 44.1ms | 0.0% | 0us | `require` | `[native code]` |
| 3.2% | 42.9ms | 0.5% | 7.9ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:542` |
| 3.0% | 41.0ms | 1.6% | 21.8ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:823` |
| 2.5% | 34.6ms | 0.1% | 1.5ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3199` |
| 2.4% | 33.1ms | 1.9% | 25.4ms | `Set` | `[native code]` |
| 2.4% | 33.1ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` |
| 2.4% | 33.1ms | 0.0% | 0us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1968` |
| 2.4% | 32.0ms | 0.0% | 0us | `get from` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:236` |
| 2.2% | 29.8ms | 0.3% | 4.5ms | `next` | `[native code]` |
| 1.8% | 24.2ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2748` |
| 1.7% | 23.9ms | 0.1% | 1.5ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3201` |
| 1.7% | 23.8ms | 0.1% | 1.3ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 1.7% | 23.5ms | 1.0% | 13.7ms | `arrayIteratorNextHelper` | `[native code]` |
| 1.7% | 23.2ms | 1.6% | 21.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2923` |
| 1.6% | 22.6ms | 1.6% | 22.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6806` |
| 1.6% | 22.5ms | 0.0% | 0us | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2823` |
| 1.6% | 22.4ms | 0.4% | 6.4ms | `from` | `[native code]` |
| 1.5% | 21.0ms | 0.4% | 6.1ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2288` |
| 1.5% | 20.2ms | 0.2% | 3.1ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2395` |
| 1.5% | 20.0ms | 1.5% | 20.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4100` |
| 1.5% | 20.0ms | 1.5% | 20.0ms | `_Reference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:255` |
| 1.5% | 20.0ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2929` |
| 1.4% | 19.0ms | 1.2% | 16.0ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3235` |
| 1.3% | 18.2ms | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 1.3% | 18.2ms | 0.1% | 2.1ms | `parseModule` | `[native code]` |
| 1.3% | 17.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` |
| 1.3% | 17.9ms | 0.1% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2297` |
| 1.2% | 16.8ms | 0.7% | 10.6ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1710` |
| 1.2% | 16.8ms | 1.1% | 15.1ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2298` |
| 1.2% | 16.5ms | 0.1% | 1.4ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2852` |
| 1.2% | 16.3ms | 0.2% | 2.9ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:905` |
| 1.1% | 15.8ms | 0.0% | 0us | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` |
| 1.1% | 15.5ms | 1.1% | 15.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 1.1% | 15.5ms | 1.1% | 15.5ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 1.1% | 14.7ms | 0.0% | 1.3ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1713` |
| 1.0% | 14.5ms | 0.3% | 4.6ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:839` |
| 1.0% | 14.2ms | 0.2% | 3.3ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2842` |
| 1.0% | 13.8ms | 1.0% | 13.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1317` |
| 1.0% | 13.6ms | 1.0% | 13.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2304` |
| 0.9% | 13.1ms | 0.1% | 1.4ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 0.9% | 13.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` |
| 0.9% | 13.0ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:72` |
| 0.9% | 13.0ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` |
| 0.9% | 12.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` |
| 0.8% | 11.6ms | 0.3% | 4.0ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2956` |
| 0.8% | 11.6ms | 0.8% | 11.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3229` |
| 0.8% | 11.1ms | 0.8% | 11.1ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` |
| 0.8% | 10.9ms | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:518` |
| 0.7% | 10.6ms | 0.2% | 2.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3203` |
| 0.7% | 10.4ms | 0.1% | 1.3ms | `forEach` | `[native code]` |
| 0.7% | 10.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` |
| 0.7% | 9.8ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2086` |
| 0.7% | 9.8ms | 0.3% | 4.8ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:855` |
| 0.7% | 9.8ms | 0.7% | 9.8ms | `typedArrayViewLength` | `[native code]` |
| 0.7% | 9.5ms | 0.7% | 9.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:615` |
| 0.7% | 9.4ms | 0.7% | 9.4ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.6% | 8.8ms | 0.0% | 0us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2803` |
| 0.6% | 8.8ms | 0.6% | 8.8ms | `_Variable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:868` |
| 0.6% | 8.7ms | 0.3% | 4.0ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2900` |
| 0.6% | 8.5ms | 0.1% | 1.4ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3169` |
| 0.6% | 8.3ms | 0.6% | 8.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7251` |
| 0.6% | 8.1ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` |
| 0.6% | 8.0ms | 0.2% | 3.2ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` |
| 0.5% | 7.8ms | 0.0% | 1.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2300` |
| 0.5% | 7.8ms | 0.4% | 6.4ms | `test` | `[native code]` |
| 0.5% | 7.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` |
| 0.5% | 7.5ms | 0.4% | 6.1ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` |
| 0.5% | 7.4ms | 0.1% | 2.4ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2752` |
| 0.5% | 7.1ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7079` |
| 0.5% | 7.1ms | 0.5% | 7.1ms | `subarray` | `[native code]` |
| 0.5% | 7.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:498` |
| 0.5% | 7.1ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:456` |
| 0.5% | 7.0ms | 0.5% | 7.0ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2182` |
| 0.5% | 6.9ms | 0.4% | 5.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 0.4% | 6.5ms | 0.2% | 3.2ms | `readdirSync` | `[native code]` |
| 0.4% | 6.5ms | 0.1% | 1.8ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` |
| 0.4% | 6.3ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1034` |
| 0.4% | 6.3ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1039` |
| 0.4% | 6.3ms | 0.0% | 0us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1250` |
| 0.4% | 6.3ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:613` |
| 0.4% | 6.3ms | 0.1% | 1.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` |
| 0.4% | 6.3ms | 0.4% | 6.3ms | `isRead` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.4% | 6.2ms | 0.1% | 1.5ms | `exec` | `[native code]` |
| 0.4% | 6.1ms | 0.0% | 1.2ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:557` |
| 0.4% | 6.1ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2242` |
| 0.4% | 6.0ms | 0.4% | 6.0ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2661` |
| 0.4% | 6.0ms | 0.4% | 6.0ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2772` |
| 0.4% | 5.9ms | 0.1% | 1.5ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2949` |
| 0.4% | 5.9ms | 0.1% | 1.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3223` |
| 0.4% | 5.8ms | 0.3% | 4.2ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.4% | 5.6ms | 0.4% | 5.6ms | `decode` | `[native code]` |
| 0.4% | 5.5ms | 0.4% | 5.5ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.3% | 5.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` |
| 0.3% | 5.0ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:478` |
| 0.3% | 5.0ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7595` |
| 0.3% | 4.9ms | 0.3% | 4.9ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.3% | 4.9ms | 0.1% | 1.6ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:506` |
| 0.3% | 4.6ms | 0.0% | 0us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2776` |
| 0.3% | 4.6ms | 0.2% | 3.0ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2868` |
| 0.3% | 4.6ms | 0.0% | 0us | `scope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:785` |
| 0.3% | 4.6ms | 0.0% | 0us | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2951` |
| 0.3% | 4.4ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2397` |
| 0.3% | 4.3ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4165` |
| 0.3% | 4.3ms | 0.3% | 4.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2290` |
| 0.3% | 4.2ms | 0.3% | 4.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2507` |
| 0.3% | 4.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.3% | 4.1ms | 0.3% | 4.1ms | `getUint32` | `[native code]` |
| 0.3% | 4.1ms | 0.3% | 4.1ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6537` |
| 0.3% | 4.1ms | 0.3% | 4.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1191` |
| 0.3% | 4.1ms | 0.2% | 2.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1223` |
| 0.2% | 4.0ms | 0.0% | 0us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` |
| 0.2% | 3.9ms | 0.2% | 3.9ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 3.6ms | 0.1% | 1.8ms | `readFileSync` | `[native code]` |
| 0.2% | 3.5ms | 0.2% | 3.5ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:911` |
| 0.2% | 3.4ms | 0.2% | 3.4ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:614` |
| 0.2% | 3.4ms | 0.2% | 3.4ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:442` |
| 0.2% | 3.4ms | 0.0% | 0us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1367` |
| 0.2% | 3.4ms | 0.1% | 1.7ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1516` |
| 0.2% | 3.3ms | 0.2% | 3.3ms | `typedArrayViewIsDetached` | `[native code]` |
| 0.2% | 3.3ms | 0.2% | 3.3ms | `slice` | `[native code]` |
| 0.2% | 3.3ms | 0.2% | 3.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2773` |
| 0.2% | 3.3ms | 0.2% | 3.3ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:570` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4344` |
| 0.2% | 3.2ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:47` |
| 0.2% | 3.2ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:144` |
| 0.2% | 3.2ms | 0.1% | 1.5ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1722` |
| 0.2% | 3.2ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` |
| 0.2% | 3.2ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3968` |
| 0.2% | 3.2ms | 0.0% | 0us | `identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:796` |
| 0.2% | 3.2ms | 0.1% | 1.3ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 0.2% | 3.1ms | 0.0% | 0us | `get identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:796` |
| 0.2% | 3.1ms | 0.2% | 3.1ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:488` |
| 0.2% | 3.1ms | 0.2% | 3.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4095` |
| 0.2% | 3.1ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:612` |
| 0.2% | 3.1ms | 0.0% | 0us | `get defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:790` |
| 0.2% | 3.0ms | 0.1% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` |
| 0.2% | 3.0ms | 0.1% | 1.7ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1733` |
| 0.2% | 3.0ms | 0.1% | 1.5ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:922` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6539` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `set` | `[native code]` |
| 0.2% | 2.9ms | 0.0% | 0us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:688` |
| 0.2% | 2.9ms | 0.2% | 2.9ms | `get eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:778` |
| 0.2% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` |
| 0.2% | 2.9ms | 0.2% | 2.9ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 2.9ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1511` |
| 0.2% | 2.9ms | 0.2% | 2.9ms | `get from` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:232` |
| 0.2% | 2.9ms | 0.1% | 1.5ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1709` |
| 0.2% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.2% | 2.7ms | 0.2% | 2.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` |
| 0.2% | 2.7ms | 0.2% | 2.7ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1736` |
| 0.2% | 2.7ms | 0.2% | 2.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4111` |
| 0.2% | 2.7ms | 0.1% | 1.3ms | `map` | `[native code]` |
| 0.2% | 2.6ms | 0.2% | 2.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2177` |
| 0.1% | 2.6ms | 0.1% | 2.6ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.1% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:35` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2503` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` |
| 0.1% | 1.7ms | 0.0% | 0us | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2949` |
| 0.1% | 1.7ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4162` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3952` |
| 0.1% | 1.7ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:947` |
| 0.1% | 1.7ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:948` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:810` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:617` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `get eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3193` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2089` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `push` | `[native code]` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2847` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:913` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2063` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2999` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3656` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1735` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:430` |
| 0.1% | 1.6ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2216` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2243` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `get` | `[native code]` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3228` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.5ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3233` |
| 0.1% | 1.5ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:288` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `dlopen` | `[native code]` |
| 0.1% | 1.5ms | 0.0% | 0us | `loadBinding` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `[native code]` |
| 0.1% | 1.5ms | 0.0% | 0us | `getTagNames` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:186` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:147` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `TokenType` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:117` |
| 0.1% | 1.5ms | 0.0% | 0us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:689` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2668` |
| 0.1% | 1.5ms | 0.0% | 0us | `isInsideOfStorableFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:630` |
| 0.1% | 1.5ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:662` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `getUpperFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:134` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `/^\s*exported\b/` | `[native code]` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `DataView` | `[native code]` |
| 0.1% | 1.5ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:286` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:484` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.4ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2156` |
| 0.1% | 1.4ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1525` |
| 0.1% | 1.4ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:747` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2287` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2263` |
| 0.1% | 1.4ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:776` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1708` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2239` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.4ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3903` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2213` |
| 0.1% | 1.3ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6709` |
| 0.1% | 1.3ms | 0.0% | 0us | `_getOrBuildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5634` |
| 0.1% | 1.3ms | 0.0% | 0us | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5989` |
| 0.1% | 1.3ms | 0.0% | 0us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5963` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:1280` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `/^\s*globals?\b/` | `[native code]` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:887` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4110` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2205` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2807` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3165` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_applyLanguageOptions` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7598` |
| 0.0% | 1.3ms | 0.0% | 0us | `RuleContext` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4021` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js:133` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` |
| 0.0% | 1.3ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:956` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `indexOf` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3248` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:465` |
| 0.0% | 1.3ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3247` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7082` |
| 0.0% | 1.2ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_isOptionalTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3885` |
| 0.0% | 1.2ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1721` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `extraForInOfData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:690` |
| 0.0% | 1.2ms | 0.0% | 0us | `internal:primordials` | `internal:primordials:71` |
| 0.0% | 1.2ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.0% | 1.2ms | 0.0% | 0us | `makeSafe` | `internal:primordials:30` |
| 0.0% | 1.2ms | 0.0% | 0us | `internal:validators` | `internal:validators:2` |
| 0.0% | 1.2ms | 0.0% | 0us | `node:events` | `node:events:9` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` |
| 0.0% | 1.2ms | 0.0% | 0us | `internal:shared` | `internal:shared:2` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `ownKeys` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3429` |
| 0.0% | 1.2ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2265` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2146` |
| 0.0% | 1.0ms | 0.0% | 1.0ms | `_getSharedCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:747` |
| 0.0% | 1.0ms | 0.0% | 0us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1099` |
| 0.0% | 1.0ms | 0.0% | 0us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4066` |

## Function Details

### `parse`
`[native code]` | Self: 30.9% (413.1ms) | Total: 30.9% (413.1ms) | Samples: 270

**Called by:**
- `parseSource` (270)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7080` | Self: 4.0% (54.2ms) | Total: 4.0% (54.2ms) | Samples: 36

**Called by:**
- `runPlugins` (36)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` | Self: 3.6% (48.5ms) | Total: 11.0% (147.6ms) | Samples: 32

**Called by:**
- `nodeView` (80)
- `_buildReference` (6)
- `get parent` (6)
- `get body` (1)
- `nodeViewChain` (1)
- `_nodesFromRange` (1)
- `get body` (1)
- `get value` (1)

**Calls:**
- `_NodeView_LR` (30)
- `_NodeView` (29)
- `_NodeView_LR` (4)
- `_NodeView` (2)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` | Self: 3.4% (46.3ms) | Total: 3.4% (46.3ms) | Samples: 29

**Called by:**
- `_nodeViewRaw` (29)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4058` | Self: 3.3% (44.1ms) | Total: 3.3% (44.1ms) | Samples: 30

**Called by:**
- `_nodeViewRaw` (30)

### `Set`
`[native code]` | Self: 1.9% (25.4ms) | Total: 2.4% (33.1ms) | Samples: 16

**Called by:**
- `_computeDeclaredVariables` (21)

**Calls:**
- `next` (5)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6806` | Self: 1.6% (22.6ms) | Total: 1.6% (22.6ms) | Samples: 15

**Called by:**
- `runPlugins` (15)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:823` | Self: 1.6% (21.8ms) | Total: 3.0% (41.0ms) | Samples: 14

**Called by:**
- `collectUnusedVariables` (18)
- `(anonymous)` (8)
- `_computeDeclaredVariables` (1)

**Calls:**
- `_computeVariableSynthRefs` (8)
- `_computeVariableSynthRefs` (3)
- `_computeVariableSynthRefs` (1)
- `_computeVariableSynthRefs` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2923` | Self: 1.6% (21.6ms) | Total: 1.7% (23.2ms) | Samples: 14

**Called by:**
- `get references` (15)

**Calls:**
- `get parent` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4100` | Self: 1.5% (20.0ms) | Total: 1.5% (20.0ms) | Samples: 13

**Called by:**
- `nodeView` (6)
- `_buildReference` (4)
- `get parent` (2)
- `_computeVarDefs` (1)

### `_Reference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:255` | Self: 1.5% (20.0ms) | Total: 1.5% (20.0ms) | Samples: 14

**Called by:**
- `_buildReference` (14)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3235` | Self: 1.2% (16.0ms) | Total: 1.4% (19.0ms) | Samples: 11

**Called by:**
- `getDeclaredVariables` (13)

**Calls:**
- `set` (2)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 1.1% (15.5ms) | Total: 1.1% (15.5ms) | Samples: 11

**Called by:**
- `_computeVarDefs` (7)
- `_buildReference` (2)
- `_computeIsStrict` (2)

### `/\/\*([\s\S]*?)\*\//g`
`[native code]` | Self: 1.1% (15.5ms) | Total: 1.1% (15.5ms) | Samples: 10

**Called by:**
- `_buildScopeVarsAndSet` (7)
- `exec` (3)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2298` | Self: 1.1% (15.1ms) | Total: 1.2% (16.8ms) | Samples: 10

**Called by:**
- `_ensureVarsSet` (11)

**Calls:**
- `get` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1317` | Self: 1.0% (13.8ms) | Total: 1.0% (13.8ms) | Samples: 9

**Called by:**
- `_buildReference` (3)
- `(anonymous)` (1)
- `getRhsNode` (1)
- `isForInOfRef` (1)
- `_computeVarDefs` (1)
- `isForInOfRef` (1)
- `_findDefNode` (1)

### `arrayIteratorNextHelper`
`[native code]` | Self: 1.0% (13.7ms) | Total: 1.7% (23.5ms) | Samples: 9

**Called by:**
- `next` (15)
- `from` (1)

**Calls:**
- `typedArrayViewLength` (7)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2304` | Self: 1.0% (13.6ms) | Total: 1.0% (13.6ms) | Samples: 9

**Called by:**
- `_ensureVarsSet` (9)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3229` | Self: 0.8% (11.6ms) | Total: 0.8% (11.6ms) | Samples: 8

**Called by:**
- `getDeclaredVariables` (8)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` | Self: 0.8% (11.1ms) | Total: 0.8% (11.1ms) | Samples: 7

**Called by:**
- `_computeIsStrict` (7)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1710` | Self: 0.7% (10.6ms) | Total: 1.2% (16.8ms) | Samples: 7

**Called by:**
- `_computeIsStrict` (11)

**Calls:**
- `nodeRhs` (2)
- `getUint32` (2)

### `typedArrayViewLength`
`[native code]` | Self: 0.7% (9.8ms) | Total: 0.7% (9.8ms) | Samples: 7

**Called by:**
- `arrayIteratorNextHelper` (7)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:615` | Self: 0.7% (9.5ms) | Total: 0.7% (9.5ms) | Samples: 6

**Called by:**
- `_precomputeScopes` (6)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.7% (9.4ms) | Total: 0.7% (9.4ms) | Samples: 6

**Called by:**
- `commentsInRange` (4)
- `commentsInRange` (2)

### `_Variable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:868` | Self: 0.6% (8.8ms) | Total: 0.6% (8.8ms) | Samples: 6

**Called by:**
- `_buildVariable` (6)

### `anonymous`
`[native code]` | Self: 0.6% (8.7ms) | Total: 3.7% (50.5ms) | Samples: 6

**Called by:**
- `require` (31)
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
- `(anonymous)` (1)
- `internal:shared` (1)
- `node:fs` (1)
- `internal:primordials` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:validators` (1)
- `node:events` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7251` | Self: 0.6% (8.3ms) | Total: 0.6% (8.3ms) | Samples: 5

**Called by:**
- `runPlugins` (5)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:542` | Self: 0.5% (7.9ms) | Total: 3.2% (42.9ms) | Samples: 5

**Called by:**
- `(anonymous)` (28)

**Calls:**
- `get from` (21)
- `get from` (2)

### `subarray`
`[native code]` | Self: 0.5% (7.1ms) | Total: 0.5% (7.1ms) | Samples: 5

**Called by:**
- `_computeDeclaredVariables` (5)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2182` | Self: 0.5% (7.0ms) | Total: 0.5% (7.0ms) | Samples: 5

**Called by:**
- `_buildScopeChildren` (3)
- `_computeVarScope` (1)
- `get from` (1)

### `test`
`[native code]` | Self: 0.4% (6.4ms) | Total: 0.5% (7.8ms) | Samples: 4

**Called by:**
- `_buildScopeVarsAndSet` (3)
- `_precomputeScopes` (2)

**Calls:**
- `/^\s*globals?\b/` (1)

### `from`
`[native code]` | Self: 0.4% (6.4ms) | Total: 1.6% (22.4ms) | Samples: 4

**Called by:**
- `_computeDeclaredVariables` (15)

**Calls:**
- `next` (10)
- `arrayIteratorNextHelper` (1)

### `isRead`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.4% (6.3ms) | Total: 0.4% (6.3ms) | Samples: 4

**Called by:**
- `isReadForItself` (3)
- `(anonymous)` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` | Self: 0.4% (6.1ms) | Total: 0.5% (7.5ms) | Samples: 4

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `get parent` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2288` | Self: 0.4% (6.1ms) | Total: 1.5% (21.0ms) | Samples: 4

**Called by:**
- `_ensureVarsSet` (13)

**Calls:**
- `_ensureDeclSymIndex` (6)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2661` | Self: 0.4% (6.0ms) | Total: 0.4% (6.0ms) | Samples: 4

**Called by:**
- `_ensureChildren` (4)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2772` | Self: 0.4% (6.0ms) | Total: 0.4% (6.0ms) | Samples: 4

**Called by:**
- `_buildScopeVarsAndSet` (3)
- `_computeDeclaredVariables` (1)

### `some`
`[native code]` | Self: 0.4% (5.6ms) | Total: 11.8% (158.2ms) | Samples: 4

**Called by:**
- `collectUnusedVariables` (52)
- `isAfterLastUsedArg` (30)
- `isUsedVariable` (13)
- `collectUnusedVariables` (9)

**Calls:**
- `(anonymous)` (40)
- `(anonymous)` (30)
- `(anonymous)` (12)
- `(anonymous)` (8)
- `(anonymous)` (5)
- `(anonymous)` (3)
- `(anonymous)` (2)

### `decode`
`[native code]` | Self: 0.4% (5.6ms) | Total: 0.4% (5.6ms) | Samples: 4

**Called by:**
- `get source` (3)
- `_buildSymNameCache` (1)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.4% (5.5ms) | Total: 0.4% (5.5ms) | Samples: 4

**Called by:**
- `_nodeViewRaw` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` | Self: 0.4% (5.5ms) | Total: 0.5% (6.9ms) | Samples: 4

**Called by:**
- `some` (5)

**Calls:**
- `get parent` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` | Self: 0.3% (4.9ms) | Total: 0.3% (4.9ms) | Samples: 3

**Called by:**
- `collectUnusedVariables` (3)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:855` | Self: 0.3% (4.8ms) | Total: 0.7% (9.8ms) | Samples: 3

**Called by:**
- `_symName` (6)

**Calls:**
- `slice` (2)
- `decode` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:829` | Self: 0.3% (4.7ms) | Total: 13.5% (181.2ms) | Samples: 3

**Called by:**
- `collectUnusedVariables` (98)
- `(anonymous)` (22)
- `isUsedVariable` (1)

**Calls:**
- `_buildReference` (45)
- `_buildReference` (35)
- `_buildReference` (15)
- `_buildReference` (14)
- `_buildReference` (6)
- `_buildReference` (3)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:839` | Self: 0.3% (4.6ms) | Total: 1.0% (14.5ms) | Samples: 3

**Called by:**
- `_ensureDeclSymIndex` (6)
- `_buildVariable` (3)

**Calls:**
- `_buildSymNameCache` (6)

### `next`
`[native code]` | Self: 0.3% (4.5ms) | Total: 2.2% (29.8ms) | Samples: 3

**Called by:**
- `from` (10)
- `Set` (5)
- `_computeDeclaredVariables` (5)

**Calls:**
- `arrayIteratorNextHelper` (15)
- `typedArrayViewIsDetached` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2162` | Self: 0.3% (4.4ms) | Total: 5.4% (72.5ms) | Samples: 3

**Called by:**
- `_buildScopeChildren` (29)
- `_buildScope` (10)
- `get from` (9)

**Calls:**
- `_computeIsStrict` (37)
- `_computeIsStrict` (4)
- `_computeIsStrict` (1)
- `_computeIsStrict` (1)
- `_computeIsStrict` (1)
- `_computeIsStrict` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` | Self: 0.3% (4.3ms) | Total: 9.2% (122.8ms) | Samples: 3

**Called by:**
- `collectUnusedVariables` (78)
- `Program:exit` (2)

**Calls:**
- `some` (52)
- `isUsedVariable` (15)
- `isUsedVariable` (10)

### `defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:790` | Self: 0.3% (4.3ms) | Total: 4.2% (56.2ms) | Samples: 3

**Called by:**
- `collectUnusedVariables` (31)
- `get identifiers` (2)
- `identifiers` (2)
- `_ensureVarsSet` (1)
- `getFunctionDefinitions` (1)
- `isAfterLastUsedArg` (1)

**Calls:**
- `_computeVarDefs` (14)
- `_computeVarDefs` (11)
- `_computeVarDefs` (9)
- `_computeVarDefs` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2290` | Self: 0.3% (4.3ms) | Total: 0.3% (4.3ms) | Samples: 3

**Called by:**
- `_ensureVarsSet` (3)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` | Self: 0.3% (4.2ms) | Total: 0.4% (5.8ms) | Samples: 3

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `get parent` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2507` | Self: 0.3% (4.2ms) | Total: 0.3% (4.2ms) | Samples: 3

**Called by:**
- `_ensureVarsSet` (3)

### `getUint32`
`[native code]` | Self: 0.3% (4.1ms) | Total: 0.3% (4.1ms) | Samples: 3

**Called by:**
- `get body` (2)
- `get body` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6537` | Self: 0.3% (4.1ms) | Total: 0.3% (4.1ms) | Samples: 3

**Called by:**
- `walkNodes` (3)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1191` | Self: 0.3% (4.1ms) | Total: 0.3% (4.1ms) | Samples: 3

**Called by:**
- `_computeVarDefs` (2)
- `_findDefNode` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2900` | Self: 0.3% (4.0ms) | Total: 0.6% (8.7ms) | Samples: 3

**Called by:**
- `get references` (6)

**Calls:**
- `_buildVariable` (3)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2956` | Self: 0.3% (4.0ms) | Total: 0.8% (11.6ms) | Samples: 3

**Called by:**
- `get references` (8)

**Calls:**
- `nodeView` (4)
- `_nodeViewRaw` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.2% (3.9ms) | Total: 0.2% (3.9ms) | Samples: 3

**Called by:**
- `get references` (3)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:911` | Self: 0.2% (3.5ms) | Total: 0.2% (3.5ms) | Samples: 2

**Called by:**
- `get` (2)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:614` | Self: 0.2% (3.4ms) | Total: 0.2% (3.4ms) | Samples: 2

**Called by:**
- `_precomputeScopes` (2)

### `isSelfReference`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:442` | Self: 0.2% (3.4ms) | Total: 0.2% (3.4ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `typedArrayViewIsDetached`
`[native code]` | Self: 0.2% (3.3ms) | Total: 0.2% (3.3ms) | Samples: 2

**Called by:**
- `next` (2)

### `slice`
`[native code]` | Self: 0.2% (3.3ms) | Total: 0.2% (3.3ms) | Samples: 2

**Called by:**
- `_buildSymNameCache` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2773` | Self: 0.2% (3.3ms) | Total: 0.2% (3.3ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2842` | Self: 0.2% (3.3ms) | Total: 1.0% (14.2ms) | Samples: 2

**Called by:**
- `defs` (9)

**Calls:**
- `_findDefNode` (7)

### `nodeRhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:570` | Self: 0.2% (3.3ms) | Total: 0.2% (3.3ms) | Samples: 2

**Called by:**
- `get body` (2)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4344` | Self: 0.2% (3.2ms) | Total: 0.2% (3.2ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `readdirSync`
`[native code]` | Self: 0.2% (3.2ms) | Total: 0.4% (6.5ms) | Samples: 2

**Called by:**
- `readdirSync` (2)
- `loadCoreRules` (2)

**Calls:**
- `readdirSync` (2)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` | Self: 0.2% (3.2ms) | Total: 0.6% (8.0ms) | Samples: 2

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `isRead` (3)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2395` | Self: 0.2% (3.1ms) | Total: 1.5% (20.2ms) | Samples: 2

**Called by:**
- `_ensureVarsSet` (13)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (7)
- `exec` (4)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:488` | Self: 0.2% (3.1ms) | Total: 0.2% (3.1ms) | Samples: 2

**Called by:**
- `getRhsNode` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4095` | Self: 0.2% (3.1ms) | Total: 0.2% (3.1ms) | Samples: 2

**Called by:**
- `_nodesFromRange` (1)
- `_computeVariableSynthRefs` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2261` | Self: 0.2% (3.0ms) | Total: 4.2% (56.1ms) | Samples: 2

**Called by:**
- `_buildScope` (37)

**Calls:**
- `get body` (11)
- `get body` (10)
- `get body` (7)
- `get body` (2)
- `get body` (2)
- `get body` (2)
- `get body` (1)

### `_computeVarScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2868` | Self: 0.2% (3.0ms) | Total: 0.3% (4.6ms) | Samples: 2

**Called by:**
- `scope` (3)

**Calls:**
- `_buildScope` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6539` | Self: 0.2% (3.0ms) | Total: 0.2% (3.0ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `set`
`[native code]` | Self: 0.2% (3.0ms) | Total: 0.2% (3.0ms) | Samples: 2

**Called by:**
- `_computeDeclaredVariables` (2)

### `get eslintUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:778` | Self: 0.2% (2.9ms) | Total: 0.2% (2.9ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (2)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.2% (2.9ms) | Total: 0.2% (2.9ms) | Samples: 2

**Called by:**
- `_nodeViewRaw` (2)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:905` | Self: 0.2% (2.9ms) | Total: 1.2% (16.3ms) | Samples: 2

**Called by:**
- `get body` (9)
- `get value` (2)

**Calls:**
- `nodeView` (6)
- `_nodeViewRaw` (1)
- `nodeView` (1)
- `_nodeViewRaw` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` | Self: 0.2% (2.9ms) | Total: 100.0% (2.86s) | Samples: 2

**Called by:**
- `collectUnusedVariables` (1434)
- `Program:exit` (467)

**Calls:**
- `collectUnusedVariables` (1434)
- `collectUnusedVariables` (125)
- `collectUnusedVariables` (116)
- `collectUnusedVariables` (102)
- `collectUnusedVariables` (78)
- `collectUnusedVariables` (33)
- `collectUnusedVariables` (4)
- `collectUnusedVariables` (2)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)

### `get from`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:232` | Self: 0.2% (2.9ms) | Total: 0.2% (2.9ms) | Samples: 2

**Called by:**
- `getRhsNode` (2)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1223` | Self: 0.2% (2.8ms) | Total: 0.3% (4.1ms) | Samples: 2

**Called by:**
- `_buildReference` (3)

**Calls:**
- `_isOptionalTag` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3203` | Self: 0.2% (2.7ms) | Total: 0.7% (10.6ms) | Samples: 2

**Called by:**
- `getDeclaredVariables` (7)

**Calls:**
- `next` (5)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` | Self: 0.2% (2.7ms) | Total: 0.2% (2.7ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (2)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1736` | Self: 0.2% (2.7ms) | Total: 0.2% (2.7ms) | Samples: 2

**Called by:**
- `_computeIsStrict` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4111` | Self: 0.2% (2.7ms) | Total: 0.2% (2.7ms) | Samples: 2

**Called by:**
- `_buildReference` (1)
- `nodeView` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2177` | Self: 0.2% (2.6ms) | Total: 0.2% (2.6ms) | Samples: 2

**Called by:**
- `_buildScopeChildren` (2)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` | Self: 0.1% (2.6ms) | Total: 0.1% (2.6ms) | Samples: 2

**Called by:**
- `isUsedVariable` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` | Self: 0.1% (2.6ms) | Total: 4.6% (61.4ms) | Samples: 2

**Called by:**
- `some` (40)

**Calls:**
- `getRhsNode` (28)
- `getRhsNode` (4)
- `getRhsNode` (4)
- `getRhsNode` (2)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2752` | Self: 0.1% (2.4ms) | Total: 0.5% (7.4ms) | Samples: 2

**Called by:**
- `getScope` (5)

**Calls:**
- `test` (2)
- `/^\s*exported\b/` (1)

### `parseModule`
`[native code]` | Self: 0.1% (2.1ms) | Total: 1.3% (18.2ms) | Samples: 1

**Called by:**
- `async (anonymous)` (12)

**Calls:**
- `(anonymous)` (9)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` | Self: 0.1% (1.8ms) | Total: 0.4% (6.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `isInLoop` (2)
- `isInLoop` (1)

### `readFileSync`
`[native code]` | Self: 0.1% (1.8ms) | Total: 0.2% (3.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)
- `readFileSync` (1)

**Calls:**
- `readFileSync` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2503` | Self: 0.1% (1.8ms) | Total: 0.1% (1.8ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `isSelfReference`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` | Self: 0.1% (1.8ms) | Total: 0.1% (1.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_isChainNode`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `nodeViewChain` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3952` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `report` (1)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:810` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `get name` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:617` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `get eslintUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3193` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1733` | Self: 0.1% (1.7ms) | Total: 0.2% (3.0ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (2)

**Calls:**
- `_nodeViewRaw` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1516` | Self: 0.1% (1.7ms) | Total: 0.2% (3.4ms) | Samples: 1

**Called by:**
- `get parent` (2)

**Calls:**
- `get loc` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2089` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `push`
`[native code]` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2847` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `defs` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:913` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `get` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2063` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2999` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `get references` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3656` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `get value` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1735` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:430` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `parseSource` (1)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `get name` (1)

### `isUnusedExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:506` | Self: 0.1% (1.6ms) | Total: 0.3% (4.9ms) | Samples: 1

**Called by:**
- `getRhsNode` (3)

**Calls:**
- `get parent` (2)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2243` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `get`
`[native code]` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3228` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` | Self: 0.1% (1.5ms) | Total: 0.2% (3.0ms) | Samples: 1

**Called by:**
- `some` (2)

**Calls:**
- `isRead` (1)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2949` | Self: 0.1% (1.5ms) | Total: 0.4% (5.9ms) | Samples: 1

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `nodeViewChain` (2)

### `dlopen`
`[native code]` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `_nodesFromRange` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1709` | Self: 0.1% (1.5ms) | Total: 0.2% (2.9ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (2)

**Calls:**
- `getUint32` (1)

### `exec`
`[native code]` | Self: 0.1% (1.5ms) | Total: 0.4% (6.2ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (4)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (3)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` | Self: 0.1% (1.5ms) | Total: 0.4% (6.3ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (4)

**Calls:**
- `get eslintUsed` (2)
- `get eslintUsed` (1)

### `TokenType`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:117` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1722` | Self: 0.1% (1.5ms) | Total: 0.2% (3.2ms) | Samples: 1

**Called by:**
- `isForInOfRef` (1)
- `isForInOfRef` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3199` | Self: 0.1% (1.5ms) | Total: 2.5% (34.6ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (22)

**Calls:**
- `Set` (21)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2668` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `_ensureChildren` (1)

### `getUpperFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:134` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `isInsideOfStorableFunction` (1)

### `/^\s*exported\b/`
`[native code]` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `DataView`
`[native code]` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:922` | Self: 0.1% (1.5ms) | Total: 0.2% (3.0ms) | Samples: 1

**Called by:**
- `get` (1)
- `_ensureVarsSet` (1)

**Calls:**
- `defs` (1)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:484` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `getRhsNode` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `getScope` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3201` | Self: 0.1% (1.5ms) | Total: 1.7% (23.9ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (16)

**Calls:**
- `from` (15)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2287` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2297` | Self: 0.1% (1.4ms) | Total: 1.3% (17.9ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (12)

**Calls:**
- `_buildVariable` (4)
- `_buildVariable` (3)
- `_buildVariable` (2)
- `_buildVariable` (1)
- `_buildVariable` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2263` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1708` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3169` | Self: 0.1% (1.4ms) | Total: 0.6% (8.5ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (6)

**Calls:**
- `subarray` (5)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2239` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1020` | Self: 0.1% (1.4ms) | Total: 9.2% (123.3ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (80)

**Calls:**
- `_ensureVarsSet` (75)
- `_ensureVarsSet` (2)
- `_ensureVarsSet` (1)
- `_ensureVarsSet` (1)

### `isFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3903` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `report` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2852` | Self: 0.1% (1.4ms) | Total: 1.2% (16.5ms) | Samples: 1

**Called by:**
- `defs` (11)
- `get defs` (1)

**Calls:**
- `get parent` (7)
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2213` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` | Self: 0.1% (1.4ms) | Total: 0.9% (13.1ms) | Samples: 1

**Called by:**
- `isUsedVariable` (8)

**Calls:**
- `forEach` (6)
- `defs` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` | Self: 0.1% (1.3ms) | Total: 0.2% (3.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `get parent` (1)

### `map`
`[native code]` | Self: 0.1% (1.3ms) | Total: 0.2% (2.7ms) | Samples: 1

**Called by:**
- `_buildTemplate` (1)
- `_computeDeclaredVariables` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:1280` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `forEach`
`[native code]` | Self: 0.1% (1.3ms) | Total: 0.7% (10.4ms) | Samples: 1

**Called by:**
- `getFunctionDefinitions` (6)

**Calls:**
- `(anonymous)` (4)
- `(anonymous)` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3223` | Self: 0.1% (1.3ms) | Total: 0.4% (5.9ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (4)

**Calls:**
- `_buildVariable` (2)
- `_buildVariable` (1)

### `/^\s*globals?\b/`
`[native code]` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 1

**Called by:**
- `test` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:887` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4110` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 1

**Called by:**
- `nodeViewChain` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2205` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` | Self: 0.1% (1.3ms) | Total: 1.7% (23.8ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (15)

**Calls:**
- `some` (13)
- `get references` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2807` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3165` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `_applyLanguageOptions`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `RuleContext` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1713` | Self: 0.0% (1.3ms) | Total: 1.1% (14.7ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (10)

**Calls:**
- `_nodesFromRange` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `indexOf`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3248` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:465` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `forEach` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` | Self: 0.0% (1.3ms) | Total: 13.1% (175.4ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (116)

**Calls:**
- `isAfterLastUsedArg` (81)
- `isAfterLastUsedArg` (30)
- `isAfterLastUsedArg` (3)
- `isAfterLastUsedArg` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7082` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` | Self: 0.0% (1.2ms) | Total: 14.6% (196.0ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (102)
- `Program:exit` (27)

**Calls:**
- `get` (80)
- `get` (44)
- `get` (4)

### `_isOptionalTag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3885` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `get parent` (1)

### `extraForInOfData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:690` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `get body` (1)

### `ownKeys`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `makeSafe` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` | Self: 0.0% (1.2ms) | Total: 0.9% (12.2ms) | Samples: 1

**Called by:**
- `some` (8)

**Calls:**
- `isReadForItself` (5)
- `isReadForItself` (1)
- `isReadForItself` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` | Self: 0.0% (1.2ms) | Total: 56.1% (749.3ms) | Samples: 1

**Called by:**
- `_invokeFused` (497)

**Calls:**
- `collectUnusedVariables` (467)
- `collectUnusedVariables` (27)
- `collectUnusedVariables` (2)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `get references` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2300` | Self: 0.0% (1.2ms) | Total: 0.5% (7.8ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (5)

**Calls:**
- `get identifiers` (2)
- `identifiers` (1)
- `push` (1)

### `get directive`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3429` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:557` | Self: 0.0% (1.2ms) | Total: 0.4% (6.1ms) | Samples: 1

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `isUnusedExpression` (3)

### `_getSharedCaches`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:747` | Self: 0.0% (1.0ms) | Total: 0.0% (1.0ms) | Samples: 1

**Called by:**
- `reset` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2748` | Self: 0.0% (0us) | Total: 1.8% (24.2ms) | Samples: 0

**Called by:**
- `getScope` (15)

**Calls:**
- `commentsInRange` (6)
- `commentsInRange` (4)
- `commentsInRange` (2)
- `commentsInRange` (2)
- `commentsInRange` (1)

### `_getOrBuildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5634` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_buildPlan` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3968` | Self: 0.0% (0us) | Total: 0.2% (3.2ms) | Samples: 0

**Called by:**
- `Program:exit` (2)

**Calls:**
- `_execReport` (1)
- `_execReport` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2242` | Self: 0.0% (0us) | Total: 0.4% (6.1ms) | Samples: 0

**Called by:**
- `_buildScope` (4)

**Calls:**
- `get parent` (2)
- `get parent` (2)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2929` | Self: 0.0% (0us) | Total: 1.5% (20.0ms) | Samples: 0

**Called by:**
- `get references` (14)

**Calls:**
- `_Reference` (14)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` | Self: 0.0% (0us) | Total: 0.3% (5.2ms) | Samples: 0

**Called by:**
- `some` (3)

**Calls:**
- `isSelfReference` (2)
- `isSelfReference` (1)

### `RuleContext`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4021` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_applyLanguageOptions` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:300` | Self: 0.0% (0us) | Total: 31.5% (421.3ms) | Samples: 0

**Calls:**
- `parseSource` (270)
- `parseSource` (4)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2216` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `get from` (1)

**Calls:**
- `get name` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7603` | Self: 0.0% (0us) | Total: 66.2% (883.6ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (585)

**Calls:**
- `walkNodes` (521)
- `walkNodes` (36)
- `walkNodes` (15)
- `walkNodes` (5)
- `walkNodes` (5)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:478` | Self: 0.0% (0us) | Total: 0.3% (5.0ms) | Samples: 0

**Called by:**
- `parseSource` (2)

**Calls:**
- `CfgGraph` (1)
- `CfgGraph` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:144` | Self: 0.0% (0us) | Total: 0.2% (3.2ms) | Samples: 0

**Calls:**
- `loadCoreRules` (2)

### `get from`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:236` | Self: 0.0% (0us) | Total: 2.4% (32.0ms) | Samples: 0

**Called by:**
- `getRhsNode` (21)

**Calls:**
- `_buildScope` (10)
- `_buildScope` (9)
- `_buildScope` (1)
- `_buildScope` (1)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:47` | Self: 0.0% (0us) | Total: 0.2% (3.2ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (2)

**Calls:**
- `readdirSync` (2)

### `internal:shared`
`internal:shared:2` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1024` | Self: 0.0% (0us) | Total: 4.8% (65.0ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (44)

**Calls:**
- `_ensureChildren` (44)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:956` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `indexOf` (1)

### `makeSafe`
`internal:primordials:30` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `internal:primordials` (1)

**Calls:**
- `ownKeys` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:912` | Self: 0.0% (0us) | Total: 8.6% (115.1ms) | Samples: 0

**Called by:**
- `get` (75)

**Calls:**
- `_buildScopeVarsAndSet` (13)
- `_buildScopeVarsAndSet` (13)
- `_buildScopeVarsAndSet` (12)
- `_buildScopeVarsAndSet` (11)
- `_buildScopeVarsAndSet` (9)
- `_buildScopeVarsAndSet` (5)
- `_buildScopeVarsAndSet` (3)
- `_buildScopeVarsAndSet` (3)
- `_buildScopeVarsAndSet` (3)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` | Self: 0.0% (0us) | Total: 3.4% (45.6ms) | Samples: 0

**Called by:**
- `some` (30)

**Calls:**
- `get references` (22)
- `get references` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` | Self: 0.0% (0us) | Total: 0.9% (13.0ms) | Samples: 0

**Called by:**
- `parseModule` (9)

**Calls:**
- `async (anonymous)` (9)

### `internal:primordials`
`internal:primordials:71` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `makeSafe` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4137` | Self: 0.0% (0us) | Total: 9.8% (131.9ms) | Samples: 0

**Called by:**
- `get parent` (38)
- `_buildReference` (24)
- `_computeVarDefs` (14)
- `_nodesFromRange` (6)
- `_computeVariableSynthRefs` (4)
- `_buildScope` (1)

**Calls:**
- `_nodeViewRaw` (80)
- `_nodeViewRaw` (6)
- `_nodeViewRaw` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:612` | Self: 0.0% (0us) | Total: 0.2% (3.1ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (2)

**Calls:**
- `_findLineIdx` (2)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` | Self: 0.0% (0us) | Total: 2.4% (33.1ms) | Samples: 0

**Called by:**
- `_invokeFused` (21)

**Calls:**
- `getScope` (21)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6709` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_getOrBuildPlan` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2823` | Self: 0.0% (0us) | Total: 1.6% (22.5ms) | Samples: 0

**Called by:**
- `defs` (14)
- `get defs` (1)

**Calls:**
- `nodeView` (14)
- `_nodeViewRaw` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2146` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_buildScopeChildren` (1)

**Calls:**
- `nodeView` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:304` | Self: 0.0% (0us) | Total: 66.6% (889.9ms) | Samples: 0

**Calls:**
- `runPlugins` (585)
- `runPlugins` (4)
- `runPlugins` (1)

### `get identifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:796` | Self: 0.0% (0us) | Total: 0.2% (3.1ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (2)

**Calls:**
- `defs` (2)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1525` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `_buildScope` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7598` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `RuleContext` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` | Self: 0.0% (0us) | Total: 13.9% (186.2ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (125)

**Calls:**
- `get references` (98)
- `get references` (18)
- `some` (9)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1034` | Self: 0.0% (0us) | Total: 0.4% (6.3ms) | Samples: 0

**Called by:**
- `get` (4)

**Calls:**
- `_ensureVarsSet` (1)
- `_ensureVarsSet` (1)
- `_ensureVarsSet` (1)
- `_ensureVarsSet` (1)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` | Self: 0.0% (0us) | Total: 0.2% (4.0ms) | Samples: 0

**Called by:**
- `runPlugins` (3)

**Calls:**
- `decode` (3)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2156` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `_buildScopeChildren` (1)

**Calls:**
- `get value` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2141` | Self: 0.0% (0us) | Total: 3.3% (44.3ms) | Samples: 0

**Called by:**
- `_buildScope` (18)
- `get from` (10)
- `_buildScopeChildren` (1)

**Calls:**
- `_buildScope` (18)
- `_buildScope` (10)
- `_buildScope` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2893` | Self: 0.0% (0us) | Total: 3.8% (51.1ms) | Samples: 0

**Called by:**
- `get references` (35)

**Calls:**
- `nodeView` (24)
- `_nodeViewRaw` (6)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (1)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:456` | Self: 0.0% (0us) | Total: 0.5% (7.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `bound require` (5)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1511` | Self: 0.0% (0us) | Total: 0.2% (2.9ms) | Samples: 0

**Called by:**
- `get parent` (2)

**Calls:**
- `_nodesFromRange` (2)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:752` | Self: 0.0% (0us) | Total: 3.4% (45.6ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (30)

**Calls:**
- `some` (30)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1367` | Self: 0.0% (0us) | Total: 0.2% (3.4ms) | Samples: 0

**Called by:**
- `_buildScope` (1)
- `_ensureVarsSet` (1)

**Calls:**
- `_identAt` (1)
- `_identAt` (1)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1968` | Self: 0.0% (0us) | Total: 2.4% (33.1ms) | Samples: 0

**Called by:**
- `Program:exit` (21)

**Calls:**
- `_precomputeScopes` (15)
- `_precomputeScopes` (5)
- `_precomputeScopes` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2951` | Self: 0.0% (0us) | Total: 0.3% (4.6ms) | Samples: 0

**Called by:**
- `get references` (3)

**Calls:**
- `scope` (3)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:662` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isInsideOfStorableFunction` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js:133` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7079` | Self: 0.0% (0us) | Total: 0.5% (7.1ms) | Samples: 0

**Called by:**
- `runPlugins` (5)

**Calls:**
- `getDFSEvents` (3)
- `getDFSEvents` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` | Self: 0.0% (0us) | Total: 1.3% (17.9ms) | Samples: 0

**Called by:**
- `some` (12)

**Calls:**
- `isForInOfRef` (5)
- `isForInOfRef` (4)
- `isForInOfRef` (2)
- `isForInOfRef` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5963` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `_getOrBuildPlan` (1)

**Calls:**
- `_buildTemplate` (1)

### `isInsideOfStorableFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:630` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `isReadForItself` (1)

**Calls:**
- `getUpperFunction` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` | Self: 0.0% (0us) | Total: 0.2% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` | Self: 0.0% (0us) | Total: 0.9% (13.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (9)

**Calls:**
- `async (anonymous)` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:498` | Self: 0.0% (0us) | Total: 0.5% (7.1ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `patchAstUtils` (5)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` | Self: 0.0% (0us) | Total: 0.6% (8.1ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (4)

**Calls:**
- `AstView` (2)
- `AstView` (1)
- `AstView` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1721` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `isForInOfRef` (1)

**Calls:**
- `extraForInOfData` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2803` | Self: 0.0% (0us) | Total: 0.6% (8.8ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (4)
- `_computeDeclaredVariables` (2)

**Calls:**
- `_Variable` (6)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1211` | Self: 0.0% (0us) | Total: 5.3% (71.6ms) | Samples: 0

**Called by:**
- `_buildReference` (38)
- `isUnusedExpression` (2)
- `_computeIsStrict` (2)
- `_buildReference` (1)
- `collectUnusedVariables` (1)
- `_computeVarDefs` (1)
- `_findDefNode` (1)

**Calls:**
- `nodeView` (38)
- `_nodeViewRaw` (6)
- `_nodeViewRaw` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:35` | Self: 0.0% (0us) | Total: 0.1% (1.8ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `readFileSync` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:776` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `identifiers` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2776` | Self: 0.0% (0us) | Total: 0.3% (4.6ms) | Samples: 0

**Called by:**
- `_buildReference` (3)

**Calls:**
- `_symName` (3)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4066` | Self: 0.0% (0us) | Total: 0.0% (1.0ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `reset` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` | Self: 0.0% (0us) | Total: 0.2% (3.2ms) | Samples: 0

**Called by:**
- `_invokeFused` (2)

**Calls:**
- `report` (2)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3233` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (1)

**Calls:**
- `get references` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:147` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `TokenType` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1099` | Self: 0.0% (0us) | Total: 0.0% (1.0ms) | Samples: 0

**Called by:**
- `reset` (1)

**Calls:**
- `_getSharedCaches` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2265` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_buildScope` (1)

**Calls:**
- `get directive` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2897` | Self: 0.0% (0us) | Total: 5.3% (71.0ms) | Samples: 0

**Called by:**
- `get references` (45)
- `_ensureVarsSet` (1)

**Calls:**
- `get parent` (38)
- `get parent` (3)
- `get parent` (3)
- `get parent` (2)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 3.3% (44.1ms) | Samples: 0

**Called by:**
- `bound require` (31)

**Calls:**
- `anonymous` (31)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 1.3% (18.2ms) | Samples: 0

**Calls:**
- `parseModule` (12)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4162` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `get init` (1)

**Calls:**
- `_isChainNode` (1)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 3.5% (47.0ms) | Samples: 0

**Called by:**
- `async (anonymous)` (9)
- `(anonymous)` (7)
- `patchAstUtils` (5)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `loadBinding` (1)

**Calls:**
- `require` (31)
- `(anonymous)` (1)
- `anonymous` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` | Self: 0.0% (0us) | Total: 30.9% (413.1ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (270)

**Calls:**
- `parse` (270)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1039` | Self: 0.0% (0us) | Total: 0.4% (6.3ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (4)

**Calls:**
- `_ensureVarsSet` (4)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` | Self: 0.0% (0us) | Total: 3.6% (48.6ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (33)

**Calls:**
- `defs` (31)
- `get defs` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` | Self: 0.0% (0us) | Total: 0.7% (10.0ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `get init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2949` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `nodeViewChain` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7595` | Self: 0.0% (0us) | Total: 0.3% (5.0ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (4)

**Calls:**
- `get source` (3)
- `reset` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2664` | Self: 0.0% (0us) | Total: 4.3% (57.4ms) | Samples: 0

**Called by:**
- `_ensureChildren` (39)

**Calls:**
- `_buildScope` (29)
- `_buildScope` (3)
- `_buildScope` (2)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `scope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:785` | Self: 0.0% (0us) | Total: 0.3% (4.6ms) | Samples: 0

**Called by:**
- `_computeVariableSynthRefs` (3)

**Calls:**
- `_computeVarScope` (3)

### `loadBinding`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `getTagNames` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `bound require` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7319` | Self: 0.0% (0us) | Total: 58.9% (787.1ms) | Samples: 0

**Called by:**
- `runPlugins` (521)

**Calls:**
- `_invokeFused` (521)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2397` | Self: 0.0% (0us) | Total: 0.3% (4.4ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (3)

**Calls:**
- `test` (3)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:688` | Self: 0.0% (0us) | Total: 0.2% (2.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `get body` (1)
- `get body` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:947` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `_buildReference` (1)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:948` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `get name` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `get parent` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4165` | Self: 0.0% (0us) | Total: 0.3% (4.3ms) | Samples: 0

**Called by:**
- `init` (2)

**Calls:**
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:747` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `defs` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:689` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get body` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `isFunction` (1)

### `identifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:796` | Self: 0.0% (0us) | Total: 0.2% (3.2ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)
- `collectUnusedVariables` (1)

**Calls:**
- `defs` (2)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1250` | Self: 0.0% (0us) | Total: 0.4% (6.3ms) | Samples: 0

**Called by:**
- `_findDefNode` (4)

**Calls:**
- `get value` (2)
- `get value` (2)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:72` | Self: 0.0% (0us) | Total: 0.9% (13.0ms) | Samples: 0

**Called by:**
- `async (anonymous)` (9)

**Calls:**
- `bound require` (9)

### `node:events`
`node:events:9` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.2% (2.8ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` | Self: 0.0% (0us) | Total: 1.1% (15.8ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (10)

**Calls:**
- `getFunctionDefinitions` (8)
- `getFunctionDefinitions` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.3% (4.2ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3157` | Self: 0.0% (0us) | Total: 9.0% (120.7ms) | Samples: 0

**Called by:**
- `isAfterLastUsedArg` (80)

**Calls:**
- `_computeDeclaredVariables` (22)
- `_computeDeclaredVariables` (16)
- `_computeDeclaredVariables` (13)
- `_computeDeclaredVariables` (8)
- `_computeDeclaredVariables` (7)
- `_computeDeclaredVariables` (6)
- `_computeDeclaredVariables` (4)
- `_computeDeclaredVariables` (1)
- `_computeDeclaredVariables` (1)
- `_computeDeclaredVariables` (1)
- `_computeDeclaredVariables` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` | Self: 0.0% (0us) | Total: 0.5% (7.7ms) | Samples: 0

**Called by:**
- `forEach` (4)

**Calls:**
- `init` (3)
- `get init` (1)

### `getTagNames`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:186` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `loadBinding` (1)

### `_ensureChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:991` | Self: 0.0% (0us) | Total: 4.8% (65.0ms) | Samples: 0

**Called by:**
- `get` (44)

**Calls:**
- `_buildScopeChildren` (39)
- `_buildScopeChildren` (4)
- `_buildScopeChildren` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4735` | Self: 0.0% (0us) | Total: 58.9% (787.1ms) | Samples: 0

**Called by:**
- `walkNodes` (521)

**Calls:**
- `Program:exit` (497)
- `Program:exit` (21)
- `Program:exit` (2)
- `Program:exit` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` | Self: 0.0% (0us) | Total: 9.1% (122.0ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (81)

**Calls:**
- `getDeclaredVariables` (80)
- `_computeDeclaredVariables` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:518` | Self: 0.0% (0us) | Total: 0.8% (10.9ms) | Samples: 0

**Called by:**
- `_computeVarDefs` (7)

**Calls:**
- `get parent` (4)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `(anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `bound require` (1)

**Calls:**
- `dlopen` (1)

### `get defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:790` | Self: 0.0% (0us) | Total: 0.2% (3.1ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (2)

**Calls:**
- `_computeVarDefs` (1)
- `_computeVarDefs` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:286` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `DataView` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:288` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Calls:**
- `getTagNames` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3247` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `isAfterLastUsedArg` (1)

**Calls:**
- `map` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:613` | Self: 0.0% (0us) | Total: 0.4% (6.3ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (4)

**Calls:**
- `_findLineIdx` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

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

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2086` | Self: 0.0% (0us) | Total: 0.7% (9.8ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (6)

**Calls:**
- `_symName` (6)

### `_buildTemplate`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5989` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `_buildPlan` (1)

**Calls:**
- `map` (1)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 41.9% | 559.8ms | `[native code]` |
| 28.9% | 386.2ms | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 22.9% | 306.0ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 5.7% | 76.5ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.1% | 1.5ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.1% | 1.5ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js` |
| 0.1% | 1.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs` |
| 0.0% | 1.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` |
