# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 5.41s | 3541 | 1.0ms | 391 |

**Top 10:** `parse` 24.1%, `_nodeViewRaw` 6.0%, `walkNodes` 4.3%, `_nodeViewRaw` 2.8%, `Set` 2.6%, `_ensureDeclSymIndex` 2.6%, `getDeclaredVariables` 2.4%, `get _tag` 2.2%, `get _tag` 2.1%, `get type` 1.9%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 24.1% | 1.30s | 24.1% | 1.30s | `parse` | `[native code]` |
| 6.0% | 324.8ms | 6.0% | 329.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3994` |
| 4.3% | 236.9ms | 4.7% | 258.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6950` |
| 2.8% | 155.0ms | 2.8% | 155.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4005` |
| 2.6% | 145.1ms | 2.6% | 145.1ms | `Set` | `[native code]` |
| 2.6% | 141.8ms | 2.7% | 148.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2013` |
| 2.4% | 133.6ms | 2.4% | 133.6ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3133` |
| 2.2% | 123.8ms | 2.2% | 123.8ms | `get _tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1072` |
| 2.1% | 115.5ms | 2.1% | 115.5ms | `get _tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 1.9% | 105.3ms | 1.9% | 105.3ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 1.8% | 100.9ms | 1.8% | 102.3ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3139` |
| 1.8% | 97.6ms | 2.4% | 129.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1222` |
| 1.4% | 78.8ms | 1.4% | 78.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1175` |
| 1.2% | 69.0ms | 1.2% | 69.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4001` |
| 1.1% | 60.2ms | 1.1% | 60.2ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1006` |
| 1.0% | 54.4ms | 2.4% | 134.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2865` |
| 0.9% | 53.3ms | 1.5% | 86.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1285` |
| 0.9% | 49.6ms | 0.9% | 49.6ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` |
| 0.8% | 47.7ms | 0.8% | 47.7ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.8% | 43.8ms | 0.8% | 43.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6706` |
| 0.7% | 42.7ms | 0.8% | 45.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2219` |
| 0.7% | 40.1ms | 0.8% | 46.0ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 0.7% | 38.5ms | 0.7% | 38.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2225` |
| 0.6% | 36.9ms | 1.4% | 75.8ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` |
| 0.6% | 36.8ms | 6.1% | 333.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1189` |
| 0.6% | 36.1ms | 27.0% | 1.46s | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 0.6% | 32.4ms | 1.8% | 98.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 0.5% | 32.2ms | 1.6% | 91.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1274` |
| 0.5% | 31.7ms | 0.5% | 31.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2142` |
| 0.5% | 31.5ms | 0.5% | 31.5ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2741` |
| 0.5% | 30.5ms | 0.5% | 30.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2103` |
| 0.5% | 29.8ms | 0.5% | 29.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3986` |
| 0.5% | 29.1ms | 0.5% | 29.1ms | `getUint32` | `[native code]` |
| 0.5% | 28.9ms | 0.5% | 28.9ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3087` |
| 0.5% | 28.2ms | 1.5% | 86.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1255` |
| 0.5% | 27.2ms | 0.5% | 27.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4002` |
| 0.4% | 26.8ms | 0.4% | 26.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3995` |
| 0.4% | 26.2ms | 0.4% | 26.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4006` |
| 0.4% | 25.6ms | 4.0% | 217.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2209` |
| 0.4% | 25.0ms | 0.5% | 29.8ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.4% | 22.1ms | 0.4% | 22.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4003` |
| 0.4% | 21.9ms | 0.4% | 21.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4004` |
| 0.3% | 21.3ms | 0.8% | 44.9ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` |
| 0.3% | 20.7ms | 0.3% | 20.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3999` |
| 0.3% | 20.3ms | 0.3% | 20.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3991` |
| 0.3% | 20.1ms | 5.0% | 274.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2083` |
| 0.3% | 18.8ms | 0.4% | 23.2ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2896` |
| 0.3% | 18.5ms | 0.3% | 18.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3997` |
| 0.3% | 18.4ms | 0.3% | 18.4ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3121` |
| 0.3% | 18.0ms | 0.3% | 18.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1295` |
| 0.3% | 17.9ms | 0.3% | 17.9ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2842` |
| 0.3% | 17.8ms | 1.2% | 66.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2316` |
| 0.3% | 17.1ms | 1.3% | 74.3ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:868` |
| 0.3% | 16.8ms | 0.3% | 16.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3998` |
| 0.3% | 16.6ms | 0.3% | 16.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2211` |
| 0.3% | 16.2ms | 0.3% | 17.7ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` |
| 0.2% | 15.9ms | 0.3% | 17.6ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:818` |
| 0.2% | 15.8ms | 1.1% | 60.1ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2585` |
| 0.2% | 15.6ms | 3.4% | 185.3ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3132` |
| 0.2% | 14.9ms | 0.2% | 14.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4000` |
| 0.2% | 14.8ms | 0.2% | 14.8ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4056` |
| 0.2% | 14.5ms | 0.2% | 14.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7118` |
| 0.2% | 14.3ms | 0.3% | 17.1ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` |
| 0.2% | 13.8ms | 6.8% | 368.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2840` |
| 0.2% | 13.7ms | 0.2% | 13.7ms | `decode` | `[native code]` |
| 0.2% | 13.7ms | 0.2% | 13.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6951` |
| 0.2% | 13.6ms | 0.2% | 14.7ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:506` |
| 0.2% | 13.6ms | 8.2% | 445.8ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 0.2% | 13.6ms | 0.2% | 13.6ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` |
| 0.2% | 13.4ms | 0.2% | 13.4ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1067` |
| 0.2% | 13.1ms | 0.8% | 46.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1237` |
| 0.2% | 12.9ms | 0.2% | 12.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6949` |
| 0.2% | 12.8ms | 0.3% | 18.8ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2836` |
| 0.2% | 12.4ms | 1.0% | 57.6ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2788` |
| 0.2% | 12.3ms | 0.2% | 15.6ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2014` |
| 0.2% | 12.3ms | 0.2% | 12.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 12.0ms | 0.8% | 45.4ms | `anonymous` | `[native code]` |
| 0.2% | 12.0ms | 0.2% | 12.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3996` |
| 0.2% | 11.6ms | 5.5% | 300.9ms | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 0.2% | 11.5ms | 0.2% | 11.5ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:865` |
| 0.2% | 11.5ms | 0.2% | 11.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 10.9ms | 2.8% | 156.0ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` |
| 0.2% | 10.8ms | 0.2% | 10.8ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4876` |
| 0.1% | 10.8ms | 0.1% | 10.8ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3106` |
| 0.1% | 10.7ms | 0.1% | 10.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2694` |
| 0.1% | 10.7ms | 0.1% | 10.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2113` |
| 0.1% | 10.6ms | 0.1% | 10.6ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 10.5ms | 0.1% | 10.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2424` |
| 0.1% | 10.2ms | 0.1% | 10.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2208` |
| 0.1% | 9.7ms | 0.1% | 9.7ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 9.7ms | 0.1% | 9.7ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 9.6ms | 0.1% | 9.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2428` |
| 0.1% | 9.4ms | 11.2% | 607.3ms | `some` | `[native code]` |
| 0.1% | 9.3ms | 5.2% | 285.3ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 0.1% | 8.3ms | 0.1% | 8.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 8.2ms | 0.3% | 16.4ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2673` |
| 0.1% | 8.1ms | 0.1% | 8.1ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2734` |
| 0.1% | 7.9ms | 0.3% | 18.9ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.1% | 7.9ms | 0.1% | 7.9ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2582` |
| 0.1% | 7.8ms | 24.6% | 1.33s | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 0.1% | 7.8ms | 0.1% | 7.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2432` |
| 0.1% | 7.7ms | 0.1% | 7.7ms | `set` | `[native code]` |
| 0.1% | 7.7ms | 0.1% | 7.7ms | `push` | `[native code]` |
| 0.1% | 7.6ms | 0.5% | 28.8ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` |
| 0.1% | 7.6ms | 0.1% | 7.6ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` |
| 0.1% | 7.3ms | 0.1% | 7.3ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.1% | 7.1ms | 0.1% | 7.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2105` |
| 0.1% | 6.7ms | 0.1% | 6.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2693` |
| 0.1% | 6.6ms | 0.9% | 51.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` |
| 0.1% | 6.6ms | 0.1% | 6.6ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` |
| 0.1% | 6.6ms | 0.1% | 9.6ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.1% | 6.5ms | 0.1% | 8.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2318` |
| 0.1% | 6.5ms | 0.1% | 6.5ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:533` |
| 0.1% | 6.4ms | 0.1% | 6.4ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2783` |
| 0.1% | 6.4ms | 0.1% | 6.4ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6441` |
| 0.1% | 6.3ms | 0.1% | 6.3ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2184` |
| 0.1% | 6.3ms | 0.1% | 6.3ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1007` |
| 0.1% | 6.2ms | 0.1% | 6.2ms | `encodeInto` | `[native code]` |
| 0.1% | 6.0ms | 0.2% | 15.3ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1676` |
| 0.1% | 5.9ms | 0.1% | 5.9ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:226` |
| 0.1% | 5.9ms | 0.1% | 7.2ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` |
| 0.1% | 5.9ms | 0.1% | 5.9ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:528` |
| 0.1% | 5.8ms | 0.1% | 5.8ms | `get` | `[native code]` |
| 0.0% | 5.4ms | 0.0% | 5.4ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4034` |
| 0.0% | 5.2ms | 0.0% | 5.2ms | `/^\s*exported\b/` | `[native code]` |
| 0.0% | 5.2ms | 0.2% | 11.0ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:682` |
| 0.0% | 4.9ms | 0.0% | 4.9ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1330` |
| 0.0% | 4.9ms | 11.5% | 624.8ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 0.0% | 4.7ms | 0.0% | 4.7ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2579` |
| 0.0% | 4.7ms | 0.4% | 21.8ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` |
| 0.0% | 4.6ms | 0.1% | 9.3ms | `scope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:745` |
| 0.0% | 4.6ms | 0.4% | 22.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` |
| 0.0% | 4.6ms | 1.2% | 68.3ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2759` |
| 0.0% | 4.6ms | 100.0% | 12.81s | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 0.0% | 4.6ms | 0.0% | 4.6ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3637` |
| 0.0% | 4.6ms | 1.8% | 101.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 0.0% | 4.5ms | 0.0% | 4.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` |
| 0.0% | 4.5ms | 3.1% | 167.8ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2182` |
| 0.0% | 4.5ms | 0.0% | 4.5ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:844` |
| 0.0% | 4.4ms | 5.8% | 316.4ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2829` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:808` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1238` |
| 0.0% | 4.1ms | 0.2% | 11.6ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2164` |
| 0.0% | 4.1ms | 0.1% | 10.5ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.0% | 4.0ms | 0.1% | 8.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 3.4ms | 0.4% | 25.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` |
| 0.0% | 3.3ms | 2.4% | 130.8ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `Uint8Array` | `[native code]` |
| 0.0% | 3.2ms | 0.3% | 19.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2067` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` |
| 0.0% | 3.1ms | 0.8% | 43.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2730` |
| 0.0% | 3.0ms | 0.0% | 4.3ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:494` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:773` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6707` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `fill` | `[native code]` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:435` |
| 0.0% | 3.0ms | 0.1% | 6.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2126` |
| 0.0% | 3.0ms | 0.0% | 4.6ms | `test` | `[native code]` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 2.9ms | 0.1% | 6.3ms | `map` | `[native code]` |
| 0.0% | 2.9ms | 0.9% | 51.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2218` |
| 0.0% | 2.9ms | 0.8% | 48.2ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1700` |
| 0.0% | 2.9ms | 0.3% | 20.5ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:802` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7117` |
| 0.0% | 2.9ms | 0.2% | 12.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 2.8ms | 9.5% | 518.8ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:845` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1182` |
| 0.0% | 2.8ms | 0.1% | 9.4ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3888` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4244` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_getTypeProto` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3980` |
| 0.0% | 2.8ms | 2.9% | 162.2ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2778` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3807` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4037` |
| 0.0% | 2.8ms | 0.1% | 10.7ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2026` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2011` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` |
| 0.0% | 2.7ms | 0.0% | 4.0ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:653` |
| 0.0% | 2.7ms | 1.9% | 102.8ms | `forEach` | `[native code]` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1185` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:647` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2723` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:482` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6881` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_ensureTagCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5595` |
| 0.0% | 1.8ms | 18.3% | 995.3ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `get right` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1788` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3958` |
| 0.0% | 1.7ms | 1.9% | 105.8ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2317` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_filteredBuiltins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:275` |
| 0.0% | 1.7ms | 0.2% | 11.1ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2891` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3113` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2870` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `slice` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 3.4ms | `readFileSync` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2109` |
| 0.0% | 1.7ms | 0.0% | 4.6ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2804` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_rawTokenText` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:794` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2943` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:959` |
| 0.0% | 1.6ms | 4.5% | 246.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` |
| 0.0% | 1.6ms | 0.1% | 6.5ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:561` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1717` |
| 0.0% | 1.6ms | 0.0% | 3.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2672` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `/^\s*globals?\b/` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 3.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3152` |
| 0.0% | 1.6ms | 0.0% | 3.1ms | `replace` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_lineStarts` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:610` |
| 0.0% | 1.6ms | 0.1% | 7.9ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1478` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1037` |
| 0.0% | 1.5ms | 0.0% | 4.6ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1689` |
| 0.0% | 1.5ms | 0.1% | 8.1ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2910` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6818` |
| 0.0% | 1.5ms | 0.3% | 17.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2864` |
| 0.0% | 1.5ms | 0.0% | 3.1ms | `readdirSync` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `computeGlobals` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 2.6ms | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3337` |
| 0.0% | 1.5ms | 0.0% | 3.1ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:508` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2997` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:447` |
| 0.0% | 1.5ms | 0.2% | 12.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2077` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `extraMethodData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:694` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:738` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1699` |
| 0.0% | 1.4ms | 0.0% | 3.0ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:619` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2027` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isReadRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:431` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get start` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1092` |
| 0.0% | 1.4ms | 0.0% | 2.8ms | `range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3594` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1184` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1709` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2098` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2426` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `ensureBufferBytes` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:53` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `Uint16Array` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:757` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2670` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2913` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_getTypeProto` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3972` |
| 0.0% | 1.3ms | 0.0% | 4.7ms | `exec` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.1% | 5.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2137` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:540` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:855` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3594` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6443` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get kind` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3393` |
| 0.0% | 1.2ms | 4.2% | 232.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2062` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` |
| 0.0% | 1.2ms | 0.1% | 7.2ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1674` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2956` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1325` |
| 0.0% | 1.2ms | 0.1% | 7.7ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:506` |
| 0.0% | 1.1ms | 0.0% | 1.1ms | `_tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1072` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 100.0% | 12.81s | 0.0% | 4.6ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 75.2% | 4.06s | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:304` |
| 74.8% | 4.04s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7468` |
| 68.0% | 3.68s | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4639` |
| 68.0% | 3.68s | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7184` |
| 66.1% | 3.57s | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` |
| 27.0% | 1.46s | 0.6% | 36.1ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 24.6% | 1.33s | 0.1% | 7.8ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 24.4% | 1.32s | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:300` |
| 24.1% | 1.30s | 24.1% | 1.30s | `parse` | `[native code]` |
| 24.1% | 1.30s | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` |
| 18.3% | 995.3ms | 0.0% | 1.8ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` |
| 13.1% | 710.6ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` |
| 11.5% | 624.8ms | 0.0% | 4.9ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 11.2% | 607.3ms | 0.1% | 9.4ms | `some` | `[native code]` |
| 10.1% | 548.9ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2833` |
| 9.5% | 518.8ms | 0.0% | 2.8ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:845` |
| 9.5% | 518.4ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:953` |
| 8.2% | 445.8ms | 0.2% | 13.6ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 6.8% | 368.6ms | 0.2% | 13.8ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2840` |
| 6.1% | 333.9ms | 0.6% | 36.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1189` |
| 6.0% | 329.0ms | 6.0% | 324.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3994` |
| 5.8% | 316.4ms | 0.0% | 4.4ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2829` |
| 5.5% | 300.9ms | 0.2% | 11.6ms | `defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 5.2% | 285.3ms | 0.1% | 9.3ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 5.0% | 274.4ms | 0.3% | 20.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2083` |
| 4.7% | 258.5ms | 4.3% | 236.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6950` |
| 4.6% | 251.8ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:752` |
| 4.5% | 246.8ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` |
| 4.2% | 232.6ms | 0.0% | 1.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2062` |
| 4.0% | 217.3ms | 0.4% | 25.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2209` |
| 3.4% | 185.3ms | 0.2% | 15.6ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3132` |
| 3.1% | 167.8ms | 0.0% | 4.5ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2182` |
| 2.9% | 162.2ms | 0.0% | 2.8ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2778` |
| 2.8% | 156.0ms | 0.2% | 10.9ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` |
| 2.8% | 155.0ms | 2.8% | 155.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4005` |
| 2.7% | 148.2ms | 2.6% | 141.8ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2013` |
| 2.6% | 145.1ms | 2.6% | 145.1ms | `Set` | `[native code]` |
| 2.4% | 134.5ms | 1.0% | 54.4ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2865` |
| 2.4% | 133.6ms | 2.4% | 133.6ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3133` |
| 2.4% | 130.8ms | 0.0% | 3.3ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` |
| 2.4% | 129.8ms | 1.8% | 97.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1222` |
| 2.2% | 123.8ms | 2.2% | 123.8ms | `get _tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1072` |
| 2.2% | 119.8ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` |
| 2.1% | 115.5ms | 2.1% | 115.5ms | `get _tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 2.0% | 113.2ms | 0.0% | 0us | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` |
| 1.9% | 105.8ms | 0.0% | 1.7ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 1.9% | 105.3ms | 1.9% | 105.3ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 1.9% | 102.8ms | 0.0% | 2.7ms | `forEach` | `[native code]` |
| 1.8% | 102.3ms | 1.8% | 100.9ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3139` |
| 1.8% | 101.2ms | 0.0% | 4.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 1.8% | 98.0ms | 0.6% | 32.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 1.8% | 97.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` |
| 1.7% | 93.9ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` |
| 1.7% | 93.9ms | 0.0% | 0us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1894` |
| 1.6% | 91.5ms | 0.5% | 32.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1274` |
| 1.5% | 86.4ms | 0.5% | 28.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1255` |
| 1.5% | 86.1ms | 0.9% | 53.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1285` |
| 1.4% | 78.8ms | 1.4% | 78.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1175` |
| 1.4% | 77.7ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1680` |
| 1.4% | 75.8ms | 0.6% | 36.9ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` |
| 1.3% | 75.6ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:957` |
| 1.3% | 75.6ms | 0.0% | 0us | `_ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:924` |
| 1.3% | 74.3ms | 0.3% | 17.1ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:868` |
| 1.2% | 70.2ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2669` |
| 1.2% | 69.0ms | 1.2% | 69.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4001` |
| 1.2% | 68.3ms | 0.0% | 4.6ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2759` |
| 1.2% | 66.9ms | 0.3% | 17.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2316` |
| 1.1% | 62.6ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2163` |
| 1.1% | 60.2ms | 1.1% | 60.2ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1006` |
| 1.1% | 60.1ms | 0.2% | 15.8ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2585` |
| 1.0% | 57.6ms | 0.2% | 12.4ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2788` |
| 0.9% | 51.4ms | 0.0% | 2.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2218` |
| 0.9% | 51.3ms | 0.1% | 6.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` |
| 0.9% | 49.6ms | 0.9% | 49.6ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` |
| 0.8% | 48.2ms | 0.0% | 2.9ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1700` |
| 0.8% | 47.7ms | 0.8% | 47.7ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.8% | 46.3ms | 0.2% | 13.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1237` |
| 0.8% | 46.0ms | 0.7% | 40.1ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 0.8% | 45.5ms | 0.7% | 42.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2219` |
| 0.8% | 45.4ms | 0.0% | 0us | `bound require` | `[native code]` |
| 0.8% | 45.4ms | 0.2% | 12.0ms | `anonymous` | `[native code]` |
| 0.8% | 44.9ms | 0.3% | 21.3ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` |
| 0.8% | 44.1ms | 0.0% | 0us | `require` | `[native code]` |
| 0.8% | 43.8ms | 0.8% | 43.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6706` |
| 0.8% | 43.7ms | 0.0% | 3.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` |
| 0.7% | 38.5ms | 0.7% | 38.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2225` |
| 0.5% | 31.7ms | 0.5% | 31.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2142` |
| 0.5% | 31.5ms | 0.5% | 31.5ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2741` |
| 0.5% | 30.5ms | 0.5% | 30.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2103` |
| 0.5% | 29.8ms | 0.5% | 29.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3986` |
| 0.5% | 29.8ms | 0.4% | 25.0ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.5% | 29.1ms | 0.5% | 29.1ms | `getUint32` | `[native code]` |
| 0.5% | 28.9ms | 0.5% | 28.9ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3087` |
| 0.5% | 28.8ms | 0.1% | 7.6ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` |
| 0.5% | 27.2ms | 0.5% | 27.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4002` |
| 0.4% | 26.8ms | 0.4% | 26.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3995` |
| 0.4% | 26.2ms | 0.4% | 26.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4006` |
| 0.4% | 25.9ms | 0.0% | 3.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` |
| 0.4% | 23.9ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:967` |
| 0.4% | 23.9ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:972` |
| 0.4% | 23.2ms | 0.3% | 18.8ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2896` |
| 0.4% | 23.0ms | 0.0% | 0us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` |
| 0.4% | 22.6ms | 0.0% | 4.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` |
| 0.4% | 22.1ms | 0.4% | 22.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4003` |
| 0.4% | 21.9ms | 0.4% | 21.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4004` |
| 0.4% | 21.8ms | 0.0% | 4.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` |
| 0.3% | 20.7ms | 0.3% | 20.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3999` |
| 0.3% | 20.5ms | 0.0% | 2.9ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:802` |
| 0.3% | 20.3ms | 0.3% | 20.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3991` |
| 0.3% | 19.3ms | 0.0% | 3.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2067` |
| 0.3% | 18.9ms | 0.1% | 7.9ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.3% | 18.8ms | 0.2% | 12.8ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2836` |
| 0.3% | 18.5ms | 0.3% | 18.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3997` |
| 0.3% | 18.4ms | 0.3% | 18.4ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3121` |
| 0.3% | 18.0ms | 0.3% | 18.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1295` |
| 0.3% | 17.9ms | 0.3% | 17.9ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2842` |
| 0.3% | 17.7ms | 0.3% | 16.2ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` |
| 0.3% | 17.6ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2025` |
| 0.3% | 17.6ms | 0.2% | 15.9ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:818` |
| 0.3% | 17.5ms | 0.0% | 1.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2864` |
| 0.3% | 17.1ms | 0.2% | 14.3ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` |
| 0.3% | 16.8ms | 0.3% | 16.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3998` |
| 0.3% | 16.6ms | 0.3% | 16.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2211` |
| 0.3% | 16.4ms | 0.1% | 8.2ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2673` |
| 0.3% | 16.4ms | 0.0% | 0us | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2907` |
| 0.2% | 15.6ms | 0.2% | 12.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2014` |
| 0.2% | 15.5ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7460` |
| 0.2% | 15.3ms | 0.1% | 6.0ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1676` |
| 0.2% | 15.1ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` |
| 0.2% | 15.0ms | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 0.2% | 15.0ms | 0.0% | 0us | `parseModule` | `[native code]` |
| 0.2% | 14.9ms | 0.2% | 14.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4000` |
| 0.2% | 14.8ms | 0.2% | 14.8ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4056` |
| 0.2% | 14.7ms | 0.2% | 13.6ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:506` |
| 0.2% | 14.5ms | 0.2% | 14.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7118` |
| 0.2% | 13.9ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2221` |
| 0.2% | 13.7ms | 0.0% | 0us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:511` |
| 0.2% | 13.7ms | 0.2% | 13.7ms | `decode` | `[native code]` |
| 0.2% | 13.7ms | 0.2% | 13.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6951` |
| 0.2% | 13.6ms | 0.2% | 13.6ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` |
| 0.2% | 13.4ms | 0.2% | 13.4ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1067` |
| 0.2% | 12.9ms | 0.2% | 12.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6949` |
| 0.2% | 12.3ms | 0.2% | 12.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 12.2ms | 0.0% | 1.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2077` |
| 0.2% | 12.0ms | 0.2% | 12.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3996` |
| 0.2% | 12.0ms | 0.0% | 2.9ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.2% | 11.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule_cfg.js:29` |
| 0.2% | 11.9ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule_cfg.js:19` |
| 0.2% | 11.9ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule_cfg.js:20` |
| 0.2% | 11.6ms | 0.0% | 4.1ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2164` |
| 0.2% | 11.6ms | 0.0% | 0us | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2909` |
| 0.2% | 11.5ms | 0.2% | 11.5ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:865` |
| 0.2% | 11.5ms | 0.2% | 11.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 11.3ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1703` |
| 0.2% | 11.2ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2223` |
| 0.2% | 11.1ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:575` |
| 0.2% | 11.1ms | 0.0% | 1.7ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2891` |
| 0.2% | 11.0ms | 0.0% | 5.2ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:682` |
| 0.2% | 10.9ms | 0.0% | 0us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1228` |
| 0.2% | 10.8ms | 0.2% | 10.8ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4876` |
| 0.1% | 10.8ms | 0.1% | 10.8ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3106` |
| 0.1% | 10.7ms | 0.1% | 10.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2694` |
| 0.1% | 10.7ms | 0.1% | 10.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2113` |
| 0.1% | 10.7ms | 0.0% | 2.8ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` |
| 0.1% | 10.6ms | 0.1% | 10.6ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 10.5ms | 0.0% | 4.1ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.1% | 10.5ms | 0.1% | 10.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2424` |
| 0.1% | 10.4ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:881` |
| 0.1% | 10.2ms | 0.1% | 10.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2208` |
| 0.1% | 9.7ms | 0.1% | 9.7ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 9.7ms | 0.1% | 9.7ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 9.7ms | 0.0% | 0us | `identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:756` |
| 0.1% | 9.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` |
| 0.1% | 9.6ms | 0.1% | 9.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2428` |
| 0.1% | 9.6ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:557` |
| 0.1% | 9.6ms | 0.1% | 6.6ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.1% | 9.5ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6948` |
| 0.1% | 9.4ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4062` |
| 0.1% | 9.4ms | 0.0% | 2.8ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3888` |
| 0.1% | 9.3ms | 0.0% | 4.6ms | `scope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:745` |
| 0.1% | 9.0ms | 0.0% | 0us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1337` |
| 0.1% | 8.5ms | 0.0% | 4.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` |
| 0.1% | 8.3ms | 0.1% | 8.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 8.2ms | 0.1% | 6.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2318` |
| 0.1% | 8.1ms | 0.0% | 1.5ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2910` |
| 0.1% | 8.1ms | 0.1% | 8.1ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2734` |
| 0.1% | 7.9ms | 0.1% | 7.9ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2582` |
| 0.1% | 7.9ms | 0.0% | 1.6ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1478` |
| 0.1% | 7.8ms | 0.1% | 7.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2432` |
| 0.1% | 7.7ms | 0.1% | 7.7ms | `set` | `[native code]` |
| 0.1% | 7.7ms | 0.0% | 1.2ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:506` |
| 0.1% | 7.7ms | 0.1% | 7.7ms | `push` | `[native code]` |
| 0.1% | 7.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` |
| 0.1% | 7.6ms | 0.1% | 7.6ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` |
| 0.1% | 7.5ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:215` |
| 0.1% | 7.3ms | 0.1% | 7.3ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.1% | 7.2ms | 0.0% | 1.2ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1674` |
| 0.1% | 7.2ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` |
| 0.1% | 7.2ms | 0.1% | 5.9ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` |
| 0.1% | 7.1ms | 0.1% | 7.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2105` |
| 0.1% | 6.7ms | 0.1% | 6.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2693` |
| 0.1% | 6.6ms | 0.1% | 6.6ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` |
| 0.1% | 6.5ms | 0.0% | 1.6ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:561` |
| 0.1% | 6.5ms | 0.1% | 6.5ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:533` |
| 0.1% | 6.5ms | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:484` |
| 0.1% | 6.5ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` |
| 0.1% | 6.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:458` |
| 0.1% | 6.4ms | 0.1% | 6.4ms | `_computeVarDefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2783` |
| 0.1% | 6.4ms | 0.1% | 6.4ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6441` |
| 0.1% | 6.3ms | 0.0% | 0us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3151` |
| 0.1% | 6.3ms | 0.0% | 2.9ms | `map` | `[native code]` |
| 0.1% | 6.3ms | 0.1% | 6.3ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2184` |
| 0.1% | 6.3ms | 0.1% | 6.3ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1007` |
| 0.1% | 6.3ms | 0.0% | 3.0ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2126` |
| 0.1% | 6.2ms | 0.1% | 6.2ms | `encodeInto` | `[native code]` |
| 0.1% | 6.2ms | 0.0% | 0us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:92` |
| 0.1% | 5.9ms | 0.1% | 5.9ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:226` |
| 0.1% | 5.9ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:880` |
| 0.1% | 5.9ms | 0.1% | 5.9ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:528` |
| 0.1% | 5.8ms | 0.1% | 5.8ms | `get` | `[native code]` |
| 0.1% | 5.7ms | 0.0% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2137` |
| 0.1% | 5.6ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:551` |
| 0.0% | 5.4ms | 0.0% | 5.4ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4034` |
| 0.0% | 5.4ms | 0.0% | 0us | `get defs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` |
| 0.0% | 5.2ms | 0.0% | 5.2ms | `/^\s*exported\b/` | `[native code]` |
| 0.0% | 4.9ms | 0.0% | 4.9ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1330` |
| 0.0% | 4.7ms | 0.0% | 1.3ms | `exec` | `[native code]` |
| 0.0% | 4.7ms | 0.0% | 4.7ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2579` |
| 0.0% | 4.6ms | 0.0% | 0us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:688` |
| 0.0% | 4.6ms | 0.0% | 1.5ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1689` |
| 0.0% | 4.6ms | 0.0% | 1.7ms | `_computeVarScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2804` |
| 0.0% | 4.6ms | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:519` |
| 0.0% | 4.6ms | 0.0% | 3.0ms | `test` | `[native code]` |
| 0.0% | 4.6ms | 0.0% | 4.6ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3637` |
| 0.0% | 4.6ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1483` |
| 0.0% | 4.5ms | 0.0% | 4.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` |
| 0.0% | 4.5ms | 0.0% | 4.5ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:844` |
| 0.0% | 4.5ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1492` |
| 0.0% | 4.4ms | 0.0% | 0us | `get identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:756` |
| 0.0% | 4.4ms | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3807` |
| 0.0% | 4.4ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3872` |
| 0.0% | 4.4ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` |
| 0.0% | 4.3ms | 0.0% | 3.0ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:494` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:808` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1238` |
| 0.0% | 4.2ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2602` |
| 0.0% | 4.0ms | 0.0% | 2.7ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:653` |
| 0.0% | 3.9ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2186` |
| 0.0% | 3.5ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:654` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 3.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.0% | 3.4ms | 0.0% | 1.7ms | `readFileSync` | `[native code]` |
| 0.0% | 3.4ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3152` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `Uint8Array` | `[native code]` |
| 0.0% | 3.2ms | 0.0% | 0us | `get left` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1756` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` |
| 0.0% | 3.1ms | 0.0% | 1.6ms | `replace` | `[native code]` |
| 0.0% | 3.1ms | 0.0% | 1.5ms | `readdirSync` | `[native code]` |
| 0.0% | 3.1ms | 0.0% | 1.5ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:508` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 3.0ms | 0.0% | 1.4ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:619` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2730` |
| 0.0% | 3.0ms | 0.0% | 0us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3136` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:773` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6707` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `fill` | `[native code]` |
| 0.0% | 3.0ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7448` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:435` |
| 0.0% | 3.0ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2012` |
| 0.0% | 3.0ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:776` |
| 0.0% | 3.0ms | 0.0% | 1.6ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 2.9ms | 0.0% | 0us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2697` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7117` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1182` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4244` |
| 0.0% | 2.8ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:441` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_getTypeProto` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3980` |
| 0.0% | 2.8ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1708` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3807` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4037` |
| 0.0% | 2.8ms | 0.0% | 1.4ms | `range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3594` |
| 0.0% | 2.8ms | 0.0% | 0us | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2909` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2026` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2011` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1185` |
| 0.0% | 2.6ms | 0.0% | 1.5ms | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3337` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:647` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2723` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:482` |
| 0.0% | 2.5ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6957` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6881` |
| 0.0% | 2.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 2.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.8ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5984` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_ensureTagCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5595` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `get right` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1788` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3958` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2180` |
| 0.0% | 1.7ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1716` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2317` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2250` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_filteredBuiltins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:275` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3113` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2870` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `slice` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:576` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule_cfg.js:15` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn-jsx/index.js:3` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2109` |
| 0.0% | 1.7ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6811` |
| 0.0% | 1.7ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1384` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_rawTokenText` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:794` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2943` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:959` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1717` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2672` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `/^\s*globals?\b/` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `RuleContext` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3930` |
| 0.0% | 1.6ms | 0.0% | 0us | `SourceCode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1010` |
| 0.0% | 1.6ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7463` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_lineStarts` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:610` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1037` |
| 0.0% | 1.5ms | 0.0% | 0us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:689` |
| 0.0% | 1.5ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:144` |
| 0.0% | 1.5ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:47` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6818` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `computeGlobals` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:291` |
| 0.0% | 1.5ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:558` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2997` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:447` |
| 0.0% | 1.5ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1474` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `extraMethodData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:694` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:738` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1699` |
| 0.0% | 1.4ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:661` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2027` |
| 0.0% | 1.4ms | 0.0% | 0us | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2259` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isReadRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:431` |
| 0.0% | 1.4ms | 0.0% | 0us | `getUpperFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:132` |
| 0.0% | 1.4ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:662` |
| 0.0% | 1.4ms | 0.0% | 0us | `isInsideOfStorableFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:630` |
| 0.0% | 1.4ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:882` |
| 0.0% | 1.4ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1482` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get start` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1092` |
| 0.0% | 1.4ms | 0.0% | 0us | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:803` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1184` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1709` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2098` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule_cfg.js:4` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `ensureBufferBytes` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:53` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2426` |
| 0.0% | 1.3ms | 0.0% | 0us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:90` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `identifiers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:757` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `Uint16Array` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:401` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get eslintUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2670` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2913` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_getTypeProto` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3972` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get references` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:747` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:540` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:855` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3594` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6443` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get kind` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:887` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3393` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js:133` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_computeVariableSynthRefs` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2956` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1325` |
| 0.0% | 1.2ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:655` |
| 0.0% | 1.1ms | 0.0% | 1.1ms | `_tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1072` |

