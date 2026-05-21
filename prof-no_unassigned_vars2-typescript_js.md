# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 18.60s | 12150 | 1.0ms | 245 |

**Top 10:** `push` 85.0%, `parse` 4.1%, `_computeDeclaredVariables` 1.9%, `_computeDeclaredVariables` 1.8%, `_computeDeclaredVariables` 1.7%, `walkNodes` 0.6%, `walkNodes` 0.5%, `walkNodes` 0.2%, `walkNodes` 0.2%, `walkNodes` 0.2%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 85.0% | 15.81s | 85.0% | 15.81s | `push` | `[native code]` |
| 4.1% | 769.4ms | 4.1% | 769.4ms | `parse` | `[native code]` |
| 1.9% | 361.9ms | 29.2% | 5.43s | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3214` |
| 1.8% | 345.8ms | 29.3% | 5.45s | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3215` |
| 1.7% | 333.7ms | 32.0% | 5.96s | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3216` |
| 0.6% | 128.3ms | 0.6% | 129.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7259` |
| 0.5% | 110.6ms | 92.4% | 17.19s | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7124` |
| 0.2% | 54.8ms | 0.2% | 54.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6804` |
| 0.2% | 51.9ms | 0.2% | 54.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7096` |
| 0.2% | 44.2ms | 0.2% | 44.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7361` |
| 0.2% | 41.2ms | 0.2% | 41.2ms | `defineProperty` | `[native code]` |
| 0.2% | 39.5ms | 0.2% | 39.5ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` |
| 0.1% | 33.1ms | 0.1% | 33.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7084` |
| 0.1% | 25.4ms | 0.1% | 25.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6790` |
| 0.1% | 25.2ms | 0.1% | 25.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7086` |
| 0.1% | 24.0ms | 0.4% | 81.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 0.1% | 19.6ms | 0.1% | 19.6ms | `create` | `[native code]` |
| 0.0% | 15.9ms | 0.3% | 58.8ms | `anonymous` | `[native code]` |
| 0.0% | 15.4ms | 0.1% | 24.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7292` |
| 0.0% | 14.2ms | 0.0% | 14.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6808` |
| 0.0% | 10.8ms | 0.0% | 10.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4110` |
| 0.0% | 10.7ms | 0.1% | 21.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7291` |
| 0.0% | 10.3ms | 0.0% | 10.3ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6528` |
| 0.0% | 10.3ms | 0.0% | 10.3ms | `subarray` | `[native code]` |
| 0.0% | 8.6ms | 0.0% | 8.6ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 8.4ms | 0.0% | 11.3ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:855` |
| 0.0% | 7.8ms | 0.0% | 7.8ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4058` |
| 0.0% | 7.8ms | 0.0% | 7.8ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1733` |
| 0.0% | 7.6ms | 0.0% | 11.1ms | `Set` | `[native code]` |
| 0.0% | 7.4ms | 0.0% | 7.4ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 7.4ms | 0.1% | 26.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7296` |
| 0.0% | 7.0ms | 0.1% | 30.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7294` |
| 0.0% | 6.4ms | 0.0% | 6.4ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3187` |
| 0.0% | 6.3ms | 0.0% | 6.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3190` |
| 0.0% | 6.2ms | 0.0% | 6.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7305` |
| 0.0% | 6.2ms | 0.0% | 12.4ms | `readdirSync` | `[native code]` |
| 0.0% | 6.1ms | 0.0% | 6.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7362` |
| 0.0% | 6.0ms | 0.0% | 6.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7235` |
| 0.0% | 5.9ms | 0.0% | 5.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4111` |
| 0.0% | 5.6ms | 0.0% | 5.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2161` |
| 0.0% | 5.1ms | 0.0% | 5.1ms | `encodeInto` | `[native code]` |
| 0.0% | 4.9ms | 0.0% | 4.9ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4393` |
| 0.0% | 4.8ms | 0.0% | 4.8ms | `decode` | `[native code]` |
| 0.0% | 4.7ms | 0.0% | 6.2ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3207` |
| 0.0% | 4.6ms | 0.1% | 23.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7226` |
| 0.0% | 4.0ms | 0.2% | 42.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2141` |
| 0.0% | 4.0ms | 0.1% | 37.0ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2240` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2135` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2068` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7260` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `has` | `[native code]` |
| 0.0% | 3.2ms | 0.4% | 75.9ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:808` |
| 0.0% | 3.1ms | 0.1% | 27.7ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:905` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `arrayIteratorNextHelper` | `[native code]` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `fill` | `[native code]` |
| 0.0% | 2.9ms | 0.3% | 72.8ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2120` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `slice` | `[native code]` |
| 0.0% | 2.8ms | 0.1% | 21.6ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2847` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6530` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2751` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_getSharedCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:726` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `split` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 3.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7390` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `values` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 13.1ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:839` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2175` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7188` |
| 0.0% | 1.7ms | 0.0% | 3.2ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1710` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2171` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4037` |
| 0.0% | 1.6ms | 0.0% | 4.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3179` |
| 0.0% | 1.6ms | 0.5% | 101.9ms | `VariableDeclarator` | `/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:60` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `fetch` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2222` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3218` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `dlopen` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `endsWith` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `internal:primordials` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7189` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4156` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7080` |
| 0.0% | 1.5ms | 0.2% | 42.8ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2883` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4132` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 2.9ms | `from` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_getSharedCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:725` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `Object` | `[native code]` |
| 0.0% | 1.5ms | 0.1% | 20.1ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2949` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1538` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:570` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7282` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6360` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6589` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6369` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2066` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6371` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `existsSync` | `[native code]` |
| 0.0% | 1.3ms | 91.0% | 16.92s | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3135` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get declare` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2042` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:902` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3189` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7234` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4720` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4115` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_Variable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:847` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2058` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7290` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get declare` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2863` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1736` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_rawTokenText` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:831` |
| 0.0% | 1.3ms | 0.1% | 24.2ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:802` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `FFIBuilder` | `bun:ffi` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2069` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7297` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6985` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2067` |
| 0.0% | 1.2ms | 0.0% | 2.4ms | `readFileSync` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3136` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4051` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5746` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 95.6% | 17.79s | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:274` |
| 95.5% | 17.77s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7607` |
| 92.4% | 17.19s | 0.5% | 110.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7124` |
| 91.7% | 17.07s | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4718` |
| 91.0% | 16.92s | 0.0% | 0us | `VariableDeclarator` | `/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:55` |
| 91.0% | 16.92s | 0.0% | 1.3ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3135` |
| 85.0% | 15.81s | 85.0% | 15.81s | `push` | `[native code]` |
| 32.0% | 5.96s | 1.7% | 333.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3216` |
| 29.3% | 5.45s | 1.8% | 345.8ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3215` |
| 29.2% | 5.43s | 1.9% | 361.9ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3214` |
| 4.1% | 779.6ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` |
| 4.1% | 769.4ms | 4.1% | 769.4ms | `parse` | `[native code]` |
| 4.1% | 769.4ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` |
| 0.6% | 129.7ms | 0.6% | 128.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7259` |
| 0.5% | 101.9ms | 0.0% | 1.6ms | `VariableDeclarator` | `/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:60` |
| 0.4% | 81.9ms | 0.1% | 24.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 0.4% | 78.0ms | 0.0% | 0us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4137` |
| 0.4% | 75.9ms | 0.0% | 3.2ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:808` |
| 0.3% | 72.8ms | 0.0% | 2.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2120` |
| 0.3% | 58.8ms | 0.0% | 15.9ms | `anonymous` | `[native code]` |
| 0.2% | 54.8ms | 0.2% | 54.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6804` |
| 0.2% | 54.6ms | 0.2% | 51.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7096` |
| 0.2% | 54.0ms | 0.0% | 0us | `bound require` | `[native code]` |
| 0.2% | 50.7ms | 0.0% | 0us | `require` | `[native code]` |
| 0.2% | 44.2ms | 0.2% | 44.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7361` |
| 0.2% | 42.8ms | 0.0% | 1.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2883` |
| 0.2% | 42.7ms | 0.0% | 4.0ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2141` |
| 0.2% | 41.2ms | 0.2% | 41.2ms | `defineProperty` | `[native code]` |
| 0.2% | 40.6ms | 0.0% | 0us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1211` |
| 0.2% | 39.5ms | 0.2% | 39.5ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` |
| 0.1% | 37.0ms | 0.0% | 4.0ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2240` |
| 0.1% | 33.1ms | 0.1% | 33.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7084` |
| 0.1% | 30.6ms | 0.0% | 7.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7294` |
| 0.1% | 27.7ms | 0.0% | 3.1ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:905` |
| 0.1% | 26.6ms | 0.0% | 7.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7296` |
| 0.1% | 25.4ms | 0.1% | 25.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6790` |
| 0.1% | 25.2ms | 0.1% | 25.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7086` |
| 0.1% | 24.5ms | 0.0% | 15.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7292` |
| 0.1% | 24.2ms | 0.0% | 1.3ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:802` |
| 0.1% | 23.8ms | 0.0% | 4.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7226` |
| 0.1% | 23.0ms | 0.0% | 0us | `VariableDeclarator` | `/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:47` |
| 0.1% | 22.4ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2876` |
| 0.1% | 21.7ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7083` |
| 0.1% | 21.6ms | 0.0% | 0us | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2929` |
| 0.1% | 21.6ms | 0.0% | 2.8ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2847` |
| 0.1% | 21.3ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3162` |
| 0.1% | 21.3ms | 0.0% | 10.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7291` |
| 0.1% | 20.1ms | 0.0% | 1.5ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2949` |
| 0.1% | 19.7ms | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 0.1% | 19.6ms | 0.1% | 19.6ms | `create` | `[native code]` |
| 0.1% | 18.7ms | 0.0% | 0us | `scope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:764` |
| 0.0% | 17.1ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1713` |
| 0.0% | 17.0ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4165` |
| 0.0% | 16.8ms | 0.0% | 0us | `VariableDeclarator` | `/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:45` |
| 0.0% | 16.3ms | 0.0% | 0us | `parseModule` | `[native code]` |
| 0.0% | 14.8ms | 0.0% | 0us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6366` |
| 0.0% | 14.2ms | 0.0% | 14.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6808` |
| 0.0% | 13.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:25` |
| 0.0% | 13.1ms | 0.0% | 1.7ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:839` |
| 0.0% | 12.4ms | 0.0% | 6.2ms | `readdirSync` | `[native code]` |
| 0.0% | 11.9ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1511` |
| 0.0% | 11.3ms | 0.0% | 8.4ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:855` |
| 0.0% | 11.3ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2065` |
| 0.0% | 11.1ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3177` |
| 0.0% | 11.1ms | 0.0% | 7.6ms | `Set` | `[native code]` |
| 0.0% | 10.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` |
| 0.0% | 10.8ms | 0.0% | 10.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4110` |
| 0.0% | 10.3ms | 0.0% | 10.3ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6528` |
| 0.0% | 10.3ms | 0.0% | 10.3ms | `subarray` | `[native code]` |
| 0.0% | 10.3ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3147` |
| 0.0% | 9.4ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:135` |
| 0.0% | 8.6ms | 0.0% | 8.6ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 8.3ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7599` |
| 0.0% | 7.8ms | 0.0% | 7.8ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4058` |
| 0.0% | 7.8ms | 0.0% | 7.8ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1733` |
| 0.0% | 7.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:477` |
| 0.0% | 7.5ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:435` |
| 0.0% | 7.4ms | 0.0% | 7.4ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 6.4ms | 0.0% | 6.4ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3187` |
| 0.0% | 6.3ms | 0.0% | 6.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3190` |
| 0.0% | 6.2ms | 0.0% | 4.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3207` |
| 0.0% | 6.2ms | 0.0% | 6.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7305` |
| 0.0% | 6.2ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7287` |
| 0.0% | 6.2ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:47` |
| 0.0% | 6.1ms | 0.0% | 6.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7362` |
| 0.0% | 6.0ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2872` |
| 0.0% | 6.0ms | 0.0% | 6.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7235` |
| 0.0% | 5.9ms | 0.0% | 5.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4111` |
| 0.0% | 5.6ms | 0.0% | 5.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2161` |
| 0.0% | 5.1ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:220` |
| 0.0% | 5.1ms | 0.0% | 5.1ms | `encodeInto` | `[native code]` |
| 0.0% | 5.1ms | 0.0% | 0us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` |
| 0.0% | 4.9ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:478` |
| 0.0% | 4.9ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` |
| 0.0% | 4.9ms | 0.0% | 4.9ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4393` |
| 0.0% | 4.8ms | 0.0% | 0us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` |
| 0.0% | 4.8ms | 0.0% | 4.8ms | `decode` | `[native code]` |
| 0.0% | 4.6ms | 0.0% | 1.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3179` |
| 0.0% | 4.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.0% | 4.4ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6463` |
| 0.0% | 4.3ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7606` |
| 0.0% | 3.5ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3157` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2135` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2068` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `[native code]` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7260` |
| 0.0% | 3.2ms | 0.0% | 1.7ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1710` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `has` | `[native code]` |
| 0.0% | 3.2ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:50` |
| 0.0% | 3.1ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7390` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `arrayIteratorNextHelper` | `[native code]` |
| 0.0% | 3.0ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7587` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `fill` | `[native code]` |
| 0.0% | 2.9ms | 0.0% | 1.5ms | `from` | `[native code]` |
| 0.0% | 2.8ms | 0.0% | 0us | `get scope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:764` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `slice` | `[native code]` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 2.8ms | 0.0% | 0us | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2949` |
| 0.0% | 2.7ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4403` |
| 0.0% | 2.7ms | 0.0% | 0us | `esquery` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:53` |
| 0.0% | 2.7ms | 0.0% | 0us | `VariableDeclarator` | `/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:50` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6530` |
| 0.0% | 2.6ms | 0.0% | 0us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5495` |
| 0.0% | 2.5ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7286` |
| 0.0% | 2.4ms | 0.0% | 1.2ms | `readFileSync` | `[native code]` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2751` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_getSharedCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:726` |
| 0.0% | 1.8ms | 0.0% | 0us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4049` |
| 0.0% | 1.8ms | 0.0% | 0us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1078` |
| 0.0% | 1.7ms | 0.0% | 0us | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5757` |
| 0.0% | 1.7ms | 0.0% | 0us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5424` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `split` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `values` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2755` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2175` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7188` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2171` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4037` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `fetch` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `requestInstantiate` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `requestFetch` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `requestSatisfyUtil` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4162` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2222` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3218` |
| 0.0% | 1.6ms | 0.0% | 0us | `getTagNames` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:191` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `dlopen` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:267` |
| 0.0% | 1.6ms | 0.0% | 0us | `loadBinding` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` |
| 0.0% | 1.6ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4398` |
| 0.0% | 1.6ms | 0.0% | 0us | `_isSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4172` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `endsWith` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `bound call` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `internal:primordials` |
| 0.0% | 1.6ms | 0.0% | 0us | `forEach` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `makeSafe` | `internal:primordials:30` |
| 0.0% | 1.6ms | 0.0% | 0us | `internal:shared` | `internal:shared:2` |
| 0.0% | 1.6ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.0% | 1.6ms | 0.0% | 0us | `node:events` | `node:events:9` |
| 0.0% | 1.6ms | 0.0% | 0us | `internal:validators` | `internal:validators:2` |
| 0.0% | 1.6ms | 0.0% | 0us | `internal:primordials` | `internal:primordials:71` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:11` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7189` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4156` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7080` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4132` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 0us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6365` |
| 0.0% | 1.5ms | 0.0% | 0us | `SourceCode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1048` |
| 0.0% | 1.5ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7602` |
| 0.0% | 1.5ms | 0.0% | 0us | `RuleContext` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4009` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_getSharedCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:725` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `Object` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1538` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:570` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7282` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6360` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn-jsx/index.js:3` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6589` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6369` |
| 0.0% | 1.4ms | 0.0% | 0us | `next` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2066` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6371` |
| 0.0% | 1.3ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:81` |
| 0.0% | 1.3ms | 0.0% | 0us | `async _loadFlatConfig` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:42` |
| 0.0% | 1.3ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:75` |
| 0.0% | 1.3ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:38` |
| 0.0% | 1.3ms | 0.0% | 0us | `async lintSource` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:350` |
| 0.0% | 1.3ms | 0.0% | 0us | `async _loadFlatConfig` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:36` |
| 0.0% | 1.3ms | 0.0% | 0us | `existsSync` | `node:fs:273` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `existsSync` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `async _resolveConfig` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:70` |
| 0.0% | 1.3ms | 0.0% | 0us | `async lintSource` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:349` |
| 0.0% | 1.3ms | 0.0% | 0us | `async _resolveConfig` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:67` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get declare` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2042` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:902` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3189` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7234` |
| 0.0% | 1.3ms | 0.0% | 0us | `_getFfiSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:109` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4720` |
| 0.0% | 1.3ms | 0.0% | 0us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2782` |
| 0.0% | 1.3ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2901` |
| 0.0% | 1.3ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3201` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4115` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_Variable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:847` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:12` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2058` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7290` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get declare` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2863` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1736` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_rawTokenText` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:831` |
| 0.0% | 1.3ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1417` |
| 0.0% | 1.2ms | 0.0% | 0us | `dlopen` | `bun:ffi:351` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `FFIBuilder` | `bun:ffi` |
| 0.0% | 1.2ms | 0.0% | 0us | `_tryLoad` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:51` |
| 0.0% | 1.2ms | 0.0% | 0us | `isAvailable` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:399` |
| 0.0% | 1.2ms | 0.0% | 0us | `_getFfiSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:110` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2069` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7297` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6985` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2067` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:28` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3136` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4051` |
| 0.0% | 1.2ms | 0.0% | 0us | `_getOrBuildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5617` |
| 0.0% | 1.2ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6687` |
| 0.0% | 1.2ms | 0.0% | 0us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5815` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5746` |

