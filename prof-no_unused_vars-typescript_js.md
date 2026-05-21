# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 6.83s | 4471 | 1.0ms | 426 |

**Top 10:** `parse` 19.5%, `_nodeViewRaw` 6.3%, `Set` 4.6%, `defineProperties` 3.6%, `walkNodes` 3.1%, `get parent` 2.8%, `getDeclaredVariables` 2.5%, `get _tag` 2.0%, `getDeclaredVariables` 1.9%, `get parent` 1.9%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 19.5% | 1.33s | 19.5% | 1.33s | `parse` | `[native code]` |
| 6.3% | 432.7ms | 6.6% | 453.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3994` |
| 4.6% | 318.1ms | 4.6% | 318.1ms | `Set` | `[native code]` |
| 3.6% | 250.9ms | 3.6% | 250.9ms | `defineProperties` | `[native code]` |
| 3.1% | 216.9ms | 3.6% | 250.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6867` |
| 2.8% | 192.4ms | 3.3% | 227.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1285` |
| 2.5% | 177.4ms | 2.6% | 178.8ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3052` |
| 2.0% | 138.5ms | 2.0% | 138.5ms | `get _tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 1.9% | 131.3ms | 1.9% | 133.1ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3058` |
| 1.9% | 130.4ms | 2.2% | 153.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1222` |
| 1.6% | 110.6ms | 1.6% | 110.6ms | `get _tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1072` |
| 1.3% | 89.3ms | 1.3% | 89.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4005` |
| 1.2% | 86.6ms | 1.3% | 90.9ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2543` |
| 1.2% | 85.6ms | 1.2% | 85.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4001` |
| 1.2% | 82.7ms | 1.2% | 82.7ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2964` |
| 1.1% | 81.8ms | 1.7% | 120.0ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1624` |
| 1.1% | 80.7ms | 1.1% | 80.7ms | `get` | `[native code]` |
| 1.1% | 79.9ms | 1.1% | 79.9ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1006` |
| 1.0% | 71.3ms | 2.2% | 156.2ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2821` |
| 0.9% | 62.4ms | 0.9% | 62.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6623` |
| 0.8% | 58.8ms | 1.5% | 109.1ms | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:152` |
| 0.8% | 58.3ms | 0.8% | 59.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1976` |
| 0.7% | 53.2ms | 0.7% | 53.2ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.7% | 52.8ms | 2.0% | 141.2ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2878` |
| 0.7% | 52.4ms | 0.7% | 52.4ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` |
| 0.6% | 47.4ms | 0.6% | 47.4ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.6% | 41.4ms | 0.6% | 41.4ms | `set` | `[native code]` |
| 0.5% | 40.1ms | 27.7% | 1.89s | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2487` |
| 0.5% | 40.1ms | 0.5% | 40.1ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1011` |
| 0.5% | 39.8ms | 0.5% | 39.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1175` |
| 0.5% | 39.6ms | 1.5% | 108.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 0.5% | 37.5ms | 0.5% | 37.5ms | `push` | `[native code]` |
| 0.5% | 36.5ms | 1.7% | 121.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1255` |
| 0.4% | 34.0ms | 0.7% | 54.1ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2534` |
| 0.4% | 32.0ms | 0.4% | 32.0ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1019` |
| 0.4% | 31.5ms | 0.4% | 31.5ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2947` |
| 0.4% | 31.4ms | 10.8% | 738.1ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2796` |
| 0.4% | 31.2ms | 4.1% | 282.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1892` |
| 0.4% | 30.5ms | 0.4% | 30.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4002` |
| 0.4% | 30.3ms | 1.2% | 83.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1274` |
| 0.4% | 29.3ms | 0.4% | 29.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2477` |
| 0.4% | 28.0ms | 6.0% | 411.0ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3050` |
| 0.4% | 27.5ms | 0.8% | 55.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1625` |
| 0.4% | 27.4ms | 0.4% | 28.9ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3018` |
| 0.3% | 27.2ms | 0.3% | 27.2ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1013` |
| 0.3% | 26.7ms | 0.3% | 26.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3991` |
| 0.3% | 26.5ms | 0.3% | 26.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2798` |
| 0.3% | 24.8ms | 0.3% | 24.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4000` |
| 0.3% | 23.8ms | 100.0% | 11.40s | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2930` |
| 0.3% | 23.0ms | 2.8% | 192.8ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1690` |
| 0.3% | 22.8ms | 1.0% | 72.0ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2067` |
| 0.3% | 22.4ms | 2.5% | 172.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3031` |
| 0.3% | 22.1ms | 0.3% | 22.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3999` |
| 0.3% | 22.1ms | 0.3% | 22.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7035` |
| 0.3% | 21.7ms | 0.3% | 21.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1655` |
| 0.3% | 21.0ms | 0.3% | 22.3ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:434` |
| 0.3% | 20.8ms | 0.3% | 20.8ms | `_getTypeProto` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3978` |
| 0.3% | 20.5ms | 0.3% | 20.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4004` |
| 0.3% | 20.4ms | 0.3% | 20.4ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 19.8ms | 0.2% | 19.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 19.4ms | 0.2% | 19.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3998` |
| 0.2% | 19.3ms | 0.2% | 19.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1962` |
| 0.2% | 19.1ms | 0.3% | 23.4ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.2% | 19.0ms | 0.8% | 57.2ms | `anonymous` | `[native code]` |
| 0.2% | 18.9ms | 0.2% | 18.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3986` |
| 0.2% | 18.9ms | 0.2% | 18.9ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2750` |
| 0.2% | 18.7ms | 0.2% | 18.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3997` |
| 0.2% | 18.7ms | 0.2% | 18.7ms | `has` | `[native code]` |
| 0.2% | 18.5ms | 0.2% | 18.5ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2457` |
| 0.2% | 18.0ms | 46.4% | 3.17s | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 0.2% | 17.9ms | 2.7% | 184.8ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1863` |
| 0.2% | 17.9ms | 0.2% | 17.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3995` |
| 0.2% | 17.4ms | 0.2% | 17.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1295` |
| 0.2% | 17.1ms | 0.5% | 36.0ms | `isLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:168` |
| 0.2% | 17.1ms | 0.2% | 17.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4003` |
| 0.2% | 16.8ms | 0.2% | 18.3ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3040` |
| 0.2% | 16.5ms | 0.2% | 16.5ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:818` |
| 0.2% | 16.1ms | 0.5% | 34.1ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.2% | 15.9ms | 0.2% | 15.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2175` |
| 0.2% | 15.8ms | 0.2% | 17.6ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1622` |
| 0.2% | 15.7ms | 0.3% | 23.3ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 0.2% | 15.5ms | 0.2% | 15.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4006` |
| 0.2% | 14.7ms | 0.2% | 14.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3996` |
| 0.2% | 14.6ms | 0.2% | 14.6ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2895` |
| 0.2% | 14.4ms | 0.2% | 14.4ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3051` |
| 0.2% | 14.4ms | 5.0% | 348.0ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1960` |
| 0.2% | 14.3ms | 0.2% | 14.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1707` |
| 0.2% | 14.1ms | 8.3% | 567.6ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 0.1% | 13.5ms | 0.1% | 13.5ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4793` |
| 0.1% | 13.3ms | 0.1% | 13.3ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2941` |
| 0.1% | 13.2ms | 0.2% | 16.5ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` |
| 0.1% | 12.8ms | 0.1% | 12.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 12.7ms | 0.6% | 46.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1237` |
| 0.1% | 12.5ms | 5.4% | 372.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1189` |
| 0.1% | 12.3ms | 0.1% | 12.3ms | `decode` | `[native code]` |
| 0.1% | 12.3ms | 0.1% | 12.3ms | `/^(?:Function(?:Declaration\|Expression)\|ArrowFunctionExpression)$/u` | `[native code]` |
| 0.1% | 12.0ms | 0.1% | 12.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6866` |
| 0.1% | 11.4ms | 3.0% | 208.2ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2872` |
| 0.1% | 11.3ms | 2.4% | 168.5ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:406` |
| 0.1% | 11.3ms | 0.1% | 11.3ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.1% | 10.9ms | 0.1% | 10.9ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6358` |
| 0.1% | 10.6ms | 0.3% | 24.1ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` |
| 0.1% | 10.5ms | 26.8% | 1.83s | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1969` |
| 0.1% | 10.5ms | 0.1% | 10.5ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2344` |
| 0.1% | 10.4ms | 0.1% | 10.4ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 10.3ms | 0.1% | 10.3ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2946` |
| 0.1% | 10.3ms | 0.2% | 15.1ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` |
| 0.1% | 10.2ms | 0.1% | 10.2ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` |
| 0.1% | 10.2ms | 0.1% | 10.2ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1067` |
| 0.1% | 10.0ms | 0.1% | 10.0ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` |
| 0.1% | 9.9ms | 0.1% | 9.9ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 9.9ms | 0.2% | 19.2ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2437` |
| 0.1% | 9.5ms | 8.2% | 563.0ms | `some` | `[native code]` |
| 0.1% | 9.4ms | 0.2% | 15.6ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1676` |
| 0.1% | 9.3ms | 0.1% | 9.3ms | `/^(?:DoWhile\|For\|ForIn\|ForOf\|While)Statement$/u` | `[native code]` |
| 0.1% | 9.3ms | 0.1% | 9.3ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2915` |
| 0.1% | 9.2ms | 1.7% | 116.9ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1933` |
| 0.1% | 9.2ms | 1.4% | 100.6ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:180` |
| 0.1% | 8.7ms | 0.1% | 8.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6868` |
| 0.1% | 8.5ms | 0.1% | 8.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2179` |
| 0.1% | 8.2ms | 0.1% | 8.2ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1007` |
| 0.1% | 8.1ms | 0.1% | 8.1ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2858` |
| 0.1% | 7.9ms | 0.2% | 14.1ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:410` |
| 0.1% | 7.8ms | 0.1% | 11.3ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:682` |
| 0.1% | 7.8ms | 0.1% | 7.8ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4056` |
| 0.1% | 7.8ms | 0.7% | 51.3ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:868` |
| 0.1% | 7.7ms | 0.2% | 16.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1228` |
| 0.1% | 7.7ms | 0.3% | 21.1ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1627` |
| 0.1% | 7.6ms | 0.4% | 27.7ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1915` |
| 0.1% | 7.6ms | 0.1% | 7.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1970` |
| 0.1% | 7.5ms | 100.0% | 7.75s | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2851` |
| 0.1% | 7.4ms | 0.1% | 7.4ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 7.1ms | 0.1% | 9.9ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1674` |
| 0.1% | 6.9ms | 0.1% | 6.9ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2641` |
| 0.0% | 6.6ms | 0.2% | 17.4ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1703` |
| 0.0% | 6.4ms | 0.0% | 6.4ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3025` |
| 0.0% | 6.2ms | 0.0% | 6.2ms | `getUint32` | `[native code]` |
| 0.0% | 6.1ms | 0.0% | 6.1ms | `/^\s*exported\b/` | `[native code]` |
| 0.0% | 6.0ms | 8.8% | 607.2ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2789` |
| 0.0% | 6.0ms | 0.0% | 6.0ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` |
| 0.0% | 5.9ms | 0.0% | 5.9ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2744` |
| 0.0% | 5.9ms | 0.0% | 5.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1185` |
| 0.0% | 5.8ms | 0.0% | 5.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 5.7ms | 1.1% | 77.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1623` |
| 0.0% | 5.7ms | 0.2% | 15.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2492` |
| 0.0% | 5.6ms | 0.0% | 5.6ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:773` |
| 0.0% | 5.1ms | 0.1% | 8.3ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:653` |
| 0.0% | 4.9ms | 0.0% | 4.9ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1639` |
| 0.0% | 4.9ms | 0.0% | 4.9ms | `test` | `[native code]` |
| 0.0% | 4.9ms | 0.1% | 7.8ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` |
| 0.0% | 4.8ms | 0.0% | 4.8ms | `DataView` | `[native code]` |
| 0.0% | 4.8ms | 0.0% | 4.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6627` |
| 0.0% | 4.7ms | 0.6% | 44.6ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2516` |
| 0.0% | 4.7ms | 0.0% | 4.7ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2835` |
| 0.0% | 4.7ms | 0.2% | 17.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` |
| 0.0% | 4.6ms | 0.1% | 7.7ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2909` |
| 0.0% | 4.6ms | 0.0% | 4.6ms | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:511` |
| 0.0% | 4.6ms | 0.4% | 27.4ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2792` |
| 0.0% | 4.5ms | 0.0% | 5.9ms | `readdirSync` | `[native code]` |
| 0.0% | 4.5ms | 0.0% | 4.5ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 4.5ms | 0.0% | 4.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 4.5ms | 0.0% | 4.5ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:435` |
| 0.0% | 4.5ms | 0.0% | 5.9ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` |
| 0.0% | 4.5ms | 6.0% | 412.9ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 0.0% | 4.4ms | 0.0% | 4.4ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3034` |
| 0.0% | 4.4ms | 100.0% | 15.77s | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3637` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2183` |
| 0.0% | 4.2ms | 0.0% | 4.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1227` |
| 0.0% | 4.2ms | 4.2% | 292.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 0.0% | 4.0ms | 0.1% | 10.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.0% | 3.6ms | 0.0% | 3.6ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4244` |
| 0.0% | 3.5ms | 0.0% | 5.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2069` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3042` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:542` |
| 0.0% | 3.3ms | 0.0% | 6.5ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.0% | 3.3ms | 0.1% | 7.6ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:447` |
| 0.0% | 3.3ms | 0.2% | 20.0ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2820` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1829` |
| 0.0% | 3.2ms | 1.0% | 72.7ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6624` |
| 0.0% | 3.2ms | 0.1% | 9.4ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2874` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:582` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:395` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4057` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:419` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6360` |
| 0.0% | 3.0ms | 0.1% | 10.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1730` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:865` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `existsSync` | `[native code]` |
| 0.0% | 2.9ms | 10.7% | 733.5ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2347` |
| 0.0% | 2.9ms | 0.0% | 6.0ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1674` |
| 0.0% | 2.9ms | 0.0% | 4.1ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:494` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4243` |
| 0.0% | 2.9ms | 0.0% | 5.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1680` |
| 0.0% | 2.9ms | 100.0% | 8.21s | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2963` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1973` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1618` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1626` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3032` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:665` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4011` |
| 0.0% | 2.7ms | 0.1% | 8.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1638` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2177` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2773` |
| 0.0% | 2.6ms | 11.1% | 760.5ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1897` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1200` |
| 0.0% | 1.8ms | 0.0% | 3.1ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1937` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2720` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:512` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `encodeInto` | `[native code]` |
| 0.0% | 1.7ms | 0.1% | 8.9ms | `exec` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `replace` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3882` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1684` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1708` |
| 0.0% | 1.7ms | 0.0% | 3.3ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:887` |
| 0.0% | 1.7ms | 0.9% | 67.2ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2939` |
| 0.0% | 1.7ms | 1.0% | 70.9ms | `forEach` | `[native code]` |
| 0.0% | 1.7ms | 1.6% | 110.1ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4032` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `error` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 3.5ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2907` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2434` |
| 0.0% | 1.7ms | 0.0% | 5.8ms | `map` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:3192` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:508` |
| 0.0% | 1.7ms | 0.0% | 3.1ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3056` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 11.0% | 756.2ms | `ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1856` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3013` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:540` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1790` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2672` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1201` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.2% | 14.6ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:412` |
| 0.0% | 1.6ms | 0.0% | 3.3ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2910` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1714` |
| 0.0% | 1.6ms | 0.5% | 37.1ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:558` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7034` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4841` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4008` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `findIndex` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1635` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 34.5% | 2.35s | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1828` |
| 0.0% | 1.5ms | 0.2% | 18.7ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1914` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `/\{\{(\w+)\}\}/g` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3059` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1826` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1325` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6419` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1492` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `indexOf` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:647` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_findLine` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:461` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `entries` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1711` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1756` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_isStatementTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs` |
| 0.0% | 1.4ms | 8.2% | 564.5ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4037` |
| 0.0% | 1.3ms | 0.3% | 26.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2612` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:828` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get start` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 4.3ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:689` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1637` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:664` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1935` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1474` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getDefinedMessageData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:283` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:185` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1703` |
| 0.0% | 1.2ms | 0.1% | 10.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1669` |
| 0.0% | 1.2ms | 0.0% | 2.5ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2956` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:121` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1330` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3049` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1628` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3594` |
| 0.0% | 1.2ms | 1.3% | 90.7ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2865` |
| 0.0% | 1.0ms | 0.1% | 13.0ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1700` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 100.0% | 15.77s | 0.0% | 4.4ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 100.0% | 11.40s | 0.3% | 23.8ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2930` |
| 100.0% | 8.21s | 0.0% | 2.9ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2963` |
| 100.0% | 7.75s | 0.1% | 7.5ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2851` |
| 79.6% | 5.43s | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:304` |
| 79.3% | 5.42s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7385` |
| 73.7% | 5.03s | 0.0% | 0us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4556` |
| 73.7% | 5.03s | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7101` |
| 72.1% | 4.92s | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` |
| 46.4% | 3.17s | 0.2% | 18.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 35.0% | 2.39s | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1893` |
| 34.5% | 2.35s | 0.0% | 1.5ms | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1828` |
| 27.7% | 1.89s | 0.5% | 40.1ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2487` |
| 26.8% | 1.83s | 0.1% | 10.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1969` |
| 19.8% | 1.35s | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:300` |
| 19.5% | 1.33s | 19.5% | 1.33s | `parse` | `[native code]` |
| 19.5% | 1.33s | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` |
| 14.8% | 1.01s | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` |
| 14.4% | 988.8ms | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` |
| 11.1% | 760.5ms | 0.0% | 2.6ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1897` |
| 11.0% | 756.2ms | 0.0% | 1.6ms | `ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1856` |
| 10.8% | 738.1ms | 0.4% | 31.4ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2796` |
| 10.7% | 733.5ms | 0.0% | 2.9ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2347` |
| 8.8% | 607.2ms | 0.0% | 6.0ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2789` |
| 8.3% | 567.6ms | 0.2% | 14.1ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 8.2% | 564.5ms | 0.0% | 1.4ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4037` |
| 8.2% | 563.0ms | 0.1% | 9.5ms | `some` | `[native code]` |
| 6.6% | 453.5ms | 6.3% | 432.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3994` |
| 6.0% | 412.9ms | 0.0% | 4.5ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 6.0% | 411.0ms | 0.4% | 28.0ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3050` |
| 5.4% | 372.1ms | 0.1% | 12.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1189` |
| 5.0% | 348.0ms | 0.2% | 14.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1960` |
| 4.6% | 318.1ms | 4.6% | 318.1ms | `Set` | `[native code]` |
| 4.2% | 292.3ms | 0.0% | 4.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 4.1% | 282.1ms | 0.4% | 31.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1892` |
| 4.0% | 274.3ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2785` |
| 3.6% | 250.9ms | 3.1% | 216.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6867` |
| 3.6% | 250.9ms | 3.6% | 250.9ms | `defineProperties` | `[native code]` |
| 3.4% | 235.0ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` |
| 3.3% | 227.8ms | 2.8% | 192.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1285` |
| 3.0% | 208.2ms | 0.1% | 11.4ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2872` |
| 2.8% | 192.8ms | 0.3% | 23.0ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1690` |
| 2.7% | 184.8ms | 0.2% | 17.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1863` |
| 2.6% | 178.8ms | 2.5% | 177.4ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3052` |
| 2.5% | 172.2ms | 0.3% | 22.4ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3031` |
| 2.4% | 168.5ms | 0.1% | 11.3ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:406` |
| 2.2% | 156.2ms | 1.0% | 71.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2821` |
| 2.2% | 153.3ms | 1.9% | 130.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1222` |
| 2.0% | 141.2ms | 0.7% | 52.8ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2878` |
| 2.0% | 138.5ms | 2.0% | 138.5ms | `get _tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 1.9% | 133.1ms | 1.9% | 131.3ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3058` |
| 1.7% | 121.9ms | 0.5% | 36.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1255` |
| 1.7% | 120.0ms | 1.1% | 81.8ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1624` |
| 1.7% | 116.9ms | 0.1% | 9.2ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1933` |
| 1.6% | 110.6ms | 1.6% | 110.6ms | `get _tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1072` |
| 1.6% | 110.1ms | 0.0% | 1.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 1.5% | 109.1ms | 0.8% | 58.8ms | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:152` |
| 1.5% | 108.4ms | 0.5% | 39.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 1.5% | 105.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` |
| 1.4% | 100.6ms | 0.1% | 9.2ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:180` |
| 1.4% | 98.4ms | 0.0% | 0us | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:179` |
| 1.4% | 97.8ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` |
| 1.4% | 97.8ms | 0.0% | 0us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1512` |
| 1.3% | 90.9ms | 1.2% | 86.6ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2543` |
| 1.3% | 90.7ms | 0.0% | 1.2ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2865` |
| 1.3% | 89.3ms | 1.3% | 89.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4005` |
| 1.2% | 85.6ms | 1.2% | 85.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4001` |
| 1.2% | 84.0ms | 0.0% | 0us | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` |
| 1.2% | 83.0ms | 0.4% | 30.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1274` |
| 1.2% | 82.7ms | 1.2% | 82.7ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2964` |
| 1.1% | 80.7ms | 1.1% | 80.7ms | `get` | `[native code]` |
| 1.1% | 79.9ms | 1.1% | 79.9ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1006` |
| 1.1% | 77.7ms | 0.0% | 5.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1623` |
| 1.0% | 75.0ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2433` |
| 1.0% | 72.7ms | 0.0% | 3.2ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 1.0% | 72.0ms | 0.3% | 22.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2067` |
| 1.0% | 70.9ms | 0.0% | 1.7ms | `forEach` | `[native code]` |
| 0.9% | 67.2ms | 0.0% | 1.7ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2939` |
| 0.9% | 62.4ms | 0.9% | 62.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6623` |
| 0.8% | 59.8ms | 0.8% | 58.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1976` |
| 0.8% | 57.2ms | 0.2% | 19.0ms | `anonymous` | `[native code]` |
| 0.8% | 55.2ms | 0.4% | 27.5ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1625` |
| 0.7% | 54.4ms | 0.0% | 0us | `bound require` | `[native code]` |
| 0.7% | 54.1ms | 0.4% | 34.0ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2534` |
| 0.7% | 53.2ms | 0.7% | 53.2ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.7% | 52.4ms | 0.7% | 52.4ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` |
| 0.7% | 51.5ms | 0.0% | 0us | `require` | `[native code]` |
| 0.7% | 51.5ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1680` |
| 0.7% | 51.3ms | 0.1% | 7.8ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:868` |
| 0.6% | 47.4ms | 0.6% | 47.4ms | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.6% | 46.0ms | 0.1% | 12.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1237` |
| 0.6% | 44.6ms | 0.0% | 4.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2516` |
| 0.6% | 41.4ms | 0.6% | 41.4ms | `set` | `[native code]` |
| 0.5% | 40.1ms | 0.5% | 40.1ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1011` |
| 0.5% | 39.8ms | 0.5% | 39.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1175` |
| 0.5% | 37.5ms | 0.5% | 37.5ms | `push` | `[native code]` |
| 0.5% | 37.1ms | 0.0% | 1.6ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` |
| 0.5% | 36.0ms | 0.2% | 17.1ms | `isLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:168` |
| 0.5% | 36.0ms | 0.0% | 0us | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:182` |
| 0.5% | 34.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` |
| 0.5% | 34.1ms | 0.2% | 16.1ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.4% | 32.0ms | 0.4% | 32.0ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1019` |
| 0.4% | 31.5ms | 0.4% | 31.5ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2947` |
| 0.4% | 30.5ms | 0.4% | 30.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4002` |
| 0.4% | 29.3ms | 0.4% | 29.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2477` |
| 0.4% | 29.0ms | 0.0% | 0us | `ensureFenVars` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1753` |
| 0.4% | 29.0ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1756` |
| 0.4% | 28.9ms | 0.4% | 27.4ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3018` |
| 0.4% | 27.7ms | 0.1% | 7.6ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1915` |
| 0.4% | 27.4ms | 0.0% | 4.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2792` |
| 0.3% | 27.2ms | 0.3% | 27.2ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1013` |
| 0.3% | 26.7ms | 0.3% | 26.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3991` |
| 0.3% | 26.5ms | 0.3% | 26.5ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2798` |
| 0.3% | 26.2ms | 0.0% | 1.3ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` |
| 0.3% | 24.8ms | 0.3% | 24.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4000` |
| 0.3% | 24.3ms | 0.0% | 0us | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:802` |
| 0.3% | 24.1ms | 0.1% | 10.6ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` |
| 0.3% | 23.4ms | 0.2% | 19.1ms | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` |
| 0.3% | 23.3ms | 0.2% | 15.7ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 0.3% | 22.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` |
| 0.3% | 22.7ms | 0.0% | 0us | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1766` |
| 0.3% | 22.3ms | 0.3% | 21.0ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:434` |
| 0.3% | 22.1ms | 0.3% | 22.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3999` |
| 0.3% | 22.1ms | 0.3% | 22.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7035` |
| 0.3% | 21.7ms | 0.3% | 21.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1655` |
| 0.3% | 21.1ms | 0.1% | 7.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1627` |
| 0.3% | 20.8ms | 0.3% | 20.8ms | `_getTypeProto` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3978` |
| 0.3% | 20.5ms | 0.3% | 20.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4004` |
| 0.3% | 20.4ms | 0.3% | 20.4ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 20.0ms | 0.0% | 3.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2820` |
| 0.2% | 19.8ms | 0.2% | 19.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 19.4ms | 0.2% | 19.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3998` |
| 0.2% | 19.3ms | 0.2% | 19.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1962` |
| 0.2% | 19.2ms | 0.1% | 9.9ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2437` |
| 0.2% | 18.9ms | 0.2% | 18.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3986` |
| 0.2% | 18.9ms | 0.2% | 18.9ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2750` |
| 0.2% | 18.7ms | 0.0% | 1.5ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1914` |
| 0.2% | 18.7ms | 0.2% | 18.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3997` |
| 0.2% | 18.7ms | 0.2% | 18.7ms | `has` | `[native code]` |
| 0.2% | 18.5ms | 0.2% | 18.5ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2457` |
| 0.2% | 18.3ms | 0.2% | 16.8ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3040` |
| 0.2% | 18.2ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1636` |
| 0.2% | 17.9ms | 0.2% | 17.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3995` |
| 0.2% | 17.6ms | 0.2% | 15.8ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1622` |
| 0.2% | 17.4ms | 0.2% | 17.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1295` |
| 0.2% | 17.4ms | 0.0% | 6.6ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1703` |
| 0.2% | 17.1ms | 0.2% | 17.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4003` |
| 0.2% | 17.0ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:144` |
| 0.2% | 17.0ms | 0.0% | 4.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` |
| 0.2% | 16.6ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4065` |
| 0.2% | 16.5ms | 0.1% | 13.2ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` |
| 0.2% | 16.5ms | 0.2% | 16.5ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:818` |
| 0.2% | 16.0ms | 0.1% | 7.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1228` |
| 0.2% | 16.0ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` |
| 0.2% | 15.9ms | 0.2% | 15.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2175` |
| 0.2% | 15.8ms | 0.0% | 5.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2492` |
| 0.2% | 15.6ms | 0.1% | 9.4ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1676` |
| 0.2% | 15.5ms | 0.2% | 15.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4006` |
| 0.2% | 15.1ms | 0.1% | 10.3ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` |
| 0.2% | 14.7ms | 0.2% | 14.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3996` |
| 0.2% | 14.6ms | 0.2% | 14.6ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2895` |
| 0.2% | 14.6ms | 0.0% | 1.6ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:412` |
| 0.2% | 14.4ms | 0.2% | 14.4ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3051` |
| 0.2% | 14.3ms | 0.2% | 14.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1707` |
| 0.2% | 14.1ms | 0.1% | 7.9ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:410` |
| 0.2% | 14.0ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6865` |
| 0.1% | 13.5ms | 0.1% | 13.5ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4793` |
| 0.1% | 13.3ms | 0.1% | 13.3ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2941` |
| 0.1% | 13.0ms | 0.0% | 1.0ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1700` |
| 0.1% | 12.8ms | 0.1% | 12.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 12.6ms | 0.0% | 0us | `parseModule` | `[native code]` |
| 0.1% | 12.6ms | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 0.1% | 12.3ms | 0.1% | 12.3ms | `decode` | `[native code]` |
| 0.1% | 12.3ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7377` |
| 0.1% | 12.3ms | 0.0% | 0us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:511` |
| 0.1% | 12.3ms | 0.1% | 12.3ms | `/^(?:Function(?:Declaration\|Expression)\|ArrowFunctionExpression)$/u` | `[native code]` |
| 0.1% | 12.1ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` |
| 0.1% | 12.0ms | 0.1% | 12.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6866` |
| 0.1% | 11.3ms | 0.1% | 11.3ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.1% | 11.3ms | 0.1% | 7.8ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:682` |
| 0.1% | 11.0ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:54` |
| 0.1% | 10.9ms | 0.1% | 10.9ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6358` |
| 0.1% | 10.6ms | 0.0% | 3.0ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1730` |
| 0.1% | 10.5ms | 0.1% | 10.5ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2344` |
| 0.1% | 10.4ms | 0.1% | 10.4ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 10.3ms | 0.1% | 10.3ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2946` |
| 0.1% | 10.3ms | 0.0% | 1.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1669` |
| 0.1% | 10.2ms | 0.0% | 4.0ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.1% | 10.2ms | 0.1% | 10.2ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` |
| 0.1% | 10.2ms | 0.1% | 10.2ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1067` |
| 0.1% | 10.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` |
| 0.1% | 10.0ms | 0.1% | 10.0ms | `isSelfReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` |
| 0.1% | 9.9ms | 0.1% | 9.9ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 9.9ms | 0.1% | 7.1ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1674` |
| 0.1% | 9.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:12` |
| 0.1% | 9.4ms | 0.0% | 3.2ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.1% | 9.3ms | 0.1% | 9.3ms | `/^(?:DoWhile\|For\|ForIn\|ForOf\|While)Statement$/u` | `[native code]` |
| 0.1% | 9.3ms | 0.1% | 9.3ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2915` |
| 0.1% | 8.9ms | 0.0% | 1.7ms | `exec` | `[native code]` |
| 0.1% | 8.7ms | 0.0% | 2.7ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1638` |
| 0.1% | 8.7ms | 0.1% | 8.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6868` |
| 0.1% | 8.5ms | 0.1% | 8.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2179` |
| 0.1% | 8.3ms | 0.0% | 5.1ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:653` |
| 0.1% | 8.2ms | 0.1% | 8.2ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1007` |
| 0.1% | 8.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:25` |
| 0.1% | 8.1ms | 0.1% | 8.1ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2858` |
| 0.1% | 7.8ms | 0.1% | 7.8ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4056` |
| 0.1% | 7.8ms | 0.0% | 4.9ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` |
| 0.1% | 7.7ms | 0.0% | 4.6ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2909` |
| 0.1% | 7.6ms | 0.1% | 7.6ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1970` |
| 0.1% | 7.6ms | 0.0% | 3.3ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:447` |
| 0.1% | 7.4ms | 0.1% | 7.4ms | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 7.4ms | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:575` |
| 0.1% | 6.9ms | 0.1% | 6.9ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2641` |
| 0.0% | 6.6ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:441` |
| 0.0% | 6.5ms | 0.0% | 3.3ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.0% | 6.4ms | 0.0% | 6.4ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3025` |
| 0.0% | 6.3ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:557` |
| 0.0% | 6.2ms | 0.0% | 6.2ms | `getUint32` | `[native code]` |
| 0.0% | 6.1ms | 0.0% | 6.1ms | `/^\s*exported\b/` | `[native code]` |
| 0.0% | 6.0ms | 0.0% | 0us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2461` |
| 0.0% | 6.0ms | 0.0% | 2.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1674` |
| 0.0% | 6.0ms | 0.0% | 6.0ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` |
| 0.0% | 5.9ms | 0.0% | 4.5ms | `readdirSync` | `[native code]` |
| 0.0% | 5.9ms | 0.0% | 5.9ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2744` |
| 0.0% | 5.9ms | 0.0% | 5.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1185` |
| 0.0% | 5.9ms | 0.0% | 4.5ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` |
| 0.0% | 5.8ms | 0.0% | 1.7ms | `map` | `[native code]` |
| 0.0% | 5.8ms | 0.0% | 5.8ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 5.8ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:661` |
| 0.0% | 5.6ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7384` |
| 0.0% | 5.6ms | 0.0% | 2.9ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1680` |
| 0.0% | 5.6ms | 0.0% | 5.6ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:773` |
| 0.0% | 5.6ms | 0.0% | 0us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1337` |
| 0.0% | 5.2ms | 0.0% | 3.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2069` |
| 0.0% | 4.9ms | 0.0% | 4.9ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1639` |
| 0.0% | 4.9ms | 0.0% | 4.9ms | `test` | `[native code]` |
| 0.0% | 4.8ms | 0.0% | 4.8ms | `DataView` | `[native code]` |
| 0.0% | 4.8ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:276` |
| 0.0% | 4.8ms | 0.0% | 4.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6627` |
| 0.0% | 4.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.0% | 4.7ms | 0.0% | 4.7ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2835` |
| 0.0% | 4.7ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` |
| 0.0% | 4.7ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3789` |
| 0.0% | 4.6ms | 0.0% | 4.6ms | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:511` |
| 0.0% | 4.6ms | 0.0% | 0us | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:809` |
| 0.0% | 4.6ms | 0.0% | 0us | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:506` |
| 0.0% | 4.5ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:47` |
| 0.0% | 4.5ms | 0.0% | 4.5ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 4.5ms | 0.0% | 4.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 4.5ms | 0.0% | 4.5ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:435` |
| 0.0% | 4.4ms | 0.0% | 4.4ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3034` |
| 0.0% | 4.3ms | 0.0% | 1.3ms | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:689` |
| 0.0% | 4.3ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1483` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3637` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2183` |
| 0.0% | 4.2ms | 0.0% | 4.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1227` |
| 0.0% | 4.1ms | 0.0% | 2.9ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:494` |
| 0.0% | 4.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3071` |
| 0.0% | 3.6ms | 0.0% | 3.6ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4244` |
| 0.0% | 3.5ms | 0.0% | 1.7ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2907` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3042` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:542` |
| 0.0% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` |
| 0.0% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.0% | 3.3ms | 0.0% | 1.6ms | `init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2910` |
| 0.0% | 3.3ms | 0.0% | 1.7ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:887` |
| 0.0% | 3.3ms | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3724` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1829` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6624` |
| 0.0% | 3.2ms | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:411` |
| 0.0% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2874` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:582` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:395` |
| 0.0% | 3.1ms | 0.0% | 1.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3056` |
| 0.0% | 3.1ms | 0.0% | 1.8ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1937` |
| 0.0% | 3.1ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:654` |
| 0.0% | 3.0ms | 0.0% | 0us | `async lintSource` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:462` |
| 0.0% | 3.0ms | 0.0% | 0us | `async _resolveConfig` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:71` |
| 0.0% | 3.0ms | 0.0% | 0us | `async lintSource` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:461` |
| 0.0% | 3.0ms | 0.0% | 0us | `async _resolveConfig` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:68` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` |
| 0.0% | 3.0ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:76` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4057` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:419` |
| 0.0% | 3.0ms | 0.0% | 0us | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1801` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6360` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:865` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `existsSync` | `[native code]` |
| 0.0% | 2.9ms | 0.0% | 0us | `existsSync` | `node:fs:273` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4243` |
| 0.0% | 2.9ms | 0.0% | 0us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:688` |
| 0.0% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:11` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1973` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1618` |
| 0.0% | 2.8ms | 0.0% | 0us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3054` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1626` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3032` |
| 0.0% | 2.7ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1699` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:665` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4011` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2177` |
| 0.0% | 2.6ms | 0.0% | 2.6ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2773` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1200` |
| 0.0% | 2.5ms | 0.0% | 1.2ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2956` |
| 0.0% | 1.8ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6422` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2720` |
| 0.0% | 1.8ms | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:658` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:512` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `encodeInto` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:92` |
| 0.0% | 1.7ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:215` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `replace` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4062` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3882` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1684` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1708` |
| 0.0% | 1.7ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1716` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4032` |
| 0.0% | 1.7ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2364` |
| 0.0% | 1.7ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1931` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `error` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:43` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2434` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:3192` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:508` |
| 0.0% | 1.7ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2002` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3013` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:540` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1790` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2672` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1201` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1714` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:558` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:21` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7034` |
| 0.0% | 1.5ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6526` |
| 0.0% | 1.5ms | 0.0% | 0us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5773` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4841` |
| 0.0% | 1.5ms | 0.0% | 0us | `_getOrBuildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5455` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4008` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 0us | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1769` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `findIndex` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1635` |
| 0.0% | 1.5ms | 0.0% | 0us | `async _loadFlatConfig` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:37` |
| 0.0% | 1.5ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:38` |
| 0.0% | 1.5ms | 0.0% | 0us | `async _loadFlatConfig` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:43` |
| 0.0% | 1.5ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:85` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.5ms | 0.0% | 0us | `get kind` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2626` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `/\{\{(\w+)\}\}/g` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3059` |
| 0.0% | 1.5ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:31` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1826` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:43` |
| 0.0% | 1.5ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:34` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1325` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6419` |
| 0.0% | 1.4ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1689` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1492` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 1.4ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6744` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `indexOf` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:647` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `getLocFromIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3345` |
| 0.0% | 1.4ms | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3744` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_findLine` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:461` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `entries` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4234` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1756` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1711` |
| 0.0% | 1.4ms | 0.0% | 0us | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3574` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_isStatementTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.4ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1482` |
| 0.0% | 1.4ms | 0.0% | 0us | `_interopNamespaceDefault` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:10` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:24` |
| 0.0% | 1.4ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:53` |
| 0.0% | 1.4ms | 0.0% | 0us | `rewrittenPath` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:19` |
| 0.0% | 1.3ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:551` |
| 0.0% | 1.3ms | 0.0% | 0us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3019` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2612` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:828` |
| 0.0% | 1.3ms | 0.0% | 0us | `node:events` | `node:events:9` |
| 0.0% | 1.3ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.0% | 1.3ms | 0.0% | 0us | `range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3594` |
| 0.0% | 1.3ms | 0.0% | 0us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2637` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get start` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4260` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1637` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:664` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1935` |
| 0.0% | 1.3ms | 0.0% | 0us | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2269` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1474` |
| 0.0% | 1.3ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1684` |
| 0.0% | 1.3ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1712` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getDefinedMessageData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:283` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:185` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1703` |
| 0.0% | 1.2ms | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1640` |
| 0.0% | 1.2ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4228` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:121` |
| 0.0% | 1.2ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1731` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1330` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3049` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1628` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3594` |
| 0.0% | 1.0ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1478` |

## Function Details

### `parse`
`[native code]` | Self: 19.5% (1.33s) | Total: 19.5% (1.33s) | Samples: 878

**Called by:**
- `parseSource` (878)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3994` | Self: 6.3% (432.7ms) | Total: 6.6% (453.5ms) | Samples: 280

