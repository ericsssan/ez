# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 4.19s | 2755 | 1.0ms | 391 |

**Top 10:** `Set` 7.3%, `walkNodes` 6.1%, `defineProperties` 5.7%, `getDeclaredVariables` 3.9%, `_buildReference` 3.3%, `getDeclaredVariables` 2.5%, `get type` 2.2%, `_buildScope` 2.0%, `get` 1.8%, `_buildVariable` 1.8%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 7.3% | 306.2ms | 7.3% | 306.2ms | `Set` | `[native code]` |
| 6.1% | 256.2ms | 6.8% | 288.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6867` |
| 5.7% | 239.2ms | 5.7% | 239.2ms | `defineProperties` | `[native code]` |
| 3.9% | 167.5ms | 4.0% | 170.6ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3052` |
| 3.3% | 140.0ms | 4.0% | 169.2ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2821` |
| 2.5% | 105.4ms | 2.5% | 105.4ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3058` |
| 2.2% | 95.0ms | 2.2% | 95.0ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1006` |
| 2.0% | 86.9ms | 3.4% | 143.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1690` |
| 1.8% | 78.4ms | 1.8% | 78.4ms | `get` | `[native code]` |
| 1.8% | 75.5ms | 1.8% | 76.9ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2543` |
| 1.7% | 72.7ms | 2.2% | 92.6ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2878` |
| 1.6% | 71.1ms | 1.6% | 71.1ms | `parse` | `[native code]` |
| 1.6% | 70.9ms | 2.8% | 117.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1624` |
| 1.6% | 68.3ms | 1.6% | 69.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1222` |
| 1.2% | 54.1ms | 1.2% | 54.1ms | `set` | `[native code]` |
| 1.2% | 53.6ms | 1.2% | 53.6ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` |
| 1.2% | 51.5ms | 1.2% | 51.5ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 1.0% | 45.5ms | 1.0% | 45.5ms | `push` | `[native code]` |
| 1.0% | 45.5ms | 1.0% | 45.5ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 1.0% | 43.8ms | 2.2% | 92.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 1.0% | 42.6ms | 1.9% | 83.3ms | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:152` |
| 1.0% | 42.5ms | 1.0% | 42.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1976` |
| 0.9% | 41.7ms | 1.9% | 83.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1625` |
| 0.9% | 40.6ms | 1.0% | 43.4ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2964` |
| 0.8% | 35.8ms | 18.8% | 790.2ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2487` |
| 0.8% | 35.1ms | 0.8% | 35.1ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2798` |
| 0.8% | 33.6ms | 0.8% | 33.6ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2947` |
| 0.8% | 33.5ms | 0.8% | 33.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6623` |
| 0.7% | 33.3ms | 100.0% | 5.43s | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2930` |
| 0.7% | 32.7ms | 0.7% | 32.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1655` |
| 0.7% | 32.2ms | 0.7% | 32.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3018` |
| 0.7% | 30.1ms | 0.7% | 30.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3994` |
| 0.6% | 28.2ms | 0.6% | 28.2ms | `get _tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1072` |
| 0.6% | 27.3ms | 1.8% | 76.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2789` |
| 0.6% | 27.3ms | 8.5% | 360.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1960` |
| 0.6% | 26.8ms | 0.6% | 26.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1175` |
| 0.6% | 26.6ms | 6.3% | 265.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1892` |
| 0.6% | 25.9ms | 0.6% | 25.9ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2477` |
| 0.5% | 24.4ms | 9.6% | 403.0ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2796` |
| 0.5% | 24.3ms | 4.2% | 179.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3031` |
| 0.5% | 23.9ms | 1.8% | 78.1ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2067` |
| 0.5% | 22.9ms | 0.5% | 22.9ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2457` |
| 0.5% | 22.6ms | 1.1% | 47.4ms | `isLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:168` |
| 0.5% | 22.4ms | 0.7% | 33.2ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2534` |
| 0.5% | 21.3ms | 0.5% | 22.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1285` |
| 0.4% | 20.9ms | 0.4% | 20.9ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2750` |
| 0.4% | 20.0ms | 1.3% | 57.8ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2872` |
| 0.4% | 19.7ms | 52.2% | 2.19s | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 0.4% | 19.5ms | 4.0% | 170.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1863` |
| 0.4% | 19.4ms | 1.5% | 64.0ms | `anonymous` | `[native code]` |
| 0.4% | 19.2ms | 0.4% | 19.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.4% | 19.1ms | 21.5% | 903.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1969` |
| 0.4% | 18.6ms | 0.4% | 18.6ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3051` |
| 0.4% | 18.4ms | 0.4% | 18.4ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2344` |
| 0.4% | 17.7ms | 0.4% | 17.7ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2941` |
| 0.4% | 17.3ms | 0.4% | 18.7ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2956` |
| 0.4% | 17.2ms | 0.4% | 17.2ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.4% | 17.0ms | 0.4% | 17.0ms | `/^(?:Function(?:Declaration\|Expression)\|ArrowFunctionExpression)$/u` | `[native code]` |
| 0.4% | 16.8ms | 0.4% | 16.8ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.4% | 16.7ms | 0.4% | 16.7ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4793` |
| 0.3% | 15.3ms | 0.3% | 15.3ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.3% | 15.2ms | 4.6% | 194.6ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3050` |
| 0.3% | 15.2ms | 0.5% | 22.8ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2792` |
| 0.3% | 14.9ms | 0.3% | 14.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7035` |
| 0.3% | 14.7ms | 0.3% | 14.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1707` |
| 0.3% | 14.7ms | 0.3% | 14.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6868` |
| 0.3% | 14.7ms | 0.3% | 16.2ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:434` |
| 0.3% | 14.6ms | 0.3% | 14.6ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2874` |
| 0.3% | 14.6ms | 0.3% | 14.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3999` |
| 0.3% | 14.5ms | 0.3% | 14.5ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` |
| 0.3% | 14.5ms | 0.8% | 34.7ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1915` |
| 0.3% | 14.4ms | 0.3% | 14.4ms | `/^(?:DoWhile\|For\|ForIn\|ForOf\|While)Statement$/u` | `[native code]` |
| 0.3% | 14.2ms | 9.8% | 413.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 0.3% | 13.9ms | 0.5% | 23.5ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.3% | 13.8ms | 0.3% | 13.8ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2895` |
| 0.3% | 13.7ms | 0.3% | 13.7ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2946` |
| 0.3% | 13.5ms | 0.7% | 32.6ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:406` |
| 0.3% | 13.4ms | 0.3% | 14.7ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` |
| 0.3% | 13.2ms | 0.3% | 14.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2179` |
| 0.3% | 13.2ms | 0.3% | 13.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3025` |
| 0.3% | 12.9ms | 10.2% | 428.4ms | `some` | `[native code]` |
| 0.3% | 12.6ms | 0.6% | 27.9ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` |
| 0.2% | 12.4ms | 0.4% | 18.0ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` |
| 0.2% | 12.2ms | 0.2% | 12.2ms | `fetch` | `[native code]` |
| 0.2% | 12.0ms | 0.5% | 23.6ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` |
| 0.2% | 11.7ms | 0.2% | 11.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6612` |
| 0.2% | 11.4ms | 0.2% | 11.4ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2835` |
| 0.2% | 10.7ms | 0.2% | 10.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1962` |
| 0.2% | 10.5ms | 0.2% | 10.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` |
| 0.2% | 10.4ms | 0.2% | 10.4ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1011` |
| 0.2% | 10.2ms | 0.2% | 10.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1622` |
| 0.2% | 10.2ms | 0.2% | 10.2ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 10.1ms | 0.5% | 23.0ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2492` |
| 0.2% | 9.9ms | 0.2% | 9.9ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6362` |
| 0.2% | 9.6ms | 0.2% | 9.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2175` |
| 0.2% | 9.4ms | 4.1% | 174.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 0.2% | 9.1ms | 0.3% | 12.5ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 0.2% | 9.1ms | 0.3% | 16.3ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2437` |
| 0.2% | 9.1ms | 0.4% | 18.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1627` |
| 0.2% | 9.1ms | 0.2% | 9.1ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1013` |
| 0.2% | 9.0ms | 0.2% | 9.0ms | `has` | `[native code]` |
| 0.2% | 8.8ms | 0.2% | 8.8ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6360` |
| 0.2% | 8.6ms | 0.2% | 8.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3986` |
| 0.2% | 8.5ms | 0.2% | 8.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7034` |
| 0.2% | 8.5ms | 0.2% | 10.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1228` |
| 0.2% | 8.3ms | 0.2% | 8.3ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:619` |
| 0.1% | 8.3ms | 0.4% | 17.0ms | `async loadAndEvaluateModule` | `[native code]` |
| 0.1% | 8.1ms | 0.1% | 8.1ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3040` |
| 0.1% | 8.1ms | 0.1% | 8.1ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1019` |
| 0.1% | 8.0ms | 0.1% | 8.0ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:395` |
| 0.1% | 7.9ms | 0.3% | 15.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1730` |
| 0.1% | 7.9ms | 0.4% | 18.0ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:410` |
| 0.1% | 7.7ms | 1.0% | 44.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2516` |
| 0.1% | 7.6ms | 0.1% | 7.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4003` |
| 0.1% | 7.6ms | 0.1% | 7.6ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2915` |
| 0.1% | 7.2ms | 0.1% | 7.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4005` |
| 0.1% | 7.2ms | 0.3% | 15.9ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:682` |
| 0.1% | 7.1ms | 0.1% | 7.1ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2744` |
| 0.1% | 6.4ms | 0.1% | 6.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3996` |
| 0.1% | 6.3ms | 0.1% | 6.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1620` |
| 0.1% | 6.2ms | 0.1% | 7.9ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.1% | 6.2ms | 0.1% | 6.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3991` |
| 0.1% | 6.1ms | 0.1% | 6.1ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` |
| 0.1% | 6.1ms | 0.1% | 6.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1295` |
| 0.1% | 6.1ms | 0.1% | 6.1ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.1% | 6.0ms | 2.4% | 102.6ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 0.1% | 6.0ms | 0.1% | 6.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4011` |
| 0.1% | 6.0ms | 15.9% | 669.5ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2347` |
| 0.1% | 5.8ms | 0.1% | 5.8ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1635` |
| 0.1% | 5.6ms | 0.1% | 5.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6866` |
| 0.1% | 5.5ms | 0.1% | 5.5ms | `test` | `[native code]` |
| 0.1% | 5.1ms | 0.1% | 5.1ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:543` |
| 0.1% | 4.9ms | 0.1% | 4.9ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` |
| 0.1% | 4.8ms | 99.3% | 4.16s | `parseModule` | `[native code]` |
| 0.1% | 4.8ms | 0.1% | 4.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2641` |
| 0.1% | 4.7ms | 0.1% | 4.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1970` |
| 0.1% | 4.7ms | 87.5% | 3.67s | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2851` |
| 0.1% | 4.7ms | 7.1% | 299.8ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 0.1% | 4.6ms | 0.1% | 4.6ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 4.4ms | 0.4% | 17.3ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:180` |
| 0.1% | 4.4ms | 34.4% | 1.44s | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1828` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `/^\s*globals?\b/` | `[native code]` |
| 0.1% | 4.4ms | 0.2% | 8.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` |
| 0.1% | 4.3ms | 0.2% | 11.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` |
| 0.1% | 4.3ms | 0.1% | 4.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4001` |
| 0.1% | 4.2ms | 0.1% | 4.2ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4244` |
| 0.1% | 4.2ms | 0.1% | 4.2ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` |
| 0.0% | 3.8ms | 1.8% | 76.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1623` |
| 0.0% | 3.6ms | 0.0% | 3.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1703` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2622` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2907` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4056` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2351` |
| 0.0% | 3.2ms | 0.1% | 6.5ms | `readFileSync` | `[native code]` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1973` |
| 0.0% | 3.2ms | 0.1% | 6.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3071` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3394` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4004` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:226` |
| 0.0% | 3.0ms | 0.2% | 11.0ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.0% | 3.0ms | 0.2% | 8.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2069` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `isReadRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:431` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3032` |
| 0.0% | 3.0ms | 0.1% | 6.1ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1639` |
| 0.0% | 3.0ms | 0.2% | 9.1ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1933` |
| 0.0% | 3.0ms | 1.3% | 56.1ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 0.0% | 2.9ms | 0.1% | 4.2ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1914` |
| 0.0% | 2.9ms | 0.1% | 4.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1674` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `/^\s*exported\b/` | `[native code]` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1274` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3995` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2873` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2177` |
| 0.0% | 2.7ms | 0.2% | 10.4ms | `exec` | `[native code]` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1330` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1747` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.8ms | 0.0% | 3.4ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2909` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2183` |
| 0.0% | 1.7ms | 0.3% | 14.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2436` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:506` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `newRegistryEntry` | `[native code]` |
| 0.0% | 1.7ms | 1.3% | 54.8ms | `forEach` | `[native code]` |
| 0.0% | 1.7ms | 0.1% | 6.6ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1937` |
| 0.0% | 1.7ms | 100.0% | 4.19s | `async (anonymous)` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:508` |
| 0.0% | 1.7ms | 1.0% | 46.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `@lazy` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `values` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 0.1% | 7.8ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3610` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1772` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1935` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getUpperFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:131` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1711` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1325` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:65` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:528` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3043` |
| 0.0% | 1.6ms | 100.0% | 11.69s | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 0.0% | 1.6ms | 0.1% | 7.8ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:576` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `dlopen` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `node:fs` | `node:fs:295` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1626` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6353` |
| 0.0% | 1.6ms | 0.2% | 9.2ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2939` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2950` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1829` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3055` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1007` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1637` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get kind` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2666` |
| 0.0% | 1.5ms | 34.8% | 1.46s | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1893` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `slice` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1201` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2773` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1607` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `resolve` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:626` |
| 0.0% | 1.4ms | 0.1% | 6.3ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2865` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1674` |
| 0.0% | 1.4ms | 0.0% | 2.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1972` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:654` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4006` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1429` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getDefinedMessageData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:283` |
| 0.0% | 1.4ms | 0.0% | 3.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1237` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1067` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `decode` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:5464` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3059` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1977` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:751` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1959` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_filteredBuiltins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:275` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2257` |
| 0.0% | 1.3ms | 18.0% | 757.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2612` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 16.9% | 711.2ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1897` |
| 0.0% | 1.3ms | 92.1% | 3.86s | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2963` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:20` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1684` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3997` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getUint32` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:512` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.5% | 24.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` |
| 0.0% | 1.2ms | 0.0% | 2.5ms | `isRead` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `error` | `[native code]` |
| 0.0% | 1.1ms | 0.0% | 1.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 913us | 0.0% | 913us | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2948` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 100.0% | 11.69s | 0.0% | 1.6ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 100.0% | 5.43s | 0.7% | 33.3ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2930` |
| 100.0% | 4.19s | 0.0% | 1.7ms | `async (anonymous)` | `[native code]` |
| 99.3% | 4.16s | 0.1% | 4.8ms | `parseModule` | `[native code]` |
| 98.9% | 4.15s | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` |
| 98.9% | 4.15s | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` |
| 96.4% | 4.04s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7385` |
| 92.1% | 3.86s | 0.0% | 1.3ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2963` |
| 89.1% | 3.73s | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:66` |
| 87.5% | 3.67s | 0.1% | 4.7ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2851` |
| 86.8% | 3.64s | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4556` |
| 86.8% | 3.64s | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7101` |
| 84.3% | 3.53s | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` |
| 52.2% | 2.19s | 0.4% | 19.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 34.8% | 1.46s | 0.0% | 1.5ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1893` |
| 34.4% | 1.44s | 0.1% | 4.4ms | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1828` |
| 21.5% | 903.6ms | 0.4% | 19.1ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1969` |
| 18.8% | 790.2ms | 0.8% | 35.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2487` |
| 18.0% | 757.0ms | 0.0% | 1.3ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` |
| 17.5% | 736.1ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` |
| 16.9% | 711.2ms | 0.0% | 1.3ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1897` |
| 16.8% | 708.5ms | 0.0% | 0us | `ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1856` |
| 15.9% | 669.5ms | 0.1% | 6.0ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2347` |
| 10.2% | 428.4ms | 0.3% | 12.9ms | `some` | `[native code]` |
| 9.8% | 413.5ms | 0.3% | 14.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 9.6% | 403.0ms | 0.5% | 24.4ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2796` |
| 8.5% | 360.5ms | 0.6% | 27.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1960` |
| 7.4% | 312.0ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:62` |
| 7.3% | 306.2ms | 7.3% | 306.2ms | `Set` | `[native code]` |
| 7.1% | 299.8ms | 0.1% | 4.7ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 6.8% | 288.3ms | 6.1% | 256.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6867` |
| 6.3% | 265.9ms | 0.6% | 26.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1892` |
| 5.7% | 239.2ms | 5.7% | 239.2ms | `defineProperties` | `[native code]` |
| 4.6% | 194.6ms | 0.3% | 15.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3050` |
| 4.2% | 179.2ms | 0.5% | 24.3ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3031` |
| 4.1% | 174.4ms | 0.2% | 9.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 4.0% | 170.9ms | 0.4% | 19.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1863` |
| 4.0% | 170.6ms | 3.9% | 167.5ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3052` |
| 4.0% | 169.2ms | 3.3% | 140.0ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2821` |
| 3.4% | 143.3ms | 2.0% | 86.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1690` |
| 3.0% | 127.9ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` |
| 2.8% | 117.7ms | 1.6% | 70.9ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1624` |
| 2.5% | 105.4ms | 2.5% | 105.4ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3058` |
| 2.4% | 102.6ms | 0.1% | 6.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 2.4% | 101.7ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` |
| 2.4% | 101.7ms | 0.0% | 0us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1512` |
| 2.2% | 95.0ms | 2.2% | 95.0ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1006` |
| 2.2% | 92.6ms | 1.7% | 72.7ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2878` |
| 2.2% | 92.5ms | 1.0% | 43.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 1.9% | 83.6ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2433` |
| 1.9% | 83.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` |
| 1.9% | 83.3ms | 0.9% | 41.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1625` |
| 1.9% | 83.3ms | 1.0% | 42.6ms | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:152` |
| 1.8% | 78.4ms | 1.8% | 78.4ms | `get` | `[native code]` |
| 1.8% | 78.1ms | 0.5% | 23.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2067` |
| 1.8% | 76.9ms | 1.8% | 75.5ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2543` |
| 1.8% | 76.5ms | 0.6% | 27.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2789` |
| 1.8% | 76.4ms | 0.0% | 3.8ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1623` |
| 1.7% | 75.0ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:59` |
| 1.6% | 71.1ms | 1.6% | 71.1ms | `parse` | `[native code]` |
| 1.6% | 69.9ms | 1.6% | 68.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1222` |
| 1.6% | 69.5ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` |
| 1.5% | 64.0ms | 0.4% | 19.4ms | `anonymous` | `[native code]` |
| 1.5% | 63.1ms | 0.0% | 0us | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:179` |
| 1.4% | 62.2ms | 0.0% | 0us | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` |
| 1.3% | 57.8ms | 0.4% | 20.0ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2872` |
| 1.3% | 56.1ms | 0.0% | 3.0ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 1.3% | 54.8ms | 0.0% | 1.7ms | `forEach` | `[native code]` |
| 1.2% | 54.1ms | 1.2% | 54.1ms | `set` | `[native code]` |
| 1.2% | 53.9ms | 0.0% | 0us | `bound require` | `[native code]` |
| 1.2% | 53.6ms | 1.2% | 53.6ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` |
| 1.2% | 51.5ms | 1.2% | 51.5ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 1.2% | 50.5ms | 0.0% | 0us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4037` |
| 1.1% | 47.4ms | 0.0% | 0us | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:182` |
| 1.1% | 47.4ms | 0.5% | 22.6ms | `isLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:168` |
| 1.0% | 46.1ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` |
| 1.0% | 45.5ms | 1.0% | 45.5ms | `push` | `[native code]` |
| 1.0% | 45.5ms | 1.0% | 45.5ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 1.0% | 44.8ms | 0.1% | 7.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2516` |
| 1.0% | 44.0ms | 0.0% | 0us | `require` | `[native code]` |
| 1.0% | 43.4ms | 0.9% | 40.6ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2964` |
| 1.0% | 42.5ms | 1.0% | 42.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1976` |
| 0.8% | 35.1ms | 0.8% | 35.1ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2798` |
| 0.8% | 34.7ms | 0.3% | 14.5ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1915` |
| 0.8% | 33.6ms | 0.8% | 33.6ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2947` |
| 0.8% | 33.5ms | 0.8% | 33.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6623` |
| 0.7% | 33.2ms | 0.5% | 22.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2534` |
| 0.7% | 32.7ms | 0.7% | 32.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1655` |
| 0.7% | 32.6ms | 0.3% | 13.5ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:406` |
| 0.7% | 32.2ms | 0.7% | 32.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3018` |
| 0.7% | 31.6ms | 0.0% | 0us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1189` |
| 0.7% | 30.1ms | 0.7% | 30.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3994` |
| 0.6% | 28.2ms | 0.6% | 28.2ms | `get _tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1072` |
| 0.6% | 27.9ms | 0.3% | 12.6ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` |
| 0.6% | 27.7ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` |
| 0.6% | 26.8ms | 0.6% | 26.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1175` |
| 0.6% | 25.9ms | 0.6% | 25.9ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2477` |
| 0.5% | 24.7ms | 0.0% | 1.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` |
| 0.5% | 23.6ms | 0.2% | 12.0ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` |
| 0.5% | 23.5ms | 0.3% | 13.9ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.5% | 23.0ms | 0.2% | 10.1ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2492` |
| 0.5% | 22.9ms | 0.5% | 22.9ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2457` |
| 0.5% | 22.8ms | 0.5% | 21.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1285` |
| 0.5% | 22.8ms | 0.3% | 15.2ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2792` |
| 0.5% | 22.5ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2820` |
| 0.5% | 21.0ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2785` |
| 0.4% | 20.9ms | 0.4% | 20.9ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2750` |
| 0.4% | 20.3ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6865` |
| 0.4% | 19.2ms | 0.4% | 19.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.4% | 19.1ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4065` |
| 0.4% | 18.7ms | 0.4% | 17.3ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2956` |
| 0.4% | 18.6ms | 0.4% | 18.6ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3051` |
| 0.4% | 18.4ms | 0.4% | 18.4ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2344` |
| 0.4% | 18.2ms | 0.2% | 9.1ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1627` |
| 0.4% | 18.0ms | 0.2% | 12.4ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` |
| 0.4% | 18.0ms | 0.1% | 7.9ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:410` |
| 0.4% | 17.7ms | 0.4% | 17.7ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2941` |
| 0.4% | 17.3ms | 0.1% | 4.4ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:180` |
| 0.4% | 17.2ms | 0.4% | 17.2ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.4% | 17.0ms | 0.4% | 17.0ms | `/^(?:Function(?:Declaration\|Expression)\|ArrowFunctionExpression)$/u` | `[native code]` |
| 0.4% | 17.0ms | 0.1% | 8.3ms | `async loadAndEvaluateModule` | `[native code]` |
| 0.4% | 16.8ms | 0.4% | 16.8ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.4% | 16.7ms | 0.4% | 16.7ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4793` |
| 0.3% | 16.3ms | 0.2% | 9.1ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2437` |
| 0.3% | 16.2ms | 0.3% | 14.7ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:434` |
| 0.3% | 15.9ms | 0.1% | 7.2ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:682` |
| 0.3% | 15.3ms | 0.3% | 15.3ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.3% | 15.2ms | 0.1% | 7.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1730` |
| 0.3% | 14.9ms | 0.3% | 14.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7035` |
| 0.3% | 14.7ms | 0.3% | 14.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1707` |
| 0.3% | 14.7ms | 0.3% | 14.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6868` |
| 0.3% | 14.7ms | 0.3% | 13.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2179` |
| 0.3% | 14.7ms | 0.3% | 13.4ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` |
| 0.3% | 14.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` |
| 0.3% | 14.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` |
| 0.3% | 14.6ms | 0.3% | 14.6ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2874` |
| 0.3% | 14.6ms | 0.3% | 14.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3999` |
| 0.3% | 14.5ms | 0.3% | 14.5ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` |
| 0.3% | 14.4ms | 0.3% | 14.4ms | `/^(?:DoWhile\|For\|ForIn\|ForOf\|While)Statement$/u` | `[native code]` |
| 0.3% | 14.3ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1756` |
| 0.3% | 14.3ms | 0.0% | 0us | `ensureFenVars` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1753` |
| 0.3% | 14.0ms | 0.0% | 0us | `requestSatisfyUtil` | `[native code]` |
| 0.3% | 14.0ms | 0.0% | 0us | `requestInstantiate` | `[native code]` |
| 0.3% | 13.9ms | 0.0% | 0us | `(anonymous)` | `[native code]` |
| 0.3% | 13.8ms | 0.3% | 13.8ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2895` |
| 0.3% | 13.7ms | 0.3% | 13.7ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2946` |
| 0.3% | 13.2ms | 0.3% | 13.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3025` |
| 0.3% | 13.0ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1669` |
| 0.3% | 12.8ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:53` |
| 0.3% | 12.5ms | 0.2% | 9.1ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 0.2% | 12.2ms | 0.2% | 12.2ms | `fetch` | `[native code]` |
| 0.2% | 12.2ms | 0.0% | 0us | `requestFetch` | `[native code]` |
| 0.2% | 11.8ms | 0.1% | 4.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` |
| 0.2% | 11.7ms | 0.2% | 11.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6612` |
| 0.2% | 11.4ms | 0.2% | 11.4ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2835` |
| 0.2% | 11.1ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:54` |
| 0.2% | 11.0ms | 0.0% | 3.0ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.2% | 10.7ms | 0.2% | 10.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1962` |
| 0.2% | 10.5ms | 0.2% | 10.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` |
| 0.2% | 10.4ms | 0.0% | 2.7ms | `exec` | `[native code]` |
| 0.2% | 10.4ms | 0.2% | 10.4ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1011` |
| 0.2% | 10.2ms | 0.2% | 10.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1622` |
| 0.2% | 10.2ms | 0.2% | 10.2ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 10.2ms | 0.2% | 8.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1228` |
| 0.2% | 9.9ms | 0.2% | 9.9ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6362` |
| 0.2% | 9.6ms | 0.2% | 9.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2175` |
| 0.2% | 9.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:12` |
| 0.2% | 9.5ms | 0.0% | 0us | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1766` |
| 0.2% | 9.2ms | 0.0% | 1.6ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2939` |
| 0.2% | 9.1ms | 0.0% | 3.0ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1933` |
| 0.2% | 9.1ms | 0.2% | 9.1ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1013` |
| 0.2% | 9.0ms | 0.2% | 9.0ms | `has` | `[native code]` |
| 0.2% | 8.8ms | 0.2% | 8.8ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6360` |
| 0.2% | 8.8ms | 0.0% | 3.0ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2069` |
| 0.2% | 8.7ms | 0.1% | 4.4ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` |
| 0.2% | 8.6ms | 0.2% | 8.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3986` |
| 0.2% | 8.5ms | 0.2% | 8.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7034` |
| 0.2% | 8.3ms | 0.2% | 8.3ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:619` |
| 0.1% | 8.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` |
| 0.1% | 8.1ms | 0.1% | 8.1ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3040` |
| 0.1% | 8.1ms | 0.1% | 8.1ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1019` |
| 0.1% | 8.0ms | 0.1% | 8.0ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:395` |
| 0.1% | 7.9ms | 0.1% | 6.2ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.1% | 7.8ms | 0.0% | 1.7ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` |
| 0.1% | 7.8ms | 0.0% | 1.6ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:576` |
| 0.1% | 7.6ms | 0.1% | 7.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4003` |
| 0.1% | 7.6ms | 0.1% | 7.6ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2915` |
| 0.1% | 7.5ms | 0.0% | 0us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1255` |
| 0.1% | 7.2ms | 0.1% | 7.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4005` |
| 0.1% | 7.1ms | 0.1% | 7.1ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2744` |
| 0.1% | 7.0ms | 0.0% | 0us | `async loadModule` | `[native code]` |
| 0.1% | 6.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.1% | 6.6ms | 0.0% | 1.7ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1937` |
| 0.1% | 6.5ms | 0.0% | 3.2ms | `readFileSync` | `[native code]` |
| 0.1% | 6.4ms | 0.1% | 6.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3996` |
| 0.1% | 6.3ms | 0.1% | 6.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1620` |
| 0.1% | 6.3ms | 0.0% | 1.4ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2865` |
| 0.1% | 6.2ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:653` |
| 0.1% | 6.2ms | 0.0% | 3.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3071` |
| 0.1% | 6.2ms | 0.0% | 0us | `map` | `[native code]` |
| 0.1% | 6.2ms | 0.0% | 0us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3070` |
| 0.1% | 6.2ms | 0.1% | 6.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3991` |
| 0.1% | 6.1ms | 0.1% | 6.1ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` |
| 0.1% | 6.1ms | 0.1% | 6.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1295` |
| 0.1% | 6.1ms | 0.1% | 6.1ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.1% | 6.1ms | 0.0% | 3.0ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1639` |
| 0.1% | 6.0ms | 0.1% | 6.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4011` |
| 0.1% | 5.8ms | 0.1% | 5.8ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1635` |
| 0.1% | 5.6ms | 0.1% | 5.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6866` |
| 0.1% | 5.5ms | 0.1% | 5.5ms | `test` | `[native code]` |
| 0.1% | 5.5ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` |
| 0.1% | 5.3ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:575` |
| 0.1% | 5.1ms | 0.1% | 5.1ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:543` |
| 0.1% | 5.0ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.1% | 4.9ms | 0.1% | 4.9ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` |
| 0.1% | 4.8ms | 0.1% | 4.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2641` |
| 0.1% | 4.7ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:46` |
| 0.1% | 4.7ms | 0.1% | 4.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1970` |
| 0.1% | 4.6ms | 0.1% | 4.6ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `/^\s*globals?\b/` | `[native code]` |
| 0.1% | 4.4ms | 0.0% | 0us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1337` |
| 0.1% | 4.3ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:887` |
| 0.1% | 4.3ms | 0.1% | 4.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4001` |
| 0.1% | 4.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` |
| 0.1% | 4.2ms | 0.0% | 2.9ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.1% | 4.2ms | 0.0% | 2.9ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1914` |
| 0.1% | 4.2ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:441` |
| 0.1% | 4.2ms | 0.1% | 4.2ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4244` |
| 0.1% | 4.2ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1731` |
| 0.1% | 4.2ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:661` |
| 0.1% | 4.2ms | 0.1% | 4.2ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` |
| 0.0% | 4.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.0% | 3.6ms | 0.0% | 3.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1703` |
| 0.0% | 3.5ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:655` |
| 0.0% | 3.4ms | 0.0% | 1.8ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2909` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2622` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2907` |
| 0.0% | 3.4ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1700` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4056` |
| 0.0% | 3.3ms | 0.0% | 0us | `node:events` | `node:events:9` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2351` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:35` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1973` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3394` |
| 0.0% | 3.1ms | 0.0% | 1.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1237` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4004` |
| 0.0% | 3.0ms | 0.0% | 0us | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1801` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:226` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `isReadRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:431` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3032` |
| 0.0% | 2.9ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:45` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1674` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `/^\s*exported\b/` | `[native code]` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1274` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3995` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2873` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` |
| 0.0% | 2.7ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1638` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2177` |
| 0.0% | 2.7ms | 0.0% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1972` |
| 0.0% | 2.6ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:752` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1330` |
| 0.0% | 2.5ms | 0.0% | 1.2ms | `isRead` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1747` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2183` |
| 0.0% | 1.7ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1708` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2436` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:506` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `newRegistryEntry` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `ensureRegistered` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `requestSatisfy` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:508` |
| 0.0% | 1.7ms | 0.0% | 0us | `node:fs/promises` | `node:fs/promises:2` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `@lazy` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `internal:primordials` | `internal:primordials:71` |
| 0.0% | 1.7ms | 0.0% | 0us | `internal:validators` | `internal:validators:2` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `internal:primordials:34` |
| 0.0% | 1.7ms | 0.0% | 0us | `makeSafe` | `internal:primordials:30` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `internal:shared` | `internal:shared:2` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `values` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `bound call` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3610` |
| 0.0% | 1.6ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1483` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1772` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1935` |
| 0.0% | 1.6ms | 0.0% | 0us | `isInsideOfStorableFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:630` |
| 0.0% | 1.6ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:662` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getUpperFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:131` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1711` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1325` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:65` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:528` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3043` |
| 0.0% | 1.6ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7384` |
| 0.0% | 1.6ms | 0.0% | 0us | `tryParse` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:126` |
| 0.0% | 1.6ms | 0.0% | 0us | `_getPlugin` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:60` |
| 0.0% | 1.6ms | 0.0% | 0us | `_loadFromDisk` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:69` |
| 0.0% | 1.6ms | 0.0% | 0us | `describeRule` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:30` |
| 0.0% | 1.6ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4216` |
| 0.0% | 1.6ms | 0.0% | 0us | `loadBinding` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `dlopen` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:50` |
| 0.0% | 1.6ms | 0.0% | 0us | `getTagNames` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:186` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `node:fs` | `node:fs:295` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1626` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6353` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2950` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7377` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1829` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3055` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1007` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.0% | 0us | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2269` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1637` |
| 0.0% | 1.5ms | 0.0% | 0us | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2910` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get kind` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2666` |
| 0.0% | 1.5ms | 0.0% | 0us | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:802` |
| 0.0% | 1.5ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1636` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `slice` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 0us | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:818` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1201` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2773` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1607` |
| 0.0% | 1.4ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1680` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `resolve` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3771` |
| 0.0% | 1.4ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3789` |
| 0.0% | 1.4ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:12` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:626` |
| 0.0% | 1.4ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1640` |
| 0.0% | 1.4ms | 0.0% | 0us | `get kind` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2626` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1674` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:654` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4006` |
| 0.0% | 1.4ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1684` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1429` |
| 0.0% | 1.4ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1712` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getDefinedMessageData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:283` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1067` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4062` |
| 0.0% | 1.4ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6761` |
| 0.0% | 1.4ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7380` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `decode` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:511` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:5464` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3059` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1977` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:751` |
| 0.0% | 1.3ms | 0.0% | 0us | `_getOrBuildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5455` |
| 0.0% | 1.3ms | 0.0% | 0us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5784` |
| 0.0% | 1.3ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6526` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1959` |
| 0.0% | 1.3ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2001` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_filteredBuiltins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:275` |
| 0.0% | 1.3ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:776` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2257` |
| 0.0% | 1.3ms | 0.0% | 0us | `_nodeMods` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:928` |
| 0.0% | 1.3ms | 0.0% | 0us | `get kind` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2667` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2612` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:20` |
| 0.0% | 1.2ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1703` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1684` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3997` |
| 0.0% | 1.2ms | 0.0% | 0us | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2907` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getUint32` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:279` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:512` |
| 0.0% | 1.2ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:557` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:70` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `error` | `[native code]` |
| 0.0% | 1.1ms | 0.0% | 1.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 913us | 0.0% | 913us | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2948` |

## Function Details

### `Set`
`[native code]` | Self: 7.3% (306.2ms) | Total: 7.3% (306.2ms) | Samples: 202

**Called by:**
- `getDeclaredVariables` (103)
- `_buildScope` (99)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6867` | Self: 6.1% (256.2ms) | Total: 6.8% (288.3ms) | Samples: 173

