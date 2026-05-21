# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 3.85s | 2517 | 1.0ms | 349 |

**Top 10:** `Set` 6.9%, `walkNodes` 6.5%, `defineProperties` 6.4%, `getDeclaredVariables` 3.8%, `_buildReference` 3.2%, `getDeclaredVariables` 2.7%, `get` 2.2%, `_ensureDeclSymIndex` 2.1%, `_buildVariable` 1.7%, `parse` 1.7%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 6.9% | 266.5ms | 6.9% | 266.5ms | `Set` | `[native code]` |
| 6.5% | 254.2ms | 7.0% | 273.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6939` |
| 6.4% | 248.3ms | 6.4% | 248.3ms | `defineProperties` | `[native code]` |
| 3.8% | 150.2ms | 3.8% | 150.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3124` |
| 3.2% | 126.4ms | 4.2% | 163.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2893` |
| 2.7% | 106.4ms | 2.7% | 107.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3130` |
| 2.2% | 87.7ms | 2.2% | 87.7ms | `get` | `[native code]` |
| 2.1% | 82.2ms | 2.9% | 113.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1696` |
| 1.7% | 69.1ms | 2.0% | 80.1ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2615` |
| 1.7% | 67.1ms | 1.7% | 67.1ms | `parse` | `[native code]` |
| 1.7% | 65.5ms | 1.7% | 65.5ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1006` |
| 1.6% | 64.1ms | 2.1% | 84.2ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2950` |
| 1.6% | 64.1ms | 1.6% | 64.1ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3036` |
| 1.6% | 62.9ms | 1.6% | 62.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1222` |
| 1.5% | 60.8ms | 3.2% | 126.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1762` |
| 1.3% | 50.3ms | 20.4% | 790.2ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2559` |
| 1.2% | 48.9ms | 1.2% | 48.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2048` |
| 1.2% | 48.8ms | 1.2% | 48.8ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 1.2% | 47.7ms | 1.2% | 47.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` |
| 0.9% | 38.2ms | 1.1% | 43.7ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 0.9% | 36.1ms | 0.9% | 36.1ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3019` |
| 0.9% | 35.3ms | 0.9% | 35.3ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.9% | 35.1ms | 0.9% | 35.1ms | `set` | `[native code]` |
| 0.8% | 33.9ms | 0.8% | 33.9ms | `push` | `[native code]` |
| 0.8% | 32.5ms | 0.8% | 32.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6695` |
| 0.8% | 31.2ms | 0.8% | 31.2ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3013` |
| 0.8% | 31.0ms | 4.4% | 173.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1935` |
| 0.7% | 30.4ms | 0.7% | 30.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3994` |
| 0.7% | 29.9ms | 2.4% | 93.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 0.7% | 28.8ms | 100.0% | 5.14s | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3002` |
| 0.7% | 28.4ms | 0.7% | 28.4ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3090` |
| 0.7% | 28.2ms | 0.7% | 28.2ms | `get _tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1072` |
| 0.7% | 27.7ms | 54.0% | 2.08s | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 0.6% | 26.1ms | 6.2% | 239.0ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3122` |
| 0.6% | 26.0ms | 10.6% | 411.0ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2868` |
| 0.6% | 25.9ms | 1.3% | 50.6ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1697` |
| 0.6% | 24.9ms | 7.0% | 273.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1964` |
| 0.6% | 24.9ms | 0.8% | 31.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2606` |
| 0.6% | 24.7ms | 0.6% | 24.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2034` |
| 0.6% | 24.1ms | 1.6% | 62.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2139` |
| 0.6% | 23.3ms | 0.6% | 23.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1175` |
| 0.5% | 23.0ms | 0.6% | 24.5ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.5% | 22.9ms | 0.5% | 22.9ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1694` |
| 0.5% | 22.4ms | 0.5% | 22.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3999` |
| 0.5% | 21.6ms | 8.7% | 337.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2032` |
| 0.5% | 21.2ms | 2.0% | 77.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2861` |
| 0.5% | 20.9ms | 0.5% | 20.9ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2416` |
| 0.5% | 20.6ms | 0.5% | 20.6ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2987` |
| 0.5% | 20.4ms | 0.5% | 20.4ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2870` |
| 0.5% | 19.5ms | 0.7% | 30.1ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2864` |
| 0.4% | 19.2ms | 0.6% | 24.1ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3028` |
| 0.4% | 18.9ms | 0.4% | 18.9ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2549` |
| 0.4% | 18.4ms | 0.4% | 18.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2529` |
| 0.4% | 18.3ms | 0.4% | 18.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.4% | 18.2ms | 7.9% | 307.9ms | `some` | `[native code]` |
| 0.4% | 17.7ms | 0.8% | 34.4ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` |
| 0.4% | 17.2ms | 0.4% | 17.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3123` |
| 0.4% | 17.0ms | 0.4% | 17.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6940` |
| 0.4% | 16.4ms | 0.4% | 17.8ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` |
| 0.4% | 16.3ms | 1.3% | 53.5ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2944` |
| 0.4% | 15.7ms | 0.4% | 15.7ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` |
| 0.3% | 15.1ms | 1.0% | 39.0ms | `anonymous` | `[native code]` |
| 0.3% | 14.9ms | 0.3% | 14.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6684` |
| 0.3% | 14.6ms | 7.4% | 287.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 0.3% | 14.4ms | 0.3% | 14.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1727` |
| 0.3% | 14.2ms | 0.3% | 14.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7107` |
| 0.3% | 14.1ms | 0.3% | 14.1ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2247` |
| 0.3% | 13.3ms | 0.3% | 13.3ms | `has` | `[native code]` |
| 0.3% | 12.6ms | 0.6% | 26.3ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.3% | 12.5ms | 0.3% | 12.5ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2907` |
| 0.3% | 12.4ms | 0.5% | 19.4ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:682` |
| 0.3% | 12.0ms | 0.6% | 26.9ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2005` |
| 0.3% | 11.9ms | 0.3% | 13.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1228` |
| 0.3% | 11.7ms | 0.3% | 11.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1779` |
| 0.3% | 11.7ms | 0.3% | 11.7ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4865` |
| 0.2% | 11.0ms | 0.2% | 11.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6938` |
| 0.2% | 10.9ms | 0.3% | 13.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1285` |
| 0.2% | 10.6ms | 0.5% | 20.0ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` |
| 0.2% | 10.6ms | 0.2% | 10.6ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2816` |
| 0.2% | 10.1ms | 0.2% | 10.1ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:619` |
| 0.2% | 10.0ms | 0.2% | 10.0ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 9.3ms | 0.2% | 9.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3986` |
| 0.2% | 9.2ms | 0.2% | 9.2ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3018` |
| 0.2% | 9.1ms | 0.7% | 28.1ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2564` |
| 0.2% | 9.1ms | 0.2% | 9.1ms | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 9.1ms | 0.2% | 9.1ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2967` |
| 0.2% | 8.8ms | 0.2% | 8.8ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1673` |
| 0.2% | 8.1ms | 0.2% | 8.1ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2251` |
| 0.2% | 8.1ms | 0.2% | 8.1ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3097` |
| 0.2% | 8.1ms | 0.2% | 8.1ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2946` |
| 0.2% | 8.1ms | 0.2% | 8.1ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 8.0ms | 0.2% | 8.0ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1007` |
| 0.2% | 7.7ms | 0.3% | 14.1ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` |
| 0.2% | 7.7ms | 0.2% | 7.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1295` |
| 0.1% | 7.6ms | 0.1% | 7.6ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6434` |
| 0.1% | 7.5ms | 0.3% | 15.1ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.1% | 7.5ms | 0.1% | 7.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3991` |
| 0.1% | 7.5ms | 0.9% | 37.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2588` |
| 0.1% | 7.4ms | 0.3% | 14.9ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:506` |
| 0.1% | 7.3ms | 0.1% | 7.3ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1013` |
| 0.1% | 7.3ms | 0.1% | 7.3ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6432` |
| 0.1% | 7.2ms | 0.1% | 7.2ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 6.8ms | 0.4% | 17.6ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` |
| 0.1% | 6.7ms | 0.2% | 10.0ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` |
| 0.1% | 6.7ms | 0.1% | 6.7ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1011` |
| 0.1% | 6.6ms | 0.4% | 16.0ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1987` |
| 0.1% | 6.2ms | 21.6% | 835.0ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2041` |
| 0.1% | 6.1ms | 100.0% | 10.65s | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 0.1% | 6.1ms | 88.4% | 3.40s | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2923` |
| 0.1% | 6.0ms | 0.1% | 6.0ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` |
| 0.1% | 5.9ms | 0.5% | 19.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1699` |
| 0.1% | 5.9ms | 0.1% | 5.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2255` |
| 0.1% | 5.8ms | 0.1% | 5.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4011` |
| 0.1% | 5.8ms | 0.1% | 5.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7106` |
| 0.1% | 5.7ms | 0.1% | 5.7ms | `/^\s*globals?\b/` | `[native code]` |
| 0.1% | 5.6ms | 0.1% | 5.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4003` |
| 0.1% | 5.6ms | 0.1% | 5.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3995` |
| 0.1% | 5.5ms | 0.3% | 11.7ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2509` |
| 0.1% | 5.0ms | 2.1% | 82.8ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1695` |
| 0.1% | 4.8ms | 0.1% | 4.8ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1679` |
| 0.1% | 4.8ms | 1.6% | 63.2ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4037` |
| 0.1% | 4.8ms | 0.2% | 10.7ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2907` |
| 0.1% | 4.8ms | 0.1% | 4.8ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1775` |
| 0.1% | 4.8ms | 0.1% | 4.8ms | `/^\s*exported\b/` | `[native code]` |
| 0.1% | 4.7ms | 0.1% | 4.7ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2508` |
| 0.1% | 4.6ms | 0.1% | 4.6ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 4.6ms | 0.1% | 4.6ms | `get _tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 4.6ms | 0.1% | 4.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4005` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4056` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2713` |
| 0.1% | 4.4ms | 3.3% | 128.6ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3103` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2845` |
| 0.1% | 4.2ms | 0.1% | 4.2ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 4.2ms | 1.8% | 71.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 0.1% | 4.1ms | 0.1% | 4.1ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.1% | 4.1ms | 0.8% | 31.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` |
| 0.1% | 4.0ms | 0.1% | 7.3ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1698` |
| 0.0% | 3.3ms | 16.7% | 647.6ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2419` |
| 0.0% | 3.3ms | 0.1% | 4.8ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3011` |
| 0.0% | 3.3ms | 0.1% | 6.5ms | `exec` | `[native code]` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4002` |
| 0.0% | 3.2ms | 0.5% | 19.3ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4065` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `isReadRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:431` |
| 0.0% | 3.1ms | 0.4% | 18.8ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2892` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2822` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` |
| 0.0% | 3.1ms | 0.4% | 16.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1802` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2684` |
| 0.0% | 3.0ms | 0.1% | 4.3ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2909` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3126` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1707` |
| 0.0% | 3.0ms | 4.8% | 188.8ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 0.0% | 3.0ms | 17.7% | 682.5ms | `ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1928` |
| 0.0% | 3.0ms | 2.5% | 98.6ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1330` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2249` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2042` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3394` |
| 0.0% | 2.8ms | 34.9% | 1.34s | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1900` |
| 0.0% | 2.8ms | 0.1% | 4.3ms | `test` | `[native code]` |
| 0.0% | 2.8ms | 18.7% | 722.8ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2423` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1983` |
| 0.0% | 2.7ms | 0.1% | 6.2ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:653` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:582` |
| 0.0% | 2.6ms | 17.8% | 688.4ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1969` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:467` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4244` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:626` |
| 0.0% | 1.8ms | 0.1% | 6.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1741` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:226` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3997` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:543` |
| 0.0% | 1.7ms | 0.3% | 13.7ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2009` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` |
| 0.0% | 1.7ms | 92.8% | 3.57s | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3035` |
| 0.0% | 1.7ms | 0.1% | 7.6ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:482` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3996` |
| 0.0% | 1.7ms | 1.3% | 51.1ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `extraClassData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:670` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1862` |
| 0.0% | 1.7ms | 19.4% | 749.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2140` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:887` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1829` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:514` |
| 0.0% | 1.6ms | 0.4% | 15.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` |
| 0.0% | 1.6ms | 0.0% | 3.4ms | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1873` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:720` |
| 0.0% | 1.6ms | 0.0% | 3.3ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:519` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3104` |
| 0.0% | 1.6ms | 0.1% | 4.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1744` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1709` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:508` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:818` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:561` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2257` |
| 0.0% | 1.5ms | 0.0% | 3.1ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:662` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1898` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3089` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6425` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:773` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:797` |
| 0.0% | 1.5ms | 0.0% | 2.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1752` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1384` |
| 0.0% | 1.5ms | 0.1% | 7.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1746` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.5ms | 0.3% | 11.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` |
| 0.0% | 1.5ms | 0.2% | 10.1ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1710` |
| 0.0% | 1.5ms | 0.0% | 3.2ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2694` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1019` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:429` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3816` |
| 0.0% | 1.4ms | 0.0% | 2.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1803` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1684` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `findIndex` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 3.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1255` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isRead` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2752` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2991` |
| 0.0% | 1.4ms | 0.5% | 22.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `RuleContext` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2506` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4001` |
| 0.0% | 1.3ms | 0.2% | 8.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2141` |
| 0.0% | 1.3ms | 1.1% | 45.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1189` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2945` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3947` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2049` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1692` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2804` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1819` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.1% | 4.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1237` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1756` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4008` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1685` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:484` |
| 0.0% | 1.2ms | 0.0% | 3.0ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:701` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `Uint8Array` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1200` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:561` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.1% | 7.3ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3128` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3106` |
| 0.0% | 1.2ms | 0.0% | 2.4ms | `readFileSync` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1700` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2913` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 100.0% | 10.65s | 0.1% | 6.1ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 100.0% | 5.14s | 0.7% | 28.8ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3002` |
| 100.0% | 3.85s | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 100.0% | 3.85s | 0.0% | 0us | `parseModule` | `[native code]` |
| 99.8% | 3.85s | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` |
| 99.8% | 3.85s | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` |
| 97.5% | 3.76s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7457` |
| 92.8% | 3.57s | 0.0% | 1.7ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3035` |
| 90.5% | 3.49s | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:66` |
| 88.4% | 3.40s | 0.1% | 6.1ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2923` |
| 87.4% | 3.37s | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4628` |
| 87.4% | 3.37s | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7173` |
| 85.0% | 3.27s | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` |
| 54.0% | 2.08s | 0.7% | 27.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 35.4% | 1.36s | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1965` |
| 34.9% | 1.34s | 0.0% | 2.8ms | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1900` |
| 21.6% | 835.0ms | 0.1% | 6.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2041` |
| 20.4% | 790.2ms | 1.3% | 50.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2559` |
| 19.4% | 749.0ms | 0.0% | 1.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` |
| 18.7% | 722.8ms | 0.0% | 2.8ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` |
| 17.8% | 688.4ms | 0.0% | 2.6ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1969` |
| 17.7% | 682.5ms | 0.0% | 3.0ms | `ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1928` |
| 16.7% | 647.6ms | 0.0% | 3.3ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2419` |
| 10.6% | 411.0ms | 0.6% | 26.0ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2868` |
| 8.7% | 337.7ms | 0.5% | 21.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2032` |
| 7.9% | 307.9ms | 0.4% | 18.2ms | `some` | `[native code]` |
| 7.4% | 287.0ms | 0.3% | 14.6ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 7.0% | 273.3ms | 6.5% | 254.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6939` |
| 7.0% | 273.2ms | 0.6% | 24.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1964` |
| 7.0% | 273.2ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:62` |
| 6.9% | 266.5ms | 6.9% | 266.5ms | `Set` | `[native code]` |
| 6.4% | 248.3ms | 6.4% | 248.3ms | `defineProperties` | `[native code]` |
| 6.2% | 239.0ms | 0.6% | 26.1ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3122` |
| 4.8% | 188.8ms | 0.0% | 3.0ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 4.4% | 173.4ms | 0.8% | 31.0ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1935` |
| 4.2% | 163.5ms | 3.2% | 126.4ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2893` |
| 3.8% | 150.2ms | 3.8% | 150.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3124` |
| 3.3% | 128.6ms | 0.1% | 4.4ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3103` |
| 3.2% | 126.1ms | 1.5% | 60.8ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1762` |
| 2.9% | 113.3ms | 2.1% | 82.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1696` |
| 2.7% | 107.7ms | 2.7% | 106.4ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3130` |
| 2.5% | 98.6ms | 0.0% | 3.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 2.4% | 93.9ms | 0.7% | 29.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 2.2% | 87.7ms | 2.2% | 87.7ms | `get` | `[native code]` |
| 2.2% | 87.6ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` |
| 2.2% | 87.6ms | 0.0% | 0us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1584` |
| 2.1% | 84.2ms | 1.6% | 64.1ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2950` |
| 2.1% | 82.8ms | 0.1% | 5.0ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1695` |
| 2.0% | 80.1ms | 1.7% | 69.1ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2615` |
| 2.0% | 77.5ms | 0.5% | 21.2ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2861` |
| 1.8% | 72.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` |
| 1.8% | 71.4ms | 0.1% | 4.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 1.8% | 71.1ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:59` |
| 1.8% | 69.7ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2505` |
| 1.7% | 67.1ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` |
| 1.7% | 67.1ms | 1.7% | 67.1ms | `parse` | `[native code]` |
| 1.7% | 65.5ms | 1.7% | 65.5ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1006` |
| 1.6% | 64.1ms | 1.6% | 64.1ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3036` |
| 1.6% | 63.2ms | 0.1% | 4.8ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4037` |
| 1.6% | 62.9ms | 1.6% | 62.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1222` |
| 1.6% | 62.8ms | 0.6% | 24.1ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2139` |
| 1.4% | 55.3ms | 0.0% | 0us | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` |
| 1.3% | 53.5ms | 0.4% | 16.3ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2944` |
| 1.3% | 51.1ms | 0.0% | 1.7ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 1.3% | 50.6ms | 0.6% | 25.9ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1697` |
| 1.2% | 49.4ms | 0.0% | 0us | `forEach` | `[native code]` |
| 1.2% | 48.9ms | 1.2% | 48.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2048` |
| 1.2% | 48.8ms | 1.2% | 48.8ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 1.2% | 47.7ms | 1.2% | 47.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` |
| 1.1% | 45.7ms | 0.0% | 1.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1189` |
| 1.1% | 43.7ms | 0.9% | 38.2ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 1.0% | 39.0ms | 0.3% | 15.1ms | `anonymous` | `[native code]` |
| 0.9% | 37.8ms | 0.1% | 7.5ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2588` |
| 0.9% | 37.5ms | 0.0% | 0us | `bound require` | `[native code]` |
| 0.9% | 36.1ms | 0.9% | 36.1ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3019` |
| 0.9% | 35.3ms | 0.9% | 35.3ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.9% | 35.1ms | 0.9% | 35.1ms | `set` | `[native code]` |
| 0.8% | 34.4ms | 0.4% | 17.7ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` |
| 0.8% | 34.3ms | 0.0% | 0us | `require` | `[native code]` |
| 0.8% | 33.9ms | 0.8% | 33.9ms | `push` | `[native code]` |
| 0.8% | 32.5ms | 0.8% | 32.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6695` |
| 0.8% | 31.8ms | 0.6% | 24.9ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2606` |
| 0.8% | 31.3ms | 0.1% | 4.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` |
| 0.8% | 31.2ms | 0.8% | 31.2ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3013` |
| 0.7% | 30.4ms | 0.7% | 30.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3994` |
| 0.7% | 30.1ms | 0.5% | 19.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2864` |
| 0.7% | 28.4ms | 0.7% | 28.4ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3090` |
| 0.7% | 28.2ms | 0.7% | 28.2ms | `get _tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1072` |
| 0.7% | 28.1ms | 0.2% | 9.1ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2564` |
| 0.6% | 26.9ms | 0.3% | 12.0ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2005` |
| 0.6% | 26.3ms | 0.3% | 12.6ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.6% | 24.7ms | 0.6% | 24.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2034` |
| 0.6% | 24.5ms | 0.5% | 23.0ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.6% | 24.1ms | 0.4% | 19.2ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3028` |
| 0.6% | 23.3ms | 0.6% | 23.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1175` |
| 0.5% | 22.9ms | 0.5% | 22.9ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1694` |
| 0.5% | 22.4ms | 0.5% | 22.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3999` |
| 0.5% | 22.0ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` |
| 0.5% | 20.9ms | 0.5% | 20.9ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2416` |
| 0.5% | 20.6ms | 0.5% | 20.6ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2987` |
| 0.5% | 20.4ms | 0.5% | 20.4ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2870` |
| 0.5% | 20.0ms | 0.2% | 10.6ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` |
| 0.5% | 19.4ms | 0.3% | 12.4ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:682` |
| 0.5% | 19.3ms | 0.0% | 3.2ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4065` |
| 0.5% | 19.3ms | 0.1% | 5.9ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1699` |
| 0.4% | 18.9ms | 0.4% | 18.9ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2549` |
| 0.4% | 18.8ms | 0.0% | 3.1ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2892` |
| 0.4% | 18.4ms | 0.4% | 18.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2529` |
| 0.4% | 18.3ms | 0.4% | 18.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.4% | 17.8ms | 0.4% | 16.4ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` |
| 0.4% | 17.6ms | 0.1% | 6.8ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` |
| 0.4% | 17.3ms | 0.0% | 0us | `ensureFenVars` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1825` |
| 0.4% | 17.3ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1828` |
| 0.4% | 17.2ms | 0.4% | 17.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3123` |
| 0.4% | 17.0ms | 0.4% | 17.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6940` |
| 0.4% | 16.5ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6937` |
| 0.4% | 16.3ms | 0.0% | 3.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1802` |
| 0.4% | 16.0ms | 0.1% | 6.6ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1987` |
| 0.4% | 15.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` |
| 0.4% | 15.7ms | 0.4% | 15.7ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` |
| 0.4% | 15.5ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` |
| 0.3% | 15.1ms | 0.1% | 7.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.3% | 14.9ms | 0.1% | 7.4ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:506` |
| 0.3% | 14.9ms | 0.3% | 14.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6684` |
| 0.3% | 14.4ms | 0.3% | 14.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1727` |
| 0.3% | 14.2ms | 0.3% | 14.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7107` |
| 0.3% | 14.1ms | 0.3% | 14.1ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2247` |
| 0.3% | 14.1ms | 0.2% | 7.7ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` |
| 0.3% | 13.9ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2857` |
| 0.3% | 13.7ms | 0.0% | 1.7ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2009` |
| 0.3% | 13.7ms | 0.2% | 10.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1285` |
| 0.3% | 13.5ms | 0.3% | 11.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1228` |
| 0.3% | 13.3ms | 0.3% | 13.3ms | `has` | `[native code]` |
| 0.3% | 12.5ms | 0.3% | 12.5ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2907` |
| 0.3% | 11.8ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` |
| 0.3% | 11.7ms | 0.3% | 11.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1779` |
| 0.3% | 11.7ms | 0.3% | 11.7ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4865` |
| 0.3% | 11.7ms | 0.1% | 5.5ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2509` |
| 0.2% | 11.1ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:46` |
| 0.2% | 11.0ms | 0.2% | 11.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6938` |
| 0.2% | 10.7ms | 0.1% | 4.8ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2907` |
| 0.2% | 10.6ms | 0.0% | 0us | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1838` |
| 0.2% | 10.6ms | 0.2% | 10.6ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2816` |
| 0.2% | 10.1ms | 0.2% | 10.1ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:619` |
| 0.2% | 10.1ms | 0.0% | 1.5ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1710` |
| 0.2% | 10.0ms | 0.2% | 10.0ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 10.0ms | 0.1% | 6.7ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` |
| 0.2% | 9.3ms | 0.2% | 9.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3986` |
| 0.2% | 9.2ms | 0.2% | 9.2ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3018` |
| 0.2% | 9.1ms | 0.2% | 9.1ms | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 9.1ms | 0.2% | 9.1ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2967` |
| 0.2% | 8.8ms | 0.2% | 8.8ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1673` |
| 0.2% | 8.5ms | 0.0% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2141` |
| 0.2% | 8.1ms | 0.2% | 8.1ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2251` |
| 0.2% | 8.1ms | 0.2% | 8.1ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3097` |
| 0.2% | 8.1ms | 0.2% | 8.1ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2946` |
| 0.2% | 8.1ms | 0.2% | 8.1ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 8.0ms | 0.2% | 8.0ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1007` |
| 0.2% | 7.7ms | 0.2% | 7.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1295` |
| 0.1% | 7.6ms | 0.0% | 1.7ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:482` |
| 0.1% | 7.6ms | 0.1% | 7.6ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6434` |
| 0.1% | 7.5ms | 0.1% | 7.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3991` |
| 0.1% | 7.4ms | 0.0% | 1.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1746` |
| 0.1% | 7.3ms | 0.1% | 7.3ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1013` |
| 0.1% | 7.3ms | 0.1% | 4.0ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.1% | 7.3ms | 0.0% | 1.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3128` |
| 0.1% | 7.3ms | 0.1% | 7.3ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6432` |
| 0.1% | 7.2ms | 0.1% | 7.2ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 7.2ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:575` |
| 0.1% | 6.7ms | 0.1% | 6.7ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1011` |
| 0.1% | 6.5ms | 0.0% | 3.3ms | `exec` | `[native code]` |
| 0.1% | 6.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:458` |
| 0.1% | 6.4ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` |
| 0.1% | 6.2ms | 0.0% | 1.8ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1741` |
| 0.1% | 6.2ms | 0.0% | 2.7ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:653` |
| 0.1% | 6.0ms | 0.1% | 6.0ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` |
| 0.1% | 5.9ms | 0.1% | 5.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2255` |
| 0.1% | 5.8ms | 0.1% | 5.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4011` |
| 0.1% | 5.8ms | 0.1% | 5.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7106` |
| 0.1% | 5.7ms | 0.1% | 5.7ms | `/^\s*globals?\b/` | `[native code]` |
| 0.1% | 5.7ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1986` |
| 0.1% | 5.6ms | 0.1% | 5.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4003` |
| 0.1% | 5.6ms | 0.1% | 5.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3995` |
| 0.1% | 4.8ms | 0.0% | 3.3ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3011` |
| 0.1% | 4.8ms | 0.1% | 4.8ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1679` |
| 0.1% | 4.8ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` |
| 0.1% | 4.8ms | 0.0% | 0us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` |
| 0.1% | 4.8ms | 0.1% | 4.8ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1775` |
| 0.1% | 4.8ms | 0.1% | 4.8ms | `/^\s*exported\b/` | `[native code]` |
| 0.1% | 4.7ms | 0.0% | 0us | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2937` |
| 0.1% | 4.7ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:576` |
| 0.1% | 4.7ms | 0.1% | 4.7ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2508` |
| 0.1% | 4.6ms | 0.1% | 4.6ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 4.6ms | 0.1% | 4.6ms | `get _tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 4.6ms | 0.1% | 4.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4005` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4056` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2713` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2845` |
| 0.1% | 4.3ms | 0.0% | 3.0ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2909` |
| 0.1% | 4.3ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` |
| 0.1% | 4.3ms | 0.0% | 2.8ms | `test` | `[native code]` |
| 0.1% | 4.3ms | 0.0% | 1.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1237` |
| 0.1% | 4.2ms | 0.1% | 4.2ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 4.2ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.1% | 4.1ms | 0.1% | 4.1ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.1% | 3.9ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` |
| 0.0% | 3.5ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:661` |
| 0.0% | 3.4ms | 0.0% | 1.6ms | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1873` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1698` |
| 0.0% | 3.3ms | 0.0% | 0us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1337` |
| 0.0% | 3.3ms | 0.0% | 1.6ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:519` |
| 0.0% | 3.2ms | 0.0% | 1.5ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2694` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 3.2ms | 0.0% | 0us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3142` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3143` |
| 0.0% | 3.2ms | 0.0% | 0us | `map` | `[native code]` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4002` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `isReadRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:431` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2822` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` |
| 0.0% | 3.1ms | 0.0% | 1.5ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:662` |
| 0.0% | 3.1ms | 0.0% | 1.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1255` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` |
| 0.0% | 3.1ms | 0.0% | 0us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1274` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2684` |
| 0.0% | 3.0ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:557` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3126` |
| 0.0% | 3.0ms | 0.0% | 1.2ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:701` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1707` |
| 0.0% | 3.0ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7449` |
| 0.0% | 2.9ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1330` |
| 0.0% | 2.9ms | 0.0% | 1.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1752` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2249` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2042` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3394` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2423` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1983` |
| 0.0% | 2.7ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1711` |
| 0.0% | 2.7ms | 0.0% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1803` |
| 0.0% | 2.7ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1680` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:582` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:467` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4244` |
| 0.0% | 2.5ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:441` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` |
| 0.0% | 2.4ms | 0.0% | 1.2ms | `readFileSync` | `[native code]` |
| 0.0% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 1.8ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:45` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:626` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:226` |
| 0.0% | 1.7ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:54` |
| 0.0% | 1.7ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:53` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:15` |
| 0.0% | 1.7ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1703` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3997` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:543` |
| 0.0% | 1.7ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` |
| 0.0% | 1.7ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3996` |
| 0.0% | 1.7ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:776` |
| 0.0% | 1.7ms | 0.0% | 0us | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2273` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `extraClassData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:670` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1862` |
| 0.0% | 1.7ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1712` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2140` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:887` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1829` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:514` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3959` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:720` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3104` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1744` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1709` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:508` |
| 0.0% | 1.6ms | 0.0% | 0us | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:802` |
| 0.0% | 1.6ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1708` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:818` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:561` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2257` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1898` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3089` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6425` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7168` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:773` |
| 0.0% | 1.5ms | 0.0% | 0us | `getUpperFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:132` |
| 0.0% | 1.5ms | 0.0% | 0us | `isInsideOfStorableFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:630` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:797` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1384` |
| 0.0% | 1.5ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1674` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1019` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:429` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3816` |
| 0.0% | 1.5ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3861` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1684` |
| 0.0% | 1.4ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1708` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:506` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `findIndex` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1841` |
| 0.0% | 1.4ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.0% | 1.4ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2046` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isRead` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2752` |
| 0.0% | 1.4ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2991` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `RuleContext` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7452` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2506` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4001` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2945` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3947` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2049` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1692` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2804` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1819` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:868` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1756` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4008` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1685` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:484` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:409` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `Uint8Array` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1200` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:561` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3106` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:35` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1700` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2913` |