**Called by:**
- `nodeView` (206)
- `get parent` (36)
- `_buildThinVariable` (20)
- `_nodesFromRange` (14)
- `nodeViewChain` (6)
- `get body` (5)
- `get body` (4)
- `_buildReference` (2)

**Calls:**
- `_getTypeProto` (13)

### `Set`
`[native code]` | Self: 4.6% (318.1ms) | Total: 4.6% (318.1ms) | Samples: 207

**Called by:**
- `_buildScope` (106)
- `getDeclaredVariables` (100)
- `getDeclaredVariables` (1)

### `defineProperties`
`[native code]` | Self: 3.6% (250.9ms) | Total: 3.6% (250.9ms) | Samples: 163

**Called by:**
- `_buildScope` (163)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6867` | Self: 3.1% (216.9ms) | Total: 3.6% (250.9ms) | Samples: 146

**Called by:**
- `runPlugins` (169)

**Calls:**
- `get allSkipped` (14)
- `get allSkipped` (9)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1285` | Self: 2.8% (192.4ms) | Total: 3.3% (227.8ms) | Samples: 127

**Called by:**
- `_buildReference` (110)
- `_buildReference` (11)
- `_findDefNode` (10)
- `isInLoop` (7)
- `_buildThinVariable` (5)
- `isForInOfRef` (3)
- `(anonymous)` (1)
- `_computeIsStrict` (1)
- `_findDefNode` (1)
- `isForInOfRef` (1)

