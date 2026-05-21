# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 3.17s | 2078 | 1.0ms | 370 |

**Top 10:** `walkNodes` 7.0%, `getDeclaredVariables` 5.4%, `Set` 3.7%, `_buildReference` 3.5%, `getDeclaredVariables` 3.1%, `_buildThinVariable` 2.3%, `parse` 2.1%, `get` 2.1%, `_ensureDeclSymIndex` 2.0%, `get type` 2.0%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 7.0% | 223.1ms | 7.7% | 246.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6952` |
| 5.4% | 172.7ms | 5.4% | 172.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` |
| 3.7% | 120.2ms | 3.7% | 120.2ms | `Set` | `[native code]` |
| 3.5% | 113.6ms | 4.3% | 137.0ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2906` |
| 3.1% | 99.6ms | 3.1% | 99.6ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3143` |
| 2.3% | 73.5ms | 2.6% | 82.6ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2963` |
| 2.1% | 68.8ms | 2.1% | 68.8ms | `parse` | `[native code]` |
| 2.1% | 68.8ms | 2.1% | 68.8ms | `get` | `[native code]` |
| 2.0% | 66.3ms | 3.0% | 96.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1853` |
| 2.0% | 63.8ms | 2.0% | 63.8ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1006` |
| 1.9% | 60.3ms | 2.0% | 63.6ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2628` |
| 1.5% | 48.3ms | 21.6% | 688.1ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2572` |
| 1.4% | 45.6ms | 1.4% | 46.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2061` |
| 1.3% | 43.9ms | 1.3% | 43.9ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` |
| 1.3% | 43.5ms | 1.3% | 43.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1222` |
| 1.3% | 41.3ms | 2.5% | 81.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1919` |
| 1.2% | 40.8ms | 1.2% | 40.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1175` |
| 1.2% | 39.7ms | 1.3% | 41.5ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3049` |
| 1.2% | 38.3ms | 1.2% | 38.3ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 1.2% | 38.2ms | 1.3% | 43.3ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 1.1% | 34.9ms | 1.1% | 34.9ms | `set` | `[native code]` |
| 1.0% | 34.2ms | 1.0% | 34.2ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 1.0% | 33.1ms | 1.0% | 34.6ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3103` |
| 0.9% | 29.7ms | 2.3% | 74.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 0.9% | 29.7ms | 0.9% | 29.7ms | `push` | `[native code]` |
| 0.8% | 28.5ms | 0.8% | 28.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6953` |
| 0.8% | 28.0ms | 1.6% | 51.5ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1854` |
| 0.8% | 26.8ms | 0.8% | 26.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6708` |
| 0.7% | 24.0ms | 0.7% | 24.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1285` |
| 0.7% | 24.0ms | 0.8% | 25.5ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1851` |
| 0.7% | 23.0ms | 100.0% | 4.64s | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3015` |
| 0.7% | 22.2ms | 0.7% | 22.2ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3032` |
| 0.6% | 21.5ms | 10.9% | 346.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2881` |
| 0.6% | 20.7ms | 0.6% | 20.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2047` |
| 0.6% | 20.7ms | 0.6% | 20.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2562` |
| 0.6% | 20.3ms | 1.8% | 60.1ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2152` |
| 0.6% | 19.9ms | 0.6% | 19.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7120` |
| 0.6% | 19.7ms | 1.1% | 37.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2619` |
| 0.6% | 19.5ms | 0.6% | 19.5ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3000` |
| 0.6% | 19.4ms | 0.6% | 19.4ms | `get _tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1072` |
| 0.6% | 19.4ms | 0.6% | 19.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.6% | 19.0ms | 0.6% | 19.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3999` |
| 0.5% | 18.7ms | 0.6% | 20.3ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3041` |
| 0.5% | 17.6ms | 0.5% | 17.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6951` |
| 0.5% | 16.4ms | 1.2% | 39.5ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` |
| 0.5% | 16.0ms | 0.5% | 16.0ms | `has` | `[native code]` |
| 0.5% | 15.9ms | 4.9% | 157.6ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2432` |
| 0.4% | 15.4ms | 0.8% | 27.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2877` |
| 0.4% | 15.3ms | 0.5% | 16.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1228` |
| 0.4% | 15.3ms | 0.4% | 15.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1939` |
| 0.4% | 14.2ms | 0.4% | 14.2ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2829` |
| 0.4% | 14.1ms | 0.4% | 14.1ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` |
| 0.4% | 14.0ms | 0.4% | 14.0ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1013` |
| 0.4% | 13.6ms | 0.4% | 13.6ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3026` |
| 0.4% | 13.5ms | 0.4% | 13.5ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4878` |
| 0.4% | 13.1ms | 5.4% | 172.4ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3135` |
| 0.3% | 12.5ms | 2.4% | 77.0ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1852` |
| 0.3% | 12.5ms | 10.6% | 336.9ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 0.3% | 12.5ms | 0.4% | 13.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3994` |
| 0.3% | 12.4ms | 0.3% | 12.4ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4056` |
| 0.3% | 12.1ms | 0.3% | 12.1ms | `get _tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.3% | 12.1ms | 0.3% | 12.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3991` |
| 0.3% | 11.7ms | 0.4% | 14.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1962` |
| 0.3% | 11.7ms | 0.3% | 11.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3136` |
| 0.3% | 11.6ms | 0.5% | 18.5ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` |
| 0.3% | 11.3ms | 0.5% | 17.4ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:506` |
| 0.3% | 11.2ms | 0.4% | 15.2ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` |
| 0.3% | 11.2ms | 0.3% | 11.2ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2542` |
| 0.3% | 11.1ms | 0.6% | 19.5ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2522` |
| 0.3% | 10.9ms | 1.2% | 40.7ms | `anonymous` | `[native code]` |
| 0.3% | 10.7ms | 1.5% | 50.5ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2601` |
| 0.3% | 10.7ms | 0.3% | 12.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2264` |
| 0.3% | 10.4ms | 0.3% | 10.4ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2920` |
| 0.3% | 10.4ms | 0.7% | 24.9ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1856` |
| 0.3% | 10.3ms | 46.0% | 1.46s | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 0.3% | 10.3ms | 9.6% | 305.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2045` |
| 0.3% | 10.0ms | 0.3% | 10.0ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2835` |
| 0.3% | 9.8ms | 0.3% | 9.8ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3125` |
| 0.3% | 9.8ms | 100.0% | 3.19s | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2936` |
| 0.3% | 9.6ms | 0.3% | 9.6ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.3% | 9.6ms | 24.6% | 780.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2054` |
| 0.3% | 9.6ms | 0.3% | 9.6ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:542` |
| 0.2% | 9.3ms | 2.3% | 75.7ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2874` |
| 0.2% | 9.3ms | 0.2% | 9.3ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.2% | 9.2ms | 0.2% | 9.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2260` |
| 0.2% | 9.1ms | 0.2% | 9.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6697` |
| 0.2% | 8.8ms | 0.5% | 17.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.2% | 8.8ms | 0.4% | 15.2ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` |
| 0.2% | 8.8ms | 0.2% | 8.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3986` |
| 0.2% | 8.7ms | 0.4% | 14.8ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:482` |
| 0.2% | 8.2ms | 0.2% | 8.2ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3031` |
| 0.2% | 7.9ms | 0.2% | 7.9ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6445` |
| 0.2% | 7.7ms | 0.4% | 14.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` |
| 0.2% | 7.7ms | 0.2% | 7.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` |
| 0.2% | 7.6ms | 0.2% | 7.6ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:226` |
| 0.2% | 7.4ms | 0.2% | 7.4ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2980` |
| 0.2% | 7.4ms | 39.7% | 1.26s | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:710` |
| 0.2% | 7.4ms | 0.2% | 7.4ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1011` |
| 0.2% | 6.8ms | 0.2% | 6.8ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:619` |
| 0.2% | 6.7ms | 0.2% | 6.7ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2429` |
| 0.2% | 6.7ms | 0.2% | 6.7ms | `/^\s*exported\b/` | `[native code]` |
| 0.2% | 6.6ms | 0.2% | 6.6ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3117` |
| 0.2% | 6.6ms | 0.2% | 6.6ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:467` |
| 0.2% | 6.6ms | 0.2% | 6.6ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2959` |
| 0.2% | 6.5ms | 0.3% | 12.0ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.2% | 6.5ms | 0.2% | 6.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4005` |
| 0.2% | 6.4ms | 0.2% | 6.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4002` |
| 0.2% | 6.4ms | 0.2% | 6.4ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2883` |
| 0.2% | 6.3ms | 0.2% | 6.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4001` |
| 0.1% | 6.2ms | 0.1% | 6.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3996` |
| 0.1% | 6.2ms | 0.1% | 6.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3110` |
| 0.1% | 6.1ms | 0.4% | 13.6ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2000` |
| 0.1% | 6.0ms | 0.1% | 6.0ms | `/^\s*globals?\b/` | `[native code]` |
| 0.1% | 6.0ms | 2.8% | 90.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 0.1% | 5.9ms | 9.9% | 314.7ms | `some` | `[native code]` |
| 0.1% | 5.9ms | 0.1% | 5.9ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:887` |
| 0.1% | 5.8ms | 0.1% | 5.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7119` |
| 0.1% | 5.8ms | 0.1% | 5.8ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6447` |
| 0.1% | 5.7ms | 1.5% | 49.9ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2957` |
| 0.1% | 5.6ms | 0.4% | 13.4ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:682` |
| 0.1% | 4.9ms | 0.1% | 4.9ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` |
| 0.1% | 4.9ms | 0.1% | 4.9ms | `isReadRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:431` |
| 0.1% | 4.8ms | 0.4% | 13.1ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2577` |
| 0.1% | 4.8ms | 0.7% | 24.6ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` |
| 0.1% | 4.7ms | 0.1% | 4.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1934` |
| 0.1% | 4.7ms | 0.1% | 4.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2726` |
| 0.1% | 4.6ms | 0.1% | 4.6ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` |
| 0.1% | 4.5ms | 0.3% | 10.9ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.1% | 4.4ms | 6.7% | 213.8ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2858` |
| 0.1% | 4.4ms | 2.1% | 69.7ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1864` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` |
| 0.1% | 4.3ms | 0.1% | 4.3ms | `Map` | `[native code]` |
| 0.1% | 4.3ms | 0.1% | 4.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4011` |
| 0.1% | 4.3ms | 0.1% | 4.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6712` |
| 0.1% | 4.2ms | 0.1% | 4.2ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2958` |
| 0.1% | 4.2ms | 0.1% | 4.2ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 4.2ms | 0.1% | 4.2ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4244` |
| 0.1% | 4.2ms | 0.1% | 4.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3995` |
| 0.1% | 3.8ms | 0.1% | 3.8ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 3.5ms | 0.1% | 3.5ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1007` |
| 0.1% | 3.4ms | 0.1% | 3.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2707` |
| 0.1% | 3.4ms | 0.1% | 3.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1849` |
| 0.1% | 3.4ms | 0.4% | 13.0ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.1% | 3.4ms | 0.1% | 3.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2793` |
| 0.1% | 3.4ms | 0.1% | 3.4ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3853` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `test` | `[native code]` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1898` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4004` |
| 0.1% | 3.2ms | 0.4% | 13.4ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2018` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1201` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 3.1ms | 100.0% | 3.35s | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3048` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3393` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 3.0ms | 0.1% | 4.6ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:653` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1717` |
| 0.0% | 3.0ms | 20.9% | 665.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` |
| 0.0% | 3.0ms | 0.7% | 24.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` |
| 0.0% | 2.9ms | 0.1% | 4.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1867` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1884` |
| 0.0% | 2.9ms | 0.1% | 6.0ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3024` |
| 0.0% | 2.9ms | 0.7% | 25.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1945` |
| 0.0% | 2.9ms | 0.2% | 7.2ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1999` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 2.8ms | 0.1% | 5.6ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3141` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 2.8ms | 3.8% | 123.0ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3116` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1855` |
| 0.0% | 2.6ms | 100.0% | 8.06s | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2044` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `Proxy` | `[native code]` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `(unknown)` | `[native code]` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:751` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1330` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2020` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_applySchemaDefaults` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1941` |
| 0.0% | 1.7ms | 39.4% | 1.25s | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:818` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3139` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2817` |
| 0.0% | 1.7ms | 0.1% | 4.8ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:688` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:711` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6709` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3102` |
| 0.0% | 1.7ms | 2.0% | 64.5ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4037` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getLocFromIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3430` |
| 0.0% | 1.7ms | 2.4% | 77.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isWrite` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2709` |
| 0.0% | 1.6ms | 0.1% | 5.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1903` |
| 0.0% | 1.6ms | 0.1% | 4.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3156` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2519` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `binop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:130` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1970` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3809` |
| 0.0% | 1.6ms | 0.1% | 4.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1255` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.1% | 3.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1868` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1677` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `next` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3140` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get right` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1793` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1838` |
| 0.0% | 1.5ms | 0.1% | 5.1ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:575` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4006` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2262` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.3% | 11.0ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2447` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3998` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3119` |
| 0.0% | 1.5ms | 0.2% | 6.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2521` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/conf/globals.js:64` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3620` |
| 0.0% | 1.5ms | 0.1% | 5.9ms | `exec` | `[native code]` |
| 0.0% | 1.4ms | 1.1% | 37.2ms | `bound require` | `[native code]` |
| 0.0% | 1.4ms | 0.1% | 6.3ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2907` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1295` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1684` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:494` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2059` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4003` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2636` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1673` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:528` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:818` |
| 0.0% | 1.3ms | 0.0% | 2.7ms | `readFileSync` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2761` |
| 0.0% | 1.3ms | 5.3% | 168.5ms | `_ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:533` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:543` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:508` |
| 0.0% | 1.3ms | 1.1% | 36.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4170` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4032` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4023` |
| 0.0% | 1.3ms | 0.1% | 4.4ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2022` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:797` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:752` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3997` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_getTypeProto` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3969` |
| 0.0% | 1.2ms | 0.1% | 4.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1909` |
| 0.0% | 1.2ms | 0.6% | 20.1ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2905` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `internal:primordials` |
| 0.0% | 1.2ms | 0.0% | 2.5ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:868` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:561` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:469` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 100.0% | 8.06s | 0.0% | 2.6ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 100.0% | 4.64s | 0.7% | 23.0ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3015` |
| 100.0% | 3.35s | 0.1% | 3.1ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3048` |
| 100.0% | 3.19s | 0.3% | 9.8ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2936` |
| 99.9% | 3.16s | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 99.9% | 3.16s | 0.0% | 0us | `parseModule` | `[native code]` |
| 99.8% | 3.16s | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` |
| 99.8% | 3.16s | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` |
| 96.9% | 3.07s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7470` |
| 89.1% | 2.82s | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:66` |
| 85.0% | 2.69s | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7186` |
| 85.0% | 2.69s | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4641` |
| 81.5% | 2.58s | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` |
| 46.0% | 1.46s | 0.3% | 10.3ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 39.7% | 1.26s | 0.2% | 7.4ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:710` |
| 39.4% | 1.25s | 0.0% | 1.7ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:818` |
| 24.6% | 780.7ms | 0.3% | 9.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2054` |
| 21.6% | 688.1ms | 1.5% | 48.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2572` |
| 20.9% | 665.2ms | 0.0% | 3.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` |
| 20.4% | 648.7ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` |
| 10.9% | 346.3ms | 0.6% | 21.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2881` |
| 10.6% | 336.9ms | 0.3% | 12.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 9.9% | 314.7ms | 0.1% | 5.9ms | `some` | `[native code]` |
| 9.6% | 305.7ms | 0.3% | 10.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2045` |
| 7.9% | 251.6ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:62` |
| 7.7% | 246.4ms | 7.0% | 223.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6952` |
| 6.7% | 213.8ms | 0.1% | 4.4ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 5.4% | 172.7ms | 5.4% | 172.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` |
| 5.4% | 172.4ms | 0.4% | 13.1ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3135` |
| 5.3% | 168.5ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:822` |
| 5.3% | 168.5ms | 0.0% | 1.3ms | `_ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` |
| 4.9% | 157.6ms | 0.5% | 15.9ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2432` |
| 4.3% | 137.0ms | 3.5% | 113.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2906` |
| 3.8% | 123.0ms | 0.0% | 2.8ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3116` |
| 3.7% | 120.2ms | 3.7% | 120.2ms | `Set` | `[native code]` |
| 3.1% | 99.6ms | 3.1% | 99.6ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3143` |
| 3.0% | 96.7ms | 2.0% | 66.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1853` |
| 3.0% | 95.9ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` |
| 3.0% | 95.9ms | 0.0% | 0us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1741` |
| 2.8% | 90.6ms | 0.1% | 6.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 2.6% | 83.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` |
| 2.6% | 82.6ms | 2.3% | 73.5ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2963` |
| 2.5% | 81.9ms | 1.3% | 41.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1919` |
| 2.4% | 79.0ms | 0.0% | 0us | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` |
| 2.4% | 77.2ms | 0.0% | 1.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 2.4% | 77.0ms | 0.3% | 12.5ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1852` |
| 2.3% | 75.7ms | 0.2% | 9.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2874` |
| 2.3% | 74.2ms | 0.9% | 29.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 2.3% | 73.0ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:59` |
| 2.1% | 69.7ms | 0.1% | 4.4ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 2.1% | 68.8ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` |
| 2.1% | 68.8ms | 2.1% | 68.8ms | `parse` | `[native code]` |
| 2.1% | 68.8ms | 2.1% | 68.8ms | `get` | `[native code]` |
| 2.1% | 68.6ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2518` |
| 2.0% | 66.5ms | 0.0% | 0us | `forEach` | `[native code]` |
| 2.0% | 64.5ms | 0.0% | 1.7ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4037` |
| 2.0% | 63.8ms | 2.0% | 63.8ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1006` |
| 2.0% | 63.6ms | 1.9% | 60.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2628` |
| 1.8% | 60.1ms | 0.6% | 20.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2152` |
| 1.6% | 51.5ms | 0.8% | 28.0ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1854` |
| 1.5% | 50.5ms | 0.3% | 10.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2601` |
| 1.5% | 49.9ms | 0.1% | 5.7ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2957` |
| 1.4% | 46.5ms | 0.0% | 0us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1189` |
| 1.4% | 46.5ms | 1.4% | 45.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2061` |
| 1.3% | 43.9ms | 1.3% | 43.9ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` |
| 1.3% | 43.5ms | 1.3% | 43.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1222` |
| 1.3% | 43.3ms | 1.2% | 38.2ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 1.3% | 41.5ms | 1.2% | 39.7ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3049` |
| 1.2% | 40.8ms | 1.2% | 40.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1175` |
| 1.2% | 40.7ms | 0.3% | 10.9ms | `anonymous` | `[native code]` |
| 1.2% | 39.5ms | 0.5% | 16.4ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` |
| 1.2% | 38.3ms | 1.2% | 38.3ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 1.1% | 37.7ms | 0.6% | 19.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2619` |
| 1.1% | 37.2ms | 0.0% | 1.4ms | `bound require` | `[native code]` |
| 1.1% | 36.6ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` |
| 1.1% | 34.9ms | 1.1% | 34.9ms | `set` | `[native code]` |
| 1.0% | 34.6ms | 1.0% | 33.1ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3103` |
| 1.0% | 34.4ms | 0.0% | 0us | `require` | `[native code]` |
| 1.0% | 34.2ms | 1.0% | 34.2ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.9% | 29.7ms | 0.9% | 29.7ms | `push` | `[native code]` |
| 0.9% | 29.3ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:837` |
| 0.9% | 29.3ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:832` |
| 0.8% | 28.5ms | 0.8% | 28.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6953` |
| 0.8% | 27.6ms | 0.4% | 15.4ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2877` |
| 0.8% | 26.8ms | 0.8% | 26.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6708` |
| 0.8% | 25.5ms | 0.7% | 24.0ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1851` |
| 0.7% | 25.2ms | 0.0% | 2.9ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` |
| 0.7% | 24.9ms | 0.3% | 10.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1856` |
| 0.7% | 24.6ms | 0.1% | 4.8ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` |
| 0.7% | 24.5ms | 0.0% | 3.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` |
| 0.7% | 24.0ms | 0.7% | 24.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1285` |
| 0.7% | 22.2ms | 0.7% | 22.2ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3032` |
| 0.6% | 20.7ms | 0.6% | 20.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2047` |
| 0.6% | 20.7ms | 0.6% | 20.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2562` |
| 0.6% | 20.3ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2870` |
| 0.6% | 20.3ms | 0.5% | 18.7ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3041` |
| 0.6% | 20.1ms | 0.0% | 1.2ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2905` |
| 0.6% | 19.9ms | 0.6% | 19.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7120` |
| 0.6% | 19.5ms | 0.3% | 11.1ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2522` |
| 0.6% | 19.5ms | 0.6% | 19.5ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3000` |
| 0.6% | 19.4ms | 0.6% | 19.4ms | `get _tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1072` |
| 0.6% | 19.4ms | 0.6% | 19.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.6% | 19.0ms | 0.6% | 19.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3999` |
| 0.5% | 18.5ms | 0.3% | 11.6ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` |
| 0.5% | 17.7ms | 0.2% | 8.8ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.5% | 17.6ms | 0.5% | 17.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6951` |
| 0.5% | 17.4ms | 0.3% | 11.3ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:506` |
| 0.5% | 16.8ms | 0.4% | 15.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1228` |
| 0.5% | 16.0ms | 0.5% | 16.0ms | `has` | `[native code]` |
| 0.4% | 15.3ms | 0.4% | 15.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1939` |
| 0.4% | 15.2ms | 0.2% | 8.8ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` |
| 0.4% | 15.2ms | 0.3% | 11.2ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` |
| 0.4% | 15.0ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6950` |
| 0.4% | 14.8ms | 0.2% | 8.7ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:482` |
| 0.4% | 14.7ms | 0.3% | 11.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1962` |
| 0.4% | 14.2ms | 0.4% | 14.2ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2829` |
| 0.4% | 14.2ms | 0.2% | 7.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` |
| 0.4% | 14.1ms | 0.4% | 14.1ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` |
| 0.4% | 14.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` |
| 0.4% | 14.0ms | 0.4% | 14.0ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1013` |
| 0.4% | 13.7ms | 0.3% | 12.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3994` |
| 0.4% | 13.6ms | 0.4% | 13.6ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3026` |
| 0.4% | 13.6ms | 0.1% | 6.1ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2000` |
| 0.4% | 13.5ms | 0.4% | 13.5ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4878` |
| 0.4% | 13.4ms | 0.1% | 5.6ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:682` |
| 0.4% | 13.4ms | 0.1% | 3.2ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2018` |
| 0.4% | 13.1ms | 0.1% | 4.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2577` |
| 0.4% | 13.0ms | 0.1% | 3.4ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.3% | 12.5ms | 0.3% | 10.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2264` |
| 0.3% | 12.4ms | 0.3% | 12.4ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4056` |
| 0.3% | 12.1ms | 0.3% | 12.1ms | `get _tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.3% | 12.1ms | 0.3% | 12.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3991` |
| 0.3% | 12.0ms | 0.2% | 6.5ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.3% | 11.7ms | 0.3% | 11.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3136` |
| 0.3% | 11.2ms | 0.3% | 11.2ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2542` |
| 0.3% | 11.0ms | 0.0% | 1.5ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.3% | 10.9ms | 0.1% | 4.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.3% | 10.8ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4065` |
| 0.3% | 10.6ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:46` |
| 0.3% | 10.4ms | 0.3% | 10.4ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2920` |
| 0.3% | 10.0ms | 0.3% | 10.0ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2835` |
| 0.3% | 9.8ms | 0.3% | 9.8ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3125` |
| 0.3% | 9.6ms | 0.3% | 9.6ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.3% | 9.6ms | 0.3% | 9.6ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:542` |
| 0.2% | 9.4ms | 0.0% | 0us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1337` |
| 0.2% | 9.3ms | 0.2% | 9.3ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.2% | 9.2ms | 0.2% | 9.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2260` |
| 0.2% | 9.1ms | 0.2% | 9.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6697` |
| 0.2% | 9.1ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` |
| 0.2% | 8.8ms | 0.2% | 8.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3986` |
| 0.2% | 8.2ms | 0.2% | 8.2ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3031` |
| 0.2% | 7.9ms | 0.2% | 7.9ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6445` |
| 0.2% | 7.7ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2154` |
| 0.2% | 7.7ms | 0.2% | 7.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` |
| 0.2% | 7.6ms | 0.2% | 7.6ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:226` |
| 0.2% | 7.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:458` |
| 0.2% | 7.6ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` |
| 0.2% | 7.4ms | 0.2% | 7.4ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2980` |
| 0.2% | 7.4ms | 0.2% | 7.4ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1011` |
| 0.2% | 7.2ms | 0.0% | 2.9ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1999` |
| 0.2% | 6.8ms | 0.2% | 6.8ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:619` |
| 0.2% | 6.7ms | 0.2% | 6.7ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2429` |
| 0.2% | 6.7ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` |
| 0.2% | 6.7ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3874` |
| 0.2% | 6.7ms | 0.2% | 6.7ms | `/^\s*exported\b/` | `[native code]` |
| 0.2% | 6.6ms | 0.2% | 6.6ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3117` |
| 0.2% | 6.6ms | 0.2% | 6.6ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:467` |
| 0.2% | 6.6ms | 0.2% | 6.6ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2959` |
| 0.2% | 6.5ms | 0.2% | 6.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4005` |
| 0.2% | 6.4ms | 0.2% | 6.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4002` |
| 0.2% | 6.4ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` |
| 0.2% | 6.4ms | 0.2% | 6.4ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2883` |
| 0.2% | 6.3ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:746` |
| 0.2% | 6.3ms | 0.2% | 6.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4001` |
| 0.1% | 6.3ms | 0.0% | 0us | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2950` |
| 0.1% | 6.3ms | 0.0% | 1.4ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2907` |
| 0.1% | 6.2ms | 0.1% | 6.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3996` |
| 0.1% | 6.2ms | 0.1% | 6.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3110` |
| 0.1% | 6.0ms | 0.1% | 6.0ms | `/^\s*globals?\b/` | `[native code]` |
| 0.1% | 6.0ms | 0.0% | 2.9ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3024` |
| 0.1% | 5.9ms | 0.0% | 1.5ms | `exec` | `[native code]` |
| 0.1% | 5.9ms | 0.0% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1903` |
| 0.1% | 5.9ms | 0.0% | 0us | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2910` |
| 0.1% | 5.9ms | 0.1% | 5.9ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:887` |
| 0.1% | 5.8ms | 0.1% | 5.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7119` |
| 0.1% | 5.8ms | 0.1% | 5.8ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6447` |
| 0.1% | 5.8ms | 0.0% | 0us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1274` |
| 0.1% | 5.7ms | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:484` |
| 0.1% | 5.6ms | 0.0% | 0us | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2909` |
| 0.1% | 5.6ms | 0.0% | 2.8ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3141` |
| 0.1% | 5.1ms | 0.0% | 1.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:575` |
| 0.1% | 4.9ms | 0.1% | 4.9ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` |
| 0.1% | 4.9ms | 0.1% | 4.9ms | `isReadRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:431` |
| 0.1% | 4.8ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:576` |
| 0.1% | 4.8ms | 0.0% | 1.7ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:688` |
| 0.1% | 4.7ms | 0.1% | 4.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1934` |
| 0.1% | 4.7ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3156` |
| 0.1% | 4.7ms | 0.0% | 0us | `map` | `[native code]` |
| 0.1% | 4.7ms | 0.1% | 4.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2726` |
| 0.1% | 4.7ms | 0.0% | 0us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` |
| 0.1% | 4.6ms | 0.0% | 0us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:701` |
| 0.1% | 4.6ms | 0.1% | 4.6ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 4.6ms | 0.0% | 3.0ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:653` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2858` |
| 0.1% | 4.4ms | 0.0% | 1.3ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2022` |
| 0.1% | 4.4ms | 0.0% | 1.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1909` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1864` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` |
| 0.1% | 4.3ms | 0.0% | 0us | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:737` |
| 0.1% | 4.3ms | 0.1% | 4.3ms | `Map` | `[native code]` |
| 0.1% | 4.3ms | 0.1% | 4.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4011` |
| 0.1% | 4.3ms | 0.1% | 4.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6712` |
| 0.1% | 4.3ms | 0.0% | 2.9ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1867` |
| 0.1% | 4.2ms | 0.1% | 4.2ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2958` |
| 0.1% | 4.2ms | 0.1% | 4.2ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 4.2ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:441` |
| 0.1% | 4.2ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` |
| 0.1% | 4.2ms | 0.1% | 4.2ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4244` |
| 0.1% | 4.2ms | 0.1% | 4.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3995` |
| 0.1% | 4.1ms | 0.0% | 1.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1255` |
| 0.1% | 3.8ms | 0.1% | 3.8ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 3.5ms | 0.1% | 3.5ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1007` |
| 0.1% | 3.5ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2057` |
| 0.1% | 3.4ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1973` |
| 0.1% | 3.4ms | 0.1% | 3.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2707` |
| 0.1% | 3.4ms | 0.1% | 3.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1849` |
| 0.1% | 3.4ms | 0.1% | 3.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2793` |
| 0.1% | 3.4ms | 0.1% | 3.4ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3853` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `test` | `[native code]` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1898` |
| 0.1% | 3.3ms | 0.1% | 3.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4004` |
| 0.1% | 3.2ms | 0.0% | 1.6ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1868` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1201` |
| 0.1% | 3.1ms | 0.1% | 3.1ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.1% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3393` |
| 0.0% | 3.1ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7469` |
| 0.0% | 3.0ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:661` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1717` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1884` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1945` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 2.8ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` |
| 0.0% | 2.8ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:557` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 2.7ms | 0.0% | 1.3ms | `readFileSync` | `[native code]` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1855` |
| 0.0% | 2.5ms | 0.0% | 1.2ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:868` |
| 0.0% | 2.5ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1680` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2044` |
| 0.0% | 2.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 2.1ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:45` |
| 0.0% | 1.8ms | 0.0% | 0us | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2943` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `Proxy` | `[native code]` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `(unknown)` | `[native code]` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:751` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1330` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2020` |
| 0.0% | 1.7ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4287` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_applySchemaDefaults` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1941` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3139` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2817` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:711` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6709` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3102` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3046` |
| 0.0% | 1.7ms | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3828` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `getLocFromIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3430` |
| 0.0% | 1.7ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2449` |
| 0.0% | 1.6ms | 0.0% | 0us | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2257` |
| 0.0% | 1.6ms | 0.0% | 0us | `filter` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1692` |
| 0.0% | 1.6ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1690` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isWrite` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2709` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2519` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `binop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:130` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:197` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1970` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3809` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3155` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1677` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `next` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6720` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3140` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get right` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1793` |
| 0.0% | 1.6ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:561` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1838` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4006` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2262` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.0% | 0us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2697` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2447` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3998` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3119` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2521` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:22` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/conf/globals.js:64` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3620` |
| 0.0% | 1.5ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1483` |
| 0.0% | 1.4ms | 0.0% | 0us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1237` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1295` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1684` |
| 0.0% | 1.4ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:752` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` |
| 0.0% | 1.4ms | 0.0% | 0us | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:512` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:840` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:841` |
| 0.0% | 1.4ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:551` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:494` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2059` |
| 0.0% | 1.4ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2055` |
| 0.0% | 1.4ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1703` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4003` |
| 0.0% | 1.4ms | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:519` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2636` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:29` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1673` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:528` |
| 0.0% | 1.3ms | 0.0% | 0us | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:802` |
| 0.0% | 1.3ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1865` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:818` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:35` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2761` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:543` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:533` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:508` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4170` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:54` |
| 0.0% | 1.3ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:53` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4032` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4023` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:797` |
| 0.0% | 1.2ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1689` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:752` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3997` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_getTypeProto` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3969` |
| 0.0% | 1.2ms | 0.0% | 0us | `node:events` | `node:events:9` |
| 0.0% | 1.2ms | 0.0% | 0us | `internal:shared` | `internal:shared:2` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `internal:primordials` |
| 0.0% | 1.2ms | 0.0% | 0us | `internal:primordials` | `internal:primordials:71` |
| 0.0% | 1.2ms | 0.0% | 0us | `bound call` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.0% | 1.2ms | 0.0% | 0us | `internal:validators` | `internal:validators:2` |
| 0.0% | 1.2ms | 0.0% | 0us | `makeSafe` | `internal:primordials:30` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:561` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:469` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |

## Function Details

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6952` | Self: 7.0% (223.1ms) | Total: 7.7% (246.4ms) | Samples: 148

**Called by:**
- `runPlugins` (163)

**Calls:**
- `get allSkipped` (9)
- `get allSkipped` (6)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3137` | Self: 5.4% (172.7ms) | Total: 5.4% (172.7ms) | Samples: 115

**Called by:**
- `isAfterLastUsedArg` (115)

### `Set`
`[native code]` | Self: 3.7% (120.2ms) | Total: 3.7% (120.2ms) | Samples: 80

**Called by:**
- `getDeclaredVariables` (80)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2906` | Self: 3.5% (113.6ms) | Total: 4.3% (137.0ms) | Samples: 74

**Called by:**
- `_buildVariable` (89)

**Calls:**
- `get type` (9)
- `get type` (5)
- `get type` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3143` | Self: 3.1% (99.6ms) | Total: 3.1% (99.6ms) | Samples: 67

**Called by:**
- `isAfterLastUsedArg` (64)
- `isAfterLastUsedArg` (3)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2963` | Self: 2.3% (73.5ms) | Total: 2.6% (82.6ms) | Samples: 49

**Called by:**
- `_buildThinScope` (55)

**Calls:**
- `get parent` (2)
- `get parent` (1)
- `_findDefNode` (1)
- `get parent` (1)
- `get parent` (1)

### `parse`
`[native code]` | Self: 2.1% (68.8ms) | Total: 2.1% (68.8ms) | Samples: 45

**Called by:**
- `parseSource` (45)

### `get`
`[native code]` | Self: 2.1% (68.8ms) | Total: 2.1% (68.8ms) | Samples: 44

**Called by:**
- `_ensureDeclSymIndex` (41)
- `_ensureDeclSymIndex` (1)
- `_buildScopeVarsAndSet` (1)
- `_ensureDeclSymIndex` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1853` | Self: 2.0% (66.3ms) | Total: 3.0% (96.7ms) | Samples: 44