## Function Details

### `Set`
`[native code]` | Self: 6.9% (266.5ms) | Total: 6.9% (266.5ms) | Samples: 174

**Called by:**
- `_buildScope` (93)
- `getDeclaredVariables` (81)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6939` | Self: 6.5% (254.2ms) | Total: 7.0% (273.3ms) | Samples: 166

**Called by:**
- `runPlugins` (179)

**Calls:**
- `get allSkipped` (8)
- `get allSkipped` (5)

### `defineProperties`
`[native code]` | Self: 6.4% (248.3ms) | Total: 6.4% (248.3ms) | Samples: 162

**Called by:**
- `_buildScope` (162)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3124` | Self: 3.8% (150.2ms) | Total: 3.8% (150.2ms) | Samples: 98

**Called by:**
- `isAfterLastUsedArg` (98)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2893` | Self: 3.2% (126.4ms) | Total: 4.2% (163.5ms) | Samples: 81

**Called by:**
- `_buildVariable` (105)

**Calls:**
- `get type` (11)
- `get type` (5)
- `get type` (3)
- `get type` (3)
- `get type` (1)
- `get type` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3130` | Self: 2.7% (106.4ms) | Total: 2.7% (107.7ms) | Samples: 71

**Called by:**
- `isAfterLastUsedArg` (71)
- `isAfterLastUsedArg` (1)

