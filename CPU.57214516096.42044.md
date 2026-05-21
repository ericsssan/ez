# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 871.9ms | 5052 | 100us | 1414 |

**Top 10:** `parse` 5.6%, `walkNodes` 2.9%, `_buildScopeVarsAndSet` 2.8%, `Uint32Array` 2.6%, `anonymous` 2.4%, `_mkGlobalVar` 2.3%, `_buildPlan` 2.3%, `_buildScopeVarsAndSet` 1.8%, `walkNodes` 1.6%, `walkNodes` 1.5%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 5.6% | 49.3ms | 5.6% | 49.3ms | `parse` | `[native code]` |
| 2.9% | 26.0ms | 3.0% | 26.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6826` |
| 2.8% | 25.1ms | 3.0% | 26.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1998` |
| 2.6% | 22.7ms | 2.6% | 22.7ms | `Uint32Array` | `[native code]` |
| 2.4% | 21.2ms | 6.0% | 52.6ms | `anonymous` | `[native code]` |
| 2.3% | 20.6ms | 2.3% | 20.6ms | `_mkGlobalVar` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:587` |
| 2.3% | 20.1ms | 2.3% | 20.1ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5745` |
| 1.8% | 16.4ms | 1.8% | 16.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2167` |
| 1.6% | 14.3ms | 1.6% | 14.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6685` |
| 1.5% | 13.1ms | 1.7% | 14.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6602` |
| 1.3% | 11.7ms | 1.6% | 14.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6759` |
| 1.2% | 11.1ms | 1.2% | 11.1ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5761` |
| 1.1% | 10.2ms | 1.1% | 10.2ms | `defineProperties` | `[native code]` |
| 1.0% | 8.8ms | 1.0% | 8.8ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.9% | 8.5ms | 2.8% | 25.1ms | `some` | `[native code]` |
| 0.9% | 8.2ms | 1.0% | 9.3ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5690` |
| 0.9% | 8.0ms | 0.9% | 8.0ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5754` |
| 0.8% | 7.1ms | 1.0% | 8.7ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5687` |
| 0.8% | 6.9ms | 1.4% | 12.7ms | `map` | `[native code]` |
| 0.7% | 6.6ms | 0.7% | 6.6ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4661` |
| 0.7% | 6.4ms | 0.9% | 8.5ms | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5804` |
| 0.7% | 6.3ms | 0.7% | 6.3ms | `Set` | `[native code]` |
| 0.6% | 6.0ms | 0.6% | 6.0ms | `get` | `[native code]` |
| 0.6% | 5.9ms | 0.6% | 5.9ms | `indexOf` | `[native code]` |
| 0.6% | 5.8ms | 0.6% | 5.8ms | `Uint8Array` | `[native code]` |
| 0.6% | 5.5ms | 0.7% | 6.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3994` |
| 0.6% | 5.3ms | 0.6% | 5.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1613` |
| 0.6% | 5.3ms | 0.6% | 5.7ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5697` |
| 0.6% | 5.3ms | 0.6% | 5.3ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:505` |
| 0.5% | 4.9ms | 0.5% | 4.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6733` |
| 0.5% | 4.9ms | 0.5% | 4.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6732` |
| 0.5% | 4.7ms | 0.6% | 5.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1285` |
| 0.5% | 4.7ms | 0.5% | 4.7ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4839` |
| 0.5% | 4.7ms | 0.5% | 4.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6818` |
| 0.5% | 4.6ms | 0.5% | 4.6ms | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5557` |
| 0.5% | 4.3ms | 0.5% | 4.3ms | `stringSplitFast` | `[native code]` |
| 0.4% | 4.3ms | 0.4% | 4.3ms | `get _tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1072` |
| 0.4% | 4.2ms | 0.4% | 4.2ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5714` |
| 0.4% | 4.0ms | 0.4% | 4.1ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4252` |
| 0.4% | 3.9ms | 0.4% | 3.9ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5641` |
| 0.4% | 3.7ms | 0.4% | 3.7ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4837` |
| 0.4% | 3.5ms | 0.4% | 3.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4006` |
| 0.4% | 3.5ms | 0.7% | 6.3ms | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5803` |
| 0.4% | 3.5ms | 0.4% | 3.5ms | `has` | `[native code]` |
| 0.4% | 3.5ms | 0.4% | 4.1ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4842` |
| 0.3% | 3.4ms | 0.3% | 3.4ms | `get _tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.3% | 3.3ms | 0.3% | 3.3ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` |
| 0.3% | 3.3ms | 0.3% | 3.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5889` |
| 0.3% | 3.3ms | 0.3% | 3.3ms | `endsWith` | `[native code]` |
| 0.3% | 3.2ms | 0.3% | 3.2ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5742` |
| 0.3% | 3.2ms | 0.3% | 3.4ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:276` |
| 0.3% | 3.2ms | 0.3% | 3.2ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4838` |
| 0.3% | 3.1ms | 0.3% | 3.1ms | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5085` |
| 0.3% | 3.1ms | 0.3% | 3.1ms | `_mkGlobalVar` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.3% | 3.1ms | 0.3% | 3.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1644` |
| 0.3% | 3.1ms | 0.4% | 3.6ms | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5564` |
| 0.3% | 3.0ms | 0.3% | 3.0ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1006` |
| 0.3% | 3.0ms | 0.3% | 3.1ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.3% | 2.9ms | 0.3% | 2.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4005` |
| 0.3% | 2.9ms | 0.5% | 5.1ms | `filter` | `[native code]` |
| 0.3% | 2.8ms | 0.4% | 3.9ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1995` |
| 0.3% | 2.8ms | 0.4% | 4.1ms | `next` | `[native code]` |
| 0.3% | 2.7ms | 0.3% | 2.7ms | `set` | `[native code]` |
| 0.3% | 2.7ms | 0.3% | 2.7ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3890` |
| 0.3% | 2.6ms | 0.3% | 2.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6570` |
| 0.3% | 2.6ms | 0.3% | 2.6ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4641` |
| 0.2% | 2.5ms | 0.2% | 2.5ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1013` |
| 0.2% | 2.5ms | 0.2% | 2.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6533` |
| 0.2% | 2.5ms | 0.2% | 2.5ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4635` |
| 0.2% | 2.4ms | 0.2% | 2.4ms | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5800` |
| 0.2% | 2.4ms | 0.2% | 2.4ms | `entries` | `[native code]` |
| 0.2% | 2.3ms | 0.2% | 2.3ms | `_deepMergeArrays` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:134` |
| 0.2% | 2.3ms | 0.2% | 2.3ms | `trim` | `[native code]` |
| 0.2% | 2.3ms | 0.2% | 2.3ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:805` |
| 0.2% | 2.2ms | 0.5% | 4.4ms | `findVariablesInScope` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:95` |
| 0.2% | 2.2ms | 0.2% | 2.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3986` |
| 0.2% | 2.2ms | 0.2% | 2.2ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5731` |
| 0.2% | 2.1ms | 0.2% | 2.1ms | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:121` |
| 0.2% | 2.1ms | 0.2% | 2.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3995` |
| 0.2% | 2.0ms | 0.2% | 2.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6731` |
| 0.2% | 2.0ms | 0.2% | 2.0ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4656` |
| 0.2% | 1.9ms | 0.2% | 1.9ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:747` |
| 0.2% | 1.8ms | 0.2% | 2.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6865` |
| 0.2% | 1.8ms | 0.2% | 1.8ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4673` |
| 0.2% | 1.8ms | 0.8% | 7.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6735` |
| 0.2% | 1.8ms | 0.9% | 8.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1952` |
| 0.2% | 1.8ms | 0.2% | 1.8ms | `encodeInto` | `[native code]` |
| 0.2% | 1.8ms | 0.2% | 1.8ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5710` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `Int32Array` | `[native code]` |
| 0.2% | 1.7ms | 0.2% | 1.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6635` |
| 0.1% | 1.7ms | 0.2% | 1.8ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:490` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6540` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5730` |
| 0.1% | 1.6ms | 0.2% | 1.8ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4637` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7065` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `decode` | `[native code]` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `dlopen` | `[native code]` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5915` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:533` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4001` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4251` |
| 0.1% | 1.5ms | 0.2% | 1.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1968` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:92` |
| 0.1% | 1.4ms | 0.1% | 1.5ms | `toString` | `[native code]` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `fill` | `[native code]` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4225` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `_tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1072` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4840` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `get start` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 1.3ms | 0.2% | 1.8ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2579` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5647` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:528` |
| 0.1% | 1.3ms | 0.1% | 1.6ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1674` |
| 0.1% | 1.3ms | 0.1% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6416` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5117` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `slice` | `[native code]` |
| 0.1% | 1.2ms | 1.0% | 8.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1189` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4666` |
| 0.1% | 1.2ms | 0.1% | 1.6ms | `performIteration` | `[native code]` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5801` |
| 0.1% | 1.2ms | 0.4% | 4.0ms | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5810` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6351` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1993` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `_expandUnion` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4044` |
| 0.1% | 1.1ms | 0.1% | 1.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1184` |
| 0.1% | 1.1ms | 0.1% | 1.1ms | `add` | `[native code]` |
| 0.1% | 1.1ms | 0.1% | 1.1ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5712` |
| 0.1% | 1.1ms | 0.1% | 1.1ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4220` |
| 0.1% | 1.1ms | 0.1% | 1.1ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4845` |
| 0.1% | 1.1ms | 0.2% | 1.7ms | `isUnderscored` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:101` |
| 0.1% | 1.1ms | 0.1% | 1.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6735` |
| 0.1% | 1.1ms | 0.2% | 1.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1996` |
| 0.1% | 1.1ms | 0.1% | 1.7ms | `_applySchemaDefaults` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:170` |
| 0.1% | 1.1ms | 0.1% | 1.2ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5643` |
| 0.1% | 1.1ms | 0.1% | 1.1ms | `copyDataProperties` | `[native code]` |
| 0.1% | 1.1ms | 0.1% | 1.1ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:642` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4032` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5649` |
| 0.1% | 1.0ms | 1.3% | 11.6ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1679` |
| 0.1% | 1.0ms | 0.1% | 1.2ms | `_isSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4029` |
| 0.1% | 1.0ms | 0.1% | 1.2ms | `isUnderscored` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:105` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `propertyIsEnumerable` | `[native code]` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5735` |
| 0.1% | 1.0ms | 0.3% | 2.8ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:802` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `test` | `[native code]` |
| 0.1% | 1.0ms | 0.2% | 1.9ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:497` |
| 0.1% | 1.0ms | 0.2% | 1.8ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2893` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4002` |
| 0.1% | 1.0ms | 0.3% | 3.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1255` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5642` |
| 0.1% | 986us | 0.1% | 986us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2191` |
| 0.1% | 986us | 0.1% | 986us | `_lineStarts` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:611` |
| 0.1% | 982us | 2.4% | 20.9ms | `forEach` | `[native code]` |
| 0.1% | 979us | 0.1% | 1.4ms | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5597` |
| 0.1% | 970us | 0.1% | 970us | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3546` |
| 0.1% | 969us | 0.1% | 969us | `Uint16Array` | `[native code]` |
| 0.1% | 965us | 0.1% | 965us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1684` |
| 0.1% | 950us | 0.1% | 950us | `iterateDeclarations` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:61` |
| 0.1% | 948us | 0.1% | 1.1ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1999` |
| 0.1% | 934us | 0.1% | 934us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6538` |
| 0.1% | 920us | 0.2% | 1.9ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2845` |
| 0.1% | 915us | 0.1% | 1.2ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:959` |
| 0.1% | 898us | 0.2% | 1.7ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3594` |
| 0.1% | 882us | 0.1% | 1.0ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:440` |
| 0.1% | 876us | 0.1% | 876us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6539` |
| 0.0% | 869us | 0.0% | 869us | `runOnce` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:96` |
| 0.0% | 866us | 0.0% | 866us | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4823` |
| 0.0% | 866us | 0.0% | 866us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6817` |
| 0.0% | 865us | 0.0% | 865us | `defToVariableType` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:204` |
| 0.0% | 865us | 0.0% | 865us | `iterateDeclarations` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:68` |
| 0.0% | 860us | 0.0% | 860us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2832` |
| 0.0% | 858us | 0.3% | 2.7ms | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:152` |
| 0.0% | 857us | 0.0% | 857us | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:226` |
| 0.0% | 857us | 0.0% | 857us | `DataView` | `[native code]` |
| 0.0% | 855us | 0.0% | 855us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6612` |
| 0.0% | 846us | 0.0% | 846us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1994` |
| 0.0% | 845us | 0.4% | 3.9ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 0.0% | 844us | 0.0% | 844us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6969` |
| 0.0% | 839us | 0.0% | 839us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3991` |
| 0.0% | 833us | 0.0% | 833us | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 832us | 0.0% | 832us | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 827us | 0.0% | 827us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5290` |
| 0.0% | 827us | 0.0% | 827us | `_applySchemaDefaults` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:169` |
| 0.0% | 825us | 0.0% | 825us | `getUint32` | `[native code]` |
| 0.0% | 821us | 0.1% | 978us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7322` |
| 0.0% | 799us | 0.1% | 955us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5901` |
| 0.0% | 792us | 0.2% | 2.2ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4232` |
| 0.0% | 787us | 0.0% | 787us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2797` |
| 0.0% | 769us | 21.6% | 188.3ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1888` |
| 0.0% | 769us | 0.0% | 769us | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:865` |
| 0.0% | 762us | 0.1% | 927us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:433` |
| 0.0% | 753us | 0.0% | 753us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1175` |
| 0.0% | 749us | 0.0% | 749us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6729` |
| 0.0% | 741us | 0.1% | 1.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6727` |
| 0.0% | 729us | 0.1% | 1.2ms | `isInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:53` |
| 0.0% | 728us | 0.0% | 728us | `regExpMatchFast` | `[native code]` |
| 0.0% | 727us | 0.0% | 727us | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 724us | 0.6% | 6.0ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:395` |
| 0.0% | 722us | 0.0% | 722us | `fetch` | `[native code]` |
| 0.0% | 720us | 0.1% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6633` |
| 0.0% | 714us | 0.2% | 2.1ms | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:511` |
| 0.0% | 706us | 0.1% | 1.4ms | `findVariablesInScope` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:96` |
| 0.0% | 703us | 0.0% | 703us | `push` | `[native code]` |
| 0.0% | 702us | 0.1% | 1.0ms | `_isSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4025` |
| 0.0% | 699us | 0.0% | 870us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6726` |
| 0.0% | 697us | 0.0% | 839us | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:809` |
| 0.0% | 691us | 0.0% | 691us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6824` |
| 0.0% | 691us | 0.0% | 691us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2514` |
| 0.0% | 690us | 0.0% | 690us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 689us | 0.0% | 832us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5249` |
| 0.0% | 688us | 0.1% | 882us | `_deepMergeObjects` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:129` |
| 0.0% | 683us | 0.0% | 683us | `_makeSafeHandler` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3818` |
| 0.0% | 680us | 1.0% | 9.3ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4199` |
| 0.0% | 676us | 0.0% | 676us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3791` |
| 0.0% | 675us | 12.3% | 107.6ms | `runOnce` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:87` |
| 0.0% | 673us | 0.0% | 819us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4205` |
| 0.0% | 670us | 0.0% | 670us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6411` |
| 0.0% | 660us | 0.0% | 660us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3999` |
| 0.0% | 655us | 10.8% | 94.2ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1886` |
| 0.0% | 655us | 0.1% | 968us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6610` |
| 0.0% | 653us | 0.6% | 5.4ms | `_deepMergeArrays` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:136` |
| 0.0% | 652us | 0.0% | 652us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5713` |
| 0.0% | 651us | 0.0% | 651us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 649us | 0.0% | 828us | `_deepMergeArrays` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:137` |
| 0.0% | 647us | 0.1% | 981us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.0% | 647us | 0.0% | 811us | `_parseDisableDirectives` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7412` |
| 0.0% | 647us | 0.0% | 647us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6541` |
| 0.0% | 646us | 0.4% | 3.9ms | `runOnce` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:101` |
| 0.0% | 643us | 0.0% | 816us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1330` |
| 0.0% | 638us | 0.0% | 638us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:510` |
| 0.0% | 636us | 0.0% | 636us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7082` |
| 0.0% | 624us | 0.0% | 624us | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2859` |
| 0.0% | 622us | 0.5% | 5.0ms | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5593` |
| 0.0% | 619us | 0.0% | 619us | `_applySchemaDefaults` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:161` |
| 0.0% | 615us | 0.3% | 3.2ms | `async loadAndEvaluateModule` | `[native code]` |
| 0.0% | 610us | 0.0% | 610us | `/^_+\|_+$/gu` | `[native code]` |
| 0.0% | 598us | 0.1% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6833` |
| 0.0% | 587us | 0.1% | 1.1ms | `readFileSync` | `[native code]` |
| 0.0% | 581us | 0.0% | 581us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 579us | 0.0% | 579us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6621` |
| 0.0% | 578us | 0.1% | 966us | `_isSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4033` |
| 0.0% | 574us | 0.0% | 574us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6757` |
| 0.0% | 574us | 0.0% | 574us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2319` |
| 0.0% | 570us | 27.3% | 237.5ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4554` |
| 0.0% | 566us | 0.0% | 566us | `newRegistryEntry` | `[native code]` |
| 0.0% | 562us | 0.0% | 562us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7365` |
| 0.0% | 562us | 0.0% | 562us | `get left` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1754` |
| 0.0% | 559us | 0.0% | 559us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4133` |
| 0.0% | 553us | 0.0% | 553us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:76` |
| 0.0% | 539us | 0.0% | 539us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1696` |
| 0.0% | 538us | 0.0% | 538us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4000` |
| 0.0% | 537us | 2.4% | 21.0ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1961` |
| 0.0% | 537us | 17.9% | 155.9ms | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1501` |
| 0.0% | 536us | 0.0% | 536us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 534us | 20.2% | 176.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7097` |
| 0.0% | 533us | 0.0% | 533us | `iterateDeclarations` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:59` |
| 0.0% | 530us | 0.0% | 530us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4176` |
| 0.0% | 530us | 0.0% | 530us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 530us | 0.0% | 530us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3067` |
| 0.0% | 529us | 0.0% | 529us | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:828` |
| 0.0% | 529us | 0.7% | 6.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1855` |
| 0.0% | 529us | 0.9% | 8.3ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 0.0% | 527us | 0.0% | 527us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 526us | 0.1% | 1.1ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:308` |
| 0.0% | 525us | 0.0% | 525us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4176` |
| 0.0% | 525us | 0.4% | 4.1ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2887` |
| 0.0% | 525us | 83.6% | 727.7ms | `runOnce` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:92` |
| 0.0% | 525us | 0.0% | 525us | `get byteLength` | `[native code]` |
| 0.0% | 525us | 0.0% | 525us | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1067` |
| 0.0% | 524us | 0.0% | 524us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6532` |
| 0.0% | 524us | 0.0% | 524us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6949` |
| 0.0% | 521us | 0.0% | 661us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:352` |
| 0.0% | 521us | 0.0% | 521us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1962` |
| 0.0% | 520us | 0.0% | 520us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6822` |
| 0.0% | 520us | 0.3% | 3.1ms | `Program` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:275` |
| 0.0% | 520us | 0.0% | 520us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7351` |
| 0.0% | 520us | 2.3% | 20.0ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2337` |
| 0.0% | 518us | 0.0% | 518us | `get mainToken` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1089` |
| 0.0% | 515us | 99.6% | 867.1ms | `parseModule` | `[native code]` |
| 0.0% | 513us | 0.0% | 513us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4034` |
| 0.0% | 512us | 0.0% | 512us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5114` |
| 0.0% | 512us | 0.0% | 512us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2774` |
| 0.0% | 511us | 0.0% | 854us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:305` |
| 0.0% | 510us | 0.0% | 510us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6412` |
| 0.0% | 509us | 0.0% | 509us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2494` |
| 0.0% | 509us | 0.3% | 2.6ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1716` |
| 0.0% | 508us | 0.0% | 508us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1548` |
| 0.0% | 507us | 0.0% | 507us | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4874` |
| 0.0% | 504us | 0.0% | 504us | `_makeBoundReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3802` |
| 0.0% | 503us | 0.1% | 1.0ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:461` |
| 0.0% | 498us | 0.0% | 670us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1274` |
| 0.0% | 497us | 2.7% | 24.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1997` |
| 0.0% | 497us | 0.0% | 497us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7136` |
| 0.0% | 496us | 0.0% | 812us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:423` |
| 0.0% | 494us | 1.1% | 9.9ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2553` |
| 0.0% | 494us | 0.0% | 494us | `get start` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1092` |
| 0.0% | 493us | 0.0% | 493us | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2907` |
| 0.0% | 493us | 0.0% | 493us | `Map` | `[native code]` |
| 0.0% | 491us | 0.0% | 491us | `mainToken` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1089` |
| 0.0% | 491us | 0.4% | 3.9ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:180` |
| 0.0% | 489us | 0.0% | 489us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6558` |
| 0.0% | 488us | 0.0% | 624us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5656` |
| 0.0% | 487us | 0.0% | 782us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:474` |
| 0.0% | 487us | 0.0% | 487us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1887` |
| 0.0% | 487us | 0.0% | 487us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:126` |
| 0.0% | 486us | 0.0% | 486us | `includes` | `[native code]` |
| 0.0% | 482us | 0.0% | 680us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1663` |
| 0.0% | 478us | 0.0% | 478us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6529` |
| 0.0% | 478us | 5.4% | 47.0ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2281` |
| 0.0% | 478us | 0.0% | 478us | `_getOrBuildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5441` |
| 0.0% | 471us | 0.0% | 471us | `isClassRefInClassDecorator` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:254` |
| 0.0% | 468us | 0.0% | 468us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6460` |
| 0.0% | 468us | 1.0% | 9.1ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4226` |
| 0.0% | 467us | 0.0% | 607us | `getDestructuringHost` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:103` |
| 0.0% | 466us | 0.1% | 985us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:232` |
| 0.0% | 462us | 0.0% | 462us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3997` |
| 0.0% | 454us | 0.0% | 454us | `create` | `[native code]` |
| 0.0% | 453us | 0.2% | 1.7ms | `_deepMergeObjects` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:126` |
| 0.0% | 430us | 0.0% | 430us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3998` |
| 0.0% | 391us | 2.8% | 24.7ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5782` |
| 0.0% | 391us | 0.0% | 391us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7135` |
| 0.0% | 386us | 0.0% | 386us | `getDestructuringHost` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:98` |
| 0.0% | 384us | 0.0% | 384us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:332` |
| 0.0% | 382us | 0.4% | 3.7ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2809` |
| 0.0% | 381us | 0.0% | 381us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6414` |
| 0.0% | 379us | 0.0% | 379us | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2864` |
| 0.0% | 379us | 0.1% | 1.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2529` |
| 0.0% | 379us | 0.0% | 379us | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1038` |
| 0.0% | 379us | 0.0% | 379us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6634` |
| 0.0% | 377us | 0.0% | 377us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4973` |
| 0.0% | 375us | 0.0% | 375us | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1048` |
| 0.0% | 374us | 0.0% | 374us | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.0% | 373us | 0.0% | 702us | `_compileAttrCheck` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5198` |
| 0.0% | 372us | 0.0% | 685us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:954` |
| 0.0% | 371us | 0.0% | 371us | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 371us | 0.0% | 529us | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:798` |
| 0.0% | 370us | 0.0% | 370us | `_applySchemaDefaults` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:167` |
| 0.0% | 369us | 0.0% | 369us | `/^[A-Z][A-Za-z]*$/` | `[native code]` |
| 0.0% | 368us | 0.2% | 1.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2571` |
| 0.0% | 368us | 0.0% | 516us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4207` |
| 0.0% | 368us | 12.9% | 112.2ms | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1816` |
| 0.0% | 368us | 0.0% | 368us | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5802` |
| 0.0% | 367us | 0.1% | 1.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7032` |
| 0.0% | 366us | 0.0% | 558us | `get right` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1789` |
| 0.0% | 365us | 0.0% | 365us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5087` |
| 0.0% | 365us | 0.0% | 365us | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6780` |
| 0.0% | 364us | 0.0% | 364us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5752` |
| 0.0% | 364us | 1.2% | 10.6ms | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5571` |
| 0.0% | 364us | 0.0% | 536us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:450` |
| 0.0% | 363us | 0.0% | 516us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6507` |
| 0.0% | 361us | 0.1% | 1.6ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4214` |
| 0.0% | 359us | 0.0% | 359us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4037` |
| 0.0% | 359us | 0.0% | 359us | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2331` |
| 0.0% | 357us | 0.0% | 357us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 357us | 0.0% | 357us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` |
| 0.0% | 357us | 0.7% | 6.8ms | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5142` |
| 0.0% | 357us | 0.0% | 357us | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 356us | 0.0% | 356us | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 355us | 0.0% | 355us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1205` |
| 0.0% | 353us | 0.0% | 353us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1596` |
| 0.0% | 352us | 0.0% | 352us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6744` |
| 0.0% | 351us | 0.2% | 2.1ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:366` |
| 0.0% | 351us | 0.1% | 1.0ms | `isLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:168` |
| 0.0% | 351us | 0.0% | 351us | `slotTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5793` |
| 0.0% | 350us | 0.0% | 350us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3790` |
| 0.0% | 350us | 0.4% | 3.6ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1925` |
| 0.0% | 349us | 0.0% | 349us | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1817` |
| 0.0% | 349us | 0.0% | 349us | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4835` |
| 0.0% | 347us | 0.0% | 632us | `get left` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1756` |
| 0.0% | 346us | 2.4% | 21.5ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1889` |
| 0.0% | 346us | 0.0% | 346us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:930` |
| 0.0% | 346us | 0.0% | 346us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5746` |
| 0.0% | 344us | 0.0% | 344us | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1829` |
| 0.0% | 344us | 0.0% | 344us | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5809` |
| 0.0% | 343us | 0.0% | 343us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4198` |
| 0.0% | 343us | 0.0% | 343us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:961` |
| 0.0% | 343us | 0.2% | 2.2ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:689` |
| 0.0% | 341us | 0.0% | 341us | `_applySchemaDefaults` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:165` |
| 0.0% | 340us | 0.0% | 340us | `RuleSkipSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4776` |
| 0.0% | 340us | 0.0% | 480us | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3550` |
| 0.0% | 340us | 0.0% | 340us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6768` |
| 0.0% | 340us | 0.0% | 340us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5917` |
| 0.0% | 340us | 1.2% | 10.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1884` |
| 0.0% | 338us | 0.1% | 1.0ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2470` |
| 0.0% | 338us | 0.0% | 338us | `ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1847` |
| 0.0% | 338us | 0.0% | 338us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 337us | 0.0% | 638us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:411` |
| 0.0% | 337us | 0.0% | 496us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:473` |
| 0.0% | 337us | 0.0% | 337us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2326` |
| 0.0% | 337us | 0.1% | 1.1ms | `_parseDisableDirectives` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7404` |
| 0.0% | 336us | 0.0% | 851us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5688` |
| 0.0% | 336us | 0.0% | 487us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4187` |
| 0.0% | 336us | 0.0% | 336us | `_expandUnion` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4043` |
| 0.0% | 334us | 0.0% | 334us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6601` |
| 0.0% | 334us | 0.0% | 334us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6099` |
| 0.0% | 334us | 0.0% | 334us | `_makeSafeHandler` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3829` |
| 0.0% | 333us | 0.0% | 333us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:84` |
| 0.0% | 333us | 0.0% | 667us | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5947` |
| 0.0% | 332us | 0.0% | 332us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:142` |
| 0.0% | 331us | 0.1% | 1.2ms | `isInitOfForStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:40` |
| 0.0% | 331us | 0.1% | 893us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:436` |
| 0.0% | 331us | 0.0% | 331us | `ensureBufferBytes` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:53` |
| 0.0% | 330us | 0.0% | 330us | `slotTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5792` |
| 0.0% | 330us | 0.0% | 330us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3734` |
| 0.0% | 327us | 0.0% | 327us | `_ensureTagCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5490` |
| 0.0% | 326us | 0.1% | 1.0ms | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5591` |
| 0.0% | 326us | 0.0% | 326us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1957` |
| 0.0% | 325us | 0.0% | 491us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4195` |
| 0.0% | 325us | 0.2% | 1.8ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1906` |
| 0.0% | 324us | 0.0% | 324us | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1007` |
| 0.0% | 322us | 0.0% | 322us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2198` |
| 0.0% | 321us | 0.1% | 1.0ms | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2910` |
| 0.0% | 321us | 0.0% | 460us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4235` |
| 0.0% | 320us | 0.0% | 320us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 320us | 6.3% | 55.0ms | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` |
| 0.0% | 320us | 0.2% | 2.1ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3902` |
| 0.0% | 319us | 0.2% | 1.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1222` |
| 0.0% | 318us | 0.0% | 318us | `existsSync` | `[native code]` |
| 0.0% | 318us | 0.0% | 318us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1903` |
| 0.0% | 318us | 0.0% | 318us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2317` |
| 0.0% | 317us | 0.2% | 1.9ms | `getArrayMethodName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:116` |
| 0.0% | 317us | 0.0% | 317us | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3547` |
| 0.0% | 316us | 0.1% | 982us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6872` |
| 0.0% | 316us | 0.3% | 3.1ms | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:92` |
| 0.0% | 315us | 0.0% | 315us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5716` |
| 0.0% | 315us | 0.1% | 1.0ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:314` |
| 0.0% | 314us | 0.0% | 314us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4541` |
| 0.0% | 313us | 0.6% | 5.6ms | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3804` |
| 0.0% | 313us | 0.0% | 313us | `regExpSplitFast` | `[native code]` |
| 0.0% | 313us | 0.0% | 313us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7307` |
| 0.0% | 313us | 0.0% | 313us | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2879` |
| 0.0% | 312us | 0.0% | 795us | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5808` |
| 0.0% | 311us | 0.0% | 311us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 310us | 0.0% | 310us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 310us | 0.0% | 500us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6814` |
| 0.0% | 309us | 0.0% | 309us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5258` |
| 0.0% | 309us | 0.1% | 1.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1237` |
| 0.0% | 308us | 0.0% | 308us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2065` |
| 0.0% | 304us | 0.0% | 304us | `checkGroup` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:438` |
| 0.0% | 304us | 0.1% | 1.1ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:487` |
| 0.0% | 303us | 0.0% | 303us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 303us | 0.1% | 981us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1328` |
| 0.0% | 303us | 0.0% | 303us | `RegExp` | `[native code]` |
| 0.0% | 300us | 0.0% | 300us | `/\[[^\]]*\]/g` | `[native code]` |
| 0.0% | 294us | 0.0% | 654us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2661` |
| 0.0% | 293us | 0.0% | 293us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 293us | 0.0% | 293us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5650` |
| 0.0% | 289us | 0.0% | 289us | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:664` |
| 0.0% | 288us | 0.0% | 288us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3066` |
| 0.0% | 288us | 0.0% | 288us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 288us | 0.0% | 448us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` |
| 0.0% | 285us | 0.0% | 285us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:682` |
| 0.0% | 282us | 0.0% | 282us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6641` |
| 0.0% | 279us | 0.0% | 279us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:159` |
| 0.0% | 212us | 0.0% | 212us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:641` |
| 0.0% | 211us | 0.0% | 211us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:479` |
| 0.0% | 205us | 0.1% | 1.1ms | `Program` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:294` |
| 0.0% | 204us | 0.0% | 204us | `keys` | `[native code]` |
| 0.0% | 203us | 0.0% | 356us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4241` |
| 0.0% | 203us | 99.8% | 868.9ms | `async (anonymous)` | `[native code]` |
| 0.0% | 202us | 0.0% | 202us | `isInitPatternNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:277` |
| 0.0% | 202us | 0.0% | 202us | `/^(?:Arrow)?FunctionExpression$/u` | `[native code]` |
| 0.0% | 201us | 0.0% | 201us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6589` |
| 0.0% | 200us | 0.0% | 200us | `safeHandler` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3820` |
| 0.0% | 199us | 0.0% | 199us | `uncurryThis` | `internal:primordials:20` |
| 0.0% | 198us | 0.0% | 198us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5694` |
| 0.0% | 198us | 0.0% | 198us | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 198us | 0.2% | 2.5ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:179` |
| 0.0% | 198us | 0.0% | 198us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6845` |
| 0.0% | 198us | 0.0% | 198us | `checkText` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js` |
| 0.0% | 197us | 0.0% | 197us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4179` |
| 0.0% | 197us | 0.0% | 197us | `_getPlugin` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:59` |
| 0.0% | 196us | 0.0% | 196us | `isInitPatternNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:318` |
| 0.0% | 196us | 0.0% | 196us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:277` |
| 0.0% | 196us | 0.0% | 386us | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:511` |
| 0.0% | 196us | 0.0% | 196us | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2269` |
| 0.0% | 195us | 0.0% | 559us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:306` |
| 0.0% | 195us | 0.0% | 195us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:221` |
| 0.0% | 195us | 0.0% | 195us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:637` |
| 0.0% | 194us | 0.0% | 194us | `_deepMergeObjects` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:122` |
| 0.0% | 194us | 0.0% | 194us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:415` |
| 0.0% | 194us | 0.0% | 194us | `isTypeValueShadow` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js` |
| 0.0% | 194us | 0.0% | 194us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6449` |
| 0.0% | 194us | 0.0% | 194us | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3623` |
| 0.0% | 194us | 0.0% | 361us | `runOnce` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:90` |
| 0.0% | 194us | 0.0% | 194us | `extraMethodData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:694` |
| 0.0% | 194us | 0.0% | 194us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1700` |
| 0.0% | 194us | 0.0% | 194us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2099` |
| 0.0% | 194us | 5.2% | 45.6ms | `require` | `[native code]` |
| 0.0% | 194us | 0.0% | 356us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:68` |
| 0.0% | 194us | 0.0% | 194us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:462` |
| 0.0% | 193us | 0.0% | 193us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 193us | 0.0% | 193us | `isImportAttributeKey` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:1423` |
| 0.0% | 193us | 0.0% | 193us | `node:fs/promises` | `node:fs/promises:175` |
| 0.0% | 193us | 0.0% | 193us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4227` |
| 0.0% | 193us | 0.0% | 193us | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3620` |
| 0.0% | 193us | 0.0% | 193us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js` |
| 0.0% | 193us | 0.0% | 193us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js` |
| 0.0% | 193us | 0.0% | 193us | `_getTypeProto` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3969` |
| 0.0% | 193us | 0.0% | 193us | `_tryLoad` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js` |
| 0.0% | 193us | 0.0% | 193us | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3604` |
| 0.0% | 193us | 0.0% | 193us | `getOwnPropertyDescriptors` | `[native code]` |
| 0.0% | 192us | 0.0% | 192us | `Function` | `[native code]` |
| 0.0% | 192us | 18.8% | 164.4ms | `ensureRefsThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1824` |
| 0.0% | 192us | 0.0% | 192us | `/[\s\[>~+.(]/` | `[native code]` |
| 0.0% | 192us | 0.0% | 366us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4225` |
| 0.0% | 192us | 0.0% | 192us | `isTypeParameterOfStaticMethod` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:206` |
| 0.0% | 192us | 0.0% | 192us | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5931` |
| 0.0% | 191us | 0.0% | 191us | `get imported` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3501` |
| 0.0% | 191us | 0.0% | 191us | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 191us | 0.0% | 191us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3884` |
| 0.0% | 191us | 0.0% | 191us | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4329` |
| 0.0% | 191us | 0.0% | 191us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6450` |
| 0.0% | 191us | 0.1% | 1.2ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3786` |
| 0.0% | 191us | 0.0% | 191us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6965` |
| 0.0% | 191us | 0.0% | 191us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3759` |
| 0.0% | 191us | 0.0% | 353us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6506` |
| 0.0% | 191us | 0.0% | 191us | `hasMemberExpressionAssignment` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:125` |
| 0.0% | 191us | 0.0% | 191us | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2973` |
| 0.0% | 191us | 0.0% | 511us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:408` |
| 0.0% | 190us | 0.0% | 190us | `isModifyingProp` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js` |
| 0.0% | 190us | 0.0% | 190us | `isImportAttributeKey` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:1440` |
| 0.0% | 190us | 0.0% | 190us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:656` |
| 0.0% | 190us | 0.0% | 190us | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 189us | 0.0% | 189us | `get callee` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1873` |
| 0.0% | 189us | 0.0% | 189us | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4649` |
| 0.0% | 189us | 0.0% | 189us | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:815` |
| 0.0% | 189us | 0.0% | 189us | `isModifyingProp` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:99` |
| 0.0% | 189us | 0.0% | 189us | `shouldCheck` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:399` |
| 0.0% | 189us | 0.0% | 189us | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6810` |
| 0.0% | 189us | 0.0% | 189us | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4655` |
| 0.0% | 189us | 0.0% | 527us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6758` |
| 0.0% | 189us | 0.0% | 556us | `getLocFromIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3359` |
| 0.0% | 188us | 0.0% | 188us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 188us | 0.0% | 188us | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4668` |
| 0.0% | 188us | 0.1% | 912us | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:662` |
| 0.0% | 188us | 0.0% | 188us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.0% | 188us | 1.0% | 9.3ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3065` |
| 0.0% | 187us | 2.3% | 20.8ms | `ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1848` |
| 0.0% | 187us | 0.0% | 187us | `be` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 187us | 0.0% | 382us | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:620` |
| 0.0% | 187us | 0.0% | 367us | `iterateDeclarations` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:77` |
| 0.0% | 187us | 0.0% | 378us | `codepath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4256` |
| 0.0% | 187us | 0.0% | 187us | `isFunctionNameInitializerException` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:402` |
| 0.0% | 187us | 0.0% | 347us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4210` |
| 0.0% | 186us | 0.0% | 186us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6625` |
| 0.0% | 186us | 0.0% | 294us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6946` |
| 0.0% | 186us | 0.0% | 186us | `checkLastSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:320` |
| 0.0% | 186us | 0.0% | 186us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6201` |
| 0.0% | 186us | 0.0% | 186us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6255` |
| 0.0% | 186us | 0.0% | 502us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:428` |
| 0.0% | 186us | 0.0% | 186us | `loadBinding` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:10` |
| 0.0% | 186us | 0.0% | 339us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5062` |
| 0.0% | 186us | 0.0% | 186us | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2933` |
| 0.0% | 186us | 0.0% | 186us | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6358` |
| 0.0% | 186us | 0.3% | 2.8ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2316` |
| 0.0% | 185us | 0.0% | 185us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5292` |
| 0.0% | 185us | 0.0% | 185us | `isAllowed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js` |
| 0.0% | 185us | 0.0% | 185us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:331` |
| 0.0% | 185us | 0.0% | 185us | `fullMethodName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:55` |
| 0.0% | 185us | 0.0% | 552us | `onCodePathStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:405` |
| 0.0% | 185us | 0.0% | 185us | `isThisParam` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:147` |
| 0.0% | 185us | 0.0% | 502us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4188` |
| 0.0% | 185us | 0.0% | 185us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:291` |
| 0.0% | 184us | 0.0% | 184us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7070` |
| 0.0% | 184us | 0.0% | 184us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1340` |
| 0.0% | 184us | 0.0% | 184us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4218` |
| 0.0% | 184us | 0.0% | 652us | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5102` |
| 0.0% | 184us | 0.0% | 184us | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` |
| 0.0% | 184us | 0.0% | 184us | `isClassRefInClassDecorator` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js` |
| 0.0% | 183us | 0.0% | 183us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4256` |
| 0.0% | 183us | 0.0% | 183us | `Proxy` | `[native code]` |
| 0.0% | 183us | 0.0% | 183us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4003` |
| 0.0% | 183us | 0.0% | 183us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1673` |
| 0.0% | 183us | 0.0% | 183us | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3885` |
| 0.0% | 183us | 0.0% | 183us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3788` |
| 0.0% | 183us | 0.0% | 183us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4250` |
| 0.0% | 183us | 0.0% | 183us | `isInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:231` |
| 0.0% | 182us | 0.0% | 182us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/escape-string-regexp/index.js` |
| 0.0% | 182us | 0.0% | 182us | `getFunctionHeadLoc` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2312` |
| 0.0% | 182us | 0.0% | 182us | `_dispatchSeg` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6111` |
| 0.0% | 182us | 0.0% | 182us | `getFirstTokenBetween` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 182us | 0.0% | 182us | `checkReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:190` |
| 0.0% | 182us | 0.0% | 182us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1200` |
| 0.0% | 182us | 5.5% | 48.1ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` |
| 0.0% | 182us | 0.0% | 182us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1208` |
| 0.0% | 181us | 0.7% | 6.4ms | `onCodePathStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:406` |
| 0.0% | 181us | 0.0% | 535us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4197` |
| 0.0% | 181us | 0.0% | 181us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1603` |
| 0.0% | 181us | 0.0% | 340us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3749` |
| 0.0% | 181us | 0.0% | 181us | `get local` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 181us | 0.0% | 181us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:74` |
| 0.0% | 181us | 0.2% | 2.0ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2865` |
| 0.0% | 180us | 0.0% | 180us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:655` |
| 0.0% | 180us | 0.0% | 180us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2768` |
| 0.0% | 180us | 0.0% | 504us | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2257` |
| 0.0% | 180us | 0.0% | 180us | `checkReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:201` |
| 0.0% | 180us | 0.0% | 725us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` |
| 0.0% | 180us | 0.0% | 180us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1451` |
| 0.0% | 180us | 0.0% | 180us | `cloneObject` | `[native code]` |
| 0.0% | 180us | 0.2% | 2.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 180us | 0.0% | 372us | `shouldCheck` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:393` |
| 0.0% | 180us | 0.0% | 180us | `getIdentifierIfShouldBeConst` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:233` |
| 0.0% | 179us | 0.0% | 493us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:479` |
| 0.0% | 179us | 0.0% | 179us | `hideFromStack` | `internal:shared:19` |
| 0.0% | 179us | 0.0% | 335us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:319` |
| 0.0% | 179us | 1.7% | 15.4ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2356` |
| 0.0% | 179us | 0.0% | 179us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3744` |
| 0.0% | 179us | 0.0% | 533us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:205` |
| 0.0% | 179us | 0.0% | 179us | `CfgSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 179us | 0.1% | 1.5ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2283` |
| 0.0% | 179us | 0.0% | 179us | `fix` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:155` |
| 0.0% | 179us | 0.0% | 179us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` |
| 0.0% | 178us | 0.0% | 178us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2665` |
| 0.0% | 178us | 0.0% | 178us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7058` |
| 0.0% | 178us | 0.0% | 178us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4984` |
| 0.0% | 178us | 0.0% | 849us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:420` |
| 0.0% | 178us | 0.0% | 178us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6715` |
| 0.0% | 178us | 0.0% | 685us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:437` |
| 0.0% | 178us | 0.0% | 178us | `getNameLocationInGlobalDirectiveComment` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2634` |
| 0.0% | 178us | 0.0% | 178us | `/^:[a-z-]+\s*/` | `[native code]` |
| 0.0% | 178us | 0.0% | 178us | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 178us | 0.0% | 178us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1614` |
| 0.0% | 177us | 0.0% | 319us | `referenceContainsTypeQuery` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:227` |
| 0.0% | 177us | 0.0% | 177us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:434` |
| 0.0% | 177us | 0.0% | 177us | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1778` |
| 0.0% | 177us | 0.2% | 1.7ms | `VariableDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:548` |
| 0.0% | 177us | 0.0% | 177us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5247` |
| 0.0% | 177us | 0.3% | 3.1ms | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:642` |
| 0.0% | 176us | 0.0% | 176us | `getVariableDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:235` |
| 0.0% | 176us | 0.0% | 176us | `get quasis` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3068` |
| 0.0% | 176us | 0.0% | 176us | `getArrayMethodName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:138` |
| 0.0% | 176us | 0.0% | 646us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4240` |
| 0.0% | 176us | 0.0% | 176us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 176us | 0.0% | 176us | `getFunctionHeadLoc` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2285` |
| 0.0% | 176us | 0.0% | 176us | `getTokenAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1221` |
| 0.0% | 176us | 0.1% | 960us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:136` |
| 0.0% | 176us | 0.1% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7165` |
| 0.0% | 175us | 0.0% | 175us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2273` |
| 0.0% | 175us | 0.0% | 175us | `_nodeStartPos` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:888` |
| 0.0% | 175us | 0.0% | 175us | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 175us | 0.0% | 175us | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5976` |
| 0.0% | 174us | 0.0% | 174us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6816` |
| 0.0% | 174us | 0.0% | 335us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` |
| 0.0% | 174us | 0.0% | 174us | `hasObservableSideEffectsForRegExpSplit` | `[native code]` |
| 0.0% | 174us | 0.0% | 174us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2822` |
| 0.0% | 174us | 0.0% | 352us | `getFunctionNameWithKind` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2181` |
| 0.0% | 174us | 0.0% | 174us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 173us | 0.0% | 173us | `Program` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:290` |
| 0.0% | 173us | 0.0% | 173us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:488` |
| 0.0% | 173us | 0.0% | 461us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3046` |
| 0.0% | 173us | 0.0% | 173us | `isModifyingProp` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:127` |
| 0.0% | 173us | 0.0% | 173us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2378` |
| 0.0% | 173us | 0.0% | 173us | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4868` |
| 0.0% | 173us | 0.0% | 173us | `_loadFromDisk` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js` |
| 0.0% | 173us | 0.0% | 173us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:123` |
| 0.0% | 173us | 0.0% | 173us | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 173us | 0.0% | 173us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:387` |
| 0.0% | 172us | 0.0% | 172us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4030` |
| 0.0% | 172us | 0.0% | 172us | `/^(?:DoWhile\|For\|ForIn\|ForOf\|While)Statement$/u` | `[native code]` |
| 0.0% | 172us | 0.0% | 789us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4222` |
| 0.0% | 172us | 0.0% | 172us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2614` |
| 0.0% | 172us | 0.0% | 172us | `[Symbol.iterator]` | `[native code]` |
| 0.0% | 172us | 0.0% | 172us | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 172us | 0.0% | 172us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1238` |
| 0.0% | 172us | 0.0% | 172us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6752` |
| 0.0% | 172us | 0.0% | 172us | `isOuterVariableInDestructing` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:79` |
| 0.0% | 172us | 0.8% | 7.0ms | `findVariablesInScope` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:94` |
| 0.0% | 171us | 0.9% | 8.0ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5651` |
| 0.0% | 171us | 0.0% | 171us | `bound` | `node:os:107` |
| 0.0% | 171us | 0.0% | 171us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4033` |
| 0.0% | 171us | 0.0% | 864us | `_isSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4031` |
| 0.0% | 171us | 0.0% | 171us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:80` |
| 0.0% | 171us | 0.0% | 171us | `speciesConstructor` | `[native code]` |
| 0.0% | 171us | 0.0% | 171us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1380` |
| 0.0% | 171us | 0.0% | 315us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5285` |
| 0.0% | 171us | 0.0% | 171us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 171us | 0.0% | 171us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:383` |
| 0.0% | 171us | 0.0% | 346us | `getIdentifierIfShouldBeConst` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:218` |
| 0.0% | 171us | 0.0% | 508us | `_getTypeProto` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3976` |
| 0.0% | 170us | 0.0% | 170us | `CfgSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4289` |
| 0.0% | 170us | 0.0% | 170us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6445` |
| 0.0% | 170us | 0.0% | 170us | `get mainToken` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 170us | 0.0% | 170us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:51` |
| 0.0% | 170us | 1.1% | 9.7ms | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5263` |
| 0.0% | 169us | 0.0% | 169us | `getArrayMethodName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:72` |
| 0.0% | 169us | 0.0% | 169us | `_rawTokenText` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:781` |
| 0.0% | 169us | 0.0% | 169us | `get property` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1946` |
| 0.0% | 169us | 0.0% | 169us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5653` |
| 0.0% | 169us | 0.0% | 169us | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:743` |
| 0.0% | 169us | 0.0% | 486us | `isNullCheck` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:125` |
| 0.0% | 169us | 0.0% | 312us | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5031` |
| 0.0% | 169us | 0.0% | 169us | `_deepMergeObjects` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:127` |
| 0.0% | 169us | 0.0% | 169us | `_computeMinTok` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:529` |
| 0.0% | 169us | 0.0% | 169us | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5032` |
| 0.0% | 168us | 0.0% | 168us | `shouldCheck` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:369` |
| 0.0% | 168us | 0.0% | 168us | `ensureRefsThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 168us | 0.0% | 509us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1929` |
| 0.0% | 168us | 0.0% | 168us | `_isStatementTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:77` |
| 0.0% | 168us | 0.2% | 1.7ms | `(anonymous)` | `[native code]` |
| 0.0% | 168us | 0.0% | 168us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4229` |
| 0.0% | 168us | 0.0% | 168us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4237` |
| 0.0% | 167us | 0.0% | 167us | `getAssignedMessageData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:309` |
| 0.0% | 167us | 0.0% | 167us | `safeHandler` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 167us | 0.0% | 167us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:289` |
| 0.0% | 167us | 0.0% | 167us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2175` |
| 0.0% | 167us | 0.0% | 167us | `isClassStaticInitializerScope` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:88` |
| 0.0% | 167us | 0.0% | 167us | `a` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 167us | 0.0% | 167us | `get left` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1766` |
| 0.0% | 167us | 0.0% | 167us | `hasObservableSideEffectsForRegExpMatch` | `[native code]` |
| 0.0% | 166us | 0.0% | 166us | `_cookTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:28` |
| 0.0% | 166us | 0.0% | 166us | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4665` |
| 0.0% | 166us | 0.0% | 836us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5665` |
| 0.0% | 166us | 0.0% | 166us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2803` |
| 0.0% | 166us | 0.0% | 166us | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:773` |
| 0.0% | 166us | 0.0% | 166us | `iterateDeclarations` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js` |
| 0.0% | 166us | 0.0% | 535us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4031` |
| 0.0% | 166us | 0.0% | 166us | `runOnce` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:84` |
| 0.0% | 166us | 0.0% | 166us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:452` |
| 0.0% | 166us | 0.0% | 166us | `kw` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 166us | 0.3% | 2.8ms | `getArrayMethodName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:124` |
| 0.0% | 165us | 0.0% | 165us | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5587` |
| 0.0% | 165us | 0.0% | 165us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6825` |
| 0.0% | 165us | 0.0% | 165us | `_scopeForNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:847` |
| 0.0% | 165us | 0.0% | 165us | `get computed` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1978` |
| 0.0% | 165us | 0.0% | 165us | `replaceTextRange` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/fix-tracker.js:97` |
| 0.0% | 165us | 0.0% | 165us | `replaceTextRange` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 165us | 0.0% | 165us | `isExported` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:358` |
| 0.0% | 165us | 0.0% | 827us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1384` |
| 0.0% | 165us | 0.0% | 165us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6505` |
| 0.0% | 165us | 0.0% | 165us | `extraArrowData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:676` |
| 0.0% | 164us | 0.0% | 164us | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2341` |
| 0.0% | 164us | 0.0% | 164us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5903` |
| 0.0% | 164us | 0.5% | 4.6ms | `Program` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:272` |
| 0.0% | 164us | 0.0% | 164us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 164us | 0.0% | 164us | `ge` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 163us | 0.0% | 163us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4056` |
| 0.0% | 163us | 0.0% | 163us | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:649` |
| 0.0% | 163us | 0.0% | 163us | `resolve` | `[native code]` |
| 0.0% | 163us | 0.0% | 163us | `get flags` | `[native code]` |
| 0.0% | 163us | 0.0% | 163us | `applyDisableDirectives` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7441` |
| 0.0% | 163us | 0.0% | 783us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1325` |
| 0.0% | 163us | 0.0% | 163us | `buildUnicodeData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 163us | 0.0% | 163us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4071` |
| 0.0% | 162us | 0.0% | 354us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 0.0% | 162us | 0.0% | 162us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1978` |
| 0.0% | 162us | 0.0% | 162us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4190` |
| 0.0% | 162us | 0.0% | 162us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:117` |
| 0.0% | 162us | 0.0% | 162us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2685` |
| 0.0% | 162us | 0.0% | 162us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1471` |
| 0.0% | 162us | 0.0% | 721us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1700` |
| 0.0% | 162us | 0.0% | 162us | `onUnreachableCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js` |
| 0.0% | 162us | 0.0% | 162us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2190` |
| 0.0% | 162us | 0.0% | 162us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2183` |
| 0.0% | 162us | 0.0% | 162us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:769` |
| 0.0% | 162us | 0.0% | 162us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js` |
| 0.0% | 161us | 0.0% | 161us | `isRead` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 161us | 0.0% | 161us | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:716` |
| 0.0% | 161us | 0.0% | 826us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:338` |
| 0.0% | 161us | 0.0% | 338us | `get local` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3477` |
| 0.0% | 161us | 0.0% | 161us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1620` |
| 0.0% | 161us | 0.0% | 161us | `getDefinedMessageData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:274` |
| 0.0% | 161us | 0.0% | 161us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:126` |
| 0.0% | 161us | 0.1% | 1.6ms | `getFunctionHeadLoc` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2308` |
| 0.0% | 161us | 0.0% | 161us | `/[iI]gnored/u` | `[native code]` |
| 0.0% | 161us | 0.0% | 161us | `runOnce` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js` |
| 0.0% | 161us | 0.1% | 1.1ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4255` |
| 0.0% | 161us | 0.0% | 161us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1612` |
| 0.0% | 161us | 0.1% | 1.1ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2880` |
| 0.0% | 161us | 0.0% | 161us | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5601` |
| 0.0% | 160us | 0.0% | 160us | `getStaticStringValue` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js` |
| 0.0% | 160us | 0.1% | 1.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` |
| 0.0% | 160us | 0.0% | 160us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6101` |
| 0.0% | 160us | 0.0% | 160us | `getTagNames` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:189` |
| 0.0% | 160us | 0.0% | 160us | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:513` |
| 0.0% | 160us | 0.0% | 160us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6464` |
| 0.0% | 160us | 0.0% | 509us | `segment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4250` |
| 0.0% | 160us | 0.0% | 160us | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:807` |
| 0.0% | 160us | 0.0% | 160us | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2962` |
| 0.0% | 159us | 0.0% | 159us | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6359` |
| 0.0% | 159us | 0.0% | 159us | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6022` |
| 0.0% | 159us | 0.0% | 159us | `describeRule` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:32` |
| 0.0% | 159us | 0.0% | 159us | `ObjectExpression > Property[computed!=true] > Identifier.key,MethodDefinition[computed!=true] > Identifier.key,PropertyDefinition[computed!=true] > Identifier.key,MethodDefinition > PrivateIdentifier.key,PropertyDefinition > PrivateIdentifier.key` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:351` |
| 0.0% | 159us | 0.0% | 159us | `equalsToOriginalName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:178` |
| 0.0% | 158us | 0.0% | 158us | `replace` | `[native code]` |
| 0.0% | 158us | 0.0% | 837us | `every` | `[native code]` |
| 0.0% | 158us | 0.0% | 158us | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 158us | 0.0% | 158us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:179` |
| 0.0% | 158us | 0.0% | 158us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.0% | 158us | 0.0% | 158us | `hasRestSpreadSibling` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.0% | 158us | 2.5% | 22.2ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5771` |
| 0.0% | 158us | 0.0% | 510us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:440` |
| 0.0% | 158us | 0.0% | 158us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 0.0% | 158us | 0.0% | 158us | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 158us | 0.0% | 158us | `join` | `[native code]` |
| 0.0% | 158us | 0.0% | 158us | `toUpperCase` | `[native code]` |
| 0.0% | 157us | 0.0% | 157us | `checkLastSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:393` |
| 0.0% | 157us | 0.0% | 157us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4004` |
| 0.0% | 157us | 0.1% | 989us | `getNameRange` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:456` |
| 0.0% | 156us | 0.0% | 156us | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4855` |
| 0.0% | 156us | 0.0% | 156us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:841` |
| 0.0% | 156us | 1.2% | 10.9ms | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5260` |
| 0.0% | 156us | 0.0% | 156us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js` |
| 0.0% | 156us | 0.0% | 156us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3055` |
| 0.0% | 156us | 0.0% | 156us | `get nodeTags` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:602` |
| 0.0% | 156us | 5.7% | 50.1ms | `bound require` | `[native code]` |
| 0.0% | 156us | 0.0% | 156us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5891` |
| 0.0% | 156us | 0.0% | 156us | `getTokenAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1261` |
| 0.0% | 156us | 0.0% | 156us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1295` |
| 0.0% | 156us | 0.0% | 156us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4213` |
| 0.0% | 156us | 0.0% | 156us | `replaceText` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3696` |
| 0.0% | 156us | 0.1% | 1.0ms | `describeRule` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:30` |
| 0.0% | 155us | 0.0% | 155us | `onCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:434` |
| 0.0% | 155us | 0.0% | 155us | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4688` |
| 0.0% | 155us | 0.0% | 155us | `/:([a-z-]+)\([^)]*\)/g` | `[native code]` |
| 0.0% | 155us | 0.0% | 155us | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4853` |
| 0.0% | 155us | 0.0% | 155us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2216` |
| 0.0% | 155us | 0.0% | 155us | `/(?:Statement\|Declaration\|Function(?:Expression)?\|Program)$/u` | `[native code]` |
| 0.0% | 155us | 0.9% | 8.2ms | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 0.0% | 155us | 0.0% | 155us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5120` |
| 0.0% | 154us | 0.0% | 154us | `get test` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1598` |
| 0.0% | 154us | 0.4% | 3.7ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1923` |
| 0.0% | 154us | 0.0% | 154us | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 154us | 0.0% | 154us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6536` |
| 0.0% | 154us | 0.0% | 489us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2636` |
| 0.0% | 154us | 0.0% | 154us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6417` |
| 0.0% | 153us | 0.0% | 153us | `delete` | `[native code]` |
| 0.0% | 153us | 0.1% | 1.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1673` |
| 0.0% | 153us | 0.0% | 153us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:384` |
| 0.0% | 152us | 0.0% | 501us | `checkGroup` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:426` |
| 0.0% | 152us | 0.0% | 152us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4991` |
| 0.0% | 152us | 0.2% | 2.5ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4249` |
| 0.0% | 152us | 0.0% | 793us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:90` |
| 0.0% | 152us | 0.0% | 152us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1735` |
| 0.0% | 152us | 1.0% | 9.1ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2524` |
| 0.0% | 152us | 0.0% | 152us | `ke` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 152us | 0.0% | 152us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1694` |
| 0.0% | 151us | 0.0% | 151us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:412` |
| 0.0% | 151us | 0.0% | 151us | `checkLastSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:316` |
| 0.0% | 151us | 0.1% | 1.1ms | `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:318` |
| 0.0% | 151us | 0.0% | 151us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5051` |
| 0.0% | 151us | 0.0% | 151us | `get kind` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 151us | 0.0% | 151us | `checkVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:227` |
| 0.0% | 151us | 0.0% | 497us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:460` |
| 0.0% | 150us | 0.3% | 3.4ms | `slotTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5798` |
| 0.0% | 150us | 0.0% | 150us | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:818` |
| 0.0% | 150us | 0.0% | 150us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3028` |
| 0.0% | 150us | 0.0% | 564us | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2945` |
| 0.0% | 150us | 0.0% | 439us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1699` |
| 0.0% | 150us | 0.0% | 150us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2275` |
| 0.0% | 150us | 0.0% | 337us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:313` |
| 0.0% | 150us | 0.7% | 6.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2813` |
| 0.0% | 150us | 0.0% | 150us | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1019` |
| 0.0% | 150us | 0.0% | 342us | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2259` |
| 0.0% | 150us | 0.0% | 150us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:136` |
| 0.0% | 149us | 0.1% | 918us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2439` |
| 0.0% | 149us | 0.0% | 149us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6458` |
| 0.0% | 149us | 0.0% | 149us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6467` |
| 0.0% | 149us | 0.1% | 1.1ms | `_deepMergeObjects` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:128` |
| 0.0% | 149us | 0.8% | 7.6ms | `VariableDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:549` |
| 0.0% | 149us | 0.0% | 149us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5064` |
| 0.0% | 149us | 0.0% | 149us | `getDefinedMessageData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.0% | 148us | 0.0% | 148us | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1037` |
| 0.0% | 148us | 0.0% | 148us | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 148us | 0.0% | 148us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4288` |
| 0.0% | 148us | 0.0% | 148us | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2939` |
| 0.0% | 148us | 0.0% | 615us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:399` |
| 0.0% | 148us | 0.0% | 148us | `_getFfiSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:105` |
| 0.0% | 148us | 0.0% | 148us | `isExported` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:363` |
| 0.0% | 148us | 0.0% | 148us | `defineProperty` | `[native code]` |
| 0.0% | 147us | 0.0% | 147us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 147us | 0.0% | 147us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4258` |
| 0.0% | 147us | 0.0% | 147us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2844` |
| 0.0% | 147us | 0.0% | 147us | `_ensureTagCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5532` |
| 0.0% | 147us | 0.0% | 147us | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4832` |
| 0.0% | 147us | 0.0% | 147us | `_isChainChild` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3866` |
| 0.0% | 147us | 0.0% | 147us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:351` |
| 0.0% | 147us | 0.0% | 147us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 147us | 0.0% | 147us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:82` |
| 0.0% | 146us | 0.0% | 146us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 146us | 0.8% | 7.7ms | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7373` |
| 0.0% | 146us | 0.0% | 146us | `RuleContext` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 146us | 0.0% | 146us | `parse` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 146us | 0.0% | 146us | `get properties` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3087` |
| 0.0% | 146us | 0.0% | 146us | `equalsToOriginalName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js` |
| 0.0% | 145us | 0.0% | 670us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:405` |
| 0.0% | 145us | 0.0% | 310us | `isImportAttributeKey` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:1426` |
| 0.0% | 145us | 0.0% | 145us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1954` |
| 0.0% | 145us | 0.0% | 145us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 145us | 0.0% | 335us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5048` |
| 0.0% | 145us | 0.0% | 145us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2748` |
| 0.0% | 145us | 0.0% | 321us | `getStaticStringValue` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:263` |
| 0.0% | 145us | 0.0% | 145us | `checkText` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:355` |
| 0.0% | 145us | 0.0% | 145us | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2913` |
| 0.0% | 144us | 0.0% | 144us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4983` |
| 0.0% | 144us | 0.0% | 144us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` |
| 0.0% | 144us | 0.0% | 144us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5655` |
| 0.0% | 144us | 0.0% | 144us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1649` |
| 0.0% | 144us | 0.0% | 323us | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3614` |
| 0.0% | 143us | 0.0% | 143us | `evaluate` | `[native code]` |
| 0.0% | 143us | 0.1% | 1.1ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3774` |
| 0.0% | 143us | 0.0% | 143us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:818` |
| 0.0% | 143us | 0.0% | 143us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:228` |
| 0.0% | 143us | 0.0% | 143us | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4844` |
| 0.0% | 143us | 0.0% | 143us | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5944` |
| 0.0% | 143us | 0.0% | 143us | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5563` |
| 0.0% | 143us | 0.0% | 143us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2471` |
| 0.0% | 142us | 0.0% | 329us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2057` |
| 0.0% | 142us | 1.1% | 10.4ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2816` |
| 0.0% | 142us | 0.0% | 142us | `e` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 142us | 0.0% | 142us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1744` |
| 0.0% | 142us | 0.0% | 487us | `[Symbol.split]` | `[native code]` |
| 0.0% | 142us | 0.0% | 142us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6469` |
| 0.0% | 142us | 0.1% | 997us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:323` |
| 0.0% | 142us | 0.0% | 142us | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5956` |
| 0.0% | 141us | 0.1% | 1.6ms | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5161` |
| 0.0% | 141us | 0.0% | 141us | `ImportDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:373` |
| 0.0% | 141us | 0.0% | 464us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:451` |
| 0.0% | 141us | 0.0% | 141us | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1030` |
| 0.0% | 140us | 0.0% | 140us | `get callee` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1871` |
| 0.0% | 140us | 0.0% | 140us | `_nodeEndPos` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:880` |
| 0.0% | 140us | 0.1% | 1.5ms | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:624` |
| 0.0% | 140us | 0.0% | 140us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6952` |
| 0.0% | 140us | 0.0% | 140us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6256` |
| 0.0% | 140us | 0.0% | 140us | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1011` |
| 0.0% | 140us | 0.0% | 140us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5288` |
| 0.0% | 140us | 0.0% | 140us | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2333` |
| 0.0% | 139us | 0.0% | 139us | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1012` |
| 0.0% | 139us | 0.0% | 139us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:180` |
| 0.0% | 139us | 0.0% | 139us | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:737` |
| 0.0% | 139us | 0.0% | 139us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5798` |
| 0.0% | 139us | 0.0% | 139us | `get property` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1941` |
| 0.0% | 138us | 0.0% | 335us | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4857` |
| 0.0% | 138us | 0.0% | 138us | `getUpperFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:130` |
| 0.0% | 138us | 0.0% | 138us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:370` |
| 0.0% | 138us | 0.0% | 138us | `_deepMergeObjects` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 138us | 0.0% | 138us | `_parseDisableDirectives` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 138us | 0.0% | 703us | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2954` |
| 0.0% | 137us | 0.0% | 137us | `_getChainExpr` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3913` |
| 0.0% | 137us | 0.1% | 1.1ms | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:656` |
| 0.0% | 137us | 0.0% | 137us | `ensureBufferBytes` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js` |
| 0.0% | 137us | 0.0% | 137us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1958` |
| 0.0% | 136us | 0.0% | 136us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:428` |
| 0.0% | 135us | 0.0% | 135us | `isFunctionNameInitializerException` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js` |
| 0.0% | 135us | 0.0% | 135us | `(anonymous)` | `internal:primordials:39` |
| 0.0% | 133us | 0.0% | 133us | `_isChainMiddleTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3854` |
| 0.0% | 122us | 0.0% | 122us | `getFirstToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 99.8% | 868.9ms | 0.0% | 203us | `async (anonymous)` | `[native code]` |
| 99.6% | 867.1ms | 0.0% | 515us | `parseModule` | `[native code]` |
| 83.6% | 727.7ms | 0.0% | 525us | `runOnce` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:92` |
| 76.0% | 661.4ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7382` |
| 51.5% | 448.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:113` |
| 45.1% | 392.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:108` |
| 27.3% | 237.5ms | 0.0% | 570us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4554` |
| 21.6% | 188.3ms | 0.0% | 769us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1888` |
| 20.2% | 176.3ms | 0.0% | 534us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7097` |
| 19.6% | 170.9ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6524` |
| 19.5% | 170.5ms | 0.0% | 0us | `_getOrBuildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5453` |
| 18.8% | 164.4ms | 0.0% | 192us | `ensureRefsThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1824` |
| 17.9% | 155.9ms | 0.0% | 537us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1501` |
| 15.8% | 137.5ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2369` |
| 12.9% | 112.2ms | 0.0% | 368us | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1816` |
| 12.3% | 107.6ms | 0.0% | 675us | `runOnce` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:87` |
| 10.8% | 94.2ms | 0.0% | 655us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1886` |
| 10.4% | 91.3ms | 0.0% | 0us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2267` |
| 8.0% | 69.9ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` |
| 7.4% | 65.0ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6900` |
| 6.3% | 55.0ms | 0.0% | 320us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` |
| 6.2% | 54.7ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7380` |
| 6.0% | 52.6ms | 2.4% | 21.2ms | `anonymous` | `[native code]` |
| 6.0% | 52.5ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6716` |
| 5.9% | 52.1ms | 0.0% | 0us | `Program` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:449` |
| 5.9% | 52.1ms | 0.0% | 0us | `safeHandler` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3822` |
| 5.7% | 50.1ms | 0.0% | 156us | `bound require` | `[native code]` |
| 5.6% | 49.3ms | 5.6% | 49.3ms | `parse` | `[native code]` |
| 5.5% | 48.1ms | 0.0% | 182us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` |
| 5.4% | 47.0ms | 0.0% | 478us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2281` |
| 5.2% | 46.0ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:224` |
| 5.2% | 45.6ms | 0.0% | 194us | `require` | `[native code]` |
| 3.4% | 29.6ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 3.0% | 26.8ms | 2.8% | 25.1ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1998` |
| 3.0% | 26.8ms | 2.9% | 26.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6826` |
| 3.0% | 26.2ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6291` |
| 2.8% | 25.1ms | 0.9% | 8.5ms | `some` | `[native code]` |
| 2.8% | 24.7ms | 0.0% | 391us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5782` |
| 2.7% | 24.2ms | 0.0% | 497us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1997` |
| 2.6% | 22.7ms | 2.6% | 22.7ms | `Uint32Array` | `[native code]` |
| 2.5% | 22.2ms | 0.0% | 158us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5771` |
| 2.4% | 21.5ms | 0.0% | 346us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1889` |
| 2.4% | 21.3ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:683` |
| 2.4% | 21.0ms | 0.0% | 537us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1961` |
| 2.4% | 20.9ms | 0.1% | 982us | `forEach` | `[native code]` |
| 2.3% | 20.8ms | 0.0% | 187us | `ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1848` |
| 2.3% | 20.6ms | 2.3% | 20.6ms | `_mkGlobalVar` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:587` |
| 2.3% | 20.1ms | 2.3% | 20.1ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5745` |
| 2.3% | 20.1ms | 0.0% | 0us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5776` |
| 2.3% | 20.1ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1885` |
| 2.3% | 20.0ms | 0.0% | 520us | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2337` |
| 2.2% | 19.3ms | 0.0% | 0us | `ensureRefsThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1823` |
| 1.9% | 17.1ms | 0.0% | 0us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2204` |
| 1.8% | 16.4ms | 1.8% | 16.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2167` |
| 1.7% | 15.4ms | 0.0% | 179us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2356` |
| 1.7% | 14.8ms | 1.5% | 13.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6602` |
| 1.6% | 14.6ms | 0.0% | 0us | `Program` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:268` |
| 1.6% | 14.3ms | 1.6% | 14.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6685` |
| 1.6% | 14.1ms | 1.3% | 11.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6759` |
| 1.4% | 12.7ms | 0.8% | 6.9ms | `map` | `[native code]` |
| 1.4% | 12.7ms | 0.0% | 0us | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` |
| 1.4% | 12.6ms | 0.0% | 0us | `Program` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:147` |
| 1.4% | 12.3ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:441` |
| 1.3% | 11.6ms | 0.1% | 1.0ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1679` |
| 1.2% | 11.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:46` |
| 1.2% | 11.1ms | 1.2% | 11.1ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5761` |
| 1.2% | 10.9ms | 0.0% | 156us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5260` |
| 1.2% | 10.6ms | 0.0% | 364us | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5571` |
| 1.2% | 10.4ms | 0.0% | 340us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1884` |
| 1.1% | 10.4ms | 0.0% | 142us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2816` |
| 1.1% | 10.2ms | 1.1% | 10.2ms | `defineProperties` | `[native code]` |
| 1.1% | 9.9ms | 0.0% | 494us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2553` |
| 1.1% | 9.7ms | 0.0% | 170us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5263` |
| 1.0% | 9.5ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:690` |
| 1.0% | 9.3ms | 0.9% | 8.2ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5690` |
| 1.0% | 9.3ms | 0.0% | 680us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4199` |
| 1.0% | 9.3ms | 0.0% | 188us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3065` |
| 1.0% | 9.2ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6894` |
| 1.0% | 9.1ms | 0.0% | 468us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4226` |
| 1.0% | 9.1ms | 0.0% | 152us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2524` |
| 1.0% | 8.8ms | 1.0% | 8.8ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 1.0% | 8.7ms | 0.8% | 7.1ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5687` |
| 1.0% | 8.7ms | 0.1% | 1.2ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1189` |
| 0.9% | 8.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 0.9% | 8.5ms | 0.7% | 6.4ms | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5804` |
| 0.9% | 8.3ms | 0.0% | 529us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 0.9% | 8.2ms | 0.0% | 155us | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 0.9% | 8.2ms | 0.2% | 1.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1952` |
| 0.9% | 8.0ms | 0.0% | 171us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5651` |
| 0.9% | 8.0ms | 0.9% | 8.0ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5754` |
| 0.8% | 7.7ms | 0.0% | 146us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7373` |
| 0.8% | 7.6ms | 0.0% | 149us | `VariableDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:549` |
| 0.8% | 7.6ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` |
| 0.8% | 7.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:12` |
| 0.8% | 7.3ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 0.8% | 7.0ms | 0.2% | 1.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6735` |
| 0.8% | 7.0ms | 0.0% | 0us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6484` |
| 0.8% | 7.0ms | 0.0% | 172us | `findVariablesInScope` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:94` |
| 0.7% | 6.8ms | 0.0% | 357us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5142` |
| 0.7% | 6.6ms | 0.7% | 6.6ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4661` |
| 0.7% | 6.4ms | 0.0% | 181us | `onCodePathStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:406` |
| 0.7% | 6.4ms | 0.0% | 529us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1855` |
| 0.7% | 6.4ms | 0.6% | 5.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3994` |
| 0.7% | 6.3ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6898` |
| 0.7% | 6.3ms | 0.7% | 6.3ms | `Set` | `[native code]` |
| 0.7% | 6.3ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:542` |
| 0.7% | 6.3ms | 0.4% | 3.5ms | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5803` |
| 0.7% | 6.3ms | 0.0% | 150us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2813` |
| 0.7% | 6.1ms | 0.0% | 0us | `checkForFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:238` |
| 0.6% | 6.0ms | 0.0% | 724us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:395` |
| 0.6% | 6.0ms | 0.6% | 6.0ms | `get` | `[native code]` |
| 0.6% | 5.9ms | 0.6% | 5.9ms | `indexOf` | `[native code]` |
| 0.6% | 5.8ms | 0.6% | 5.8ms | `Uint8Array` | `[native code]` |
| 0.6% | 5.8ms | 0.0% | 0us | `checkReferencesInScope` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:426` |
| 0.6% | 5.7ms | 0.6% | 5.3ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5697` |
| 0.6% | 5.6ms | 0.5% | 4.7ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1285` |
| 0.6% | 5.6ms | 0.0% | 313us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3804` |
| 0.6% | 5.5ms | 0.0% | 0us | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6084` |
| 0.6% | 5.4ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4234` |
| 0.6% | 5.4ms | 0.0% | 653us | `_deepMergeArrays` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:136` |
| 0.6% | 5.3ms | 0.6% | 5.3ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1613` |
| 0.6% | 5.3ms | 0.6% | 5.3ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:505` |
| 0.5% | 5.1ms | 0.3% | 2.9ms | `filter` | `[native code]` |
| 0.5% | 5.0ms | 0.0% | 0us | `Program` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:145` |
| 0.5% | 5.0ms | 0.0% | 0us | `checkReferencesInScope` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:444` |
| 0.5% | 5.0ms | 0.0% | 622us | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5593` |
| 0.5% | 4.9ms | 0.5% | 4.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6733` |
| 0.5% | 4.9ms | 0.5% | 4.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6732` |
| 0.5% | 4.7ms | 0.5% | 4.7ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4839` |
| 0.5% | 4.7ms | 0.5% | 4.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6818` |
| 0.5% | 4.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.5% | 4.6ms | 0.0% | 164us | `Program` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:272` |
| 0.5% | 4.6ms | 0.5% | 4.6ms | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5557` |
| 0.5% | 4.5ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4200` |
| 0.5% | 4.4ms | 0.2% | 2.2ms | `findVariablesInScope` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:95` |
| 0.5% | 4.4ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4239` |
| 0.5% | 4.3ms | 0.5% | 4.3ms | `stringSplitFast` | `[native code]` |
| 0.4% | 4.3ms | 0.4% | 4.3ms | `get _tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1072` |
| 0.4% | 4.2ms | 0.4% | 4.2ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5714` |
| 0.4% | 4.1ms | 0.4% | 4.0ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4252` |
| 0.4% | 4.1ms | 0.4% | 3.5ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4842` |
| 0.4% | 4.1ms | 0.3% | 2.8ms | `next` | `[native code]` |
| 0.4% | 4.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:21` |
| 0.4% | 4.1ms | 0.0% | 525us | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2887` |
| 0.4% | 4.0ms | 0.1% | 1.2ms | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5810` |
| 0.4% | 3.9ms | 0.0% | 491us | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:180` |
| 0.4% | 3.9ms | 0.4% | 3.9ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5641` |
| 0.4% | 3.9ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:215` |
| 0.4% | 3.9ms | 0.3% | 2.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1995` |
| 0.4% | 3.9ms | 0.0% | 845us | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 0.4% | 3.9ms | 0.0% | 0us | `BinaryExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:206` |
| 0.4% | 3.9ms | 0.0% | 646us | `runOnce` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:101` |
| 0.4% | 3.7ms | 0.0% | 382us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2809` |
| 0.4% | 3.7ms | 0.4% | 3.7ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4837` |
| 0.4% | 3.7ms | 0.0% | 154us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1923` |
| 0.4% | 3.6ms | 0.0% | 350us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1925` |
| 0.4% | 3.6ms | 0.0% | 0us | `ensureRefsThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1830` |
| 0.4% | 3.6ms | 0.3% | 3.1ms | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5564` |
| 0.4% | 3.5ms | 0.4% | 3.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4006` |
| 0.4% | 3.5ms | 0.4% | 3.5ms | `has` | `[native code]` |
| 0.3% | 3.4ms | 0.0% | 150us | `slotTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5798` |
| 0.3% | 3.4ms | 0.3% | 3.4ms | `get _tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.3% | 3.4ms | 0.3% | 3.2ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:276` |
| 0.3% | 3.3ms | 0.3% | 3.3ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` |
| 0.3% | 3.3ms | 0.3% | 3.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5889` |
| 0.3% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:56` |
| 0.3% | 3.3ms | 0.3% | 3.3ms | `endsWith` | `[native code]` |
| 0.3% | 3.2ms | 0.3% | 3.2ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5742` |
| 0.3% | 3.2ms | 0.1% | 1.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1255` |
| 0.3% | 3.2ms | 0.0% | 0us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4220` |
| 0.3% | 3.2ms | 0.3% | 3.2ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4838` |
| 0.3% | 3.2ms | 0.0% | 615us | `async loadAndEvaluateModule` | `[native code]` |
| 0.3% | 3.1ms | 0.3% | 3.1ms | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5085` |
| 0.3% | 3.1ms | 0.3% | 3.0ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.3% | 3.1ms | 0.0% | 316us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:92` |
| 0.3% | 3.1ms | 0.0% | 520us | `Program` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:275` |
| 0.3% | 3.1ms | 0.3% | 3.1ms | `_mkGlobalVar` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.3% | 3.1ms | 0.0% | 177us | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:642` |
| 0.3% | 3.1ms | 0.0% | 0us | `groupByDestructuring` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:290` |
| 0.3% | 3.1ms | 0.3% | 3.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1644` |
| 0.3% | 3.0ms | 0.3% | 3.0ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1006` |
| 0.3% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` |
| 0.3% | 2.9ms | 0.3% | 2.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4005` |
| 0.3% | 2.9ms | 0.0% | 0us | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:868` |
| 0.3% | 2.9ms | 0.0% | 0us | `getVariableByName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:1599` |
| 0.3% | 2.9ms | 0.0% | 0us | `isGoodName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:128` |
| 0.3% | 2.9ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:138` |
| 0.3% | 2.8ms | 0.1% | 1.0ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:802` |
| 0.3% | 2.8ms | 0.0% | 166us | `getArrayMethodName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:124` |
| 0.3% | 2.8ms | 0.0% | 0us | `esquery` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:53` |
| 0.3% | 2.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:20` |
| 0.3% | 2.8ms | 0.0% | 186us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2316` |
| 0.3% | 2.8ms | 0.0% | 0us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1337` |
| 0.3% | 2.7ms | 0.0% | 858us | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:152` |
| 0.3% | 2.7ms | 0.3% | 2.7ms | `set` | `[native code]` |
| 0.3% | 2.7ms | 0.3% | 2.7ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3890` |
| 0.3% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.3% | 2.6ms | 0.3% | 2.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6570` |
| 0.3% | 2.6ms | 0.3% | 2.6ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4641` |
| 0.3% | 2.6ms | 0.0% | 0us | `getFirstTokenBetween` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1335` |
| 0.3% | 2.6ms | 0.0% | 509us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1716` |
| 0.2% | 2.6ms | 0.2% | 1.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6865` |
| 0.2% | 2.6ms | 0.0% | 0us | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5993` |
| 0.2% | 2.5ms | 0.0% | 198us | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:179` |
| 0.2% | 2.5ms | 0.2% | 2.5ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1013` |
| 0.2% | 2.5ms | 0.0% | 152us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4249` |
| 0.2% | 2.5ms | 0.2% | 2.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6533` |
| 0.2% | 2.5ms | 0.2% | 2.5ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4635` |
| 0.2% | 2.4ms | 0.2% | 2.4ms | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5800` |
| 0.2% | 2.4ms | 0.2% | 2.4ms | `entries` | `[native code]` |
| 0.2% | 2.4ms | 0.0% | 0us | `checkVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:228` |
| 0.2% | 2.3ms | 0.2% | 2.3ms | `_deepMergeArrays` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:134` |
| 0.2% | 2.3ms | 0.2% | 2.3ms | `trim` | `[native code]` |
| 0.2% | 2.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:433` |
| 0.2% | 2.3ms | 0.2% | 2.3ms | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:805` |
| 0.2% | 2.2ms | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:401` |
| 0.2% | 2.2ms | 0.0% | 0us | `isSpecificMemberAccess` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:389` |
| 0.2% | 2.2ms | 0.0% | 792us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4232` |
| 0.2% | 2.2ms | 0.0% | 0us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5331` |
| 0.2% | 2.2ms | 0.0% | 343us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:689` |
| 0.2% | 2.2ms | 0.0% | 0us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5658` |
| 0.2% | 2.2ms | 0.0% | 180us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.2% | 2.2ms | 0.2% | 2.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3986` |
| 0.2% | 2.2ms | 0.2% | 2.2ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5731` |
| 0.2% | 2.1ms | 0.2% | 2.1ms | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:121` |
| 0.2% | 2.1ms | 0.0% | 320us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3902` |
| 0.2% | 2.1ms | 0.0% | 714us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:511` |
| 0.2% | 2.1ms | 0.0% | 351us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:366` |
| 0.2% | 2.1ms | 0.2% | 2.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3995` |
| 0.2% | 2.1ms | 0.0% | 0us | `checkLastSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:384` |
| 0.2% | 2.0ms | 0.0% | 0us | `applyDisableDirectives` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7442` |
| 0.2% | 2.0ms | 0.2% | 2.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6731` |
| 0.2% | 2.0ms | 0.2% | 2.0ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4656` |
| 0.2% | 2.0ms | 0.0% | 181us | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2865` |
| 0.2% | 2.0ms | 0.0% | 0us | `generatorResume` | `[native code]` |
| 0.2% | 1.9ms | 0.1% | 920us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2845` |
| 0.2% | 1.9ms | 0.2% | 1.9ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:747` |
| 0.2% | 1.9ms | 0.0% | 0us | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2874` |
| 0.2% | 1.9ms | 0.2% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6635` |
| 0.2% | 1.9ms | 0.0% | 317us | `getArrayMethodName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:116` |
| 0.2% | 1.9ms | 0.1% | 1.0ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:497` |
| 0.2% | 1.8ms | 0.1% | 1.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1968` |
| 0.2% | 1.8ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.2% | 1.8ms | 0.1% | 1.7ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:490` |
| 0.2% | 1.8ms | 0.0% | 0us | `async loadModule` | `[native code]` |
| 0.2% | 1.8ms | 0.2% | 1.8ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4673` |
| 0.2% | 1.8ms | 0.0% | 325us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1906` |
| 0.2% | 1.8ms | 0.1% | 1.6ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4637` |
| 0.2% | 1.8ms | 0.1% | 1.1ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1996` |
| 0.2% | 1.8ms | 0.2% | 1.8ms | `encodeInto` | `[native code]` |
| 0.2% | 1.8ms | 0.2% | 1.8ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5710` |
| 0.2% | 1.8ms | 0.1% | 1.3ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2579` |
| 0.2% | 1.8ms | 0.1% | 1.0ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2893` |
| 0.2% | 1.7ms | 0.0% | 168us | `(anonymous)` | `[native code]` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `Int32Array` | `[native code]` |
| 0.2% | 1.7ms | 0.0% | 319us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1222` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:14` |
| 0.2% | 1.7ms | 0.0% | 177us | `VariableDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:548` |
| 0.2% | 1.7ms | 0.0% | 453us | `_deepMergeObjects` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:126` |
| 0.2% | 1.7ms | 0.1% | 1.1ms | `isUnderscored` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:101` |
| 0.2% | 1.7ms | 0.1% | 898us | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3594` |
| 0.2% | 1.7ms | 0.0% | 368us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2571` |
| 0.1% | 1.7ms | 0.1% | 1.1ms | `_applySchemaDefaults` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:170` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6540` |
| 0.1% | 1.7ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` |
| 0.1% | 1.7ms | 0.1% | 1.7ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5730` |
| 0.1% | 1.6ms | 0.1% | 1.3ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1674` |
| 0.1% | 1.6ms | 0.1% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6416` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7065` |
| 0.1% | 1.6ms | 0.0% | 0us | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5998` |
| 0.1% | 1.6ms | 0.0% | 141us | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5161` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `decode` | `[native code]` |
| 0.1% | 1.6ms | 0.0% | 0us | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2978` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `dlopen` | `[native code]` |
| 0.1% | 1.6ms | 0.0% | 161us | `getFunctionHeadLoc` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2308` |
| 0.1% | 1.6ms | 0.1% | 1.2ms | `performIteration` | `[native code]` |
| 0.1% | 1.6ms | 0.0% | 361us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4214` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5915` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:533` |
| 0.1% | 1.5ms | 0.1% | 1.4ms | `toString` | `[native code]` |
| 0.1% | 1.5ms | 0.0% | 0us | `isAvailable` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:399` |
| 0.1% | 1.5ms | 0.0% | 0us | `_getFfiSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:110` |
| 0.1% | 1.5ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6863` |
| 0.1% | 1.5ms | 0.0% | 179us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2283` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4001` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4251` |
| 0.1% | 1.5ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6749` |
| 0.1% | 1.5ms | 0.0% | 0us | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5554` |
| 0.1% | 1.5ms | 0.0% | 140us | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:624` |
| 0.1% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` |
| 0.1% | 1.5ms | 0.0% | 0us | `g` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.1% | 1.5ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:296` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:92` |
| 0.1% | 1.4ms | 0.0% | 160us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` |
| 0.1% | 1.4ms | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1680` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` |
| 0.1% | 1.4ms | 0.1% | 979us | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5597` |
| 0.1% | 1.4ms | 0.0% | 598us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6833` |
| 0.1% | 1.4ms | 0.0% | 0us | `_isSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4030` |
| 0.1% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` |
| 0.1% | 1.4ms | 0.0% | 706us | `findVariablesInScope` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:96` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `fill` | `[native code]` |
| 0.1% | 1.3ms | 0.0% | 379us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2529` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4225` |
| 0.1% | 1.3ms | 0.0% | 0us | `Ae` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.1% | 1.3ms | 0.0% | 0us | `parse` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.1% | 1.3ms | 0.0% | 720us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6633` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `_tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1072` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4840` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `get start` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.3ms | 0.0% | 176us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7165` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5647` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:528` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` |
| 0.1% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5117` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `slice` | `[native code]` |
| 0.1% | 1.2ms | 0.1% | 1.1ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5643` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4666` |
| 0.1% | 1.2ms | 0.0% | 729us | `isInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:53` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5801` |
| 0.1% | 1.2ms | 0.0% | 331us | `isInitOfForStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:40` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6351` |
| 0.1% | 1.2ms | 0.1% | 1.0ms | `_isSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4029` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1993` |
| 0.1% | 1.2ms | 0.0% | 0us | `checkReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:209` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `_expandUnion` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4044` |
| 0.1% | 1.2ms | 0.0% | 191us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3786` |
| 0.1% | 1.2ms | 0.1% | 915us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:959` |
| 0.1% | 1.2ms | 0.0% | 0us | `Pe` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.1% | 1.2ms | 0.0% | 0us | `we` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.1% | 1.2ms | 0.0% | 0us | `_e` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.1% | 1.2ms | 0.1% | 1.0ms | `isUnderscored` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:105` |
| 0.1% | 1.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` |
| 0.1% | 1.1ms | 0.0% | 161us | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2880` |
| 0.1% | 1.1ms | 0.0% | 149us | `_deepMergeObjects` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:128` |
| 0.1% | 1.1ms | 0.1% | 1.1ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1184` |
| 0.1% | 1.1ms | 0.1% | 1.1ms | `add` | `[native code]` |
| 0.1% | 1.1ms | 0.1% | 1.1ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5712` |
| 0.1% | 1.1ms | 0.0% | 304us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:487` |
| 0.1% | 1.1ms | 0.0% | 161us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4255` |
| 0.1% | 1.1ms | 0.0% | 526us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:308` |
| 0.1% | 1.1ms | 0.0% | 587us | `readFileSync` | `[native code]` |
| 0.1% | 1.1ms | 0.0% | 205us | `Program` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:294` |
| 0.1% | 1.1ms | 0.1% | 1.1ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4220` |
| 0.1% | 1.1ms | 0.0% | 0us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6471` |
| 0.1% | 1.1ms | 0.1% | 1.1ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4845` |
| 0.1% | 1.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:13` |
| 0.1% | 1.1ms | 0.0% | 0us | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5992` |
| 0.1% | 1.1ms | 0.1% | 1.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6735` |
| 0.1% | 1.1ms | 0.0% | 337us | `_parseDisableDirectives` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7404` |
| 0.1% | 1.1ms | 0.0% | 143us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3774` |
| 0.1% | 1.1ms | 0.0% | 0us | `checkGroup` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:509` |
| 0.1% | 1.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:510` |
| 0.1% | 1.1ms | 0.0% | 153us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1673` |
| 0.1% | 1.1ms | 0.0% | 137us | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:656` |
| 0.1% | 1.1ms | 0.1% | 1.1ms | `copyDataProperties` | `[native code]` |
| 0.1% | 1.1ms | 0.1% | 948us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1999` |
| 0.1% | 1.1ms | 0.1% | 1.1ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:642` |
| 0.1% | 1.1ms | 0.0% | 151us | `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:318` |
| 0.1% | 1.1ms | 0.0% | 0us | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:453` |
| 0.1% | 1.1ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1744` |
| 0.1% | 1.1ms | 0.0% | 0us | `ensureFenVars` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1741` |
| 0.1% | 1.0ms | 0.0% | 367us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7032` |
| 0.1% | 1.0ms | 0.0% | 156us | `describeRule` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:30` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4032` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5649` |
| 0.1% | 1.0ms | 0.0% | 0us | `_tryLoad` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:51` |
| 0.1% | 1.0ms | 0.0% | 503us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:461` |
| 0.1% | 1.0ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7001` |
| 0.1% | 1.0ms | 0.0% | 0us | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:182` |
| 0.1% | 1.0ms | 0.0% | 351us | `isLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:168` |
| 0.1% | 1.0ms | 0.1% | 882us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:440` |
| 0.1% | 1.0ms | 0.0% | 0us | `checkLastSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:380` |
| 0.1% | 1.0ms | 0.0% | 0us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3033` |
| 0.1% | 1.0ms | 0.0% | 0us | `ke` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.1% | 1.0ms | 0.0% | 741us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6727` |
| 0.1% | 1.0ms | 0.0% | 326us | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5591` |
| 0.1% | 1.0ms | 0.0% | 0us | `loadBinding` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `propertyIsEnumerable` | `[native code]` |
| 0.1% | 1.0ms | 0.0% | 315us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:314` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5735` |
| 0.1% | 1.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:24` |
| 0.1% | 1.0ms | 0.0% | 309us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1237` |
| 0.1% | 1.0ms | 0.0% | 321us | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2910` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `test` | `[native code]` |
| 0.1% | 1.0ms | 0.0% | 702us | `_isSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4025` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4002` |
| 0.1% | 1.0ms | 0.0% | 0us | `BinaryExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:184` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5642` |
| 0.1% | 1.0ms | 0.0% | 338us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2470` |
| 0.1% | 1.0ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.1% | 997us | 0.0% | 142us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:323` |
| 0.1% | 989us | 0.0% | 157us | `getNameRange` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:456` |
| 0.1% | 987us | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6577` |
| 0.1% | 986us | 0.1% | 986us | `_lineStarts` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:611` |
| 0.1% | 986us | 0.1% | 986us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2191` |
| 0.1% | 985us | 0.0% | 466us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:232` |
| 0.1% | 982us | 0.0% | 316us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6872` |
| 0.1% | 981us | 0.0% | 647us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.1% | 981us | 0.0% | 303us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1328` |
| 0.1% | 978us | 0.0% | 821us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7322` |
| 0.1% | 973us | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:662` |
| 0.1% | 970us | 0.1% | 970us | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3546` |
| 0.1% | 969us | 0.1% | 969us | `Uint16Array` | `[native code]` |
| 0.1% | 968us | 0.0% | 655us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6610` |
| 0.1% | 966us | 0.0% | 578us | `_isSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4033` |
| 0.1% | 965us | 0.1% | 965us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1684` |
| 0.1% | 960us | 0.0% | 176us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:136` |
| 0.1% | 955us | 0.0% | 799us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5901` |
| 0.1% | 950us | 0.1% | 950us | `iterateDeclarations` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:61` |
| 0.1% | 944us | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2820` |
| 0.1% | 934us | 0.1% | 934us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6538` |
| 0.1% | 934us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` |
| 0.1% | 927us | 0.0% | 762us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:433` |
| 0.1% | 925us | 0.0% | 0us | `Program` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:304` |
| 0.1% | 925us | 0.0% | 0us | `requestSatisfyUtil` | `[native code]` |
| 0.1% | 925us | 0.0% | 0us | `requestInstantiate` | `[native code]` |
| 0.1% | 918us | 0.0% | 149us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2439` |
| 0.1% | 912us | 0.0% | 188us | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:662` |
| 0.1% | 895us | 0.0% | 0us | `isEvaluatedDuringInitialization` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:189` |
| 0.1% | 893us | 0.0% | 331us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:436` |
| 0.1% | 888us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` |
| 0.1% | 882us | 0.0% | 688us | `_deepMergeObjects` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:129` |
| 0.1% | 881us | 0.0% | 0us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6194` |
| 0.1% | 881us | 0.0% | 0us | `dlopen` | `bun:ffi:345` |
| 0.1% | 878us | 0.0% | 0us | `getTagNames` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:186` |
| 0.1% | 876us | 0.1% | 876us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6539` |
| 0.1% | 875us | 0.0% | 0us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2498` |
| 0.1% | 871us | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1711` |
| 0.0% | 870us | 0.0% | 699us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6726` |
| 0.0% | 869us | 0.0% | 869us | `runOnce` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:96` |
| 0.0% | 866us | 0.0% | 866us | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4823` |
| 0.0% | 866us | 0.0% | 866us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6817` |
| 0.0% | 865us | 0.0% | 865us | `defToVariableType` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:204` |
| 0.0% | 865us | 0.0% | 865us | `iterateDeclarations` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:68` |
| 0.0% | 864us | 0.0% | 171us | `_isSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4031` |
| 0.0% | 860us | 0.0% | 860us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2832` |
| 0.0% | 857us | 0.0% | 857us | `DataView` | `[native code]` |
| 0.0% | 857us | 0.0% | 857us | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:226` |
| 0.0% | 855us | 0.0% | 855us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6612` |
| 0.0% | 854us | 0.0% | 511us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:305` |
| 0.0% | 853us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:14` |
| 0.0% | 851us | 0.0% | 336us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5688` |
| 0.0% | 850us | 0.0% | 0us | `node:path` | `node:path:2` |
| 0.0% | 849us | 0.0% | 178us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:420` |
| 0.0% | 847us | 0.0% | 0us | `getFirstToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:984` |
| 0.0% | 846us | 0.0% | 846us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1994` |
| 0.0% | 844us | 0.0% | 844us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6969` |
| 0.0% | 839us | 0.0% | 839us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3991` |
| 0.0% | 839us | 0.0% | 697us | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:809` |
| 0.0% | 837us | 0.0% | 158us | `every` | `[native code]` |
| 0.0% | 836us | 0.0% | 166us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5665` |
| 0.0% | 835us | 0.0% | 0us | `checkLastSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:370` |
| 0.0% | 833us | 0.0% | 833us | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 832us | 0.0% | 689us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5249` |
| 0.0% | 832us | 0.0% | 832us | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 832us | 0.0% | 0us | `isInTdz` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:490` |
| 0.0% | 828us | 0.0% | 649us | `_deepMergeArrays` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:137` |
| 0.0% | 827us | 0.0% | 165us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1384` |
| 0.0% | 827us | 0.0% | 827us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5290` |
| 0.0% | 827us | 0.0% | 827us | `_applySchemaDefaults` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:169` |
| 0.0% | 826us | 0.0% | 0us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2282` |
| 0.0% | 826us | 0.0% | 161us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:338` |
| 0.0% | 825us | 0.0% | 825us | `getUint32` | `[native code]` |
| 0.0% | 824us | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1712` |
| 0.0% | 823us | 0.0% | 0us | `reportReferenceId` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:251` |
| 0.0% | 822us | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5899` |
| 0.0% | 819us | 0.0% | 673us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4205` |
| 0.0% | 816us | 0.0% | 643us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1330` |
| 0.0% | 812us | 0.0% | 496us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:423` |
| 0.0% | 811us | 0.0% | 647us | `_parseDisableDirectives` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7412` |
| 0.0% | 807us | 0.0% | 0us | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:651` |
| 0.0% | 795us | 0.0% | 312us | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5808` |
| 0.0% | 793us | 0.0% | 152us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:90` |
| 0.0% | 789us | 0.0% | 172us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4222` |
| 0.0% | 787us | 0.0% | 787us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2797` |
| 0.0% | 783us | 0.0% | 163us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1325` |
| 0.0% | 782us | 0.0% | 487us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:474` |
| 0.0% | 769us | 0.0% | 769us | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:865` |
| 0.0% | 766us | 0.0% | 0us | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1754` |
| 0.0% | 753us | 0.0% | 753us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1175` |
| 0.0% | 750us | 0.0% | 0us | `reportReferenceId` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:262` |
| 0.0% | 749us | 0.0% | 749us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6729` |
| 0.0% | 741us | 0.0% | 0us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5088` |
| 0.0% | 730us | 0.0% | 0us | `_getPlugin` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:60` |
| 0.0% | 728us | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2066` |
| 0.0% | 728us | 0.0% | 728us | `regExpMatchFast` | `[native code]` |
| 0.0% | 727us | 0.0% | 727us | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 727us | 0.0% | 0us | `isEvaluatedDuringInitialization` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:184` |
| 0.0% | 725us | 0.0% | 180us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` |
| 0.0% | 724us | 0.0% | 0us | `getDeclaredLocation` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:471` |
| 0.0% | 722us | 0.0% | 722us | `fetch` | `[native code]` |
| 0.0% | 722us | 0.0% | 0us | `requestFetch` | `[native code]` |
| 0.0% | 721us | 0.0% | 162us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1700` |
| 0.0% | 715us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:295` |
| 0.0% | 703us | 0.0% | 703us | `push` | `[native code]` |
| 0.0% | 703us | 0.0% | 138us | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2954` |
| 0.0% | 702us | 0.0% | 373us | `_compileAttrCheck` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5198` |
| 0.0% | 700us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:390` |
| 0.0% | 691us | 0.0% | 691us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2514` |
| 0.0% | 691us | 0.0% | 691us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6824` |
| 0.0% | 690us | 0.0% | 690us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 685us | 0.0% | 178us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:437` |
| 0.0% | 685us | 0.0% | 372us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:954` |
| 0.0% | 683us | 0.0% | 683us | `_makeSafeHandler` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3818` |
| 0.0% | 680us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:400` |
| 0.0% | 680us | 0.0% | 482us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1663` |
| 0.0% | 676us | 0.0% | 676us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3791` |
| 0.0% | 675us | 0.0% | 0us | `getIdentifierIfShouldBeConst` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:207` |
| 0.0% | 675us | 0.0% | 0us | `checkReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:212` |
| 0.0% | 671us | 0.0% | 0us | `internal:validators` | `internal:validators:2` |
| 0.0% | 670us | 0.0% | 670us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6411` |
| 0.0% | 670us | 0.0% | 145us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:405` |
| 0.0% | 670us | 0.0% | 498us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1274` |
| 0.0% | 667us | 0.0% | 333us | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5947` |
| 0.0% | 666us | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7092` |
| 0.0% | 661us | 0.0% | 521us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:352` |
| 0.0% | 660us | 0.0% | 660us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3999` |
| 0.0% | 656us | 0.0% | 0us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4993` |
| 0.0% | 655us | 0.0% | 0us | `shouldCheck` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:413` |
| 0.0% | 654us | 0.0% | 294us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2661` |
| 0.0% | 653us | 0.0% | 0us | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5100` |
| 0.0% | 652us | 0.0% | 184us | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5102` |
| 0.0% | 652us | 0.0% | 652us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5713` |
| 0.0% | 651us | 0.0% | 651us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 651us | 0.0% | 0us | `Program` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:295` |
| 0.0% | 650us | 0.0% | 0us | `MemberExpression[computed!=true] > Identifier.property` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:362` |
| 0.0% | 648us | 0.0% | 0us | `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:337` |
| 0.0% | 647us | 0.0% | 647us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6541` |
| 0.0% | 646us | 0.0% | 176us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4240` |
| 0.0% | 645us | 0.0% | 0us | `_expandUnion` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4042` |
| 0.0% | 645us | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2071` |
| 0.0% | 638us | 0.0% | 337us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:411` |
| 0.0% | 638us | 0.0% | 638us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:510` |
| 0.0% | 636us | 0.0% | 636us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7082` |
| 0.0% | 635us | 0.0% | 0us | `getArrayMethodName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:78` |
| 0.0% | 632us | 0.0% | 347us | `get left` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1756` |
| 0.0% | 631us | 0.0% | 0us | `_applySchemaDefaults` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:162` |
| 0.0% | 629us | 0.0% | 0us | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6048` |
| 0.0% | 624us | 0.0% | 624us | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2859` |
| 0.0% | 624us | 0.0% | 488us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5656` |
| 0.0% | 623us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:302` |
| 0.0% | 623us | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1718` |
| 0.0% | 619us | 0.0% | 619us | `_applySchemaDefaults` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:161` |
| 0.0% | 616us | 0.0% | 0us | `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:325` |
| 0.0% | 615us | 0.0% | 148us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:399` |
| 0.0% | 613us | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7361` |
| 0.0% | 610us | 0.0% | 610us | `/^_+\|_+$/gu` | `[native code]` |
| 0.0% | 607us | 0.0% | 467us | `getDestructuringHost` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:103` |
| 0.0% | 581us | 0.0% | 581us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 581us | 0.0% | 0us | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:654` |
| 0.0% | 579us | 0.0% | 579us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6621` |
| 0.0% | 574us | 0.0% | 574us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6757` |
| 0.0% | 574us | 0.0% | 574us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2319` |
| 0.0% | 566us | 0.0% | 566us | `newRegistryEntry` | `[native code]` |
| 0.0% | 566us | 0.0% | 0us | `ensureRegistered` | `[native code]` |
| 0.0% | 564us | 0.0% | 150us | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2945` |
| 0.0% | 562us | 0.0% | 562us | `get left` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1754` |
| 0.0% | 562us | 0.0% | 562us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7365` |
| 0.0% | 562us | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` |
| 0.0% | 559us | 0.0% | 559us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4133` |
| 0.0% | 559us | 0.0% | 195us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:306` |
| 0.0% | 558us | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:561` |
| 0.0% | 558us | 0.0% | 0us | `_getFfiSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:109` |
| 0.0% | 558us | 0.0% | 366us | `get right` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1789` |
| 0.0% | 557us | 0.0% | 0us | `_loadFromDisk` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:69` |
| 0.0% | 557us | 0.0% | 0us | `tryParse` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:126` |
| 0.0% | 556us | 0.0% | 189us | `getLocFromIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3359` |
| 0.0% | 553us | 0.0% | 553us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:76` |
| 0.0% | 552us | 0.0% | 0us | `isSpecificMemberAccess` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:384` |
| 0.0% | 552us | 0.0% | 185us | `onCodePathStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:405` |
| 0.0% | 540us | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 0.0% | 539us | 0.0% | 539us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1696` |
| 0.0% | 538us | 0.0% | 0us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4230` |
| 0.0% | 538us | 0.0% | 538us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4000` |
| 0.0% | 536us | 0.0% | 364us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:450` |
| 0.0% | 536us | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:208` |
| 0.0% | 536us | 0.0% | 536us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 535us | 0.0% | 181us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4197` |
| 0.0% | 535us | 0.0% | 166us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4031` |
| 0.0% | 533us | 0.0% | 533us | `iterateDeclarations` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:59` |
| 0.0% | 533us | 0.0% | 179us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:205` |
| 0.0% | 530us | 0.0% | 530us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3067` |
| 0.0% | 530us | 0.0% | 530us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 530us | 0.0% | 530us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4176` |
| 0.0% | 529us | 0.0% | 371us | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:798` |
| 0.0% | 529us | 0.0% | 529us | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:828` |
| 0.0% | 528us | 0.0% | 0us | `getAssignedMessageData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:306` |
| 0.0% | 527us | 0.0% | 189us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6758` |
| 0.0% | 527us | 0.0% | 527us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 525us | 0.0% | 525us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4176` |
| 0.0% | 525us | 0.0% | 0us | `getVariableDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:261` |
| 0.0% | 525us | 0.0% | 525us | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1067` |
| 0.0% | 525us | 0.0% | 525us | `get byteLength` | `[native code]` |
| 0.0% | 524us | 0.0% | 524us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6532` |
| 0.0% | 524us | 0.0% | 524us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6949` |
| 0.0% | 524us | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:824` |
| 0.0% | 522us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:404` |
| 0.0% | 522us | 0.0% | 0us | `isNullCheck` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:126` |
| 0.0% | 521us | 0.0% | 521us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1962` |
| 0.0% | 520us | 0.0% | 520us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6822` |
| 0.0% | 520us | 0.0% | 520us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7351` |
| 0.0% | 518us | 0.0% | 518us | `get mainToken` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1089` |
| 0.0% | 518us | 0.0% | 0us | `isEvaluatedDuringInitialization` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:197` |
| 0.0% | 517us | 0.0% | 0us | `getStaticPropertyName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:320` |
| 0.0% | 516us | 0.0% | 363us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6507` |
| 0.0% | 516us | 0.0% | 368us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4207` |
| 0.0% | 514us | 0.0% | 0us | `checkLastSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:382` |
| 0.0% | 513us | 0.0% | 513us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4034` |
| 0.0% | 512us | 0.0% | 512us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2774` |
| 0.0% | 512us | 0.0% | 512us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5114` |
| 0.0% | 511us | 0.0% | 191us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:408` |
| 0.0% | 510us | 0.0% | 158us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:440` |
| 0.0% | 510us | 0.0% | 510us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6412` |
| 0.0% | 509us | 0.0% | 160us | `segment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4250` |
| 0.0% | 509us | 0.0% | 0us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6479` |
| 0.0% | 509us | 0.0% | 168us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1929` |
| 0.0% | 509us | 0.0% | 509us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2494` |
| 0.0% | 508us | 0.0% | 508us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1548` |
| 0.0% | 508us | 0.0% | 171us | `_getTypeProto` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3976` |
| 0.0% | 507us | 0.0% | 507us | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4874` |
| 0.0% | 504us | 0.0% | 0us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` |
| 0.0% | 504us | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4208` |
| 0.0% | 504us | 0.0% | 180us | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2257` |
| 0.0% | 504us | 0.0% | 504us | `_makeBoundReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3802` |
| 0.0% | 503us | 0.0% | 0us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4226` |
| 0.0% | 502us | 0.0% | 186us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:428` |
| 0.0% | 502us | 0.0% | 185us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4188` |
| 0.0% | 501us | 0.0% | 152us | `checkGroup` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:426` |
| 0.0% | 501us | 0.0% | 0us | `internal:shared` | `internal:shared:2` |
| 0.0% | 500us | 0.0% | 310us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6814` |
| 0.0% | 497us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:401` |
| 0.0% | 497us | 0.0% | 0us | `getStaticStringValue` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:264` |
| 0.0% | 497us | 0.0% | 497us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7136` |
| 0.0% | 497us | 0.0% | 151us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:460` |
| 0.0% | 496us | 0.0% | 337us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:473` |
| 0.0% | 495us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:410` |
| 0.0% | 494us | 0.0% | 494us | `get start` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1092` |
| 0.0% | 494us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3` |
| 0.0% | 493us | 0.0% | 493us | `Map` | `[native code]` |
| 0.0% | 493us | 0.0% | 493us | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2907` |
| 0.0% | 493us | 0.0% | 179us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:479` |
| 0.0% | 491us | 0.0% | 325us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4195` |
| 0.0% | 491us | 0.0% | 491us | `mainToken` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1089` |
| 0.0% | 490us | 0.0% | 0us | `checkForBlock` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:132` |
| 0.0% | 489us | 0.0% | 154us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2636` |
| 0.0% | 489us | 0.0% | 489us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6558` |
| 0.0% | 489us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:414` |
| 0.0% | 488us | 0.0% | 0us | `getStaticPropertyName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:327` |
| 0.0% | 487us | 0.0% | 336us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4187` |
| 0.0% | 487us | 0.0% | 487us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1887` |
| 0.0% | 487us | 0.0% | 142us | `[Symbol.split]` | `[native code]` |
| 0.0% | 487us | 0.0% | 487us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:126` |
| 0.0% | 486us | 0.0% | 486us | `includes` | `[native code]` |
| 0.0% | 486us | 0.0% | 169us | `isNullCheck` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:125` |
| 0.0% | 480us | 0.0% | 340us | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3550` |
| 0.0% | 478us | 0.0% | 478us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6529` |
| 0.0% | 478us | 0.0% | 478us | `_getOrBuildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5441` |
| 0.0% | 471us | 0.0% | 471us | `isClassRefInClassDecorator` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:254` |
| 0.0% | 470us | 0.0% | 0us | `_dispatchSeg` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6108` |
| 0.0% | 469us | 0.0% | 0us | `isInsideOfStorableFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:630` |
| 0.0% | 468us | 0.0% | 468us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6460` |
| 0.0% | 464us | 0.0% | 141us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:451` |
| 0.0% | 463us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:3999` |
| 0.0% | 463us | 0.0% | 0us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4062` |
| 0.0% | 462us | 0.0% | 462us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3997` |
| 0.0% | 461us | 0.0% | 173us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3046` |
| 0.0% | 460us | 0.0% | 321us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4235` |
| 0.0% | 459us | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:430` |
| 0.0% | 454us | 0.0% | 0us | `getStaticPropertyName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:328` |
| 0.0% | 454us | 0.0% | 454us | `create` | `[native code]` |
| 0.0% | 448us | 0.0% | 288us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` |
| 0.0% | 443us | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1907` |
| 0.0% | 439us | 0.0% | 150us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1699` |
| 0.0% | 437us | 0.0% | 0us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4219` |
| 0.0% | 430us | 0.0% | 430us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3998` |
| 0.0% | 400us | 0.0% | 0us | `get kind` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2626` |
| 0.0% | 391us | 0.0% | 391us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7135` |
| 0.0% | 386us | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:211` |
| 0.0% | 386us | 0.0% | 386us | `getDestructuringHost` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:98` |
| 0.0% | 386us | 0.0% | 196us | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:511` |
| 0.0% | 384us | 0.0% | 384us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:332` |
| 0.0% | 382us | 0.0% | 0us | `getIdentifierIfShouldBeConst` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:221` |
| 0.0% | 382us | 0.0% | 187us | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:620` |
| 0.0% | 381us | 0.0% | 381us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6414` |
| 0.0% | 380us | 0.0% | 0us | `skipChainExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:343` |
| 0.0% | 380us | 0.0% | 0us | `isSpecificMemberAccess` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:378` |
| 0.0% | 379us | 0.0% | 379us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6634` |
| 0.0% | 379us | 0.0% | 379us | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1038` |
| 0.0% | 379us | 0.0% | 379us | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2864` |
| 0.0% | 378us | 0.0% | 187us | `codepath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4256` |
| 0.0% | 378us | 0.0% | 0us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6476` |
| 0.0% | 377us | 0.0% | 377us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4973` |
| 0.0% | 376us | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3758` |
| 0.0% | 376us | 0.0% | 0us | `getFunctionNameWithKind` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2180` |
| 0.0% | 375us | 0.0% | 375us | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1048` |
| 0.0% | 374us | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2060` |
| 0.0% | 374us | 0.0% | 374us | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.0% | 373us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn-jsx/index.js:3` |
| 0.0% | 373us | 0.0% | 0us | `get property` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1943` |
| 0.0% | 372us | 0.0% | 180us | `shouldCheck` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:393` |
| 0.0% | 371us | 0.0% | 371us | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 371us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:329` |
| 0.0% | 370us | 0.0% | 0us | `requestSatisfy` | `[native code]` |
| 0.0% | 370us | 0.0% | 370us | `_applySchemaDefaults` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:167` |
| 0.0% | 369us | 0.0% | 369us | `/^[A-Z][A-Za-z]*$/` | `[native code]` |
| 0.0% | 368us | 0.0% | 368us | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5802` |
| 0.0% | 367us | 0.0% | 0us | `checkGroup` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:412` |
| 0.0% | 367us | 0.0% | 187us | `iterateDeclarations` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:77` |
| 0.0% | 367us | 0.0% | 0us | `findUp` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:333` |
| 0.0% | 366us | 0.0% | 192us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4225` |
| 0.0% | 365us | 0.0% | 365us | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6780` |
| 0.0% | 365us | 0.0% | 365us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5087` |
| 0.0% | 364us | 0.0% | 364us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5752` |
| 0.0% | 362us | 0.0% | 0us | `isInsideOfStorableFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:634` |
| 0.0% | 361us | 0.0% | 194us | `runOnce` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:90` |
| 0.0% | 360us | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1733` |
| 0.0% | 359us | 0.0% | 359us | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2331` |
| 0.0% | 359us | 0.0% | 359us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4037` |
| 0.0% | 357us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js:133` |
| 0.0% | 357us | 0.0% | 357us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` |
| 0.0% | 357us | 0.0% | 357us | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 357us | 0.0% | 357us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 356us | 0.0% | 356us | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 356us | 0.0% | 0us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4200` |
| 0.0% | 356us | 0.0% | 194us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:68` |
| 0.0% | 356us | 0.0% | 0us | `getIdentifierIfShouldBeConst` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:237` |
| 0.0% | 356us | 0.0% | 203us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4241` |
| 0.0% | 355us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:430` |
| 0.0% | 355us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:12` |
| 0.0% | 355us | 0.0% | 355us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1205` |
| 0.0% | 354us | 0.0% | 162us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 0.0% | 353us | 0.0% | 353us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1596` |
| 0.0% | 353us | 0.0% | 191us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6506` |
| 0.0% | 352us | 0.0% | 0us | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:494` |
| 0.0% | 352us | 0.0% | 352us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6744` |
| 0.0% | 352us | 0.0% | 174us | `getFunctionNameWithKind` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2181` |
| 0.0% | 351us | 0.0% | 351us | `slotTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5793` |
| 0.0% | 350us | 0.0% | 350us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3790` |
| 0.0% | 349us | 0.0% | 349us | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4835` |
| 0.0% | 349us | 0.0% | 349us | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1817` |
| 0.0% | 347us | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:414` |
| 0.0% | 347us | 0.0% | 187us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4210` |
| 0.0% | 347us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:416` |
| 0.0% | 346us | 0.0% | 346us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5746` |
| 0.0% | 346us | 0.0% | 346us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:930` |
| 0.0% | 346us | 0.0% | 171us | `getIdentifierIfShouldBeConst` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:218` |
| 0.0% | 345us | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1625` |
| 0.0% | 344us | 0.0% | 0us | `equalsToOriginalName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:177` |
| 0.0% | 344us | 0.0% | 344us | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1829` |
| 0.0% | 344us | 0.0% | 344us | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5809` |
| 0.0% | 343us | 0.0% | 343us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:961` |
| 0.0% | 343us | 0.0% | 0us | `isAssignmentTarget` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:138` |
| 0.0% | 343us | 0.0% | 343us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4198` |
| 0.0% | 342us | 0.0% | 0us | `ObjectExpression > Property[computed!=true] > Identifier.key,MethodDefinition[computed!=true] > Identifier.key,PropertyDefinition[computed!=true] > Identifier.key,MethodDefinition > PrivateIdentifier.key,PropertyDefinition > PrivateIdentifier.key` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:357` |
| 0.0% | 342us | 0.0% | 150us | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2259` |
| 0.0% | 341us | 0.0% | 341us | `_applySchemaDefaults` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:165` |
| 0.0% | 340us | 0.0% | 181us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3749` |
| 0.0% | 340us | 0.0% | 340us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6768` |
| 0.0% | 340us | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6630` |
| 0.0% | 340us | 0.0% | 340us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5917` |
| 0.0% | 340us | 0.0% | 340us | `RuleSkipSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4776` |
| 0.0% | 339us | 0.0% | 186us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5062` |
| 0.0% | 338us | 0.0% | 0us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4202` |
| 0.0% | 338us | 0.0% | 0us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2541` |
| 0.0% | 338us | 0.0% | 338us | `ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1847` |
| 0.0% | 338us | 0.0% | 338us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 338us | 0.0% | 161us | `get local` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3477` |
| 0.0% | 338us | 0.0% | 0us | `getDefinedMessageData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:278` |
| 0.0% | 337us | 0.0% | 150us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:313` |
| 0.0% | 337us | 0.0% | 337us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2326` |
| 0.0% | 337us | 0.0% | 0us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6504` |
| 0.0% | 337us | 0.0% | 0us | `getDefinedMessageData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:279` |
| 0.0% | 336us | 0.0% | 336us | `_expandUnion` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4043` |
| 0.0% | 336us | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:162` |
| 0.0% | 335us | 0.0% | 179us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:319` |
| 0.0% | 335us | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:152` |
| 0.0% | 335us | 0.0% | 145us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5048` |
| 0.0% | 335us | 0.0% | 138us | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4857` |
| 0.0% | 335us | 0.0% | 174us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` |
| 0.0% | 334us | 0.0% | 334us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6601` |
| 0.0% | 334us | 0.0% | 0us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4212` |
| 0.0% | 334us | 0.0% | 334us | `_makeSafeHandler` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3829` |
| 0.0% | 334us | 0.0% | 334us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6099` |
| 0.0% | 333us | 0.0% | 333us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:84` |
| 0.0% | 332us | 0.0% | 332us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:142` |
| 0.0% | 331us | 0.0% | 331us | `ensureBufferBytes` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:53` |
| 0.0% | 331us | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1482` |
| 0.0% | 331us | 0.0% | 0us | `getUpperFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:134` |
| 0.0% | 331us | 0.0% | 0us | `isFunctionNameInitializerException` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:438` |
| 0.0% | 331us | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1527` |
| 0.0% | 330us | 0.0% | 330us | `slotTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5792` |
| 0.0% | 330us | 0.0% | 330us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3734` |
| 0.0% | 330us | 0.0% | 0us | `initialSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4343` |
| 0.0% | 329us | 0.0% | 142us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2057` |
| 0.0% | 329us | 0.0% | 0us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4991` |
| 0.0% | 327us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:517` |
| 0.0% | 327us | 0.0% | 327us | `_ensureTagCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5490` |
| 0.0% | 326us | 0.0% | 326us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1957` |
| 0.0% | 324us | 0.0% | 0us | `isModifyingProp` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:159` |
| 0.0% | 324us | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1719` |
| 0.0% | 324us | 0.0% | 324us | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1007` |
| 0.0% | 323us | 0.0% | 144us | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3614` |
| 0.0% | 322us | 0.0% | 322us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2198` |
| 0.0% | 321us | 0.0% | 145us | `getStaticStringValue` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:263` |
| 0.0% | 320us | 0.0% | 0us | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5101` |
| 0.0% | 320us | 0.0% | 320us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 319us | 0.0% | 0us | `shouldCheck` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:392` |
| 0.0% | 319us | 0.0% | 0us | `MemberExpression[computed!=true] > Identifier.property` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:363` |
| 0.0% | 319us | 0.0% | 0us | `getIdentifierIfShouldBeConst` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:223` |
| 0.0% | 319us | 0.0% | 177us | `referenceContainsTypeQuery` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:227` |
| 0.0% | 318us | 0.0% | 318us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1903` |
| 0.0% | 318us | 0.0% | 0us | `groupByDestructuring` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:310` |
| 0.0% | 318us | 0.0% | 318us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2317` |
| 0.0% | 318us | 0.0% | 0us | `existsSync` | `node:fs:273` |
| 0.0% | 318us | 0.0% | 318us | `existsSync` | `[native code]` |
| 0.0% | 317us | 0.0% | 317us | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3547` |
| 0.0% | 316us | 0.0% | 0us | `equalsToOriginalName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:175` |
| 0.0% | 315us | 0.0% | 171us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5285` |
| 0.0% | 315us | 0.0% | 315us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5716` |
| 0.0% | 314us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:432` |
| 0.0% | 314us | 0.0% | 314us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4541` |
| 0.0% | 313us | 0.0% | 0us | `getIdentifierIfShouldBeConst` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:261` |
| 0.0% | 313us | 0.0% | 313us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7307` |
| 0.0% | 313us | 0.0% | 313us | `regExpSplitFast` | `[native code]` |
| 0.0% | 313us | 0.0% | 313us | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2879` |
| 0.0% | 312us | 0.0% | 169us | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5031` |
| 0.0% | 311us | 0.0% | 311us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 311us | 0.0% | 0us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4192` |
| 0.0% | 310us | 0.0% | 145us | `isImportAttributeKey` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:1426` |
| 0.0% | 310us | 0.0% | 310us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 309us | 0.0% | 309us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5258` |
| 0.0% | 308us | 0.0% | 308us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2065` |
| 0.0% | 304us | 0.0% | 304us | `checkGroup` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:438` |
| 0.0% | 303us | 0.0% | 303us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 303us | 0.0% | 303us | `RegExp` | `[native code]` |
| 0.0% | 300us | 0.0% | 0us | `buildUnicodeData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:3986` |
| 0.0% | 300us | 0.0% | 0us | `wordsRegexp` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:285` |
| 0.0% | 300us | 0.0% | 300us | `/\[[^\]]*\]/g` | `[native code]` |
| 0.0% | 299us | 0.0% | 0us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5051` |
| 0.0% | 294us | 0.0% | 186us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6946` |
| 0.0% | 293us | 0.0% | 293us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 293us | 0.0% | 293us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5650` |
| 0.0% | 290us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:435` |
| 0.0% | 289us | 0.0% | 289us | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:664` |
| 0.0% | 288us | 0.0% | 288us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 288us | 0.0% | 288us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3066` |
| 0.0% | 285us | 0.0% | 285us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:682` |
| 0.0% | 285us | 0.0% | 0us | `isTypeOfBinary` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:100` |
| 0.0% | 285us | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:151` |
| 0.0% | 282us | 0.0% | 282us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6641` |
| 0.0% | 281us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` |
| 0.0% | 279us | 0.0% | 279us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:159` |
| 0.0% | 212us | 0.0% | 212us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:641` |
| 0.0% | 211us | 0.0% | 211us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:479` |
| 0.0% | 204us | 0.0% | 204us | `keys` | `[native code]` |
| 0.0% | 204us | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4231` |
| 0.0% | 202us | 0.0% | 202us | `isInitPatternNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:277` |
| 0.0% | 202us | 0.0% | 202us | `/^(?:Arrow)?FunctionExpression$/u` | `[native code]` |
| 0.0% | 201us | 0.0% | 201us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6589` |
| 0.0% | 200us | 0.0% | 200us | `safeHandler` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3820` |
| 0.0% | 199us | 0.0% | 199us | `uncurryThis` | `internal:primordials:20` |
| 0.0% | 199us | 0.0% | 0us | `internal:primordials` | `internal:primordials:70` |
| 0.0% | 198us | 0.0% | 198us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5694` |
| 0.0% | 198us | 0.0% | 198us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6845` |
| 0.0% | 198us | 0.0% | 198us | `checkText` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js` |
| 0.0% | 198us | 0.0% | 198us | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 197us | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:653` |
| 0.0% | 197us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:466` |
| 0.0% | 197us | 0.0% | 197us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4179` |
| 0.0% | 197us | 0.0% | 197us | `_getPlugin` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:59` |
| 0.0% | 196us | 0.0% | 196us | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2269` |
| 0.0% | 196us | 0.0% | 196us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:277` |
| 0.0% | 196us | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:555` |
| 0.0% | 196us | 0.0% | 196us | `isInitPatternNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:318` |
| 0.0% | 196us | 0.0% | 0us | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2979` |
| 0.0% | 195us | 0.0% | 0us | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:672` |
| 0.0% | 195us | 0.0% | 195us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:221` |
| 0.0% | 195us | 0.0% | 0us | `checkForBlock` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:139` |
| 0.0% | 195us | 0.0% | 0us | `isGlobalAugmentation` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:136` |
| 0.0% | 195us | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4237` |
| 0.0% | 195us | 0.0% | 195us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:637` |
| 0.0% | 194us | 0.0% | 194us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2099` |
| 0.0% | 194us | 0.0% | 194us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:462` |
| 0.0% | 194us | 0.0% | 194us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6449` |
| 0.0% | 194us | 0.0% | 194us | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3623` |
| 0.0% | 194us | 0.0% | 194us | `isTypeValueShadow` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js` |
| 0.0% | 194us | 0.0% | 194us | `extraMethodData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:694` |
| 0.0% | 194us | 0.0% | 194us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1700` |
| 0.0% | 194us | 0.0% | 194us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:415` |
| 0.0% | 194us | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1474` |
| 0.0% | 194us | 0.0% | 0us | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:657` |
| 0.0% | 194us | 0.0% | 194us | `_deepMergeObjects` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:122` |
| 0.0% | 193us | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:400` |
| 0.0% | 193us | 0.0% | 193us | `isImportAttributeKey` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:1423` |
| 0.0% | 193us | 0.0% | 0us | `BinaryExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:196` |
| 0.0% | 193us | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:654` |
| 0.0% | 193us | 0.0% | 0us | `getFunctionNameWithKind` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2110` |
| 0.0% | 193us | 0.0% | 193us | `node:fs/promises` | `node:fs/promises:175` |
| 0.0% | 193us | 0.0% | 193us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js` |
| 0.0% | 193us | 0.0% | 193us | `_tryLoad` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js` |
| 0.0% | 193us | 0.0% | 0us | `get right` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1788` |
| 0.0% | 193us | 0.0% | 193us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4227` |
| 0.0% | 193us | 0.0% | 0us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5050` |
| 0.0% | 193us | 0.0% | 193us | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3620` |
| 0.0% | 193us | 0.0% | 193us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 193us | 0.0% | 193us | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3604` |
| 0.0% | 193us | 0.0% | 193us | `_getTypeProto` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3969` |
| 0.0% | 193us | 0.0% | 0us | `areLiteralsAndSameType` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:113` |
| 0.0% | 193us | 0.0% | 193us | `getOwnPropertyDescriptors` | `[native code]` |
| 0.0% | 193us | 0.0% | 193us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js` |
| 0.0% | 192us | 0.0% | 0us | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:659` |
| 0.0% | 192us | 0.0% | 0us | `FFIBuilder` | `bun:ffi:283` |
| 0.0% | 192us | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4259` |
| 0.0% | 192us | 0.0% | 192us | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5931` |
| 0.0% | 192us | 0.0% | 0us | `isGenericOfAStaticMethodShadow` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:220` |
| 0.0% | 192us | 0.0% | 192us | `/[\s\[>~+.(]/` | `[native code]` |
| 0.0% | 192us | 0.0% | 192us | `isTypeParameterOfStaticMethod` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:206` |
| 0.0% | 192us | 0.0% | 192us | `Function` | `[native code]` |
| 0.0% | 192us | 0.0% | 0us | `dlopen` | `bun:ffi:351` |
| 0.0% | 191us | 0.0% | 191us | `hasMemberExpressionAssignment` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:125` |
| 0.0% | 191us | 0.0% | 191us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3884` |
| 0.0% | 191us | 0.0% | 191us | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 191us | 0.0% | 191us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6450` |
| 0.0% | 191us | 0.0% | 0us | `ImportDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:379` |
| 0.0% | 191us | 0.0% | 191us | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4329` |
| 0.0% | 191us | 0.0% | 0us | `node:fs` | `node:fs:303` |
| 0.0% | 191us | 0.0% | 191us | `get imported` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3501` |
| 0.0% | 191us | 0.0% | 0us | `internal:promisify` | `internal:promisify:53` |
| 0.0% | 191us | 0.0% | 191us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3759` |
| 0.0% | 191us | 0.0% | 191us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6965` |
| 0.0% | 191us | 0.0% | 191us | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2973` |
| 0.0% | 191us | 0.0% | 0us | `equalsToOriginalName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:186` |
| 0.0% | 191us | 0.0% | 0us | `isModifyingProp` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:134` |
| 0.0% | 190us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:413` |
| 0.0% | 190us | 0.0% | 190us | `isImportAttributeKey` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:1440` |
| 0.0% | 190us | 0.0% | 0us | `ObjectExpression > Property[computed!=true] > Identifier.key,MethodDefinition[computed!=true] > Identifier.key,PropertyDefinition[computed!=true] > Identifier.key,MethodDefinition > PrivateIdentifier.key,PropertyDefinition > PrivateIdentifier.key` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:352` |
| 0.0% | 190us | 0.0% | 0us | `get arguments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1890` |
| 0.0% | 190us | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.0% | 190us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:485` |
| 0.0% | 190us | 0.0% | 190us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:656` |
| 0.0% | 190us | 0.0% | 0us | `BinaryExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:188` |
| 0.0% | 190us | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6098` |
| 0.0% | 190us | 0.0% | 190us | `isModifyingProp` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js` |
| 0.0% | 190us | 0.0% | 190us | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 190us | 0.0% | 0us | `getArrayMethodName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:126` |
| 0.0% | 189us | 0.0% | 0us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5013` |
| 0.0% | 189us | 0.0% | 189us | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:815` |
| 0.0% | 189us | 0.0% | 189us | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6810` |
| 0.0% | 189us | 0.0% | 189us | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4655` |
| 0.0% | 189us | 0.0% | 189us | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4649` |
| 0.0% | 189us | 0.0% | 189us | `shouldCheck` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:399` |
| 0.0% | 189us | 0.0% | 189us | `isModifyingProp` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:99` |
| 0.0% | 189us | 0.0% | 189us | `get callee` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1873` |
| 0.0% | 189us | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1711` |
| 0.0% | 188us | 0.0% | 188us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 188us | 0.0% | 188us | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4668` |
| 0.0% | 188us | 0.0% | 188us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` |
| 0.0% | 188us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:12` |
| 0.0% | 187us | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:872` |
| 0.0% | 187us | 0.0% | 187us | `isFunctionNameInitializerException` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:402` |
| 0.0% | 187us | 0.0% | 0us | `getUsedIgnoredMessageData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:331` |
| 0.0% | 187us | 0.0% | 187us | `be` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 187us | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6579` |
| 0.0% | 187us | 0.0% | 0us | `getIdentifierIfShouldBeConst` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:211` |
| 0.0% | 186us | 0.0% | 186us | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2933` |
| 0.0% | 186us | 0.0% | 186us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6625` |
| 0.0% | 186us | 0.0% | 186us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6255` |
| 0.0% | 186us | 0.0% | 186us | `loadBinding` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:10` |
| 0.0% | 186us | 0.0% | 186us | `checkLastSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:320` |
| 0.0% | 186us | 0.0% | 186us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6201` |
| 0.0% | 186us | 0.0% | 186us | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6358` |
| 0.0% | 186us | 0.0% | 0us | `_ensureTagCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5504` |
| 0.0% | 185us | 0.0% | 185us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5292` |
| 0.0% | 185us | 0.0% | 0us | `checkLastSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:388` |
| 0.0% | 185us | 0.0% | 185us | `fullMethodName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:55` |
| 0.0% | 185us | 0.0% | 185us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:291` |
| 0.0% | 185us | 0.0% | 185us | `isAllowed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js` |
| 0.0% | 185us | 0.0% | 185us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:331` |
| 0.0% | 185us | 0.0% | 185us | `isThisParam` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:147` |
| 0.0% | 185us | 0.0% | 0us | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:636` |
| 0.0% | 184us | 0.0% | 184us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1340` |
| 0.0% | 184us | 0.0% | 184us | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` |
| 0.0% | 184us | 0.0% | 0us | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5566` |
| 0.0% | 184us | 0.0% | 184us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4218` |
| 0.0% | 184us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:232` |
| 0.0% | 184us | 0.0% | 184us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7070` |
| 0.0% | 184us | 0.0% | 184us | `isClassRefInClassDecorator` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js` |
| 0.0% | 184us | 0.0% | 0us | `getIdentifierIfShouldBeConst` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:232` |
| 0.0% | 183us | 0.0% | 183us | `isInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:231` |
| 0.0% | 183us | 0.0% | 183us | `Proxy` | `[native code]` |
| 0.0% | 183us | 0.0% | 183us | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3885` |
| 0.0% | 183us | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1677` |
| 0.0% | 183us | 0.0% | 0us | `isInitPatternNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:304` |
| 0.0% | 183us | 0.0% | 183us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4256` |
| 0.0% | 183us | 0.0% | 183us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4250` |
| 0.0% | 183us | 0.0% | 183us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1673` |
| 0.0% | 183us | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1980` |
| 0.0% | 183us | 0.0% | 183us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3788` |
| 0.0% | 183us | 0.0% | 183us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4003` |
| 0.0% | 182us | 0.0% | 182us | `_dispatchSeg` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6111` |
| 0.0% | 182us | 0.0% | 0us | `getNameLocationInGlobalDirectiveComment` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2635` |
| 0.0% | 182us | 0.0% | 0us | `getIdentifierIfShouldBeConst` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:213` |
| 0.0% | 182us | 0.0% | 182us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1200` |
| 0.0% | 182us | 0.0% | 182us | `checkReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:190` |
| 0.0% | 182us | 0.0% | 182us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1208` |
| 0.0% | 182us | 0.0% | 182us | `getFunctionHeadLoc` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2312` |
| 0.0% | 182us | 0.0% | 182us | `getFirstTokenBetween` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 182us | 0.0% | 182us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/escape-string-regexp/index.js` |
| 0.0% | 182us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:29` |
| 0.0% | 181us | 0.0% | 181us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:74` |
| 0.0% | 181us | 0.0% | 181us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1603` |
| 0.0% | 181us | 0.0% | 181us | `get local` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 181us | 0.0% | 0us | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3337` |
| 0.0% | 181us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:436` |
| 0.0% | 181us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:20` |
| 0.0% | 180us | 0.0% | 0us | `getNameLocationInGlobalDirectiveComment` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2646` |
| 0.0% | 180us | 0.0% | 180us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1451` |
| 0.0% | 180us | 0.0% | 180us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2768` |
| 0.0% | 180us | 0.0% | 0us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2727` |
| 0.0% | 180us | 0.0% | 180us | `getIdentifierIfShouldBeConst` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:233` |
| 0.0% | 180us | 0.0% | 180us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:655` |
| 0.0% | 180us | 0.0% | 0us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4218` |
| 0.0% | 180us | 0.0% | 0us | `getStaticStringValue` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:246` |
| 0.0% | 180us | 0.0% | 180us | `cloneObject` | `[native code]` |
| 0.0% | 180us | 0.0% | 180us | `checkReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:201` |
| 0.0% | 179us | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1483` |
| 0.0% | 179us | 0.0% | 0us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3073` |
| 0.0% | 179us | 0.0% | 179us | `hideFromStack` | `internal:shared:19` |
| 0.0% | 179us | 0.0% | 0us | `internal:validators` | `internal:validators:47` |
| 0.0% | 179us | 0.0% | 179us | `CfgSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 179us | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` |
| 0.0% | 179us | 0.0% | 179us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3744` |
| 0.0% | 179us | 0.0% | 179us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` |
| 0.0% | 179us | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` |
| 0.0% | 179us | 0.0% | 179us | `fix` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:155` |
| 0.0% | 179us | 0.0% | 0us | `get initialSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4343` |
| 0.0% | 179us | 0.0% | 0us | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:455` |
| 0.0% | 178us | 0.0% | 178us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6715` |
| 0.0% | 178us | 0.0% | 178us | `/^:[a-z-]+\s*/` | `[native code]` |
| 0.0% | 178us | 0.0% | 0us | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5600` |
| 0.0% | 178us | 0.0% | 178us | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 178us | 0.0% | 178us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7058` |
| 0.0% | 178us | 0.0% | 0us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5291` |
| 0.0% | 178us | 0.0% | 178us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4984` |
| 0.0% | 178us | 0.0% | 178us | `getNameLocationInGlobalDirectiveComment` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2634` |
| 0.0% | 178us | 0.0% | 178us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1614` |
| 0.0% | 178us | 0.0% | 178us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2665` |
| 0.0% | 177us | 0.0% | 177us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:434` |
| 0.0% | 177us | 0.0% | 0us | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2909` |
| 0.0% | 177us | 0.0% | 177us | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1778` |
| 0.0% | 177us | 0.0% | 177us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5247` |
| 0.0% | 176us | 0.0% | 0us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3040` |
| 0.0% | 176us | 0.0% | 0us | `getAssignedMessageData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:305` |
| 0.0% | 176us | 0.0% | 176us | `getArrayMethodName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:138` |
| 0.0% | 176us | 0.0% | 176us | `get quasis` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3068` |
| 0.0% | 176us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:71` |
| 0.0% | 176us | 0.0% | 176us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 176us | 0.0% | 176us | `getVariableDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:235` |
| 0.0% | 176us | 0.0% | 176us | `getTokenAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1221` |
| 0.0% | 176us | 0.0% | 176us | `getFunctionHeadLoc` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2285` |
| 0.0% | 175us | 0.0% | 0us | `get properties` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3090` |
| 0.0% | 175us | 0.0% | 175us | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5976` |
| 0.0% | 175us | 0.0% | 175us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2273` |
| 0.0% | 175us | 0.0% | 0us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2709` |
| 0.0% | 175us | 0.0% | 175us | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 175us | 0.0% | 175us | `_nodeStartPos` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:888` |
| 0.0% | 174us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:415` |
| 0.0% | 174us | 0.0% | 174us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2822` |
| 0.0% | 174us | 0.0% | 174us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 174us | 0.0% | 0us | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:490` |
| 0.0% | 174us | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:551` |
| 0.0% | 174us | 0.0% | 174us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6816` |
| 0.0% | 174us | 0.0% | 0us | `findUp` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:339` |
| 0.0% | 174us | 0.0% | 174us | `hasObservableSideEffectsForRegExpSplit` | `[native code]` |
| 0.0% | 174us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:282` |
| 0.0% | 173us | 0.0% | 173us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:387` |
| 0.0% | 173us | 0.0% | 173us | `Program` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:290` |
| 0.0% | 173us | 0.0% | 173us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2378` |
| 0.0% | 173us | 0.0% | 173us | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4868` |
| 0.0% | 173us | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:819` |
| 0.0% | 173us | 0.0% | 0us | `ensureBufferBytes` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:58` |
| 0.0% | 173us | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` |
| 0.0% | 173us | 0.0% | 173us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:123` |
| 0.0% | 173us | 0.0% | 0us | `ImportDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:372` |
| 0.0% | 173us | 0.0% | 173us | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 173us | 0.0% | 173us | `_loadFromDisk` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js` |
| 0.0% | 173us | 0.0% | 173us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:488` |
| 0.0% | 173us | 0.0% | 173us | `isModifyingProp` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:127` |
| 0.0% | 172us | 0.0% | 172us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2614` |
| 0.0% | 172us | 0.0% | 172us | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 172us | 0.0% | 172us | `isOuterVariableInDestructing` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:79` |
| 0.0% | 172us | 0.0% | 172us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6752` |
| 0.0% | 172us | 0.0% | 172us | `[Symbol.iterator]` | `[native code]` |
| 0.0% | 172us | 0.0% | 172us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1238` |
| 0.0% | 172us | 0.0% | 172us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4030` |
| 0.0% | 172us | 0.0% | 172us | `/^(?:DoWhile\|For\|ForIn\|ForOf\|While)Statement$/u` | `[native code]` |
| 0.0% | 171us | 0.0% | 171us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 171us | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7164` |
| 0.0% | 171us | 0.0% | 0us | `node:os` | `node:os:110` |
| 0.0% | 171us | 0.0% | 171us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:383` |
| 0.0% | 171us | 0.0% | 171us | `bound` | `node:os:107` |
| 0.0% | 171us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:345` |
| 0.0% | 171us | 0.0% | 171us | `speciesConstructor` | `[native code]` |
| 0.0% | 171us | 0.0% | 0us | `node:child_process` | `node:child_process:2` |
| 0.0% | 171us | 0.0% | 171us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4033` |
| 0.0% | 171us | 0.0% | 171us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1380` |
| 0.0% | 171us | 0.0% | 171us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:80` |
| 0.0% | 170us | 0.0% | 0us | `isNullLiteral` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:205` |
| 0.0% | 170us | 0.0% | 170us | `get mainToken` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 170us | 0.0% | 170us | `CfgSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4289` |
| 0.0% | 170us | 0.0% | 170us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6445` |
| 0.0% | 170us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:431` |
| 0.0% | 170us | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:202` |
| 0.0% | 170us | 0.0% | 170us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:51` |
| 0.0% | 169us | 0.0% | 169us | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5032` |
| 0.0% | 169us | 0.0% | 169us | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:743` |
| 0.0% | 169us | 0.0% | 0us | `(anonymous)` | `node:child_process:777` |
| 0.0% | 169us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:15` |
| 0.0% | 169us | 0.0% | 169us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5653` |
| 0.0% | 169us | 0.0% | 169us | `_computeMinTok` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:529` |
| 0.0% | 169us | 0.0% | 169us | `get property` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1946` |
| 0.0% | 169us | 0.0% | 169us | `getArrayMethodName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:72` |
| 0.0% | 169us | 0.0% | 0us | `node:child_process` | `node:child_process:473` |
| 0.0% | 169us | 0.0% | 169us | `_rawTokenText` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:781` |
| 0.0% | 169us | 0.0% | 0us | `(anonymous)` | `node:child_process:831` |
| 0.0% | 169us | 0.0% | 169us | `_deepMergeObjects` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:127` |
| 0.0% | 169us | 0.0% | 0us | `getFirstToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:945` |
| 0.0% | 168us | 0.0% | 168us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4237` |
| 0.0% | 168us | 0.0% | 168us | `_isStatementTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:77` |
| 0.0% | 168us | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:234` |
| 0.0% | 168us | 0.0% | 168us | `shouldCheck` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:369` |
| 0.0% | 168us | 0.0% | 168us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4229` |
| 0.0% | 168us | 0.0% | 0us | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3574` |
| 0.0% | 168us | 0.0% | 168us | `ensureRefsThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 168us | 0.0% | 0us | `isSpecificId` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:365` |
| 0.0% | 167us | 0.0% | 167us | `safeHandler` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 167us | 0.0% | 167us | `getAssignedMessageData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:309` |
| 0.0% | 167us | 0.0% | 0us | `[Symbol.match]` | `[native code]` |
| 0.0% | 167us | 0.0% | 167us | `a` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 167us | 0.0% | 167us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2175` |
| 0.0% | 167us | 0.0% | 167us | `hasObservableSideEffectsForRegExpMatch` | `[native code]` |
| 0.0% | 167us | 0.0% | 0us | `isFromSeparateExecutionContext` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:138` |
| 0.0% | 167us | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1703` |
| 0.0% | 167us | 0.0% | 167us | `isClassStaticInitializerScope` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:88` |
| 0.0% | 167us | 0.0% | 167us | `get left` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1766` |
| 0.0% | 167us | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6588` |
| 0.0% | 167us | 0.0% | 167us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:289` |
| 0.0% | 167us | 0.0% | 0us | `isEvaluatedDuringInitialization` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:168` |
| 0.0% | 166us | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1533` |
| 0.0% | 166us | 0.0% | 166us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:452` |
| 0.0% | 166us | 0.0% | 166us | `kw` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 166us | 0.0% | 166us | `_cookTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:28` |
| 0.0% | 166us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:208` |
| 0.0% | 166us | 0.0% | 166us | `runOnce` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:84` |
| 0.0% | 166us | 0.0% | 0us | `getFirstToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:949` |
| 0.0% | 166us | 0.0% | 166us | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:773` |
| 0.0% | 166us | 0.0% | 166us | `iterateDeclarations` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js` |
| 0.0% | 166us | 0.0% | 0us | `_tryLoad` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:46` |
| 0.0% | 166us | 0.0% | 166us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2803` |
| 0.0% | 166us | 0.0% | 166us | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4665` |
| 0.0% | 165us | 0.0% | 0us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1528` |
| 0.0% | 165us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:134` |
| 0.0% | 165us | 0.0% | 165us | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5587` |
| 0.0% | 165us | 0.0% | 165us | `replaceTextRange` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/fix-tracker.js:97` |
| 0.0% | 165us | 0.0% | 0us | `accessPath` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5206` |
| 0.0% | 165us | 0.0% | 165us | `isExported` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:358` |
| 0.0% | 165us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5222` |
| 0.0% | 165us | 0.0% | 0us | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:633` |
| 0.0% | 165us | 0.0% | 165us | `get computed` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1978` |
| 0.0% | 165us | 0.0% | 165us | `_scopeForNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:847` |
| 0.0% | 165us | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1702` |
| 0.0% | 165us | 0.0% | 165us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6505` |
| 0.0% | 165us | 0.0% | 0us | `canBecomeVariableDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:52` |
| 0.0% | 165us | 0.0% | 165us | `extraArrowData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:676` |
| 0.0% | 165us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5065` |
| 0.0% | 165us | 0.0% | 165us | `replaceTextRange` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 165us | 0.0% | 0us | `isDuplicatedEnumNameVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:552` |
| 0.0% | 165us | 0.0% | 165us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6825` |
| 0.0% | 164us | 0.0% | 164us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 164us | 0.0% | 164us | `ge` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 164us | 0.0% | 0us | `equalsToOriginalName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:169` |
| 0.0% | 164us | 0.0% | 164us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5903` |
| 0.0% | 164us | 0.0% | 164us | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2341` |
| 0.0% | 164us | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7009` |
| 0.0% | 164us | 0.0% | 0us | `Ee` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 163us | 0.0% | 163us | `get flags` | `[native code]` |
| 0.0% | 163us | 0.0% | 163us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4071` |
| 0.0% | 163us | 0.0% | 163us | `buildUnicodeData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 163us | 0.0% | 163us | `applyDisableDirectives` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7441` |
| 0.0% | 163us | 0.0% | 163us | `resolve` | `[native code]` |
| 0.0% | 163us | 0.0% | 163us | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:649` |
| 0.0% | 163us | 0.0% | 163us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4056` |
| 0.0% | 162us | 0.0% | 0us | `_ensureTagCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5519` |
| 0.0% | 162us | 0.0% | 162us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2190` |
| 0.0% | 162us | 0.0% | 0us | `checkReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:205` |
| 0.0% | 162us | 0.0% | 162us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2685` |
| 0.0% | 162us | 0.0% | 162us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2183` |
| 0.0% | 162us | 0.0% | 162us | `onUnreachableCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js` |
| 0.0% | 162us | 0.0% | 162us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4190` |
| 0.0% | 162us | 0.0% | 0us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5677` |
| 0.0% | 162us | 0.0% | 162us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1978` |
| 0.0% | 162us | 0.0% | 162us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1471` |
| 0.0% | 162us | 0.0% | 162us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:769` |
| 0.0% | 162us | 0.0% | 162us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js` |
| 0.0% | 162us | 0.0% | 162us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:117` |
| 0.0% | 161us | 0.0% | 161us | `isRead` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 161us | 0.0% | 161us | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:716` |
| 0.0% | 161us | 0.0% | 161us | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5601` |
| 0.0% | 161us | 0.0% | 161us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:126` |
| 0.0% | 161us | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:931` |
| 0.0% | 161us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:48` |
| 0.0% | 161us | 0.0% | 161us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1620` |
| 0.0% | 161us | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1739` |
| 0.0% | 161us | 0.0% | 161us | `getDefinedMessageData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:274` |
| 0.0% | 161us | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6713` |
| 0.0% | 161us | 0.0% | 161us | `runOnce` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js` |
| 0.0% | 161us | 0.0% | 161us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1612` |
| 0.0% | 161us | 0.0% | 161us | `/[iI]gnored/u` | `[native code]` |
| 0.0% | 160us | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:658` |
| 0.0% | 160us | 0.0% | 0us | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3342` |
| 0.0% | 160us | 0.0% | 160us | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:807` |
| 0.0% | 160us | 0.0% | 160us | `getStaticStringValue` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js` |
| 0.0% | 160us | 0.0% | 160us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6101` |
| 0.0% | 160us | 0.0% | 160us | `getTagNames` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:189` |
| 0.0% | 160us | 0.0% | 160us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6464` |
| 0.0% | 160us | 0.0% | 160us | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2962` |
| 0.0% | 160us | 0.0% | 160us | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:513` |
| 0.0% | 159us | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7095` |
| 0.0% | 159us | 0.0% | 159us | `describeRule` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:32` |
| 0.0% | 159us | 0.0% | 0us | `getFunctionNameWithKind` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2115` |
| 0.0% | 159us | 0.0% | 159us | `ObjectExpression > Property[computed!=true] > Identifier.key,MethodDefinition[computed!=true] > Identifier.key,PropertyDefinition[computed!=true] > Identifier.key,MethodDefinition > PrivateIdentifier.key,PropertyDefinition > PrivateIdentifier.key` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:351` |
| 0.0% | 159us | 0.0% | 159us | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6022` |
| 0.0% | 159us | 0.0% | 159us | `equalsToOriginalName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:178` |
| 0.0% | 159us | 0.0% | 159us | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6359` |
| 0.0% | 159us | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` |
| 0.0% | 158us | 0.0% | 158us | `join` | `[native code]` |
| 0.0% | 158us | 0.0% | 158us | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 158us | 0.0% | 158us | `toUpperCase` | `[native code]` |
| 0.0% | 158us | 0.0% | 0us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` |
| 0.0% | 158us | 0.0% | 158us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.0% | 158us | 0.0% | 158us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:179` |
| 0.0% | 158us | 0.0% | 158us | `hasRestSpreadSibling` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.0% | 158us | 0.0% | 0us | `checkGroup` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:476` |
| 0.0% | 158us | 0.0% | 158us | `replace` | `[native code]` |
| 0.0% | 158us | 0.0% | 158us | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 158us | 0.0% | 0us | `equalsToOriginalName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:179` |
| 0.0% | 158us | 0.0% | 0us | `get key` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3120` |
| 0.0% | 158us | 0.0% | 158us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` |
| 0.0% | 157us | 0.0% | 0us | `isInTdz` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:491` |
| 0.0% | 157us | 0.0% | 157us | `checkLastSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:393` |
| 0.0% | 157us | 0.0% | 157us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4004` |
| 0.0% | 157us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:22` |
| 0.0% | 156us | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:840` |
| 0.0% | 156us | 0.0% | 156us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3055` |
| 0.0% | 156us | 0.0% | 156us | `get nodeTags` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:602` |
| 0.0% | 156us | 0.0% | 156us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5891` |
| 0.0% | 156us | 0.0% | 156us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js` |
| 0.0% | 156us | 0.0% | 156us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4213` |
| 0.0% | 156us | 0.0% | 156us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1295` |
| 0.0% | 156us | 0.0% | 156us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:841` |
| 0.0% | 156us | 0.0% | 156us | `replaceText` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3696` |
| 0.0% | 156us | 0.0% | 156us | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4855` |
| 0.0% | 156us | 0.0% | 156us | `getTokenAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1261` |
| 0.0% | 155us | 0.0% | 155us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5120` |
| 0.0% | 155us | 0.0% | 155us | `onCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:434` |
| 0.0% | 155us | 0.0% | 155us | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4853` |
| 0.0% | 155us | 0.0% | 0us | `isModifyingProp` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:95` |
| 0.0% | 155us | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3783` |
| 0.0% | 155us | 0.0% | 155us | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4688` |
| 0.0% | 155us | 0.0% | 0us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1628` |
| 0.0% | 155us | 0.0% | 155us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2216` |
| 0.0% | 155us | 0.0% | 155us | `/:([a-z-]+)\([^)]*\)/g` | `[native code]` |
| 0.0% | 155us | 0.0% | 155us | `/(?:Statement\|Declaration\|Function(?:Expression)?\|Program)$/u` | `[native code]` |
| 0.0% | 154us | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1658` |
| 0.0% | 154us | 0.0% | 0us | `isFunctionNameInitializerException` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:445` |
| 0.0% | 154us | 0.0% | 154us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6536` |
| 0.0% | 154us | 0.0% | 154us | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 154us | 0.0% | 154us | `get test` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1598` |
| 0.0% | 154us | 0.0% | 0us | `unwrapExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:373` |
| 0.0% | 154us | 0.0% | 154us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6417` |
| 0.0% | 154us | 0.0% | 0us | `getFunctionHeadLoc` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2299` |
| 0.0% | 153us | 0.0% | 153us | `delete` | `[native code]` |
| 0.0% | 153us | 0.0% | 0us | `onUnreachableCodePathSegmentEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:430` |
| 0.0% | 153us | 0.0% | 153us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:384` |
| 0.0% | 152us | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1690` |
| 0.0% | 152us | 0.0% | 152us | `ke` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 152us | 0.0% | 152us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4991` |
| 0.0% | 152us | 0.0% | 152us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1735` |
| 0.0% | 152us | 0.0% | 0us | `equalsToOriginalName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:167` |
| 0.0% | 152us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:55` |
| 0.0% | 152us | 0.0% | 152us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1694` |
| 0.0% | 151us | 0.0% | 0us | `isAssignmentTarget` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:143` |
| 0.0% | 151us | 0.0% | 151us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5051` |
| 0.0% | 151us | 0.0% | 151us | `checkVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:227` |
| 0.0% | 151us | 0.0% | 151us | `get kind` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 151us | 0.0% | 151us | `checkLastSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:316` |
| 0.0% | 151us | 0.0% | 151us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:412` |
| 0.0% | 150us | 0.0% | 150us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:136` |
| 0.0% | 150us | 0.0% | 150us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3028` |
| 0.0% | 150us | 0.0% | 150us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2275` |
| 0.0% | 150us | 0.0% | 0us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5734` |
| 0.0% | 150us | 0.0% | 150us | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1019` |
| 0.0% | 150us | 0.0% | 150us | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:818` |
| 0.0% | 150us | 0.0% | 0us | `_tryLoad` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:34` |
| 0.0% | 149us | 0.0% | 149us | `getDefinedMessageData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.0% | 149us | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:576` |
| 0.0% | 149us | 0.0% | 149us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6467` |
| 0.0% | 149us | 0.0% | 149us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5064` |
| 0.0% | 149us | 0.0% | 149us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6458` |
| 0.0% | 149us | 0.0% | 0us | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:619` |
| 0.0% | 148us | 0.0% | 148us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4288` |
| 0.0% | 148us | 0.0% | 0us | `canBecomeVariableDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:51` |
| 0.0% | 148us | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7342` |
| 0.0% | 148us | 0.0% | 0us | `get key` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3128` |
| 0.0% | 148us | 0.0% | 148us | `defineProperty` | `[native code]` |
| 0.0% | 148us | 0.0% | 0us | `node:events` | `node:events:320` |
| 0.0% | 148us | 0.0% | 148us | `_getFfiSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:105` |
| 0.0% | 148us | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:560` |
| 0.0% | 148us | 0.0% | 148us | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 148us | 0.0% | 148us | `isExported` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:363` |
| 0.0% | 148us | 0.0% | 148us | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1037` |
| 0.0% | 148us | 0.0% | 0us | `isImportAttributeKey` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:1424` |
| 0.0% | 148us | 0.0% | 148us | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2939` |
| 0.0% | 147us | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:862` |
| 0.0% | 147us | 0.0% | 147us | `_isChainChild` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3866` |
| 0.0% | 147us | 0.0% | 147us | `_ensureTagCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5532` |
| 0.0% | 147us | 0.0% | 147us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:351` |
| 0.0% | 147us | 0.0% | 147us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2844` |
| 0.0% | 147us | 0.0% | 0us | `get right` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1786` |
| 0.0% | 147us | 0.0% | 147us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4258` |
| 0.0% | 147us | 0.0% | 147us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 147us | 0.0% | 147us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 147us | 0.0% | 147us | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4832` |
| 0.0% | 147us | 0.0% | 147us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:82` |
| 0.0% | 146us | 0.0% | 0us | `checkGroup` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:492` |
| 0.0% | 146us | 0.0% | 146us | `RuleContext` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 146us | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7376` |
| 0.0% | 146us | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6578` |
| 0.0% | 146us | 0.0% | 146us | `get properties` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3087` |
| 0.0% | 146us | 0.0% | 146us | `equalsToOriginalName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js` |
| 0.0% | 146us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:495` |
| 0.0% | 146us | 0.0% | 146us | `parse` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 146us | 0.0% | 146us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 145us | 0.0% | 0us | `isSpecificMemberAccess` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:393` |
| 0.0% | 145us | 0.0% | 145us | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2913` |
| 0.0% | 145us | 0.0% | 145us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1954` |
| 0.0% | 145us | 0.0% | 145us | `checkText` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:355` |
| 0.0% | 145us | 0.0% | 145us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2748` |
| 0.0% | 145us | 0.0% | 145us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 145us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:397` |
| 0.0% | 144us | 0.0% | 144us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5655` |
| 0.0% | 144us | 0.0% | 144us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4983` |
| 0.0% | 144us | 0.0% | 144us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` |
| 0.0% | 144us | 0.0% | 144us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1649` |
| 0.0% | 144us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:464` |
| 0.0% | 144us | 0.0% | 0us | `checkGroup` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:463` |
| 0.0% | 143us | 0.0% | 0us | `getTokenAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1265` |
| 0.0% | 143us | 0.0% | 0us | `moduleEvaluation` | `[native code]` |
| 0.0% | 143us | 0.0% | 143us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:228` |
| 0.0% | 143us | 0.0% | 143us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:818` |
| 0.0% | 143us | 0.0% | 143us | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4844` |
| 0.0% | 143us | 0.0% | 143us | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5563` |
| 0.0% | 143us | 0.0% | 0us | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:790` |
| 0.0% | 143us | 0.0% | 143us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2471` |
| 0.0% | 143us | 0.0% | 0us | `hasRestSpreadSibling` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:411` |
| 0.0% | 143us | 0.0% | 143us | `evaluate` | `[native code]` |
| 0.0% | 143us | 0.0% | 143us | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5944` |
| 0.0% | 142us | 0.0% | 0us | `isStorableFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:584` |
| 0.0% | 142us | 0.0% | 142us | `e` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 142us | 0.0% | 142us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6469` |
| 0.0% | 142us | 0.0% | 142us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1744` |
| 0.0% | 142us | 0.0% | 142us | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5956` |
| 0.0% | 142us | 0.0% | 0us | `get expressions` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3031` |
| 0.0% | 142us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:426` |
| 0.0% | 142us | 0.0% | 0us | `a` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 141us | 0.0% | 141us | `ImportDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:373` |
| 0.0% | 141us | 0.0% | 141us | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1030` |
| 0.0% | 140us | 0.0% | 140us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6952` |
| 0.0% | 140us | 0.0% | 140us | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1011` |
| 0.0% | 140us | 0.0% | 140us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6256` |
| 0.0% | 140us | 0.0% | 140us | `_nodeEndPos` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:880` |
| 0.0% | 140us | 0.0% | 0us | `getFirstTokenBetween` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1313` |
| 0.0% | 140us | 0.0% | 140us | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2333` |
| 0.0% | 140us | 0.0% | 140us | `get callee` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1871` |
| 0.0% | 140us | 0.0% | 140us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5288` |
| 0.0% | 139us | 0.0% | 139us | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:737` |
| 0.0% | 139us | 0.0% | 139us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5798` |
| 0.0% | 139us | 0.0% | 139us | `get property` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1941` |
| 0.0% | 139us | 0.0% | 139us | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1012` |
| 0.0% | 139us | 0.0% | 139us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:180` |
| 0.0% | 138us | 0.0% | 138us | `_deepMergeObjects` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 138us | 0.0% | 138us | `getUpperFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:130` |
| 0.0% | 138us | 0.0% | 138us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:370` |
| 0.0% | 138us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:429` |
| 0.0% | 138us | 0.0% | 138us | `_parseDisableDirectives` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 137us | 0.0% | 137us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1958` |
| 0.0% | 137us | 0.0% | 137us | `_getChainExpr` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3913` |
| 0.0% | 137us | 0.0% | 137us | `ensureBufferBytes` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js` |
| 0.0% | 136us | 0.0% | 0us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3034` |
| 0.0% | 136us | 0.0% | 136us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:428` |
| 0.0% | 135us | 0.0% | 0us | `bound call` | `[native code]` |
| 0.0% | 135us | 0.0% | 0us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4205` |
| 0.0% | 135us | 0.0% | 135us | `isFunctionNameInitializerException` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js` |
| 0.0% | 135us | 0.0% | 0us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2646` |
| 0.0% | 135us | 0.0% | 0us | `makeSafe` | `internal:primordials:30` |
| 0.0% | 135us | 0.0% | 135us | `(anonymous)` | `internal:primordials:39` |
| 0.0% | 135us | 0.0% | 0us | `internal:primordials` | `internal:primordials:71` |
| 0.0% | 133us | 0.0% | 133us | `_isChainMiddleTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3854` |
| 0.0% | 133us | 0.0% | 0us | `_isChainNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3886` |
| 0.0% | 122us | 0.0% | 122us | `getFirstToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |

## Function Details

### `parse`
`[native code]` | Self: 5.6% (49.3ms) | Total: 5.6% (49.3ms) | Samples: 288

**Called by:**
- `parseSource` (269)
- `(anonymous)` (16)
- `tryParse` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6826` | Self: 2.9% (26.0ms) | Total: 3.0% (26.8ms) | Samples: 155

**Called by:**
- `runPlugins` (160)

**Calls:**
- `add` (5)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1998` | Self: 2.8% (25.1ms) | Total: 3.0% (26.8ms) | Samples: 146

**Called by:**
- `ensureVarsSet` (156)

**Calls:**
- `set` (10)

### `Uint32Array`
`[native code]` | Self: 2.6% (22.7ms) | Total: 2.6% (22.7ms) | Samples: 134

**Called by:**
- `CfgGraph` (18)
- `AstView` (9)
- `AstView` (5)
- `AstView` (5)
- `AstView` (5)
- `AstView` (4)
- `AstView` (4)
- `AstView` (4)
- `CfgGraph` (4)
- `AstView` (4)
- `AstView` (4)
- `CfgGraph` (3)
- `CfgGraph` (3)
- `AstView` (3)
- `AstView` (3)
- `AstView` (3)
- `CfgGraph` (3)
- `CfgGraph` (2)
- `CfgGraph` (2)
- `CfgGraph` (2)
- `CfgGraph` (2)
- `AstView` (2)
- `AstView` (2)
- `AstView` (2)
- `AstView` (2)
- `AstView` (2)
- `CfgGraph` (2)
- `AstView` (2)
- `AstView` (2)
- `AstView` (2)
- `AstView` (2)
- `CfgGraph` (2)
- `AstView` (2)
- `AstView` (2)
- `CfgGraph` (1)
- `AstView` (1)
- `AstView` (1)
- `AstView` (1)
- `CfgGraph` (1)
- `AstView` (1)
- `AstView` (1)
- `AstView` (1)
- `AstView` (1)
- `AstView` (1)
- `CfgGraph` (1)
- `AstView` (1)
- `AstView` (1)
- `AstView` (1)
- `CfgGraph` (1)
- `AstView` (1)

### `anonymous`
`[native code]` | Self: 2.4% (21.2ms) | Total: 6.0% (52.6ms) | Samples: 125

**Called by:**
- `require` (264)
- `bound require` (22)
- `node:fs` (6)
- `node:path` (5)
- `internal:validators` (4)
- `internal:shared` (3)
- `node:child_process` (1)
- `internal:promisify` (1)
- `node:fs` (1)

**Calls:**
- `(anonymous)` (44)
- `(anonymous)` (27)
- `(anonymous)` (16)
- `(anonymous)` (11)
- `(anonymous)` (8)
- `(anonymous)` (8)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `node:fs` (6)
- `node:path` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `internal:validators` (4)
- `(anonymous)` (3)
- `internal:shared` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `node:os` (1)
- `(anonymous)` (1)
- `node:events` (1)
- `internal:promisify` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:child_process` (1)
- `internal:validators` (1)
- `internal:primordials` (1)
- `(anonymous)` (1)
- `node:child_process` (1)
- `internal:primordials` (1)
- `node:fs/promises` (1)
- `(anonymous)` (1)
- `node:fs` (1)

### `_mkGlobalVar`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:587` | Self: 2.3% (20.6ms) | Total: 2.3% (20.6ms) | Samples: 116

**Called by:**
- `_buildScopeVarsAndSet` (116)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5745` | Self: 2.3% (20.1ms) | Total: 2.3% (20.1ms) | Samples: 120

**Called by:**
- `_getOrBuildPlan` (120)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2167` | Self: 1.8% (16.4ms) | Total: 1.8% (16.4ms) | Samples: 105

**Called by:**
- `ensureVarsSet` (105)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6685` | Self: 1.6% (14.3ms) | Total: 1.6% (14.3ms) | Samples: 86

**Called by:**
- `runPlugins` (86)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6602` | Self: 1.5% (13.1ms) | Total: 1.7% (14.8ms) | Samples: 76

**Called by:**
- `runPlugins` (86)

**Calls:**
- `has` (10)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6759` | Self: 1.3% (11.7ms) | Total: 1.6% (14.1ms) | Samples: 67

**Called by:**
- `runPlugins` (81)

**Calls:**
- `get` (14)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5761` | Self: 1.2% (11.1ms) | Total: 1.2% (11.1ms) | Samples: 67

**Called by:**
- `_getOrBuildPlan` (67)

### `defineProperties`
`[native code]` | Self: 1.1% (10.2ms) | Total: 1.1% (10.2ms) | Samples: 61

**Called by:**
- `_buildScope` (60)
- `(anonymous)` (1)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` | Self: 1.0% (8.8ms) | Total: 1.0% (8.8ms) | Samples: 14

**Called by:**
- `isUsedVariable` (14)

### `some`
`[native code]` | Self: 0.9% (8.5ms) | Total: 2.8% (25.1ms) | Samples: 49

**Called by:**
- `collectUnusedVariables` (51)
- `isUsedVariable` (48)
- `walkNodes` (31)
- `collectUnusedVariables` (3)
- `isEvaluatedDuringInitialization` (3)
- `some` (2)
- `getIdentifierIfShouldBeConst` (2)
- `_compileSelectorFastMatcher` (2)
- `getIdentifierIfShouldBeConst` (2)
- `hasRestSpreadSibling` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)
- `Program` (1)

**Calls:**
- `(anonymous)` (52)
- `(anonymous)` (17)
- `(anonymous)` (9)
- `(anonymous)` (7)
- `(anonymous)` (2)
- `some` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `hasMemberExpressionAssignment` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `[Symbol.match]` (1)
- `isOuterVariableInDestructing` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5690` | Self: 0.9% (8.2ms) | Total: 1.0% (9.3ms) | Samples: 49

**Called by:**
- `_getOrBuildPlan` (56)

**Calls:**
- `get` (7)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5754` | Self: 0.9% (8.0ms) | Total: 0.9% (8.0ms) | Samples: 46

**Called by:**
- `_getOrBuildPlan` (46)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5687` | Self: 0.8% (7.1ms) | Total: 1.0% (8.7ms) | Samples: 42

**Called by:**
- `_getOrBuildPlan` (51)

**Calls:**
- `next` (9)

### `map`
`[native code]` | Self: 0.8% (6.9ms) | Total: 1.4% (12.7ms) | Samples: 42

**Called by:**
- `_deepMergeArrays` (29)
- `slotTemplate` (20)
- `_buildTemplate` (6)
- `_isSelector` (6)
- `_compileSelectorFastMatcher` (4)
- `_buildTemplate` (3)
- `_buildTemplate` (3)
- `runPlugins` (1)
- `buildVisitorMap` (1)
- `_compileSelectorFastMatcher` (1)
- `_buildTemplate` (1)
- `_ensureTagCaches` (1)
- `getIdentifierIfShouldBeConst` (1)

**Calls:**
- `_deepMergeObjects` (9)
- `(anonymous)` (6)
- `_deepMergeObjects` (5)
- `_compileAttrCheck` (4)
- `_deepMergeObjects` (4)
- `(anonymous)` (1)
- `trim` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `_deepMergeObjects` (1)
- `_deepMergeObjects` (1)
- `(anonymous)` (1)

### `_extractBatchScannable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4661` | Self: 0.7% (6.6ms) | Total: 0.7% (6.6ms) | Samples: 39

**Called by:**
- `_buildPlan` (39)

### `_buildTemplate`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5804` | Self: 0.7% (6.4ms) | Total: 0.9% (8.5ms) | Samples: 36

**Called by:**
- `_buildPlan` (48)

**Calls:**
- `slotTemplate` (11)
- `map` (1)

### `Set`
`[native code]` | Self: 0.7% (6.3ms) | Total: 0.7% (6.3ms) | Samples: 39

**Called by:**
- `_buildScope` (36)
- `getDeclaredVariables` (2)
- `_getOrBuildSelectorPlan` (1)

### `get`
`[native code]` | Self: 0.6% (6.0ms) | Total: 0.6% (6.0ms) | Samples: 36

**Called by:**
- `walkNodes` (14)
- `_buildPlan` (7)
- `walkNodes` (2)
- `walkNodes` (2)
- `buildVisitorMap` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `getDeclaredVariables` (1)
- `_buildPlan` (1)
- `_buildPlan` (1)
- `buildVisitorMap` (1)
- `runOnce` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `_buildPlan` (1)

### `indexOf`
`[native code]` | Self: 0.6% (5.9ms) | Total: 0.6% (5.9ms) | Samples: 35

**Called by:**
- `_buildPlan` (13)
- `walkNodes` (9)
- `walkNodes` (6)
- `_buildPlan` (4)
- `_buildPlan` (2)
- `_getOrBuildSelectorPlan` (1)

### `Uint8Array`
`[native code]` | Self: 0.6% (5.8ms) | Total: 0.6% (5.8ms) | Samples: 35

**Called by:**
- `_encodeSource` (6)
- `AstView` (4)
- `AstView` (4)
- `AstView` (4)
- `AstView` (3)
- `AstView` (3)
- `AstView` (2)
- `walkNodes` (2)
- `walkNodes` (2)
- `AstView` (2)
- `CfgGraph` (1)
- `walkNodes` (1)
- `CfgGraph` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3994` | Self: 0.6% (5.5ms) | Total: 0.7% (6.4ms) | Samples: 33

**Called by:**
- `get parent` (10)
- `_buildReference` (9)
- `_nodesFromRange` (7)
- `_fireCfgEvents` (3)
- `_buildThinVariable` (2)
- `(anonymous)` (1)
- `_buildScope` (1)
- `_buildScope` (1)
- `isSpecificMemberAccess` (1)
- `invokeSelectorHandlers` (1)
- `_buildVariable` (1)
- `walkNodes` (1)

**Calls:**
- `_getTypeProto` (3)
- `_getTypeProto` (1)
- `create` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1613` | Self: 0.6% (5.3ms) | Total: 0.6% (5.3ms) | Samples: 32

**Called by:**
- `_buildScopeVarsAndSet` (27)
- `getDeclaredVariables` (5)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5697` | Self: 0.6% (5.3ms) | Total: 0.6% (5.7ms) | Samples: 33

**Called by:**
- `_getOrBuildPlan` (35)

**Calls:**
- `indexOf` (2)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:505` | Self: 0.6% (5.3ms) | Total: 0.6% (5.3ms) | Samples: 33

**Called by:**
- `parseSource` (33)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6733` | Self: 0.5% (4.9ms) | Total: 0.5% (4.9ms) | Samples: 30

**Called by:**
- `runPlugins` (30)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6732` | Self: 0.5% (4.9ms) | Total: 0.5% (4.9ms) | Samples: 30

**Called by:**
- `runPlugins` (30)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1285` | Self: 0.5% (4.7ms) | Total: 0.6% (5.6ms) | Samples: 29

**Called by:**
- `_buildReference` (7)
- `isInLoop` (7)
- `_findDefNode` (6)
- `_findDefNode` (3)
- `isInitOfForStatement` (2)
- `_buildVariable` (2)
- `_computeIsStrict` (2)
- `_buildThinVariable` (2)
- `_findDefNode` (1)
- `isForInOfRef` (1)
- `isImportAttributeKey` (1)

**Calls:**
- `get _tag` (3)
- `get _tag` (2)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4839` | Self: 0.5% (4.7ms) | Total: 0.5% (4.7ms) | Samples: 25

**Called by:**
- `_buildPlan` (25)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6818` | Self: 0.5% (4.7ms) | Total: 0.5% (4.7ms) | Samples: 28

**Called by:**
- `runPlugins` (28)

### `_getSelectorRootTypes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5557` | Self: 0.5% (4.6ms) | Total: 0.5% (4.6ms) | Samples: 28

**Called by:**
- `_getSelectorRootTypes` (17)
- `_getOrBuildSelectorPlan` (8)
- `_buildPlan` (3)

### `stringSplitFast`
`[native code]` | Self: 0.5% (4.3ms) | Total: 0.5% (4.3ms) | Samples: 25

**Called by:**
- `_getSelectorRootTypes` (21)
- `_compileAttrCheck` (2)
- `_isSelector` (2)

### `get _tag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1072` | Self: 0.4% (4.3ms) | Total: 0.4% (4.3ms) | Samples: 26

**Called by:**
- `get parent` (6)
- `get parent` (5)
- `get name` (3)
- `_findDefNode` (3)
- `get body` (2)
- `get parent` (2)
- `get parent` (2)
- `get local` (1)
- `_findDefNode` (1)
- `_findDefNode` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5714` | Self: 0.4% (4.2ms) | Total: 0.4% (4.2ms) | Samples: 26

**Called by:**
- `_getOrBuildPlan` (26)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4252` | Self: 0.4% (4.0ms) | Total: 0.4% (4.1ms) | Samples: 25

**Called by:**
- `runPlugins` (26)

**Calls:**
- `set` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5641` | Self: 0.4% (3.9ms) | Total: 0.4% (3.9ms) | Samples: 22

**Called by:**
- `_getOrBuildPlan` (22)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4837` | Self: 0.4% (3.7ms) | Total: 0.4% (3.7ms) | Samples: 21

**Called by:**
- `_buildPlan` (21)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4006` | Self: 0.4% (3.5ms) | Total: 0.4% (3.5ms) | Samples: 21

**Called by:**
- `get parent` (5)
- `walkNodes` (3)
- `walkNodes` (3)
- `_buildVariable` (2)
- `_nodesFromRange` (2)
- `get body` (1)
- `getAncestorsFor` (1)
- `(anonymous)` (1)
- `invokeSelectorHandlers` (1)
- `_buildThinScope` (1)
- `getArrayMethodName` (1)

### `_buildTemplate`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5803` | Self: 0.4% (3.5ms) | Total: 0.7% (6.3ms) | Samples: 21

**Called by:**
- `_buildPlan` (38)

**Calls:**
- `slotTemplate` (10)
- `map` (3)
- `slotTemplate` (2)
- `slotTemplate` (2)

### `has`
`[native code]` | Self: 0.4% (3.5ms) | Total: 0.4% (3.5ms) | Samples: 21

**Called by:**
- `walkNodes` (10)
- `walkNodes` (5)
- `_buildScopeVarsAndSet` (4)
- `walkNodes` (1)
- `walkNodes` (1)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4842` | Self: 0.4% (3.5ms) | Total: 0.4% (4.1ms) | Samples: 20

**Called by:**
- `_buildPlan` (24)

**Calls:**
- `next` (4)

### `get _tag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.3% (3.4ms) | Total: 0.3% (3.4ms) | Samples: 21

**Called by:**
- `get parent` (8)
- `get parent` (4)
- `get parent` (3)
- `get parent` (2)
- `get name` (1)
- `get parent` (1)
- `get right` (1)
- `_findDefNode` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` | Self: 0.3% (3.3ms) | Total: 0.3% (3.3ms) | Samples: 21

**Called by:**
- `Program:exit` (21)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5889` | Self: 0.3% (3.3ms) | Total: 0.3% (3.3ms) | Samples: 19

**Called by:**
- `runPlugins` (19)

### `endsWith`
`[native code]` | Self: 0.3% (3.3ms) | Total: 0.3% (3.3ms) | Samples: 20

**Called by:**
- `_getSelectorRootTypes` (9)
- `_expandUnion` (4)
- `_buildPlan` (3)
- `_isSelector` (2)
- `_isSelector` (1)
- `buildVisitorMap` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5742` | Self: 0.3% (3.2ms) | Total: 0.3% (3.2ms) | Samples: 18

**Called by:**
- `_getOrBuildPlan` (18)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:276` | Self: 0.3% (3.2ms) | Total: 0.3% (3.4ms) | Samples: 19

**Called by:**
- `parseSource` (20)

**Calls:**
- `DataView` (1)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4838` | Self: 0.3% (3.2ms) | Total: 0.3% (3.2ms) | Samples: 19

**Called by:**
- `_buildPlan` (19)

### `_compileSelectorFastMatcher`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5085` | Self: 0.3% (3.1ms) | Total: 0.3% (3.1ms) | Samples: 10

**Called by:**
- `_compileSelectorFastMatcher` (10)

### `_mkGlobalVar`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.3% (3.1ms) | Total: 0.3% (3.1ms) | Samples: 19

**Called by:**
- `_buildScopeVarsAndSet` (19)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1644` | Self: 0.3% (3.1ms) | Total: 0.3% (3.1ms) | Samples: 19

**Called by:**
- `_precomputeScopes` (9)
- `_buildScopeChildren` (4)
- `Program:exit` (2)
- `Program:exit` (2)
- `_buildScope` (1)
- `Program` (1)

### `_getSelectorRootTypes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5564` | Self: 0.3% (3.1ms) | Total: 0.4% (3.6ms) | Samples: 19

**Called by:**
- `_buildPlan` (13)
- `_getOrBuildSelectorPlan` (9)

**Calls:**
- `trim` (3)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1006` | Self: 0.3% (3.0ms) | Total: 0.3% (3.0ms) | Samples: 18

**Called by:**
- `isFunction` (3)
- `skipChainExpression` (2)
- `checkLastSegment` (2)
- `(anonymous)` (1)
- `isDuplicatedEnumNameVariable` (1)
- `_buildScopeRefsAndThrough` (1)
- `onCodePathStart` (1)
- `equalsToOriginalName` (1)
- `collectUnusedVariables` (1)
- `getStaticPropertyName` (1)
- `(anonymous)` (1)
- `getFunctionNameWithKind` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.3% (3.0ms) | Total: 0.3% (3.1ms) | Samples: 18

**Called by:**
- `_buildReference` (5)
- `isLoop` (3)
- `_computeIsStrict` (2)
- `isFunction` (2)
- `isForInOfRef` (2)
- `isReadForItself` (1)
- `_findDefNode` (1)
- `isReadForItself` (1)
- `_buildScopeRefsAndThrough` (1)
- `getDestructuringHost` (1)

**Calls:**
- `nodeLhs` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4005` | Self: 0.3% (2.9ms) | Total: 0.3% (2.9ms) | Samples: 16

**Called by:**
- `ReturnStatement` (5)
- `get parent` (3)
- `_nodesFromRange` (3)
- `_buildThinVariable` (1)
- `walkNodes` (1)
- `_buildThinScope` (1)
- `_buildVariable` (1)
- `walkNodes` (1)

### `filter`
`[native code]` | Self: 0.3% (2.9ms) | Total: 0.5% (5.1ms) | Samples: 17

**Called by:**
- `checkReferencesInScope` (13)
- `runOnce` (6)
- `_compileSelectorFastMatcher` (4)
- `getIdentifierIfShouldBeConst` (2)
- `_compileSelectorFastMatcher` (2)
- `_compileSelectorFastMatcher` (1)
- `Program:exit` (1)
- `_compileSelectorFastMatcher` (1)

**Calls:**
- `shouldCheck` (4)
- `shouldCheck` (2)
- `shouldCheck` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `shouldCheck` (1)
- `shouldCheck` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1995` | Self: 0.3% (2.8ms) | Total: 0.4% (3.9ms) | Samples: 17

**Called by:**
- `ensureVarsSet` (23)

**Calls:**
- `toString` (6)

### `next`
`[native code]` | Self: 0.3% (2.8ms) | Total: 0.4% (4.1ms) | Samples: 17

**Called by:**
- `_buildPlan` (9)
- `findVariablesInScope` (8)
- `_extractFileLevelRules` (4)
- `walkNodes` (4)

**Calls:**
- `generatorResume` (8)

### `set`
`[native code]` | Self: 0.3% (2.7ms) | Total: 0.3% (2.7ms) | Samples: 16

**Called by:**
- `_buildScopeVarsAndSet` (10)
- `_buildScopeVarsAndSet` (2)
- `buildVisitorMap` (1)
- `_buildThinScope` (1)
- `_ensureDeclSymIndex` (1)
- `getDeclaredVariables` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3890` | Self: 0.3% (2.7ms) | Total: 0.3% (2.7ms) | Samples: 17

**Called by:**
- `runPlugins` (17)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6570` | Self: 0.3% (2.6ms) | Total: 0.3% (2.6ms) | Samples: 16

**Called by:**
- `runPlugins` (16)

### `_extractBatchScannable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4641` | Self: 0.3% (2.6ms) | Total: 0.3% (2.6ms) | Samples: 15

**Called by:**
- `_buildPlan` (15)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1013` | Self: 0.2% (2.5ms) | Total: 0.2% (2.5ms) | Samples: 16

**Called by:**
- `isFunction` (3)
- `_buildScopeRefsAndThrough` (2)
- `getStaticPropertyName` (2)
- `_findDefNode` (1)
- `fn` (1)
- `referenceContainsTypeQuery` (1)
- `isSpecificId` (1)
- `isInitOfForStatement` (1)
- `get key` (1)
- `fn` (1)
- `getUpperFunction` (1)
- `_execReport` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6533` | Self: 0.2% (2.5ms) | Total: 0.2% (2.5ms) | Samples: 15

**Called by:**
- `runPlugins` (15)

### `_extractBatchScannable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4635` | Self: 0.2% (2.5ms) | Total: 0.2% (2.5ms) | Samples: 15

**Called by:**
- `_buildPlan` (15)

### `_buildTemplate`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5800` | Self: 0.2% (2.4ms) | Total: 0.2% (2.4ms) | Samples: 14

**Called by:**
- `_buildPlan` (14)

### `entries`
`[native code]` | Self: 0.2% (2.4ms) | Total: 0.2% (2.4ms) | Samples: 15

**Called by:**
- `buildVisitorMap` (9)
- `_applySchemaDefaults` (4)
- `performIteration` (2)

### `_deepMergeArrays`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:134` | Self: 0.2% (2.3ms) | Total: 0.2% (2.3ms) | Samples: 9

**Called by:**
- `buildVisitorMap` (9)

### `trim`
`[native code]` | Self: 0.2% (2.3ms) | Total: 0.2% (2.3ms) | Samples: 14

**Called by:**
- `_getSelectorRootTypes` (4)
- `_getSelectorRootTypes` (3)
- `_getSelectorRootTypes` (3)
- `_getSelectorRootTypes` (2)
- `_getSelectorRootTypes` (1)
- `map` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:805` | Self: 0.2% (2.3ms) | Total: 0.2% (2.3ms) | Samples: 10

**Called by:**
- `getFirstTokenBetween` (9)
- `getFirstToken` (1)

### `findVariablesInScope`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:95` | Self: 0.2% (2.2ms) | Total: 0.5% (4.4ms) | Samples: 13

**Called by:**
- `Program` (26)

**Calls:**
- `next` (8)
- `generatorResume` (4)
- `[Symbol.iterator]` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3986` | Self: 0.2% (2.2ms) | Total: 0.2% (2.2ms) | Samples: 13

**Called by:**
- `walkNodes` (2)
- `_buildReference` (2)
- `getArrayMethodName` (1)
- `(anonymous)` (1)
- `invokeSelectorHandlers` (1)
- `_buildVariable` (1)
- `get parent` (1)
- `_buildThinScope` (1)
- `walkNodes` (1)
- `_nodesFromRange` (1)
- `walkNodes` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5731` | Self: 0.2% (2.2ms) | Total: 0.2% (2.2ms) | Samples: 13

**Called by:**
- `_getOrBuildPlan` (13)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:121` | Self: 0.2% (2.1ms) | Total: 0.2% (2.1ms) | Samples: 12

**Called by:**
- `buildVisitorMap` (12)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3995` | Self: 0.2% (2.1ms) | Total: 0.2% (2.1ms) | Samples: 12

**Called by:**
- `get parent` (9)
- `walkNodes` (1)
- `fn` (1)
- `getStaticPropertyName` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6731` | Self: 0.2% (2.0ms) | Total: 0.2% (2.0ms) | Samples: 12

**Called by:**
- `runPlugins` (12)

### `_extractBatchScannable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4656` | Self: 0.2% (2.0ms) | Total: 0.2% (2.0ms) | Samples: 12

**Called by:**
- `_buildPlan` (12)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:747` | Self: 0.2% (1.9ms) | Total: 0.2% (1.9ms) | Samples: 12

**Called by:**
- `get name` (12)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6865` | Self: 0.2% (1.8ms) | Total: 0.2% (2.6ms) | Samples: 11

**Called by:**
- `runPlugins` (14)

**Calls:**
- `get allSkipped` (3)

### `_extractBatchScannable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4673` | Self: 0.2% (1.8ms) | Total: 0.2% (1.8ms) | Samples: 11

**Called by:**
- `_buildPlan` (11)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6735` | Self: 0.2% (1.8ms) | Total: 0.8% (7.0ms) | Samples: 11

**Called by:**
- `runPlugins` (42)

**Calls:**
- `some` (31)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1952` | Self: 0.2% (1.8ms) | Total: 0.9% (8.2ms) | Samples: 11

**Called by:**
- `ensureVarsSet` (49)

**Calls:**
- `_ensureDeclSymIndex` (27)
- `_ensureDeclSymIndex` (3)
- `_ensureDeclSymIndex` (2)
- `_ensureDeclSymIndex` (2)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)

### `encodeInto`
`[native code]` | Self: 0.2% (1.8ms) | Total: 0.2% (1.8ms) | Samples: 11

**Called by:**
- `_encodeSource` (11)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5710` | Self: 0.2% (1.8ms) | Total: 0.2% (1.8ms) | Samples: 11

**Called by:**
- `_getOrBuildPlan` (11)

### `Int32Array`
`[native code]` | Self: 0.2% (1.7ms) | Total: 0.2% (1.7ms) | Samples: 10

**Called by:**
- `AstView` (10)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6635` | Self: 0.2% (1.7ms) | Total: 0.2% (1.9ms) | Samples: 11

**Called by:**
- `runPlugins` (12)

**Calls:**
- `add` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:490` | Self: 0.1% (1.7ms) | Total: 0.2% (1.8ms) | Samples: 10

**Called by:**
- `parseSource` (11)

**Calls:**
- `Uint32Array` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6540` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 10

**Called by:**
- `runPlugins` (10)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5730` | Self: 0.1% (1.7ms) | Total: 0.1% (1.7ms) | Samples: 10

**Called by:**
- `_getOrBuildPlan` (10)

### `_extractBatchScannable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4637` | Self: 0.1% (1.6ms) | Total: 0.2% (1.8ms) | Samples: 10

**Called by:**
- `_buildPlan` (11)

**Calls:**
- `includes` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7065` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 9

**Called by:**
- `runPlugins` (9)

### `decode`
`[native code]` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 9

**Called by:**
- `get source` (8)
- `source` (1)

### `dlopen`
`[native code]` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 9

**Called by:**
- `dlopen` (5)
- `(anonymous)` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5915` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 10

**Called by:**
- `runPlugins` (10)

### `nodeRhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:533` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 9

**Called by:**
- `get init` (4)
- `get property` (2)
- `get right` (1)
- `get expressions` (1)
- `get body` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4001` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 9

**Called by:**
- `_nodesFromRange` (2)
- `walkNodes` (2)
- `getAncestorsFor` (1)
- `_fireCfgEvents` (1)
- `_buildVariable` (1)
- `get parent` (1)
- `_buildReference` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 8

**Called by:**
- `_buildReference` (2)
- `_buildVariable` (2)
- `_computeIsStrict` (1)
- `isInitOfForStatement` (1)
- `_findDefNode` (1)
- `isInLoop` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4251` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 8

**Called by:**
- `runPlugins` (8)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1968` | Self: 0.1% (1.5ms) | Total: 0.2% (1.8ms) | Samples: 9

**Called by:**
- `ensureVarsSet` (10)
- `ensureVarsSet` (1)

**Calls:**
- `set` (2)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:92` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 9

**Called by:**
- `buildVisitorMap` (9)

### `toString`
`[native code]` | Self: 0.1% (1.4ms) | Total: 0.1% (1.5ms) | Samples: 8

**Called by:**
- `_buildScopeVarsAndSet` (6)
- `getVariableDescription` (3)

**Calls:**
- `get flags` (1)

### `fill`
`[native code]` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 9

**Called by:**
- `runPlugins` (4)
- `CfgGraph` (3)
- `CfgGraph` (1)
- `_getOrBuildSelectorPlan` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4225` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 8

**Called by:**
- `runPlugins` (8)

### `_tag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1072` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 7

**Called by:**
- `_findDefNode` (3)
- `get kind` (2)
- `get id` (1)
- `get directive` (1)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4840` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 8

**Called by:**
- `_buildPlan` (8)

### `get start`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 8

**Called by:**
- `get range` (4)
- `_execReport` (4)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2579` | Self: 0.1% (1.3ms) | Total: 0.2% (1.8ms) | Samples: 8

**Called by:**
- `_buildScopeVarsAndSet` (7)
- `getDeclaredVariables` (4)

**Calls:**
- `_buildThinScope` (2)
- `_buildThinScope` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 8

**Called by:**
- `runPlugins` (8)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5647` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 8

**Called by:**
- `_getOrBuildPlan` (8)

### `nodeLhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:528` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 7

**Called by:**
- `get init` (1)
- `walkNodes` (1)
- `get id` (1)
- `get type` (1)
- `get right` (1)
- `get left` (1)
- `get directive` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1674` | Self: 0.1% (1.3ms) | Total: 0.1% (1.6ms) | Samples: 8

**Called by:**
- `_computeIsStrict` (7)
- `_computeIsStrict` (3)

**Calls:**
- `get _tag` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6416` | Self: 0.1% (1.3ms) | Total: 0.1% (1.6ms) | Samples: 8

**Called by:**
- `runPlugins` (10)

**Calls:**
- `get` (2)

### `_compileSelectorFastMatcher`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5117` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 7

**Called by:**
- `_getOrBuildSelectorPlan` (7)

### `slice`
`[native code]` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 7

**Called by:**
- `_applySchemaDefaults` (4)
- `get value` (1)
- `_deepMergeArrays` (1)
- `commentsInRange` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1189` | Self: 0.1% (1.2ms) | Total: 1.0% (8.7ms) | Samples: 8

**Called by:**
- `_buildReference` (18)
- `_findDefNode` (11)
- `isInLoop` (5)
- `_findDefNode` (4)
- `_buildVariable` (3)
- `getArrayMethodName` (3)
- `_findDefNode` (2)
- `_computeIsStrict` (2)
- `isModifyingProp` (1)
- `_findDefNode` (1)

**Calls:**
- `_nodeViewRaw` (10)
- `_nodeViewRaw` (9)
- `_nodeViewRaw` (5)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (2)
- `nodeView` (1)
- `nodeView` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `nodeView` (1)
- `nodeView` (1)
- `nodeView` (1)

### `_extractBatchScannable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4666` | Self: 0.1% (1.2ms) | Total: 0.1% (1.2ms) | Samples: 8

**Called by:**
- `_buildPlan` (8)

### `performIteration`
`[native code]` | Self: 0.1% (1.2ms) | Total: 0.1% (1.6ms) | Samples: 8

**Called by:**
- `_buildTemplate` (10)

**Calls:**
- `entries` (2)

### `_buildTemplate`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5801` | Self: 0.1% (1.2ms) | Total: 0.1% (1.2ms) | Samples: 8

**Called by:**
- `_buildPlan` (8)

### `_buildTemplate`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5810` | Self: 0.1% (1.2ms) | Total: 0.4% (4.0ms) | Samples: 8

**Called by:**
- `_buildPlan` (26)

**Calls:**
- `performIteration` (10)
- `map` (6)
- `Map` (2)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6351` | Self: 0.1% (1.2ms) | Total: 0.1% (1.2ms) | Samples: 7

**Called by:**
- `walkNodes` (7)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1993` | Self: 0.1% (1.2ms) | Total: 0.1% (1.2ms) | Samples: 8

**Called by:**
- `ensureVarsSet` (8)

### `_expandUnion`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4044` | Self: 0.1% (1.2ms) | Total: 0.1% (1.2ms) | Samples: 7

**Called by:**
- `buildVisitorMap` (7)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1184` | Self: 0.1% (1.1ms) | Total: 0.1% (1.1ms) | Samples: 7

**Called by:**
- `isReadForItself` (1)
- `getFunctionNameWithKind` (1)
- `canBecomeVariableDeclaration` (1)
- `_computeIsStrict` (1)
- `getArrayMethodName` (1)
- `_buildThinVariable` (1)
- `_findDefNode` (1)

### `add`
`[native code]` | Self: 0.1% (1.1ms) | Total: 0.1% (1.1ms) | Samples: 7

**Called by:**
- `walkNodes` (5)
- `_ensureTagCaches` (1)
- `walkNodes` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5712` | Self: 0.1% (1.1ms) | Total: 0.1% (1.1ms) | Samples: 7

**Called by:**
- `_getOrBuildPlan` (7)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4220` | Self: 0.1% (1.1ms) | Total: 0.1% (1.1ms) | Samples: 6

**Called by:**
- `runPlugins` (6)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4845` | Self: 0.1% (1.1ms) | Total: 0.1% (1.1ms) | Samples: 7

**Called by:**
- `_buildPlan` (7)

### `isUnderscored`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:101` | Self: 0.1% (1.1ms) | Total: 0.2% (1.7ms) | Samples: 7

**Called by:**
- `isGoodName` (11)

**Calls:**
- `/^_+\|_+$/gu` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6735` | Self: 0.1% (1.1ms) | Total: 0.1% (1.1ms) | Samples: 7

**Called by:**
- `some` (7)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1996` | Self: 0.1% (1.1ms) | Total: 0.2% (1.8ms) | Samples: 7

**Called by:**
- `ensureVarsSet` (11)

**Calls:**
- `has` (4)

### `_applySchemaDefaults`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:170` | Self: 0.1% (1.1ms) | Total: 0.1% (1.7ms) | Samples: 7

**Called by:**
- `buildVisitorMap` (11)

**Calls:**
- `entries` (4)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5643` | Self: 0.1% (1.1ms) | Total: 0.1% (1.2ms) | Samples: 5

**Called by:**
- `_getOrBuildPlan` (6)

**Calls:**
- `Uint16Array` (1)

### `copyDataProperties`
`[native code]` | Self: 0.1% (1.1ms) | Total: 0.1% (1.1ms) | Samples: 7

**Called by:**
- `_deepMergeObjects` (7)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:642` | Self: 0.1% (1.1ms) | Total: 0.1% (1.1ms) | Samples: 7

**Called by:**
- `reset` (7)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4032` | Self: 0.1% (1.0ms) | Total: 0.1% (1.0ms) | Samples: 6

**Called by:**
- `walkNodes` (1)
- `_buildReference` (1)
- `get body` (1)
- `isNullCheck` (1)
- `get parent` (1)
- `_nodesFromRange` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5649` | Self: 0.1% (1.0ms) | Total: 0.1% (1.0ms) | Samples: 6

**Called by:**
- `_getOrBuildPlan` (6)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1679` | Self: 0.1% (1.0ms) | Total: 1.3% (11.6ms) | Samples: 6

**Called by:**
- `_buildScopeChildren` (38)
- `_precomputeScopes` (31)

**Calls:**
- `_computeIsStrict` (23)
- `_computeIsStrict` (22)
- `_computeIsStrict` (10)
- `_computeIsStrict` (3)
- `_computeIsStrict` (3)
- `_computeIsStrict` (2)

### `_isSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4029` | Self: 0.1% (1.0ms) | Total: 0.1% (1.2ms) | Samples: 6

**Called by:**
- `buildVisitorMap` (7)

**Calls:**
- `endsWith` (1)

### `isUnderscored`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:105` | Self: 0.1% (1.0ms) | Total: 0.1% (1.2ms) | Samples: 6

**Called by:**
- `isGoodName` (7)

**Calls:**
- `toUpperCase` (1)

### `propertyIsEnumerable`
`[native code]` | Self: 0.1% (1.0ms) | Total: 0.1% (1.0ms) | Samples: 6

**Called by:**
- `_deepMergeObjects` (6)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5735` | Self: 0.1% (1.0ms) | Total: 0.1% (1.0ms) | Samples: 6

**Called by:**
- `_getOrBuildPlan` (6)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:802` | Self: 0.1% (1.0ms) | Total: 0.3% (2.8ms) | Samples: 5

**Called by:**
- `_buildThinVariable` (10)
- `_buildVariable` (4)
- `_ensureDeclSymIndex` (2)

**Calls:**
- `_buildSymNameCache` (5)
- `_buildSymNameCache` (3)
- `_buildSymNameCache` (1)
- `_buildSymNameCache` (1)
- `_buildSymNameCache` (1)

### `test`
`[native code]` | Self: 0.1% (1.0ms) | Total: 0.1% (1.0ms) | Samples: 6

**Called by:**
- `_buildScopeVarsAndSet` (4)
- `getUpperFunction` (1)
- `_isSelector` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:497` | Self: 0.1% (1.0ms) | Total: 0.2% (1.9ms) | Samples: 5

**Called by:**
- `parseSource` (9)
- `runPlugins` (1)

**Calls:**
- `Uint32Array` (5)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2893` | Self: 0.1% (1.0ms) | Total: 0.2% (1.8ms) | Samples: 6

**Called by:**
- `_buildReference` (8)
- `_buildThinScope` (2)
- `_buildVariable` (1)

**Calls:**
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4002` | Self: 0.1% (1.0ms) | Total: 0.1% (1.0ms) | Samples: 6

**Called by:**
- `get parent` (2)
- `_buildReference` (2)
- `get body` (1)
- `_nodesFromRange` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1255` | Self: 0.1% (1.0ms) | Total: 0.3% (3.2ms) | Samples: 6

**Called by:**
- `_buildReference` (7)
- `isInLoop` (4)
- `_computeIsStrict` (2)
- `_findDefNode` (2)
- `_findDefNode` (2)
- `checkGroup` (1)
- `equalsToOriginalName` (1)
- `_buildThinVariable` (1)

**Calls:**
- `get _tag` (8)
- `get _tag` (6)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5642` | Self: 0.1% (1.0ms) | Total: 0.1% (1.0ms) | Samples: 6

**Called by:**
- `_getOrBuildPlan` (6)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2191` | Self: 0.1% (986us) | Total: 0.1% (986us) | Samples: 6

**Called by:**
- `ensureRefsThrough` (6)

### `_lineStarts`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:611` | Self: 0.1% (986us) | Total: 0.1% (986us) | Samples: 6

**Called by:**
- `getLocFromIndex` (2)
- `_findLineIdx` (1)
- `get loc` (1)
- `_makeToken` (1)
- `commentsInRange` (1)

### `forEach`
`[native code]` | Self: 0.1% (982us) | Total: 2.4% (20.9ms) | Samples: 5

**Called by:**
- `checkReferencesInScope` (29)
- `getFunctionDefinitions` (18)
- `checkReferencesInScope` (18)
- `Program:exit` (18)
- `checkForFunction` (15)
- `checkVariable` (14)
- `checkGroup` (7)
- `checkGroup` (1)
- `(anonymous)` (1)
- `bound call` (1)

**Calls:**
- `checkReferencesInScope` (19)
- `checkVariable` (14)
- `(anonymous)` (13)
- `checkReferencesInScope` (9)
- `(anonymous)` (9)
- `checkReference` (7)
- `(anonymous)` (7)
- `checkGroup` (7)
- `checkReference` (4)
- `(anonymous)` (4)
- `checkGroup` (3)
- `(anonymous)` (2)
- `checkGroup` (2)
- `checkGroup` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `checkReference` (1)
- `checkReference` (1)
- `(anonymous)` (1)
- `checkVariable` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `checkGroup` (1)
- `(anonymous)` (1)
- `checkGroup` (1)
- `checkGroup` (1)
- `(anonymous)` (1)
- `checkReference` (1)

### `_getSelectorRootTypes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5597` | Self: 0.1% (979us) | Total: 0.1% (1.4ms) | Samples: 6

**Called by:**
- `_getSelectorRootTypes` (7)
- `_getOrBuildSelectorPlan` (2)

**Calls:**
- `trim` (2)
- `/:([a-z-]+)\([^)]*\)/g` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3546` | Self: 0.1% (970us) | Total: 0.1% (970us) | Samples: 6

**Called by:**
- `getNameRange` (2)
- `get value` (1)
- `isFunctionNameInitializerException` (1)
- `(anonymous)` (1)
- `getFirstToken` (1)

### `Uint16Array`
`[native code]` | Self: 0.1% (969us) | Total: 0.1% (969us) | Samples: 6

**Called by:**
- `AstView` (3)
- `AstView` (2)
- `_buildPlan` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1684` | Self: 0.1% (965us) | Total: 0.1% (965us) | Samples: 6

**Called by:**
- `_invokeFused` (6)

### `iterateDeclarations`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:61` | Self: 0.1% (950us) | Total: 0.1% (950us) | Samples: 6

**Called by:**
- `generatorResume` (6)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1999` | Self: 0.1% (948us) | Total: 0.1% (1.1ms) | Samples: 6

**Called by:**
- `ensureVarsSet` (7)

**Calls:**
- `push` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6538` | Self: 0.1% (934us) | Total: 0.1% (934us) | Samples: 6

**Called by:**
- `runPlugins` (6)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2845` | Self: 0.1% (920us) | Total: 0.2% (1.9ms) | Samples: 5

**Called by:**
- `_buildScopeRefsAndThrough` (7)
- `_buildVariable` (4)

**Calls:**
- `get type` (5)
- `get local` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:959` | Self: 0.1% (915us) | Total: 0.1% (1.2ms) | Samples: 5

**Called by:**
- `Program:exit` (7)

**Calls:**
- `hasRestSpreadSibling` (1)
- `hasRestSpreadSibling` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3594` | Self: 0.1% (898us) | Total: 0.2% (1.7ms) | Samples: 5

**Called by:**
- `isInRange` (2)
- `getNameRange` (2)
- `isInside` (1)
- `(anonymous)` (1)
- `_buildVariable` (1)
- `get value` (1)
- `getFirstTokenBetween` (1)
- `isFunctionNameInitializerException` (1)

**Calls:**
- `get start` (4)
- `get start` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:440` | Self: 0.1% (882us) | Total: 0.1% (1.0ms) | Samples: 5

**Called by:**
- `_buildThinVariable` (3)
- `_buildVariable` (3)

**Calls:**
- `get parent` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6539` | Self: 0.1% (876us) | Total: 0.1% (876us) | Samples: 5

**Called by:**
- `runPlugins` (5)

### `runOnce`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:96` | Self: 0.0% (869us) | Total: 0.0% (869us) | Samples: 5

**Called by:**
- `(anonymous)` (4)
- `(anonymous)` (1)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4823` | Self: 0.0% (866us) | Total: 0.0% (866us) | Samples: 5

**Called by:**
- `_buildPlan` (5)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6817` | Self: 0.0% (866us) | Total: 0.0% (866us) | Samples: 5

**Called by:**
- `runPlugins` (5)

### `defToVariableType`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:204` | Self: 0.0% (865us) | Total: 0.0% (865us) | Samples: 4

**Called by:**
- `getDefinedMessageData` (2)
- `getAssignedMessageData` (2)

### `iterateDeclarations`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:68` | Self: 0.0% (865us) | Total: 0.0% (865us) | Samples: 5

**Called by:**
- `generatorResume` (4)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2832` | Self: 0.0% (860us) | Total: 0.0% (860us) | Samples: 5

**Called by:**
- `_buildVariable` (3)
- `_buildScopeRefsAndThrough` (2)

### `isFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:152` | Self: 0.0% (858us) | Total: 0.3% (2.7ms) | Samples: 5

**Called by:**
- `isInLoop` (15)
- `collectUnusedVariables` (2)

**Calls:**
- `get type` (3)
- `get type` (3)
- `get type` (2)
- `get type` (1)
- `get type` (1)
- `get type` (1)
- `get type` (1)

### `_resolveUnicodeEscapes`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:226` | Self: 0.0% (857us) | Total: 0.0% (857us) | Samples: 5

**Called by:**
- `get name` (4)
- `_buildScopeRefsAndThrough` (1)

### `DataView`
`[native code]` | Self: 0.0% (857us) | Total: 0.0% (857us) | Samples: 5

**Called by:**
- `parseSource` (3)
- `parseSource` (1)
- `AstView` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6612` | Self: 0.0% (855us) | Total: 0.0% (855us) | Samples: 5

**Called by:**
- `runPlugins` (5)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1994` | Self: 0.0% (846us) | Total: 0.0% (846us) | Samples: 5

**Called by:**
- `ensureVarsSet` (5)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` | Self: 0.0% (845us) | Total: 0.4% (3.9ms) | Samples: 5

**Called by:**
- `isUsedVariable` (23)

**Calls:**
- `forEach` (18)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6969` | Self: 0.0% (844us) | Total: 0.0% (844us) | Samples: 5

**Called by:**
- `runPlugins` (5)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3991` | Self: 0.0% (839us) | Total: 0.0% (839us) | Samples: 4

**Called by:**
- `get parent` (4)

### `_resolveHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (833us) | Total: 0.0% (833us) | Samples: 5

**Called by:**
- `walkNodes` (3)
- `walkNodes` (2)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (832us) | Total: 0.0% (832us) | Samples: 5

**Called by:**
- `_buildPlan` (5)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5290` | Self: 0.0% (827us) | Total: 0.0% (827us) | Samples: 5

**Called by:**
- `walkNodes` (5)

### `_applySchemaDefaults`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:169` | Self: 0.0% (827us) | Total: 0.0% (827us) | Samples: 5

**Called by:**
- `buildVisitorMap` (5)

### `getUint32`
`[native code]` | Self: 0.0% (825us) | Total: 0.0% (825us) | Samples: 5

**Called by:**
- `AstView` (1)
- `AstView` (1)
- `AstView` (1)
- `get key` (1)
- `AstView` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7322` | Self: 0.0% (821us) | Total: 0.1% (978us) | Samples: 4

**Called by:**
- `runOnce` (5)

**Calls:**
- `AstView` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5901` | Self: 0.0% (799us) | Total: 0.1% (955us) | Samples: 5

**Called by:**
- `runPlugins` (6)

**Calls:**
- `get nodeTags` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4232` | Self: 0.0% (792us) | Total: 0.2% (2.2ms) | Samples: 5

**Called by:**
- `runPlugins` (14)

**Calls:**
- `entries` (9)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2797` | Self: 0.0% (787us) | Total: 0.0% (787us) | Samples: 5

**Called by:**
- `_buildVariable` (3)
- `_buildScopeRefsAndThrough` (2)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1888` | Self: 0.0% (769us) | Total: 21.6% (188.3ms) | Samples: 5

**Called by:**
- `_precomputeScopes` (812)
- `_buildScopeRefsAndThrough` (281)
- `ensureRefsThrough` (21)
- `_precomputeScopes` (5)

**Calls:**
- `ensureRefsThrough` (979)
- `ensureRefsThrough` (113)
- `ensureRefsThrough` (21)
- `ensureRefsThrough` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:865` | Self: 0.0% (769us) | Total: 0.0% (769us) | Samples: 5

**Called by:**
- `get body` (3)
- `get body` (1)
- `checkGroup` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:433` | Self: 0.0% (762us) | Total: 0.1% (927us) | Samples: 4

**Called by:**
- `parseSource` (5)

**Calls:**
- `Uint32Array` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1175` | Self: 0.0% (753us) | Total: 0.0% (753us) | Samples: 4

**Called by:**
- `_findDefNode` (1)
- `shouldCheck` (1)
- `collectUnusedVariables` (1)
- `_buildVariable` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6729` | Self: 0.0% (749us) | Total: 0.0% (749us) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6727` | Self: 0.0% (741us) | Total: 0.1% (1.0ms) | Samples: 4

**Called by:**
- `runPlugins` (6)

**Calls:**
- `Uint8Array` (2)

### `isInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:53` | Self: 0.0% (729us) | Total: 0.1% (1.2ms) | Samples: 4

**Called by:**
- `isEvaluatedDuringInitialization` (4)
- `isEvaluatedDuringInitialization` (2)
- `(anonymous)` (1)

**Calls:**
- `get range` (2)
- `get range` (1)

### `regExpMatchFast`
`[native code]` | Self: 0.0% (728us) | Total: 0.0% (728us) | Samples: 4

**Called by:**
- `_buildScopeVarsAndSet` (4)

### `get allSkipped`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (727us) | Total: 0.0% (727us) | Samples: 3

**Called by:**
- `walkNodes` (3)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:395` | Self: 0.0% (724us) | Total: 0.6% (6.0ms) | Samples: 4

**Called by:**
- `_buildVariable` (26)
- `_buildThinVariable` (9)

**Calls:**
- `get parent` (11)
- `get parent` (6)
- `get parent` (5)
- `get parent` (3)
- `get parent` (2)
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)

### `fetch`
`[native code]` | Self: 0.0% (722us) | Total: 0.0% (722us) | Samples: 4

**Called by:**
- `requestFetch` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6633` | Self: 0.0% (720us) | Total: 0.1% (1.3ms) | Samples: 4

**Called by:**
- `runPlugins` (8)

**Calls:**
- `next` (4)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:511` | Self: 0.0% (714us) | Total: 0.2% (2.1ms) | Samples: 4

**Called by:**
- `runPlugins` (11)
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `decode` (8)

### `findVariablesInScope`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:96` | Self: 0.0% (706us) | Total: 0.1% (1.4ms) | Samples: 3

**Called by:**
- `Program` (7)

**Calls:**
- `iterateDeclarations` (3)
- `iterateDeclarations` (1)

### `push`
`[native code]` | Self: 0.0% (703us) | Total: 0.0% (703us) | Samples: 4

**Called by:**
- `_buildScopeVarsAndSet` (1)
- `Program:exit` (1)
- `_execReport` (1)
- `_extractFileLevelRules` (1)

### `_isSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4025` | Self: 0.0% (702us) | Total: 0.1% (1.0ms) | Samples: 4

**Called by:**
- `buildVisitorMap` (6)

**Calls:**
- `endsWith` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6726` | Self: 0.0% (699us) | Total: 0.0% (870us) | Samples: 4

**Called by:**
- `runPlugins` (5)

**Calls:**
- `Uint8Array` (1)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:809` | Self: 0.0% (697us) | Total: 0.0% (839us) | Samples: 4

**Called by:**
- `_symName` (5)

**Calls:**
- `get source` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6824` | Self: 0.0% (691us) | Total: 0.0% (691us) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2514` | Self: 0.0% (691us) | Total: 0.0% (691us) | Samples: 3

**Called by:**
- `getDeclaredVariables` (2)
- `_buildScopeVarsAndSet` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` | Self: 0.0% (690us) | Total: 0.0% (690us) | Samples: 4

**Called by:**
- `(anonymous)` (2)
- `ke` (2)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5249` | Self: 0.0% (689us) | Total: 0.0% (832us) | Samples: 4

**Called by:**
- `walkNodes` (5)

**Calls:**
- `fill` (1)

### `_deepMergeObjects`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:129` | Self: 0.0% (688us) | Total: 0.1% (882us) | Samples: 4

**Called by:**
- `map` (5)

**Calls:**
- `_deepMergeObjects` (1)

### `_makeSafeHandler`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3818` | Self: 0.0% (683us) | Total: 0.0% (683us) | Samples: 4

**Called by:**
- `buildVisitorMap` (4)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4199` | Self: 0.0% (680us) | Total: 1.0% (9.3ms) | Samples: 4

**Called by:**
- `runPlugins` (51)

**Calls:**
- `_deepMergeArrays` (33)
- `_deepMergeArrays` (9)
- `_deepMergeArrays` (5)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3791` | Self: 0.0% (676us) | Total: 0.0% (676us) | Samples: 4

**Called by:**
- `report` (4)

### `runOnce`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:87` | Self: 0.0% (675us) | Total: 12.3% (107.6ms) | Samples: 4

**Called by:**
- `(anonymous)` (360)
- `(anonymous)` (271)

**Calls:**
- `parseSource` (323)
- `parseSource` (269)
- `parseSource` (24)
- `parseSource` (6)
- `parseSource` (3)
- `parseSource` (1)
- `parseSource` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4205` | Self: 0.0% (673us) | Total: 0.0% (819us) | Samples: 4

**Called by:**
- `runPlugins` (5)

**Calls:**
- `create` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6411` | Self: 0.0% (670us) | Total: 0.0% (670us) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3999` | Self: 0.0% (660us) | Total: 0.0% (660us) | Samples: 3

**Called by:**
- `get body` (1)
- `_buildThinVariable` (1)
- `_fireCfgEvents` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1886` | Self: 0.0% (655us) | Total: 10.8% (94.2ms) | Samples: 4

**Called by:**
- `_buildScopeRefsAndThrough` (541)
- `getVariableByName` (18)

**Calls:**
- `ensureVarsSet` (553)
- `ensureVarsSet` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6610` | Self: 0.0% (655us) | Total: 0.1% (968us) | Samples: 4

**Called by:**
- `runPlugins` (6)

**Calls:**
- `Uint8Array` (2)

### `_deepMergeArrays`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:136` | Self: 0.0% (653us) | Total: 0.6% (5.4ms) | Samples: 4

**Called by:**
- `buildVisitorMap` (33)

**Calls:**
- `map` (29)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5713` | Self: 0.0% (652us) | Total: 0.0% (652us) | Samples: 4

**Called by:**
- `_getOrBuildPlan` (4)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (651us) | Total: 0.0% (651us) | Samples: 4

**Called by:**
- `ensureVarsSet` (4)

### `_deepMergeArrays`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:137` | Self: 0.0% (649us) | Total: 0.0% (828us) | Samples: 4

**Called by:**
- `buildVisitorMap` (5)

**Calls:**
- `slice` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` | Self: 0.0% (647us) | Total: 0.1% (981us) | Samples: 4

**Called by:**
- `Program:exit` (3)
- `collectUnusedVariables` (3)

**Calls:**
- `get type` (1)
- `get type` (1)

### `_parseDisableDirectives`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7412` | Self: 0.0% (647us) | Total: 0.0% (811us) | Samples: 4

**Called by:**
- `applyDisableDirectives` (5)

**Calls:**
- `includes` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6541` | Self: 0.0% (647us) | Total: 0.0% (647us) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `runOnce`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:101` | Self: 0.0% (646us) | Total: 0.4% (3.9ms) | Samples: 4

**Called by:**
- `(anonymous)` (14)
- `(anonymous)` (10)

**Calls:**
- `applyDisableDirectives` (13)
- `filter` (6)
- `applyDisableDirectives` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1330` | Self: 0.0% (643us) | Total: 0.0% (816us) | Samples: 4

**Called by:**
- `_buildScopeRefsAndThrough` (2)
- `equalsToOriginalName` (1)
- `collectUnusedVariables` (1)
- `getStaticPropertyName` (1)

**Calls:**
- `get source` (1)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:510` | Self: 0.0% (638us) | Total: 0.0% (638us) | Samples: 4

**Called by:**
- `runPlugins` (2)
- `get name` (1)
- `_buildSymNameCache` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7082` | Self: 0.0% (636us) | Total: 0.0% (636us) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2859` | Self: 0.0% (624us) | Total: 0.0% (624us) | Samples: 4

**Called by:**
- `_buildReference` (4)

### `_getSelectorRootTypes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5593` | Self: 0.0% (622us) | Total: 0.5% (5.0ms) | Samples: 4

**Called by:**
- `_getSelectorRootTypes` (27)
- `_getOrBuildSelectorPlan` (2)
- `_buildPlan` (1)

**Calls:**
- `stringSplitFast` (21)
- `trim` (3)
- `/\[[^\]]*\]/g` (2)

### `_applySchemaDefaults`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:161` | Self: 0.0% (619us) | Total: 0.0% (619us) | Samples: 4

**Called by:**
- `buildVisitorMap` (4)

### `async loadAndEvaluateModule`
`[native code]` | Self: 0.0% (615us) | Total: 0.3% (3.2ms) | Samples: 1

**Called by:**
- `async loadAndEvaluateModule` (4)

**Calls:**
- `async loadAndEvaluateModule` (4)
- `async loadModule` (3)
- `moduleEvaluation` (1)

### `/^_+\|_+$/gu`
`[native code]` | Self: 0.0% (610us) | Total: 0.0% (610us) | Samples: 4

**Called by:**
- `isUnderscored` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6833` | Self: 0.0% (598us) | Total: 0.1% (1.4ms) | Samples: 4

**Called by:**
- `runPlugins` (9)

**Calls:**
- `has` (5)

### `readFileSync`
`[native code]` | Self: 0.0% (587us) | Total: 0.1% (1.1ms) | Samples: 3

**Called by:**
- `(anonymous)` (3)
- `readFileSync` (3)

**Calls:**
- `readFileSync` (3)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (581us) | Total: 0.0% (581us) | Samples: 3

**Called by:**
- `_getOrBuildPlan` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6621` | Self: 0.0% (579us) | Total: 0.0% (579us) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `_isSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4033` | Self: 0.0% (578us) | Total: 0.1% (966us) | Samples: 3

**Called by:**
- `buildVisitorMap` (5)

**Calls:**
- `test` (1)
- `/[\s\[>~+.(]/` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6757` | Self: 0.0% (574us) | Total: 0.0% (574us) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2319` | Self: 0.0% (574us) | Total: 0.0% (574us) | Samples: 4

**Called by:**
- `ensureRefsThrough` (4)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4554` | Self: 0.0% (570us) | Total: 27.3% (237.5ms) | Samples: 3

**Called by:**
- `walkNodes` (981)
- `walkNodes` (366)

**Calls:**
- `Program:exit` (406)
- `Program:exit` (243)
- `Program:exit` (128)
- `Program` (88)
- `Program` (72)
- `Program:exit` (56)
- `VariableDeclaration` (45)
- `Program:exit` (38)
- `checkForFunction` (37)
- `Program` (30)
- `Program` (26)
- `BinaryExpression` (19)
- `Program` (19)
- `checkLastSegment` (13)
- `Program:exit` (13)
- `Program:exit` (10)
- `VariableDeclaration` (10)
- `Program` (7)
- `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause` (7)
- `BinaryExpression` (6)
- `checkLastSegment` (6)
- `Program:exit` (6)
- `checkLastSegment` (5)
- `ReturnStatement` (5)
- `Program:exit` (5)
- `Program` (5)
- `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause` (4)
- `Program` (4)
- `Program:exit` (4)
- `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause` (4)
- `checkForBlock` (3)
- `checkLastSegment` (3)
- `Program:exit` (2)
- `ImportDeclaration` (1)
- `Program` (1)
- `Program:exit` (1)
- `ImportDeclaration` (1)
- `ReturnStatement` (1)
- `checkForBlock` (1)
- `ReturnStatement` (1)
- `checkLastSegment` (1)
- `BinaryExpression` (1)
- `checkLastSegment` (1)
- `checkLastSegment` (1)
- `BinaryExpression` (1)
- `Program:exit` (1)
- `ImportDeclaration` (1)
- `checkLastSegment` (1)

### `newRegistryEntry`
`[native code]` | Self: 0.0% (566us) | Total: 0.0% (566us) | Samples: 1

**Called by:**
- `ensureRegistered` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7365` | Self: 0.0% (562us) | Total: 0.0% (562us) | Samples: 3

**Called by:**
- `runOnce` (3)

### `get left`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1754` | Self: 0.0% (562us) | Total: 0.0% (562us) | Samples: 3

**Called by:**
- `getIdentifierIfShouldBeConst` (1)
- `getIdentifierIfShouldBeConst` (1)
- `isReadForItself` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4133` | Self: 0.0% (559us) | Total: 0.0% (559us) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:76` | Self: 0.0% (553us) | Total: 0.0% (553us) | Samples: 3

**Called by:**
- `buildVisitorMap` (3)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1696` | Self: 0.0% (539us) | Total: 0.0% (539us) | Samples: 2

**Called by:**
- `_precomputeScopes` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4000` | Self: 0.0% (538us) | Total: 0.0% (538us) | Samples: 3

**Called by:**
- `_fireCfgEvents` (1)
- `isModifyingProp` (1)
- `_buildReference` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1961` | Self: 0.0% (537us) | Total: 2.4% (21.0ms) | Samples: 3

**Called by:**
- `ensureVarsSet` (118)
- `ensureVarsSet` (2)

**Calls:**
- `_buildVariable` (49)
- `_buildVariable` (20)
- `_buildVariable` (9)
- `_buildVariable` (8)
- `_buildVariable` (7)
- `_buildVariable` (4)
- `_buildVariable` (3)
- `_buildVariable` (2)
- `_buildVariable` (2)
- `_buildVariable` (2)
- `_buildVariable` (2)
- `_buildVariable` (1)
- `_buildVariable` (1)
- `_buildVariable` (1)
- `_buildVariable` (1)
- `_buildVariable` (1)
- `_buildVariable` (1)
- `_buildVariable` (1)
- `_buildVariable` (1)
- `_buildVariable` (1)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1501` | Self: 0.0% (537us) | Total: 17.9% (155.9ms) | Samples: 3

**Called by:**
- `Program:exit` (403)
- `Program` (278)
- `Program:exit` (125)
- `Program` (87)
- `Program` (30)

**Calls:**
- `_precomputeScopes` (812)
- `_precomputeScopes` (93)
- `_precomputeScopes` (6)
- `_precomputeScopes` (6)
- `_precomputeScopes` (1)
- `_precomputeScopes` (1)
- `_precomputeScopes` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (536us) | Total: 0.0% (536us) | Samples: 3

**Called by:**
- `_buildScopeVarsAndSet` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7097` | Self: 0.0% (534us) | Total: 20.2% (176.3ms) | Samples: 3

**Called by:**
- `runPlugins` (994)

**Calls:**
- `_invokeFused` (981)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_invokeFused` (1)

### `iterateDeclarations`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:59` | Self: 0.0% (533us) | Total: 0.0% (533us) | Samples: 3

**Called by:**
- `findVariablesInScope` (3)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4176` | Self: 0.0% (530us) | Total: 0.0% (530us) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (530us) | Total: 0.0% (530us) | Samples: 3

**Called by:**
- `_buildScopeRefsAndThrough` (2)
- `_buildVariable` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3067` | Self: 0.0% (530us) | Total: 0.0% (530us) | Samples: 3

**Called by:**
- `ImportDeclaration` (1)
- `checkForFunction` (1)
- `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause` (1)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:828` | Self: 0.0% (529us) | Total: 0.0% (529us) | Samples: 3

**Called by:**
- `_symName` (3)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1855` | Self: 0.0% (529us) | Total: 0.7% (6.4ms) | Samples: 3

**Called by:**
- `_buildScopeChildren` (21)
- `_precomputeScopes` (18)

**Calls:**
- `Set` (36)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` | Self: 0.0% (529us) | Total: 0.9% (8.3ms) | Samples: 3

**Called by:**
- `Program:exit` (32)
- `collectUnusedVariables` (14)

**Calls:**
- `get` (37)
- `get` (4)
- `get` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` | Self: 0.0% (527us) | Total: 0.0% (527us) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:308` | Self: 0.0% (526us) | Total: 0.1% (1.1ms) | Samples: 3

**Called by:**
- `parseSource` (7)

**Calls:**
- `Uint32Array` (4)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4176` | Self: 0.0% (525us) | Total: 0.0% (525us) | Samples: 3

**Called by:**
- `AstView` (3)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2887` | Self: 0.0% (525us) | Total: 0.4% (4.1ms) | Samples: 3

**Called by:**
- `_buildReference` (22)
- `_buildThinScope` (3)

**Calls:**
- `_findDefNode` (9)
- `_findDefNode` (3)
- `_findDefNode` (3)
- `_findDefNode` (2)
- `_findDefNode` (1)
- `_findDefNode` (1)
- `_findDefNode` (1)
- `_findDefNode` (1)
- `_findDefNode` (1)

### `runOnce`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:92` | Self: 0.0% (525us) | Total: 83.6% (727.7ms) | Samples: 3

**Called by:**
- `(anonymous)` (2269)
- `(anonymous)` (1954)

**Calls:**
- `runPlugins` (3838)
- `runPlugins` (317)
- `runPlugins` (46)
- `runPlugins` (5)
- `runPlugins` (4)
- `runPlugins` (3)
- `runPlugins` (3)
- `runPlugins` (2)
- `runPlugins` (1)
- `runPlugins` (1)

### `get byteLength`
`[native code]` | Self: 0.0% (525us) | Total: 0.0% (525us) | Samples: 3

**Called by:**
- `AstView` (2)
- `ensureBufferBytes` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1067` | Self: 0.0% (525us) | Total: 0.0% (525us) | Samples: 3

**Called by:**
- `equalsToOriginalName` (1)
- `fn` (1)
- `report` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6532` | Self: 0.0% (524us) | Total: 0.0% (524us) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6949` | Self: 0.0% (524us) | Total: 0.0% (524us) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:352` | Self: 0.0% (521us) | Total: 0.0% (661us) | Samples: 3

**Called by:**
- `parseSource` (4)

**Calls:**
- `Uint32Array` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1962` | Self: 0.0% (521us) | Total: 0.0% (521us) | Samples: 3

**Called by:**
- `ensureVarsSet` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6822` | Self: 0.0% (520us) | Total: 0.0% (520us) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `Program`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:275` | Self: 0.0% (520us) | Total: 0.3% (3.1ms) | Samples: 3

**Called by:**
- `_invokeFused` (19)

**Calls:**
- `isGoodName` (16)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7351` | Self: 0.0% (520us) | Total: 0.0% (520us) | Samples: 3

**Called by:**
- `runOnce` (3)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2337` | Self: 0.0% (520us) | Total: 2.3% (20.0ms) | Samples: 3

**Called by:**
- `ensureChildren` (116)

**Calls:**
- `_buildScope` (38)
- `_buildScope` (30)
- `_buildScope` (21)
- `_buildScope` (6)
- `_buildScope` (4)
- `_buildScope` (4)
- `_buildScope` (4)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `get mainToken`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1089` | Self: 0.0% (518us) | Total: 0.0% (518us) | Samples: 3

**Called by:**
- `get name` (3)

### `parseModule`
`[native code]` | Self: 0.0% (515us) | Total: 99.6% (867.1ms) | Samples: 3

**Called by:**
- `async (anonymous)` (5041)

**Calls:**
- `(anonymous)` (2644)
- `(anonymous)` (2243)
- `(anonymous)` (66)
- `(anonymous)` (24)
- `(anonymous)` (19)
- `(anonymous)` (17)
- `(anonymous)` (11)
- `(anonymous)` (7)
- `(anonymous)` (6)
- `(anonymous)` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4034` | Self: 0.0% (513us) | Total: 0.0% (513us) | Samples: 3

**Called by:**
- `_fireCfgEvents` (1)
- `get parent` (1)
- `invokeSelectorHandlers` (1)

### `_compileSelectorFastMatcher`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5114` | Self: 0.0% (512us) | Total: 0.0% (512us) | Samples: 3

**Called by:**
- `_getOrBuildSelectorPlan` (3)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2774` | Self: 0.0% (512us) | Total: 0.0% (512us) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:305` | Self: 0.0% (511us) | Total: 0.0% (854us) | Samples: 3

**Called by:**
- `parseSource` (5)

**Calls:**
- `Uint8Array` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6412` | Self: 0.0% (510us) | Total: 0.0% (510us) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2494` | Self: 0.0% (509us) | Total: 0.0% (509us) | Samples: 3

**Called by:**
- `_buildScopeVarsAndSet` (3)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1716` | Self: 0.0% (509us) | Total: 0.3% (2.6ms) | Samples: 3

**Called by:**
- `_computeIsStrict` (14)
- `_computeIsStrict` (1)
- `isEvaluatedDuringInitialization` (1)

**Calls:**
- `_nodesFromRange` (12)
- `_nodesFromRange` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1548` | Self: 0.0% (508us) | Total: 0.0% (508us) | Samples: 3

**Called by:**
- `_buildScope` (2)
- `equalsToOriginalName` (1)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4874` | Self: 0.0% (507us) | Total: 0.0% (507us) | Samples: 3

**Called by:**
- `_buildPlan` (3)

### `_makeBoundReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3802` | Self: 0.0% (504us) | Total: 0.0% (504us) | Samples: 3

**Called by:**
- `buildVisitorMap` (3)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:461` | Self: 0.0% (503us) | Total: 0.1% (1.0ms) | Samples: 3

**Called by:**
- `parseSource` (6)

**Calls:**
- `Uint32Array` (3)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1274` | Self: 0.0% (498us) | Total: 0.0% (670us) | Samples: 3

**Called by:**
- `_buildReference` (2)
- `_findDefNode` (2)

**Calls:**
- `get _tag` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1997` | Self: 0.0% (497us) | Total: 2.7% (24.2ms) | Samples: 3

**Called by:**
- `ensureVarsSet` (138)

**Calls:**
- `_mkGlobalVar` (116)
- `_mkGlobalVar` (19)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7136` | Self: 0.0% (497us) | Total: 0.0% (497us) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:423` | Self: 0.0% (496us) | Total: 0.0% (812us) | Samples: 3

**Called by:**
- `_buildVariable` (3)
- `_buildThinVariable` (2)

**Calls:**
- `get _tag` (1)
- `get _tag` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2553` | Self: 0.0% (494us) | Total: 1.1% (9.9ms) | Samples: 3

**Called by:**
- `_buildScopeVarsAndSet` (49)
- `getDeclaredVariables` (9)

**Calls:**
- `_findDefNode` (26)
- `_findDefNode` (11)
- `_findDefNode` (4)
- `_findDefNode` (3)
- `_findDefNode` (3)
- `_findDefNode` (3)
- `_findDefNode` (3)
- `_findDefNode` (1)
- `_findDefNode` (1)

### `get start`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1092` | Self: 0.0% (494us) | Total: 0.0% (494us) | Samples: 3

**Called by:**
- `_execReport` (1)
- `get range` (1)
- `_execReport` (1)

### `get init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2907` | Self: 0.0% (493us) | Total: 0.0% (493us) | Samples: 3

**Called by:**
- `(anonymous)` (2)
- `(anonymous)` (1)

### `Map`
`[native code]` | Self: 0.0% (493us) | Total: 0.0% (493us) | Samples: 3

**Called by:**
- `_buildTemplate` (2)
- `getDeclaredVariables` (1)

### `mainToken`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1089` | Self: 0.0% (491us) | Total: 0.0% (491us) | Samples: 2

**Called by:**
- `get name` (1)
- `get value` (1)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:180` | Self: 0.0% (491us) | Total: 0.4% (3.9ms) | Samples: 3

**Called by:**
- `getRhsNode` (24)

**Calls:**
- `get parent` (7)
- `get parent` (5)
- `get parent` (4)
- `get parent` (3)
- `get parent` (1)
- `get parent` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6558` | Self: 0.0% (489us) | Total: 0.0% (489us) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5656` | Self: 0.0% (488us) | Total: 0.0% (624us) | Samples: 3

**Called by:**
- `_getOrBuildPlan` (4)

**Calls:**
- `get` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:474` | Self: 0.0% (487us) | Total: 0.0% (782us) | Samples: 3

**Called by:**
- `parseSource` (5)

**Calls:**
- `Uint32Array` (2)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1887` | Self: 0.0% (487us) | Total: 0.0% (487us) | Samples: 3

**Called by:**
- `checkReferencesInScope` (3)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:126` | Self: 0.0% (487us) | Total: 0.0% (487us) | Samples: 3

**Called by:**
- `buildVisitorMap` (3)

### `includes`
`[native code]` | Self: 0.0% (486us) | Total: 0.0% (486us) | Samples: 3

**Called by:**
- `_extractBatchScannable` (1)
- `_parseDisableDirectives` (1)
- `buildVisitorMap` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1663` | Self: 0.0% (482us) | Total: 0.0% (680us) | Samples: 3

**Called by:**
- `_buildScopeChildren` (4)

**Calls:**
- `_nodeViewRaw` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6529` | Self: 0.0% (478us) | Total: 0.0% (478us) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2281` | Self: 0.0% (478us) | Total: 5.4% (47.0ms) | Samples: 3

**Called by:**
- `ensureRefsThrough` (285)

**Calls:**
- `get` (281)
- `get` (1)

### `_getOrBuildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5441` | Self: 0.0% (478us) | Total: 0.0% (478us) | Samples: 3

**Called by:**
- `walkNodes` (3)

### `isClassRefInClassDecorator`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:254` | Self: 0.0% (471us) | Total: 0.0% (471us) | Samples: 3

**Called by:**
- `shouldCheck` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6460` | Self: 0.0% (468us) | Total: 0.0% (468us) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4226` | Self: 0.0% (468us) | Total: 1.0% (9.1ms) | Samples: 3

**Called by:**
- `runPlugins` (54)

**Calls:**
- `create` (12)
- `create` (9)
- `create` (3)
- `create` (3)
- `create` (2)
- `create` (2)
- `create` (2)
- `create` (2)
- `create` (1)
- `create` (1)
- `create` (1)
- `create` (1)
- `create` (1)
- `create` (1)
- `create` (1)
- `create` (1)
- `create` (1)
- `create` (1)
- `create` (1)
- `create` (1)
- `create` (1)
- `create` (1)
- `create` (1)
- `create` (1)

### `getDestructuringHost`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:103` | Self: 0.0% (467us) | Total: 0.0% (607us) | Samples: 3

**Called by:**
- `getIdentifierIfShouldBeConst` (2)
- `groupByDestructuring` (2)

**Calls:**
- `get type` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:232` | Self: 0.0% (466us) | Total: 0.1% (985us) | Samples: 3

**Called by:**
- `runOnce` (6)

**Calls:**
- `DataView` (3)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3997` | Self: 0.0% (462us) | Total: 0.0% (462us) | Samples: 3

**Called by:**
- `_buildVariable` (1)
- `get parent` (1)
- `_buildReference` (1)

### `create`
`[native code]` | Self: 0.0% (454us) | Total: 0.0% (454us) | Samples: 3

**Called by:**
- `_nodeViewRaw` (1)
- `buildVisitorMap` (1)
- `_getTypeProto` (1)

### `_deepMergeObjects`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:126` | Self: 0.0% (453us) | Total: 0.2% (1.7ms) | Samples: 3

**Called by:**
- `map` (9)
- `(anonymous)` (2)

**Calls:**
- `copyDataProperties` (7)
- `cloneObject` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3998` | Self: 0.0% (430us) | Total: 0.0% (430us) | Samples: 3

**Called by:**
- `get parent` (1)
- `_nodesFromRange` (1)
- `_buildReference` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5782` | Self: 0.0% (391us) | Total: 2.8% (24.7ms) | Samples: 2

**Called by:**
- `_getOrBuildPlan` (146)

**Calls:**
- `_buildTemplate` (48)
- `_buildTemplate` (38)
- `_buildTemplate` (26)
- `_buildTemplate` (14)
- `_buildTemplate` (8)
- `_buildTemplate` (5)
- `_buildTemplate` (2)
- `_buildTemplate` (2)
- `_buildTemplate` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7135` | Self: 0.0% (391us) | Total: 0.0% (391us) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `getDestructuringHost`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:98` | Self: 0.0% (386us) | Total: 0.0% (386us) | Samples: 2

**Called by:**
- `getIdentifierIfShouldBeConst` (2)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:332` | Self: 0.0% (384us) | Total: 0.0% (384us) | Samples: 2

**Called by:**
- `buildVisitorMap` (2)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2809` | Self: 0.0% (382us) | Total: 0.4% (3.7ms) | Samples: 2

**Called by:**
- `_buildScopeRefsAndThrough` (20)
- `_buildVariable` (2)

**Calls:**
- `_nodeViewRaw` (9)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `nodeView` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6414` | Self: 0.0% (381us) | Total: 0.0% (381us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2864` | Self: 0.0% (379us) | Total: 0.0% (379us) | Samples: 2

**Called by:**
- `_buildVariable` (1)
- `_buildReference` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2529` | Self: 0.0% (379us) | Total: 0.1% (1.3ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (8)

**Calls:**
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1038` | Self: 0.0% (379us) | Total: 0.0% (379us) | Samples: 2

**Called by:**
- `isFunction` (1)
- `report` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6634` | Self: 0.0% (379us) | Total: 0.0% (379us) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `_compileSelectorFastMatcher`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4973` | Self: 0.0% (377us) | Total: 0.0% (377us) | Samples: 2

**Called by:**
- `_compileSelectorFastMatcher` (1)
- `_getOrBuildSelectorPlan` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1048` | Self: 0.0% (375us) | Total: 0.0% (375us) | Samples: 2

**Called by:**
- `isFunction` (1)
- `isForInOfRef` (1)

### `/\/\*([\s\S]*?)\*\//g`
`[native code]` | Self: 0.0% (374us) | Total: 0.0% (374us) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `_compileAttrCheck`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5198` | Self: 0.0% (373us) | Total: 0.0% (702us) | Samples: 2

**Called by:**
- `map` (4)

**Calls:**
- `stringSplitFast` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:954` | Self: 0.0% (372us) | Total: 0.0% (685us) | Samples: 2

**Called by:**
- `Program:exit` (4)

**Calls:**
- `isExported` (1)
- `isExported` (1)

### `_extractBatchScannable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (371us) | Total: 0.0% (371us) | Samples: 2

**Called by:**
- `_buildPlan` (2)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:798` | Self: 0.0% (371us) | Total: 0.0% (529us) | Samples: 2

**Called by:**
- `getFirstTokenBetween` (2)
- `getFirstToken` (1)

**Calls:**
- `_getJsxTextTokFlags` (1)

### `_applySchemaDefaults`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:167` | Self: 0.0% (370us) | Total: 0.0% (370us) | Samples: 2

**Called by:**
- `buildVisitorMap` (2)

### `/^[A-Z][A-Za-z]*$/`
`[native code]` | Self: 0.0% (369us) | Total: 0.0% (369us) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2571` | Self: 0.0% (368us) | Total: 0.2% (1.7ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (9)
- `getDeclaredVariables` (1)

**Calls:**
- `get parent` (3)
- `get parent` (2)
- `get parent` (2)
- `get parent` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4207` | Self: 0.0% (368us) | Total: 0.0% (516us) | Samples: 2

**Called by:**
- `AstView` (3)

**Calls:**
- `Uint32Array` (1)

### `ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1816` | Self: 0.0% (368us) | Total: 12.9% (112.2ms) | Samples: 2

**Called by:**
- `get` (553)
- `get` (108)

**Calls:**
- `_buildScopeVarsAndSet` (156)
- `_buildScopeVarsAndSet` (138)
- `_buildScopeVarsAndSet` (118)
- `_buildScopeVarsAndSet` (105)
- `_buildScopeVarsAndSet` (49)
- `_buildScopeVarsAndSet` (23)
- `_buildScopeVarsAndSet` (11)
- `_buildScopeVarsAndSet` (10)
- `_buildScopeVarsAndSet` (8)
- `_buildScopeVarsAndSet` (7)
- `_buildScopeVarsAndSet` (5)
- `_buildScopeVarsAndSet` (4)
- `_buildScopeVarsAndSet` (4)
- `_buildScopeVarsAndSet` (4)
- `_buildScopeVarsAndSet` (3)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)

### `_buildTemplate`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5802` | Self: 0.0% (368us) | Total: 0.0% (368us) | Samples: 2

**Called by:**
- `_buildPlan` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7032` | Self: 0.0% (367us) | Total: 0.1% (1.0ms) | Samples: 2

**Called by:**
- `runPlugins` (6)

**Calls:**
- `_resolveHandlers` (2)
- `_resolveHandlers` (1)
- `_resolveHandlers` (1)

### `get right`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1789` | Self: 0.0% (366us) | Total: 0.0% (558us) | Samples: 2

**Called by:**
- `getRhsNode` (2)
- `areLiteralsAndSameType` (1)

**Calls:**
- `nodeRhs` (1)

### `_compileSelectorFastMatcher`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5087` | Self: 0.0% (365us) | Total: 0.0% (365us) | Samples: 2

**Called by:**
- `_compileSelectorFastMatcher` (2)

### `_resolveHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6780` | Self: 0.0% (365us) | Total: 0.0% (365us) | Samples: 2

**Called by:**
- `walkNodes` (1)
- `walkNodes` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5752` | Self: 0.0% (364us) | Total: 0.0% (364us) | Samples: 2

**Called by:**
- `_getOrBuildPlan` (2)

### `_getSelectorRootTypes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5571` | Self: 0.0% (364us) | Total: 1.2% (10.6ms) | Samples: 2

**Called by:**
- `_getOrBuildSelectorPlan` (38)
- `_buildPlan` (26)

**Calls:**
- `_getSelectorRootTypes` (27)
- `_getSelectorRootTypes` (17)
- `_getSelectorRootTypes` (7)
- `_getSelectorRootTypes` (6)
- `_getSelectorRootTypes` (4)
- `_getSelectorRootTypes` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:450` | Self: 0.0% (364us) | Total: 0.0% (536us) | Samples: 2

**Called by:**
- `parseSource` (3)

**Calls:**
- `Uint32Array` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6507` | Self: 0.0% (363us) | Total: 0.0% (516us) | Samples: 2

**Called by:**
- `walkNodes` (2)
- `walkNodes` (1)

**Calls:**
- `_dispatchSeg` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4214` | Self: 0.0% (361us) | Total: 0.1% (1.6ms) | Samples: 2

**Called by:**
- `runPlugins` (9)

**Calls:**
- `describeRule` (6)
- `describeRule` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4037` | Self: 0.0% (359us) | Total: 0.0% (359us) | Samples: 2

**Called by:**
- `get parent` (1)
- `_buildThinVariable` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2331` | Self: 0.0% (359us) | Total: 0.0% (359us) | Samples: 2

**Called by:**
- `ensureChildren` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (357us) | Total: 0.0% (357us) | Samples: 2

**Called by:**
- `_precomputeScopes` (1)
- `_buildScopeChildren` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` | Self: 0.0% (357us) | Total: 0.0% (357us) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `_compileSelectorFastMatcher`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5142` | Self: 0.0% (357us) | Total: 0.7% (6.8ms) | Samples: 2

**Called by:**
- `_getOrBuildSelectorPlan` (31)

**Calls:**
- `_compileSelectorFastMatcher` (10)
- `_compileSelectorFastMatcher` (4)
- `_compileSelectorFastMatcher` (4)
- `_compileSelectorFastMatcher` (2)
- `_compileSelectorFastMatcher` (2)
- `_compileSelectorFastMatcher` (2)
- `_compileSelectorFastMatcher` (1)
- `_compileSelectorFastMatcher` (1)
- `_compileSelectorFastMatcher` (1)
- `_compileSelectorFastMatcher` (1)
- `_compileSelectorFastMatcher` (1)

### `fn`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (357us) | Total: 0.0% (357us) | Samples: 2

**Called by:**
- `fn` (2)

### `_resolveUnicodeEscapes`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (356us) | Total: 0.0% (356us) | Samples: 1

**Called by:**
- `_buildScopeRefsAndThrough` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1205` | Self: 0.0% (355us) | Total: 0.0% (355us) | Samples: 2

**Called by:**
- `_buildThinVariable` (1)
- `collectUnusedVariables` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1596` | Self: 0.0% (353us) | Total: 0.0% (353us) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6744` | Self: 0.0% (352us) | Total: 0.0% (352us) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:366` | Self: 0.0% (351us) | Total: 0.2% (2.1ms) | Samples: 2

**Called by:**
- `parseSource` (12)

**Calls:**
- `Int32Array` (10)

### `isLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:168` | Self: 0.0% (351us) | Total: 0.1% (1.0ms) | Samples: 2

**Called by:**
- `isInLoop` (6)

**Calls:**
- `get type` (3)
- `/^(?:DoWhile\|For\|ForIn\|ForOf\|While)Statement$/u` (1)

### `slotTemplate`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5793` | Self: 0.0% (351us) | Total: 0.0% (351us) | Samples: 2

**Called by:**
- `_buildTemplate` (2)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3790` | Self: 0.0% (350us) | Total: 0.0% (350us) | Samples: 2

**Called by:**
- `report` (2)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1925` | Self: 0.0% (350us) | Total: 0.4% (3.6ms) | Samples: 2

**Called by:**
- `_buildScope` (22)

**Calls:**
- `get body` (9)
- `get body` (3)
- `get body` (2)
- `get body` (2)
- `get body` (1)
- `get body` (1)
- `get body` (1)
- `get body` (1)

### `ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1817` | Self: 0.0% (349us) | Total: 0.0% (349us) | Samples: 2

**Called by:**
- `get` (2)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4835` | Self: 0.0% (349us) | Total: 0.0% (349us) | Samples: 2

**Called by:**
- `_buildPlan` (2)

### `get left`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1756` | Self: 0.0% (347us) | Total: 0.0% (632us) | Samples: 2

**Called by:**
- `isNullCheck` (1)
- `isAssignmentTarget` (1)
- `isTypeOfBinary` (1)

**Calls:**
- `nodeLhs` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1889` | Self: 0.0% (346us) | Total: 2.4% (21.5ms) | Samples: 2

**Called by:**
- `ensureRefsThrough` (113)
- `Program:exit` (9)
- `collectUnusedVariables` (2)
- `Program:exit` (1)

**Calls:**
- `ensureChildren` (121)
- `ensureChildren` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:930` | Self: 0.0% (346us) | Total: 0.0% (346us) | Samples: 2

**Called by:**
- `Program:exit` (2)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5746` | Self: 0.0% (346us) | Total: 0.0% (346us) | Samples: 2

**Called by:**
- `_getOrBuildPlan` (2)

### `get argument`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1829` | Self: 0.0% (344us) | Total: 0.0% (344us) | Samples: 2

**Called by:**
- `(anonymous)` (1)
- `ReturnStatement` (1)

### `_buildTemplate`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5809` | Self: 0.0% (344us) | Total: 0.0% (344us) | Samples: 2

**Called by:**
- `_buildPlan` (2)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4198` | Self: 0.0% (343us) | Total: 0.0% (343us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:961` | Self: 0.0% (343us) | Total: 0.0% (343us) | Samples: 2

**Called by:**
- `Program:exit` (2)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:689` | Self: 0.0% (343us) | Total: 0.2% (2.2ms) | Samples: 2

**Called by:**
- `_invokeFused` (13)

**Calls:**
- `get` (9)
- `push` (1)
- `get` (1)

### `_applySchemaDefaults`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:165` | Self: 0.0% (341us) | Total: 0.0% (341us) | Samples: 2

**Called by:**
- `buildVisitorMap` (2)

### `RuleSkipSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4776` | Self: 0.0% (340us) | Total: 0.0% (340us) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3550` | Self: 0.0% (340us) | Total: 0.0% (480us) | Samples: 2

**Called by:**
- `_buildVariable` (1)
- `report` (1)
- `getNameRange` (1)

**Calls:**
- `_nodeEndPos` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6768` | Self: 0.0% (340us) | Total: 0.0% (340us) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5917` | Self: 0.0% (340us) | Total: 0.0% (340us) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1884` | Self: 0.0% (340us) | Total: 1.2% (10.4ms) | Samples: 2

**Called by:**
- `_precomputeScopes` (31)
- `_buildScopeChildren` (30)
- `checkForBlock` (1)

**Calls:**
- `defineProperties` (60)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2470` | Self: 0.0% (338us) | Total: 0.1% (1.0ms) | Samples: 2

**Called by:**
- `getScope` (6)

**Calls:**
- `commentsInRange` (1)
- `commentsInRange` (1)
- `commentsInRange` (1)
- `commentsInRange` (1)

### `ensureChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1847` | Self: 0.0% (338us) | Total: 0.0% (338us) | Samples: 2

**Called by:**
- `get` (2)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (338us) | Total: 0.0% (338us) | Samples: 2

**Called by:**
- `get parent` (1)
- `get body` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:411` | Self: 0.0% (337us) | Total: 0.0% (638us) | Samples: 1

**Called by:**
- `parseSource` (3)

**Calls:**
- `Uint32Array` (2)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:473` | Self: 0.0% (337us) | Total: 0.0% (496us) | Samples: 2

**Called by:**
- `parseSource` (3)

**Calls:**
- `Uint32Array` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2326` | Self: 0.0% (337us) | Total: 0.0% (337us) | Samples: 2

**Called by:**
- `ensureRefsThrough` (2)

### `_parseDisableDirectives`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7404` | Self: 0.0% (337us) | Total: 0.1% (1.1ms) | Samples: 2

**Called by:**
- `applyDisableDirectives` (7)

**Calls:**
- `[Symbol.split]` (3)
- `regExpSplitFast` (2)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5688` | Self: 0.0% (336us) | Total: 0.0% (851us) | Samples: 2

**Called by:**
- `_getOrBuildPlan` (5)

**Calls:**
- `endsWith` (3)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4187` | Self: 0.0% (336us) | Total: 0.0% (487us) | Samples: 2

**Called by:**
- `AstView` (3)

**Calls:**
- `Uint8Array` (1)

### `_expandUnion`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4043` | Self: 0.0% (336us) | Total: 0.0% (336us) | Samples: 2

**Called by:**
- `buildVisitorMap` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6601` | Self: 0.0% (334us) | Total: 0.0% (334us) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6099` | Self: 0.0% (334us) | Total: 0.0% (334us) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `_makeSafeHandler`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3829` | Self: 0.0% (334us) | Total: 0.0% (334us) | Samples: 2

**Called by:**
- `buildVisitorMap` (2)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:84` | Self: 0.0% (333us) | Total: 0.0% (333us) | Samples: 2

**Called by:**
- `buildVisitorMap` (2)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5947` | Self: 0.0% (333us) | Total: 0.0% (667us) | Samples: 2

**Called by:**
- `_runSelectorList` (4)

**Calls:**
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:142` | Self: 0.0% (332us) | Total: 0.0% (332us) | Samples: 2

**Called by:**
- `buildVisitorMap` (2)

### `isInitOfForStatement`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:40` | Self: 0.0% (331us) | Total: 0.1% (1.2ms) | Samples: 2

**Called by:**
- `VariableDeclaration` (7)

**Calls:**
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)
- `get type` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:436` | Self: 0.0% (331us) | Total: 0.1% (893us) | Samples: 2

**Called by:**
- `_buildVariable` (4)
- `_buildThinVariable` (1)

**Calls:**
- `get parent` (2)
- `get parent` (1)

### `ensureBufferBytes`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:53` | Self: 0.0% (331us) | Total: 0.0% (331us) | Samples: 2

**Called by:**
- `_encodeSource` (2)

### `slotTemplate`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5792` | Self: 0.0% (330us) | Total: 0.0% (330us) | Samples: 2

**Called by:**
- `_buildTemplate` (2)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3734` | Self: 0.0% (330us) | Total: 0.0% (330us) | Samples: 2

**Called by:**
- `report` (2)

### `_ensureTagCaches`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5490` | Self: 0.0% (327us) | Total: 0.0% (327us) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `_getSelectorRootTypes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5591` | Self: 0.0% (326us) | Total: 0.1% (1.0ms) | Samples: 2

**Called by:**
- `_getSelectorRootTypes` (4)
- `_buildPlan` (1)
- `_getOrBuildSelectorPlan` (1)

**Calls:**
- `trim` (4)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1957` | Self: 0.0% (326us) | Total: 0.0% (326us) | Samples: 2

**Called by:**
- `ensureVarsSet` (2)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4195` | Self: 0.0% (325us) | Total: 0.0% (491us) | Samples: 2

**Called by:**
- `runPlugins` (3)

**Calls:**
- `includes` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1906` | Self: 0.0% (325us) | Total: 0.2% (1.8ms) | Samples: 2

**Called by:**
- `_buildScope` (10)

**Calls:**
- `get parent` (2)
- `get parent` (2)
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1007` | Self: 0.0% (324us) | Total: 0.0% (324us) | Samples: 2

**Called by:**
- `_computeIsStrict` (1)
- `collectUnusedVariables` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2198` | Self: 0.0% (322us) | Total: 0.0% (322us) | Samples: 2

**Called by:**
- `ensureRefsThrough` (2)

### `get init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2910` | Self: 0.0% (321us) | Total: 0.1% (1.0ms) | Samples: 2

**Called by:**
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (1)

**Calls:**
- `nodeRhs` (4)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4235` | Self: 0.0% (321us) | Total: 0.0% (460us) | Samples: 2

**Called by:**
- `runPlugins` (3)

**Calls:**
- `endsWith` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (320us) | Total: 0.0% (320us) | Samples: 2

**Called by:**
- `reset` (2)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` | Self: 0.0% (320us) | Total: 6.3% (55.0ms) | Samples: 2

**Called by:**
- `runOnce` (323)

**Calls:**
- `AstView` (72)
- `AstView` (33)
- `AstView` (20)
- `AstView` (12)
- `AstView` (11)
- `AstView` (9)
- `AstView` (9)
- `AstView` (7)
- `AstView` (7)
- `AstView` (6)
- `AstView` (6)
- `AstView` (6)
- `AstView` (5)
- `AstView` (5)
- `AstView` (5)
- `AstView` (5)
- `AstView` (5)
- `AstView` (4)
- `AstView` (4)
- `AstView` (4)
- `AstView` (4)
- `AstView` (4)
- `AstView` (4)
- `AstView` (4)
- `AstView` (3)
- `AstView` (3)
- `AstView` (3)
- `AstView` (3)
- `AstView` (3)
- `AstView` (3)
- `AstView` (3)
- `AstView` (3)
- `AstView` (3)
- `AstView` (3)
- `AstView` (3)
- `AstView` (3)
- `AstView` (3)
- `AstView` (3)
- `AstView` (2)
- `AstView` (2)
- `AstView` (2)
- `AstView` (2)
- `AstView` (2)
- `AstView` (2)
- `AstView` (1)
- `AstView` (1)
- `AstView` (1)
- `AstView` (1)
- `AstView` (1)
- `AstView` (1)
- `AstView` (1)
- `AstView` (1)
- `AstView` (1)
- `AstView` (1)
- `AstView` (1)
- `AstView` (1)
- `AstView` (1)
- `AstView` (1)
- `AstView` (1)
- `AstView` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3902` | Self: 0.0% (320us) | Total: 0.2% (2.1ms) | Samples: 2

**Called by:**
- `runPlugins` (13)

**Calls:**
- `reset` (7)
- `reset` (2)
- `reset` (1)
- `reset` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1222` | Self: 0.0% (319us) | Total: 0.2% (1.7ms) | Samples: 2

**Called by:**
- `_findDefNode` (5)
- `isInLoop` (3)
- `_findDefNode` (2)
- `isModifyingProp` (1)

**Calls:**
- `get _tag` (5)
- `get _tag` (4)

### `existsSync`
`[native code]` | Self: 0.0% (318us) | Total: 0.0% (318us) | Samples: 2

**Called by:**
- `existsSync` (2)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1903` | Self: 0.0% (318us) | Total: 0.0% (318us) | Samples: 2

**Called by:**
- `_buildScope` (2)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2317` | Self: 0.0% (318us) | Total: 0.0% (318us) | Samples: 2

**Called by:**
- `ensureRefsThrough` (2)

### `getArrayMethodName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:116` | Self: 0.0% (317us) | Total: 0.2% (1.9ms) | Samples: 2

**Called by:**
- `onCodePathStart` (11)

**Calls:**
- `isSpecificMemberAccess` (3)
- `isSpecificMemberAccess` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_getChainExpr` (1)
- `get callee` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3547` | Self: 0.0% (317us) | Total: 0.0% (317us) | Samples: 2

**Called by:**
- `getTokenAfter` (1)
- `isInside` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6872` | Self: 0.0% (316us) | Total: 0.1% (982us) | Samples: 2

**Called by:**
- `runPlugins` (6)

**Calls:**
- `_resolveHandlers` (3)
- `_resolveHandlers` (1)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:92` | Self: 0.0% (316us) | Total: 0.3% (3.1ms) | Samples: 2

**Called by:**
- `parseSource` (19)

**Calls:**
- `encodeInto` (11)
- `Uint8Array` (6)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5716` | Self: 0.0% (315us) | Total: 0.0% (315us) | Samples: 2

**Called by:**
- `_getOrBuildPlan` (2)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:314` | Self: 0.0% (315us) | Total: 0.1% (1.0ms) | Samples: 2

**Called by:**
- `parseSource` (6)

**Calls:**
- `Uint32Array` (4)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4541` | Self: 0.0% (314us) | Total: 0.0% (314us) | Samples: 2

**Called by:**
- `walkNodes` (1)
- `walkNodes` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3804` | Self: 0.0% (313us) | Total: 0.6% (5.6ms) | Samples: 2

**Called by:**
- `Program:exit` (10)
- `(anonymous)` (7)
- `checkReference` (4)
- `checkLastSegment` (3)
- `report` (3)
- `report` (2)
- `report` (2)
- `(anonymous)` (1)
- `checkForShadows` (1)

**Calls:**
- `_execReport` (7)
- `_execReport` (7)
- `_execReport` (4)
- `_execReport` (2)
- `_execReport` (2)
- `_execReport` (2)
- `_execReport` (2)
- `_execReport` (1)
- `_execReport` (1)
- `_execReport` (1)
- `_execReport` (1)
- `_execReport` (1)

### `regExpSplitFast`
`[native code]` | Self: 0.0% (313us) | Total: 0.0% (313us) | Samples: 2

**Called by:**
- `_parseDisableDirectives` (2)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7307` | Self: 0.0% (313us) | Total: 0.0% (313us) | Samples: 2

**Called by:**
- `runOnce` (2)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2879` | Self: 0.0% (313us) | Total: 0.0% (313us) | Samples: 2

**Called by:**
- `_buildReference` (1)
- `_buildThinScope` (1)

### `_buildTemplate`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5808` | Self: 0.0% (312us) | Total: 0.0% (795us) | Samples: 2

**Called by:**
- `_buildPlan` (5)

**Calls:**
- `map` (3)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (311us) | Total: 0.0% (311us) | Samples: 2

**Called by:**
- `Program:exit` (1)
- `_buildScopeRefsAndThrough` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (310us) | Total: 0.0% (310us) | Samples: 2

**Called by:**
- `walkNodes` (1)
- `walkNodes` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6814` | Self: 0.0% (310us) | Total: 0.0% (500us) | Samples: 2

**Called by:**
- `runPlugins` (3)

**Calls:**
- `has` (1)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5258` | Self: 0.0% (309us) | Total: 0.0% (309us) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1237` | Self: 0.0% (309us) | Total: 0.1% (1.0ms) | Samples: 2

**Called by:**
- `_findDefNode` (3)
- `_findDefNode` (1)
- `isAssignmentTarget` (1)
- `isInitOfForStatement` (1)

**Calls:**
- `get _tag` (2)
- `get _tag` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2065` | Self: 0.0% (308us) | Total: 0.0% (308us) | Samples: 2

**Called by:**
- `ensureVarsSet` (2)

### `checkGroup`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:438` | Self: 0.0% (304us) | Total: 0.0% (304us) | Samples: 2

**Called by:**
- `forEach` (2)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:487` | Self: 0.0% (304us) | Total: 0.1% (1.1ms) | Samples: 2

**Called by:**
- `parseSource` (7)

**Calls:**
- `Uint32Array` (5)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (303us) | Total: 0.0% (303us) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1328` | Self: 0.0% (303us) | Total: 0.1% (981us) | Samples: 2

**Called by:**
- `_buildScopeRefsAndThrough` (3)
- `_buildScopeRefsAndThrough` (2)
- `collectUnusedVariables` (1)

**Calls:**
- `get mainToken` (3)
- `mainToken` (1)

### `RegExp`
`[native code]` | Self: 0.0% (303us) | Total: 0.0% (303us) | Samples: 2

**Called by:**
- `wordsRegexp` (1)
- `(anonymous)` (1)

### `/\[[^\]]*\]/g`
`[native code]` | Self: 0.0% (300us) | Total: 0.0% (300us) | Samples: 2

**Called by:**
- `_getSelectorRootTypes` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2661` | Self: 0.0% (294us) | Total: 0.0% (654us) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (4)

**Calls:**
- `get range` (1)
- `get range` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (293us) | Total: 0.0% (293us) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5650` | Self: 0.0% (293us) | Total: 0.0% (293us) | Samples: 2

**Called by:**
- `_getOrBuildPlan` (2)

### `extraFnData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:664` | Self: 0.0% (289us) | Total: 0.0% (289us) | Samples: 2

**Called by:**
- `get body` (2)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3066` | Self: 0.0% (288us) | Total: 0.0% (288us) | Samples: 2

**Called by:**
- `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause` (1)
- `checkForFunction` (1)

### `_compileSelectorFastMatcher`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (288us) | Total: 0.0% (288us) | Samples: 2

**Called by:**
- `_getOrBuildSelectorPlan` (2)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:657` | Self: 0.0% (288us) | Total: 0.0% (448us) | Samples: 1

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `get type` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:682` | Self: 0.0% (285us) | Total: 0.0% (285us) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6641` | Self: 0.0% (282us) | Total: 0.0% (282us) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:159` | Self: 0.0% (279us) | Total: 0.0% (279us) | Samples: 2

**Called by:**
- `buildVisitorMap` (2)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:641` | Self: 0.0% (212us) | Total: 0.0% (212us) | Samples: 1

**Called by:**
- `reset` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:479` | Self: 0.0% (211us) | Total: 0.0% (211us) | Samples: 1

**Called by:**
- `forEach` (1)

### `Program`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:294` | Self: 0.0% (205us) | Total: 0.1% (1.1ms) | Samples: 1

**Called by:**
- `_invokeFused` (7)

**Calls:**
- `get name` (2)
- `isGoodName` (1)
- `some` (1)
- `get name` (1)
- `isAllowed` (1)

### `keys`
`[native code]` | Self: 0.0% (204us) | Total: 0.0% (204us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4241` | Self: 0.0% (203us) | Total: 0.0% (356us) | Samples: 1

**Called by:**
- `AstView` (2)

**Calls:**
- `fill` (1)

### `async (anonymous)`
`[native code]` | Self: 0.0% (203us) | Total: 99.8% (868.9ms) | Samples: 1

**Called by:**
- `requestInstantiate` (5)
- `async (anonymous)` (4)

**Calls:**
- `parseModule` (5041)
- `async (anonymous)` (4)
- `requestFetch` (4)
- `resolve` (1)

### `isInitPatternNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:277` | Self: 0.0% (202us) | Total: 0.0% (202us) | Samples: 1

**Called by:**
- `checkForShadows` (1)

### `/^(?:Arrow)?FunctionExpression$/u`
`[native code]` | Self: 0.0% (202us) | Total: 0.0% (202us) | Samples: 1

**Called by:**
- `onCodePathStart` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6589` | Self: 0.0% (201us) | Total: 0.0% (201us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `safeHandler`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3820` | Self: 0.0% (200us) | Total: 0.0% (200us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `uncurryThis`
`internal:primordials:20` | Self: 0.0% (199us) | Total: 0.0% (199us) | Samples: 1

**Called by:**
- `internal:primordials` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5694` | Self: 0.0% (198us) | Total: 0.0% (198us) | Samples: 1

**Called by:**
- `_getOrBuildPlan` (1)

### `_buildTemplate`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (198us) | Total: 0.0% (198us) | Samples: 1

**Called by:**
- `_buildPlan` (1)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:179` | Self: 0.0% (198us) | Total: 0.2% (2.5ms) | Samples: 1

**Called by:**
- `getRhsNode` (16)

**Calls:**
- `isFunction` (15)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6845` | Self: 0.0% (198us) | Total: 0.0% (198us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `checkText`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js` | Self: 0.0% (198us) | Total: 0.0% (198us) | Samples: 1

**Called by:**
- `isSpecificMemberAccess` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4179` | Self: 0.0% (197us) | Total: 0.0% (197us) | Samples: 1

**Called by:**
- `AstView` (1)

### `_getPlugin`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:59` | Self: 0.0% (197us) | Total: 0.0% (197us) | Samples: 1

**Called by:**
- `describeRule` (1)

### `isInitPatternNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:318` | Self: 0.0% (196us) | Total: 0.0% (196us) | Samples: 1

**Called by:**
- `checkForShadows` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:277` | Self: 0.0% (196us) | Total: 0.0% (196us) | Samples: 1

**Called by:**
- `anonymous` (1)

### `source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:511` | Self: 0.0% (196us) | Total: 0.0% (386us) | Samples: 1

**Called by:**
- `commentsInRange` (1)
- `runPlugins` (1)

**Calls:**
- `decode` (1)

### `get id`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2269` | Self: 0.0% (196us) | Total: 0.0% (196us) | Samples: 1

**Called by:**
- `getFunctionNameWithKind` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:306` | Self: 0.0% (195us) | Total: 0.0% (559us) | Samples: 1

**Called by:**
- `parseSource` (3)

**Calls:**
- `Uint32Array` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:221` | Self: 0.0% (195us) | Total: 0.0% (195us) | Samples: 1

**Called by:**
- `filter` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:637` | Self: 0.0% (195us) | Total: 0.0% (195us) | Samples: 1

**Called by:**
- `reset` (1)

### `_deepMergeObjects`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:122` | Self: 0.0% (194us) | Total: 0.0% (194us) | Samples: 1

**Called by:**
- `_deepMergeObjects` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:415` | Self: 0.0% (194us) | Total: 0.0% (194us) | Samples: 1

**Called by:**
- `parseSource` (1)

### `isTypeValueShadow`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js` | Self: 0.0% (194us) | Total: 0.0% (194us) | Samples: 1

**Called by:**
- `checkForShadows` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6449` | Self: 0.0% (194us) | Total: 0.0% (194us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3623` | Self: 0.0% (194us) | Total: 0.0% (194us) | Samples: 1

**Called by:**
- `getDeclaredLocation` (1)

### `runOnce`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:90` | Self: 0.0% (194us) | Total: 0.0% (361us) | Samples: 1

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `get` (1)

### `extraMethodData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:694` | Self: 0.0% (194us) | Total: 0.0% (194us) | Samples: 1

**Called by:**
- `get value` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1700` | Self: 0.0% (194us) | Total: 0.0% (194us) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2099` | Self: 0.0% (194us) | Total: 0.0% (194us) | Samples: 1

**Called by:**
- `ensureVarsSet` (1)

### `require`
`[native code]` | Self: 0.0% (194us) | Total: 5.2% (45.6ms) | Samples: 1

**Called by:**
- `bound require` (265)

**Calls:**
- `anonymous` (264)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:68` | Self: 0.0% (194us) | Total: 0.0% (356us) | Samples: 1

**Called by:**
- `some` (2)

**Calls:**
- `get type` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:462` | Self: 0.0% (194us) | Total: 0.0% (194us) | Samples: 1

**Called by:**
- `parseSource` (1)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (193us) | Total: 0.0% (193us) | Samples: 1

**Called by:**
- `Program:exit` (1)

### `isImportAttributeKey`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:1423` | Self: 0.0% (193us) | Total: 0.0% (193us) | Samples: 1

**Called by:**
- `Program` (1)

### `node:fs/promises`
`node:fs/promises:175` | Self: 0.0% (193us) | Total: 0.0% (193us) | Samples: 1

**Called by:**
- `anonymous` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4227` | Self: 0.0% (193us) | Total: 0.0% (193us) | Samples: 1

**Called by:**
- `AstView` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3620` | Self: 0.0% (193us) | Total: 0.0% (193us) | Samples: 1

**Called by:**
- `getDeclaredLocation` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js` | Self: 0.0% (193us) | Total: 0.0% (193us) | Samples: 1

**Called by:**
- `BinaryExpression` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js` | Self: 0.0% (193us) | Total: 0.0% (193us) | Samples: 1

**Called by:**
- `findUp` (1)

### `_getTypeProto`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3969` | Self: 0.0% (193us) | Total: 0.0% (193us) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `_tryLoad`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js` | Self: 0.0% (193us) | Total: 0.0% (193us) | Samples: 1

**Called by:**
- `isAvailable` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3604` | Self: 0.0% (193us) | Total: 0.0% (193us) | Samples: 1

**Called by:**
- `getDeclaredLocation` (1)

### `getOwnPropertyDescriptors`
`[native code]` | Self: 0.0% (193us) | Total: 0.0% (193us) | Samples: 1

**Called by:**
- `_getTypeProto` (1)

### `Function`
`[native code]` | Self: 0.0% (192us) | Total: 0.0% (192us) | Samples: 1

**Called by:**
- `FFIBuilder` (1)

### `ensureRefsThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1824` | Self: 0.0% (192us) | Total: 18.8% (164.4ms) | Samples: 1

**Called by:**
- `get` (979)

**Calls:**
- `_buildScopeRefsAndThrough` (541)
- `_buildScopeRefsAndThrough` (285)
- `_buildScopeRefsAndThrough` (100)
- `_buildScopeRefsAndThrough` (16)
- `_buildScopeRefsAndThrough` (9)
- `_buildScopeRefsAndThrough` (6)
- `_buildScopeRefsAndThrough` (5)
- `_buildScopeRefsAndThrough` (4)
- `_buildScopeRefsAndThrough` (2)
- `_buildScopeRefsAndThrough` (2)
- `_buildScopeRefsAndThrough` (2)
- `_buildScopeRefsAndThrough` (1)
- `_buildScopeRefsAndThrough` (1)
- `_buildScopeRefsAndThrough` (1)
- `_buildScopeRefsAndThrough` (1)
- `_buildScopeRefsAndThrough` (1)
- `_buildScopeRefsAndThrough` (1)

### `/[\s\[>~+.(]/`
`[native code]` | Self: 0.0% (192us) | Total: 0.0% (192us) | Samples: 1

**Called by:**
- `_isSelector` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4225` | Self: 0.0% (192us) | Total: 0.0% (366us) | Samples: 1

**Called by:**
- `AstView` (2)

**Calls:**
- `Uint32Array` (1)

### `isTypeParameterOfStaticMethod`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:206` | Self: 0.0% (192us) | Total: 0.0% (192us) | Samples: 1

**Called by:**
- `isGenericOfAStaticMethodShadow` (1)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5931` | Self: 0.0% (192us) | Total: 0.0% (192us) | Samples: 1

**Called by:**
- `_runSelectorList` (1)

### `get imported`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3501` | Self: 0.0% (191us) | Total: 0.0% (191us) | Samples: 1

**Called by:**
- `equalsToOriginalName` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (191us) | Total: 0.0% (191us) | Samples: 1

**Called by:**
- `getFirstToken` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3884` | Self: 0.0% (191us) | Total: 0.0% (191us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `CfgCodePath`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4329` | Self: 0.0% (191us) | Total: 0.0% (191us) | Samples: 1

**Called by:**
- `codepath` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6450` | Self: 0.0% (191us) | Total: 0.0% (191us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3786` | Self: 0.0% (191us) | Total: 0.1% (1.2ms) | Samples: 1

**Called by:**
- `report` (7)

**Calls:**
- `get start` (4)
- `get type` (1)
- `get start` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6965` | Self: 0.0% (191us) | Total: 0.0% (191us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3759` | Self: 0.0% (191us) | Total: 0.0% (191us) | Samples: 1

**Called by:**
- `report` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6506` | Self: 0.0% (191us) | Total: 0.0% (353us) | Samples: 1

**Called by:**
- `walkNodes` (2)

**Calls:**
- `_dispatchSeg` (1)

### `hasMemberExpressionAssignment`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:125` | Self: 0.0% (191us) | Total: 0.0% (191us) | Samples: 1

**Called by:**
- `some` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2973` | Self: 0.0% (191us) | Total: 0.0% (191us) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:408` | Self: 0.0% (191us) | Total: 0.0% (511us) | Samples: 1

**Called by:**
- `parseSource` (3)

**Calls:**
- `Uint16Array` (2)

### `isModifyingProp`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js` | Self: 0.0% (190us) | Total: 0.0% (190us) | Samples: 1

**Called by:**
- `checkReference` (1)

### `isImportAttributeKey`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:1440` | Self: 0.0% (190us) | Total: 0.0% (190us) | Samples: 1

**Called by:**
- `ObjectExpression > Property[computed!=true] > Identifier.key,MethodDefinition[computed!=true] > Identifier.key,PropertyDefinition[computed!=true] > Identifier.key,MethodDefinition > PrivateIdentifier.key,PropertyDefinition > PrivateIdentifier.key` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:656` | Self: 0.0% (190us) | Total: 0.0% (190us) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `nodeRhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (190us) | Total: 0.0% (190us) | Samples: 1

**Called by:**
- `get arguments` (1)

### `get callee`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1873` | Self: 0.0% (189us) | Total: 0.0% (189us) | Samples: 1

**Called by:**
- `getArrayMethodName` (1)

### `_extractBatchScannable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4649` | Self: 0.0% (189us) | Total: 0.0% (189us) | Samples: 1

**Called by:**
- `_buildPlan` (1)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:815` | Self: 0.0% (189us) | Total: 0.0% (189us) | Samples: 1

**Called by:**
- `_symName` (1)

### `isModifyingProp`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:99` | Self: 0.0% (189us) | Total: 0.0% (189us) | Samples: 1

**Called by:**
- `checkReference` (1)

### `shouldCheck`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:399` | Self: 0.0% (189us) | Total: 0.0% (189us) | Samples: 1

**Called by:**
- `filter` (1)

### `_resolveHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6810` | Self: 0.0% (189us) | Total: 0.0% (189us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_extractBatchScannable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4655` | Self: 0.0% (189us) | Total: 0.0% (189us) | Samples: 1

**Called by:**
- `_buildPlan` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6758` | Self: 0.0% (189us) | Total: 0.0% (527us) | Samples: 1

**Called by:**
- `runPlugins` (3)

**Calls:**
- `get` (2)

### `getLocFromIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3359` | Self: 0.0% (189us) | Total: 0.0% (556us) | Samples: 1

**Called by:**
- `_execReport` (2)
- `getNameLocationInGlobalDirectiveComment` (1)

**Calls:**
- `_lineStarts` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (188us) | Total: 0.0% (188us) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_extractBatchScannable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4668` | Self: 0.0% (188us) | Total: 0.0% (188us) | Samples: 1

**Called by:**
- `_buildPlan` (1)

### `checkForShadows`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:662` | Self: 0.0% (188us) | Total: 0.1% (912us) | Samples: 1

**Called by:**
- `Program:exit` (5)

**Calls:**
- `getDeclaredLocation` (4)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:673` | Self: 0.0% (188us) | Total: 0.0% (188us) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3065` | Self: 0.0% (188us) | Total: 1.0% (9.3ms) | Samples: 1

**Called by:**
- `VariableDeclaration` (37)
- `checkForFunction` (17)
- `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause` (1)

**Calls:**
- `_buildVariable` (34)
- `_buildVariable` (9)
- `_buildVariable` (4)
- `_buildVariable` (2)
- `_buildVariable` (2)
- `_buildVariable` (1)
- `_buildVariable` (1)
- `_buildVariable` (1)

### `ensureChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1848` | Self: 0.0% (187us) | Total: 2.3% (20.8ms) | Samples: 1

**Called by:**
- `get` (121)

**Calls:**
- `_buildScopeChildren` (116)
- `_buildScopeChildren` (2)
- `_buildScopeChildren` (1)
- `_buildScopeChildren` (1)

### `be`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (187us) | Total: 0.0% (187us) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `checkForShadows`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:620` | Self: 0.0% (187us) | Total: 0.0% (382us) | Samples: 1

**Called by:**
- `Program:exit` (2)

**Calls:**
- `isGlobalAugmentation` (1)

### `iterateDeclarations`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:77` | Self: 0.0% (187us) | Total: 0.0% (367us) | Samples: 1

**Called by:**
- `generatorResume` (2)

**Calls:**
- `getNameLocationInGlobalDirectiveComment` (1)

### `codepath`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4256` | Self: 0.0% (187us) | Total: 0.0% (378us) | Samples: 1

**Called by:**
- `_fireCfgEvents` (2)

**Calls:**
- `CfgCodePath` (1)

### `isFunctionNameInitializerException`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:402` | Self: 0.0% (187us) | Total: 0.0% (187us) | Samples: 1

**Called by:**
- `checkForShadows` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4210` | Self: 0.0% (187us) | Total: 0.0% (347us) | Samples: 1

**Called by:**
- `AstView` (2)

**Calls:**
- `Uint32Array` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6625` | Self: 0.0% (186us) | Total: 0.0% (186us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6946` | Self: 0.0% (186us) | Total: 0.0% (294us) | Samples: 1

**Called by:**
- `runPlugins` (2)

**Calls:**
- `has` (1)

### `checkLastSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:320` | Self: 0.0% (186us) | Total: 0.0% (186us) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6201` | Self: 0.0% (186us) | Total: 0.0% (186us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6255` | Self: 0.0% (186us) | Total: 0.0% (186us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:428` | Self: 0.0% (186us) | Total: 0.0% (502us) | Samples: 1

**Called by:**
- `parseSource` (3)

**Calls:**
- `Uint32Array` (2)

### `loadBinding`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:10` | Self: 0.0% (186us) | Total: 0.0% (186us) | Samples: 1

**Called by:**
- `parseSource` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5062` | Self: 0.0% (186us) | Total: 0.0% (339us) | Samples: 1

**Called by:**
- `fn` (2)

**Calls:**
- `get type` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2933` | Self: 0.0% (186us) | Total: 0.0% (186us) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6358` | Self: 0.0% (186us) | Total: 0.0% (186us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2316` | Self: 0.0% (186us) | Total: 0.3% (2.8ms) | Samples: 1

**Called by:**
- `ensureRefsThrough` (16)

**Calls:**
- `get name` (9)
- `get name` (3)
- `get name` (1)
- `_resolveUnicodeEscapes` (1)
- `_resolveUnicodeEscapes` (1)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5292` | Self: 0.0% (185us) | Total: 0.0% (185us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `isAllowed`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js` | Self: 0.0% (185us) | Total: 0.0% (185us) | Samples: 1

**Called by:**
- `Program` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:331` | Self: 0.0% (185us) | Total: 0.0% (185us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `fullMethodName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:55` | Self: 0.0% (185us) | Total: 0.0% (185us) | Samples: 1

**Called by:**
- `checkLastSegment` (1)

### `onCodePathStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:405` | Self: 0.0% (185us) | Total: 0.0% (552us) | Samples: 1

**Called by:**
- `_fireCfgEvents` (3)

**Calls:**
- `/^(?:Arrow)?FunctionExpression$/u` (1)
- `get type` (1)

### `isThisParam`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:147` | Self: 0.0% (185us) | Total: 0.0% (185us) | Samples: 1

**Called by:**
- `checkForShadows` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4188` | Self: 0.0% (185us) | Total: 0.0% (502us) | Samples: 1

**Called by:**
- `AstView` (3)

**Calls:**
- `Uint32Array` (2)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:291` | Self: 0.0% (185us) | Total: 0.0% (185us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7070` | Self: 0.0% (184us) | Total: 0.0% (184us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1340` | Self: 0.0% (184us) | Total: 0.0% (184us) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4218` | Self: 0.0% (184us) | Total: 0.0% (184us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `fn`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5102` | Self: 0.0% (184us) | Total: 0.0% (652us) | Samples: 1

**Called by:**
- `_runSelectorList` (3)
- `fn` (1)

**Calls:**
- `get property` (1)
- `_nodeViewRaw` (1)
- `get property` (1)

### `isInside`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` | Self: 0.0% (184us) | Total: 0.0% (184us) | Samples: 1

**Called by:**
- `isInsideOfStorableFunction` (1)

### `isClassRefInClassDecorator`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js` | Self: 0.0% (184us) | Total: 0.0% (184us) | Samples: 1

**Called by:**
- `shouldCheck` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4256` | Self: 0.0% (183us) | Total: 0.0% (183us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `Proxy`
`[native code]` | Self: 0.0% (183us) | Total: 0.0% (183us) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4003` | Self: 0.0% (183us) | Total: 0.0% (183us) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1673` | Self: 0.0% (183us) | Total: 0.0% (183us) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `_isChainNode`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3885` | Self: 0.0% (183us) | Total: 0.0% (183us) | Samples: 1

**Called by:**
- `nodeViewChain` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3788` | Self: 0.0% (183us) | Total: 0.0% (183us) | Samples: 1

**Called by:**
- `report` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4250` | Self: 0.0% (183us) | Total: 0.0% (183us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `isInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:231` | Self: 0.0% (183us) | Total: 0.0% (183us) | Samples: 1

**Called by:**
- `isInitPatternNode` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/escape-string-regexp/index.js` | Self: 0.0% (182us) | Total: 0.0% (182us) | Samples: 1

**Called by:**
- `getNameLocationInGlobalDirectiveComment` (1)

### `getFunctionHeadLoc`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2312` | Self: 0.0% (182us) | Total: 0.0% (182us) | Samples: 1

**Called by:**
- `checkLastSegment` (1)

### `_dispatchSeg`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6111` | Self: 0.0% (182us) | Total: 0.0% (182us) | Samples: 1

**Called by:**
- `_fireCfgEvents` (1)

### `getFirstTokenBetween`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (182us) | Total: 0.0% (182us) | Samples: 1

**Called by:**
- `report` (1)

### `checkReference`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:190` | Self: 0.0% (182us) | Total: 0.0% (182us) | Samples: 1

**Called by:**
- `forEach` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1200` | Self: 0.0% (182us) | Total: 0.0% (182us) | Samples: 1

**Called by:**
- `isInLoop` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` | Self: 0.0% (182us) | Total: 5.5% (48.1ms) | Samples: 1

**Called by:**
- `_invokeFused` (243)

**Calls:**
- `collectUnusedVariables` (118)
- `collectUnusedVariables` (41)
- `collectUnusedVariables` (32)
- `collectUnusedVariables` (21)
- `collectUnusedVariables` (7)
- `collectUnusedVariables` (4)
- `collectUnusedVariables` (3)
- `collectUnusedVariables` (3)
- `collectUnusedVariables` (3)
- `collectUnusedVariables` (2)
- `collectUnusedVariables` (2)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1208` | Self: 0.0% (182us) | Total: 0.0% (182us) | Samples: 1

**Called by:**
- `isAssignmentTarget` (1)

### `onCodePathStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:406` | Self: 0.0% (181us) | Total: 0.7% (6.4ms) | Samples: 1

**Called by:**
- `_fireCfgEvents` (38)

**Calls:**
- `getArrayMethodName` (17)
- `getArrayMethodName` (11)
- `getArrayMethodName` (4)
- `getArrayMethodName` (1)
- `getArrayMethodName` (1)
- `getStaticPropertyName` (1)
- `getStaticPropertyName` (1)
- `getArrayMethodName` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4197` | Self: 0.0% (181us) | Total: 0.0% (535us) | Samples: 1

**Called by:**
- `AstView` (3)

**Calls:**
- `Uint32Array` (2)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1603` | Self: 0.0% (181us) | Total: 0.0% (181us) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3749` | Self: 0.0% (181us) | Total: 0.0% (340us) | Samples: 1

**Called by:**
- `report` (2)

**Calls:**
- `get start` (1)

### `get local`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (181us) | Total: 0.0% (181us) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:74` | Self: 0.0% (181us) | Total: 0.0% (181us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2865` | Self: 0.0% (181us) | Total: 0.2% (2.0ms) | Samples: 1

**Called by:**
- `_buildReference` (12)

**Calls:**
- `_symName` (10)
- `_symName` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:655` | Self: 0.0% (180us) | Total: 0.0% (180us) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2768` | Self: 0.0% (180us) | Total: 0.0% (180us) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `get id`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2257` | Self: 0.0% (180us) | Total: 0.0% (504us) | Samples: 1

**Called by:**
- `getFunctionNameWithKind` (1)
- `_buildScope` (1)

**Calls:**
- `_tag` (1)

### `checkReference`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:201` | Self: 0.0% (180us) | Total: 0.0% (180us) | Samples: 1

**Called by:**
- `forEach` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` | Self: 0.0% (180us) | Total: 0.0% (725us) | Samples: 1

**Called by:**
- `forEach` (4)

**Calls:**
- `get init` (3)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1451` | Self: 0.0% (180us) | Total: 0.0% (180us) | Samples: 1

**Called by:**
- `getStaticStringValue` (1)

### `cloneObject`
`[native code]` | Self: 0.0% (180us) | Total: 0.0% (180us) | Samples: 1

**Called by:**
- `_deepMergeObjects` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (180us) | Total: 0.2% (2.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (6)
- `ke` (4)
- `anonymous` (2)
- `a` (1)

**Calls:**
- `(anonymous)` (6)
- `(anonymous)` (2)
- `be` (1)
- `a` (1)
- `a` (1)
- `e` (1)

### `shouldCheck`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:393` | Self: 0.0% (180us) | Total: 0.0% (372us) | Samples: 1

**Called by:**
- `filter` (2)

**Calls:**
- `get parent` (1)

### `getIdentifierIfShouldBeConst`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:233` | Self: 0.0% (180us) | Total: 0.0% (180us) | Samples: 1

**Called by:**
- `groupByDestructuring` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:479` | Self: 0.0% (179us) | Total: 0.0% (493us) | Samples: 1

**Called by:**
- `parseSource` (3)

**Calls:**
- `Uint32Array` (2)

### `hideFromStack`
`internal:shared:19` | Self: 0.0% (179us) | Total: 0.0% (179us) | Samples: 1

**Called by:**
- `internal:validators` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:319` | Self: 0.0% (179us) | Total: 0.0% (335us) | Samples: 1

**Called by:**
- `parseSource` (2)

**Calls:**
- `Uint32Array` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2356` | Self: 0.0% (179us) | Total: 1.7% (15.4ms) | Samples: 1

**Called by:**
- `getScope` (93)

**Calls:**
- `_buildScope` (31)
- `_buildScope` (31)
- `_buildScope` (18)
- `_buildScope` (9)
- `_buildScope` (2)
- `_buildScope` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3744` | Self: 0.0% (179us) | Total: 0.0% (179us) | Samples: 1

**Called by:**
- `report` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:205` | Self: 0.0% (179us) | Total: 0.0% (533us) | Samples: 1

**Called by:**
- `runOnce` (3)

**Calls:**
- `loadBinding` (1)
- `loadBinding` (1)

### `CfgSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (179us) | Total: 0.0% (179us) | Samples: 1

**Called by:**
- `segment` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2283` | Self: 0.0% (179us) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `ensureRefsThrough` (9)

**Calls:**
- `get name` (3)
- `get name` (2)
- `get name` (2)
- `get name` (1)

### `fix`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:155` | Self: 0.0% (179us) | Total: 0.0% (179us) | Samples: 1

**Called by:**
- `_execReport` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` | Self: 0.0% (179us) | Total: 0.0% (179us) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2665` | Self: 0.0% (178us) | Total: 0.0% (178us) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7058` | Self: 0.0% (178us) | Total: 0.0% (178us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_compileSelectorFastMatcher`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4984` | Self: 0.0% (178us) | Total: 0.0% (178us) | Samples: 1

**Called by:**
- `_compileSelectorFastMatcher` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:420` | Self: 0.0% (178us) | Total: 0.0% (849us) | Samples: 1

**Called by:**
- `parseSource` (5)

**Calls:**
- `Uint32Array` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6715` | Self: 0.0% (178us) | Total: 0.0% (178us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:437` | Self: 0.0% (178us) | Total: 0.0% (685us) | Samples: 1

**Called by:**
- `parseSource` (4)

**Calls:**
- `Uint8Array` (3)

### `getNameLocationInGlobalDirectiveComment`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2634` | Self: 0.0% (178us) | Total: 0.0% (178us) | Samples: 1

**Called by:**
- `Program:exit` (1)

### `/^:[a-z-]+\s*/`
`[native code]` | Self: 0.0% (178us) | Total: 0.0% (178us) | Samples: 1

**Called by:**
- `_getSelectorRootTypes` (1)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (178us) | Total: 0.0% (178us) | Samples: 1

**Called by:**
- `_buildThinVariable` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1614` | Self: 0.0% (178us) | Total: 0.0% (178us) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `referenceContainsTypeQuery`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:227` | Self: 0.0% (177us) | Total: 0.0% (319us) | Samples: 1

**Called by:**
- `shouldCheck` (2)

**Calls:**
- `get type` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:434` | Self: 0.0% (177us) | Total: 0.0% (177us) | Samples: 1

**Called by:**
- `forEach` (1)

### `ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1778` | Self: 0.0% (177us) | Total: 0.0% (177us) | Samples: 1

**Called by:**
- `get` (1)

### `VariableDeclaration`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:548` | Self: 0.0% (177us) | Total: 0.2% (1.7ms) | Samples: 1

**Called by:**
- `_invokeFused` (10)

**Calls:**
- `isInitOfForStatement` (7)
- `get kind` (1)
- `get kind` (1)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5247` | Self: 0.0% (177us) | Total: 0.0% (177us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `checkForShadows`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:642` | Self: 0.0% (177us) | Total: 0.3% (3.1ms) | Samples: 1

**Called by:**
- `Program:exit` (19)

**Calls:**
- `getVariableByName` (18)

### `getVariableDescription`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:235` | Self: 0.0% (176us) | Total: 0.0% (176us) | Samples: 1

**Called by:**
- `getAssignedMessageData` (1)

### `get quasis`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3068` | Self: 0.0% (176us) | Total: 0.0% (176us) | Samples: 1

**Called by:**
- `getStaticStringValue` (1)

### `getArrayMethodName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:138` | Self: 0.0% (176us) | Total: 0.0% (176us) | Samples: 1

**Called by:**
- `onCodePathStart` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4240` | Self: 0.0% (176us) | Total: 0.0% (646us) | Samples: 1

**Called by:**
- `AstView` (4)

**Calls:**
- `fill` (3)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (176us) | Total: 0.0% (176us) | Samples: 1

**Called by:**
- `report` (1)

### `getFunctionHeadLoc`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2285` | Self: 0.0% (176us) | Total: 0.0% (176us) | Samples: 1

**Called by:**
- `checkLastSegment` (1)

### `getTokenAfter`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1221` | Self: 0.0% (176us) | Total: 0.0% (176us) | Samples: 1

**Called by:**
- `getFunctionHeadLoc` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:136` | Self: 0.0% (176us) | Total: 0.1% (960us) | Samples: 1

**Called by:**
- `map` (6)

**Calls:**
- `_deepMergeObjects` (3)
- `_deepMergeObjects` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7165` | Self: 0.0% (176us) | Total: 0.1% (1.3ms) | Samples: 1

**Called by:**
- `runPlugins` (8)

**Calls:**
- `_fireCfgEvents` (2)
- `_fireCfgEvents` (2)
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2273` | Self: 0.0% (175us) | Total: 0.0% (175us) | Samples: 1

**Called by:**
- `ensureRefsThrough` (1)

### `_nodeStartPos`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:888` | Self: 0.0% (175us) | Total: 0.0% (175us) | Samples: 1

**Called by:**
- `_buildVariable` (1)

### `nodeLhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (175us) | Total: 0.0% (175us) | Samples: 1

**Called by:**
- `get properties` (1)

### `_runSelectorList`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5976` | Self: 0.0% (175us) | Total: 0.0% (175us) | Samples: 1

**Called by:**
- `invokeSelectorHandlers` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6816` | Self: 0.0% (174us) | Total: 0.0% (174us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:651` | Self: 0.0% (174us) | Total: 0.0% (335us) | Samples: 1

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `isRead` (1)

### `hasObservableSideEffectsForRegExpSplit`
`[native code]` | Self: 0.0% (174us) | Total: 0.0% (174us) | Samples: 1

**Called by:**
- `[Symbol.split]` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2822` | Self: 0.0% (174us) | Total: 0.0% (174us) | Samples: 1

**Called by:**
- `_buildScopeRefsAndThrough` (1)

### `getFunctionNameWithKind`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2181` | Self: 0.0% (174us) | Total: 0.0% (352us) | Samples: 1

**Called by:**
- `checkLastSegment` (1)
- `ReturnStatement` (1)

**Calls:**
- `get name` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (174us) | Total: 0.0% (174us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `Program`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:290` | Self: 0.0% (173us) | Total: 0.0% (173us) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:488` | Self: 0.0% (173us) | Total: 0.0% (173us) | Samples: 1

**Called by:**
- `parseSource` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3046` | Self: 0.0% (173us) | Total: 0.0% (461us) | Samples: 1

**Called by:**
- `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause` (2)
- `checkForFunction` (1)

**Calls:**
- `Set` (2)

### `isModifyingProp`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:127` | Self: 0.0% (173us) | Total: 0.0% (173us) | Samples: 1

**Called by:**
- `checkReference` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2378` | Self: 0.0% (173us) | Total: 0.0% (173us) | Samples: 1

**Called by:**
- `getScope` (1)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4868` | Self: 0.0% (173us) | Total: 0.0% (173us) | Samples: 1

**Called by:**
- `_buildPlan` (1)

### `_loadFromDisk`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js` | Self: 0.0% (173us) | Total: 0.0% (173us) | Samples: 1

**Called by:**
- `_getPlugin` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:123` | Self: 0.0% (173us) | Total: 0.0% (173us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `invokeSelectorHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (173us) | Total: 0.0% (173us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:387` | Self: 0.0% (173us) | Total: 0.0% (173us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4030` | Self: 0.0% (172us) | Total: 0.0% (172us) | Samples: 1

**Called by:**
- `map` (1)

### `/^(?:DoWhile\|For\|ForIn\|ForOf\|While)Statement$/u`
`[native code]` | Self: 0.0% (172us) | Total: 0.0% (172us) | Samples: 1

**Called by:**
- `isLoop` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4222` | Self: 0.0% (172us) | Total: 0.0% (789us) | Samples: 1

**Called by:**
- `AstView` (5)

**Calls:**
- `Uint32Array` (4)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2614` | Self: 0.0% (172us) | Total: 0.0% (172us) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `[Symbol.iterator]`
`[native code]` | Self: 0.0% (172us) | Total: 0.0% (172us) | Samples: 1

**Called by:**
- `findVariablesInScope` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (172us) | Total: 0.0% (172us) | Samples: 1

**Called by:**
- `isInRange` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1238` | Self: 0.0% (172us) | Total: 0.0% (172us) | Samples: 1

**Called by:**
- `_findDefNode` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6752` | Self: 0.0% (172us) | Total: 0.0% (172us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `isOuterVariableInDestructing`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:79` | Self: 0.0% (172us) | Total: 0.0% (172us) | Samples: 1

**Called by:**
- `some` (1)

### `findVariablesInScope`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:94` | Self: 0.0% (172us) | Total: 0.8% (7.0ms) | Samples: 1

**Called by:**
- `Program` (39)
- `checkForBlock` (1)

**Calls:**
- `get` (39)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5651` | Self: 0.0% (171us) | Total: 0.9% (8.0ms) | Samples: 1

**Called by:**
- `_getOrBuildPlan` (48)

**Calls:**
- `_getSelectorRootTypes` (26)
- `_getSelectorRootTypes` (13)
- `_getSelectorRootTypes` (3)
- `_getSelectorRootTypes` (1)
- `_getSelectorRootTypes` (1)
- `_getSelectorRootTypes` (1)
- `_getSelectorRootTypes` (1)
- `_getSelectorRootTypes` (1)

### `bound`
`node:os:107` | Self: 0.0% (171us) | Total: 0.0% (171us) | Samples: 1

**Called by:**
- `node:os` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4033` | Self: 0.0% (171us) | Total: 0.0% (171us) | Samples: 1

**Called by:**
- `get parent` (1)

### `_isSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4031` | Self: 0.0% (171us) | Total: 0.0% (864us) | Samples: 1

**Called by:**
- `buildVisitorMap` (5)

**Calls:**
- `every` (4)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:80` | Self: 0.0% (171us) | Total: 0.0% (171us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `speciesConstructor`
`[native code]` | Self: 0.0% (171us) | Total: 0.0% (171us) | Samples: 1

**Called by:**
- `[Symbol.split]` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1380` | Self: 0.0% (171us) | Total: 0.0% (171us) | Samples: 1

**Called by:**
- `invokeMethodFnHandlers` (1)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5285` | Self: 0.0% (171us) | Total: 0.0% (315us) | Samples: 1

**Called by:**
- `walkNodes` (2)

**Calls:**
- `Set` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (171us) | Total: 0.0% (171us) | Samples: 1

**Called by:**
- `parseSource` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:383` | Self: 0.0% (171us) | Total: 0.0% (171us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `getIdentifierIfShouldBeConst`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:218` | Self: 0.0% (171us) | Total: 0.0% (346us) | Samples: 1

**Called by:**
- `groupByDestructuring` (2)

**Calls:**
- `get properties` (1)

### `_getTypeProto`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3976` | Self: 0.0% (171us) | Total: 0.0% (508us) | Samples: 1

**Called by:**
- `_nodeViewRaw` (3)

**Calls:**
- `getOwnPropertyDescriptors` (1)
- `create` (1)

### `CfgSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4289` | Self: 0.0% (170us) | Total: 0.0% (170us) | Samples: 1

**Called by:**
- `segment` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6445` | Self: 0.0% (170us) | Total: 0.0% (170us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `get mainToken`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (170us) | Total: 0.0% (170us) | Samples: 1

**Called by:**
- `get value` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:51` | Self: 0.0% (170us) | Total: 0.0% (170us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5263` | Self: 0.0% (170us) | Total: 1.1% (9.7ms) | Samples: 1

**Called by:**
- `walkNodes` (48)

**Calls:**
- `_compileSelectorFastMatcher` (31)
- `_compileSelectorFastMatcher` (7)
- `_compileSelectorFastMatcher` (3)
- `_compileSelectorFastMatcher` (2)
- `_compileSelectorFastMatcher` (1)
- `_compileSelectorFastMatcher` (1)
- `_compileSelectorFastMatcher` (1)
- `_compileSelectorFastMatcher` (1)

### `getArrayMethodName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:72` | Self: 0.0% (169us) | Total: 0.0% (169us) | Samples: 1

**Called by:**
- `onCodePathStart` (1)

### `_rawTokenText`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:781` | Self: 0.0% (169us) | Total: 0.0% (169us) | Samples: 1

**Called by:**
- `get value` (1)

### `get property`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1946` | Self: 0.0% (169us) | Total: 0.0% (169us) | Samples: 1

**Called by:**
- `getStaticPropertyName` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5653` | Self: 0.0% (169us) | Total: 0.0% (169us) | Samples: 1

**Called by:**
- `_getOrBuildPlan` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:743` | Self: 0.0% (169us) | Total: 0.0% (169us) | Samples: 1

**Called by:**
- `getFirstToken` (1)

### `isNullCheck`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:125` | Self: 0.0% (169us) | Total: 0.0% (486us) | Samples: 1

**Called by:**
- `BinaryExpression` (3)

**Calls:**
- `isNullLiteral` (1)
- `get right` (1)

### `fn`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5031` | Self: 0.0% (169us) | Total: 0.0% (312us) | Samples: 1

**Called by:**
- `fn` (2)

**Calls:**
- `get type` (1)

### `_deepMergeObjects`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:127` | Self: 0.0% (169us) | Total: 0.0% (169us) | Samples: 1

**Called by:**
- `map` (1)

### `_computeMinTok`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:529` | Self: 0.0% (169us) | Total: 0.0% (169us) | Samples: 1

**Called by:**
- `getFirstToken` (1)

### `fn`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5032` | Self: 0.0% (169us) | Total: 0.0% (169us) | Samples: 1

**Called by:**
- `fn` (1)

### `shouldCheck`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:369` | Self: 0.0% (168us) | Total: 0.0% (168us) | Samples: 1

**Called by:**
- `filter` (1)

### `ensureRefsThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (168us) | Total: 0.0% (168us) | Samples: 1

**Called by:**
- `get` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1929` | Self: 0.0% (168us) | Total: 0.0% (509us) | Samples: 1

**Called by:**
- `_buildScope` (3)

**Calls:**
- `get directive` (1)
- `get directive` (1)

### `_isStatementTag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:77` | Self: 0.0% (168us) | Total: 0.0% (168us) | Samples: 1

**Called by:**
- `get range` (1)

### `(anonymous)`
`[native code]` | Self: 0.0% (168us) | Total: 0.2% (1.7ms) | Samples: 1

**Called by:**
- `bound require` (4)
- `loadBinding` (1)

**Calls:**
- `dlopen` (4)
- `requestSatisfyUtil` (3)
- `forEach` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4229` | Self: 0.0% (168us) | Total: 0.0% (168us) | Samples: 1

**Called by:**
- `AstView` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4237` | Self: 0.0% (168us) | Total: 0.0% (168us) | Samples: 1

**Called by:**
- `AstView` (1)

### `getAssignedMessageData`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:309` | Self: 0.0% (167us) | Total: 0.0% (167us) | Samples: 1

**Called by:**
- `Program:exit` (1)

### `safeHandler`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (167us) | Total: 0.0% (167us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:289` | Self: 0.0% (167us) | Total: 0.0% (167us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2175` | Self: 0.0% (167us) | Total: 0.0% (167us) | Samples: 1

**Called by:**
- `ensureVarsSet` (1)

### `isClassStaticInitializerScope`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:88` | Self: 0.0% (167us) | Total: 0.0% (167us) | Samples: 1

**Called by:**
- `isFromSeparateExecutionContext` (1)

### `a`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` | Self: 0.0% (167us) | Total: 0.0% (167us) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get left`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1766` | Self: 0.0% (167us) | Total: 0.0% (167us) | Samples: 1

**Called by:**
- `isNullCheck` (1)

### `hasObservableSideEffectsForRegExpMatch`
`[native code]` | Self: 0.0% (167us) | Total: 0.0% (167us) | Samples: 1

**Called by:**
- `[Symbol.match]` (1)

### `_cookTemplate`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:28` | Self: 0.0% (166us) | Total: 0.0% (166us) | Samples: 1

**Called by:**
- `get value` (1)

### `_extractBatchScannable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4665` | Self: 0.0% (166us) | Total: 0.0% (166us) | Samples: 1

**Called by:**
- `_buildPlan` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5665` | Self: 0.0% (166us) | Total: 0.0% (836us) | Samples: 1

**Called by:**
- `_getOrBuildPlan` (5)

**Calls:**
- `indexOf` (4)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2803` | Self: 0.0% (166us) | Total: 0.0% (166us) | Samples: 1

**Called by:**
- `_buildScopeRefsAndThrough` (1)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:773` | Self: 0.0% (166us) | Total: 0.0% (166us) | Samples: 1

**Called by:**
- `get name` (1)

### `iterateDeclarations`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js` | Self: 0.0% (166us) | Total: 0.0% (166us) | Samples: 1

**Called by:**
- `findVariablesInScope` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4031` | Self: 0.0% (166us) | Total: 0.0% (535us) | Samples: 1

**Called by:**
- `every` (3)

**Calls:**
- `/^[A-Z][A-Za-z]*$/` (2)

### `runOnce`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:84` | Self: 0.0% (166us) | Total: 0.0% (166us) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:452` | Self: 0.0% (166us) | Total: 0.0% (166us) | Samples: 1

**Called by:**
- `parseSource` (1)

### `kw`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` | Self: 0.0% (166us) | Total: 0.0% (166us) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getArrayMethodName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:124` | Self: 0.0% (166us) | Total: 0.3% (2.8ms) | Samples: 1

**Called by:**
- `onCodePathStart` (17)

**Calls:**
- `isSpecificMemberAccess` (13)
- `isSpecificMemberAccess` (1)
- `get callee` (1)
- `nodeViewChain` (1)

### `_getSelectorRootTypes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5587` | Self: 0.0% (165us) | Total: 0.0% (165us) | Samples: 1

**Called by:**
- `_getOrBuildSelectorPlan` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6825` | Self: 0.0% (165us) | Total: 0.0% (165us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_scopeForNode`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:847` | Self: 0.0% (165us) | Total: 0.0% (165us) | Samples: 1

**Called by:**
- `getScope` (1)

### `get computed`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1978` | Self: 0.0% (165us) | Total: 0.0% (165us) | Samples: 1

**Called by:**
- `accessPath` (1)

### `replaceTextRange`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/fix-tracker.js:97` | Self: 0.0% (165us) | Total: 0.0% (165us) | Samples: 1

**Called by:**
- `_execReport` (1)

### `replaceTextRange`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (165us) | Total: 0.0% (165us) | Samples: 1

**Called by:**
- `_execReport` (1)

### `isExported`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:358` | Self: 0.0% (165us) | Total: 0.0% (165us) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1384` | Self: 0.0% (165us) | Total: 0.0% (827us) | Samples: 1

**Called by:**
- `_buildScope` (1)
- `equalsToOriginalName` (1)
- `isNullLiteral` (1)
- `invokeMethodFnHandlers` (1)

**Calls:**
- `get mainToken` (1)
- `slice` (1)
- `_rawTokenText` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6505` | Self: 0.0% (165us) | Total: 0.0% (165us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `extraArrowData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:676` | Self: 0.0% (165us) | Total: 0.0% (165us) | Samples: 1

**Called by:**
- `get body` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2341` | Self: 0.0% (164us) | Total: 0.0% (164us) | Samples: 1

**Called by:**
- `ensureChildren` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5903` | Self: 0.0% (164us) | Total: 0.0% (164us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `Program`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:272` | Self: 0.0% (164us) | Total: 0.5% (4.6ms) | Samples: 1

**Called by:**
- `_invokeFused` (26)

**Calls:**
- `get` (25)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (164us) | Total: 0.0% (164us) | Samples: 1

**Called by:**
- `ensureRefsThrough` (1)

### `ge`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` | Self: 0.0% (164us) | Total: 0.0% (164us) | Samples: 1

**Called by:**
- `Ee` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4056` | Self: 0.0% (163us) | Total: 0.0% (163us) | Samples: 1

**Called by:**
- `checkGroup` (1)

### `checkForShadows`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:649` | Self: 0.0% (163us) | Total: 0.0% (163us) | Samples: 1

**Called by:**
- `Program:exit` (1)

### `resolve`
`[native code]` | Self: 0.0% (163us) | Total: 0.0% (163us) | Samples: 1

**Called by:**
- `async (anonymous)` (1)

### `get flags`
`[native code]` | Self: 0.0% (163us) | Total: 0.0% (163us) | Samples: 1

**Called by:**
- `toString` (1)

### `applyDisableDirectives`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7441` | Self: 0.0% (163us) | Total: 0.0% (163us) | Samples: 1

**Called by:**
- `runOnce` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1325` | Self: 0.0% (163us) | Total: 0.0% (783us) | Samples: 1

**Called by:**
- `Program` (2)
- `_buildScopeRefsAndThrough` (1)
- `_buildScopeRefsAndThrough` (1)
- `getStaticPropertyName` (1)

**Calls:**
- `get _tag` (3)
- `get _tag` (1)

### `buildUnicodeData`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` | Self: 0.0% (163us) | Total: 0.0% (163us) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4071` | Self: 0.0% (163us) | Total: 0.0% (163us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` | Self: 0.0% (162us) | Total: 0.0% (354us) | Samples: 1

**Called by:**
- `some` (2)

**Calls:**
- `get type` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1978` | Self: 0.0% (162us) | Total: 0.0% (162us) | Samples: 1

**Called by:**
- `ensureVarsSet` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4190` | Self: 0.0% (162us) | Total: 0.0% (162us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:117` | Self: 0.0% (162us) | Total: 0.0% (162us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2685` | Self: 0.0% (162us) | Total: 0.0% (162us) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1471` | Self: 0.0% (162us) | Total: 0.0% (162us) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1700` | Self: 0.0% (162us) | Total: 0.0% (721us) | Samples: 1

**Called by:**
- `_computeIsStrict` (2)
- `checkLastSegment` (2)

**Calls:**
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `nodeView` (1)

### `onUnreachableCodePathSegmentStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js` | Self: 0.0% (162us) | Total: 0.0% (162us) | Samples: 1

**Called by:**
- `_dispatchSeg` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2190` | Self: 0.0% (162us) | Total: 0.0% (162us) | Samples: 1

**Called by:**
- `ensureRefsThrough` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2183` | Self: 0.0% (162us) | Total: 0.0% (162us) | Samples: 1

**Called by:**
- `ensureRefsThrough` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:769` | Self: 0.0% (162us) | Total: 0.0% (162us) | Samples: 1

**Called by:**
- `Program:exit` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js` | Self: 0.0% (162us) | Total: 0.0% (162us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `isRead`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (161us) | Total: 0.0% (161us) | Samples: 1

**Called by:**
- `isReadForItself` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:716` | Self: 0.0% (161us) | Total: 0.0% (161us) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:338` | Self: 0.0% (161us) | Total: 0.0% (826us) | Samples: 1

**Called by:**
- `parseSource` (5)

**Calls:**
- `Uint8Array` (4)

### `get local`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3477` | Self: 0.0% (161us) | Total: 0.0% (338us) | Samples: 1

**Called by:**
- `_buildVariable` (2)

**Calls:**
- `get _tag` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1620` | Self: 0.0% (161us) | Total: 0.0% (161us) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `getDefinedMessageData`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:274` | Self: 0.0% (161us) | Total: 0.0% (161us) | Samples: 1

**Called by:**
- `Program:exit` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:126` | Self: 0.0% (161us) | Total: 0.0% (161us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `getFunctionHeadLoc`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2308` | Self: 0.0% (161us) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `checkLastSegment` (10)

**Calls:**
- `getFirstToken` (4)
- `getFirstToken` (1)
- `getTokenAfter` (1)
- `getTokenAfter` (1)
- `getTokenAfter` (1)
- `getFirstToken` (1)

### `/[iI]gnored/u`
`[native code]` | Self: 0.0% (161us) | Total: 0.0% (161us) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `runOnce`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js` | Self: 0.0% (161us) | Total: 0.0% (161us) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4255` | Self: 0.0% (161us) | Total: 0.1% (1.1ms) | Samples: 1

**Called by:**
- `runPlugins` (7)

**Calls:**
- `_makeSafeHandler` (4)
- `_makeSafeHandler` (2)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1612` | Self: 0.0% (161us) | Total: 0.0% (161us) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2880` | Self: 0.0% (161us) | Total: 0.1% (1.1ms) | Samples: 1

**Called by:**
- `_buildThinScope` (3)
- `_buildReference` (2)
- `_buildVariable` (1)

**Calls:**
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)
- `nodeView` (1)
- `_nodeViewRaw` (1)

### `_getSelectorRootTypes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5601` | Self: 0.0% (161us) | Total: 0.0% (161us) | Samples: 1

**Called by:**
- `_getSelectorRootTypes` (1)

### `getStaticStringValue`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js` | Self: 0.0% (160us) | Total: 0.0% (160us) | Samples: 1

**Called by:**
- `isSpecificMemberAccess` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` | Self: 0.0% (160us) | Total: 0.1% (1.4ms) | Samples: 1

**Called by:**
- `some` (9)

**Calls:**
- `isForInOfRef` (3)
- `isForInOfRef` (2)
- `isForInOfRef` (1)
- `isForInOfRef` (1)
- `isForInOfRef` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6101` | Self: 0.0% (160us) | Total: 0.0% (160us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `getTagNames`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:189` | Self: 0.0% (160us) | Total: 0.0% (160us) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `isUnusedExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:513` | Self: 0.0% (160us) | Total: 0.0% (160us) | Samples: 1

**Called by:**
- `isReadForItself` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6464` | Self: 0.0% (160us) | Total: 0.0% (160us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `segment`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4250` | Self: 0.0% (160us) | Total: 0.0% (509us) | Samples: 1

**Called by:**
- `initialSegment` (2)
- `get initialSegment` (1)

**Calls:**
- `CfgSegment` (1)
- `CfgSegment` (1)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:807` | Self: 0.0% (160us) | Total: 0.0% (160us) | Samples: 1

**Called by:**
- `_symName` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2962` | Self: 0.0% (160us) | Total: 0.0% (160us) | Samples: 1

**Called by:**
- `_buildThinVariable` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6359` | Self: 0.0% (159us) | Total: 0.0% (159us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `invokeSelectorHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6022` | Self: 0.0% (159us) | Total: 0.0% (159us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `describeRule`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:32` | Self: 0.0% (159us) | Total: 0.0% (159us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `ObjectExpression > Property[computed!=true] > Identifier.key,MethodDefinition[computed!=true] > Identifier.key,PropertyDefinition[computed!=true] > Identifier.key,MethodDefinition > PrivateIdentifier.key,PropertyDefinition > PrivateIdentifier.key`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:351` | Self: 0.0% (159us) | Total: 0.0% (159us) | Samples: 1

**Called by:**
- `_runSelectorList` (1)

### `equalsToOriginalName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:178` | Self: 0.0% (159us) | Total: 0.0% (159us) | Samples: 1

**Called by:**
- `reportReferenceId` (1)

### `replace`
`[native code]` | Self: 0.0% (158us) | Total: 0.0% (158us) | Samples: 1

**Called by:**
- `wordsRegexp` (1)

### `every`
`[native code]` | Self: 0.0% (158us) | Total: 0.0% (837us) | Samples: 1

**Called by:**
- `_isSelector` (4)
- `checkGroup` (1)

**Calls:**
- `(anonymous)` (3)
- `(anonymous)` (1)

### `ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (158us) | Total: 0.0% (158us) | Samples: 1

**Called by:**
- `get` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:179` | Self: 0.0% (158us) | Total: 0.0% (158us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` | Self: 0.0% (158us) | Total: 0.0% (158us) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `hasRestSpreadSibling`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` | Self: 0.0% (158us) | Total: 0.0% (158us) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5771` | Self: 0.0% (158us) | Total: 2.5% (22.2ms) | Samples: 1

**Called by:**
- `_getOrBuildPlan` (127)

**Calls:**
- `_extractFileLevelRules` (25)
- `_extractFileLevelRules` (24)
- `_extractFileLevelRules` (21)
- `_extractFileLevelRules` (19)
- `_extractFileLevelRules` (8)
- `_extractFileLevelRules` (7)
- `_extractFileLevelRules` (5)
- `_extractFileLevelRules` (5)
- `_extractFileLevelRules` (3)
- `_extractFileLevelRules` (2)
- `_extractFileLevelRules` (2)
- `_extractFileLevelRules` (1)
- `_extractFileLevelRules` (1)
- `_extractFileLevelRules` (1)
- `_extractFileLevelRules` (1)
- `_extractFileLevelRules` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:440` | Self: 0.0% (158us) | Total: 0.0% (510us) | Samples: 1

**Called by:**
- `parseSource` (3)

**Calls:**
- `get byteLength` (2)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:541` | Self: 0.0% (158us) | Total: 0.0% (158us) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (158us) | Total: 0.0% (158us) | Samples: 1

**Called by:**
- `_makeToken` (1)

### `join`
`[native code]` | Self: 0.0% (158us) | Total: 0.0% (158us) | Samples: 1

**Called by:**
- `checkLastSegment` (1)

### `toUpperCase`
`[native code]` | Self: 0.0% (158us) | Total: 0.0% (158us) | Samples: 1

**Called by:**
- `isUnderscored` (1)

### `checkLastSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:393` | Self: 0.0% (157us) | Total: 0.0% (157us) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4004` | Self: 0.0% (157us) | Total: 0.0% (157us) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `getNameRange`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:456` | Self: 0.0% (157us) | Total: 0.1% (989us) | Samples: 1

**Called by:**
- `isInTdz` (5)
- `isInTdz` (1)

**Calls:**
- `get range` (2)
- `get range` (2)
- `get range` (1)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4855` | Self: 0.0% (156us) | Total: 0.0% (156us) | Samples: 1

**Called by:**
- `_buildPlan` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:841` | Self: 0.0% (156us) | Total: 0.0% (156us) | Samples: 1

**Called by:**
- `some` (1)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5260` | Self: 0.0% (156us) | Total: 1.2% (10.9ms) | Samples: 1

**Called by:**
- `walkNodes` (66)

**Calls:**
- `_getSelectorRootTypes` (38)
- `_getSelectorRootTypes` (9)
- `_getSelectorRootTypes` (8)
- `_getSelectorRootTypes` (2)
- `_getSelectorRootTypes` (2)
- `_getSelectorRootTypes` (2)
- `_getSelectorRootTypes` (1)
- `_getSelectorRootTypes` (1)
- `_getSelectorRootTypes` (1)
- `_getSelectorRootTypes` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js` | Self: 0.0% (156us) | Total: 0.0% (156us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3055` | Self: 0.0% (156us) | Total: 0.0% (156us) | Samples: 1

**Called by:**
- `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause` (1)

### `get nodeTags`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:602` | Self: 0.0% (156us) | Total: 0.0% (156us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `bound require`
`[native code]` | Self: 0.0% (156us) | Total: 5.7% (50.1ms) | Samples: 1

**Called by:**
- `(anonymous)` (66)
- `(anonymous)` (44)
- `(anonymous)` (27)
- `(anonymous)` (24)
- `esquery` (17)
- `(anonymous)` (17)
- `(anonymous)` (16)
- `(anonymous)` (11)
- `(anonymous)` (11)
- `(anonymous)` (8)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `loadBinding` (5)
- `(anonymous)` (3)
- `_getFfiSelector` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `_tryLoad` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `require` (265)
- `anonymous` (22)
- `(anonymous)` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5891` | Self: 0.0% (156us) | Total: 0.0% (156us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `getTokenAfter`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1261` | Self: 0.0% (156us) | Total: 0.0% (156us) | Samples: 1

**Called by:**
- `getFunctionHeadLoc` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1295` | Self: 0.0% (156us) | Total: 0.0% (156us) | Samples: 1

**Called by:**
- `MemberExpression[computed!=true] > Identifier.property` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4213` | Self: 0.0% (156us) | Total: 0.0% (156us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `replaceText`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3696` | Self: 0.0% (156us) | Total: 0.0% (156us) | Samples: 1

**Called by:**
- `_execReport` (1)

### `describeRule`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:30` | Self: 0.0% (156us) | Total: 0.1% (1.0ms) | Samples: 1

**Called by:**
- `buildVisitorMap` (6)

**Calls:**
- `_getPlugin` (4)
- `_getPlugin` (1)

### `onCodePathSegmentStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:434` | Self: 0.0% (155us) | Total: 0.0% (155us) | Samples: 1

**Called by:**
- `_dispatchSeg` (1)

### `_extractBatchScannable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4688` | Self: 0.0% (155us) | Total: 0.0% (155us) | Samples: 1

**Called by:**
- `_buildPlan` (1)

### `/:([a-z-]+)\([^)]*\)/g`
`[native code]` | Self: 0.0% (155us) | Total: 0.0% (155us) | Samples: 1

**Called by:**
- `_getSelectorRootTypes` (1)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4853` | Self: 0.0% (155us) | Total: 0.0% (155us) | Samples: 1

**Called by:**
- `_buildPlan` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2216` | Self: 0.0% (155us) | Total: 0.0% (155us) | Samples: 1

**Called by:**
- `ensureRefsThrough` (1)

### `/(?:Statement\|Declaration\|Function(?:Expression)?\|Program)$/u`
`[native code]` | Self: 0.0% (155us) | Total: 0.0% (155us) | Samples: 1

**Called by:**
- `isModifyingProp` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` | Self: 0.0% (155us) | Total: 0.9% (8.2ms) | Samples: 1

**Called by:**
- `collectUnusedVariables` (47)
- `collectUnusedVariables` (2)

**Calls:**
- `some` (48)

### `_compileSelectorFastMatcher`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5120` | Self: 0.0% (155us) | Total: 0.0% (155us) | Samples: 1

**Called by:**
- `_getOrBuildSelectorPlan` (1)

### `get test`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1598` | Self: 0.0% (154us) | Total: 0.0% (154us) | Samples: 1

**Called by:**
- `unwrapExpression` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1923` | Self: 0.0% (154us) | Total: 0.4% (3.7ms) | Samples: 1

**Called by:**
- `_buildScope` (23)

**Calls:**
- `get body` (14)
- `get body` (7)
- `get body` (1)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (154us) | Total: 0.0% (154us) | Samples: 1

**Called by:**
- `getFunctionHeadLoc` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6536` | Self: 0.0% (154us) | Total: 0.0% (154us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2636` | Self: 0.0% (154us) | Total: 0.0% (489us) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (2)
- `getDeclaredVariables` (1)

**Calls:**
- `_buildThinVariable` (1)
- `_buildThinVariable` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6417` | Self: 0.0% (154us) | Total: 0.0% (154us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `delete`
`[native code]` | Self: 0.0% (153us) | Total: 0.0% (153us) | Samples: 1

**Called by:**
- `onUnreachableCodePathSegmentEnd` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1673` | Self: 0.0% (153us) | Total: 0.1% (1.1ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (6)

**Calls:**
- `get value` (2)
- `get value` (1)
- `get value` (1)
- `get value` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:384` | Self: 0.0% (153us) | Total: 0.0% (153us) | Samples: 1

**Called by:**
- `_buildThinVariable` (1)

### `checkGroup`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:426` | Self: 0.0% (152us) | Total: 0.0% (501us) | Samples: 1

**Called by:**
- `forEach` (3)

**Calls:**
- `get parent` (1)
- `nodeViewChain` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4991` | Self: 0.0% (152us) | Total: 0.0% (152us) | Samples: 1

**Called by:**
- `filter` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4249` | Self: 0.0% (152us) | Total: 0.2% (2.5ms) | Samples: 1

**Called by:**
- `runPlugins` (15)

**Calls:**
- `_expandUnion` (7)
- `_expandUnion` (4)
- `_expandUnion` (2)
- `map` (1)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:90` | Self: 0.0% (152us) | Total: 0.0% (793us) | Samples: 1

**Called by:**
- `parseSource` (5)

**Calls:**
- `ensureBufferBytes` (2)
- `ensureBufferBytes` (1)
- `ensureBufferBytes` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1735` | Self: 0.0% (152us) | Total: 0.0% (152us) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2524` | Self: 0.0% (152us) | Total: 1.0% (9.1ms) | Samples: 1

**Called by:**
- `getDeclaredVariables` (34)
- `_buildScopeVarsAndSet` (20)

**Calls:**
- `_buildReference` (20)
- `_buildReference` (15)
- `_buildReference` (4)
- `_buildReference` (4)
- `_buildReference` (3)
- `_buildReference` (3)
- `_buildReference` (2)
- `_buildReference` (1)
- `_buildReference` (1)

### `ke`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` | Self: 0.0% (152us) | Total: 0.0% (152us) | Samples: 1

**Called by:**
- `we` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1694` | Self: 0.0% (152us) | Total: 0.0% (152us) | Samples: 1

**Called by:**
- `filter` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:412` | Self: 0.0% (151us) | Total: 0.0% (151us) | Samples: 1

**Called by:**
- `parseSource` (1)

### `checkLastSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:316` | Self: 0.0% (151us) | Total: 0.0% (151us) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:318` | Self: 0.0% (151us) | Total: 0.1% (1.1ms) | Samples: 1

**Called by:**
- `_invokeFused` (7)

**Calls:**
- `getDeclaredVariables` (2)
- `getDeclaredVariables` (1)
- `getDeclaredVariables` (1)
- `getDeclaredVariables` (1)
- `getDeclaredVariables` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5051` | Self: 0.0% (151us) | Total: 0.0% (151us) | Samples: 1

**Called by:**
- `some` (1)

### `get kind`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (151us) | Total: 0.0% (151us) | Samples: 1

**Called by:**
- `VariableDeclaration` (1)

### `checkVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:227` | Self: 0.0% (151us) | Total: 0.0% (151us) | Samples: 1

**Called by:**
- `forEach` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:460` | Self: 0.0% (151us) | Total: 0.0% (497us) | Samples: 1

**Called by:**
- `parseSource` (3)

**Calls:**
- `Uint32Array` (2)

### `slotTemplate`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5798` | Self: 0.0% (150us) | Total: 0.3% (3.4ms) | Samples: 1

**Called by:**
- `_buildTemplate` (11)
- `_buildTemplate` (10)

**Calls:**
- `map` (20)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:818` | Self: 0.0% (150us) | Total: 0.0% (150us) | Samples: 1

**Called by:**
- `_symName` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3028` | Self: 0.0% (150us) | Total: 0.0% (150us) | Samples: 1

**Called by:**
- `checkForFunction` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2945` | Self: 0.0% (150us) | Total: 0.0% (564us) | Samples: 1

**Called by:**
- `_buildThinVariable` (1)
- `_buildThinScope` (1)
- `_buildVariable` (1)

**Calls:**
- `_buildThinScope` (1)
- `_buildThinScope` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1699` | Self: 0.0% (150us) | Total: 0.0% (439us) | Samples: 1

**Called by:**
- `_computeIsStrict` (2)
- `checkLastSegment` (1)

**Calls:**
- `extraFnData` (2)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2275` | Self: 0.0% (150us) | Total: 0.0% (150us) | Samples: 1

**Called by:**
- `ensureRefsThrough` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:313` | Self: 0.0% (150us) | Total: 0.0% (337us) | Samples: 1

**Called by:**
- `parseSource` (2)

**Calls:**
- `Uint32Array` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2813` | Self: 0.0% (150us) | Total: 0.7% (6.3ms) | Samples: 1

**Called by:**
- `_buildScopeRefsAndThrough` (22)
- `_buildVariable` (15)

**Calls:**
- `get parent` (18)
- `get parent` (7)
- `get parent` (7)
- `get parent` (2)
- `get parent` (2)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1019` | Self: 0.0% (150us) | Total: 0.0% (150us) | Samples: 1

**Called by:**
- `isFunction` (1)

### `get id`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2259` | Self: 0.0% (150us) | Total: 0.0% (342us) | Samples: 1

**Called by:**
- `_buildScope` (2)

**Calls:**
- `nodeLhs` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:136` | Self: 0.0% (150us) | Total: 0.0% (150us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2439` | Self: 0.0% (149us) | Total: 0.1% (918us) | Samples: 1

**Called by:**
- `getScope` (6)

**Calls:**
- `get` (5)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6458` | Self: 0.0% (149us) | Total: 0.0% (149us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6467` | Self: 0.0% (149us) | Total: 0.0% (149us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_deepMergeObjects`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:128` | Self: 0.0% (149us) | Total: 0.1% (1.1ms) | Samples: 1

**Called by:**
- `map` (4)
- `(anonymous)` (3)

**Calls:**
- `propertyIsEnumerable` (6)

### `VariableDeclaration`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:549` | Self: 0.0% (149us) | Total: 0.8% (7.6ms) | Samples: 1

**Called by:**
- `_invokeFused` (45)

**Calls:**
- `getDeclaredVariables` (37)
- `getDeclaredVariables` (5)
- `getDeclaredVariables` (1)
- `getDeclaredVariables` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5064` | Self: 0.0% (149us) | Total: 0.0% (149us) | Samples: 1

**Called by:**
- `fn` (1)

### `getDefinedMessageData`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` | Self: 0.0% (149us) | Total: 0.0% (149us) | Samples: 1

**Called by:**
- `Program:exit` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1037` | Self: 0.0% (148us) | Total: 0.0% (148us) | Samples: 1

**Called by:**
- `canBecomeVariableDeclaration` (1)

### `_getSelectorRootTypes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (148us) | Total: 0.0% (148us) | Samples: 1

**Called by:**
- `_buildPlan` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4288` | Self: 0.0% (148us) | Total: 0.0% (148us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2939` | Self: 0.0% (148us) | Total: 0.0% (148us) | Samples: 1

**Called by:**
- `_buildThinVariable` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:399` | Self: 0.0% (148us) | Total: 0.0% (615us) | Samples: 1

**Called by:**
- `_buildVariable` (3)
- `_buildThinVariable` (1)

**Calls:**
- `get _tag` (3)

### `_getFfiSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:105` | Self: 0.0% (148us) | Total: 0.0% (148us) | Samples: 1

**Called by:**
- `_getOrBuildSelectorPlan` (1)

### `isExported`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:363` | Self: 0.0% (148us) | Total: 0.0% (148us) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `defineProperty`
`[native code]` | Self: 0.0% (148us) | Total: 0.0% (148us) | Samples: 1

**Called by:**
- `node:events` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (147us) | Total: 0.0% (147us) | Samples: 1

**Called by:**
- `AstView` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4258` | Self: 0.0% (147us) | Total: 0.0% (147us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2844` | Self: 0.0% (147us) | Total: 0.0% (147us) | Samples: 1

**Called by:**
- `_buildVariable` (1)

### `_ensureTagCaches`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5532` | Self: 0.0% (147us) | Total: 0.0% (147us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4832` | Self: 0.0% (147us) | Total: 0.0% (147us) | Samples: 1

**Called by:**
- `_buildPlan` (1)

### `_isChainChild`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3866` | Self: 0.0% (147us) | Total: 0.0% (147us) | Samples: 1

**Called by:**
- `nodeViewChain` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:351` | Self: 0.0% (147us) | Total: 0.0% (147us) | Samples: 1

**Called by:**
- `parseSource` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (147us) | Total: 0.0% (147us) | Samples: 1

**Called by:**
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:82` | Self: 0.0% (147us) | Total: 0.0% (147us) | Samples: 1

**Called by:**
- `some` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (146us) | Total: 0.0% (146us) | Samples: 1

**Called by:**
- `getScope` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7373` | Self: 0.0% (146us) | Total: 0.8% (7.7ms) | Samples: 1

**Called by:**
- `runOnce` (46)

**Calls:**
- `reset` (17)
- `reset` (13)
- `get source` (11)
- `get source` (2)
- `reset` (1)
- `source` (1)

### `RuleContext`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (146us) | Total: 0.0% (146us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `parse`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` | Self: 0.0% (146us) | Total: 0.0% (146us) | Samples: 1

**Called by:**
- `g` (1)

### `get properties`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3087` | Self: 0.0% (146us) | Total: 0.0% (146us) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `equalsToOriginalName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js` | Self: 0.0% (146us) | Total: 0.0% (146us) | Samples: 1

**Called by:**
- `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:405` | Self: 0.0% (145us) | Total: 0.0% (670us) | Samples: 1

**Called by:**
- `parseSource` (4)

**Calls:**
- `Uint32Array` (3)

### `isImportAttributeKey`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:1426` | Self: 0.0% (145us) | Total: 0.0% (310us) | Samples: 1

**Called by:**
- `Program` (2)

**Calls:**
- `get parent` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1954` | Self: 0.0% (145us) | Total: 0.0% (145us) | Samples: 1

**Called by:**
- `ensureVarsSet` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (145us) | Total: 0.0% (145us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_compileSelectorFastMatcher`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5048` | Self: 0.0% (145us) | Total: 0.0% (335us) | Samples: 1

**Called by:**
- `_compileSelectorFastMatcher` (2)

**Calls:**
- `filter` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2748` | Self: 0.0% (145us) | Total: 0.0% (145us) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `getStaticStringValue`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:263` | Self: 0.0% (145us) | Total: 0.0% (321us) | Samples: 1

**Called by:**
- `isSpecificMemberAccess` (2)

**Calls:**
- `get quasis` (1)

### `checkText`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:355` | Self: 0.0% (145us) | Total: 0.0% (145us) | Samples: 1

**Called by:**
- `isSpecificMemberAccess` (1)

### `get init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2913` | Self: 0.0% (145us) | Total: 0.0% (145us) | Samples: 1

**Called by:**
- `isEvaluatedDuringInitialization` (1)

### `_compileSelectorFastMatcher`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4983` | Self: 0.0% (144us) | Total: 0.0% (144us) | Samples: 1

**Called by:**
- `_compileSelectorFastMatcher` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` | Self: 0.0% (144us) | Total: 0.0% (144us) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5655` | Self: 0.0% (144us) | Total: 0.0% (144us) | Samples: 1

**Called by:**
- `_getOrBuildPlan` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1649` | Self: 0.0% (144us) | Total: 0.0% (144us) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3614` | Self: 0.0% (144us) | Total: 0.0% (323us) | Samples: 1

**Called by:**
- `getDeclaredLocation` (1)
- `get value` (1)

**Calls:**
- `_lineStarts` (1)

### `evaluate`
`[native code]` | Self: 0.0% (143us) | Total: 0.0% (143us) | Samples: 1

**Called by:**
- `moduleEvaluation` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3774` | Self: 0.0% (143us) | Total: 0.1% (1.1ms) | Samples: 1

**Called by:**
- `report` (7)

**Calls:**
- `(anonymous)` (2)
- `replaceTextRange` (1)
- `replaceTextRange` (1)
- `replaceText` (1)
- `fix` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:818` | Self: 0.0% (143us) | Total: 0.0% (143us) | Samples: 1

**Called by:**
- `Program:exit` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:228` | Self: 0.0% (143us) | Total: 0.0% (143us) | Samples: 1

**Called by:**
- `runOnce` (1)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4844` | Self: 0.0% (143us) | Total: 0.0% (143us) | Samples: 1

**Called by:**
- `_buildPlan` (1)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5944` | Self: 0.0% (143us) | Total: 0.0% (143us) | Samples: 1

**Called by:**
- `_runSelectorList` (1)

### `_getSelectorRootTypes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5563` | Self: 0.0% (143us) | Total: 0.0% (143us) | Samples: 1

**Called by:**
- `_getOrBuildSelectorPlan` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2471` | Self: 0.0% (143us) | Total: 0.0% (143us) | Samples: 1

**Called by:**
- `getScope` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2057` | Self: 0.0% (142us) | Total: 0.0% (329us) | Samples: 1

**Called by:**
- `ensureVarsSet` (2)

**Calls:**
- `get source` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2816` | Self: 0.0% (142us) | Total: 1.1% (10.4ms) | Samples: 1

**Called by:**
- `_buildScopeRefsAndThrough` (42)
- `_buildVariable` (20)

**Calls:**
- `_buildThinVariable` (22)
- `_buildThinVariable` (12)
- `_buildThinVariable` (11)
- `_buildThinVariable` (8)
- `_buildThinVariable` (4)
- `_buildThinVariable` (2)
- `_buildThinVariable` (1)
- `_buildThinVariable` (1)

### `e`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (142us) | Total: 0.0% (142us) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1744` | Self: 0.0% (142us) | Total: 0.0% (142us) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `[Symbol.split]`
`[native code]` | Self: 0.0% (142us) | Total: 0.0% (487us) | Samples: 1

**Called by:**
- `_parseDisableDirectives` (3)

**Calls:**
- `hasObservableSideEffectsForRegExpSplit` (1)
- `speciesConstructor` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6469` | Self: 0.0% (142us) | Total: 0.0% (142us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:323` | Self: 0.0% (142us) | Total: 0.1% (997us) | Samples: 1

**Called by:**
- `parseSource` (6)

**Calls:**
- `Uint32Array` (5)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5956` | Self: 0.0% (142us) | Total: 0.0% (142us) | Samples: 1

**Called by:**
- `_runSelectorList` (1)

### `fn`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5161` | Self: 0.0% (141us) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `_runSelectorList` (10)

**Calls:**
- `fn` (3)
- `fn` (2)
- `fn` (2)
- `fn` (1)
- `fn` (1)

### `ImportDeclaration`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:373` | Self: 0.0% (141us) | Total: 0.0% (141us) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:451` | Self: 0.0% (141us) | Total: 0.0% (464us) | Samples: 1

**Called by:**
- `parseSource` (3)

**Calls:**
- `Uint32Array` (2)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1030` | Self: 0.0% (141us) | Total: 0.0% (141us) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `get callee`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1871` | Self: 0.0% (140us) | Total: 0.0% (140us) | Samples: 1

**Called by:**
- `getArrayMethodName` (1)

### `_nodeEndPos`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:880` | Self: 0.0% (140us) | Total: 0.0% (140us) | Samples: 1

**Called by:**
- `get range` (1)

### `checkForShadows`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:624` | Self: 0.0% (140us) | Total: 0.1% (1.5ms) | Samples: 1

**Called by:**
- `Program:exit` (9)

**Calls:**
- `get` (7)
- `get` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6952` | Self: 0.0% (140us) | Total: 0.0% (140us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6256` | Self: 0.0% (140us) | Total: 0.0% (140us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1011` | Self: 0.0% (140us) | Total: 0.0% (140us) | Samples: 1

**Called by:**
- `isFunction` (1)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5288` | Self: 0.0% (140us) | Total: 0.0% (140us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2333` | Self: 0.0% (140us) | Total: 0.0% (140us) | Samples: 1

**Called by:**
- `ensureChildren` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1012` | Self: 0.0% (139us) | Total: 0.0% (139us) | Samples: 1

**Called by:**
- `_buildScopeRefsAndThrough` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:180` | Self: 0.0% (139us) | Total: 0.0% (139us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:737` | Self: 0.0% (139us) | Total: 0.0% (139us) | Samples: 1

**Called by:**
- `getFirstToken` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5798` | Self: 0.0% (139us) | Total: 0.0% (139us) | Samples: 1

**Called by:**
- `map` (1)

### `get property`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1941` | Self: 0.0% (139us) | Total: 0.0% (139us) | Samples: 1

**Called by:**
- `fn` (1)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4857` | Self: 0.0% (138us) | Total: 0.0% (335us) | Samples: 1

**Called by:**
- `_buildPlan` (2)

**Calls:**
- `push` (1)

### `getUpperFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:130` | Self: 0.0% (138us) | Total: 0.0% (138us) | Samples: 1

**Called by:**
- `isInsideOfStorableFunction` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:370` | Self: 0.0% (138us) | Total: 0.0% (138us) | Samples: 1

**Called by:**
- `parseSource` (1)

### `_deepMergeObjects`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (138us) | Total: 0.0% (138us) | Samples: 1

**Called by:**
- `map` (1)

### `_parseDisableDirectives`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (138us) | Total: 0.0% (138us) | Samples: 1

**Called by:**
- `applyDisableDirectives` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2954` | Self: 0.0% (138us) | Total: 0.0% (703us) | Samples: 1

**Called by:**
- `_buildReference` (2)
- `_buildThinVariable` (1)
- `_buildThinScope` (1)

**Calls:**
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `_getChainExpr`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3913` | Self: 0.0% (137us) | Total: 0.0% (137us) | Samples: 1

**Called by:**
- `getArrayMethodName` (1)

### `checkForShadows`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:656` | Self: 0.0% (137us) | Total: 0.1% (1.1ms) | Samples: 1

**Called by:**
- `Program:exit` (7)

**Calls:**
- `isInTdz` (5)
- `isInTdz` (1)

### `ensureBufferBytes`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js` | Self: 0.0% (137us) | Total: 0.0% (137us) | Samples: 1

**Called by:**
- `_encodeSource` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1958` | Self: 0.0% (137us) | Total: 0.0% (137us) | Samples: 1

**Called by:**
- `ensureVarsSet` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:428` | Self: 0.0% (136us) | Total: 0.0% (136us) | Samples: 1

**Called by:**
- `_buildThinVariable` (1)

### `isFunctionNameInitializerException`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js` | Self: 0.0% (135us) | Total: 0.0% (135us) | Samples: 1

**Called by:**
- `checkForShadows` (1)

### `(anonymous)`
`internal:primordials:39` | Self: 0.0% (135us) | Total: 0.0% (135us) | Samples: 1

**Called by:**
- `forEach` (1)

### `_isChainMiddleTag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3854` | Self: 0.0% (133us) | Total: 0.0% (133us) | Samples: 1

**Called by:**
- `_isChainNode` (1)

### `getFirstToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (122us) | Total: 0.0% (122us) | Samples: 1

**Called by:**
- `getFunctionHeadLoc` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:551` | Self: 0.0% (0us) | Total: 0.0% (174us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isInside` (1)

### `_getSelectorRootTypes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5566` | Self: 0.0% (0us) | Total: 0.0% (184us) | Samples: 0

**Called by:**
- `_buildPlan` (1)

**Calls:**
- `trim` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:436` | Self: 0.0% (0us) | Total: 0.0% (181us) | Samples: 0

**Called by:**
- `forEach` (1)

**Calls:**
- `report` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:790` | Self: 0.0% (0us) | Total: 0.0% (143us) | Samples: 0

**Called by:**
- `getFirstTokenBetween` (1)

**Calls:**
- `_lineStarts` (1)

### `_tryLoad`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:34` | Self: 0.0% (0us) | Total: 0.0% (150us) | Samples: 0

**Called by:**
- `isAvailable` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:12` | Self: 0.0% (0us) | Total: 0.8% (7.6ms) | Samples: 0

**Called by:**
- `anonymous` (44)

**Calls:**
- `bound require` (44)

### `isTypeOfBinary`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:100` | Self: 0.0% (0us) | Total: 0.0% (285us) | Samples: 0

**Called by:**
- `report` (1)

**Calls:**
- `get left` (1)

### `checkVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:228` | Self: 0.0% (0us) | Total: 0.2% (2.4ms) | Samples: 0

**Called by:**
- `forEach` (14)

**Calls:**
- `forEach` (14)

### `_tryLoad`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:46` | Self: 0.0% (0us) | Total: 0.0% (166us) | Samples: 0

**Called by:**
- `isAvailable` (1)

**Calls:**
- `existsSync` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:14` | Self: 0.0% (0us) | Total: 0.0% (853us) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `isFunctionNameInitializerException`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:438` | Self: 0.0% (0us) | Total: 0.0% (331us) | Samples: 0

**Called by:**
- `checkForShadows` (2)

**Calls:**
- `get range` (1)
- `get range` (1)

### `get property`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1943` | Self: 0.0% (0us) | Total: 0.0% (373us) | Samples: 0

**Called by:**
- `fn` (1)
- `getStaticPropertyName` (1)

**Calls:**
- `nodeRhs` (2)

### `ensureRefsThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1830` | Self: 0.0% (0us) | Total: 0.4% (3.6ms) | Samples: 0

**Called by:**
- `get` (21)

**Calls:**
- `get` (21)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4226` | Self: 0.0% (0us) | Total: 0.0% (503us) | Samples: 0

**Called by:**
- `AstView` (3)

**Calls:**
- `Uint32Array` (3)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1677` | Self: 0.0% (0us) | Total: 0.0% (183us) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `nodeRhs` (1)

### `getVariableDescription`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:261` | Self: 0.0% (0us) | Total: 0.0% (525us) | Samples: 0

**Called by:**
- `getDefinedMessageData` (2)
- `getUsedIgnoredMessageData` (1)

**Calls:**
- `toString` (3)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4192` | Self: 0.0% (0us) | Total: 0.0% (311us) | Samples: 0

**Called by:**
- `AstView` (2)

**Calls:**
- `Uint32Array` (2)

### `parse`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `g` (8)

**Calls:**
- `Ae` (8)

### `node:child_process`
`node:child_process:2` | Self: 0.0% (0us) | Total: 0.0% (171us) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `Ae`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `parse` (8)

**Calls:**
- `_e` (7)
- `Ee` (1)

### `equalsToOriginalName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:186` | Self: 0.0% (0us) | Total: 0.0% (191us) | Samples: 0

**Called by:**
- `ImportDeclaration` (1)

**Calls:**
- `get imported` (1)

### `internal:primordials`
`internal:primordials:70` | Self: 0.0% (0us) | Total: 0.0% (199us) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `uncurryThis` (1)

### `isAvailable`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:399` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `_getFfiSelector` (9)

**Calls:**
- `_tryLoad` (6)
- `_tryLoad` (1)
- `_tryLoad` (1)
- `_tryLoad` (1)

### `invokeSelectorHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6048` | Self: 0.0% (0us) | Total: 0.0% (629us) | Samples: 0

**Called by:**
- `walkNodes` (4)

**Calls:**
- `_nodeViewRaw` (1)
- `nodeView` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:224` | Self: 0.0% (0us) | Total: 5.2% (46.0ms) | Samples: 0

**Called by:**
- `runOnce` (269)

**Calls:**
- `parse` (269)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:14` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `parseModule` (11)

**Calls:**
- `bound require` (11)

### `BinaryExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:188` | Self: 0.0% (0us) | Total: 0.0% (190us) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `report` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6894` | Self: 0.0% (0us) | Total: 1.0% (9.2ms) | Samples: 0

**Called by:**
- `runPlugins` (54)

**Calls:**
- `_fireCfgEvents` (41)
- `_fireCfgEvents` (5)
- `_fireCfgEvents` (3)
- `_fireCfgEvents` (2)
- `_fireCfgEvents` (2)
- `_fireCfgEvents` (1)

### `applyDisableDirectives`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7442` | Self: 0.0% (0us) | Total: 0.2% (2.0ms) | Samples: 0

**Called by:**
- `runOnce` (13)

**Calls:**
- `_parseDisableDirectives` (7)
- `_parseDisableDirectives` (5)
- `_parseDisableDirectives` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1739` | Self: 0.0% (0us) | Total: 0.0% (161us) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `getDefinedMessageData` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (8)

**Calls:**
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `isStorableFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:584` | Self: 0.0% (0us) | Total: 0.0% (142us) | Samples: 0

**Called by:**
- `isReadForItself` (1)

**Calls:**
- `get expressions` (1)

### `get kind`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2626` | Self: 0.0% (0us) | Total: 0.0% (400us) | Samples: 0

**Called by:**
- `VariableDeclaration` (1)
- `isGlobalAugmentation` (1)

**Calls:**
- `_tag` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6579` | Self: 0.0% (0us) | Total: 0.0% (187us) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `get` (1)

### `isSpecificMemberAccess`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:378` | Self: 0.0% (0us) | Total: 0.0% (380us) | Samples: 0

**Called by:**
- `getArrayMethodName` (2)

**Calls:**
- `skipChainExpression` (2)

### `isNullCheck`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:126` | Self: 0.0% (0us) | Total: 0.0% (522us) | Samples: 0

**Called by:**
- `BinaryExpression` (3)

**Calls:**
- `get left` (1)
- `get left` (1)
- `nodeView` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:400` | Self: 0.0% (0us) | Total: 0.0% (193us) | Samples: 0

**Called by:**
- `_buildVariable` (1)

**Calls:**
- `get _tag` (1)

### `requestSatisfy`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (370us) | Samples: 0

**Called by:**
- `async loadModule` (2)

**Calls:**
- `requestSatisfyUtil` (2)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3033` | Self: 0.0% (0us) | Total: 0.1% (1.0ms) | Samples: 0

**Called by:**
- `VariableDeclaration` (5)
- `checkForFunction` (1)

**Calls:**
- `_ensureDeclSymIndex` (5)
- `_ensureDeclSymIndex` (1)

### `ImportDeclaration`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:379` | Self: 0.0% (0us) | Total: 0.0% (191us) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `equalsToOriginalName` (1)

### `getStaticStringValue`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:264` | Self: 0.0% (0us) | Total: 0.0% (497us) | Samples: 0

**Called by:**
- `isSpecificMemberAccess` (2)

**Calls:**
- `get value` (1)
- `get value` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4237` | Self: 0.0% (0us) | Total: 0.0% (195us) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `get` (1)

### `ke`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.1% (1.0ms) | Samples: 0

**Called by:**
- `we` (6)

**Calls:**
- `(anonymous)` (4)
- `(anonymous)` (2)

### `getDeclaredLocation`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:471` | Self: 0.0% (0us) | Total: 0.0% (724us) | Samples: 0

**Called by:**
- `checkForShadows` (4)

**Calls:**
- `get loc` (1)
- `get loc` (1)
- `get loc` (1)
- `get loc` (1)

### `isAssignmentTarget`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:138` | Self: 0.0% (0us) | Total: 0.0% (343us) | Samples: 0

**Called by:**
- `MemberExpression[computed!=true] > Identifier.property` (2)

**Calls:**
- `get parent` (1)
- `get parent` (1)

### `get directive`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3337` | Self: 0.0% (0us) | Total: 0.0% (181us) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `_tag` (1)

### `checkGroup`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:476` | Self: 0.0% (0us) | Total: 0.0% (158us) | Samples: 0

**Called by:**
- `forEach` (1)

**Calls:**
- `_nodesFromRange` (1)

### `getFirstToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:984` | Self: 0.0% (0us) | Total: 0.0% (847us) | Samples: 0

**Called by:**
- `getFunctionHeadLoc` (4)
- `(anonymous)` (1)

**Calls:**
- `_makeToken` (1)
- `_makeToken` (1)
- `_makeToken` (1)
- `_makeToken` (1)
- `_makeToken` (1)

### `checkLastSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:380` | Self: 0.0% (0us) | Total: 0.1% (1.0ms) | Samples: 0

**Called by:**
- `_invokeFused` (6)

**Calls:**
- `getFunctionNameWithKind` (2)
- `getFunctionNameWithKind` (1)
- `getFunctionNameWithKind` (1)
- `getFunctionNameWithKind` (1)
- `join` (1)

### `getFirstToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:945` | Self: 0.0% (0us) | Total: 0.0% (169us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `_computeMinTok` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `(anonymous)` (8)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` | Self: 0.0% (0us) | Total: 0.1% (934us) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:20` | Self: 0.0% (0us) | Total: 0.3% (2.8ms) | Samples: 0

**Called by:**
- `parseModule` (17)

**Calls:**
- `bound require` (17)

### `get directive`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3342` | Self: 0.0% (0us) | Total: 0.0% (160us) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `nodeLhs` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` | Self: 0.0% (0us) | Total: 3.4% (29.6ms) | Samples: 0

**Called by:**
- `Program:exit` (118)
- `collectUnusedVariables` (18)

**Calls:**
- `some` (51)
- `isUsedVariable` (47)
- `isUsedVariable` (37)
- `isUsedVariable` (1)

### `checkGroup`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:509` | Self: 0.0% (0us) | Total: 0.1% (1.1ms) | Samples: 0

**Called by:**
- `forEach` (7)

**Calls:**
- `forEach` (7)

### `getAssignedMessageData`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:305` | Self: 0.0% (0us) | Total: 0.0% (176us) | Samples: 0

**Called by:**
- `Program:exit` (1)

**Calls:**
- `getVariableDescription` (1)

### `isSpecificMemberAccess`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:389` | Self: 0.0% (0us) | Total: 0.2% (2.2ms) | Samples: 0

**Called by:**
- `getArrayMethodName` (13)

**Calls:**
- `getStaticPropertyName` (3)
- `getStaticStringValue` (2)
- `getStaticPropertyName` (2)
- `getStaticStringValue` (2)
- `getStaticPropertyName` (2)
- `getStaticStringValue` (1)
- `getStaticStringValue` (1)

### `isEvaluatedDuringInitialization`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:184` | Self: 0.0% (0us) | Total: 0.0% (727us) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `isInRange` (4)

### `_getSelectorRootTypes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5554` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `_getSelectorRootTypes` (6)
- `_getOrBuildSelectorPlan` (2)
- `_buildPlan` (1)

**Calls:**
- `endsWith` (9)

### `isFunctionNameInitializerException`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:445` | Self: 0.0% (0us) | Total: 0.0% (154us) | Samples: 0

**Called by:**
- `checkForShadows` (1)

**Calls:**
- `unwrapExpression` (1)

### `isSpecificMemberAccess`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:393` | Self: 0.0% (0us) | Total: 0.0% (145us) | Samples: 0

**Called by:**
- `getArrayMethodName` (1)

**Calls:**
- `checkText` (1)

### `_compileSelectorFastMatcher`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5013` | Self: 0.0% (0us) | Total: 0.0% (189us) | Samples: 0

**Called by:**
- `_compileSelectorFastMatcher` (1)

**Calls:**
- `filter` (1)

### `_ensureTagCaches`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5504` | Self: 0.0% (0us) | Total: 0.0% (186us) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `add` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2820` | Self: 0.0% (0us) | Total: 0.1% (944us) | Samples: 0

**Called by:**
- `_buildVariable` (4)
- `_buildScopeRefsAndThrough` (1)

**Calls:**
- `_buildThinScope` (2)
- `_buildThinScope` (1)
- `_buildThinScope` (1)
- `_buildThinScope` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2066` | Self: 0.0% (0us) | Total: 0.0% (728us) | Samples: 0

**Called by:**
- `ensureVarsSet` (4)

**Calls:**
- `regExpMatchFast` (4)

### `getVariableByName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:1599` | Self: 0.0% (0us) | Total: 0.3% (2.9ms) | Samples: 0

**Called by:**
- `checkForShadows` (18)

**Calls:**
- `get` (18)

### `getStaticStringValue`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:246` | Self: 0.0% (0us) | Total: 0.0% (180us) | Samples: 0

**Called by:**
- `isSpecificMemberAccess` (1)

**Calls:**
- `get value` (1)

### `ensureRefsThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1823` | Self: 0.0% (0us) | Total: 2.2% (19.3ms) | Samples: 0

**Called by:**
- `get` (113)

**Calls:**
- `get` (113)

### `getIdentifierIfShouldBeConst`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:232` | Self: 0.0% (0us) | Total: 0.0% (184us) | Samples: 0

**Called by:**
- `groupByDestructuring` (1)

**Calls:**
- `map` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` | Self: 0.0% (0us) | Total: 0.0% (179us) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `isAfterLastUsedArg` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` | Self: 0.0% (0us) | Total: 1.4% (12.7ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (37)

**Calls:**
- `getFunctionDefinitions` (23)
- `getFunctionDefinitions` (14)

### `isInitPatternNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:304` | Self: 0.0% (0us) | Total: 0.0% (183us) | Samples: 0

**Called by:**
- `checkForShadows` (1)

**Calls:**
- `isInRange` (1)

### `_e`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `Ae` (7)

**Calls:**
- `Pe` (7)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:578` | Self: 0.0% (0us) | Total: 0.0% (173us) | Samples: 0

**Called by:**
- `_precomputeScopes` (1)

**Calls:**
- `slice` (1)

### `getIdentifierIfShouldBeConst`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:207` | Self: 0.0% (0us) | Total: 0.0% (675us) | Samples: 0

**Called by:**
- `groupByDestructuring` (4)

**Calls:**
- `getDestructuringHost` (2)
- `getDestructuringHost` (2)

### `isInsideOfStorableFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:630` | Self: 0.0% (0us) | Total: 0.0% (469us) | Samples: 0

**Called by:**
- `isReadForItself` (3)

**Calls:**
- `getUpperFunction` (2)
- `getUpperFunction` (1)

### `ensureBufferBytes`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:58` | Self: 0.0% (0us) | Total: 0.0% (173us) | Samples: 0

**Called by:**
- `_encodeSource` (1)

**Calls:**
- `get byteLength` (1)

### `ReturnStatement`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:455` | Self: 0.0% (0us) | Total: 0.0% (179us) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `get argument` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` | Self: 0.0% (0us) | Total: 0.0% (190us) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `get parent` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2369` | Self: 0.0% (0us) | Total: 15.8% (137.5ms) | Samples: 0

**Called by:**
- `getScope` (812)

**Calls:**
- `get` (812)

### `reportReferenceId`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:262` | Self: 0.0% (0us) | Total: 0.0% (750us) | Samples: 0

**Called by:**
- `Program` (4)

**Calls:**
- `report` (2)
- `report` (1)
- `report` (1)

### `checkLastSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:384` | Self: 0.0% (0us) | Total: 0.2% (2.1ms) | Samples: 0

**Called by:**
- `_invokeFused` (13)

**Calls:**
- `getFunctionHeadLoc` (10)
- `getFunctionHeadLoc` (1)
- `getFunctionHeadLoc` (1)
- `getFunctionHeadLoc` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:113` | Self: 0.0% (0us) | Total: 51.5% (448.1ms) | Samples: 0

**Called by:**
- `parseModule` (2644)

**Calls:**
- `runOnce` (2269)
- `runOnce` (360)
- `runOnce` (10)
- `runOnce` (4)
- `runOnce` (1)

### `checkForShadows`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:672` | Self: 0.0% (0us) | Total: 0.0% (195us) | Samples: 0

**Called by:**
- `Program:exit` (1)

**Calls:**
- `report` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:413` | Self: 0.0% (0us) | Total: 0.0% (190us) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `Uint32Array` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1703` | Self: 0.0% (0us) | Total: 0.0% (167us) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `nodeView` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1680` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `_computeIsStrict` (9)

**Calls:**
- `_nodesFromRange` (6)
- `_nodesFromRange` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:24` | Self: 0.0% (0us) | Total: 0.1% (1.0ms) | Samples: 0

**Called by:**
- `parseModule` (6)

**Calls:**
- `getTagNames` (5)
- `getTagNames` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2709` | Self: 0.0% (0us) | Total: 0.0% (175us) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `_nodeStartPos` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.5% (4.6ms) | Samples: 0

**Called by:**
- `anonymous` (27)

**Calls:**
- `bound require` (27)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:151` | Self: 0.0% (0us) | Total: 0.0% (285us) | Samples: 0

**Called by:**
- `BinaryExpression` (1)

**Calls:**
- `isTypeOfBinary` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4239` | Self: 0.0% (0us) | Total: 0.5% (4.4ms) | Samples: 0

**Called by:**
- `runPlugins` (26)

**Calls:**
- `esquery` (17)
- `g` (9)

### `Program`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:145` | Self: 0.0% (0us) | Total: 0.5% (5.0ms) | Samples: 0

**Called by:**
- `_invokeFused` (30)

**Calls:**
- `getScope` (30)

### `dlopen`
`bun:ffi:345` | Self: 0.0% (0us) | Total: 0.1% (881us) | Samples: 0

**Called by:**
- `_tryLoad` (5)

**Calls:**
- `dlopen` (5)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` | Self: 0.0% (0us) | Total: 0.0% (179us) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `getDeclaredVariables` (1)

### `Program`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:268` | Self: 0.0% (0us) | Total: 1.6% (14.6ms) | Samples: 0

**Called by:**
- `_invokeFused` (88)

**Calls:**
- `getScope` (87)
- `_buildScope` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4220` | Self: 0.0% (0us) | Total: 0.3% (3.2ms) | Samples: 0

**Called by:**
- `AstView` (18)

**Calls:**
- `Uint32Array` (18)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6630` | Self: 0.0% (0us) | Total: 0.0% (340us) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `RuleSkipSet` (2)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:282` | Self: 0.0% (0us) | Total: 0.0% (174us) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `getUint32` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` | Self: 0.0% (0us) | Total: 0.0% (504us) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `get type` (2)
- `get type` (1)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.1% (1.0ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `anonymous` (6)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:12` | Self: 0.0% (0us) | Total: 0.0% (355us) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:410` | Self: 0.0% (0us) | Total: 0.0% (495us) | Samples: 0

**Called by:**
- `parseSource` (3)

**Calls:**
- `Uint8Array` (3)

### `safeHandler`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3822` | Self: 0.0% (0us) | Total: 5.9% (52.1ms) | Samples: 0

**Called by:**
- `walkNodes` (313)

**Calls:**
- `Program` (313)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5776` | Self: 0.0% (0us) | Total: 2.3% (20.1ms) | Samples: 0

**Called by:**
- `_getOrBuildPlan` (118)

**Calls:**
- `_extractBatchScannable` (39)
- `_extractBatchScannable` (15)
- `_extractBatchScannable` (15)
- `_extractBatchScannable` (12)
- `_extractBatchScannable` (11)
- `_extractBatchScannable` (11)
- `_extractBatchScannable` (8)
- `_extractBatchScannable` (2)
- `_extractBatchScannable` (1)
- `_extractBatchScannable` (1)
- `_extractBatchScannable` (1)
- `_extractBatchScannable` (1)
- `_extractBatchScannable` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (7)
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (5)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `bound require` (1)

### `internal:validators`
`internal:validators:2` | Self: 0.0% (0us) | Total: 0.0% (671us) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `anonymous` (4)

### `checkForShadows`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:659` | Self: 0.0% (0us) | Total: 0.0% (192us) | Samples: 0

**Called by:**
- `Program:exit` (1)

**Calls:**
- `isGenericOfAStaticMethodShadow` (1)

### `checkLastSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:388` | Self: 0.0% (0us) | Total: 0.0% (185us) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `fullMethodName` (1)

### `checkForShadows`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:654` | Self: 0.0% (0us) | Total: 0.0% (581us) | Samples: 0

**Called by:**
- `Program:exit` (3)

**Calls:**
- `isInitPatternNode` (1)
- `isInitPatternNode` (1)
- `isInitPatternNode` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4200` | Self: 0.0% (0us) | Total: 0.5% (4.5ms) | Samples: 0

**Called by:**
- `runPlugins` (28)

**Calls:**
- `_applySchemaDefaults` (11)
- `_applySchemaDefaults` (5)
- `_applySchemaDefaults` (4)
- `_applySchemaDefaults` (4)
- `_applySchemaDefaults` (2)
- `_applySchemaDefaults` (2)

### `Program`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:304` | Self: 0.0% (0us) | Total: 0.1% (925us) | Samples: 0

**Called by:**
- `_invokeFused` (5)

**Calls:**
- `reportReferenceId` (4)
- `reportReferenceId` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2282` | Self: 0.0% (0us) | Total: 0.0% (826us) | Samples: 0

**Called by:**
- `ensureRefsThrough` (5)

**Calls:**
- `get type` (2)
- `get type` (1)
- `get type` (1)
- `get type` (1)

### `get properties`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3090` | Self: 0.0% (0us) | Total: 0.0% (175us) | Samples: 0

**Called by:**
- `getIdentifierIfShouldBeConst` (1)

**Calls:**
- `nodeLhs` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6291` | Self: 0.0% (0us) | Total: 3.0% (26.2ms) | Samples: 0

**Called by:**
- `runPlugins` (147)

**Calls:**
- `_getOrBuildSelectorPlan` (66)
- `_getOrBuildSelectorPlan` (48)
- `_getOrBuildSelectorPlan` (13)
- `_getOrBuildSelectorPlan` (5)
- `_getOrBuildSelectorPlan` (5)
- `_getOrBuildSelectorPlan` (2)
- `_getOrBuildSelectorPlan` (2)
- `_getOrBuildSelectorPlan` (2)
- `_getOrBuildSelectorPlan` (1)
- `_getOrBuildSelectorPlan` (1)
- `_getOrBuildSelectorPlan` (1)
- `_getOrBuildSelectorPlan` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:868` | Self: 0.0% (0us) | Total: 0.3% (2.9ms) | Samples: 0

**Called by:**
- `get body` (12)
- `get body` (6)

**Calls:**
- `_nodeViewRaw` (7)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)
- `nodeView` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` | Self: 0.0% (0us) | Total: 0.8% (7.3ms) | Samples: 0

**Called by:**
- `Program:exit` (41)
- `collectUnusedVariables` (1)

**Calls:**
- `collectUnusedVariables` (18)
- `collectUnusedVariables` (14)
- `collectUnusedVariables` (3)
- `collectUnusedVariables` (2)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)

### `node:events`
`node:events:320` | Self: 0.0% (0us) | Total: 0.0% (148us) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `defineProperty` (1)

### `get right`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1786` | Self: 0.0% (0us) | Total: 0.0% (147us) | Samples: 0

**Called by:**
- `isNullCheck` (1)

**Calls:**
- `get _tag` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7095` | Self: 0.0% (0us) | Total: 0.0% (159us) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `invokeSelectorHandlers` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` | Self: 0.0% (0us) | Total: 0.0% (281us) | Samples: 0

**Called by:**
- `forEach` (2)

**Calls:**
- `nodeViewChain` (1)
- `get init` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:872` | Self: 0.0% (0us) | Total: 0.0% (187us) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `getUsedIgnoredMessageData` (1)

### `getAssignedMessageData`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:306` | Self: 0.0% (0us) | Total: 0.0% (528us) | Samples: 0

**Called by:**
- `Program:exit` (2)

**Calls:**
- `defToVariableType` (2)

### `getIdentifierIfShouldBeConst`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:223` | Self: 0.0% (0us) | Total: 0.0% (319us) | Samples: 0

**Called by:**
- `groupByDestructuring` (2)

**Calls:**
- `some` (2)

### `async loadModule`
`[native code]` | Self: 0.0% (0us) | Total: 0.2% (1.8ms) | Samples: 0

**Called by:**
- `async loadModule` (3)
- `async loadAndEvaluateModule` (3)

**Calls:**
- `async loadModule` (3)
- `requestSatisfy` (2)
- `ensureRegistered` (1)

### `canBecomeVariableDeclaration`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:52` | Self: 0.0% (0us) | Total: 0.0% (165us) | Samples: 0

**Called by:**
- `getIdentifierIfShouldBeConst` (1)

**Calls:**
- `get parent` (1)

### `getTagNames`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:186` | Self: 0.0% (0us) | Total: 0.1% (878us) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `loadBinding` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` | Self: 0.0% (0us) | Total: 0.3% (2.9ms) | Samples: 0

**Called by:**
- `some` (17)

**Calls:**
- `isReadForItself` (6)
- `isReadForItself` (2)
- `isReadForItself` (2)
- `isReadForItself` (1)
- `isReadForItself` (1)
- `isReadForItself` (1)
- `isReadForItself` (1)
- `isReadForItself` (1)
- `isReadForItself` (1)
- `isReadForItself` (1)

### `_getFfiSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:110` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `_getOrBuildSelectorPlan` (9)

**Calls:**
- `isAvailable` (9)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1474` | Self: 0.0% (0us) | Total: 0.0% (194us) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (1)

**Calls:**
- `extraMethodData` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:862` | Self: 0.0% (0us) | Total: 0.0% (147us) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `get name` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3034` | Self: 0.0% (0us) | Total: 0.0% (136us) | Samples: 0

**Called by:**
- `VariableDeclaration` (1)

**Calls:**
- `get` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4259` | Self: 0.0% (0us) | Total: 0.0% (192us) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `get` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7164` | Self: 0.0% (0us) | Total: 0.0% (171us) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `invokeMethodFnHandlers` (1)

### `_runSelectorList`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5993` | Self: 0.0% (0us) | Total: 0.2% (2.6ms) | Samples: 0

**Called by:**
- `invokeSelectorHandlers` (16)

**Calls:**
- `fn` (10)
- `fn` (3)
- `fn` (2)
- `fn` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1719` | Self: 0.0% (0us) | Total: 0.0% (324us) | Samples: 0

**Called by:**
- `_buildScopeChildren` (1)

**Calls:**
- `get id` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:234` | Self: 0.0% (0us) | Total: 0.0% (168us) | Samples: 0

**Called by:**
- `runOnce` (1)

**Calls:**
- `DataView` (1)

### `MemberExpression[computed!=true] > Identifier.property`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:363` | Self: 0.0% (0us) | Total: 0.0% (319us) | Samples: 0

**Called by:**
- `_runSelectorList` (2)

**Calls:**
- `isGoodName` (1)
- `get name` (1)

### `getIdentifierIfShouldBeConst`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:211` | Self: 0.0% (0us) | Total: 0.0% (187us) | Samples: 0

**Called by:**
- `groupByDestructuring` (1)

**Calls:**
- `get left` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:416` | Self: 0.0% (0us) | Total: 0.0% (347us) | Samples: 0

**Called by:**
- `parseSource` (2)

**Calls:**
- `Uint32Array` (2)

### `shouldCheck`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:392` | Self: 0.0% (0us) | Total: 0.0% (319us) | Samples: 0

**Called by:**
- `filter` (2)

**Calls:**
- `referenceContainsTypeQuery` (2)

### `checkGroup`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:463` | Self: 0.0% (0us) | Total: 0.0% (144us) | Samples: 0

**Called by:**
- `forEach` (1)

**Calls:**
- `every` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1712` | Self: 0.0% (0us) | Total: 0.0% (824us) | Samples: 0

**Called by:**
- `_invokeFused` (5)

**Calls:**
- `getDefinedMessageData` (2)
- `getDefinedMessageData` (2)
- `getDefinedMessageData` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` | Self: 0.0% (0us) | Total: 0.0% (158us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get parent` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:819` | Self: 0.0% (0us) | Total: 0.0% (173us) | Samples: 0

**Called by:**
- `Program:exit` (1)

**Calls:**
- `get name` (1)

### `(anonymous)`
`node:child_process:831` | Self: 0.0% (0us) | Total: 0.0% (169us) | Samples: 0

**Called by:**
- `node:child_process` (1)

**Calls:**
- `(anonymous)` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6471` | Self: 0.0% (0us) | Total: 0.1% (1.1ms) | Samples: 0

**Called by:**
- `walkNodes` (5)
- `walkNodes` (1)
- `walkNodes` (1)

**Calls:**
- `_nodeViewRaw` (3)
- `nodeView` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:29` | Self: 0.0% (0us) | Total: 0.0% (182us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `isEvaluatedDuringInitialization`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:189` | Self: 0.0% (0us) | Total: 0.1% (895us) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `some` (3)
- `get body` (1)
- `get body` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5658` | Self: 0.0% (0us) | Total: 0.2% (2.2ms) | Samples: 0

**Called by:**
- `_getOrBuildPlan` (13)

**Calls:**
- `indexOf` (13)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7361` | Self: 0.0% (0us) | Total: 0.0% (613us) | Samples: 0

**Called by:**
- `runOnce` (4)

**Calls:**
- `fill` (4)

### `isSpecificId`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:365` | Self: 0.0% (0us) | Total: 0.0% (168us) | Samples: 0

**Called by:**
- `isSpecificMemberAccess` (1)

**Calls:**
- `get type` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5677` | Self: 0.0% (0us) | Total: 0.0% (162us) | Samples: 0

**Called by:**
- `_getOrBuildPlan` (1)

**Calls:**
- `get` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1658` | Self: 0.0% (0us) | Total: 0.0% (154us) | Samples: 0

**Called by:**
- `checkForBlock` (1)

**Calls:**
- `_buildScope` (1)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5291` | Self: 0.0% (0us) | Total: 0.0% (178us) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `indexOf` (1)

### `_expandUnion`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4042` | Self: 0.0% (0us) | Total: 0.0% (645us) | Samples: 0

**Called by:**
- `buildVisitorMap` (4)

**Calls:**
- `endsWith` (4)

### `getNameLocationInGlobalDirectiveComment`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2635` | Self: 0.0% (0us) | Total: 0.0% (182us) | Samples: 0

**Called by:**
- `Program:exit` (1)

**Calls:**
- `(anonymous)` (1)

### `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:325` | Self: 0.0% (0us) | Total: 0.0% (616us) | Samples: 0

**Called by:**
- `_invokeFused` (4)

**Calls:**
- `equalsToOriginalName` (1)
- `equalsToOriginalName` (1)
- `equalsToOriginalName` (1)
- `equalsToOriginalName` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:134` | Self: 0.0% (0us) | Total: 0.0% (165us) | Samples: 0

**Called by:**
- `some` (1)

**Calls:**
- `get argument` (1)

### `getIdentifierIfShouldBeConst`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:237` | Self: 0.0% (0us) | Total: 0.0% (356us) | Samples: 0

**Called by:**
- `groupByDestructuring` (2)

**Calls:**
- `some` (2)

### `checkForFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:238` | Self: 0.0% (0us) | Total: 0.7% (6.1ms) | Samples: 0

**Called by:**
- `_invokeFused` (37)

**Calls:**
- `getDeclaredVariables` (17)
- `forEach` (15)
- `getDeclaredVariables` (1)
- `getDeclaredVariables` (1)
- `getDeclaredVariables` (1)
- `getDeclaredVariables` (1)
- `getDeclaredVariables` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4231` | Self: 0.0% (0us) | Total: 0.0% (204us) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `keys` (1)

### `equalsToOriginalName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:169` | Self: 0.0% (0us) | Total: 0.0% (164us) | Samples: 0

**Called by:**
- `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause` (1)

**Calls:**
- `get type` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:21` | Self: 0.0% (0us) | Total: 0.4% (4.1ms) | Samples: 0

**Called by:**
- `parseModule` (24)

**Calls:**
- `bound require` (24)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4219` | Self: 0.0% (0us) | Total: 0.0% (437us) | Samples: 0

**Called by:**
- `AstView` (3)

**Calls:**
- `Uint32Array` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:55` | Self: 0.0% (0us) | Total: 0.0% (152us) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `existsSync` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1527` | Self: 0.0% (0us) | Total: 0.0% (331us) | Samples: 0

**Called by:**
- `getStaticStringValue` (1)

**Calls:**
- `mainToken` (1)

### `isGlobalAugmentation`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:136` | Self: 0.0% (0us) | Total: 0.0% (195us) | Samples: 0

**Called by:**
- `checkForShadows` (1)

**Calls:**
- `get kind` (1)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:182` | Self: 0.0% (0us) | Total: 0.1% (1.0ms) | Samples: 0

**Called by:**
- `getRhsNode` (6)

**Calls:**
- `isLoop` (6)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:345` | Self: 0.0% (0us) | Total: 0.0% (171us) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `Uint32Array` (1)

### `buildUnicodeData`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:3986` | Self: 0.0% (0us) | Total: 0.0% (300us) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `wordsRegexp` (2)

### `equalsToOriginalName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:177` | Self: 0.0% (0us) | Total: 0.0% (344us) | Samples: 0

**Called by:**
- `reportReferenceId` (2)

**Calls:**
- `get value` (1)
- `get value` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:619` | Self: 0.0% (0us) | Total: 0.0% (149us) | Samples: 0

**Called by:**
- `commentsInRange` (1)

**Calls:**
- `_lineStarts` (1)

### `node:path`
`node:path:2` | Self: 0.0% (0us) | Total: 0.0% (850us) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `anonymous` (5)

### `getFirstToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:949` | Self: 0.0% (0us) | Total: 0.0% (166us) | Samples: 0

**Called by:**
- `getFunctionHeadLoc` (1)

**Calls:**
- `get range` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7092` | Self: 0.0% (0us) | Total: 0.0% (666us) | Samples: 0

**Called by:**
- `runPlugins` (4)

**Calls:**
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)

### `isGoodName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:128` | Self: 0.0% (0us) | Total: 0.3% (2.9ms) | Samples: 0

**Called by:**
- `Program` (16)
- `Program` (1)
- `MemberExpression[computed!=true] > Identifier.property` (1)

**Calls:**
- `isUnderscored` (11)
- `isUnderscored` (7)

### `ReturnStatement`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:453` | Self: 0.0% (0us) | Total: 0.1% (1.1ms) | Samples: 0

**Called by:**
- `_invokeFused` (5)

**Calls:**
- `_nodeViewRaw` (5)

### `_tryLoad`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:51` | Self: 0.0% (0us) | Total: 0.1% (1.0ms) | Samples: 0

**Called by:**
- `isAvailable` (6)

**Calls:**
- `dlopen` (5)
- `dlopen` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:824` | Self: 0.0% (0us) | Total: 0.0% (524us) | Samples: 0

**Called by:**
- `Program:exit` (3)

**Calls:**
- `isUsedVariable` (2)
- `some` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:13` | Self: 0.0% (0us) | Total: 0.1% (1.1ms) | Samples: 0

**Called by:**
- `parseModule` (7)

**Calls:**
- `bound require` (7)

### `invokeSelectorHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6084` | Self: 0.0% (0us) | Total: 0.6% (5.5ms) | Samples: 0

**Called by:**
- `walkNodes` (34)

**Calls:**
- `_runSelectorList` (16)
- `_runSelectorList` (10)
- `_runSelectorList` (7)
- `_runSelectorList` (1)

### `FFIBuilder`
`bun:ffi:283` | Self: 0.0% (0us) | Total: 0.0% (192us) | Samples: 0

**Called by:**
- `dlopen` (1)

**Calls:**
- `Function` (1)

### `areLiteralsAndSameType`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:113` | Self: 0.0% (0us) | Total: 0.0% (193us) | Samples: 0

**Called by:**
- `BinaryExpression` (1)

**Calls:**
- `get right` (1)

### `_ensureTagCaches`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5519` | Self: 0.0% (0us) | Total: 0.0% (162us) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `map` (1)

### `[Symbol.match]`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (167us) | Samples: 0

**Called by:**
- `some` (1)

**Calls:**
- `hasObservableSideEffectsForRegExpMatch` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:215` | Self: 0.0% (0us) | Total: 0.4% (3.9ms) | Samples: 0

**Called by:**
- `runOnce` (24)

**Calls:**
- `_encodeSource` (19)
- `_encodeSource` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js:133` | Self: 0.0% (0us) | Total: 0.0% (357us) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (2)

### `checkLastSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:382` | Self: 0.0% (0us) | Total: 0.0% (514us) | Samples: 0

**Called by:**
- `_invokeFused` (3)

**Calls:**
- `report` (3)

### `checkForBlock`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:139` | Self: 0.0% (0us) | Total: 0.0% (195us) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `findVariablesInScope` (1)

### `getTokenAfter`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1265` | Self: 0.0% (0us) | Total: 0.0% (143us) | Samples: 0

**Called by:**
- `getFunctionHeadLoc` (1)

**Calls:**
- `get range` (1)

### `isModifyingProp`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:134` | Self: 0.0% (0us) | Total: 0.0% (191us) | Samples: 0

**Called by:**
- `checkReference` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:208` | Self: 0.0% (0us) | Total: 0.0% (536us) | Samples: 0

**Called by:**
- `ObjectExpression > Property[computed!=true] > Identifier.key,MethodDefinition[computed!=true] > Identifier.key,PropertyDefinition[computed!=true] > Identifier.key,MethodDefinition > PrivateIdentifier.key,PropertyDefinition > PrivateIdentifier.key` (2)
- `reportReferenceId` (1)

**Calls:**
- `report` (3)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:390` | Self: 0.0% (0us) | Total: 0.0% (700us) | Samples: 0

**Called by:**
- `parseSource` (4)

**Calls:**
- `Uint32Array` (4)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1980` | Self: 0.0% (0us) | Total: 0.0% (183us) | Samples: 0

**Called by:**
- `ensureVarsSet` (1)

**Calls:**
- `Proxy` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:561` | Self: 0.0% (0us) | Total: 0.0% (558us) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `get right` (2)
- `get right` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:931` | Self: 0.0% (0us) | Total: 0.0% (161us) | Samples: 0

**Called by:**
- `Program:exit` (1)

**Calls:**
- `/[iI]gnored/u` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:435` | Self: 0.0% (0us) | Total: 0.0% (290us) | Samples: 0

**Called by:**
- `parseSource` (2)

**Calls:**
- `Uint8Array` (2)

### `isGenericOfAStaticMethodShadow`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:220` | Self: 0.0% (0us) | Total: 0.0% (192us) | Samples: 0

**Called by:**
- `checkForShadows` (1)

**Calls:**
- `isTypeParameterOfStaticMethod` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:495` | Self: 0.0% (0us) | Total: 0.0% (146us) | Samples: 0

**Called by:**
- `forEach` (1)

**Calls:**
- `get properties` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:653` | Self: 0.0% (0us) | Total: 0.0% (197us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get type` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:56` | Self: 0.0% (0us) | Total: 0.3% (3.3ms) | Samples: 0

**Called by:**
- `parseModule` (19)

**Calls:**
- `parse` (16)
- `readFileSync` (3)

### `_runSelectorList`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5998` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `invokeSelectorHandlers` (10)

**Calls:**
- `MemberExpression[computed!=true] > Identifier.property` (4)
- `MemberExpression[computed!=true] > Identifier.property` (2)
- `ObjectExpression > Property[computed!=true] > Identifier.key,MethodDefinition[computed!=true] > Identifier.key,PropertyDefinition[computed!=true] > Identifier.key,MethodDefinition > PrivateIdentifier.key,PropertyDefinition > PrivateIdentifier.key` (2)
- `ObjectExpression > Property[computed!=true] > Identifier.key,MethodDefinition[computed!=true] > Identifier.key,PropertyDefinition[computed!=true] > Identifier.key,MethodDefinition > PrivateIdentifier.key,PropertyDefinition > PrivateIdentifier.key` (1)
- `ObjectExpression > Property[computed!=true] > Identifier.key,MethodDefinition[computed!=true] > Identifier.key,PropertyDefinition[computed!=true] > Identifier.key,MethodDefinition > PrivateIdentifier.key,PropertyDefinition > PrivateIdentifier.key` (1)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5331` | Self: 0.0% (0us) | Total: 0.2% (2.2ms) | Samples: 0

**Called by:**
- `walkNodes` (13)

**Calls:**
- `_getFfiSelector` (9)
- `_getFfiSelector` (3)
- `_getFfiSelector` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:232` | Self: 0.0% (0us) | Total: 0.0% (184us) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `get name` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:71` | Self: 0.0% (0us) | Total: 0.0% (176us) | Samples: 0

**Called by:**
- `some` (1)

**Calls:**
- `isInRange` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:46` | Self: 0.0% (0us) | Total: 1.2% (11.3ms) | Samples: 0

**Called by:**
- `parseModule` (66)

**Calls:**
- `bound require` (66)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1483` | Self: 0.0% (0us) | Total: 0.0% (179us) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (1)

**Calls:**
- `get loc` (1)

### `equalsToOriginalName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:167` | Self: 0.0% (0us) | Total: 0.0% (152us) | Samples: 0

**Called by:**
- `reportReferenceId` (1)

**Calls:**
- `get name` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:400` | Self: 0.0% (0us) | Total: 0.0% (680us) | Samples: 0

**Called by:**
- `parseSource` (4)

**Calls:**
- `Uint8Array` (4)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1482` | Self: 0.0% (0us) | Total: 0.0% (331us) | Samples: 0

**Called by:**
- `_buildScope` (1)
- `invokeMethodFnHandlers` (1)

**Calls:**
- `get range` (1)
- `get range` (1)

### `_compileSelectorFastMatcher`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5088` | Self: 0.0% (0us) | Total: 0.0% (741us) | Samples: 0

**Called by:**
- `_compileSelectorFastMatcher` (4)

**Calls:**
- `filter` (4)

### `isInTdz`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:491` | Self: 0.0% (0us) | Total: 0.0% (157us) | Samples: 0

**Called by:**
- `checkForShadows` (1)

**Calls:**
- `getNameRange` (1)

### `_getFfiSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:109` | Self: 0.0% (0us) | Total: 0.0% (558us) | Samples: 0

**Called by:**
- `_getOrBuildSelectorPlan` (3)

**Calls:**
- `bound require` (3)

### `makeSafe`
`internal:primordials:30` | Self: 0.0% (0us) | Total: 0.0% (135us) | Samples: 0

**Called by:**
- `internal:primordials` (1)

**Calls:**
- `bound call` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:404` | Self: 0.0% (0us) | Total: 0.0% (522us) | Samples: 0

**Called by:**
- `parseSource` (3)

**Calls:**
- `Uint32Array` (3)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:211` | Self: 0.0% (0us) | Total: 0.0% (386us) | Samples: 0

**Called by:**
- `reportReferenceId` (2)

**Calls:**
- `get type` (1)
- `get type` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4062` | Self: 0.0% (0us) | Total: 0.0% (463us) | Samples: 0

**Called by:**
- `(anonymous)` (1)
- `getArrayMethodName` (1)
- `(anonymous)` (1)

**Calls:**
- `_isChainChild` (1)
- `_isChainNode` (1)
- `_isChainNode` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7001` | Self: 0.0% (0us) | Total: 0.1% (1.0ms) | Samples: 0

**Called by:**
- `runPlugins` (6)

**Calls:**
- `invokeMethodFnHandlers` (4)
- `invokeMethodFnHandlers` (1)
- `invokeMethodFnHandlers` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:20` | Self: 0.0% (0us) | Total: 0.0% (181us) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1733` | Self: 0.0% (0us) | Total: 0.0% (360us) | Samples: 0

**Called by:**
- `_invokeFused` (2)

**Calls:**
- `getNameLocationInGlobalDirectiveComment` (1)
- `getNameLocationInGlobalDirectiveComment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:431` | Self: 0.0% (0us) | Total: 0.0% (170us) | Samples: 0

**Called by:**
- `forEach` (1)

**Calls:**
- `get range` (1)

### `isImportAttributeKey`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:1424` | Self: 0.0% (0us) | Total: 0.0% (148us) | Samples: 0

**Called by:**
- `Program` (1)

**Calls:**
- `get key` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2979` | Self: 0.0% (0us) | Total: 0.0% (196us) | Samples: 0

**Called by:**
- `_buildThinVariable` (1)

**Calls:**
- `set` (1)

### `getFirstTokenBetween`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1313` | Self: 0.0% (0us) | Total: 0.0% (140us) | Samples: 0

**Called by:**
- `report` (1)

**Calls:**
- `get range` (1)

### `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:337` | Self: 0.0% (0us) | Total: 0.0% (648us) | Samples: 0

**Called by:**
- `_invokeFused` (4)

**Calls:**
- `reportReferenceId` (4)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1718` | Self: 0.0% (0us) | Total: 0.0% (623us) | Samples: 0

**Called by:**
- `_buildScopeChildren` (4)

**Calls:**
- `get id` (2)
- `_nodeViewRaw` (1)
- `get type` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:22` | Self: 0.0% (0us) | Total: 0.0% (157us) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `hasRestSpreadSibling`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:411` | Self: 0.0% (0us) | Total: 0.0% (143us) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `some` (1)

### `_applySchemaDefaults`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:162` | Self: 0.0% (0us) | Total: 0.0% (631us) | Samples: 0

**Called by:**
- `buildVisitorMap` (4)

**Calls:**
- `slice` (4)

### `isSpecificMemberAccess`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:384` | Self: 0.0% (0us) | Total: 0.0% (552us) | Samples: 0

**Called by:**
- `getArrayMethodName` (3)

**Calls:**
- `_nodeViewRaw` (1)
- `isSpecificId` (1)
- `checkText` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2204` | Self: 0.0% (0us) | Total: 1.9% (17.1ms) | Samples: 0

**Called by:**
- `ensureRefsThrough` (100)

**Calls:**
- `_buildReference` (42)
- `_buildReference` (22)
- `_buildReference` (20)
- `_buildReference` (7)
- `_buildReference` (2)
- `_buildReference` (2)
- `_buildReference` (2)
- `_buildReference` (1)
- `_buildReference` (1)
- `_buildReference` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:429` | Self: 0.0% (0us) | Total: 0.0% (138us) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `Uint32Array` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4218` | Self: 0.0% (0us) | Total: 0.0% (180us) | Samples: 0

**Called by:**
- `AstView` (1)

**Calls:**
- `Uint8Array` (1)

### `internal:primordials`
`internal:primordials:71` | Self: 0.0% (0us) | Total: 0.0% (135us) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `makeSafe` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5222` | Self: 0.0% (0us) | Total: 0.0% (165us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `accessPath` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:683` | Self: 0.0% (0us) | Total: 2.4% (21.3ms) | Samples: 0

**Called by:**
- `_invokeFused` (128)

**Calls:**
- `getScope` (125)
- `_buildScope` (2)
- `get` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:485` | Self: 0.0% (0us) | Total: 0.0% (190us) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `getUint32` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` | Self: 0.0% (0us) | Total: 8.0% (69.9ms) | Samples: 0

**Called by:**
- `_invokeFused` (406)

**Calls:**
- `getScope` (403)
- `_buildScope` (2)
- `getScope` (1)

### `_getSelectorRootTypes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5600` | Self: 0.0% (0us) | Total: 0.0% (178us) | Samples: 0

**Called by:**
- `_getOrBuildSelectorPlan` (1)

**Calls:**
- `/^:[a-z-]+\s*/` (1)

### `getStaticPropertyName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:320` | Self: 0.0% (0us) | Total: 0.0% (517us) | Samples: 0

**Called by:**
- `isSpecificMemberAccess` (2)
- `onCodePathStart` (1)

**Calls:**
- `_nodeViewRaw` (1)
- `get property` (1)
- `get property` (1)

### `checkForBlock`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:132` | Self: 0.0% (0us) | Total: 0.0% (490us) | Samples: 0

**Called by:**
- `_invokeFused` (3)

**Calls:**
- `_buildScope` (1)
- `getScope` (1)
- `_buildScope` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:152` | Self: 0.0% (0us) | Total: 0.0% (335us) | Samples: 0

**Called by:**
- `BinaryExpression` (2)

**Calls:**
- `report` (2)

### `canBecomeVariableDeclaration`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:51` | Self: 0.0% (0us) | Total: 0.0% (148us) | Samples: 0

**Called by:**
- `getIdentifierIfShouldBeConst` (1)

**Calls:**
- `get type` (1)

### `accessPath`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5206` | Self: 0.0% (0us) | Total: 0.0% (165us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get computed` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.2% (1.8ms) | Samples: 0

**Called by:**
- `anonymous` (11)

**Calls:**
- `bound require` (11)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2071` | Self: 0.0% (0us) | Total: 0.0% (645us) | Samples: 0

**Called by:**
- `ensureVarsSet` (4)

**Calls:**
- `test` (4)

### `ensureRegistered`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (566us) | Samples: 0

**Called by:**
- `async loadModule` (1)

**Calls:**
- `newRegistryEntry` (1)

### `getFirstTokenBetween`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1335` | Self: 0.0% (0us) | Total: 0.3% (2.6ms) | Samples: 0

**Called by:**
- `report` (12)

**Calls:**
- `_makeToken` (9)
- `_makeToken` (2)
- `_makeToken` (1)

### `checkGroup`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:492` | Self: 0.0% (0us) | Total: 0.0% (146us) | Samples: 0

**Called by:**
- `forEach` (1)

**Calls:**
- `forEach` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `_invokeFused` (10)

**Calls:**
- `report` (10)

### `isFromSeparateExecutionContext`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:138` | Self: 0.0% (0us) | Total: 0.0% (167us) | Samples: 0

**Called by:**
- `isEvaluatedDuringInitialization` (1)

**Calls:**
- `isClassStaticInitializerScope` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:414` | Self: 0.0% (0us) | Total: 0.0% (489us) | Samples: 0

**Called by:**
- `parseSource` (3)

**Calls:**
- `Uint32Array` (2)
- `getUint32` (1)

### `node:os`
`node:os:110` | Self: 0.0% (0us) | Total: 0.0% (171us) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6098` | Self: 0.0% (0us) | Total: 0.0% (190us) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `get` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6504` | Self: 0.0% (0us) | Total: 0.0% (337us) | Samples: 0

**Called by:**
- `walkNodes` (2)

**Calls:**
- `_dispatchSeg` (1)
- `_dispatchSeg` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3073` | Self: 0.0% (0us) | Total: 0.0% (179us) | Samples: 0

**Called by:**
- `isAfterLastUsedArg` (1)

**Calls:**
- `set` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5065` | Self: 0.0% (0us) | Total: 0.0% (165us) | Samples: 0

**Called by:**
- `fn` (1)

**Calls:**
- `(anonymous)` (1)

### `get initialSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4343` | Self: 0.0% (0us) | Total: 0.0% (179us) | Samples: 0

**Called by:**
- `_fireCfgEvents` (1)

**Calls:**
- `segment` (1)

### `isDuplicatedEnumNameVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:552` | Self: 0.0% (0us) | Total: 0.0% (165us) | Samples: 0

**Called by:**
- `checkForShadows` (1)

**Calls:**
- `get type` (1)

### `requestSatisfyUtil`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (925us) | Samples: 0

**Called by:**
- `(anonymous)` (3)
- `requestSatisfy` (2)

**Calls:**
- `requestInstantiate` (5)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6476` | Self: 0.0% (0us) | Total: 0.0% (378us) | Samples: 0

**Called by:**
- `walkNodes` (2)

**Calls:**
- `codepath` (2)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6479` | Self: 0.0% (0us) | Total: 0.0% (509us) | Samples: 0

**Called by:**
- `walkNodes` (3)

**Calls:**
- `initialSegment` (2)
- `get initialSegment` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:48` | Self: 0.0% (0us) | Total: 0.0% (161us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `RegExp` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:648` | Self: 0.0% (0us) | Total: 0.0% (159us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get parent` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4208` | Self: 0.0% (0us) | Total: 0.0% (504us) | Samples: 0

**Called by:**
- `runPlugins` (3)

**Calls:**
- `_makeBoundReport` (3)

### `get right`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1788` | Self: 0.0% (0us) | Total: 0.0% (193us) | Samples: 0

**Called by:**
- `getRhsNode` (1)

**Calls:**
- `nodeLhs` (1)

### `getArrayMethodName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:78` | Self: 0.0% (0us) | Total: 0.0% (635us) | Samples: 0

**Called by:**
- `onCodePathStart` (4)

**Calls:**
- `get parent` (3)
- `get parent` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:415` | Self: 0.0% (0us) | Total: 0.0% (174us) | Samples: 0

**Called by:**
- `findUp` (1)

**Calls:**
- `get type` (1)

### `unwrapExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:373` | Self: 0.0% (0us) | Total: 0.0% (154us) | Samples: 0

**Called by:**
- `isFunctionNameInitializerException` (1)

**Calls:**
- `get test` (1)

### `checkReferencesInScope`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:426` | Self: 0.0% (0us) | Total: 0.6% (5.8ms) | Samples: 0

**Called by:**
- `forEach` (19)
- `Program` (15)

**Calls:**
- `forEach` (18)
- `filter` (13)
- `get` (3)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:576` | Self: 0.0% (0us) | Total: 0.0% (149us) | Samples: 0

**Called by:**
- `_precomputeScopes` (1)

**Calls:**
- `_findLineIdx` (1)

### `checkForShadows`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:651` | Self: 0.0% (0us) | Total: 0.0% (807us) | Samples: 0

**Called by:**
- `Program:exit` (5)

**Calls:**
- `isFunctionNameInitializerException` (2)
- `isFunctionNameInitializerException` (1)
- `isFunctionNameInitializerException` (1)
- `isFunctionNameInitializerException` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `forEach` (9)

**Calls:**
- `get init` (2)
- `get init` (2)
- `nodeViewChain` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `get init` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:15` | Self: 0.0% (0us) | Total: 0.0% (169us) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` | Self: 0.0% (0us) | Total: 0.1% (1.1ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `_compileSelectorFastMatcher`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4993` | Self: 0.0% (0us) | Total: 0.0% (656us) | Samples: 0

**Called by:**
- `_compileSelectorFastMatcher` (4)

**Calls:**
- `map` (4)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:922` | Self: 0.0% (0us) | Total: 0.0% (562us) | Samples: 0

**Called by:**
- `collectUnusedVariables` (2)
- `Program:exit` (1)

**Calls:**
- `isFunction` (2)
- `get parent` (1)

### `getUsedIgnoredMessageData`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:331` | Self: 0.0% (0us) | Total: 0.0% (187us) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `getVariableDescription` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:430` | Self: 0.0% (0us) | Total: 0.0% (355us) | Samples: 0

**Called by:**
- `parseSource` (2)

**Calls:**
- `Uint32Array` (2)

### `isModifyingProp`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:159` | Self: 0.0% (0us) | Total: 0.0% (324us) | Samples: 0

**Called by:**
- `checkReference` (2)

**Calls:**
- `get parent` (1)
- `get parent` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7009` | Self: 0.0% (0us) | Total: 0.0% (164us) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `nodeLhs` (1)

### `getFunctionNameWithKind`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2110` | Self: 0.0% (0us) | Total: 0.0% (193us) | Samples: 0

**Called by:**
- `checkLastSegment` (1)

**Calls:**
- `get parent` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:560` | Self: 0.0% (0us) | Total: 0.0% (148us) | Samples: 0

**Called by:**
- `_precomputeScopes` (1)

**Calls:**
- `_lineStarts` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:295` | Self: 0.0% (0us) | Total: 0.0% (715us) | Samples: 0

**Called by:**
- `parseSource` (4)

**Calls:**
- `Uint8Array` (4)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:840` | Self: 0.0% (0us) | Total: 0.0% (156us) | Samples: 0

**Called by:**
- `Program:exit` (1)

**Calls:**
- `some` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3` | Self: 0.0% (0us) | Total: 0.0% (494us) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `internal:promisify`
`internal:promisify:53` | Self: 0.0% (0us) | Total: 0.0% (191us) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `_isChainNode`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3886` | Self: 0.0% (0us) | Total: 0.0% (133us) | Samples: 0

**Called by:**
- `nodeViewChain` (1)

**Calls:**
- `_isChainMiddleTag` (1)

### `skipChainExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:343` | Self: 0.0% (0us) | Total: 0.0% (380us) | Samples: 0

**Called by:**
- `isSpecificMemberAccess` (2)

**Calls:**
- `get type` (2)

### `equalsToOriginalName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:175` | Self: 0.0% (0us) | Total: 0.0% (316us) | Samples: 0

**Called by:**
- `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause` (1)
- `reportReferenceId` (1)

**Calls:**
- `get parent` (1)
- `get type` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:433` | Self: 0.0% (0us) | Total: 0.2% (2.3ms) | Samples: 0

**Called by:**
- `forEach` (13)

**Calls:**
- `isEvaluatedDuringInitialization` (5)
- `isEvaluatedDuringInitialization` (4)
- `isEvaluatedDuringInitialization` (3)
- `isEvaluatedDuringInitialization` (1)

### `_dispatchSeg`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6108` | Self: 0.0% (0us) | Total: 0.0% (470us) | Samples: 0

**Called by:**
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)

**Calls:**
- `onUnreachableCodePathSegmentStart` (1)
- `onUnreachableCodePathSegmentEnd` (1)
- `onCodePathSegmentStart` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2727` | Self: 0.0% (0us) | Total: 0.0% (180us) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `_buildThinVariable` (1)

### `checkReferencesInScope`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:444` | Self: 0.0% (0us) | Total: 0.5% (5.0ms) | Samples: 0

**Called by:**
- `Program` (20)
- `forEach` (9)

**Calls:**
- `forEach` (29)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` | Self: 0.0% (0us) | Total: 0.0% (540us) | Samples: 0

**Called by:**
- `Program:exit` (3)

**Calls:**
- `some` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:108` | Self: 0.0% (0us) | Total: 45.1% (392.7ms) | Samples: 0

**Called by:**
- `parseModule` (2243)

**Calls:**
- `runOnce` (1954)
- `runOnce` (271)
- `runOnce` (14)
- `runOnce` (1)
- `runOnce` (1)
- `runOnce` (1)
- `runOnce` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:690` | Self: 0.0% (0us) | Total: 1.0% (9.5ms) | Samples: 0

**Called by:**
- `_invokeFused` (56)

**Calls:**
- `checkForShadows` (19)
- `checkForShadows` (9)
- `checkForShadows` (7)
- `checkForShadows` (5)
- `checkForShadows` (5)
- `checkForShadows` (3)
- `checkForShadows` (2)
- `checkForShadows` (1)
- `checkForShadows` (1)
- `checkForShadows` (1)
- `checkForShadows` (1)
- `checkForShadows` (1)
- `checkForShadows` (1)

### `onUnreachableCodePathSegmentEnd`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:430` | Self: 0.0% (0us) | Total: 0.0% (153us) | Samples: 0

**Called by:**
- `_dispatchSeg` (1)

**Calls:**
- `delete` (1)

### `checkReference`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:205` | Self: 0.0% (0us) | Total: 0.0% (162us) | Samples: 0

**Called by:**
- `forEach` (1)

**Calls:**
- `get name` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:138` | Self: 0.0% (0us) | Total: 0.3% (2.9ms) | Samples: 0

**Called by:**
- `BinaryExpression` (13)
- `BinaryExpression` (1)

**Calls:**
- `getFirstTokenBetween` (12)
- `getFirstTokenBetween` (1)
- `getFirstTokenBetween` (1)

### `esquery`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:53` | Self: 0.0% (0us) | Total: 0.3% (2.8ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (17)

**Calls:**
- `bound require` (17)

### `node:child_process`
`node:child_process:473` | Self: 0.0% (0us) | Total: 0.0% (169us) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4230` | Self: 0.0% (0us) | Total: 0.0% (538us) | Samples: 0

**Called by:**
- `AstView` (3)

**Calls:**
- `Uint32Array` (3)

### `ImportDeclaration`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:372` | Self: 0.0% (0us) | Total: 0.0% (173us) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `getDeclaredVariables` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:517` | Self: 0.0% (0us) | Total: 0.0% (327us) | Samples: 0

**Called by:**
- `_execReport` (2)

**Calls:**
- `getFirstToken` (1)
- `getFirstToken` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1533` | Self: 0.0% (0us) | Total: 0.0% (166us) | Samples: 0

**Called by:**
- `getStaticStringValue` (1)

**Calls:**
- `_cookTemplate` (1)

### `_compileSelectorFastMatcher`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5050` | Self: 0.0% (0us) | Total: 0.0% (193us) | Samples: 0

**Called by:**
- `_getOrBuildSelectorPlan` (1)

**Calls:**
- `map` (1)

### `fn`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5101` | Self: 0.0% (0us) | Total: 0.0% (320us) | Samples: 0

**Called by:**
- `_runSelectorList` (2)

**Calls:**
- `get type` (1)
- `get type` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1885` | Self: 0.0% (0us) | Total: 2.3% (20.1ms) | Samples: 0

**Called by:**
- `findVariablesInScope` (39)
- `collectUnusedVariables` (37)
- `Program` (25)
- `checkForShadows` (7)
- `ensureFenVars` (5)

**Calls:**
- `ensureVarsSet` (108)
- `ensureVarsSet` (3)
- `ensureVarsSet` (1)
- `ensureVarsSet` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7380` | Self: 0.0% (0us) | Total: 6.2% (54.7ms) | Samples: 0

**Called by:**
- `runOnce` (317)

**Calls:**
- `buildVisitorMap` (54)
- `buildVisitorMap` (51)
- `buildVisitorMap` (31)
- `buildVisitorMap` (28)
- `buildVisitorMap` (26)
- `buildVisitorMap` (26)
- `buildVisitorMap` (15)
- `buildVisitorMap` (14)
- `buildVisitorMap` (9)
- `buildVisitorMap` (8)
- `buildVisitorMap` (8)
- `buildVisitorMap` (7)
- `buildVisitorMap` (6)
- `buildVisitorMap` (5)
- `buildVisitorMap` (3)
- `buildVisitorMap` (3)
- `buildVisitorMap` (3)
- `buildVisitorMap` (3)
- `buildVisitorMap` (3)
- `buildVisitorMap` (2)
- `buildVisitorMap` (1)
- `buildVisitorMap` (1)
- `buildVisitorMap` (1)
- `buildVisitorMap` (1)
- `buildVisitorMap` (1)
- `buildVisitorMap` (1)
- `buildVisitorMap` (1)
- `buildVisitorMap` (1)
- `buildVisitorMap` (1)
- `buildVisitorMap` (1)
- `buildVisitorMap` (1)
- `buildVisitorMap` (1)

### `_runSelectorList`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5992` | Self: 0.0% (0us) | Total: 0.1% (1.1ms) | Samples: 0

**Called by:**
- `invokeSelectorHandlers` (7)

**Calls:**
- `getAncestorsFor` (4)
- `getAncestorsFor` (1)
- `getAncestorsFor` (1)
- `getAncestorsFor` (1)

### `groupByDestructuring`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:310` | Self: 0.0% (0us) | Total: 0.0% (318us) | Samples: 0

**Called by:**
- `Program:exit` (2)

**Calls:**
- `getDestructuringHost` (2)

### `internal:validators`
`internal:validators:47` | Self: 0.0% (0us) | Total: 0.0% (179us) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `hideFromStack` (1)

### `ReturnStatement`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:490` | Self: 0.0% (0us) | Total: 0.0% (174us) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `getFunctionNameWithKind` (1)

### `a`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (142us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:296` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `parseSource` (9)

**Calls:**
- `Uint32Array` (9)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:658` | Self: 0.0% (0us) | Total: 0.0% (160us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isUnusedExpression` (1)

### `isAssignmentTarget`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:143` | Self: 0.0% (0us) | Total: 0.0% (151us) | Samples: 0

**Called by:**
- `MemberExpression[computed!=true] > Identifier.property` (1)

**Calls:**
- `get left` (1)

### `_compileSelectorFastMatcher`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5051` | Self: 0.0% (0us) | Total: 0.0% (299us) | Samples: 0

**Called by:**
- `_compileSelectorFastMatcher` (1)
- `_getOrBuildSelectorPlan` (1)

**Calls:**
- `some` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2541` | Self: 0.0% (0us) | Total: 0.0% (338us) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (2)

**Calls:**
- `get local` (2)

### `getNameLocationInGlobalDirectiveComment`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2646` | Self: 0.0% (0us) | Total: 0.0% (180us) | Samples: 0

**Called by:**
- `iterateDeclarations` (1)

**Calls:**
- `getLocFromIndex` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6898` | Self: 0.0% (0us) | Total: 0.7% (6.3ms) | Samples: 0

**Called by:**
- `runPlugins` (39)

**Calls:**
- `invokeSelectorHandlers` (34)
- `invokeSelectorHandlers` (4)
- `invokeSelectorHandlers` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:555` | Self: 0.0% (0us) | Total: 0.0% (196us) | Samples: 0

**Called by:**
- `_precomputeScopes` (1)

**Calls:**
- `source` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:426` | Self: 0.0% (0us) | Total: 0.0% (142us) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `Uint32Array` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6194` | Self: 0.0% (0us) | Total: 0.1% (881us) | Samples: 0

**Called by:**
- `walkNodes` (4)
- `walkNodes` (1)

**Calls:**
- `get value` (1)
- `get value` (1)
- `get value` (1)
- `get value` (1)
- `get value` (1)

### `BinaryExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:196` | Self: 0.0% (0us) | Total: 0.0% (193us) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `areLiteralsAndSameType` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:662` | Self: 0.0% (0us) | Total: 0.1% (973us) | Samples: 0

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `isInsideOfStorableFunction` (3)
- `isInsideOfStorableFunction` (2)
- `isStorableFunction` (1)

### `findUp`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:339` | Self: 0.0% (0us) | Total: 0.0% (174us) | Samples: 0

**Called by:**
- `checkGroup` (1)

**Calls:**
- `findUp` (1)

### `Program`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:449` | Self: 0.0% (0us) | Total: 5.9% (52.1ms) | Samples: 0

**Called by:**
- `safeHandler` (313)

**Calls:**
- `getScope` (278)
- `checkReferencesInScope` (20)
- `checkReferencesInScope` (15)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6749` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `runPlugins` (9)

**Calls:**
- `indexOf` (9)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7376` | Self: 0.0% (0us) | Total: 0.0% (146us) | Samples: 0

**Called by:**
- `runOnce` (1)

**Calls:**
- `RuleContext` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1744` | Self: 0.0% (0us) | Total: 0.1% (1.1ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (4)
- `checkForShadows` (1)

**Calls:**
- `ensureFenVars` (5)

### `get arguments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1890` | Self: 0.0% (0us) | Total: 0.0% (190us) | Samples: 0

**Called by:**
- `getArrayMethodName` (1)

**Calls:**
- `nodeRhs` (1)

### `BinaryExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:184` | Self: 0.0% (0us) | Total: 0.1% (1.0ms) | Samples: 0

**Called by:**
- `_invokeFused` (6)

**Calls:**
- `isNullCheck` (3)
- `isNullCheck` (3)

### `ensureFenVars`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1741` | Self: 0.0% (0us) | Total: 0.1% (1.1ms) | Samples: 0

**Called by:**
- `get` (5)

**Calls:**
- `get` (5)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5734` | Self: 0.0% (0us) | Total: 0.0% (150us) | Samples: 0

**Called by:**
- `_getOrBuildPlan` (1)

**Calls:**
- `get` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7382` | Self: 0.0% (0us) | Total: 76.0% (661.4ms) | Samples: 0

**Called by:**
- `runOnce` (3838)

**Calls:**
- `walkNodes` (1003)
- `walkNodes` (994)
- `walkNodes` (375)
- `walkNodes` (315)
- `walkNodes` (160)
- `walkNodes` (147)
- `walkNodes` (86)
- `walkNodes` (86)
- `walkNodes` (81)
- `walkNodes` (54)
- `walkNodes` (42)
- `walkNodes` (39)
- `walkNodes` (30)
- `walkNodes` (30)
- `walkNodes` (28)
- `walkNodes` (19)
- `walkNodes` (16)
- `walkNodes` (15)
- `walkNodes` (14)
- `walkNodes` (12)
- `walkNodes` (12)
- `walkNodes` (10)
- `walkNodes` (10)
- `walkNodes` (10)
- `walkNodes` (9)
- `walkNodes` (9)
- `walkNodes` (9)
- `walkNodes` (9)
- `walkNodes` (8)
- `walkNodes` (8)
- `walkNodes` (8)
- `walkNodes` (6)
- `walkNodes` (6)
- `walkNodes` (6)
- `walkNodes` (6)
- `walkNodes` (6)
- `walkNodes` (6)
- `walkNodes` (6)
- `walkNodes` (6)
- `walkNodes` (5)
- `walkNodes` (5)
- `walkNodes` (5)
- `walkNodes` (5)
- `walkNodes` (5)
- `walkNodes` (5)
- `walkNodes` (4)
- `walkNodes` (4)
- `walkNodes` (4)
- `walkNodes` (4)
- `walkNodes` (4)
- `walkNodes` (4)
- `walkNodes` (3)
- `walkNodes` (3)
- `walkNodes` (3)
- `walkNodes` (3)
- `walkNodes` (3)
- `walkNodes` (3)
- `walkNodes` (3)
- `walkNodes` (3)
- `walkNodes` (3)
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
- `walkNodes` (1)
- `walkNodes` (1)

### `checkReference`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:212` | Self: 0.0% (0us) | Total: 0.0% (675us) | Samples: 0

**Called by:**
- `forEach` (4)

**Calls:**
- `report` (4)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:441` | Self: 0.0% (0us) | Total: 1.4% (12.3ms) | Samples: 0

**Called by:**
- `parseSource` (72)

**Calls:**
- `CfgGraph` (18)
- `CfgGraph` (5)
- `CfgGraph` (4)
- `CfgGraph` (3)
- `CfgGraph` (3)
- `CfgGraph` (3)
- `CfgGraph` (3)
- `CfgGraph` (3)
- `CfgGraph` (3)
- `CfgGraph` (3)
- `CfgGraph` (3)
- `CfgGraph` (2)
- `CfgGraph` (2)
- `CfgGraph` (2)
- `CfgGraph` (2)
- `CfgGraph` (2)
- `CfgGraph` (2)
- `CfgGraph` (2)
- `CfgGraph` (1)
- `CfgGraph` (1)
- `CfgGraph` (1)
- `CfgGraph` (1)
- `CfgGraph` (1)
- `CfgGraph` (1)
- `CfgGraph` (1)

### `get key`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3128` | Self: 0.0% (0us) | Total: 0.0% (148us) | Samples: 0

**Called by:**
- `isImportAttributeKey` (1)

**Calls:**
- `get type` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6716` | Self: 0.0% (0us) | Total: 6.0% (52.5ms) | Samples: 0

**Called by:**
- `runPlugins` (315)

**Calls:**
- `safeHandler` (313)
- `safeHandler` (1)
- `safeHandler` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2498` | Self: 0.0% (0us) | Total: 0.1% (875us) | Samples: 0

**Called by:**
- `getDeclaredVariables` (2)
- `_buildScopeVarsAndSet` (2)

**Calls:**
- `_symName` (4)

### `get init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2909` | Self: 0.0% (0us) | Total: 0.0% (177us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `nodeLhs` (1)

### `ObjectExpression > Property[computed!=true] > Identifier.key,MethodDefinition[computed!=true] > Identifier.key,PropertyDefinition[computed!=true] > Identifier.key,MethodDefinition > PrivateIdentifier.key,PropertyDefinition > PrivateIdentifier.key`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:352` | Self: 0.0% (0us) | Total: 0.0% (190us) | Samples: 0

**Called by:**
- `_runSelectorList` (1)

**Calls:**
- `isImportAttributeKey` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6863` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `runPlugins` (9)

**Calls:**
- `getDFSEvents` (7)
- `getDFSEvents` (1)
- `getDFSEvents` (1)

### `wordsRegexp`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:285` | Self: 0.0% (0us) | Total: 0.0% (300us) | Samples: 0

**Called by:**
- `buildUnicodeData` (2)

**Calls:**
- `RegExp` (1)
- `replace` (1)

### `get expressions`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3031` | Self: 0.0% (0us) | Total: 0.0% (142us) | Samples: 0

**Called by:**
- `isStorableFunction` (1)

**Calls:**
- `nodeRhs` (1)

### `_isSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4030` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (8)

**Calls:**
- `map` (6)
- `stringSplitFast` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6588` | Self: 0.0% (0us) | Total: 0.0% (167us) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `get` (1)

### `isNullLiteral`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:205` | Self: 0.0% (0us) | Total: 0.0% (170us) | Samples: 0

**Called by:**
- `isNullCheck` (1)

**Calls:**
- `get value` (1)

### `getIdentifierIfShouldBeConst`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:261` | Self: 0.0% (0us) | Total: 0.0% (313us) | Samples: 0

**Called by:**
- `groupByDestructuring` (2)

**Calls:**
- `canBecomeVariableDeclaration` (1)
- `canBecomeVariableDeclaration` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2267` | Self: 0.0% (0us) | Total: 10.4% (91.3ms) | Samples: 0

**Called by:**
- `ensureRefsThrough` (541)

**Calls:**
- `get` (541)

### `ObjectExpression > Property[computed!=true] > Identifier.key,MethodDefinition[computed!=true] > Identifier.key,PropertyDefinition[computed!=true] > Identifier.key,MethodDefinition > PrivateIdentifier.key,PropertyDefinition > PrivateIdentifier.key`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:357` | Self: 0.0% (0us) | Total: 0.0% (342us) | Samples: 0

**Called by:**
- `_runSelectorList` (2)

**Calls:**
- `report` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6524` | Self: 0.0% (0us) | Total: 19.6% (170.9ms) | Samples: 0

**Called by:**
- `runPlugins` (1003)

**Calls:**
- `_getOrBuildPlan` (1000)
- `_getOrBuildPlan` (3)

### `findUp`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:333` | Self: 0.0% (0us) | Total: 0.0% (367us) | Samples: 0

**Called by:**
- `findUp` (1)
- `checkGroup` (1)

**Calls:**
- `(anonymous)` (1)
- `(anonymous)` (1)

### `isInsideOfStorableFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:634` | Self: 0.0% (0us) | Total: 0.0% (362us) | Samples: 0

**Called by:**
- `isReadForItself` (2)

**Calls:**
- `isInside` (1)
- `isInside` (1)

### `reportReferenceId`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:251` | Self: 0.0% (0us) | Total: 0.0% (823us) | Samples: 0

**Called by:**
- `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause` (4)
- `Program` (1)

**Calls:**
- `equalsToOriginalName` (2)
- `equalsToOriginalName` (1)
- `equalsToOriginalName` (1)
- `equalsToOriginalName` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:510` | Self: 0.0% (0us) | Total: 0.1% (1.1ms) | Samples: 0

**Called by:**
- `forEach` (7)

**Calls:**
- `report` (7)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:329` | Self: 0.0% (0us) | Total: 0.0% (371us) | Samples: 0

**Called by:**
- `parseSource` (2)

**Calls:**
- `Uint32Array` (2)

### `getFunctionHeadLoc`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2299` | Self: 0.0% (0us) | Total: 0.0% (154us) | Samples: 0

**Called by:**
- `checkLastSegment` (1)

**Calls:**
- `getTokenBefore` (1)

### `isEvaluatedDuringInitialization`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:168` | Self: 0.0% (0us) | Total: 0.0% (167us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isFromSeparateExecutionContext` (1)

### `checkLastSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:370` | Self: 0.0% (0us) | Total: 0.0% (835us) | Samples: 0

**Called by:**
- `_invokeFused` (5)

**Calls:**
- `get body` (2)
- `get type` (2)
- `get body` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1907` | Self: 0.0% (0us) | Total: 0.0% (443us) | Samples: 0

**Called by:**
- `_buildScope` (3)

**Calls:**
- `get type` (2)
- `get type` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` | Self: 0.0% (0us) | Total: 0.1% (888us) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `bound require` (5)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2978` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `_buildThinVariable` (6)
- `_buildVariable` (2)
- `_buildReference` (1)

**Calls:**
- `_buildThinVariable` (3)
- `_buildThinVariable` (3)
- `_buildThinVariable` (2)
- `_buildThinVariable` (1)

### `isEvaluatedDuringInitialization`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:197` | Self: 0.0% (0us) | Total: 0.0% (518us) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `isInRange` (2)
- `get init` (1)

### `fn`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5100` | Self: 0.0% (0us) | Total: 0.0% (653us) | Samples: 0

**Called by:**
- `fn` (3)
- `_runSelectorList` (1)

**Calls:**
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2060` | Self: 0.0% (0us) | Total: 0.0% (374us) | Samples: 0

**Called by:**
- `ensureVarsSet` (2)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (2)

### `checkForShadows`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:636` | Self: 0.0% (0us) | Total: 0.0% (185us) | Samples: 0

**Called by:**
- `Program:exit` (1)

**Calls:**
- `isThisParam` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:162` | Self: 0.0% (0us) | Total: 0.0% (336us) | Samples: 0

**Called by:**
- `BinaryExpression` (2)

**Calls:**
- `report` (2)

### `(anonymous)`
`node:child_process:777` | Self: 0.0% (0us) | Total: 0.0% (169us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `defineProperties` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` | Self: 0.0% (0us) | Total: 0.9% (8.6ms) | Samples: 0

**Called by:**
- `some` (52)

**Calls:**
- `getRhsNode` (46)
- `getRhsNode` (3)
- `getRhsNode` (1)
- `getRhsNode` (1)
- `getRhsNode` (1)

### `BinaryExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:206` | Self: 0.0% (0us) | Total: 0.4% (3.9ms) | Samples: 0

**Called by:**
- `_invokeFused` (19)

**Calls:**
- `report` (13)
- `report` (2)
- `report` (2)
- `report` (1)
- `report` (1)

### `requestInstantiate`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (925us) | Samples: 0

**Called by:**
- `requestSatisfyUtil` (5)

**Calls:**
- `async (anonymous)` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:464` | Self: 0.0% (0us) | Total: 0.0% (144us) | Samples: 0

**Called by:**
- `every` (1)

**Calls:**
- `get init` (1)

### `g`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (9)

**Calls:**
- `parse` (8)
- `parse` (1)

### `requestFetch`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (722us) | Samples: 0

**Called by:**
- `async (anonymous)` (4)

**Calls:**
- `fetch` (4)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4200` | Self: 0.0% (0us) | Total: 0.0% (356us) | Samples: 0

**Called by:**
- `AstView` (2)

**Calls:**
- `Uint32Array` (2)

### `getStaticPropertyName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:327` | Self: 0.0% (0us) | Total: 0.0% (488us) | Samples: 0

**Called by:**
- `isSpecificMemberAccess` (3)

**Calls:**
- `get type` (2)
- `get type` (1)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2874` | Self: 0.0% (0us) | Total: 0.2% (1.9ms) | Samples: 0

**Called by:**
- `_buildReference` (11)

**Calls:**
- `_buildThinScope` (6)
- `_buildThinScope` (1)
- `_buildThinScope` (1)
- `_buildThinScope` (1)
- `_buildThinScope` (1)
- `_buildThinScope` (1)

### `Program`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:147` | Self: 0.0% (0us) | Total: 1.4% (12.6ms) | Samples: 0

**Called by:**
- `_invokeFused` (72)

**Calls:**
- `findVariablesInScope` (39)
- `findVariablesInScope` (26)
- `findVariablesInScope` (7)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3040` | Self: 0.0% (0us) | Total: 0.0% (176us) | Samples: 0

**Called by:**
- `VariableDeclaration` (1)

**Calls:**
- `Map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:432` | Self: 0.0% (0us) | Total: 0.0% (314us) | Samples: 0

**Called by:**
- `forEach` (2)

**Calls:**
- `get range` (1)
- `get range` (1)

### `groupByDestructuring`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:290` | Self: 0.0% (0us) | Total: 0.3% (3.1ms) | Samples: 0

**Called by:**
- `Program:exit` (18)

**Calls:**
- `getIdentifierIfShouldBeConst` (4)
- `getIdentifierIfShouldBeConst` (2)
- `getIdentifierIfShouldBeConst` (2)
- `getIdentifierIfShouldBeConst` (2)
- `getIdentifierIfShouldBeConst` (2)
- `getIdentifierIfShouldBeConst` (2)
- `getIdentifierIfShouldBeConst` (1)
- `getIdentifierIfShouldBeConst` (1)
- `getIdentifierIfShouldBeConst` (1)
- `getIdentifierIfShouldBeConst` (1)

### `checkGroup`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:412` | Self: 0.0% (0us) | Total: 0.0% (367us) | Samples: 0

**Called by:**
- `forEach` (2)

**Calls:**
- `findUp` (1)
- `findUp` (1)

### `internal:shared`
`internal:shared:2` | Self: 0.0% (0us) | Total: 0.0% (501us) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `anonymous` (3)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3783` | Self: 0.0% (0us) | Total: 0.0% (155us) | Samples: 0

**Called by:**
- `report` (1)

**Calls:**
- `push` (1)

### `ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1754` | Self: 0.0% (0us) | Total: 0.0% (766us) | Samples: 0

**Called by:**
- `get` (3)

**Calls:**
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4205` | Self: 0.0% (0us) | Total: 0.0% (135us) | Samples: 0

**Called by:**
- `AstView` (1)

**Calls:**
- `Uint32Array` (1)

### `getDefinedMessageData`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:279` | Self: 0.0% (0us) | Total: 0.0% (337us) | Samples: 0

**Called by:**
- `Program:exit` (2)

**Calls:**
- `defToVariableType` (2)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:401` | Self: 0.0% (0us) | Total: 0.0% (497us) | Samples: 0

**Called by:**
- `parseSource` (3)

**Calls:**
- `Uint16Array` (3)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:302` | Self: 0.0% (0us) | Total: 0.0% (623us) | Samples: 0

**Called by:**
- `parseSource` (4)

**Calls:**
- `Uint32Array` (4)

### `getStaticPropertyName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:328` | Self: 0.0% (0us) | Total: 0.0% (454us) | Samples: 0

**Called by:**
- `isSpecificMemberAccess` (2)
- `onCodePathStart` (1)

**Calls:**
- `get name` (1)
- `get name` (1)
- `get name` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:414` | Self: 0.0% (0us) | Total: 0.0% (347us) | Samples: 0

**Called by:**
- `_buildThinVariable` (1)
- `_buildVariable` (1)

**Calls:**
- `get type` (1)
- `get type` (1)

### `getFunctionNameWithKind`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2180` | Self: 0.0% (0us) | Total: 0.0% (376us) | Samples: 0

**Called by:**
- `checkLastSegment` (2)

**Calls:**
- `get id` (1)
- `get id` (1)

### `moduleEvaluation`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (143us) | Samples: 0

**Called by:**
- `async loadAndEvaluateModule` (1)

**Calls:**
- `evaluate` (1)

### `generatorResume`
`[native code]` | Self: 0.0% (0us) | Total: 0.2% (2.0ms) | Samples: 0

**Called by:**
- `next` (8)
- `findVariablesInScope` (4)

**Calls:**
- `iterateDeclarations` (6)
- `iterateDeclarations` (4)
- `iterateDeclarations` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.3% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (16)

**Calls:**
- `bound require` (16)

### `Ee`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (164us) | Samples: 0

**Called by:**
- `Ae` (1)

**Calls:**
- `ge` (1)

### `getIdentifierIfShouldBeConst`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:221` | Self: 0.0% (0us) | Total: 0.0% (382us) | Samples: 0

**Called by:**
- `groupByDestructuring` (2)

**Calls:**
- `filter` (2)

### `isModifyingProp`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:95` | Self: 0.0% (0us) | Total: 0.0% (155us) | Samples: 0

**Called by:**
- `checkReference` (1)

**Calls:**
- `/(?:Statement\|Declaration\|Function(?:Expression)?\|Program)$/u` (1)

### `getUpperFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:134` | Self: 0.0% (0us) | Total: 0.0% (331us) | Samples: 0

**Called by:**
- `isInsideOfStorableFunction` (2)

**Calls:**
- `test` (1)
- `get type` (1)

### `existsSync`
`node:fs:273` | Self: 0.0% (0us) | Total: 0.0% (318us) | Samples: 0

**Called by:**
- `_tryLoad` (1)
- `(anonymous)` (1)

**Calls:**
- `existsSync` (2)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:466` | Self: 0.0% (0us) | Total: 0.0% (197us) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `Uint32Array` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3758` | Self: 0.0% (0us) | Total: 0.0% (376us) | Samples: 0

**Called by:**
- `report` (2)

**Calls:**
- `getLocFromIndex` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:208` | Self: 0.0% (0us) | Total: 0.0% (166us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `kw` (1)

### `checkReference`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:209` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `forEach` (7)

**Calls:**
- `isModifyingProp` (2)
- `isModifyingProp` (1)
- `isModifyingProp` (1)
- `isModifyingProp` (1)
- `isModifyingProp` (1)
- `isModifyingProp` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:542` | Self: 0.0% (0us) | Total: 0.7% (6.3ms) | Samples: 0

**Called by:**
- `_invokeFused` (38)

**Calls:**
- `groupByDestructuring` (18)
- `forEach` (18)
- `groupByDestructuring` (2)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1711` | Self: 0.0% (0us) | Total: 0.0% (189us) | Samples: 0

**Called by:**
- `isEvaluatedDuringInitialization` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `_loadFromDisk`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:69` | Self: 0.0% (0us) | Total: 0.0% (557us) | Samples: 0

**Called by:**
- `_getPlugin` (3)

**Calls:**
- `tryParse` (3)

### `getFunctionNameWithKind`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2115` | Self: 0.0% (0us) | Total: 0.0% (159us) | Samples: 0

**Called by:**
- `checkLastSegment` (1)

**Calls:**
- `get type` (1)

### `Program`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:295` | Self: 0.0% (0us) | Total: 0.0% (651us) | Samples: 0

**Called by:**
- `_invokeFused` (4)

**Calls:**
- `isImportAttributeKey` (2)
- `isImportAttributeKey` (1)
- `isImportAttributeKey` (1)

### `_compileSelectorFastMatcher`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4991` | Self: 0.0% (0us) | Total: 0.0% (329us) | Samples: 0

**Called by:**
- `_compileSelectorFastMatcher` (2)

**Calls:**
- `filter` (2)

### `bound call`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (135us) | Samples: 0

**Called by:**
- `makeSafe` (1)

**Calls:**
- `forEach` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1690` | Self: 0.0% (0us) | Total: 0.0% (152us) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `filter` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:397` | Self: 0.0% (0us) | Total: 0.0% (145us) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `getUint32` (1)

### `node:fs`
`node:fs:303` | Self: 0.0% (0us) | Total: 0.0% (191us) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3574` | Self: 0.0% (0us) | Total: 0.0% (168us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `_isStatementTag` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6900` | Self: 0.0% (0us) | Total: 7.4% (65.0ms) | Samples: 0

**Called by:**
- `runPlugins` (375)

**Calls:**
- `_invokeFused` (366)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `nodeView` (1)
- `_invokeFused` (1)

### `isInTdz`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:490` | Self: 0.0% (0us) | Total: 0.0% (832us) | Samples: 0

**Called by:**
- `checkForShadows` (5)

**Calls:**
- `getNameRange` (5)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1628` | Self: 0.0% (0us) | Total: 0.0% (155us) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `set` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5899` | Self: 0.0% (0us) | Total: 0.0% (822us) | Samples: 0

**Called by:**
- `runPlugins` (5)

**Calls:**
- `_ensureTagCaches` (2)
- `_ensureTagCaches` (1)
- `_ensureTagCaches` (1)
- `_ensureTagCaches` (1)

### `Pe`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `_e` (7)

**Calls:**
- `we` (7)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4202` | Self: 0.0% (0us) | Total: 0.0% (338us) | Samples: 0

**Called by:**
- `AstView` (2)

**Calls:**
- `Uint32Array` (2)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7342` | Self: 0.0% (0us) | Total: 0.0% (148us) | Samples: 0

**Called by:**
- `runOnce` (1)

**Calls:**
- `map` (1)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1528` | Self: 0.0% (0us) | Total: 0.0% (165us) | Samples: 0

**Called by:**
- `checkForBlock` (1)

**Calls:**
- `_scopeForNode` (1)

### `we`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `Pe` (7)

**Calls:**
- `ke` (6)
- `ke` (1)

### `equalsToOriginalName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:179` | Self: 0.0% (0us) | Total: 0.0% (158us) | Samples: 0

**Called by:**
- `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause` (1)

**Calls:**
- `get key` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1702` | Self: 0.0% (0us) | Total: 0.0% (165us) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `extraArrowData` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6713` | Self: 0.0% (0us) | Total: 0.0% (161us) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `get key`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3120` | Self: 0.0% (0us) | Total: 0.0% (158us) | Samples: 0

**Called by:**
- `equalsToOriginalName` (1)

**Calls:**
- `getUint32` (1)

### `tryParse`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:126` | Self: 0.0% (0us) | Total: 0.0% (557us) | Samples: 0

**Called by:**
- `_loadFromDisk` (3)

**Calls:**
- `parse` (3)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4234` | Self: 0.0% (0us) | Total: 0.6% (5.4ms) | Samples: 0

**Called by:**
- `runPlugins` (31)

**Calls:**
- `_isSelector` (8)
- `_isSelector` (7)
- `_isSelector` (6)
- `_isSelector` (5)
- `_isSelector` (5)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4212` | Self: 0.0% (0us) | Total: 0.0% (334us) | Samples: 0

**Called by:**
- `AstView` (2)

**Calls:**
- `Uint32Array` (2)

### `getDefinedMessageData`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:278` | Self: 0.0% (0us) | Total: 0.0% (338us) | Samples: 0

**Called by:**
- `Program:exit` (2)

**Calls:**
- `getVariableDescription` (2)

### `loadBinding`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` | Self: 0.0% (0us) | Total: 0.1% (1.0ms) | Samples: 0

**Called by:**
- `getTagNames` (5)
- `parseSource` (1)

**Calls:**
- `bound require` (5)
- `(anonymous)` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6484` | Self: 0.0% (0us) | Total: 0.8% (7.0ms) | Samples: 0

**Called by:**
- `walkNodes` (41)

**Calls:**
- `onCodePathStart` (38)
- `onCodePathStart` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6577` | Self: 0.0% (0us) | Total: 0.1% (987us) | Samples: 0

**Called by:**
- `runPlugins` (6)

**Calls:**
- `indexOf` (6)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:202` | Self: 0.0% (0us) | Total: 0.0% (170us) | Samples: 0

**Called by:**
- `reportReferenceId` (1)

**Calls:**
- `get range` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:401` | Self: 0.0% (0us) | Total: 0.2% (2.2ms) | Samples: 0

**Called by:**
- `_buildVariable` (11)
- `_buildThinVariable` (3)

**Calls:**
- `get parent` (4)
- `get parent` (3)
- `get parent` (2)
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `MemberExpression[computed!=true] > Identifier.property`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:362` | Self: 0.0% (0us) | Total: 0.0% (650us) | Samples: 0

**Called by:**
- `_runSelectorList` (4)

**Calls:**
- `isAssignmentTarget` (2)
- `get parent` (1)
- `isAssignmentTarget` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (8)

**Calls:**
- `bound require` (8)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1711` | Self: 0.0% (0us) | Total: 0.1% (871us) | Samples: 0

**Called by:**
- `_invokeFused` (4)

**Calls:**
- `getAssignedMessageData` (2)
- `getAssignedMessageData` (1)
- `getAssignedMessageData` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn-jsx/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (373us) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `getArrayMethodName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:126` | Self: 0.0% (0us) | Total: 0.0% (190us) | Samples: 0

**Called by:**
- `onCodePathStart` (1)

**Calls:**
- `get arguments` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1337` | Self: 0.0% (0us) | Total: 0.3% (2.8ms) | Samples: 0

**Called by:**
- `_buildScopeRefsAndThrough` (9)
- `_buildScopeRefsAndThrough` (3)
- `getFunctionNameWithKind` (1)
- `MemberExpression[computed!=true] > Identifier.property` (1)
- `Program` (1)
- `getStaticPropertyName` (1)
- `checkReference` (1)

**Calls:**
- `_identAt` (12)
- `_resolveUnicodeEscapes` (4)
- `_identAt` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:654` | Self: 0.0% (0us) | Total: 0.0% (193us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get left` (1)

### `shouldCheck`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:413` | Self: 0.0% (0us) | Total: 0.0% (655us) | Samples: 0

**Called by:**
- `filter` (4)

**Calls:**
- `isClassRefInClassDecorator` (3)
- `isClassRefInClassDecorator` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1625` | Self: 0.0% (0us) | Total: 0.0% (345us) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (2)

**Calls:**
- `_symName` (2)

### `dlopen`
`bun:ffi:351` | Self: 0.0% (0us) | Total: 0.0% (192us) | Samples: 0

**Called by:**
- `_tryLoad` (1)

**Calls:**
- `FFIBuilder` (1)

### `checkForShadows`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:657` | Self: 0.0% (0us) | Total: 0.0% (194us) | Samples: 0

**Called by:**
- `Program:exit` (1)

**Calls:**
- `isTypeValueShadow` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2646` | Self: 0.0% (0us) | Total: 0.0% (135us) | Samples: 0

**Called by:**
- `getDeclaredVariables` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `checkForShadows`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:633` | Self: 0.0% (0us) | Total: 0.0% (165us) | Samples: 0

**Called by:**
- `Program:exit` (1)

**Calls:**
- `isDuplicatedEnumNameVariable` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:12` | Self: 0.0% (0us) | Total: 0.0% (188us) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `isInside`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:494` | Self: 0.0% (0us) | Total: 0.0% (352us) | Samples: 0

**Called by:**
- `getRhsNode` (1)
- `isInsideOfStorableFunction` (1)

**Calls:**
- `get range` (1)
- `get range` (1)

### `_getPlugin`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:60` | Self: 0.0% (0us) | Total: 0.0% (730us) | Samples: 0

**Called by:**
- `describeRule` (4)

**Calls:**
- `_loadFromDisk` (3)
- `_loadFromDisk` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` | Self: 0.0% (0us) | Total: 0.8% (7.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (46)

**Calls:**
- `isInLoop` (24)
- `isInLoop` (16)
- `isInLoop` (6)

### `getIdentifierIfShouldBeConst`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:213` | Self: 0.0% (0us) | Total: 0.0% (182us) | Samples: 0

**Called by:**
- `groupByDestructuring` (1)

**Calls:**
- `get left` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:3999` | Self: 0.0% (0us) | Total: 0.0% (463us) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `buildUnicodeData` (2)
- `buildUnicodeData` (1)

### `_getOrBuildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5453` | Self: 0.0% (0us) | Total: 19.5% (170.5ms) | Samples: 0

**Called by:**
- `walkNodes` (1000)

**Calls:**
- `_buildPlan` (146)
- `_buildPlan` (127)
- `_buildPlan` (120)
- `_buildPlan` (118)
- `_buildPlan` (67)
- `_buildPlan` (56)
- `_buildPlan` (51)
- `_buildPlan` (48)
- `_buildPlan` (46)
- `_buildPlan` (35)
- `_buildPlan` (26)
- `_buildPlan` (22)
- `_buildPlan` (18)
- `_buildPlan` (13)
- `_buildPlan` (13)
- `_buildPlan` (11)
- `_buildPlan` (10)
- `_buildPlan` (8)
- `_buildPlan` (7)
- `_buildPlan` (6)
- `_buildPlan` (6)
- `_buildPlan` (6)
- `_buildPlan` (6)
- `_buildPlan` (5)
- `_buildPlan` (5)
- `_buildPlan` (4)
- `_buildPlan` (4)
- `_buildPlan` (3)
- `_buildPlan` (2)
- `_buildPlan` (2)
- `_buildPlan` (2)
- `_buildPlan` (2)
- `_buildPlan` (1)
- `_buildPlan` (1)
- `_buildPlan` (1)
- `_buildPlan` (1)
- `_buildPlan` (1)

### `initialSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4343` | Self: 0.0% (0us) | Total: 0.0% (330us) | Samples: 0

**Called by:**
- `_fireCfgEvents` (2)

**Calls:**
- `segment` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6578` | Self: 0.0% (0us) | Total: 0.0% (146us) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `get` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:430` | Self: 0.0% (0us) | Total: 0.0% (459us) | Samples: 0

**Called by:**
- `_buildVariable` (3)

**Calls:**
- `_tag` (3)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 55.5% | 483.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 23.2% | 202.3ms | `[native code]` |
| 13.1% | 114.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 3.0% | 26.8ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.7% | 6.5ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js` |
| 0.6% | 6.0ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js` |
| 0.4% | 4.0ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js` |
| 0.4% | 3.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js` |
| 0.4% | 3.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js` |
| 0.3% | 3.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js` |
| 0.3% | 3.2ms | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js` |
| 0.2% | 2.5ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js` |
| 0.2% | 2.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/index.js` |
| 0.2% | 1.8ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.1% | 1.2ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js` |
| 0.1% | 878us | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js` |
| 0.0% | 856us | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 685us | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js` |
| 0.0% | 357us | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` |
| 0.0% | 334us | `internal:primordials` |
| 0.0% | 193us | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js` |
| 0.0% | 193us | `node:fs/promises` |
| 0.0% | 182us | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/escape-string-regexp/index.js` |
| 0.0% | 179us | `internal:shared` |
| 0.0% | 171us | `node:os` |
| 0.0% | 165us | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/fix-tracker.js` |
