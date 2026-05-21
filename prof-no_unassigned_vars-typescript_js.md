# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 25.30s | 16281 | 1.0ms | 233 |

**Top 10:** `push` 67.4%, `_computeDeclaredVariables` 12.7%, `_computeDeclaredVariables` 6.6%, `_computeDeclaredVariables` 6.0%, `parse` 3.0%, `walkNodes` 0.4%, `walkNodes` 0.3%, `walkNodes` 0.2%, `walkNodes` 0.2%, `walkNodes` 0.2%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 67.4% | 17.07s | 67.4% | 17.07s | `push` | `[native code]` |
| 12.7% | 3.21s | 36.0% | 9.11s | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3211` |
| 6.6% | 1.67s | 28.2% | 7.15s | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3209` |
| 6.0% | 1.53s | 28.5% | 7.22s | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3210` |
| 3.0% | 765.8ms | 3.0% | 765.8ms | `parse` | `[native code]` |
| 0.4% | 120.1ms | 0.4% | 122.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7254` |
| 0.3% | 87.7ms | 94.4% | 23.88s | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7119` |
| 0.2% | 72.9ms | 0.3% | 80.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7091` |
| 0.2% | 60.6ms | 0.2% | 60.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6799` |
| 0.2% | 54.1ms | 0.2% | 54.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7356` |
| 0.1% | 40.3ms | 0.1% | 40.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7079` |
| 0.1% | 39.0ms | 0.4% | 101.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 0.1% | 34.9ms | 0.1% | 34.9ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` |
| 0.1% | 33.7ms | 0.1% | 33.7ms | `defineProperty` | `[native code]` |
| 0.1% | 30.4ms | 0.1% | 30.4ms | `create` | `[native code]` |
| 0.0% | 25.1ms | 0.0% | 25.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6785` |
| 0.0% | 21.9ms | 0.0% | 21.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7081` |
| 0.0% | 21.6ms | 0.0% | 23.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4110` |
| 0.0% | 17.2ms | 0.0% | 17.2ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:855` |
| 0.0% | 15.7ms | 0.0% | 15.7ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4058` |
| 0.0% | 15.3ms | 0.1% | 49.4ms | `anonymous` | `[native code]` |
| 0.0% | 15.0ms | 0.0% | 15.0ms | `decode` | `[native code]` |
| 0.0% | 11.8ms | 0.1% | 28.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7287` |
| 0.0% | 10.4ms | 0.0% | 10.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6803` |
| 0.0% | 9.5ms | 0.0% | 9.5ms | `subarray` | `[native code]` |
| 0.0% | 9.0ms | 0.0% | 9.0ms | `encodeInto` | `[native code]` |
| 0.0% | 8.8ms | 0.0% | 8.8ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 8.4ms | 0.0% | 8.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7300` |
| 0.0% | 8.1ms | 0.1% | 37.5ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2240` |
| 0.0% | 7.7ms | 0.0% | 7.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2175` |
| 0.0% | 7.1ms | 0.0% | 7.1ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3187` |
| 0.0% | 6.6ms | 0.0% | 6.6ms | `Set` | `[native code]` |
| 0.0% | 6.2ms | 0.0% | 6.2ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6523` |
| 0.0% | 6.1ms | 0.0% | 6.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2161` |
| 0.0% | 5.9ms | 0.0% | 5.9ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3200` |
| 0.0% | 5.9ms | 0.0% | 5.9ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3207` |
| 0.0% | 5.9ms | 0.0% | 20.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7289` |
| 0.0% | 5.5ms | 0.0% | 5.5ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 5.2ms | 0.0% | 5.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4111` |
| 0.0% | 5.1ms | 0.0% | 5.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2171` |
| 0.0% | 4.9ms | 0.0% | 4.9ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2068` |
| 0.0% | 4.9ms | 0.0% | 4.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7184` |
| 0.0% | 4.7ms | 0.0% | 4.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7357` |
| 0.0% | 4.7ms | 0.0% | 16.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2872` |
| 0.0% | 4.7ms | 0.0% | 4.7ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 4.6ms | 0.0% | 4.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1317` |
| 0.0% | 4.5ms | 0.0% | 4.5ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 4.5ms | 0.0% | 4.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4116` |
| 0.0% | 4.4ms | 0.0% | 4.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7255` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4132` |
| 0.0% | 3.7ms | 0.0% | 3.7ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4393` |
| 0.0% | 3.5ms | 0.2% | 50.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2141` |
| 0.0% | 3.3ms | 0.0% | 6.7ms | `readdirSync` | `[native code]` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2901` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2879` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3667` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4051` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7167` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2067` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3190` |
| 0.0% | 2.9ms | 0.0% | 22.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7291` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7007` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7292` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `isWrite` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7230` |
| 0.0% | 2.6ms | 0.0% | 16.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7286` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1710` |
| 0.0% | 1.8ms | 0.1% | 32.9ms | `VariableDeclarator` | `/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:45` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:100` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `binop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2069` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6525` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3373` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7029` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3206` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_Variable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:847` |
| 0.0% | 1.7ms | 0.0% | 4.5ms | `VariableDeclarator` | `/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:50` |
| 0.0% | 1.7ms | 0.0% | 11.2ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3147` |
| 0.0% | 1.6ms | 0.0% | 4.1ms | `next` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2222` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:570` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5904` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:466` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2066` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 2.5ms | `from` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6980` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3646` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_isChainMiddleTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3035` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5866` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7179` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `fetch` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getOwnPropertyDescriptor` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 16.5ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:802` |
| 0.0% | 1.4ms | 0.4% | 106.4ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:808` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7171` |
| 0.0% | 1.4ms | 0.0% | 9.3ms | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6361` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_rawTokenText` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:831` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_getSharedCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:726` |
| 0.0% | 1.4ms | 0.0% | 2.8ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3181` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2131` |
| 0.0% | 1.4ms | 0.0% | 2.4ms | `arrayIteratorNextHelper` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 5.9ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3201` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `dlopen` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_isOptionalTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3884` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2191` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1779` |
| 0.0% | 1.3ms | 0.1% | 26.5ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:905` |
| 0.0% | 1.3ms | 0.0% | 10.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7221` |
| 0.0% | 1.3ms | 0.0% | 2.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7385` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1413` |
| 0.0% | 1.3ms | 0.0% | 2.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7294` |
| 0.0% | 1.3ms | 94.0% | 23.77s | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4713` |
| 0.0% | 1.2ms | 0.3% | 81.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2120` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7279` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_Variable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 3.0ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2244` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3225` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2934` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` |
| 0.0% | 1.0ms | 0.0% | 1.0ms | `typedArrayViewLength` | `[native code]` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 96.8% | 24.49s | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:274` |
| 96.7% | 24.47s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7602` |
| 94.4% | 23.88s | 0.3% | 87.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7119` |
| 94.0% | 23.77s | 0.0% | 1.3ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4713` |
| 93.2% | 23.58s | 0.0% | 0us | `VariableDeclarator` | `/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:55` |
| 93.2% | 23.58s | 0.0% | 0us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3135` |
| 67.4% | 17.07s | 67.4% | 17.07s | `push` | `[native code]` |
| 36.0% | 9.11s | 12.7% | 3.21s | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3211` |
| 28.5% | 7.22s | 6.0% | 1.53s | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3210` |
| 28.2% | 7.15s | 6.6% | 1.67s | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3209` |
| 3.0% | 780.2ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` |
| 3.0% | 765.8ms | 3.0% | 765.8ms | `parse` | `[native code]` |
| 3.0% | 765.8ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` |
| 0.4% | 122.8ms | 0.4% | 120.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7254` |
| 0.4% | 121.2ms | 0.0% | 0us | `VariableDeclarator` | `/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:60` |
| 0.4% | 106.4ms | 0.0% | 1.4ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:808` |
| 0.4% | 101.7ms | 0.1% | 39.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 0.3% | 100.9ms | 0.0% | 0us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4137` |
| 0.3% | 81.9ms | 0.0% | 1.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2120` |
| 0.3% | 80.2ms | 0.2% | 72.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7091` |
| 0.2% | 66.2ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2883` |
| 0.2% | 60.6ms | 0.2% | 60.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6799` |
| 0.2% | 54.1ms | 0.2% | 54.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7356` |
| 0.2% | 50.7ms | 0.0% | 3.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2141` |
| 0.1% | 49.4ms | 0.0% | 15.3ms | `anonymous` | `[native code]` |
| 0.1% | 47.7ms | 0.0% | 0us | `bound require` | `[native code]` |
| 0.1% | 44.8ms | 0.0% | 0us | `require` | `[native code]` |
| 0.1% | 44.0ms | 0.0% | 0us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1211` |
| 0.1% | 40.3ms | 0.1% | 40.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7079` |
| 0.1% | 37.5ms | 0.0% | 8.1ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2240` |
| 0.1% | 34.9ms | 0.1% | 34.9ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` |
| 0.1% | 33.7ms | 0.1% | 33.7ms | `defineProperty` | `[native code]` |
| 0.1% | 32.9ms | 0.0% | 1.8ms | `VariableDeclarator` | `/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:45` |
| 0.1% | 30.4ms | 0.1% | 30.4ms | `create` | `[native code]` |
| 0.1% | 28.5ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3162` |
| 0.1% | 28.3ms | 0.0% | 11.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7287` |
| 0.1% | 28.0ms | 0.0% | 0us | `VariableDeclarator` | `/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:47` |
| 0.1% | 26.5ms | 0.0% | 1.3ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:905` |
| 0.0% | 25.1ms | 0.0% | 25.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6785` |
| 0.0% | 24.8ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4165` |
| 0.0% | 24.8ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1713` |
| 0.0% | 23.1ms | 0.0% | 21.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4110` |
| 0.0% | 22.0ms | 0.0% | 2.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7291` |
| 0.0% | 21.9ms | 0.0% | 21.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7081` |
| 0.0% | 20.9ms | 0.0% | 0us | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2949` |
| 0.0% | 20.5ms | 0.0% | 5.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7289` |
| 0.0% | 18.6ms | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 0.0% | 17.2ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2065` |
| 0.0% | 17.2ms | 0.0% | 17.2ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:855` |
| 0.0% | 17.2ms | 0.0% | 0us | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:839` |
| 0.0% | 16.6ms | 0.0% | 2.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7286` |
| 0.0% | 16.5ms | 0.0% | 1.4ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:802` |
| 0.0% | 16.3ms | 0.0% | 4.7ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2872` |
| 0.0% | 15.7ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2876` |
| 0.0% | 15.7ms | 0.0% | 15.7ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4058` |
| 0.0% | 15.6ms | 0.0% | 0us | `parseModule` | `[native code]` |
| 0.0% | 15.4ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7594` |
| 0.0% | 15.0ms | 0.0% | 15.0ms | `decode` | `[native code]` |
| 0.0% | 15.0ms | 0.0% | 0us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` |
| 0.0% | 12.8ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7078` |
| 0.0% | 12.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:25` |
| 0.0% | 12.3ms | 0.0% | 0us | `scope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:764` |
| 0.0% | 12.3ms | 0.0% | 0us | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2929` |
| 0.0% | 12.3ms | 0.0% | 0us | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2847` |
| 0.0% | 11.2ms | 0.0% | 1.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3147` |
| 0.0% | 10.8ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7221` |
| 0.0% | 10.4ms | 0.0% | 10.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6803` |
| 0.0% | 9.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` |
| 0.0% | 9.5ms | 0.0% | 9.5ms | `subarray` | `[native code]` |
| 0.0% | 9.3ms | 0.0% | 1.4ms | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6361` |
| 0.0% | 9.0ms | 0.0% | 9.0ms | `encodeInto` | `[native code]` |
| 0.0% | 9.0ms | 0.0% | 0us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` |
| 0.0% | 9.0ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:220` |
| 0.0% | 8.8ms | 0.0% | 8.8ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 8.4ms | 0.0% | 8.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7300` |
| 0.0% | 7.7ms | 0.0% | 7.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2175` |
| 0.0% | 7.1ms | 0.0% | 7.1ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3187` |
| 0.0% | 6.7ms | 0.0% | 3.3ms | `readdirSync` | `[native code]` |
| 0.0% | 6.6ms | 0.0% | 6.6ms | `Set` | `[native code]` |
| 0.0% | 6.2ms | 0.0% | 6.2ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6523` |
| 0.0% | 6.1ms | 0.0% | 6.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2161` |
| 0.0% | 6.1ms | 0.0% | 0us | `VariableDeclarator` | `/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:48` |
| 0.0% | 5.9ms | 0.0% | 1.4ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3201` |
| 0.0% | 5.9ms | 0.0% | 5.9ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3207` |
| 0.0% | 5.9ms | 0.0% | 5.9ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3200` |
| 0.0% | 5.7ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7282` |
| 0.0% | 5.5ms | 0.0% | 5.5ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 5.4ms | 0.0% | 0us | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2949` |
| 0.0% | 5.3ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` |
| 0.0% | 5.2ms | 0.0% | 5.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4111` |
| 0.0% | 5.1ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:435` |
| 0.0% | 5.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:477` |
| 0.0% | 5.1ms | 0.0% | 5.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2171` |
| 0.0% | 5.0ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3177` |
| 0.0% | 4.9ms | 0.0% | 4.9ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2068` |
| 0.0% | 4.9ms | 0.0% | 4.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7184` |
| 0.0% | 4.8ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1516` |
| 0.0% | 4.7ms | 0.0% | 4.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7357` |
| 0.0% | 4.7ms | 0.0% | 4.7ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 4.6ms | 0.0% | 4.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1317` |
| 0.0% | 4.5ms | 0.0% | 1.7ms | `VariableDeclarator` | `/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:50` |
| 0.0% | 4.5ms | 0.0% | 4.5ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 4.5ms | 0.0% | 4.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4116` |
| 0.0% | 4.4ms | 0.0% | 4.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7255` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4132` |
| 0.0% | 4.1ms | 0.0% | 1.6ms | `next` | `[native code]` |
| 0.0% | 3.7ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:478` |
| 0.0% | 3.7ms | 0.0% | 3.7ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4393` |
| 0.0% | 3.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.0% | 3.3ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:47` |
| 0.0% | 3.3ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:135` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2901` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2879` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3667` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4051` |
| 0.0% | 3.1ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7281` |
| 0.0% | 3.1ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2221` |
| 0.0% | 3.1ms | 0.0% | 0us | `_getOrBuildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5612` |
| 0.0% | 3.1ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6682` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7167` |
| 0.0% | 3.0ms | 0.0% | 0us | `esquery` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:53` |
| 0.0% | 3.0ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4398` |
| 0.0% | 3.0ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7601` |
| 0.0% | 3.0ms | 0.0% | 1.2ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2244` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2067` |
| 0.0% | 3.0ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3157` |
| 0.0% | 3.0ms | 0.0% | 0us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2782` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3190` |
| 0.0% | 2.9ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7294` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` |
| 0.0% | 2.8ms | 0.0% | 0us | `get declare` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2861` |
| 0.0% | 2.8ms | 0.0% | 0us | `(anonymous)` | `[native code]` |
| 0.0% | 2.8ms | 0.0% | 1.4ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3181` |
| 0.0% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7007` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7292` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `isWrite` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 2.8ms | 0.0% | 0us | `VariableDeclarator` | `/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:61` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7230` |
| 0.0% | 2.6ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7385` |
| 0.0% | 2.5ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3179` |
| 0.0% | 2.5ms | 0.0% | 1.5ms | `from` | `[native code]` |
| 0.0% | 2.4ms | 0.0% | 1.4ms | `arrayIteratorNextHelper` | `[native code]` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1710` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:100` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `binop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:192` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2069` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6525` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3373` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2125` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7029` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3206` |
| 0.0% | 1.7ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1511` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_Variable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:847` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` |
| 0.0% | 1.6ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6815` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2948` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:12` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2222` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:570` |
| 0.0% | 1.6ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7278` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5904` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:614` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:466` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2066` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6980` |
| 0.0% | 1.5ms | 0.0% | 0us | `async lintSource` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:350` |
| 0.0% | 1.5ms | 0.0% | 0us | `async _resolveConfig` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:67` |
| 0.0% | 1.5ms | 0.0% | 0us | `async lintSource` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:349` |
| 0.0% | 1.5ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:75` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:43` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js` |
| 0.0% | 1.5ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:34` |
| 0.0% | 1.5ms | 0.0% | 0us | `async _resolveConfig` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:70` |
| 0.0% | 1.5ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:31` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3646` |
| 0.0% | 1.5ms | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4715` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_isChainMiddleTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.0% | 0us | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3922` |
| 0.0% | 1.5ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4162` |
| 0.0% | 1.5ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6458` |
| 0.0% | 1.5ms | 0.0% | 0us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5490` |
| 0.0% | 1.5ms | 0.0% | 0us | `_tryLoad` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:34` |
| 0.0% | 1.5ms | 0.0% | 0us | `_getFfiSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:110` |
| 0.0% | 1.5ms | 0.0% | 0us | `isAvailable` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:399` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:11` |
| 0.0% | 1.5ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.0% | 1.5ms | 0.0% | 0us | `node:events` | `node:events:9` |
| 0.0% | 1.5ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1733` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3035` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5866` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7179` |
| 0.0% | 1.4ms | 0.0% | 0us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6360` |
| 0.0% | 1.4ms | 0.0% | 0us | `requestSatisfyUtil` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `requestInstantiate` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `fetch` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `requestFetch` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getOwnPropertyDescriptor` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7171` |
| 0.0% | 1.4ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1417` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_rawTokenText` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:831` |
| 0.0% | 1.4ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2135` |
| 0.0% | 1.4ms | 0.0% | 0us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4044` |
| 0.0% | 1.4ms | 0.0% | 0us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1078` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_getSharedCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:726` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2131` |
| 0.0% | 1.4ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:267` |
| 0.0% | 1.4ms | 0.0% | 0us | `getTagNames` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:191` |
| 0.0% | 1.4ms | 0.0% | 0us | `loadBinding` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `dlopen` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1223` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_isOptionalTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3884` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2191` |
| 0.0% | 1.3ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2184` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1779` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1413` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7279` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_Variable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3225` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2934` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` |
| 0.0% | 1.0ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7597` |
| 0.0% | 1.0ms | 0.0% | 1.0ms | `typedArrayViewLength` | `[native code]` |