## Function Details

### `push`
`[native code]` | Self: 85.0% (15.81s) | Total: 85.0% (15.81s) | Samples: 10320

**Called by:**
- `_computeDeclaredVariables` (3663)
- `_computeDeclaredVariables` (3333)
- `_computeDeclaredVariables` (3323)
- `_computeDeclaredVariables` (1)

### `parse`
`[native code]` | Self: 4.1% (769.4ms) | Total: 4.1% (769.4ms) | Samples: 508

**Called by:**
- `parseSource` (508)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3214` | Self: 1.9% (361.9ms) | Total: 29.2% (5.43s) | Samples: 238

**Called by:**
- `getDeclaredVariables` (3562)

**Calls:**
- `push` (3323)
- `get identifiers` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3215` | Self: 1.8% (345.8ms) | Total: 29.3% (5.45s) | Samples: 225

**Called by:**
- `getDeclaredVariables` (3558)

**Calls:**
- `push` (3333)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3216` | Self: 1.7% (333.7ms) | Total: 32.0% (5.96s) | Samples: 217

**Called by:**
- `getDeclaredVariables` (3880)

**Calls:**
- `push` (3663)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7259` | Self: 0.6% (128.3ms) | Total: 0.6% (129.7ms) | Samples: 83

**Called by:**
- `runPlugins` (84)

