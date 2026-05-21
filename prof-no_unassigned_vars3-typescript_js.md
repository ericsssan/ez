# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 18.09s | 11807 | 1.0ms | 249 |

**Top 10:** `push` 84.4%, `parse` 4.2%, `_computeDeclaredVariables` 1.9%, `_computeDeclaredVariables` 1.8%, `_computeDeclaredVariables` 1.7%, `walkNodes` 0.6%, `walkNodes` 0.5%, `walkNodes` 0.3%, `walkNodes` 0.3%, `walkNodes` 0.3%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 84.4% | 15.28s | 84.4% | 15.28s | `push` | `[native code]` |
| 4.2% | 764.7ms | 4.2% | 764.7ms | `parse` | `[native code]` |
| 1.9% | 360.9ms | 28.6% | 5.18s | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3226` |
| 1.8% | 332.6ms | 29.6% | 5.36s | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3225` |
| 1.7% | 322.6ms | 31.7% | 5.74s | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3227` |
| 0.6% | 120.2ms | 0.6% | 125.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7271` |
| 0.5% | 98.8ms | 92.0% | 16.65s | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7136` |
| 0.3% | 70.4ms | 0.4% | 73.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7108` |
| 0.3% | 56.7ms | 0.3% | 56.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7373` |
| 0.3% | 54.7ms | 0.3% | 54.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6816` |
| 0.2% | 40.7ms | 0.2% | 40.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7096` |
| 0.2% | 37.1ms | 0.2% | 37.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7098` |
| 0.2% | 36.6ms | 0.4% | 79.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 0.1% | 36.1ms | 0.1% | 36.1ms | `defineProperty` | `[native code]` |
| 0.1% | 34.1ms | 0.1% | 34.1ms | `create` | `[native code]` |
| 0.1% | 25.4ms | 0.1% | 25.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6802` |
| 0.1% | 23.9ms | 0.1% | 23.9ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` |
| 0.1% | 19.2ms | 0.2% | 40.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7304` |
| 0.0% | 15.8ms | 0.2% | 50.1ms | `anonymous` | `[native code]` |
| 0.0% | 15.7ms | 0.0% | 15.7ms | `subarray` | `[native code]` |
| 0.0% | 14.8ms | 0.0% | 14.8ms | `decode` | `[native code]` |
| 0.0% | 14.7ms | 0.0% | 14.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6820` |
| 0.0% | 11.7ms | 0.0% | 15.0ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1733` |
| 0.0% | 10.7ms | 0.0% | 10.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3187` |
| 0.0% | 10.3ms | 0.1% | 22.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7303` |
| 0.0% | 9.9ms | 0.0% | 9.9ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 9.7ms | 0.0% | 9.7ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 9.6ms | 0.0% | 11.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4110` |
| 0.0% | 9.0ms | 0.0% | 14.0ms | `Set` | `[native code]` |
| 0.0% | 7.6ms | 0.0% | 7.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3207` |
| 0.0% | 7.0ms | 0.0% | 7.0ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:855` |
| 0.0% | 6.6ms | 0.0% | 6.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7374` |
| 0.0% | 6.6ms | 0.0% | 6.6ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 6.6ms | 0.0% | 6.6ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6540` |
| 0.0% | 6.3ms | 0.0% | 6.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7201` |
| 0.0% | 6.0ms | 0.2% | 38.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2141` |
| 0.0% | 5.8ms | 0.0% | 5.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7247` |
| 0.0% | 5.6ms | 0.0% | 5.6ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4058` |
| 0.0% | 4.6ms | 0.0% | 15.4ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:802` |
| 0.0% | 4.5ms | 0.0% | 4.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2879` |
| 0.0% | 4.4ms | 0.0% | 4.4ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3190` |
| 0.0% | 4.3ms | 0.0% | 15.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7238` |
| 0.0% | 4.2ms | 0.0% | 4.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2067` |
| 0.0% | 3.3ms | 0.1% | 22.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7306` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3656` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_Reference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:236` |
| 0.0% | 3.1ms | 0.0% | 6.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7311` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `dlopen` | `[native code]` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `get` | `[native code]` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `typedArrayViewLength` | `[native code]` |
| 0.0% | 3.0ms | 0.4% | 80.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2120` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3223` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `encodeInto` | `[native code]` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4393` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2167` |
| 0.0% | 2.9ms | 0.1% | 19.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7308` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `has` | `[native code]` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7296` |
| 0.0% | 2.7ms | 0.0% | 4.0ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2068` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3673` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1223` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7030` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_isChainMiddleTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `typedArrayViewIsDetached` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `linkAndEvaluateModule` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2175` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5015` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3667` |
| 0.0% | 1.7ms | 0.0% | 3.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2195` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7297` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:565` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1317` |
| 0.0% | 1.7ms | 0.0% | 3.4ms | `readdirSync` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `VariableDeclarator` | `/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:50` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7024` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5011` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3026` |
| 0.0% | 1.6ms | 0.4% | 86.6ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:808` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4732` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getUint32` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `join` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 3.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2125` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2751` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_Variable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:847` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `VariableDeclarator` | `/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:49` |
| 0.0% | 1.5ms | 0.1% | 18.4ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3162` |
| 0.0% | 1.5ms | 90.5% | 16.38s | `VariableDeclarator` | `/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:55` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4116` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2069` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2106` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_nodeStartPos` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:925` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getOwnPropertyDescriptor` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6542` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4392` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2781` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2161` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `values` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2244` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7317` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7302` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 2.7ms | `readFileSync` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1515` |
| 0.0% | 1.3ms | 0.0% | 6.1ms | `VariableDeclarator` | `/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:48` |
| 0.0% | 1.3ms | 0.0% | 16.5ms | `VariableDeclarator` | `/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:45` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4051` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` |
| 0.0% | 1.3ms | 0.0% | 11.4ms | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6378` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4049` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7184` |
| 0.0% | 1.3ms | 91.4% | 16.53s | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4730` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2156` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:769` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7309` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getTagNames` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:190` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4775` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `set` | `[native code]` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 95.5% | 17.29s | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:274` |
| 95.4% | 17.26s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7619` |
| 92.0% | 16.65s | 0.5% | 98.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7136` |
| 91.4% | 16.53s | 0.0% | 1.3ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4730` |
| 90.5% | 16.38s | 0.0% | 1.5ms | `VariableDeclarator` | `/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:55` |
| 90.5% | 16.38s | 0.0% | 0us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3135` |
| 84.4% | 15.28s | 84.4% | 15.28s | `push` | `[native code]` |
| 31.7% | 5.74s | 1.7% | 322.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3227` |
| 29.6% | 5.36s | 1.8% | 332.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3225` |
| 28.6% | 5.18s | 1.9% | 360.9ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3226` |
| 4.2% | 775.0ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` |
| 4.2% | 764.7ms | 4.2% | 764.7ms | `parse` | `[native code]` |
| 4.2% | 764.7ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` |
| 0.6% | 125.3ms | 0.6% | 120.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7271` |
| 0.5% | 100.9ms | 0.0% | 0us | `VariableDeclarator` | `/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:60` |
| 0.4% | 86.6ms | 0.0% | 1.6ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:808` |
| 0.4% | 80.1ms | 0.0% | 3.0ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2120` |
| 0.4% | 79.3ms | 0.2% | 36.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 0.4% | 73.7ms | 0.3% | 70.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7108` |
| 0.3% | 67.1ms | 0.0% | 0us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4137` |
| 0.3% | 56.7ms | 0.3% | 56.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7373` |
| 0.3% | 54.7ms | 0.3% | 54.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6816` |
| 0.2% | 52.0ms | 0.0% | 0us | `bound require` | `[native code]` |
| 0.2% | 50.1ms | 0.0% | 15.8ms | `anonymous` | `[native code]` |
| 0.2% | 49.6ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2883` |
| 0.2% | 48.3ms | 0.0% | 0us | `require` | `[native code]` |
| 0.2% | 40.7ms | 0.2% | 40.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7096` |
| 0.2% | 40.1ms | 0.1% | 19.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7304` |
| 0.2% | 38.7ms | 0.0% | 6.0ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2141` |
| 0.2% | 37.1ms | 0.2% | 37.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7098` |
| 0.1% | 36.1ms | 0.1% | 36.1ms | `defineProperty` | `[native code]` |
| 0.1% | 34.1ms | 0.1% | 34.1ms | `create` | `[native code]` |
| 0.1% | 29.4ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2240` |
| 0.1% | 28.7ms | 0.0% | 0us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1211` |
| 0.1% | 25.4ms | 0.1% | 25.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6802` |
| 0.1% | 23.9ms | 0.1% | 23.9ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` |
| 0.1% | 22.7ms | 0.0% | 3.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7306` |
| 0.1% | 22.3ms | 0.0% | 10.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7303` |
| 0.1% | 21.3ms | 0.0% | 0us | `VariableDeclarator` | `/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:47` |
| 0.1% | 19.6ms | 0.0% | 2.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7308` |
| 0.1% | 19.5ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4165` |
| 0.1% | 19.5ms | 0.0% | 0us | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2949` |
| 0.1% | 18.4ms | 0.0% | 1.5ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3162` |
| 0.0% | 17.8ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7095` |
| 0.0% | 16.8ms | 0.0% | 0us | `parseModule` | `[native code]` |
| 0.0% | 16.8ms | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 0.0% | 16.5ms | 0.0% | 1.3ms | `VariableDeclarator` | `/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:45` |
| 0.0% | 16.2ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7611` |
| 0.0% | 15.7ms | 0.0% | 4.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7238` |
| 0.0% | 15.7ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3147` |
| 0.0% | 15.7ms | 0.0% | 15.7ms | `subarray` | `[native code]` |
| 0.0% | 15.4ms | 0.0% | 4.6ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:802` |
| 0.0% | 15.2ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2876` |
| 0.0% | 15.0ms | 0.0% | 11.7ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1733` |
| 0.0% | 14.8ms | 0.0% | 14.8ms | `decode` | `[native code]` |
| 0.0% | 14.8ms | 0.0% | 0us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` |
| 0.0% | 14.7ms | 0.0% | 14.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6820` |
| 0.0% | 14.6ms | 0.0% | 0us | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:905` |
| 0.0% | 14.0ms | 0.0% | 9.0ms | `Set` | `[native code]` |
| 0.0% | 14.0ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3177` |
| 0.0% | 13.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:25` |
| 0.0% | 12.7ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1713` |
| 0.0% | 12.2ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2872` |
| 0.0% | 11.4ms | 0.0% | 1.3ms | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6378` |
| 0.0% | 11.1ms | 0.0% | 9.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4110` |
| 0.0% | 10.7ms | 0.0% | 10.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3187` |
| 0.0% | 10.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` |
| 0.0% | 9.9ms | 0.0% | 9.9ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 9.7ms | 0.0% | 9.7ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 7.6ms | 0.0% | 7.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3207` |
| 0.0% | 7.3ms | 0.0% | 0us | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2929` |
| 0.0% | 7.3ms | 0.0% | 0us | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2847` |
| 0.0% | 7.3ms | 0.0% | 0us | `scope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:764` |
| 0.0% | 7.2ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:435` |
| 0.0% | 7.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:477` |
| 0.0% | 7.0ms | 0.0% | 7.0ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:855` |
| 0.0% | 7.0ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2065` |
| 0.0% | 7.0ms | 0.0% | 0us | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:839` |
| 0.0% | 6.8ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1516` |
| 0.0% | 6.6ms | 0.0% | 6.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7374` |
| 0.0% | 6.6ms | 0.0% | 6.6ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 6.6ms | 0.0% | 6.6ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6540` |
| 0.0% | 6.4ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7618` |
| 0.0% | 6.3ms | 0.0% | 6.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7201` |
| 0.0% | 6.3ms | 0.0% | 3.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7311` |
| 0.0% | 6.1ms | 0.0% | 1.3ms | `VariableDeclarator` | `/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:48` |
| 0.0% | 6.0ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` |
| 0.0% | 5.8ms | 0.0% | 5.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7247` |
| 0.0% | 5.6ms | 0.0% | 5.6ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4058` |
| 0.0% | 4.8ms | 0.0% | 0us | `next` | `[native code]` |
| 0.0% | 4.5ms | 0.0% | 4.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2879` |
| 0.0% | 4.4ms | 0.0% | 4.4ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3190` |
| 0.0% | 4.3ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:478` |
| 0.0% | 4.2ms | 0.0% | 4.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2067` |
| 0.0% | 4.0ms | 0.0% | 2.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2068` |
| 0.0% | 3.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.0% | 3.4ms | 0.0% | 0us | `_getOrBuildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5629` |
| 0.0% | 3.4ms | 0.0% | 0us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5947` |
| 0.0% | 3.4ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6699` |
| 0.0% | 3.4ms | 0.0% | 1.7ms | `readdirSync` | `[native code]` |
| 0.0% | 3.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 3.3ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4415` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3656` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 3.1ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2907` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_Reference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:236` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `dlopen` | `[native code]` |
| 0.0% | 3.1ms | 0.0% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2125` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `get` | `[native code]` |
| 0.0% | 3.1ms | 0.0% | 1.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2195` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `typedArrayViewLength` | `[native code]` |
| 0.0% | 3.0ms | 0.0% | 0us | `arrayIteratorNextHelper` | `[native code]` |
| 0.0% | 3.0ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3201` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3223` |
| 0.0% | 2.9ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:220` |
| 0.0% | 2.9ms | 0.0% | 0us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `encodeInto` | `[native code]` |
| 0.0% | 2.9ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7298` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4393` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2167` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `has` | `[native code]` |
| 0.0% | 2.8ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3222` |
| 0.0% | 2.8ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6475` |
| 0.0% | 2.7ms | 0.0% | 1.3ms | `readFileSync` | `[native code]` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7296` |
| 0.0% | 2.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.0% | 1.8ms | 0.0% | 0us | `loadBinding` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` |
| 0.0% | 1.8ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:267` |
| 0.0% | 1.8ms | 0.0% | 0us | `getTagNames` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:191` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `[native code]` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:11` |
| 0.0% | 1.8ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1511` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3673` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7030` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1223` |
| 0.0% | 1.8ms | 0.0% | 0us | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3922` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_isChainMiddleTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.8ms | 0.0% | 0us | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2949` |
| 0.0% | 1.8ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4162` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `typedArrayViewIsDetached` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `linkAndEvaluateModule` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `async loadAndEvaluateModule` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2971` |
| 0.0% | 1.7ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2221` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2175` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5015` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3667` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7297` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:565` |
| 0.0% | 1.7ms | 0.0% | 0us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4134` |
| 0.0% | 1.7ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:47` |
| 0.0% | 1.7ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:135` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1317` |
| 0.0% | 1.7ms | 0.0% | 0us | `Ae` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.7ms | 0.0% | 0us | `Pe` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `g` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.7ms | 0.0% | 0us | `we` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.7ms | 0.0% | 0us | `ke` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.7ms | 0.0% | 0us | `parse` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.7ms | 0.0% | 0us | `_e` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `VariableDeclarator` | `/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:50` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7024` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5011` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3026` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4732` |
| 0.0% | 1.6ms | 0.0% | 0us | `esquery` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:53` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getUint32` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:289` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1732` |
| 0.0% | 1.6ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:38` |
| 0.0% | 1.6ms | 0.0% | 0us | `async _loadFlatConfig` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:36` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `join` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `async _loadFlatConfig` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:39` |
| 0.0% | 1.6ms | 0.0% | 0us | `async lintSource` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:349` |
| 0.0% | 1.6ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:81` |
| 0.0% | 1.6ms | 0.0% | 0us | `async lintSource` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:350` |
| 0.0% | 1.6ms | 0.0% | 0us | `async _resolveConfig` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:70` |
| 0.0% | 1.6ms | 0.0% | 0us | `bound join` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `async _resolveConfig` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:67` |
| 0.0% | 1.6ms | 0.0% | 0us | `map` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:75` |
| 0.0% | 1.6ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3157` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2751` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` |
| 0.0% | 1.5ms | 0.0% | 0us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5439` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_Variable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:847` |
| 0.0% | 1.5ms | 0.0% | 0us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2782` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `VariableDeclarator` | `/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:49` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4116` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2069` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2106` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_nodeStartPos` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:925` |
| 0.0% | 1.4ms | 0.0% | 0us | `get start` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1122` |
| 0.0% | 1.4ms | 0.0% | 0us | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3630` |
| 0.0% | 1.4ms | 0.0% | 0us | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:822` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getOwnPropertyDescriptor` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7246` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6542` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4392` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2781` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2161` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `values` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2244` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7317` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7302` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:28` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1515` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn-jsx/index.js:3` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4051` |
| 0.0% | 1.3ms | 0.0% | 0us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1367` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` |
| 0.0% | 1.3ms | 0.0% | 0us | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:784` |
| 0.0% | 1.3ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7402` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4049` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7184` |
| 0.0% | 1.3ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3181` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2156` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:769` |
| 0.0% | 1.3ms | 0.0% | 0us | `get identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:775` |
| 0.0% | 1.3ms | 0.0% | 0us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6377` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7309` |
| 0.0% | 1.2ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:233` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getTagNames` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:190` |
| 0.0% | 1.2ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4365` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4775` |
| 0.0% | 1.2ms | 0.0% | 0us | `_getFfiSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:110` |
| 0.0% | 1.2ms | 0.0% | 0us | `dlopen` | `bun:ffi:345` |
| 0.0% | 1.2ms | 0.0% | 0us | `isAvailable` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:399` |
| 0.0% | 1.2ms | 0.0% | 0us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5507` |
| 0.0% | 1.2ms | 0.0% | 0us | `_tryLoad` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:51` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `set` | `[native code]` |

