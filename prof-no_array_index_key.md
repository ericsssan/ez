# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 56.61s | 37290 | 1.0ms | 354 |

**Top 10:** `(anonymous)` 49.0%, `/@jsx\s+([^\s]+)/` 44.8%, `(anonymous)` 4.0%, `parse` 0.3%, `walkNodes` 0.1%, `anonymous` 0.1%, `walkNodes` 0.0%, `source` 0.0%, `_NodeView` 0.0%, `_NodeView_LR` 0.0%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 49.0% | 27.75s | 93.9% | 53.15s | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/pragma.js:54` |
| 44.8% | 25.40s | 44.8% | 25.40s | `/@jsx\s+([^\s]+)/` | `[native code]` |
| 4.0% | 2.28s | 4.0% | 2.28s | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/variable.js:27` |
| 0.3% | 223.8ms | 0.3% | 223.8ms | `parse` | `[native code]` |
| 0.1% | 76.6ms | 98.4% | 55.73s | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7181` |
| 0.1% | 65.9ms | 0.7% | 398.3ms | `anonymous` | `[native code]` |
| 0.0% | 47.8ms | 0.8% | 465.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7380` |
| 0.0% | 39.7ms | 0.0% | 39.7ms | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` |
| 0.0% | 34.0ms | 0.0% | 34.0ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` |
| 0.0% | 21.2ms | 0.0% | 21.2ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4058` |
| 0.0% | 20.7ms | 0.0% | 20.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2328` |
| 0.0% | 19.9ms | 0.0% | 19.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6861` |
| 0.0% | 18.6ms | 0.0% | 18.6ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:615` |
| 0.0% | 17.1ms | 0.0% | 17.1ms | `hasOwnProperty` | `[native code]` |
| 0.0% | 16.5ms | 0.0% | 16.5ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:236` |
| 0.0% | 16.1ms | 0.0% | 22.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7316` |
| 0.0% | 15.9ms | 0.2% | 114.5ms | `getVariableFromContext` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/variable.js:45` |
| 0.0% | 15.2ms | 0.0% | 35.6ms | `getVariableFromContext` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/variable.js:48` |
| 0.0% | 15.2ms | 0.0% | 15.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6865` |
| 0.0% | 14.9ms | 2.8% | 1.61s | `getVariable` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/variable.js:27` |
| 0.0% | 14.7ms | 0.0% | 51.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2161` |
| 0.0% | 13.8ms | 0.0% | 15.0ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2297` |
| 0.0% | 12.2ms | 0.0% | 27.2ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4162` |
| 0.0% | 12.0ms | 0.0% | 12.0ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:656` |
| 0.0% | 12.0ms | 0.0% | 12.0ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 10.9ms | 0.0% | 25.1ms | `getMapIndexParamName` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:109` |
| 0.0% | 9.9ms | 0.0% | 22.1ms | `getMapIndexParamName` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:113` |
| 0.0% | 9.7ms | 0.0% | 9.7ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 9.0ms | 0.0% | 42.5ms | `getMapIndexParamName` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:116` |
| 0.0% | 8.9ms | 92.6% | 52.43s | `isCreateCloneElement` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:26` |
| 0.0% | 8.6ms | 0.1% | 73.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 0.0% | 8.3ms | 0.0% | 8.3ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 7.9ms | 0.0% | 9.3ms | `test` | `[native code]` |
| 0.0% | 7.9ms | 0.0% | 7.9ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 7.8ms | 0.0% | 7.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4095` |
| 0.0% | 7.8ms | 4.1% | 2.33s | `getVariableFromContext` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/variable.js:42` |
| 0.0% | 7.7ms | 0.0% | 7.7ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 7.4ms | 0.0% | 7.4ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.0% | 7.2ms | 0.0% | 7.2ms | `call` | `[native code]` |
| 0.0% | 7.0ms | 0.0% | 7.0ms | `_Variable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:867` |
| 0.0% | 6.6ms | 0.0% | 11.3ms | `exec` | `[native code]` |
| 0.0% | 6.4ms | 0.0% | 14.7ms | `getVariableFromContext` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/variable.js:47` |
| 0.0% | 6.2ms | 0.0% | 6.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7141` |
| 0.0% | 6.0ms | 99.0% | 56.03s | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4775` |
| 0.0% | 5.9ms | 0.0% | 5.9ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:912` |
| 0.0% | 5.9ms | 0.0% | 5.9ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2796` |
| 0.0% | 5.7ms | 0.0% | 5.7ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4393` |
| 0.0% | 5.7ms | 0.0% | 8.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7153` |
| 0.0% | 5.7ms | 0.0% | 5.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2527` |
| 0.0% | 5.2ms | 0.0% | 5.2ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 5.2ms | 0.0% | 6.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1223` |
| 0.0% | 5.1ms | 97.9% | 55.45s | `find` | `[native code]` |
| 0.0% | 4.8ms | 0.0% | 4.8ms | `decode` | `[native code]` |
| 0.0% | 4.7ms | 0.0% | 4.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2797` |
| 0.0% | 4.7ms | 0.0% | 7.7ms | `findVariableByName` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/variable.js:82` |
| 0.0% | 4.6ms | 0.0% | 6.3ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:855` |
| 0.0% | 4.6ms | 0.0% | 4.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1244` |
| 0.0% | 4.5ms | 0.0% | 4.5ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:810` |
| 0.0% | 4.3ms | 97.4% | 55.14s | `CallExpression, OptionalCallExpression` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:236` |
| 0.0% | 4.2ms | 0.0% | 22.4ms | `findVariableByName` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/variable.js:70` |
| 0.0% | 4.2ms | 0.0% | 4.2ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2876` |
| 0.0% | 3.8ms | 0.0% | 6.9ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2776` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7312` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2062` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 3.3ms | 0.0% | 27.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2296` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 3.1ms | 0.8% | 470.0ms | `CallExpression, OptionalCallExpression` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:261` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2943` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3918` |
| 0.0% | 2.9ms | 0.1% | 71.8ms | `getVariableFromContext` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/variable.js:44` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7143` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `getFromContext` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/pragma.js:64` |
| 0.0% | 2.7ms | 0.0% | 4.5ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2242` |
| 0.0% | 2.7ms | 0.0% | 34.6ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4137` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2087` |
| 0.0% | 2.5ms | 0.0% | 4.0ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:947` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `filter` | `[native code]` |
| 0.0% | 1.8ms | 0.0% | 4.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2140` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2682` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:601` |
| 0.0% | 1.7ms | 0.7% | 413.0ms | `popIndex` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:226` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2685` |
| 0.0% | 1.7ms | 0.0% | 12.7ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:517` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:910` |
| 0.0% | 1.7ms | 0.0% | 3.4ms | `readFileSync` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2191` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2289` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `slice` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `extraArrowData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:713` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isCreateCloneElement` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:24` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2294` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getBaseIntrinsic` | `/Users/ericsan/node_modules/get-intrinsic/index.js:291` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:701` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2183` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:617` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2176` |
| 0.0% | 1.6ms | 0.0% | 15.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2287` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4110` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2126` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2532` |
| 0.0% | 1.5ms | 0.0% | 7.9ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:839` |
| 0.0% | 1.5ms | 0.0% | 9.1ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:905` |
| 0.0% | 1.5ms | 0.0% | 14.3ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2866` |
| 0.0% | 1.5ms | 0.0% | 16.8ms | `parseModule` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2181` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4134` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `defineDataProperty` | `/Users/ericsan/node_modules/define-data-property/index.js:16` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2692` |
| 0.0% | 1.5ms | 0.0% | 4.4ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1736` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2295` |
| 0.0% | 1.5ms | 93.9% | 53.18s | `getFromContext` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/pragma.js:54` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2220` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2831` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1347` |
| 0.0% | 1.4ms | 0.0% | 15.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2419` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getMapIndexParamName` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:136` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4051` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2238` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get callee` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1904` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1317` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `set` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isUsingReactChildren` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:86` |
| 0.0% | 1.4ms | 0.0% | 3.0ms | `get params` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2586` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `/^\s*exported\b/` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:794` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2420` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4111` |
| 0.0% | 1.3ms | 0.0% | 28.7ms | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1967` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` |
| 0.0% | 1.3ms | 0.0% | 2.6ms | `refresh` | `internal:util/colors:18` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_isOptionalTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3884` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7042` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6847` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:959` |
| 0.0% | 1.2ms | 0.0% | 37.5ms | `getVariableFromContext` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/variable.js:39` |
| 0.0% | 1.2ms | 0.0% | 21.1ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2260` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4509` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2322` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `isUsingReactChildren` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:87` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5973` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 18.2ms | `get defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 0.0% | 1.0ms | 0.0% | 1.0ms | `dlopen` | `[native code]` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 99.8% | 56.52s | 0.0% | 0us | `(anonymous)` | `[native code]` |
| 99.8% | 56.51s | 0.0% | 0us | `processTicksAndRejections` | `[native code]` |
| 99.4% | 56.28s | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:274` |
| 99.4% | 56.28s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7664` |
| 99.0% | 56.03s | 0.0% | 6.0ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4775` |
| 98.4% | 55.73s | 0.1% | 76.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7181` |
| 97.9% | 55.45s | 0.0% | 5.1ms | `find` | `[native code]` |
| 97.4% | 55.14s | 0.0% | 4.3ms | `CallExpression, OptionalCallExpression` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:236` |
| 93.9% | 53.18s | 0.0% | 1.5ms | `getFromContext` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/pragma.js:54` |
| 93.9% | 53.15s | 49.0% | 27.75s | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/pragma.js:54` |
| 92.6% | 52.43s | 0.0% | 8.9ms | `isCreateCloneElement` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:26` |
| 44.8% | 25.40s | 44.8% | 25.40s | `/@jsx\s+([^\s]+)/` | `[native code]` |
| 4.7% | 2.68s | 0.0% | 0us | `isCreateCloneElement` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:31` |
| 4.6% | 2.60s | 0.0% | 0us | `findVariableByName` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/variable.js:68` |
| 4.1% | 2.33s | 0.0% | 7.8ms | `getVariableFromContext` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/variable.js:42` |
| 4.0% | 2.28s | 4.0% | 2.28s | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/variable.js:27` |
| 2.8% | 1.61s | 0.0% | 14.9ms | `getVariable` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/variable.js:27` |
| 1.3% | 782.4ms | 0.0% | 0us | `getMapIndexParamName` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:122` |
| 1.3% | 778.3ms | 0.0% | 0us | `isUsingReactChildren` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:101` |
| 0.8% | 470.0ms | 0.0% | 3.1ms | `CallExpression, OptionalCallExpression` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:261` |
| 0.8% | 465.6ms | 0.0% | 47.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7380` |
| 0.7% | 413.0ms | 0.0% | 1.7ms | `popIndex` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:226` |
| 0.7% | 398.3ms | 0.1% | 65.9ms | `anonymous` | `[native code]` |
| 0.6% | 380.7ms | 0.0% | 0us | `bound require` | `[native code]` |
| 0.6% | 375.6ms | 0.0% | 0us | `require` | `[native code]` |
| 0.4% | 230.9ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` |
| 0.3% | 223.8ms | 0.3% | 223.8ms | `parse` | `[native code]` |
| 0.3% | 223.8ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` |
| 0.2% | 134.8ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1019` |
| 0.2% | 123.0ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:911` |
| 0.2% | 114.5ms | 0.0% | 15.9ms | `getVariableFromContext` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/variable.js:45` |
| 0.1% | 73.7ms | 0.0% | 8.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 0.1% | 71.8ms | 0.0% | 2.9ms | `getVariableFromContext` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/variable.js:44` |
| 0.1% | 70.6ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1023` |
| 0.1% | 70.6ms | 0.0% | 0us | `_ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:990` |
| 0.1% | 63.9ms | 0.0% | 0us | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2688` |
| 0.1% | 60.1ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:142` |
| 0.1% | 60.1ms | 0.0% | 0us | `loadPlugin` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:89` |
| 0.0% | 51.2ms | 0.0% | 14.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2161` |
| 0.0% | 46.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/index.js:6` |
| 0.0% | 42.5ms | 0.0% | 9.0ms | `getMapIndexParamName` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:116` |
| 0.0% | 39.7ms | 0.0% | 39.7ms | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` |
| 0.0% | 39.7ms | 0.0% | 0us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1359` |
| 0.0% | 37.5ms | 0.0% | 1.2ms | `getVariableFromContext` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/variable.js:39` |
| 0.0% | 35.6ms | 0.0% | 15.2ms | `getVariableFromContext` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/variable.js:48` |
| 0.0% | 34.6ms | 0.0% | 2.7ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4137` |
| 0.0% | 34.0ms | 0.0% | 34.0ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` |
| 0.0% | 28.7ms | 0.0% | 1.3ms | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1967` |
| 0.0% | 27.4ms | 0.0% | 3.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2296` |
| 0.0% | 27.2ms | 0.0% | 12.2ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4162` |
| 0.0% | 25.1ms | 0.0% | 10.9ms | `getMapIndexParamName` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:109` |
| 0.0% | 24.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/index.js:7` |
| 0.0% | 22.4ms | 0.0% | 4.2ms | `findVariableByName` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/variable.js:70` |
| 0.0% | 22.4ms | 0.0% | 16.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7316` |
| 0.0% | 22.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/boolean-prop-naming.js:11` |
| 0.0% | 22.1ms | 0.0% | 9.9ms | `getMapIndexParamName` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:113` |
| 0.0% | 21.2ms | 0.0% | 21.2ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4058` |
| 0.0% | 21.1ms | 0.0% | 1.2ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2260` |
| 0.0% | 21.1ms | 0.0% | 0us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1367` |
| 0.0% | 20.7ms | 0.0% | 20.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2328` |
| 0.0% | 20.5ms | 0.0% | 0us | `getAllComments` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3369` |
| 0.0% | 19.9ms | 0.0% | 19.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6861` |
| 0.0% | 18.7ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2772` |
| 0.0% | 18.6ms | 0.0% | 18.6ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:615` |
| 0.0% | 18.2ms | 0.0% | 1.2ms | `get defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 0.0% | 17.1ms | 0.0% | 17.1ms | `hasOwnProperty` | `[native code]` |
| 0.0% | 16.8ms | 0.0% | 1.5ms | `parseModule` | `[native code]` |
| 0.0% | 16.8ms | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 0.0% | 16.5ms | 0.0% | 16.5ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:236` |
| 0.0% | 15.5ms | 0.0% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2419` |
| 0.0% | 15.5ms | 0.0% | 1.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2287` |
| 0.0% | 15.2ms | 0.0% | 15.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6865` |
| 0.0% | 15.0ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4165` |
| 0.0% | 15.0ms | 0.0% | 13.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2297` |
| 0.0% | 14.7ms | 0.0% | 6.4ms | `getVariableFromContext` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/variable.js:47` |
| 0.0% | 14.3ms | 0.0% | 1.5ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2866` |
| 0.0% | 12.7ms | 0.0% | 1.7ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:517` |
| 0.0% | 12.4ms | 0.0% | 0us | `getScope` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/eslint.js:15` |
| 0.0% | 12.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/index.js:3` |
| 0.0% | 12.1ms | 0.0% | 0us | `get property` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1979` |
| 0.0% | 12.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:25` |
| 0.0% | 12.0ms | 0.0% | 12.0ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:656` |
| 0.0% | 12.0ms | 0.0% | 12.0ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 11.3ms | 0.0% | 6.6ms | `exec` | `[native code]` |
| 0.0% | 9.7ms | 0.0% | 9.7ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 9.3ms | 0.0% | 7.9ms | `test` | `[native code]` |
| 0.0% | 9.3ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:612` |
| 0.0% | 9.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` |
| 0.0% | 9.1ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1713` |
| 0.0% | 9.1ms | 0.0% | 1.5ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:905` |
| 0.0% | 8.7ms | 0.0% | 5.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7153` |
| 0.0% | 8.3ms | 0.0% | 8.3ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 7.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/object.fromentries/index.js:6` |
| 0.0% | 7.9ms | 0.0% | 1.5ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:839` |
| 0.0% | 7.9ms | 0.0% | 7.9ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 7.9ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:613` |
| 0.0% | 7.8ms | 0.0% | 7.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4095` |
| 0.0% | 7.7ms | 0.0% | 4.7ms | `findVariableByName` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/variable.js:82` |
| 0.0% | 7.7ms | 0.0% | 7.7ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 7.6ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2241` |
| 0.0% | 7.4ms | 0.0% | 7.4ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.0% | 7.2ms | 0.0% | 7.2ms | `call` | `[native code]` |
| 0.0% | 7.1ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` |
| 0.0% | 7.1ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:478` |
| 0.0% | 7.0ms | 0.0% | 0us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2827` |
| 0.0% | 7.0ms | 0.0% | 7.0ms | `_Variable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:867` |
| 0.0% | 6.9ms | 0.0% | 3.8ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2776` |
| 0.0% | 6.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:497` |
| 0.0% | 6.5ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:455` |
| 0.0% | 6.5ms | 0.0% | 5.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1223` |
| 0.0% | 6.4ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2145` |
| 0.0% | 6.3ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2085` |
| 0.0% | 6.3ms | 0.0% | 4.6ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:855` |
| 0.0% | 6.3ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2421` |
| 0.0% | 6.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/object.fromentries/implementation.js:3` |
| 0.0% | 6.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/Components.js:18` |
| 0.0% | 6.2ms | 0.0% | 6.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7141` |
| 0.0% | 5.9ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2323` |
| 0.0% | 5.9ms | 0.0% | 5.9ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:912` |
| 0.0% | 5.9ms | 0.0% | 5.9ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2796` |
| 0.0% | 5.7ms | 0.0% | 5.7ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4393` |
| 0.0% | 5.7ms | 0.0% | 5.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2527` |
| 0.0% | 5.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/doctrine/lib/utility.js:32` |
| 0.0% | 5.2ms | 0.0% | 5.2ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 4.8ms | 0.0% | 4.8ms | `decode` | `[native code]` |
| 0.0% | 4.8ms | 0.0% | 0us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` |
| 0.0% | 4.7ms | 0.0% | 4.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2797` |
| 0.0% | 4.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/propTypes.js:12` |
| 0.0% | 4.6ms | 0.0% | 0us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1211` |
| 0.0% | 4.6ms | 0.0% | 4.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1244` |
| 0.0% | 4.5ms | 0.0% | 0us | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 0.0% | 4.5ms | 0.0% | 2.7ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2242` |
| 0.0% | 4.5ms | 0.0% | 4.5ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:810` |
| 0.0% | 4.4ms | 0.0% | 1.8ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2140` |
| 0.0% | 4.4ms | 0.0% | 1.5ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1736` |
| 0.0% | 4.2ms | 0.0% | 4.2ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2876` |
| 0.0% | 4.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/doctrine/lib/doctrine.js:897` |
| 0.0% | 4.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/componentUtil.js:3` |
| 0.0% | 4.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/Components.js:17` |
| 0.0% | 4.0ms | 0.0% | 2.5ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:947` |
| 0.0% | 3.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7312` |
| 0.0% | 3.4ms | 0.0% | 1.7ms | `readFileSync` | `[native code]` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2062` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 3.3ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7140` |
| 0.0% | 3.3ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7656` |
| 0.0% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/Components.js:19` |
| 0.0% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/jsx-ast-utils/elementType.js:1` |
| 0.0% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/jsx.js:7` |
| 0.0% | 3.2ms | 0.0% | 0us | `isCreateCloneElement` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:25` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 3.0ms | 0.0% | 0us | `getMapIndexParamName` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:134` |
| 0.0% | 3.0ms | 0.0% | 1.4ms | `get params` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2586` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2943` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/resolve/index.js:1` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/version.js:11` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/call-bind/index.js:3` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/object.fromentries/index.js:4` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/set-function-length/index.js:3` |
| 0.0% | 3.0ms | 0.0% | 0us | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2847` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3918` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7143` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `getFromContext` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/pragma.js:64` |
| 0.0% | 2.8ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1733` |
| 0.0% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/Components.js:11` |
| 0.0% | 2.8ms | 0.0% | 0us | `get identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:795` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2087` |
| 0.0% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/doctrine/lib/doctrine.js:18` |
| 0.0% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/doctrine/lib/typed.js:1303` |
| 0.0% | 2.6ms | 0.0% | 0us | `loadAssertionError` | `node:assert:28` |
| 0.0% | 2.6ms | 0.0% | 0us | `get` | `node:assert:70` |
| 0.0% | 2.6ms | 0.0% | 0us | `internal:util/colors` | `internal:util/colors:24` |
| 0.0% | 2.6ms | 0.0% | 1.3ms | `refresh` | `internal:util/colors:18` |
| 0.0% | 2.6ms | 0.0% | 0us | `node:assert` | `node:assert:588` |
| 0.0% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/doctrine/lib/typed.js:27` |
| 0.0% | 2.6ms | 0.0% | 0us | `internal:assert/assertion_error` | `internal:assert/assertion_error:2` |
| 0.0% | 2.6ms | 0.0% | 0us | `assign` | `[native code]` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/jsx-sort-props.js:10` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-abstract/2024/IsLessThan.js:13` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-abstract/2024/CompareArrayElements.js:6` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/index.js:56` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/array.prototype.tosorted/implementation.js:4` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/array.prototype.tosorted/index.js:6` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.0% | 1.8ms | 0.0% | 0us | `filterRules` | `/Users/ericsan/node_modules/eslint-plugin-react/index.js:9` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `filter` | `[native code]` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/index.js:26` |
| 0.0% | 1.7ms | 0.0% | 0us | `identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:795` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2682` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:601` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/resolve/lib/async.js:7` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2685` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-abstract/2024/AddEntriesFromIterable.js:12` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/get-intrinsic/index.js:57` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/function-bind/index.js:3` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/get-proto/index.js:6` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:910` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/dunder-proto/get.js:3` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/call-bind-apply-helpers/index.js:3` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:28` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2191` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/index.js:62` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2289` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `slice` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/version.js:12` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `extraArrowData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:713` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isCreateCloneElement` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:24` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/index.js:36` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2294` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-abstract/2024/ToPropertyKey.js:7` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/is-symbol/index.js:9` |
| 0.0% | 1.6ms | 0.0% | 0us | `callBoundIntrinsic` | `/Users/ericsan/node_modules/call-bound/index.js:14` |
| 0.0% | 1.6ms | 0.0% | 0us | `GetIntrinsic` | `/Users/ericsan/node_modules/get-intrinsic/index.js:311` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/object.fromentries/implementation.js:6` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-abstract/2024/ToPrimitive.js:3` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getBaseIntrinsic` | `/Users/ericsan/node_modules/get-intrinsic/index.js:291` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-to-primitive/es2015.js:8` |
| 0.0% | 1.6ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1732` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:701` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-abstract/2024/AddEntriesFromIterable.js:7` |
| 0.0% | 1.6ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2258` |
| 0.0% | 1.6ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2705` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2183` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-abstract/2024/IsConstructor.js:3` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-abstract/2024/ArraySpeciesCreate.js:13` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/array.prototype.flatmap/index.js:6` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/array.prototype.flatmap/implementation.js:3` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:617` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/boolean-prop-naming.js:8` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2176` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4110` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2126` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2532` |
| 0.0% | 1.5ms | 0.0% | 0us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2800` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/index.js:21` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/ast.js:7` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/Components.js:16` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2181` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4134` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-iterator-helpers/Iterator.from/index.js:10` |
| 0.0% | 1.5ms | 0.0% | 0us | `setFunctionLength` | `/Users/ericsan/node_modules/set-function-length/index.js:36` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `defineDataProperty` | `/Users/ericsan/node_modules/define-data-property/index.js:16` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2692` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2295` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2220` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-abstract/2024/GetIterator.js:12` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-abstract/2024/GetMethod.js:6` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-abstract/2024/CreateAsyncFromSyncIterator.js:14` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-abstract/2024/AddEntriesFromIterable.js:9` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-abstract/2024/IsCallable.js:5` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2831` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1347` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/index.js:70` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/index.js:26` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/jsx-ast-utils/lib/getPropValue.js:9` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/jsx-ast-utils/lib/index.js:19` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/jsx-ast-utils/lib/values/index.js:28` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/jsx-ast-utils/lib/values/expressions/index.js:40` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getMapIndexParamName` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:136` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2238` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4051` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get callee` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1904` |
| 0.0% | 1.4ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7659` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1317` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/index.js:83` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/Components.js:20` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/jsx-no-literals.js:12` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/index.js:43` |
| 0.0% | 1.4ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2088` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `set` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/string.prototype.matchall/index.js:6` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/index.js:32` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/jsx-indent.js:33` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/string.prototype.matchall/implementation.js:11` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/regexp.prototype.flags/index.js:6` |
| 0.0% | 1.4ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:11` |
| 0.0% | 1.4ms | 0.0% | 0us | `isUsingReactChildren` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:97` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isUsingReactChildren` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:86` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-abstract/2024/AddEntriesFromIterable.js:5` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:794` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `/^\s*exported\b/` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2420` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/index.js:90` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4111` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/index.js:49` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js:133` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1511` |
| 0.0% | 1.3ms | 0.0% | 0us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1250` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/index.js:84` |
| 0.0% | 1.3ms | 0.0% | 0us | `getMapIndexParamName` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:124` |
| 0.0% | 1.3ms | 0.0% | 0us | `get arguments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1931` |
| 0.0% | 1.3ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2215` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_isOptionalTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3884` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/doctrine/lib/doctrine.js:17` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/esutils/lib/utils.js:31` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/esutils/lib/utils.js:30` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7042` |
| 0.0% | 1.3ms | 0.0% | 0us | `get WriteStream` | `node:fs:583` |
| 0.0% | 1.3ms | 0.0% | 0us | `internal:streams/pipeline` | `internal:streams/pipeline:2` |
| 0.0% | 1.3ms | 0.0% | 0us | `internal:stream` | `internal:stream:2` |
| 0.0% | 1.3ms | 0.0% | 0us | `internal:streams/duplex` | `internal:streams/duplex:2` |
| 0.0% | 1.3ms | 0.0% | 0us | `internal:fs/streams` | `internal:fs/streams:2` |
| 0.0% | 1.3ms | 0.0% | 0us | `internal:streams/compose` | `internal:streams/compose:2` |
| 0.0% | 1.3ms | 0.0% | 0us | `internal:streams/readable` | `internal:streams/readable:14` |
| 0.0% | 1.3ms | 0.0% | 0us | `node:stream` | `node:stream:2` |
| 0.0% | 1.3ms | 0.0% | 0us | `internal:streams/operators` | `internal:streams/operators:2` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/index.js:13` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/node_modules/minimatch/minimatch.js:10` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/forbid-component-props.js:8` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6847` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:959` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4509` |
| 0.0% | 1.2ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7663` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/resolve/lib/async.js:11` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2322` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/node-exports-info/getCategoriesForRange.js:5` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `isUsingReactChildren` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:87` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/index.js:12` |
| 0.0% | 1.2ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1516` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2155` |
| 0.0% | 1.2ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6744` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5973` |
| 0.0% | 1.2ms | 0.0% | 0us | `_getOrBuildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5674` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/Components.js:12` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-iterator-helpers/Iterator.prototype.map/index.js:6` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-set-tostringtag/index.js:7` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-iterator-helpers/IteratorHelperPrototype/index.js:3` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/es-iterator-helpers/Iterator.prototype.map/implementation.js:16` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/index.js:99` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1038` |
| 0.0% | 1.2ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1033` |
| 0.0% | 1.0ms | 0.0% | 0us | `loadBinding` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` |
| 0.0% | 1.0ms | 0.0% | 1.0ms | `dlopen` | `[native code]` |
| 0.0% | 1.0ms | 0.0% | 0us | `getTagNames` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:191` |
| 0.0% | 1.0ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:267` |

## Function Details

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/pragma.js:54` | Self: 49.0% (27.75s) | Total: 93.9% (53.15s) | Samples: 18302

