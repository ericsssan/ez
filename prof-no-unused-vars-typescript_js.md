# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 6.19s | 3974 | 1.0ms | 933 |

**Top 10:** `parse` 12.6%, `_parseDisableDirectives` 4.5%, `_resolveUnicodeEscapes` 3.9%, `anonymous` 3.7%, `set` 3.6%, `walkNodes` 3.2%, `collectUnusedVariables` 2.6%, `/\r?\n/` 1.9%, `_nodeViewRaw` 1.5%, `_computeDeclaredVariables` 1.2%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 12.6% | 783.3ms | 12.6% | 783.3ms | `parse` | `[native code]` |
| 4.5% | 282.4ms | 4.6% | 290.1ms | `_parseDisableDirectives` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8655` |
| 3.9% | 246.9ms | 3.9% | 246.9ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:241` |
| 3.7% | 232.0ms | 23.8% | 1.47s | `anonymous` | `[native code]` |
| 3.6% | 227.8ms | 3.6% | 227.8ms | `set` | `[native code]` |
| 3.2% | 199.4ms | 3.2% | 199.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8109` |
| 2.6% | 161.4ms | 5.9% | 366.8ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34240` |
| 1.9% | 120.2ms | 1.9% | 120.2ms | `/\r?\n/` | `[native code]` |
| 1.5% | 95.6ms | 11.8% | 736.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4530` |
| 1.2% | 79.3ms | 1.2% | 79.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3512` |
| 1.2% | 78.2ms | 1.2% | 78.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 1.2% | 76.6ms | 4.0% | 250.7ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3154` |
| 1.1% | 71.5ms | 1.1% | 71.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301227` |
| 1.1% | 71.2ms | 1.1% | 71.2ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4417` |
| 1.1% | 71.0ms | 1.1% | 71.0ms | `getOwnPropertyDescriptor` | `[native code]` |
| 1.1% | 69.9ms | 1.1% | 71.3ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34220` |
| 1.0% | 64.0ms | 10.2% | 636.4ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2813` |
| 1.0% | 63.9ms | 2.2% | 141.7ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:913` |
| 1.0% | 63.2ms | 1.5% | 98.4ms | `Set` | `[native code]` |
| 1.0% | 62.2ms | 1.0% | 65.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34097` |
| 0.9% | 60.5ms | 1.0% | 62.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2501` |
| 0.9% | 60.5ms | 1.3% | 84.8ms | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:619` |
| 0.9% | 59.4ms | 0.9% | 59.4ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2747` |
| 0.9% | 57.9ms | 4.0% | 249.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2295` |
| 0.8% | 52.6ms | 0.8% | 52.6ms | `get` | `[native code]` |
| 0.8% | 52.5ms | 2.7% | 172.8ms | `regExpSplitFast` | `[native code]` |
| 0.8% | 51.8ms | 0.8% | 51.8ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:676` |
| 0.8% | 51.5ms | 0.8% | 51.5ms | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:609` |
| 0.8% | 49.7ms | 0.8% | 49.7ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.8% | 49.6ms | 0.8% | 49.6ms | `_computeIdentifierName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.7% | 48.3ms | 0.7% | 48.3ms | `_getSynth` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1031` |
| 0.7% | 47.4ms | 0.7% | 47.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2449` |
| 0.6% | 42.9ms | 0.6% | 42.9ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4478` |
| 0.6% | 41.3ms | 0.6% | 41.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4524` |
| 0.6% | 40.6ms | 0.6% | 40.6ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4476` |
| 0.6% | 39.8ms | 2.4% | 151.7ms | `parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1289` |
| 0.5% | 36.1ms | 7.8% | 486.2ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2781` |
| 0.5% | 35.6ms | 0.5% | 35.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2324` |
| 0.5% | 35.6ms | 1.0% | 62.3ms | `isLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:622` |
| 0.5% | 35.4ms | 0.5% | 35.4ms | `_Reference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:320` |
| 0.5% | 34.8ms | 0.5% | 36.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3171` |
| 0.5% | 34.5ms | 0.9% | 59.4ms | `arrayIteratorNextHelper` | `[native code]` |
| 0.5% | 34.1ms | 0.5% | 34.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7785` |
| 0.5% | 33.8ms | 1.2% | 76.5ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:919` |
| 0.5% | 32.9ms | 0.5% | 32.9ms | `push` | `[native code]` |
| 0.5% | 31.9ms | 0.5% | 31.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1290` |
| 0.4% | 30.2ms | 6.7% | 417.0ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4484` |
| 0.4% | 27.8ms | 0.4% | 27.8ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34095` |
| 0.4% | 26.8ms | 0.4% | 26.8ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:871` |
| 0.4% | 26.7ms | 0.4% | 26.7ms | `/^(?:DoWhile\|For\|ForIn\|ForOf\|While)Statement$/u` | `[native code]` |
| 0.4% | 26.5ms | 0.4% | 28.1ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4428` |
| 0.4% | 26.2ms | 0.4% | 26.2ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.4% | 26.0ms | 7.4% | 459.2ms | `some` | `[native code]` |
| 0.4% | 25.6ms | 3.6% | 225.2ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2910` |
| 0.4% | 25.0ms | 0.4% | 25.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8297` |
| 0.4% | 25.0ms | 0.6% | 41.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2439` |
| 0.4% | 24.9ms | 0.4% | 24.9ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34087` |
| 0.4% | 24.9ms | 0.4% | 24.9ms | `typedArrayViewLength` | `[native code]` |
| 0.3% | 24.6ms | 0.3% | 24.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4541` |
| 0.3% | 24.5ms | 0.3% | 24.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8111` |
| 0.3% | 24.3ms | 0.3% | 24.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2722` |
| 0.3% | 24.2ms | 0.3% | 24.2ms | `/^(?:Function(?:Declaration\|Expression)\|ArrowFunctionExpression)$/u` | `[native code]` |
| 0.3% | 24.1ms | 0.3% | 24.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2343` |
| 0.3% | 23.5ms | 0.3% | 23.5ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2907` |
| 0.3% | 20.8ms | 0.3% | 20.8ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3498` |
| 0.3% | 20.5ms | 0.4% | 24.8ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3173` |
| 0.3% | 20.2ms | 4.5% | 279.6ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2831` |
| 0.3% | 19.9ms | 0.3% | 22.6ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3118` |
| 0.3% | 19.8ms | 0.3% | 19.8ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4429` |
| 0.3% | 19.8ms | 0.3% | 19.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.3% | 19.7ms | 0.3% | 19.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3057` |
| 0.3% | 19.2ms | 100.0% | 8.51s | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2847` |
| 0.3% | 19.0ms | 0.3% | 19.0ms | `values` | `[native code]` |
| 0.3% | 18.9ms | 0.7% | 44.9ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3223` |
| 0.2% | 18.5ms | 0.2% | 18.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2441` |
| 0.2% | 18.5ms | 0.2% | 18.5ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` |
| 0.2% | 18.3ms | 100.0% | 10.06s | `_ensureRefsThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1052` |
| 0.2% | 18.1ms | 1.1% | 69.1ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2598` |
| 0.2% | 17.8ms | 7.4% | 459.8ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3143` |
| 0.2% | 16.7ms | 3.7% | 232.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34208` |
| 0.2% | 15.1ms | 0.5% | 35.1ms | `from` | `[native code]` |
| 0.2% | 14.2ms | 0.4% | 25.0ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3499` |
| 0.2% | 13.9ms | 0.2% | 16.8ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34231` |
| 0.2% | 13.6ms | 2.1% | 132.1ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:625` |
| 0.2% | 13.2ms | 0.2% | 13.2ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3097` |
| 0.2% | 13.1ms | 0.6% | 37.6ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1841` |
| 0.2% | 12.9ms | 0.8% | 52.2ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:966` |
| 0.2% | 12.9ms | 0.3% | 22.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34240` |
| 0.2% | 12.7ms | 0.2% | 12.7ms | `decode` | `[native code]` |
| 0.2% | 12.7ms | 0.2% | 12.7ms | `subarray` | `[native code]` |
| 0.2% | 12.7ms | 0.2% | 12.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.2% | 12.7ms | 0.2% | 12.7ms | `_Variable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:958` |
| 0.2% | 12.6ms | 0.2% | 12.6ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4560` |
| 0.1% | 12.3ms | 0.3% | 21.3ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3002` |
| 0.1% | 12.2ms | 0.1% | 12.2ms | `_getSynth` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 12.1ms | 0.2% | 15.5ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34197` |
| 0.1% | 11.9ms | 0.7% | 46.0ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3478` |
| 0.1% | 11.8ms | 0.1% | 11.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 11.8ms | 0.6% | 37.9ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3150` |
| 0.1% | 11.7ms | 0.1% | 11.7ms | `_computeIdentifierName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4463` |
| 0.1% | 11.6ms | 0.1% | 11.6ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 11.3ms | 0.1% | 11.3ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2899` |
| 0.1% | 11.0ms | 0.1% | 12.3ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2890` |
| 0.1% | 10.7ms | 0.1% | 10.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7771` |
| 0.1% | 10.7ms | 0.1% | 10.7ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2845` |
| 0.1% | 10.7ms | 0.1% | 10.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3022` |
| 0.1% | 10.5ms | 0.1% | 10.5ms | `parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1290` |
| 0.1% | 10.5ms | 0.2% | 14.8ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3235` |
| 0.1% | 10.5ms | 12.7% | 787.4ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34288` |
| 0.1% | 10.4ms | 0.1% | 10.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8293` |
| 0.1% | 10.2ms | 0.1% | 10.2ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 10.2ms | 0.1% | 11.7ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2394` |
| 0.1% | 10.1ms | 0.1% | 10.1ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34215` |
| 0.1% | 10.1ms | 0.1% | 10.1ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 9.7ms | 2.7% | 173.1ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2412` |
| 0.1% | 9.5ms | 0.2% | 18.1ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3102` |
| 0.1% | 9.3ms | 0.1% | 9.3ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 9.2ms | 0.2% | 12.5ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3484` |
| 0.1% | 8.9ms | 0.1% | 8.9ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4845` |
| 0.1% | 8.7ms | 0.1% | 8.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2735` |
| 0.1% | 8.5ms | 0.1% | 8.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2334` |
| 0.1% | 8.3ms | 0.1% | 8.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2719` |
| 0.1% | 8.2ms | 0.1% | 11.1ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34132` |
| 0.1% | 8.1ms | 35.4% | 2.19s | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34203` |
| 0.1% | 7.9ms | 0.1% | 7.9ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2837` |
| 0.1% | 7.8ms | 0.1% | 7.8ms | `parentTypeEq` | `/Users/ericsan/Development/OpenSource/Ez/js/rewrite-helpers.js` |
| 0.1% | 7.8ms | 0.1% | 7.8ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 7.6ms | 0.1% | 7.6ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7476` |
| 0.1% | 7.6ms | 0.1% | 7.6ms | `includes` | `[native code]` |
| 0.1% | 7.6ms | 3.1% | 192.3ms | `get defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:880` |
| 0.1% | 7.4ms | 0.1% | 9.1ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34112` |
| 0.1% | 7.4ms | 0.4% | 30.0ms | `scope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:875` |
| 0.1% | 7.4ms | 0.1% | 7.4ms | `/^\s*exported\b/` | `[native code]` |
| 0.1% | 6.9ms | 0.1% | 6.9ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` |
| 0.1% | 6.7ms | 0.3% | 24.7ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34176` |
| 0.1% | 6.6ms | 0.1% | 6.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3175` |
| 0.1% | 6.6ms | 0.1% | 6.6ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1307` |
| 0.1% | 6.4ms | 0.1% | 6.4ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2793` |
| 0.1% | 6.3ms | 0.1% | 6.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3502` |
| 0.1% | 6.3ms | 0.1% | 6.3ms | `get eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:868` |
| 0.1% | 6.2ms | 0.7% | 43.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2448` |
| 0.0% | 6.1ms | 0.0% | 6.1ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:590` |
| 0.0% | 6.1ms | 0.0% | 6.1ms | `defineProperty` | `[native code]` |
| 0.0% | 6.1ms | 0.6% | 40.8ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1844` |
| 0.0% | 6.0ms | 0.1% | 8.9ms | `parentTypeEq` | `/Users/ericsan/Development/OpenSource/Ez/js/rewrite-helpers.js:176` |
| 0.0% | 6.0ms | 0.0% | 6.0ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:916` |
| 0.0% | 6.0ms | 0.0% | 6.0ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 5.9ms | 0.0% | 5.9ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 5.9ms | 0.0% | 5.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2717` |
| 0.0% | 5.8ms | 0.3% | 24.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2279` |
| 0.0% | 5.8ms | 0.0% | 5.8ms | `typedArrayViewIsDetached` | `[native code]` |
| 0.0% | 5.7ms | 0.0% | 5.7ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 5.7ms | 0.6% | 38.5ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3092` |
| 0.0% | 5.6ms | 0.0% | 5.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3548` |
| 0.0% | 5.3ms | 5.7% | 353.0ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1002` |
| 0.0% | 4.9ms | 1.1% | 70.2ms | `next` | `[native code]` |
| 0.0% | 4.8ms | 0.0% | 4.8ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:593` |
| 0.0% | 4.8ms | 0.0% | 4.8ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3197` |
| 0.0% | 4.7ms | 0.0% | 4.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3468` |
| 0.0% | 4.7ms | 0.0% | 4.7ms | `RegExp` | `[native code]` |
| 0.0% | 4.7ms | 0.0% | 4.7ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:938` |
| 0.0% | 4.6ms | 0.0% | 4.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 4.6ms | 0.0% | 4.6ms | `encodeInto` | `[native code]` |
| 0.0% | 4.6ms | 0.0% | 4.6ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:678` |
| 0.0% | 4.5ms | 0.0% | 4.5ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1814` |
| 0.0% | 4.4ms | 0.1% | 7.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34104` |
| 0.0% | 4.4ms | 0.0% | 4.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2502` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4538` |
| 0.0% | 4.2ms | 0.0% | 4.2ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1271` |
| 0.0% | 4.1ms | 0.0% | 4.1ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2785` |
| 0.0% | 4.1ms | 0.0% | 4.1ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3433` |
| 0.0% | 4.0ms | 0.0% | 4.0ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34183` |
| 0.0% | 4.0ms | 0.6% | 39.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1289` |
| 0.0% | 3.7ms | 0.2% | 18.0ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3444` |
| 0.0% | 3.6ms | 0.0% | 3.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3440` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2438` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `get left` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2886` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 3.4ms | 1.2% | 77.2ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34216` |
| 0.0% | 3.3ms | 0.1% | 6.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2222` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:591` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:559` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3487` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2599` |
| 0.0% | 3.3ms | 3.1% | 196.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34237` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:717` |
| 0.0% | 3.2ms | 1.7% | 107.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34219` |
| 0.0% | 3.2ms | 1.5% | 98.8ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3474` |
| 0.0% | 3.1ms | 4.3% | 267.0ms | `_ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1069` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1266` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2319` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `toLocaleLowerCase` | `[native code]` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34119` |
| 0.0% | 3.1ms | 0.8% | 49.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3513` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2904` |
| 0.0% | 3.0ms | 0.6% | 38.2ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3476` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2208` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3486` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4565` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 3.0ms | 100.0% | 9.24s | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34310` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:609` |
| 0.0% | 3.0ms | 0.1% | 8.8ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3172` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2999` |
| 0.0% | 3.0ms | 2.4% | 154.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2274` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:675` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `isRead` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 2.9ms | 0.1% | 11.9ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1364` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_getSynth` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1030` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:906` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3190` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `get scope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:875` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301221` |
| 0.0% | 2.5ms | 0.0% | 4.0ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4562` |
| 0.0% | 1.8ms | 37.3% | 2.31s | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34304` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `parentTypeEq` | `/Users/ericsan/Development/OpenSource/Ez/js/rewrite-helpers.js:164` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:187573` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `get defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:232263` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `/^\s*globals?\b/` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 4.6ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34137` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:933` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:595` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `node:child_process` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2914` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3132` |
| 0.0% | 1.7ms | 4.1% | 258.1ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1099` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `file` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2360` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1282` |
| 0.0% | 1.7ms | 1.1% | 73.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34216` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `/(\p{Lu})([\p{Lu}][\p{Ll}])/gu` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:680` |
| 0.0% | 1.7ms | 0.4% | 29.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34207` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.1% | 7.7ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:900` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2260` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/useProgramFromProjectService.js:5` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170940` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:943` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7786` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2857` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:54205` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1632` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `Comparator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2410` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2264` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_isSimpleRangeTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4413` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `mapDefined` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:2610` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_getSharedCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:836` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/tsconfig-utils/dist/getParsedConfigFile.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_NodeView_N` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:179640` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_lineAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:762` |
| 0.0% | 1.5ms | 0.2% | 14.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3053` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `nodeTypeAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4669` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:30` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173068` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `handleFixes` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34315` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `keys` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2330` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_declSymsForNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `test` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2779` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `stringify` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/fast-json-stable-stringify/index.js:48` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4309` |
| 0.0% | 1.5ms | 0.0% | 2.5ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2856` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3424` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91331` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1280` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34180` |
| 0.0% | 1.5ms | 0.0% | 3.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2600` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:195507` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3229` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getUpperFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:612` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4432` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7478` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8029` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:585` |
| 0.0% | 1.5ms | 0.2% | 18.4ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3537` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `Map` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get right` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34130` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1887` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183935` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `/\{\{\s*(\w+)\s*\}\}/g` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4539` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:622` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `internal:fs/streams` | `internal:fs/streams:252` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3270` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get operator` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1403` |
| 0.0% | 1.4ms | 0.1% | 6.9ms | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:880` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_interopRequireDefault` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `handleFixes` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34573` |
| 0.0% | 1.4ms | 0.4% | 28.7ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1813` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:271662` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2739` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1272` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3479` |
| 0.0% | 1.4ms | 0.1% | 12.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8108` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1024` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2423` |
| 0.0% | 1.4ms | 0.0% | 2.8ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34187` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `handleFixes` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34647` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3454` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:626` |
| 0.0% | 1.4ms | 0.7% | 43.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3174` |
| 0.0% | 1.4ms | 0.2% | 18.4ms | `map` | `[native code]` |
| 0.0% | 1.4ms | 4.3% | 268.8ms | `_ensureRefsThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1051` |
| 0.0% | 1.4ms | 1.8% | 114.4ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3073` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js` |
| 0.0% | 1.4ms | 0.0% | 3.1ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3026` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34116` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getOwnPropertyDescriptors` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1888` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1596` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:194186` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:202009` |
| 0.0% | 1.3ms | 10.8% | 673.2ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34214` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `internal:streams/destroy` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1830` |
| 0.0% | 1.3ms | 0.1% | 10.7ms | `exec` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getLocFromIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3833` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:963` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `SemVer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1371` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2854` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `isatty` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301197` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:267051` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3275` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getDefinedMessageData` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34015` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2326` |
| 0.0% | 1.3ms | 0.0% | 3.0ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2859` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2221` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `dlopen` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1818` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/index.js:15` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4475` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `nodeTypeAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `generateNamedReferences` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321795` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:169261` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1035` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_getOrBuildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6524` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `handleFixes` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:218307` |
| 0.0% | 1.2ms | 0.2% | 17.0ms | `parseModule` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `replace` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:241535` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:291272` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureRefsThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1050` |
| 0.0% | 1.2ms | 0.0% | 4.1ms | `filter` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3549` |
| 0.0% | 1.2ms | 0.0% | 2.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2349` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190190` |
| 0.0% | 1.0ms | 0.0% | 1.0ms | `performProxyObjectSetStrict` | `[native code]` |
| 0.0% | 1.0ms | 0.0% | 1.0ms | `toLocaleUpperCase` | `[native code]` |
| 0.0% | 998us | 0.0% | 998us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3450` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 100.0% | 10.06s | 0.2% | 18.3ms | `_ensureRefsThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1052` |
| 100.0% | 9.24s | 0.0% | 3.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34310` |
| 100.0% | 8.51s | 0.3% | 19.2ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2847` |
| 91.1% | 5.64s | 0.0% | 0us | `(anonymous)` | `[native code]` |
| 91.1% | 5.64s | 0.0% | 0us | `processTicksAndRejections` | `[native code]` |
| 70.1% | 4.34s | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:284` |
| 69.8% | 4.32s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8625` |
| 64.6% | 4.00s | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5356` |
| 64.6% | 4.00s | 0.0% | 0us | `_runItemsBare` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5323` |
| 64.6% | 4.00s | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8366` |
| 64.1% | 3.96s | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34670` |
| 37.3% | 2.31s | 0.0% | 1.8ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34304` |
| 35.4% | 2.19s | 0.1% | 8.1ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34203` |
| 29.6% | 1.83s | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:795` |
| 23.8% | 1.47s | 3.7% | 232.0ms | `anonymous` | `[native code]` |
| 23.6% | 1.46s | 0.0% | 0us | `bound require` | `[native code]` |
| 23.5% | 1.46s | 0.0% | 0us | `require` | `[native code]` |
| 21.8% | 1.35s | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:33` |
| 13.4% | 831.7ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:280` |
| 12.7% | 787.4ms | 0.1% | 10.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34288` |
| 12.6% | 783.3ms | 12.6% | 783.3ms | `parse` | `[native code]` |
| 12.6% | 782.0ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:239` |
| 11.8% | 736.8ms | 1.5% | 95.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4530` |
| 10.8% | 673.2ms | 0.0% | 1.3ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34214` |
| 10.7% | 663.6ms | 0.0% | 0us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3432` |
| 10.2% | 636.4ms | 1.0% | 64.0ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2813` |
| 8.6% | 533.3ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:135` |
| 8.6% | 533.3ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:54` |
| 8.6% | 533.3ms | 0.0% | 0us | `_loadBundle` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-loader.js:34` |
| 8.6% | 533.3ms | 0.0% | 0us | `bundleRulesFor` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-loader.js:59` |
| 7.8% | 486.2ms | 0.5% | 36.1ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2781` |
| 7.4% | 462.6ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:295` |
| 7.4% | 461.2ms | 0.0% | 0us | `applyDisableDirectives` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8685` |
| 7.4% | 459.8ms | 0.2% | 17.8ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3143` |
| 7.4% | 459.2ms | 0.4% | 26.0ms | `some` | `[native code]` |
| 6.7% | 417.0ms | 0.4% | 30.2ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4484` |
| 5.9% | 366.8ms | 2.6% | 161.4ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34240` |
| 5.7% | 353.0ms | 0.0% | 5.3ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1002` |
| 4.6% | 290.1ms | 4.5% | 282.4ms | `_parseDisableDirectives` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8655` |
| 4.5% | 279.6ms | 0.3% | 20.2ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2831` |
| 4.4% | 273.8ms | 0.0% | 0us | `_computeIdentifierName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4472` |
| 4.3% | 268.8ms | 0.0% | 1.4ms | `_ensureRefsThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1051` |
| 4.3% | 267.0ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1115` |
| 4.3% | 267.0ms | 0.0% | 3.1ms | `_ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1069` |
| 4.1% | 258.1ms | 0.0% | 1.7ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1099` |
| 4.0% | 250.7ms | 1.2% | 76.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3154` |
| 4.0% | 249.3ms | 0.9% | 57.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2295` |
| 3.9% | 246.9ms | 3.9% | 246.9ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:241` |
| 3.7% | 232.0ms | 0.2% | 16.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34208` |
| 3.6% | 227.8ms | 3.6% | 227.8ms | `set` | `[native code]` |
| 3.6% | 225.2ms | 0.4% | 25.6ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2910` |
| 3.6% | 223.2ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3536` |
| 3.2% | 199.4ms | 3.2% | 199.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8109` |
| 3.1% | 196.5ms | 0.0% | 3.3ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34237` |
| 3.1% | 194.5ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34133` |
| 3.1% | 192.3ms | 0.1% | 7.6ms | `get defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:880` |
| 2.7% | 173.1ms | 0.1% | 9.7ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2412` |
| 2.7% | 172.8ms | 0.8% | 52.5ms | `regExpSplitFast` | `[native code]` |
| 2.7% | 171.1ms | 0.0% | 0us | `_parseDisableDirectives` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8647` |
| 2.4% | 154.4ms | 0.0% | 3.0ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2274` |
| 2.4% | 151.7ms | 0.6% | 39.8ms | `parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1289` |
| 2.2% | 141.7ms | 1.0% | 63.9ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:913` |
| 2.1% | 132.1ms | 0.2% | 13.6ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:625` |
| 2.0% | 124.7ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3147` |
| 1.9% | 120.2ms | 1.9% | 120.2ms | `/\r?\n/` | `[native code]` |
| 1.8% | 114.4ms | 0.0% | 1.4ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3073` |
| 1.8% | 114.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313143` |
| 1.7% | 107.2ms | 0.0% | 3.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34219` |
| 1.6% | 100.9ms | 0.0% | 0us | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34200` |
| 1.5% | 98.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173303` |
| 1.5% | 98.8ms | 0.0% | 3.2ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3474` |
| 1.5% | 98.4ms | 1.0% | 63.2ms | `Set` | `[native code]` |
| 1.5% | 96.4ms | 0.0% | 0us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2101` |
| 1.5% | 94.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173275` |
| 1.5% | 94.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172457` |
| 1.5% | 94.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172599` |
| 1.4% | 92.3ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1098` |
| 1.4% | 89.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171795` |
| 1.4% | 89.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171574` |
| 1.4% | 89.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172375` |
| 1.4% | 89.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171420` |
| 1.4% | 89.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/index.js:18` |
| 1.3% | 84.8ms | 0.9% | 60.5ms | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:619` |
| 1.2% | 79.3ms | 1.2% | 79.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3512` |
| 1.2% | 78.2ms | 1.2% | 78.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 1.2% | 77.2ms | 0.0% | 3.4ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34216` |
| 1.2% | 76.5ms | 0.5% | 33.8ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:919` |
| 1.1% | 73.8ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34216` |
| 1.1% | 73.0ms | 0.0% | 0us | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34108` |
| 1.1% | 72.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313135` |
| 1.1% | 71.5ms | 1.1% | 71.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301227` |
| 1.1% | 71.3ms | 1.1% | 69.9ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34220` |
| 1.1% | 71.2ms | 1.1% | 71.2ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4417` |
| 1.1% | 71.0ms | 1.1% | 71.0ms | `getOwnPropertyDescriptor` | `[native code]` |
| 1.1% | 70.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:168184` |
| 1.1% | 70.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:168372` |
| 1.1% | 70.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/clear-caches.js:5` |
| 1.1% | 70.4ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2998` |
| 1.1% | 70.2ms | 0.0% | 4.9ms | `next` | `[native code]` |
| 1.1% | 69.1ms | 0.2% | 18.1ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2598` |
| 1.1% | 68.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/getWatchProgramsForProjects.js:45` |
| 1.0% | 67.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:4` |
| 1.0% | 67.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:48` |
| 1.0% | 67.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:30` |
| 1.0% | 65.6ms | 1.0% | 62.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34097` |
| 1.0% | 62.3ms | 0.0% | 0us | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:626` |
| 1.0% | 62.3ms | 0.5% | 35.6ms | `isLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:622` |
| 1.0% | 62.2ms | 0.9% | 60.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2501` |
| 0.9% | 59.4ms | 0.5% | 34.5ms | `arrayIteratorNextHelper` | `[native code]` |
| 0.9% | 59.4ms | 0.9% | 59.4ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2747` |
| 0.8% | 52.6ms | 0.8% | 52.6ms | `get` | `[native code]` |
| 0.8% | 52.2ms | 0.2% | 12.9ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:966` |
| 0.8% | 51.8ms | 0.8% | 51.8ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:676` |
| 0.8% | 51.5ms | 0.0% | 0us | `_computeIdentifierName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4465` |
| 0.8% | 51.5ms | 0.8% | 51.5ms | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:609` |
| 0.8% | 49.7ms | 0.0% | 3.1ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3513` |
| 0.8% | 49.7ms | 0.8% | 49.7ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.8% | 49.6ms | 0.8% | 49.6ms | `_computeIdentifierName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.7% | 48.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34204` |
| 0.7% | 48.3ms | 0.7% | 48.3ms | `_getSynth` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1031` |
| 0.7% | 47.4ms | 0.7% | 47.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2449` |
| 0.7% | 46.4ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1821` |
| 0.7% | 46.0ms | 0.1% | 11.9ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3478` |
| 0.7% | 44.9ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:251` |
| 0.7% | 44.9ms | 0.3% | 18.9ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3223` |
| 0.7% | 43.5ms | 0.0% | 1.4ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3174` |
| 0.7% | 43.4ms | 0.1% | 6.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2448` |
| 0.6% | 42.9ms | 0.6% | 42.9ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4478` |
| 0.6% | 42.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:337765` |
| 0.6% | 42.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290056` |
| 0.6% | 41.6ms | 0.4% | 25.0ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2439` |
| 0.6% | 41.3ms | 0.6% | 41.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4524` |
| 0.6% | 40.8ms | 0.0% | 6.1ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1844` |
| 0.6% | 40.6ms | 0.6% | 40.6ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4476` |
| 0.6% | 39.9ms | 0.0% | 4.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1289` |
| 0.6% | 38.5ms | 0.0% | 5.7ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3092` |
| 0.6% | 38.2ms | 0.0% | 3.0ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3476` |
| 0.6% | 37.9ms | 0.1% | 11.8ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3150` |
| 0.6% | 37.6ms | 0.2% | 13.1ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1841` |
| 0.5% | 36.6ms | 0.5% | 34.8ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3171` |
| 0.5% | 35.6ms | 0.5% | 35.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2324` |
| 0.5% | 35.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:293466` |
| 0.5% | 35.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/unsupported-api.js:14` |
| 0.5% | 35.4ms | 0.5% | 35.4ms | `_Reference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:320` |
| 0.5% | 35.4ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3196` |
| 0.5% | 35.1ms | 0.2% | 15.1ms | `from` | `[native code]` |
| 0.5% | 34.1ms | 0.5% | 34.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7785` |
| 0.5% | 33.9ms | 0.0% | 0us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34181` |
| 0.5% | 32.9ms | 0.5% | 32.9ms | `push` | `[native code]` |
| 0.5% | 32.2ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34679` |
| 0.5% | 31.9ms | 0.5% | 31.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1290` |
| 0.4% | 30.9ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4478` |
| 0.4% | 30.0ms | 0.1% | 7.4ms | `scope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:875` |
| 0.4% | 30.0ms | 0.0% | 0us | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3218` |
| 0.4% | 29.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313162` |
| 0.4% | 29.7ms | 0.0% | 0us | `fix` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34690` |
| 0.4% | 29.7ms | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4424` |
| 0.4% | 29.4ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34207` |
| 0.4% | 28.7ms | 0.0% | 1.4ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1813` |
| 0.4% | 28.7ms | 0.0% | 0us | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3228` |
| 0.4% | 28.1ms | 0.4% | 26.5ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4428` |
| 0.4% | 27.8ms | 0.4% | 27.8ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34095` |
| 0.4% | 26.8ms | 0.4% | 26.8ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:871` |
| 0.4% | 26.7ms | 0.4% | 26.7ms | `/^(?:DoWhile\|For\|ForIn\|ForOf\|While)Statement$/u` | `[native code]` |
| 0.4% | 26.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34209` |
| 0.4% | 26.2ms | 0.4% | 26.2ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.4% | 25.0ms | 0.4% | 25.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8297` |
| 0.4% | 25.0ms | 0.2% | 14.2ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3499` |
| 0.4% | 24.9ms | 0.4% | 24.9ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34087` |
| 0.4% | 24.9ms | 0.4% | 24.9ms | `typedArrayViewLength` | `[native code]` |
| 0.4% | 24.8ms | 0.3% | 20.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3173` |
| 0.3% | 24.7ms | 0.0% | 5.8ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2279` |
| 0.3% | 24.7ms | 0.1% | 6.7ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34176` |
| 0.3% | 24.6ms | 0.3% | 24.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4541` |
| 0.3% | 24.5ms | 0.3% | 24.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8111` |
| 0.3% | 24.3ms | 0.3% | 24.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2722` |
| 0.3% | 24.2ms | 0.3% | 24.2ms | `/^(?:Function(?:Declaration\|Expression)\|ArrowFunctionExpression)$/u` | `[native code]` |
| 0.3% | 24.1ms | 0.3% | 24.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2343` |
| 0.3% | 23.5ms | 0.3% | 23.5ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2907` |
| 0.3% | 22.6ms | 0.3% | 19.9ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3118` |
| 0.3% | 22.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:44` |
| 0.3% | 22.3ms | 0.2% | 12.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34240` |
| 0.3% | 21.3ms | 0.1% | 12.3ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3002` |
| 0.3% | 20.8ms | 0.3% | 20.8ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3498` |
| 0.3% | 19.8ms | 0.3% | 19.8ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4429` |
| 0.3% | 19.8ms | 0.3% | 19.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.3% | 19.7ms | 0.0% | 0us | `handleFixes` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34318` |
| 0.3% | 19.7ms | 0.3% | 19.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3057` |
| 0.3% | 19.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/clear-caches.js:6` |
| 0.3% | 19.0ms | 0.3% | 19.0ms | `values` | `[native code]` |
| 0.3% | 19.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:198766` |
| 0.2% | 18.5ms | 0.2% | 18.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2441` |
| 0.2% | 18.5ms | 0.2% | 18.5ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` |
| 0.2% | 18.4ms | 0.0% | 0us | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1729` |
| 0.2% | 18.4ms | 0.0% | 1.4ms | `map` | `[native code]` |
| 0.2% | 18.4ms | 0.0% | 1.5ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3537` |
| 0.2% | 18.1ms | 0.1% | 9.5ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3102` |
| 0.2% | 18.0ms | 0.0% | 3.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3444` |
| 0.2% | 17.0ms | 0.0% | 1.2ms | `parseModule` | `[native code]` |
| 0.2% | 17.0ms | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 0.2% | 16.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/index.js:3` |
| 0.2% | 16.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:20` |
| 0.2% | 16.8ms | 0.2% | 13.9ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34231` |
| 0.2% | 15.5ms | 0.1% | 12.1ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34197` |
| 0.2% | 15.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173302` |
| 0.2% | 14.8ms | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:581` |
| 0.2% | 14.8ms | 0.1% | 10.5ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3235` |
| 0.2% | 14.3ms | 0.0% | 1.5ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3053` |
| 0.2% | 14.1ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2289` |
| 0.2% | 13.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:25` |
| 0.2% | 13.2ms | 0.2% | 13.2ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3097` |
| 0.2% | 12.7ms | 0.0% | 0us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:609` |
| 0.2% | 12.7ms | 0.2% | 12.7ms | `decode` | `[native code]` |
| 0.2% | 12.7ms | 0.2% | 12.7ms | `subarray` | `[native code]` |
| 0.2% | 12.7ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8614` |
| 0.2% | 12.7ms | 0.2% | 12.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.2% | 12.7ms | 0.2% | 12.7ms | `_Variable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:958` |
| 0.2% | 12.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:19` |
| 0.2% | 12.6ms | 0.2% | 12.6ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4560` |
| 0.2% | 12.5ms | 0.1% | 9.2ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3484` |
| 0.1% | 12.3ms | 0.1% | 11.0ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2890` |
| 0.1% | 12.3ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8108` |
| 0.1% | 12.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/index.js:26` |
| 0.1% | 12.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/index.js:18` |
| 0.1% | 12.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/Scope.js:38` |
| 0.1% | 12.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:43` |
| 0.1% | 12.2ms | 0.1% | 12.2ms | `_getSynth` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 11.9ms | 0.0% | 2.9ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1364` |
| 0.1% | 11.8ms | 0.1% | 11.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 11.7ms | 0.1% | 11.7ms | `_computeIdentifierName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4463` |
| 0.1% | 11.7ms | 0.1% | 10.2ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2394` |
| 0.1% | 11.6ms | 0.1% | 11.6ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 11.3ms | 0.1% | 11.3ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2899` |
| 0.1% | 11.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:12` |
| 0.1% | 11.1ms | 0.1% | 8.2ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34132` |
| 0.1% | 11.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/apply-disable-directives.js:22` |
| 0.1% | 10.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/index.js:4` |
| 0.1% | 10.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/analyze.js:5` |
| 0.1% | 10.7ms | 0.1% | 10.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7771` |
| 0.1% | 10.7ms | 0.0% | 1.3ms | `exec` | `[native code]` |
| 0.1% | 10.7ms | 0.1% | 10.7ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2845` |
| 0.1% | 10.7ms | 0.1% | 10.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3022` |
| 0.1% | 10.5ms | 0.1% | 10.5ms | `parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1290` |
| 0.1% | 10.4ms | 0.1% | 10.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8293` |
| 0.1% | 10.2ms | 0.1% | 10.2ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 10.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:19` |
| 0.1% | 10.1ms | 0.1% | 10.1ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34215` |
| 0.1% | 10.1ms | 0.1% | 10.1ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 9.9ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1125` |
| 0.1% | 9.9ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1134` |
| 0.1% | 9.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/ast-converter.js:4` |
| 0.1% | 9.3ms | 0.1% | 9.3ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 9.1ms | 0.1% | 7.4ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34112` |
| 0.1% | 9.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92706` |
| 0.1% | 9.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301137` |
| 0.1% | 8.9ms | 0.1% | 8.9ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4845` |
| 0.1% | 8.9ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:490` |
| 0.1% | 8.9ms | 0.0% | 6.0ms | `parentTypeEq` | `/Users/ericsan/Development/OpenSource/Ez/js/rewrite-helpers.js:176` |
| 0.1% | 8.8ms | 0.0% | 3.0ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3172` |
| 0.1% | 8.7ms | 0.1% | 8.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2735` |
| 0.1% | 8.5ms | 0.1% | 8.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2334` |
| 0.1% | 8.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301179` |
| 0.1% | 8.3ms | 0.1% | 8.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2719` |
| 0.1% | 8.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:38` |
| 0.1% | 8.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/convert.js:41` |
| 0.1% | 8.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` |
| 0.1% | 7.9ms | 0.1% | 7.9ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2837` |
| 0.1% | 7.8ms | 0.1% | 7.8ms | `parentTypeEq` | `/Users/ericsan/Development/OpenSource/Ez/js/rewrite-helpers.js` |
| 0.1% | 7.8ms | 0.1% | 7.8ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 7.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:15` |
| 0.1% | 7.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:11` |
| 0.1% | 7.7ms | 0.0% | 1.7ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:900` |
| 0.1% | 7.6ms | 0.1% | 7.6ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7476` |
| 0.1% | 7.6ms | 0.1% | 7.6ms | `includes` | `[native code]` |
| 0.1% | 7.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/default-config.js:37` |
| 0.1% | 7.5ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1497` |
| 0.1% | 7.4ms | 0.1% | 7.4ms | `/^\s*exported\b/` | `[native code]` |
| 0.1% | 7.3ms | 0.0% | 4.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34104` |
| 0.1% | 7.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:277121` |
| 0.1% | 7.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:277097` |
| 0.1% | 7.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289719` |
| 0.1% | 7.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:276550` |
| 0.1% | 6.9ms | 0.0% | 1.4ms | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:880` |
| 0.1% | 6.9ms | 0.1% | 6.9ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` |
| 0.1% | 6.6ms | 0.1% | 6.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3175` |
| 0.1% | 6.6ms | 0.1% | 6.6ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1307` |
| 0.1% | 6.4ms | 0.1% | 6.4ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2793` |
| 0.1% | 6.3ms | 0.1% | 6.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3502` |
| 0.1% | 6.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:7` |
| 0.1% | 6.3ms | 0.1% | 6.3ms | `get eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:868` |
| 0.1% | 6.2ms | 0.0% | 3.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2222` |
| 0.0% | 6.1ms | 0.0% | 6.1ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:590` |
| 0.0% | 6.1ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:673` |
| 0.0% | 6.1ms | 0.0% | 6.1ms | `defineProperty` | `[native code]` |
| 0.0% | 6.0ms | 0.0% | 6.0ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:916` |
| 0.0% | 6.0ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2219` |
| 0.0% | 6.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92530` |
| 0.0% | 6.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92632` |
| 0.0% | 6.0ms | 0.0% | 6.0ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 5.9ms | 0.0% | 5.9ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 5.9ms | 0.0% | 5.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2717` |
| 0.0% | 5.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/index.js:3` |
| 0.0% | 5.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/index.js:12` |
| 0.0% | 5.8ms | 0.0% | 5.8ms | `typedArrayViewIsDetached` | `[native code]` |
| 0.0% | 5.7ms | 0.0% | 5.7ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 5.6ms | 0.0% | 5.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3548` |
| 0.0% | 4.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:45774` |
| 0.0% | 4.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290160` |
| 0.0% | 4.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12524` |
| 0.0% | 4.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:561` |
| 0.0% | 4.8ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:519` |
| 0.0% | 4.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:20` |
| 0.0% | 4.8ms | 0.0% | 4.8ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:593` |
| 0.0% | 4.8ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34272` |
| 0.0% | 4.8ms | 0.0% | 4.8ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3197` |
| 0.0% | 4.7ms | 0.0% | 4.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3468` |
| 0.0% | 4.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/getModifiers.js:39` |
| 0.0% | 4.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-modifiers.js:38` |
| 0.0% | 4.7ms | 0.0% | 0us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34186` |
| 0.0% | 4.7ms | 0.0% | 4.7ms | `RegExp` | `[native code]` |
| 0.0% | 4.7ms | 0.0% | 0us | `stringify` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/fast-json-stable-stringify/index.js:50` |
| 0.0% | 4.7ms | 0.0% | 4.7ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:938` |
| 0.0% | 4.6ms | 0.0% | 1.7ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34137` |
| 0.0% | 4.6ms | 0.0% | 4.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 4.6ms | 0.0% | 0us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` |
| 0.0% | 4.6ms | 0.0% | 4.6ms | `encodeInto` | `[native code]` |
| 0.0% | 4.6ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:230` |
| 0.0% | 4.6ms | 0.0% | 4.6ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:678` |
| 0.0% | 4.5ms | 0.0% | 4.5ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1814` |
| 0.0% | 4.4ms | 0.0% | 4.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2502` |
| 0.0% | 4.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:312947` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4538` |
| 0.0% | 4.3ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34241` |
| 0.0% | 4.2ms | 0.0% | 4.2ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1271` |
| 0.0% | 4.2ms | 0.0% | 0us | `getESLintCoreRule` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:174826` |
| 0.0% | 4.1ms | 0.0% | 4.1ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2785` |
| 0.0% | 4.1ms | 0.0% | 0us | `camelCase` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295657` |
| 0.0% | 4.1ms | 0.0% | 1.2ms | `filter` | `[native code]` |
| 0.0% | 4.1ms | 0.0% | 4.1ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3433` |
| 0.0% | 4.0ms | 0.0% | 4.0ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34183` |
| 0.0% | 4.0ms | 0.0% | 2.5ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4562` |
| 0.0% | 3.9ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1855` |
| 0.0% | 3.6ms | 0.0% | 3.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3440` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2438` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `get left` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2886` |
| 0.0% | 3.4ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2393` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 3.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:37` |
| 0.0% | 3.4ms | 0.0% | 0us | `splitPrefixSuffix` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295713` |
| 0.0% | 3.4ms | 0.0% | 0us | `camelCase` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295653` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:591` |
| 0.0% | 3.3ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3169` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:559` |
| 0.0% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:9` |
| 0.0% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/rules.js:3` |
| 0.0% | 3.3ms | 0.0% | 1.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2600` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3487` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2599` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:717` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.0% | 3.2ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1600` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1266` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2319` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12344` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12518` |
| 0.0% | 3.1ms | 0.0% | 0us | `node:tty` | `node:tty:6` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `toLocaleLowerCase` | `[native code]` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295659` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301215` |
| 0.0% | 3.1ms | 0.0% | 0us | `addPolyfillToken` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301175` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295677` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34119` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2904` |
| 0.0% | 3.1ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:674` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/resolveProjectList.js:10` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:53` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/tinyglobby/dist/index.cjs:27` |
| 0.0% | 3.1ms | 0.0% | 1.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3026` |
| 0.0% | 3.0ms | 0.0% | 1.3ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2859` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2208` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3486` |
| 0.0% | 3.0ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:299` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313116` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:110326` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:21` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:8` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/ClassVisitor.js:6` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4565` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138712` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313069` |
| 0.0% | 3.0ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34175` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:609` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2999` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:675` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `isRead` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_getSynth` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1030` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:906` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3190` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `get scope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:875` |
| 0.0% | 2.9ms | 0.0% | 0us | `handleFixes` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34319` |
| 0.0% | 2.9ms | 0.0% | 0us | `getTokenAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1831` |
| 0.0% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:312962` |
| 0.0% | 2.8ms | 0.0% | 0us | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34115` |
| 0.0% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:18` |
| 0.0% | 2.8ms | 0.0% | 1.4ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34187` |
| 0.0% | 2.7ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1027` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301221` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301188` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:3` |
| 0.0% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` |
| 0.0% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 2.6ms | 0.0% | 1.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2349` |
| 0.0% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/default-config.js:12` |
| 0.0% | 2.5ms | 0.0% | 1.5ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2856` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289649` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:251066` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `parentTypeEq` | `/Users/ericsan/Development/OpenSource/Ez/js/rewrite-helpers.js:164` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201894` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:187608` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:187573` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:187617` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `get defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:232263` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:232359` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289577` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.8ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3483` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `/^\s*globals?\b/` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236769` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236729` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289579` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/TypeVisitor.js:7` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/dotjs/index.js:10` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:933` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:595` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:49` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:14` |
| 0.0% | 1.7ms | 0.0% | 0us | `node:child_process` | `node:child_process:473` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `node:child_process` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `node:child_process:831` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34134` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2914` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3132` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-modifiers.js:39` |
| 0.0% | 1.7ms | 0.0% | 0us | `useColors` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12457` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `file` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `WriteStream` | `internal:fs/streams:244` |
| 0.0% | 1.7ms | 0.0% | 0us | `createDebug` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12073` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:4` |
| 0.0% | 1.7ms | 0.0% | 0us | `createToken` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/internal/re.js:50` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/internal/re.js:173` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2360` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290218` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1282` |
| 0.0% | 1.7ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34673` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:30` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:266549` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:14` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:266488` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289718` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/es2017.js:12` |
| 0.0% | 1.7ms | 0.0% | 0us | `split` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295624` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `/(\p{Lu})([\p{Lu}][\p{Ll}])/gu` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:680` |
| 0.0% | 1.7ms | 0.0% | 0us | `isReadRef` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34082` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2260` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170755` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170746` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172367` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301209` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170717` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/useProgramFromProjectService.js:5` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170978` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:22` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/useProgramFromProjectService.js:44` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172372` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/useProgramFromProjectService.js:30` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170969` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170940` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:943` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2857` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:261130` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260850` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289691` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7786` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:261194` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:58232` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:54205` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:296388` |
| 0.0% | 1.6ms | 0.0% | 0us | `node:stream` | `node:stream:2` |
| 0.0% | 1.6ms | 0.0% | 0us | `internal:fs/streams` | `internal:fs/streams:2` |
| 0.0% | 1.6ms | 0.0% | 0us | `internal:stream` | `internal:stream:2` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289502` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289779` |
| 0.0% | 1.6ms | 0.0% | 0us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34179` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1632` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-scope/dist/eslint-scope.cjs:3` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/index.js:16` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301225` |
| 0.0% | 1.6ms | 0.0% | 0us | `split` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295634` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289682` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:257753` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:257727` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:254662` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:254678` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289664` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:283480` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289746` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/eslint-utils/index.js:21` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:41` |
| 0.0% | 1.6ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8617` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164528` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164618` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164456` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313121` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `Comparator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164283` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:31` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/comparator.js:143` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:3999` |
| 0.0% | 1.6ms | 0.0% | 0us | `wordsRegexp` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:285` |
| 0.0% | 1.6ms | 0.0% | 0us | `buildUnicodeData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:3982` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:6246` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313156` |
| 0.0% | 1.6ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2927` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2410` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2264` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:119` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/index.js:3` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/lib/picomatch.js:4` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/fdir/dist/index.cjs:462` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161566` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161332` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161620` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161377` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_isSimpleRangeTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4413` |
| 0.0% | 1.6ms | 0.0% | 0us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2839` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:165588` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `mapDefined` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:2610` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92629` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290368` |
| 0.0% | 1.6ms | 0.0% | 0us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1200` |
| 0.0% | 1.6ms | 0.0% | 0us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4576` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_getSharedCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:836` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:195111` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201932` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:195121` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:195759` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:196180` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:195082` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/tsconfig-utils/dist/getParsedConfigFile.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/tsconfig-utils/dist/index.js:18` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:46` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/tsconfig-utils/dist/getParsedConfigFile.js:37` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/tsconfig-utils/dist/getParsedConfigFile.js:30` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:312951` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_NodeView_N` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:179640` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_lineAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:179651` |
| 0.0% | 1.6ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1618` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201849` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:192902` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:192937` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:192946` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201919` |
| 0.0% | 1.6ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1840` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:762` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/ast-converter.js:7` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313380` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:247418` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `nodeTypeAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4669` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289631` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:42` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:30` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:16` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173068` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173290` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173097` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173105` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `handleFixes` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34315` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:128059` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `keys` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:123510` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289560` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:225762` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:225829` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2330` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_declSymsForNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:14659` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `test` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2779` |
| 0.0% | 1.5ms | 0.0% | 0us | `_fromRunnerReport` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:204` |
| 0.0% | 1.5ms | 0.0% | 0us | `_addSchema` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:295` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4309` |
| 0.0% | 1.5ms | 0.0% | 0us | `stringify` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/fast-json-stable-stringify/index.js:33` |
| 0.0% | 1.5ms | 0.0% | 0us | `addSchema` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:137` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `stringify` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/fast-json-stable-stringify/index.js:48` |
| 0.0% | 1.5ms | 0.0% | 0us | `addMetaSchema` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:152` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:16` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:29` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3424` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92477` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92498` |
| 0.0% | 1.5ms | 0.0% | 0us | `normalize` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91330` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91331` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/dotjs/index.js:28` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rule-tester/index.js:3` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138287` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/api.js:14` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138522` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/parse-string.js:4` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:4` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/prelude-ls/lib/index.js:5` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint/plugin-kit/dist/cjs/index.cjs:3` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:22` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/parse-string.js:113` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1280` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:214106` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:325969` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/minimatch/dist/commonjs/index.js:6` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34180` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:221575` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289537` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:221528` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:105273` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:106438` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:104249` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:106851` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:103885` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109718` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:195507` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3229` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:24` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getUpperFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:612` |
| 0.0% | 1.5ms | 0.0% | 0us | `isInsideOfStorableFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34170` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4432` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7478` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8029` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:585` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290123` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8624` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201864` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201872` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:40825` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `Map` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:6` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/definition/index.js:24` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get right` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34130` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92628` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1887` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:98704` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109712` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:98391` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:98783` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183970` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183935` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183979` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201876` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:10` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `/\{\{\s*(\w+)\s*\}\}/g` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `get message` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4347` |
| 0.0% | 1.4ms | 0.0% | 0us | `_fromRunnerReport` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:207` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4539` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:622` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3270` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `internal:fs/streams` | `internal:fs/streams:252` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201885` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:185339` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:49` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get operator` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1403` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:139404` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_interopRequireDefault` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313072` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `handleFixes` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34573` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172238` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172230` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172379` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301207` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:271662` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2739` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:136000` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:136042` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:136158` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290288` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:134900` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138520` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:29594` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:134857` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/es2022.js:12` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:69` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1272` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3479` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:13` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1024` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2423` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:199323` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201949` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:199294` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:199332` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/source-code-traverser.js:12` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/esquery.js:12` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:48` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201901` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `handleFixes` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34647` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3454` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:626` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91307` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:46` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161618` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:152219` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:152915` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:152829` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:152806` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:196951` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201936` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:196986` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:196993` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:11` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/token-store/index.js:11` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:3` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/index.js:3` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js:5` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js:3` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201898` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289760` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:285978` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34116` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getOwnPropertyDescriptors` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `_getTypeProto` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4390` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4506` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1888` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1596` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:223042` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:223124` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289545` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:194224` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201928` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:194215` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:194186` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:202009` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:110324` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:95861` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96741` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:95835` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96809` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:95902` |
| 0.0% | 1.3ms | 0.0% | 0us | `constructNT` | `internal:streams/destroy:147` |
| 0.0% | 1.3ms | 0.0% | 0us | `streamConstruct` | `internal:fs/streams:102` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `internal:streams/destroy` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201910` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190784` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1830` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/eslint-utils/predicates.js:37` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:40` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/eslint-utils/index.js:19` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/index.js:17` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289563` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228571` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228730` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228470` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/analyze.js:4` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/visitor-keys/dist/index.js:6` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getLocFromIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3833` |
| 0.0% | 1.3ms | 0.0% | 0us | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4328` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8689` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:177215` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201842` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:963` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:294964` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:53717` |
| 0.0% | 1.3ms | 0.0% | 0us | `parse` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:53168` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:53544` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `SemVer` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `Comparator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:53147` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:30` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:8` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:38` |
| 0.0% | 1.3ms | 0.0% | 0us | `performProxyObjectGet` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2513` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1371` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:146427` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2854` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313089` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:142824` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `isatty` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `useColors` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:133587` |
| 0.0% | 1.3ms | 0.0% | 0us | `createDebug` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:133383` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313081` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301197` |
| 0.0% | 1.3ms | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:617` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:267051` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:272101` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3275` |
| 0.0% | 1.3ms | 0.0% | 0us | `negate` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:267056` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getDefinedMessageData` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34015` |
| 0.0% | 1.3ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34682` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313152` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:174884` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2326` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301201` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/index.js:8` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91308` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:21` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2221` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:244141` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:244069` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:244171` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:244073` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289612` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201891` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:277232` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:277307` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289720` |
| 0.0% | 1.2ms | 0.0% | 0us | `RegExpValidator` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:19019` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `dlopen` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 0us | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1698` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:216654` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289514` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:216614` |
| 0.0% | 1.2ms | 0.0% | 0us | `_getFfi` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:129` |
| 0.0% | 1.2ms | 0.0% | 0us | `isAvailable` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-source-code.js:56` |
| 0.0% | 1.2ms | 0.0% | 0us | `dlopen` | `bun:ffi:345` |
| 0.0% | 1.2ms | 0.0% | 0us | `_tryLoad` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-source-code.js:44` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1818` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4475` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/index.js:15` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:48487` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:51210` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:48407` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:47936` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:51152` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290410` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `nodeTypeAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321809` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `generateNamedReferences` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321795` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289729` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:280304` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:280231` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:280235` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:280355` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:169296` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173262` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:169312` |
| 0.0% | 1.2ms | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:587` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:169261` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1035` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_getOrBuildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6524` |
| 0.0% | 1.2ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7651` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:128019` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:169438` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173263` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290109` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:560` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:1664` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `handleFixes` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:198186` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:198192` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201944` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:21` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:271749` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:218378` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289522` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:218307` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:218453` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `replace` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4436` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:241966` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289600` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:241767` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:241535` |
| 0.0% | 1.2ms | 0.0% | 0us | `async lintSource` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:370` |
| 0.0% | 1.2ms | 0.0% | 0us | `async lintSource` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:369` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:75` |
| 0.0% | 1.2ms | 0.0% | 0us | `async _resolveConfig` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:67` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:59` |
| 0.0% | 1.2ms | 0.0% | 0us | `async _resolveConfig` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:70` |
| 0.0% | 1.2ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:50` |
| 0.0% | 1.2ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:47` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:291272` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureRefsThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1050` |
| 0.0% | 1.2ms | 0.0% | 0us | `handleFixes` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34322` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3549` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313065` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:131004` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:130970` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313483` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289592` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:309800` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:93788` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201953` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190224` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190232` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201906` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190190` |
| 0.0% | 1.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289701` |
| 0.0% | 1.0ms | 0.0% | 1.0ms | `performProxyObjectSetStrict` | `[native code]` |
| 0.0% | 1.0ms | 0.0% | 0us | `_ensureRefsThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1046` |
| 0.0% | 1.0ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.0% | 1.0ms | 0.0% | 0us | `node:events` | `node:events:9` |
| 0.0% | 1.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:11` |
| 0.0% | 1.0ms | 0.0% | 1.0ms | `toLocaleUpperCase` | `[native code]` |
| 0.0% | 1.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295688` |
| 0.0% | 1.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295660` |
| 0.0% | 1.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295680` |
| 0.0% | 999us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:180398` |
| 0.0% | 999us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:180354` |
| 0.0% | 999us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:180389` |
| 0.0% | 999us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201852` |
| 0.0% | 998us | 0.0% | 998us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3450` |

## Function Details

### `parse`
`[native code]` | Self: 12.6% (783.3ms) | Total: 12.6% (783.3ms) | Samples: 510

**Called by:**
- `parseSource` (509)
- `(anonymous)` (1)

### `_parseDisableDirectives`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8655` | Self: 4.5% (282.4ms) | Total: 4.6% (290.1ms) | Samples: 183