**Called by:**
- `runPlugins` (194)

**Calls:**
- `get allSkipped` (11)
- `get allSkipped` (10)

### `defineProperties`
`[native code]` | Self: 5.7% (239.2ms) | Total: 5.7% (239.2ms) | Samples: 155

**Called by:**
- `_buildScope` (155)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3052` | Self: 3.9% (167.5ms) | Total: 4.0% (170.6ms) | Samples: 110

**Called by:**
- `isAfterLastUsedArg` (112)

**Calls:**
- `get` (1)
- `_buildVariable` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2821` | Self: 3.3% (140.0ms) | Total: 4.0% (169.2ms) | Samples: 93

**Called by:**
- `_buildVariable` (113)

**Calls:**
- `get type` (7)
- `get type` (6)
- `get type` (5)
- `get type` (1)
- `get type` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3058` | Self: 2.5% (105.4ms) | Total: 2.5% (105.4ms) | Samples: 68

**Called by:**
- `isAfterLastUsedArg` (68)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1006` | Self: 2.2% (95.0ms) | Total: 2.2% (95.0ms) | Samples: 64

**Called by:**
- `(anonymous)` (16)
- `isFunction` (10)
- `_buildReference` (7)
- `_computeIsStrict` (7)
- `isForInOfRef` (6)
- `isReadForItself` (3)
- `isForInOfRef` (3)
- `_buildScope` (2)
- `getRhsNode` (2)
- `isForInOfRef` (2)
- `collectUnusedVariables` (1)
- `(anonymous)` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)
- `_execReport` (1)
- `isLoop` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1690` | Self: 2.0% (86.9ms) | Total: 3.4% (143.3ms) | Samples: 59

**Called by:**
- `_buildScopeChildren` (97)

**Calls:**
- `_computeIsStrict` (24)
- `_computeIsStrict` (6)
- `_computeIsStrict` (4)
- `_computeIsStrict` (3)
- `_computeIsStrict` (1)

### `get`
`[native code]` | Self: 1.8% (78.4ms) | Total: 1.8% (78.4ms) | Samples: 52

**Called by:**
- `_ensureDeclSymIndex` (48)
- `_ensureDeclSymIndex` (2)
- `getDeclaredVariables` (1)
- `walkNodes` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2543` | Self: 1.8% (75.5ms) | Total: 1.8% (76.9ms) | Samples: 50