**Calls:**
- `set` (1)

### `get`
`[native code]` | Self: 2.2% (87.7ms) | Total: 2.2% (87.7ms) | Samples: 59

**Called by:**
- `_ensureDeclSymIndex` (52)
- `_ensureDeclSymIndex` (6)
- `getDeclaredVariables` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1696` | Self: 2.1% (82.2ms) | Total: 2.9% (113.3ms) | Samples: 53

**Called by:**
- `_buildScopeVarsAndSet` (73)

**Calls:**
- `set` (20)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2615` | Self: 1.7% (69.1ms) | Total: 2.0% (80.1ms) | Samples: 45

**Called by:**
- `_buildScopeVarsAndSet` (37)
- `getDeclaredVariables` (15)

**Calls:**
- `_buildThinScope` (7)

### `parse`
`[native code]` | Self: 1.7% (67.1ms) | Total: 1.7% (67.1ms) | Samples: 44

**Called by:**
- `parseSource` (44)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1006` | Self: 1.7% (65.5ms) | Total: 1.7% (65.5ms) | Samples: 43

**Called by:**
- `(anonymous)` (14)
- `_buildReference` (11)
- `_computeIsStrict` (4)
- `_buildScope` (3)
- `isForInOfRef` (3)
- `isForInOfRef` (2)
- `collectUnusedVariables` (2)
- `(anonymous)` (1)
- `isReadForItself` (1)
- `isReadForItself` (1)
- `collectUnusedVariables` (1)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2950` | Self: 1.6% (64.1ms) | Total: 2.1% (84.2ms) | Samples: 41