## Function Details

### `push`
`[native code]` | Self: 67.4% (17.07s) | Total: 67.4% (17.07s) | Samples: 10931

**Called by:**
- `_computeDeclaredVariables` (3785)
- `_computeDeclaredVariables` (3638)
- `_computeDeclaredVariables` (3507)
- `_invokeFused` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3211` | Self: 12.7% (3.21s) | Total: 36.0% (9.11s) | Samples: 2089

**Called by:**
- `getDeclaredVariables` (5875)

**Calls:**
- `push` (3785)
- `get references` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3209` | Self: 6.6% (1.67s) | Total: 28.2% (7.15s) | Samples: 1091

**Called by:**
- `getDeclaredVariables` (4598)

**Calls:**
- `push` (3507)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3210` | Self: 6.0% (1.53s) | Total: 28.5% (7.22s) | Samples: 996

**Called by:**
- `getDeclaredVariables` (4634)

**Calls:**
- `push` (3638)

### `parse`
`[native code]` | Self: 3.0% (765.8ms) | Total: 3.0% (765.8ms) | Samples: 500

**Called by:**
- `parseSource` (500)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7254` | Self: 0.4% (120.1ms) | Total: 0.4% (122.8ms) | Samples: 77

**Called by:**
- `runPlugins` (79)