**Called by:**
- `applyDisableDirectives` (188)

**Calls:**
- `includes` (5)

### `_resolveUnicodeEscapes`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:241` | Self: 3.9% (246.9ms) | Total: 3.9% (246.9ms) | Samples: 163

**Called by:**
- `_computeIdentifierName` (163)

### `anonymous`
`[native code]` | Self: 3.7% (232.0ms) | Total: 23.8% (1.47s) | Samples: 152

**Called by:**
- `require` (724)
- `bound require` (5)
- `node:tty` (2)
- `node:stream` (1)
- `internal:stream` (1)
- `internal:fs/streams` (1)
- `node:fs` (1)
- `node:events` (1)

**Calls:**
- `(anonymous)` (48)
- `(anonymous)` (35)
- `(anonymous)` (29)
- `(anonymous)` (24)
- `(anonymous)` (24)
- `(anonymous)` (21)
- `(anonymous)` (19)
- `(anonymous)` (15)
- `(anonymous)` (12)
- `(anonymous)` (12)
- `(anonymous)` (11)
- `(anonymous)` (11)
- `(anonymous)` (10)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
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
- `node:tty` (2)
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
- `node:child_process` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
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
- `node:fs` (1)
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
- `internal:fs/streams` (1)
- `node:events` (1)
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
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:fs/streams` (1)

### `set`
`[native code]` | Self: 3.6% (227.8ms) | Total: 3.6% (227.8ms) | Samples: 151

**Called by:**
- `_computeDeclaredVariables` (148)
- `_ensureDeclSymIndex` (2)
- `_buildScopeVarsAndSet` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8109` | Self: 3.2% (199.4ms) | Total: 3.2% (199.4ms) | Samples: 131