## Function Details

### `push`
`[native code]` | Self: 84.4% (15.28s) | Total: 84.4% (15.28s) | Samples: 9977

**Called by:**
- `_computeDeclaredVariables` (3523)
- `_computeDeclaredVariables` (3300)
- `_computeDeclaredVariables` (3154)

### `parse`
`[native code]` | Self: 4.2% (764.7ms) | Total: 4.2% (764.7ms) | Samples: 501

**Called by:**
- `parseSource` (501)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3226` | Self: 1.9% (360.9ms) | Total: 28.6% (5.18s) | Samples: 235

**Called by:**
- `getDeclaredVariables` (3389)

**Calls:**
- `push` (3154)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3225` | Self: 1.8% (332.6ms) | Total: 29.6% (5.36s) | Samples: 219

**Called by:**
- `getDeclaredVariables` (3520)

**Calls:**
- `push` (3300)
- `get identifiers` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3227` | Self: 1.7% (322.6ms) | Total: 31.7% (5.74s) | Samples: 205

**Called by:**
- `getDeclaredVariables` (3730)

**Calls:**
- `push` (3523)
- `get references` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7271` | Self: 0.6% (120.2ms) | Total: 0.6% (125.3ms) | Samples: 78

**Called by:**
- `runPlugins` (81)