**Calls:**
- `_resolveHandlers` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7124` | Self: 0.5% (110.6ms) | Total: 92.4% (17.19s) | Samples: 71

**Called by:**
- `runPlugins` (11220)

**Calls:**
- `_invokeFused` (11145)
- `nodeView` (2)
- `nodeView` (1)
- `_invokeFused` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6804` | Self: 0.2% (54.8ms) | Total: 0.2% (54.8ms) | Samples: 37

**Called by:**
- `runPlugins` (37)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7096` | Self: 0.2% (51.9ms) | Total: 0.2% (54.6ms) | Samples: 34

**Called by:**
- `runPlugins` (36)

**Calls:**
- `_resolveHandlers` (1)
- `_resolveHandlers` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7361` | Self: 0.2% (44.2ms) | Total: 0.2% (44.2ms) | Samples: 28

**Called by:**
- `runPlugins` (28)

### `defineProperty`
`[native code]` | Self: 0.2% (41.2ms) | Total: 0.2% (41.2ms) | Samples: 28

**Called by:**
- `walkNodes` (15)
- `walkNodes` (13)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` | Self: 0.2% (39.5ms) | Total: 0.2% (39.5ms) | Samples: 26

**Called by:**
- `_nodeViewRaw` (26)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7084` | Self: 0.1% (33.1ms) | Total: 0.1% (33.1ms) | Samples: 21