**Called by:**
- `runPlugins` (131)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34240` | Self: 2.6% (161.4ms) | Total: 5.9% (366.8ms) | Samples: 106

**Called by:**
- `collectUnusedVariables` (243)

**Calls:**
- `get references` (64)
- `get references` (37)
- `some` (25)
- `get references` (5)
- `get references` (2)
- `get references` (2)
- `get references` (1)
- `get references` (1)

### `/\r?\n/`
`[native code]` | Self: 1.9% (120.2ms) | Total: 1.9% (120.2ms) | Samples: 79

**Called by:**
- `regExpSplitFast` (79)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4530` | Self: 1.5% (95.6ms) | Total: 11.8% (736.8ms) | Samples: 62

**Called by:**
- `_buildReference` (259)
- `parent` (60)
- `_computeVarDefs` (60)
- `_nodesFromRange` (26)
- `get body` (20)
- `get parent` (17)
- `get body` (16)
- `_computeVariableSynthRefs` (10)
- `_buildScope` (9)
- `_buildReference` (3)
- `_buildScope` (1)

**Calls:**
- `_NodeView_LR` (272)
- `_NodeView` (47)
- `_NodeView_LR` (28)
- `_NodeView_LR` (26)
- `_NodeView` (19)
- `_NodeView` (14)
- `_NodeView` (6)
- `_NodeView_LR` (5)
- `_NodeView_N` (1)
- `_NodeView` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3512` | Self: 1.2% (79.3ms) | Total: 1.2% (79.3ms) | Samples: 53

**Called by:**
- `getDeclaredVariables` (53)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 1.2% (78.2ms) | Total: 1.2% (78.2ms) | Samples: 53

**Called by:**
- `(anonymous)` (46)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3154` | Self: 1.2% (76.6ms) | Total: 4.0% (250.7ms) | Samples: 50