**Calls:**
- `get _tag` (13)
- `get _tag` (10)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3052` | Self: 2.5% (177.4ms) | Total: 2.6% (178.8ms) | Samples: 116

**Called by:**
- `isAfterLastUsedArg` (117)

**Calls:**
- `get` (1)

### `get _tag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 2.0% (138.5ms) | Total: 2.0% (138.5ms) | Samples: 89

**Called by:**
- `get parent` (29)
- `get parent` (22)
- `get parent` (13)
- `get parent` (13)
- `get parent` (10)
- `get body` (2)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3058` | Self: 1.9% (131.3ms) | Total: 1.9% (133.1ms) | Samples: 85

**Called by:**
- `isAfterLastUsedArg` (84)
- `isAfterLastUsedArg` (2)

**Calls:**
- `set` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1222` | Self: 1.9% (130.4ms) | Total: 2.2% (153.3ms) | Samples: 87

**Called by:**
- `_findDefNode` (30)
- `isInLoop` (27)
- `_buildReference` (17)
- `_buildThinVariable` (9)
- `isForInOfRef` (7)
- `getRhsNode` (5)
- `_computeIsStrict` (2)
- `(anonymous)` (1)
- `isReadForItself` (1)
- `_findDefNode` (1)
- `_findDefNode` (1)
- `isForInOfRef` (1)

