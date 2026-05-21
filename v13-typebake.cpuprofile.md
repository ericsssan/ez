# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 1.40s | 918 | 1.0ms | 303 |

**Top 10:** `parse` 29.2%, `walkNodes` 4.2%, `_ensureDeclSymIndex` 3.8%, `_NodeView_LR` 3.1%, `_nodeViewRaw` 2.2%, `_NodeView` 2.0%, `_nodeViewRaw` 1.9%, `get parent` 1.7%, `isInLoop` 1.6%, `walkNodes` 1.4%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 29.2% | 410.2ms | 29.2% | 410.2ms | `parse` | `[native code]` |
| 4.2% | 60.0ms | 4.2% | 60.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7017` |
| 3.8% | 54.2ms | 4.1% | 58.9ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2017` |
| 3.1% | 44.2ms | 3.1% | 44.2ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4043` |
| 2.2% | 32.2ms | 8.2% | 116.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4090` |
| 2.0% | 28.7ms | 2.0% | 28.7ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4012` |
| 1.9% | 27.3ms | 1.9% | 27.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4085` |
| 1.7% | 24.5ms | 7.3% | 103.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1196` |
| 1.6% | 23.7ms | 1.6% | 23.7ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` |
| 1.4% | 20.8ms | 1.4% | 20.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6743` |
| 1.4% | 20.2ms | 1.4% | 20.2ms | `Set` | `[native code]` |
| 1.3% | 19.4ms | 1.4% | 20.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3166` |
| 1.2% | 17.8ms | 1.2% | 17.8ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2107` |
| 1.2% | 17.5ms | 3.7% | 52.7ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` |
| 1.1% | 15.5ms | 4.0% | 57.4ms | `anonymous` | `[native code]` |
| 1.0% | 15.3ms | 1.0% | 15.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3172` |
| 1.0% | 15.1ms | 1.0% | 15.1ms | `getUint32` | `[native code]` |
| 1.0% | 15.1ms | 1.0% | 15.1ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 1.0% | 14.2ms | 1.0% | 14.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2229` |
| 1.0% | 14.2ms | 1.0% | 14.2ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` |
| 1.0% | 14.1ms | 1.4% | 19.7ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2868` |
| 0.8% | 12.1ms | 1.2% | 18.2ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1695` |
| 0.8% | 11.8ms | 0.8% | 11.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2745` |
| 0.8% | 11.3ms | 0.8% | 11.3ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.7% | 10.7ms | 0.7% | 10.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1176` |
| 0.7% | 10.6ms | 0.7% | 10.6ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.7% | 10.0ms | 0.7% | 10.0ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2698` |
| 0.7% | 9.8ms | 0.8% | 11.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2223` |
| 0.5% | 8.2ms | 0.5% | 8.2ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2846` |
| 0.5% | 7.8ms | 0.5% | 7.8ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:600` |
| 0.5% | 7.8ms | 0.5% | 7.8ms | `decode` | `[native code]` |
| 0.5% | 7.6ms | 0.5% | 7.6ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.5% | 7.4ms | 0.5% | 7.4ms | `get` | `[native code]` |
| 0.5% | 7.4ms | 0.8% | 11.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 0.5% | 7.3ms | 19.9% | 280.3ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 0.5% | 7.2ms | 0.5% | 7.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4095` |
| 0.4% | 6.4ms | 0.4% | 6.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1302` |
| 0.4% | 6.4ms | 0.4% | 6.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2738` |
| 0.4% | 6.4ms | 0.4% | 6.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4096` |
| 0.4% | 6.1ms | 4.7% | 66.0ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2087` |
| 0.4% | 6.0ms | 6.1% | 86.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2213` |
| 0.4% | 6.0ms | 0.4% | 6.0ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2787` |
| 0.4% | 5.7ms | 1.4% | 20.6ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2589` |
| 0.3% | 5.5ms | 0.3% | 5.5ms | `test` | `[native code]` |
| 0.3% | 5.1ms | 0.3% | 5.1ms | `push` | `[native code]` |
| 0.3% | 5.1ms | 0.3% | 5.1ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2586` |
| 0.3% | 4.8ms | 3.2% | 45.1ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2186` |
| 0.3% | 4.8ms | 0.6% | 9.6ms | `exec` | `[native code]` |
| 0.3% | 4.7ms | 0.3% | 4.7ms | `DataView` | `[native code]` |
| 0.3% | 4.6ms | 0.3% | 4.6ms | `set` | `[native code]` |
| 0.3% | 4.5ms | 0.3% | 4.5ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3146` |
| 0.3% | 4.5ms | 0.3% | 4.5ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4117` |
| 0.3% | 4.4ms | 0.3% | 4.4ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.3% | 4.4ms | 0.3% | 4.4ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.2% | 4.2ms | 0.2% | 4.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 4.1ms | 0.2% | 4.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1208` |
| 0.2% | 4.1ms | 1.7% | 24.1ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2320` |
| 0.2% | 3.5ms | 0.2% | 3.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2117` |
| 0.2% | 3.4ms | 0.2% | 3.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2734` |
| 0.2% | 3.4ms | 0.2% | 3.4ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2992` |
| 0.2% | 3.4ms | 0.5% | 8.1ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2840` |
| 0.2% | 3.3ms | 0.5% | 8.1ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2792` |
| 0.2% | 3.3ms | 0.2% | 3.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2428` |
| 0.2% | 3.3ms | 0.2% | 3.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4108` |
| 0.2% | 3.3ms | 3.7% | 53.2ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2833` |
| 0.2% | 3.2ms | 0.4% | 6.5ms | `readdirSync` | `[native code]` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3165` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6476` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2727` |
| 0.2% | 3.2ms | 0.7% | 10.7ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:824` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 3.2ms | 13.2% | 186.2ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:845` |
| 0.2% | 3.1ms | 0.3% | 5.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1235` |
| 0.2% | 3.1ms | 6.4% | 90.9ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 0.2% | 3.1ms | 0.2% | 3.1ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2952` |
| 0.2% | 3.1ms | 0.4% | 5.7ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:840` |
| 0.2% | 3.1ms | 0.4% | 6.2ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3909` |
| 0.2% | 3.1ms | 6.6% | 93.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2844` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2102` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` |
| 0.2% | 3.0ms | 0.3% | 4.5ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` |
| 0.2% | 2.9ms | 0.2% | 2.9ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.2% | 2.9ms | 0.2% | 2.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2052` |
| 0.2% | 2.9ms | 0.6% | 9.7ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 0.2% | 2.9ms | 0.2% | 2.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2212` |
| 0.2% | 2.8ms | 1.0% | 14.7ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` |
| 0.2% | 2.8ms | 0.2% | 2.8ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2054` |
| 0.2% | 2.8ms | 0.3% | 5.4ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2808` |
| 0.2% | 2.8ms | 0.2% | 2.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 2.8ms | 0.2% | 2.8ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` |
| 0.2% | 2.8ms | 0.4% | 5.6ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2016` |
| 0.2% | 2.8ms | 1.6% | 23.1ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2900` |
| 0.2% | 2.8ms | 0.2% | 2.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2697` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7188` |
| 0.1% | 2.7ms | 1.8% | 26.2ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 0.1% | 2.5ms | 0.1% | 2.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 2.5ms | 0.1% | 2.5ms | `slice` | `[native code]` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2718` |
| 0.1% | 1.8ms | 0.4% | 6.4ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2677` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4329` |
| 0.1% | 1.8ms | 13.0% | 183.1ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `/^\s*globals?\b/` | `[native code]` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3641` |
| 0.1% | 1.8ms | 0.9% | 13.9ms | `forEach` | `[native code]` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2939` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:830` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6474` |
| 0.1% | 1.7ms | 0.3% | 4.5ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2190` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4080` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `/^\s*exported\b/` | `[native code]` |
| 0.1% | 1.7ms | 3.2% | 45.1ms | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `setPrototypeOf` | `[native code]` |
| 0.1% | 1.7ms | 1.5% | 21.9ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` |
| 0.1% | 1.7ms | 0.3% | 4.3ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1718` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:808` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2869` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7019` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3159` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:514` |
| 0.1% | 1.6ms | 0.5% | 7.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2071` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2168` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6747` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_isStatementTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2432` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1691` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `encodeInto` | `[native code]` |
| 0.1% | 1.5ms | 2.6% | 37.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2430` |
| 0.1% | 1.5ms | 0.2% | 3.0ms | `readFileSync` | `[native code]` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `isRead` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.5ms | 9.9% | 139.3ms | `some` | `[native code]` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1721` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:641` |
| 0.1% | 1.5ms | 0.2% | 3.1ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3595` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3414` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:872` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `fetch` | `[native code]` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3168` |
| 0.1% | 1.4ms | 1.0% | 15.3ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3148` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `has` | `[native code]` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `replace` | `[native code]` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6857` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `get identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:755` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.4ms | 19.2% | 269.9ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:887` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:122` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4141` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2934` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.3% | 4.8ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2018` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3615` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3102` |
| 0.0% | 1.3ms | 1.5% | 22.0ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2782` |
| 0.0% | 1.3ms | 3.8% | 53.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2066` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `RuleContext` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1292` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:602` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2032` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4328` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `driveAsyncFunction` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:887` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3358` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:550` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:648` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1706` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:543` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:892` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:484` |
| 0.0% | 1.1ms | 0.0% | 1.1ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3086` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 100.0% | 2.75s | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 68.2% | 958.7ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:304` |
| 67.6% | 949.6ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7540` |
| 60.7% | 853.3ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7256` |
| 60.6% | 851.9ms | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4672` |
| 58.2% | 818.7ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` |
| 29.8% | 419.6ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:300` |
| 29.2% | 410.2ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` |
| 29.2% | 410.2ms | 29.2% | 410.2ms | `parse` | `[native code]` |
| 19.9% | 280.3ms | 0.5% | 7.3ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 19.2% | 269.9ms | 0.1% | 1.4ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 15.3% | 216.2ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 13.2% | 186.2ms | 0.2% | 3.2ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:845` |
| 13.1% | 184.5ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:953` |
| 13.0% | 183.1ms | 0.1% | 1.8ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` |
| 10.5% | 148.0ms | 0.0% | 0us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4122` |
| 9.9% | 139.3ms | 0.1% | 1.5ms | `some` | `[native code]` |
| 8.2% | 116.0ms | 2.2% | 32.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4090` |
| 7.6% | 107.9ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` |
| 7.5% | 105.4ms | 0.0% | 0us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3101` |
| 7.3% | 103.1ms | 1.7% | 24.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1196` |
| 6.6% | 93.5ms | 0.2% | 3.1ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2844` |
| 6.4% | 90.9ms | 0.2% | 3.1ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 6.3% | 89.8ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2837` |
| 6.1% | 86.2ms | 0.4% | 6.0ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2213` |
| 4.7% | 67.1ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:752` |
| 4.7% | 66.0ms | 0.4% | 6.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2087` |
| 4.6% | 65.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` |
| 4.2% | 60.0ms | 4.2% | 60.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7017` |
| 4.1% | 58.9ms | 3.8% | 54.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2017` |
| 4.0% | 57.4ms | 1.1% | 15.5ms | `anonymous` | `[native code]` |
| 3.8% | 53.4ms | 0.0% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2066` |
| 3.7% | 53.2ms | 0.2% | 3.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2833` |
| 3.7% | 52.7ms | 1.2% | 17.5ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` |
| 3.5% | 50.4ms | 0.0% | 0us | `bound require` | `[native code]` |
| 3.4% | 48.6ms | 0.0% | 0us | `require` | `[native code]` |
| 3.3% | 46.6ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` |
| 3.2% | 45.1ms | 0.1% | 1.7ms | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 3.2% | 45.1ms | 0.3% | 4.8ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2186` |
| 3.1% | 44.2ms | 3.1% | 44.2ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4043` |
| 2.6% | 37.8ms | 0.1% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 2.1% | 30.4ms | 0.0% | 0us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1898` |
| 2.1% | 30.4ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` |
| 2.0% | 28.7ms | 2.0% | 28.7ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4012` |
| 2.0% | 28.2ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2222` |
| 1.9% | 27.3ms | 1.9% | 27.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4085` |
| 1.8% | 26.2ms | 0.1% | 2.7ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 1.8% | 25.7ms | 0.0% | 0us | `_ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:924` |
| 1.8% | 25.7ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:957` |
| 1.7% | 24.1ms | 0.2% | 4.1ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2320` |
| 1.6% | 23.7ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` |
| 1.6% | 23.7ms | 1.6% | 23.7ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` |
| 1.6% | 23.1ms | 0.2% | 2.8ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2900` |
| 1.6% | 22.5ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2673` |
| 1.5% | 22.0ms | 0.0% | 1.3ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2782` |
| 1.5% | 21.9ms | 0.1% | 1.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` |
| 1.5% | 21.6ms | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 1.4% | 20.8ms | 1.4% | 20.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6743` |
| 1.4% | 20.7ms | 1.3% | 19.4ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3166` |
| 1.4% | 20.6ms | 0.4% | 5.7ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2589` |
| 1.4% | 20.2ms | 1.4% | 20.2ms | `Set` | `[native code]` |
| 1.4% | 19.7ms | 1.0% | 14.1ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2868` |
| 1.3% | 18.7ms | 0.0% | 0us | `parseModule` | `[native code]` |
| 1.3% | 18.6ms | 0.0% | 0us | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` |
| 1.2% | 18.2ms | 0.8% | 12.1ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1695` |
| 1.2% | 17.8ms | 1.2% | 17.8ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2107` |
| 1.1% | 15.4ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:72` |
| 1.1% | 15.4ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` |
| 1.1% | 15.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` |
| 1.0% | 15.3ms | 0.1% | 1.4ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 1.0% | 15.3ms | 1.0% | 15.3ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3172` |
| 1.0% | 15.1ms | 1.0% | 15.1ms | `getUint32` | `[native code]` |
| 1.0% | 15.1ms | 1.0% | 15.1ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 1.0% | 14.7ms | 0.2% | 2.8ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` |
| 1.0% | 14.2ms | 1.0% | 14.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2229` |
| 1.0% | 14.2ms | 1.0% | 14.2ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` |
| 0.9% | 13.9ms | 0.1% | 1.8ms | `forEach` | `[native code]` |
| 0.9% | 13.0ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3160` |
| 0.8% | 12.1ms | 0.0% | 0us | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2763` |
| 0.8% | 11.9ms | 0.5% | 7.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 0.8% | 11.8ms | 0.8% | 11.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2745` |
| 0.8% | 11.4ms | 0.7% | 9.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2223` |
| 0.8% | 11.3ms | 0.8% | 11.3ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.7% | 10.7ms | 0.2% | 3.2ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:824` |
| 0.7% | 10.7ms | 0.7% | 10.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1176` |
| 0.7% | 10.6ms | 0.7% | 10.6ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.7% | 10.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` |
| 0.7% | 10.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` |
| 0.7% | 10.0ms | 0.7% | 10.0ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2698` |
| 0.6% | 9.7ms | 0.2% | 2.9ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 0.6% | 9.6ms | 0.3% | 4.8ms | `exec` | `[native code]` |
| 0.6% | 8.9ms | 0.0% | 0us | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2934` |
| 0.6% | 8.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` |
| 0.6% | 8.5ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1698` |
| 0.6% | 8.5ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2167` |
| 0.5% | 8.2ms | 0.5% | 8.2ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2846` |
| 0.5% | 8.1ms | 0.2% | 3.3ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2792` |
| 0.5% | 8.1ms | 0.2% | 3.4ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2840` |
| 0.5% | 7.8ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` |
| 0.5% | 7.8ms | 0.5% | 7.8ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:600` |
| 0.5% | 7.8ms | 0.0% | 0us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:533` |
| 0.5% | 7.8ms | 0.5% | 7.8ms | `decode` | `[native code]` |
| 0.5% | 7.8ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7532` |
| 0.5% | 7.6ms | 0.5% | 7.6ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.5% | 7.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` |
| 0.5% | 7.5ms | 0.1% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2071` |
| 0.5% | 7.5ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2029` |
| 0.5% | 7.4ms | 0.5% | 7.4ms | `get` | `[native code]` |
| 0.5% | 7.4ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:597` |
| 0.5% | 7.3ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1694` |
| 0.5% | 7.2ms | 0.5% | 7.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4095` |
| 0.5% | 7.2ms | 0.0% | 0us | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:890` |
| 0.5% | 7.1ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` |
| 0.5% | 7.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:458` |
| 0.4% | 6.5ms | 0.2% | 3.2ms | `readdirSync` | `[native code]` |
| 0.4% | 6.4ms | 0.4% | 6.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1302` |
| 0.4% | 6.4ms | 0.4% | 6.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2738` |
| 0.4% | 6.4ms | 0.4% | 6.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4096` |
| 0.4% | 6.4ms | 0.1% | 1.8ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2677` |
| 0.4% | 6.2ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4147` |
| 0.4% | 6.2ms | 0.2% | 3.1ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3909` |
| 0.4% | 6.0ms | 0.0% | 0us | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3170` |
| 0.4% | 6.0ms | 0.4% | 6.0ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2787` |
| 0.4% | 6.0ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:598` |
| 0.4% | 5.9ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:967` |
| 0.4% | 5.9ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:972` |
| 0.4% | 5.7ms | 0.2% | 3.1ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:840` |
| 0.4% | 5.6ms | 0.2% | 2.8ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2016` |
| 0.3% | 5.5ms | 0.3% | 5.5ms | `test` | `[native code]` |
| 0.3% | 5.4ms | 0.0% | 0us | `scope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:745` |
| 0.3% | 5.4ms | 0.0% | 0us | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2895` |
| 0.3% | 5.4ms | 0.2% | 2.8ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2808` |
| 0.3% | 5.1ms | 0.3% | 5.1ms | `push` | `[native code]` |
| 0.3% | 5.1ms | 0.3% | 5.1ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2586` |
| 0.3% | 5.0ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7016` |
| 0.3% | 5.0ms | 0.2% | 3.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1235` |
| 0.3% | 4.9ms | 0.0% | 0us | `get defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 0.3% | 4.8ms | 0.0% | 1.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2018` |
| 0.3% | 4.7ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:144` |
| 0.3% | 4.7ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:283` |
| 0.3% | 4.7ms | 0.3% | 4.7ms | `DataView` | `[native code]` |
| 0.3% | 4.6ms | 0.3% | 4.6ms | `set` | `[native code]` |
| 0.3% | 4.5ms | 0.2% | 3.0ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` |
| 0.3% | 4.5ms | 0.1% | 1.7ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2190` |
| 0.3% | 4.5ms | 0.3% | 4.5ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3146` |
| 0.3% | 4.5ms | 0.3% | 4.5ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4117` |
| 0.3% | 4.4ms | 0.3% | 4.4ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.3% | 4.4ms | 0.3% | 4.4ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.3% | 4.3ms | 0.1% | 1.7ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1718` |
| 0.2% | 4.2ms | 0.2% | 4.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 4.1ms | 0.2% | 4.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1208` |
| 0.2% | 4.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.2% | 3.5ms | 0.2% | 3.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2117` |
| 0.2% | 3.4ms | 0.2% | 3.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2734` |
| 0.2% | 3.4ms | 0.2% | 3.4ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2992` |
| 0.2% | 3.3ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2227` |
| 0.2% | 3.3ms | 0.2% | 3.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2428` |
| 0.2% | 3.3ms | 0.2% | 3.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4108` |
| 0.2% | 3.2ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:47` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3165` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6476` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2727` |
| 0.2% | 3.2ms | 0.0% | 0us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2701` |
| 0.2% | 3.2ms | 0.2% | 3.2ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 3.1ms | 0.2% | 3.1ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2952` |
| 0.2% | 3.1ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:463` |
| 0.2% | 3.1ms | 0.1% | 1.5ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3595` |
| 0.2% | 3.0ms | 0.1% | 1.5ms | `readFileSync` | `[native code]` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2102` |
| 0.2% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` |
| 0.2% | 3.0ms | 0.2% | 3.0ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` |
| 0.2% | 3.0ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2322` |
| 0.2% | 2.9ms | 0.2% | 2.9ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.2% | 2.9ms | 0.2% | 2.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2052` |
| 0.2% | 2.9ms | 0.2% | 2.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2212` |
| 0.2% | 2.8ms | 0.2% | 2.8ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2054` |
| 0.2% | 2.8ms | 0.2% | 2.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 2.8ms | 0.0% | 0us | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:803` |
| 0.2% | 2.8ms | 0.2% | 2.8ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` |
| 0.2% | 2.8ms | 0.2% | 2.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2697` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7188` |
| 0.1% | 2.5ms | 0.1% | 2.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 2.5ms | 0.1% | 2.5ms | `slice` | `[native code]` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2718` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4329` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `/^\s*globals?\b/` | `[native code]` |
| 0.1% | 1.8ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:776` |
| 0.1% | 1.8ms | 0.0% | 0us | `get identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:756` |
| 0.1% | 1.8ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1501` |
| 0.1% | 1.8ms | 0.1% | 1.8ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3641` |
| 0.1% | 1.7ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2031` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2939` |
| 0.1% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:830` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6474` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4080` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `/^\s*exported\b/` | `[native code]` |
| 0.1% | 1.7ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:747` |
| 0.1% | 1.7ms | 0.0% | 0us | `internal:shared` | `internal:shared:2` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `setPrototypeOf` | `[native code]` |
| 0.1% | 1.7ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.1% | 1.7ms | 0.0% | 0us | `internal:primordials` | `internal:primordials:50` |
| 0.1% | 1.7ms | 0.0% | 0us | `node:events` | `node:events:9` |
| 0.1% | 1.7ms | 0.0% | 0us | `createSafeIterator` | `internal:primordials:14` |
| 0.1% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` |
| 0.1% | 1.7ms | 0.0% | 0us | `internal:validators` | `internal:validators:2` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:808` |
| 0.1% | 1.6ms | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:519` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2869` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7019` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3159` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:514` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2168` |
| 0.1% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` |
| 0.1% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6747` |
| 0.1% | 1.6ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:557` |
| 0.1% | 1.6ms | 0.0% | 0us | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:506` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_isStatementTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 1.6ms | 0.0% | 0us | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:494` |
| 0.1% | 1.6ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:661` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2432` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1691` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `encodeInto` | `[native code]` |
| 0.1% | 1.5ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:215` |
| 0.1% | 1.5ms | 0.0% | 0us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:92` |
| 0.1% | 1.5ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:880` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2430` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:35` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `isRead` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1721` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:641` |
| 0.1% | 1.5ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2674` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3414` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:872` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.1% | 1.4ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:54` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `[native code]` |
| 0.1% | 1.4ms | 0.0% | 0us | `requestFetch` | `[native code]` |
| 0.1% | 1.4ms | 0.0% | 0us | `requestInstantiate` | `[native code]` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `fetch` | `[native code]` |
| 0.1% | 1.4ms | 0.0% | 0us | `requestSatisfyUtil` | `[native code]` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3168` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_computeDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3148` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.4ms | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:506` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `has` | `[native code]` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.4ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7251` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` |
| 0.1% | 1.4ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` |
| 0.1% | 1.4ms | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3840` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `replace` | `[native code]` |
| 0.1% | 1.4ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3905` |
| 0.1% | 1.4ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6857` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6857` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `get identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:755` |
| 0.1% | 1.4ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2225` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:887` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:122` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4141` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2934` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` |
| 0.0% | 1.3ms | 0.0% | 0us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:688` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3615` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3102` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` |
| 0.0% | 1.3ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7535` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `RuleContext` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1292` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:602` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2032` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4328` |
| 0.0% | 1.3ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:77` |
| 0.0% | 1.3ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:76` |
| 0.0% | 1.3ms | 0.0% | 0us | `async lintSource` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:462` |
| 0.0% | 1.3ms | 0.0% | 0us | `async lintSource` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:461` |
| 0.0% | 1.3ms | 0.0% | 0us | `async _resolveConfig` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:71` |
| 0.0% | 1.3ms | 0.0% | 0us | `async _resolveConfig` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:68` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `driveAsyncFunction` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:887` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3358` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:550` |
| 0.0% | 1.2ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4150` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:648` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1706` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:543` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:21` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:892` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:484` |
| 0.0% | 1.1ms | 0.0% | 1.1ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3086` |