**Called by:**
- `_buildScopeRefsAndThrough` (132)
- `_buildScopeRefsAndThrough` (29)
- `_buildScopeRefsAndThrough` (1)

**Calls:**
- `_buildScope` (62)
- `_buildScope` (21)
- `_buildScope` (15)
- `_buildScope` (4)
- `_buildScope` (3)
- `_buildScope` (2)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301227` | Self: 1.1% (71.5ms) | Total: 1.1% (71.5ms) | Samples: 10

**Called by:**
- `anonymous` (10)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4417` | Self: 1.1% (71.2ms) | Total: 1.1% (71.2ms) | Samples: 47

**Called by:**
- `_nodeViewRaw` (47)

### `getOwnPropertyDescriptor`
`[native code]` | Self: 1.1% (71.0ms) | Total: 1.1% (71.0ms) | Samples: 8

**Called by:**
- `(anonymous)` (5)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34220` | Self: 1.1% (69.9ms) | Total: 1.1% (71.3ms) | Samples: 46

**Called by:**
- `collectUnusedVariables` (47)

**Calls:**
- `get` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2813` | Self: 1.0% (64.0ms) | Total: 10.2% (636.4ms) | Samples: 40

**Called by:**
- `_ensureRefsThrough` (408)

**Calls:**
- `_buildReference` (154)
- `_buildReference` (132)
- `_buildReference` (36)
- `_buildReference` (12)
- `_buildReference` (12)
- `push` (9)
- `_buildReference` (5)
- `_buildReference` (4)
- `_buildReference` (2)
- `_buildReference` (1)
- `_buildReference` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:913` | Self: 1.0% (63.9ms) | Total: 2.2% (141.7ms) | Samples: 44

**Called by:**
- `collectUnusedVariables` (64)
- `(anonymous)` (31)

**Calls:**
- `_computeVariableSynthRefs` (29)
- `_computeVariableSynthRefs` (20)
- `_computeVariableSynthRefs` (1)
- `_computeVariableSynthRefs` (1)

### `Set`
`[native code]` | Self: 1.0% (63.2ms) | Total: 1.5% (98.4ms) | Samples: 41

**Called by:**
- `_computeDeclaredVariables` (63)
- `RegExpValidator` (1)
- `(anonymous)` (1)

**Calls:**
- `next` (14)
- `values` (10)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34097` | Self: 1.0% (62.2ms) | Total: 1.0% (65.6ms) | Samples: 40

**Called by:**
- `getFunctionDefinitions` (42)

**Calls:**
- `get defs` (1)
- `get defs` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2501` | Self: 0.9% (60.5ms) | Total: 1.0% (62.2ms) | Samples: 40

**Called by:**
- `_ensureVarsSet` (41)

**Calls:**
- `set` (1)

### `isFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:619` | Self: 0.9% (60.5ms) | Total: 1.3% (84.8ms) | Samples: 40

**Called by:**
- `isInLoop` (45)
- `collectUnusedVariables` (11)

**Calls:**
- `/^(?:Function(?:Declaration\|Expression)\|ArrowFunctionExpression)$/u` (16)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2747` | Self: 0.9% (59.4ms) | Total: 0.9% (59.4ms) | Samples: 39

**Called by:**
- `_ensureRefsThrough` (39)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2295` | Self: 0.9% (57.9ms) | Total: 4.0% (249.3ms) | Samples: 37

**Called by:**
- `_buildScopeChildren` (102)
- `_buildScope` (41)
- `_buildReference` (21)
- `_precomputeScopes` (1)

**Calls:**
- `_computeIsStrict` (116)
- `_computeIsStrict` (8)
- `_computeIsStrict` (2)
- `_computeIsStrict` (1)
- `_computeIsStrict` (1)

### `get`
`[native code]` | Self: 0.8% (52.6ms) | Total: 0.8% (52.6ms) | Samples: 34

**Called by:**
- `_computeDeclaredVariables` (30)
- `_computeDeclaredVariables` (2)
- `_buildScopeRefsAndThrough` (1)
- `get` (1)

### `regExpSplitFast`
`[native code]` | Self: 0.8% (52.5ms) | Total: 2.7% (172.8ms) | Samples: 35

**Called by:**
- `_parseDisableDirectives` (113)
- `split` (1)

**Calls:**
- `/\r?\n/` (79)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:676` | Self: 0.8% (51.8ms) | Total: 0.8% (51.8ms) | Samples: 33

**Called by:**
- `_precomputeScopes` (33)

### `source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:609` | Self: 0.8% (51.5ms) | Total: 0.8% (51.5ms) | Samples: 32

**Called by:**
- `_computeIdentifierName` (32)

### `/\/\*([\s\S]*?)\*\//g`
`[native code]` | Self: 0.8% (49.7ms) | Total: 0.8% (49.7ms) | Samples: 32

**Called by:**
- `_buildScopeVarsAndSet` (26)
- `exec` (6)

### `_computeIdentifierName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.8% (49.6ms) | Total: 0.8% (49.6ms) | Samples: 33

**Called by:**
- `_NodeView_LR` (33)

### `_getSynth`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1031` | Self: 0.7% (48.3ms) | Total: 0.7% (48.3ms) | Samples: 33

**Called by:**
- `init` (19)
- `get body` (14)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2449` | Self: 0.7% (47.4ms) | Total: 0.7% (47.4ms) | Samples: 31

**Called by:**
- `_ensureVarsSet` (31)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4478` | Self: 0.6% (42.9ms) | Total: 0.6% (42.9ms) | Samples: 28

**Called by:**
- `_nodeViewRaw` (28)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4524` | Self: 0.6% (41.3ms) | Total: 0.6% (41.3ms) | Samples: 27

**Called by:**
- `_buildReference` (12)
- `parent` (8)
- `get body` (3)
- `get parent` (2)
- `_buildReference` (1)
- `_computeVariableSynthRefs` (1)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4476` | Self: 0.6% (40.6ms) | Total: 0.6% (40.6ms) | Samples: 26

**Called by:**
- `_nodeViewRaw` (26)

### `parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1289` | Self: 0.6% (39.8ms) | Total: 2.4% (151.7ms) | Samples: 26

**Called by:**
- `_buildReference` (75)
- `isForInOfRef` (21)
- `isUnusedExpression` (2)
- `_findDefNode` (2)

**Calls:**
- `_nodeViewRaw` (60)
- `_nodeViewRaw` (8)
- `nodeView` (2)
- `nodeView` (1)
- `_nodeViewRaw` (1)
- `nodeView` (1)
- `nodeView` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2781` | Self: 0.5% (36.1ms) | Total: 7.8% (486.2ms) | Samples: 23

**Called by:**
- `_ensureRefsThrough` (321)

**Calls:**
- `_buildReference` (142)
- `_buildReference` (45)
- `_buildReference` (29)
- `_buildReference` (20)
- `_buildReference` (19)
- `_buildReference` (17)
- `_buildReference` (10)
- `_buildReference` (7)
- `_buildReference` (5)
- `_buildReference` (2)
- `_buildReference` (1)
- `_buildReference` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2324` | Self: 0.5% (35.6ms) | Total: 0.5% (35.6ms) | Samples: 23

**Called by:**
- `_buildScopeChildren` (9)
- `_buildScope` (8)
- `_buildReference` (4)
- `_computeVarScope` (2)

### `isLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:622` | Self: 0.5% (35.6ms) | Total: 1.0% (62.3ms) | Samples: 24

**Called by:**
- `isInLoop` (42)

**Calls:**
- `/^(?:DoWhile\|For\|ForIn\|ForOf\|While)Statement$/u` (18)

### `_Reference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:320` | Self: 0.5% (35.4ms) | Total: 0.5% (35.4ms) | Samples: 22

**Called by:**
- `_buildReference` (22)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3171` | Self: 0.5% (34.8ms) | Total: 0.5% (36.6ms) | Samples: 23

**Called by:**
- `_buildScopeRefsAndThrough` (12)
- `_buildScopeRefsAndThrough` (7)
- `get references` (5)

**Calls:**
- `get left` (1)

### `arrayIteratorNextHelper`
`[native code]` | Self: 0.5% (34.5ms) | Total: 0.9% (59.4ms) | Samples: 23

**Called by:**
- `next` (39)

**Calls:**
- `typedArrayViewLength` (16)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7785` | Self: 0.5% (34.1ms) | Total: 0.5% (34.1ms) | Samples: 22

**Called by:**
- `runPlugins` (22)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:919` | Self: 0.5% (33.8ms) | Total: 1.2% (76.5ms) | Samples: 21

**Called by:**
- `collectUnusedVariables` (37)
- `(anonymous)` (12)

**Calls:**
- `_buildReference` (9)
- `_buildReference` (5)
- `_buildReference` (5)
- `_buildReference` (4)
- `_buildReference` (3)
- `_buildReference` (1)
- `_buildReference` (1)

### `push`
`[native code]` | Self: 0.5% (32.9ms) | Total: 0.5% (32.9ms) | Samples: 21

**Called by:**
- `_computeDeclaredVariables` (11)
- `_buildScopeRefsAndThrough` (9)
- `_buildScopeRefsAndThrough` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1290` | Self: 0.5% (31.9ms) | Total: 0.5% (31.9ms) | Samples: 20

**Called by:**
- `isInLoop` (20)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4484` | Self: 0.4% (30.2ms) | Total: 6.7% (417.0ms) | Samples: 19

**Called by:**
- `_nodeViewRaw` (272)

**Calls:**
- `_computeIdentifierName` (180)
- `_computeIdentifierName` (33)
- `_computeIdentifierName` (32)
- `_computeIdentifierName` (8)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34095` | Self: 0.4% (27.8ms) | Total: 0.4% (27.8ms) | Samples: 18

**Called by:**
- `isUsedVariable` (18)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:871` | Self: 0.4% (26.8ms) | Total: 0.4% (26.8ms) | Samples: 17

**Called by:**
- `_computeIdentifierName` (17)

### `/^(?:DoWhile\|For\|ForIn\|ForOf\|While)Statement$/u`
`[native code]` | Self: 0.4% (26.7ms) | Total: 0.4% (26.7ms) | Samples: 18

**Called by:**
- `isLoop` (18)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4428` | Self: 0.4% (26.5ms) | Total: 0.4% (28.1ms) | Samples: 18

**Called by:**
- `_nodeViewRaw` (19)

**Calls:**
- `_isSimpleRangeTag` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.4% (26.2ms) | Total: 0.4% (26.2ms) | Samples: 17

**Called by:**
- `_buildReference` (12)
- `_buildScopeVarsAndSet` (3)
- `_computeDeclaredVariables` (2)

### `some`
`[native code]` | Self: 0.4% (26.0ms) | Total: 7.4% (459.2ms) | Samples: 18

**Called by:**
- `isUsedVariable` (229)
- `isAfterLastUsedArg` (48)
- `collectUnusedVariables` (25)

**Calls:**
- `(anonymous)` (152)
- `(anonymous)` (48)
- `(anonymous)` (32)
- `(anonymous)` (19)
- `(anonymous)` (18)
- `(anonymous)` (15)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2910` | Self: 0.4% (25.6ms) | Total: 3.6% (225.2ms) | Samples: 17

**Called by:**
- `_ensureChildren` (150)

**Calls:**
- `_buildScope` (102)
- `_buildScope` (9)
- `_buildScope` (9)
- `_buildScope` (4)
- `_buildScope` (3)
- `_buildScope` (3)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8297` | Self: 0.4% (25.0ms) | Total: 0.4% (25.0ms) | Samples: 16

**Called by:**
- `runPlugins` (16)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2439` | Self: 0.4% (25.0ms) | Total: 0.6% (41.6ms) | Samples: 16

**Called by:**
- `_ensureVarsSet` (27)

**Calls:**
- `_ensureDeclSymIndex` (4)
- `_ensureDeclSymIndex` (4)
- `_ensureDeclSymIndex` (2)
- `_ensureDeclSymIndex` (1)

### `isSelfReference`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34087` | Self: 0.4% (24.9ms) | Total: 0.4% (24.9ms) | Samples: 17

**Called by:**
- `(anonymous)` (17)

### `typedArrayViewLength`
`[native code]` | Self: 0.4% (24.9ms) | Total: 0.4% (24.9ms) | Samples: 16

**Called by:**
- `arrayIteratorNextHelper` (16)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4541` | Self: 0.3% (24.6ms) | Total: 0.3% (24.6ms) | Samples: 16

**Called by:**
- `_computeVariableSynthRefs` (5)
- `_computeVarDefs` (3)
- `get parent` (3)
- `init` (2)
- `_buildReference` (2)
- `parent` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8111` | Self: 0.3% (24.5ms) | Total: 0.3% (24.5ms) | Samples: 17

**Called by:**
- `runPlugins` (17)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2722` | Self: 0.3% (24.3ms) | Total: 0.3% (24.3ms) | Samples: 16

**Called by:**
- `_ensureVarsSet` (16)

### `/^(?:Function(?:Declaration\|Expression)\|ArrowFunctionExpression)$/u`
`[native code]` | Self: 0.3% (24.2ms) | Total: 0.3% (24.2ms) | Samples: 16

**Called by:**
- `isFunction` (16)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2343` | Self: 0.3% (24.1ms) | Total: 0.3% (24.1ms) | Samples: 15

**Called by:**
- `_buildReference` (15)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2907` | Self: 0.3% (23.5ms) | Total: 0.3% (23.5ms) | Samples: 16

**Called by:**
- `_ensureChildren` (16)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3498` | Self: 0.3% (20.8ms) | Total: 0.3% (20.8ms) | Samples: 14

**Called by:**
- `getDeclaredVariables` (14)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3173` | Self: 0.3% (20.5ms) | Total: 0.4% (24.8ms) | Samples: 14

**Called by:**
- `_buildScopeRefsAndThrough` (17)

**Calls:**
- `get id` (2)
- `_nodeViewRaw` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2831` | Self: 0.3% (20.2ms) | Total: 4.5% (279.6ms) | Samples: 13

**Called by:**
- `_ensureRefsThrough` (182)

**Calls:**
- `get` (168)
- `performProxyObjectGet` (1)

### `_computeVarScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3118` | Self: 0.3% (19.9ms) | Total: 0.3% (22.6ms) | Samples: 13

**Called by:**
- `scope` (15)

**Calls:**
- `_buildScope` (2)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4429` | Self: 0.3% (19.8ms) | Total: 0.3% (19.8ms) | Samples: 14

**Called by:**
- `_nodeViewRaw` (14)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.3% (19.8ms) | Total: 0.3% (19.8ms) | Samples: 14

**Called by:**
- `_computeVarDefs` (9)
- `_buildScope` (3)
- `_buildReference` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3057` | Self: 0.3% (19.7ms) | Total: 0.3% (19.7ms) | Samples: 13