## Function Details

### `parse`
`[native code]` | Self: 24.1% (1.30s) | Total: 24.1% (1.30s) | Samples: 860

**Called by:**
- `parseSource` (860)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3994` | Self: 6.0% (324.8ms) | Total: 6.0% (329.0ms) | Samples: 212

**Called by:**
- `get parent` (85)
- `_buildReference` (75)
- `_computeVarDefs` (18)
- `_nodesFromRange` (11)
- `get body` (8)
- `_buildScope` (6)
- `(anonymous)` (4)
- `get body` (3)
- `get value` (3)
- `get body` (1)
- `isReadForItself` (1)

**Calls:**
- `_getTypeProto` (2)
- `_getTypeProto` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6950` | Self: 4.3% (236.9ms) | Total: 4.7% (258.5ms) | Samples: 153

**Called by:**
- `runPlugins` (167)

**Calls:**
- `get allSkipped` (7)
- `get allSkipped` (7)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4005` | Self: 2.8% (155.0ms) | Total: 2.8% (155.0ms) | Samples: 103

**Called by:**
- `_buildReference` (46)
- `get parent` (36)
- `_computeVarDefs` (8)
- `_nodesFromRange` (6)
- `get body` (3)
- `(anonymous)` (2)
- `get body` (1)
- `_buildScope` (1)

### `Set`
`[native code]` | Self: 2.6% (145.1ms) | Total: 2.6% (145.1ms) | Samples: 92

**Called by:**
- `getDeclaredVariables` (92)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2013` | Self: 2.6% (141.8ms) | Total: 2.7% (148.2ms) | Samples: 93