## Function Details

### `parse`
`[native code]` | Self: 29.2% (410.2ms) | Total: 29.2% (410.2ms) | Samples: 271

**Called by:**
- `parseSource` (271)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7017` | Self: 4.2% (60.0ms) | Total: 4.2% (60.0ms) | Samples: 40

**Called by:**
- `runPlugins` (40)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2017` | Self: 3.8% (54.2ms) | Total: 4.1% (58.9ms) | Samples: 34

**Called by:**
- `_buildScopeVarsAndSet` (37)

**Calls:**
- `set` (3)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4043` | Self: 3.1% (44.2ms) | Total: 3.1% (44.2ms) | Samples: 29

**Called by:**
- `_nodeViewRaw` (29)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4090` | Self: 2.2% (32.2ms) | Total: 8.2% (116.0ms) | Samples: 22

**Called by:**
- `nodeView` (76)
- `get parent` (1)

**Calls:**
- `_NodeView_LR` (29)
- `_NodeView` (19)
- `_NodeView_LR` (5)
- `_NodeView` (2)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4012` | Self: 2.0% (28.7ms) | Total: 2.0% (28.7ms) | Samples: 19

**Called by:**
- `_nodeViewRaw` (19)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4085` | Self: 1.9% (27.3ms) | Total: 1.9% (27.3ms) | Samples: 19