**Calls:**
- `_resolveHandlers` (1)
- `_resolveHandlers` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7119` | Self: 0.3% (87.7ms) | Total: 94.4% (23.88s) | Samples: 58

**Called by:**
- `runPlugins` (15357)

**Calls:**
- `_invokeFused` (15289)
- `nodeView` (7)
- `_nodeViewRaw` (2)
- `_invokeFused` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7091` | Self: 0.2% (72.9ms) | Total: 0.3% (80.2ms) | Samples: 49

**Called by:**
- `runPlugins` (54)

**Calls:**
- `_resolveHandlers` (3)
- `_resolveHandlers` (1)
- `_resolveHandlers` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6799` | Self: 0.2% (60.6ms) | Total: 0.2% (60.6ms) | Samples: 40

**Called by:**
- `runPlugins` (40)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7356` | Self: 0.2% (54.1ms) | Total: 0.2% (54.1ms) | Samples: 36

**Called by:**
- `runPlugins` (36)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7079` | Self: 0.1% (40.3ms) | Total: 0.1% (40.3ms) | Samples: 28

**Called by:**
- `runPlugins` (28)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` | Self: 0.1% (39.0ms) | Total: 0.4% (101.7ms) | Samples: 26

**Called by:**
- `nodeView` (52)
- `nodeViewChain` (9)
- `walkNodes` (2)
- `_nodesFromRange` (2)
- `_buildReference` (1)
- `VariableDeclarator` (1)