**Called by:**
- `_buildScopeVarsAndSet` (42)
- `getDeclaredVariables` (9)

**Calls:**
- `_buildThinScope` (1)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2878` | Self: 1.7% (72.7ms) | Total: 2.2% (92.6ms) | Samples: 48

**Called by:**
- `_buildThinScope` (61)

**Calls:**
- `get parent` (6)
- `get parent` (3)
- `get parent` (3)
- `get parent` (1)

### `parse`
`[native code]` | Self: 1.6% (71.1ms) | Total: 1.6% (71.1ms) | Samples: 47

**Called by:**
- `parseSource` (46)
- `tryParse` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1624` | Self: 1.6% (70.9ms) | Total: 2.8% (117.7ms) | Samples: 47

**Called by:**
- `_buildScopeVarsAndSet` (78)

**Calls:**
- `set` (31)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1222` | Self: 1.6% (68.3ms) | Total: 1.6% (69.9ms) | Samples: 44

**Called by:**
- `_buildReference` (7)
- `isInLoop` (7)
- `_buildThinVariable` (6)
- `_buildReference` (6)
- `(anonymous)` (5)
- `_findDefNode` (4)
- `_computeIsStrict` (2)
- `getRhsNode` (2)
- `isForInOfRef` (2)
- `isReadForItself` (1)
- `isRead` (1)
- `isForInOfRef` (1)
- `collectUnusedVariables` (1)

**Calls:**
- `get _tag` (1)

### `set`
`[native code]` | Self: 1.2% (54.1ms) | Total: 1.2% (54.1ms) | Samples: 36

**Called by:**
- `_ensureDeclSymIndex` (31)
- `_buildThinScope` (2)
- `_ensureDeclSymIndex` (2)
- `_buildScopeVarsAndSet` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` | Self: 1.2% (53.6ms) | Total: 1.2% (53.6ms) | Samples: 35