**Called by:**
- `nodeView` (12)
- `get parent` (3)
- `_buildReference` (2)
- `_nodesFromRange` (1)
- `get body` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1196` | Self: 1.7% (24.5ms) | Total: 7.3% (103.1ms) | Samples: 17

**Called by:**
- `_buildReference` (57)
- `_findDefNode` (6)
- `_computeIsStrict` (3)
- `_computeVarDefs` (2)
- `isUnusedExpression` (1)

**Calls:**
- `nodeView` (41)
- `nodeView` (5)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (1)
- `nodeView` (1)
- `_nodeViewRaw` (1)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` | Self: 1.6% (23.7ms) | Total: 1.6% (23.7ms) | Samples: 16

**Called by:**
- `getRhsNode` (16)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6743` | Self: 1.4% (20.8ms) | Total: 1.4% (20.8ms) | Samples: 14

**Called by:**
- `runPlugins` (14)

### `Set`
`[native code]` | Self: 1.4% (20.2ms) | Total: 1.4% (20.2ms) | Samples: 13

**Called by:**
- `_computeDeclaredVariables` (13)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3166` | Self: 1.3% (19.4ms) | Total: 1.4% (20.7ms) | Samples: 12

**Called by:**
- `getDeclaredVariables` (13)

**Calls:**
- `get` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2107` | Self: 1.2% (17.8ms) | Total: 1.2% (17.8ms) | Samples: 12

**Called by:**
- `_buildReference` (10)
- `_computeVarScope` (1)
- `_buildScope` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` | Self: 1.2% (17.5ms) | Total: 3.7% (52.7ms) | Samples: 12