**Called by:**
- `_buildScopeVarsAndSet` (9)
- `_computeDeclaredVariables` (4)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2847` | Self: 0.3% (19.2ms) | Total: 100.0% (8.51s) | Samples: 12

**Called by:**
- `_ensureRefsThrough` (5556)

**Calls:**
- `_ensureRefsThrough` (5365)
- `_ensureRefsThrough` (179)

### `values`
`[native code]` | Self: 0.3% (19.0ms) | Total: 0.3% (19.0ms) | Samples: 13

**Called by:**
- `Set` (10)
- `_computeDeclaredVariables` (2)
- `from` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3223` | Self: 0.3% (18.9ms) | Total: 0.7% (44.9ms) | Samples: 12

**Called by:**
- `get references` (29)

**Calls:**
- `_nodeViewRaw` (10)
- `_nodeViewRaw` (5)
- `_nodeViewRaw` (1)
- `nodeView` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2441` | Self: 0.2% (18.5ms) | Total: 0.2% (18.5ms) | Samples: 12

**Called by:**
- `_ensureVarsSet` (12)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` | Self: 0.2% (18.5ms) | Total: 0.2% (18.5ms) | Samples: 12

**Called by:**
- `parseSource` (12)

### `_ensureRefsThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1052` | Self: 0.2% (18.3ms) | Total: 100.0% (10.06s) | Samples: 13

**Called by:**
- `_buildScopeRefsAndThrough` (5365)
- `get` (1198)

**Calls:**
- `_buildScopeRefsAndThrough` (5556)
- `_buildScopeRefsAndThrough` (408)
- `_buildScopeRefsAndThrough` (321)
- `_buildScopeRefsAndThrough` (182)
- `_buildScopeRefsAndThrough` (39)
- `_buildScopeRefsAndThrough` (8)
- `_buildScopeRefsAndThrough` (7)
- `_buildScopeRefsAndThrough` (7)
- `_buildScopeRefsAndThrough` (5)
- `_buildScopeRefsAndThrough` (4)
- `_buildScopeRefsAndThrough` (3)
- `_buildScopeRefsAndThrough` (2)
- `_buildScopeRefsAndThrough` (2)
- `_buildScopeRefsAndThrough` (2)
- `_buildScopeRefsAndThrough` (1)
- `_buildScopeRefsAndThrough` (1)
- `_buildScopeRefsAndThrough` (1)
- `_buildScopeRefsAndThrough` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2598` | Self: 0.2% (18.1ms) | Total: 1.1% (69.1ms) | Samples: 12

**Called by:**
- `_ensureVarsSet` (45)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (26)
- `exec` (7)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3143` | Self: 0.2% (17.8ms) | Total: 7.4% (459.8ms) | Samples: 12

**Called by:**
- `_buildScopeRefsAndThrough` (154)
- `_buildScopeRefsAndThrough` (142)
- `get references` (5)

**Calls:**
- `_nodeViewRaw` (259)
- `_nodeViewRaw` (12)
- `nodeView` (6)
- `nodeView` (4)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (2)
- `nodeView` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34208` | Self: 0.2% (16.7ms) | Total: 3.7% (232.0ms) | Samples: 11

**Called by:**
- `some` (152)

**Calls:**
- `getRhsNode` (128)
- `getRhsNode` (7)
- `getRhsNode` (3)
- `getRhsNode` (1)
- `getRhsNode` (1)
- `getRhsNode` (1)

### `from`
`[native code]` | Self: 0.2% (15.1ms) | Total: 0.5% (35.1ms) | Samples: 10

**Called by:**
- `_computeDeclaredVariables` (23)

**Calls:**
- `next` (12)
- `values` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3499` | Self: 0.2% (14.2ms) | Total: 0.4% (25.0ms) | Samples: 9

**Called by:**
- `getDeclaredVariables` (16)

**Calls:**
- `_buildVariable` (4)
- `_buildVariable` (2)
- `_buildVariable` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34231` | Self: 0.2% (13.9ms) | Total: 0.2% (16.8ms) | Samples: 9

**Called by:**
- `collectUnusedVariables` (11)

**Calls:**
- `get eslintUsed` (2)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:625` | Self: 0.2% (13.6ms) | Total: 2.1% (132.1ms) | Samples: 9

**Called by:**
- `getRhsNode` (86)

**Calls:**
- `isFunction` (45)
- `get parent` (20)
- `get parent` (12)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3097` | Self: 0.2% (13.2ms) | Total: 0.2% (13.2ms) | Samples: 9

**Called by:**
- `get defs` (9)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1841` | Self: 0.2% (13.1ms) | Total: 0.6% (37.6ms) | Samples: 9

**Called by:**
- `_computeIsStrict` (25)

**Calls:**
- `_nodeViewRaw` (16)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:966` | Self: 0.2% (12.9ms) | Total: 0.8% (52.2ms) | Samples: 9

**Called by:**
- `get body` (30)
- `get body` (3)
- `get value` (2)

**Calls:**
- `_nodeViewRaw` (26)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34240` | Self: 0.2% (12.9ms) | Total: 0.3% (22.3ms) | Samples: 9

**Called by:**
- `some` (15)

**Calls:**
- `parentTypeEq` (5)
- `parentTypeEq` (1)

### `decode`
`[native code]` | Self: 0.2% (12.7ms) | Total: 0.2% (12.7ms) | Samples: 8

**Called by:**
- `get source` (8)

### `subarray`
`[native code]` | Self: 0.2% (12.7ms) | Total: 0.2% (12.7ms) | Samples: 8

**Called by:**
- `_computeDeclaredVariables` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` | Self: 0.2% (12.7ms) | Total: 0.2% (12.7ms) | Samples: 8

**Called by:**
- `(anonymous)` (7)
- `(anonymous)` (1)

### `_Variable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:958` | Self: 0.2% (12.7ms) | Total: 0.2% (12.7ms) | Samples: 8

**Called by:**
- `_buildVariable` (8)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4560` | Self: 0.2% (12.6ms) | Total: 0.2% (12.6ms) | Samples: 8

**Called by:**
- `_buildReference` (6)
- `_computeVariableSynthRefs` (1)
- `parent` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3002` | Self: 0.1% (12.3ms) | Total: 0.3% (21.3ms) | Samples: 8

**Called by:**
- `getScope` (14)

**Calls:**
- `/^\s*exported\b/` (5)
- `test` (1)

### `_getSynth`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (12.2ms) | Total: 0.1% (12.2ms) | Samples: 8

**Called by:**
- `get body` (5)
- `get value` (3)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34197` | Self: 0.1% (12.1ms) | Total: 0.2% (15.5ms) | Samples: 8

**Called by:**
- `collectUnusedVariables` (10)

**Calls:**
- `get eslintUsed` (2)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3478` | Self: 0.1% (11.9ms) | Total: 0.7% (46.0ms) | Samples: 8

**Called by:**
- `getDeclaredVariables` (30)

**Calls:**
- `next` (20)
- `values` (2)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (11.8ms) | Total: 0.1% (11.8ms) | Samples: 8

**Called by:**
- `_computeVarDefs` (3)
- `isReadForItself` (2)
- `isForInOfRef` (1)
- `isForInOfRef` (1)
- `_computeIsStrict` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3150` | Self: 0.1% (11.8ms) | Total: 0.6% (37.9ms) | Samples: 7

**Called by:**
- `_buildScopeRefsAndThrough` (19)
- `_buildScopeRefsAndThrough` (5)

**Calls:**
- `_buildVariable` (12)
- `_buildVariable` (3)
- `_buildVariable` (2)

### `_computeIdentifierName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4463` | Self: 0.1% (11.7ms) | Total: 0.1% (11.7ms) | Samples: 8

**Called by:**
- `_NodeView_LR` (8)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (11.6ms) | Total: 0.1% (11.6ms) | Samples: 8

**Called by:**
- `collectUnusedVariables` (5)
- `(anonymous)` (3)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2899` | Self: 0.1% (11.3ms) | Total: 0.1% (11.3ms) | Samples: 7

**Called by:**
- `_ensureRefsThrough` (7)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2890` | Self: 0.1% (11.0ms) | Total: 0.1% (12.3ms) | Samples: 7

**Called by:**
- `_ensureRefsThrough` (8)

**Calls:**
- `get` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7771` | Self: 0.1% (10.7ms) | Total: 0.1% (10.7ms) | Samples: 7

**Called by:**
- `runPlugins` (7)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2845` | Self: 0.1% (10.7ms) | Total: 0.1% (10.7ms) | Samples: 7

**Called by:**
- `_ensureRefsThrough` (7)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3022` | Self: 0.1% (10.7ms) | Total: 0.1% (10.7ms) | Samples: 7

**Called by:**
- `_buildScopeVarsAndSet` (5)
- `_buildReference` (2)

### `parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1290` | Self: 0.1% (10.5ms) | Total: 0.1% (10.5ms) | Samples: 7

**Called by:**
- `_findDefNode` (5)
- `_buildReference` (2)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3235` | Self: 0.1% (10.5ms) | Total: 0.2% (14.8ms) | Samples: 7

**Called by:**
- `_buildReference` (10)

**Calls:**
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34288` | Self: 0.1% (10.5ms) | Total: 12.7% (787.4ms) | Samples: 7

**Called by:**
- `collectUnusedVariables` (518)

**Calls:**
- `isAfterLastUsedArg` (443)
- `isAfterLastUsedArg` (50)
- `isFunction` (11)
- `isAfterLastUsedArg` (7)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8293` | Self: 0.1% (10.4ms) | Total: 0.1% (10.4ms) | Samples: 7

**Called by:**
- `runPlugins` (7)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (10.2ms) | Total: 0.1% (10.2ms) | Samples: 6

**Called by:**
- `_nodeViewRaw` (6)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2394` | Self: 0.1% (10.2ms) | Total: 0.1% (11.7ms) | Samples: 7

**Called by:**
- `_buildScope` (8)

**Calls:**
- `get parent` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34215` | Self: 0.1% (10.1ms) | Total: 0.1% (10.1ms) | Samples: 7

**Called by:**
- `collectUnusedVariables` (7)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (10.1ms) | Total: 0.1% (10.1ms) | Samples: 7

**Called by:**
- `_ensureChildren` (7)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2412` | Self: 0.1% (9.7ms) | Total: 2.7% (173.1ms) | Samples: 6

**Called by:**
- `_buildScope` (116)

**Calls:**
- `get body` (31)
- `get body` (27)
- `get body` (25)
- `get body` (18)
- `get body` (3)
- `get body` (3)
- `get body` (1)
- `get body` (1)
- `get body` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3102` | Self: 0.1% (9.5ms) | Total: 0.2% (18.1ms) | Samples: 6

**Called by:**
- `get defs` (10)
- `defs` (2)

**Calls:**
- `get parent` (3)
- `get parent` (2)
- `get parent` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (9.3ms) | Total: 0.1% (9.3ms) | Samples: 6

**Called by:**
- `_buildReference` (4)
- `parent` (2)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3484` | Self: 0.1% (9.2ms) | Total: 0.2% (12.5ms) | Samples: 6

**Called by:**
- `getDeclaredVariables` (8)

**Calls:**
- `get` (2)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4845` | Self: 0.1% (8.9ms) | Total: 0.1% (8.9ms) | Samples: 2

**Called by:**
- `AstView` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2735` | Self: 0.1% (8.7ms) | Total: 0.1% (8.7ms) | Samples: 6

**Called by:**
- `_ensureVarsSet` (6)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2334` | Self: 0.1% (8.5ms) | Total: 0.1% (8.5ms) | Samples: 6

**Called by:**
- `_buildReference` (3)
- `_buildScopeChildren` (3)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2719` | Self: 0.1% (8.3ms) | Total: 0.1% (8.3ms) | Samples: 5

**Called by:**
- `_ensureVarsSet` (5)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34132` | Self: 0.1% (8.2ms) | Total: 0.1% (11.1ms) | Samples: 5

**Called by:**
- `(anonymous)` (7)

**Calls:**
- `get scope` (2)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34203` | Self: 0.1% (8.1ms) | Total: 35.4% (2.19s) | Samples: 5

**Called by:**
- `collectUnusedVariables` (1433)

**Calls:**
- `get` (1199)
- `some` (229)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2837` | Self: 0.1% (7.9ms) | Total: 0.1% (7.9ms) | Samples: 5

**Called by:**
- `_ensureRefsThrough` (5)

### `parentTypeEq`
`/Users/ericsan/Development/OpenSource/Ez/js/rewrite-helpers.js` | Self: 0.1% (7.8ms) | Total: 0.1% (7.8ms) | Samples: 5

**Called by:**
- `collectUnusedVariables` (3)
- `collectUnusedVariables` (2)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (7.8ms) | Total: 0.1% (7.8ms) | Samples: 5

**Called by:**
- `_nodeViewRaw` (5)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7476` | Self: 0.1% (7.6ms) | Total: 0.1% (7.6ms) | Samples: 5

**Called by:**
- `walkNodes` (5)

### `includes`
`[native code]` | Self: 0.1% (7.6ms) | Total: 0.1% (7.6ms) | Samples: 5

**Called by:**
- `_parseDisableDirectives` (5)

### `get defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:880` | Self: 0.1% (7.6ms) | Total: 3.1% (192.3ms) | Samples: 5

**Called by:**
- `collectUnusedVariables` (124)
- `Program:exit` (1)
- `(anonymous)` (1)

**Calls:**
- `_computeVarDefs` (72)
- `_computeVarDefs` (26)
- `_computeVarDefs` (10)
- `_computeVarDefs` (9)
- `_computeVarDefs` (4)

### `isInside`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34112` | Self: 0.1% (7.4ms) | Total: 0.1% (9.1ms) | Samples: 5

**Called by:**
- `isReadForItself` (5)
- `getRhsNode` (1)

**Calls:**
- `get range` (1)

### `scope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:875` | Self: 0.1% (7.4ms) | Total: 0.4% (30.0ms) | Samples: 5

**Called by:**
- `_computeVariableSynthRefs` (20)

**Calls:**
- `_computeVarScope` (15)

### `/^\s*exported\b/`
`[native code]` | Self: 0.1% (7.4ms) | Total: 0.1% (7.4ms) | Samples: 5

**Called by:**
- `_precomputeScopes` (5)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` | Self: 0.1% (6.9ms) | Total: 0.1% (6.9ms) | Samples: 5

**Called by:**
- `_buildScopeRefsAndThrough` (5)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34176` | Self: 0.1% (6.7ms) | Total: 0.3% (24.7ms) | Samples: 4

**Called by:**
- `(anonymous)` (16)

**Calls:**
- `isInside` (5)
- `isUnusedExpression` (2)
- `get operator` (1)
- `isInsideOfStorableFunction` (1)
- `isRead` (1)
- `get left` (1)
- `isUnusedExpression` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3175` | Self: 0.1% (6.6ms) | Total: 0.1% (6.6ms) | Samples: 4

**Called by:**
- `get references` (4)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1307` | Self: 0.1% (6.6ms) | Total: 0.1% (6.6ms) | Samples: 4

**Called by:**
- `getTokenBefore` (4)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2793` | Self: 0.1% (6.4ms) | Total: 0.1% (6.4ms) | Samples: 4

**Called by:**
- `_ensureRefsThrough` (4)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3502` | Self: 0.1% (6.3ms) | Total: 0.1% (6.3ms) | Samples: 4

**Called by:**
- `getDeclaredVariables` (4)

### `get eslintUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:868` | Self: 0.1% (6.3ms) | Total: 0.1% (6.3ms) | Samples: 4

**Called by:**
- `collectUnusedVariables` (2)
- `isUsedVariable` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2448` | Self: 0.1% (6.2ms) | Total: 0.7% (43.4ms) | Samples: 4

**Called by:**
- `_ensureVarsSet` (28)

**Calls:**
- `_buildVariable` (9)
- `_buildVariable` (5)
- `_buildVariable` (5)
- `_buildVariable` (3)
- `_buildVariable` (2)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:590` | Self: 0.0% (6.1ms) | Total: 0.0% (6.1ms) | Samples: 4

**Called by:**
- `parseSource` (4)

### `defineProperty`
`[native code]` | Self: 0.0% (6.1ms) | Total: 0.0% (6.1ms) | Samples: 4

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1844` | Self: 0.0% (6.1ms) | Total: 0.6% (40.8ms) | Samples: 4

**Called by:**
- `_computeIsStrict` (27)

**Calls:**
- `_nodeViewRaw` (20)
- `_nodeViewRaw` (3)

### `parentTypeEq`
`/Users/ericsan/Development/OpenSource/Ez/js/rewrite-helpers.js:176` | Self: 0.0% (6.0ms) | Total: 0.1% (8.9ms) | Samples: 4

**Called by:**
- `(anonymous)` (5)
- `collectUnusedVariables` (1)

**Calls:**
- `nodeTypeAt` (1)
- `nodeTypeAt` (1)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:916` | Self: 0.0% (6.0ms) | Total: 0.0% (6.0ms) | Samples: 4

**Called by:**
- `_symName` (4)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (6.0ms) | Total: 0.0% (6.0ms) | Samples: 4

**Called by:**
- `_computeVarDefs` (4)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (5.9ms) | Total: 0.0% (5.9ms) | Samples: 4

**Called by:**
- `commentsInRange` (2)
- `commentsInRange` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2717` | Self: 0.0% (5.9ms) | Total: 0.0% (5.9ms) | Samples: 4

**Called by:**
- `_ensureVarsSet` (4)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2279` | Self: 0.0% (5.8ms) | Total: 0.3% (24.7ms) | Samples: 4

**Called by:**
- `_buildScopeChildren` (9)
- `_buildScope` (5)
- `_buildReference` (2)

**Calls:**
- `_nodeViewRaw` (9)
- `_nodeViewRaw` (3)

### `typedArrayViewIsDetached`
`[native code]` | Self: 0.0% (5.8ms) | Total: 0.0% (5.8ms) | Samples: 4

**Called by:**
- `next` (4)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (5.7ms) | Total: 0.0% (5.7ms) | Samples: 4

**Called by:**
- `get defs` (4)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3092` | Self: 0.0% (5.7ms) | Total: 0.6% (38.5ms) | Samples: 4

**Called by:**
- `get defs` (26)

**Calls:**
- `_findDefNode` (10)
- `_findDefNode` (4)
- `_findDefNode` (2)
- `_findDefNode` (2)
- `_findDefNode` (1)
- `_findDefNode` (1)
- `_findDefNode` (1)
- `_findDefNode` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3548` | Self: 0.0% (5.6ms) | Total: 0.0% (5.6ms) | Samples: 4