**Calls:**
- `_resolveHandlers` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7136` | Self: 0.5% (98.8ms) | Total: 92.0% (16.65s) | Samples: 65

**Called by:**
- `runPlugins` (10865)

**Calls:**
- `_invokeFused` (10792)
- `nodeView` (5)
- `_invokeFused` (1)
- `_invokeFused` (1)
- `_invokeFused` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7108` | Self: 0.3% (70.4ms) | Total: 0.4% (73.7ms) | Samples: 47

**Called by:**
- `runPlugins` (49)

**Calls:**
- `_resolveHandlers` (1)
- `_resolveHandlers` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7373` | Self: 0.3% (56.7ms) | Total: 0.3% (56.7ms) | Samples: 36

**Called by:**
- `runPlugins` (36)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6816` | Self: 0.3% (54.7ms) | Total: 0.3% (54.7ms) | Samples: 36

**Called by:**
- `runPlugins` (36)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7096` | Self: 0.2% (40.7ms) | Total: 0.2% (40.7ms) | Samples: 27

**Called by:**
- `runPlugins` (27)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7098` | Self: 0.2% (37.1ms) | Total: 0.2% (37.1ms) | Samples: 23

**Called by:**
- `runPlugins` (23)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` | Self: 0.2% (36.6ms) | Total: 0.4% (79.3ms) | Samples: 24

**Called by:**
- `nodeView` (40)
- `nodeViewChain` (8)
- `_nodesFromRange` (1)
- `get parent` (1)
- `get body` (1)

**Calls:**
- `_NodeView` (15)
- `_NodeView` (6)
- `_NodeView_LR` (4)
- `_NodeView_LRN` (1)
- `_NodeView_LR` (1)

### `defineProperty`
`[native code]` | Self: 0.1% (36.1ms) | Total: 0.1% (36.1ms) | Samples: 24

**Called by:**
- `walkNodes` (13)
- `walkNodes` (11)

### `create`
`[native code]` | Self: 0.1% (34.1ms) | Total: 0.1% (34.1ms) | Samples: 23

**Called by:**
- `walkNodes` (14)
- `walkNodes` (8)
- `buildVisitorMap` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6802` | Self: 0.1% (25.4ms) | Total: 0.1% (25.4ms) | Samples: 17