**Calls:**
- `get _tag` (10)
- `get _tag` (5)

### `get _tag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1072` | Self: 1.6% (110.6ms) | Total: 1.6% (110.6ms) | Samples: 72

**Called by:**
- `get parent` (25)
- `get parent` (13)
- `get parent` (10)
- `get parent` (8)
- `get parent` (5)
- `_findDefNode` (4)
- `_buildScope` (2)
- `_findDefNode` (2)
- `get kind` (1)
- `_findDefNode` (1)
- `init` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4005` | Self: 1.3% (89.3ms) | Total: 1.3% (89.3ms) | Samples: 58

**Called by:**
- `nodeView` (42)
- `get parent` (8)
- `_buildThinVariable` (6)
- `_buildThinScope` (1)
- `isReadForItself` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2543` | Self: 1.2% (86.6ms) | Total: 1.3% (90.9ms) | Samples: 58

**Called by:**
- `_buildScopeVarsAndSet` (41)
- `getDeclaredVariables` (20)

**Calls:**
- `_buildThinScope` (3)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4001` | Self: 1.2% (85.6ms) | Total: 1.2% (85.6ms) | Samples: 56

**Called by:**
- `nodeView` (29)
- `get parent` (12)
- `_buildThinVariable` (11)
- `_buildReference` (3)
- `_nodesFromRange` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2964` | Self: 1.2% (82.7ms) | Total: 1.2% (82.7ms) | Samples: 54

**Called by:**
- `_buildThinVariable` (47)
- `_buildThinScope` (7)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1624` | Self: 1.1% (81.8ms) | Total: 1.7% (120.0ms) | Samples: 53

**Called by:**
- `_buildScopeVarsAndSet` (77)

**Calls:**
- `set` (24)

### `get`
`[native code]` | Self: 1.1% (80.7ms) | Total: 1.1% (80.7ms) | Samples: 52

**Called by:**
- `_ensureDeclSymIndex` (46)
- `_ensureDeclSymIndex` (4)
- `getDeclaredVariables` (1)
- `getDeclaredVariables` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1006` | Self: 1.1% (79.9ms) | Total: 1.1% (79.9ms) | Samples: 51

**Called by:**
- `(anonymous)` (11)
- `_computeIsStrict` (9)
- `isFunction` (9)
- `_buildReference` (5)
- `isForInOfRef` (4)
- `isLoop` (3)
- `_buildScope` (2)
- `isForInOfRef` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `isReadForItself` (1)
- `collectUnusedVariables` (1)
- `isReadForItself` (1)
- `isForInOfRef` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2821` | Self: 1.0% (71.3ms) | Total: 2.2% (156.2ms) | Samples: 47

**Called by:**
- `_buildVariable` (102)

**Calls:**
- `get type` (21)
- `get type` (18)
- `get type` (8)
- `get type` (5)
- `get type` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6623` | Self: 0.9% (62.4ms) | Total: 0.9% (62.4ms) | Samples: 41

**Called by:**
- `runPlugins` (41)

### `isFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:152` | Self: 0.8% (58.8ms) | Total: 1.5% (109.1ms) | Samples: 38

**Called by:**
- `isInLoop` (64)
- `collectUnusedVariables` (7)

**Calls:**
- `get type` (13)
- `get type` (9)
- `/^(?:Function(?:Declaration\|Expression)\|ArrowFunctionExpression)$/u` (8)
- `get type` (2)
- `get type` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1976` | Self: 0.8% (58.3ms) | Total: 0.8% (59.8ms) | Samples: 38

**Called by:**
- `ensureVarsSet` (39)

**Calls:**
- `set` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.7% (53.2ms) | Total: 0.7% (53.2ms) | Samples: 34

**Called by:**
- `(anonymous)` (11)
- `(anonymous)` (5)
- `isForInOfRef` (5)
- `collectUnusedVariables` (3)
- `_computeIsStrict` (2)
- `isFunction` (2)
- `(anonymous)` (1)
- `collectUnusedVariables` (1)
- `isReadForItself` (1)
- `isReadForItself` (1)
- `getRhsNode` (1)
- `isForInOfRef` (1)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2878` | Self: 0.7% (52.8ms) | Total: 2.0% (141.2ms) | Samples: 34

**Called by:**
- `_buildThinScope` (89)

**Calls:**
- `get parent` (23)
- `get parent` (9)
- `get parent` (8)
- `get parent` (5)
- `get parent` (4)
- `get parent` (4)
- `get parent` (1)
- `get parent` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` | Self: 0.7% (52.4ms) | Total: 0.7% (52.4ms) | Samples: 34

**Called by:**
- `_precomputeScopes` (34)

### `/\/\*([\s\S]*?)\*\//g`
`[native code]` | Self: 0.6% (47.4ms) | Total: 0.6% (47.4ms) | Samples: 32

**Called by:**
- `_buildScopeVarsAndSet` (27)
- `exec` (5)

### `set`
`[native code]` | Self: 0.6% (41.4ms) | Total: 0.6% (41.4ms) | Samples: 26

**Called by:**
- `_ensureDeclSymIndex` (24)
- `getDeclaredVariables` (1)
- `_buildScopeVarsAndSet` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2487` | Self: 0.5% (40.1ms) | Total: 27.7% (1.89s) | Samples: 27

**Called by:**
- `_buildScopeVarsAndSet` (1040)
- `getDeclaredVariables` (198)

**Calls:**
- `_buildReference` (483)
- `_buildReference` (397)
- `_buildReference` (179)
- `_buildReference` (102)
- `_buildReference` (17)
- `_buildReference` (17)
- `_buildReference` (13)
- `_buildReference` (2)
- `push` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1011` | Self: 0.5% (40.1ms) | Total: 0.5% (40.1ms) | Samples: 26

**Called by:**
- `isFunction` (13)
- `_buildReference` (8)
- `isLoop` (3)
- `getRhsNode` (2)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1175` | Self: 0.5% (39.8ms) | Total: 0.5% (39.8ms) | Samples: 26

**Called by:**
- `_buildVariable` (10)
- `_computeIsStrict` (6)
- `_buildReference` (4)
- `(anonymous)` (2)
- `_findDefNode` (2)
- `collectUnusedVariables` (1)
- `isInLoop` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` | Self: 0.5% (39.6ms) | Total: 1.5% (108.4ms) | Samples: 27

**Called by:**
- `some` (72)

**Calls:**
- `get type` (11)
- `get type` (11)
- `get parent` (6)
- `get parent` (6)
- `get type` (3)
- `get parent` (2)
- `get parent` (2)
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)

### `push`
`[native code]` | Self: 0.5% (37.5ms) | Total: 0.5% (37.5ms) | Samples: 26

**Called by:**
- `_ensureDeclSymIndex` (19)
- `getDeclaredVariables` (2)
- `_ensureDeclSymIndex` (1)
- `buildVisitorMap` (1)
- `_buildVariable` (1)
- `commentsInRange` (1)
- `getDeclaredVariables` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1255` | Self: 0.5% (36.5ms) | Total: 1.7% (121.9ms) | Samples: 25

**Called by:**
- `_buildReference` (41)
- `_findDefNode` (14)
- `isInLoop` (9)
- `_buildThinVariable` (8)
- `isForInOfRef` (4)
- `_findDefNode` (2)
- `_findDefNode` (1)

**Calls:**
- `get _tag` (29)
- `get _tag` (25)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2534` | Self: 0.4% (34.0ms) | Total: 0.7% (54.1ms) | Samples: 23

**Called by:**
- `_buildScopeVarsAndSet` (33)
- `getDeclaredVariables` (3)

**Calls:**
- `get parent` (10)
- `get parent` (3)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1019` | Self: 0.4% (32.0ms) | Total: 0.4% (32.0ms) | Samples: 21

**Called by:**
- `_buildReference` (21)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2947` | Self: 0.4% (31.5ms) | Total: 0.4% (31.5ms) | Samples: 22

**Called by:**
- `_buildThinVariable` (14)
- `_buildVariable` (3)
- `_buildThinScope` (3)
- `_buildReference` (2)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2796` | Self: 0.4% (31.4ms) | Total: 10.8% (738.1ms) | Samples: 21

**Called by:**
- `_buildVariable` (483)

**Calls:**
- `_buildThinScope` (440)
- `_buildThinScope` (19)
- `_buildThinScope` (2)
- `_buildThinScope` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1892` | Self: 0.4% (31.2ms) | Total: 4.1% (282.1ms) | Samples: 21

**Called by:**
- `_buildScopeChildren` (182)
- `_buildScope` (2)

**Calls:**
- `defineProperties` (163)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4002` | Self: 0.4% (30.5ms) | Total: 0.4% (30.5ms) | Samples: 20

**Called by:**
- `nodeView` (12)
- `get parent` (6)
- `_buildReference` (1)
- `_buildThinVariable` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1274` | Self: 0.4% (30.3ms) | Total: 1.2% (83.0ms) | Samples: 20

**Called by:**
- `_buildReference` (35)
- `_findDefNode` (7)
- `isForInOfRef` (5)
- `_buildThinVariable` (4)
- `isInLoop` (4)

**Calls:**
- `get _tag` (22)
- `get _tag` (13)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2477` | Self: 0.4% (29.3ms) | Total: 0.4% (29.3ms) | Samples: 19

**Called by:**
- `_buildScopeVarsAndSet` (13)
- `getDeclaredVariables` (6)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3050` | Self: 0.4% (28.0ms) | Total: 6.0% (411.0ms) | Samples: 18

**Called by:**
- `isAfterLastUsedArg` (270)

**Calls:**
- `_buildVariable` (198)
- `_buildVariable` (20)
- `_buildVariable` (9)
- `_buildVariable` (6)
- `_buildVariable` (4)
- `_buildVariable` (4)
- `_buildVariable` (3)
- `_buildVariable` (3)
- `_buildVariable` (2)
- `_buildVariable` (2)
- `_buildVariable` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1625` | Self: 0.4% (27.5ms) | Total: 0.8% (55.2ms) | Samples: 18

**Called by:**
- `_buildScopeVarsAndSet` (37)

**Calls:**
- `push` (19)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3018` | Self: 0.4% (27.4ms) | Total: 0.4% (28.9ms) | Samples: 17

**Called by:**
- `isAfterLastUsedArg` (18)

**Calls:**
- `_ensureDeclSymIndex` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1013` | Self: 0.3% (27.2ms) | Total: 0.3% (27.2ms) | Samples: 18

**Called by:**
- `_buildReference` (18)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3991` | Self: 0.3% (26.7ms) | Total: 0.3% (26.7ms) | Samples: 18

**Called by:**
- `nodeView` (9)
- `_nodesFromRange` (3)
- `_buildThinVariable` (2)
- `_buildScope` (1)
- `get body` (1)
- `_buildVariable` (1)
- `isReadForItself` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2798` | Self: 0.3% (26.5ms) | Total: 0.3% (26.5ms) | Samples: 17

**Called by:**
- `_buildVariable` (17)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4000` | Self: 0.3% (24.8ms) | Total: 0.3% (24.8ms) | Samples: 16

**Called by:**
- `nodeView` (9)
- `get parent` (3)
- `get body` (1)
- `get body` (1)
- `_buildReference` (1)
- `_buildThinVariable` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2930` | Self: 0.3% (23.8ms) | Total: 100.0% (11.40s) | Samples: 16

**Called by:**
- `_buildThinScope` (5123)
- `_buildThinVariable` (1900)
- `_buildReference` (440)

**Calls:**
- `_buildThinScope` (5123)
- `_buildThinScope` (2309)
- `_buildThinScope` (7)
- `_buildThinScope` (3)
- `_buildThinScope` (2)
- `_buildThinScope` (1)
- `_buildThinScope` (1)
- `_buildThinScope` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1690` | Self: 0.3% (23.0ms) | Total: 2.8% (192.8ms) | Samples: 15

**Called by:**
- `_buildScopeChildren` (125)
- `_precomputeScopes` (1)

**Calls:**
- `_computeIsStrict` (77)
- `_computeIsStrict` (18)
- `_computeIsStrict` (12)
- `_computeIsStrict` (2)
- `_computeIsStrict` (1)
- `_computeIsStrict` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2067` | Self: 0.3% (22.8ms) | Total: 1.0% (72.0ms) | Samples: 15

**Called by:**
- `ensureVarsSet` (48)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (27)
- `exec` (6)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3031` | Self: 0.3% (22.4ms) | Total: 2.5% (172.2ms) | Samples: 14

**Called by:**
- `isAfterLastUsedArg` (114)

**Calls:**
- `Set` (100)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3999` | Self: 0.3% (22.1ms) | Total: 0.3% (22.1ms) | Samples: 15

**Called by:**
- `nodeView` (9)
- `_buildThinVariable` (2)
- `get parent` (2)
- `_buildReference` (1)
- `_nodesFromRange` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7035` | Self: 0.3% (22.1ms) | Total: 0.3% (22.1ms) | Samples: 14

**Called by:**
- `runPlugins` (14)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1655` | Self: 0.3% (21.7ms) | Total: 0.3% (21.7ms) | Samples: 15

**Called by:**
- `_buildScopeChildren` (12)
- `_buildScope` (3)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:434` | Self: 0.3% (21.0ms) | Total: 0.3% (22.3ms) | Samples: 15

**Called by:**
- `_buildThinVariable` (9)
- `_buildVariable` (7)

**Calls:**
- `get _tag` (1)

### `_getTypeProto`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3978` | Self: 0.3% (20.8ms) | Total: 0.3% (20.8ms) | Samples: 13