**Called by:**
- `_buildThinScope` (55)

**Calls:**
- `get parent` (8)
- `get parent` (3)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3036` | Self: 1.6% (64.1ms) | Total: 1.6% (64.1ms) | Samples: 40

**Called by:**
- `_buildThinVariable` (32)
- `_buildThinScope` (8)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1222` | Self: 1.6% (62.9ms) | Total: 1.6% (62.9ms) | Samples: 42

**Called by:**
- `_buildReference` (13)
- `_buildThinVariable` (8)
- `_findDefNode` (5)
- `(anonymous)` (3)
- `getRhsNode` (3)
- `isForInOfRef` (3)
- `isReadForItself` (2)
- `_buildReference` (2)
- `_computeIsStrict` (1)
- `collectUnusedVariables` (1)
- `isUnusedExpression` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1762` | Self: 1.5% (60.8ms) | Total: 3.2% (126.1ms) | Samples: 40

**Called by:**
- `_buildScopeChildren` (82)

**Calls:**
- `_computeIsStrict` (18)
- `_computeIsStrict` (10)
- `_computeIsStrict` (9)
- `_computeIsStrict` (3)
- `_computeIsStrict` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2559` | Self: 1.3% (50.3ms) | Total: 20.4% (790.2ms) | Samples: 33

**Called by:**
- `_buildScopeVarsAndSet` (422)
- `getDeclaredVariables` (87)

**Calls:**
- `_buildReference` (264)
- `_buildReference` (105)
- `_buildReference` (51)
- `_buildReference` (20)
- `_buildReference` (13)
- `_buildReference` (12)
- `_buildReference` (9)
- `_buildReference` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2048` | Self: 1.2% (48.9ms) | Total: 1.2% (48.9ms) | Samples: 33

**Called by:**
- `ensureVarsSet` (32)
- `ensureVarsSet` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 1.2% (48.8ms) | Total: 1.2% (48.8ms) | Samples: 32

**Called by:**
- `(anonymous)` (5)
- `_buildScope` (4)
- `isForInOfRef` (4)
- `getRhsNode` (4)
- `isForInOfRef` (4)
- `collectUnusedVariables` (3)
- `isForInOfRef` (3)
- `(anonymous)` (1)
- `collectUnusedVariables` (1)
- `isReadForItself` (1)
- `_buildReference` (1)
- `isReadForItself` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` | Self: 1.2% (47.7ms) | Total: 1.2% (47.7ms) | Samples: 31

**Called by:**
- `_precomputeScopes` (31)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` | Self: 0.9% (38.2ms) | Total: 1.1% (43.7ms) | Samples: 25

**Called by:**
- `(anonymous)` (29)

**Calls:**
- `get parent` (3)
- `get parent` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3019` | Self: 0.9% (36.1ms) | Total: 0.9% (36.1ms) | Samples: 23

**Called by:**
- `_buildThinVariable` (8)
- `_buildVariable` (7)
- `_buildReference` (7)
- `_buildThinScope` (1)

### `/\/\*([\s\S]*?)\*\//g`
`[native code]` | Self: 0.9% (35.3ms) | Total: 0.9% (35.3ms) | Samples: 23

**Called by:**
- `_buildScopeVarsAndSet` (21)
- `exec` (2)

### `set`
`[native code]` | Self: 0.9% (35.1ms) | Total: 0.9% (35.1ms) | Samples: 23

**Called by:**
- `_ensureDeclSymIndex` (20)
- `_ensureDeclSymIndex` (2)
- `getDeclaredVariables` (1)

### `push`
`[native code]` | Self: 0.8% (33.9ms) | Total: 0.8% (33.9ms) | Samples: 22

**Called by:**
- `_ensureDeclSymIndex` (16)
- `getDeclaredVariables` (4)
- `_ensureDeclSymIndex` (1)
- `_buildScopeVarsAndSet` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6695` | Self: 0.8% (32.5ms) | Total: 0.8% (32.5ms) | Samples: 21

**Called by:**
- `runPlugins` (21)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3013` | Self: 0.8% (31.2ms) | Total: 0.8% (31.2ms) | Samples: 20

**Called by:**
- `_buildReference` (13)
- `_buildThinVariable` (5)
- `_buildThinScope` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1935` | Self: 0.8% (31.0ms) | Total: 4.4% (173.4ms) | Samples: 20

**Called by:**
- `_buildScopeChildren` (113)

**Calls:**
- `Set` (93)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3994` | Self: 0.7% (30.4ms) | Total: 0.7% (30.4ms) | Samples: 20

**Called by:**
- `nodeView` (9)
- `nodeViewChain` (7)
- `_buildScope` (1)
- `_buildReference` (1)
- `_buildThinVariable` (1)
- `get parent` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` | Self: 0.7% (29.9ms) | Total: 2.4% (93.9ms) | Samples: 20

**Called by:**
- `some` (62)

**Calls:**
- `get parent` (15)
- `get type` (14)
- `get type` (5)
- `get parent` (3)
- `get parent` (3)
- `get parent` (1)
- `get parent` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3002` | Self: 0.7% (28.8ms) | Total: 100.0% (5.14s) | Samples: 19

**Called by:**
- `_buildThinScope` (2296)
- `_buildThinVariable` (845)
- `_buildReference` (203)

**Calls:**
- `_buildThinScope` (2296)
- `_buildThinScope` (1017)
- `_buildThinScope` (8)
- `_buildThinScope` (2)
- `_buildThinScope` (1)
- `_buildThinScope` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3090` | Self: 0.7% (28.4ms) | Total: 0.7% (28.4ms) | Samples: 18

**Called by:**
- `isAfterLastUsedArg` (18)

### `get _tag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1072` | Self: 0.7% (28.2ms) | Total: 0.7% (28.2ms) | Samples: 19

**Called by:**
- `_findDefNode` (5)
- `_findDefNode` (4)
- `init` (4)
- `get parent` (2)
- `get body` (1)
- `get parent` (1)
- `get parent` (1)
- `_buildScope` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` | Self: 0.7% (27.7ms) | Total: 54.0% (2.08s) | Samples: 17

**Called by:**
- `collectUnusedVariables` (897)
- `Program:exit` (458)

**Calls:**
- `get` (875)
- `get` (451)
- `get` (11)
- `get` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3122` | Self: 0.6% (26.1ms) | Total: 6.2% (239.0ms) | Samples: 17

**Called by:**
- `isAfterLastUsedArg` (155)

**Calls:**
- `_buildVariable` (87)
- `_buildVariable` (15)
- `_buildVariable` (8)
- `_buildVariable` (4)
- `_buildVariable` (4)
- `_buildVariable` (4)
- `_buildVariable` (3)
- `_buildVariable` (3)
- `_buildVariable` (3)
- `_buildVariable` (2)
- `_buildVariable` (2)
- `_buildVariable` (2)
- `_buildVariable` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2868` | Self: 0.6% (26.0ms) | Total: 10.6% (411.0ms) | Samples: 17

**Called by:**
- `_buildVariable` (264)

**Calls:**
- `_buildThinScope` (203)
- `_buildThinScope` (13)
- `_buildThinScope` (12)
- `_buildThinScope` (10)
- `_buildThinScope` (7)
- `_buildThinScope` (1)
- `_buildThinScope` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1697` | Self: 0.6% (25.9ms) | Total: 1.3% (50.6ms) | Samples: 17

**Called by:**
- `_buildScopeVarsAndSet` (33)

**Calls:**
- `push` (16)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1964` | Self: 0.6% (24.9ms) | Total: 7.0% (273.2ms) | Samples: 17

**Called by:**
- `_buildScopeChildren` (178)
- `_buildScope` (1)

**Calls:**
- `defineProperties` (162)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2606` | Self: 0.6% (24.9ms) | Total: 0.8% (31.8ms) | Samples: 16

**Called by:**
- `_buildScopeVarsAndSet` (18)
- `getDeclaredVariables` (3)

**Calls:**
- `get parent` (3)
- `get parent` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2034` | Self: 0.6% (24.7ms) | Total: 0.6% (24.7ms) | Samples: 15

**Called by:**
- `ensureVarsSet` (15)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2139` | Self: 0.6% (24.1ms) | Total: 1.6% (62.8ms) | Samples: 16

**Called by:**
- `ensureVarsSet` (41)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (21)
- `exec` (4)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1175` | Self: 0.6% (23.3ms) | Total: 0.6% (23.3ms) | Samples: 15

**Called by:**
- `_buildReference` (5)
- `_buildVariable` (3)
- `_computeIsStrict` (2)
- `_computeIsStrict` (1)
- `_findDefNode` (1)
- `getRhsNode` (1)
- `isForInOfRef` (1)
- `_buildReference` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` | Self: 0.5% (23.0ms) | Total: 0.6% (24.5ms) | Samples: 15

**Called by:**
- `collectUnusedVariables` (16)

**Calls:**
- `getDeclaredVariables` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1694` | Self: 0.5% (22.9ms) | Total: 0.5% (22.9ms) | Samples: 15

**Called by:**
- `_buildScopeVarsAndSet` (15)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3999` | Self: 0.5% (22.4ms) | Total: 0.5% (22.4ms) | Samples: 14

**Called by:**
- `nodeView` (14)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2032` | Self: 0.5% (21.6ms) | Total: 8.7% (337.7ms) | Samples: 14

**Called by:**
- `ensureVarsSet` (219)
- `ensureVarsSet` (1)