**Called by:**
- `_buildScopeVarsAndSet` (97)

**Calls:**
- `set` (4)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3133` | Self: 2.4% (133.6ms) | Total: 2.4% (133.6ms) | Samples: 87

**Called by:**
- `isAfterLastUsedArg` (87)

### `get _tag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1072` | Self: 2.2% (123.8ms) | Total: 2.2% (123.8ms) | Samples: 82

**Called by:**
- `get parent` (20)
- `get parent` (15)
- `get parent` (14)
- `get parent` (10)
- `get parent` (10)
- `init` (8)
- `get body` (4)
- `_findDefNode` (1)

### `get _tag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 2.1% (115.5ms) | Total: 2.1% (115.5ms) | Samples: 75

**Called by:**
- `get parent` (25)
- `get parent` (17)
- `get parent` (12)
- `get parent` (11)
- `get parent` (7)
- `init` (3)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 1.9% (105.3ms) | Total: 1.9% (105.3ms) | Samples: 69

**Called by:**
- `_buildReference` (40)
- `(anonymous)` (14)
- `isForInOfRef` (8)
- `getRhsNode` (3)
- `(anonymous)` (2)
- `collectUnusedVariables` (1)
- `isForInOfRef` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3139` | Self: 1.8% (100.9ms) | Total: 1.8% (102.3ms) | Samples: 67

**Called by:**
- `isAfterLastUsedArg` (65)
- `isAfterLastUsedArg` (3)

**Calls:**
- `set` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1222` | Self: 1.8% (97.6ms) | Total: 2.4% (129.8ms) | Samples: 63