**Called by:**
- `getDeclaredVariables` (3)
- `isAfterLastUsedArg` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1002` | Self: 0.0% (5.3ms) | Total: 5.7% (353.0ms) | Samples: 4

**Called by:**
- `get` (167)
- `get` (60)
- `_ensureVarsSet` (3)

**Calls:**
- `_buildScopeVarsAndSet` (45)
- `_buildScopeVarsAndSet` (41)
- `_buildScopeVarsAndSet` (31)
- `_buildScopeVarsAndSet` (28)
- `_buildScopeVarsAndSet` (27)
- `_buildScopeVarsAndSet` (16)
- `_buildScopeVarsAndSet` (12)
- `_buildScopeVarsAndSet` (6)
- `_buildScopeVarsAndSet` (5)
- `_buildScopeVarsAndSet` (4)
- `_buildScopeVarsAndSet` (3)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)

### `next`
`[native code]` | Self: 0.0% (4.9ms) | Total: 1.1% (70.2ms) | Samples: 3

**Called by:**
- `_computeDeclaredVariables` (20)
- `Set` (14)
- `from` (12)

**Calls:**
- `arrayIteratorNextHelper` (39)
- `typedArrayViewIsDetached` (4)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:593` | Self: 0.0% (4.8ms) | Total: 0.0% (4.8ms) | Samples: 3

**Called by:**
- `parseSource` (3)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3197` | Self: 0.0% (4.8ms) | Total: 0.0% (4.8ms) | Samples: 3

**Called by:**
- `get references` (3)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3468` | Self: 0.0% (4.7ms) | Total: 0.0% (4.7ms) | Samples: 3

**Called by:**
- `getDeclaredVariables` (3)

### `RegExp`
`[native code]` | Self: 0.0% (4.7ms) | Total: 0.0% (4.7ms) | Samples: 3

**Called by:**
- `wordsRegexp` (1)
- `createToken` (1)
- `(anonymous)` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:938` | Self: 0.0% (4.7ms) | Total: 0.0% (4.7ms) | Samples: 3

**Called by:**
- `collectUnusedVariables` (2)
- `(anonymous)` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (4.6ms) | Total: 0.0% (4.6ms) | Samples: 3

**Called by:**
- `_buildScopeChildren` (3)

### `encodeInto`
`[native code]` | Self: 0.0% (4.6ms) | Total: 0.0% (4.6ms) | Samples: 3

**Called by:**
- `_encodeSource` (3)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:678` | Self: 0.0% (4.6ms) | Total: 0.0% (4.6ms) | Samples: 3

**Called by:**
- `_precomputeScopes` (3)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1814` | Self: 0.0% (4.5ms) | Total: 0.0% (4.5ms) | Samples: 3

**Called by:**
- `_computeIsStrict` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34104` | Self: 0.0% (4.4ms) | Total: 0.1% (7.3ms) | Samples: 3

**Called by:**
- `getFunctionDefinitions` (5)

**Calls:**
- `init` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2502` | Self: 0.0% (4.4ms) | Total: 0.0% (4.4ms) | Samples: 3

**Called by:**
- `_ensureVarsSet` (3)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4538` | Self: 0.0% (4.3ms) | Total: 0.0% (4.3ms) | Samples: 3

**Called by:**
- `_buildReference` (2)
- `_computeVarDefs` (1)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1271` | Self: 0.0% (4.2ms) | Total: 0.0% (4.2ms) | Samples: 3

**Called by:**
- `_makeToken` (3)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2785` | Self: 0.0% (4.1ms) | Total: 0.0% (4.1ms) | Samples: 3