**Called by:**
- `find` (35030)

**Calls:**
- `/@jsx\s+([^\s]+)/` (16728)

### `/@jsx\s+([^\s]+)/`
`[native code]` | Self: 44.8% (25.40s) | Total: 44.8% (25.40s) | Samples: 16728

**Called by:**
- `(anonymous)` (16728)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/variable.js:27` | Self: 4.0% (2.28s) | Total: 4.0% (2.28s) | Samples: 1507

**Called by:**
- `find` (1507)

### `parse`
`[native code]` | Self: 0.3% (223.8ms) | Total: 0.3% (223.8ms) | Samples: 149

**Called by:**
- `parseSource` (149)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7181` | Self: 0.1% (76.6ms) | Total: 98.4% (55.73s) | Samples: 51

**Called by:**
- `runPlugins` (36720)

**Calls:**
- `_invokeFused` (36654)
- `_nodeViewRaw` (12)
- `_invokeFused` (1)
- `_nodeViewRaw` (1)
- `nodeView` (1)

### `anonymous`
`[native code]` | Self: 0.1% (65.9ms) | Total: 0.7% (398.3ms) | Samples: 44

**Called by:**
- `require` (248)
- `bound require` (3)
- `loadAssertionError` (2)
- `internal:assert/assertion_error` (2)
- `node:stream` (1)
- `internal:streams/readable` (1)
- `get WriteStream` (1)
- `node:fs` (1)
- `internal:streams/duplex` (1)
- `internal:stream` (1)
- `internal:streams/operators` (1)
- `internal:streams/compose` (1)
- `internal:fs/streams` (1)
- `internal:streams/pipeline` (1)