**Calls:**
- `_NodeView` (22)
- `_NodeView_LR` (11)
- `_NodeView` (6)
- `_NodeView_LRN` (2)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` | Self: 0.1% (34.9ms) | Total: 0.1% (34.9ms) | Samples: 22

**Called by:**
- `_nodeViewRaw` (22)

### `defineProperty`
`[native code]` | Self: 0.1% (33.7ms) | Total: 0.1% (33.7ms) | Samples: 21

**Called by:**
- `walkNodes` (13)
- `walkNodes` (8)

### `create`
`[native code]` | Self: 0.1% (30.4ms) | Total: 0.1% (30.4ms) | Samples: 20

**Called by:**
- `walkNodes` (11)
- `walkNodes` (9)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6785` | Self: 0.0% (25.1ms) | Total: 0.0% (25.1ms) | Samples: 17

**Called by:**
- `runPlugins` (17)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7081` | Self: 0.0% (21.9ms) | Total: 0.0% (21.9ms) | Samples: 15

**Called by:**
- `runPlugins` (15)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4110` | Self: 0.0% (21.6ms) | Total: 0.0% (23.1ms) | Samples: 14

**Called by:**
- `nodeViewChain` (8)
- `nodeView` (7)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:855` | Self: 0.0% (17.2ms) | Total: 0.0% (17.2ms) | Samples: 11

**Called by:**
- `_symName` (11)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4058` | Self: 0.0% (15.7ms) | Total: 0.0% (15.7ms) | Samples: 11

**Called by:**
- `_nodeViewRaw` (11)

### `anonymous`
`[native code]` | Self: 0.0% (15.3ms) | Total: 0.1% (49.4ms) | Samples: 10

**Called by:**
- `require` (28)
- `bound require` (1)
- `node:fs` (1)
- `node:events` (1)

**Calls:**
- `(anonymous)` (6)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:fs` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:events` (1)

### `decode`
`[native code]` | Self: 0.0% (15.0ms) | Total: 0.0% (15.0ms) | Samples: 10

**Called by:**
- `get source` (10)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7287` | Self: 0.0% (11.8ms) | Total: 0.1% (28.3ms) | Samples: 8

**Called by:**
- `runPlugins` (19)

**Calls:**
- `create` (11)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6803` | Self: 0.0% (10.4ms) | Total: 0.0% (10.4ms) | Samples: 7

**Called by:**
- `runPlugins` (7)

### `subarray`
`[native code]` | Self: 0.0% (9.5ms) | Total: 0.0% (9.5ms) | Samples: 6

**Called by:**
- `_computeDeclaredVariables` (6)

### `encodeInto`
`[native code]` | Self: 0.0% (9.0ms) | Total: 0.0% (9.0ms) | Samples: 6

**Called by:**
- `_encodeSource` (6)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (8.8ms) | Total: 0.0% (8.8ms) | Samples: 6

**Called by:**
- `_nodeViewRaw` (6)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7300` | Self: 0.0% (8.4ms) | Total: 0.0% (8.4ms) | Samples: 5

**Called by:**
- `runPlugins` (5)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2240` | Self: 0.0% (8.1ms) | Total: 0.1% (37.5ms) | Samples: 4

**Called by:**
- `_buildScope` (23)