**Called by:**
- `(anonymous)` (17)
- `collectUnusedVariables` (17)
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `_computeVariableSynthRefs` (15)
- `_computeVariableSynthRefs` (4)
- `_computeVariableSynthRefs` (2)
- `_computeVariableSynthRefs` (2)

### `anonymous`
`[native code]` | Self: 1.1% (15.5ms) | Total: 4.0% (57.4ms) | Samples: 10

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
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:events` (1)
- `internal:shared` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:fs` (1)
- `internal:primordials` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:validators` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3172` | Self: 1.0% (15.3ms) | Total: 1.0% (15.3ms) | Samples: 10

**Called by:**
- `getDeclaredVariables` (10)

### `getUint32`
`[native code]` | Self: 1.0% (15.1ms) | Total: 1.0% (15.1ms) | Samples: 10

**Called by:**
- `get body` (4)
- `get body` (4)
- `_isChainNode` (2)

### `/\/\*([\s\S]*?)\*\//g`
`[native code]` | Self: 1.0% (15.1ms) | Total: 1.0% (15.1ms) | Samples: 10

**Called by:**
- `_buildScopeVarsAndSet` (7)
- `exec` (3)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2229` | Self: 1.0% (14.2ms) | Total: 1.0% (14.2ms) | Samples: 9

**Called by:**
- `_ensureVarsSet` (9)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` | Self: 1.0% (14.2ms) | Total: 1.0% (14.2ms) | Samples: 10

**Called by:**
- `getDeclaredVariables` (10)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2868` | Self: 1.0% (14.1ms) | Total: 1.4% (19.7ms) | Samples: 9

**Called by:**
- `get references` (13)

**Calls:**
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1695` | Self: 0.8% (12.1ms) | Total: 1.2% (18.2ms) | Samples: 8

**Called by:**
- `_computeIsStrict` (12)

**Calls:**
- `getUint32` (4)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2745` | Self: 0.8% (11.8ms) | Total: 0.8% (11.8ms) | Samples: 8

**Called by:**
- `_buildScopeVarsAndSet` (4)
- `_computeDeclaredVariables` (4)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.8% (11.3ms) | Total: 0.8% (11.3ms) | Samples: 7

**Called by:**
- `get parent` (5)
- `_buildReference` (2)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1176` | Self: 0.7% (10.7ms) | Total: 0.7% (10.7ms) | Samples: 7

**Called by:**
- `(anonymous)` (2)
- `getRhsNode` (2)
- `_buildReference` (2)
- `_findDefNode` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.7% (10.6ms) | Total: 0.7% (10.6ms) | Samples: 7

**Called by:**
- `commentsInRange` (4)
- `commentsInRange` (3)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2698` | Self: 0.7% (10.0ms) | Total: 0.7% (10.0ms) | Samples: 7

**Called by:**
- `_buildScopeVarsAndSet` (4)
- `_computeDeclaredVariables` (3)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2223` | Self: 0.7% (9.8ms) | Total: 0.8% (11.4ms) | Samples: 5

**Called by:**
- `_ensureVarsSet` (6)

**Calls:**
- `get` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2846` | Self: 0.5% (8.2ms) | Total: 0.5% (8.2ms) | Samples: 5

**Called by:**
- `get references` (5)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:600` | Self: 0.5% (7.8ms) | Total: 0.5% (7.8ms) | Samples: 5

**Called by:**
- `_precomputeScopes` (5)

### `decode`
`[native code]` | Self: 0.5% (7.8ms) | Total: 0.5% (7.8ms) | Samples: 5

**Called by:**
- `get source` (5)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.5% (7.6ms) | Total: 0.5% (7.6ms) | Samples: 5

**Called by:**
- `_nodeViewRaw` (5)

### `get`
`[native code]` | Self: 0.5% (7.4ms) | Total: 0.5% (7.4ms) | Samples: 5

**Called by:**
- `_ensureDeclSymIndex` (2)
- `_ensureDeclSymIndex` (1)
- `_computeDeclaredVariables` (1)
- `_buildScopeVarsAndSet` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` | Self: 0.5% (7.4ms) | Total: 0.8% (11.9ms) | Samples: 5

**Called by:**
- `some` (8)

**Calls:**
- `get parent` (2)
- `get parent` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` | Self: 0.5% (7.3ms) | Total: 19.9% (280.3ms) | Samples: 5

**Called by:**
- `collectUnusedVariables` (149)
- `(anonymous)` (25)
- `isUsedVariable` (5)
- `_computeDeclaredVariables` (4)

**Calls:**
- `_buildReference` (62)
- `_buildReference` (60)
- `_buildReference` (32)
- `_buildReference` (13)
- `_buildReference` (5)
- `_buildReference` (5)
- `_buildReference` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4095` | Self: 0.5% (7.2ms) | Total: 0.5% (7.2ms) | Samples: 5

**Called by:**
- `nodeView` (4)
- `nodeViewChain` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1302` | Self: 0.4% (6.4ms) | Total: 0.4% (6.4ms) | Samples: 4

**Called by:**
- `getRhsNode` (2)
- `_findDefNode` (1)
- `_buildReference` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2738` | Self: 0.4% (6.4ms) | Total: 0.4% (6.4ms) | Samples: 4

**Called by:**
- `_buildReference` (3)
- `_computeDeclaredVariables` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4096` | Self: 0.4% (6.4ms) | Total: 0.4% (6.4ms) | Samples: 3

**Called by:**
- `nodeView` (3)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2087` | Self: 0.4% (6.1ms) | Total: 4.7% (66.0ms) | Samples: 4

**Called by:**
- `_buildReference` (23)
- `_buildScope` (16)
- `_buildScopeChildren` (5)

**Calls:**
- `_computeIsStrict` (30)
- `_computeIsStrict` (6)
- `_computeIsStrict` (3)
- `_computeIsStrict` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2213` | Self: 0.4% (6.0ms) | Total: 6.1% (86.2ms) | Samples: 4