**Called by:**
- `_buildScopeVarsAndSet` (64)

**Calls:**
- `set` (19)
- `get` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1006` | Self: 2.0% (63.8ms) | Total: 2.0% (63.8ms) | Samples: 42

**Called by:**
- `(anonymous)` (10)
- `isForInOfRef` (10)
- `_buildReference` (5)
- `isReadForItself` (2)
- `collectUnusedVariables` (2)
- `isForInOfRef` (2)
- `getRhsNode` (2)
- `_buildScope` (2)
- `_computeIsStrict` (1)
- `collectUnusedVariables` (1)
- `(anonymous)` (1)
- `collectUnusedVariables` (1)
- `(anonymous)` (1)
- `isUnusedExpression` (1)
- `isForInOfRef` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2628` | Self: 1.9% (60.3ms) | Total: 2.0% (63.6ms) | Samples: 40

**Called by:**
- `_buildScopeVarsAndSet` (25)
- `getDeclaredVariables` (17)

**Calls:**
- `_buildThinScope` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2572` | Self: 1.5% (48.3ms) | Total: 21.6% (688.1ms) | Samples: 32

**Called by:**
- `_buildScopeVarsAndSet` (393)
- `getDeclaredVariables` (58)

**Calls:**
- `_buildReference` (228)
- `_buildReference` (89)
- `_buildReference` (50)
- `_buildReference` (18)
- `_buildReference` (13)
- `_buildReference` (13)
- `_buildReference` (4)
- `_buildReference` (3)
- `_buildReference` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2061` | Self: 1.4% (45.6ms) | Total: 1.4% (46.5ms) | Samples: 30