**Called by:**
- `_nodeViewRaw` (13)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4004` | Self: 0.3% (20.5ms) | Total: 0.3% (20.5ms) | Samples: 13

**Called by:**
- `nodeView` (9)
- `get parent` (3)
- `_buildThinVariable` (1)

### `get allSkipped`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.3% (20.4ms) | Total: 0.3% (20.4ms) | Samples: 14

**Called by:**
- `walkNodes` (14)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.2% (19.8ms) | Total: 0.2% (19.8ms) | Samples: 13

**Called by:**
- `_buildVariable` (3)
- `_findDefNode` (3)
- `collectUnusedVariables` (2)
- `isReadForItself` (1)
- `_buildReference` (1)
- `collectUnusedVariables` (1)
- `_findDefNode` (1)
- `_buildThinVariable` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3998` | Self: 0.2% (19.4ms) | Total: 0.2% (19.4ms) | Samples: 12

**Called by:**
- `nodeView` (6)
- `get parent` (3)
- `nodeViewChain` (2)
- `_buildThinVariable` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1962` | Self: 0.2% (19.3ms) | Total: 0.2% (19.3ms) | Samples: 13

**Called by:**
- `ensureVarsSet` (13)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:749` | Self: 0.2% (19.1ms) | Total: 0.3% (23.4ms) | Samples: 13

**Called by:**
- `collectUnusedVariables` (15)

**Calls:**
- `getDeclaredVariables` (2)

### `anonymous`
`[native code]` | Self: 0.2% (19.0ms) | Total: 0.8% (57.2ms) | Samples: 12

**Called by:**
- `require` (32)
- `bound require` (2)
- `node:fs` (1)
- `node:events` (1)

**Calls:**
- `(anonymous)` (6)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `node:fs` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:events` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3986` | Self: 0.2% (18.9ms) | Total: 0.2% (18.9ms) | Samples: 13

**Called by:**
- `_nodesFromRange` (4)
- `(anonymous)` (3)
- `get body` (2)
- `get parent` (2)
- `_buildVariable` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2750` | Self: 0.2% (18.9ms) | Total: 0.2% (18.9ms) | Samples: 12

**Called by:**
- `_buildScopeVarsAndSet` (10)
- `getDeclaredVariables` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3997` | Self: 0.2% (18.7ms) | Total: 0.2% (18.7ms) | Samples: 12

**Called by:**
- `nodeView` (6)
- `_buildThinVariable` (3)
- `get parent` (1)
- `get body` (1)
- `_buildScope` (1)

### `has`
`[native code]` | Self: 0.2% (18.7ms) | Total: 0.2% (18.7ms) | Samples: 12

**Called by:**
- `_ensureDeclSymIndex` (9)
- `_buildScopeVarsAndSet` (1)
- `walkNodes` (1)
- `_ensureDeclSymIndex` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2457` | Self: 0.2% (18.5ms) | Total: 0.2% (18.5ms) | Samples: 12

**Called by:**
- `_buildScopeVarsAndSet` (10)
- `getDeclaredVariables` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` | Self: 0.2% (18.0ms) | Total: 46.4% (3.17s) | Samples: 12

**Called by:**
- `collectUnusedVariables` (1355)
- `Program:exit` (719)

**Calls:**
- `get` (1546)
- `get` (496)
- `get` (19)
- `get` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1863` | Self: 0.2% (17.9ms) | Total: 2.7% (184.8ms) | Samples: 12

**Called by:**
- `_buildScopeChildren` (118)

**Calls:**
- `Set` (106)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3995` | Self: 0.2% (17.9ms) | Total: 0.2% (17.9ms) | Samples: 12

**Called by:**
- `nodeView` (7)
- `get parent` (3)
- `_buildThinVariable` (1)
- `nodeViewChain` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1295` | Self: 0.2% (17.4ms) | Total: 0.2% (17.4ms) | Samples: 12

**Called by:**
- `(anonymous)` (6)
- `_buildReference` (4)
- `_findDefNode` (1)
- `collectUnusedVariables` (1)

### `isLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:168` | Self: 0.2% (17.1ms) | Total: 0.5% (36.0ms) | Samples: 11

**Called by:**
- `isInLoop` (23)

**Calls:**
- `/^(?:DoWhile\|For\|ForIn\|ForOf\|While)Statement$/u` (6)
- `get type` (3)
- `get type` (3)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4003` | Self: 0.2% (17.1ms) | Total: 0.2% (17.1ms) | Samples: 11

**Called by:**
- `nodeView` (9)
- `get parent` (1)
- `_nodesFromRange` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3040` | Self: 0.2% (16.8ms) | Total: 0.2% (18.3ms) | Samples: 11

**Called by:**
- `isAfterLastUsedArg` (12)

**Calls:**
- `Set` (1)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:818` | Self: 0.2% (16.5ms) | Total: 0.2% (16.5ms) | Samples: 11

**Called by:**
- `_symName` (11)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` | Self: 0.2% (16.1ms) | Total: 0.5% (34.1ms) | Samples: 11

**Called by:**
- `collectUnusedVariables` (23)

**Calls:**
- `get type` (3)
- `get type` (2)
- `get parent` (2)
- `get parent` (1)
- `get type` (1)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2175` | Self: 0.2% (15.9ms) | Total: 0.2% (15.9ms) | Samples: 10

**Called by:**
- `ensureVarsSet` (10)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1622` | Self: 0.2% (15.8ms) | Total: 0.2% (17.6ms) | Samples: 11

**Called by:**
- `_buildScopeVarsAndSet` (12)

**Calls:**
- `has` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` | Self: 0.2% (15.7ms) | Total: 0.3% (23.3ms) | Samples: 10

**Called by:**
- `(anonymous)` (15)

**Calls:**
- `get parent` (5)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4006` | Self: 0.2% (15.5ms) | Total: 0.2% (15.5ms) | Samples: 10

**Called by:**
- `nodeView` (5)
- `_buildThinVariable` (4)
- `get parent` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3996` | Self: 0.2% (14.7ms) | Total: 0.2% (14.7ms) | Samples: 9

**Called by:**
- `nodeView` (6)
- `_buildThinVariable` (3)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2895` | Self: 0.2% (14.6ms) | Total: 0.2% (14.6ms) | Samples: 10

**Called by:**
- `_buildThinScope` (10)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3051` | Self: 0.2% (14.4ms) | Total: 0.2% (14.4ms) | Samples: 9

**Called by:**
- `isAfterLastUsedArg` (9)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1960` | Self: 0.2% (14.4ms) | Total: 5.0% (348.0ms) | Samples: 10

**Called by:**
- `ensureVarsSet` (227)
- `ensureVarsSet` (1)

**Calls:**
- `_ensureDeclSymIndex` (77)
- `_ensureDeclSymIndex` (50)
- `_ensureDeclSymIndex` (37)
- `_ensureDeclSymIndex` (14)
- `_ensureDeclSymIndex` (12)
- `_ensureDeclSymIndex` (12)
- `_ensureDeclSymIndex` (6)
- `_ensureDeclSymIndex` (3)
- `_ensureDeclSymIndex` (2)
- `_ensureDeclSymIndex` (2)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1707` | Self: 0.2% (14.3ms) | Total: 0.2% (14.3ms) | Samples: 9

**Called by:**
- `_buildScopeChildren` (8)
- `_buildScope` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` | Self: 0.2% (14.1ms) | Total: 8.3% (567.6ms) | Samples: 9

**Called by:**
- `collectUnusedVariables` (368)
- `Program:exit` (1)

**Calls:**
- `isUsedVariable` (269)
- `isUsedVariable` (55)
- `some` (29)
- `isUsedVariable` (7)

### `get allSkipped`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4793` | Self: 0.1% (13.5ms) | Total: 0.1% (13.5ms) | Samples: 9

**Called by:**
- `walkNodes` (9)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2941` | Self: 0.1% (13.3ms) | Total: 0.1% (13.3ms) | Samples: 9

**Called by:**
- `_buildThinVariable` (8)
- `_buildThinScope` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` | Self: 0.1% (13.2ms) | Total: 0.2% (16.5ms) | Samples: 9

**Called by:**
- `(anonymous)` (11)

**Calls:**
- `get type` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (12.8ms) | Total: 0.1% (12.8ms) | Samples: 8

**Called by:**
- `getDeclaredVariables` (4)
- `_buildScopeVarsAndSet` (4)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1237` | Self: 0.1% (12.7ms) | Total: 0.6% (46.0ms) | Samples: 8

**Called by:**
- `_buildReference` (18)
- `_buildThinVariable` (4)
- `isInLoop` (3)
- `isUnusedExpression` (2)
- `isForInOfRef` (1)
- `_findDefNode` (1)

**Calls:**
- `get _tag` (13)
- `get _tag` (8)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1189` | Self: 0.1% (12.5ms) | Total: 5.4% (372.1ms) | Samples: 8

**Called by:**
- `_buildReference` (158)
- `_findDefNode` (31)
- `_buildThinVariable` (23)
- `isInLoop` (9)
- `(anonymous)` (6)
- `_computeIsStrict` (4)
- `isForInOfRef` (3)
- `isUnusedExpression` (1)
- `collectUnusedVariables` (1)
- `_findDefNode` (1)
- `collectUnusedVariables` (1)

**Calls:**
- `nodeView` (145)
- `_nodeViewRaw` (36)
- `_nodeViewRaw` (12)
- `_nodeViewRaw` (8)
- `_nodeViewRaw` (6)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `decode`
`[native code]` | Self: 0.1% (12.3ms) | Total: 0.1% (12.3ms) | Samples: 8

**Called by:**
- `get source` (8)

### `/^(?:Function(?:Declaration\|Expression)\|ArrowFunctionExpression)$/u`
`[native code]` | Self: 0.1% (12.3ms) | Total: 0.1% (12.3ms) | Samples: 8

**Called by:**
- `isFunction` (8)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6866` | Self: 0.1% (12.0ms) | Total: 0.1% (12.0ms) | Samples: 8

**Called by:**
- `runPlugins` (8)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2872` | Self: 0.1% (11.4ms) | Total: 3.0% (208.2ms) | Samples: 8

**Called by:**
- `_buildThinScope` (137)

**Calls:**
- `_findDefNode` (104)
- `_findDefNode` (9)
- `_findDefNode` (7)
- `_findDefNode` (4)
- `_findDefNode` (2)
- `_findDefNode` (2)
- `_findDefNode` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:406` | Self: 0.1% (11.3ms) | Total: 2.4% (168.5ms) | Samples: 7

**Called by:**
- `_buildThinVariable` (104)
- `_buildVariable` (6)

**Calls:**
- `get parent` (31)
- `get parent` (30)
- `get parent` (14)
- `get parent` (10)
- `get parent` (7)
- `get parent` (6)
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` | Self: 0.1% (11.3ms) | Total: 0.1% (11.3ms) | Samples: 8

**Called by:**
- `isUsedVariable` (8)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6358` | Self: 0.1% (10.9ms) | Total: 0.1% (10.9ms) | Samples: 7

**Called by:**
- `walkNodes` (7)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` | Self: 0.1% (10.6ms) | Total: 0.3% (24.1ms) | Samples: 7

**Called by:**
- `(anonymous)` (16)

**Calls:**
- `get type` (5)
- `get type` (4)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1969` | Self: 0.1% (10.5ms) | Total: 26.8% (1.83s) | Samples: 7

**Called by:**
- `ensureVarsSet` (1184)
- `ensureVarsSet` (14)

**Calls:**
- `_buildVariable` (1040)
- `_buildVariable` (41)
- `_buildVariable` (33)
- `_buildVariable` (20)
- `_buildVariable` (13)
- `_buildVariable` (10)
- `_buildVariable` (10)
- `_buildVariable` (8)
- `_buildVariable` (4)
- `_buildVariable` (4)
- `_buildVariable` (4)
- `_buildVariable` (1)
- `_buildVariable` (1)
- `_buildVariable` (1)
- `_buildVariable` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2344` | Self: 0.1% (10.5ms) | Total: 0.1% (10.5ms) | Samples: 7

**Called by:**
- `ensureChildren` (7)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (10.4ms) | Total: 0.1% (10.4ms) | Samples: 7

**Called by:**
- `ensureChildren` (7)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2946` | Self: 0.1% (10.3ms) | Total: 0.1% (10.3ms) | Samples: 7

**Called by:**
- `_buildThinVariable` (7)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` | Self: 0.1% (10.3ms) | Total: 0.2% (15.1ms) | Samples: 7

**Called by:**
- `(anonymous)` (10)

**Calls:**
- `get type` (2)
- `get type` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` | Self: 0.1% (10.2ms) | Total: 0.1% (10.2ms) | Samples: 7

**Called by:**
- `collectUnusedVariables` (7)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1067` | Self: 0.1% (10.2ms) | Total: 0.1% (10.2ms) | Samples: 7

**Called by:**
- `_buildReference` (3)
- `_buildScope` (2)
- `collectUnusedVariables` (2)

### `isSelfReference`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:445` | Self: 0.1% (10.0ms) | Total: 0.1% (10.0ms) | Samples: 7

**Called by:**
- `(anonymous)` (7)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (9.9ms) | Total: 0.1% (9.9ms) | Samples: 6

**Called by:**
- `_buildReference` (6)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2437` | Self: 0.1% (9.9ms) | Total: 0.2% (19.2ms) | Samples: 7

**Called by:**
- `getScope` (13)

**Calls:**
- `/^\s*exported\b/` (4)
- `test` (2)

### `some`
`[native code]` | Self: 0.1% (9.5ms) | Total: 8.2% (563.0ms) | Samples: 6

**Called by:**
- `isUsedVariable` (266)
- `collectUnusedVariables` (72)
- `collectUnusedVariables` (29)

**Calls:**
- `(anonymous)` (190)
- `(anonymous)` (72)
- `(anonymous)` (69)
- `(anonymous)` (22)
- `(anonymous)` (7)
- `(anonymous)` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1676` | Self: 0.1% (9.4ms) | Total: 0.2% (15.6ms) | Samples: 6