**Calls:**
- `_ensureDeclSymIndex` (73)
- `_ensureDeclSymIndex` (55)
- `_ensureDeclSymIndex` (33)
- `_ensureDeclSymIndex` (15)
- `_ensureDeclSymIndex` (12)
- `_ensureDeclSymIndex` (7)
- `_ensureDeclSymIndex` (2)
- `_ensureDeclSymIndex` (2)
- `_ensureDeclSymIndex` (2)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2861` | Self: 0.5% (21.2ms) | Total: 2.0% (77.5ms) | Samples: 14

**Called by:**
- `_buildVariable` (51)

**Calls:**
- `get parent` (13)
- `get parent` (5)
- `get parent` (5)
- `get parent` (5)
- `get parent` (4)
- `get parent` (2)
- `get parent` (2)
- `get parent` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2416` | Self: 0.5% (20.9ms) | Total: 0.5% (20.9ms) | Samples: 14

**Called by:**
- `ensureChildren` (14)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2987` | Self: 0.5% (20.6ms) | Total: 0.5% (20.6ms) | Samples: 14

**Called by:**
- `_buildReference` (12)
- `_buildThinVariable` (1)
- `_buildThinScope` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2870` | Self: 0.5% (20.4ms) | Total: 0.5% (20.4ms) | Samples: 13

**Called by:**
- `_buildVariable` (13)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2864` | Self: 0.5% (19.5ms) | Total: 0.7% (30.1ms) | Samples: 13

**Called by:**
- `_buildVariable` (20)

**Calls:**
- `_buildThinVariable` (4)
- `_buildThinVariable` (2)
- `_buildThinVariable` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3028` | Self: 0.4% (19.2ms) | Total: 0.6% (24.1ms) | Samples: 12

**Called by:**
- `_buildReference` (10)
- `_buildThinVariable` (5)

**Calls:**
- `_ensureDeclSymIndex` (3)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2549` | Self: 0.4% (18.9ms) | Total: 0.4% (18.9ms) | Samples: 12

**Called by:**
- `_buildScopeVarsAndSet` (8)
- `getDeclaredVariables` (4)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2529` | Self: 0.4% (18.4ms) | Total: 0.4% (18.4ms) | Samples: 12

**Called by:**
- `_buildScopeVarsAndSet` (10)
- `getDeclaredVariables` (2)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.4% (18.3ms) | Total: 0.4% (18.3ms) | Samples: 12

**Called by:**
- `collectUnusedVariables` (4)
- `_buildThinVariable` (3)
- `_buildVariable` (2)
- `(anonymous)` (1)
- `getUpperFunction` (1)
- `_buildReference` (1)

### `some`
`[native code]` | Self: 0.4% (18.2ms) | Total: 7.9% (307.9ms) | Samples: 12

**Called by:**
- `isUsedVariable` (121)
- `collectUnusedVariables` (63)
- `collectUnusedVariables` (17)
- `Program:exit` (1)

**Calls:**
- `(anonymous)` (62)
- `(anonymous)` (47)
- `(anonymous)` (47)
- `(anonymous)` (21)
- `(anonymous)` (10)
- `(anonymous)` (3)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` | Self: 0.4% (17.7ms) | Total: 0.8% (34.4ms) | Samples: 11

**Called by:**
- `_buildThinVariable` (14)
- `_buildVariable` (8)

**Calls:**
- `get parent` (5)
- `get parent` (2)
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3123` | Self: 0.4% (17.2ms) | Total: 0.4% (17.2ms) | Samples: 12

**Called by:**
- `isAfterLastUsedArg` (12)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6940` | Self: 0.4% (17.0ms) | Total: 0.4% (17.0ms) | Samples: 12

**Called by:**
- `runPlugins` (12)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3112` | Self: 0.4% (16.4ms) | Total: 0.4% (17.8ms) | Samples: 11

**Called by:**
- `isAfterLastUsedArg` (12)

**Calls:**
- `get` (1)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2944` | Self: 0.4% (16.3ms) | Total: 1.3% (53.5ms) | Samples: 10

**Called by:**
- `_buildThinScope` (34)

**Calls:**
- `_findDefNode` (14)
- `_findDefNode` (5)
- `_findDefNode` (2)
- `_findDefNode` (1)
- `_findDefNode` (1)
- `_findDefNode` (1)

### `isSelfReference`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` | Self: 0.4% (15.7ms) | Total: 0.4% (15.7ms) | Samples: 10

**Called by:**
- `(anonymous)` (10)

### `anonymous`
`[native code]` | Self: 0.3% (15.1ms) | Total: 1.0% (39.0ms) | Samples: 9

**Called by:**
- `require` (21)
- `bound require` (2)
- `node:fs` (1)

**Calls:**
- `(anonymous)` (4)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:fs` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6684` | Self: 0.3% (14.9ms) | Total: 0.3% (14.9ms) | Samples: 9

**Called by:**
- `runPlugins` (9)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` | Self: 0.3% (14.6ms) | Total: 7.4% (287.0ms) | Samples: 10

**Called by:**
- `collectUnusedVariables` (189)

**Calls:**
- `isUsedVariable` (123)
- `isUsedVariable` (37)
- `some` (17)
- `isUsedVariable` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1727` | Self: 0.3% (14.4ms) | Total: 0.3% (14.4ms) | Samples: 10

**Called by:**
- `_buildScopeChildren` (8)
- `_buildScope` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7107` | Self: 0.3% (14.2ms) | Total: 0.3% (14.2ms) | Samples: 9

**Called by:**
- `runPlugins` (9)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2247` | Self: 0.3% (14.1ms) | Total: 0.3% (14.1ms) | Samples: 10

**Called by:**
- `ensureVarsSet` (10)

### `has`
`[native code]` | Self: 0.3% (13.3ms) | Total: 0.3% (13.3ms) | Samples: 8

**Called by:**
- `_ensureDeclSymIndex` (8)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` | Self: 0.3% (12.6ms) | Total: 0.6% (26.3ms) | Samples: 9

**Called by:**
- `collectUnusedVariables` (19)

**Calls:**
- `get parent` (4)
- `get type` (3)
- `get type` (2)
- `get parent` (1)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2907` | Self: 0.3% (12.5ms) | Total: 0.3% (12.5ms) | Samples: 8

**Called by:**
- `_buildThinScope` (4)
- `_buildReference` (4)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:682` | Self: 0.3% (12.4ms) | Total: 0.5% (19.4ms) | Samples: 8

**Called by:**
- `(anonymous)` (12)

**Calls:**
- `get type` (4)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2005` | Self: 0.3% (12.0ms) | Total: 0.6% (26.9ms) | Samples: 8

**Called by:**
- `_buildScope` (18)

**Calls:**
- `get body` (6)
- `get body` (2)
- `get body` (1)
- `get body` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1228` | Self: 0.3% (11.9ms) | Total: 0.3% (13.5ms) | Samples: 8

**Called by:**
- `_buildReference` (5)
- `_buildReference` (2)
- `_findDefNode` (2)

**Calls:**
- `get value` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1779` | Self: 0.3% (11.7ms) | Total: 0.3% (11.7ms) | Samples: 8

**Called by:**
- `_buildScopeChildren` (8)

### `get allSkipped`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4865` | Self: 0.3% (11.7ms) | Total: 0.3% (11.7ms) | Samples: 8

**Called by:**
- `walkNodes` (8)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6938` | Self: 0.2% (11.0ms) | Total: 0.2% (11.0ms) | Samples: 7

**Called by:**
- `runPlugins` (7)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1285` | Self: 0.2% (10.9ms) | Total: 0.3% (13.7ms) | Samples: 7

**Called by:**
- `_buildReference` (5)
- `(anonymous)` (1)
- `_buildThinVariable` (1)
- `_buildReference` (1)
- `isReadForItself` (1)

**Calls:**
- `get _tag` (2)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` | Self: 0.2% (10.6ms) | Total: 0.5% (20.0ms) | Samples: 7

**Called by:**
- `(anonymous)` (13)

**Calls:**
- `get type` (4)
- `get type` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2816` | Self: 0.2% (10.6ms) | Total: 0.2% (10.6ms) | Samples: 7

**Called by:**
- `getDeclaredVariables` (4)
- `_buildScopeVarsAndSet` (3)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:619` | Self: 0.2% (10.1ms) | Total: 0.2% (10.1ms) | Samples: 7

**Called by:**
- `commentsInRange` (5)
- `commentsInRange` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.2% (10.0ms) | Total: 0.2% (10.0ms) | Samples: 7

**Called by:**
- `getDeclaredVariables` (4)
- `_buildScopeVarsAndSet` (3)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3986` | Self: 0.2% (9.3ms) | Total: 0.2% (9.3ms) | Samples: 6

**Called by:**
- `_buildVariable` (6)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3018` | Self: 0.2% (9.2ms) | Total: 0.2% (9.2ms) | Samples: 6

**Called by:**
- `_buildThinVariable` (5)
- `_buildReference` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2564` | Self: 0.2% (9.1ms) | Total: 0.7% (28.1ms) | Samples: 6

**Called by:**
- `_buildScopeVarsAndSet` (10)
- `getDeclaredVariables` (8)

**Calls:**
- `_nodeViewRaw` (6)
- `_nodeViewRaw` (3)
- `nodeView` (2)
- `nodeView` (1)

### `get directive`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.2% (9.1ms) | Total: 0.2% (9.1ms) | Samples: 6

**Called by:**
- `_computeIsStrict` (6)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2967` | Self: 0.2% (9.1ms) | Total: 0.2% (9.1ms) | Samples: 6

**Called by:**
- `_buildThinScope` (6)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1673` | Self: 0.2% (8.8ms) | Total: 0.2% (8.8ms) | Samples: 6

**Called by:**
- `_computeIsStrict` (6)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2251` | Self: 0.2% (8.1ms) | Total: 0.2% (8.1ms) | Samples: 5

**Called by:**
- `ensureVarsSet` (4)
- `ensureVarsSet` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3097` | Self: 0.2% (8.1ms) | Total: 0.2% (8.1ms) | Samples: 5

**Called by:**
- `isAfterLastUsedArg` (5)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2946` | Self: 0.2% (8.1ms) | Total: 0.2% (8.1ms) | Samples: 5

**Called by:**
- `_buildThinScope` (5)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.2% (8.1ms) | Total: 0.2% (8.1ms) | Samples: 5

**Called by:**
- `ensureChildren` (5)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1007` | Self: 0.2% (8.0ms) | Total: 0.2% (8.0ms) | Samples: 5

**Called by:**
- `_buildReference` (3)
- `isForInOfRef` (1)
- `_buildScope` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` | Self: 0.2% (7.7ms) | Total: 0.3% (14.1ms) | Samples: 5

**Called by:**
- `(anonymous)` (9)

**Calls:**
- `get type` (4)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1295` | Self: 0.2% (7.7ms) | Total: 0.2% (7.7ms) | Samples: 5