**Calls:**
- `(anonymous)` (31)
- `(anonymous)` (16)
- `(anonymous)` (15)
- `(anonymous)` (8)
- `(anonymous)` (6)
- `(anonymous)` (5)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `internal:util/colors` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `node:assert` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `internal:assert/assertion_error` (2)
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
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:streams/duplex` (1)
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
- `internal:streams/compose` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:fs/streams` (1)
- `internal:streams/readable` (1)
- `node:fs` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:streams/pipeline` (1)
- `(anonymous)` (1)
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
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:streams/operators` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7380` | Self: 0.0% (47.8ms) | Total: 0.8% (465.6ms) | Samples: 32

**Called by:**
- `runPlugins` (306)

**Calls:**
- `_invokeFused` (271)
- `_nodeViewRaw` (2)
- `nodeView` (1)

### `source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` | Self: 0.0% (39.7ms) | Total: 0.0% (39.7ms) | Samples: 26

**Called by:**
- `get name` (26)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` | Self: 0.0% (34.0ms) | Total: 0.0% (34.0ms) | Samples: 17

**Called by:**
- `_nodeViewRaw` (17)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4058` | Self: 0.0% (21.2ms) | Total: 0.0% (21.2ms) | Samples: 14

**Called by:**
- `_nodeViewRaw` (14)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2328` | Self: 0.0% (20.7ms) | Total: 0.0% (20.7ms) | Samples: 14