**Calls:**
- `get body` (16)
- `get body` (1)
- `get body` (1)
- `get body` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2175` | Self: 0.0% (7.7ms) | Total: 0.0% (7.7ms) | Samples: 5

**Called by:**
- `_buildReference` (5)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3187` | Self: 0.0% (7.1ms) | Total: 0.0% (7.1ms) | Samples: 5

**Called by:**
- `getDeclaredVariables` (5)

### `Set`
`[native code]` | Self: 0.0% (6.6ms) | Total: 0.0% (6.6ms) | Samples: 4

**Called by:**
- `_computeDeclaredVariables` (3)
- `(anonymous)` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6523` | Self: 0.0% (6.2ms) | Total: 0.0% (6.2ms) | Samples: 4

**Called by:**
- `walkNodes` (4)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2161` | Self: 0.0% (6.1ms) | Total: 0.0% (6.1ms) | Samples: 4

**Called by:**
- `_buildScope` (2)
- `_buildReference` (2)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3200` | Self: 0.0% (5.9ms) | Total: 0.0% (5.9ms) | Samples: 4

**Called by:**
- `getDeclaredVariables` (4)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3207` | Self: 0.0% (5.9ms) | Total: 0.0% (5.9ms) | Samples: 4

**Called by:**
- `getDeclaredVariables` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7289` | Self: 0.0% (5.9ms) | Total: 0.0% (20.5ms) | Samples: 4

**Called by:**
- `runPlugins` (12)

**Calls:**
- `defineProperty` (8)

### `_resolveHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (5.5ms) | Total: 0.0% (5.5ms) | Samples: 4

**Called by:**
- `walkNodes` (3)
- `walkNodes` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4111` | Self: 0.0% (5.2ms) | Total: 0.0% (5.2ms) | Samples: 3

**Called by:**
- `nodeView` (3)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2171` | Self: 0.0% (5.1ms) | Total: 0.0% (5.1ms) | Samples: 3

**Called by:**
- `_buildReference` (2)
- `_buildScope` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2068` | Self: 0.0% (4.9ms) | Total: 0.0% (4.9ms) | Samples: 3

**Called by:**
- `_computeDeclaredVariables` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7184` | Self: 0.0% (4.9ms) | Total: 0.0% (4.9ms) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7357` | Self: 0.0% (4.7ms) | Total: 0.0% (4.7ms) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2872` | Self: 0.0% (4.7ms) | Total: 0.0% (16.3ms) | Samples: 3

**Called by:**
- `get references` (11)

**Calls:**
- `nodeView` (7)
- `_nodeViewRaw` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (4.7ms) | Total: 0.0% (4.7ms) | Samples: 3

**Called by:**
- `walkNodes` (3)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1317` | Self: 0.0% (4.6ms) | Total: 0.0% (4.6ms) | Samples: 3

**Called by:**
- `VariableDeclarator` (2)
- `_computeIsStrict` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (4.5ms) | Total: 0.0% (4.5ms) | Samples: 3

**Called by:**
- `_computeDeclaredVariables` (3)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4116` | Self: 0.0% (4.5ms) | Total: 0.0% (4.5ms) | Samples: 3

**Called by:**
- `nodeView` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7255` | Self: 0.0% (4.4ms) | Total: 0.0% (4.4ms) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4132` | Self: 0.0% (4.3ms) | Total: 0.0% (4.3ms) | Samples: 2

**Called by:**
- `_buildScope` (1)
- `VariableDeclarator` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4393` | Self: 0.0% (3.7ms) | Total: 0.0% (3.7ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2141` | Self: 0.0% (3.5ms) | Total: 0.2% (50.7ms) | Samples: 2

**Called by:**
- `_buildScope` (23)
- `_buildReference` (7)
- `_computeVarScope` (1)

**Calls:**
- `_computeIsStrict` (23)
- `_computeIsStrict` (2)
- `_computeIsStrict` (2)
- `_computeIsStrict` (1)
- `_computeIsStrict` (1)

### `readdirSync`
`[native code]` | Self: 0.0% (3.3ms) | Total: 0.0% (6.7ms) | Samples: 2

**Called by:**
- `readdirSync` (2)
- `loadCoreRules` (2)

**Calls:**
- `readdirSync` (2)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2901` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `get references` (2)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2879` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `get references` (2)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3667` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `get value` (2)

### `_NodeView_LRN`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4051` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `_nodeViewRaw` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7167` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2067` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `_computeDeclaredVariables` (2)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3190` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `getDeclaredVariables` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7291` | Self: 0.0% (2.9ms) | Total: 0.0% (22.0ms) | Samples: 2

**Called by:**
- `runPlugins` (15)

**Calls:**
- `defineProperty` (13)

### `source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `get declare` (2)