**Called by:**
- `_ensureVarsSet` (55)

**Calls:**
- `_ensureDeclSymIndex` (37)
- `_ensureDeclSymIndex` (5)
- `_ensureDeclSymIndex` (4)
- `_ensureDeclSymIndex` (3)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2787` | Self: 0.4% (6.0ms) | Total: 0.4% (6.0ms) | Samples: 3

**Called by:**
- `defs` (3)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2589` | Self: 0.4% (5.7ms) | Total: 1.4% (20.6ms) | Samples: 3

**Called by:**
- `_ensureChildren` (12)

**Calls:**
- `_buildScope` (5)
- `_buildScope` (2)
- `_buildScope` (1)
- `_buildScope` (1)

### `test`
`[native code]` | Self: 0.3% (5.5ms) | Total: 0.3% (5.5ms) | Samples: 4

**Called by:**
- `_precomputeScopes` (2)
- `_buildScopeVarsAndSet` (1)
- `_precomputeScopes` (1)

### `push`
`[native code]` | Self: 0.3% (5.1ms) | Total: 0.3% (5.1ms) | Samples: 3

**Called by:**
- `_ensureDeclSymIndex` (2)
- `_buildScopeVarsAndSet` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2586` | Self: 0.3% (5.1ms) | Total: 0.3% (5.1ms) | Samples: 3

**Called by:**
- `_ensureChildren` (3)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2186` | Self: 0.3% (4.8ms) | Total: 3.2% (45.1ms) | Samples: 3

**Called by:**
- `_buildScope` (30)

**Calls:**
- `get body` (12)
- `get body` (6)
- `get body` (4)
- `get body` (3)
- `get body` (1)
- `get body` (1)

### `exec`
`[native code]` | Self: 0.3% (4.8ms) | Total: 0.6% (9.6ms) | Samples: 3

**Called by:**
- `_buildScopeVarsAndSet` (6)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (3)

### `DataView`
`[native code]` | Self: 0.3% (4.7ms) | Total: 0.3% (4.7ms) | Samples: 3

**Called by:**
- `AstView` (3)

### `set`
`[native code]` | Self: 0.3% (4.6ms) | Total: 0.3% (4.6ms) | Samples: 3

**Called by:**
- `_ensureDeclSymIndex` (3)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3146` | Self: 0.3% (4.5ms) | Total: 0.3% (4.5ms) | Samples: 3

**Called by:**
- `getDeclaredVariables` (3)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4117` | Self: 0.3% (4.5ms) | Total: 0.3% (4.5ms) | Samples: 3