**Called by:**
- `_precomputeScopes` (35)

### `/\/\*([\s\S]*?)\*\//g`
`[native code]` | Self: 1.2% (51.5ms) | Total: 1.2% (51.5ms) | Samples: 34

**Called by:**
- `_buildScopeVarsAndSet` (29)
- `exec` (5)

### `push`
`[native code]` | Self: 1.0% (45.5ms) | Total: 1.0% (45.5ms) | Samples: 30

**Called by:**
- `_ensureDeclSymIndex` (27)
- `_ensureDeclSymIndex` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildVariable` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 1.0% (45.5ms) | Total: 1.0% (45.5ms) | Samples: 29

**Called by:**
- `isForInOfRef` (4)
- `isForInOfRef` (4)
- `isLoop` (4)
- `isForInOfRef` (4)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `collectUnusedVariables` (2)
- `_buildScope` (2)
- `getRhsNode` (2)
- `(anonymous)` (1)
- `isFunction` (1)
- `isReadForItself` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` | Self: 1.0% (43.8ms) | Total: 2.2% (92.5ms) | Samples: 29

**Called by:**
- `some` (61)

**Calls:**
- `get type` (16)
- `get parent` (7)
- `get parent` (5)
- `get type` (2)
- `get parent` (1)
- `get parent` (1)

### `isFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:152` | Self: 1.0% (42.6ms) | Total: 1.9% (83.3ms) | Samples: 27

**Called by:**
- `isInLoop` (41)
- `collectUnusedVariables` (13)

**Calls:**
- `/^(?:Function(?:Declaration\|Expression)\|ArrowFunctionExpression)$/u` (11)
- `get type` (10)
- `get type` (4)
- `get type` (1)
- `get type` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1976` | Self: 1.0% (42.5ms) | Total: 1.0% (42.5ms) | Samples: 28

**Called by:**
- `ensureVarsSet` (28)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1625` | Self: 0.9% (41.7ms) | Total: 1.9% (83.3ms) | Samples: 27

**Called by:**
- `_buildScopeVarsAndSet` (54)

**Calls:**
- `push` (27)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2964` | Self: 0.9% (40.6ms) | Total: 1.0% (43.4ms) | Samples: 28

**Called by:**
- `_buildThinVariable` (23)
- `_buildThinScope` (7)

**Calls:**
- `set` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2487` | Self: 0.8% (35.8ms) | Total: 18.8% (790.2ms) | Samples: 23

**Called by:**
- `_buildScopeVarsAndSet` (451)
- `getDeclaredVariables` (69)

**Calls:**
- `_buildReference` (266)
- `_buildReference` (113)
- `_buildReference` (48)
- `_buildReference` (23)
- `_buildReference` (15)
- `_buildReference` (15)
- `_buildReference` (14)
- `push` (1)
- `_buildReference` (1)
- `_buildReference` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2798` | Self: 0.8% (35.1ms) | Total: 0.8% (35.1ms) | Samples: 23

**Called by:**
- `_buildVariable` (23)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2947` | Self: 0.8% (33.6ms) | Total: 0.8% (33.6ms) | Samples: 22

**Called by:**
- `_buildThinVariable` (12)
- `_buildReference` (6)
- `_buildThinScope` (3)
- `_buildVariable` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6623` | Self: 0.8% (33.5ms) | Total: 0.8% (33.5ms) | Samples: 22

**Called by:**
- `runPlugins` (22)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2930` | Self: 0.7% (33.3ms) | Total: 100.0% (5.43s) | Samples: 22

**Called by:**
- `_buildThinScope` (2444)
- `_buildThinVariable` (881)
- `_buildReference` (223)

**Calls:**
- `_buildThinScope` (2444)
- `_buildThinScope` (1068)
- `_buildThinScope` (7)
- `_buildThinScope` (3)
- `_buildThinScope` (2)
- `_buildThinScope` (1)
- `_buildThinScope` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1655` | Self: 0.7% (32.7ms) | Total: 0.7% (32.7ms) | Samples: 21

**Called by:**
- `_buildScopeChildren` (16)
- `_buildScope` (5)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3018` | Self: 0.7% (32.2ms) | Total: 0.7% (32.2ms) | Samples: 20

**Called by:**
- `isAfterLastUsedArg` (20)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3994` | Self: 0.7% (30.1ms) | Total: 0.7% (30.1ms) | Samples: 19

**Called by:**
- `nodeViewChain` (7)
- `nodeView` (5)
- `get body` (2)
- `_buildReference` (2)
- `get body` (1)
- `_buildThinScope` (1)
- `_buildThinVariable` (1)

### `get _tag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1072` | Self: 0.6% (28.2ms) | Total: 0.6% (28.2ms) | Samples: 18

**Called by:**
- `_findDefNode` (7)
- `get parent` (4)
- `_buildScope` (1)
- `get parent` (1)
- `_findDefNode` (1)
- `init` (1)
- `get parent` (1)
- `get parent` (1)
- `get kind` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2789` | Self: 0.6% (27.3ms) | Total: 1.8% (76.5ms) | Samples: 18

**Called by:**
- `_buildVariable` (48)

**Calls:**
- `get parent` (7)
- `get parent` (6)
- `get parent` (4)
- `get parent` (4)
- `get parent` (3)
- `get parent` (3)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1960` | Self: 0.6% (27.3ms) | Total: 8.5% (360.5ms) | Samples: 17

**Called by:**
- `ensureVarsSet` (237)

**Calls:**
- `_ensureDeclSymIndex` (78)
- `_ensureDeclSymIndex` (54)
- `_ensureDeclSymIndex` (51)
- `_ensureDeclSymIndex` (12)
- `_ensureDeclSymIndex` (7)
- `_ensureDeclSymIndex` (4)
- `_ensureDeclSymIndex` (4)
- `_ensureDeclSymIndex` (4)
- `_ensureDeclSymIndex` (2)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1175` | Self: 0.6% (26.8ms) | Total: 0.6% (26.8ms) | Samples: 17

**Called by:**
- `_buildReference` (6)
- `_buildVariable` (5)
- `_buildReference` (2)
- `isReadForItself` (2)
- `_computeIsStrict` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1892` | Self: 0.6% (26.6ms) | Total: 6.3% (265.9ms) | Samples: 17

**Called by:**
- `_buildScopeChildren` (171)
- `_buildScope` (1)

**Calls:**
- `defineProperties` (155)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2477` | Self: 0.6% (25.9ms) | Total: 0.6% (25.9ms) | Samples: 17

**Called by:**
- `_buildScopeVarsAndSet` (13)
- `getDeclaredVariables` (4)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2796` | Self: 0.5% (24.4ms) | Total: 9.6% (403.0ms) | Samples: 16

**Called by:**
- `_buildVariable` (266)

**Calls:**
- `_buildThinScope` (223)
- `_buildThinScope` (7)
- `_buildThinScope` (7)
- `_buildThinScope` (6)
- `_buildThinScope` (3)
- `_buildThinScope` (2)
- `_buildThinScope` (2)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3031` | Self: 0.5% (24.3ms) | Total: 4.2% (179.2ms) | Samples: 16

**Called by:**
- `isAfterLastUsedArg` (119)

**Calls:**
- `Set` (103)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2067` | Self: 0.5% (23.9ms) | Total: 1.8% (78.1ms) | Samples: 16

**Called by:**
- `ensureVarsSet` (52)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (29)
- `exec` (7)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2457` | Self: 0.5% (22.9ms) | Total: 0.5% (22.9ms) | Samples: 16

**Called by:**
- `_buildScopeVarsAndSet` (9)
- `getDeclaredVariables` (7)

### `isLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:168` | Self: 0.5% (22.6ms) | Total: 1.1% (47.4ms) | Samples: 15

**Called by:**
- `isInLoop` (32)

**Calls:**
- `/^(?:DoWhile\|For\|ForIn\|ForOf\|While)Statement$/u` (10)
- `get type` (4)
- `get type` (2)
- `get type` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2534` | Self: 0.5% (22.4ms) | Total: 0.7% (33.2ms) | Samples: 14

**Called by:**
- `_buildScopeVarsAndSet` (20)
- `getDeclaredVariables` (1)

**Calls:**
- `get parent` (5)
- `get parent` (2)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1285` | Self: 0.5% (21.3ms) | Total: 0.5% (22.8ms) | Samples: 13

**Called by:**
- `_buildReference` (4)
- `_findDefNode` (3)
- `_buildThinVariable` (3)
- `_buildReference` (2)
- `(anonymous)` (1)
- `isForInOfRef` (1)

**Calls:**
- `get _tag` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2750` | Self: 0.4% (20.9ms) | Total: 0.4% (20.9ms) | Samples: 14

**Called by:**
- `_buildScopeVarsAndSet` (12)
- `getDeclaredVariables` (2)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2872` | Self: 0.4% (20.0ms) | Total: 1.3% (57.8ms) | Samples: 13

**Called by:**
- `_buildThinScope` (37)

**Calls:**
- `_findDefNode` (15)
- `_findDefNode` (5)
- `_findDefNode` (4)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` | Self: 0.4% (19.7ms) | Total: 52.2% (2.19s) | Samples: 14

**Called by:**
- `collectUnusedVariables` (941)
- `Program:exit` (502)

**Calls:**
- `get` (954)
- `get` (466)
- `get` (9)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1863` | Self: 0.4% (19.5ms) | Total: 4.0% (170.9ms) | Samples: 13

**Called by:**
- `_buildScopeChildren` (112)

**Calls:**
- `Set` (99)

### `anonymous`
`[native code]` | Self: 0.4% (19.4ms) | Total: 1.5% (64.0ms) | Samples: 13

**Called by:**
- `require` (31)
- `bound require` (5)
- `node:fs` (3)
- `node:events` (2)
- `internal:shared` (1)
- `internal:validators` (1)