**Called by:**
- `runPlugins` (17)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` | Self: 0.1% (23.9ms) | Total: 0.1% (23.9ms) | Samples: 15

**Called by:**
- `_nodeViewRaw` (15)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7304` | Self: 0.1% (19.2ms) | Total: 0.2% (40.1ms) | Samples: 13

**Called by:**
- `runPlugins` (27)

**Calls:**
- `create` (14)

### `anonymous`
`[native code]` | Self: 0.0% (15.8ms) | Total: 0.2% (50.1ms) | Samples: 10

**Called by:**
- `require` (33)
- `bound require` (1)

**Calls:**
- `(anonymous)` (7)
- `(anonymous)` (5)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `subarray`
`[native code]` | Self: 0.0% (15.7ms) | Total: 0.0% (15.7ms) | Samples: 10

**Called by:**
- `_computeDeclaredVariables` (10)

### `decode`
`[native code]` | Self: 0.0% (14.8ms) | Total: 0.0% (14.8ms) | Samples: 10

**Called by:**
- `get source` (10)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6820` | Self: 0.0% (14.7ms) | Total: 0.0% (14.7ms) | Samples: 10

**Called by:**
- `runPlugins` (10)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1733` | Self: 0.0% (11.7ms) | Total: 0.0% (15.0ms) | Samples: 8

**Called by:**
- `_computeIsStrict` (10)

**Calls:**
- `nodeView` (1)
- `_nodeViewRaw` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3187` | Self: 0.0% (10.7ms) | Total: 0.0% (10.7ms) | Samples: 7

**Called by:**
- `getDeclaredVariables` (7)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7303` | Self: 0.0% (10.3ms) | Total: 0.1% (22.3ms) | Samples: 7

**Called by:**
- `runPlugins` (15)

**Calls:**
- `create` (8)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (9.9ms) | Total: 0.0% (9.9ms) | Samples: 6

**Called by:**
- `_nodeViewRaw` (6)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (9.7ms) | Total: 0.0% (9.7ms) | Samples: 7

**Called by:**
- `walkNodes` (7)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4110` | Self: 0.0% (9.6ms) | Total: 0.0% (11.1ms) | Samples: 6

**Called by:**
- `nodeViewChain` (4)
- `nodeView` (3)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `Set`
`[native code]` | Self: 0.0% (9.0ms) | Total: 0.0% (14.0ms) | Samples: 6

**Called by:**
- `_computeDeclaredVariables` (9)

**Calls:**
- `next` (2)
- `values` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3207` | Self: 0.0% (7.6ms) | Total: 0.0% (7.6ms) | Samples: 5