**Called by:**
- `_ensureVarsSet` (31)

**Calls:**
- `set` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` | Self: 1.3% (43.9ms) | Total: 1.3% (43.9ms) | Samples: 29

**Called by:**
- `_precomputeScopes` (29)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1222` | Self: 1.3% (43.5ms) | Total: 1.3% (43.5ms) | Samples: 29

**Called by:**
- `_buildReference` (8)
- `_findDefNode` (5)
- `(anonymous)` (4)
- `isReadForItself` (3)
- `_buildReference` (3)
- `isForInOfRef` (2)
- `getRhsNode` (2)
- `isForInOfRef` (1)
- `_findDefNode` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1919` | Self: 1.3% (41.3ms) | Total: 2.5% (81.9ms) | Samples: 27

**Called by:**
- `_buildScopeChildren` (54)

**Calls:**
- `_computeIsStrict` (9)
- `_computeIsStrict` (9)
- `_computeIsStrict` (5)
- `_computeIsStrict` (3)
- `_computeIsStrict` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1175` | Self: 1.2% (40.8ms) | Total: 1.2% (40.8ms) | Samples: 26

**Called by:**
- `_buildVariable` (11)
- `_buildReference` (5)
- `_buildReference` (4)
- `_findDefNode` (2)
- `(anonymous)` (1)
- `isReadForItself` (1)
- `_computeIsStrict` (1)
- `isForInOfRef` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3049` | Self: 1.2% (39.7ms) | Total: 1.3% (41.5ms) | Samples: 26

**Called by:**
- `_buildThinVariable` (23)
- `_buildThinScope` (4)

**Calls:**
- `set` (1)

### `/\/\*([\s\S]*?)\*\//g`
`[native code]` | Self: 1.2% (38.3ms) | Total: 1.2% (38.3ms) | Samples: 26

**Called by:**
- `_buildScopeVarsAndSet` (23)
- `exec` (3)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` | Self: 1.2% (38.2ms) | Total: 1.3% (43.3ms) | Samples: 25

**Called by:**
- `(anonymous)` (28)

**Calls:**
- `get parent` (2)
- `get parent` (1)

### `set`
`[native code]` | Self: 1.1% (34.9ms) | Total: 1.1% (34.9ms) | Samples: 23

**Called by:**
- `_ensureDeclSymIndex` (19)
- `_ensureDeclSymIndex` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildThinScope` (1)
- `_buildScopeVarsAndSet` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 1.0% (34.2ms) | Total: 1.0% (34.2ms) | Samples: 22

**Called by:**
- `(anonymous)` (5)
- `isForInOfRef` (3)
- `isForInOfRef` (3)
- `isForInOfRef` (2)
- `getRhsNode` (2)
- `collectUnusedVariables` (1)
- `(anonymous)` (1)
- `isReadForItself` (1)
- `collectUnusedVariables` (1)
- `isReadForItself` (1)
- `isForInOfRef` (1)
- `isForInOfRef` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3103` | Self: 1.0% (33.1ms) | Total: 1.0% (34.6ms) | Samples: 22

**Called by:**
- `isAfterLastUsedArg` (23)

**Calls:**
- `_ensureDeclSymIndex` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` | Self: 0.9% (29.7ms) | Total: 2.3% (74.2ms) | Samples: 20

**Called by:**
- `some` (49)

**Calls:**
- `get type` (10)
- `get parent` (9)
- `get type` (5)
- `get parent` (4)
- `get parent` (1)

### `push`
`[native code]` | Self: 0.9% (29.7ms) | Total: 0.9% (29.7ms) | Samples: 19

**Called by:**
- `_ensureDeclSymIndex` (15)
- `_buildScopeVarsAndSet` (2)
- `getDeclaredVariables` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6953` | Self: 0.8% (28.5ms) | Total: 0.8% (28.5ms) | Samples: 18

**Called by:**
- `runPlugins` (18)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1854` | Self: 0.8% (28.0ms) | Total: 1.6% (51.5ms) | Samples: 19

**Called by:**
- `_buildScopeVarsAndSet` (34)

**Calls:**
- `push` (15)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6708` | Self: 0.8% (26.8ms) | Total: 0.8% (26.8ms) | Samples: 17

**Called by:**
- `runPlugins` (17)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1285` | Self: 0.7% (24.0ms) | Total: 0.7% (24.0ms) | Samples: 16

**Called by:**
- `_buildReference` (7)
- `_findDefNode` (5)
- `_buildReference` (2)
- `isForInOfRef` (1)
- `_buildThinVariable` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1851` | Self: 0.7% (24.0ms) | Total: 0.8% (25.5ms) | Samples: 15

**Called by:**
- `_buildScopeVarsAndSet` (16)

**Calls:**
- `has` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3015` | Self: 0.7% (23.0ms) | Total: 100.0% (4.64s) | Samples: 16

**Called by:**
- `_buildThinScope` (2109)
- `_buildThinVariable` (747)
- `_buildReference` (188)

**Calls:**
- `_buildThinScope` (2109)
- `_buildThinScope` (909)
- `_buildThinScope` (4)
- `_buildThinScope` (3)
- `_buildThinScope` (2)
- `_buildThinScope` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3032` | Self: 0.7% (22.2ms) | Total: 0.7% (22.2ms) | Samples: 15

**Called by:**
- `_buildThinVariable` (10)
- `_buildVariable` (2)
- `_buildThinScope` (2)
- `_buildReference` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2881` | Self: 0.6% (21.5ms) | Total: 10.9% (346.3ms) | Samples: 14

**Called by:**
- `_buildVariable` (228)

**Calls:**
- `_buildThinScope` (188)
- `_buildThinScope` (11)
- `_buildThinScope` (7)
- `_buildThinScope` (4)
- `_buildThinScope` (2)
- `_buildThinScope` (1)
- `_buildThinScope` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2047` | Self: 0.6% (20.7ms) | Total: 0.6% (20.7ms) | Samples: 14

**Called by:**
- `_ensureVarsSet` (14)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2562` | Self: 0.6% (20.7ms) | Total: 0.6% (20.7ms) | Samples: 13

**Called by:**
- `_buildScopeVarsAndSet` (9)
- `getDeclaredVariables` (4)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2152` | Self: 0.6% (20.3ms) | Total: 1.8% (60.1ms) | Samples: 14

**Called by:**
- `_ensureVarsSet` (41)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (23)
- `exec` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7120` | Self: 0.6% (19.9ms) | Total: 0.6% (19.9ms) | Samples: 13

**Called by:**
- `runPlugins` (13)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2619` | Self: 0.6% (19.7ms) | Total: 1.1% (37.7ms) | Samples: 13

**Called by:**
- `_buildScopeVarsAndSet` (23)
- `getDeclaredVariables` (2)

**Calls:**
- `get parent` (11)
- `get parent` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3000` | Self: 0.6% (19.5ms) | Total: 0.6% (19.5ms) | Samples: 13

**Called by:**
- `_buildReference` (7)
- `_buildThinScope` (3)
- `_buildThinVariable` (3)

### `get _tag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1072` | Self: 0.6% (19.4ms) | Total: 0.6% (19.4ms) | Samples: 13

**Called by:**
- `_findDefNode` (4)
- `_findDefNode` (3)
- `_buildScope` (2)
- `init` (2)
- `get parent` (1)
- `get id` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.6% (19.4ms) | Total: 0.6% (19.4ms) | Samples: 13

**Called by:**
- `_computeIsStrict` (3)
- `isReadForItself` (2)
- `_buildThinVariable` (2)
- `collectUnusedVariables` (1)
- `getRhsNode` (1)
- `_computeIsStrict` (1)
- `_findDefNode` (1)
- `_buildVariable` (1)
- `collectUnusedVariables` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3999` | Self: 0.6% (19.0ms) | Total: 0.6% (19.0ms) | Samples: 12

**Called by:**
- `nodeView` (12)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3041` | Self: 0.5% (18.7ms) | Total: 0.6% (20.3ms) | Samples: 12

**Called by:**
- `_buildReference` (11)
- `_buildThinVariable` (2)

**Calls:**
- `_ensureDeclSymIndex` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6951` | Self: 0.5% (17.6ms) | Total: 0.5% (17.6ms) | Samples: 12

**Called by:**
- `runPlugins` (12)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:478` | Self: 0.5% (16.4ms) | Total: 1.2% (39.5ms) | Samples: 11

**Called by:**
- `_buildThinVariable` (18)
- `_buildVariable` (9)

**Calls:**
- `get parent` (5)
- `get parent` (5)
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `has`
`[native code]` | Self: 0.5% (16.0ms) | Total: 0.5% (16.0ms) | Samples: 10

**Called by:**
- `_ensureDeclSymIndex` (9)
- `_ensureDeclSymIndex` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2432` | Self: 0.5% (15.9ms) | Total: 4.9% (157.6ms) | Samples: 10

**Called by:**
- `_ensureChildren` (103)

**Calls:**
- `_buildScope` (54)
- `_buildScope` (10)
- `_buildScope` (10)
- `_buildScope` (4)
- `_buildScope` (3)
- `_buildScope` (3)
- `_buildScope` (2)
- `_buildScope` (2)
- `_buildScope` (2)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2877` | Self: 0.4% (15.4ms) | Total: 0.8% (27.6ms) | Samples: 10

**Called by:**
- `_buildVariable` (18)

**Calls:**
- `_buildThinVariable` (5)
- `_buildThinVariable` (3)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1228` | Self: 0.4% (15.3ms) | Total: 0.5% (16.8ms) | Samples: 10

**Called by:**
- `_buildReference` (7)
- `_buildReference` (3)
- `_findDefNode` (1)

**Calls:**
- `get value` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1939` | Self: 0.4% (15.3ms) | Total: 0.4% (15.3ms) | Samples: 10