**Called by:**
- `_buildReference` (69)
- `_findDefNode` (6)
- `_computeVarDefs` (3)
- `(anonymous)` (1)
- `_computeIsStrict` (1)
- `getRhsNode` (1)
- `isUnusedExpression` (1)
- `_findDefNode` (1)
- `_findDefNode` (1)

**Calls:**
- `get _tag` (11)
- `get _tag` (10)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1175` | Self: 1.4% (78.8ms) | Total: 1.4% (78.8ms) | Samples: 51

**Called by:**
- `_computeIsStrict` (10)
- `(anonymous)` (9)
- `isReadForItself` (5)
- `_buildReference` (5)
- `isForInOfRef` (4)
- `isForInOfRef` (4)
- `_buildReference` (4)
- `getRhsNode` (3)
- `_computeIsStrict` (3)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)
- `_computeVarDefs` (1)
- `collectUnusedVariables` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4001` | Self: 1.2% (69.0ms) | Total: 1.2% (69.0ms) | Samples: 47

**Called by:**
- `_buildReference` (23)
- `get parent` (11)
- `get body` (8)
- `_computeVarDefs` (3)
- `_buildScope` (1)
- `_nodesFromRange` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1006` | Self: 1.1% (60.2ms) | Total: 1.1% (60.2ms) | Samples: 39

**Called by:**
- `(anonymous)` (12)
- `isForInOfRef` (5)
- `_buildReference` (4)
- `isForInOfRef` (3)
- `collectUnusedVariables` (2)
- `_buildScope` (2)
- `getRhsNode` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `isReadForItself` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)
- `isReadForItself` (1)
- `isForInOfRef` (1)
- `isForInOfRef` (1)
- `isUnusedExpression` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2865` | Self: 1.0% (54.4ms) | Total: 2.4% (134.5ms) | Samples: 36

**Called by:**
- `get references` (88)

**Calls:**
- `get type` (40)
- `get type` (5)
- `get type` (4)
- `get type` (3)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1285` | Self: 0.9% (53.3ms) | Total: 1.5% (86.1ms) | Samples: 37

**Called by:**
- `_buildReference` (26)
- `_findDefNode` (15)
- `_buildReference` (5)
- `_computeIsStrict` (4)
- `_computeVarDefs` (3)
- `isForInOfRef` (3)
- `isUnusedExpression` (2)
- `_findDefNode` (1)

**Calls:**
- `get _tag` (12)
- `get _tag` (10)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` | Self: 0.9% (49.6ms) | Total: 0.9% (49.6ms) | Samples: 32

**Called by:**
- `_precomputeScopes` (32)

### `/\/\*([\s\S]*?)\*\//g`
`[native code]` | Self: 0.8% (47.7ms) | Total: 0.8% (47.7ms) | Samples: 31

**Called by:**
- `_buildScopeVarsAndSet` (29)
- `exec` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6706` | Self: 0.8% (43.8ms) | Total: 0.8% (43.8ms) | Samples: 29

**Called by:**
- `runPlugins` (29)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2219` | Self: 0.7% (42.7ms) | Total: 0.8% (45.5ms) | Samples: 28

**Called by:**
- `_ensureVarsSet` (30)

**Calls:**
- `get` (2)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` | Self: 0.7% (40.1ms) | Total: 0.8% (46.0ms) | Samples: 26

**Called by:**
- `(anonymous)` (30)

**Calls:**
- `get parent` (3)
- `get parent` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2225` | Self: 0.7% (38.5ms) | Total: 0.7% (38.5ms) | Samples: 26

**Called by:**
- `_ensureVarsSet` (26)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:783` | Self: 0.6% (36.9ms) | Total: 1.4% (75.8ms) | Samples: 24

**Called by:**
- `collectUnusedVariables` (27)
- `(anonymous)` (19)
- `getDeclaredVariables` (2)
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `_computeVariableSynthRefs` (15)
- `_computeVariableSynthRefs` (7)
- `_computeVariableSynthRefs` (1)
- `_computeVariableSynthRefs` (1)
- `_computeVariableSynthRefs` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1189` | Self: 0.6% (36.8ms) | Total: 6.1% (333.9ms) | Samples: 24

**Called by:**
- `_buildReference` (162)
- `_findDefNode` (31)
- `_computeVarDefs` (14)
- `_computeIsStrict` (10)
- `_findDefNode` (2)
- `getUpperFunction` (1)
- `isForInOfRef` (1)
- `_findDefNode` (1)

**Calls:**
- `_nodeViewRaw` (85)
- `_nodeViewRaw` (36)
- `_nodeViewRaw` (11)
- `_nodeViewRaw` (10)
- `_nodeViewRaw` (7)
- `_nodeViewRaw` (7)
- `_nodeViewRaw` (6)
- `_nodeViewRaw` (5)
- `_nodeViewRaw` (5)
- `_nodeViewRaw` (5)
- `_nodeViewRaw` (5)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (3)
- `nodeView` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` | Self: 0.6% (36.1ms) | Total: 27.0% (1.46s) | Samples: 24

**Called by:**
- `collectUnusedVariables` (777)
- `(anonymous)` (140)
- `isUsedVariable` (31)
- `getDeclaredVariables` (8)
- `_buildScopeVarsAndSet` (6)
- `Program:exit` (1)

**Calls:**
- `_buildReference` (359)
- `_buildReference` (245)
- `_buildReference` (206)
- `_buildReference` (88)
- `_buildReference` (13)
- `_buildReference` (11)
- `_buildReference` (10)
- `_buildReference` (6)
- `_buildReference` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` | Self: 0.6% (32.4ms) | Total: 1.8% (98.0ms) | Samples: 21

**Called by:**
- `some` (64)

**Calls:**
- `get type` (14)
- `get type` (12)
- `get parent` (9)
- `get parent` (2)
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)
- `get type` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1274` | Self: 0.5% (32.2ms) | Total: 1.6% (91.5ms) | Samples: 20

**Called by:**
- `_buildReference` (42)
- `_findDefNode` (9)
- `_computeIsStrict` (5)
- `_computeVarDefs` (3)

**Calls:**
- `get _tag` (25)
- `get _tag` (14)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2142` | Self: 0.5% (31.7ms) | Total: 0.5% (31.7ms) | Samples: 21

**Called by:**
- `_buildReference` (21)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2741` | Self: 0.5% (31.5ms) | Total: 0.5% (31.5ms) | Samples: 21

**Called by:**
- `getDeclaredVariables` (13)
- `_buildScopeVarsAndSet` (8)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2103` | Self: 0.5% (30.5ms) | Total: 0.5% (30.5ms) | Samples: 21

**Called by:**
- `_buildScope` (12)
- `_buildReference` (6)
- `_computeVarScope` (2)
- `_buildScopeChildren` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3986` | Self: 0.5% (29.8ms) | Total: 0.5% (29.8ms) | Samples: 20

**Called by:**
- `_nodesFromRange` (6)
- `_buildReference` (5)
- `_computeVarDefs` (4)
- `get body` (2)
- `_buildScope` (1)
- `(anonymous)` (1)
- `_computeVariableSynthRefs` (1)

### `getUint32`
`[native code]` | Self: 0.5% (29.1ms) | Total: 0.5% (29.1ms) | Samples: 19

**Called by:**
- `get body` (6)
- `init` (4)
- `_isChainNode` (4)
- `get init` (2)
- `get left` (2)
- `get id` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3087` | Self: 0.5% (28.9ms) | Total: 0.5% (28.9ms) | Samples: 19

**Called by:**
- `isAfterLastUsedArg` (19)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1255` | Self: 0.5% (28.2ms) | Total: 1.5% (86.4ms) | Samples: 19

**Called by:**
- `_buildReference` (31)
- `_findDefNode` (11)
- `_computeIsStrict` (8)
- `isForInOfRef` (3)
- `_computeVarDefs` (2)
- `isUnusedExpression` (1)

**Calls:**
- `get _tag` (20)
- `get _tag` (17)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4002` | Self: 0.5% (27.2ms) | Total: 0.5% (27.2ms) | Samples: 18

**Called by:**
- `get parent` (10)
- `_buildReference` (5)
- `get body` (1)
- `get body` (1)
- `_nodesFromRange` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3995` | Self: 0.4% (26.8ms) | Total: 0.4% (26.8ms) | Samples: 18

**Called by:**
- `_buildReference` (8)
- `get parent` (7)
- `get body` (1)
- `_computeVarDefs` (1)
- `_nodesFromRange` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4006` | Self: 0.4% (26.2ms) | Total: 0.4% (26.2ms) | Samples: 18

**Called by:**
- `_buildReference` (10)
- `get parent` (5)
- `(anonymous)` (2)
- `_nodesFromRange` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2209` | Self: 0.4% (25.6ms) | Total: 4.0% (217.3ms) | Samples: 16

**Called by:**
- `_ensureVarsSet` (141)

**Calls:**
- `_ensureDeclSymIndex` (97)
- `_ensureDeclSymIndex` (11)
- `_ensureDeclSymIndex` (10)
- `_ensureDeclSymIndex` (2)
- `_ensureDeclSymIndex` (2)
- `_ensureDeclSymIndex` (2)
- `_ensureDeclSymIndex` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` | Self: 0.4% (25.0ms) | Total: 0.5% (29.8ms) | Samples: 16

**Called by:**
- `collectUnusedVariables` (19)

**Calls:**
- `getDeclaredVariables` (3)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4003` | Self: 0.4% (22.1ms) | Total: 0.4% (22.1ms) | Samples: 14

**Called by:**
- `_buildReference` (7)
- `get parent` (4)
- `_buildScope` (1)
- `get body` (1)
- `(anonymous)` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4004` | Self: 0.4% (21.9ms) | Total: 0.4% (21.9ms) | Samples: 14

**Called by:**
- `_buildReference` (5)
- `get parent` (5)
- `_nodesFromRange` (2)
- `get body` (1)
- `_computeVarDefs` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` | Self: 0.3% (21.3ms) | Total: 0.8% (44.9ms) | Samples: 14

**Called by:**
- `isAfterLastUsedArg` (30)

**Calls:**
- `_buildVariable` (13)
- `_buildVariable` (2)
- `_buildVariable` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3999` | Self: 0.3% (20.7ms) | Total: 0.3% (20.7ms) | Samples: 14

**Called by:**
- `_buildReference` (6)
- `get parent` (4)
- `get body` (3)
- `get body` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3991` | Self: 0.3% (20.3ms) | Total: 0.3% (20.3ms) | Samples: 14

**Called by:**
- `get parent` (5)
- `_nodesFromRange` (3)
- `_buildReference` (2)
- `_computeVariableSynthRefs` (2)
- `_computeVarDefs` (1)
- `get body` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2083` | Self: 0.3% (20.1ms) | Total: 5.0% (274.4ms) | Samples: 13

**Called by:**
- `_buildReference` (83)
- `_buildScope` (78)
- `_buildScopeChildren` (18)
- `_precomputeScopes` (2)

**Calls:**
- `_computeIsStrict` (112)
- `_computeIsStrict` (40)
- `_computeIsStrict` (8)
- `_computeIsStrict` (4)
- `_computeIsStrict` (3)
- `_computeIsStrict` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2896` | Self: 0.3% (18.8ms) | Total: 0.4% (23.2ms) | Samples: 12

**Called by:**
- `get references` (15)

**Calls:**
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3997` | Self: 0.3% (18.5ms) | Total: 0.3% (18.5ms) | Samples: 12

**Called by:**
- `get parent` (4)
- `_buildReference` (4)
- `get body` (2)
- `_nodesFromRange` (2)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3121` | Self: 0.3% (18.4ms) | Total: 0.3% (18.4ms) | Samples: 12

**Called by:**
- `isAfterLastUsedArg` (12)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1295` | Self: 0.3% (18.0ms) | Total: 0.3% (18.0ms) | Samples: 12

**Called by:**
- `_buildReference` (6)
- `_findDefNode` (2)
- `isForInOfRef` (2)
- `(anonymous)` (1)
- `_computeVarDefs` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2842` | Self: 0.3% (17.9ms) | Total: 0.3% (17.9ms) | Samples: 10

**Called by:**
- `get references` (10)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2316` | Self: 0.3% (17.8ms) | Total: 1.2% (66.9ms) | Samples: 11

**Called by:**
- `_ensureVarsSet` (43)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (29)
- `exec` (3)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:868` | Self: 0.3% (17.1ms) | Total: 1.3% (74.3ms) | Samples: 11

**Called by:**
- `get body` (45)
- `get value` (4)

**Calls:**
- `_nodeViewRaw` (11)
- `_nodeViewRaw` (6)
- `_nodeViewRaw` (6)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (2)
- `nodeView` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3998` | Self: 0.3% (16.8ms) | Total: 0.3% (16.8ms) | Samples: 11