**Called by:**
- `(anonymous)` (3)
- `_buildReference` (2)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6434` | Self: 0.1% (7.6ms) | Total: 0.1% (7.6ms) | Samples: 5

**Called by:**
- `walkNodes` (5)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` | Self: 0.1% (7.5ms) | Total: 0.3% (15.1ms) | Samples: 5

**Called by:**
- `collectUnusedVariables` (10)

**Calls:**
- `get parent` (4)
- `get type` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3991` | Self: 0.1% (7.5ms) | Total: 0.1% (7.5ms) | Samples: 5

**Called by:**
- `_buildVariable` (3)
- `nodeView` (1)
- `_buildScope` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2588` | Self: 0.1% (7.5ms) | Total: 0.9% (37.8ms) | Samples: 5

**Called by:**
- `_buildScopeVarsAndSet` (22)
- `getDeclaredVariables` (3)

**Calls:**
- `_findDefNode` (8)
- `_findDefNode` (5)
- `_findDefNode` (3)
- `_findDefNode` (2)
- `_findDefNode` (1)
- `_findDefNode` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:506` | Self: 0.1% (7.4ms) | Total: 0.3% (14.9ms) | Samples: 5

**Called by:**
- `_buildVariable` (5)
- `_buildThinVariable` (5)

**Calls:**
- `get _tag` (5)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1013` | Self: 0.1% (7.3ms) | Total: 0.1% (7.3ms) | Samples: 5

**Called by:**
- `_buildReference` (5)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6432` | Self: 0.1% (7.3ms) | Total: 0.1% (7.3ms) | Samples: 5

**Called by:**
- `walkNodes` (5)

### `get allSkipped`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (7.2ms) | Total: 0.1% (7.2ms) | Samples: 5

**Called by:**
- `walkNodes` (5)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` | Self: 0.1% (6.8ms) | Total: 0.4% (17.6ms) | Samples: 5

**Called by:**
- `(anonymous)` (12)

**Calls:**
- `get type` (3)
- `get type` (3)
- `get type` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` | Self: 0.1% (6.7ms) | Total: 0.2% (10.0ms) | Samples: 5

**Called by:**
- `(anonymous)` (7)

**Calls:**
- `get type` (1)
- `get type` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1011` | Self: 0.1% (6.7ms) | Total: 0.1% (6.7ms) | Samples: 4

**Called by:**
- `_buildReference` (3)
- `isForInOfRef` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1987` | Self: 0.1% (6.6ms) | Total: 0.4% (16.0ms) | Samples: 4

**Called by:**
- `_buildScope` (10)

**Calls:**
- `get type` (4)
- `get parent` (1)
- `get parent` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2041` | Self: 0.1% (6.2ms) | Total: 21.6% (835.0ms) | Samples: 4

**Called by:**
- `ensureVarsSet` (535)
- `ensureVarsSet` (4)

**Calls:**
- `_buildVariable` (422)
- `_buildVariable` (37)
- `_buildVariable` (22)
- `_buildVariable` (18)
- `_buildVariable` (10)
- `_buildVariable` (10)
- `_buildVariable` (8)
- `_buildVariable` (3)
- `_buildVariable` (3)
- `_buildVariable` (1)
- `_buildVariable` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` | Self: 0.1% (6.1ms) | Total: 100.0% (10.65s) | Samples: 4

**Called by:**
- `collectUnusedVariables` (5287)
- `Program:exit` (1680)

**Calls:**
- `collectUnusedVariables` (5287)
- `collectUnusedVariables` (897)
- `collectUnusedVariables` (490)
- `collectUnusedVariables` (189)
- `collectUnusedVariables` (64)
- `collectUnusedVariables` (19)
- `collectUnusedVariables` (10)
- `collectUnusedVariables` (3)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2923` | Self: 0.1% (6.1ms) | Total: 88.4% (3.40s) | Samples: 4

**Called by:**
- `_buildThinScope` (2208)

**Calls:**
- `_buildThinScope` (1300)
- `_buildThinScope` (845)
- `_buildThinScope` (32)
- `_buildThinScope` (8)
- `_buildThinScope` (5)
- `_buildThinScope` (5)
- `_buildThinScope` (5)
- `_buildThinScope` (3)
- `_buildThinScope` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3131` | Self: 0.1% (6.0ms) | Total: 0.1% (6.0ms) | Samples: 4

**Called by:**
- `isAfterLastUsedArg` (4)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1699` | Self: 0.1% (5.9ms) | Total: 0.5% (19.3ms) | Samples: 4

**Called by:**
- `_buildScopeVarsAndSet` (12)

**Calls:**
- `has` (8)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2255` | Self: 0.1% (5.9ms) | Total: 0.1% (5.9ms) | Samples: 4

**Called by:**
- `ensureVarsSet` (4)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4011` | Self: 0.1% (5.8ms) | Total: 0.1% (5.8ms) | Samples: 4

**Called by:**
- `nodeViewChain` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7106` | Self: 0.1% (5.8ms) | Total: 0.1% (5.8ms) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `/^\s*globals?\b/`
`[native code]` | Self: 0.1% (5.7ms) | Total: 0.1% (5.7ms) | Samples: 4

**Called by:**
- `_buildScopeVarsAndSet` (3)
- `test` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4003` | Self: 0.1% (5.6ms) | Total: 0.1% (5.6ms) | Samples: 4

**Called by:**
- `nodeView` (3)
- `get parent` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3995` | Self: 0.1% (5.6ms) | Total: 0.1% (5.6ms) | Samples: 4

**Called by:**
- `nodeView` (4)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2509` | Self: 0.1% (5.5ms) | Total: 0.3% (11.7ms) | Samples: 4

**Called by:**
- `getScope` (8)

**Calls:**
- `/^\s*exported\b/` (3)
- `test` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1695` | Self: 0.1% (5.0ms) | Total: 2.1% (82.8ms) | Samples: 3

**Called by:**
- `_buildScopeVarsAndSet` (55)

**Calls:**
- `get` (52)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1679` | Self: 0.1% (4.8ms) | Total: 0.1% (4.8ms) | Samples: 3

**Called by:**
- `_buildThinScope` (3)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4037` | Self: 0.1% (4.8ms) | Total: 1.6% (63.2ms) | Samples: 3

**Called by:**
- `get parent` (27)
- `_buildReference` (7)
- `_buildVariable` (2)
- `get body` (1)
- `_buildThinScope` (1)
- `_buildThinVariable` (1)
- `_nodesFromRange` (1)
- `_buildVariable` (1)

**Calls:**
- `_nodeViewRaw` (14)
- `_nodeViewRaw` (9)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2907` | Self: 0.1% (4.8ms) | Total: 0.2% (10.7ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)

**Calls:**
- `get _tag` (4)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1775` | Self: 0.1% (4.8ms) | Total: 0.1% (4.8ms) | Samples: 3

**Called by:**
- `_buildScopeChildren` (3)

### `/^\s*exported\b/`
`[native code]` | Self: 0.1% (4.8ms) | Total: 0.1% (4.8ms) | Samples: 3

**Called by:**
- `_precomputeScopes` (3)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2508` | Self: 0.1% (4.7ms) | Total: 0.1% (4.7ms) | Samples: 3

**Called by:**
- `getScope` (3)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (4.6ms) | Total: 0.1% (4.6ms) | Samples: 3

**Called by:**
- `_buildScope` (2)
- `_buildVariable` (1)

### `get _tag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (4.6ms) | Total: 0.1% (4.6ms) | Samples: 3

**Called by:**
- `get parent` (2)
- `get parent` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4005` | Self: 0.1% (4.6ms) | Total: 0.1% (4.6ms) | Samples: 3

**Called by:**
- `nodeView` (2)
- `_buildReference` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4056` | Self: 0.1% (4.5ms) | Total: 0.1% (4.5ms) | Samples: 3

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2713` | Self: 0.1% (4.5ms) | Total: 0.1% (4.5ms) | Samples: 3

**Called by:**
- `getDeclaredVariables` (3)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3103` | Self: 0.1% (4.4ms) | Total: 3.3% (128.6ms) | Samples: 3

**Called by:**
- `isAfterLastUsedArg` (84)

**Calls:**
- `Set` (81)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2845` | Self: 0.1% (4.4ms) | Total: 0.1% (4.4ms) | Samples: 2

**Called by:**
- `_buildVariable` (2)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (4.2ms) | Total: 0.1% (4.2ms) | Samples: 3

**Called by:**
- `_buildReference` (2)
- `_buildThinScope` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` | Self: 0.1% (4.2ms) | Total: 1.8% (71.4ms) | Samples: 3

**Called by:**
- `some` (47)

**Calls:**
- `getRhsNode` (29)
- `getRhsNode` (9)
- `getRhsNode` (2)
- `getRhsNode` (1)
- `getRhsNode` (1)
- `getRhsNode` (1)
- `getRhsNode` (1)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` | Self: 0.1% (4.1ms) | Total: 0.1% (4.1ms) | Samples: 3

**Called by:**
- `isUsedVariable` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` | Self: 0.1% (4.1ms) | Total: 0.8% (31.3ms) | Samples: 3

**Called by:**
- `some` (21)

**Calls:**
- `isReadForItself` (7)
- `isReadForItself` (4)
- `isReadForItself` (3)
- `isReadForItself` (2)
- `isReadForItself` (2)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` | Self: 0.1% (4.0ms) | Total: 0.1% (7.3ms) | Samples: 3

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `get parent` (1)
- `get parent` (1)

### `isInside`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` | Self: 0.0% (3.5ms) | Total: 0.0% (3.5ms) | Samples: 2

**Called by:**
- `isReadForItself` (2)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1698` | Self: 0.0% (3.4ms) | Total: 0.0% (3.4ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2419` | Self: 0.0% (3.3ms) | Total: 16.7% (647.6ms) | Samples: 2

**Called by:**
- `ensureChildren` (424)

**Calls:**
- `_buildScope` (178)
- `_buildScope` (113)
- `_buildScope` (82)
- `_buildScope` (11)
- `_buildScope` (8)
- `_buildScope` (8)
- `_buildScope` (5)
- `_buildScope` (4)
- `_buildScope` (3)
- `_buildScope` (2)
- `_buildScope` (2)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3011` | Self: 0.0% (3.3ms) | Total: 0.1% (4.8ms) | Samples: 2

**Called by:**
- `_buildThinVariable` (3)

**Calls:**
- `nodeView` (1)

### `exec`
`[native code]` | Self: 0.0% (3.3ms) | Total: 0.1% (6.5ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (4)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (2)

### `ensureChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `get` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4002` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `nodeView` (1)
- `_buildThinVariable` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4065` | Self: 0.0% (3.2ms) | Total: 0.5% (19.3ms) | Samples: 2