**Called by:**
- `_buildScopeChildren` (10)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2829` | Self: 0.4% (14.2ms) | Total: 0.4% (14.2ms) | Samples: 9

**Called by:**
- `getDeclaredVariables` (7)
- `_buildScopeVarsAndSet` (2)

### `isSelfReference`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` | Self: 0.4% (14.1ms) | Total: 0.4% (14.1ms) | Samples: 9

**Called by:**
- `(anonymous)` (9)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1013` | Self: 0.4% (14.0ms) | Total: 0.4% (14.0ms) | Samples: 9

**Called by:**
- `_buildReference` (9)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3026` | Self: 0.4% (13.6ms) | Total: 0.4% (13.6ms) | Samples: 9

**Called by:**
- `_buildThinVariable` (5)
- `_buildReference` (4)

### `get allSkipped`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4878` | Self: 0.4% (13.5ms) | Total: 0.4% (13.5ms) | Samples: 9

**Called by:**
- `walkNodes` (9)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3135` | Self: 0.4% (13.1ms) | Total: 5.4% (172.4ms) | Samples: 8

**Called by:**
- `isAfterLastUsedArg` (113)

**Calls:**
- `_buildVariable` (58)
- `_buildVariable` (17)
- `_buildVariable` (7)
- `_buildVariable` (6)
- `_buildVariable` (4)
- `_buildVariable` (3)
- `_buildVariable` (3)
- `_buildVariable` (2)
- `_buildVariable` (2)
- `_buildVariable` (1)
- `_buildVariable` (1)
- `_buildVariable` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1852` | Self: 0.3% (12.5ms) | Total: 2.4% (77.0ms) | Samples: 8

**Called by:**
- `_buildScopeVarsAndSet` (49)

**Calls:**
- `get` (41)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` | Self: 0.3% (12.5ms) | Total: 10.6% (336.9ms) | Samples: 8

**Called by:**
- `collectUnusedVariables` (219)

**Calls:**
- `isUsedVariable` (139)
- `isUsedVariable` (52)
- `some` (17)
- `isUsedVariable` (3)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3994` | Self: 0.3% (12.5ms) | Total: 0.4% (13.7ms) | Samples: 9

**Called by:**
- `nodeView` (3)
- `_buildThinScope` (1)
- `_buildThinVariable` (1)
- `get body` (1)
- `_buildReference` (1)
- `nodeViewChain` (1)
- `get parent` (1)
- `_nodesFromRange` (1)

**Calls:**
- `_getTypeProto` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4056` | Self: 0.3% (12.4ms) | Total: 0.3% (12.4ms) | Samples: 8

**Called by:**
- `(anonymous)` (5)
- `(anonymous)` (2)
- `(anonymous)` (1)

### `get _tag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.3% (12.1ms) | Total: 0.3% (12.1ms) | Samples: 8

**Called by:**
- `get parent` (4)
- `_findDefNode` (1)
- `init` (1)
- `get parent` (1)
- `get parent` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3991` | Self: 0.3% (12.1ms) | Total: 0.3% (12.1ms) | Samples: 8

**Called by:**
- `nodeView` (8)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1962` | Self: 0.3% (11.7ms) | Total: 0.4% (14.7ms) | Samples: 8

**Called by:**
- `_buildScopeChildren` (10)

**Calls:**
- `get type` (2)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3136` | Self: 0.3% (11.7ms) | Total: 0.3% (11.7ms) | Samples: 8

**Called by:**
- `isAfterLastUsedArg` (8)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` | Self: 0.3% (11.6ms) | Total: 0.5% (18.5ms) | Samples: 8

**Called by:**
- `(anonymous)` (12)

**Calls:**
- `get type` (2)
- `get type` (2)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:506` | Self: 0.3% (11.3ms) | Total: 0.5% (17.4ms) | Samples: 7

**Called by:**
- `_buildVariable` (7)
- `_buildThinVariable` (3)
- `_buildThinVariable` (1)

**Calls:**
- `get _tag` (4)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` | Self: 0.3% (11.2ms) | Total: 0.4% (15.2ms) | Samples: 7

**Called by:**
- `(anonymous)` (10)

**Calls:**
- `get type` (2)
- `get type` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2542` | Self: 0.3% (11.2ms) | Total: 0.3% (11.2ms) | Samples: 7

**Called by:**
- `_buildScopeVarsAndSet` (4)
- `getDeclaredVariables` (3)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2522` | Self: 0.3% (11.1ms) | Total: 0.6% (19.5ms) | Samples: 7

**Called by:**
- `getScope` (13)

**Calls:**
- `/^\s*exported\b/` (5)
- `test` (1)

### `anonymous`
`[native code]` | Self: 0.3% (10.9ms) | Total: 1.2% (40.7ms) | Samples: 7

**Called by:**
- `require` (22)
- `internal:shared` (1)
- `internal:validators` (1)
- `bound require` (1)
- `node:fs` (1)
- `node:events` (1)

**Calls:**
- `(anonymous)` (5)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `node:events` (1)
- `(anonymous)` (1)
- `internal:shared` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:fs` (1)
- `internal:primordials` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:validators` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2601` | Self: 0.3% (10.7ms) | Total: 1.5% (50.5ms) | Samples: 7

**Called by:**
- `_buildScopeVarsAndSet` (27)
- `getDeclaredVariables` (6)

**Calls:**
- `_findDefNode` (9)
- `_findDefNode` (7)
- `_findDefNode` (5)
- `_findDefNode` (4)
- `_findDefNode` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2264` | Self: 0.3% (10.7ms) | Total: 0.3% (12.5ms) | Samples: 7

**Called by:**
- `_ensureVarsSet` (8)

**Calls:**
- `set` (1)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2920` | Self: 0.3% (10.4ms) | Total: 0.3% (10.4ms) | Samples: 7

**Called by:**
- `_buildReference` (5)
- `_buildThinScope` (2)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1856` | Self: 0.3% (10.4ms) | Total: 0.7% (24.9ms) | Samples: 7

**Called by:**
- `_buildScopeVarsAndSet` (16)

**Calls:**
- `has` (9)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` | Self: 0.3% (10.3ms) | Total: 46.0% (1.46s) | Samples: 7

**Called by:**
- `collectUnusedVariables` (529)
- `Program:exit` (428)

**Calls:**
- `get` (820)
- `get` (110)
- `get` (19)
- `get` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2045` | Self: 0.3% (10.3ms) | Total: 9.6% (305.7ms) | Samples: 7

**Called by:**
- `_ensureVarsSet` (199)

**Calls:**
- `_ensureDeclSymIndex` (64)
- `_ensureDeclSymIndex` (49)
- `_ensureDeclSymIndex` (34)
- `_ensureDeclSymIndex` (16)
- `_ensureDeclSymIndex` (16)
- `_ensureDeclSymIndex` (3)
- `_ensureDeclSymIndex` (3)
- `_ensureDeclSymIndex` (2)
- `_ensureDeclSymIndex` (2)
- `_ensureDeclSymIndex` (2)
- `_ensureDeclSymIndex` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2835` | Self: 0.3% (10.0ms) | Total: 0.3% (10.0ms) | Samples: 7

**Called by:**
- `_buildScopeVarsAndSet` (6)
- `getDeclaredVariables` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3125` | Self: 0.3% (9.8ms) | Total: 0.3% (9.8ms) | Samples: 6

**Called by:**
- `isAfterLastUsedArg` (6)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2936` | Self: 0.3% (9.8ms) | Total: 100.0% (3.19s) | Samples: 6

**Called by:**
- `_buildThinScope` (2101)

**Calls:**
- `_buildThinScope` (1298)
- `_buildThinScope` (747)
- `_buildThinScope` (23)
- `_buildThinScope` (10)
- `_buildThinScope` (5)
- `_buildThinScope` (4)
- `_buildThinScope` (3)
- `_buildThinScope` (3)
- `_buildThinScope` (2)

### `get allSkipped`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.3% (9.6ms) | Total: 0.3% (9.6ms) | Samples: 6

**Called by:**
- `walkNodes` (6)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2054` | Self: 0.3% (9.6ms) | Total: 24.6% (780.7ms) | Samples: 7

**Called by:**
- `_ensureVarsSet` (511)

**Calls:**
- `_buildVariable` (393)
- `_buildVariable` (27)
- `_buildVariable` (25)
- `_buildVariable` (23)
- `_buildVariable` (9)
- `_buildVariable` (8)
- `_buildVariable` (6)
- `_buildVariable` (4)
- `_buildVariable` (2)
- `_buildVariable` (2)
- `_buildVariable` (1)
- `_buildVariable` (1)
- `_buildVariable` (1)
- `_buildVariable` (1)
- `_buildVariable` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:542` | Self: 0.3% (9.6ms) | Total: 0.3% (9.6ms) | Samples: 6

**Called by:**
- `(anonymous)` (6)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2874` | Self: 0.2% (9.3ms) | Total: 2.3% (75.7ms) | Samples: 6

**Called by:**
- `_buildVariable` (50)

**Calls:**
- `get parent` (12)
- `get parent` (8)
- `get parent` (7)
- `get parent` (7)
- `get parent` (5)
- `get parent` (3)
- `get parent` (2)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` | Self: 0.2% (9.3ms) | Total: 0.2% (9.3ms) | Samples: 6

**Called by:**
- `isUsedVariable` (6)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2260` | Self: 0.2% (9.2ms) | Total: 0.2% (9.2ms) | Samples: 6

**Called by:**
- `_ensureVarsSet` (6)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6697` | Self: 0.2% (9.1ms) | Total: 0.2% (9.1ms) | Samples: 6

**Called by:**
- `runPlugins` (6)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` | Self: 0.2% (8.8ms) | Total: 0.5% (17.7ms) | Samples: 6

**Called by:**
- `collectUnusedVariables` (12)

**Calls:**
- `get parent` (3)
- `get type` (2)
- `get type` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` | Self: 0.2% (8.8ms) | Total: 0.4% (15.2ms) | Samples: 6

**Called by:**
- `(anonymous)` (10)

**Calls:**
- `get type` (2)
- `get type` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3986` | Self: 0.2% (8.8ms) | Total: 0.2% (8.8ms) | Samples: 6

**Called by:**
- `_buildVariable` (3)
- `(anonymous)` (1)
- `_buildScope` (1)
- `_buildReference` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:482` | Self: 0.2% (8.7ms) | Total: 0.4% (14.8ms) | Samples: 5

**Called by:**
- `_buildVariable` (5)
- `_buildThinVariable` (4)

**Calls:**
- `get _tag` (3)
- `get _tag` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3031` | Self: 0.2% (8.2ms) | Total: 0.2% (8.2ms) | Samples: 4

**Called by:**
- `_buildThinVariable` (3)
- `_buildReference` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6445` | Self: 0.2% (7.9ms) | Total: 0.2% (7.9ms) | Samples: 5

**Called by:**
- `walkNodes` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` | Self: 0.2% (7.7ms) | Total: 0.4% (14.2ms) | Samples: 5

**Called by:**
- `forEach` (9)

**Calls:**
- `init` (2)
- `nodeViewChain` (1)
- `_nodeViewRaw` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` | Self: 0.2% (7.7ms) | Total: 0.2% (7.7ms) | Samples: 5

**Called by:**
- `_precomputeScopes` (5)

### `_resolveUnicodeEscapes`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:226` | Self: 0.2% (7.6ms) | Total: 0.2% (7.6ms) | Samples: 5