### `_resolveHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7007` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `walkNodes` (1)
- `walkNodes` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7292` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `isWrite`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `VariableDeclarator` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7230` | Self: 0.0% (2.6ms) | Total: 0.0% (2.6ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7286` | Self: 0.0% (2.6ms) | Total: 0.0% (16.6ms) | Samples: 2

**Called by:**
- `runPlugins` (11)

**Calls:**
- `create` (9)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1710` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `VariableDeclarator`
`/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:45` | Self: 0.0% (1.8ms) | Total: 0.1% (32.9ms) | Samples: 1

**Called by:**
- `_invokeFused` (21)

**Calls:**
- `get parent` (17)
- `get parent` (2)
- `get parent` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:100` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

### `get id`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `VariableDeclarator` (1)

### `binop`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2069` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_computeDeclaredVariables` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6525` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `get directive`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3373` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7029` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3206` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `_Variable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:847` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_buildVariable` (1)

### `VariableDeclarator`
`/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:50` | Self: 0.0% (1.7ms) | Total: 0.0% (4.5ms) | Samples: 1

**Called by:**
- `_invokeFused` (3)

**Calls:**
- `get declare` (2)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3147` | Self: 0.0% (1.7ms) | Total: 0.0% (11.2ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (7)

**Calls:**
- `subarray` (6)

### `next`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (4.1ms) | Samples: 1

**Called by:**
- `walkNodes` (1)
- `from` (1)
- `_computeDeclaredVariables` (1)

**Calls:**
- `arrayIteratorNextHelper` (2)

### `nodeRhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `get init` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2222` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `nodeRhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:570` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5904` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_getOrBuildPlan` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:466` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `parseSource` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2066` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_computeDeclaredVariables` (1)

### `get`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `from`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (2.5ms) | Samples: 1

**Called by:**
- `_computeDeclaredVariables` (2)

**Calls:**
- `next` (1)

### `_resolveHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6980` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `async _resolveConfigImpl` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3646` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `get value` (1)

### `_isChainMiddleTag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_isChainNode` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3035` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `get references` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5866` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_getOrBuildPlan` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7179` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `fetch`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `requestFetch` (1)

### `getOwnPropertyDescriptor`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:802` | Self: 0.0% (1.4ms) | Total: 0.0% (16.5ms) | Samples: 1

**Called by:**
- `VariableDeclarator` (11)

**Calls:**
- `_computeVariableSynthRefs` (8)
- `_computeVariableSynthRefs` (1)
- `_computeVariableSynthRefs` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:808` | Self: 0.0% (1.4ms) | Total: 0.4% (106.4ms) | Samples: 1

**Called by:**
- `VariableDeclarator` (66)
- `_computeDeclaredVariables` (1)

**Calls:**
- `_buildReference` (41)
- `_buildReference` (11)
- `_buildReference` (10)
- `_buildReference` (2)
- `_buildReference` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7171` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6361` | Self: 0.0% (1.4ms) | Total: 0.0% (9.3ms) | Samples: 1

**Called by:**
- `walkNodes` (5)
- `walkNodes` (1)

**Calls:**
- `get value` (3)
- `get value` (1)
- `get value` (1)

### `_rawTokenText`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:831` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get value` (1)

### `_getSharedCaches`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:726` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `reset` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3181` | Self: 0.0% (1.4ms) | Total: 0.0% (2.8ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (2)

**Calls:**
- `next` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2131` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `arrayIteratorNextHelper`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (2.4ms) | Samples: 1

**Called by:**
- `next` (2)

**Calls:**
- `typedArrayViewLength` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3201` | Self: 0.0% (1.4ms) | Total: 0.0% (5.9ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (4)

**Calls:**
- `_buildVariable` (3)

### `dlopen`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_isOptionalTag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3884` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `get parent` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2191` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_computeVarScope` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1779` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:905` | Self: 0.0% (1.3ms) | Total: 0.1% (26.5ms) | Samples: 1

**Called by:**
- `get body` (16)
- `get value` (1)

**Calls:**
- `nodeView` (14)
- `_nodeViewRaw` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7221` | Self: 0.0% (1.3ms) | Total: 0.0% (10.8ms) | Samples: 1

**Called by:**
- `runPlugins` (7)

**Calls:**
- `invokeMethodFnHandlers` (5)
- `invokeMethodFnHandlers` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7385` | Self: 0.0% (1.3ms) | Total: 0.0% (2.6ms) | Samples: 1

**Called by:**
- `runPlugins` (2)

**Calls:**
- `invokeMethodFnHandlers` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1413` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `invokeMethodFnHandlers` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7294` | Self: 0.0% (1.3ms) | Total: 0.0% (2.9ms) | Samples: 1

**Called by:**
- `runPlugins` (2)

**Calls:**
- `get` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4713` | Self: 0.0% (1.3ms) | Total: 94.0% (23.77s) | Samples: 1

**Called by:**
- `walkNodes` (15289)

**Calls:**
- `VariableDeclarator` (15163)
- `VariableDeclarator` (77)
- `VariableDeclarator` (21)
- `VariableDeclarator` (19)
- `VariableDeclarator` (3)
- `VariableDeclarator` (3)
- `VariableDeclarator` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2120` | Self: 0.0% (1.2ms) | Total: 0.3% (81.9ms) | Samples: 1

**Called by:**
- `_buildScope` (22)
- `_buildReference` (22)
- `_computeVarScope` (6)

**Calls:**
- `_buildScope` (23)
- `_buildScope` (22)
- `_buildScope` (2)
- `_buildScope` (1)
- `_buildScope` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7279` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_Variable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_buildVariable` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2244` | Self: 0.0% (1.2ms) | Total: 0.0% (3.0ms) | Samples: 1

**Called by:**
- `_buildScope` (2)

**Calls:**
- `get directive` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3225` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2934` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `get references` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `VariableDeclarator` (1)

### `typedArrayViewLength`
`[native code]` | Self: 0.0% (1.0ms) | Total: 0.0% (1.0ms) | Samples: 1

**Called by:**
- `arrayIteratorNextHelper` (1)

### `requestFetch`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `fetch` (1)

### `_getFfiSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:110` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_getOrBuildSelectorPlan` (1)

**Calls:**
- `isAvailable` (1)

### `async lintSource`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:350` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `async lintSource` (1)

**Calls:**
- `async _resolveConfig` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:477` | Self: 0.0% (0us) | Total: 0.0% (5.1ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `patchAstUtils` (3)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7601` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (2)

**Calls:**
- `buildVisitorMap` (2)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:478` | Self: 0.0% (0us) | Total: 0.0% (3.7ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `CfgGraph` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6360` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `nodeView` (1)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:435` | Self: 0.0% (0us) | Total: 0.0% (5.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `bound require` (3)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:274` | Self: 0.0% (0us) | Total: 96.8% (24.49s) | Samples: 0

**Calls:**
- `runPlugins` (15745)
- `runPlugins` (10)
- `runPlugins` (2)
- `runPlugins` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1211` | Self: 0.0% (0us) | Total: 0.1% (44.0ms) | Samples: 0

**Called by:**
- `VariableDeclarator` (17)
- `_buildReference` (10)
- `_computeIsStrict` (1)

**Calls:**
- `nodeView` (28)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:47` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (2)

**Calls:**
- `readdirSync` (2)

### `VariableDeclarator`
`/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:61` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `_invokeFused` (2)

**Calls:**
- `isWrite` (2)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` | Self: 0.0% (0us) | Total: 3.0% (765.8ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (500)

**Calls:**
- `parse` (500)

### `_getOrBuildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5612` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `walkNodes` (2)

**Calls:**
- `_buildPlan` (1)
- `_buildPlan` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:25` | Self: 0.0% (0us) | Total: 0.0% (12.5ms) | Samples: 0

**Called by:**
- `parseModule` (8)

**Calls:**
- `bound require` (8)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2929` | Self: 0.0% (0us) | Total: 0.0% (12.3ms) | Samples: 0

**Called by:**
- `get references` (8)

**Calls:**
- `scope` (8)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4044` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `reset` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3162` | Self: 0.0% (0us) | Total: 0.1% (28.5ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (18)

**Calls:**
- `_ensureDeclSymIndex` (11)
- `_ensureDeclSymIndex` (3)
- `_ensureDeclSymIndex` (2)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (44.8ms) | Samples: 0

**Called by:**
- `bound require` (28)

**Calls:**
- `anonymous` (28)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (18.6ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)
- `requestInstantiate` (1)

**Calls:**
- `parseModule` (10)
- `async (anonymous)` (1)
- `requestFetch` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `get init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2949` | Self: 0.0% (0us) | Total: 0.0% (5.4ms) | Samples: 0

**Called by:**
- `VariableDeclarator` (4)

**Calls:**
- `nodeViewChain` (3)
- `nodeViewChain` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1078` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `reset` (1)

**Calls:**
- `_getSharedCaches` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2125` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_buildReference` (1)

**Calls:**
- `nodeView` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `VariableDeclarator`
`/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:55` | Self: 0.0% (0us) | Total: 93.2% (23.58s) | Samples: 0

**Called by:**
- `_invokeFused` (15163)

**Calls:**
- `getDeclaredVariables` (15162)
- `getDeclaredVariables` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6815` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `next` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2135` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_buildScope` (1)

**Calls:**
- `get value` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:192` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `binop` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7602` | Self: 0.0% (0us) | Total: 96.7% (24.47s) | Samples: 0

**Called by:**
- `_lintSourceOne` (15745)

**Calls:**
- `walkNodes` (15357)
- `walkNodes` (79)
- `walkNodes` (54)
- `walkNodes` (40)
- `walkNodes` (36)
- `walkNodes` (28)
- `walkNodes` (19)
- `walkNodes` (17)
- `walkNodes` (15)
- `walkNodes` (15)
- `walkNodes` (12)
- `walkNodes` (11)
- `walkNodes` (8)
- `walkNodes` (7)
- `walkNodes` (7)
- `walkNodes` (5)
- `walkNodes` (4)
- `walkNodes` (3)
- `walkNodes` (3)
- `walkNodes` (3)
- `walkNodes` (2)
- `walkNodes` (2)
- `walkNodes` (2)
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

### `loadBinding`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `getTagNames` (1)

**Calls:**
- `bound require` (1)

### `_computeVarScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2847` | Self: 0.0% (0us) | Total: 0.0% (12.3ms) | Samples: 0

**Called by:**
- `scope` (8)

**Calls:**
- `_buildScope` (6)
- `_buildScope` (1)
- `_buildScope` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:267` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Calls:**
- `getTagNames` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2782` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `_computeDeclaredVariables` (2)

**Calls:**
- `_Variable` (1)
- `_Variable` (1)

### `VariableDeclarator`
`/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:47` | Self: 0.0% (0us) | Total: 0.1% (28.0ms) | Samples: 0

**Called by:**
- `_invokeFused` (19)

**Calls:**
- `init` (14)
- `get init` (4)
- `get init` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4715` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `push` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:75` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `async _resolveConfig` (1)

**Calls:**
- `async _resolveConfigImpl` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2883` | Self: 0.0% (0us) | Total: 0.2% (66.2ms) | Samples: 0

**Called by:**
- `get references` (41)

**Calls:**
- `_buildScope` (22)
- `_buildScope` (7)
- `_buildScope` (5)
- `_buildScope` (2)
- `_buildScope` (2)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7594` | Self: 0.0% (0us) | Total: 0.0% (15.4ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (10)

**Calls:**
- `get source` (9)
- `reset` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `async (anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:220` | Self: 0.0% (0us) | Total: 0.0% (9.0ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (6)

**Calls:**
- `_encodeSource` (6)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4398` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `esquery` (2)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2876` | Self: 0.0% (0us) | Total: 0.0% (15.7ms) | Samples: 0

**Called by:**
- `get references` (10)

**Calls:**
- `get parent` (10)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3157` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (2)

**Calls:**
- `_buildVariable` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `bound require` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4137` | Self: 0.0% (0us) | Total: 0.3% (100.9ms) | Samples: 0

**Called by:**
- `get parent` (28)
- `_nodesFromRange` (14)
- `walkNodes` (7)
- `_buildReference` (7)
- `walkNodes` (4)
- `walkNodes` (2)
- `_buildScope` (1)
- `get body` (1)
- `invokeMethodFnHandlers` (1)

**Calls:**
- `_nodeViewRaw` (52)
- `_nodeViewRaw` (7)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1223` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `VariableDeclarator` (1)

**Calls:**
- `_isOptionalTag` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7278` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `nodeRhs` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4165` | Self: 0.0% (0us) | Total: 0.0% (24.8ms) | Samples: 0

**Called by:**
- `init` (14)
- `get init` (3)

**Calls:**
- `_nodeViewRaw` (9)
- `_nodeViewRaw` (8)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1733` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `nodeView` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.0% (3.5ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `_isChainNode`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3922` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `nodeViewChain` (1)

**Calls:**
- `_isChainMiddleTag` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` | Self: 0.0% (0us) | Total: 0.0% (5.3ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (2)

**Calls:**
- `AstView` (1)
- `AstView` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` | Self: 0.0% (0us) | Total: 3.0% (780.2ms) | Samples: 0

**Calls:**
- `parseSource` (500)
- `parseSource` (6)
- `parseSource` (2)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2221` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `_buildScope` (2)

**Calls:**
- `get parent` (1)
- `get parent` (1)

### `(anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `bound require` (1)

**Calls:**
- `requestSatisfyUtil` (1)
- `dlopen` (1)

### `getTagNames`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:191` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `loadBinding` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3135` | Self: 0.0% (0us) | Total: 93.2% (23.58s) | Samples: 0

**Called by:**
- `VariableDeclarator` (15162)

**Calls:**
- `_computeDeclaredVariables` (5875)
- `_computeDeclaredVariables` (4634)
- `_computeDeclaredVariables` (4598)
- `_computeDeclaredVariables` (18)
- `_computeDeclaredVariables` (7)
- `_computeDeclaredVariables` (5)
- `_computeDeclaredVariables` (4)
- `_computeDeclaredVariables` (4)
- `_computeDeclaredVariables` (4)
- `_computeDeclaredVariables` (3)
- `_computeDeclaredVariables` (2)
- `_computeDeclaredVariables` (2)
- `_computeDeclaredVariables` (2)
- `_computeDeclaredVariables` (2)
- `_computeDeclaredVariables` (1)
- `_computeDeclaredVariables` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:135` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Calls:**
- `loadCoreRules` (2)

### `async _resolveConfig`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:67` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `async lintSource` (1)

**Calls:**
- `async _resolveConfig` (1)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` | Self: 0.0% (0us) | Total: 0.0% (15.0ms) | Samples: 0

**Called by:**
- `runPlugins` (9)
- `runPlugins` (1)

**Calls:**
- `decode` (10)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5490` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_getFfiSelector` (1)

### `requestSatisfyUtil`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `requestInstantiate` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:614` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `Set` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1417` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_buildScope` (1)

**Calls:**
- `_rawTokenText` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4162` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `get init` (1)

**Calls:**
- `_isChainNode` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1516` | Self: 0.0% (0us) | Total: 0.0% (4.8ms) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (3)

**Calls:**
- `get loc` (2)
- `get loc` (1)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (47.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (8)
- `(anonymous)` (6)
- `patchAstUtils` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `esquery` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `loadBinding` (1)
- `(anonymous)` (1)
- `_tryLoad` (1)
- `(anonymous)` (1)

**Calls:**
- `require` (28)
- `(anonymous)` (1)
- `anonymous` (1)

### `async lintSource`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:349` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `async lintSource` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` | Self: 0.0% (0us) | Total: 0.0% (9.7ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `VariableDeclarator`
`/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:48` | Self: 0.0% (0us) | Total: 0.0% (6.1ms) | Samples: 0

**Called by:**
- `_invokeFused` (3)

**Calls:**
- `nodeView` (1)
- `get id` (1)
- `_nodeViewRaw` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1713` | Self: 0.0% (0us) | Total: 0.0% (24.8ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (16)

**Calls:**
- `_nodesFromRange` (16)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3177` | Self: 0.0% (0us) | Total: 0.0% (5.0ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (3)

**Calls:**
- `Set` (3)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:839` | Self: 0.0% (0us) | Total: 0.0% (17.2ms) | Samples: 0

**Called by:**
- `_ensureDeclSymIndex` (11)

**Calls:**
- `_buildSymNameCache` (11)

### `esquery`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:53` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (2)

**Calls:**
- `bound require` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7078` | Self: 0.0% (0us) | Total: 0.0% (12.8ms) | Samples: 0

**Called by:**
- `runPlugins` (8)

**Calls:**
- `getDFSEvents` (4)
- `getDFSEvents` (3)
- `getDFSEvents` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:43` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `async (anonymous)` (1)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` | Self: 0.0% (0us) | Total: 0.0% (9.0ms) | Samples: 0

**Called by:**
- `parseSource` (6)

**Calls:**
- `encodeInto` (6)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2949` | Self: 0.0% (0us) | Total: 0.0% (20.9ms) | Samples: 0

**Called by:**
- `VariableDeclarator` (14)

**Calls:**
- `nodeViewChain` (14)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2184` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_buildReference` (1)

**Calls:**
- `nodeView` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6682` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `_getOrBuildPlan` (2)

### `scope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:764` | Self: 0.0% (0us) | Total: 0.0% (12.3ms) | Samples: 0

**Called by:**
- `_computeVariableSynthRefs` (8)

**Calls:**
- `_computeVarScope` (8)

### `requestInstantiate`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `requestSatisfyUtil` (1)

**Calls:**
- `async (anonymous)` (1)

### `node:events`
`node:events:9` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `parseModule`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (15.6ms) | Samples: 0

**Called by:**
- `async (anonymous)` (10)

**Calls:**
- `(anonymous)` (8)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6458` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_getOrBuildSelectorPlan` (1)

### `isAvailable`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:399` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_getFfiSelector` (1)

**Calls:**
- `_tryLoad` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1511` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (1)

**Calls:**
- `_nodesFromRange` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_tryLoad`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:34` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `isAvailable` (1)

**Calls:**
- `bound require` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:34` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `async lintSource` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7597` | Self: 0.0% (0us) | Total: 0.0% (1.0ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `get source` (1)

### `async _resolveConfig`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:70` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `async _resolveConfig` (1)

**Calls:**
- `async _resolveConfigImpl` (1)

### `get init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2948` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `VariableDeclarator` (1)

**Calls:**
- `nodeRhs` (1)

### `VariableDeclarator`
`/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:60` | Self: 0.0% (0us) | Total: 0.4% (121.2ms) | Samples: 0

**Called by:**
- `_invokeFused` (77)

**Calls:**
- `get references` (66)
- `get references` (11)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7282` | Self: 0.0% (0us) | Total: 0.0% (5.7ms) | Samples: 0

**Called by:**
- `runPlugins` (4)

**Calls:**
- `nodeView` (4)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2065` | Self: 0.0% (0us) | Total: 0.0% (17.2ms) | Samples: 0

**Called by:**
- `_computeDeclaredVariables` (11)

**Calls:**
- `_symName` (11)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7281` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `nodeView` (2)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3179` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (2)

**Calls:**
- `from` (2)

### `get declare`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2861` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `VariableDeclarator` (2)

**Calls:**
- `source` (2)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 71.0% | 17.97s | `[native code]` |
| 28.1% | 7.12s | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.7% | 189.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 3.5ms | `/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js` |
| 0.0% | 3.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/api.js` |
| 0.0% | 1.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