**Called by:**
- `get parent` (6)
- `_buildReference` (2)
- `get body` (1)
- `_buildScope` (1)
- `(anonymous)` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2211` | Self: 0.3% (16.6ms) | Total: 0.3% (16.6ms) | Samples: 11

**Called by:**
- `_ensureVarsSet` (11)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` | Self: 0.3% (16.2ms) | Total: 0.3% (17.7ms) | Samples: 11

**Called by:**
- `(anonymous)` (12)

**Calls:**
- `get type` (1)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:818` | Self: 0.2% (15.9ms) | Total: 0.3% (17.6ms) | Samples: 10

**Called by:**
- `_symName` (11)

**Calls:**
- `slice` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2585` | Self: 0.2% (15.8ms) | Total: 1.1% (60.1ms) | Samples: 10

**Called by:**
- `_ensureChildren` (38)

**Calls:**
- `_buildScope` (18)
- `_buildScope` (4)
- `_buildScope` (2)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3132` | Self: 0.2% (15.6ms) | Total: 3.4% (185.3ms) | Samples: 9

**Called by:**
- `isAfterLastUsedArg` (122)

**Calls:**
- `defs` (111)
- `get defs` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4000` | Self: 0.2% (14.9ms) | Total: 0.2% (14.9ms) | Samples: 10

**Called by:**
- `get parent` (5)
- `_buildReference` (3)
- `get body` (1)
- `_nodesFromRange` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4056` | Self: 0.2% (14.8ms) | Total: 0.2% (14.8ms) | Samples: 10

**Called by:**
- `(anonymous)` (5)
- `(anonymous)` (3)
- `(anonymous)` (1)
- `getRhsNode` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7118` | Self: 0.2% (14.5ms) | Total: 0.2% (14.5ms) | Samples: 10

**Called by:**
- `runPlugins` (10)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:789` | Self: 0.2% (14.3ms) | Total: 0.3% (17.1ms) | Samples: 9

**Called by:**
- `collectUnusedVariables` (11)

**Calls:**
- `get eslintUsed` (1)
- `get eslintUsed` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2840` | Self: 0.2% (13.8ms) | Total: 6.8% (368.6ms) | Samples: 9

**Called by:**
- `get references` (245)

**Calls:**
- `_buildScope` (103)
- `_buildScope` (83)
- `_buildScope` (21)
- `_buildScope` (9)
- `_buildScope` (6)
- `_buildScope` (3)
- `_buildScope` (3)
- `_buildScope` (3)
- `_buildScope` (2)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `decode`
`[native code]` | Self: 0.2% (13.7ms) | Total: 0.2% (13.7ms) | Samples: 9

**Called by:**
- `get source` (9)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6951` | Self: 0.2% (13.7ms) | Total: 0.2% (13.7ms) | Samples: 9

**Called by:**
- `runPlugins` (9)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:506` | Self: 0.2% (13.6ms) | Total: 0.2% (14.7ms) | Samples: 9

**Called by:**
- `_computeVarDefs` (10)

**Calls:**
- `get _tag` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` | Self: 0.2% (13.6ms) | Total: 8.2% (445.8ms) | Samples: 9

**Called by:**
- `collectUnusedVariables` (263)
- `Program:exit` (31)

**Calls:**
- `isUsedVariable` (189)
- `isUsedVariable` (74)
- `some` (17)
- `isUsedVariable` (4)
- `isUsedVariable` (1)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` | Self: 0.2% (13.6ms) | Total: 0.2% (13.6ms) | Samples: 9

**Called by:**
- `getRhsNode` (9)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1067` | Self: 0.2% (13.4ms) | Total: 0.2% (13.4ms) | Samples: 9

**Called by:**
- `_buildReference` (5)
- `_computeIsStrict` (2)
- `(anonymous)` (1)
- `isForInOfRef` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1237` | Self: 0.2% (13.1ms) | Total: 0.8% (46.3ms) | Samples: 9

**Called by:**
- `_buildReference` (20)
- `_findDefNode` (4)
- `isForInOfRef` (3)
- `_computeIsStrict` (2)
- `_computeVarDefs` (2)

**Calls:**
- `get _tag` (15)
- `get _tag` (7)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6949` | Self: 0.2% (12.9ms) | Total: 0.2% (12.9ms) | Samples: 9

**Called by:**
- `runPlugins` (9)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2836` | Self: 0.2% (12.8ms) | Total: 0.3% (18.8ms) | Samples: 9

**Called by:**
- `get references` (13)

**Calls:**
- `_buildVariable` (4)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2788` | Self: 0.2% (12.4ms) | Total: 1.0% (57.6ms) | Samples: 8

**Called by:**
- `defs` (35)
- `get defs` (3)

**Calls:**
- `get parent` (14)
- `get parent` (3)
- `get parent` (3)
- `get parent` (3)
- `get parent` (2)
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2014` | Self: 0.2% (12.3ms) | Total: 0.2% (15.6ms) | Samples: 8

**Called by:**
- `_buildScopeVarsAndSet` (10)

**Calls:**
- `push` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.2% (12.3ms) | Total: 0.2% (12.3ms) | Samples: 8

**Called by:**
- `_buildScopeVarsAndSet` (4)
- `_buildReference` (4)

### `anonymous`
`[native code]` | Self: 0.2% (12.0ms) | Total: 0.8% (45.4ms) | Samples: 7

**Called by:**
- `require` (26)
- `bound require` (1)

**Calls:**
- `(anonymous)` (6)
- `(anonymous)` (4)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3996` | Self: 0.2% (12.0ms) | Total: 0.2% (12.0ms) | Samples: 8

**Called by:**
- `_buildReference` (3)
- `get parent` (3)
- `get body` (1)
- `_nodesFromRange` (1)

### `defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` | Self: 0.2% (11.6ms) | Total: 5.5% (300.9ms) | Samples: 8

**Called by:**
- `getDeclaredVariables` (111)
- `collectUnusedVariables` (77)
- `identifiers` (6)
- `get identifiers` (3)
- `getFunctionDefinitions` (1)
- `isAfterLastUsedArg` (1)

**Calls:**
- `_computeVarDefs` (109)
- `_computeVarDefs` (43)
- `_computeVarDefs` (35)
- `_computeVarDefs` (4)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:865` | Self: 0.2% (11.5ms) | Total: 0.2% (11.5ms) | Samples: 7

**Called by:**
- `get body` (6)
- `get body` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.2% (11.5ms) | Total: 0.2% (11.5ms) | Samples: 8

**Called by:**
- `get parent` (7)
- `_buildReference` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` | Self: 0.2% (10.9ms) | Total: 2.8% (156.0ms) | Samples: 7

**Called by:**
- `isAfterLastUsedArg` (99)

**Calls:**
- `Set` (92)

### `get allSkipped`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4876` | Self: 0.2% (10.8ms) | Total: 0.2% (10.8ms) | Samples: 7

**Called by:**
- `walkNodes` (7)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3106` | Self: 0.1% (10.8ms) | Total: 0.1% (10.8ms) | Samples: 7

**Called by:**
- `isAfterLastUsedArg` (7)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2694` | Self: 0.1% (10.7ms) | Total: 0.1% (10.7ms) | Samples: 7

**Called by:**
- `_buildScopeVarsAndSet` (7)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2113` | Self: 0.1% (10.7ms) | Total: 0.1% (10.7ms) | Samples: 7

**Called by:**
- `_buildScope` (4)
- `_buildReference` (3)

### `get allSkipped`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (10.6ms) | Total: 0.1% (10.6ms) | Samples: 7

**Called by:**
- `walkNodes` (7)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2424` | Self: 0.1% (10.5ms) | Total: 0.1% (10.5ms) | Samples: 7

**Called by:**
- `_ensureVarsSet` (7)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2208` | Self: 0.1% (10.2ms) | Total: 0.1% (10.2ms) | Samples: 7

**Called by:**
- `_ensureVarsSet` (7)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (9.7ms) | Total: 0.1% (9.7ms) | Samples: 7

**Called by:**
- `commentsInRange` (6)
- `commentsInRange` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (9.7ms) | Total: 0.1% (9.7ms) | Samples: 6

**Called by:**
- `get references` (6)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2428` | Self: 0.1% (9.6ms) | Total: 0.1% (9.6ms) | Samples: 6

**Called by:**
- `_ensureVarsSet` (6)

### `some`
`[native code]` | Self: 0.1% (9.4ms) | Total: 11.2% (607.3ms) | Samples: 6

**Called by:**
- `isAfterLastUsedArg` (163)
- `isUsedVariable` (152)
- `collectUnusedVariables` (64)
- `collectUnusedVariables` (17)
- `Program:exit` (1)

**Calls:**
- `(anonymous)` (160)
- `(anonymous)` (66)
- `(anonymous)` (65)
- `(anonymous)` (64)
- `(anonymous)` (29)
- `(anonymous)` (5)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` | Self: 0.1% (9.3ms) | Total: 5.2% (285.3ms) | Samples: 6

**Called by:**
- `collectUnusedVariables` (189)

**Calls:**
- `some` (152)
- `get references` (31)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (8.3ms) | Total: 0.1% (8.3ms) | Samples: 5

**Called by:**
- `isReadForItself` (2)
- `collectUnusedVariables` (2)
- `_computeVarDefs` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2673` | Self: 0.1% (8.2ms) | Total: 0.3% (16.4ms) | Samples: 5

**Called by:**
- `getScope` (10)

**Calls:**
- `/^\s*exported\b/` (3)
- `test` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2734` | Self: 0.1% (8.1ms) | Total: 0.1% (8.1ms) | Samples: 5

**Called by:**
- `_buildScopeVarsAndSet` (3)
- `getDeclaredVariables` (2)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` | Self: 0.1% (7.9ms) | Total: 0.3% (18.9ms) | Samples: 5

**Called by:**
- `(anonymous)` (12)

**Calls:**
- `get parent` (5)
- `get parent` (2)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2582` | Self: 0.1% (7.9ms) | Total: 0.1% (7.9ms) | Samples: 5

**Called by:**
- `_ensureChildren` (5)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` | Self: 0.1% (7.8ms) | Total: 24.6% (1.33s) | Samples: 5

**Called by:**
- `collectUnusedVariables` (878)

**Calls:**
- `get references` (777)
- `some` (64)
- `get references` (27)
- `get references` (3)
- `get references` (1)
- `get references` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2432` | Self: 0.1% (7.8ms) | Total: 0.1% (7.8ms) | Samples: 5

**Called by:**
- `_ensureVarsSet` (5)

### `set`
`[native code]` | Self: 0.1% (7.7ms) | Total: 0.1% (7.7ms) | Samples: 5

**Called by:**
- `_ensureDeclSymIndex` (4)
- `getDeclaredVariables` (1)

### `push`
`[native code]` | Self: 0.1% (7.7ms) | Total: 0.1% (7.7ms) | Samples: 5

**Called by:**
- `_ensureDeclSymIndex` (2)
- `getDeclaredVariables` (2)
- `_ensureVarsSet` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` | Self: 0.1% (7.6ms) | Total: 0.5% (28.8ms) | Samples: 5

**Called by:**
- `(anonymous)` (19)

**Calls:**
- `get type` (8)
- `get type` (5)
- `get type` (1)

### `isSelfReference`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` | Self: 0.1% (7.6ms) | Total: 0.1% (7.6ms) | Samples: 5

**Called by:**
- `(anonymous)` (5)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` | Self: 0.1% (7.3ms) | Total: 0.1% (7.3ms) | Samples: 5

**Called by:**
- `isUsedVariable` (5)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2105` | Self: 0.1% (7.1ms) | Total: 0.1% (7.1ms) | Samples: 5

**Called by:**
- `_buildScope` (3)
- `_buildReference` (1)
- `_buildScopeChildren` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2693` | Self: 0.1% (6.7ms) | Total: 0.1% (6.7ms) | Samples: 4

**Called by:**
- `_buildScopeVarsAndSet` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` | Self: 0.1% (6.6ms) | Total: 0.9% (51.3ms) | Samples: 4

**Called by:**
- `forEach` (33)

**Calls:**
- `init` (6)
- `init` (4)
- `_nodeViewRaw` (4)
- `nodeViewChain` (3)
- `_nodeViewRaw` (2)
- `nodeViewChain` (2)
- `_nodeViewRaw` (2)
- `get init` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `init` (1)
- `get init` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` | Self: 0.1% (6.6ms) | Total: 0.1% (6.6ms) | Samples: 4

**Called by:**
- `collectUnusedVariables` (4)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` | Self: 0.1% (6.6ms) | Total: 0.1% (9.6ms) | Samples: 4