**Calls:**
- `(anonymous)` (7)
- `(anonymous)` (5)
- `(anonymous)` (3)
- `node:fs` (3)
- `(anonymous)` (2)
- `node:events` (2)
- `(anonymous)` (1)
- `node:fs` (1)
- `internal:shared` (1)
- `(anonymous)` (1)
- `node:fs/promises` (1)
- `internal:primordials` (1)
- `(anonymous)` (1)
- `internal:validators` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.4% (19.2ms) | Total: 0.4% (19.2ms) | Samples: 13

**Called by:**
- `_computeIsStrict` (3)
- `_buildThinVariable` (3)
- `_buildVariable` (2)
- `collectUnusedVariables` (2)
- `(anonymous)` (1)
- `isReadForItself` (1)
- `_buildReference` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1969` | Self: 0.4% (19.1ms) | Total: 21.5% (903.6ms) | Samples: 13

**Called by:**
- `ensureVarsSet` (589)
- `ensureVarsSet` (6)

**Calls:**
- `_buildVariable` (451)
- `_buildVariable` (42)
- `_buildVariable` (20)
- `_buildVariable` (18)
- `_buildVariable` (14)
- `_buildVariable` (13)
- `_buildVariable` (12)
- `_buildVariable` (9)
- `_buildVariable` (2)
- `_buildVariable` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3051` | Self: 0.4% (18.6ms) | Total: 0.4% (18.6ms) | Samples: 12

**Called by:**
- `isAfterLastUsedArg` (12)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2344` | Self: 0.4% (18.4ms) | Total: 0.4% (18.4ms) | Samples: 12

**Called by:**
- `ensureChildren` (12)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2941` | Self: 0.4% (17.7ms) | Total: 0.4% (17.7ms) | Samples: 12

**Called by:**
- `_buildReference` (7)
- `_buildThinVariable` (4)
- `_buildThinScope` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2956` | Self: 0.4% (17.3ms) | Total: 0.4% (18.7ms) | Samples: 12

**Called by:**
- `_buildReference` (7)
- `_buildThinVariable` (5)
- `_buildThinScope` (1)

**Calls:**
- `_ensureDeclSymIndex` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.4% (17.2ms) | Total: 0.4% (17.2ms) | Samples: 11

**Called by:**
- `ensureChildren` (11)

### `/^(?:Function(?:Declaration\|Expression)\|ArrowFunctionExpression)$/u`
`[native code]` | Self: 0.4% (17.0ms) | Total: 0.4% (17.0ms) | Samples: 11

**Called by:**
- `isFunction` (11)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` | Self: 0.4% (16.8ms) | Total: 0.4% (16.8ms) | Samples: 12

**Called by:**
- `collectUnusedVariables` (12)

### `get allSkipped`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4793` | Self: 0.4% (16.7ms) | Total: 0.4% (16.7ms) | Samples: 11

**Called by:**
- `walkNodes` (11)

### `get allSkipped`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.3% (15.3ms) | Total: 0.3% (15.3ms) | Samples: 10

**Called by:**
- `walkNodes` (10)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3050` | Self: 0.3% (15.2ms) | Total: 4.6% (194.6ms) | Samples: 10

**Called by:**
- `isAfterLastUsedArg` (128)

**Calls:**
- `_buildVariable` (69)
- `_buildVariable` (11)
- `_buildVariable` (9)
- `_buildVariable` (7)
- `_buildVariable` (5)
- `_buildVariable` (4)
- `_buildVariable` (3)
- `_buildVariable` (2)
- `_buildVariable` (2)
- `_buildVariable` (2)
- `_buildVariable` (2)
- `_buildVariable` (1)
- `_buildVariable` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2792` | Self: 0.3% (15.2ms) | Total: 0.5% (22.8ms) | Samples: 10

**Called by:**
- `_buildVariable` (15)

**Calls:**
- `_buildThinVariable` (2)
- `_buildThinVariable` (1)
- `_buildThinVariable` (1)
- `_buildThinVariable` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7035` | Self: 0.3% (14.9ms) | Total: 0.3% (14.9ms) | Samples: 10

**Called by:**
- `runPlugins` (10)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1707` | Self: 0.3% (14.7ms) | Total: 0.3% (14.7ms) | Samples: 10

**Called by:**
- `_buildScopeChildren` (9)
- `_buildScope` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6868` | Self: 0.3% (14.7ms) | Total: 0.3% (14.7ms) | Samples: 10

**Called by:**
- `runPlugins` (10)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:434` | Self: 0.3% (14.7ms) | Total: 0.3% (16.2ms) | Samples: 9

**Called by:**
- `_buildVariable` (6)
- `_buildThinVariable` (4)

**Calls:**
- `get _tag` (1)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2874` | Self: 0.3% (14.6ms) | Total: 0.3% (14.6ms) | Samples: 10

**Called by:**
- `_buildThinScope` (10)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3999` | Self: 0.3% (14.6ms) | Total: 0.3% (14.6ms) | Samples: 10

**Called by:**
- `nodeView` (9)
- `nodeViewChain` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` | Self: 0.3% (14.5ms) | Total: 0.3% (14.5ms) | Samples: 10

**Called by:**
- `(anonymous)` (10)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1915` | Self: 0.3% (14.5ms) | Total: 0.8% (34.7ms) | Samples: 10

**Called by:**
- `_buildScope` (24)

**Calls:**
- `get type` (7)
- `get parent` (3)
- `get parent` (2)
- `get parent` (2)

### `/^(?:DoWhile\|For\|ForIn\|ForOf\|While)Statement$/u`
`[native code]` | Self: 0.3% (14.4ms) | Total: 0.3% (14.4ms) | Samples: 10

**Called by:**
- `isLoop` (10)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` | Self: 0.3% (14.2ms) | Total: 9.8% (413.5ms) | Samples: 9

**Called by:**
- `collectUnusedVariables` (269)

**Calls:**
- `isUsedVariable` (196)
- `isUsedVariable` (40)
- `some` (21)
- `isUsedVariable` (3)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` | Self: 0.3% (13.9ms) | Total: 0.5% (23.5ms) | Samples: 9

**Called by:**
- `collectUnusedVariables` (15)

**Calls:**
- `get parent` (3)
- `get type` (2)
- `get type` (1)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2895` | Self: 0.3% (13.8ms) | Total: 0.3% (13.8ms) | Samples: 9

**Called by:**
- `_buildThinScope` (9)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2946` | Self: 0.3% (13.7ms) | Total: 0.3% (13.7ms) | Samples: 8

**Called by:**
- `_buildThinVariable` (4)
- `_buildReference` (2)
- `_buildThinScope` (2)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:406` | Self: 0.3% (13.5ms) | Total: 0.7% (32.6ms) | Samples: 9

**Called by:**
- `_buildThinVariable` (15)
- `_buildVariable` (6)

**Calls:**
- `get parent` (4)
- `get parent` (3)
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `isSelfReference`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` | Self: 0.3% (13.4ms) | Total: 0.3% (14.7ms) | Samples: 9

**Called by:**
- `(anonymous)` (10)

**Calls:**
- `isRead` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2179` | Self: 0.3% (13.2ms) | Total: 0.3% (14.7ms) | Samples: 9

**Called by:**
- `ensureVarsSet` (10)

**Calls:**
- `set` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3025` | Self: 0.3% (13.2ms) | Total: 0.3% (13.2ms) | Samples: 8

**Called by:**
- `isAfterLastUsedArg` (8)

### `some`
`[native code]` | Self: 0.3% (12.9ms) | Total: 10.2% (428.4ms) | Samples: 9

**Called by:**
- `isUsedVariable` (193)
- `collectUnusedVariables` (64)
- `collectUnusedVariables` (21)
- `isAfterLastUsedArg` (2)
- `Program:exit` (1)

**Calls:**
- `(anonymous)` (114)
- `(anonymous)` (61)
- `(anonymous)` (54)
- `(anonymous)` (30)
- `(anonymous)` (10)
- `(anonymous)` (3)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` | Self: 0.3% (12.6ms) | Total: 0.6% (27.9ms) | Samples: 8

**Called by:**
- `(anonymous)` (18)

**Calls:**
- `get type` (6)
- `get type` (4)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` | Self: 0.2% (12.4ms) | Total: 0.4% (18.0ms) | Samples: 8

**Called by:**
- `(anonymous)` (12)

**Calls:**
- `get type` (2)
- `get type` (2)

### `fetch`
`[native code]` | Self: 0.2% (12.2ms) | Total: 0.2% (12.2ms) | Samples: 8

**Called by:**
- `requestFetch` (8)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` | Self: 0.2% (12.0ms) | Total: 0.5% (23.6ms) | Samples: 8

**Called by:**
- `(anonymous)` (15)

**Calls:**
- `get type` (4)
- `get type` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6612` | Self: 0.2% (11.7ms) | Total: 0.2% (11.7ms) | Samples: 8

**Called by:**
- `runPlugins` (8)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2835` | Self: 0.2% (11.4ms) | Total: 0.2% (11.4ms) | Samples: 8

**Called by:**
- `_buildThinScope` (7)
- `_buildReference` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1962` | Self: 0.2% (10.7ms) | Total: 0.2% (10.7ms) | Samples: 7

**Called by:**
- `ensureVarsSet` (7)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` | Self: 0.2% (10.5ms) | Total: 0.2% (10.5ms) | Samples: 7

**Called by:**
- `_precomputeScopes` (7)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1011` | Self: 0.2% (10.4ms) | Total: 0.2% (10.4ms) | Samples: 7

**Called by:**
- `isFunction` (4)
- `isLoop` (2)
- `_buildReference` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1622` | Self: 0.2% (10.2ms) | Total: 0.2% (10.2ms) | Samples: 7

**Called by:**
- `_buildScopeVarsAndSet` (7)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.2% (10.2ms) | Total: 0.2% (10.2ms) | Samples: 7

**Called by:**
- `getDeclaredVariables` (5)
- `getDeclaredVariables` (1)
- `_buildScopeVarsAndSet` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2492` | Self: 0.2% (10.1ms) | Total: 0.5% (23.0ms) | Samples: 7

**Called by:**
- `_buildScopeVarsAndSet` (14)
- `getDeclaredVariables` (2)

**Calls:**
- `_nodeViewRaw` (5)
- `nodeView` (3)
- `_nodeViewRaw` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6362` | Self: 0.2% (9.9ms) | Total: 0.2% (9.9ms) | Samples: 6

**Called by:**
- `walkNodes` (6)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2175` | Self: 0.2% (9.6ms) | Total: 0.2% (9.6ms) | Samples: 6

**Called by:**
- `ensureVarsSet` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` | Self: 0.2% (9.4ms) | Total: 4.1% (174.4ms) | Samples: 6

**Called by:**
- `some` (114)

**Calls:**
- `getRhsNode` (84)
- `getRhsNode` (12)
- `getRhsNode` (8)
- `getRhsNode` (3)
- `getRhsNode` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` | Self: 0.2% (9.1ms) | Total: 0.3% (12.5ms) | Samples: 6

**Called by:**
- `(anonymous)` (8)

**Calls:**
- `get parent` (2)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2437` | Self: 0.2% (9.1ms) | Total: 0.3% (16.3ms) | Samples: 6

**Called by:**
- `getScope` (11)

**Calls:**
- `test` (3)
- `/^\s*exported\b/` (2)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1627` | Self: 0.2% (9.1ms) | Total: 0.4% (18.2ms) | Samples: 6

**Called by:**
- `_buildScopeVarsAndSet` (12)

**Calls:**
- `has` (6)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1013` | Self: 0.2% (9.1ms) | Total: 0.2% (9.1ms) | Samples: 6

**Called by:**
- `_buildReference` (6)

### `has`
`[native code]` | Self: 0.2% (9.0ms) | Total: 0.2% (9.0ms) | Samples: 6

**Called by:**
- `_ensureDeclSymIndex` (6)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6360` | Self: 0.2% (8.8ms) | Total: 0.2% (8.8ms) | Samples: 6

**Called by:**
- `walkNodes` (6)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3986` | Self: 0.2% (8.6ms) | Total: 0.2% (8.6ms) | Samples: 6

**Called by:**
- `_buildVariable` (5)
- `_buildThinVariable` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7034` | Self: 0.2% (8.5ms) | Total: 0.2% (8.5ms) | Samples: 6