**Called by:**
- `(anonymous)` (9)
- `(anonymous)` (3)
- `(anonymous)` (1)

**Calls:**
- `_nodeViewRaw` (7)
- `_nodeViewRaw` (4)

### `isReadRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:431` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2892` | Self: 0.0% (3.1ms) | Total: 0.4% (18.8ms) | Samples: 2

**Called by:**
- `_buildVariable` (12)

**Calls:**
- `get parent` (2)
- `get parent` (2)
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2822` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `getDeclaredVariables` (2)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (2)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `_precomputeScopes` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1802` | Self: 0.0% (3.1ms) | Total: 0.4% (16.3ms) | Samples: 2

**Called by:**
- `_buildScopeChildren` (11)

**Calls:**
- `get type` (4)
- `get type` (3)
- `get id` (1)
- `get type` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2684` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (1)
- `getDeclaredVariables` (1)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2909` | Self: 0.0% (3.0ms) | Total: 0.1% (4.3ms) | Samples: 2

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `nodeLhs` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3126` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `isAfterLastUsedArg` (2)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1707` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` | Self: 0.0% (3.0ms) | Total: 4.8% (188.8ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (123)

**Calls:**
- `some` (121)

### `ensureChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1928` | Self: 0.0% (3.0ms) | Total: 17.7% (682.5ms) | Samples: 2

**Called by:**
- `get` (447)

**Calls:**
- `_buildScopeChildren` (424)
- `_buildScopeChildren` (14)
- `_buildScopeChildren` (5)
- `_buildScopeChildren` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` | Self: 0.0% (3.0ms) | Total: 2.5% (98.6ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (64)
- `Program:exit` (1)

**Calls:**
- `some` (63)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1330` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `(anonymous)` (1)
- `_buildScope` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2249` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `ensureVarsSet` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2042` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `ensureVarsSet` (2)

### `get directive`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3394` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `_computeIsStrict` (2)

### `ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1900` | Self: 0.0% (2.8ms) | Total: 34.9% (1.34s) | Samples: 2

**Called by:**
- `get` (875)

**Calls:**
- `_buildScopeVarsAndSet` (535)
- `_buildScopeVarsAndSet` (219)
- `_buildScopeVarsAndSet` (41)
- `_buildScopeVarsAndSet` (32)
- `_buildScopeVarsAndSet` (15)
- `_buildScopeVarsAndSet` (10)
- `_buildScopeVarsAndSet` (6)
- `_buildScopeVarsAndSet` (4)
- `_buildScopeVarsAndSet` (4)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)

### `test`
`[native code]` | Self: 0.0% (2.8ms) | Total: 0.1% (4.3ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)
- `_precomputeScopes` (1)