**Called by:**
- `runPlugins` (21)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6790` | Self: 0.1% (25.4ms) | Total: 0.1% (25.4ms) | Samples: 17

**Called by:**
- `runPlugins` (17)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7086` | Self: 0.1% (25.2ms) | Total: 0.1% (25.2ms) | Samples: 17

**Called by:**
- `runPlugins` (17)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` | Self: 0.1% (24.0ms) | Total: 0.4% (81.9ms) | Samples: 15

**Called by:**
- `nodeView` (44)
- `nodeViewChain` (6)
- `_nodesFromRange` (1)
- `invokeMethodFnHandlers` (1)
- `_buildReference` (1)

**Calls:**
- `_NodeView` (26)
- `_NodeView_LR` (5)
- `_NodeView` (5)
- `_NodeView_LRN` (1)
- `_NodeView_LR` (1)

### `create`
`[native code]` | Self: 0.1% (19.6ms) | Total: 0.1% (19.6ms) | Samples: 13

**Called by:**
- `walkNodes` (7)
- `walkNodes` (6)

### `anonymous`
`[native code]` | Self: 0.0% (15.9ms) | Total: 0.3% (58.8ms) | Samples: 11

**Called by:**
- `require` (34)
- `internal:shared` (1)
- `internal:validators` (1)
- `bound require` (1)
- `node:fs` (1)
- `node:events` (1)

**Calls:**
- `(anonymous)` (7)
- `(anonymous)` (5)
- `(anonymous)` (3)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:shared` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:fs` (1)
- `internal:primordials` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:validators` (1)
- `node:events` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7292` | Self: 0.0% (15.4ms) | Total: 0.1% (24.5ms) | Samples: 11

**Called by:**
- `runPlugins` (17)

**Calls:**
- `create` (6)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6808` | Self: 0.0% (14.2ms) | Total: 0.0% (14.2ms) | Samples: 10

**Called by:**
- `runPlugins` (10)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4110` | Self: 0.0% (10.8ms) | Total: 0.0% (10.8ms) | Samples: 7

**Called by:**
- `nodeViewChain` (4)
- `nodeView` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7291` | Self: 0.0% (10.7ms) | Total: 0.1% (21.3ms) | Samples: 7

**Called by:**
- `runPlugins` (14)

**Calls:**
- `create` (7)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6528` | Self: 0.0% (10.3ms) | Total: 0.0% (10.3ms) | Samples: 7

**Called by:**
- `walkNodes` (7)

### `subarray`
`[native code]` | Self: 0.0% (10.3ms) | Total: 0.0% (10.3ms) | Samples: 7

**Called by:**
- `_computeDeclaredVariables` (7)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (8.6ms) | Total: 0.0% (8.6ms) | Samples: 6

**Called by:**
- `walkNodes` (6)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:855` | Self: 0.0% (8.4ms) | Total: 0.0% (11.3ms) | Samples: 6

**Called by:**
- `_symName` (8)

**Calls:**
- `slice` (2)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4058` | Self: 0.0% (7.8ms) | Total: 0.0% (7.8ms) | Samples: 5

**Called by:**
- `_nodeViewRaw` (5)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1733` | Self: 0.0% (7.8ms) | Total: 0.0% (7.8ms) | Samples: 5

**Called by:**
- `_computeIsStrict` (5)