**Called by:**
- `runPlugins` (6)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1228` | Self: 0.2% (8.5ms) | Total: 0.2% (10.2ms) | Samples: 6

**Called by:**
- `_buildReference` (3)
- `_buildReference` (3)
- `_findDefNode` (1)

**Calls:**
- `get value` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:619` | Self: 0.2% (8.3ms) | Total: 0.2% (8.3ms) | Samples: 6

**Called by:**
- `commentsInRange` (4)
- `commentsInRange` (2)

### `async loadAndEvaluateModule`
`[native code]` | Self: 0.1% (8.3ms) | Total: 0.4% (17.0ms) | Samples: 2

**Called by:**
- `async loadAndEvaluateModule` (3)

**Calls:**
- `async loadAndEvaluateModule` (3)
- `async loadModule` (2)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3040` | Self: 0.1% (8.1ms) | Total: 0.1% (8.1ms) | Samples: 5

**Called by:**
- `isAfterLastUsedArg` (5)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1019` | Self: 0.1% (8.1ms) | Total: 0.1% (8.1ms) | Samples: 6

**Called by:**
- `_buildReference` (5)
- `isFunction` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:395` | Self: 0.1% (8.0ms) | Total: 0.1% (8.0ms) | Samples: 5

**Called by:**
- `_buildVariable` (5)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1730` | Self: 0.1% (7.9ms) | Total: 0.3% (15.2ms) | Samples: 5

**Called by:**
- `_buildScopeChildren` (10)

**Calls:**
- `get type` (2)
- `get type` (2)
- `get type` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:410` | Self: 0.1% (7.9ms) | Total: 0.4% (18.0ms) | Samples: 5

**Called by:**
- `_buildVariable` (7)
- `_buildThinVariable` (5)

**Calls:**
- `get _tag` (7)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2516` | Self: 0.1% (7.7ms) | Total: 1.0% (44.8ms) | Samples: 5

**Called by:**
- `_buildScopeVarsAndSet` (18)
- `getDeclaredVariables` (11)

**Calls:**
- `_findDefNode` (7)
- `_findDefNode` (6)
- `_findDefNode` (6)
- `_findDefNode` (5)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4003` | Self: 0.1% (7.6ms) | Total: 0.1% (7.6ms) | Samples: 5

**Called by:**
- `nodeView` (5)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2915` | Self: 0.1% (7.6ms) | Total: 0.1% (7.6ms) | Samples: 5

**Called by:**
- `_buildReference` (3)
- `_buildThinVariable` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4005` | Self: 0.1% (7.2ms) | Total: 0.1% (7.2ms) | Samples: 5

**Called by:**
- `nodeView` (2)
- `_buildReference` (2)
- `_buildThinScope` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:682` | Self: 0.1% (7.2ms) | Total: 0.3% (15.9ms) | Samples: 5

**Called by:**
- `(anonymous)` (11)

**Calls:**
- `get type` (4)
- `get type` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2744` | Self: 0.1% (7.1ms) | Total: 0.1% (7.1ms) | Samples: 5

**Called by:**
- `getDeclaredVariables` (3)
- `_buildScopeVarsAndSet` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3996` | Self: 0.1% (6.4ms) | Total: 0.1% (6.4ms) | Samples: 4

**Called by:**
- `nodeView` (4)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1620` | Self: 0.1% (6.3ms) | Total: 0.1% (6.3ms) | Samples: 4

**Called by:**
- `_buildScopeVarsAndSet` (4)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` | Self: 0.1% (6.2ms) | Total: 0.1% (7.9ms) | Samples: 4

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `get parent` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3991` | Self: 0.1% (6.2ms) | Total: 0.1% (6.2ms) | Samples: 4

**Called by:**
- `nodeView` (2)
- `(anonymous)` (1)
- `_buildVariable` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` | Self: 0.1% (6.1ms) | Total: 0.1% (6.1ms) | Samples: 4

**Called by:**
- `_precomputeScopes` (4)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1295` | Self: 0.1% (6.1ms) | Total: 0.1% (6.1ms) | Samples: 4

**Called by:**
- `_findDefNode` (2)
- `isReadForItself` (1)
- `_buildReference` (1)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` | Self: 0.1% (6.1ms) | Total: 0.1% (6.1ms) | Samples: 4

**Called by:**
- `isUsedVariable` (4)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` | Self: 0.1% (6.0ms) | Total: 2.4% (102.6ms) | Samples: 4

**Called by:**
- `collectUnusedVariables` (68)

**Calls:**
- `some` (64)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4011` | Self: 0.1% (6.0ms) | Total: 0.1% (6.0ms) | Samples: 4

**Called by:**
- `nodeViewChain` (4)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2347` | Self: 0.1% (6.0ms) | Total: 15.9% (669.5ms) | Samples: 4

**Called by:**
- `ensureChildren` (439)

**Calls:**
- `_buildScope` (171)
- `_buildScope` (112)
- `_buildScope` (97)
- `_buildScope` (16)
- `_buildScope` (10)
- `_buildScope` (9)
- `_buildScope` (8)
- `_buildScope` (3)
- `_buildScope` (2)
- `_buildScope` (2)
- `_buildScope` (2)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1635` | Self: 0.1% (5.8ms) | Total: 0.1% (5.8ms) | Samples: 4

**Called by:**
- `_buildScopeVarsAndSet` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6866` | Self: 0.1% (5.6ms) | Total: 0.1% (5.6ms) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `test`
`[native code]` | Self: 0.1% (5.5ms) | Total: 0.1% (5.5ms) | Samples: 4

**Called by:**
- `_precomputeScopes` (3)
- `_buildScopeVarsAndSet` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:543` | Self: 0.1% (5.1ms) | Total: 0.1% (5.1ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` | Self: 0.1% (4.9ms) | Total: 0.1% (4.9ms) | Samples: 3

**Called by:**
- `collectUnusedVariables` (3)

### `parseModule`
`[native code]` | Self: 0.1% (4.8ms) | Total: 99.3% (4.16s) | Samples: 2

**Called by:**
- `async (anonymous)` (2742)

**Calls:**
- `(anonymous)` (2732)
- `(anonymous)` (5)
- `(anonymous)` (2)
- `(anonymous)` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2641` | Self: 0.1% (4.8ms) | Total: 0.1% (4.8ms) | Samples: 2

**Called by:**
- `getDeclaredVariables` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1970` | Self: 0.1% (4.7ms) | Total: 0.1% (4.7ms) | Samples: 3

**Called by:**
- `ensureVarsSet` (3)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2851` | Self: 0.1% (4.7ms) | Total: 87.5% (3.67s) | Samples: 3

**Called by:**
- `_buildThinScope` (2407)

**Calls:**
- `_buildThinScope` (1467)
- `_buildThinScope` (881)
- `_buildThinScope` (23)
- `_buildThinScope` (12)
- `_buildThinScope` (5)
- `_buildThinScope` (4)
- `_buildThinScope` (4)
- `_buildThinScope` (4)
- `_buildThinScope` (2)
- `_buildThinScope` (1)
- `_buildThinScope` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` | Self: 0.1% (4.7ms) | Total: 7.1% (299.8ms) | Samples: 3

**Called by:**
- `collectUnusedVariables` (196)

**Calls:**
- `some` (193)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (4.6ms) | Total: 0.1% (4.6ms) | Samples: 3

**Called by:**
- `_buildVariable` (3)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:180` | Self: 0.1% (4.4ms) | Total: 0.4% (17.3ms) | Samples: 3

**Called by:**
- `getRhsNode` (11)

**Calls:**
- `get parent` (7)
- `get parent` (1)

### `ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1828` | Self: 0.1% (4.4ms) | Total: 34.4% (1.44s) | Samples: 3

**Called by:**
- `get` (952)

**Calls:**
- `_buildScopeVarsAndSet` (589)
- `_buildScopeVarsAndSet` (237)
- `_buildScopeVarsAndSet` (52)
- `_buildScopeVarsAndSet` (28)
- `_buildScopeVarsAndSet` (10)
- `_buildScopeVarsAndSet` (7)
- `_buildScopeVarsAndSet` (6)
- `_buildScopeVarsAndSet` (6)
- `_buildScopeVarsAndSet` (3)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)

### `/^\s*globals?\b/`
`[native code]` | Self: 0.1% (4.4ms) | Total: 0.1% (4.4ms) | Samples: 3

**Called by:**
- `_buildScopeVarsAndSet` (3)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` | Self: 0.1% (4.4ms) | Total: 0.2% (8.7ms) | Samples: 3

**Called by:**
- `collectUnusedVariables` (6)

**Calls:**
- `get parent` (2)
- `get type` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` | Self: 0.1% (4.3ms) | Total: 0.2% (11.8ms) | Samples: 3

**Called by:**
- `forEach` (8)