**Called by:**
- `_computeIsStrict` (8)
- `isForInOfRef` (1)
- `isForInOfRef` (1)

**Calls:**
- `getUint32` (4)

### `/^(?:DoWhile\|For\|ForIn\|ForOf\|While)Statement$/u`
`[native code]` | Self: 0.1% (9.3ms) | Total: 0.1% (9.3ms) | Samples: 6

**Called by:**
- `isLoop` (6)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2915` | Self: 0.1% (9.3ms) | Total: 0.1% (9.3ms) | Samples: 6

**Called by:**
- `_buildThinVariable` (4)
- `_buildReference` (1)
- `_buildThinScope` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1933` | Self: 0.1% (9.2ms) | Total: 1.7% (116.9ms) | Samples: 6

**Called by:**
- `_buildScope` (77)

**Calls:**
- `get body` (33)
- `get body` (11)
- `get body` (9)
- `get body` (8)
- `get body` (7)
- `get body` (2)
- `get body` (1)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:180` | Self: 0.1% (9.2ms) | Total: 1.4% (100.6ms) | Samples: 6

**Called by:**
- `getRhsNode` (66)

**Calls:**
- `get parent` (27)
- `get parent` (9)
- `get parent` (9)
- `get parent` (7)
- `get parent` (4)
- `get parent` (3)
- `get parent` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6868` | Self: 0.1% (8.7ms) | Total: 0.1% (8.7ms) | Samples: 6

**Called by:**
- `runPlugins` (6)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2179` | Self: 0.1% (8.5ms) | Total: 0.1% (8.5ms) | Samples: 5

**Called by:**
- `ensureVarsSet` (5)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1007` | Self: 0.1% (8.2ms) | Total: 0.1% (8.2ms) | Samples: 5

**Called by:**
- `(anonymous)` (3)
- `collectUnusedVariables` (1)
- `isFunction` (1)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2858` | Self: 0.1% (8.1ms) | Total: 0.1% (8.1ms) | Samples: 5

**Called by:**
- `_buildReference` (5)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:410` | Self: 0.1% (7.9ms) | Total: 0.2% (14.1ms) | Samples: 5

**Called by:**
- `_buildVariable` (8)
- `_buildThinVariable` (1)

**Calls:**
- `get _tag` (4)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:682` | Self: 0.1% (7.8ms) | Total: 0.1% (11.3ms) | Samples: 5

**Called by:**
- `(anonymous)` (7)

**Calls:**
- `get type` (1)
- `get type` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4056` | Self: 0.1% (7.8ms) | Total: 0.1% (7.8ms) | Samples: 5

**Called by:**
- `(anonymous)` (3)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:868` | Self: 0.1% (7.8ms) | Total: 0.7% (51.3ms) | Samples: 5

**Called by:**
- `get body` (32)
- `get value` (1)
- `get body` (1)

**Calls:**
- `_nodeViewRaw` (14)
- `nodeView` (4)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (1)
- `nodeView` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1228` | Self: 0.1% (7.7ms) | Total: 0.2% (16.0ms) | Samples: 5

**Called by:**
- `_findDefNode` (6)
- `_buildReference` (5)

**Calls:**
- `get value` (3)
- `get value` (1)
- `get value` (1)
- `get value` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1627` | Self: 0.1% (7.7ms) | Total: 0.3% (21.1ms) | Samples: 5

**Called by:**
- `_buildScopeVarsAndSet` (14)

**Calls:**
- `has` (9)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1915` | Self: 0.1% (7.6ms) | Total: 0.4% (27.7ms) | Samples: 5

**Called by:**
- `_buildScope` (18)

**Calls:**
- `get type` (9)
- `get type` (2)
- `get parent` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1970` | Self: 0.1% (7.6ms) | Total: 0.1% (7.6ms) | Samples: 5

**Called by:**
- `ensureVarsSet` (5)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2851` | Self: 0.1% (7.5ms) | Total: 100.0% (7.75s) | Samples: 5

**Called by:**
- `_buildThinScope` (5060)
- `_buildReference` (1)

**Calls:**
- `_buildThinScope` (3052)
- `_buildThinScope` (1900)
- `_buildThinScope` (47)
- `_buildThinScope` (22)
- `_buildThinScope` (14)
- `_buildThinScope` (8)
- `_buildThinScope` (7)
- `_buildThinScope` (4)
- `_buildThinScope` (2)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (7.4ms) | Total: 0.1% (7.4ms) | Samples: 5

**Called by:**
- `commentsInRange` (5)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1674` | Self: 0.1% (7.1ms) | Total: 0.1% (9.9ms) | Samples: 5

**Called by:**
- `_computeIsStrict` (7)

**Calls:**
- `get _tag` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2641` | Self: 0.1% (6.9ms) | Total: 0.1% (6.9ms) | Samples: 5

**Called by:**
- `getDeclaredVariables` (4)
- `_buildScopeVarsAndSet` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1703` | Self: 0.0% (6.6ms) | Total: 0.2% (17.4ms) | Samples: 4

**Called by:**
- `_computeIsStrict` (11)

**Calls:**
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3025` | Self: 0.0% (6.4ms) | Total: 0.0% (6.4ms) | Samples: 4

**Called by:**
- `isAfterLastUsedArg` (4)

### `getUint32`
`[native code]` | Self: 0.0% (6.2ms) | Total: 0.0% (6.2ms) | Samples: 4

**Called by:**
- `get body` (4)

### `/^\s*exported\b/`
`[native code]` | Self: 0.0% (6.1ms) | Total: 0.0% (6.1ms) | Samples: 4

**Called by:**
- `_precomputeScopes` (4)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2789` | Self: 0.0% (6.0ms) | Total: 8.8% (607.2ms) | Samples: 4

**Called by:**
- `_buildVariable` (397)

**Calls:**
- `get parent` (158)
- `get parent` (110)
- `get parent` (41)
- `get parent` (35)
- `get parent` (18)
- `get parent` (17)
- `get parent` (5)
- `get parent` (4)
- `get parent` (4)
- `get parent` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:580` | Self: 0.0% (6.0ms) | Total: 0.0% (6.0ms) | Samples: 4

**Called by:**
- `_precomputeScopes` (4)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2744` | Self: 0.0% (5.9ms) | Total: 0.0% (5.9ms) | Samples: 4

**Called by:**
- `_buildScopeVarsAndSet` (4)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1185` | Self: 0.0% (5.9ms) | Total: 0.0% (5.9ms) | Samples: 4

**Called by:**
- `(anonymous)` (2)
- `collectUnusedVariables` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (5.8ms) | Total: 0.0% (5.8ms) | Samples: 4

**Called by:**
- `get parent` (4)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1623` | Self: 0.0% (5.7ms) | Total: 1.1% (77.7ms) | Samples: 4

**Called by:**
- `_buildScopeVarsAndSet` (50)

**Calls:**
- `get` (46)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2492` | Self: 0.0% (5.7ms) | Total: 0.2% (15.8ms) | Samples: 4

**Called by:**
- `_buildScopeVarsAndSet` (8)
- `getDeclaredVariables` (3)

**Calls:**
- `nodeView` (3)
- `_nodeViewRaw` (2)
- `nodeView` (1)
- `_nodeViewRaw` (1)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:773` | Self: 0.0% (5.6ms) | Total: 0.0% (5.6ms) | Samples: 4

**Called by:**
- `get name` (4)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:653` | Self: 0.0% (5.1ms) | Total: 0.1% (8.3ms) | Samples: 3

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `get type` (1)
- `get type` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1639` | Self: 0.0% (4.9ms) | Total: 0.0% (4.9ms) | Samples: 3

**Called by:**
- `_buildScopeVarsAndSet` (3)

### `test`
`[native code]` | Self: 0.0% (4.9ms) | Total: 0.0% (4.9ms) | Samples: 3

**Called by:**
- `_precomputeScopes` (2)
- `_buildScopeVarsAndSet` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` | Self: 0.0% (4.9ms) | Total: 0.1% (7.8ms) | Samples: 3

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `get type` (1)
- `get type` (1)

### `DataView`
`[native code]` | Self: 0.0% (4.8ms) | Total: 0.0% (4.8ms) | Samples: 3

**Called by:**
- `AstView` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6627` | Self: 0.0% (4.8ms) | Total: 0.0% (4.8ms) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2516` | Self: 0.0% (4.7ms) | Total: 0.6% (44.6ms) | Samples: 3

**Called by:**
- `_buildScopeVarsAndSet` (20)
- `getDeclaredVariables` (9)

**Calls:**
- `_findDefNode` (8)
- `_findDefNode` (7)
- `_findDefNode` (6)
- `_findDefNode` (2)
- `_findDefNode` (2)
- `_findDefNode` (1)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2835` | Self: 0.0% (4.7ms) | Total: 0.0% (4.7ms) | Samples: 3

**Called by:**
- `_buildReference` (2)
- `_buildThinScope` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` | Self: 0.0% (4.7ms) | Total: 0.2% (17.0ms) | Samples: 3

**Called by:**
- `forEach` (11)

**Calls:**
- `nodeViewChain` (2)
- `init` (1)
- `init` (1)
- `nodeViewChain` (1)
- `get type` (1)
- `get type` (1)
- `nodeViewChain` (1)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2909` | Self: 0.0% (4.6ms) | Total: 0.1% (7.7ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `nodeLhs` (2)

### `source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:511` | Self: 0.0% (4.6ms) | Total: 0.0% (4.6ms) | Samples: 3

**Called by:**
- `_buildSymNameCache` (3)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2792` | Self: 0.0% (4.6ms) | Total: 0.4% (27.4ms) | Samples: 3

**Called by:**
- `_buildVariable` (17)

**Calls:**
- `_buildThinVariable` (6)
- `_buildThinVariable` (5)
- `_buildThinVariable` (2)
- `_buildThinVariable` (1)

### `readdirSync`
`[native code]` | Self: 0.0% (4.5ms) | Total: 0.0% (5.9ms) | Samples: 3

**Called by:**
- `loadCoreRules` (3)
- `readdirSync` (1)

**Calls:**
- `readdirSync` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (4.5ms) | Total: 0.0% (4.5ms) | Samples: 3

**Called by:**
- `_buildVariable` (3)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (4.5ms) | Total: 0.0% (4.5ms) | Samples: 3

**Called by:**
- `_buildScopeChildren` (3)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:435` | Self: 0.0% (4.5ms) | Total: 0.0% (4.5ms) | Samples: 3

**Called by:**
- `parseSource` (3)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:577` | Self: 0.0% (4.5ms) | Total: 0.0% (5.9ms) | Samples: 3

**Called by:**
- `_precomputeScopes` (4)

**Calls:**
- `push` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` | Self: 0.0% (4.5ms) | Total: 6.0% (412.9ms) | Samples: 3

**Called by:**
- `collectUnusedVariables` (269)

**Calls:**
- `some` (266)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3034` | Self: 0.0% (4.4ms) | Total: 0.0% (4.4ms) | Samples: 3

**Called by:**
- `isAfterLastUsedArg` (3)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` | Self: 0.0% (4.4ms) | Total: 100.0% (15.77s) | Samples: 3

**Called by:**
- `collectUnusedVariables` (7818)
- `Program:exit` (2502)

**Calls:**
- `collectUnusedVariables` (7818)
- `collectUnusedVariables` (1355)
- `collectUnusedVariables` (663)
- `collectUnusedVariables` (368)
- `collectUnusedVariables` (73)
- `collectUnusedVariables` (23)
- `collectUnusedVariables` (8)
- `collectUnusedVariables` (7)
- `collectUnusedVariables` (2)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3637` | Self: 0.0% (4.3ms) | Total: 0.0% (4.3ms) | Samples: 3

**Called by:**
- `get value` (3)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2183` | Self: 0.0% (4.3ms) | Total: 0.0% (4.3ms) | Samples: 3

**Called by:**
- `ensureVarsSet` (3)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1227` | Self: 0.0% (4.2ms) | Total: 0.0% (4.2ms) | Samples: 3

**Called by:**
- `isForInOfRef` (2)
- `_findDefNode` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` | Self: 0.0% (4.2ms) | Total: 4.2% (292.3ms) | Samples: 3

**Called by:**
- `some` (190)

**Calls:**
- `getRhsNode` (153)
- `getRhsNode` (15)
- `getRhsNode` (10)
- `getRhsNode` (4)
- `getRhsNode` (2)
- `getRhsNode` (1)
- `getRhsNode` (1)
- `getRhsNode` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` | Self: 0.0% (4.0ms) | Total: 0.1% (10.2ms) | Samples: 3

**Called by:**
- `collectUnusedVariables` (7)

**Calls:**
- `get parent` (2)
- `get type` (1)
- `get type` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4244` | Self: 0.0% (3.6ms) | Total: 0.0% (3.6ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2069` | Self: 0.0% (3.5ms) | Total: 0.0% (5.2ms) | Samples: 2

**Called by:**
- `ensureVarsSet` (3)