**Called by:**
- `_ensureVarsSet` (14)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6861` | Self: 0.0% (19.9ms) | Total: 0.0% (19.9ms) | Samples: 13

**Called by:**
- `runPlugins` (13)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:615` | Self: 0.0% (18.6ms) | Total: 0.0% (18.6ms) | Samples: 12

**Called by:**
- `getAllComments` (7)
- `_precomputeScopes` (5)

### `hasOwnProperty`
`[native code]` | Self: 0.0% (17.1ms) | Total: 0.0% (17.1ms) | Samples: 12

**Called by:**
- `getMapIndexParamName` (12)

### `_resolveUnicodeEscapes`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:236` | Self: 0.0% (16.5ms) | Total: 0.0% (16.5ms) | Samples: 11

**Called by:**
- `get name` (11)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7316` | Self: 0.0% (16.1ms) | Total: 0.0% (22.4ms) | Samples: 11

**Called by:**
- `runPlugins` (15)

**Calls:**
- `_resolveHandlers` (3)
- `_resolveHandlers` (1)

### `getVariableFromContext`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/variable.js:45` | Self: 0.0% (15.9ms) | Total: 0.2% (114.5ms) | Samples: 10

**Called by:**
- `findVariableByName` (74)

**Calls:**
- `getVariable` (28)
- `find` (24)
- `get` (9)
- `get` (2)
- `get` (1)

### `getVariableFromContext`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/variable.js:48` | Self: 0.0% (15.2ms) | Total: 0.0% (35.6ms) | Samples: 10

**Called by:**
- `findVariableByName` (24)

**Calls:**
- `getVariable` (8)
- `get` (3)
- `find` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6865` | Self: 0.0% (15.2ms) | Total: 0.0% (15.2ms) | Samples: 10

**Called by:**
- `runPlugins` (10)

### `getVariable`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/variable.js:27` | Self: 0.0% (14.9ms) | Total: 2.8% (1.61s) | Samples: 10

**Called by:**
- `getVariableFromContext` (1023)
- `getVariableFromContext` (28)
- `getVariableFromContext` (8)

**Calls:**
- `find` (1049)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2161` | Self: 0.0% (14.7ms) | Total: 0.0% (51.2ms) | Samples: 10

**Called by:**
- `_buildScopeChildren` (29)
- `_buildScope` (2)
- `getVariableFromContext` (2)
- `_precomputeScopes` (1)

**Calls:**
- `_computeIsStrict` (14)
- `_computeIsStrict` (5)
- `_computeIsStrict` (3)
- `_computeIsStrict` (1)
- `_computeIsStrict` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2297` | Self: 0.0% (13.8ms) | Total: 0.0% (15.0ms) | Samples: 9

**Called by:**
- `_ensureVarsSet` (10)

**Calls:**
- `get` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4162` | Self: 0.0% (12.2ms) | Total: 0.0% (27.2ms) | Samples: 8

**Called by:**
- `CallExpression, OptionalCallExpression` (9)
- `getMapIndexParamName` (7)
- `isUsingReactChildren` (1)
- `get arguments` (1)

**Calls:**
- `_isChainNode` (8)
- `_isChainNode` (2)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:656` | Self: 0.0% (12.0ms) | Total: 0.0% (12.0ms) | Samples: 8

**Called by:**
- `commentsInRange` (5)
- `commentsInRange` (3)

### `_isChainNode`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (12.0ms) | Total: 0.0% (12.0ms) | Samples: 8

**Called by:**
- `nodeViewChain` (8)

### `getMapIndexParamName`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:109` | Self: 0.0% (10.9ms) | Total: 0.0% (25.1ms) | Samples: 7

**Called by:**
- `popIndex` (8)
- `CallExpression, OptionalCallExpression` (8)

**Calls:**
- `nodeViewChain` (7)
- `nodeViewChain` (1)
- `get callee` (1)

### `getMapIndexParamName`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:113` | Self: 0.0% (9.9ms) | Total: 0.0% (22.1ms) | Samples: 6

**Called by:**
- `CallExpression, OptionalCallExpression` (14)

**Calls:**
- `get property` (8)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (9.7ms) | Total: 0.0% (9.7ms) | Samples: 6

**Called by:**
- `getVariableFromContext` (3)
- `getVariableFromContext` (2)
- `getVariableFromContext` (1)

### `getMapIndexParamName`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:116` | Self: 0.0% (9.0ms) | Total: 0.0% (42.5ms) | Samples: 6

**Called by:**
- `CallExpression, OptionalCallExpression` (24)
- `popIndex` (5)

**Calls:**
- `hasOwnProperty` (12)
- `call` (5)
- `get name` (3)
- `get name` (3)

### `isCreateCloneElement`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:26` | Self: 0.0% (8.9ms) | Total: 92.6% (52.43s) | Samples: 6

**Called by:**
- `CallExpression, OptionalCallExpression` (34554)