**Called by:**
- `get name` (5)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2980` | Self: 0.2% (7.4ms) | Total: 0.2% (7.4ms) | Samples: 5

**Called by:**
- `_buildThinScope` (4)
- `_buildVariable` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:710` | Self: 0.2% (7.4ms) | Total: 39.7% (1.26s) | Samples: 5

**Called by:**
- `get` (816)
- `_ensureVarsSet` (11)

**Calls:**
- `_buildScopeVarsAndSet` (511)
- `_buildScopeVarsAndSet` (199)
- `_buildScopeVarsAndSet` (41)
- `_buildScopeVarsAndSet` (31)
- `_buildScopeVarsAndSet` (14)
- `_buildScopeVarsAndSet` (8)
- `_buildScopeVarsAndSet` (6)
- `_buildScopeVarsAndSet` (5)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1011` | Self: 0.2% (7.4ms) | Total: 0.2% (7.4ms) | Samples: 5

**Called by:**
- `_computeIsStrict` (2)
- `(anonymous)` (1)
- `_buildReference` (1)
- `isForInOfRef` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:619` | Self: 0.2% (6.8ms) | Total: 0.2% (6.8ms) | Samples: 4

**Called by:**
- `commentsInRange` (2)
- `commentsInRange` (2)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2429` | Self: 0.2% (6.7ms) | Total: 0.2% (6.7ms) | Samples: 4

**Called by:**
- `_ensureChildren` (4)

### `/^\s*exported\b/`
`[native code]` | Self: 0.2% (6.7ms) | Total: 0.2% (6.7ms) | Samples: 5

**Called by:**
- `_precomputeScopes` (5)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3117` | Self: 0.2% (6.6ms) | Total: 0.2% (6.6ms) | Samples: 3

**Called by:**
- `isAfterLastUsedArg` (3)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:467` | Self: 0.2% (6.6ms) | Total: 0.2% (6.6ms) | Samples: 4

**Called by:**
- `_buildVariable` (4)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2959` | Self: 0.2% (6.6ms) | Total: 0.2% (6.6ms) | Samples: 5

**Called by:**
- `_buildThinScope` (5)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` | Self: 0.2% (6.5ms) | Total: 0.3% (12.0ms) | Samples: 4

**Called by:**
- `collectUnusedVariables` (8)

**Calls:**
- `getDeclaredVariables` (3)
- `map` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4005` | Self: 0.2% (6.5ms) | Total: 0.2% (6.5ms) | Samples: 4

**Called by:**
- `nodeView` (4)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4002` | Self: 0.2% (6.4ms) | Total: 0.2% (6.4ms) | Samples: 4

**Called by:**
- `nodeView` (4)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2883` | Self: 0.2% (6.4ms) | Total: 0.2% (6.4ms) | Samples: 4

**Called by:**
- `_buildVariable` (4)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4001` | Self: 0.2% (6.3ms) | Total: 0.2% (6.3ms) | Samples: 4

**Called by:**
- `nodeViewChain` (2)
- `nodeView` (1)
- `get parent` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3996` | Self: 0.1% (6.2ms) | Total: 0.1% (6.2ms) | Samples: 4

**Called by:**
- `nodeView` (4)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3110` | Self: 0.1% (6.2ms) | Total: 0.1% (6.2ms) | Samples: 4

**Called by:**
- `isAfterLastUsedArg` (4)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2000` | Self: 0.1% (6.1ms) | Total: 0.4% (13.6ms) | Samples: 4

**Called by:**
- `_buildScope` (9)

**Calls:**
- `get type` (2)
- `get parent` (1)
- `get type` (1)
- `get parent` (1)

### `/^\s*globals?\b/`
`[native code]` | Self: 0.1% (6.0ms) | Total: 0.1% (6.0ms) | Samples: 4

**Called by:**
- `_buildScopeVarsAndSet` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` | Self: 0.1% (6.0ms) | Total: 2.8% (90.6ms) | Samples: 4

**Called by:**
- `some` (59)

**Calls:**
- `getRhsNode` (28)
- `getRhsNode` (10)
- `getRhsNode` (6)
- `getRhsNode` (6)
- `getRhsNode` (2)
- `getRhsNode` (1)
- `getRhsNode` (1)
- `getRhsNode` (1)

### `some`
`[native code]` | Self: 0.1% (5.9ms) | Total: 9.9% (314.7ms) | Samples: 4

**Called by:**
- `isUsedVariable` (136)
- `collectUnusedVariables` (50)
- `collectUnusedVariables` (17)
- `collectUnusedVariables` (1)
- `isAfterLastUsedArg` (1)

**Calls:**
- `(anonymous)` (59)
- `(anonymous)` (54)
- `(anonymous)` (49)
- `(anonymous)` (24)
- `(anonymous)` (9)
- `(anonymous)` (4)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:887` | Self: 0.1% (5.9ms) | Total: 0.1% (5.9ms) | Samples: 4

**Called by:**
- `collectUnusedVariables` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7119` | Self: 0.1% (5.8ms) | Total: 0.1% (5.8ms) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6447` | Self: 0.1% (5.8ms) | Total: 0.1% (5.8ms) | Samples: 4

**Called by:**
- `walkNodes` (4)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2957` | Self: 0.1% (5.7ms) | Total: 1.5% (49.9ms) | Samples: 4

**Called by:**
- `_buildThinScope` (33)

**Calls:**
- `_findDefNode` (18)
- `_findDefNode` (4)
- `_findDefNode` (4)
- `_findDefNode` (3)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:682` | Self: 0.1% (5.6ms) | Total: 0.4% (13.4ms) | Samples: 4

**Called by:**
- `(anonymous)` (9)

**Calls:**
- `get type` (3)
- `get type` (1)
- `get type` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` | Self: 0.1% (4.9ms) | Total: 0.1% (4.9ms) | Samples: 3

**Called by:**
- `collectUnusedVariables` (3)

### `isReadRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:431` | Self: 0.1% (4.9ms) | Total: 0.1% (4.9ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2577` | Self: 0.1% (4.8ms) | Total: 0.4% (13.1ms) | Samples: 3

**Called by:**
- `_buildScopeVarsAndSet` (8)
- `getDeclaredVariables` (1)

**Calls:**
- `nodeView` (3)
- `_nodeViewRaw` (3)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` | Self: 0.1% (4.8ms) | Total: 0.7% (24.6ms) | Samples: 3

**Called by:**
- `(anonymous)` (16)

**Calls:**
- `get type` (10)
- `get type` (3)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1934` | Self: 0.1% (4.7ms) | Total: 0.1% (4.7ms) | Samples: 3

**Called by:**
- `_buildScopeChildren` (3)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2726` | Self: 0.1% (4.7ms) | Total: 0.1% (4.7ms) | Samples: 3

**Called by:**
- `getDeclaredVariables` (3)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (4.6ms) | Total: 0.1% (4.6ms) | Samples: 3

**Called by:**
- `getRhsNode` (3)

### `nodeRhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (4.5ms) | Total: 0.1% (4.5ms) | Samples: 3

**Called by:**
- `init` (3)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:448` | Self: 0.1% (4.5ms) | Total: 0.1% (4.5ms) | Samples: 3

**Called by:**
- `getRhsNode` (3)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` | Self: 0.1% (4.5ms) | Total: 0.3% (10.9ms) | Samples: 3

**Called by:**
- `collectUnusedVariables` (7)

**Calls:**
- `get parent` (1)
- `get type` (1)
- `get parent` (1)
- `get type` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` | Self: 0.1% (4.4ms) | Total: 6.7% (213.8ms) | Samples: 3

**Called by:**
- `collectUnusedVariables` (139)

**Calls:**
- `some` (136)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2858` | Self: 0.1% (4.4ms) | Total: 0.1% (4.4ms) | Samples: 3

**Called by:**
- `_buildVariable` (3)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` | Self: 0.1% (4.4ms) | Total: 2.1% (69.7ms) | Samples: 3

**Called by:**
- `isUsedVariable` (46)

**Calls:**
- `forEach` (43)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` | Self: 0.1% (4.4ms) | Total: 0.1% (4.4ms) | Samples: 3

**Called by:**
- `_precomputeScopes` (3)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1864` | Self: 0.1% (4.4ms) | Total: 0.1% (4.4ms) | Samples: 3

**Called by:**
- `_buildScopeVarsAndSet` (3)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` | Self: 0.1% (4.4ms) | Total: 0.1% (4.4ms) | Samples: 3

**Called by:**
- `collectUnusedVariables` (3)

### `Map`
`[native code]` | Self: 0.1% (4.3ms) | Total: 0.1% (4.3ms) | Samples: 3

**Called by:**
- `_ensureVarsSet` (3)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4011` | Self: 0.1% (4.3ms) | Total: 0.1% (4.3ms) | Samples: 3

**Called by:**
- `nodeViewChain` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6712` | Self: 0.1% (4.3ms) | Total: 0.1% (4.3ms) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2958` | Self: 0.1% (4.2ms) | Total: 0.1% (4.2ms) | Samples: 3

**Called by:**
- `_buildReference` (3)

### `nodeLhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (4.2ms) | Total: 0.1% (4.2ms) | Samples: 3

**Called by:**
- `init` (3)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4244` | Self: 0.1% (4.2ms) | Total: 0.1% (4.2ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3995` | Self: 0.1% (4.2ms) | Total: 0.1% (4.2ms) | Samples: 3

**Called by:**
- `nodeView` (2)
- `get body` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (3.8ms) | Total: 0.1% (3.8ms) | Samples: 3

**Called by:**
- `_buildVariable` (3)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1007` | Self: 0.1% (3.5ms) | Total: 0.1% (3.5ms) | Samples: 2

**Called by:**
- `isForInOfRef` (1)
- `isForInOfRef` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2707` | Self: 0.1% (3.4ms) | Total: 0.1% (3.4ms) | Samples: 2

**Called by:**
- `getDeclaredVariables` (1)
- `_buildScopeVarsAndSet` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1849` | Self: 0.1% (3.4ms) | Total: 0.1% (3.4ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` | Self: 0.1% (3.4ms) | Total: 0.4% (13.0ms) | Samples: 2

**Called by:**
- `(anonymous)` (8)

**Calls:**
- `get parent` (3)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2793` | Self: 0.1% (3.4ms) | Total: 0.1% (3.4ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3853` | Self: 0.1% (3.4ms) | Total: 0.1% (3.4ms) | Samples: 1

**Called by:**
- `report` (1)