**Called by:**
- `collectUnusedVariables` (6)

**Calls:**
- `get parent` (1)
- `get type` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2318` | Self: 0.1% (6.5ms) | Total: 0.1% (8.2ms) | Samples: 4

**Called by:**
- `_ensureVarsSet` (5)

**Calls:**
- `test` (1)

### `nodeRhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:533` | Self: 0.1% (6.5ms) | Total: 0.1% (6.5ms) | Samples: 4

**Called by:**
- `init` (4)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2783` | Self: 0.1% (6.4ms) | Total: 0.1% (6.4ms) | Samples: 4

**Called by:**
- `defs` (4)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6441` | Self: 0.1% (6.4ms) | Total: 0.1% (6.4ms) | Samples: 4

**Called by:**
- `walkNodes` (4)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2184` | Self: 0.1% (6.3ms) | Total: 0.1% (6.3ms) | Samples: 4

**Called by:**
- `_buildScope` (4)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1007` | Self: 0.1% (6.3ms) | Total: 0.1% (6.3ms) | Samples: 4

**Called by:**
- `_buildReference` (3)
- `collectUnusedVariables` (1)

### `encodeInto`
`[native code]` | Self: 0.1% (6.2ms) | Total: 0.1% (6.2ms) | Samples: 4

**Called by:**
- `_encodeSource` (4)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1676` | Self: 0.1% (6.0ms) | Total: 0.2% (15.3ms) | Samples: 4

**Called by:**
- `_computeIsStrict` (10)

**Calls:**
- `getUint32` (6)

### `_resolveUnicodeEscapes`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:226` | Self: 0.1% (5.9ms) | Total: 0.1% (5.9ms) | Samples: 4

**Called by:**
- `get name` (4)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` | Self: 0.1% (5.9ms) | Total: 0.1% (7.2ms) | Samples: 4

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `get type` (1)

### `nodeLhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:528` | Self: 0.1% (5.9ms) | Total: 0.1% (5.9ms) | Samples: 4

**Called by:**
- `init` (4)

### `get`
`[native code]` | Self: 0.1% (5.8ms) | Total: 0.1% (5.8ms) | Samples: 4

**Called by:**
- `_buildScopeVarsAndSet` (2)
- `_ensureDeclSymIndex` (2)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4034` | Self: 0.0% (5.4ms) | Total: 0.0% (5.4ms) | Samples: 4

**Called by:**
- `_computeVarDefs` (2)
- `_nodesFromRange` (2)

### `/^\s*exported\b/`
`[native code]` | Self: 0.0% (5.2ms) | Total: 0.0% (5.2ms) | Samples: 3

**Called by:**
- `_precomputeScopes` (3)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:682` | Self: 0.0% (5.2ms) | Total: 0.2% (11.0ms) | Samples: 3

**Called by:**
- `(anonymous)` (7)

**Calls:**
- `get type` (3)
- `get type` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1330` | Self: 0.0% (4.9ms) | Total: 0.0% (4.9ms) | Samples: 3

**Called by:**
- `_buildScope` (2)
- `(anonymous)` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` | Self: 0.0% (4.9ms) | Total: 11.5% (624.8ms) | Samples: 3

**Called by:**
- `collectUnusedVariables` (221)
- `Program:exit` (184)

**Calls:**
- `get` (337)
- `get` (48)
- `get` (16)
- `get` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2579` | Self: 0.0% (4.7ms) | Total: 0.0% (4.7ms) | Samples: 3

**Called by:**
- `_ensureChildren` (3)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` | Self: 0.0% (4.7ms) | Total: 0.4% (21.8ms) | Samples: 3

**Called by:**
- `isAfterLastUsedArg` (13)

**Calls:**
- `get references` (8)
- `get references` (2)

### `scope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:745` | Self: 0.0% (4.6ms) | Total: 0.1% (9.3ms) | Samples: 3

**Called by:**
- `_computeVariableSynthRefs` (6)

**Calls:**
- `_computeVarScope` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` | Self: 0.0% (4.6ms) | Total: 0.4% (22.6ms) | Samples: 3

**Called by:**
- `forEach` (15)

**Calls:**
- `nodeViewChain` (5)
- `init` (3)
- `init` (1)
- `nodeViewChain` (1)
- `get type` (1)
- `get init` (1)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2759` | Self: 0.0% (4.6ms) | Total: 1.2% (68.3ms) | Samples: 3

**Called by:**
- `defs` (43)
- `get defs` (1)

**Calls:**
- `_nodeViewRaw` (18)
- `_nodeViewRaw` (8)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (3)
- `nodeView` (2)
- `nodeView` (2)
- `nodeView` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` | Self: 0.0% (4.6ms) | Total: 100.0% (12.81s) | Samples: 3

**Called by:**
- `collectUnusedVariables` (6239)
- `Program:exit` (2127)

**Calls:**
- `collectUnusedVariables` (6239)
- `collectUnusedVariables` (878)
- `collectUnusedVariables` (646)
- `collectUnusedVariables` (263)
- `collectUnusedVariables` (221)
- `collectUnusedVariables` (79)
- `collectUnusedVariables` (11)
- `collectUnusedVariables` (8)
- `collectUnusedVariables` (6)
- `collectUnusedVariables` (6)
- `collectUnusedVariables` (2)
- `collectUnusedVariables` (2)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3637` | Self: 0.0% (4.6ms) | Total: 0.0% (4.6ms) | Samples: 3

**Called by:**
- `get value` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` | Self: 0.0% (4.6ms) | Total: 1.8% (101.2ms) | Samples: 3

**Called by:**
- `some` (66)

**Calls:**
- `getRhsNode` (30)
- `getRhsNode` (10)
- `getRhsNode` (7)
- `getRhsNode` (6)
- `getRhsNode` (4)
- `getRhsNode` (4)
- `getRhsNode` (1)
- `getRhsNode` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` | Self: 0.0% (4.5ms) | Total: 0.0% (4.5ms) | Samples: 3

**Called by:**
- `_precomputeScopes` (3)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2182` | Self: 0.0% (4.5ms) | Total: 3.1% (167.8ms) | Samples: 3

**Called by:**
- `_buildScope` (112)

**Calls:**
- `get body` (51)
- `get body` (33)
- `get body` (10)
- `get body` (8)
- `get body` (5)
- `get body` (1)
- `get body` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:844` | Self: 0.0% (4.5ms) | Total: 0.0% (4.5ms) | Samples: 3

**Called by:**
- `get` (3)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2829` | Self: 0.0% (4.4ms) | Total: 5.8% (316.4ms) | Samples: 3

**Called by:**
- `get references` (206)
- `_ensureVarsSet` (2)

**Calls:**
- `_nodeViewRaw` (75)
- `_nodeViewRaw` (46)
- `_nodeViewRaw` (23)
- `_nodeViewRaw` (10)
- `_nodeViewRaw` (8)
- `_nodeViewRaw` (7)
- `_nodeViewRaw` (6)
- `_nodeViewRaw` (5)
- `_nodeViewRaw` (5)
- `_nodeViewRaw` (5)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:808` | Self: 0.0% (4.3ms) | Total: 0.0% (4.3ms) | Samples: 3

**Called by:**
- `collectUnusedVariables` (3)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1238` | Self: 0.0% (4.3ms) | Total: 0.0% (4.3ms) | Samples: 3

**Called by:**
- `_findDefNode` (1)
- `_findDefNode` (1)
- `_buildReference` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2164` | Self: 0.0% (4.1ms) | Total: 0.2% (11.6ms) | Samples: 3

**Called by:**
- `_buildScope` (8)

**Calls:**
- `get parent` (3)
- `get type` (2)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` | Self: 0.0% (4.1ms) | Total: 0.1% (10.5ms) | Samples: 3

**Called by:**
- `(anonymous)` (7)

**Calls:**
- `get parent` (4)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` | Self: 0.0% (4.0ms) | Total: 0.1% (8.5ms) | Samples: 3

**Called by:**
- `collectUnusedVariables` (6)

**Calls:**
- `get type` (1)
- `get parent` (1)
- `get type` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (3.5ms) | Total: 0.0% (3.5ms) | Samples: 2

**Called by:**
- `_buildScopeChildren` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` | Self: 0.0% (3.4ms) | Total: 0.4% (25.9ms) | Samples: 2

**Called by:**
- `forEach` (17)

**Calls:**
- `init` (7)
- `nodeViewChain` (2)
- `init` (2)
- `get type` (2)
- `get type` (1)
- `nodeViewChain` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` | Self: 0.0% (3.3ms) | Total: 2.4% (130.8ms) | Samples: 2

**Called by:**
- `_computeVarDefs` (88)

**Calls:**
- `get parent` (31)
- `get parent` (15)
- `get parent` (11)
- `get parent` (9)
- `get parent` (7)
- `get parent` (6)
- `get parent` (4)
- `get parent` (2)
- `get parent` (1)

### `Uint8Array`
`[native code]` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `SourceCode` (1)
- `walkNodes` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2067` | Self: 0.0% (3.2ms) | Total: 0.3% (19.3ms) | Samples: 2

**Called by:**
- `_buildReference` (9)
- `_buildScope` (2)
- `_buildScopeChildren` (1)
- `_precomputeScopes` (1)

**Calls:**
- `_nodeViewRaw` (6)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `_precomputeScopes` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` | Self: 0.0% (3.1ms) | Total: 0.8% (43.7ms) | Samples: 2

**Called by:**
- `some` (29)

**Calls:**
- `isReadForItself` (12)
- `isReadForItself` (5)
- `isReadForItself` (3)
- `isReadForItself` (2)
- `isReadForItself` (2)
- `isReadForItself` (1)
- `isReadForItself` (1)
- `isReadForItself` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `_computeVarDefs` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2730` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `isInside`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:494` | Self: 0.0% (3.0ms) | Total: 0.0% (4.3ms) | Samples: 2

**Called by:**
- `getRhsNode` (3)

**Calls:**
- `get range` (1)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:773` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `get name` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6707` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `fill`
`[native code]` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:435` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `parseSource` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2126` | Self: 0.0% (3.0ms) | Total: 0.1% (6.3ms) | Samples: 2

**Called by:**
- `_buildReference` (2)
- `_buildScopeChildren` (1)
- `_buildScope` (1)

**Calls:**
- `get type` (2)

### `test`
`[native code]` | Self: 0.0% (3.0ms) | Total: 0.0% (4.6ms) | Samples: 2

**Called by:**
- `_precomputeScopes` (2)
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `/^\s*globals?\b/` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `_ensureVarsSet` (2)

### `map`
`[native code]` | Self: 0.0% (2.9ms) | Total: 0.1% (6.3ms) | Samples: 2

**Called by:**
- `getDeclaredVariables` (4)

**Calls:**
- `(anonymous)` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2218` | Self: 0.0% (2.9ms) | Total: 0.9% (51.4ms) | Samples: 2

**Called by:**
- `_ensureVarsSet` (33)

**Calls:**
- `_buildVariable` (8)
- `_buildVariable` (7)
- `_buildVariable` (4)
- `_buildVariable` (4)
- `_buildVariable` (3)
- `_buildVariable` (2)
- `_buildVariable` (2)
- `_buildVariable` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1700` | Self: 0.0% (2.9ms) | Total: 0.8% (48.2ms) | Samples: 2

**Called by:**
- `_computeIsStrict` (33)

**Calls:**
- `_nodeViewRaw` (8)
- `_nodeViewRaw` (8)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:802` | Self: 0.0% (2.9ms) | Total: 0.3% (20.5ms) | Samples: 2

**Called by:**
- `_ensureDeclSymIndex` (11)
- `_buildVariable` (2)