**Calls:**
- `/^\s*globals?\b/` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` | Self: 0.0% (2.8ms) | Total: 18.7% (722.8ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (473)

**Calls:**
- `getDeclaredVariables` (155)
- `getDeclaredVariables` (98)
- `getDeclaredVariables` (84)
- `getDeclaredVariables` (71)
- `getDeclaredVariables` (18)
- `getDeclaredVariables` (12)
- `getDeclaredVariables` (12)
- `getDeclaredVariables` (5)
- `getDeclaredVariables` (5)
- `getDeclaredVariables` (4)
- `getDeclaredVariables` (2)
- `getDeclaredVariables` (2)
- `getDeclaredVariables` (1)
- `getDeclaredVariables` (1)
- `getDeclaredVariables` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2423` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `ensureChildren` (2)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1983` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `_buildScope` (2)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:653` | Self: 0.0% (2.7ms) | Total: 0.1% (6.2ms) | Samples: 2

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `get type` (1)
- `get type` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:582` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `_precomputeScopes` (2)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1969` | Self: 0.0% (2.6ms) | Total: 17.8% (688.4ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (451)

**Calls:**
- `ensureChildren` (447)
- `ensureChildren` (2)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:467` | Self: 0.0% (2.5ms) | Total: 0.0% (2.5ms) | Samples: 2

**Called by:**
- `_buildVariable` (2)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4244` | Self: 0.0% (2.5ms) | Total: 0.0% (2.5ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` | Self: 0.0% (2.5ms) | Total: 0.0% (2.5ms) | Samples: 2

**Called by:**
- `_precomputeScopes` (2)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:626` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `commentsInRange` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1741` | Self: 0.0% (1.8ms) | Total: 0.1% (6.2ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (4)

**Calls:**
- `_buildScope` (2)
- `_buildScope` (1)

### `_resolveUnicodeEscapes`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:226` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `get name` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3997` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `nodeView` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:543` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2009` | Self: 0.0% (1.7ms) | Total: 0.3% (13.7ms) | Samples: 1

**Called by:**
- `_buildScope` (9)

**Calls:**
- `get directive` (6)
- `get directive` (2)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getRhsNode` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3035` | Self: 0.0% (1.7ms) | Total: 92.8% (3.57s) | Samples: 1

**Called by:**
- `_buildThinVariable` (1300)
- `_buildThinScope` (1017)

**Calls:**
- `_buildThinVariable` (2208)
- `_buildThinVariable` (55)
- `_buildThinVariable` (34)
- `_buildThinVariable` (6)
- `_buildThinVariable` (5)
- `_buildThinVariable` (4)
- `_buildThinVariable` (3)
- `_buildThinVariable` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:482` | Self: 0.0% (1.7ms) | Total: 0.1% (7.6ms) | Samples: 1

**Called by:**
- `_buildVariable` (3)
- `_buildThinVariable` (2)

**Calls:**
- `get _tag` (4)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3996` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `nodeView` (1)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` | Self: 0.0% (1.7ms) | Total: 1.3% (51.1ms) | Samples: 1

**Called by:**
- `isUsedVariable` (34)

**Calls:**
- `forEach` (33)

### `extraClassData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:670` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `get id` (1)

### `ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1862` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `get` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` | Self: 0.0% (1.7ms) | Total: 19.4% (749.0ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (490)

**Calls:**
- `isAfterLastUsedArg` (473)
- `isAfterLastUsedArg` (16)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2140` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `ensureVarsSet` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:887` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1829` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:514` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildThinVariable` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` | Self: 0.0% (1.6ms) | Total: 0.4% (15.5ms) | Samples: 1

**Called by:**
- `forEach` (10)

**Calls:**
- `init` (3)
- `nodeViewChain` (3)
- `get init` (1)
- `init` (1)
- `nodeViewChain` (1)

### `ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1873` | Self: 0.0% (1.6ms) | Total: 0.0% (3.4ms) | Samples: 1

**Called by:**
- `get` (2)

**Calls:**
- `get name` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:720` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `reset` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:519` | Self: 0.0% (1.6ms) | Total: 0.0% (3.3ms) | Samples: 1

**Called by:**
- `_buildVariable` (1)
- `_buildThinVariable` (1)

**Calls:**
- `get parent` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3104` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` | Self: 0.0% (1.6ms) | Total: 0.1% (4.8ms) | Samples: 1

**Called by:**
- `some` (3)

**Calls:**
- `isReadRef` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1744` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildVariable` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1709` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `isUnusedExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:508` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `getRhsNode` (1)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:818` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_symName` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:561` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `get id`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2257` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:662` | Self: 0.0% (1.5ms) | Total: 0.0% (3.1ms) | Samples: 1

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `isInsideOfStorableFunction` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1898` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3089` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6425` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:773` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `get name` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:797` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1752` | Self: 0.0% (1.5ms) | Total: 0.0% (2.9ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (2)

**Calls:**
- `get _tag` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1384` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `get parent` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1746` | Self: 0.0% (1.5ms) | Total: 0.1% (7.4ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (5)

**Calls:**
- `nodeView` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` | Self: 0.0% (1.5ms) | Total: 0.3% (11.8ms) | Samples: 1

**Called by:**
- `forEach` (8)

**Calls:**
- `init` (2)
- `init` (1)
- `get type` (1)
- `nodeViewChain` (1)
- `get type` (1)
- `nodeViewChain` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1710` | Self: 0.0% (1.5ms) | Total: 0.2% (10.1ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (7)

**Calls:**
- `get` (6)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2694` | Self: 0.0% (1.5ms) | Total: 0.0% (3.2ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (2)

**Calls:**
- `nodeView` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1019` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `isFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:429` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3816` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `report` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1803` | Self: 0.0% (1.4ms) | Total: 0.0% (2.7ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (2)

**Calls:**
- `get name` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1684` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `Program:exit` (1)

### `findIndex`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `ensureVarsSet` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1255` | Self: 0.0% (1.4ms) | Total: 0.0% (3.1ms) | Samples: 1

**Called by:**
- `_buildReference` (1)
- `_findDefNode` (1)

**Calls:**
- `get _tag` (1)

### `isRead`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2752` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getRhsNode` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2991` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` | Self: 0.0% (1.4ms) | Total: 0.5% (22.0ms) | Samples: 1

**Called by:**
- `forEach` (15)

**Calls:**
- `nodeViewChain` (9)
- `init` (2)
- `nodeViewChain` (1)
- `init` (1)
- `nodeViewChain` (1)

### `RuleContext`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2506` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getScope` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get body` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `parseSource` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4001` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `nodeView` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2141` | Self: 0.0% (1.3ms) | Total: 0.2% (8.5ms) | Samples: 1

**Called by:**
- `ensureVarsSet` (6)

**Calls:**
- `/^\s*globals?\b/` (3)
- `test` (2)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1189` | Self: 0.0% (1.3ms) | Total: 1.1% (45.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (15)
- `collectUnusedVariables` (4)
- `_buildReference` (4)
- `_findDefNode` (2)
- `_buildThinVariable` (1)
- `collectUnusedVariables` (1)
- `_buildReference` (1)
- `isForInOfRef` (1)
- `_computeIsStrict` (1)

**Calls:**
- `nodeView` (27)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2945` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3947` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2049` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `ensureVarsSet` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1692` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `isFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2804` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1819` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1237` | Self: 0.0% (1.3ms) | Total: 0.1% (4.3ms) | Samples: 1

**Called by:**
- `_buildReference` (2)
- `_buildThinVariable` (1)

**Calls:**
- `get _tag` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1756` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4008` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `nodeView` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1685` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:484` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_buildThinVariable` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:701` | Self: 0.0% (1.2ms) | Total: 0.0% (3.0ms) | Samples: 1

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `get type` (1)

### `Uint8Array`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1200` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_findDefNode` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:561` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `nodeLhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `init` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3128` | Self: 0.0% (1.2ms) | Total: 0.1% (7.3ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (5)

**Calls:**
- `push` (4)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3106` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `readFileSync`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (2.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)
- `readFileSync` (1)

**Calls:**
- `readFileSync` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1700` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `get init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2913` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:661` | Self: 0.0% (0us) | Total: 0.0% (3.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `isInside` (2)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:46` | Self: 0.0% (0us) | Total: 0.2% (11.1ms) | Samples: 0

**Called by:**
- `async (anonymous)` (7)

**Calls:**
- `bound require` (7)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1703` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `nodeView` (1)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` | Self: 0.0% (0us) | Total: 0.1% (6.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `bound require` (4)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 100.0% (3.85s) | Samples: 0

**Calls:**
- `parseModule` (2517)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:557` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `isUnusedExpression` (1)
- `isUnusedExpression` (1)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 0.8% (34.3ms) | Samples: 0

**Called by:**
- `bound require` (21)

**Calls:**
- `anonymous` (21)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:59` | Self: 0.0% (0us) | Total: 1.8% (71.1ms) | Samples: 0

**Called by:**
- `async (anonymous)` (46)

**Calls:**
- `parseSource` (44)
- `parseSource` (2)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3142` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `isAfterLastUsedArg` (2)

**Calls:**
- `map` (2)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7457` | Self: 0.0% (0us) | Total: 97.5% (3.76s) | Samples: 0

**Called by:**
- `async (anonymous)` (2276)
- `async (anonymous)` (180)

**Calls:**
- `walkNodes` (2202)
- `walkNodes` (179)
- `walkNodes` (21)
- `walkNodes` (12)
- `walkNodes` (11)
- `walkNodes` (9)
- `walkNodes` (9)
- `walkNodes` (7)
- `walkNodes` (4)
- `walkNodes` (1)
- `walkNodes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` | Self: 0.0% (0us) | Total: 99.8% (3.85s) | Samples: 0

**Called by:**
- `parseModule` (2514)

**Calls:**
- `async (anonymous)` (2514)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1680` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (2)

**Calls:**
- `_nodesFromRange` (1)
- `_nodesFromRange` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1674` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `get _tag` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:409` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `Uint8Array` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:441` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `CfgGraph` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6937` | Self: 0.0% (0us) | Total: 0.4% (16.5ms) | Samples: 0

**Called by:**
- `runPlugins` (11)

**Calls:**
- `getDFSEvents` (5)
- `getDFSEvents` (5)
- `getDFSEvents` (1)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:802` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_ensureDeclSymIndex` (1)

**Calls:**
- `_buildSymNameCache` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `get type` (1)

### `isInsideOfStorableFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:630` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `isReadForItself` (1)

**Calls:**
- `getUpperFunction` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1708` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `some` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:458` | Self: 0.0% (0us) | Total: 0.1% (6.4ms) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `patchAstUtils` (4)

### `getUpperFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:132` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `isInsideOfStorableFunction` (1)

**Calls:**
- `get parent` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` | Self: 0.0% (0us) | Total: 99.8% (3.85s) | Samples: 0

**Called by:**
- `(anonymous)` (2514)

**Calls:**
- `async (anonymous)` (2278)
- `async (anonymous)` (181)
- `async (anonymous)` (46)
- `async (anonymous)` (7)
- `async (anonymous)` (1)
- `async (anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` | Self: 0.0% (0us) | Total: 0.1% (3.9ms) | Samples: 0

**Called by:**
- `async (anonymous)` (2)

**Calls:**
- `AstView` (1)
- `AstView` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` | Self: 0.0% (0us) | Total: 2.2% (87.6ms) | Samples: 0

**Called by:**
- `_invokeFused` (58)

**Calls:**
- `getScope` (58)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` | Self: 0.0% (0us) | Total: 85.0% (3.27s) | Samples: 0

**Called by:**
- `_invokeFused` (2139)

**Calls:**
- `collectUnusedVariables` (1680)
- `collectUnusedVariables` (458)
- `collectUnusedVariables` (1)

### `ensureFenVars`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1825` | Self: 0.0% (0us) | Total: 0.4% (17.3ms) | Samples: 0

**Called by:**
- `get` (11)

**Calls:**
- `get` (11)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3959` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `reset` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2857` | Self: 0.0% (0us) | Total: 0.3% (13.9ms) | Samples: 0

**Called by:**
- `_buildVariable` (9)

**Calls:**
- `nodeView` (7)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2937` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `_buildThinScope` (3)

**Calls:**
- `_nodeViewRaw` (1)
- `nodeView` (1)
- `_nodeViewRaw` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7168` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_fireCfgEvents` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:45` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `bound require` (1)

### `forEach`
`[native code]` | Self: 0.0% (0us) | Total: 1.2% (49.4ms) | Samples: 0

**Called by:**
- `getFunctionDefinitions` (33)

**Calls:**
- `(anonymous)` (15)
- `(anonymous)` (10)
- `(anonymous)` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `_invokeFused` (2)

**Calls:**
- `report` (1)
- `report` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:15` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7173` | Self: 0.0% (0us) | Total: 87.4% (3.37s) | Samples: 0

**Called by:**
- `runPlugins` (2202)

**Calls:**
- `_invokeFused` (2202)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:576` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (3)

**Calls:**
- `_findLineIdx` (2)
- `_findLineIdx` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1828` | Self: 0.0% (0us) | Total: 0.4% (17.3ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (11)

**Calls:**
- `ensureFenVars` (11)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7449` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `async (anonymous)` (2)

**Calls:**
- `reset` (1)
- `reset` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:575` | Self: 0.0% (0us) | Total: 0.1% (7.2ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (5)

**Calls:**
- `_findLineIdx` (5)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` | Self: 0.0% (0us) | Total: 1.7% (67.1ms) | Samples: 0

**Called by:**
- `async (anonymous)` (44)

**Calls:**
- `parse` (44)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 0.9% (37.5ms) | Samples: 0

**Called by:**
- `async (anonymous)` (7)
- `patchAstUtils` (4)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `loadCoreRules` (1)
- `async (anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `require` (21)
- `anonymous` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` | Self: 0.0% (0us) | Total: 0.4% (15.7ms) | Samples: 0

**Called by:**
- `some` (10)

**Calls:**
- `isSelfReference` (10)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2505` | Self: 0.0% (0us) | Total: 1.8% (69.7ms) | Samples: 0

**Called by:**
- `getScope` (46)

**Calls:**
- `commentsInRange` (31)
- `commentsInRange` (5)
- `commentsInRange` (3)
- `commentsInRange` (2)
- `commentsInRange` (2)
- `commentsInRange` (2)
- `commentsInRange` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1274` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `_buildReference` (2)

**Calls:**
- `get _tag` (1)
- `get _tag` (1)

### `get id`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2273` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `extraClassData` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:776` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `get id` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` | Self: 0.0% (0us) | Total: 0.1% (4.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `get parent` (2)
- `get parent` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1712` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `push` (1)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:54` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:35` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `readFileSync` (1)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:66` | Self: 0.0% (0us) | Total: 90.5% (3.49s) | Samples: 0

**Called by:**
- `async (anonymous)` (2278)

**Calls:**
- `runPlugins` (2276)
- `runPlugins` (2)

### `ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1838` | Self: 0.0% (0us) | Total: 0.2% (10.6ms) | Samples: 0

**Called by:**
- `get` (7)

**Calls:**
- `_buildScopeVarsAndSet` (4)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` | Self: 0.0% (0us) | Total: 0.1% (4.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `get parent` (3)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1337` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)
- `ensureVarsSet` (1)

**Calls:**
- `_identAt` (1)
- `_resolveUnicodeEscapes` (1)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1584` | Self: 0.0% (0us) | Total: 2.2% (87.6ms) | Samples: 0

**Called by:**
- `Program:exit` (58)

**Calls:**
- `_precomputeScopes` (46)
- `_precomputeScopes` (8)
- `_precomputeScopes` (3)
- `_precomputeScopes` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` | Self: 0.0% (0us) | Total: 0.1% (4.3ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (3)

**Calls:**
- `get parent` (1)
- `isFunction` (1)
- `isFunction` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3861` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `Program:exit` (1)

**Calls:**
- `_execReport` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4628` | Self: 0.0% (0us) | Total: 87.4% (3.37s) | Samples: 0

**Called by:**
- `walkNodes` (2202)

**Calls:**
- `Program:exit` (2139)
- `Program:exit` (58)
- `Program:exit` (2)
- `Program:exit` (1)
- `Program:exit` (1)
- `Program:exit` (1)

### `parseModule`
`[native code]` | Self: 0.0% (0us) | Total: 100.0% (3.85s) | Samples: 0

**Called by:**
- `async (anonymous)` (2517)

**Calls:**
- `(anonymous)` (2514)
- `(anonymous)` (2)
- `(anonymous)` (1)

### `isUnusedExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:506` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `getRhsNode` (1)

**Calls:**
- `get parent` (1)

### `map`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (2)

**Calls:**
- `(anonymous)` (2)

### `ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1841` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `get` (1)

**Calls:**
- `findIndex` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isRead` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1965` | Self: 0.0% (0us) | Total: 35.4% (1.36s) | Samples: 0

**Called by:**
- `collectUnusedVariables` (875)
- `ensureFenVars` (11)

**Calls:**
- `ensureVarsSet` (875)
- `ensureVarsSet` (7)
- `ensureVarsSet` (2)
- `ensureVarsSet` (1)
- `ensureVarsSet` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `parseModule` (2)

**Calls:**
- `bound require` (2)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` | Self: 0.0% (0us) | Total: 1.4% (55.3ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (37)

**Calls:**
- `getFunctionDefinitions` (34)
- `getFunctionDefinitions` (3)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:868` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `get body` (1)

**Calls:**
- `nodeView` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2046` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `ensureVarsSet` (1)

**Calls:**
- `push` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:62` | Self: 0.0% (0us) | Total: 7.0% (273.2ms) | Samples: 0

**Called by:**
- `async (anonymous)` (181)

**Calls:**
- `runPlugins` (180)
- `runPlugins` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isInLoop` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` | Self: 0.0% (0us) | Total: 1.8% (72.3ms) | Samples: 0

**Called by:**
- `some` (47)

**Calls:**
- `isForInOfRef` (13)
- `isForInOfRef` (12)
- `isForInOfRef` (12)
- `isForInOfRef` (5)
- `isForInOfRef` (3)
- `isForInOfRef` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7452` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `RuleContext` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1711` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (2)

**Calls:**
- `set` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3143` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `map` (2)

**Calls:**
- `get name` (1)
- `get name` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1708` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `_symName` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1986` | Self: 0.0% (0us) | Total: 0.1% (5.7ms) | Samples: 0

**Called by:**
- `_buildScope` (3)

**Calls:**
- `get parent` (2)
- `get parent` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:53` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `loadCoreRules` (1)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 56.5% | 2.17s | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 21.8% | 841.8ms | `[native code]` |
| 14.2% | 551.1ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 7.3% | 281.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.0% | 1.5ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