**Calls:**
- `get type` (2)
- `init` (1)
- `get type` (1)
- `nodeViewChain` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4001` | Self: 0.1% (4.3ms) | Total: 0.1% (4.3ms) | Samples: 3

**Called by:**
- `get parent` (1)
- `_buildThinScope` (1)
- `(anonymous)` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4244` | Self: 0.1% (4.2ms) | Total: 0.1% (4.2ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `isInside`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` | Self: 0.1% (4.2ms) | Total: 0.1% (4.2ms) | Samples: 3

**Called by:**
- `isReadForItself` (3)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1623` | Self: 0.0% (3.8ms) | Total: 1.8% (76.4ms) | Samples: 3

**Called by:**
- `_buildScopeVarsAndSet` (51)

**Calls:**
- `get` (48)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1703` | Self: 0.0% (3.6ms) | Total: 0.0% (3.6ms) | Samples: 2

**Called by:**
- `_buildScopeChildren` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2622` | Self: 0.0% (3.4ms) | Total: 0.0% (3.4ms) | Samples: 2

**Called by:**
- `getDeclaredVariables` (2)

### `get init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2907` | Self: 0.0% (3.4ms) | Total: 0.0% (3.4ms) | Samples: 2

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4056` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2351` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `ensureChildren` (2)

### `readFileSync`
`[native code]` | Self: 0.0% (3.2ms) | Total: 0.1% (6.5ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)
- `readFileSync` (2)

**Calls:**
- `readFileSync` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1973` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `ensureVarsSet` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3071` | Self: 0.0% (3.2ms) | Total: 0.1% (6.2ms) | Samples: 2

**Called by:**
- `map` (4)

**Calls:**
- `get name` (1)
- `get name` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `_buildScopeChildren` (2)

### `get directive`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3394` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `_computeIsStrict` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4004` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `nodeView` (2)

### `_resolveUnicodeEscapes`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:226` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `get name` (2)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` | Self: 0.0% (3.0ms) | Total: 0.2% (11.0ms) | Samples: 2

**Called by:**
- `(anonymous)` (7)

**Calls:**
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2069` | Self: 0.0% (3.0ms) | Total: 0.2% (8.8ms) | Samples: 2

**Called by:**
- `ensureVarsSet` (6)

**Calls:**
- `/^\s*globals?\b/` (3)
- `test` (1)

### `isReadRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:431` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3032` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `isAfterLastUsedArg` (2)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1639` | Self: 0.0% (3.0ms) | Total: 0.1% (6.1ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (4)

**Calls:**
- `set` (2)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1933` | Self: 0.0% (3.0ms) | Total: 0.2% (9.1ms) | Samples: 2

**Called by:**
- `_buildScope` (6)

**Calls:**
- `get body` (2)
- `get body` (1)
- `get body` (1)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` | Self: 0.0% (3.0ms) | Total: 1.3% (56.1ms) | Samples: 2

**Called by:**
- `isUsedVariable` (36)

**Calls:**
- `forEach` (34)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1914` | Self: 0.0% (2.9ms) | Total: 0.1% (4.2ms) | Samples: 2

**Called by:**
- `_buildScope` (3)

**Calls:**
- `get parent` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` | Self: 0.0% (2.9ms) | Total: 0.1% (4.2ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (3)

**Calls:**
- `get type` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1674` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `_buildScopeChildren` (2)

### `nodeRhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `init` (1)
- `_nodeMods` (1)

### `/^\s*exported\b/`
`[native code]` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `_precomputeScopes` (2)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1274` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `_buildReference` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3995` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `nodeView` (2)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2873` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `_buildReference` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2177` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `ensureVarsSet` (2)

### `exec`
`[native code]` | Self: 0.0% (2.7ms) | Total: 0.2% (10.4ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (7)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (5)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1330` | Self: 0.0% (2.6ms) | Total: 0.0% (2.6ms) | Samples: 2

**Called by:**
- `_buildScope` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1747` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2909` | Self: 0.0% (1.8ms) | Total: 0.0% (3.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `nodeLhs` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2183` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `ensureVarsSet` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` | Self: 0.0% (1.7ms) | Total: 0.3% (14.7ms) | Samples: 1

**Called by:**
- `forEach` (9)

**Calls:**
- `nodeViewChain` (3)
- `init` (2)
- `get type` (1)
- `get init` (1)
- `_nodeViewRaw` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2436` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getScope` (1)

### `isUnusedExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:506` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `isReadForItself` (1)

### `newRegistryEntry`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `ensureRegistered` (1)

### `forEach`
`[native code]` | Self: 0.0% (1.7ms) | Total: 1.3% (54.8ms) | Samples: 1

**Called by:**
- `getFunctionDefinitions` (34)
- `bound call` (1)

**Calls:**
- `(anonymous)` (16)
- `(anonymous)` (9)
- `(anonymous)` (8)
- `(anonymous)` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1937` | Self: 0.0% (1.7ms) | Total: 0.1% (6.6ms) | Samples: 1

**Called by:**
- `_buildScope` (4)

**Calls:**
- `get directive` (2)
- `get directive` (1)

### `async (anonymous)`
`[native code]` | Self: 0.0% (1.7ms) | Total: 100.0% (4.19s) | Samples: 1

**Called by:**
- `async (anonymous)` (9)
- `requestInstantiate` (9)

**Calls:**
- `parseModule` (2742)
- `async (anonymous)` (9)
- `requestFetch` (8)
- `resolve` (1)

### `isUnusedExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:508` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `isReadForItself` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` | Self: 0.0% (1.7ms) | Total: 1.0% (46.1ms) | Samples: 1

**Called by:**
- `some` (30)

**Calls:**
- `isReadForItself` (10)
- `isReadForItself` (7)
- `isReadForItself` (4)
- `isReadForItself` (3)
- `isReadForItself` (2)
- `isReadForItself` (1)
- `isReadForItself` (1)
- `isReadForItself` (1)

### `@lazy`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `node:fs/promises` (1)

### `values`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `commentsInRange` (1)

### `get directive`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` | Self: 0.0% (1.7ms) | Total: 0.1% (7.8ms) | Samples: 1

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3610` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `get value` (1)

### `ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1772` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `get` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1935` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `getUpperFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:131` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `isInsideOfStorableFunction` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1711` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1325` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:65` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `async (anonymous)` (1)

### `nodeLhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:528` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `init` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3043` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` | Self: 0.0% (1.6ms) | Total: 100.0% (11.69s) | Samples: 1

**Called by:**
- `collectUnusedVariables` (5833)
- `Program:exit` (1821)

**Calls:**
- `collectUnusedVariables` (5833)
- `collectUnusedVariables` (941)
- `collectUnusedVariables` (496)
- `collectUnusedVariables` (269)
- `collectUnusedVariables` (68)
- `collectUnusedVariables` (18)
- `collectUnusedVariables` (15)
- `collectUnusedVariables` (6)
- `collectUnusedVariables` (3)
- `collectUnusedVariables` (3)
- `collectUnusedVariables` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:576` | Self: 0.0% (1.6ms) | Total: 0.1% (7.8ms) | Samples: 1

**Called by:**
- `_precomputeScopes` (5)

**Calls:**
- `_findLineIdx` (2)
- `_findLineIdx` (1)
- `_findLineIdx` (1)

### `dlopen`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `node:fs`
`node:fs:295` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `anonymous` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1626` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6353` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2939` | Self: 0.0% (1.6ms) | Total: 0.2% (9.2ms) | Samples: 1

**Called by:**
- `_buildThinVariable` (4)
- `_buildReference` (2)

**Calls:**
- `nodeView` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2950` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildThinVariable` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1829` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `get` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3055` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1007` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `extraFnData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `get id` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1637` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `get kind`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2666` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1893` | Self: 0.0% (1.5ms) | Total: 34.8% (1.46s) | Samples: 1

**Called by:**
- `collectUnusedVariables` (954)
- `ensureFenVars` (9)

**Calls:**
- `ensureVarsSet` (952)
- `ensureVarsSet` (6)
- `ensureVarsSet` (2)
- `ensureVarsSet` (1)
- `ensureVarsSet` (1)

### `slice`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildSymNameCache` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1201` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_findDefNode` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2773` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildVariable` (1)

### `get init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1607` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildThinScope` (1)

### `resolve`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `async (anonymous)` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:626` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `commentsInRange` (1)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2865` | Self: 0.0% (1.4ms) | Total: 0.1% (6.3ms) | Samples: 1

**Called by:**
- `_buildThinScope` (3)
- `_buildReference` (1)

**Calls:**
- `_nodeViewRaw` (1)
- `nodeView` (1)
- `_nodeViewRaw` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1674` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1972` | Self: 0.0% (1.4ms) | Total: 0.0% (2.7ms) | Samples: 1

**Called by:**
- `ensureVarsSet` (2)

**Calls:**
- `push` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:654` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4006` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `nodeView` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1429` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `getDefinedMessageData`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:283` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `Program:exit` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1237` | Self: 0.0% (1.4ms) | Total: 0.0% (3.1ms) | Samples: 1

**Called by:**
- `_buildReference` (1)
- `isInLoop` (1)

**Calls:**
- `get _tag` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `async (anonymous)` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1067` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `_isChainNode`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `nodeViewChain` (1)

### `decode`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get source` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:5464` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3059` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `ensureChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `get` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1977` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `ensureVarsSet` (1)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:751` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `get name` (1)

### `_buildTemplate`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildPlan` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1959` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `ensureVarsSet` (1)

### `_filteredBuiltins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:275` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `get id`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2257` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` | Self: 0.0% (1.3ms) | Total: 18.0% (757.0ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (496)

**Calls:**
- `isAfterLastUsedArg` (481)
- `isAfterLastUsedArg` (12)
- `isAfterLastUsedArg` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2612` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `ensureVarsSet` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1897` | Self: 0.0% (1.3ms) | Total: 16.9% (711.2ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (466)

**Calls:**
- `ensureChildren` (464)
- `ensureChildren` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2963` | Self: 0.0% (1.3ms) | Total: 92.1% (3.86s) | Samples: 1

**Called by:**
- `_buildThinVariable` (1467)
- `_buildThinScope` (1068)

**Calls:**
- `_buildThinVariable` (2407)
- `_buildThinVariable` (61)
- `_buildThinVariable` (37)
- `_buildThinVariable` (10)
- `_buildThinVariable` (9)
- `_buildThinVariable` (7)
- `_buildThinVariable` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:20` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `parseModule` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1684` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3997` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `nodeView` (1)

### `getUint32`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `isUnusedExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:512` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `getRhsNode` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_buildVariable` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` | Self: 0.0% (1.2ms) | Total: 0.5% (24.7ms) | Samples: 1

**Called by:**
- `forEach` (16)

**Calls:**
- `nodeViewChain` (8)
- `nodeViewChain` (2)
- `get init` (1)
- `_nodeViewRaw` (1)
- `get init` (1)
- `nodeViewChain` (1)
- `init` (1)

### `isRead`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.2ms) | Total: 0.0% (2.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)
- `isSelfReference` (1)

**Calls:**
- `get parent` (1)

### `error`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `async (anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.1ms) | Total: 0.0% (1.1ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2948` | Self: 0.0% (913us) | Total: 0.0% (913us) | Samples: 1

**Called by:**
- `_buildThinVariable` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1731` | Self: 0.0% (0us) | Total: 0.1% (4.2ms) | Samples: 0

**Called by:**
- `_buildScopeChildren` (3)

**Calls:**
- `get name` (2)
- `get id` (1)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:182` | Self: 0.0% (0us) | Total: 1.1% (47.4ms) | Samples: 0

**Called by:**
- `getRhsNode` (32)

**Calls:**
- `isLoop` (32)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.1% (5.0ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `anonymous` (3)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1255` | Self: 0.0% (0us) | Total: 0.1% (7.5ms) | Samples: 0

**Called by:**
- `_buildReference` (3)
- `isForInOfRef` (1)

**Calls:**
- `get _tag` (4)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:776` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `get id` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` | Self: 0.0% (0us) | Total: 0.6% (27.7ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (18)

**Calls:**
- `isFunction` (13)
- `get parent` (4)
- `get parent` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:35` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `parseModule` (2)

**Calls:**
- `readFileSync` (2)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7384` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `buildVisitorMap` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` | Self: 0.0% (0us) | Total: 1.9% (83.3ms) | Samples: 0

**Called by:**
- `some` (54)

**Calls:**
- `isForInOfRef` (18)
- `isForInOfRef` (15)
- `isForInOfRef` (11)
- `isForInOfRef` (5)
- `isForInOfRef` (5)

### `node:events`
`node:events:9` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `anonymous` (2)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:59` | Self: 0.0% (0us) | Total: 1.7% (75.0ms) | Samples: 0

**Called by:**
- `async (anonymous)` (48)

**Calls:**
- `parseSource` (46)
- `parseSource` (2)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:653` | Self: 0.0% (0us) | Total: 0.1% (6.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `get type` (3)
- `get type` (1)

### `(anonymous)`
`internal:primordials:34` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `forEach` (1)

**Calls:**
- `values` (1)

### `loadBinding`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `getTagNames` (1)

**Calls:**
- `bound require` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3070` | Self: 0.0% (0us) | Total: 0.1% (6.2ms) | Samples: 0

**Called by:**
- `isAfterLastUsedArg` (4)

**Calls:**
- `map` (4)

### `describeRule`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (1)

**Calls:**
- `_getPlugin` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5784` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_getOrBuildPlan` (1)

**Calls:**
- `_buildTemplate` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` | Self: 0.0% (0us) | Total: 0.1% (8.3ms) | Samples: 0

**Called by:**
- `parseModule` (5)

**Calls:**
- `bound require` (5)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` | Self: 0.0% (0us) | Total: 1.6% (69.5ms) | Samples: 0

**Called by:**
- `async (anonymous)` (46)

**Calls:**
- `parse` (46)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1680` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_buildScopeChildren` (1)

**Calls:**
- `get _tag` (1)

### `_nodeMods`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:928` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `get kind` (1)

**Calls:**
- `nodeRhs` (1)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:802` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_ensureDeclSymIndex` (1)

**Calls:**
- `_buildSymNameCache` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:12` | Self: 0.0% (0us) | Total: 0.2% (9.6ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:54` | Self: 0.0% (0us) | Total: 0.2% (11.1ms) | Samples: 0

**Called by:**
- `async (anonymous)` (8)

**Calls:**
- `bound require` (8)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:279` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `getUint32` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7380` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `get source` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2820` | Self: 0.0% (0us) | Total: 0.5% (22.5ms) | Samples: 0

**Called by:**
- `_buildVariable` (15)

**Calls:**
- `get parent` (6)
- `get parent` (3)
- `get parent` (2)
- `get parent` (2)
- `get parent` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `node:fs/promises`
`node:fs/promises:2` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `@lazy` (1)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 1.0% (44.0ms) | Samples: 0

**Called by:**
- `bound require` (31)

**Calls:**
- `anonymous` (31)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 1.2% (53.9ms) | Samples: 0

**Called by:**
- `loadCoreRules` (8)
- `(anonymous)` (7)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (3)
- `async (anonymous)` (3)
- `async (anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `loadBinding` (1)
- `(anonymous)` (1)

**Calls:**
- `require` (31)
- `anonymous` (5)
- `(anonymous)` (1)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2910` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `nodeRhs` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6526` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_getOrBuildPlan` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` | Self: 0.0% (0us) | Total: 84.3% (3.53s) | Samples: 0

**Called by:**
- `_invokeFused` (2323)

**Calls:**
- `collectUnusedVariables` (1821)
- `collectUnusedVariables` (502)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:50` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `getTagNames` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (4.1ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7101` | Self: 0.0% (0us) | Total: 86.8% (3.64s) | Samples: 0

**Called by:**
- `runPlugins` (2394)

**Calls:**
- `_invokeFused` (2394)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:557` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isUnusedExpression` (1)

### `ensureChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1856` | Self: 0.0% (0us) | Total: 16.8% (708.5ms) | Samples: 0

**Called by:**
- `get` (464)

**Calls:**
- `_buildScopeChildren` (439)
- `_buildScopeChildren` (12)
- `_buildScopeChildren` (11)
- `_buildScopeChildren` (2)

### `map`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (6.2ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (4)

**Calls:**
- `(anonymous)` (4)

### `internal:shared`
`internal:shared:2` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4556` | Self: 0.0% (0us) | Total: 86.8% (3.64s) | Samples: 0

**Called by:**
- `walkNodes` (2394)

**Calls:**
- `Program:exit` (2323)
- `Program:exit` (67)
- `Program:exit` (1)
- `Program:exit` (1)
- `Program:exit` (1)
- `Program:exit` (1)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:179` | Self: 0.0% (0us) | Total: 1.5% (63.1ms) | Samples: 0

**Called by:**
- `getRhsNode` (41)

**Calls:**
- `isFunction` (41)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:575` | Self: 0.0% (0us) | Total: 0.1% (5.3ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (4)

**Calls:**
- `_findLineIdx` (4)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` | Self: 0.0% (0us) | Total: 17.5% (736.1ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (481)

**Calls:**
- `getDeclaredVariables` (128)
- `getDeclaredVariables` (119)
- `getDeclaredVariables` (112)
- `getDeclaredVariables` (68)
- `getDeclaredVariables` (20)
- `getDeclaredVariables` (12)
- `getDeclaredVariables` (8)
- `getDeclaredVariables` (5)
- `getDeclaredVariables` (4)
- `getDeclaredVariables` (2)
- `getDeclaredVariables` (1)
- `getDeclaredVariables` (1)
- `getDeclaredVariables` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2001` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `ensureVarsSet` (1)

**Calls:**
- `_filteredBuiltins` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` | Self: 0.0% (0us) | Total: 0.1% (5.5ms) | Samples: 0

**Called by:**
- `async (anonymous)` (2)

**Calls:**
- `AstView` (1)
- `AstView` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2433` | Self: 0.0% (0us) | Total: 1.9% (83.6ms) | Samples: 0

**Called by:**
- `getScope` (55)

**Calls:**
- `commentsInRange` (35)
- `commentsInRange` (7)
- `commentsInRange` (5)
- `commentsInRange` (4)
- `commentsInRange` (4)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:662` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isInsideOfStorableFunction` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1638` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (2)

**Calls:**
- `get` (2)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:62` | Self: 0.0% (0us) | Total: 7.4% (312.0ms) | Samples: 0

**Called by:**
- `async (anonymous)` (207)

**Calls:**
- `runPlugins` (205)
- `runPlugins` (1)
- `runPlugins` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:887` | Self: 0.0% (0us) | Total: 0.1% (4.3ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (3)

**Calls:**
- `get kind` (1)
- `get kind` (1)
- `get kind` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:661` | Self: 0.0% (0us) | Total: 0.1% (4.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `isInside` (3)

### `get id`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2269` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_buildScope` (1)

**Calls:**
- `extraFnData` (1)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2907` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get _tag` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` | Self: 0.0% (0us) | Total: 0.3% (14.7ms) | Samples: 0

**Called by:**
- `some` (10)

**Calls:**
- `isSelfReference` (10)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `requestFetch`
`[native code]` | Self: 0.0% (0us) | Total: 0.2% (12.2ms) | Samples: 0

**Called by:**
- `async (anonymous)` (8)

**Calls:**
- `fetch` (8)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7377` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `reset` (1)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:511` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `decode` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1703` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1512` | Self: 0.0% (0us) | Total: 2.4% (101.7ms) | Samples: 0

**Called by:**
- `Program:exit` (67)

**Calls:**
- `_precomputeScopes` (55)
- `_precomputeScopes` (11)
- `_precomputeScopes` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6865` | Self: 0.0% (0us) | Total: 0.4% (20.3ms) | Samples: 0

**Called by:**
- `runPlugins` (13)

**Calls:**
- `getDFSEvents` (6)
- `getDFSEvents` (6)
- `getDFSEvents` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` | Self: 0.0% (0us) | Total: 2.4% (101.7ms) | Samples: 0

**Called by:**
- `_invokeFused` (67)

**Calls:**
- `getScope` (67)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:66` | Self: 0.0% (0us) | Total: 89.1% (3.73s) | Samples: 0

**Called by:**
- `async (anonymous)` (2460)

**Calls:**
- `runPlugins` (2459)
- `runPlugins` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4062` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `_isChainNode` (1)

### `bound call`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `makeSafe` (1)

**Calls:**
- `forEach` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:53` | Self: 0.0% (0us) | Total: 0.3% (12.8ms) | Samples: 0

**Called by:**
- `async (anonymous)` (9)

**Calls:**
- `loadCoreRules` (8)
- `loadCoreRules` (1)

### `_getOrBuildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5455` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_buildPlan` (1)

### `requestSatisfy`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `async loadModule` (1)

**Calls:**
- `requestSatisfyUtil` (1)

### `internal:primordials`
`internal:primordials:71` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `makeSafe` (1)

### `requestInstantiate`
`[native code]` | Self: 0.0% (0us) | Total: 0.3% (14.0ms) | Samples: 0

**Called by:**
- `requestSatisfyUtil` (9)

**Calls:**
- `async (anonymous)` (9)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:70` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `error` (1)

### `get kind`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2626` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `get _tag` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:752` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (2)

**Calls:**
- `some` (2)

### `getTagNames`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:186` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `loadBinding` (1)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:818` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_symName` (1)

**Calls:**
- `slice` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:46` | Self: 0.0% (0us) | Total: 0.1% (4.7ms) | Samples: 0

**Called by:**
- `async (anonymous)` (3)

**Calls:**
- `bound require` (3)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1708` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `some` (1)

### `isInsideOfStorableFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:630` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `isReadForItself` (1)

**Calls:**
- `getUpperFunction` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1640` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `push` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` | Self: 0.0% (0us) | Total: 98.9% (4.15s) | Samples: 0

**Called by:**
- `(anonymous)` (2732)

**Calls:**
- `async (anonymous)` (2460)
- `async (anonymous)` (207)
- `async (anonymous)` (48)
- `async (anonymous)` (9)
- `async (anonymous)` (3)
- `async (anonymous)` (2)
- `async (anonymous)` (1)
- `async (anonymous)` (1)
- `async (anonymous)` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1684` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_buildScopeChildren` (1)

**Calls:**
- `get value` (1)

### `async loadModule`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (7.0ms) | Samples: 0

**Called by:**
- `async loadModule` (2)
- `async loadAndEvaluateModule` (2)

**Calls:**
- `async loadModule` (2)
- `requestSatisfy` (1)
- `ensureRegistered` (1)

### `ensureRegistered`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `async loadModule` (1)

**Calls:**
- `newRegistryEntry` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.1% (6.8ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `_loadFromDisk`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:69` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_getPlugin` (1)

**Calls:**
- `tryParse` (1)

### `ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1766` | Self: 0.0% (0us) | Total: 0.2% (9.5ms) | Samples: 0

**Called by:**
- `get` (6)

**Calls:**
- `_buildScopeVarsAndSet` (6)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3771` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `report` (1)

**Calls:**
- `get type` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1712` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `getDefinedMessageData` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1189` | Self: 0.0% (0us) | Total: 0.7% (31.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (7)
- `_buildReference` (4)
- `collectUnusedVariables` (4)
- `collectUnusedVariables` (3)
- `_findDefNode` (1)
- `_computeIsStrict` (1)
- `_buildThinVariable` (1)

**Calls:**
- `nodeView` (20)
- `_nodeViewRaw` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6761` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `get` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` | Self: 0.0% (0us) | Total: 98.9% (4.15s) | Samples: 0

**Called by:**
- `parseModule` (2732)

**Calls:**
- `async (anonymous)` (2732)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1700` | Self: 0.0% (0us) | Total: 0.0% (3.4ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (2)

**Calls:**
- `_nodeViewRaw` (2)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4065` | Self: 0.0% (0us) | Total: 0.4% (19.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (8)
- `(anonymous)` (3)
- `(anonymous)` (1)

**Calls:**
- `_nodeViewRaw` (7)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (1)

### `tryParse`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:126` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_loadFromDisk` (1)

**Calls:**
- `parse` (1)

### `(anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.3% (13.9ms) | Samples: 0

**Called by:**
- `bound require` (1)

**Calls:**
- `requestSatisfyUtil` (8)
- `dlopen` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7385` | Self: 0.0% (0us) | Total: 96.4% (4.04s) | Samples: 0

**Called by:**
- `async (anonymous)` (2459)
- `async (anonymous)` (205)

**Calls:**
- `walkNodes` (2394)
- `walkNodes` (194)
- `walkNodes` (22)
- `walkNodes` (13)
- `walkNodes` (10)
- `walkNodes` (10)
- `walkNodes` (8)
- `walkNodes` (6)
- `walkNodes` (4)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1337` | Self: 0.0% (0us) | Total: 0.1% (4.4ms) | Samples: 0

**Called by:**
- `ensureVarsSet` (2)
- `(anonymous)` (1)

**Calls:**
- `_resolveUnicodeEscapes` (2)
- `_identAt` (1)

### `ensureFenVars`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1753` | Self: 0.0% (0us) | Total: 0.3% (14.3ms) | Samples: 0

**Called by:**
- `get` (9)

**Calls:**
- `get` (9)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:45` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `async (anonymous)` (2)

**Calls:**
- `bound require` (2)

### `ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1801` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `get` (2)

**Calls:**
- `get name` (2)

### `requestSatisfyUtil`
`[native code]` | Self: 0.0% (0us) | Total: 0.3% (14.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (8)
- `requestSatisfy` (1)

**Calls:**
- `requestInstantiate` (9)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:441` | Self: 0.0% (0us) | Total: 0.1% (4.2ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `CfgGraph` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` | Self: 0.0% (0us) | Total: 0.1% (4.2ms) | Samples: 0

**Called by:**
- `some` (3)

**Calls:**
- `isReadRef` (2)
- `isRead` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:12` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4037` | Self: 0.0% (0us) | Total: 1.2% (50.5ms) | Samples: 0

**Called by:**
- `get parent` (20)
- `_buildReference` (10)
- `_buildThinScope` (2)
- `_buildThinVariable` (1)

**Calls:**
- `_nodeViewRaw` (9)
- `_nodeViewRaw` (5)
- `_nodeViewRaw` (5)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1483` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `get parent` (1)

**Calls:**
- `get loc` (1)

### `_getPlugin`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:60` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `describeRule` (1)

**Calls:**
- `_loadFromDisk` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1636` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `_symName` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:655` | Self: 0.0% (0us) | Total: 0.0% (3.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `isUnusedExpression` (1)
- `isUnusedExpression` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` | Self: 0.0% (0us) | Total: 3.0% (127.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (84)

**Calls:**
- `isInLoop` (41)
- `isInLoop` (32)
- `isInLoop` (11)

### `makeSafe`
`internal:primordials:30` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `internal:primordials` (1)

**Calls:**
- `bound call` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1756` | Self: 0.0% (0us) | Total: 0.3% (14.3ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (9)

**Calls:**
- `ensureFenVars` (9)

### `get kind`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2667` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `_nodeMods` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2785` | Self: 0.0% (0us) | Total: 0.5% (21.0ms) | Samples: 0

**Called by:**
- `_buildVariable` (14)

**Calls:**
- `nodeView` (10)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (2)

### `internal:validators`
`internal:validators:2` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1669` | Self: 0.0% (0us) | Total: 0.3% (13.0ms) | Samples: 0

**Called by:**
- `_buildScopeChildren` (8)

**Calls:**
- `_buildScope` (5)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3789` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `Program:exit` (1)

**Calls:**
- `_execReport` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4216` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `describeRule` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` | Self: 0.0% (0us) | Total: 1.4% (62.2ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (40)

**Calls:**
- `getFunctionDefinitions` (36)
- `getFunctionDefinitions` (4)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `report` (1)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 54.0% | 2.26s | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 23.3% | 980.9ms | `[native code]` |
| 13.9% | 586.9ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 6.6% | 278.2ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 1.7% | 71.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js` |
| 0.0% | 2.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 2.7ms | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js` |
| 0.0% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js` |
| 0.0% | 1.6ms | `node:fs` |