### `Set`
`[native code]` | Self: 0.0% (7.6ms) | Total: 0.0% (11.1ms) | Samples: 5

**Called by:**
- `_computeDeclaredVariables` (7)

**Calls:**
- `values` (1)
- `arrayIteratorNextHelper` (1)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (7.4ms) | Total: 0.0% (7.4ms) | Samples: 5

**Called by:**
- `_nodeViewRaw` (5)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7296` | Self: 0.0% (7.4ms) | Total: 0.1% (26.6ms) | Samples: 5

**Called by:**
- `runPlugins` (18)

**Calls:**
- `defineProperty` (13)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7294` | Self: 0.0% (7.0ms) | Total: 0.1% (30.6ms) | Samples: 5

**Called by:**
- `runPlugins` (21)

**Calls:**
- `defineProperty` (15)
- `Object` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3187` | Self: 0.0% (6.4ms) | Total: 0.0% (6.4ms) | Samples: 4

**Called by:**
- `getDeclaredVariables` (4)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3190` | Self: 0.0% (6.3ms) | Total: 0.0% (6.3ms) | Samples: 4

**Called by:**
- `getDeclaredVariables` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7305` | Self: 0.0% (6.2ms) | Total: 0.0% (6.2ms) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `readdirSync`
`[native code]` | Self: 0.0% (6.2ms) | Total: 0.0% (12.4ms) | Samples: 4

**Called by:**
- `readdirSync` (4)
- `loadCoreRules` (4)

**Calls:**
- `readdirSync` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7362` | Self: 0.0% (6.1ms) | Total: 0.0% (6.1ms) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7235` | Self: 0.0% (6.0ms) | Total: 0.0% (6.0ms) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4111` | Self: 0.0% (5.9ms) | Total: 0.0% (5.9ms) | Samples: 4

**Called by:**
- `nodeView` (3)
- `nodeViewChain` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2161` | Self: 0.0% (5.6ms) | Total: 0.0% (5.6ms) | Samples: 4

**Called by:**
- `_buildReference` (3)
- `_buildScope` (1)

### `encodeInto`
`[native code]` | Self: 0.0% (5.1ms) | Total: 0.0% (5.1ms) | Samples: 3

**Called by:**
- `_encodeSource` (3)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4393` | Self: 0.0% (4.9ms) | Total: 0.0% (4.9ms) | Samples: 2

**Called by:**
- `AstView` (2)

### `decode`
`[native code]` | Self: 0.0% (4.8ms) | Total: 0.0% (4.8ms) | Samples: 3

**Called by:**
- `get source` (3)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3207` | Self: 0.0% (4.7ms) | Total: 0.0% (6.2ms) | Samples: 3

**Called by:**
- `getDeclaredVariables` (4)

**Calls:**
- `push` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7226` | Self: 0.0% (4.6ms) | Total: 0.1% (23.8ms) | Samples: 3

**Called by:**
- `runPlugins` (16)

**Calls:**
- `invokeMethodFnHandlers` (10)
- `invokeMethodFnHandlers` (1)
- `invokeMethodFnHandlers` (1)
- `invokeMethodFnHandlers` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2141` | Self: 0.0% (4.0ms) | Total: 0.2% (42.7ms) | Samples: 3

**Called by:**
- `_buildScope` (18)
- `_buildReference` (6)
- `_computeVarScope` (3)

**Calls:**
- `_computeIsStrict` (23)
- `_computeIsStrict` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2240` | Self: 0.0% (4.0ms) | Total: 0.1% (37.0ms) | Samples: 3

**Called by:**
- `_buildScope` (23)

**Calls:**
- `get body` (10)
- `get body` (5)
- `get body` (2)
- `get body` (2)
- `get body` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2135` | Self: 0.0% (3.5ms) | Total: 0.0% (3.5ms) | Samples: 2

**Called by:**
- `_computeVarScope` (1)
- `_buildScope` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1706` | Self: 0.0% (3.4ms) | Total: 0.0% (3.4ms) | Samples: 2

**Called by:**
- `_computeIsStrict` (2)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2068` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `_computeDeclaredVariables` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7260` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `has`
`[native code]` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `loadCoreRules` (2)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:808` | Self: 0.0% (3.2ms) | Total: 0.4% (75.9ms) | Samples: 2

**Called by:**
- `VariableDeclarator` (49)

**Calls:**
- `_buildReference` (27)
- `_buildReference` (15)
- `_buildReference` (4)
- `_buildReference` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:905` | Self: 0.0% (3.1ms) | Total: 0.1% (27.7ms) | Samples: 2

**Called by:**
- `get body` (10)
- `get value` (7)

**Calls:**
- `nodeView` (14)
- `_nodeViewRaw` (1)

### `arrayIteratorNextHelper`
`[native code]` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `Set` (1)
- `next` (1)

### `fill`
`[native code]` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2120` | Self: 0.0% (2.9ms) | Total: 0.3% (72.8ms) | Samples: 2

**Called by:**
- `_buildScope` (21)
- `_buildReference` (16)
- `_computeVarScope` (8)

**Calls:**
- `_buildScope` (21)
- `_buildScope` (18)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `slice`
`[native code]` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `_buildSymNameCache` (2)

### `_computeVarScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2847` | Self: 0.0% (2.8ms) | Total: 0.1% (21.6ms) | Samples: 2

**Called by:**
- `scope` (12)
- `get scope` (2)

**Calls:**
- `_buildScope` (8)
- `_buildScope` (3)
- `_buildScope` (1)

### `_resolveHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `walkNodes` (1)
- `walkNodes` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6530` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2751` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `_computeDeclaredVariables` (1)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `_getSharedCaches`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:726` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `reset` (1)

### `split`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_getSelectorRootTypes` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7390` | Self: 0.0% (1.7ms) | Total: 0.0% (3.1ms) | Samples: 1

**Called by:**
- `runPlugins` (2)

**Calls:**
- `invokeMethodFnHandlers` (1)

### `values`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `Set` (1)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:839` | Self: 0.0% (1.7ms) | Total: 0.0% (13.1ms) | Samples: 1