**Called by:**
- `_ensureRefsThrough` (3)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3433` | Self: 0.0% (4.1ms) | Total: 0.0% (4.1ms) | Samples: 3

**Called by:**
- `isAfterLastUsedArg` (3)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34183` | Self: 0.0% (4.0ms) | Total: 0.0% (4.0ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1289` | Self: 0.0% (4.0ms) | Total: 0.6% (39.9ms) | Samples: 3

**Called by:**
- `isInLoop` (12)
- `_buildReference` (7)
- `_computeVarDefs` (2)
- `_findDefNode` (2)
- `_computeIsStrict` (1)
- `_findDefNode` (1)
- `_computeIsStrict` (1)

**Calls:**
- `_nodeViewRaw` (17)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (2)
- `nodeView` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3444` | Self: 0.0% (3.7ms) | Total: 0.2% (18.0ms) | Samples: 3

**Called by:**
- `getDeclaredVariables` (12)

**Calls:**
- `subarray` (8)
- `_declSymsForNode` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3440` | Self: 0.0% (3.6ms) | Total: 0.0% (3.6ms) | Samples: 2

**Called by:**
- `getDeclaredVariables` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2438` | Self: 0.0% (3.5ms) | Total: 0.0% (3.5ms) | Samples: 2

**Called by:**
- `_ensureVarsSet` (2)

### `get left`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (3.4ms) | Total: 0.0% (3.4ms) | Samples: 2

**Called by:**
- `isReadForItself` (1)
- `_buildReference` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2886` | Self: 0.0% (3.4ms) | Total: 0.0% (3.4ms) | Samples: 2

**Called by:**
- `_ensureRefsThrough` (2)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (3.4ms) | Total: 0.0% (3.4ms) | Samples: 2

**Called by:**
- `_ensureRefsThrough` (1)
- `collectUnusedVariables` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34216` | Self: 0.0% (3.4ms) | Total: 1.2% (77.2ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (50)

**Calls:**
- `some` (48)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2222` | Self: 0.0% (3.3ms) | Total: 0.1% (6.2ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (4)

**Calls:**
- `set` (2)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `_buildScopeRefsAndThrough` (1)
- `get references` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:591` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `_computeVarDefs` (2)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:559` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `parseSource` (2)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3487` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `getDeclaredVariables` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2599` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `_ensureVarsSet` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34237` | Self: 0.0% (3.3ms) | Total: 3.1% (196.5ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (128)
- `Program:exit` (1)

**Calls:**
- `get defs` (124)
- `defs` (3)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:717` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `commentsInRange` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34219` | Self: 0.0% (3.2ms) | Total: 1.7% (107.2ms) | Samples: 2

**Called by:**
- `Program:exit` (59)
- `collectUnusedVariables` (11)

**Calls:**
- `get` (60)
- `get` (7)
- `get` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3474` | Self: 0.0% (3.2ms) | Total: 1.5% (98.8ms) | Samples: 2

**Called by:**
- `getDeclaredVariables` (65)

**Calls:**
- `Set` (63)

### `_ensureChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1069` | Self: 0.0% (3.1ms) | Total: 4.3% (267.0ms) | Samples: 2

**Called by:**
- `get` (178)

**Calls:**
- `_buildScopeChildren` (150)
- `_buildScopeChildren` (16)
- `_buildScopeChildren` (7)
- `_buildScopeChildren` (2)
- `_buildScopeChildren` (1)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1266` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `_makeToken` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2319` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `_buildReference` (1)
- `_buildScope` (1)

### `toLocaleLowerCase`
`[native code]` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `isUnusedExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34119` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `isReadForItself` (2)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3513` | Self: 0.0% (3.1ms) | Total: 0.8% (49.7ms) | Samples: 2

**Called by:**
- `getDeclaredVariables` (32)

**Calls:**
- `get` (30)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2904` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `_ensureChildren` (2)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3476` | Self: 0.0% (3.0ms) | Total: 0.6% (38.2ms) | Samples: 2

**Called by:**
- `getDeclaredVariables` (25)

**Calls:**
- `from` (23)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2208` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3486` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `getDeclaredVariables` (2)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4565` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `get parent` (1)
- `parent` (1)

### `get id`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `_buildReference` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34310` | Self: 0.0% (3.0ms) | Total: 100.0% (9.24s) | Samples: 2

**Called by:**
- `collectUnusedVariables` (4803)
- `Program:exit` (1276)

**Calls:**
- `collectUnusedVariables` (4803)
- `collectUnusedVariables` (518)
- `collectUnusedVariables` (309)
- `collectUnusedVariables` (243)
- `collectUnusedVariables` (128)
- `collectUnusedVariables` (47)
- `collectUnusedVariables` (11)
- `collectUnusedVariables` (11)
- `collectUnusedVariables` (3)
- `collectUnusedVariables` (3)
- `collectUnusedVariables` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:609` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `_computeVarDefs` (2)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3172` | Self: 0.0% (3.0ms) | Total: 0.1% (8.8ms) | Samples: 2

**Called by:**
- `_buildScopeRefsAndThrough` (4)
- `_buildScopeRefsAndThrough` (2)

**Calls:**
- `_nodeViewRaw` (3)
- `get right` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2999` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `getScope` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2274` | Self: 0.0% (3.0ms) | Total: 2.4% (154.4ms) | Samples: 2

**Called by:**
- `_buildReference` (62)
- `_buildScope` (38)
- `_buildScopeChildren` (1)

**Calls:**
- `_buildScope` (41)
- `_buildScope` (38)
- `_buildScope` (8)
- `_buildScope` (5)
- `_buildScope` (5)
- `_buildScope` (1)
- `_buildScope` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:675` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `_precomputeScopes` (2)

### `isRead`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `isReadRef` (1)
- `isReadForItself` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1364` | Self: 0.0% (2.9ms) | Total: 0.1% (11.9ms) | Samples: 2

**Called by:**
- `getTokenBefore` (7)
- `getTokenAfter` (1)

**Calls:**
- `_getJsxTextTokFlags` (3)
- `_getJsxTextTokFlags` (2)
- `_getJsxTextTokFlags` (1)

### `_getSynth`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1030` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `get value` (2)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:906` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (2)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3190` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `_buildScopeRefsAndThrough` (1)
- `_buildScopeRefsAndThrough` (1)

### `get scope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:875` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `getRhsNode` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301221` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `anonymous` (2)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4562` | Self: 0.0% (2.5ms) | Total: 0.0% (4.0ms) | Samples: 2

**Called by:**
- `_buildReference` (2)
- `parent` (1)

**Calls:**
- `nodeLhs` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34304` | Self: 0.0% (1.8ms) | Total: 37.3% (2.31s) | Samples: 1

**Called by:**
- `Program:exit` (1200)
- `collectUnusedVariables` (309)

**Calls:**
- `isUsedVariable` (1433)
- `isUsedVariable` (65)
- `isUsedVariable` (10)

### `parentTypeEq`
`/Users/ericsan/Development/OpenSource/Ez/js/rewrite-helpers.js:164` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:187573` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:232263` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `_computeDeclaredVariables` (1)

### `/^\s*globals?\b/`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34137` | Self: 0.0% (1.7ms) | Total: 0.0% (4.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `isUnusedExpression` (1)
- `isUnusedExpression` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:933` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:595` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `parseSource` (1)

### `(anonymous)`
`node:child_process` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2914` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_ensureChildren` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3132` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_buildScopeRefsAndThrough` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1099` | Self: 0.0% (1.7ms) | Total: 4.1% (258.1ms) | Samples: 1

**Called by:**
- `_buildScopeRefsAndThrough` (168)

**Calls:**
- `_ensureVarsSet` (167)

### `file`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `WriteStream` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2360` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1282` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_findDefNode` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34216` | Self: 0.0% (1.7ms) | Total: 1.1% (73.8ms) | Samples: 1

**Called by:**
- `some` (48)

**Calls:**
- `get references` (31)
- `get references` (12)
- `get references` (3)
- `get references` (1)

### `/(\p{Lu})([\p{Lu}][\p{Ll}])/gu`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `split` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:680` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34207` | Self: 0.0% (1.7ms) | Total: 0.4% (29.4ms) | Samples: 1

**Called by:**
- `some` (19)

**Calls:**
- `isReadForItself` (16)
- `isReadForItself` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:900` | Self: 0.0% (1.7ms) | Total: 0.1% (7.7ms) | Samples: 1

**Called by:**
- `_ensureDeclSymIndex` (4)
- `_buildVariable` (1)

**Calls:**
- `_buildSymNameCache` (4)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2260` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/useProgramFromProjectService.js:5` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170940` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:943` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7786` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2857` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_ensureRefsThrough` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:54205` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1632` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `isInside` (1)

### `Comparator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2410` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2264` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_isSimpleRangeTag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4413` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_NodeView` (1)

### `mapDefined`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:2610` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_getSharedCaches`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:836` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `reset` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/tsconfig-utils/dist/getParsedConfigFile.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `_NodeView_N`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:179640` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_lineAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `get value` (1)

### `extraFnData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:762` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `get body` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3053` | Self: 0.0% (1.5ms) | Total: 0.2% (14.3ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (5)
- `_buildReference` (3)
- `_computeDeclaredVariables` (1)

**Calls:**
- `_Variable` (8)

### `nodeTypeAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4669` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `parentTypeEq` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:30` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173068` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `handleFixes`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34315` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `fix` (1)

### `keys`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2330` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `_declSymsForNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_computeDeclaredVariables` (1)

### `test`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2779` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_ensureRefsThrough` (1)

### `stringify`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/fast-json-stable-stringify/index.js:48` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `stringify` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4309` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_fromRunnerReport` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2856` | Self: 0.0% (1.5ms) | Total: 0.0% (2.5ms) | Samples: 1

**Called by:**
- `_ensureRefsThrough` (2)

**Calls:**
- `get` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3424` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91331` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `filter` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1280` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_computeVarDefs` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `getTokenBefore` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34180` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2600` | Self: 0.0% (1.5ms) | Total: 0.0% (3.3ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (2)

**Calls:**
- `/^\s*globals?\b/` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:195507` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3229` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `getUpperFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:612` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `isInsideOfStorableFunction` (1)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4432` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7478` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8029` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:585` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_computeVarDefs` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3537` | Self: 0.0% (1.5ms) | Total: 0.2% (18.4ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (12)

**Calls:**
- `push` (11)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `Map`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get right`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34130` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1887` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `isForInOfRef` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183935` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `/\{\{\s*(\w+)\s*\}\}/g`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get message` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4539` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `init` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:622` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_computeVarDefs` (1)

### `internal:fs/streams`
`internal:fs/streams:252` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3270` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get references` (1)

### `get operator`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1403` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `isReadForItself` (1)

### `defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:880` | Self: 0.0% (1.4ms) | Total: 0.1% (6.9ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (3)
- `_ensureVarsSet` (2)

**Calls:**
- `_computeVarDefs` (2)
- `_computeVarDefs` (2)

### `_interopRequireDefault`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `handleFixes`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34573` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `fix` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1813` | Self: 0.0% (1.4ms) | Total: 0.4% (28.7ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (18)
- `isForInOfRef` (2)

**Calls:**
- `_getSynth` (14)
- `_getSynth` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:271662` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2739` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1272` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_makeToken` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3479` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8108` | Self: 0.0% (1.4ms) | Total: 0.1% (12.3ms) | Samples: 1

**Called by:**
- `runPlugins` (8)

**Calls:**
- `getDFSEvents` (5)
- `getDFSEvents` (1)
- `getDFSEvents` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1024` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2423` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34187` | Self: 0.0% (1.4ms) | Total: 0.0% (2.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `get body` (1)

### `handleFixes`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34647` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `fix` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3454` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `nodeLhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:626` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `nodeView` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3174` | Self: 0.0% (1.4ms) | Total: 0.7% (43.5ms) | Samples: 1

**Called by:**
- `_buildScopeRefsAndThrough` (20)
- `get references` (9)

**Calls:**
- `init` (17)
- `init` (10)
- `init` (1)

### `map`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.2% (18.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (6)
- `camelCase` (3)
- `_lintSourceOne` (2)
- `(anonymous)` (1)
- `isAfterLastUsedArg` (1)

**Calls:**
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `_fromRunnerReport` (1)
- `(anonymous)` (1)
- `_fromRunnerReport` (1)
- `(anonymous)` (1)

### `_ensureRefsThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1051` | Self: 0.0% (1.4ms) | Total: 4.3% (268.8ms) | Samples: 1

**Called by:**
- `_buildScopeRefsAndThrough` (179)

**Calls:**
- `get` (177)
- `get` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3073` | Self: 0.0% (1.4ms) | Total: 1.8% (114.4ms) | Samples: 1

**Called by:**
- `get defs` (72)
- `defs` (2)

**Calls:**
- `_nodeViewRaw` (60)
- `_nodeViewRaw` (9)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3026` | Self: 0.0% (1.4ms) | Total: 0.0% (3.1ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (2)

**Calls:**
- `_symName` (1)

### `isUnusedExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34116` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getRhsNode` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `parseSource` (1)

### `getOwnPropertyDescriptors`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_getTypeProto` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1888` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1596` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:194186` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:202009` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34214` | Self: 0.0% (1.3ms) | Total: 10.8% (673.2ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (443)

**Calls:**
- `getDeclaredVariables` (436)
- `getDeclaredVariables` (3)
- `getDeclaredVariables` (1)
- `map` (1)
- `_computeDeclaredVariables` (1)

### `(anonymous)`
`internal:streams/destroy` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `streamConstruct` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1830` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `isForInOfRef` (1)

### `exec`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.1% (10.7ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (7)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (6)

### `getLocFromIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3833` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `get loc` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:963` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `get body` (1)

### `SemVer`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `parse` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1371` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getTokenAfter` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2854` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_ensureRefsThrough` (1)

### `isatty`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `useColors` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301197` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:267051` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `negate` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3275` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `get references` (1)

### `getDefinedMessageData`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34015` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `Program:exit` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2326` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2859` | Self: 0.0% (1.3ms) | Total: 0.0% (3.0ms) | Samples: 1

**Called by:**
- `_ensureRefsThrough` (2)

**Calls:**
- `push` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2221` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `dlopen`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `dlopen` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1818` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/index.js:15` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4475` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `Program:exit` (1)

### `nodeTypeAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `parentTypeEq` (1)

### `generateNamedReferences`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321795` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:169261` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1035` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `_getOrBuildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6524` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `handleFixes`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `fix` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:218307` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `parseModule`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.2% (17.0ms) | Samples: 1

**Called by:**
- `async (anonymous)` (12)

**Calls:**
- `(anonymous)` (9)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `replace`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_execReport` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:241535` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `async _resolveConfigImpl` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:291272` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `_ensureRefsThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1050` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `get` (1)

### `filter`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (4.1ms) | Samples: 1

**Called by:**
- `_lintSourceOne` (1)
- `handleFixes` (1)
- `normalize` (1)

**Calls:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3549` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `map` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2349` | Self: 0.0% (1.2ms) | Total: 0.0% (2.6ms) | Samples: 1

**Called by:**
- `_buildReference` (1)
- `_buildScopeChildren` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190190` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `performProxyObjectSetStrict`
`[native code]` | Self: 0.0% (1.0ms) | Total: 0.0% (1.0ms) | Samples: 1

**Called by:**
- `_ensureRefsThrough` (1)

### `toLocaleUpperCase`
`[native code]` | Self: 0.0% (1.0ms) | Total: 0.0% (1.0ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3450` | Self: 0.0% (998us) | Total: 0.0% (998us) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201898` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289719` | Self: 0.0% (0us) | Total: 0.1% (7.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `(anonymous)` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2927` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `getScope` (1)

**Calls:**
- `_buildScope` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201932` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:6246` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:299` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `map` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290218` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:49` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/tinyglobby/dist/index.cjs:27` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:20` | Self: 0.0% (0us) | Total: 0.0% (4.8ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172372` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`node:child_process:831` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `node:child_process` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:266488` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289612` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:21` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `RegExpValidator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:19019` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `Set` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:53544` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `Comparator` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5356` | Self: 0.0% (0us) | Total: 64.6% (4.00s) | Samples: 0

**Called by:**
- `walkNodes` (2622)

**Calls:**
- `_runItemsBare` (2622)

### `getTokenAfter`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1831` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `handleFixes` (2)

**Calls:**
- `_makeToken` (1)
- `_makeToken` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295688` | Self: 0.0% (0us) | Total: 0.0% (1.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290368` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:12` | Self: 0.0% (0us) | Total: 0.1% (11.1ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `stringify`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/fast-json-stable-stringify/index.js:33` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `stringify` (1)

**Calls:**
- `stringify` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34186` | Self: 0.0% (0us) | Total: 0.0% (4.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `get body` (2)
- `get body` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/prelude-ls/lib/index.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8614` | Self: 0.0% (0us) | Total: 0.2% (12.7ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (8)

**Calls:**
- `get source` (7)
- `reset` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:168184` | Self: 0.0% (0us) | Total: 1.1% (70.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (47)

**Calls:**
- `bound require` (47)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:196993` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3228` | Self: 0.0% (0us) | Total: 0.4% (28.7ms) | Samples: 0

**Called by:**
- `_buildReference` (17)
- `(anonymous)` (2)

**Calls:**
- `_getSynth` (19)

### `_loadBundle`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-loader.js:34` | Self: 0.0% (0us) | Total: 8.6% (533.3ms) | Samples: 0

**Called by:**
- `bundleRulesFor` (276)

**Calls:**
- `bound require` (276)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172230` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1729` | Self: 0.0% (0us) | Total: 0.2% (18.4ms) | Samples: 0

**Called by:**
- `handleFixes` (12)

**Calls:**
- `_makeToken` (7)
- `_makeToken` (4)
- `_makeToken` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:174884` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:105273` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/default-config.js:37` | Self: 0.0% (0us) | Total: 0.1% (7.5ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `isUnusedExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34115` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `getRhsNode` (1)
- `isReadForItself` (1)

**Calls:**
- `parent` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92530` | Self: 0.0% (0us) | Total: 0.0% (6.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `(anonymous)` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:51152` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1600` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `_buildScope` (2)

**Calls:**
- `_nodesFromRange` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:254678` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34272` | Self: 0.0% (0us) | Total: 0.0% (4.8ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (3)

**Calls:**
- `parentTypeEq` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:130970` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:136158` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:128059` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:216654` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/eslint-utils/index.js:19` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:280` | Self: 0.0% (0us) | Total: 13.4% (831.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (537)

**Calls:**
- `parseSource` (509)
- `parseSource` (25)
- `parseSource` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164618` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:54` | Self: 0.0% (0us) | Total: 8.6% (533.3ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (276)

**Calls:**
- `bundleRulesFor` (276)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` | Self: 0.0% (0us) | Total: 0.1% (8.0ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/index.js:26` | Self: 0.0% (0us) | Total: 0.1% (12.2ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:626` | Self: 0.0% (0us) | Total: 1.0% (62.3ms) | Samples: 0

**Called by:**
- `getRhsNode` (42)

**Calls:**
- `isLoop` (42)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:48` | Self: 0.0% (0us) | Total: 1.0% (67.0ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `(anonymous)` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:123510` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `keys` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138520` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `dlopen`
`bun:ffi:345` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_tryLoad` (1)

**Calls:**
- `dlopen` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/es2022.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/source-code-traverser.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301188` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `map` (2)

**Calls:**
- `camelCase` (1)
- `camelCase` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1618` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_buildScope` (1)

**Calls:**
- `_lineAt` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:106438` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/index.js:17` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:187617` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:95835` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `node:tty`
`node:tty:6` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `anonymous` (2)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:617` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_computeVarDefs` (1)

**Calls:**
- `get value` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:48487` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:194224` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34179` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get parent` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:33` | Self: 0.0% (0us) | Total: 21.8% (1.35s) | Samples: 0

**Called by:**
- `(anonymous)` (48)
- `(anonymous)` (47)
- `(anonymous)` (35)
- `(anonymous)` (29)
- `(anonymous)` (29)
- `(anonymous)` (25)
- `(anonymous)` (22)
- `(anonymous)` (22)
- `(anonymous)` (22)
- `(anonymous)` (21)
- `(anonymous)` (19)
- `(anonymous)` (19)
- `(anonymous)` (19)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (4)
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
- `(anonymous)` (47)
- `(anonymous)` (47)
- `(anonymous)` (46)
- `(anonymous)` (29)
- `(anonymous)` (25)
- `(anonymous)` (22)
- `(anonymous)` (22)
- `(anonymous)` (22)
- `(anonymous)` (19)
- `(anonymous)` (19)
- `(anonymous)` (19)
- `(anonymous)` (19)
- `(anonymous)` (10)
- `(anonymous)` (6)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (3)
- `(anonymous)` (3)
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

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/unsupported-api.js:14` | Self: 0.0% (0us) | Total: 0.5% (35.4ms) | Samples: 0

**Called by:**
- `anonymous` (24)

**Calls:**
- `bound require` (24)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173263` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:180389` | Self: 0.0% (0us) | Total: 0.0% (999us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:251066` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:244073` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:277232` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `RegExpValidator` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92628` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289577` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8625` | Self: 0.0% (0us) | Total: 69.8% (4.32s) | Samples: 0

**Called by:**
- `_lintSourceOne` (2834)

**Calls:**
- `walkNodes` (2622)
- `walkNodes` (131)
- `walkNodes` (22)
- `walkNodes` (17)
- `walkNodes` (16)
- `walkNodes` (8)
- `walkNodes` (7)
- `walkNodes` (7)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:225829` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:321809` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `generateNamedReferences` (1)

### `parse`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:53168` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `Comparator` (1)

**Calls:**
- `SemVer` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172599` | Self: 0.0% (0us) | Total: 1.5% (94.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (22)

**Calls:**
- `(anonymous)` (22)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:309800` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12524` | Self: 0.0% (0us) | Total: 0.0% (4.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `(anonymous)` (2)
- `createDebug` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:312947` | Self: 0.0% (0us) | Total: 0.0% (4.4ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161620` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:241767` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_computeIdentifierName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4472` | Self: 0.0% (0us) | Total: 4.4% (273.8ms) | Samples: 0

**Called by:**
- `_NodeView_LR` (180)

**Calls:**
- `_resolveUnicodeEscapes` (163)
- `_identAt` (17)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:609` | Self: 0.0% (0us) | Total: 0.2% (12.7ms) | Samples: 0

**Called by:**
- `runPlugins` (7)
- `runPlugins` (1)

**Calls:**
- `decode` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/tsconfig-utils/dist/getParsedConfigFile.js:37` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:134857` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/convert.js:41` | Self: 0.0% (0us) | Total: 0.1% (8.1ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4424` | Self: 0.0% (0us) | Total: 0.4% (29.7ms) | Samples: 0

**Called by:**
- `report` (20)

**Calls:**
- `fix` (20)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:48` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172379` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:277121` | Self: 0.0% (0us) | Total: 0.1% (7.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `(anonymous)` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289631` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:110326` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:19` | Self: 0.0% (0us) | Total: 0.2% (12.6ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:51210` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313483` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/classes/comparator.js:143` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:142824` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `createDebug` (1)

### `Comparator`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:53147` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `parse` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:587` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_computeVarDefs` (1)

**Calls:**
- `get parent` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:11` | Self: 0.0% (0us) | Total: 0.1% (7.7ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:312951` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34670` | Self: 0.0% (0us) | Total: 64.1% (3.96s) | Samples: 0

**Called by:**
- `_runItemsBare` (2598)

**Calls:**
- `collectUnusedVariables` (1276)
- `collectUnusedVariables` (1200)
- `getScope` (62)
- `collectUnusedVariables` (59)
- `collectUnusedVariables` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313121` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/useProgramFromProjectService.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:221528` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:40` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:519` | Self: 0.0% (0us) | Total: 0.0% (4.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/parse-string.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:280235` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/resolveProjectList.js:10` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.0ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201919` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:169438` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/ast-converter.js:7` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:560` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `async lintSource`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:369` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `async lintSource` (1)

### `_runItemsBare`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5323` | Self: 0.0% (0us) | Total: 64.6% (4.00s) | Samples: 0

**Called by:**
- `_invokeFused` (2622)

**Calls:**
- `Program:exit` (2598)
- `Program:exit` (22)
- `Program:exit` (1)
- `Program:exit` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301215` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `map` (2)

**Calls:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:280304` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:218378` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `split`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295624` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `splitPrefixSuffix` (1)

**Calls:**
- `/(\p{Lu})([\p{Lu}][\p{Ll}])/gu` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201872` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4328` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getLocFromIndex` (1)

### `constructNT`
`internal:streams/destroy:147` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `processTicksAndRejections` (1)

**Calls:**
- `streamConstruct` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-syntax-errors.js:38` | Self: 0.0% (0us) | Total: 0.1% (8.1ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `internal:stream`
`internal:stream:2` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4436` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `report` (1)

**Calls:**
- `replace` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3483` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (1)

**Calls:**
- `_symName` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289746` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_getTypeProto`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4390` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptors` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1821` | Self: 0.0% (0us) | Total: 0.7% (46.4ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (31)

**Calls:**
- `_nodesFromRange` (30)
- `_nodesFromRange` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289563` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `handleFixes`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34318` | Self: 0.0% (0us) | Total: 0.3% (19.7ms) | Samples: 0

**Called by:**
- `fix` (13)

**Calls:**
- `getTokenBefore` (12)
- `getTokenBefore` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/shared/ajv.js:29` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `addMetaSchema` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/es2017.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:325969` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:195759` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (5.9ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `bound require` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289537` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:25` | Self: 0.0% (0us) | Total: 0.2% (13.5ms) | Samples: 0

**Called by:**
- `parseModule` (9)

**Calls:**
- `bound require` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173275` | Self: 0.0% (0us) | Total: 1.5% (94.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (22)

**Calls:**
- `(anonymous)` (22)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2839` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_ensureRefsThrough` (1)

**Calls:**
- `_buildReference` (1)

### `isReadRef`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34082` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isRead` (1)

### `createDebug`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:133383` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `useColors` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:239` | Self: 0.0% (0us) | Total: 12.6% (782.0ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (509)

**Calls:**
- `parse` (509)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:194215` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:47936` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289522` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint-scope/dist/eslint-scope.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:180398` | Self: 0.0% (0us) | Total: 0.0% (999us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3147` | Self: 0.0% (0us) | Total: 2.0% (124.7ms) | Samples: 0

**Called by:**
- `_buildScopeRefsAndThrough` (45)
- `_buildScopeRefsAndThrough` (36)
- `get references` (1)

**Calls:**
- `parent` (75)
- `get parent` (7)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:135` | Self: 0.0% (0us) | Total: 8.6% (533.3ms) | Samples: 0

**Calls:**
- `loadCoreRules` (276)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:46` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:152829` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:14659` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `Set` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290410` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/clear-caches.js:6` | Self: 0.0% (0us) | Total: 0.3% (19.3ms) | Samples: 0

**Called by:**
- `anonymous` (12)

**Calls:**
- `bound require` (12)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:277307` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:295` | Self: 0.0% (0us) | Total: 7.4% (462.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (302)

**Calls:**
- `applyDisableDirectives` (301)
- `filter` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/index.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34200` | Self: 0.0% (0us) | Total: 1.6% (100.9ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (65)

**Calls:**
- `getFunctionDefinitions` (47)
- `getFunctionDefinitions` (18)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:44` | Self: 0.0% (0us) | Total: 0.3% (22.5ms) | Samples: 0

**Called by:**
- `anonymous` (15)

**Calls:**
- `bound require` (15)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:673` | Self: 0.0% (0us) | Total: 0.0% (6.1ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (4)

**Calls:**
- `_findLineIdx` (2)
- `_findLineIdx` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `defineProperty` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parseSettings/createParseSettings.js:53` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `processTicksAndRejections`
`[native code]` | Self: 0.0% (0us) | Total: 91.1% (5.64s) | Samples: 0

**Calls:**
- `(anonymous)` (3685)
- `constructNT` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34204` | Self: 0.0% (0us) | Total: 0.7% (48.8ms) | Samples: 0

**Called by:**
- `some` (32)

**Calls:**
- `isForInOfRef` (22)
- `isForInOfRef` (3)
- `isForInOfRef` (3)
- `isForInOfRef` (2)
- `isForInOfRef` (1)
- `isForInOfRef` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313162` | Self: 0.0% (0us) | Total: 0.4% (29.9ms) | Samples: 0

**Called by:**
- `anonymous` (21)

**Calls:**
- `(anonymous)` (21)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/index.js:22` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289545` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:136042` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313135` | Self: 0.0% (0us) | Total: 1.1% (72.2ms) | Samples: 0

**Called by:**
- `anonymous` (48)

**Calls:**
- `(anonymous)` (48)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201901` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:95902` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:214106` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:168372` | Self: 0.0% (0us) | Total: 1.1% (70.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (47)

**Calls:**
- `(anonymous)` (47)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:283480` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34209` | Self: 0.0% (0us) | Total: 0.4% (26.6ms) | Samples: 0

**Called by:**
- `some` (18)

**Calls:**
- `isSelfReference` (17)
- `isReadRef` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:38` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313152` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92629` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:95861` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ts-eslint/Scope.js:38` | Self: 0.0% (0us) | Total: 0.1% (12.2ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138522` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:187608` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/resolve.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161618` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201876` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:199294` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `defineProperty` (1)

### `isInsideOfStorableFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34170` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `isReadForItself` (1)

**Calls:**
- `getUpperFunction` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:43` | Self: 0.0% (0us) | Total: 0.1% (12.2ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:58232` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1098` | Self: 0.0% (0us) | Total: 1.4% (92.3ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (60)

**Calls:**
- `_ensureVarsSet` (60)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/minimatch/dist/commonjs/index.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295660` | Self: 0.0% (0us) | Total: 0.0% (1.0ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/index.js:4` | Self: 0.0% (0us) | Total: 0.1% (10.8ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `async _resolveConfig`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:70` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `async _resolveConfig` (1)

**Calls:**
- `async _resolveConfigImpl` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228571` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:131004` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/index.js:18` | Self: 0.0% (0us) | Total: 1.4% (89.8ms) | Samples: 0

**Called by:**
- `anonymous` (19)

**Calls:**
- `bound require` (19)

### `node:stream`
`node:stream:2` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/config.js:15` | Self: 0.0% (0us) | Total: 0.1% (7.7ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `node:events`
`node:events:9` | Self: 0.0% (0us) | Total: 0.0% (1.0ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190224` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172238` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:280355` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2393` | Self: 0.0% (0us) | Total: 0.0% (3.4ms) | Samples: 0

**Called by:**
- `_buildScope` (2)

**Calls:**
- `get parent` (1)
- `get parent` (1)

### `useColors`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12457` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `createDebug` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:276550` | Self: 0.0% (0us) | Total: 0.1% (7.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `(anonymous)` (5)

### `createDebug`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12073` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `useColors` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109718` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/index.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34682` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_runItemsBare` (1)

**Calls:**
- `getDefinedMessageData` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236769` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:98391` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `applyDisableDirectives`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8685` | Self: 0.0% (0us) | Total: 7.4% (461.2ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (301)

**Calls:**
- `_parseDisableDirectives` (188)
- `_parseDisableDirectives` (113)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289600` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:110324` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/esquery.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:10` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:24` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:119` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `stringify`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/fast-json-stable-stringify/index.js:50` | Self: 0.0% (0us) | Total: 0.0% (4.7ms) | Samples: 0

**Called by:**
- `stringify` (2)
- `_addSchema` (1)

**Calls:**
- `stringify` (2)
- `stringify` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/TypeVisitor.js:7` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:20` | Self: 0.0% (0us) | Total: 0.2% (16.8ms) | Samples: 0

**Called by:**
- `anonymous` (11)

**Calls:**
- `bound require` (11)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/config/default-config.js:12` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:3` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `negate`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:267056` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:30` | Self: 0.0% (0us) | Total: 1.0% (67.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `(anonymous)` (5)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 23.6% (1.46s) | Samples: 0

**Called by:**
- `_loadBundle` (276)
- `(anonymous)` (47)
- `(anonymous)` (24)
- `(anonymous)` (24)
- `(anonymous)` (19)
- `(anonymous)` (19)
- `(anonymous)` (15)
- `(anonymous)` (12)
- `(anonymous)` (11)
- `(anonymous)` (11)
- `(anonymous)` (10)
- `(anonymous)` (9)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `(anonymous)` (4)
- `patchAstUtils` (3)
- `(anonymous)` (3)
- `(anonymous)` (3)
- `getESLintCoreRule` (3)
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
- `require` (724)
- `anonymous` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:152219` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/getWatchProgramsForProjects.js:45` | Self: 0.0% (0us) | Total: 1.1% (68.6ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:45774` | Self: 0.0% (0us) | Total: 0.0% (4.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183979` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:195082` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `defineProperty` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:49` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92632` | Self: 0.0% (0us) | Total: 0.0% (6.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `(anonymous)` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228470` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170755` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:294964` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172375` | Self: 0.0% (0us) | Total: 1.4% (89.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (19)

**Calls:**
- `(anonymous)` (19)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:22` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `handleFixes`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34322` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `fix` (1)

**Calls:**
- `filter` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8617` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `get source` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201944` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:284` | Self: 0.0% (0us) | Total: 70.1% (4.34s) | Samples: 0

**Called by:**
- `(anonymous)` (2844)

**Calls:**
- `runPlugins` (2834)
- `runPlugins` (8)
- `runPlugins` (1)
- `runPlugins` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/dotjs/index.js:10` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@eslint/plugin-kit/dist/cjs/index.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/dotjs/index.js:28` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/visitor-keys/dist/index.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295677` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `toLocaleLowerCase` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:293466` | Self: 0.0% (0us) | Total: 0.5% (35.4ms) | Samples: 0

**Called by:**
- `anonymous` (24)

**Calls:**
- `bound require` (24)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290288` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `addMetaSchema`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:152` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `addSchema` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289701` | Self: 0.0% (0us) | Total: 0.0% (1.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:48407` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8366` | Self: 0.0% (0us) | Total: 64.6% (4.00s) | Samples: 0

**Called by:**
- `runPlugins` (2622)

**Calls:**
- `_invokeFused` (2622)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:21` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `_tryLoad`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-source-code.js:44` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `isAvailable` (1)

**Calls:**
- `dlopen` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/lib/picomatch.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1855` | Self: 0.0% (0us) | Total: 0.0% (3.9ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (3)

**Calls:**
- `_nodesFromRange` (3)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:490` | Self: 0.0% (0us) | Total: 0.1% (8.9ms) | Samples: 0

**Called by:**
- `parseSource` (2)

**Calls:**
- `CfgGraph` (2)

### `split`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295634` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `splitPrefixSuffix` (1)

**Calls:**
- `regExpSplitFast` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289682` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_fromRunnerReport`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:207` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `get message` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:180354` | Self: 0.0% (0us) | Total: 0.0% (999us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:795` | Self: 0.0% (0us) | Total: 29.6% (1.83s) | Samples: 0

**Called by:**
- `isUsedVariable` (1199)
- `_buildScopeRefsAndThrough` (1)

**Calls:**
- `_ensureRefsThrough` (1198)
- `_ensureRefsThrough` (1)
- `_ensureRefsThrough` (1)

### `async _resolveConfig`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:67` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `async lintSource` (1)

**Calls:**
- `async _resolveConfig` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313116` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201852` | Self: 0.0% (0us) | Total: 0.0% (999us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161377` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:230` | Self: 0.0% (0us) | Total: 0.0% (4.6ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (3)

**Calls:**
- `_encodeSource` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/rules.js:3` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313065` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `async lintSource`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:370` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `async lintSource` (1)

**Calls:**
- `async _resolveConfig` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:152915` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.0% (1.0ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201894` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `normalize`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91330` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `filter` (1)

### `_computeIdentifierName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4465` | Self: 0.0% (0us) | Total: 0.8% (51.5ms) | Samples: 0

**Called by:**
- `_NodeView_LR` (32)

**Calls:**
- `source` (32)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` | Self: 0.0% (0us) | Total: 0.0% (4.6ms) | Samples: 0

**Called by:**
- `parseSource` (3)

**Calls:**
- `encodeInto` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172457` | Self: 0.0% (0us) | Total: 1.5% (94.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (22)

**Calls:**
- `(anonymous)` (22)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313081` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295659` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `map` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289592` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `node:child_process`
`node:child_process:473` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8689` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `filter` (1)

**Calls:**
- `get loc` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:223042` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201936` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_addSchema`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:295` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `addSchema` (1)

**Calls:**
- `stringify` (1)

### `isAvailable`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-source-code.js:56` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_getFfi` (1)

**Calls:**
- `_tryLoad` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161332` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:280231` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1115` | Self: 0.0% (0us) | Total: 4.3% (267.0ms) | Samples: 0

**Called by:**
- `_ensureRefsThrough` (177)
- `collectUnusedVariables` (1)

**Calls:**
- `_ensureChildren` (178)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/getModifiers.js:39` | Self: 0.0% (0us) | Total: 0.0% (4.7ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:103885` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34134` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isInside` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289729` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2101` | Self: 0.0% (0us) | Total: 1.5% (96.4ms) | Samples: 0

**Called by:**
- `Program:exit` (62)

**Calls:**
- `_precomputeScopes` (45)
- `_precomputeScopes` (14)
- `_precomputeScopes` (2)
- `_precomputeScopes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:257727` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:228730` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289560` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/linter.js:21` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:172367` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:47` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `async (anonymous)` (1)

### `useColors`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:133587` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `createDebug` (1)

**Calls:**
- `isatty` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289502` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:152806` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:183970` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:139404` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `_interopRequireDefault` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289664` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/ClassVisitor.js:6` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/useProgramFromProjectService.js:44` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173262` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/ast-converter.js:4` | Self: 0.0% (0us) | Total: 0.1% (9.5ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138712` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:581` | Self: 0.0% (0us) | Total: 0.2% (14.8ms) | Samples: 0

**Called by:**
- `_computeVarDefs` (10)

**Calls:**
- `parent` (5)
- `get parent` (2)
- `parent` (2)
- `get parent` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:244069` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3218` | Self: 0.0% (0us) | Total: 0.4% (30.0ms) | Samples: 0

**Called by:**
- `get references` (20)

**Calls:**
- `scope` (20)

### `get message`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4347` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_fromRunnerReport` (1)

**Calls:**
- `/\{\{\s*(\w+)\s*\}\}/g` (1)

### `camelCase`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295657` | Self: 0.0% (0us) | Total: 0.0% (4.1ms) | Samples: 0

**Called by:**
- `addPolyfillToken` (2)
- `(anonymous)` (1)

**Calls:**
- `map` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96741` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171795` | Self: 0.0% (0us) | Total: 1.4% (89.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (19)

**Calls:**
- `(anonymous)` (19)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91307` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:98704` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3432` | Self: 0.0% (0us) | Total: 10.7% (663.6ms) | Samples: 0

**Called by:**
- `isAfterLastUsedArg` (436)

**Calls:**
- `_computeDeclaredVariables` (148)
- `_computeDeclaredVariables` (65)
- `_computeDeclaredVariables` (53)
- `_computeDeclaredVariables` (32)
- `_computeDeclaredVariables` (30)
- `_computeDeclaredVariables` (25)
- `_computeDeclaredVariables` (16)
- `_computeDeclaredVariables` (14)
- `_computeDeclaredVariables` (12)
- `_computeDeclaredVariables` (12)
- `_computeDeclaredVariables` (8)
- `_computeDeclaredVariables` (4)
- `_computeDeclaredVariables` (3)
- `_computeDeclaredVariables` (3)
- `_computeDeclaredVariables` (2)
- `_computeDeclaredVariables` (2)
- `_computeDeclaredVariables` (2)
- `_computeDeclaredVariables` (1)
- `_computeDeclaredVariables` (1)
- `_computeDeclaredVariables` (1)
- `_computeDeclaredVariables` (1)
- `_computeDeclaredVariables` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:37` | Self: 0.0% (0us) | Total: 0.0% (3.4ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3536` | Self: 0.0% (0us) | Total: 3.6% (223.2ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (148)

**Calls:**
- `set` (148)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170717` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `defineProperty` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173105` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:8` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:7` | Self: 0.0% (0us) | Total: 0.1% (6.3ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `bound require` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289760` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170969` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `splitPrefixSuffix`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295713` | Self: 0.0% (0us) | Total: 0.0% (3.4ms) | Samples: 0

**Called by:**
- `camelCase` (2)

**Calls:**
- `split` (1)
- `split` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1840` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `extraFnData` (1)

### `buildUnicodeData`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:3982` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `wordsRegexp` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:277097` | Self: 0.0% (0us) | Total: 0.1% (7.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `(anonymous)` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164283` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `Comparator` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:198192` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3196` | Self: 0.0% (0us) | Total: 0.5% (35.4ms) | Samples: 0

**Called by:**
- `_buildScopeRefsAndThrough` (12)
- `_buildScopeRefsAndThrough` (10)

**Calls:**
- `_Reference` (22)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2998` | Self: 0.0% (0us) | Total: 1.1% (70.4ms) | Samples: 0

**Called by:**
- `getScope` (45)

**Calls:**
- `commentsInRange` (33)
- `commentsInRange` (4)
- `commentsInRange` (3)
- `commentsInRange` (2)
- `commentsInRange` (2)
- `commentsInRange` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-modifiers.js:38` | Self: 0.0% (0us) | Total: 0.0% (4.7ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:9` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:285978` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/tsconfig-utils/dist/getParsedConfigFile.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/token-store/index.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92477` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `normalize` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/eslint-utils/index.js:21` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/analyze.js:5` | Self: 0.0% (0us) | Total: 0.1% (10.8ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.2% (17.0ms) | Samples: 0

**Calls:**
- `parseModule` (12)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313380` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 23.5% (1.46s) | Samples: 0

**Called by:**
- `bound require` (724)

**Calls:**
- `anonymous` (724)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12344` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:146427` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1698` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `handleFixes` (1)

**Calls:**
- `_getFfi` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/clear-caches.js:5` | Self: 0.0% (0us) | Total: 1.1% (70.4ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rule-tester/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1027` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (2)

**Calls:**
- `defs` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/picomatch/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295680` | Self: 0.0% (0us) | Total: 0.0% (1.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `toLocaleUpperCase` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:198186` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173097` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:109712` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201928` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:29594` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `streamConstruct`
`internal:fs/streams:102` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `constructNT` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301137` | Self: 0.0% (0us) | Total: 0.1% (9.1ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `(anonymous)` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/api.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_fromRunnerReport`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:204` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `get loc` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201885` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:91308` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:53717` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301207` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `addPolyfillToken` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:196951` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/analyze.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/internal/re.js:173` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `createToken` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js:42` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:50` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `async lintSource` (1)

### `wordsRegexp`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:285` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `buildUnicodeData` (1)

**Calls:**
- `RegExp` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92498` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:169296` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_ensureRefsThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1046` | Self: 0.0% (0us) | Total: 0.0% (1.0ms) | Samples: 0

**Called by:**
- `get` (1)

**Calls:**
- `performProxyObjectSetStrict` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301209` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `addPolyfillToken` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:1664` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313156` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:251` | Self: 0.0% (0us) | Total: 0.7% (44.9ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (25)

**Calls:**
- `AstView` (12)
- `AstView` (4)
- `AstView` (3)
- `AstView` (2)
- `AstView` (2)
- `AstView` (1)
- `AstView` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:199332` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289779` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:225762` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:12518` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:261130` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `WriteStream`
`internal:fs/streams:244` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `file` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:75` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `async _resolveConfig` (1)

**Calls:**
- `async _resolveConfigImpl` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/version-check.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201906` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4576` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `reset` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1125` | Self: 0.0% (0us) | Total: 0.1% (9.9ms) | Samples: 0

**Called by:**
- `get` (7)

**Calls:**
- `_ensureVarsSet` (3)
- `_ensureVarsSet` (2)
- `_ensureVarsSet` (1)
- `_ensureVarsSet` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:254662` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getESLintCoreRule`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:174826` | Self: 0.0% (0us) | Total: 0.0% (4.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `bound require` (3)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1200` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `reset` (1)

**Calls:**
- `_getSharedCaches` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164528` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170746` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290056` | Self: 0.0% (0us) | Total: 0.6% (42.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (29)

**Calls:**
- `(anonymous)` (29)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:271749` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `parse` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201953` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290160` | Self: 0.0% (0us) | Total: 0.0% (4.9ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `(anonymous)` (3)

### `createToken`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/node_modules/semver/internal/re.js:50` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `RegExp` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289691` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:260850` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:257753` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/index.js:41` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:177215` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getESLintCoreRule` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:196180` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4478` | Self: 0.0% (0us) | Total: 0.4% (30.9ms) | Samples: 0

**Called by:**
- `Program:exit` (21)

**Calls:**
- `_execReport` (20)
- `_execReport` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173303` | Self: 0.0% (0us) | Total: 1.5% (98.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (25)

**Calls:**
- `(anonymous)` (25)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/tsconfig-utils/dist/index.js:18` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:136000` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289514` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1134` | Self: 0.0% (0us) | Total: 0.1% (9.9ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (7)

**Calls:**
- `_ensureVarsSet` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313143` | Self: 0.0% (0us) | Total: 1.8% (114.1ms) | Samples: 0

**Called by:**
- `anonymous` (35)

**Calls:**
- `(anonymous)` (35)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:185339` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getESLintCoreRule` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:198766` | Self: 0.0% (0us) | Total: 0.3% (19.0ms) | Samples: 0

**Called by:**
- `anonymous` (12)

**Calls:**
- `(anonymous)` (7)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `internal:fs/streams`
`internal:fs/streams:2` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/lib/index.js:69` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201864` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:164456` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:92706` | Self: 0.0% (0us) | Total: 0.1% (9.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `(anonymous)` (6)

### `addPolyfillToken`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301175` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `camelCase` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:106851` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:96809` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171574` | Self: 0.0% (0us) | Total: 1.4% (89.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (19)

**Calls:**
- `(anonymous)` (19)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:296388` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:104249` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34679` | Self: 0.0% (0us) | Total: 0.5% (32.2ms) | Samples: 0

**Called by:**
- `_runItemsBare` (22)

**Calls:**
- `report` (21)
- `report` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1497` | Self: 0.0% (0us) | Total: 0.1% (7.5ms) | Samples: 0

**Called by:**
- `_buildScope` (4)
- `_findDefNode` (1)

**Calls:**
- `_getSynth` (3)
- `_getSynth` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201842` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `addSchema`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/ajv.js:137` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `addMetaSchema` (1)

**Calls:**
- `_addSchema` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7651` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_getOrBuildPlan` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34673` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_runItemsBare` (1)

**Calls:**
- `get defs` (1)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34108` | Self: 0.0% (0us) | Total: 1.1% (73.0ms) | Samples: 0

**Called by:**
- `isUsedVariable` (47)

**Calls:**
- `(anonymous)` (42)
- `(anonymous)` (5)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2513` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `performProxyObjectGet` (1)

**Calls:**
- `get` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201891` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289720` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:674` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (2)

**Calls:**
- `_findLineIdx` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:221575` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190232` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:190784` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getESLintCoreRule` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:138287` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:93788` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:171420` | Self: 0.0% (0us) | Total: 1.4% (89.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (19)

**Calls:**
- `bound require` (19)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290109` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289579` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:192946` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint.js:19` | Self: 0.0% (0us) | Total: 0.1% (10.2ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201949` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173302` | Self: 0.0% (0us) | Total: 0.2% (15.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (10)

**Calls:**
- `bound require` (10)

### `bundleRulesFor`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-loader.js:59` | Self: 0.0% (0us) | Total: 8.6% (533.3ms) | Samples: 0

**Called by:**
- `loadCoreRules` (276)

**Calls:**
- `_loadBundle` (276)

### `_parseDisableDirectives`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8647` | Self: 0.0% (0us) | Total: 2.7% (171.1ms) | Samples: 0

**Called by:**
- `applyDisableDirectives` (113)

**Calls:**
- `regExpSplitFast` (113)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:128019` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:218453` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2219` | Self: 0.0% (0us) | Total: 0.0% (6.0ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (4)

**Calls:**
- `_symName` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/referencer/Referencer.js:6` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:192937` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:165588` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `mapDefined` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34175` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `get parent` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:195111` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:266549` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/fdir/dist/index.cjs:462` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:170978` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201849` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `fix`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34690` | Self: 0.0% (0us) | Total: 0.4% (29.7ms) | Samples: 0

**Called by:**
- `_execReport` (20)

**Calls:**
- `handleFixes` (13)
- `handleFixes` (2)
- `handleFixes` (1)
- `handleFixes` (1)
- `handleFixes` (1)
- `handleFixes` (1)
- `handleFixes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301201` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `RegExp` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:244141` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/levn/lib/parse-string.js:113` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301179` | Self: 0.0% (0us) | Total: 0.1% (8.5ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `map` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:199323` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:98783` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:561` | Self: 0.0% (0us) | Total: 0.0% (4.8ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `patchAstUtils` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:179651` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:290123` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:241966` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:236729` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:337765` | Self: 0.0% (0us) | Total: 0.6% (42.7ms) | Samples: 0

**Called by:**
- `anonymous` (29)

**Calls:**
- `(anonymous)` (29)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:134900` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2289` | Self: 0.0% (0us) | Total: 0.2% (14.1ms) | Samples: 0

**Called by:**
- `_buildScope` (5)
- `_buildScopeChildren` (4)

**Calls:**
- `get value` (4)
- `get value` (2)
- `get value` (1)
- `get value` (1)
- `get value` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:169312` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:201910` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_getFfi`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:129` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `getTokenBefore` (1)

**Calls:**
- `isAvailable` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/apply-disable-directives.js:22` | Self: 0.0% (0us) | Total: 0.1% (11.0ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/linter/index.js:3` | Self: 0.0% (0us) | Total: 0.2% (16.8ms) | Samples: 0

**Called by:**
- `anonymous` (11)

**Calls:**
- `bound require` (11)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:161566` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:312962` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4506` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `_getTypeProto` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/eslint/eslint-helpers.js:18` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313072` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:195121` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34133` | Self: 0.0% (0us) | Total: 3.1% (194.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (128)

**Calls:**
- `isInLoop` (86)
- `isInLoop` (42)

### `(anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 91.1% (5.64s) | Samples: 0

**Called by:**
- `processTicksAndRejections` (3685)
- `useColors` (1)

**Calls:**
- `_lintSourceOne` (2844)
- `_lintSourceOne` (537)
- `_lintSourceOne` (302)
- `_lintSourceOne` (2)
- `WriteStream` (1)

### `handleFixes`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34319` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `fix` (2)

**Calls:**
- `getTokenAfter` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/definition/index.js:24` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:59` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `async (anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:192902` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `getOwnPropertyDescriptor` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:173290` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/index.js:12` | Self: 0.0% (0us) | Total: 0.0% (5.9ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `bound require` (4)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:8624` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `buildVisitorMap` (1)

### `performProxyObjectGet`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_buildScopeRefsAndThrough` (1)

**Calls:**
- `get` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js:40825` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `Map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:216614` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/utils/dist/ast-utils/eslint-utils/predicates.js:37` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/languages/js/source-code/source-code.js:11` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313089` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:196986` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:247418` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/check-modifiers.js:39` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:46` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3169` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `_buildScopeRefsAndThrough` (2)

**Calls:**
- `parent` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34241` | Self: 0.0% (0us) | Total: 0.0% (4.3ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (3)

**Calls:**
- `parentTypeEq` (2)
- `parentTypeEq` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:3999` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `buildUnicodeData` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:244171` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/scope-manager/dist/index.js:18` | Self: 0.0% (0us) | Total: 0.1% (12.2ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/shared.js:4` | Self: 0.0% (0us) | Total: 1.0% (67.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `getOwnPropertyDescriptor` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:261194` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/index.js:8` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/parser.js:16` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `camelCase`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:295653` | Self: 0.0% (0us) | Total: 0.0% (3.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `splitPrefixSuffix` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:223124` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:34181` | Self: 0.0% (0us) | Total: 0.5% (33.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (22)

**Calls:**
- `parent` (21)
- `get parent` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:232359` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:313069` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:272101` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `negate` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:301225` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `camelCase` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289718` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js:289649` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/ajv/lib/compile/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 35.0% | 2.17s | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 31.4% | 1.95s | `[native code]` |
| 19.7% | 1.22s | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 12.9% | 799.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/.ez-dist/rules.bundle.js` |
| 0.2% | 15.9ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/typescript/lib/typescript.js` |
| 0.2% | 15.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/rewrite-helpers.js` |
| 0.0% | 1.7ms | `node:child_process` |
| 0.0% | 1.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/useProgramFromProjectService.js` |
| 0.0% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/tsconfig-utils/dist/getParsedConfigFile.js` |
| 0.0% | 1.5ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/@typescript-eslint/typescript-estree/dist/create-program/createSourceFile.js` |
| 0.0% | 1.5ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/fast-json-stable-stringify/index.js` |
| 0.0% | 1.4ms | `internal:fs/streams` |
| 0.0% | 1.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/uri-js/dist/es5/uri.all.js` |
| 0.0% | 1.3ms | `internal:streams/destroy` |
| 0.0% | 1.2ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/index.js` |
| 0.0% | 1.2ms | `/Users/ericsan/Development/OpenSource/Ez/js/api.js` |