**Calls:**
- `getFromContext` (34536)
- `get name` (10)
- `getFromContext` (1)
- `get name` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` | Self: 0.0% (8.6ms) | Total: 0.1% (73.7ms) | Samples: 6

**Called by:**
- `nodeView` (20)
- `walkNodes` (12)
- `nodeViewChain` (9)
- `get parent` (1)
- `_buildScope` (1)

**Calls:**
- `_NodeView` (17)
- `_NodeView_LR` (14)
- `_NodeView` (5)
- `_NodeView_LRN` (1)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (8.3ms) | Total: 0.0% (8.3ms) | Samples: 5

**Called by:**
- `_nodeViewRaw` (5)

### `test`
`[native code]` | Self: 0.0% (7.9ms) | Total: 0.0% (9.3ms) | Samples: 5

**Called by:**
- `_buildScopeVarsAndSet` (4)
- `_precomputeScopes` (2)

**Calls:**
- `/^\s*exported\b/` (1)

### `_resolveHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (7.9ms) | Total: 0.0% (7.9ms) | Samples: 5

**Called by:**
- `walkNodes` (3)
- `walkNodes` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4095` | Self: 0.0% (7.8ms) | Total: 0.0% (7.8ms) | Samples: 5

**Called by:**
- `walkNodes` (2)
- `_nodesFromRange` (1)
- `walkNodes` (1)
- `_buildScope` (1)

### `getVariableFromContext`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/variable.js:42` | Self: 0.0% (7.8ms) | Total: 4.1% (2.33s) | Samples: 5

**Called by:**
- `findVariableByName` (1538)

**Calls:**
- `getVariable` (1023)
- `find` (433)
- `get` (77)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (7.7ms) | Total: 0.0% (7.7ms) | Samples: 5

**Called by:**
- `getMapIndexParamName` (3)
- `isCreateCloneElement` (2)

### `/\/\*([\s\S]*?)\*\//g`
`[native code]` | Self: 0.0% (7.4ms) | Total: 0.0% (7.4ms) | Samples: 5

**Called by:**
- `exec` (3)
- `_buildScopeVarsAndSet` (2)

### `call`
`[native code]` | Self: 0.0% (7.2ms) | Total: 0.0% (7.2ms) | Samples: 5

**Called by:**
- `getMapIndexParamName` (5)

### `_Variable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:867` | Self: 0.0% (7.0ms) | Total: 0.0% (7.0ms) | Samples: 5

**Called by:**
- `_buildVariable` (5)

### `exec`
`[native code]` | Self: 0.0% (6.6ms) | Total: 0.0% (11.3ms) | Samples: 4

**Called by:**
- `_buildScopeVarsAndSet` (7)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (3)

### `getVariableFromContext`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/variable.js:47` | Self: 0.0% (6.4ms) | Total: 0.0% (14.7ms) | Samples: 5

**Called by:**
- `findVariableByName` (10)

**Calls:**
- `get` (3)
- `get` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7141` | Self: 0.0% (6.2ms) | Total: 0.0% (6.2ms) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4775` | Self: 0.0% (6.0ms) | Total: 99.0% (56.03s) | Samples: 4

**Called by:**
- `walkNodes` (36654)
- `walkNodes` (271)

**Calls:**
- `CallExpression, OptionalCallExpression` (36341)
- `CallExpression, OptionalCallExpression` (309)
- `popIndex` (271)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:912` | Self: 0.0% (5.9ms) | Total: 0.0% (5.9ms) | Samples: 4

**Called by:**
- `get` (4)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2796` | Self: 0.0% (5.9ms) | Total: 0.0% (5.9ms) | Samples: 4

**Called by:**
- `_buildScopeVarsAndSet` (4)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4393` | Self: 0.0% (5.7ms) | Total: 0.0% (5.7ms) | Samples: 2

**Called by:**
- `AstView` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7153` | Self: 0.0% (5.7ms) | Total: 0.0% (8.7ms) | Samples: 4

**Called by:**
- `runPlugins` (6)

**Calls:**
- `_resolveHandlers` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2527` | Self: 0.0% (5.7ms) | Total: 0.0% (5.7ms) | Samples: 4

**Called by:**
- `_ensureVarsSet` (4)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (5.2ms) | Total: 0.0% (5.2ms) | Samples: 4

**Called by:**
- `commentsInRange` (3)
- `commentsInRange` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1223` | Self: 0.0% (5.2ms) | Total: 0.0% (6.5ms) | Samples: 3

**Called by:**
- `_computeIsStrict` (2)
- `_computeIsStrict` (1)
- `_findDefNode` (1)

**Calls:**
- `_isOptionalTag` (1)

### `find`
`[native code]` | Self: 0.0% (5.1ms) | Total: 97.9% (55.45s) | Samples: 3

**Called by:**
- `getFromContext` (35031)
- `getVariable` (1049)
- `getVariableFromContext` (433)
- `getVariableFromContext` (24)
- `getVariableFromContext` (3)

**Calls:**
- `(anonymous)` (35030)
- `(anonymous)` (1507)

### `decode`
`[native code]` | Self: 0.0% (4.8ms) | Total: 0.0% (4.8ms) | Samples: 3

**Called by:**
- `get source` (3)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2797` | Self: 0.0% (4.7ms) | Total: 0.0% (4.7ms) | Samples: 3

**Called by:**
- `_buildScopeVarsAndSet` (3)

### `findVariableByName`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/variable.js:82` | Self: 0.0% (4.7ms) | Total: 0.0% (7.7ms) | Samples: 3

**Called by:**
- `isCreateCloneElement` (5)

**Calls:**
- `get init` (2)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:855` | Self: 0.0% (4.6ms) | Total: 0.0% (6.3ms) | Samples: 3

**Called by:**
- `_symName` (4)

**Calls:**
- `slice` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1244` | Self: 0.0% (4.6ms) | Total: 0.0% (4.6ms) | Samples: 3

**Called by:**
- `_findDefNode` (3)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:810` | Self: 0.0% (4.5ms) | Total: 0.0% (4.5ms) | Samples: 3

**Called by:**
- `get name` (3)

### `CallExpression, OptionalCallExpression`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:236` | Self: 0.0% (4.3ms) | Total: 97.4% (55.14s) | Samples: 3

**Called by:**
- `_invokeFused` (36341)

**Calls:**
- `isCreateCloneElement` (34554)
- `isCreateCloneElement` (1765)
- `nodeViewChain` (9)
- `nodeViewChain` (7)
- `isCreateCloneElement` (2)
- `isCreateCloneElement` (1)

### `findVariableByName`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/variable.js:70` | Self: 0.0% (4.2ms) | Total: 0.0% (22.4ms) | Samples: 3

**Called by:**
- `isCreateCloneElement` (15)

**Calls:**
- `get defs` (12)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2876` | Self: 0.0% (4.2ms) | Total: 0.0% (4.2ms) | Samples: 3

**Called by:**
- `get defs` (3)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2776` | Self: 0.0% (3.8ms) | Total: 0.0% (6.9ms) | Samples: 3

**Called by:**
- `getScope` (5)