**Calls:**
- `_buildSymNameCache` (11)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7117` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` | Self: 0.0% (2.9ms) | Total: 0.2% (12.0ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (8)

**Calls:**
- `get type` (2)
- `get parent` (2)
- `get type` (1)
- `get type` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `_ensureChildren` (2)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:845` | Self: 0.0% (2.8ms) | Total: 9.5% (518.8ms) | Samples: 2

**Called by:**
- `get` (334)
- `_ensureVarsSet` (3)

**Calls:**
- `_buildScopeVarsAndSet` (141)
- `_buildScopeVarsAndSet` (43)
- `_buildScopeVarsAndSet` (33)
- `_buildScopeVarsAndSet` (30)
- `_buildScopeVarsAndSet` (26)
- `_buildScopeVarsAndSet` (11)
- `_buildScopeVarsAndSet` (9)
- `_buildScopeVarsAndSet` (7)
- `_buildScopeVarsAndSet` (7)
- `_buildScopeVarsAndSet` (7)
- `_buildScopeVarsAndSet` (6)
- `_buildScopeVarsAndSet` (5)
- `_buildScopeVarsAndSet` (5)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1182` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `_isChainNode`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3888` | Self: 0.0% (2.8ms) | Total: 0.1% (9.4ms) | Samples: 2

**Called by:**
- `nodeViewChain` (6)

**Calls:**
- `getUint32` (4)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4244` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `_getTypeProto`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3980` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `_nodeViewRaw` (2)

### `_computeVarDefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2778` | Self: 0.0% (2.8ms) | Total: 2.9% (162.2ms) | Samples: 2

**Called by:**
- `defs` (109)

**Calls:**
- `_findDefNode` (88)
- `_findDefNode` (10)
- `_findDefNode` (4)
- `_findDefNode` (3)
- `_findDefNode` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3807` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `replace` (1)
- `_execReport` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4037` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `get parent` (1)
- `_computeVarDefs` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` | Self: 0.0% (2.8ms) | Total: 0.1% (10.7ms) | Samples: 2

**Called by:**
- `(anonymous)` (7)

**Calls:**
- `get type` (3)
- `get type` (2)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2026` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2011` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `isInside`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `getRhsNode` (1)
- `isReadForItself` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:653` | Self: 0.0% (2.7ms) | Total: 0.0% (4.0ms) | Samples: 2

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `get type` (1)

### `forEach`
`[native code]` | Self: 0.0% (2.7ms) | Total: 1.9% (102.8ms) | Samples: 2

**Called by:**
- `getFunctionDefinitions` (67)

**Calls:**
- `(anonymous)` (33)
- `(anonymous)` (17)
- `(anonymous)` (15)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1185` | Self: 0.0% (2.6ms) | Total: 0.0% (2.6ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:647` | Self: 0.0% (2.6ms) | Total: 0.0% (2.6ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2723` | Self: 0.0% (2.6ms) | Total: 0.0% (2.6ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (1)
- `getDeclaredVariables` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:482` | Self: 0.0% (2.5ms) | Total: 0.0% (2.5ms) | Samples: 2

**Called by:**
- `_computeVarDefs` (2)

### `_resolveHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6881` | Self: 0.0% (2.5ms) | Total: 0.0% (2.5ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_ensureTagCaches`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5595` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` | Self: 0.0% (1.8ms) | Total: 18.3% (995.3ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (646)

**Calls:**
- `isAfterLastUsedArg` (462)
- `isAfterLastUsedArg` (163)
- `isAfterLastUsedArg` (19)
- `isAfterLastUsedArg` (1)

### `get right`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1788` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `getRhsNode` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3958` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` | Self: 0.0% (1.7ms) | Total: 1.9% (105.8ms) | Samples: 1

**Called by:**
- `isUsedVariable` (69)

**Calls:**
- `forEach` (67)
- `defs` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2317` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `_filteredBuiltins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:275` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2891` | Self: 0.0% (1.7ms) | Total: 0.2% (11.1ms) | Samples: 1

**Called by:**
- `get references` (7)

**Calls:**
- `scope` (6)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3113` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2870` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `get references` (1)

### `slice`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_buildSymNameCache` (1)

### `readFileSync`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (3.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)
- `readFileSync` (1)

**Calls:**
- `readFileSync` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2109` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `_computeVarScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2804` | Self: 0.0% (1.7ms) | Total: 0.0% (4.6ms) | Samples: 1

**Called by:**
- `scope` (3)

**Calls:**
- `_buildScope` (2)

### `_rawTokenText`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:794` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `get value` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2943` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `get references` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:959` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` | Self: 0.0% (1.6ms) | Total: 4.5% (246.8ms) | Samples: 1

**Called by:**
- `some` (160)

**Calls:**
- `get references` (140)
- `get references` (19)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:561` | Self: 0.0% (1.6ms) | Total: 0.1% (6.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `nodeViewChain` (1)
- `get right` (1)
- `nodeViewChain` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1717` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` | Self: 0.0% (1.6ms) | Total: 0.0% (3.0ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (2)

**Calls:**
- `get parent` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2672` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `getScope` (1)

### `/^\s*globals?\b/`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `test` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3152` | Self: 0.0% (1.6ms) | Total: 0.0% (3.4ms) | Samples: 1

**Called by:**
- `map` (2)

**Calls:**
- `get name` (1)

### `replace`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (3.1ms) | Samples: 1

**Called by:**
- `_execReport` (2)

**Calls:**
- `(anonymous)` (1)

### `_lineStarts`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:610` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_findLineIdx` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1478` | Self: 0.0% (1.6ms) | Total: 0.1% (7.9ms) | Samples: 1

**Called by:**
- `_buildScope` (3)
- `get parent` (2)

**Calls:**
- `_nodesFromRange` (4)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1037` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1689` | Self: 0.0% (1.5ms) | Total: 0.0% (4.6ms) | Samples: 1

**Called by:**
- `isForInOfRef` (2)
- `isForInOfRef` (1)

**Calls:**
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2910` | Self: 0.0% (1.5ms) | Total: 0.1% (8.1ms) | Samples: 1

**Called by:**
- `(anonymous)` (4)
- `(anonymous)` (1)

**Calls:**
- `nodeRhs` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6818` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2864` | Self: 0.0% (1.5ms) | Total: 0.3% (17.5ms) | Samples: 1

**Called by:**
- `get references` (11)

**Calls:**
- `get parent` (5)
- `get parent` (5)

### `readdirSync`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (3.1ms) | Samples: 1

**Called by:**
- `readdirSync` (1)
- `loadCoreRules` (1)

**Calls:**
- `readdirSync` (1)

### `computeGlobals`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_lintSourceOne` (1)

### `get directive`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3337` | Self: 0.0% (1.5ms) | Total: 0.0% (2.6ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (2)

**Calls:**
- `_tag` (1)

### `isUnusedExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:508` | Self: 0.0% (1.5ms) | Total: 0.0% (3.1ms) | Samples: 1

**Called by:**
- `getRhsNode` (2)

**Calls:**
- `get type` (1)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2997` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `get references` (1)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:447` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `getRhsNode` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2077` | Self: 0.0% (1.5ms) | Total: 0.2% (12.2ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (4)
- `_buildReference` (3)
- `_buildScope` (1)

**Calls:**
- `get value` (3)
- `get value` (1)
- `get value` (1)
- `get value` (1)
- `get value` (1)

### `extraMethodData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:694` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `get value` (1)

### `get eslintUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:738` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1699` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:619` | Self: 0.0% (1.4ms) | Total: 0.0% (3.0ms) | Samples: 1

**Called by:**
- `commentsInRange` (2)

**Calls:**
- `_lineStarts` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2027` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `isReadRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:431` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get start`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1092` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `range` (1)

### `range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3594` | Self: 0.0% (1.4ms) | Total: 0.0% (2.8ms) | Samples: 1

**Called by:**
- `get value` (1)
- `get references` (1)

**Calls:**
- `get start` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1184` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1709` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `some` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2098` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2426` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `ensureBufferBytes`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:53` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_encodeSource` (1)

### `Uint16Array`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `identifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:757` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `get eslintUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2670` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getScope` (1)

### `get init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2913` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_getTypeProto`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3972` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `exec`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (4.7ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (3)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (2)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2137` | Self: 0.0% (1.3ms) | Total: 0.1% (5.7ms) | Samples: 1

**Called by:**
- `_buildReference` (3)
- `_buildScope` (1)

**Calls:**
- `get name` (2)
- `get name` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:540` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:855` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3594` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `isInside` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6443` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `get kind`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `get directive`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3393` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2062` | Self: 0.0% (1.2ms) | Total: 4.2% (232.6ms) | Samples: 1

**Called by:**
- `_buildReference` (103)
- `_buildScope` (52)

**Calls:**
- `_buildScope` (78)
- `_buildScope` (52)
- `_buildScope` (12)
- `_buildScope` (4)
- `_buildScope` (3)
- `_buildScope` (2)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1674` | Self: 0.0% (1.2ms) | Total: 0.1% (7.2ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (5)

**Calls:**
- `get _tag` (4)

### `_computeVariableSynthRefs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2956` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `get references` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1325` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `isUnusedExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:506` | Self: 0.0% (1.2ms) | Total: 0.1% (7.7ms) | Samples: 1

**Called by:**
- `getRhsNode` (4)
- `isReadForItself` (1)

**Calls:**
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)

### `_tag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1072` | Self: 0.0% (1.1ms) | Total: 0.0% (1.1ms) | Samples: 1

**Called by:**
- `get directive` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:557` | Self: 0.0% (0us) | Total: 0.1% (9.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `isUnusedExpression` (4)
- `isUnusedExpression` (2)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:654` | Self: 0.0% (0us) | Total: 0.0% (3.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `_nodeViewRaw` (1)
- `get left` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3872` | Self: 0.0% (0us) | Total: 0.0% (4.4ms) | Samples: 0

**Called by:**
- `Program:exit` (3)

**Calls:**
- `_execReport` (3)

### `_ensureChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:924` | Self: 0.0% (0us) | Total: 1.3% (75.6ms) | Samples: 0

**Called by:**
- `get` (48)

**Calls:**
- `_buildScopeChildren` (38)
- `_buildScopeChildren` (5)
- `_buildScopeChildren` (3)
- `_buildScopeChildren` (2)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` | Self: 0.0% (0us) | Total: 24.1% (1.30s) | Samples: 0

**Called by:**
- `_lintSourceOne` (860)

**Calls:**
- `parse` (860)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1228` | Self: 0.0% (0us) | Total: 0.2% (10.9ms) | Samples: 0

**Called by:**
- `_findDefNode` (7)

**Calls:**
- `get value` (2)
- `get value` (2)
- `get value` (2)
- `get value` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule_cfg.js:15` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `readFileSync` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:689` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get body` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2180` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_buildScope` (1)

**Calls:**
- `get body` (1)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:92` | Self: 0.0% (0us) | Total: 0.1% (6.2ms) | Samples: 0

**Called by:**
- `parseSource` (4)

**Calls:**
- `encodeInto` (4)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` | Self: 0.0% (0us) | Total: 0.1% (7.2ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (4)

**Calls:**
- `AstView` (2)
- `AstView` (1)
- `AstView` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` | Self: 0.0% (0us) | Total: 0.0% (2.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:458` | Self: 0.0% (0us) | Total: 0.1% (6.5ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `patchAstUtils` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js:133` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7463` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `RuleContext` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:215` | Self: 0.0% (0us) | Total: 0.1% (7.5ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (5)

**Calls:**
- `_encodeSource` (4)
- `_encodeSource` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1384` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_buildScope` (1)

**Calls:**
- `_rawTokenText` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:776` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (2)

**Calls:**
- `get id` (1)
- `get identifiers` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:558` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get left` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5984` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_ensureTagCaches` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6811` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `Uint8Array` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6957` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `_resolveHandlers` (2)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:304` | Self: 0.0% (0us) | Total: 75.2% (4.06s) | Samples: 0

**Calls:**
- `runPlugins` (2648)
- `runPlugins` (10)
- `runPlugins` (2)
- `runPlugins` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1680` | Self: 0.0% (0us) | Total: 1.4% (77.7ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (51)

**Calls:**
- `_nodesFromRange` (45)
- `_nodesFromRange` (6)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:887` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `get kind` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1703` | Self: 0.0% (0us) | Total: 0.2% (11.3ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (8)

**Calls:**
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `SourceCode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1010` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `RuleContext` (1)

**Calls:**
- `Uint8Array` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` | Self: 0.0% (0us) | Total: 1.7% (93.9ms) | Samples: 0

**Called by:**
- `_invokeFused` (61)

**Calls:**
- `getScope` (61)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4062` | Self: 0.0% (0us) | Total: 0.1% (9.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `getRhsNode` (1)

**Calls:**
- `_isChainNode` (6)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:90` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `ensureBufferBytes` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2250` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `_filteredBuiltins` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2221` | Self: 0.0% (0us) | Total: 0.2% (13.9ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (9)

**Calls:**
- `identifiers` (6)
- `get identifiers` (2)
- `identifiers` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1492` | Self: 0.0% (0us) | Total: 0.0% (4.5ms) | Samples: 0

**Called by:**
- `get parent` (2)
- `_buildScope` (1)

**Calls:**
- `_nodeViewRaw` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7184` | Self: 0.0% (0us) | Total: 68.0% (3.68s) | Samples: 0

**Called by:**
- `runPlugins` (2409)

**Calls:**
- `_invokeFused` (2409)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:300` | Self: 0.0% (0us) | Total: 24.4% (1.32s) | Samples: 0

**Calls:**
- `parseSource` (860)
- `parseSource` (5)
- `parseSource` (4)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` | Self: 0.0% (0us) | Total: 0.1% (6.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `bound require` (4)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:957` | Self: 0.0% (0us) | Total: 1.3% (75.6ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (48)

**Calls:**
- `_ensureChildren` (48)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:144` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Calls:**
- `loadCoreRules` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (2.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:401` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `Uint16Array` (1)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:47` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (1)

**Calls:**
- `readdirSync` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:575` | Self: 0.0% (0us) | Total: 0.2% (11.1ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (8)

**Calls:**
- `_findLineIdx` (6)
- `_findLineIdx` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule_cfg.js:29` | Self: 0.0% (0us) | Total: 0.2% (11.9ms) | Samples: 0

**Called by:**
- `parseModule` (7)

**Calls:**
- `async (anonymous)` (7)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:972` | Self: 0.0% (0us) | Total: 0.4% (23.9ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (16)

**Calls:**
- `_ensureVarsSet` (16)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` | Self: 0.0% (0us) | Total: 0.0% (4.4ms) | Samples: 0

**Called by:**
- `_invokeFused` (3)

**Calls:**
- `report` (3)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1716` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `_nodesFromRange` (1)

### `parseModule`
`[native code]` | Self: 0.0% (0us) | Total: 0.2% (15.0ms) | Samples: 0

**Called by:**
- `async (anonymous)` (9)

**Calls:**
- `(anonymous)` (7)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:484` | Self: 0.0% (0us) | Total: 0.1% (6.5ms) | Samples: 0

**Called by:**
- `_computeVarDefs` (4)

**Calls:**
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:661` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isInside` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2012` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (2)

**Calls:**
- `get` (2)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1894` | Self: 0.0% (0us) | Total: 1.7% (93.9ms) | Samples: 0

**Called by:**
- `Program:exit` (61)

**Calls:**
- `_precomputeScopes` (46)
- `_precomputeScopes` (10)
- `_precomputeScopes` (3)
- `_precomputeScopes` (1)
- `_precomputeScopes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` | Self: 0.0% (0us) | Total: 0.1% (7.6ms) | Samples: 0

**Called by:**
- `some` (5)

**Calls:**
- `isSelfReference` (5)

### `identifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:756` | Self: 0.0% (0us) | Total: 0.1% (9.7ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (6)

**Calls:**
- `defs` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3151` | Self: 0.0% (0us) | Total: 0.1% (6.3ms) | Samples: 0

**Called by:**
- `isAfterLastUsedArg` (4)

**Calls:**
- `map` (4)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:576` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (1)

**Calls:**
- `_findLineIdx` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:441` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `CfgGraph` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1482` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `get parent` (1)

**Calls:**
- `range` (1)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:511` | Self: 0.0% (0us) | Total: 0.2% (13.7ms) | Samples: 0

**Called by:**
- `runPlugins` (9)

**Calls:**
- `decode` (9)

### `get init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2909` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `getUint32` (2)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1483` | Self: 0.0% (0us) | Total: 0.0% (4.6ms) | Samples: 0

**Called by:**
- `get parent` (2)
- `_buildScope` (1)

**Calls:**
- `get loc` (3)

### `getUpperFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:132` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `isInsideOfStorableFunction` (1)

**Calls:**
- `get parent` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:953` | Self: 0.0% (0us) | Total: 9.5% (518.4ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (337)

**Calls:**
- `_ensureVarsSet` (334)
- `_ensureVarsSet` (3)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 0.8% (44.1ms) | Samples: 0

**Called by:**
- `bound require` (26)

**Calls:**
- `anonymous` (26)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:519` | Self: 0.0% (0us) | Total: 0.0% (4.6ms) | Samples: 0

**Called by:**
- `_computeVarDefs` (3)

**Calls:**
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `get left`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1756` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `getRhsNode` (1)
- `isReadForItself` (1)

**Calls:**
- `getUint32` (2)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7468` | Self: 0.0% (0us) | Total: 74.8% (4.04s) | Samples: 0

**Called by:**
- `_lintSourceOne` (2648)

**Calls:**
- `walkNodes` (2409)
- `walkNodes` (167)
- `walkNodes` (29)
- `walkNodes` (10)
- `walkNodes` (9)
- `walkNodes` (9)
- `walkNodes` (6)
- `walkNodes` (2)
- `walkNodes` (2)
- `walkNodes` (2)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2697` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (2)

**Calls:**
- `_symName` (2)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4639` | Self: 0.0% (0us) | Total: 68.0% (3.68s) | Samples: 0

**Called by:**
- `walkNodes` (2409)

**Calls:**
- `Program:exit` (2342)
- `Program:exit` (61)
- `Program:exit` (3)
- `Program:exit` (2)
- `Program:exit` (1)

### `get id`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2259` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `getUint32` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7448` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (2)

**Calls:**
- `fill` (2)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7460` | Self: 0.0% (0us) | Total: 0.2% (15.5ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (10)

**Calls:**
- `get source` (9)
- `reset` (1)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.2% (15.0ms) | Samples: 0

**Calls:**
- `parseModule` (9)

### `get identifiers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:756` | Self: 0.0% (0us) | Total: 0.0% (4.4ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (2)
- `collectUnusedVariables` (1)

**Calls:**
- `defs` (3)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:882` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `push` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:752` | Self: 0.0% (0us) | Total: 4.6% (251.8ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (163)

**Calls:**
- `some` (163)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` | Self: 0.0% (0us) | Total: 66.1% (3.57s) | Samples: 0

**Called by:**
- `_invokeFused` (2342)

**Calls:**
- `collectUnusedVariables` (2127)
- `collectUnusedVariables` (184)
- `collectUnusedVariables` (31)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:881` | Self: 0.0% (0us) | Total: 0.1% (10.4ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (7)

**Calls:**
- `get name` (6)
- `get name` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1474` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_buildScope` (1)

**Calls:**
- `extraMethodData` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:662` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isInsideOfStorableFunction` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule_cfg.js:20` | Self: 0.0% (0us) | Total: 0.2% (11.9ms) | Samples: 0

**Called by:**
- `async (anonymous)` (7)

**Calls:**
- `bound require` (7)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:880` | Self: 0.0% (0us) | Total: 0.1% (5.9ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (4)

**Calls:**
- `_buildReference` (2)
- `_buildReference` (2)

### `isInsideOfStorableFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:630` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `isReadForItself` (1)

**Calls:**
- `getUpperFunction` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6948` | Self: 0.0% (0us) | Total: 0.1% (9.5ms) | Samples: 0

**Called by:**
- `runPlugins` (6)

**Calls:**
- `getDFSEvents` (4)
- `getDFSEvents` (1)
- `getDFSEvents` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` | Self: 0.0% (0us) | Total: 1.8% (97.5ms) | Samples: 0

**Called by:**
- `some` (65)

**Calls:**
- `isForInOfRef` (19)
- `isForInOfRef` (16)
- `isForInOfRef` (12)
- `isForInOfRef` (7)
- `isForInOfRef` (7)
- `isForInOfRef` (3)
- `isForInOfRef` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1708` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `_invokeFused` (2)

**Calls:**
- `some` (1)
- `get references` (1)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2907` | Self: 0.0% (0us) | Total: 0.3% (16.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (6)
- `(anonymous)` (3)
- `(anonymous)` (2)

**Calls:**
- `get _tag` (8)
- `get _tag` (3)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:967` | Self: 0.0% (0us) | Total: 0.4% (23.9ms) | Samples: 0

**Called by:**
- `get` (16)

**Calls:**
- `_ensureVarsSet` (7)
- `_ensureVarsSet` (4)
- `_ensureVarsSet` (3)
- `_ensureVarsSet` (1)
- `_ensureVarsSet` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:688` | Self: 0.0% (0us) | Total: 0.0% (4.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `get body` (2)
- `get type` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3136` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `isAfterLastUsedArg` (2)

**Calls:**
- `push` (2)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` | Self: 0.0% (0us) | Total: 0.4% (23.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (16)

**Calls:**
- `get parent` (4)
- `get parent` (3)
- `get parent` (3)
- `get parent` (3)
- `get parent` (2)
- `get parent` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2163` | Self: 0.0% (0us) | Total: 1.1% (62.6ms) | Samples: 0

**Called by:**
- `_buildScope` (40)

**Calls:**
- `get parent` (10)
- `get parent` (10)
- `get parent` (8)
- `get parent` (5)
- `get parent` (4)
- `get parent` (2)
- `get parent` (1)

### `get references`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:803` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `range` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2833` | Self: 0.0% (0us) | Total: 10.1% (548.9ms) | Samples: 0

**Called by:**
- `get references` (359)
- `_ensureVarsSet` (2)

**Calls:**
- `get parent` (162)
- `get parent` (69)
- `get parent` (42)
- `get parent` (31)
- `get parent` (26)
- `get parent` (20)
- `get parent` (6)
- `get parent` (4)
- `get parent` (1)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2909` | Self: 0.0% (0us) | Total: 0.2% (11.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (7)
- `(anonymous)` (1)

**Calls:**
- `nodeLhs` (4)
- `getUint32` (4)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2602` | Self: 0.0% (0us) | Total: 0.0% (4.2ms) | Samples: 0

**Called by:**
- `getScope` (3)

**Calls:**
- `_buildScope` (2)
- `_buildScope` (1)

### `RuleContext`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3930` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `SourceCode` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` | Self: 0.0% (0us) | Total: 2.2% (119.8ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (79)

**Calls:**
- `defs` (77)
- `get defs` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` | Self: 0.0% (0us) | Total: 0.1% (9.6ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2223` | Self: 0.0% (0us) | Total: 0.2% (11.2ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (7)

**Calls:**
- `get references` (6)
- `get references` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3807` | Self: 0.0% (0us) | Total: 0.0% (4.4ms) | Samples: 0

**Called by:**
- `report` (3)

**Calls:**
- `replace` (2)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule_cfg.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `bound require` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` | Self: 0.0% (0us) | Total: 13.1% (710.6ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (462)

**Calls:**
- `getDeclaredVariables` (122)
- `getDeclaredVariables` (99)
- `getDeclaredVariables` (87)
- `getDeclaredVariables` (65)
- `getDeclaredVariables` (30)
- `getDeclaredVariables` (19)
- `getDeclaredVariables` (13)
- `getDeclaredVariables` (12)
- `getDeclaredVariables` (7)
- `getDeclaredVariables` (4)
- `getDeclaredVariables` (2)
- `getDeclaredVariables` (1)
- `getDeclaredVariables` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:747` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `defs` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:291` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Calls:**
- `computeGlobals` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1337` | Self: 0.0% (0us) | Total: 0.1% (9.0ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (6)

**Calls:**
- `_resolveUnicodeEscapes` (4)
- `_identAt` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `some` (1)

**Calls:**
- `isReadRef` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` | Self: 0.0% (0us) | Total: 2.0% (113.2ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (74)

**Calls:**
- `getFunctionDefinitions` (69)
- `getFunctionDefinitions` (5)

### `get defs`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:750` | Self: 0.0% (0us) | Total: 0.0% (5.4ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (2)
- `getDeclaredVariables` (2)

**Calls:**
- `_computeVarDefs` (3)
- `_computeVarDefs` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2186` | Self: 0.0% (0us) | Total: 0.0% (3.9ms) | Samples: 0

**Called by:**
- `_buildScope` (3)

**Calls:**
- `get directive` (2)
- `get directive` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:655` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isUnusedExpression` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` | Self: 0.0% (0us) | Total: 0.2% (15.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (10)

**Calls:**
- `isInLoop` (9)
- `isInLoop` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2025` | Self: 0.0% (0us) | Total: 0.3% (17.6ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (11)

**Calls:**
- `_symName` (11)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.0% (3.5ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn-jsx/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule_cfg.js:19` | Self: 0.0% (0us) | Total: 0.2% (11.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (7)

**Calls:**
- `async (anonymous)` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:551` | Self: 0.0% (0us) | Total: 0.1% (5.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `isInside` (3)
- `isInside` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2669` | Self: 0.0% (0us) | Total: 1.2% (70.2ms) | Samples: 0

**Called by:**
- `getScope` (46)

**Calls:**
- `commentsInRange` (32)
- `commentsInRange` (8)
- `commentsInRange` (3)
- `commentsInRange` (2)
- `commentsInRange` (1)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 0.8% (45.4ms) | Samples: 0

**Called by:**
- `async (anonymous)` (7)
- `(anonymous)` (6)
- `patchAstUtils` (4)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `require` (26)
- `anonymous` (1)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 34.1% | 1.84s | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 30.3% | 1.64s | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 30.0% | 1.62s | `[native code]` |
| 5.3% | 291.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.0% | 1.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/index.js` |
| 0.0% | 1.2ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` |