**Called by:**
- `getDeclaredVariables` (5)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:855` | Self: 0.0% (7.0ms) | Total: 0.0% (7.0ms) | Samples: 5

**Called by:**
- `_symName` (5)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7374` | Self: 0.0% (6.6ms) | Total: 0.0% (6.6ms) | Samples: 5

**Called by:**
- `runPlugins` (5)

### `_resolveHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (6.6ms) | Total: 0.0% (6.6ms) | Samples: 4

**Called by:**
- `walkNodes` (3)
- `walkNodes` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6540` | Self: 0.0% (6.6ms) | Total: 0.0% (6.6ms) | Samples: 4

**Called by:**
- `walkNodes` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7201` | Self: 0.0% (6.3ms) | Total: 0.0% (6.3ms) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2141` | Self: 0.0% (6.0ms) | Total: 0.2% (38.7ms) | Samples: 4

**Called by:**
- `_buildScope` (16)
- `_buildReference` (6)
- `_computeVarScope` (3)

**Calls:**
- `_computeIsStrict` (19)
- `_computeIsStrict` (1)
- `_computeIsStrict` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7247` | Self: 0.0% (5.8ms) | Total: 0.0% (5.8ms) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4058` | Self: 0.0% (5.6ms) | Total: 0.0% (5.6ms) | Samples: 4

**Called by:**
- `_nodeViewRaw` (4)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:802` | Self: 0.0% (4.6ms) | Total: 0.0% (15.4ms) | Samples: 3

**Called by:**
- `VariableDeclarator` (10)

**Calls:**
- `_computeVariableSynthRefs` (5)
- `_computeVariableSynthRefs` (1)
- `_computeVariableSynthRefs` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2879` | Self: 0.0% (4.5ms) | Total: 0.0% (4.5ms) | Samples: 3

**Called by:**
- `get references` (3)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3190` | Self: 0.0% (4.4ms) | Total: 0.0% (4.4ms) | Samples: 3

**Called by:**
- `getDeclaredVariables` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7238` | Self: 0.0% (4.3ms) | Total: 0.0% (15.7ms) | Samples: 3

**Called by:**
- `runPlugins` (10)

**Calls:**
- `invokeMethodFnHandlers` (6)
- `invokeMethodFnHandlers` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2067` | Self: 0.0% (4.2ms) | Total: 0.0% (4.2ms) | Samples: 3

**Called by:**
- `_computeDeclaredVariables` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7306` | Self: 0.0% (3.3ms) | Total: 0.1% (22.7ms) | Samples: 2

**Called by:**
- `runPlugins` (15)

**Calls:**
- `defineProperty` (13)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3656` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `get value` (2)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `_buildReference` (2)

### `_Reference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:236` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `_buildReference` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7311` | Self: 0.0% (3.1ms) | Total: 0.0% (6.3ms) | Samples: 2

**Called by:**
- `runPlugins` (4)

**Calls:**
- `get` (2)

### `dlopen`
`[native code]` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `dlopen` (1)
- `(anonymous)` (1)

### `get`
`[native code]` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `typedArrayViewLength`
`[native code]` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `arrayIteratorNextHelper` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2120` | Self: 0.0% (3.0ms) | Total: 0.4% (80.1ms) | Samples: 2

**Called by:**
- `_buildScope` (30)
- `_buildReference` (20)
- `_computeVarScope` (1)

**Calls:**
- `_buildScope` (30)
- `_buildScope` (16)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3223` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `getDeclaredVariables` (2)

### `encodeInto`
`[native code]` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `_encodeSource` (2)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4393` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2167` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `_buildReference` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7308` | Self: 0.0% (2.9ms) | Total: 0.1% (19.6ms) | Samples: 2

**Called by:**
- `runPlugins` (13)

**Calls:**
- `defineProperty` (11)

### `has`
`[native code]` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `_computeDeclaredVariables` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7296` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2068` | Self: 0.0% (2.7ms) | Total: 0.0% (4.0ms) | Samples: 2

**Called by:**
- `_computeDeclaredVariables` (3)

**Calls:**
- `set` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3673` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `get value` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1223` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `VariableDeclarator` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7030` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_isChainMiddleTag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `_isChainNode` (1)

### `typedArrayViewIsDetached`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `next` (1)

### `linkAndEvaluateModule`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `async loadAndEvaluateModule` (1)

### `nodeRhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_computeVariableSynthRefs` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2175` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5015` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_buildPlan` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3667` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `get value` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2195` | Self: 0.0% (1.7ms) | Total: 0.0% (3.1ms) | Samples: 1

**Called by:**
- `_buildScope` (1)
- `_buildReference` (1)

**Calls:**
- `get name` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7297` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `nodeLhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:565` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `nodeView` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1317` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `VariableDeclarator` (1)

### `readdirSync`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (3.4ms) | Samples: 1

**Called by:**
- `readdirSync` (1)
- `loadCoreRules` (1)

**Calls:**
- `readdirSync` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `VariableDeclarator`
`/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:50` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `_resolveHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7024` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5011` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildPlan` (1)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3026` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `get references` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:808` | Self: 0.0% (1.6ms) | Total: 0.4% (86.6ms) | Samples: 1

**Called by:**
- `VariableDeclarator` (54)
- `_computeDeclaredVariables` (2)

**Calls:**
- `_buildReference` (32)
- `_buildReference` (10)
- `_buildReference` (8)
- `_buildReference` (3)
- `_buildReference` (2)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4732` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `getUint32`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `extraFnData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `get body` (1)

### `join`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `bound join` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2125` | Self: 0.0% (1.6ms) | Total: 0.0% (3.1ms) | Samples: 1

**Called by:**
- `_buildScope` (1)
- `_buildReference` (1)