**Calls:**
- `test` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3042` | Self: 0.0% (3.4ms) | Total: 0.0% (3.4ms) | Samples: 2

**Called by:**
- `isAfterLastUsedArg` (2)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:542` | Self: 0.0% (3.4ms) | Total: 0.0% (3.4ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` | Self: 0.0% (3.3ms) | Total: 0.0% (6.5ms) | Samples: 2

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `get parent` (1)
- `get parent` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:447` | Self: 0.0% (3.3ms) | Total: 0.1% (7.6ms) | Samples: 2

**Called by:**
- `_buildThinVariable` (4)
- `_buildVariable` (1)

**Calls:**
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2820` | Self: 0.0% (3.3ms) | Total: 0.2% (20.0ms) | Samples: 2

**Called by:**
- `_buildVariable` (13)

**Calls:**
- `get parent` (11)

### `ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1829` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `get` (2)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` | Self: 0.0% (3.2ms) | Total: 1.0% (72.7ms) | Samples: 2

**Called by:**
- `isUsedVariable` (47)

**Calls:**
- `forEach` (45)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6624` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` | Self: 0.0% (3.2ms) | Total: 0.1% (9.4ms) | Samples: 2

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2874` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `_buildThinScope` (2)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:582` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `_precomputeScopes` (2)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:395` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `_buildVariable` (2)

### `nodeLhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `init` (2)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4057` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:419` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `_buildThinVariable` (2)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6360` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1730` | Self: 0.0% (3.0ms) | Total: 0.1% (10.6ms) | Samples: 2

**Called by:**
- `_buildScopeChildren` (7)

**Calls:**
- `get type` (2)
- `get type` (2)
- `get id` (1)

### `isInside`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `isReadForItself` (2)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:865` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `get body` (2)

### `existsSync`
`[native code]` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `existsSync` (2)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2347` | Self: 0.0% (2.9ms) | Total: 10.7% (733.5ms) | Samples: 2

**Called by:**
- `ensureChildren` (478)

**Calls:**
- `_buildScope` (182)
- `_buildScope` (125)
- `_buildScope` (118)
- `_buildScope` (12)
- `_buildScope` (8)
- `_buildScope` (7)
- `_buildScope` (7)
- `_buildScope` (4)
- `_buildScope` (4)
- `_buildScope` (3)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1674` | Self: 0.0% (2.9ms) | Total: 0.0% (6.0ms) | Samples: 2

**Called by:**
- `_buildScopeChildren` (4)

**Calls:**
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `isInside`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:494` | Self: 0.0% (2.9ms) | Total: 0.0% (4.1ms) | Samples: 2

**Called by:**
- `isReadForItself` (2)
- `getRhsNode` (1)

**Calls:**
- `get range` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4243` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `AstView` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1680` | Self: 0.0% (2.9ms) | Total: 0.0% (5.6ms) | Samples: 2

**Called by:**
- `_buildScopeChildren` (4)

**Calls:**
- `get _tag` (2)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2963` | Self: 0.0% (2.9ms) | Total: 100.0% (8.21s) | Samples: 2

**Called by:**
- `_buildThinVariable` (3052)
- `_buildThinScope` (2309)

**Calls:**
- `_buildThinVariable` (5060)
- `_buildThinVariable` (137)
- `_buildThinVariable` (89)
- `_buildThinVariable` (60)
- `_buildThinVariable` (10)
- `_buildThinVariable` (2)
- `_buildThinVariable` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1973` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `ensureVarsSet` (2)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1618` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1626` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3032` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `isAfterLastUsedArg` (2)

### `extraFnData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:665` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `get body` (1)
- `get id` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4011` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `nodeViewChain` (2)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1638` | Self: 0.0% (2.7ms) | Total: 0.1% (8.7ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (6)

**Calls:**
- `get` (4)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2177` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `ensureVarsSet` (2)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2773` | Self: 0.0% (2.6ms) | Total: 0.0% (2.6ms) | Samples: 2

**Called by:**
- `_buildVariable` (2)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1897` | Self: 0.0% (2.6ms) | Total: 11.1% (760.5ms) | Samples: 2

**Called by:**
- `collectUnusedVariables` (496)

**Calls:**
- `ensureChildren` (493)
- `ensureChildren` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1200` | Self: 0.0% (2.5ms) | Total: 0.0% (2.5ms) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1937` | Self: 0.0% (1.8ms) | Total: 0.0% (3.1ms) | Samples: 1

**Called by:**
- `_buildScope` (2)

**Calls:**
- `get directive` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2720` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `isUnusedExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:512` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `isReadForItself` (1)

### `encodeInto`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_encodeSource` (1)

### `exec`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.1% (8.9ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (6)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `some` (1)

### `replace`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_execReport` (1)

### `_isChainNode`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3882` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `nodeViewChain` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1684` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1708` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:887` | Self: 0.0% (1.7ms) | Total: 0.0% (3.3ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (2)

**Calls:**
- `get kind` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2939` | Self: 0.0% (1.7ms) | Total: 0.9% (67.2ms) | Samples: 1

**Called by:**
- `_buildThinVariable` (22)
- `_buildReference` (19)
- `_buildThinScope` (2)

**Calls:**
- `nodeView` (41)
- `_nodeViewRaw` (1)

### `forEach`
`[native code]` | Self: 0.0% (1.7ms) | Total: 1.0% (70.9ms) | Samples: 1

**Called by:**
- `getFunctionDefinitions` (45)
- `_interopNamespaceDefault` (1)

**Calls:**
- `(anonymous)` (17)
- `(anonymous)` (15)
- `(anonymous)` (11)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` | Self: 0.0% (1.7ms) | Total: 1.6% (110.1ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (73)

**Calls:**
- `some` (72)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4032` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_nodesFromRange` (1)

### `error`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `async (anonymous)` (1)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2907` | Self: 0.0% (1.7ms) | Total: 0.0% (3.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `get _tag` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2434` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getScope` (1)

### `map`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (5.8ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (4)

**Calls:**
- `(anonymous)` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:3192` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `isUnusedExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:508` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getRhsNode` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3056` | Self: 0.0% (1.7ms) | Total: 0.0% (3.1ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (2)

**Calls:**
- `push` (1)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_symName` (1)

### `ensureChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1856` | Self: 0.0% (1.6ms) | Total: 11.0% (756.2ms) | Samples: 1

**Called by:**
- `get` (493)

**Calls:**
- `_buildScopeChildren` (478)
- `_buildScopeChildren` (7)
- `_buildScopeChildren` (7)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3013` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `nodeRhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `init` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:540` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1790` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `get` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2672` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1201` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_buildThinVariable` (1)

### `ensureChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `get` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:412` | Self: 0.0% (1.6ms) | Total: 0.2% (14.6ms) | Samples: 1

**Called by:**
- `_buildThinVariable` (7)
- `_buildVariable` (2)

**Calls:**
- `get parent` (3)
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2910` | Self: 0.0% (1.6ms) | Total: 0.0% (3.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `nodeRhs` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1714` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` | Self: 0.0% (1.6ms) | Total: 0.5% (37.1ms) | Samples: 1

**Called by:**
- `(anonymous)` (24)

**Calls:**
- `get parent` (7)
- `get parent` (5)
- `get parent` (4)
- `get parent` (3)
- `get parent` (3)
- `get parent` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:558` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7034` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4841` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildPlan` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4008` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `nodeView` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `findIndex`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `ensureVarsSet` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1635` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `get` (1)

### `ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1828` | Self: 0.0% (1.5ms) | Total: 34.5% (2.35s) | Samples: 1

**Called by:**
- `get` (1543)

**Calls:**
- `_buildScopeVarsAndSet` (1184)
- `_buildScopeVarsAndSet` (227)
- `_buildScopeVarsAndSet` (48)
- `_buildScopeVarsAndSet` (39)
- `_buildScopeVarsAndSet` (13)
- `_buildScopeVarsAndSet` (10)
- `_buildScopeVarsAndSet` (5)
- `_buildScopeVarsAndSet` (5)
- `_buildScopeVarsAndSet` (3)
- `_buildScopeVarsAndSet` (3)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1914` | Self: 0.0% (1.5ms) | Total: 0.2% (18.7ms) | Samples: 1

**Called by:**
- `_buildScope` (12)

**Calls:**
- `get parent` (6)
- `get parent` (4)
- `get parent` (1)

### `/\{\{(\w+)\}\}/g`
`[native code]` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_execReport` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3059` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `async _resolveConfigImpl` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1826` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `forEach` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1325` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6419` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1492` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get parent` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `indexOf`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:647` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildThinScope` (1)

### `_findLine`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:461` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `getLocFromIndex` (1)

### `entries`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1711` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1756` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `_isStatementTag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get range` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `forEach` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4037` | Self: 0.0% (1.4ms) | Total: 8.2% (564.5ms) | Samples: 1

**Called by:**
- `_buildReference` (171)
- `get parent` (145)
- `_buildThinScope` (41)
- `_nodesFromRange` (4)
- `_buildThinVariable` (3)
- `_buildVariable` (1)
- `get body` (1)

**Calls:**
- `_nodeViewRaw` (206)
- `_nodeViewRaw` (42)
- `_nodeViewRaw` (29)
- `_nodeViewRaw` (12)
- `_nodeViewRaw` (9)
- `_nodeViewRaw` (9)
- `_nodeViewRaw` (9)
- `_nodeViewRaw` (9)
- `_nodeViewRaw` (9)
- `_nodeViewRaw` (7)
- `_nodeViewRaw` (6)
- `_nodeViewRaw` (6)
- `_nodeViewRaw` (6)
- `_nodeViewRaw` (5)
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` | Self: 0.0% (1.3ms) | Total: 0.3% (26.2ms) | Samples: 1

**Called by:**
- `forEach` (17)

**Calls:**
- `nodeViewChain` (8)
- `nodeViewChain` (3)
- `nodeViewChain` (2)
- `init` (1)
- `init` (1)
- `init` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2612` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:828` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_symName` (1)

### `get start`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `range` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:689` | Self: 0.0% (1.3ms) | Total: 0.0% (4.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `get body` (1)
- `get body` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1637` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `extraFnData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:664` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `get body` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1935` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1474` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `getDefinedMessageData`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:283` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `Program:exit` (1)

### `get directive`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:185` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1703` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1669` | Self: 0.0% (1.2ms) | Total: 0.1% (10.3ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (7)

**Calls:**
- `_buildScope` (3)
- `_buildScope` (2)
- `_buildScope` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2956` | Self: 0.0% (1.2ms) | Total: 0.0% (2.5ms) | Samples: 1

**Called by:**
- `_buildThinVariable` (2)

**Calls:**
- `_ensureDeclSymIndex` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:121` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1330` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3049` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1628` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_buildThinScope` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3594` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `isInside` (1)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2865` | Self: 0.0% (1.2ms) | Total: 1.3% (90.7ms) | Samples: 1

**Called by:**
- `_buildThinScope` (60)

**Calls:**
- `_nodeViewRaw` (20)
- `_nodeViewRaw` (11)
- `_nodeViewRaw` (6)
- `_nodeViewRaw` (4)
- `nodeView` (3)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1700` | Self: 0.0% (1.0ms) | Total: 0.1% (13.0ms) | Samples: 1

**Called by:**
- `_computeIsStrict` (9)

**Calls:**
- `_nodeViewRaw` (5)
- `nodeView` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:76` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `async _resolveConfig` (2)

**Calls:**
- `async _resolveConfigImpl` (1)
- `async _resolveConfigImpl` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:654` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7384` | Self: 0.0% (0us) | Total: 0.0% (5.6ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (4)

**Calls:**
- `buildVisitorMap` (1)
- `buildVisitorMap` (1)
- `buildVisitorMap` (1)
- `buildVisitorMap` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:24` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `_interopNamespaceDefault` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` | Self: 0.0% (0us) | Total: 0.0% (4.7ms) | Samples: 0

**Called by:**
- `_invokeFused` (3)

**Calls:**
- `report` (3)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1482` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `get parent` (1)

**Calls:**
- `get range` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3724` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `report` (2)

**Calls:**
- `/\{\{(\w+)\}\}/g` (1)
- `replace` (1)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:802` | Self: 0.0% (0us) | Total: 0.3% (24.3ms) | Samples: 0

**Called by:**
- `_ensureDeclSymIndex` (12)
- `_buildVariable` (4)

**Calls:**
- `_buildSymNameCache` (11)
- `_buildSymNameCache` (3)
- `_buildSymNameCache` (1)
- `_buildSymNameCache` (1)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 0.7% (51.5ms) | Samples: 0

**Called by:**
- `bound require` (32)

**Calls:**
- `anonymous` (32)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:53` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (1)

**Calls:**
- `rewrittenPath` (1)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (12.6ms) | Samples: 0

**Calls:**
- `parseModule` (8)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1689` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `isForInOfRef` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` | Self: 0.0% (0us) | Total: 72.1% (4.92s) | Samples: 0

**Called by:**
- `_invokeFused` (3222)

**Calls:**
- `collectUnusedVariables` (2502)
- `collectUnusedVariables` (719)
- `collectUnusedVariables` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:658` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isUnusedExpression` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2433` | Self: 0.0% (0us) | Total: 1.0% (75.0ms) | Samples: 0

**Called by:**
- `getScope` (49)

**Calls:**
- `commentsInRange` (34)
- `commentsInRange` (5)
- `commentsInRange` (4)
- `commentsInRange` (4)
- `commentsInRange` (2)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:54` | Self: 0.0% (0us) | Total: 0.1% (11.0ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (7)

**Calls:**
- `bound require` (7)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `async (anonymous)` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:688` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `get body` (1)
- `get body` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3071` | Self: 0.0% (0us) | Total: 0.0% (4.1ms) | Samples: 0

**Called by:**
- `map` (3)

**Calls:**
- `get name` (2)
- `get name` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1478` | Self: 0.0% (0us) | Total: 0.0% (1.0ms) | Samples: 0

**Called by:**
- `get parent` (1)

**Calls:**
- `_nodesFromRange` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1684` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_buildScopeChildren` (1)

**Calls:**
- `get value` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.0% (4.7ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1893` | Self: 0.0% (0us) | Total: 35.0% (2.39s) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1546)
- `ensureFenVars` (19)

**Calls:**
- `ensureVarsSet` (1543)
- `ensureVarsSet` (15)
- `ensureVarsSet` (2)
- `ensureVarsSet` (2)
- `ensureVarsSet` (1)
- `ensureVarsSet` (1)
- `ensureVarsSet` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` | Self: 0.0% (0us) | Total: 14.4% (988.8ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (648)

**Calls:**
- `getDeclaredVariables` (270)
- `getDeclaredVariables` (117)
- `getDeclaredVariables` (114)
- `getDeclaredVariables` (84)
- `getDeclaredVariables` (18)
- `getDeclaredVariables` (12)
- `getDeclaredVariables` (9)
- `getDeclaredVariables` (4)
- `map` (4)
- `getDeclaredVariables` (3)
- `getDeclaredVariables` (2)
- `getDeclaredVariables` (2)
- `getDeclaredVariables` (2)
- `getDeclaredVariables` (2)
- `getDeclaredVariables` (1)
- `getDeclaredVariables` (1)
- `getDeclaredVariables` (1)
- `getDeclaredVariables` (1)
- `getDeclaredVariables` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:304` | Self: 0.0% (0us) | Total: 79.6% (5.43s) | Samples: 0

**Calls:**
- `runPlugins` (3549)
- `runPlugins` (8)
- `runPlugins` (4)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1731` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_buildScopeChildren` (1)

**Calls:**
- `get name` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1712` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `getDefinedMessageData` (1)

### `isUnusedExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:506` | Self: 0.0% (0us) | Total: 0.0% (4.6ms) | Samples: 0

**Called by:**
- `getRhsNode` (3)

**Calls:**
- `get parent` (2)
- `get parent` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3054` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `isAfterLastUsedArg` (2)

**Calls:**
- `push` (2)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:411` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `_buildThinVariable` (2)

**Calls:**
- `get _tag` (2)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:34` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `async lintSource` (1)

### `node:events`
`node:events:9` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2002` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `ensureVarsSet` (1)

**Calls:**
- `has` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:557` | Self: 0.0% (0us) | Total: 0.0% (6.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `isUnusedExpression` (3)
- `isUnusedExpression` (1)

### `async _loadFlatConfig`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:37` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (1)

**Calls:**
- `async _loadFlatConfig` (1)

### `parseModule`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (12.6ms) | Samples: 0

**Called by:**
- `async (anonymous)` (8)

**Calls:**
- `(anonymous)` (5)
- `(anonymous)` (2)
- `(anonymous)` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` | Self: 0.0% (0us) | Total: 0.1% (12.1ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (8)

**Calls:**
- `isFunction` (7)
- `get parent` (1)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 0.7% (54.4ms) | Samples: 0

**Called by:**
- `loadCoreRules` (7)
- `(anonymous)` (6)
- `(anonymous)` (5)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `require` (32)
- `anonymous` (2)

### `ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1769` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `get` (1)

**Calls:**
- `findIndex` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` | Self: 0.0% (0us) | Total: 19.5% (1.33s) | Samples: 0

**Called by:**
- `_lintSourceOne` (878)

**Calls:**
- `parse` (878)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:179` | Self: 0.0% (0us) | Total: 1.4% (98.4ms) | Samples: 0

**Called by:**
- `getRhsNode` (64)

**Calls:**
- `isFunction` (64)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:575` | Self: 0.0% (0us) | Total: 0.1% (7.4ms) | Samples: 0

**Called by:**
- `_precomputeScopes` (5)

**Calls:**
- `_findLineIdx` (5)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:47` | Self: 0.0% (0us) | Total: 0.0% (4.5ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (3)

**Calls:**
- `readdirSync` (3)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1931` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_buildScope` (1)

**Calls:**
- `get body` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6526` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_getOrBuildPlan` (1)

### `getLocFromIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3345` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_execReport` (1)

**Calls:**
- `_findLine` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:21` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4556` | Self: 0.0% (0us) | Total: 73.7% (5.03s) | Samples: 0

**Called by:**
- `walkNodes` (3292)

**Calls:**
- `Program:exit` (3222)
- `Program:exit` (64)
- `Program:exit` (3)
- `Program:exit` (1)
- `Program:exit` (1)
- `Program:exit` (1)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:182` | Self: 0.0% (0us) | Total: 0.5% (36.0ms) | Samples: 0

**Called by:**
- `getRhsNode` (23)

**Calls:**
- `isLoop` (23)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3019` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `isAfterLastUsedArg` (1)

**Calls:**
- `get` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1716` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `_nodesFromRange` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` | Self: 0.0% (0us) | Total: 0.2% (16.0ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (9)

**Calls:**
- `AstView` (3)
- `AstView` (3)
- `AstView` (3)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:661` | Self: 0.0% (0us) | Total: 0.0% (5.8ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `isInside` (2)
- `isInside` (2)

### `get id`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2269` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_buildScope` (1)

**Calls:**
- `extraFnData` (1)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:92` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `encodeInto` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:734` | Self: 0.0% (0us) | Total: 0.1% (10.0ms) | Samples: 0

**Called by:**
- `some` (7)

**Calls:**
- `isSelfReference` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:215` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `_encodeSource` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1680` | Self: 0.0% (0us) | Total: 0.7% (51.5ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (33)
- `isForInOfRef` (1)

**Calls:**
- `_nodesFromRange` (32)
- `_nodesFromRange` (2)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:85` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (1)

**Calls:**
- `async _loadFlatConfig` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5773` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_getOrBuildPlan` (1)

**Calls:**
- `_extractFileLevelRules` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:43` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Calls:**
- `error` (1)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:511` | Self: 0.0% (0us) | Total: 0.1% (12.3ms) | Samples: 0

**Called by:**
- `runPlugins` (8)

**Calls:**
- `decode` (8)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2637` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (1)

**Calls:**
- `range` (1)

### `async _resolveConfig`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:68` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `async lintSource` (2)

**Calls:**
- `async _resolveConfig` (2)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1512` | Self: 0.0% (0us) | Total: 1.4% (97.8ms) | Samples: 0

**Called by:**
- `Program:exit` (64)

**Calls:**
- `_precomputeScopes` (49)
- `_precomputeScopes` (13)
- `_precomputeScopes` (1)
- `_precomputeScopes` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` | Self: 0.0% (0us) | Total: 1.4% (97.8ms) | Samples: 0

**Called by:**
- `_invokeFused` (64)

**Calls:**
- `getScope` (64)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4062` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `_isChainNode` (1)

### `async lintSource`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:461` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)
- `async (anonymous)` (1)

**Calls:**
- `async lintSource` (2)

### `async lintSource`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:462` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `async lintSource` (2)

**Calls:**
- `async _resolveConfig` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6422` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `has` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:300` | Self: 0.0% (0us) | Total: 19.8% (1.35s) | Samples: 0

**Calls:**
- `parseSource` (878)
- `parseSource` (9)
- `parseSource` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:144` | Self: 0.0% (0us) | Total: 0.2% (17.0ms) | Samples: 0

**Calls:**
- `loadCoreRules` (7)
- `loadCoreRules` (3)
- `loadCoreRules` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:809` | Self: 0.0% (0us) | Total: 0.0% (4.6ms) | Samples: 0

**Called by:**
- `_symName` (3)

**Calls:**
- `source` (3)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4065` | Self: 0.0% (0us) | Total: 0.2% (16.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (8)
- `(anonymous)` (2)
- `(anonymous)` (1)

**Calls:**
- `_nodeViewRaw` (6)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)

### `ensureFenVars`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1753` | Self: 0.0% (0us) | Total: 0.4% (29.0ms) | Samples: 0

**Called by:**
- `get` (19)

**Calls:**
- `get` (19)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3574` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `get value` (1)

**Calls:**
- `_isStatementTag` (1)

### `ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1801` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `get` (2)

**Calls:**
- `get name` (2)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:441` | Self: 0.0% (0us) | Total: 0.0% (6.6ms) | Samples: 0

**Called by:**
- `parseSource` (3)

**Calls:**
- `CfgGraph` (2)
- `CfgGraph` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1483` | Self: 0.0% (0us) | Total: 0.0% (4.3ms) | Samples: 0

**Called by:**
- `get parent` (3)

**Calls:**
- `get loc` (3)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4260` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `push` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:276` | Self: 0.0% (0us) | Total: 0.0% (4.8ms) | Samples: 0

**Called by:**
- `parseSource` (3)

**Calls:**
- `DataView` (3)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1756` | Self: 0.0% (0us) | Total: 0.4% (29.0ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (19)

**Calls:**
- `ensureFenVars` (19)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2364` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `getScope` (1)

**Calls:**
- `_buildScope` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1640` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `push` (1)

### `range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3594` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_buildVariable` (1)

**Calls:**
- `get start` (1)

### `get kind`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2626` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `get _tag` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` | Self: 0.0% (0us) | Total: 0.3% (22.9ms) | Samples: 0

**Called by:**
- `forEach` (15)

**Calls:**
- `get type` (5)
- `init` (3)
- `_nodeViewRaw` (3)
- `get type` (1)
- `nodeViewChain` (1)
- `init` (1)
- `nodeViewChain` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2461` | Self: 0.0% (0us) | Total: 0.0% (6.0ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (4)

**Calls:**
- `_symName` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:12` | Self: 0.0% (0us) | Total: 0.1% (9.6ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` | Self: 0.0% (0us) | Total: 1.5% (105.9ms) | Samples: 0

**Called by:**
- `some` (69)

**Calls:**
- `isForInOfRef` (24)
- `isForInOfRef` (16)
- `isForInOfRef` (11)
- `isForInOfRef` (7)
- `isForInOfRef` (6)
- `isForInOfRef` (3)
- `isForInOfRef` (2)

### `ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1766` | Self: 0.0% (0us) | Total: 0.3% (22.7ms) | Samples: 0

**Called by:**
- `get` (15)

**Calls:**
- `_buildScopeVarsAndSet` (14)
- `_buildScopeVarsAndSet` (1)

### `async _resolveConfig`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:71` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `async _resolveConfig` (2)

**Calls:**
- `async _resolveConfigImpl` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7101` | Self: 0.0% (0us) | Total: 73.7% (5.03s) | Samples: 0

**Called by:**
- `runPlugins` (3292)

**Calls:**
- `_invokeFused` (3292)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4234` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `entries` (1)

### `existsSync`
`node:fs:273` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `rewrittenPath` (1)
- `async _loadFlatConfig` (1)

**Calls:**
- `existsSync` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:25` | Self: 0.0% (0us) | Total: 0.1% (8.2ms) | Samples: 0

**Called by:**
- `parseModule` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `rewrittenPath`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:19` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `loadCoreRules` (1)

**Calls:**
- `existsSync` (1)

### `async _loadFlatConfig`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:43` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `async _loadFlatConfig` (1)

**Calls:**
- `existsSync` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3744` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `report` (1)

**Calls:**
- `getLocFromIndex` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:43` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `async (anonymous)` (1)

### `_interopNamespaceDefault`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:10` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `forEach` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:11` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `parseModule` (2)

**Calls:**
- `bound require` (2)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7385` | Self: 0.0% (0us) | Total: 79.3% (5.42s) | Samples: 0

**Called by:**
- `_lintSourceOne` (3549)

**Calls:**
- `walkNodes` (3292)
- `walkNodes` (169)
- `walkNodes` (41)
- `walkNodes` (14)
- `walkNodes` (9)
- `walkNodes` (8)
- `walkNodes` (6)
- `walkNodes` (3)
- `walkNodes` (2)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1337` | Self: 0.0% (0us) | Total: 0.0% (5.6ms) | Samples: 0

**Called by:**
- `ensureVarsSet` (2)
- `(anonymous)` (2)

**Calls:**
- `_identAt` (4)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` | Self: 0.0% (0us) | Total: 14.8% (1.01s) | Samples: 0

**Called by:**
- `collectUnusedVariables` (663)

**Calls:**
- `isAfterLastUsedArg` (648)
- `isAfterLastUsedArg` (15)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6744` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `indexOf` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` | Self: 0.0% (0us) | Total: 1.2% (84.0ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (55)

**Calls:**
- `getFunctionDefinitions` (47)
- `getFunctionDefinitions` (8)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7377` | Self: 0.0% (0us) | Total: 0.1% (12.3ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (8)

**Calls:**
- `get source` (8)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6865` | Self: 0.0% (0us) | Total: 0.2% (14.0ms) | Samples: 0

**Called by:**
- `runPlugins` (9)

**Calls:**
- `getDFSEvents` (7)
- `getDFSEvents` (2)

### `_getOrBuildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5455` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_buildPlan` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` | Self: 0.0% (0us) | Total: 0.5% (34.9ms) | Samples: 0

**Called by:**
- `some` (22)

**Calls:**
- `isReadForItself` (5)
- `isReadForItself` (5)
- `isReadForItself` (4)
- `isReadForItself` (4)
- `isReadForItself` (2)
- `isReadForItself` (1)
- `isReadForItself` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4228` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `create` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` | Self: 0.0% (0us) | Total: 3.4% (235.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (153)

**Calls:**
- `isInLoop` (66)
- `isInLoop` (64)
- `isInLoop` (23)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1699` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (2)

**Calls:**
- `extraFnData` (1)
- `extraFnData` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1636` | Self: 0.0% (0us) | Total: 0.2% (18.2ms) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (12)

**Calls:**
- `_symName` (12)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)
- `bound require` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2785` | Self: 0.0% (0us) | Total: 4.0% (274.3ms) | Samples: 0

**Called by:**
- `_buildVariable` (179)

**Calls:**
- `nodeView` (171)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3789` | Self: 0.0% (0us) | Total: 0.0% (4.7ms) | Samples: 0

**Called by:**
- `Program:exit` (3)

**Calls:**
- `_execReport` (2)
- `_execReport` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:551` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isInside` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:38` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Calls:**
- `async lintSource` (1)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 32.8% | 2.24s | `[native code]` |
| 31.0% | 2.11s | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 30.8% | 2.10s | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 4.0% | 273.5ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 1.2% | 85.2ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js` |
| 0.0% | 2.8ms | `/Users/ericsan/Development/OpenSource/Ez/js/api.js` |
| 0.0% | 1.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 1.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs` |