**Called by:**
- `_buildScope` (2)
- `get parent` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` | Self: 0.3% (4.4ms) | Total: 0.3% (4.4ms) | Samples: 3

**Called by:**
- `collectUnusedVariables` (3)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` | Self: 0.3% (4.4ms) | Total: 0.3% (4.4ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.2% (4.2ms) | Total: 0.2% (4.2ms) | Samples: 3

**Called by:**
- `_computeIsStrict` (1)
- `(anonymous)` (1)
- `_computeVarDefs` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1208` | Self: 0.2% (4.1ms) | Total: 0.2% (4.1ms) | Samples: 3

**Called by:**
- `_computeIsStrict` (2)
- `_buildReference` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2320` | Self: 0.2% (4.1ms) | Total: 1.7% (24.1ms) | Samples: 3

**Called by:**
- `_ensureVarsSet` (16)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (7)
- `exec` (6)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2117` | Self: 0.2% (3.5ms) | Total: 0.2% (3.5ms) | Samples: 2

**Called by:**
- `_buildReference` (1)
- `_buildScopeChildren` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2734` | Self: 0.2% (3.4ms) | Total: 0.2% (3.4ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2992` | Self: 0.2% (3.4ms) | Total: 0.2% (3.4ms) | Samples: 2

**Called by:**
- `get references` (2)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2840` | Self: 0.2% (3.4ms) | Total: 0.5% (8.1ms) | Samples: 2

**Called by:**
- `get references` (5)

**Calls:**
- `_buildVariable` (3)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2792` | Self: 0.2% (3.3ms) | Total: 0.5% (8.1ms) | Samples: 2

**Called by:**
- `defs` (3)
- `get defs` (2)

**Calls:**
- `get parent` (2)
- `get parent` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2428` | Self: 0.2% (3.3ms) | Total: 0.2% (3.3ms) | Samples: 2

**Called by:**
- `_ensureVarsSet` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4108` | Self: 0.2% (3.3ms) | Total: 0.2% (3.3ms) | Samples: 2

**Called by:**
- `nodeView` (2)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2833` | Self: 0.2% (3.3ms) | Total: 3.7% (53.2ms) | Samples: 2

**Called by:**
- `get references` (32)
- `_ensureVarsSet` (1)

**Calls:**
- `nodeView` (27)
- `_nodeViewRaw` (2)
- `nodeView` (2)

### `readdirSync`
`[native code]` | Self: 0.2% (3.2ms) | Total: 0.4% (6.5ms) | Samples: 1

**Called by:**
- `readdirSync` (1)
- `loadCoreRules` (1)

**Calls:**
- `readdirSync` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3165` | Self: 0.2% (3.2ms) | Total: 0.2% (3.2ms) | Samples: 2

**Called by:**
- `getDeclaredVariables` (2)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` | Self: 0.2% (3.2ms) | Total: 0.2% (3.2ms) | Samples: 2

**Called by:**
- `isUsedVariable` (2)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6476` | Self: 0.2% (3.2ms) | Total: 0.2% (3.2ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2727` | Self: 0.2% (3.2ms) | Total: 0.2% (3.2ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:824` | Self: 0.2% (3.2ms) | Total: 0.7% (10.7ms) | Samples: 2

**Called by:**
- `_ensureDeclSymIndex` (5)
- `_buildVariable` (2)

**Calls:**
- `_buildSymNameCache` (4)
- `_buildSymNameCache` (1)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.2% (3.2ms) | Total: 0.2% (3.2ms) | Samples: 2

**Called by:**
- `_nodeViewRaw` (2)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:845` | Self: 0.2% (3.2ms) | Total: 13.2% (186.2ms) | Samples: 2

**Called by:**
- `get` (117)
- `_ensureVarsSet` (1)

**Calls:**
- `_buildScopeVarsAndSet` (55)
- `_buildScopeVarsAndSet` (18)
- `_buildScopeVarsAndSet` (16)
- `_buildScopeVarsAndSet` (9)
- `_buildScopeVarsAndSet` (6)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1235` | Self: 0.2% (3.1ms) | Total: 0.3% (5.0ms) | Samples: 2

**Called by:**
- `_buildReference` (2)
- `_findDefNode` (1)

**Calls:**
- `get value` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` | Self: 0.2% (3.1ms) | Total: 6.4% (90.9ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (54)
- `Program:exit` (6)

**Calls:**
- `some` (29)
- `isUsedVariable` (17)
- `isUsedVariable` (12)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2952` | Self: 0.2% (3.1ms) | Total: 0.2% (3.1ms) | Samples: 2

**Called by:**
- `get references` (2)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:840` | Self: 0.2% (3.1ms) | Total: 0.4% (5.7ms) | Samples: 2

**Called by:**
- `_symName` (4)

**Calls:**
- `slice` (2)

### `_isChainNode`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3909` | Self: 0.2% (3.1ms) | Total: 0.4% (6.2ms) | Samples: 2

**Called by:**
- `nodeViewChain` (4)

**Calls:**
- `getUint32` (2)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2844` | Self: 0.2% (3.1ms) | Total: 6.6% (93.5ms) | Samples: 2

**Called by:**
- `get references` (62)

**Calls:**
- `_buildScope` (23)
- `_buildScope` (21)
- `_buildScope` (10)
- `_buildScope` (4)
- `_buildScope` (1)
- `_buildScope` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2102` | Self: 0.2% (3.0ms) | Total: 0.2% (3.0ms) | Samples: 2

**Called by:**
- `_buildScope` (1)
- `_buildReference` (1)

### `isSelfReference`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` | Self: 0.2% (3.0ms) | Total: 0.2% (3.0ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` | Self: 0.2% (3.0ms) | Total: 0.3% (4.5ms) | Samples: 2

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `isRead` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` | Self: 0.2% (2.9ms) | Total: 0.2% (2.9ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2052` | Self: 0.2% (2.9ms) | Total: 0.2% (2.9ms) | Samples: 2

**Called by:**
- `_buildScope` (1)
- `_computeVarScope` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` | Self: 0.2% (2.9ms) | Total: 0.6% (9.7ms) | Samples: 2

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `get parent` (2)
- `get parent` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2212` | Self: 0.2% (2.9ms) | Total: 0.2% (2.9ms) | Samples: 2

**Called by:**
- `_ensureVarsSet` (2)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` | Self: 0.2% (2.8ms) | Total: 1.0% (14.7ms) | Samples: 2

**Called by:**
- `_computeVarDefs` (10)

**Calls:**
- `get parent` (6)
- `get parent` (1)
- `get parent` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2054` | Self: 0.2% (2.8ms) | Total: 0.2% (2.8ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `_computeVarScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2808` | Self: 0.2% (2.8ms) | Total: 0.3% (5.4ms) | Samples: 2

**Called by:**
- `scope` (4)

**Calls:**
- `_buildScope` (1)
- `_buildScope` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.2% (2.8ms) | Total: 0.2% (2.8ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` | Self: 0.2% (2.8ms) | Total: 0.2% (2.8ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (2)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2016` | Self: 0.2% (2.8ms) | Total: 0.4% (5.6ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (4)

**Calls:**
- `get` (2)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2900` | Self: 0.2% (2.8ms) | Total: 1.6% (23.1ms) | Samples: 2

**Called by:**
- `get references` (15)

**Calls:**
- `nodeView` (13)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2697` | Self: 0.2% (2.8ms) | Total: 0.2% (2.8ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (1)
- `_computeDeclaredVariables` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7188` | Self: 0.1% (2.7ms) | Total: 0.1% (2.7ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` | Self: 0.1% (2.7ms) | Total: 1.8% (26.2ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (17)

**Calls:**
- `some` (10)
- `get references` (5)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (2.5ms) | Total: 0.1% (2.5ms) | Samples: 2

**Called by:**
- `_buildScopeChildren` (2)

### `slice`
`[native code]` | Self: 0.1% (2.5ms) | Total: 0.1% (2.5ms) | Samples: 2

**Called by:**
- `_buildSymNameCache` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2718` | Self: 0.1% (1.8ms) | Total: 0.1% (1.8ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2677` | Self: 0.1% (1.8ms) | Total: 0.4% (6.4ms) | Samples: 1

**Called by:**
- `getScope` (4)

**Calls:**
- `test` (2)
- `/^\s*exported\b/` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4329` | Self: 0.1% (1.8ms) | Total: 0.1% (1.8ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` | Self: 0.1% (1.8ms) | Total: 13.0% (183.1ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (120)

**Calls:**
- `isAfterLastUsedArg` (71)
- `isAfterLastUsedArg` (44)
- `isAfterLastUsedArg` (3)
- `isAfterLastUsedArg` (1)

### `/^\s*globals?\b/`
`[native code]` | Self: 0.1% (1.8ms) | Total: 0.1% (1.8ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3641` | Self: 0.1% (1.8ms) | Total: 0.1% (1.8ms) | Samples: 1

**Called by:**
- `get value` (1)

### `forEach`
`[native code]` | Self: 0.1% (1.8ms) | Total: 0.9% (13.9ms) | Samples: 1

**Called by:**
- `getFunctionDefinitions` (9)

**Calls:**
- `(anonymous)` (6)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2939` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:830` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `_symName` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6474` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2190` | Self: 0.1% (1.7ms) | Total: 0.3% (4.5ms) | Samples: 1

**Called by:**
- `_buildScope` (3)

**Calls:**
- `get directive` (1)
- `get directive` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4080` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `get parent` (1)

### `/^\s*exported\b/`
`[native code]` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` | Self: 0.1% (1.7ms) | Total: 3.2% (45.1ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (28)
- `get identifiers` (1)
- `isAfterLastUsedArg` (1)

**Calls:**
- `_computeVarDefs` (14)
- `_computeVarDefs` (9)
- `_computeVarDefs` (3)
- `_computeVarDefs` (3)

### `setPrototypeOf`
`[native code]` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `createSafeIterator` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` | Self: 0.1% (1.7ms) | Total: 1.5% (21.9ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (14)

**Calls:**
- `Set` (13)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1718` | Self: 0.1% (1.7ms) | Total: 0.3% (4.3ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (3)

**Calls:**
- `_nodeViewRaw` (1)
- `nodeView` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:808` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2869` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `get references` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7019` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3159` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:514` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `_computeVarDefs` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2071` | Self: 0.1% (1.6ms) | Total: 0.5% (7.5ms) | Samples: 1

**Called by:**
- `_buildReference` (4)
- `_buildScope` (1)

**Calls:**
- `nodeView` (2)
- `nodeView` (2)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2168` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6747` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_isStatementTag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `get range` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2432` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1691` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `encodeInto`
`[native code]` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `_encodeSource` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` | Self: 0.1% (1.5ms) | Total: 2.6% (37.8ms) | Samples: 1

**Called by:**
- `some` (25)

**Calls:**
- `getRhsNode` (16)
- `getRhsNode` (6)
- `getRhsNode` (1)
- `getRhsNode` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2430` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `readFileSync`
`[native code]` | Self: 0.1% (1.5ms) | Total: 0.2% (3.0ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)
- `readFileSync` (1)

**Calls:**
- `readFileSync` (1)

### `isRead`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `isReadForItself` (1)

### `some`
`[native code]` | Self: 0.1% (1.5ms) | Total: 9.9% (139.3ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (44)
- `collectUnusedVariables` (29)
- `isUsedVariable` (10)
- `collectUnusedVariables` (8)
- `walkNodes` (1)

**Calls:**
- `(anonymous)` (43)
- `(anonymous)` (25)
- `(anonymous)` (8)
- `(anonymous)` (7)
- `(anonymous)` (5)
- `(anonymous)` (2)
- `(anonymous)` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1721` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:641` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `commentsInRange` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3595` | Self: 0.1% (1.5ms) | Total: 0.2% (3.1ms) | Samples: 1

**Called by:**
- `isInside` (1)
- `get references` (1)

**Calls:**
- `_isStatementTag` (1)

### `get directive`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3414` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:872` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `fetch`
`[native code]` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `requestFetch` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3168` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` | Self: 0.1% (1.4ms) | Total: 1.0% (15.3ms) | Samples: 1

**Called by:**
- `isUsedVariable` (10)

**Calls:**
- `forEach` (9)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3148` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `has`
`[native code]` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `_findDefNode` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `replace`
`[native code]` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `_execReport` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6857` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `some` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get identifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:755` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` | Self: 0.1% (1.4ms) | Total: 19.2% (269.9ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (177)

**Calls:**
- `get references` (149)
- `get references` (17)
- `some` (8)
- `get references` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:887` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:122` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4141` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `init` (1)

### `get init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2934` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2018` | Self: 0.0% (1.3ms) | Total: 0.3% (4.8ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (3)

**Calls:**
- `push` (2)

### `range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3615` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `get references` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3102` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2782` | Self: 0.0% (1.3ms) | Total: 1.5% (22.0ms) | Samples: 1

**Called by:**
- `defs` (14)
- `get defs` (1)

**Calls:**
- `_findDefNode` (10)
- `_findDefNode` (1)
- `_findDefNode` (1)
- `_findDefNode` (1)
- `_findDefNode` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2066` | Self: 0.0% (1.3ms) | Total: 3.8% (53.4ms) | Samples: 1

**Called by:**
- `_buildReference` (21)
- `_buildScope` (14)

**Calls:**
- `_buildScope` (16)
- `_buildScope` (14)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `RuleContext`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1292` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:602` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2032` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4328` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `driveAsyncFunction`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `async _resolveConfigImpl` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:887` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `get body` (1)

### `get directive`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3358` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `nodeLhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:550` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `get body` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:648` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `commentsInRange` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1706` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:543` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:892` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:484` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_computeVarDefs` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3086` | Self: 0.0% (1.1ms) | Total: 0.0% (1.1ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2673` | Self: 0.0% (0us) | Total: 1.6% (22.5ms) | Samples: 0

**Called by:**
- `getScope` (15)

**Calls:**
- `commentsInRange` (5)
- `commentsInRange` (5)
- `commentsInRange` (4)
- `commentsInRange` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` | Self: 0.0% (0us) | Total: 4.6% (65.6ms) | Samples: 0

**Called by:**
- `some` (43)

**Calls:**
- `get references` (25)
- `get references` (17)
- `get references` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2222` | Self: 0.0% (0us) | Total: 2.0% (28.2ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (18)

**Calls:**
- `_buildVariable` (4)
- `_buildVariable` (4)
- `_buildVariable` (2)
- `_buildVariable` (2)
- `_buildVariable` (2)
- `_buildVariable` (2)
- `_buildVariable` (1)
- `_buildVariable` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:661` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isInside` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:880` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `_buildReference` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2031` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `get` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` | Self: 0.0% (0us) | Total: 0.7% (10.2ms) | Samples: 0

**Called by:**
- `some` (7)

**Calls:**
- `isForInOfRef` (3)
- `isForInOfRef` (1)
- `isForInOfRef` (1)
- `isForInOfRef` (1)
- `isForInOfRef` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` | Self: 0.0% (0us) | Total: 0.2% (3.0ms) | Samples: 0

**Called by:**
- `some` (2)

**Calls:**
- `isSelfReference` (2)

### `async _resolveConfig`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:71` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `async _resolveConfig` (1)

**Calls:**
- `async _resolveConfigImpl` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:144` | Self: 0.0% (0us) | Total: 0.3% (4.7ms) | Samples: 0

**Calls:**
- `loadCoreRules` (1)
- `loadCoreRules` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:300` | Self: 0.0% (0us) | Total: 29.8% (419.6ms) | Samples: 0

**Calls:**
- `parseSource` (271)
- `parseSource` (5)
- `parseSource` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:598` | Self: 0.0% (0us) | Total: 0.4% (6.0ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (4)

**Calls:**
- `_findLineIdx` (4)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` | Self: 0.0% (0us) | Total: 15.3% (216.2ms) | Samples: 0

**Called by:**
- `Program:exit` (72)
- `collectUnusedVariables` (64)

**Calls:**
- `get` (117)
- `get` (15)
- `get` (4)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2225` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `get identifiers` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2763` | Self: 0.0% (0us) | Total: 0.8% (12.1ms) | Samples: 0

**Called by:**
- `defs` (9)

**Calls:**
- `nodeView` (9)

### `requestFetch`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `fetch` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:77` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Calls:**
- `async lintSource` (1)

### `async lintSource`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:462` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `async lintSource` (1)

**Calls:**
- `async _resolveConfig` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:967` | Self: 0.0% (0us) | Total: 0.4% (5.9ms) | Samples: 0

**Called by:**
- `get` (4)

**Calls:**
- `_ensureVarsSet` (1)
- `_ensureVarsSet` (1)
- `_ensureVarsSet` (1)
- `_ensureVarsSet` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4150` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `init` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7016` | Self: 0.0% (0us) | Total: 0.3% (5.0ms) | Samples: 0

**Called by:**
- `runPlugins` (3)

**Calls:**
- `getDFSEvents` (2)
- `getDFSEvents` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:803` | Self: 0.0% (0us) | Total: 0.2% (2.8ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (2)

**Calls:**
- `get range` (1)
- `range` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7540` | Self: 0.0% (0us) | Total: 67.6% (949.6ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (619)

**Calls:**
- `walkNodes` (555)
- `walkNodes` (40)
- `walkNodes` (14)
- `walkNodes` (3)
- `walkNodes` (2)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)

### `async lintSource`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:461` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `async lintSource` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2227` | Self: 0.0% (0us) | Total: 0.2% (3.3ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (2)

**Calls:**
- `get references` (1)
- `push` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7256` | Self: 0.0% (0us) | Total: 60.7% (853.3ms) | Samples: 0

**Called by:**
- `runPlugins` (555)

**Calls:**
- `_invokeFused` (554)
- `_invokeFused` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:21` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` | Self: 0.0% (0us) | Total: 2.1% (30.4ms) | Samples: 0

**Called by:**
- `_invokeFused` (20)

**Calls:**
- `getScope` (20)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:35` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `readFileSync` (1)

### `async _resolveConfig`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:68` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `async lintSource` (1)

**Calls:**
- `async _resolveConfig` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:519` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `_computeVarDefs` (1)

**Calls:**
- `get parent` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:776` | Self: 0.0% (0us) | Total: 0.1% (1.8ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `get identifiers` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `report` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4147` | Self: 0.0% (0us) | Total: 0.4% (6.2ms) | Samples: 0

**Called by:**
- `init` (4)

**Calls:**
- `_isChainNode` (4)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:972` | Self: 0.0% (0us) | Total: 0.4% (5.9ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (4)

**Calls:**
- `_ensureVarsSet` (4)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:533` | Self: 0.0% (0us) | Total: 0.5% (7.8ms) | Samples: 0

**Called by:**
- `runPlugins` (5)

**Calls:**
- `decode` (5)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4672` | Self: 0.0% (0us) | Total: 60.6% (851.9ms) | Samples: 0

**Called by:**
- `walkNodes` (554)

**Calls:**
- `Program:exit` (532)
- `Program:exit` (20)
- `Program:exit` (1)
- `Program:exit` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1694` | Self: 0.0% (0us) | Total: 0.5% (7.3ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (4)
- `isForInOfRef` (1)

**Calls:**
- `getUint32` (4)
- `nodeLhs` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7535` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `RuleContext` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2701` | Self: 0.0% (0us) | Total: 0.2% (3.2ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (2)

**Calls:**
- `_symName` (2)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:47` | Self: 0.0% (0us) | Total: 0.2% (3.2ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (1)

**Calls:**
- `readdirSync` (1)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 3.4% (48.6ms) | Samples: 0

**Called by:**
- `bound require` (33)

**Calls:**
- `anonymous` (33)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:752` | Self: 0.0% (0us) | Total: 4.7% (67.1ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (44)

**Calls:**
- `some` (44)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` | Self: 0.0% (0us) | Total: 1.1% (15.4ms) | Samples: 0

**Called by:**
- `parseModule` (10)

**Calls:**
- `async (anonymous)` (10)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:304` | Self: 0.0% (0us) | Total: 68.2% (958.7ms) | Samples: 0

**Calls:**
- `runPlugins` (619)
- `runPlugins` (5)
- `runPlugins` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3160` | Self: 0.0% (0us) | Total: 0.9% (13.0ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (9)

**Calls:**
- `_buildVariable` (4)
- `_buildVariable` (3)
- `_buildVariable` (1)
- `_buildVariable` (1)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 1.5% (21.6ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)
- `requestInstantiate` (1)

**Calls:**
- `parseModule` (12)
- `async (anonymous)` (1)
- `requestFetch` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:215` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `_encodeSource` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:597` | Self: 0.0% (0us) | Total: 0.5% (7.4ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (5)

**Calls:**
- `_findLineIdx` (3)
- `_findLineIdx` (1)
- `_findLineIdx` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:458` | Self: 0.0% (0us) | Total: 0.5% (7.1ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `patchAstUtils` (5)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` | Self: 0.0% (0us) | Total: 58.2% (818.7ms) | Samples: 0

**Called by:**
- `_invokeFused` (532)

**Calls:**
- `collectUnusedVariables` (454)
- `collectUnusedVariables` (72)
- `collectUnusedVariables` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` | Self: 0.0% (0us) | Total: 1.1% (15.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (10)

**Calls:**
- `async (anonymous)` (10)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` | Self: 0.0% (0us) | Total: 0.5% (7.8ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (5)

**Calls:**
- `AstView` (3)
- `AstView` (2)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:92` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `encodeInto` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `forEach` (1)

**Calls:**
- `init` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4122` | Self: 0.0% (0us) | Total: 10.5% (148.0ms) | Samples: 0

**Called by:**
- `get parent` (41)
- `_buildReference` (27)
- `_computeVariableSynthRefs` (13)
- `_computeVarDefs` (9)
- `_nodesFromRange` (4)
- `_buildScope` (2)
- `get body` (1)

**Calls:**
- `_nodeViewRaw` (76)
- `_nodeViewRaw` (12)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (2)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:283` | Self: 0.0% (0us) | Total: 0.3% (4.7ms) | Samples: 0

**Called by:**
- `parseSource` (3)

**Calls:**
- `DataView` (3)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` | Self: 0.0% (0us) | Total: 100.0% (2.75s) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1334)
- `Program:exit` (454)

**Calls:**
- `collectUnusedVariables` (1334)
- `collectUnusedVariables` (177)
- `collectUnusedVariables` (120)
- `collectUnusedVariables` (64)
- `collectUnusedVariables` (54)
- `collectUnusedVariables` (31)
- `collectUnusedVariables` (2)
- `collectUnusedVariables` (2)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3905` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `Program:exit` (1)

**Calls:**
- `_execReport` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `bound require` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:506` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `_computeVarDefs` (1)

**Calls:**
- `has` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6857` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `some` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:688` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get body` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:747` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `defs` (1)

### `_computeDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3170` | Self: 0.0% (0us) | Total: 0.4% (6.0ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (4)

**Calls:**
- `get references` (4)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3840` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `report` (1)

**Calls:**
- `replace` (1)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1898` | Self: 0.0% (0us) | Total: 2.1% (30.4ms) | Samples: 0

**Called by:**
- `Program:exit` (20)

**Calls:**
- `_precomputeScopes` (15)
- `_precomputeScopes` (4)
- `_precomputeScopes` (1)

### `requestInstantiate`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `requestSatisfyUtil` (1)

**Calls:**
- `async (anonymous)` (1)

### `_ensureChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:924` | Self: 0.0% (0us) | Total: 1.8% (25.7ms) | Samples: 0

**Called by:**
- `get` (15)

**Calls:**
- `_buildScopeChildren` (12)
- `_buildScopeChildren` (3)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:463` | Self: 0.0% (0us) | Total: 0.2% (3.1ms) | Samples: 0

**Called by:**
- `parseSource` (2)

**Calls:**
- `CfgGraph` (1)
- `CfgGraph` (1)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 3.5% (50.4ms) | Samples: 0

**Called by:**
- `async (anonymous)` (10)
- `(anonymous)` (7)
- `patchAstUtils` (5)
- `(anonymous)` (3)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `loadCoreRules` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `require` (33)
- `anonymous` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` | Self: 0.0% (0us) | Total: 29.2% (410.2ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (271)

**Calls:**
- `parse` (271)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2674` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `getScope` (1)

**Calls:**
- `test` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` | Self: 0.0% (0us) | Total: 3.3% (46.6ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (31)

**Calls:**
- `defs` (28)
- `get defs` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` | Self: 0.0% (0us) | Total: 0.7% (10.4ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:72` | Self: 0.0% (0us) | Total: 1.1% (15.4ms) | Samples: 0

**Called by:**
- `async (anonymous)` (10)

**Calls:**
- `bound require` (10)

### `internal:shared`
`internal:shared:2` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` | Self: 0.0% (0us) | Total: 1.3% (18.6ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (12)

**Calls:**
- `getFunctionDefinitions` (10)
- `getFunctionDefinitions` (2)

### `createSafeIterator`
`internal:primordials:14` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `internal:primordials` (1)

**Calls:**
- `setPrototypeOf` (1)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:54` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` | Self: 0.0% (0us) | Total: 0.5% (7.6ms) | Samples: 0

**Called by:**
- `some` (5)

**Calls:**
- `isReadForItself` (3)
- `isReadForItself` (1)
- `isReadForItself` (1)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` | Self: 0.0% (0us) | Total: 0.5% (7.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `bound require` (5)

### `scope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:745` | Self: 0.0% (0us) | Total: 0.3% (5.4ms) | Samples: 0

**Called by:**
- `_computeVariableSynthRefs` (4)

**Calls:**
- `_computeVarScope` (4)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2934` | Self: 0.0% (0us) | Total: 0.6% (8.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `nodeViewChain` (4)
- `nodeViewChain` (1)
- `nodeViewChain` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `forEach` (1)

**Calls:**
- `get init` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2895` | Self: 0.0% (0us) | Total: 0.3% (5.4ms) | Samples: 0

**Called by:**
- `get references` (4)

**Calls:**
- `scope` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.2% (4.0ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3101` | Self: 0.0% (0us) | Total: 7.5% (105.4ms) | Samples: 0

**Called by:**
- `isAfterLastUsedArg` (69)

**Calls:**
- `_computeDeclaredVariables` (14)
- `_computeDeclaredVariables` (13)
- `_computeDeclaredVariables` (10)
- `_computeDeclaredVariables` (10)
- `_computeDeclaredVariables` (9)
- `_computeDeclaredVariables` (4)
- `_computeDeclaredVariables` (3)
- `_computeDeclaredVariables` (2)
- `_computeDeclaredVariables` (1)
- `_computeDeclaredVariables` (1)
- `_computeDeclaredVariables` (1)
- `_computeDeclaredVariables` (1)

### `get defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` | Self: 0.0% (0us) | Total: 0.3% (4.9ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (3)

**Calls:**
- `_computeVarDefs` (2)
- `_computeVarDefs` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:957` | Self: 0.0% (0us) | Total: 1.8% (25.7ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (15)

**Calls:**
- `_ensureChildren` (15)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2322` | Self: 0.0% (0us) | Total: 0.2% (3.0ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (2)

**Calls:**
- `test` (1)
- `/^\s*globals?\b/` (1)

### `node:events`
`node:events:9` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` | Self: 0.0% (0us) | Total: 7.6% (107.9ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (71)

**Calls:**
- `getDeclaredVariables` (69)
- `getDeclaredVariables` (1)
- `getDeclaredVariables` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:557` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isUnusedExpression` (1)

### `parseModule`
`[native code]` | Self: 0.0% (0us) | Total: 1.3% (18.7ms) | Samples: 0

**Called by:**
- `async (anonymous)` (12)

**Calls:**
- `(anonymous)` (10)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:76` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `async _resolveConfig` (1)

**Calls:**
- `driveAsyncFunction` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1698` | Self: 0.0% (0us) | Total: 0.6% (8.5ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (6)

**Calls:**
- `_nodesFromRange` (5)
- `_nodesFromRange` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` | Self: 0.0% (0us) | Total: 0.6% (8.9ms) | Samples: 0

**Called by:**
- `forEach` (6)

**Calls:**
- `init` (6)

### `get identifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:756` | Self: 0.0% (0us) | Total: 0.1% (1.8ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `defs` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2167` | Self: 0.0% (0us) | Total: 0.6% (8.5ms) | Samples: 0

**Called by:**
- `_buildScope` (6)

**Calls:**
- `get parent` (3)
- `get parent` (2)
- `get parent` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7251` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_fireCfgEvents` (1)

### `(anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Calls:**
- `requestSatisfyUtil` (1)

### `requestSatisfyUtil`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `requestInstantiate` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:953` | Self: 0.0% (0us) | Total: 13.1% (184.5ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (117)

**Calls:**
- `_ensureVarsSet` (117)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:890` | Self: 0.0% (0us) | Total: 0.5% (7.2ms) | Samples: 0

**Called by:**
- `get body` (5)

**Calls:**
- `nodeView` (4)
- `_nodeViewRaw` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1501` | Self: 0.0% (0us) | Total: 0.1% (1.8ms) | Samples: 0

**Called by:**
- `get parent` (1)

**Calls:**
- `get loc` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` | Self: 0.0% (0us) | Total: 1.6% (23.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (16)

**Calls:**
- `isInLoop` (16)

### `isUnusedExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:506` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `getRhsNode` (1)

**Calls:**
- `get parent` (1)

### `isInside`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:494` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `isReadForItself` (1)

**Calls:**
- `get range` (1)

### `internal:primordials`
`internal:primordials:50` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `createSafeIterator` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `internal:validators`
`internal:validators:2` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7532` | Self: 0.0% (0us) | Total: 0.5% (7.8ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (5)

**Calls:**
- `get source` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2029` | Self: 0.0% (0us) | Total: 0.5% (7.5ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (5)

**Calls:**
- `_symName` (5)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2837` | Self: 0.0% (0us) | Total: 6.3% (89.8ms) | Samples: 0

**Called by:**
- `get references` (60)

**Calls:**
- `get parent` (57)
- `get parent` (2)
- `get parent` (1)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 38.4% | 539.9ms | `[native code]` |
| 35.6% | 501.0ms | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 21.5% | 303.1ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 4.2% | 59.2ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.0% | 1.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs` |