**Called by:**
- `_ensureDeclSymIndex` (8)
- `_buildVariable` (1)

**Calls:**
- `_buildSymNameCache` (8)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2175` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `get identifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_computeDeclaredVariables` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7188` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1710` | Self: 0.0% (1.7ms) | Total: 0.0% (3.2ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (2)

**Calls:**
- `nodeRhs` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2171` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4037` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3179` | Self: 0.0% (1.6ms) | Total: 0.0% (4.6ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (3)

**Calls:**
- `from` (2)

### `VariableDeclarator`
`/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:60` | Self: 0.0% (1.6ms) | Total: 0.5% (101.9ms) | Samples: 1

**Called by:**
- `_invokeFused` (66)

**Calls:**
- `get references` (49)
- `get references` (16)

### `fetch`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `requestFetch` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_isChainNode`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `nodeViewChain` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2222` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3218` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `dlopen`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `endsWith`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_isSelector` (1)

### `(anonymous)`
`internal:primordials` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `forEach` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7189` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4156` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `get init` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7080` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2883` | Self: 0.0% (1.5ms) | Total: 0.2% (42.8ms) | Samples: 1

**Called by:**
- `get references` (27)

**Calls:**
- `_buildScope` (16)
- `_buildScope` (6)
- `_buildScope` (3)
- `_buildScope` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4132` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `from`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (2.9ms) | Samples: 1

**Called by:**
- `_computeDeclaredVariables` (2)

**Calls:**
- `next` (1)

### `_getSharedCaches`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:725` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `SourceCode` (1)

### `Object`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2949` | Self: 0.0% (1.5ms) | Total: 0.1% (20.1ms) | Samples: 1

**Called by:**
- `VariableDeclarator` (13)

**Calls:**
- `nodeViewChain` (11)
- `nodeViewChain` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1538` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `invokeMethodFnHandlers` (1)

### `nodeRhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:570` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get body` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7282` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6360` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6589` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6369` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2066` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_computeDeclaredVariables` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6371` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `existsSync`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `existsSync` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3135` | Self: 0.0% (1.3ms) | Total: 91.0% (16.92s) | Samples: 1

**Called by:**
- `VariableDeclarator` (11050)

**Calls:**
- `_computeDeclaredVariables` (3880)
- `_computeDeclaredVariables` (3562)
- `_computeDeclaredVariables` (3558)
- `_computeDeclaredVariables` (15)
- `_computeDeclaredVariables` (7)
- `_computeDeclaredVariables` (7)
- `_computeDeclaredVariables` (4)
- `_computeDeclaredVariables` (4)
- `_computeDeclaredVariables` (4)
- `_computeDeclaredVariables` (3)
- `_computeDeclaredVariables` (2)
- `_computeDeclaredVariables` (1)
- `_computeDeclaredVariables` (1)
- `_computeDeclaredVariables` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `get declare`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `VariableDeclarator` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2042` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_computeDeclaredVariables` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:902` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `get value` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3189` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7234` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `get references` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4720` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4115` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `nodeView` (1)

### `_Variable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:847` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildVariable` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2058` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_computeDeclaredVariables` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7290` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `get declare`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2863` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `VariableDeclarator` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1736` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `_rawTokenText`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:831` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `get value` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:802` | Self: 0.0% (1.3ms) | Total: 0.1% (24.2ms) | Samples: 1

**Called by:**
- `VariableDeclarator` (16)

**Calls:**
- `_computeVariableSynthRefs` (14)
- `_computeVariableSynthRefs` (1)

### `FFIBuilder`
`bun:ffi` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `dlopen` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2069` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_computeDeclaredVariables` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7297` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `get init` (1)

### `_resolveHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6985` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2067` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_computeDeclaredVariables` (1)

### `readFileSync`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (2.4ms) | Samples: 1

**Called by:**
- `readFileSync` (1)
- `(anonymous)` (1)

**Calls:**
- `readFileSync` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3136` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `VariableDeclarator` (1)

### `_NodeView_LRN`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4051` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `_getSelectorRootTypes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5746` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_buildPlan` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` | Self: 0.0% (0us) | Total: 4.1% (779.6ms) | Samples: 0

**Calls:**
- `parseSource` (508)
- `parseSource` (3)
- `parseSource` (2)

### `_getFfiSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:110` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_getOrBuildSelectorPlan` (1)

**Calls:**
- `isAvailable` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2929` | Self: 0.0% (0us) | Total: 0.1% (21.6ms) | Samples: 0

**Called by:**
- `get references` (14)

**Calls:**
- `scope` (12)
- `get scope` (2)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:267` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Calls:**
- `getTagNames` (1)

### `makeSafe`
`internal:primordials:30` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `internal:primordials` (1)

**Calls:**
- `bound call` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4137` | Self: 0.0% (0us) | Total: 0.4% (78.0ms) | Samples: 0

**Called by:**
- `get parent` (27)
- `_nodesFromRange` (14)
- `walkNodes` (4)
- `_buildReference` (3)
- `walkNodes` (2)
- `walkNodes` (1)

**Calls:**
- `_nodeViewRaw` (44)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (1)

### `internal:shared`
`internal:shared:2` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `_getOrBuildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5617` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_buildPlan` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` | Self: 0.0% (0us) | Total: 0.0% (4.9ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (2)

**Calls:**
- `AstView` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:477` | Self: 0.0% (0us) | Total: 0.0% (7.5ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `patchAstUtils` (5)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` | Self: 0.0% (0us) | Total: 0.0% (4.8ms) | Samples: 0

**Called by:**
- `runPlugins` (3)

**Calls:**
- `decode` (3)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:478` | Self: 0.0% (0us) | Total: 0.0% (4.9ms) | Samples: 0

**Called by:**
- `parseSource` (2)

**Calls:**
- `CfgGraph` (2)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:47` | Self: 0.0% (0us) | Total: 0.0% (6.2ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (4)

**Calls:**
- `readdirSync` (4)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:435` | Self: 0.0% (0us) | Total: 0.0% (7.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `bound require` (5)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:274` | Self: 0.0% (0us) | Total: 95.6% (17.79s) | Samples: 0

**Calls:**
- `runPlugins` (11606)
- `runPlugins` (5)
- `runPlugins` (3)
- `runPlugins` (2)
- `runPlugins` (1)

### `SourceCode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1048` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `RuleContext` (1)

**Calls:**
- `_getSharedCaches` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3201` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (1)

**Calls:**
- `_buildVariable` (1)

### `async lintSource`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:350` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `async lintSource` (1)

**Calls:**
- `async _resolveConfig` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` | Self: 0.0% (0us) | Total: 4.1% (769.4ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (508)

**Calls:**
- `parse` (508)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2872` | Self: 0.0% (0us) | Total: 0.0% (6.0ms) | Samples: 0

**Called by:**
- `get references` (4)

**Calls:**
- `nodeView` (3)
- `_nodeViewRaw` (1)

### `async lintSource`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:349` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `async lintSource` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7587` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (2)

**Calls:**
- `fill` (2)

### `requestInstantiate`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `requestSatisfyUtil` (1)

**Calls:**
- `async (anonymous)` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5815` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_getOrBuildPlan` (1)

**Calls:**
- `_getSelectorRootTypes` (1)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5424` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_getSelectorRootTypes` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1511` | Self: 0.0% (0us) | Total: 0.0% (11.9ms) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (8)

**Calls:**
- `_nodesFromRange` (7)
- `_nodesFromRange` (1)

### `scope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:764` | Self: 0.0% (0us) | Total: 0.1% (18.7ms) | Samples: 0

**Called by:**
- `_computeVariableSynthRefs` (12)

**Calls:**
- `_computeVarScope` (12)

### `requestFetch`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `fetch` (1)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5495` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `walkNodes` (2)

**Calls:**
- `_getFfiSelector` (1)
- `_getFfiSelector` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `async _loadFlatConfig`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:42` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `async _loadFlatConfig` (1)

**Calls:**
- `existsSync` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `isAvailable`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:399` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_getFfiSelector` (1)

**Calls:**
- `_tryLoad` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1078` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `reset` (1)

**Calls:**
- `_getSharedCaches` (1)

### `VariableDeclarator`
`/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:50` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `_invokeFused` (2)

**Calls:**
- `get declare` (1)
- `get declare` (1)

### `RuleContext`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4009` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `SourceCode` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3147` | Self: 0.0% (0us) | Total: 0.0% (10.3ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (7)

**Calls:**
- `subarray` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:28` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `readFileSync` (1)

### `internal:primordials`
`internal:primordials:71` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `makeSafe` (1)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:50` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (2)

**Calls:**
- `has` (2)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:135` | Self: 0.0% (0us) | Total: 0.0% (9.4ms) | Samples: 0

**Calls:**
- `loadCoreRules` (4)
- `loadCoreRules` (2)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6366` | Self: 0.0% (0us) | Total: 0.0% (14.8ms) | Samples: 0

**Called by:**
- `walkNodes` (10)

**Calls:**
- `get value` (8)
- `get value` (1)
- `get value` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7599` | Self: 0.0% (0us) | Total: 0.0% (8.3ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (5)

**Calls:**
- `get source` (3)
- `reset` (1)
- `reset` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4718` | Self: 0.0% (0us) | Total: 91.7% (17.07s) | Samples: 0

**Called by:**
- `walkNodes` (11145)

**Calls:**
- `VariableDeclarator` (11051)
- `VariableDeclarator` (66)
- `VariableDeclarator` (15)
- `VariableDeclarator` (11)
- `VariableDeclarator` (2)

### `bound call`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `makeSafe` (1)

**Calls:**
- `forEach` (1)

### `existsSync`
`node:fs:273` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `async _loadFlatConfig` (1)

**Calls:**
- `existsSync` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7606` | Self: 0.0% (0us) | Total: 0.0% (4.3ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (3)

**Calls:**
- `buildVisitorMap` (2)
- `buildVisitorMap` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:38` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Calls:**
- `async lintSource` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:75` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `async _resolveConfig` (1)

**Calls:**
- `async _resolveConfigImpl` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2755` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_computeDeclaredVariables` (1)

**Calls:**
- `_symName` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:25` | Self: 0.0% (0us) | Total: 0.0% (13.5ms) | Samples: 0

**Called by:**
- `parseModule` (9)

**Calls:**
- `bound require` (9)

### `VariableDeclarator`
`/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:55` | Self: 0.0% (0us) | Total: 91.0% (16.92s) | Samples: 0

**Called by:**
- `_invokeFused` (11051)

**Calls:**
- `getDeclaredVariables` (11050)
- `getDeclaredVariables` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:220` | Self: 0.0% (0us) | Total: 0.0% (5.1ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (3)

**Calls:**
- `_encodeSource` (3)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2876` | Self: 0.0% (0us) | Total: 0.1% (22.4ms) | Samples: 0

**Called by:**
- `get references` (15)

**Calls:**
- `get parent` (15)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3157` | Self: 0.0% (0us) | Total: 0.0% (3.5ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (2)

**Calls:**
- `_buildVariable` (1)
- `_buildVariable` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

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

### `VariableDeclarator`
`/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:45` | Self: 0.0% (0us) | Total: 0.0% (16.8ms) | Samples: 0

**Called by:**
- `_invokeFused` (11)

**Calls:**
- `get parent` (11)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1211` | Self: 0.0% (0us) | Total: 0.2% (40.6ms) | Samples: 0

**Called by:**
- `_buildReference` (15)
- `VariableDeclarator` (11)
- `_buildReference` (1)

**Calls:**
- `nodeView` (27)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7287` | Self: 0.0% (0us) | Total: 0.0% (6.2ms) | Samples: 0

**Called by:**
- `runPlugins` (4)

**Calls:**
- `nodeView` (4)

### `_getSelectorRootTypes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5757` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_getOrBuildSelectorPlan` (1)

**Calls:**
- `split` (1)

### `forEach`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `bound call` (1)

**Calls:**
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7083` | Self: 0.0% (0us) | Total: 0.1% (21.7ms) | Samples: 0

**Called by:**
- `runPlugins` (15)

**Calls:**
- `getDFSEvents` (7)
- `getDFSEvents` (6)
- `getDFSEvents` (2)

### `_getFfiSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:109` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_getOrBuildSelectorPlan` (1)

**Calls:**
- `bound require` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7286` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `nodeView` (1)
- `nodeView` (1)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 0.2% (50.7ms) | Samples: 0

**Called by:**
- `bound require` (34)

**Calls:**
- `anonymous` (34)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6687` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_getOrBuildPlan` (1)

### `getTagNames`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:191` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `loadBinding` (1)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (19.7ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)
- `requestInstantiate` (1)

**Calls:**
- `parseModule` (11)
- `async (anonymous)` (1)
- `requestFetch` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1417` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (1)

**Calls:**
- `_rawTokenText` (1)

### `get init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2949` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `VariableDeclarator` (2)

**Calls:**
- `nodeViewChain` (1)
- `nodeViewChain` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7602` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `RuleContext` (1)

### `next`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `from` (1)

**Calls:**
- `arrayIteratorNextHelper` (1)

### `async _resolveConfig`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:67` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `async lintSource` (1)

**Calls:**
- `async _resolveConfig` (1)

### `_isSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4172` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (1)

**Calls:**
- `endsWith` (1)

### `loadBinding`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `getTagNames` (1)

**Calls:**
- `bound require` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4162` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `init` (1)

**Calls:**
- `_isChainNode` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4398` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_isSelector` (1)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 0.2% (54.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (9)
- `(anonymous)` (7)
- `patchAstUtils` (5)
- `(anonymous)` (3)
- `esquery` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `loadBinding` (1)
- `(anonymous)` (1)
- `_getFfiSelector` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `require` (34)
- `(anonymous)` (1)
- `anonymous` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4403` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `esquery` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` | Self: 0.0% (0us) | Total: 0.0% (10.9ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2782` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_computeDeclaredVariables` (1)

**Calls:**
- `_Variable` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1713` | Self: 0.0% (0us) | Total: 0.0% (17.1ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (10)

**Calls:**
- `_nodesFromRange` (10)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3177` | Self: 0.0% (0us) | Total: 0.0% (11.1ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (7)

**Calls:**
- `Set` (7)

### `VariableDeclarator`
`/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js:47` | Self: 0.0% (0us) | Total: 0.1% (23.0ms) | Samples: 0

**Called by:**
- `_invokeFused` (15)

**Calls:**
- `init` (13)
- `get init` (2)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6365` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `bound require` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2901` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `get references` (1)

**Calls:**
- `get parent` (1)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4165` | Self: 0.0% (0us) | Total: 0.0% (17.0ms) | Samples: 0

**Called by:**
- `init` (11)

**Calls:**
- `_nodeViewRaw` (6)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (1)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` | Self: 0.0% (0us) | Total: 0.0% (5.1ms) | Samples: 0

**Called by:**
- `parseSource` (3)

**Calls:**
- `encodeInto` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `get scope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:764` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `_computeVariableSynthRefs` (2)

**Calls:**
- `_computeVarScope` (2)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4049` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `reset` (1)

### `node:events`
`node:events:9` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `dlopen`
`bun:ffi:351` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_tryLoad` (1)

**Calls:**
- `FFIBuilder` (1)

### `parseModule`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (16.3ms) | Samples: 0

**Called by:**
- `async (anonymous)` (11)

**Calls:**
- `(anonymous)` (9)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.0% (4.5ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `async _loadFlatConfig`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:36` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (1)

**Calls:**
- `async _loadFlatConfig` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6463` | Self: 0.0% (0us) | Total: 0.0% (4.4ms) | Samples: 0

**Called by:**
- `runPlugins` (3)

**Calls:**
- `_getOrBuildSelectorPlan` (2)
- `_getOrBuildSelectorPlan` (1)

### `async _resolveConfig`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:70` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `async _resolveConfig` (1)

**Calls:**
- `async _resolveConfigImpl` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn-jsx/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `bound require` (1)

**Calls:**
- `requestSatisfyUtil` (1)
- `dlopen` (1)

### `requestSatisfyUtil`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `requestInstantiate` (1)

### `esquery`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:53` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (2)

**Calls:**
- `bound require` (2)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2065` | Self: 0.0% (0us) | Total: 0.0% (11.3ms) | Samples: 0

**Called by:**
- `_computeDeclaredVariables` (8)

**Calls:**
- `_symName` (8)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:81` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (1)

**Calls:**
- `async _loadFlatConfig` (1)

### `internal:validators`
`internal:validators:2` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7607` | Self: 0.0% (0us) | Total: 95.5% (17.77s) | Samples: 0

**Called by:**
- `_lintSourceOne` (11606)

**Calls:**
- `walkNodes` (11220)
- `walkNodes` (84)
- `walkNodes` (37)
- `walkNodes` (36)
- `walkNodes` (28)
- `walkNodes` (21)
- `walkNodes` (21)
- `walkNodes` (18)
- `walkNodes` (17)
- `walkNodes` (17)
- `walkNodes` (17)
- `walkNodes` (16)
- `walkNodes` (15)
- `walkNodes` (14)
- `walkNodes` (10)
- `walkNodes` (4)
- `walkNodes` (4)
- `walkNodes` (4)
- `walkNodes` (4)
- `walkNodes` (3)
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
- `walkNodes` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3162` | Self: 0.0% (0us) | Total: 0.1% (21.3ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (15)

**Calls:**
- `_ensureDeclSymIndex` (8)
- `_ensureDeclSymIndex` (2)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 89.8% | 16.71s | `[native code]` |
| 9.2% | 1.72s | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.8% | 150.1ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/.ez/rules-rewritten/eslint/no-unassigned-vars.js` |
| 0.0% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.6ms | `internal:primordials` |
| 0.0% | 1.2ms | `bun:ffi` |