**Calls:**
- `nodeView` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2751` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_computeDeclaredVariables` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_compileSelectorFastMatcher`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_getOrBuildSelectorPlan` (1)

### `_Variable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:847` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildVariable` (1)

### `VariableDeclarator`
`/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:49` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3162` | Self: 0.0% (1.5ms) | Total: 0.1% (18.4ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (13)

**Calls:**
- `_ensureDeclSymIndex` (5)
- `_ensureDeclSymIndex` (3)
- `_ensureDeclSymIndex` (3)
- `_ensureDeclSymIndex` (1)

### `VariableDeclarator`
`/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:55` | Self: 0.0% (1.5ms) | Total: 90.5% (16.38s) | Samples: 1

**Called by:**
- `_invokeFused` (10696)

**Calls:**
- `getDeclaredVariables` (10694)
- `getDeclaredVariables` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4116` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `nodeView` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2069` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_computeDeclaredVariables` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2106` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_computeVarScope` (1)

### `_nodeStartPos`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:925` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get start` (1)

### `getOwnPropertyDescriptor`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `nodeLhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6542` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4392` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2781` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_computeDeclaredVariables` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2161` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `values`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `Set` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2244` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7317` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7302` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `VariableDeclarator` (1)

### `readFileSync`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (2.7ms) | Samples: 1

**Called by:**
- `readFileSync` (1)
- `(anonymous)` (1)

**Calls:**
- `readFileSync` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1515` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `invokeMethodFnHandlers` (1)

### `VariableDeclarator`
`/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:48` | Self: 0.0% (1.3ms) | Total: 0.0% (6.1ms) | Samples: 1

**Called by:**
- `_invokeFused` (4)

**Calls:**
- `nodeView` (3)

### `VariableDeclarator`
`/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:45` | Self: 0.0% (1.3ms) | Total: 0.0% (16.5ms) | Samples: 1

**Called by:**
- `_invokeFused` (11)

**Calls:**
- `get parent` (8)
- `get parent` (1)
- `get parent` (1)

### `_NodeView_LRN`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4051` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_identAt` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6378` | Self: 0.0% (1.3ms) | Total: 0.0% (11.4ms) | Samples: 1

**Called by:**
- `walkNodes` (6)
- `walkNodes` (1)

**Calls:**
- `get value` (4)
- `get value` (1)
- `get value` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4049` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7184` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4730` | Self: 0.0% (1.3ms) | Total: 91.4% (16.53s) | Samples: 1

**Called by:**
- `walkNodes` (10792)

**Calls:**
- `VariableDeclarator` (10696)
- `VariableDeclarator` (65)
- `VariableDeclarator` (13)
- `VariableDeclarator` (11)
- `VariableDeclarator` (4)
- `VariableDeclarator` (1)
- `VariableDeclarator` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2156` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:769` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `get identifiers` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7309` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `getTagNames`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:190` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `parseSource` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4775` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `set`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_ensureDeclSymIndex` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_getFfiSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:110` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_getOrBuildSelectorPlan` (1)

**Calls:**
- `isAvailable` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` | Self: 0.0% (0us) | Total: 4.2% (775.0ms) | Samples: 0

**Calls:**
- `parseSource` (501)
- `parseSource` (3)
- `parseSource` (2)
- `parseSource` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` | Self: 0.0% (0us) | Total: 0.0% (6.0ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (3)

**Calls:**
- `AstView` (2)
- `AstView` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7619` | Self: 0.0% (0us) | Total: 95.4% (17.26s) | Samples: 0

**Called by:**
- `_lintSourceOne` (11270)

**Calls:**
- `walkNodes` (10865)
- `walkNodes` (81)
- `walkNodes` (49)
- `walkNodes` (36)
- `walkNodes` (36)
- `walkNodes` (27)
- `walkNodes` (27)
- `walkNodes` (23)
- `walkNodes` (17)
- `walkNodes` (15)
- `walkNodes` (15)
- `walkNodes` (13)
- `walkNodes` (12)
- `walkNodes` (10)
- `walkNodes` (10)
- `walkNodes` (5)
- `walkNodes` (4)
- `walkNodes` (4)
- `walkNodes` (4)
- `walkNodes` (2)
- `walkNodes` (2)
- `walkNodes` (2)
- `walkNodes` (2)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)

### `_isChainNode`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3922` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `nodeViewChain` (1)

**Calls:**
- `_isChainMiddleTag` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4137` | Self: 0.0% (0us) | Total: 0.3% (67.1ms) | Samples: 0

**Called by:**
- `get parent` (18)
- `_nodesFromRange` (8)
- `_buildReference` (5)
- `walkNodes` (5)
- `VariableDeclarator` (3)
- `walkNodes` (2)
- `_buildScope` (1)
- `get body` (1)
- `invokeMethodFnHandlers` (1)

**Calls:**
- `_nodeViewRaw` (40)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4365` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `create` (1)

### `Ae`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `parse` (1)

**Calls:**
- `_e` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:289` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `getUint32` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:267` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Calls:**
- `getTagNames` (1)

### `g`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (1)

**Calls:**
- `parse` (1)

### `async lintSource`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:349` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `async lintSource` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3222` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (2)

**Calls:**
- `has` (2)

### `_computeVarScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2847` | Self: 0.0% (0us) | Total: 0.0% (7.3ms) | Samples: 0

**Called by:**
- `scope` (5)

**Calls:**
- `_buildScope` (3)
- `_buildScope` (1)
- `_buildScope` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1511` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (1)

**Calls:**
- `_nodesFromRange` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:905` | Self: 0.0% (0us) | Total: 0.0% (14.6ms) | Samples: 0

**Called by:**
- `get body` (8)
- `get value` (1)

**Calls:**
- `nodeView` (8)
- `_nodeViewRaw` (1)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5439` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_compileSelectorFastMatcher` (1)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:784` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `get name` (1)

**Calls:**
- `source` (1)

### `scope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:764` | Self: 0.0% (0us) | Total: 0.0% (7.3ms) | Samples: 0

**Called by:**
- `_computeVariableSynthRefs` (5)

**Calls:**
- `_computeVarScope` (5)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2929` | Self: 0.0% (0us) | Total: 0.0% (7.3ms) | Samples: 0