### `test`
`[native code]` | Self: 0.1% (3.3ms) | Total: 0.1% (3.3ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (1)
- `_precomputeScopes` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1898` | Self: 0.1% (3.3ms) | Total: 0.1% (3.3ms) | Samples: 2

**Called by:**
- `_buildScopeChildren` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4004` | Self: 0.1% (3.3ms) | Total: 0.1% (3.3ms) | Samples: 2

**Called by:**
- `nodeView` (1)
- `nodeViewChain` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2018` | Self: 0.1% (3.2ms) | Total: 0.4% (13.4ms) | Samples: 2

**Called by:**
- `_buildScope` (9)

**Calls:**
- `get body` (2)
- `get body` (2)
- `get body` (1)
- `get body` (1)
- `get body` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1201` | Self: 0.1% (3.2ms) | Total: 0.1% (3.2ms) | Samples: 2

**Called by:**
- `_findDefNode` (1)
- `_buildThinVariable` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (3.1ms) | Total: 0.1% (3.1ms) | Samples: 2

**Called by:**
- `_computeIsStrict` (2)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3048` | Self: 0.1% (3.1ms) | Total: 100.0% (3.35s) | Samples: 2

**Called by:**
- `_buildThinVariable` (1298)
- `_buildThinScope` (909)

**Calls:**
- `_buildThinVariable` (2101)
- `_buildThinVariable` (55)
- `_buildThinVariable` (33)
- `_buildThinVariable` (5)
- `_buildThinVariable` (4)
- `_buildThinVariable` (4)
- `_buildThinVariable` (2)
- `_buildThinVariable` (1)

### `get directive`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3393` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `_computeIsStrict` (2)

### `isInside`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `isReadForItself` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `getDeclaredVariables` (2)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:653` | Self: 0.0% (3.0ms) | Total: 0.1% (4.6ms) | Samples: 2

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `get type` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1717` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `_invokeFused` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` | Self: 0.0% (3.0ms) | Total: 20.9% (665.2ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (439)

**Calls:**
- `isAfterLastUsedArg` (428)
- `isAfterLastUsedArg` (8)
- `isAfterLastUsedArg` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` | Self: 0.0% (3.0ms) | Total: 0.7% (24.5ms) | Samples: 2

**Called by:**
- `forEach` (16)

**Calls:**
- `nodeViewChain` (5)
- `nodeViewChain` (3)
- `init` (2)
- `get init` (1)
- `init` (1)
- `nodeViewChain` (1)
- `init` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1867` | Self: 0.0% (2.9ms) | Total: 0.1% (4.3ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (3)

**Calls:**
- `get` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1884` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `_buildScopeChildren` (1)
- `_precomputeScopes` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3024` | Self: 0.0% (2.9ms) | Total: 0.1% (6.0ms) | Samples: 2

**Called by:**
- `_buildThinVariable` (4)

**Calls:**
- `_nodeViewRaw` (1)
- `nodeView` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` | Self: 0.0% (2.9ms) | Total: 0.7% (25.2ms) | Samples: 2

**Called by:**
- `forEach` (17)

**Calls:**
- `nodeViewChain` (4)
- `init` (3)
- `init` (2)
- `nodeViewChain` (2)
- `init` (1)
- `get type` (1)
- `get type` (1)
- `get type` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1945` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `_buildScopeChildren` (2)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1999` | Self: 0.0% (2.9ms) | Total: 0.2% (7.2ms) | Samples: 2

**Called by:**
- `_buildScope` (5)

**Calls:**
- `get parent` (3)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `get` (2)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3141` | Self: 0.0% (2.8ms) | Total: 0.1% (5.6ms) | Samples: 2

**Called by:**
- `isAfterLastUsedArg` (4)

**Calls:**
- `push` (2)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `_buildReference` (2)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3116` | Self: 0.0% (2.8ms) | Total: 3.8% (123.0ms) | Samples: 2

**Called by:**
- `isAfterLastUsedArg` (82)

**Calls:**
- `Set` (80)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `_ensureChildren` (2)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1855` | Self: 0.0% (2.6ms) | Total: 0.0% (2.6ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` | Self: 0.0% (2.6ms) | Total: 100.0% (8.06s) | Samples: 2

**Called by:**
- `collectUnusedVariables` (4012)
- `Program:exit` (1270)

**Calls:**
- `collectUnusedVariables` (4012)
- `collectUnusedVariables` (529)
- `collectUnusedVariables` (439)
- `collectUnusedVariables` (219)
- `collectUnusedVariables` (51)
- `collectUnusedVariables` (12)
- `collectUnusedVariables` (7)
- `collectUnusedVariables` (4)
- `collectUnusedVariables` (3)
- `collectUnusedVariables` (2)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2044` | Self: 0.0% (2.5ms) | Total: 0.0% (2.5ms) | Samples: 2

**Called by:**
- `_ensureVarsSet` (2)

### `Proxy`
`[native code]` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `_buildThinVariable` (1)

### `(unknown)`
`[native code]` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:751` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `get name` (1)

### `get init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1330` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2020` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `_applySchemaDefaults`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1941` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:818` | Self: 0.0% (1.7ms) | Total: 39.4% (1.25s) | Samples: 1

**Called by:**
- `collectUnusedVariables` (820)

**Calls:**
- `_ensureVarsSet` (816)
- `_ensureVarsSet` (2)
- `_ensureVarsSet` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3139` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2817` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:688` | Self: 0.0% (1.7ms) | Total: 0.1% (4.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `get type` (1)
- `get body` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:711` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `get` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6709` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3102` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4037` | Self: 0.0% (1.7ms) | Total: 2.0% (64.5ms) | Samples: 1

**Called by:**
- `get parent` (29)
- `_buildReference` (9)
- `_buildThinVariable` (2)
- `_buildThinScope` (1)
- `_buildScope` (1)

**Calls:**
- `_nodeViewRaw` (12)
- `_nodeViewRaw` (8)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_buildThinScope` (1)

### `getLocFromIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3430` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_execReport` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` | Self: 0.0% (1.7ms) | Total: 2.4% (77.2ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (51)

**Calls:**
- `some` (50)

### `isWrite`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2709` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1903` | Self: 0.0% (1.6ms) | Total: 0.1% (5.9ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (4)

**Calls:**
- `nodeView` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3156` | Self: 0.0% (1.6ms) | Total: 0.1% (4.7ms) | Samples: 1

**Called by:**
- `map` (3)

**Calls:**
- `get name` (2)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2519` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `getScope` (1)

### `binop`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:130` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1970` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3809` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `report` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1255` | Self: 0.0% (1.6ms) | Total: 0.1% (4.1ms) | Samples: 1

**Called by:**
- `_buildReference` (2)
- `_findDefNode` (1)

**Calls:**
- `get _tag` (1)
- `get _tag` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1868` | Self: 0.0% (1.6ms) | Total: 0.1% (3.2ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (2)

**Calls:**
- `set` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1677` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `next`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3140` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `get right`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1793` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `getRhsNode` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1838` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildThinScope` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:575` | Self: 0.0% (1.5ms) | Total: 0.1% (5.1ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (3)

**Calls:**
- `_findLineIdx` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4006` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildThinVariable` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2262` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildVariable` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `commentsInRange` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` | Self: 0.0% (1.5ms) | Total: 0.3% (11.0ms) | Samples: 1

**Called by:**
- `(anonymous)` (7)

**Calls:**
- `get parent` (3)
- `get parent` (2)
- `get parent` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2447` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `getScope` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3998` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `nodeView` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3119` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` | Self: 0.0% (1.5ms) | Total: 0.2% (6.4ms) | Samples: 1

**Called by:**
- `some` (4)

**Calls:**
- `isReadRef` (3)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2521` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `getScope` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/conf/globals.js:64` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3620` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `get value` (1)

### `exec`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.1% (5.9ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (4)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (3)

### `bound require`
`[native code]` | Self: 0.0% (1.4ms) | Total: 1.1% (37.2ms) | Samples: 1

**Called by:**
- `async (anonymous)` (7)
- `patchAstUtils` (5)
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
- `require` (22)
- `anonymous` (1)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2907` | Self: 0.0% (1.4ms) | Total: 0.1% (6.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (3)
- `(anonymous)` (1)

**Calls:**
- `get _tag` (2)
- `get _tag` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1295` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_findDefNode` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1684` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:753` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `some` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `isInside`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:494` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getRhsNode` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2059` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4003` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2636` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1673` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `nodeLhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:528` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `init` (1)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:818` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_symName` (1)

### `readFileSync`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (2.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)
- `readFileSync` (1)

**Calls:**
- `readFileSync` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2761` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_ensureChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:789` | Self: 0.0% (1.3ms) | Total: 5.3% (168.5ms) | Samples: 1

**Called by:**
- `get` (110)

**Calls:**
- `_buildScopeChildren` (103)
- `_buildScopeChildren` (4)
- `_buildScopeChildren` (2)

### `nodeRhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:533` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `init` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:543` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `isUnusedExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:508` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getRhsNode` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` | Self: 0.0% (1.3ms) | Total: 1.1% (36.6ms) | Samples: 1

**Called by:**
- `some` (24)

**Calls:**
- `isReadForItself` (10)
- `isReadForItself` (7)
- `isReadForItself` (3)
- `isReadForItself` (2)
- `isReadForItself` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4170` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4032` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4023` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2022` | Self: 0.0% (1.3ms) | Total: 0.1% (4.4ms) | Samples: 1

**Called by:**
- `_buildScope` (3)

**Calls:**
- `get directive` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:797` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:752` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_ensureVarsSet` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3997` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `nodeView` (1)

### `_getTypeProto`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3969` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1909` | Self: 0.0% (1.2ms) | Total: 0.1% (4.4ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (3)

**Calls:**
- `get _tag` (2)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2905` | Self: 0.0% (1.2ms) | Total: 0.6% (20.1ms) | Samples: 1

**Called by:**
- `_buildVariable` (13)

**Calls:**
- `get parent` (4)
- `get parent` (3)
- `get parent` (3)
- `get parent` (2)

### `(anonymous)`
`internal:primordials` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `forEach` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:868` | Self: 0.0% (1.2ms) | Total: 0.0% (2.5ms) | Samples: 1

**Called by:**
- `get body` (2)

**Calls:**
- `_nodeViewRaw` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:561` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:469` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `forEach` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `getScope` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7186` | Self: 0.0% (0us) | Total: 85.0% (2.69s) | Samples: 0

**Called by:**
- `runPlugins` (1768)

**Calls:**
- `_invokeFused` (1768)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:46` | Self: 0.0% (0us) | Total: 0.3% (10.6ms) | Samples: 0

**Called by:**
- `async (anonymous)` (7)

**Calls:**
- `bound require` (7)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:822` | Self: 0.0% (0us) | Total: 5.3% (168.5ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (110)

**Calls:**
- `_ensureChildren` (110)

### `internal:primordials`
`internal:primordials:71` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `makeSafe` (1)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2950` | Self: 0.0% (0us) | Total: 0.1% (6.3ms) | Samples: 0

**Called by:**
- `_buildThinScope` (4)

**Calls:**
- `nodeView` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` | Self: 0.0% (0us) | Total: 0.4% (14.1ms) | Samples: 0

**Called by:**
- `some` (9)

**Calls:**
- `isSelfReference` (9)

### `isUnusedExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:512` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `getRhsNode` (1)

**Calls:**
- `get type` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` | Self: 0.0% (0us) | Total: 3.0% (95.9ms) | Samples: 0

**Called by:**
- `_invokeFused` (63)

**Calls:**
- `getScope` (63)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `bound call`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `makeSafe` (1)

**Calls:**
- `forEach` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:519` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_buildVariable` (1)

**Calls:**
- `get parent` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:53` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `loadCoreRules` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1703` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (2.1ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1237` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_findDefNode` (1)

**Calls:**
- `get _tag` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:661` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `isInside` (2)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3828` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `report` (1)

**Calls:**
- `getLocFromIndex` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:62` | Self: 0.0% (0us) | Total: 7.9% (251.6ms) | Samples: 0

**Called by:**
- `async (anonymous)` (169)

**Calls:**
- `runPlugins` (168)
- `runPlugins` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2057` | Self: 0.0% (0us) | Total: 0.1% (3.5ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (2)

**Calls:**
- `push` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2697` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `_buildThinVariable` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:737` | Self: 0.0% (0us) | Total: 0.1% (4.3ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (3)

**Calls:**
- `Map` (3)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4065` | Self: 0.0% (0us) | Total: 0.3% (10.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)
- `(anonymous)` (3)

**Calls:**
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1680` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (2)

**Calls:**
- `_nodesFromRange` (2)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:752` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `some` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:484` | Self: 0.0% (0us) | Total: 0.1% (5.7ms) | Samples: 0

**Called by:**
- `_buildThinVariable` (4)

**Calls:**
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3046` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_buildThinScope` (1)

**Calls:**
- `_symName` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1274` | Self: 0.0% (0us) | Total: 0.1% (5.8ms) | Samples: 0

**Called by:**
- `_buildReference` (3)
- `_buildThinVariable` (1)

**Calls:**
- `get _tag` (4)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:576` | Self: 0.0% (0us) | Total: 0.1% (4.8ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (3)

**Calls:**
- `_findLineIdx` (2)
- `_findLineIdx` (1)

### `internal:shared`
`internal:shared:2` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:557` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `isUnusedExpression` (1)
- `isUnusedExpression` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:458` | Self: 0.0% (0us) | Total: 0.2% (7.6ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `patchAstUtils` (5)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:441` | Self: 0.0% (0us) | Total: 0.1% (4.2ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `CfgGraph` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` | Self: 0.0% (0us) | Total: 99.8% (3.16s) | Samples: 0

**Called by:**
- `(anonymous)` (2074)

**Calls:**
- `async (anonymous)` (1850)
- `async (anonymous)` (169)
- `async (anonymous)` (46)
- `async (anonymous)` (7)
- `async (anonymous)` (1)
- `async (anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` | Self: 0.0% (0us) | Total: 0.1% (4.2ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `AstView` (1)

### `makeSafe`
`internal:primordials:30` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `internal:primordials` (1)

**Calls:**
- `bound call` (1)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` | Self: 0.0% (0us) | Total: 0.2% (7.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `bound require` (5)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1483` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `get parent` (1)

**Calls:**
- `get loc` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2154` | Self: 0.0% (0us) | Total: 0.2% (7.7ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (5)

**Calls:**
- `/^\s*globals?\b/` (4)
- `test` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6950` | Self: 0.0% (0us) | Total: 0.4% (15.0ms) | Samples: 0

**Called by:**
- `runPlugins` (10)

**Calls:**
- `getDFSEvents` (5)
- `getDFSEvents` (4)
- `getDFSEvents` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` | Self: 0.0% (0us) | Total: 99.8% (3.16s) | Samples: 0

**Called by:**
- `parseModule` (2074)

**Calls:**
- `async (anonymous)` (2074)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (2)

**Calls:**
- `get parent` (1)
- `get type` (1)

### `filter`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `Program:exit` (1)

**Calls:**
- `(anonymous)` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:561` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get right` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3155` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `isAfterLastUsedArg` (1)

**Calls:**
- `map` (1)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:54` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `bound require` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4641` | Self: 0.0% (0us) | Total: 85.0% (2.69s) | Samples: 0

**Called by:**
- `walkNodes` (1768)

**Calls:**
- `Program:exit` (1698)
- `Program:exit` (63)
- `Program:exit` (3)
- `Program:exit` (2)
- `Program:exit` (1)
- `Program:exit` (1)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2943` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `_buildThinScope` (1)

**Calls:**
- `Proxy` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:66` | Self: 0.0% (0us) | Total: 89.1% (2.82s) | Samples: 0

**Called by:**
- `async (anonymous)` (1850)

**Calls:**
- `runPlugins` (1849)
- `runPlugins` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1689` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `isForInOfRef` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `map`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `isAfterLastUsedArg` (1)
- `isAfterLastUsedArg` (1)
- `getDeclaredVariables` (1)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` | Self: 0.0% (0us) | Total: 2.6% (83.8ms) | Samples: 0

**Called by:**
- `some` (54)

**Calls:**
- `isForInOfRef` (16)
- `isForInOfRef` (12)
- `isForInOfRef` (9)
- `isForInOfRef` (8)
- `isForInOfRef` (3)
- `isForInOfRef` (3)
- `isForInOfRef` (3)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1973` | Self: 0.0% (0us) | Total: 0.1% (3.4ms) | Samples: 0

**Called by:**
- `_buildScopeChildren` (2)

**Calls:**
- `get name` (1)
- `get id` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7469` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)
- `async (anonymous)` (1)

**Calls:**
- `buildVisitorMap` (1)
- `buildVisitorMap` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1189` | Self: 0.0% (0us) | Total: 1.4% (46.5ms) | Samples: 0

**Called by:**
- `_buildReference` (12)
- `(anonymous)` (9)
- `collectUnusedVariables` (3)
- `isForInOfRef` (3)
- `collectUnusedVariables` (1)
- `_findDefNode` (1)
- `isForInOfRef` (1)
- `_findDefNode` (1)

**Calls:**
- `nodeView` (29)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:840` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `some` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` | Self: 0.0% (0us) | Total: 2.1% (68.8ms) | Samples: 0

**Called by:**
- `async (anonymous)` (45)

**Calls:**
- `parse` (45)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7470` | Self: 0.0% (0us) | Total: 96.9% (3.07s) | Samples: 0

**Called by:**
- `async (anonymous)` (1849)
- `async (anonymous)` (168)

**Calls:**
- `walkNodes` (1768)
- `walkNodes` (163)
- `walkNodes` (18)
- `walkNodes` (17)
- `walkNodes` (13)
- `walkNodes` (12)
- `walkNodes` (10)
- `walkNodes` (6)
- `walkNodes` (4)
- `walkNodes` (3)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2910` | Self: 0.0% (0us) | Total: 0.1% (5.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)
- `(anonymous)` (2)

**Calls:**
- `nodeRhs` (3)
- `nodeRhs` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:832` | Self: 0.0% (0us) | Total: 0.9% (29.3ms) | Samples: 0

**Called by:**
- `get` (19)

**Calls:**
- `_ensureVarsSet` (11)
- `_ensureVarsSet` (4)
- `_ensureVarsSet` (3)
- `_ensureVarsSet` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:35` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `readFileSync` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2055` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (1)

**Calls:**
- `get` (1)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2909` | Self: 0.0% (0us) | Total: 0.1% (5.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `nodeLhs` (3)
- `nodeLhs` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4287` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_applySchemaDefaults` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` | Self: 0.0% (0us) | Total: 0.2% (6.7ms) | Samples: 0

**Called by:**
- `_invokeFused` (3)

**Calls:**
- `report` (3)

### `_ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:746` | Self: 0.0% (0us) | Total: 0.2% (6.3ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (4)

**Calls:**
- `get name` (4)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `forEach`
`[native code]` | Self: 0.0% (0us) | Total: 2.0% (66.5ms) | Samples: 0

**Called by:**
- `getFunctionDefinitions` (43)
- `bound call` (1)

**Calls:**
- `(anonymous)` (17)
- `(anonymous)` (16)
- `(anonymous)` (9)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1690` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `filter` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6720` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `next` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:59` | Self: 0.0% (0us) | Total: 2.3% (73.0ms) | Samples: 0

**Called by:**
- `async (anonymous)` (46)

**Calls:**
- `parseSource` (45)
- `parseSource` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1337` | Self: 0.0% (0us) | Total: 0.2% (9.4ms) | Samples: 0

**Called by:**
- `_ensureVarsSet` (4)
- `(anonymous)` (2)

**Calls:**
- `_resolveUnicodeEscapes` (5)
- `_identAt` (1)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:802` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_ensureDeclSymIndex` (1)

**Calls:**
- `_buildSymNameCache` (1)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 1.0% (34.4ms) | Samples: 0

**Called by:**
- `bound require` (22)

**Calls:**
- `anonymous` (22)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:701` | Self: 0.0% (0us) | Total: 0.1% (4.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `get type` (1)
- `get type` (1)
- `get type` (1)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 99.9% (3.16s) | Samples: 0

**Calls:**
- `parseModule` (2077)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` | Self: 0.0% (0us) | Total: 81.5% (2.58s) | Samples: 0

**Called by:**
- `_invokeFused` (1698)

**Calls:**
- `collectUnusedVariables` (1270)
- `collectUnusedVariables` (428)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `parseModule` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.1% (3.1ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `parseModule`
`[native code]` | Self: 0.0% (0us) | Total: 99.9% (3.16s) | Samples: 0

**Called by:**
- `async (anonymous)` (2077)

**Calls:**
- `(anonymous)` (2074)
- `(anonymous)` (2)
- `(anonymous)` (1)

### `node:events`
`node:events:9` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` | Self: 0.0% (0us) | Total: 2.4% (79.0ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (52)

**Calls:**
- `getFunctionDefinitions` (46)
- `getFunctionDefinitions` (6)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2518` | Self: 0.0% (0us) | Total: 2.1% (68.6ms) | Samples: 0

**Called by:**
- `getScope` (45)

**Calls:**
- `commentsInRange` (29)
- `commentsInRange` (5)
- `commentsInRange` (3)
- `commentsInRange` (3)
- `commentsInRange` (3)
- `commentsInRange` (1)
- `commentsInRange` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2449` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `getScope` (1)

**Calls:**
- `_buildScope` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.1% (3.1ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:45` | Self: 0.0% (0us) | Total: 0.0% (2.1ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `bound require` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3874` | Self: 0.0% (0us) | Total: 0.2% (6.7ms) | Samples: 0

**Called by:**
- `Program:exit` (3)

**Calls:**
- `_execReport` (1)
- `_execReport` (1)
- `_execReport` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` | Self: 0.0% (0us) | Total: 20.4% (648.7ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (428)

**Calls:**
- `getDeclaredVariables` (115)
- `getDeclaredVariables` (113)
- `getDeclaredVariables` (82)
- `getDeclaredVariables` (64)
- `getDeclaredVariables` (23)
- `getDeclaredVariables` (8)
- `getDeclaredVariables` (6)
- `getDeclaredVariables` (4)
- `getDeclaredVariables` (4)
- `getDeclaredVariables` (3)
- `getDeclaredVariables` (1)
- `getDeclaredVariables` (1)
- `getDeclaredVariables` (1)
- `map` (1)
- `getDeclaredVariables` (1)
- `getDeclaredVariables` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:197` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `binop` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1865` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `_symName` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1692` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `filter` (1)

**Calls:**
- `isWrite` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` | Self: 0.0% (0us) | Total: 0.2% (9.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `isInLoop` (3)
- `isInLoop` (3)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1741` | Self: 0.0% (0us) | Total: 3.0% (95.9ms) | Samples: 0

**Called by:**
- `Program:exit` (63)

**Calls:**
- `_precomputeScopes` (45)
- `_precomputeScopes` (13)
- `_precomputeScopes` (1)
- `_precomputeScopes` (1)
- `_precomputeScopes` (1)
- `_precomputeScopes` (1)
- `_precomputeScopes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:29` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `get parent` (2)
- `get parent` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:837` | Self: 0.0% (0us) | Total: 0.9% (29.3ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (19)

**Calls:**
- `_ensureVarsSet` (19)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2870` | Self: 0.0% (0us) | Total: 0.6% (20.3ms) | Samples: 0

**Called by:**
- `_buildVariable` (13)

**Calls:**
- `nodeView` (9)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `nodeView` (1)

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

### `get id`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2257` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_buildScope` (1)

**Calls:**
- `get _tag` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:841` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `some` (1)

**Calls:**
- `get type` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:551` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isInside` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:22` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 60.8% | 1.93s | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 17.0% | 539.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 13.3% | 424.0ms | `[native code]` |
| 8.5% | 272.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.0% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.5ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/conf/globals.js` |
| 0.0% | 1.2ms | `internal:primordials` |