**Calls:**
- `test` (2)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` | Self: 0.0% (3.4ms) | Total: 0.0% (3.4ms) | Samples: 2

**Called by:**
- `_computeIsStrict` (1)
- `_computeIsStrict` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7312` | Self: 0.0% (3.4ms) | Total: 0.0% (3.4ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2062` | Self: 0.0% (3.4ms) | Total: 0.0% (3.4ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2296` | Self: 0.0% (3.3ms) | Total: 0.0% (27.4ms) | Samples: 2

**Called by:**
- `_ensureVarsSet` (18)

**Calls:**
- `_buildVariable` (5)
- `_buildVariable` (4)
- `_buildVariable` (3)
- `_buildVariable` (2)
- `_buildVariable` (1)
- `_buildVariable` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `CallExpression, OptionalCallExpression`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:261` | Self: 0.0% (3.1ms) | Total: 0.8% (470.0ms) | Samples: 2

**Called by:**
- `_invokeFused` (309)

**Calls:**
- `getMapIndexParamName` (257)
- `getMapIndexParamName` (24)
- `getMapIndexParamName` (14)
- `getMapIndexParamName` (8)
- `getMapIndexParamName` (2)
- `getMapIndexParamName` (1)
- `getMapIndexParamName` (1)

### `get init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2943` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `findVariableByName` (2)

### `_isChainNode`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3918` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `nodeViewChain` (2)

### `getVariableFromContext`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/variable.js:44` | Self: 0.0% (2.9ms) | Total: 0.1% (71.8ms) | Samples: 2

**Called by:**
- `findVariableByName` (47)

**Calls:**
- `get` (44)
- `get` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7143` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `getFromContext`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/pragma.js:64` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `isCreateCloneElement` (1)
- `isUsingReactChildren` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2242` | Self: 0.0% (2.7ms) | Total: 0.0% (4.5ms) | Samples: 2

**Called by:**
- `_buildScope` (3)

**Calls:**
- `get parent` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4137` | Self: 0.0% (2.7ms) | Total: 0.0% (34.6ms) | Samples: 2

**Called by:**
- `get property` (8)
- `_nodesFromRange` (4)
- `get body` (2)
- `_computeVarDefs` (2)
- `_buildScope` (2)
- `get parent` (2)
- `get body` (1)
- `walkNodes` (1)
- `walkNodes` (1)

**Calls:**
- `_nodeViewRaw` (20)
- `_nodeViewRaw` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2087` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:947` | Self: 0.0% (2.5ms) | Total: 0.0% (4.0ms) | Samples: 2

**Called by:**
- `get` (2)
- `_ensureVarsSet` (1)

**Calls:**
- `get name` (1)

### `filter`
`[native code]` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `filterRules` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2140` | Self: 0.0% (1.8ms) | Total: 0.0% (4.4ms) | Samples: 1

**Called by:**
- `getVariableFromContext` (2)
- `_buildScopeChildren` (1)

**Calls:**
- `_buildScope` (2)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2682` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_ensureChildren` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:601` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `popIndex`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:226` | Self: 0.0% (1.7ms) | Total: 0.7% (413.0ms) | Samples: 1

**Called by:**
- `_invokeFused` (271)

**Calls:**
- `getMapIndexParamName` (257)
- `getMapIndexParamName` (8)
- `getMapIndexParamName` (5)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2685` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_ensureChildren` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:517` | Self: 0.0% (1.7ms) | Total: 0.0% (12.7ms) | Samples: 1

**Called by:**
- `_computeVarDefs` (8)

**Calls:**
- `get parent` (3)
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:910` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `get` (1)

### `readFileSync`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (3.4ms) | Samples: 1

**Called by:**
- `readFileSync` (1)
- `(anonymous)` (1)

**Calls:**
- `readFileSync` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2191` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2289` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `slice`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildSymNameCache` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `extraArrowData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:713` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `get params` (1)

### `isCreateCloneElement`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:24` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `CallExpression, OptionalCallExpression` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2294` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `getBaseIntrinsic`
`/Users/ericsan/node_modules/get-intrinsic/index.js:291` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `GetIntrinsic` (1)

### `extraFnData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:701` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `get body` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2183` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:617` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2176` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2287` | Self: 0.0% (1.6ms) | Total: 0.0% (15.5ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (10)

**Calls:**
- `_ensureDeclSymIndex` (4)
- `_ensureDeclSymIndex` (2)
- `_ensureDeclSymIndex` (2)
- `_ensureDeclSymIndex` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4110` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `nodeViewChain` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2126` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `getVariableFromContext` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2532` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:839` | Self: 0.0% (1.5ms) | Total: 0.0% (7.9ms) | Samples: 1

**Called by:**
- `_ensureDeclSymIndex` (4)
- `_buildVariable` (1)

**Calls:**
- `_buildSymNameCache` (4)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:905` | Self: 0.0% (1.5ms) | Total: 0.0% (9.1ms) | Samples: 1

**Called by:**
- `get body` (6)

**Calls:**
- `nodeView` (4)
- `_nodeViewRaw` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2866` | Self: 0.0% (1.5ms) | Total: 0.0% (14.3ms) | Samples: 1

**Called by:**
- `get defs` (6)
- `defs` (3)

**Calls:**
- `_findDefNode` (8)

### `parseModule`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (16.8ms) | Samples: 1

**Called by:**
- `async (anonymous)` (11)

**Calls:**
- `(anonymous)` (8)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_ensureChildren` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2181` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4134` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `get body` (1)

### `defineDataProperty`
`/Users/ericsan/node_modules/define-data-property/index.js:16` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `setFunctionLength` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2692` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_ensureChildren` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1736` | Self: 0.0% (1.5ms) | Total: 0.0% (4.4ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (3)

**Calls:**
- `nodeView` (1)
- `nodeView` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2295` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `getFromContext`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/pragma.js:54` | Self: 0.0% (1.5ms) | Total: 93.9% (53.18s) | Samples: 1

**Called by:**
- `isCreateCloneElement` (34536)
- `isUsingReactChildren` (510)

**Calls:**
- `find` (35031)
- `getAllComments` (14)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2220` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2831` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1347` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `isCreateCloneElement` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2419` | Self: 0.0% (1.4ms) | Total: 0.0% (15.5ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (10)

**Calls:**
- `exec` (7)
- `/\/\*([\s\S]*?)\*\//g` (2)

### `getMapIndexParamName`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:136` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `CallExpression, OptionalCallExpression` (1)

### `_NodeView_LRN`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4051` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2238` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `get callee`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1904` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getMapIndexParamName` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1317` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `set`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_ensureDeclSymIndex` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `isUsingReactChildren`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:86` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getMapIndexParamName` (1)

### `get params`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2586` | Self: 0.0% (1.4ms) | Total: 0.0% (3.0ms) | Samples: 1

**Called by:**
- `getMapIndexParamName` (2)

**Calls:**
- `extraArrowData` (1)

### `/^\s*exported\b/`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `test` (1)

### `get identifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:794` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2420` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4111` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `nodeView` (1)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1967` | Self: 0.0% (1.3ms) | Total: 0.0% (28.7ms) | Samples: 1

**Called by:**
- `getVariableFromContext` (11)
- `getScope` (8)

**Calls:**
- `_precomputeScopes` (12)
- `_precomputeScopes` (5)
- `_precomputeScopes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `refresh`
`internal:util/colors:18` | Self: 0.0% (1.3ms) | Total: 0.0% (2.6ms) | Samples: 1

**Called by:**
- `internal:util/colors` (2)

**Calls:**
- `(anonymous)` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `get value` (1)

### `_isOptionalTag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3884` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `get parent` (1)

### `_resolveHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7042` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6847` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:959` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `get` (1)

### `getVariableFromContext`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/variable.js:39` | Self: 0.0% (1.2ms) | Total: 0.0% (37.5ms) | Samples: 1

**Called by:**
- `findVariableByName` (25)

**Calls:**
- `getScope` (11)
- `getScope` (8)
- `_buildScope` (2)
- `_buildScope` (2)
- `_buildScope` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2260` | Self: 0.0% (1.2ms) | Total: 0.0% (21.1ms) | Samples: 1

**Called by:**
- `_buildScope` (14)

**Calls:**
- `get body` (6)
- `get body` (3)
- `get body` (2)
- `get body` (1)
- `get body` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4509` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2322` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `isUsingReactChildren`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:87` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `getMapIndexParamName` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `get value` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5973` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_getOrBuildPlan` (1)

### `get`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `get defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` | Self: 0.0% (1.2ms) | Total: 0.0% (18.2ms) | Samples: 1

**Called by:**
- `findVariableByName` (12)

**Calls:**
- `_computeVarDefs` (6)
- `_computeVarDefs` (3)
- `_computeVarDefs` (2)

### `dlopen`
`[native code]` | Self: 0.0% (1.0ms) | Total: 0.0% (1.0ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/Components.js:11` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/index.js:70` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/doctrine/lib/doctrine.js:17` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/resolve/lib/async.js:7` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `internal:streams/operators`
`internal:streams/operators:2` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/resolve/lib/async.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `internal:util/colors`
`internal:util/colors:24` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `refresh` (2)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` | Self: 0.0% (0us) | Total: 0.0% (4.8ms) | Samples: 0

**Called by:**
- `runPlugins` (2)
- `runPlugins` (1)

**Calls:**
- `decode` (3)

### `(anonymous)`
`/Users/ericsan/node_modules/object.fromentries/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/object.fromentries/implementation.js:3` | Self: 0.0% (0us) | Total: 0.0% (6.3ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `bound require` (4)

### `node:assert`
`node:assert:588` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `assign` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/node-exports-info/getCategoriesForRange.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `internal:streams/readable`
`internal:streams/readable:14` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/doctrine/lib/typed.js:1303` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (2)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` | Self: 0.0% (0us) | Total: 0.4% (230.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (152)

**Calls:**
- `parseSource` (149)
- `parseSource` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7140` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `getDFSEvents` (2)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:612` | Self: 0.0% (0us) | Total: 0.0% (9.3ms) | Samples: 0

**Called by:**
- `getAllComments` (4)
- `_precomputeScopes` (2)

**Calls:**
- `_findLineIdx` (5)
- `_findLineIdx` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` | Self: 0.0% (0us) | Total: 0.0% (7.1ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (3)

**Calls:**
- `AstView` (3)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2827` | Self: 0.0% (0us) | Total: 0.0% (7.0ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (5)

**Calls:**
- `_Variable` (5)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/index.js:62` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `identifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:795` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `defs` (1)

### `filterRules`
`/Users/ericsan/node_modules/eslint-plugin-react/index.js:9` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `filter` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:911` | Self: 0.0% (0us) | Total: 0.2% (123.0ms) | Samples: 0

**Called by:**
- `get` (81)

**Calls:**
- `_buildScopeVarsAndSet` (18)
- `_buildScopeVarsAndSet` (14)
- `_buildScopeVarsAndSet` (10)
- `_buildScopeVarsAndSet` (10)
- `_buildScopeVarsAndSet` (10)
- `_buildScopeVarsAndSet` (4)
- `_buildScopeVarsAndSet` (4)
- `_buildScopeVarsAndSet` (4)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2258` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_buildScope` (1)

**Calls:**
- `get body` (1)

### `loadAssertionError`
`node:assert:28` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `get` (2)

**Calls:**
- `anonymous` (2)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:267` | Self: 0.0% (0us) | Total: 0.0% (1.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getTagNames` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/jsx.js:7` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/call-bind-apply-helpers/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2772` | Self: 0.0% (0us) | Total: 0.0% (18.7ms) | Samples: 0

**Called by:**
- `getScope` (12)

**Calls:**
- `commentsInRange` (5)
- `commentsInRange` (3)
- `commentsInRange` (2)
- `commentsInRange` (1)
- `commentsInRange` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:25` | Self: 0.0% (0us) | Total: 0.0% (12.1ms) | Samples: 0

**Called by:**
- `parseModule` (8)

**Calls:**
- `bound require` (8)

### `(anonymous)`
`/Users/ericsan/node_modules/es-abstract/2024/GetMethod.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/Components.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/dunder-proto/get.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `get arguments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1931` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `getMapIndexParamName` (1)

**Calls:**
- `nodeViewChain` (1)

### `assign`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `node:assert` (2)

**Calls:**
- `get` (2)

### `internal:fs/streams`
`internal:fs/streams:2` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `getAllComments`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3369` | Self: 0.0% (0us) | Total: 0.0% (20.5ms) | Samples: 0

**Called by:**
- `getFromContext` (14)

**Calls:**
- `commentsInRange` (7)
- `commentsInRange` (4)
- `commentsInRange` (3)

### `loadPlugin`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:89` | Self: 0.0% (0us) | Total: 0.1% (60.1ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (40)

**Calls:**
- `bound require` (40)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/Components.js:19` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `getMapIndexParamName`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:122` | Self: 0.0% (0us) | Total: 1.3% (782.4ms) | Samples: 0

**Called by:**
- `popIndex` (257)
- `CallExpression, OptionalCallExpression` (257)

**Calls:**
- `isUsingReactChildren` (511)
- `isUsingReactChildren` (1)
- `isUsingReactChildren` (1)
- `isUsingReactChildren` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/componentUtil.js:3` | Self: 0.0% (0us) | Total: 0.0% (4.0ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/version.js:11` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `callBoundIntrinsic`
`/Users/ericsan/node_modules/call-bound/index.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `GetIntrinsic` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/Components.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/index.js:90` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/jsx-ast-utils/lib/index.js:19` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/es-abstract/2024/IsConstructor.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_getOrBuildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5674` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_buildPlan` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:478` | Self: 0.0% (0us) | Total: 0.0% (7.1ms) | Samples: 0

**Called by:**
- `parseSource` (3)

**Calls:**
- `CfgGraph` (2)
- `CfgGraph` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/index.js:21` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2155` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_buildScopeChildren` (1)

**Calls:**
- `get value` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:274` | Self: 0.0% (0us) | Total: 99.4% (56.28s) | Samples: 0

**Called by:**
- `(anonymous)` (37086)

**Calls:**
- `runPlugins` (37082)
- `runPlugins` (2)
- `runPlugins` (1)
- `runPlugins` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2688` | Self: 0.0% (0us) | Total: 0.1% (63.9ms) | Samples: 0

**Called by:**
- `_ensureChildren` (42)

**Calls:**
- `_buildScope` (29)
- `_buildScope` (4)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2421` | Self: 0.0% (0us) | Total: 0.0% (6.3ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (4)

**Calls:**
- `test` (4)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/index.js:26` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `filterRules` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/es-abstract/2024/GetIterator.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` | Self: 0.0% (0us) | Total: 0.3% (223.8ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (149)

**Calls:**
- `parse` (149)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2085` | Self: 0.0% (0us) | Total: 0.0% (6.3ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (4)

**Calls:**
- `_symName` (4)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1211` | Self: 0.0% (0us) | Total: 0.0% (4.6ms) | Samples: 0

**Called by:**
- `_findDefNode` (2)
- `_computeIsStrict` (1)

**Calls:**
- `nodeView` (2)
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/es-iterator-helpers/Iterator.prototype.map/implementation.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/propTypes.js:12` | Self: 0.0% (0us) | Total: 0.0% (4.7ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `get WriteStream`
`node:fs:583` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `anonymous` (1)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:455` | Self: 0.0% (0us) | Total: 0.0% (6.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `bound require` (4)

### `isCreateCloneElement`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:25` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `CallExpression, OptionalCallExpression` (2)

**Calls:**
- `nodeViewChain` (2)

### `getMapIndexParamName`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:134` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `CallExpression, OptionalCallExpression` (2)

**Calls:**
- `get params` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/es-abstract/2024/ToPropertyKey.js:7` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 0.6% (375.6ms) | Samples: 0

**Called by:**
- `bound require` (248)

**Calls:**
- `anonymous` (248)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/object.fromentries/index.js:6` | Self: 0.0% (0us) | Total: 0.0% (7.9ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/jsx-indent.js:33` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2800` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `_symName` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:142` | Self: 0.0% (0us) | Total: 0.1% (60.1ms) | Samples: 0

**Calls:**
- `loadPlugin` (40)

### `(anonymous)`
`/Users/ericsan/node_modules/jsx-ast-utils/lib/values/expressions/index.js:40` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (16.8ms) | Samples: 0

**Calls:**
- `parseModule` (11)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `get`
`node:assert:70` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `assign` (2)

**Calls:**
- `loadAssertionError` (2)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1023` | Self: 0.0% (0us) | Total: 0.1% (70.6ms) | Samples: 0

**Called by:**
- `getVariableFromContext` (44)
- `getVariableFromContext` (2)

**Calls:**
- `_ensureChildren` (46)

### `internal:stream`
`internal:stream:2` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/get-intrinsic/index.js:57` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/array.prototype.tosorted/implementation.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/es-set-tostringtag/index.js:7` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `internal:streams/duplex`
`internal:streams/duplex:2` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `findVariableByName`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/variable.js:68` | Self: 0.0% (0us) | Total: 4.6% (2.60s) | Samples: 0

**Called by:**
- `isCreateCloneElement` (1718)

**Calls:**
- `getVariableFromContext` (1538)
- `getVariableFromContext` (74)
- `getVariableFromContext` (47)
- `getVariableFromContext` (25)
- `getVariableFromContext` (24)
- `getVariableFromContext` (10)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/index.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/is-symbol/index.js:9` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `callBoundIntrinsic` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/Components.js:20` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7663` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `buildVisitorMap` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/index.js:43` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `internal:assert/assertion_error`
`internal:assert/assertion_error:2` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `anonymous` (2)

### `loadBinding`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.0ms) | Samples: 0

**Called by:**
- `getTagNames` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/es-abstract/2024/AddEntriesFromIterable.js:9` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js:133` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1732` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `extraFnData` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/string.prototype.matchall/index.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/Components.js:18` | Self: 0.0% (0us) | Total: 0.0% (6.2ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `bound require` (4)

### `(anonymous)`
`/Users/ericsan/node_modules/jsx-ast-utils/lib/getPropValue.js:9` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/index.js:6` | Self: 0.0% (0us) | Total: 0.0% (46.0ms) | Samples: 0

**Called by:**
- `anonymous` (31)

**Calls:**
- `bound require` (31)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/index.js:99` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/ast.js:7` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1511` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `get parent` (1)

**Calls:**
- `_nodesFromRange` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/index.js:7` | Self: 0.0% (0us) | Total: 0.0% (24.0ms) | Samples: 0

**Called by:**
- `anonymous` (16)

**Calls:**
- `bound require` (16)

### `(anonymous)`
`/Users/ericsan/node_modules/array.prototype.flatmap/index.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/boolean-prop-naming.js:11` | Self: 0.0% (0us) | Total: 0.0% (22.3ms) | Samples: 0

**Called by:**
- `anonymous` (15)

**Calls:**
- `bound require` (15)

### `(anonymous)`
`/Users/ericsan/node_modules/es-abstract/2024/CreateAsyncFromSyncIterator.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/jsx-ast-utils/lib/values/index.js:28` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/array.prototype.tosorted/index.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1367` | Self: 0.0% (0us) | Total: 0.0% (21.1ms) | Samples: 0

**Called by:**
- `isCreateCloneElement` (9)
- `getMapIndexParamName` (3)
- `isCreateCloneElement` (1)
- `_ensureVarsSet` (1)

**Calls:**
- `_resolveUnicodeEscapes` (11)
- `_identAt` (3)

### `(anonymous)`
`/Users/ericsan/node_modules/object.fromentries/implementation.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4165` | Self: 0.0% (0us) | Total: 0.0% (15.0ms) | Samples: 0

**Called by:**
- `CallExpression, OptionalCallExpression` (7)
- `isCreateCloneElement` (2)
- `getMapIndexParamName` (1)

**Calls:**
- `_nodeViewRaw` (9)
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:28` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `readFileSync` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/es-iterator-helpers/Iterator.from/index.js:10` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `setFunctionLength` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/version.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `isUsingReactChildren`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:101` | Self: 0.0% (0us) | Total: 1.3% (778.3ms) | Samples: 0

**Called by:**
- `getMapIndexParamName` (511)

**Calls:**
- `getFromContext` (510)
- `getFromContext` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/function-bind/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/es-abstract/2024/IsCallable.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` | Self: 0.0% (0us) | Total: 0.0% (4.5ms) | Samples: 0

**Called by:**
- `get identifiers` (2)
- `identifiers` (1)

**Calls:**
- `_computeVarDefs` (3)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1359` | Self: 0.0% (0us) | Total: 0.0% (39.7ms) | Samples: 0

**Called by:**
- `isCreateCloneElement` (15)
- `isCreateCloneElement` (10)
- `_buildScope` (1)

**Calls:**
- `source` (26)

### `(anonymous)`
`/Users/ericsan/node_modules/es-iterator-helpers/IteratorHelperPrototype/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/index.js:83` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1733` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (2)

**Calls:**
- `nodeView` (2)

### `get identifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:795` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (2)

**Calls:**
- `defs` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/es-abstract/2024/IsLessThan.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/es-abstract/2024/AddEntriesFromIterable.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `getTagNames`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:191` | Self: 0.0% (0us) | Total: 0.0% (1.0ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `loadBinding` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/regexp.prototype.flags/index.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/array.prototype.flatmap/implementation.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/set-function-length/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (12.2ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `internal:streams/compose`
`internal:streams/compose:2` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/forbid-component-props.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/Components.js:17` | Self: 0.0% (0us) | Total: 0.0% (4.0ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.0% (3.5ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7659` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `get source` (1)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 0.6% (380.7ms) | Samples: 0

**Called by:**
- `loadPlugin` (40)
- `(anonymous)` (31)
- `(anonymous)` (16)
- `(anonymous)` (15)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (6)
- `(anonymous)` (5)
- `(anonymous)` (4)
- `patchAstUtils` (4)
- `(anonymous)` (4)
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
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `require` (248)
- `anonymous` (3)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/index.js:56` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/index.js:36` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_ensureChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:990` | Self: 0.0% (0us) | Total: 0.1% (70.6ms) | Samples: 0

**Called by:**
- `get` (46)

**Calls:**
- `_buildScopeChildren` (42)
- `_buildScopeChildren` (1)
- `_buildScopeChildren` (1)
- `_buildScopeChildren` (1)
- `_buildScopeChildren` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1033` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `get` (1)

**Calls:**
- `_ensureVarsSet` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/es-abstract/2024/CompareArrayElements.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` | Self: 0.0% (0us) | Total: 0.0% (9.1ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `(anonymous)`
`/Users/ericsan/node_modules/call-bind/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1713` | Self: 0.0% (0us) | Total: 0.0% (9.1ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (6)

**Calls:**
- `_nodesFromRange` (6)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/index.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7656` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (2)

**Calls:**
- `get source` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/jsx-ast-utils/elementType.js:1` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `isCreateCloneElement`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:31` | Self: 0.0% (0us) | Total: 4.7% (2.68s) | Samples: 0

**Called by:**
- `CallExpression, OptionalCallExpression` (1765)

**Calls:**
- `findVariableByName` (1718)
- `findVariableByName` (15)
- `get name` (15)
- `get name` (9)
- `findVariableByName` (5)
- `get name` (2)
- `get name` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/es-abstract/2024/ToPrimitive.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2705` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `getScope` (1)

**Calls:**
- `_buildScope` (1)

### `internal:streams/pipeline`
`internal:streams/pipeline:2` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `GetIntrinsic`
`/Users/ericsan/node_modules/get-intrinsic/index.js:311` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `callBoundIntrinsic` (1)

**Calls:**
- `getBaseIntrinsic` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/index.js:26` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/doctrine/lib/utility.js:32` | Self: 0.0% (0us) | Total: 0.0% (5.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)
- `anonymous` (2)

**Calls:**
- `(anonymous)` (2)
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/node_modules/minimatch/minimatch.js:10` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2145` | Self: 0.0% (0us) | Total: 0.0% (6.4ms) | Samples: 0

**Called by:**
- `_buildScopeChildren` (4)

**Calls:**
- `nodeView` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/index.js:84` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1516` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_buildScope` (1)

**Calls:**
- `get loc` (1)

### `(anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 99.8% (56.52s) | Samples: 0

**Called by:**
- `processTicksAndRejections` (37239)
- `refresh` (1)
- `bound require` (1)

**Calls:**
- `_lintSourceOne` (37086)
- `_lintSourceOne` (152)
- `_lintSourceOne` (1)
- `get WriteStream` (1)
- `dlopen` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/jsx-no-literals.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/esutils/lib/utils.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:497` | Self: 0.0% (0us) | Total: 0.0% (6.5ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `patchAstUtils` (4)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1019` | Self: 0.0% (0us) | Total: 0.2% (134.8ms) | Samples: 0

**Called by:**
- `getVariableFromContext` (77)
- `getVariableFromContext` (9)
- `getVariableFromContext` (3)

**Calls:**
- `_ensureVarsSet` (81)
- `_ensureVarsSet` (4)
- `_ensureVarsSet` (2)
- `_ensureVarsSet` (1)
- `_ensureVarsSet` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1250` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_findDefNode` (1)

**Calls:**
- `get value` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/es-abstract/2024/ArraySpeciesCreate.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/index.js:49` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6744` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_getOrBuildPlan` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2215` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_buildScopeChildren` (1)

**Calls:**
- `get name` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/esutils/lib/utils.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/index.js:32` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/boolean-prop-naming.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `setFunctionLength`
`/Users/ericsan/node_modules/set-function-length/index.js:36` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `defineDataProperty` (1)

### `node:stream`
`node:stream:2` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `getMapIndexParamName`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:124` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `CallExpression, OptionalCallExpression` (1)

**Calls:**
- `get arguments` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2241` | Self: 0.0% (0us) | Total: 0.0% (7.6ms) | Samples: 0

**Called by:**
- `_buildScope` (5)

**Calls:**
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/resolve/index.js:1` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/string.prototype.matchall/implementation.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `getScope`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/util/eslint.js:15` | Self: 0.0% (0us) | Total: 0.0% (12.4ms) | Samples: 0

**Called by:**
- `getVariableFromContext` (8)

**Calls:**
- `getScope` (8)

### `(anonymous)`
`/Users/ericsan/node_modules/es-to-primitive/es2015.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `get property`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1979` | Self: 0.0% (0us) | Total: 0.0% (12.1ms) | Samples: 0

**Called by:**
- `getMapIndexParamName` (8)

**Calls:**
- `nodeView` (8)

### `(anonymous)`
`/Users/ericsan/node_modules/get-proto/index.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2323` | Self: 0.0% (0us) | Total: 0.0% (5.9ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (4)

**Calls:**
- `get identifiers` (2)
- `get identifiers` (1)
- `identifiers` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/es-abstract/2024/AddEntriesFromIterable.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7664` | Self: 0.0% (0us) | Total: 99.4% (56.28s) | Samples: 0

**Called by:**
- `_lintSourceOne` (37082)

**Calls:**
- `walkNodes` (36720)
- `walkNodes` (306)
- `walkNodes` (15)
- `walkNodes` (13)
- `walkNodes` (10)
- `walkNodes` (6)
- `walkNodes` (4)
- `walkNodes` (2)
- `walkNodes` (2)
- `walkNodes` (2)
- `walkNodes` (1)
- `walkNodes` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/es-abstract/2024/AddEntriesFromIterable.js:7` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `isUsingReactChildren`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js:97` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `getMapIndexParamName` (1)

**Calls:**
- `nodeViewChain` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1038` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `getVariableFromContext` (1)

**Calls:**
- `_ensureVarsSet` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2847` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `get defs` (2)

**Calls:**
- `nodeView` (2)

### `(anonymous)`
`/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/jsx-sort-props.js:10` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/doctrine/lib/doctrine.js:897` | Self: 0.0% (0us) | Total: 0.0% (4.0ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `(anonymous)` (2)
- `(anonymous)` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:613` | Self: 0.0% (0us) | Total: 0.0% (7.9ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (3)
- `getAllComments` (3)

**Calls:**
- `_findLineIdx` (3)
- `_findLineIdx` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2088` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `set` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/doctrine/lib/typed.js:27` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `bound require` (2)

### `processTicksAndRejections`
`[native code]` | Self: 0.0% (0us) | Total: 99.8% (56.51s) | Samples: 0

**Calls:**
- `(anonymous)` (37239)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/es-iterator-helpers/Iterator.prototype.map/index.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/node_modules/doctrine/lib/doctrine.js:18` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `bound require` (2)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 49.0% | 27.76s | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/pragma.js` |
| 45.5% | 25.75s | `[native code]` |
| 4.1% | 2.36s | `/Users/ericsan/node_modules/eslint-plugin-react/lib/util/variable.js` |
| 0.6% | 380.8ms | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.4% | 272.0ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 54.0ms | `/Users/ericsan/node_modules/eslint-plugin-react/lib/rules/no-array-index-key.js` |
| 0.0% | 1.6ms | `/Users/ericsan/node_modules/get-intrinsic/index.js` |
| 0.0% | 1.5ms | `/Users/ericsan/node_modules/define-data-property/index.js` |
| 0.0% | 1.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` |
| 0.0% | 1.3ms | `internal:util/colors` |