**Called by:**
- `get references` (5)

**Calls:**
- `scope` (5)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7246` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `nodeLhs` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:233` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `getTagNames` (1)

### `isAvailable`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:399` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_getFfiSelector` (1)

**Calls:**
- `_tryLoad` (1)

### `arrayIteratorNextHelper`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `next` (2)

**Calls:**
- `typedArrayViewLength` (2)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4134` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_buildReference` (1)

**Calls:**
- `nodeLhs` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6377` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `nodeView` (1)

### `map`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `async _loadFlatConfig` (1)

**Calls:**
- `bound join` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:477` | Self: 0.0% (0us) | Total: 0.0% (7.2ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `patchAstUtils` (5)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6475` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `_getOrBuildSelectorPlan` (1)
- `_getOrBuildSelectorPlan` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:478` | Self: 0.0% (0us) | Total: 0.0% (4.3ms) | Samples: 0

**Called by:**
- `parseSource` (2)

**Calls:**
- `CfgGraph` (1)
- `CfgGraph` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3201` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (2)

**Calls:**
- `_buildVariable` (1)
- `_buildVariable` (1)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:435` | Self: 0.0% (0us) | Total: 0.0% (7.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `bound require` (5)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:274` | Self: 0.0% (0us) | Total: 95.5% (17.29s) | Samples: 0

**Calls:**
- `runPlugins` (11270)
- `runPlugins` (11)
- `runPlugins` (4)

### `_getOrBuildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5629` | Self: 0.0% (0us) | Total: 0.0% (3.4ms) | Samples: 0

**Called by:**
- `walkNodes` (2)

**Calls:**
- `_buildPlan` (2)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:47` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (1)

**Calls:**
- `readdirSync` (1)

### `async lintSource`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:350` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `async lintSource` (1)

**Calls:**
- `async _resolveConfig` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` | Self: 0.0% (0us) | Total: 4.2% (764.7ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (501)

**Calls:**
- `parse` (501)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:28` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `readFileSync` (1)

### `parse`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `g` (1)

**Calls:**
- `Ae` (1)

### `ke`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `we` (1)

**Calls:**
- `(anonymous)` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3181` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (1)

**Calls:**
- `next` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:135` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Calls:**
- `loadCoreRules` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6699` | Self: 0.0% (0us) | Total: 0.0% (3.4ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `_getOrBuildPlan` (2)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2883` | Self: 0.0% (0us) | Total: 0.2% (49.6ms) | Samples: 0

**Called by:**
- `get references` (32)

**Calls:**
- `_buildScope` (20)
- `_buildScope` (6)
- `_buildScope` (2)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:38` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Calls:**
- `async lintSource` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:75` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `async _resolveConfig` (1)

**Calls:**
- `async _resolveConfigImpl` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:25` | Self: 0.0% (0us) | Total: 0.0% (13.6ms) | Samples: 0

**Called by:**
- `parseModule` (9)

**Calls:**
- `bound require` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4415` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `g` (1)
- `esquery` (1)

### `get identifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:775` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_computeDeclaredVariables` (1)

**Calls:**
- `defs` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3630` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `get references` (1)

**Calls:**
- `get start` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7298` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `nodeView` (2)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1211` | Self: 0.0% (0us) | Total: 0.1% (28.7ms) | Samples: 0

**Called by:**
- `_buildReference` (10)
- `VariableDeclarator` (8)
- `_computeIsStrict` (1)

**Calls:**
- `nodeView` (18)
- `_nodeViewRaw` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3147` | Self: 0.0% (0us) | Total: 0.0% (15.7ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (10)

**Calls:**
- `subarray` (10)

### `Pe`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_e` (1)

**Calls:**
- `we` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5947` | Self: 0.0% (0us) | Total: 0.0% (3.4ms) | Samples: 0

**Called by:**
- `_getOrBuildPlan` (2)

**Calls:**
- `_extractFileLevelRules` (1)
- `_extractFileLevelRules` (1)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 0.2% (48.3ms) | Samples: 0

**Called by:**
- `bound require` (33)

**Calls:**
- `anonymous` (33)

### `bound join`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `join` (1)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (16.8ms) | Samples: 0

**Calls:**
- `parseModule` (11)

### `_e`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `Ae` (1)

**Calls:**
- `Pe` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2876` | Self: 0.0% (0us) | Total: 0.0% (15.2ms) | Samples: 0

**Called by:**
- `get references` (10)

**Calls:**
- `get parent` (10)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1367` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_buildScope` (1)

**Calls:**
- `_identAt` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3157` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (1)

**Calls:**
- `_buildVariable` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:220` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (2)

**Calls:**
- `_encodeSource` (2)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2971` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `get references` (1)

**Calls:**
- `nodeRhs` (1)

### `we`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `Pe` (1)

**Calls:**
- `ke` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_tryLoad`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:51` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `isAvailable` (1)

**Calls:**
- `dlopen` (1)

### `get init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2949` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `VariableDeclarator` (1)

**Calls:**
- `nodeViewChain` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2907` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `get references` (2)

**Calls:**
- `_Reference` (2)

### `loadBinding`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `getTagNames` (1)

**Calls:**
- `bound require` (1)

### `async _loadFlatConfig`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:39` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `async _loadFlatConfig` (1)

**Calls:**
- `map` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1732` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `extraFnData` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2782` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_computeDeclaredVariables` (1)

**Calls:**
- `_Variable` (1)

### `VariableDeclarator`
`/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:47` | Self: 0.0% (0us) | Total: 0.1% (21.3ms) | Samples: 0

**Called by:**
- `_invokeFused` (13)

**Calls:**
- `init` (12)
- `get init` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `bound require` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7402` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `invokeMethodFnHandlers` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:822` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `VariableDeclarator` (1)

**Calls:**
- `get range` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2240` | Self: 0.0% (0us) | Total: 0.1% (29.4ms) | Samples: 0

**Called by:**
- `_buildScope` (19)

**Calls:**
- `get body` (10)
- `get body` (8)
- `get body` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4165` | Self: 0.0% (0us) | Total: 0.1% (19.5ms) | Samples: 0

**Called by:**
- `init` (12)

**Calls:**
- `_nodeViewRaw` (8)
- `_nodeViewRaw` (4)

### `getTagNames`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:191` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `loadBinding` (1)

### `get start`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1122` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `get range` (1)

**Calls:**
- `_nodeStartPos` (1)

### `async _resolveConfig`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:67` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `async lintSource` (1)

**Calls:**
- `async _resolveConfig` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (3.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)
- `ke` (1)

**Calls:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `next`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (4.8ms) | Samples: 0

**Called by:**
- `Set` (2)
- `_computeDeclaredVariables` (1)

**Calls:**
- `arrayIteratorNextHelper` (2)
- `typedArrayViewIsDetached` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1516` | Self: 0.0% (0us) | Total: 0.0% (6.8ms) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (4)

**Calls:**
- `get loc` (2)
- `get loc` (1)
- `get loc` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4162` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `get init` (1)

**Calls:**
- `_isChainNode` (1)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 0.2% (52.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (9)
- `(anonymous)` (7)
- `patchAstUtils` (5)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `loadBinding` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `esquery` (1)

**Calls:**
- `require` (33)
- `(anonymous)` (1)
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` | Self: 0.0% (0us) | Total: 0.0% (10.5ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.0% (3.9ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5507` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_getFfiSelector` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1713` | Self: 0.0% (0us) | Total: 0.0% (12.7ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (8)

**Calls:**
- `_nodesFromRange` (8)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3177` | Self: 0.0% (0us) | Total: 0.0% (14.0ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (9)

**Calls:**
- `Set` (9)

### `async _loadFlatConfig`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:36` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (1)

**Calls:**
- `async _loadFlatConfig` (1)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:839` | Self: 0.0% (0us) | Total: 0.0% (7.0ms) | Samples: 0

**Called by:**
- `_ensureDeclSymIndex` (5)

**Calls:**
- `_buildSymNameCache` (5)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2221` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_buildScope` (1)

**Calls:**
- `get parent` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7618` | Self: 0.0% (0us) | Total: 0.0% (6.4ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (4)

**Calls:**
- `buildVisitorMap` (2)
- `buildVisitorMap` (1)
- `buildVisitorMap` (1)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `parseSource` (2)

**Calls:**
- `encodeInto` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn-jsx/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7611` | Self: 0.0% (0us) | Total: 0.0% (16.2ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (11)

**Calls:**
- `get source` (10)
- `reset` (1)

### `dlopen`
`bun:ffi:345` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_tryLoad` (1)

**Calls:**
- `dlopen` (1)

### `(anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `bound require` (1)

**Calls:**
- `dlopen` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7095` | Self: 0.0% (0us) | Total: 0.0% (17.8ms) | Samples: 0

**Called by:**
- `runPlugins` (12)

**Calls:**
- `getDFSEvents` (7)
- `getDFSEvents` (4)
- `getDFSEvents` (1)

### `esquery`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:53` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (1)

**Calls:**
- `bound require` (1)

### `parseModule`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (16.8ms) | Samples: 0

**Called by:**
- `async (anonymous)` (11)

**Calls:**
- `(anonymous)` (9)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2949` | Self: 0.0% (0us) | Total: 0.1% (19.5ms) | Samples: 0

**Called by:**
- `VariableDeclarator` (12)

**Calls:**
- `nodeViewChain` (12)

### `async _resolveConfig`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:70` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `async _resolveConfig` (1)

**Calls:**
- `async _resolveConfigImpl` (1)

### `VariableDeclarator`
`/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:60` | Self: 0.0% (0us) | Total: 0.5% (100.9ms) | Samples: 0

**Called by:**
- `_invokeFused` (65)

**Calls:**
- `get references` (54)
- `get references` (10)
- `get references` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:81` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (1)

**Calls:**
- `async _loadFlatConfig` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2065` | Self: 0.0% (0us) | Total: 0.0% (7.0ms) | Samples: 0

**Called by:**
- `_computeDeclaredVariables` (5)

**Calls:**
- `_symName` (5)

### `async loadAndEvaluateModule`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Calls:**
- `linkAndEvaluateModule` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` | Self: 0.0% (0us) | Total: 0.0% (14.8ms) | Samples: 0

**Called by:**
- `runPlugins` (10)

**Calls:**
- `decode` (10)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2872` | Self: 0.0% (0us) | Total: 0.0% (12.2ms) | Samples: 0

**Called by:**
- `get references` (8)

**Calls:**
- `nodeView` (5)
- `nodeView` (2)
- `nodeView` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3135` | Self: 0.0% (0us) | Total: 90.5% (16.38s) | Samples: 0

**Called by:**
- `VariableDeclarator` (10694)

**Calls:**
- `_computeDeclaredVariables` (3730)
- `_computeDeclaredVariables` (3520)
- `_computeDeclaredVariables` (3389)
- `_computeDeclaredVariables` (13)
- `_computeDeclaredVariables` (10)
- `_computeDeclaredVariables` (9)
- `_computeDeclaredVariables` (7)
- `_computeDeclaredVariables` (5)
- `_computeDeclaredVariables` (3)
- `_computeDeclaredVariables` (2)
- `_computeDeclaredVariables` (2)
- `_computeDeclaredVariables` (2)
- `_computeDeclaredVariables` (1)
- `_computeDeclaredVariables` (1)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 89.5% | 16.20s | `[native code]` |
| 9.5% | 1.73s | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.7% | 140.0ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 7.5ms | `/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js` |
| 0.0% | 1.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 1.2ms | `/Users/ericsan/Development/OpenSource/Ez/js/index.js` |
| 0.0% | 1.2ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
