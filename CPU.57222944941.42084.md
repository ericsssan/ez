# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 859.7ms | 4962 | 100us | 1378 |

**Top 10:** `parse` 5.8%, `_buildScopeVarsAndSet` 2.7%, `Uint32Array` 2.5%, `_mkGlobalVar` 2.3%, `walkNodes` 2.3%, `anonymous` 2.2%, `_buildPlan` 2.1%, `DataView` 2.1%, `walkNodes` 1.7%, `walkNodes` 1.7%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 5.8% | 50.2ms | 5.8% | 50.2ms | `parse` | `[native code]` |
| 2.7% | 23.5ms | 2.9% | 24.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1998` |
| 2.5% | 21.7ms | 2.5% | 21.7ms | `Uint32Array` | `[native code]` |
| 2.3% | 19.9ms | 2.3% | 19.9ms | `_mkGlobalVar` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:587` |
| 2.3% | 19.7ms | 2.4% | 21.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6826` |
| 2.2% | 19.5ms | 5.5% | 47.9ms | `anonymous` | `[native code]` |
| 2.1% | 18.3ms | 2.1% | 18.3ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5745` |
| 2.1% | 18.2ms | 2.1% | 18.2ms | `DataView` | `[native code]` |
| 1.7% | 15.4ms | 1.7% | 15.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6685` |
| 1.7% | 14.7ms | 1.8% | 15.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6602` |
| 1.7% | 14.6ms | 1.9% | 16.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6759` |
| 1.5% | 13.6ms | 1.5% | 13.6ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5761` |
| 1.1% | 10.2ms | 1.1% | 10.2ms | `Set` | `[native code]` |
| 1.1% | 9.7ms | 1.3% | 11.3ms | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5804` |
| 1.0% | 9.2ms | 1.1% | 10.0ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5690` |
| 1.0% | 8.9ms | 1.0% | 8.9ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5754` |
| 1.0% | 8.7ms | 1.0% | 8.7ms | `Uint8Array` | `[native code]` |
| 1.0% | 8.6ms | 1.1% | 9.4ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5687` |
| 1.0% | 8.5ms | 2.7% | 23.4ms | `some` | `[native code]` |
| 0.9% | 8.5ms | 1.1% | 10.1ms | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5803` |
| 0.9% | 8.1ms | 0.9% | 8.1ms | `defineProperties` | `[native code]` |
| 0.8% | 7.4ms | 0.8% | 7.4ms | `indexOf` | `[native code]` |
| 0.8% | 7.3ms | 0.8% | 7.3ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4176` |
| 0.7% | 6.5ms | 0.7% | 6.5ms | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5800` |
| 0.7% | 6.3ms | 0.7% | 6.3ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4837` |
| 0.6% | 5.6ms | 0.6% | 5.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6732` |
| 0.6% | 5.5ms | 0.6% | 5.5ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3890` |
| 0.6% | 5.4ms | 0.6% | 5.4ms | `get` | `[native code]` |
| 0.6% | 5.2ms | 0.6% | 5.2ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5714` |
| 0.6% | 5.2ms | 0.6% | 5.2ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4839` |
| 0.6% | 5.2ms | 0.6% | 5.4ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5697` |
| 0.5% | 4.7ms | 0.5% | 4.7ms | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5557` |
| 0.5% | 4.7ms | 0.5% | 4.7ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:505` |
| 0.5% | 4.5ms | 0.6% | 5.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1995` |
| 0.4% | 4.1ms | 0.4% | 4.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6733` |
| 0.4% | 4.1ms | 0.4% | 4.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6818` |
| 0.4% | 4.0ms | 0.5% | 5.0ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4842` |
| 0.4% | 4.0ms | 0.4% | 4.0ms | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:121` |
| 0.4% | 4.0ms | 0.4% | 4.0ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5647` |
| 0.4% | 3.9ms | 0.4% | 3.9ms | `stringSplitFast` | `[native code]` |
| 0.4% | 3.8ms | 0.4% | 3.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6731` |
| 0.4% | 3.8ms | 0.4% | 3.8ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1613` |
| 0.4% | 3.6ms | 0.4% | 3.6ms | `get _tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1072` |
| 0.4% | 3.6ms | 0.4% | 3.6ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4641` |
| 0.3% | 3.4ms | 0.3% | 3.4ms | `has` | `[native code]` |
| 0.3% | 3.2ms | 0.4% | 3.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6610` |
| 0.3% | 3.2ms | 0.4% | 3.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3994` |
| 0.3% | 3.2ms | 0.3% | 3.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1644` |
| 0.3% | 3.1ms | 0.6% | 5.5ms | `next` | `[native code]` |
| 0.3% | 3.0ms | 0.3% | 3.0ms | `add` | `[native code]` |
| 0.3% | 2.9ms | 0.3% | 2.9ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5731` |
| 0.3% | 2.9ms | 0.3% | 2.9ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1006` |
| 0.3% | 2.8ms | 0.4% | 3.6ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4838` |
| 0.3% | 2.8ms | 0.3% | 2.8ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` |
| 0.3% | 2.7ms | 0.3% | 2.7ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4661` |
| 0.3% | 2.7ms | 0.3% | 2.7ms | `entries` | `[native code]` |
| 0.3% | 2.7ms | 0.3% | 2.7ms | `_mkGlobalVar` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.3% | 2.6ms | 0.3% | 2.8ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4252` |
| 0.3% | 2.6ms | 0.9% | 7.9ms | `map` | `[native code]` |
| 0.3% | 2.5ms | 0.3% | 2.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.3% | 2.5ms | 0.3% | 2.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6865` |
| 0.2% | 2.5ms | 0.3% | 2.7ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4176` |
| 0.2% | 2.5ms | 0.3% | 3.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1285` |
| 0.2% | 2.4ms | 0.2% | 2.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4005` |
| 0.2% | 2.3ms | 0.2% | 2.3ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 2.2ms | 0.3% | 2.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6529` |
| 0.2% | 2.2ms | 0.2% | 2.2ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4823` |
| 0.2% | 2.2ms | 0.2% | 2.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5889` |
| 0.2% | 2.2ms | 0.2% | 2.2ms | `get _tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 2.2ms | 0.2% | 2.2ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5710` |
| 0.2% | 2.2ms | 0.2% | 2.5ms | `_applySchemaDefaults` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:170` |
| 0.2% | 2.1ms | 0.3% | 3.1ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:959` |
| 0.2% | 2.1ms | 0.2% | 2.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3986` |
| 0.2% | 2.0ms | 0.2% | 2.0ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5641` |
| 0.2% | 2.0ms | 0.5% | 4.5ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 0.2% | 2.0ms | 0.6% | 5.2ms | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5810` |
| 0.2% | 2.0ms | 0.3% | 3.3ms | `filter` | `[native code]` |
| 0.2% | 2.0ms | 0.2% | 2.0ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4635` |
| 0.2% | 1.9ms | 0.2% | 1.9ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.2% | 1.9ms | 0.2% | 1.9ms | `decode` | `[native code]` |
| 0.2% | 1.9ms | 0.2% | 1.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6412` |
| 0.2% | 1.8ms | 0.2% | 2.2ms | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5600` |
| 0.2% | 1.8ms | 0.2% | 2.3ms | `performIteration` | `[native code]` |
| 0.2% | 1.8ms | 0.5% | 4.4ms | `generatorResume` | `[native code]` |
| 0.2% | 1.8ms | 0.2% | 1.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6570` |
| 0.2% | 1.8ms | 0.2% | 1.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1954` |
| 0.2% | 1.8ms | 0.2% | 1.8ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1684` |
| 0.2% | 1.8ms | 0.2% | 1.8ms | `trim` | `[native code]` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4637` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4666` |
| 0.1% | 1.6ms | 0.2% | 1.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6533` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4006` |
| 0.1% | 1.6ms | 0.2% | 2.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6633` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:92` |
| 0.1% | 1.6ms | 0.4% | 3.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1222` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_isSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4033` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_isSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4029` |
| 0.1% | 1.5ms | 0.7% | 6.3ms | `findVariablesInScope` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:95` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:510` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6538` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5712` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `set` | `[native code]` |
| 0.1% | 1.4ms | 0.2% | 2.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5901` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5735` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `Map` | `[native code]` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `endsWith` | `[native code]` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `runOnce` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:95` |
| 0.1% | 1.3ms | 0.7% | 6.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1189` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `/^_+\|_+$/gu` | `[native code]` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6541` |
| 0.1% | 1.3ms | 0.6% | 5.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6735` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `dlopen` | `[native code]` |
| 0.1% | 1.3ms | 0.1% | 1.5ms | `_expandUnion` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4044` |
| 0.1% | 1.3ms | 0.1% | 1.6ms | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5564` |
| 0.1% | 1.3ms | 0.1% | 1.4ms | `toString` | `[native code]` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `fill` | `[native code]` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6969` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5649` |
| 0.1% | 1.2ms | 0.2% | 2.3ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4845` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `getFunctionHeadLoc` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2312` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4032` |
| 0.1% | 1.2ms | 0.1% | 1.4ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:747` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6949` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `slice` | `[native code]` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6416` |
| 0.1% | 1.1ms | 0.1% | 1.1ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1968` |
| 0.1% | 1.1ms | 0.1% | 1.1ms | `regExpMatchFast` | `[native code]` |
| 0.1% | 1.1ms | 0.2% | 1.8ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1013` |
| 0.1% | 1.1ms | 0.7% | 6.5ms | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3804` |
| 0.1% | 1.1ms | 0.1% | 1.1ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:490` |
| 0.1% | 1.1ms | 0.1% | 1.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4002` |
| 0.1% | 1.0ms | 0.1% | 1.2ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2099` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5716` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4656` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:528` |
| 0.1% | 1.0ms | 4.8% | 41.2ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` |
| 0.1% | 1.0ms | 0.3% | 3.3ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4232` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `get mainToken` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1089` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1330` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4192` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1038` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7082` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1175` |
| 0.1% | 1.0ms | 0.1% | 1.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1999` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `getUint32` | `[native code]` |
| 0.1% | 1.0ms | 0.1% | 1.3ms | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5591` |
| 0.1% | 997us | 1.0% | 9.1ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1884` |
| 0.1% | 985us | 0.4% | 3.8ms | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:152` |
| 0.1% | 984us | 0.1% | 984us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:961` |
| 0.1% | 982us | 0.1% | 982us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5915` |
| 0.1% | 978us | 0.2% | 2.3ms | `isUnderscored` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:101` |
| 0.1% | 976us | 0.1% | 976us | `includes` | `[native code]` |
| 0.1% | 975us | 0.3% | 3.3ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2893` |
| 0.1% | 974us | 0.1% | 974us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5730` |
| 0.1% | 974us | 0.4% | 4.0ms | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2874` |
| 0.1% | 968us | 0.1% | 968us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5642` |
| 0.1% | 954us | 0.1% | 954us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4001` |
| 0.1% | 940us | 0.1% | 1.3ms | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:809` |
| 0.1% | 938us | 0.1% | 938us | `test` | `[native code]` |
| 0.1% | 933us | 0.1% | 933us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3991` |
| 0.1% | 924us | 0.1% | 924us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 899us | 0.1% | 899us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4256` |
| 0.1% | 895us | 0.1% | 895us | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:533` |
| 0.1% | 887us | 0.2% | 2.1ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4214` |
| 0.1% | 880us | 0.1% | 1.4ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2060` |
| 0.1% | 879us | 0.1% | 879us | `/\r?\n/` | `[native code]` |
| 0.1% | 874us | 0.1% | 874us | `Uint16Array` | `[native code]` |
| 0.1% | 871us | 0.1% | 1.6ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2579` |
| 0.1% | 866us | 0.1% | 866us | `push` | `[native code]` |
| 0.0% | 856us | 0.0% | 856us | `_expandUnion` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4043` |
| 0.0% | 852us | 0.0% | 852us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 844us | 0.0% | 844us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1380` |
| 0.0% | 844us | 0.0% | 844us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1612` |
| 0.0% | 842us | 0.0% | 842us | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2979` |
| 0.0% | 839us | 0.1% | 1.3ms | `isLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:168` |
| 0.0% | 839us | 0.0% | 839us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5248` |
| 0.0% | 838us | 0.0% | 838us | `_applySchemaDefaults` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:161` |
| 0.0% | 828us | 0.0% | 828us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:205` |
| 0.0% | 820us | 0.1% | 1.0ms | `replace` | `[native code]` |
| 0.0% | 817us | 0.0% | 817us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1184` |
| 0.0% | 815us | 0.0% | 815us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:159` |
| 0.0% | 808us | 0.0% | 808us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5694` |
| 0.0% | 804us | 0.1% | 1.6ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:276` |
| 0.0% | 800us | 0.0% | 800us | `_tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1072` |
| 0.0% | 798us | 0.0% | 798us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4225` |
| 0.0% | 793us | 1.7% | 15.2ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2204` |
| 0.0% | 789us | 0.0% | 789us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6540` |
| 0.0% | 777us | 0.0% | 777us | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:773` |
| 0.0% | 773us | 0.1% | 1.1ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1674` |
| 0.0% | 766us | 0.0% | 766us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5655` |
| 0.0% | 754us | 0.1% | 894us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6727` |
| 0.0% | 754us | 0.1% | 1.2ms | `_deepMergeObjects` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:128` |
| 0.0% | 736us | 81.7% | 701.4ms | `runOnce` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:92` |
| 0.0% | 726us | 0.0% | 726us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6536` |
| 0.0% | 726us | 0.0% | 726us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1994` |
| 0.0% | 725us | 99.8% | 856.4ms | `parseModule` | `[native code]` |
| 0.0% | 717us | 0.0% | 717us | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.0% | 713us | 0.0% | 713us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6757` |
| 0.0% | 712us | 0.0% | 712us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2191` |
| 0.0% | 709us | 0.1% | 866us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6822` |
| 0.0% | 709us | 0.0% | 709us | `_parseDisableDirectives` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7412` |
| 0.0% | 707us | 1.9% | 16.9ms | `forEach` | `[native code]` |
| 0.0% | 697us | 0.0% | 697us | `slotTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5798` |
| 0.0% | 695us | 0.0% | 695us | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 692us | 0.1% | 1.1ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1384` |
| 0.0% | 682us | 1.7% | 14.9ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:441` |
| 0.0% | 680us | 0.0% | 851us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6569` |
| 0.0% | 678us | 0.0% | 678us | `get start` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1092` |
| 0.0% | 675us | 1.1% | 9.4ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1855` |
| 0.0% | 675us | 26.2% | 224.8ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4554` |
| 0.0% | 669us | 1.0% | 9.3ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1679` |
| 0.0% | 663us | 0.0% | 807us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5062` |
| 0.0% | 661us | 0.0% | 661us | `copyDataProperties` | `[native code]` |
| 0.0% | 661us | 0.2% | 2.3ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3786` |
| 0.0% | 661us | 0.0% | 661us | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6351` |
| 0.0% | 659us | 0.1% | 1.0ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1996` |
| 0.0% | 658us | 0.2% | 1.9ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:954` |
| 0.0% | 656us | 0.0% | 656us | `iterateDeclarations` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:68` |
| 0.0% | 652us | 0.0% | 652us | `_nodeEndPos` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:880` |
| 0.0% | 652us | 0.0% | 652us | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1067` |
| 0.0% | 650us | 0.0% | 650us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6729` |
| 0.0% | 647us | 0.0% | 810us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6263` |
| 0.0% | 646us | 0.0% | 646us | `runOnce` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:84` |
| 0.0% | 645us | 0.0% | 645us | `slotTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5792` |
| 0.0% | 644us | 0.0% | 644us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 640us | 3.3% | 28.5ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5771` |
| 0.0% | 640us | 2.2% | 19.7ms | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2337` |
| 0.0% | 636us | 0.0% | 636us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:642` |
| 0.0% | 635us | 0.0% | 635us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7032` |
| 0.0% | 633us | 0.0% | 633us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6824` |
| 0.0% | 631us | 0.0% | 631us | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:226` |
| 0.0% | 629us | 0.0% | 629us | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` |
| 0.0% | 624us | 0.0% | 624us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2317` |
| 0.0% | 622us | 0.0% | 622us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 622us | 0.0% | 622us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6817` |
| 0.0% | 618us | 0.1% | 1.4ms | `regExpSplitFast` | `[native code]` |
| 0.0% | 615us | 0.0% | 784us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6872` |
| 0.0% | 606us | 0.0% | 606us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:637` |
| 0.0% | 606us | 0.0% | 606us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6726` |
| 0.0% | 585us | 0.0% | 585us | `encodeInto` | `[native code]` |
| 0.0% | 575us | 0.2% | 2.2ms | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:802` |
| 0.0% | 574us | 0.0% | 574us | `get nodeTags` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:602` |
| 0.0% | 556us | 0.1% | 921us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6414` |
| 0.0% | 551us | 0.0% | 551us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 542us | 0.0% | 542us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1649` |
| 0.0% | 536us | 0.4% | 4.2ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:395` |
| 0.0% | 534us | 0.0% | 698us | `_expandUnion` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4042` |
| 0.0% | 533us | 0.0% | 533us | `iterateDeclarations` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:61` |
| 0.0% | 533us | 0.0% | 533us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3915` |
| 0.0% | 531us | 0.0% | 531us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6539` |
| 0.0% | 530us | 0.0% | 530us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3995` |
| 0.0% | 530us | 0.0% | 530us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2832` |
| 0.0% | 529us | 0.0% | 529us | `get byteLength` | `[native code]` |
| 0.0% | 526us | 16.8% | 144.6ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1888` |
| 0.0% | 526us | 0.0% | 526us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6735` |
| 0.0% | 523us | 0.0% | 700us | `isExported` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:369` |
| 0.0% | 523us | 8.3% | 71.2ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2267` |
| 0.0% | 521us | 0.0% | 521us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5798` |
| 0.0% | 520us | 0.0% | 520us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7322` |
| 0.0% | 517us | 0.1% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6758` |
| 0.0% | 515us | 0.0% | 515us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 515us | 0.0% | 515us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4003` |
| 0.0% | 512us | 0.1% | 882us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3046` |
| 0.0% | 512us | 0.0% | 657us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:440` |
| 0.0% | 510us | 4.0% | 34.7ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5782` |
| 0.0% | 508us | 0.0% | 508us | `propertyIsEnumerable` | `[native code]` |
| 0.0% | 507us | 0.0% | 507us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6635` |
| 0.0% | 505us | 0.6% | 5.7ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1952` |
| 0.0% | 504us | 0.4% | 3.5ms | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5161` |
| 0.0% | 503us | 0.0% | 503us | `lastIndexOf` | `[native code]` |
| 0.0% | 502us | 0.0% | 502us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4034` |
| 0.0% | 501us | 0.0% | 501us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5064` |
| 0.0% | 498us | 0.0% | 498us | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:664` |
| 0.0% | 497us | 0.0% | 497us | `get start` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 495us | 0.0% | 495us | `[Symbol.iterator]` | `[native code]` |
| 0.0% | 495us | 0.0% | 495us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1696` |
| 0.0% | 494us | 0.0% | 494us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7351` |
| 0.0% | 492us | 0.1% | 1.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6833` |
| 0.0% | 490us | 0.0% | 490us | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5801` |
| 0.0% | 490us | 0.0% | 490us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1993` |
| 0.0% | 488us | 0.0% | 488us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2352` |
| 0.0% | 487us | 0.0% | 487us | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4673` |
| 0.0% | 486us | 15.9% | 137.2ms | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1501` |
| 0.0% | 486us | 0.0% | 486us | `runOnce` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:96` |
| 0.0% | 486us | 0.1% | 1.3ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2470` |
| 0.0% | 485us | 0.0% | 485us | `Int32Array` | `[native code]` |
| 0.0% | 484us | 0.1% | 938us | `every` | `[native code]` |
| 0.0% | 484us | 0.6% | 5.7ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2553` |
| 0.0% | 483us | 1.2% | 10.7ms | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7373` |
| 0.0% | 482us | 0.0% | 620us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:423` |
| 0.0% | 481us | 1.0% | 9.2ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4226` |
| 0.0% | 480us | 0.1% | 975us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1663` |
| 0.0% | 479us | 0.0% | 479us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6612` |
| 0.0% | 472us | 0.0% | 472us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6504` |
| 0.0% | 471us | 0.1% | 942us | `readFileSync` | `[native code]` |
| 0.0% | 467us | 0.0% | 467us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3997` |
| 0.0% | 463us | 0.0% | 463us | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6358` |
| 0.0% | 462us | 0.0% | 462us | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2859` |
| 0.0% | 459us | 0.0% | 770us | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3594` |
| 0.0% | 458us | 0.0% | 458us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5258` |
| 0.0% | 454us | 0.1% | 949us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:306` |
| 0.0% | 452us | 0.1% | 1.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1255` |
| 0.0% | 446us | 0.0% | 446us | `_lineStarts` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:611` |
| 0.0% | 413us | 0.0% | 413us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6613` |
| 0.0% | 409us | 0.0% | 409us | `fetch` | `[native code]` |
| 0.0% | 398us | 0.0% | 398us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3791` |
| 0.0% | 389us | 0.0% | 389us | `iterateDeclarations` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:59` |
| 0.0% | 386us | 1.7% | 15.1ms | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1885` |
| 0.0% | 384us | 0.1% | 910us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:451` |
| 0.0% | 382us | 0.0% | 382us | `CfgSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4286` |
| 0.0% | 380us | 0.0% | 380us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1607` |
| 0.0% | 380us | 0.0% | 543us | `isGlobalAugmentation` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:136` |
| 0.0% | 380us | 14.2% | 121.9ms | `ensureRefsThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1824` |
| 0.0% | 379us | 0.0% | 379us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 379us | 0.1% | 1.3ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:435` |
| 0.0% | 378us | 0.0% | 378us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5290` |
| 0.0% | 374us | 0.0% | 374us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:930` |
| 0.0% | 373us | 21.7% | 186.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6524` |
| 0.0% | 372us | 0.0% | 372us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5693` |
| 0.0% | 369us | 0.0% | 369us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5752` |
| 0.0% | 369us | 0.0% | 796us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4195` |
| 0.0% | 369us | 0.0% | 369us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6634` |
| 0.0% | 369us | 0.0% | 369us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2774` |
| 0.0% | 368us | 0.0% | 368us | `_makeSafeHandler` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3818` |
| 0.0% | 367us | 0.0% | 367us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2183` |
| 0.0% | 365us | 0.0% | 365us | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1007` |
| 0.0% | 364us | 0.1% | 881us | `Program` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:294` |
| 0.0% | 363us | 0.0% | 363us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 362us | 0.0% | 843us | `hasRestSpreadSibling` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:411` |
| 0.0% | 362us | 0.0% | 362us | `iterateDeclarations` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:72` |
| 0.0% | 360us | 0.0% | 809us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:689` |
| 0.0% | 360us | 0.0% | 360us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7068` |
| 0.0% | 360us | 0.0% | 360us | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4655` |
| 0.0% | 360us | 0.1% | 1.2ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2529` |
| 0.0% | 359us | 0.0% | 359us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:165` |
| 0.0% | 359us | 0.0% | 717us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1237` |
| 0.0% | 358us | 0.0% | 358us | `_deepMergeObjects` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:129` |
| 0.0% | 357us | 0.0% | 357us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6644` |
| 0.0% | 355us | 7.1% | 61.0ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` |
| 0.0% | 354us | 0.0% | 854us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1328` |
| 0.0% | 354us | 0.0% | 354us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1200` |
| 0.0% | 354us | 0.0% | 354us | `cloneObject` | `[native code]` |
| 0.0% | 353us | 0.1% | 1.0ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:461` |
| 0.0% | 353us | 0.0% | 353us | `hasObservableSideEffectsForRegExpMatch` | `[native code]` |
| 0.0% | 352us | 0.0% | 352us | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1012` |
| 0.0% | 352us | 0.0% | 493us | `accessPath` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5206` |
| 0.0% | 352us | 0.0% | 352us | `assign` | `[native code]` |
| 0.0% | 351us | 0.5% | 4.7ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4199` |
| 0.0% | 351us | 1.3% | 11.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2816` |
| 0.0% | 350us | 0.0% | 350us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5689` |
| 0.0% | 350us | 0.0% | 518us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4205` |
| 0.0% | 349us | 0.0% | 523us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3774` |
| 0.0% | 349us | 0.0% | 349us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 349us | 0.0% | 856us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1325` |
| 0.0% | 349us | 0.0% | 349us | `isExported` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:363` |
| 0.0% | 348us | 0.0% | 348us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:641` |
| 0.0% | 347us | 0.0% | 347us | `link` | `[native code]` |
| 0.0% | 347us | 0.0% | 347us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 346us | 0.0% | 698us | `_applySchemaDefaults` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:169` |
| 0.0% | 345us | 0.0% | 544us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:313` |
| 0.0% | 345us | 0.1% | 866us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6816` |
| 0.0% | 344us | 0.1% | 975us | `describeRule` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:30` |
| 0.0% | 343us | 0.0% | 529us | `isUnderscored` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:105` |
| 0.0% | 343us | 0.0% | 343us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:420` |
| 0.0% | 341us | 0.0% | 341us | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4844` |
| 0.0% | 341us | 0.0% | 341us | `RegExp` | `[native code]` |
| 0.0% | 340us | 0.2% | 1.7ms | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1716` |
| 0.0% | 340us | 0.0% | 340us | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:865` |
| 0.0% | 340us | 0.0% | 340us | `/^(?:Function(?:Declaration\|Expression)\|ArrowFunctionExpression)$/u` | `[native code]` |
| 0.0% | 339us | 0.0% | 339us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6579` |
| 0.0% | 339us | 0.0% | 339us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1903` |
| 0.0% | 339us | 0.0% | 339us | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5802` |
| 0.0% | 339us | 0.0% | 339us | `_getChainExpr` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3899` |
| 0.0% | 337us | 0.0% | 337us | `RuleSkipSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4776` |
| 0.0% | 337us | 0.3% | 2.8ms | `Program` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:275` |
| 0.0% | 337us | 0.4% | 3.9ms | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5593` |
| 0.0% | 336us | 0.0% | 336us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` |
| 0.0% | 336us | 0.0% | 336us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2065` |
| 0.0% | 336us | 0.0% | 336us | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1037` |
| 0.0% | 335us | 0.0% | 475us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6411` |
| 0.0% | 335us | 0.0% | 335us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2471` |
| 0.0% | 335us | 0.0% | 335us | `get left` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1754` |
| 0.0% | 333us | 0.0% | 333us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 332us | 0.0% | 332us | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2879` |
| 0.0% | 332us | 0.1% | 1.5ms | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:92` |
| 0.0% | 331us | 0.0% | 331us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7365` |
| 0.0% | 330us | 0.0% | 330us | `/^(?:DoWhile\|For\|ForIn\|ForOf\|While)Statement$/u` | `[native code]` |
| 0.0% | 330us | 0.0% | 330us | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4868` |
| 0.0% | 330us | 0.0% | 814us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1700` |
| 0.0% | 330us | 0.0% | 330us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3734` |
| 0.0% | 330us | 0.0% | 330us | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` |
| 0.0% | 329us | 0.0% | 329us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5744` |
| 0.0% | 329us | 0.0% | 329us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6832` |
| 0.0% | 329us | 0.0% | 329us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1614` |
| 0.0% | 328us | 0.0% | 525us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4237` |
| 0.0% | 328us | 0.0% | 328us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4033` |
| 0.0% | 328us | 0.0% | 684us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4190` |
| 0.0% | 328us | 0.1% | 1.0ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:305` |
| 0.0% | 327us | 0.0% | 483us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6744` |
| 0.0% | 327us | 0.0% | 327us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6258` |
| 0.0% | 324us | 0.1% | 1.4ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2283` |
| 0.0% | 324us | 0.0% | 324us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5097` |
| 0.0% | 322us | 0.0% | 322us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3999` |
| 0.0% | 321us | 0.1% | 861us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:497` |
| 0.0% | 321us | 0.0% | 321us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2244` |
| 0.0% | 320us | 0.0% | 467us | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2954` |
| 0.0% | 320us | 3.1% | 27.3ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2281` |
| 0.0% | 320us | 0.0% | 658us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:473` |
| 0.0% | 318us | 21.6% | 186.0ms | `_getOrBuildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5453` |
| 0.0% | 318us | 0.1% | 1.3ms | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2845` |
| 0.0% | 317us | 0.2% | 2.0ms | `_parseDisableDirectives` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7404` |
| 0.0% | 317us | 0.4% | 3.6ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1925` |
| 0.0% | 316us | 0.0% | 316us | `describeRule` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:32` |
| 0.0% | 316us | 2.6% | 22.8ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 0.0% | 315us | 0.1% | 1.1ms | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5285` |
| 0.0% | 315us | 0.0% | 315us | `get property` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1946` |
| 0.0% | 314us | 0.0% | 314us | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5029` |
| 0.0% | 313us | 0.0% | 313us | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4840` |
| 0.0% | 313us | 0.4% | 4.1ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 0.0% | 313us | 0.0% | 313us | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3546` |
| 0.0% | 312us | 0.0% | 502us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2102` |
| 0.0% | 312us | 0.1% | 860us | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2907` |
| 0.0% | 312us | 0.0% | 822us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7092` |
| 0.0% | 311us | 0.2% | 2.0ms | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3033` |
| 0.0% | 310us | 0.2% | 2.3ms | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2978` |
| 0.0% | 310us | 0.0% | 310us | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4857` |
| 0.0% | 310us | 0.0% | 476us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5713` |
| 0.0% | 309us | 0.0% | 309us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2171` |
| 0.0% | 308us | 0.0% | 308us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6464` |
| 0.0% | 308us | 0.3% | 2.9ms | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2316` |
| 0.0% | 307us | 0.0% | 307us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:551` |
| 0.0% | 307us | 0.3% | 3.3ms | `_deepMergeArrays` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:136` |
| 0.0% | 305us | 0.0% | 305us | `create` | `[native code]` |
| 0.0% | 301us | 0.0% | 454us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4031` |
| 0.0% | 301us | 0.0% | 301us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 301us | 0.0% | 831us | `_compileAttrCheck` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5198` |
| 0.0% | 296us | 0.0% | 447us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:487` |
| 0.0% | 295us | 0.0% | 639us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:314` |
| 0.0% | 294us | 0.0% | 759us | `_isSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4025` |
| 0.0% | 291us | 0.0% | 291us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2665` |
| 0.0% | 287us | 0.0% | 287us | `_rawTokenText` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:781` |
| 0.0% | 286us | 0.0% | 286us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:179` |
| 0.0% | 284us | 0.0% | 284us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6637` |
| 0.0% | 284us | 0.0% | 284us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6450` |
| 0.0% | 270us | 0.0% | 270us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5891` |
| 0.0% | 204us | 0.0% | 204us | `isInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:231` |
| 0.0% | 204us | 0.0% | 204us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2700` |
| 0.0% | 202us | 0.0% | 202us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5120` |
| 0.0% | 201us | 0.0% | 371us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4192` |
| 0.0% | 201us | 0.0% | 201us | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4331` |
| 0.0% | 200us | 0.0% | 200us | `Ae` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 200us | 0.0% | 200us | `get start` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1106` |
| 0.0% | 199us | 0.0% | 199us | `Program` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js` |
| 0.0% | 199us | 0.0% | 760us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:436` |
| 0.0% | 198us | 0.0% | 198us | `be` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 198us | 0.0% | 198us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 198us | 0.8% | 6.9ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6484` |
| 0.0% | 197us | 0.0% | 710us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2844` |
| 0.0% | 197us | 0.0% | 197us | `invokeHandlersWithNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6152` |
| 0.0% | 197us | 0.0% | 197us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1498` |
| 0.0% | 197us | 0.0% | 197us | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 197us | 0.0% | 197us | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:801` |
| 0.0% | 196us | 0.0% | 196us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7018` |
| 0.0% | 196us | 0.0% | 196us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:956` |
| 0.0% | 196us | 0.0% | 196us | `Ee` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 196us | 0.0% | 354us | `getAssignedMessageData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:305` |
| 0.0% | 196us | 0.0% | 196us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4288` |
| 0.0% | 195us | 0.7% | 6.5ms | `onCodePathStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:406` |
| 0.0% | 195us | 0.0% | 195us | `_cookTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 195us | 0.0% | 195us | `getNameLocationInGlobalDirectiveComment` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2643` |
| 0.0% | 195us | 0.0% | 195us | `isExported` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:364` |
| 0.0% | 195us | 0.0% | 195us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5012` |
| 0.0% | 195us | 0.0% | 337us | `isFunctionNameInitializerException` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:423` |
| 0.0% | 195us | 0.0% | 195us | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2956` |
| 0.0% | 195us | 0.0% | 195us | `groupByDestructuring` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:316` |
| 0.0% | 195us | 0.0% | 195us | `get property` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 194us | 0.0% | 194us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2172` |
| 0.0% | 194us | 0.0% | 194us | `get operator` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1317` |
| 0.0% | 194us | 0.0% | 347us | `runOnce` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:90` |
| 0.0% | 194us | 0.0% | 194us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5785` |
| 0.0% | 193us | 0.0% | 193us | `getIdentifierIfShouldBeConst` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:228` |
| 0.0% | 193us | 0.0% | 193us | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2341` |
| 0.0% | 193us | 0.0% | 342us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2057` |
| 0.0% | 193us | 2.6% | 22.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1997` |
| 0.0% | 193us | 0.0% | 193us | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1048` |
| 0.0% | 193us | 0.0% | 362us | `getDestructuringHost` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:98` |
| 0.0% | 192us | 0.0% | 192us | `getVariableByName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js` |
| 0.0% | 192us | 0.0% | 192us | `isModifyingProp` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:95` |
| 0.0% | 192us | 0.0% | 192us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1962` |
| 0.0% | 192us | 0.0% | 192us | `[Symbol.split]` | `[native code]` |
| 0.0% | 192us | 0.0% | 192us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1474` |
| 0.0% | 192us | 0.0% | 192us | `get left` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 192us | 0.0% | 735us | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:620` |
| 0.0% | 191us | 0.0% | 191us | `resolve` | `[native code]` |
| 0.0% | 191us | 0.0% | 191us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1966` |
| 0.0% | 191us | 0.0% | 191us | `_deepMergeObjects` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 191us | 0.0% | 191us | `_isChainChild` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3873` |
| 0.0% | 191us | 0.0% | 191us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5678` |
| 0.0% | 191us | 1.3% | 11.4ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:690` |
| 0.0% | 191us | 0.0% | 191us | `isStorableFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.0% | 190us | 0.0% | 190us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4036` |
| 0.0% | 190us | 0.0% | 190us | `isImportAttributeKey` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:1426` |
| 0.0% | 190us | 0.0% | 190us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7071` |
| 0.0% | 190us | 0.0% | 190us | `_lineStarts` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 189us | 0.0% | 189us | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2889` |
| 0.0% | 189us | 0.0% | 189us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7341` |
| 0.0% | 189us | 0.0% | 189us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1503` |
| 0.0% | 189us | 0.4% | 4.0ms | `runOnce` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:101` |
| 0.0% | 189us | 0.0% | 189us | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5031` |
| 0.0% | 189us | 0.0% | 189us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6417` |
| 0.0% | 189us | 0.0% | 189us | `get local` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3488` |
| 0.0% | 189us | 0.0% | 189us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.0% | 189us | 0.0% | 713us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4187` |
| 0.0% | 188us | 0.0% | 188us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4242` |
| 0.0% | 188us | 0.0% | 383us | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:513` |
| 0.0% | 188us | 0.1% | 863us | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5102` |
| 0.0% | 188us | 0.0% | 188us | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1040` |
| 0.0% | 188us | 0.0% | 188us | `defineProperty` | `[native code]` |
| 0.0% | 188us | 0.0% | 188us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` |
| 0.0% | 188us | 0.0% | 594us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1625` |
| 0.0% | 188us | 0.0% | 188us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:318` |
| 0.0% | 188us | 0.0% | 188us | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 187us | 0.0% | 187us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1176` |
| 0.0% | 187us | 0.0% | 187us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:155` |
| 0.0% | 187us | 0.0% | 187us | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 187us | 0.0% | 187us | `RuleMetadataIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js` |
| 0.0% | 187us | 0.0% | 187us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4000` |
| 0.0% | 187us | 0.0% | 187us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2494` |
| 0.0% | 187us | 0.0% | 187us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:228` |
| 0.0% | 187us | 0.3% | 3.2ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1337` |
| 0.0% | 187us | 0.0% | 187us | `isOuterVariableInDestructing` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:72` |
| 0.0% | 187us | 0.0% | 526us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:401` |
| 0.0% | 187us | 0.0% | 364us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4200` |
| 0.0% | 186us | 0.0% | 186us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2522` |
| 0.0% | 186us | 0.0% | 186us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:205` |
| 0.0% | 186us | 0.0% | 186us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4133` |
| 0.0% | 186us | 0.0% | 186us | `toUpperCase` | `[native code]` |
| 0.0% | 186us | 0.0% | 186us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:59` |
| 0.0% | 186us | 0.0% | 186us | `get key` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3120` |
| 0.0% | 186us | 0.0% | 186us | `isLogicalAssignmentOperator` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:941` |
| 0.0% | 186us | 0.0% | 186us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:788` |
| 0.0% | 186us | 0.7% | 6.6ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4234` |
| 0.0% | 186us | 0.0% | 550us | `getStaticPropertyName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:320` |
| 0.0% | 186us | 0.0% | 186us | `getModuleExportName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:973` |
| 0.0% | 185us | 0.1% | 1.0ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:433` |
| 0.0% | 185us | 0.2% | 2.3ms | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:180` |
| 0.0% | 185us | 0.0% | 185us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1661` |
| 0.0% | 185us | 0.0% | 185us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4973` |
| 0.0% | 185us | 0.0% | 185us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6467` |
| 0.0% | 185us | 0.0% | 185us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:280` |
| 0.0% | 185us | 0.0% | 506us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:329` |
| 0.0% | 184us | 0.0% | 184us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4045` |
| 0.0% | 184us | 0.0% | 184us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5107` |
| 0.0% | 184us | 0.0% | 184us | `_isSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 184us | 0.0% | 557us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:234` |
| 0.0% | 184us | 0.0% | 701us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6476` |
| 0.0% | 184us | 0.0% | 184us | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:487` |
| 0.0% | 184us | 0.1% | 880us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:296` |
| 0.0% | 184us | 0.0% | 184us | `getTokenAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1289` |
| 0.0% | 184us | 0.0% | 184us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3073` |
| 0.0% | 184us | 0.0% | 184us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 184us | 0.0% | 184us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4201` |
| 0.0% | 183us | 0.1% | 1.1ms | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:651` |
| 0.0% | 183us | 0.0% | 183us | `getFunctionNameWithKind` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2184` |
| 0.0% | 183us | 0.0% | 183us | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:818` |
| 0.0% | 183us | 0.0% | 183us | `get operator` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1307` |
| 0.0% | 182us | 0.0% | 359us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:418` |
| 0.0% | 182us | 0.0% | 354us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` |
| 0.0% | 182us | 0.0% | 182us | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:621` |
| 0.0% | 182us | 0.0% | 182us | `_applySchemaDefaults` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:171` |
| 0.0% | 182us | 0.0% | 324us | `isNullLiteral` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:204` |
| 0.0% | 182us | 0.0% | 319us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4188` |
| 0.0% | 182us | 0.0% | 182us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6097` |
| 0.0% | 182us | 0.1% | 1.7ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1673` |
| 0.0% | 182us | 0.0% | 182us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn-jsx/xhtml.js:1` |
| 0.0% | 182us | 0.1% | 1.3ms | `async loadAndEvaluateModule` | `[native code]` |
| 0.0% | 182us | 0.0% | 182us | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4654` |
| 0.0% | 181us | 0.0% | 332us | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:636` |
| 0.0% | 181us | 0.0% | 181us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3759` |
| 0.0% | 181us | 0.0% | 181us | `isInClassStaticInitializerRange` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js` |
| 0.0% | 181us | 0.0% | 181us | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3394` |
| 0.0% | 181us | 0.0% | 181us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3074` |
| 0.0% | 181us | 0.0% | 181us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:405` |
| 0.0% | 181us | 0.0% | 181us | `_getChainExpr` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3903` |
| 0.0% | 181us | 0.0% | 181us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:653` |
| 0.0% | 181us | 0.0% | 181us | `isSpecificMemberAccess` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js` |
| 0.0% | 181us | 0.0% | 181us | `isAssignmentTarget` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:140` |
| 0.0% | 180us | 0.0% | 180us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3884` |
| 0.0% | 180us | 0.0% | 180us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js` |
| 0.0% | 180us | 0.0% | 180us | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5601` |
| 0.0% | 180us | 0.0% | 180us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5244` |
| 0.0% | 180us | 0.0% | 180us | `defToVariableType` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:204` |
| 0.0% | 180us | 0.0% | 180us | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4665` |
| 0.0% | 180us | 0.0% | 180us | `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:334` |
| 0.0% | 180us | 0.0% | 180us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6946` |
| 0.0% | 180us | 0.2% | 1.7ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3902` |
| 0.0% | 179us | 0.0% | 179us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4004` |
| 0.0% | 179us | 0.0% | 179us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2377` |
| 0.0% | 179us | 0.1% | 988us | `_isSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4030` |
| 0.0% | 179us | 0.0% | 179us | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1783` |
| 0.0% | 179us | 0.0% | 179us | `get callee` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 179us | 2.0% | 17.9ms | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2356` |
| 0.0% | 179us | 0.0% | 179us | `getFunctionNameWithKind` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2110` |
| 0.0% | 178us | 0.0% | 178us | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3610` |
| 0.0% | 178us | 0.0% | 178us | `slotTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5793` |
| 0.0% | 178us | 0.0% | 178us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5051` |
| 0.0% | 178us | 0.0% | 178us | `onCodePathStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js` |
| 0.0% | 178us | 0.0% | 178us | `isEvaluatedDuringInitialization` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js` |
| 0.0% | 177us | 0.0% | 336us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4220` |
| 0.0% | 177us | 0.0% | 473us | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1778` |
| 0.0% | 177us | 0.0% | 177us | `getIdentifierIfShouldBeConst` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:187` |
| 0.0% | 177us | 0.0% | 177us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5643` |
| 0.0% | 177us | 0.0% | 177us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 177us | 0.0% | 177us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:479` |
| 0.0% | 177us | 0.0% | 660us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 0.0% | 177us | 0.0% | 177us | `isGenericOfAStaticMethodShadow` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js` |
| 0.0% | 177us | 0.0% | 177us | `ensureBufferBytes` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js` |
| 0.0% | 177us | 0.0% | 177us | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4668` |
| 0.0% | 177us | 0.0% | 177us | `ensureBufferBytes` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:61` |
| 0.0% | 176us | 0.0% | 176us | `_tokenIndexAtOrBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 176us | 0.0% | 176us | `equalsToOriginalName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:179` |
| 0.0% | 176us | 0.0% | 176us | `getNameLocationInGlobalDirectiveComment` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2634` |
| 0.0% | 176us | 0.3% | 3.2ms | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:624` |
| 0.0% | 175us | 0.0% | 175us | `isAssignmentTarget` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:143` |
| 0.0% | 175us | 0.0% | 320us | `requestSatisfy` | `[native code]` |
| 0.0% | 175us | 0.0% | 175us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:126` |
| 0.0% | 175us | 0.0% | 324us | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5597` |
| 0.0% | 175us | 0.0% | 175us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6945` |
| 0.0% | 175us | 0.2% | 2.1ms | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5331` |
| 0.0% | 174us | 0.0% | 174us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1669` |
| 0.0% | 174us | 0.0% | 174us | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:513` |
| 0.0% | 174us | 0.0% | 174us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 174us | 0.0% | 174us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7136` |
| 0.0% | 174us | 0.0% | 174us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6200` |
| 0.0% | 174us | 0.0% | 174us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3783` |
| 0.0% | 174us | 0.0% | 174us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5087` |
| 0.0% | 174us | 0.0% | 174us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2624` |
| 0.0% | 174us | 0.0% | 174us | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3620` |
| 0.0% | 174us | 0.0% | 174us | `replaceTextRange` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/fix-tracker.js:110` |
| 0.0% | 174us | 0.0% | 174us | `getStaticPropertyName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:307` |
| 0.0% | 173us | 0.0% | 173us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1620` |
| 0.0% | 173us | 0.0% | 345us | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2910` |
| 0.0% | 173us | 0.0% | 173us | `_getTypeProto` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3967` |
| 0.0% | 173us | 0.0% | 173us | `get params` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2541` |
| 0.0% | 173us | 0.0% | 173us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.0% | 173us | 0.0% | 173us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2216` |
| 0.0% | 173us | 5.9% | 51.4ms | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7380` |
| 0.0% | 173us | 0.0% | 173us | `_isSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4026` |
| 0.0% | 173us | 0.0% | 360us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1677` |
| 0.0% | 172us | 0.0% | 172us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1628` |
| 0.0% | 172us | 0.0% | 172us | `getFirstToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 171us | 0.0% | 171us | `iterateDeclarations` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js` |
| 0.0% | 171us | 0.0% | 664us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:433` |
| 0.0% | 171us | 0.0% | 343us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5742` |
| 0.0% | 171us | 0.0% | 551us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:430` |
| 0.0% | 170us | 0.0% | 170us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5086` |
| 0.0% | 170us | 0.0% | 170us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1295` |
| 0.0% | 170us | 0.0% | 701us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:460` |
| 0.0% | 170us | 0.4% | 3.7ms | `checkLastSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:384` |
| 0.0% | 170us | 0.0% | 170us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2378` |
| 0.0% | 169us | 0.0% | 169us | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 169us | 0.0% | 169us | `(anonymous)` | `internal:primordials:35` |
| 0.0% | 169us | 0.0% | 169us | `get options` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2173` |
| 0.0% | 169us | 0.0% | 356us | `ruleMetadataIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:12` |
| 0.0% | 169us | 0.0% | 169us | `isWrite` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:217` |
| 0.0% | 169us | 0.0% | 372us | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2909` |
| 0.0% | 169us | 0.0% | 169us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4056` |
| 0.0% | 169us | 0.0% | 169us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3756` |
| 0.0% | 169us | 0.0% | 169us | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 169us | 0.1% | 992us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:302` |
| 0.0% | 169us | 0.0% | 320us | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:696` |
| 0.0% | 169us | 0.0% | 169us | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2278` |
| 0.0% | 168us | 0.0% | 168us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3095` |
| 0.0% | 168us | 0.0% | 168us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:434` |
| 0.0% | 168us | 0.0% | 168us | `get regex` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1569` |
| 0.0% | 168us | 0.0% | 168us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:84` |
| 0.0% | 168us | 0.0% | 168us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:394` |
| 0.0% | 167us | 0.0% | 167us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3790` |
| 0.0% | 167us | 0.0% | 167us | `isTypeOf` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js` |
| 0.0% | 167us | 0.0% | 167us | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:808` |
| 0.0% | 167us | 0.0% | 167us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 166us | 0.0% | 166us | `getIdentifierIfShouldBeConst` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:233` |
| 0.0% | 166us | 0.0% | 166us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6559` |
| 0.0% | 166us | 0.0% | 166us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2169` |
| 0.0% | 166us | 0.0% | 166us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6446` |
| 0.0% | 165us | 0.0% | 165us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1627` |
| 0.0% | 165us | 0.0% | 165us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:476` |
| 0.0% | 165us | 0.0% | 165us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6480` |
| 0.0% | 165us | 0.0% | 165us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:331` |
| 0.0% | 164us | 0.0% | 164us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4220` |
| 0.0% | 164us | 0.2% | 1.9ms | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1923` |
| 0.0% | 164us | 0.0% | 164us | `join` | `[native code]` |
| 0.0% | 164us | 0.0% | 164us | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:619` |
| 0.0% | 164us | 0.0% | 164us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:349` |
| 0.0% | 164us | 0.0% | 164us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2818` |
| 0.0% | 164us | 0.0% | 164us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:782` |
| 0.0% | 164us | 10.2% | 87.5ms | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1816` |
| 0.0% | 164us | 0.0% | 496us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2439` |
| 0.0% | 164us | 0.1% | 867us | `_deepMergeArrays` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:137` |
| 0.0% | 164us | 0.0% | 164us | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2270` |
| 0.0% | 163us | 0.0% | 163us | `(program)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:1` |
| 0.0% | 163us | 0.0% | 163us | `get kind` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2626` |
| 0.0% | 163us | 0.0% | 163us | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2864` |
| 0.0% | 163us | 0.0% | 163us | `Program` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:152` |
| 0.0% | 163us | 0.0% | 163us | `isReadRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:431` |
| 0.0% | 163us | 0.0% | 163us | `_nodeStartPos` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:888` |
| 0.0% | 163us | 0.0% | 163us | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1829` |
| 0.0% | 163us | 0.0% | 163us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:398` |
| 0.0% | 163us | 0.6% | 5.1ms | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5993` |
| 0.0% | 163us | 0.0% | 330us | `getNameRange` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:456` |
| 0.0% | 163us | 0.2% | 1.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6749` |
| 0.0% | 162us | 0.0% | 162us | `fullMethodName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:58` |
| 0.0% | 162us | 0.0% | 162us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:682` |
| 0.0% | 162us | 0.0% | 348us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:656` |
| 0.0% | 162us | 0.0% | 162us | `hasRestSpreadSibling` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:410` |
| 0.0% | 162us | 0.0% | 162us | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:665` |
| 0.0% | 162us | 0.0% | 451us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2636` |
| 0.0% | 162us | 0.0% | 298us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:430` |
| 0.0% | 162us | 0.0% | 162us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2646` |
| 0.0% | 162us | 0.0% | 162us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:396` |
| 0.0% | 162us | 0.2% | 2.0ms | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2498` |
| 0.0% | 162us | 0.0% | 323us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2820` |
| 0.0% | 162us | 0.0% | 162us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1735` |
| 0.0% | 162us | 0.0% | 162us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:51` |
| 0.0% | 161us | 0.0% | 161us | `canBecomeVariableDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:59` |
| 0.0% | 161us | 0.0% | 161us | `isArrayFromMethod` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:533` |
| 0.0% | 161us | 0.4% | 3.6ms | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5263` |
| 0.0% | 161us | 0.0% | 161us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4235` |
| 0.0% | 161us | 0.0% | 161us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2273` |
| 0.0% | 160us | 0.0% | 160us | `isFunctionNameInitializerException` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:426` |
| 0.0% | 160us | 0.0% | 295us | `getLocFromIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3359` |
| 0.0% | 160us | 0.0% | 501us | `getDestructuringHost` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:103` |
| 0.0% | 160us | 0.0% | 160us | `getUsedIgnoredMessageData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.0% | 160us | 0.0% | 160us | `get params` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2543` |
| 0.0% | 160us | 0.0% | 485us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:404` |
| 0.0% | 160us | 0.0% | 160us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1745` |
| 0.0% | 159us | 0.0% | 159us | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 159us | 0.0% | 159us | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 159us | 0.0% | 694us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:408` |
| 0.0% | 159us | 0.0% | 159us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4215` |
| 0.0% | 159us | 0.0% | 159us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 159us | 0.0% | 159us | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 159us | 0.0% | 159us | `safeHandler` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3820` |
| 0.0% | 159us | 0.0% | 159us | `ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1847` |
| 0.0% | 158us | 0.0% | 686us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1274` |
| 0.0% | 158us | 0.0% | 158us | `get flags` | `[native code]` |
| 0.0% | 158us | 0.0% | 517us | `codepath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4256` |
| 0.0% | 158us | 0.0% | 158us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2447` |
| 0.0% | 158us | 0.0% | 158us | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4330` |
| 0.0% | 158us | 0.0% | 158us | `normalizePath` | `bun:ffi` |
| 0.0% | 158us | 0.0% | 342us | `getFunctionNameWithKind` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2181` |
| 0.0% | 157us | 0.0% | 157us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js` |
| 0.0% | 157us | 0.0% | 157us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6768` |
| 0.0% | 157us | 0.0% | 157us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 157us | 0.0% | 157us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:142` |
| 0.0% | 157us | 0.0% | 157us | `getArrayMethodName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:72` |
| 0.0% | 157us | 0.0% | 157us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2175` |
| 0.0% | 157us | 0.1% | 1.6ms | `getFunctionHeadLoc` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2308` |
| 0.0% | 156us | 0.0% | 524us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4255` |
| 0.0% | 156us | 0.0% | 156us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:384` |
| 0.0% | 156us | 0.0% | 156us | `getFunctionNameWithKind` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js` |
| 0.0% | 156us | 0.1% | 1.1ms | `BinaryExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:184` |
| 0.0% | 156us | 0.0% | 156us | `extraClassData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 156us | 0.0% | 156us | `_ensureTagCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 156us | 0.0% | 156us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6588` |
| 0.0% | 156us | 0.1% | 1.1ms | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:401` |
| 0.0% | 156us | 0.0% | 156us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 156us | 0.0% | 156us | `e` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 155us | 0.0% | 155us | `getTokenAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 155us | 0.0% | 155us | `checkLastSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:320` |
| 0.0% | 155us | 0.0% | 155us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2321` |
| 0.0% | 155us | 0.0% | 155us | `getFirstToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:916` |
| 0.0% | 155us | 0.0% | 491us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4240` |
| 0.0% | 155us | 0.0% | 155us | `getVariableDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:250` |
| 0.0% | 155us | 0.0% | 155us | `get callee` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1871` |
| 0.0% | 155us | 0.0% | 155us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1693` |
| 0.0% | 155us | 0.0% | 155us | `_applySchemaDefaults` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:166` |
| 0.0% | 154us | 0.0% | 624us | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5947` |
| 0.0% | 154us | 0.0% | 346us | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4630` |
| 0.0% | 154us | 0.0% | 154us | `_deepMergeArrays` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:134` |
| 0.0% | 154us | 0.0% | 154us | `isTypeValueShadow` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:157` |
| 0.0% | 154us | 0.0% | 307us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4212` |
| 0.0% | 154us | 0.0% | 154us | `startsWith` | `[native code]` |
| 0.0% | 154us | 0.0% | 154us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7015` |
| 0.0% | 153us | 0.0% | 153us | `_getFfiSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:105` |
| 0.0% | 153us | 0.0% | 153us | `_scopeForNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:847` |
| 0.0% | 153us | 0.0% | 153us | `/^[A-Z][A-Za-z]*$/` | `[native code]` |
| 0.0% | 153us | 0.0% | 153us | `checkGroup` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js` |
| 0.0% | 153us | 0.0% | 317us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6449` |
| 0.0% | 153us | 0.0% | 153us | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6022` |
| 0.0% | 153us | 0.0% | 153us | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:716` |
| 0.0% | 152us | 0.0% | 152us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6491` |
| 0.0% | 152us | 0.0% | 152us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6415` |
| 0.0% | 152us | 0.0% | 342us | `reportReferenceId` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:242` |
| 0.0% | 152us | 0.0% | 152us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6814` |
| 0.0% | 151us | 0.0% | 151us | `isThisParam` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:147` |
| 0.0% | 151us | 0.0% | 151us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2514` |
| 0.0% | 151us | 0.0% | 314us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` |
| 0.0% | 151us | 0.0% | 151us | `toLength` | `[native code]` |
| 0.0% | 151us | 0.0% | 151us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2721` |
| 0.0% | 151us | 0.0% | 151us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6461` |
| 0.0% | 151us | 0.0% | 151us | `TokenType` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:115` |
| 0.0% | 150us | 0.0% | 150us | `unwrapExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:372` |
| 0.0% | 150us | 0.0% | 150us | `getVariableDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:264` |
| 0.0% | 150us | 0.0% | 150us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6469` |
| 0.0% | 150us | 0.1% | 1.2ms | `isSpecificMemberAccess` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:384` |
| 0.0% | 150us | 0.0% | 150us | `shouldCheck` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:399` |
| 0.0% | 150us | 0.0% | 345us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1533` |
| 0.0% | 150us | 0.0% | 150us | `_getTypeProto` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 150us | 0.0% | 150us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:123` |
| 0.0% | 150us | 0.8% | 7.0ms | `VariableDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:549` |
| 0.0% | 150us | 0.0% | 150us | `get end` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1109` |
| 0.0% | 149us | 0.0% | 149us | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:751` |
| 0.0% | 149us | 0.0% | 149us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1662` |
| 0.0% | 149us | 0.0% | 149us | `/:([a-z-]+)\([^)]*\)/g` | `[native code]` |
| 0.0% | 149us | 0.0% | 149us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3101` |
| 0.0% | 149us | 0.0% | 149us | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:805` |
| 0.0% | 149us | 0.0% | 149us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3996` |
| 0.0% | 149us | 0.0% | 149us | `accessPath` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5204` |
| 0.0% | 149us | 0.0% | 149us | `setName` | `node:fs` |
| 0.0% | 149us | 0.0% | 857us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4207` |
| 0.0% | 149us | 0.0% | 149us | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5956` |
| 0.0% | 149us | 0.0% | 149us | `isImportAttributeKey` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:1423` |
| 0.0% | 148us | 0.0% | 430us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:308` |
| 0.0% | 148us | 0.0% | 285us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7065` |
| 0.0% | 148us | 0.0% | 148us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1598` |
| 0.0% | 148us | 0.0% | 148us | `/^:[a-z-]+\s*/` | `[native code]` |
| 0.0% | 148us | 0.0% | 148us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4229` |
| 0.0% | 148us | 0.0% | 148us | `get start` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1094` |
| 0.0% | 148us | 0.0% | 148us | `get nodeTags` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 148us | 0.0% | 148us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 148us | 0.6% | 5.4ms | `findVariablesInScope` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:94` |
| 0.0% | 148us | 0.0% | 148us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1727` |
| 0.0% | 147us | 0.0% | 617us | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:494` |
| 0.0% | 147us | 0.0% | 147us | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 147us | 0.4% | 3.8ms | `getArrayMethodName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:116` |
| 0.0% | 147us | 0.0% | 338us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4062` |
| 0.0% | 147us | 0.0% | 493us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4225` |
| 0.0% | 147us | 0.0% | 147us | `get property` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1941` |
| 0.0% | 147us | 0.0% | 147us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1645` |
| 0.0% | 146us | 0.0% | 146us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1182` |
| 0.0% | 146us | 0.0% | 146us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2578` |
| 0.0% | 146us | 0.0% | 146us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1238` |
| 0.0% | 146us | 0.0% | 146us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` |
| 0.0% | 146us | 0.0% | 146us | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2331` |
| 0.0% | 146us | 0.0% | 146us | `_computeMinTok` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:529` |
| 0.0% | 145us | 0.0% | 145us | `_getOrBuildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5441` |
| 0.0% | 145us | 0.0% | 145us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6459` |
| 0.0% | 145us | 0.0% | 145us | `ExportAllDeclaration > Identifier.exported,ExportSpecifier > Identifier.exported` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:398` |
| 0.0% | 145us | 0.0% | 502us | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2269` |
| 0.0% | 145us | 99.9% | 857.7ms | `async (anonymous)` | `[native code]` |
| 0.0% | 145us | 0.0% | 602us | `getStaticPropertyName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:327` |
| 0.0% | 145us | 0.0% | 145us | `getAssignedMessageData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:310` |
| 0.0% | 144us | 0.0% | 144us | `_dispatchSeg` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6108` |
| 0.0% | 144us | 0.0% | 144us | `fullMethodName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:56` |
| 0.0% | 144us | 0.0% | 144us | `_ensureTagCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5522` |
| 0.0% | 144us | 0.0% | 144us | `ImportDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:372` |
| 0.0% | 144us | 0.0% | 144us | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js` |
| 0.0% | 143us | 0.0% | 143us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 143us | 0.0% | 143us | `getTagNames` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:190` |
| 0.0% | 143us | 0.0% | 143us | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6359` |
| 0.0% | 143us | 0.0% | 143us | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1798` |
| 0.0% | 143us | 0.0% | 143us | `checkGroup` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:475` |
| 0.0% | 143us | 0.0% | 439us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:419` |
| 0.0% | 143us | 0.0% | 143us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 142us | 0.0% | 142us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4251` |
| 0.0% | 142us | 0.0% | 142us | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 142us | 0.0% | 332us | `get right` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1788` |
| 0.0% | 142us | 0.4% | 3.9ms | `groupByDestructuring` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:290` |
| 0.0% | 142us | 0.0% | 142us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 142us | 0.0% | 329us | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2088` |
| 0.0% | 142us | 0.0% | 731us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2571` |
| 0.0% | 142us | 0.0% | 142us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5249` |
| 0.0% | 142us | 0.0% | 142us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` |
| 0.0% | 142us | 0.0% | 142us | `isImportAttributeKey` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:1422` |
| 0.0% | 141us | 0.0% | 141us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6625` |
| 0.0% | 141us | 0.0% | 141us | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2910` |
| 0.0% | 141us | 0.0% | 141us | `get computed` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 141us | 0.0% | 141us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6752` |
| 0.0% | 141us | 0.0% | 282us | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3574` |
| 0.0% | 141us | 0.0% | 141us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:76` |
| 0.0% | 141us | 0.0% | 141us | `_loadFromDisk` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js` |
| 0.0% | 141us | 0.0% | 288us | `isModifyingProp` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:134` |
| 0.0% | 141us | 0.0% | 141us | `getDestructuringHost` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:107` |
| 0.0% | 141us | 0.0% | 141us | `_isStatementTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 140us | 0.0% | 140us | `getTagNames` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js` |
| 0.0% | 140us | 0.1% | 975us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:402` |
| 0.0% | 140us | 0.0% | 325us | `referenceContainsTypeQuery` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:227` |
| 0.0% | 139us | 0.0% | 139us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2275` |
| 0.0% | 139us | 0.0% | 139us | `isExternalDeclarationMerging` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:577` |
| 0.0% | 139us | 0.0% | 139us | `node:child_process` | `node:child_process:10` |
| 0.0% | 139us | 0.0% | 139us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1887` |
| 0.0% | 138us | 0.0% | 138us | `isTypeValueShadow` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js` |
| 0.0% | 138us | 0.0% | 138us | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 138us | 0.0% | 318us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:399` |
| 0.0% | 138us | 0.1% | 1.0ms | `(anonymous)` | `[native code]` |
| 0.0% | 137us | 0.0% | 319us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` |
| 0.0% | 137us | 0.0% | 300us | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:480` |
| 0.0% | 137us | 0.0% | 137us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:222` |
| 0.0% | 137us | 0.0% | 137us | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4791` |
| 0.0% | 136us | 0.0% | 136us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1969` |
| 0.0% | 136us | 0.0% | 136us | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:815` |
| 0.0% | 136us | 0.0% | 136us | `isInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js` |
| 0.0% | 135us | 0.0% | 135us | `getIdentifierIfShouldBeConst` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:229` |
| 0.0% | 135us | 0.0% | 499us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.0% | 135us | 0.0% | 524us | `findVariablesInScope` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:96` |
| 0.0% | 134us | 0.0% | 134us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7083` |
| 0.0% | 134us | 0.0% | 134us | `segment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4251` |
| 0.0% | 134us | 0.0% | 134us | `ensureRefsThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 134us | 0.2% | 2.0ms | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:868` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 99.9% | 857.7ms | 0.0% | 145us | `async (anonymous)` | `[native code]` |
| 99.8% | 856.4ms | 0.0% | 725us | `parseModule` | `[native code]` |
| 81.7% | 701.4ms | 0.0% | 736us | `runOnce` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:92` |
| 74.1% | 635.8ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7382` |
| 52.1% | 447.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:113` |
| 44.8% | 384.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:108` |
| 26.2% | 224.8ms | 0.0% | 675us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4554` |
| 21.7% | 186.5ms | 0.0% | 373us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6524` |
| 21.6% | 186.0ms | 0.0% | 318us | `_getOrBuildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5453` |
| 19.3% | 166.1ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7097` |
| 16.8% | 144.6ms | 0.0% | 526us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1888` |
| 15.9% | 137.2ms | 0.0% | 486us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1501` |
| 14.4% | 124.0ms | 0.0% | 0us | `runOnce` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:87` |
| 14.2% | 121.9ms | 0.0% | 380us | `ensureRefsThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1824` |
| 13.3% | 114.8ms | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2369` |
| 10.2% | 87.5ms | 0.0% | 164us | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1816` |
| 8.6% | 74.1ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1886` |
| 8.3% | 71.2ms | 0.0% | 523us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2267` |
| 7.2% | 61.8ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6900` |
| 7.1% | 61.0ms | 0.0% | 355us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` |
| 6.5% | 55.8ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` |
| 5.9% | 51.4ms | 0.0% | 173us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7380` |
| 5.8% | 50.2ms | 5.8% | 50.2ms | `parse` | `[native code]` |
| 5.5% | 47.9ms | 2.2% | 19.5ms | `anonymous` | `[native code]` |
| 5.5% | 47.5ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:224` |
| 5.2% | 45.2ms | 0.0% | 0us | `bound require` | `[native code]` |
| 4.8% | 41.2ms | 0.1% | 1.0ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` |
| 4.7% | 41.0ms | 0.0% | 0us | `require` | `[native code]` |
| 4.0% | 34.7ms | 0.0% | 510us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5782` |
| 3.6% | 30.9ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6716` |
| 3.5% | 30.7ms | 0.0% | 0us | `safeHandler` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3822` |
| 3.5% | 30.7ms | 0.0% | 0us | `Program` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:449` |
| 3.3% | 28.5ms | 0.0% | 640us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5771` |
| 3.1% | 27.3ms | 0.0% | 320us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2281` |
| 2.9% | 25.2ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:683` |
| 2.9% | 24.8ms | 2.7% | 23.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1998` |
| 2.7% | 23.4ms | 1.0% | 8.5ms | `some` | `[native code]` |
| 2.6% | 22.8ms | 0.0% | 193us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1997` |
| 2.6% | 22.8ms | 0.0% | 316us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` |
| 2.5% | 21.7ms | 2.5% | 21.7ms | `Uint32Array` | `[native code]` |
| 2.4% | 21.1ms | 0.0% | 0us | `Program` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:268` |
| 2.4% | 21.0ms | 2.3% | 19.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6826` |
| 2.3% | 20.3ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1889` |
| 2.3% | 20.1ms | 0.0% | 0us | `ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1848` |
| 2.3% | 19.9ms | 2.3% | 19.9ms | `_mkGlobalVar` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:587` |
| 2.2% | 19.7ms | 0.0% | 640us | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2337` |
| 2.2% | 19.4ms | 0.0% | 0us | `ensureRefsThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1823` |
| 2.1% | 18.3ms | 2.1% | 18.3ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5745` |
| 2.1% | 18.2ms | 2.1% | 18.2ms | `DataView` | `[native code]` |
| 2.0% | 17.9ms | 0.0% | 179us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2356` |
| 1.9% | 17.0ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:232` |
| 1.9% | 16.9ms | 0.0% | 707us | `forEach` | `[native code]` |
| 1.9% | 16.3ms | 1.7% | 14.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6759` |
| 1.9% | 16.3ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6291` |
| 1.8% | 15.8ms | 1.7% | 14.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6602` |
| 1.8% | 15.6ms | 0.0% | 0us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5776` |
| 1.7% | 15.4ms | 1.7% | 15.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6685` |
| 1.7% | 15.2ms | 0.0% | 793us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2204` |
| 1.7% | 15.1ms | 0.0% | 386us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1885` |
| 1.7% | 14.9ms | 0.0% | 682us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:441` |
| 1.5% | 13.6ms | 1.5% | 13.6ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5761` |
| 1.5% | 13.0ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1961` |
| 1.3% | 11.8ms | 0.0% | 0us | `Program` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:147` |
| 1.3% | 11.4ms | 0.0% | 191us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:690` |
| 1.3% | 11.3ms | 0.0% | 351us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2816` |
| 1.3% | 11.3ms | 1.1% | 9.7ms | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5804` |
| 1.2% | 10.7ms | 0.0% | 483us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7373` |
| 1.2% | 10.6ms | 0.0% | 0us | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5571` |
| 1.1% | 10.2ms | 1.1% | 10.2ms | `Set` | `[native code]` |
| 1.1% | 10.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:46` |
| 1.1% | 10.1ms | 0.9% | 8.5ms | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5803` |
| 1.1% | 10.0ms | 1.0% | 9.2ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5690` |
| 1.1% | 9.4ms | 1.0% | 8.6ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5687` |
| 1.1% | 9.4ms | 0.0% | 675us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1855` |
| 1.0% | 9.3ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6894` |
| 1.0% | 9.3ms | 0.0% | 669us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1679` |
| 1.0% | 9.2ms | 0.0% | 481us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4226` |
| 1.0% | 9.1ms | 0.1% | 997us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1884` |
| 1.0% | 8.9ms | 1.0% | 8.9ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5754` |
| 1.0% | 8.7ms | 1.0% | 8.7ms | `Uint8Array` | `[native code]` |
| 0.9% | 8.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` |
| 0.9% | 8.2ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6898` |
| 0.9% | 8.1ms | 0.9% | 8.1ms | `defineProperties` | `[native code]` |
| 0.9% | 7.9ms | 0.0% | 0us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3065` |
| 0.9% | 7.9ms | 0.0% | 0us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5651` |
| 0.9% | 7.9ms | 0.3% | 2.6ms | `map` | `[native code]` |
| 0.9% | 7.7ms | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` |
| 0.8% | 7.6ms | 0.0% | 0us | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6084` |
| 0.8% | 7.4ms | 0.8% | 7.4ms | `indexOf` | `[native code]` |
| 0.8% | 7.4ms | 0.0% | 0us | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` |
| 0.8% | 7.3ms | 0.8% | 7.3ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4176` |
| 0.8% | 7.0ms | 0.0% | 150us | `VariableDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:549` |
| 0.8% | 6.9ms | 0.0% | 0us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5260` |
| 0.8% | 6.9ms | 0.0% | 198us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6484` |
| 0.7% | 6.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:12` |
| 0.7% | 6.6ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:542` |
| 0.7% | 6.6ms | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` |
| 0.7% | 6.6ms | 0.0% | 186us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4234` |
| 0.7% | 6.6ms | 0.0% | 0us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2524` |
| 0.7% | 6.5ms | 0.0% | 195us | `onCodePathStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:406` |
| 0.7% | 6.5ms | 0.1% | 1.1ms | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3804` |
| 0.7% | 6.5ms | 0.7% | 6.5ms | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5800` |
| 0.7% | 6.4ms | 0.0% | 0us | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` |
| 0.7% | 6.3ms | 0.7% | 6.3ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4837` |
| 0.7% | 6.3ms | 0.1% | 1.5ms | `findVariablesInScope` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:95` |
| 0.7% | 6.0ms | 0.1% | 1.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1189` |
| 0.6% | 5.9ms | 0.1% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6735` |
| 0.6% | 5.8ms | 0.5% | 4.5ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1995` |
| 0.6% | 5.7ms | 0.0% | 0us | `checkForFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:238` |
| 0.6% | 5.7ms | 0.0% | 505us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1952` |
| 0.6% | 5.7ms | 0.0% | 484us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2553` |
| 0.6% | 5.6ms | 0.6% | 5.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6732` |
| 0.6% | 5.5ms | 0.6% | 5.5ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3890` |
| 0.6% | 5.5ms | 0.3% | 3.1ms | `next` | `[native code]` |
| 0.6% | 5.4ms | 0.0% | 148us | `findVariablesInScope` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:94` |
| 0.6% | 5.4ms | 0.6% | 5.4ms | `get` | `[native code]` |
| 0.6% | 5.4ms | 0.6% | 5.2ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5697` |
| 0.6% | 5.2ms | 0.6% | 5.2ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5714` |
| 0.6% | 5.2ms | 0.6% | 5.2ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4839` |
| 0.6% | 5.2ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2813` |
| 0.6% | 5.2ms | 0.2% | 2.0ms | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5810` |
| 0.6% | 5.1ms | 0.0% | 163us | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5993` |
| 0.5% | 5.0ms | 0.4% | 4.0ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4842` |
| 0.5% | 4.7ms | 0.5% | 4.7ms | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5557` |
| 0.5% | 4.7ms | 0.5% | 4.7ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:505` |
| 0.5% | 4.7ms | 0.0% | 351us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4199` |
| 0.5% | 4.5ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4200` |
| 0.5% | 4.5ms | 0.2% | 2.0ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` |
| 0.5% | 4.4ms | 0.2% | 1.8ms | `generatorResume` | `[native code]` |
| 0.4% | 4.2ms | 0.0% | 0us | `Program` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:145` |
| 0.4% | 4.2ms | 0.0% | 536us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:395` |
| 0.4% | 4.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.4% | 4.1ms | 0.0% | 313us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` |
| 0.4% | 4.1ms | 0.4% | 4.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6733` |
| 0.4% | 4.1ms | 0.4% | 4.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6818` |
| 0.4% | 4.0ms | 0.1% | 974us | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2874` |
| 0.4% | 4.0ms | 0.4% | 4.0ms | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:121` |
| 0.4% | 4.0ms | 0.0% | 189us | `runOnce` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:101` |
| 0.4% | 4.0ms | 0.0% | 0us | `checkReferencesInScope` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:426` |
| 0.4% | 4.0ms | 0.4% | 4.0ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5647` |
| 0.4% | 4.0ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4239` |
| 0.4% | 3.9ms | 0.4% | 3.9ms | `stringSplitFast` | `[native code]` |
| 0.4% | 3.9ms | 0.0% | 337us | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5593` |
| 0.4% | 3.9ms | 0.0% | 142us | `groupByDestructuring` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:290` |
| 0.4% | 3.8ms | 0.4% | 3.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6731` |
| 0.4% | 3.8ms | 0.1% | 985us | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:152` |
| 0.4% | 3.8ms | 0.0% | 0us | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:179` |
| 0.4% | 3.8ms | 0.0% | 0us | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2887` |
| 0.4% | 3.8ms | 0.4% | 3.8ms | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1613` |
| 0.4% | 3.8ms | 0.0% | 147us | `getArrayMethodName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:116` |
| 0.4% | 3.7ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4249` |
| 0.4% | 3.7ms | 0.0% | 170us | `checkLastSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:384` |
| 0.4% | 3.6ms | 0.4% | 3.6ms | `get _tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1072` |
| 0.4% | 3.6ms | 0.0% | 161us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5263` |
| 0.4% | 3.6ms | 0.4% | 3.6ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4641` |
| 0.4% | 3.6ms | 0.0% | 0us | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:642` |
| 0.4% | 3.6ms | 0.3% | 2.8ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4838` |
| 0.4% | 3.6ms | 0.0% | 317us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1925` |
| 0.4% | 3.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:21` |
| 0.4% | 3.5ms | 0.1% | 1.6ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1222` |
| 0.4% | 3.5ms | 0.3% | 3.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3994` |
| 0.4% | 3.5ms | 0.0% | 504us | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5161` |
| 0.4% | 3.4ms | 0.3% | 3.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6610` |
| 0.3% | 3.4ms | 0.0% | 0us | `getVariableByName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:1599` |
| 0.3% | 3.4ms | 0.3% | 3.4ms | `has` | `[native code]` |
| 0.3% | 3.4ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:345` |
| 0.3% | 3.3ms | 0.1% | 1.0ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4232` |
| 0.3% | 3.3ms | 0.0% | 307us | `_deepMergeArrays` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:136` |
| 0.3% | 3.3ms | 0.0% | 0us | `Program` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:272` |
| 0.3% | 3.3ms | 0.2% | 2.0ms | `filter` | `[native code]` |
| 0.3% | 3.3ms | 0.1% | 975us | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2893` |
| 0.3% | 3.2ms | 0.0% | 176us | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:624` |
| 0.3% | 3.2ms | 0.3% | 3.2ms | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1644` |
| 0.3% | 3.2ms | 0.0% | 187us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1337` |
| 0.3% | 3.1ms | 0.2% | 2.1ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:959` |
| 0.3% | 3.0ms | 0.3% | 3.0ms | `add` | `[native code]` |
| 0.3% | 3.0ms | 0.2% | 2.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1285` |
| 0.3% | 2.9ms | 0.0% | 308us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2316` |
| 0.3% | 2.9ms | 0.3% | 2.9ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5731` |
| 0.3% | 2.9ms | 0.0% | 0us | `checkReferencesInScope` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:444` |
| 0.3% | 2.9ms | 0.3% | 2.9ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1006` |
| 0.3% | 2.8ms | 0.0% | 0us | `isGoodName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:128` |
| 0.3% | 2.8ms | 0.0% | 337us | `Program` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:275` |
| 0.3% | 2.8ms | 0.3% | 2.8ms | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` |
| 0.3% | 2.8ms | 0.3% | 2.6ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4252` |
| 0.3% | 2.8ms | 0.0% | 0us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5142` |
| 0.3% | 2.7ms | 0.2% | 2.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6529` |
| 0.3% | 2.7ms | 0.3% | 2.7ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4661` |
| 0.3% | 2.7ms | 0.3% | 2.7ms | `entries` | `[native code]` |
| 0.3% | 2.7ms | 0.3% | 2.7ms | `_mkGlobalVar` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.3% | 2.7ms | 0.3% | 2.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6865` |
| 0.3% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` |
| 0.3% | 2.7ms | 0.2% | 2.5ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4176` |
| 0.3% | 2.7ms | 0.0% | 0us | `esquery` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:53` |
| 0.3% | 2.7ms | 0.0% | 0us | `applyDisableDirectives` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7442` |
| 0.3% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.3% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:56` |
| 0.3% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:20` |
| 0.3% | 2.5ms | 0.3% | 2.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 2.5ms | 0.0% | 0us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5658` |
| 0.2% | 2.5ms | 0.0% | 0us | `ensureRefsThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1830` |
| 0.2% | 2.5ms | 0.2% | 2.2ms | `_applySchemaDefaults` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:170` |
| 0.2% | 2.4ms | 0.0% | 0us | `checkVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:228` |
| 0.2% | 2.4ms | 0.2% | 2.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4005` |
| 0.2% | 2.3ms | 0.0% | 310us | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2978` |
| 0.2% | 2.3ms | 0.0% | 185us | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:180` |
| 0.2% | 2.3ms | 0.2% | 2.3ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 2.3ms | 0.2% | 1.8ms | `performIteration` | `[native code]` |
| 0.2% | 2.3ms | 0.1% | 978us | `isUnderscored` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:101` |
| 0.2% | 2.3ms | 0.1% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6633` |
| 0.2% | 2.3ms | 0.1% | 1.2ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4845` |
| 0.2% | 2.3ms | 0.0% | 661us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3786` |
| 0.2% | 2.2ms | 0.2% | 2.2ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4823` |
| 0.2% | 2.2ms | 0.2% | 2.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5889` |
| 0.2% | 2.2ms | 0.2% | 2.2ms | `get _tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 2.2ms | 0.2% | 2.2ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5710` |
| 0.2% | 2.2ms | 0.0% | 575us | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:802` |
| 0.2% | 2.2ms | 0.2% | 1.8ms | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5600` |
| 0.2% | 2.2ms | 0.1% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5901` |
| 0.2% | 2.1ms | 0.1% | 887us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4214` |
| 0.2% | 2.1ms | 0.2% | 2.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3986` |
| 0.2% | 2.1ms | 0.0% | 175us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5331` |
| 0.2% | 2.1ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:215` |
| 0.2% | 2.0ms | 0.0% | 162us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2498` |
| 0.2% | 2.0ms | 0.2% | 2.0ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5641` |
| 0.2% | 2.0ms | 0.0% | 311us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3033` |
| 0.2% | 2.0ms | 0.0% | 134us | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:868` |
| 0.2% | 2.0ms | 0.2% | 2.0ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4635` |
| 0.2% | 2.0ms | 0.0% | 317us | `_parseDisableDirectives` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7404` |
| 0.2% | 1.9ms | 0.2% | 1.9ms | `getFunctionDefinitions` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` |
| 0.2% | 1.9ms | 0.0% | 0us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:511` |
| 0.2% | 1.9ms | 0.2% | 1.9ms | `decode` | `[native code]` |
| 0.2% | 1.9ms | 0.0% | 163us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6749` |
| 0.2% | 1.9ms | 0.2% | 1.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6412` |
| 0.2% | 1.9ms | 0.0% | 164us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1923` |
| 0.2% | 1.9ms | 0.0% | 658us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:954` |
| 0.2% | 1.8ms | 0.2% | 1.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6570` |
| 0.2% | 1.8ms | 0.2% | 1.8ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1954` |
| 0.2% | 1.8ms | 0.1% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6533` |
| 0.2% | 1.8ms | 0.2% | 1.8ms | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1684` |
| 0.2% | 1.8ms | 0.1% | 1.1ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1013` |
| 0.2% | 1.8ms | 0.2% | 1.8ms | `trim` | `[native code]` |
| 0.2% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.2% | 1.7ms | 0.0% | 180us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3902` |
| 0.2% | 1.7ms | 0.0% | 0us | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5100` |
| 0.2% | 1.7ms | 0.0% | 340us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1716` |
| 0.2% | 1.7ms | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1906` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4637` |
| 0.2% | 1.7ms | 0.2% | 1.7ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4666` |
| 0.1% | 1.7ms | 0.1% | 1.0ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1999` |
| 0.1% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:14` |
| 0.1% | 1.7ms | 0.0% | 182us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1673` |
| 0.1% | 1.7ms | 0.0% | 0us | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5998` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4006` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:92` |
| 0.1% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.1% | 1.6ms | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` |
| 0.1% | 1.6ms | 0.1% | 871us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2579` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_isSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4033` |
| 0.1% | 1.6ms | 0.1% | 1.3ms | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5564` |
| 0.1% | 1.6ms | 0.1% | 1.6ms | `_isSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4029` |
| 0.1% | 1.6ms | 0.0% | 157us | `getFunctionHeadLoc` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2308` |
| 0.1% | 1.6ms | 0.0% | 804us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:276` |
| 0.1% | 1.5ms | 0.0% | 332us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:92` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:510` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6538` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5712` |
| 0.1% | 1.5ms | 0.1% | 1.5ms | `set` | `[native code]` |
| 0.1% | 1.5ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:295` |
| 0.1% | 1.5ms | 0.1% | 1.3ms | `_expandUnion` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4044` |
| 0.1% | 1.4ms | 0.0% | 618us | `regExpSplitFast` | `[native code]` |
| 0.1% | 1.4ms | 0.0% | 0us | `checkLastSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:380` |
| 0.1% | 1.4ms | 0.1% | 1.3ms | `toString` | `[native code]` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5735` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `Map` | `[native code]` |
| 0.1% | 1.4ms | 0.0% | 324us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2283` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `endsWith` | `[native code]` |
| 0.1% | 1.4ms | 0.0% | 0us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2809` |
| 0.1% | 1.4ms | 0.1% | 1.4ms | `runOnce` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:95` |
| 0.1% | 1.4ms | 0.1% | 1.2ms | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:747` |
| 0.1% | 1.4ms | 0.0% | 517us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6758` |
| 0.1% | 1.4ms | 0.1% | 880us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2060` |
| 0.1% | 1.4ms | 0.0% | 452us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1255` |
| 0.1% | 1.4ms | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1718` |
| 0.1% | 1.3ms | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2066` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `/^_+\|_+$/gu` | `[native code]` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6541` |
| 0.1% | 1.3ms | 0.0% | 318us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2845` |
| 0.1% | 1.3ms | 0.1% | 1.0ms | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5591` |
| 0.1% | 1.3ms | 0.0% | 0us | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:182` |
| 0.1% | 1.3ms | 0.0% | 839us | `isLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:168` |
| 0.1% | 1.3ms | 0.0% | 182us | `async loadAndEvaluateModule` | `[native code]` |
| 0.1% | 1.3ms | 0.0% | 0us | `isSpecificMemberAccess` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:389` |
| 0.1% | 1.3ms | 0.1% | 940us | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:809` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `dlopen` | `[native code]` |
| 0.1% | 1.3ms | 0.0% | 0us | `isAvailable` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:399` |
| 0.1% | 1.3ms | 0.0% | 0us | `_getFfiSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:110` |
| 0.1% | 1.3ms | 0.0% | 0us | `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:318` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `fill` | `[native code]` |
| 0.1% | 1.3ms | 0.0% | 379us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:435` |
| 0.1% | 1.3ms | 0.0% | 486us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2470` |
| 0.1% | 1.3ms | 0.1% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6969` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5649` |
| 0.1% | 1.2ms | 0.0% | 0us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1744` |
| 0.1% | 1.2ms | 0.0% | 0us | `ensureFenVars` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1741` |
| 0.1% | 1.2ms | 0.0% | 0us | `parse` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.1% | 1.2ms | 0.0% | 0us | `g` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.1% | 1.2ms | 0.0% | 0us | `getIdentifierIfShouldBeConst` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:207` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 1.2ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6863` |
| 0.1% | 1.2ms | 0.0% | 754us | `_deepMergeObjects` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:128` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `getFunctionHeadLoc` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2312` |
| 0.1% | 1.2ms | 0.1% | 1.0ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2099` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4032` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6949` |
| 0.1% | 1.2ms | 0.0% | 0us | `checkReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:209` |
| 0.1% | 1.2ms | 0.0% | 360us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2529` |
| 0.1% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:436` |
| 0.1% | 1.2ms | 0.0% | 150us | `isSpecificMemberAccess` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:384` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `slice` | `[native code]` |
| 0.1% | 1.2ms | 0.1% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6416` |
| 0.1% | 1.2ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6577` |
| 0.1% | 1.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` |
| 0.1% | 1.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` |
| 0.1% | 1.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` |
| 0.1% | 1.1ms | 0.1% | 1.1ms | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1968` |
| 0.1% | 1.1ms | 0.1% | 1.1ms | `regExpMatchFast` | `[native code]` |
| 0.1% | 1.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` |
| 0.1% | 1.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` |
| 0.1% | 1.1ms | 0.0% | 156us | `BinaryExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:184` |
| 0.1% | 1.1ms | 0.0% | 692us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1384` |
| 0.1% | 1.1ms | 0.0% | 183us | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:651` |
| 0.1% | 1.1ms | 0.0% | 492us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6833` |
| 0.1% | 1.1ms | 0.0% | 0us | `getArrayMethodName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:124` |
| 0.1% | 1.1ms | 0.0% | 0us | `checkGroup` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:509` |
| 0.1% | 1.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:510` |
| 0.1% | 1.1ms | 0.0% | 773us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1674` |
| 0.1% | 1.1ms | 0.1% | 1.1ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:490` |
| 0.1% | 1.1ms | 0.0% | 315us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5285` |
| 0.1% | 1.1ms | 0.0% | 156us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:401` |
| 0.1% | 1.1ms | 0.1% | 1.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4002` |
| 0.1% | 1.0ms | 0.0% | 353us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:461` |
| 0.1% | 1.0ms | 0.0% | 0us | `Program` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:304` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5716` |
| 0.1% | 1.0ms | 0.0% | 185us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:433` |
| 0.1% | 1.0ms | 0.0% | 0us | `_e` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.1% | 1.0ms | 0.0% | 0us | `Ae` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.1% | 1.0ms | 0.0% | 0us | `Pe` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.1% | 1.0ms | 0.0% | 328us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:305` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4656` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:528` |
| 0.1% | 1.0ms | 0.0% | 138us | `(anonymous)` | `[native code]` |
| 0.1% | 1.0ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:403` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `get mainToken` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1089` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1330` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1038` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4192` |
| 0.1% | 1.0ms | 0.0% | 659us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1996` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7082` |
| 0.1% | 1.0ms | 0.0% | 0us | `_deepMergeObjects` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:126` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1175` |
| 0.1% | 1.0ms | 0.1% | 1.0ms | `getUint32` | `[native code]` |
| 0.1% | 1.0ms | 0.0% | 820us | `replace` | `[native code]` |
| 0.1% | 1.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:13` |
| 0.1% | 1.0ms | 0.0% | 0us | `node:path` | `node:path:2` |
| 0.1% | 992us | 0.0% | 169us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:302` |
| 0.1% | 991us | 0.0% | 0us | `_tryLoad` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:51` |
| 0.1% | 988us | 0.0% | 179us | `_isSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4030` |
| 0.1% | 984us | 0.1% | 984us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:961` |
| 0.1% | 982us | 0.1% | 982us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5915` |
| 0.1% | 976us | 0.1% | 976us | `includes` | `[native code]` |
| 0.1% | 975us | 0.0% | 480us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1663` |
| 0.1% | 975us | 0.0% | 344us | `describeRule` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:30` |
| 0.1% | 975us | 0.0% | 140us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:402` |
| 0.1% | 974us | 0.1% | 974us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5730` |
| 0.1% | 973us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` |
| 0.1% | 968us | 0.1% | 968us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5642` |
| 0.1% | 954us | 0.1% | 954us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4001` |
| 0.1% | 950us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` |
| 0.1% | 949us | 0.0% | 454us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:306` |
| 0.1% | 942us | 0.0% | 471us | `readFileSync` | `[native code]` |
| 0.1% | 938us | 0.0% | 484us | `every` | `[native code]` |
| 0.1% | 938us | 0.0% | 0us | `_isSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4031` |
| 0.1% | 938us | 0.1% | 938us | `test` | `[native code]` |
| 0.1% | 934us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:24` |
| 0.1% | 933us | 0.1% | 933us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3991` |
| 0.1% | 924us | 0.1% | 924us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 921us | 0.0% | 556us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6414` |
| 0.1% | 920us | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:661` |
| 0.1% | 910us | 0.0% | 384us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:451` |
| 0.1% | 907us | 0.0% | 0us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5088` |
| 0.1% | 899us | 0.1% | 899us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4256` |
| 0.1% | 895us | 0.0% | 0us | `isSpecificId` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:365` |
| 0.1% | 895us | 0.1% | 895us | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:533` |
| 0.1% | 894us | 0.0% | 754us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6727` |
| 0.1% | 882us | 0.0% | 512us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3046` |
| 0.1% | 881us | 0.0% | 364us | `Program` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:294` |
| 0.1% | 880us | 0.0% | 184us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:296` |
| 0.1% | 879us | 0.1% | 879us | `/\r?\n/` | `[native code]` |
| 0.1% | 874us | 0.1% | 874us | `Uint16Array` | `[native code]` |
| 0.1% | 867us | 0.0% | 164us | `_deepMergeArrays` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:137` |
| 0.1% | 866us | 0.1% | 866us | `push` | `[native code]` |
| 0.1% | 866us | 0.0% | 709us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6822` |
| 0.1% | 866us | 0.0% | 345us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6816` |
| 0.1% | 864us | 0.0% | 0us | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2880` |
| 0.1% | 863us | 0.0% | 188us | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5102` |
| 0.1% | 861us | 0.0% | 321us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:497` |
| 0.1% | 860us | 0.0% | 312us | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2907` |
| 0.0% | 857us | 0.0% | 149us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4207` |
| 0.0% | 856us | 0.0% | 856us | `_expandUnion` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4043` |
| 0.0% | 856us | 0.0% | 349us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1325` |
| 0.0% | 854us | 0.0% | 354us | `get name` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1328` |
| 0.0% | 852us | 0.0% | 852us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 851us | 0.0% | 680us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6569` |
| 0.0% | 844us | 0.0% | 844us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1612` |
| 0.0% | 844us | 0.0% | 844us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1380` |
| 0.0% | 843us | 0.0% | 362us | `hasRestSpreadSibling` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:411` |
| 0.0% | 843us | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.0% | 842us | 0.0% | 842us | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2979` |
| 0.0% | 842us | 0.0% | 0us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6471` |
| 0.0% | 839us | 0.0% | 839us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5248` |
| 0.0% | 838us | 0.0% | 838us | `_applySchemaDefaults` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:161` |
| 0.0% | 834us | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` |
| 0.0% | 833us | 0.0% | 0us | `dlopen` | `bun:ffi:345` |
| 0.0% | 831us | 0.0% | 301us | `_compileAttrCheck` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5198` |
| 0.0% | 828us | 0.0% | 0us | `isNullCheck` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:125` |
| 0.0% | 828us | 0.0% | 828us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:205` |
| 0.0% | 822us | 0.0% | 312us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7092` |
| 0.0% | 821us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` |
| 0.0% | 821us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:14` |
| 0.0% | 818us | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7361` |
| 0.0% | 817us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:136` |
| 0.0% | 817us | 0.0% | 817us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1184` |
| 0.0% | 815us | 0.0% | 815us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:159` |
| 0.0% | 814us | 0.0% | 330us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1700` |
| 0.0% | 810us | 0.0% | 647us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6263` |
| 0.0% | 809us | 0.0% | 360us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:689` |
| 0.0% | 808us | 0.0% | 808us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5694` |
| 0.0% | 807us | 0.0% | 663us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5062` |
| 0.0% | 800us | 0.0% | 800us | `_tag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1072` |
| 0.0% | 798us | 0.0% | 798us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4225` |
| 0.0% | 796us | 0.0% | 369us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4195` |
| 0.0% | 789us | 0.0% | 789us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6540` |
| 0.0% | 784us | 0.0% | 615us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6872` |
| 0.0% | 777us | 0.0% | 777us | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:773` |
| 0.0% | 773us | 0.0% | 0us | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5992` |
| 0.0% | 772us | 0.0% | 0us | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2945` |
| 0.0% | 770us | 0.0% | 459us | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3594` |
| 0.0% | 766us | 0.0% | 766us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5655` |
| 0.0% | 760us | 0.0% | 199us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:436` |
| 0.0% | 759us | 0.0% | 294us | `_isSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4025` |
| 0.0% | 756us | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6742` |
| 0.0% | 735us | 0.0% | 192us | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:620` |
| 0.0% | 731us | 0.0% | 142us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2571` |
| 0.0% | 726us | 0.0% | 726us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6536` |
| 0.0% | 726us | 0.0% | 726us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1994` |
| 0.0% | 717us | 0.0% | 717us | `/\/\*([\s\S]*?)\*\//g` | `[native code]` |
| 0.0% | 717us | 0.0% | 359us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1237` |
| 0.0% | 713us | 0.0% | 713us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6757` |
| 0.0% | 713us | 0.0% | 189us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4187` |
| 0.0% | 712us | 0.0% | 712us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2191` |
| 0.0% | 710us | 0.0% | 197us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2844` |
| 0.0% | 709us | 0.0% | 709us | `_parseDisableDirectives` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7412` |
| 0.0% | 708us | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:662` |
| 0.0% | 701us | 0.0% | 184us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6476` |
| 0.0% | 701us | 0.0% | 170us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:460` |
| 0.0% | 700us | 0.0% | 523us | `isExported` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:369` |
| 0.0% | 698us | 0.0% | 0us | `we` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 698us | 0.0% | 0us | `ke` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 698us | 0.0% | 346us | `_applySchemaDefaults` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:169` |
| 0.0% | 698us | 0.0% | 534us | `_expandUnion` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4042` |
| 0.0% | 697us | 0.0% | 697us | `slotTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5798` |
| 0.0% | 695us | 0.0% | 695us | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 694us | 0.0% | 159us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:408` |
| 0.0% | 694us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` |
| 0.0% | 694us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:450` |
| 0.0% | 688us | 0.0% | 0us | `BinaryExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:206` |
| 0.0% | 686us | 0.0% | 158us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1274` |
| 0.0% | 684us | 0.0% | 328us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4190` |
| 0.0% | 679us | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1711` |
| 0.0% | 678us | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7001` |
| 0.0% | 678us | 0.0% | 678us | `get start` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1092` |
| 0.0% | 675us | 0.0% | 0us | `MemberExpression[computed!=true] > Identifier.property` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:362` |
| 0.0% | 664us | 0.0% | 171us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:433` |
| 0.0% | 661us | 0.0% | 661us | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6351` |
| 0.0% | 661us | 0.0% | 661us | `copyDataProperties` | `[native code]` |
| 0.0% | 660us | 0.0% | 177us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` |
| 0.0% | 659us | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1680` |
| 0.0% | 658us | 0.0% | 320us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:473` |
| 0.0% | 657us | 0.0% | 512us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:440` |
| 0.0% | 656us | 0.0% | 656us | `iterateDeclarations` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:68` |
| 0.0% | 652us | 0.0% | 652us | `_nodeEndPos` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:880` |
| 0.0% | 652us | 0.0% | 652us | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1067` |
| 0.0% | 651us | 0.0% | 0us | `getTagNames` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:186` |
| 0.0% | 651us | 0.0% | 0us | `loadBinding` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` |
| 0.0% | 650us | 0.0% | 650us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6729` |
| 0.0% | 646us | 0.0% | 646us | `runOnce` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:84` |
| 0.0% | 645us | 0.0% | 645us | `slotTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5792` |
| 0.0% | 644us | 0.0% | 644us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 642us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5222` |
| 0.0% | 640us | 0.0% | 0us | `async loadModule` | `[native code]` |
| 0.0% | 639us | 0.0% | 295us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:314` |
| 0.0% | 638us | 0.0% | 0us | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5027` |
| 0.0% | 636us | 0.0% | 0us | `getFirstToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:984` |
| 0.0% | 636us | 0.0% | 636us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:642` |
| 0.0% | 635us | 0.0% | 635us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7032` |
| 0.0% | 633us | 0.0% | 633us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6824` |
| 0.0% | 631us | 0.0% | 0us | `getDestructuringHost` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:104` |
| 0.0% | 631us | 0.0% | 0us | `_getPlugin` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:60` |
| 0.0% | 631us | 0.0% | 631us | `_resolveUnicodeEscapes` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:226` |
| 0.0% | 630us | 0.0% | 0us | `internal:validators` | `internal:validators:2` |
| 0.0% | 629us | 0.0% | 629us | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` |
| 0.0% | 624us | 0.0% | 624us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2317` |
| 0.0% | 624us | 0.0% | 154us | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5947` |
| 0.0% | 622us | 0.0% | 622us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 622us | 0.0% | 622us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6817` |
| 0.0% | 620us | 0.0% | 482us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:423` |
| 0.0% | 620us | 0.0% | 0us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2282` |
| 0.0% | 617us | 0.0% | 147us | `isInside` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:494` |
| 0.0% | 606us | 0.0% | 606us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:637` |
| 0.0% | 606us | 0.0% | 606us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6726` |
| 0.0% | 602us | 0.0% | 145us | `getStaticPropertyName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:327` |
| 0.0% | 596us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:431` |
| 0.0% | 594us | 0.0% | 188us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1625` |
| 0.0% | 585us | 0.0% | 585us | `encodeInto` | `[native code]` |
| 0.0% | 574us | 0.0% | 574us | `get nodeTags` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:602` |
| 0.0% | 564us | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2071` |
| 0.0% | 562us | 0.0% | 0us | `reportReferenceId` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:262` |
| 0.0% | 557us | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:208` |
| 0.0% | 557us | 0.0% | 184us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:234` |
| 0.0% | 554us | 0.0% | 0us | `requestSatisfyUtil` | `[native code]` |
| 0.0% | 554us | 0.0% | 0us | `requestInstantiate` | `[native code]` |
| 0.0% | 554us | 0.0% | 0us | `ObjectExpression > Property[computed!=true] > Identifier.key,MethodDefinition[computed!=true] > Identifier.key,PropertyDefinition[computed!=true] > Identifier.key,MethodDefinition > PrivateIdentifier.key,PropertyDefinition > PrivateIdentifier.key` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:352` |
| 0.0% | 551us | 0.0% | 551us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 551us | 0.0% | 171us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:430` |
| 0.0% | 550us | 0.0% | 186us | `getStaticPropertyName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:320` |
| 0.0% | 547us | 0.0% | 0us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5688` |
| 0.0% | 545us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:437` |
| 0.0% | 544us | 0.0% | 345us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:313` |
| 0.0% | 543us | 0.0% | 380us | `isGlobalAugmentation` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:136` |
| 0.0% | 542us | 0.0% | 542us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1649` |
| 0.0% | 537us | 0.0% | 0us | `getArrayMethodName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:78` |
| 0.0% | 533us | 0.0% | 533us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3915` |
| 0.0% | 533us | 0.0% | 533us | `iterateDeclarations` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:61` |
| 0.0% | 531us | 0.0% | 531us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6539` |
| 0.0% | 531us | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1907` |
| 0.0% | 531us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3` |
| 0.0% | 530us | 0.0% | 530us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3995` |
| 0.0% | 530us | 0.0% | 0us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:90` |
| 0.0% | 530us | 0.0% | 530us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2832` |
| 0.0% | 529us | 0.0% | 529us | `get byteLength` | `[native code]` |
| 0.0% | 529us | 0.0% | 343us | `isUnderscored` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:105` |
| 0.0% | 527us | 0.0% | 0us | `isInitOfForStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:40` |
| 0.0% | 527us | 0.0% | 0us | `VariableDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:548` |
| 0.0% | 526us | 0.0% | 187us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:401` |
| 0.0% | 526us | 0.0% | 526us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6735` |
| 0.0% | 525us | 0.0% | 328us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4237` |
| 0.0% | 524us | 0.0% | 135us | `findVariablesInScope` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:96` |
| 0.0% | 524us | 0.0% | 156us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4255` |
| 0.0% | 523us | 0.0% | 349us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3774` |
| 0.0% | 521us | 0.0% | 521us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5798` |
| 0.0% | 520us | 0.0% | 520us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7322` |
| 0.0% | 518us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:325` |
| 0.0% | 518us | 0.0% | 0us | `isAfterLastUsedArg` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` |
| 0.0% | 518us | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` |
| 0.0% | 518us | 0.0% | 350us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4205` |
| 0.0% | 517us | 0.0% | 158us | `codepath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4256` |
| 0.0% | 516us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:3999` |
| 0.0% | 516us | 0.0% | 0us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6479` |
| 0.0% | 516us | 0.0% | 0us | `wordsRegexp` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:285` |
| 0.0% | 515us | 0.0% | 515us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4003` |
| 0.0% | 515us | 0.0% | 515us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 515us | 0.0% | 0us | `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:325` |
| 0.0% | 512us | 0.0% | 0us | `getIdentifierIfShouldBeConst` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:223` |
| 0.0% | 511us | 0.0% | 0us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5656` |
| 0.0% | 509us | 0.0% | 0us | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:654` |
| 0.0% | 509us | 0.0% | 0us | `isInitPatternNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:304` |
| 0.0% | 508us | 0.0% | 508us | `propertyIsEnumerable` | `[native code]` |
| 0.0% | 507us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:474` |
| 0.0% | 507us | 0.0% | 507us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6635` |
| 0.0% | 506us | 0.0% | 185us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:329` |
| 0.0% | 503us | 0.0% | 503us | `lastIndexOf` | `[native code]` |
| 0.0% | 502us | 0.0% | 145us | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2269` |
| 0.0% | 502us | 0.0% | 312us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2102` |
| 0.0% | 502us | 0.0% | 502us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4034` |
| 0.0% | 501us | 0.0% | 501us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5064` |
| 0.0% | 501us | 0.0% | 0us | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3614` |
| 0.0% | 501us | 0.0% | 160us | `getDestructuringHost` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:103` |
| 0.0% | 499us | 0.0% | 135us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` |
| 0.0% | 498us | 0.0% | 498us | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:664` |
| 0.0% | 497us | 0.0% | 497us | `get start` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 496us | 0.0% | 164us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2439` |
| 0.0% | 495us | 0.0% | 0us | `checkForBlock` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:139` |
| 0.0% | 495us | 0.0% | 495us | `[Symbol.iterator]` | `[native code]` |
| 0.0% | 495us | 0.0% | 495us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1696` |
| 0.0% | 494us | 0.0% | 494us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7351` |
| 0.0% | 493us | 0.0% | 352us | `accessPath` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5206` |
| 0.0% | 493us | 0.0% | 147us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4225` |
| 0.0% | 491us | 0.0% | 155us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4240` |
| 0.0% | 490us | 0.0% | 490us | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5801` |
| 0.0% | 490us | 0.0% | 490us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1993` |
| 0.0% | 490us | 0.0% | 0us | `iterateDeclarations` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:77` |
| 0.0% | 490us | 0.0% | 0us | `tryParse` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:126` |
| 0.0% | 490us | 0.0% | 0us | `_loadFromDisk` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:69` |
| 0.0% | 488us | 0.0% | 488us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2352` |
| 0.0% | 487us | 0.0% | 487us | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4673` |
| 0.0% | 486us | 0.0% | 486us | `runOnce` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:96` |
| 0.0% | 486us | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1733` |
| 0.0% | 485us | 0.0% | 160us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:404` |
| 0.0% | 485us | 0.0% | 485us | `Int32Array` | `[native code]` |
| 0.0% | 485us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:366` |
| 0.0% | 483us | 0.0% | 327us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6744` |
| 0.0% | 482us | 0.0% | 0us | `_expandUnion` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4045` |
| 0.0% | 481us | 0.0% | 0us | `Program` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:295` |
| 0.0% | 480us | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3750` |
| 0.0% | 480us | 0.0% | 0us | `get end` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1127` |
| 0.0% | 479us | 0.0% | 479us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6612` |
| 0.0% | 478us | 0.0% | 0us | `checkForBlock` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:132` |
| 0.0% | 476us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:429` |
| 0.0% | 476us | 0.0% | 310us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5713` |
| 0.0% | 475us | 0.0% | 335us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6411` |
| 0.0% | 473us | 0.0% | 177us | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1778` |
| 0.0% | 472us | 0.0% | 472us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6504` |
| 0.0% | 470us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:410` |
| 0.0% | 470us | 0.0% | 0us | `internal:shared` | `internal:shared:2` |
| 0.0% | 468us | 0.0% | 0us | `_getFfiSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:109` |
| 0.0% | 467us | 0.0% | 320us | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2954` |
| 0.0% | 467us | 0.0% | 467us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3997` |
| 0.0% | 463us | 0.0% | 463us | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6358` |
| 0.0% | 462us | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1699` |
| 0.0% | 462us | 0.0% | 462us | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2859` |
| 0.0% | 461us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5065` |
| 0.0% | 458us | 0.0% | 458us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5258` |
| 0.0% | 454us | 0.0% | 301us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4031` |
| 0.0% | 452us | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6713` |
| 0.0% | 451us | 0.0% | 162us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2636` |
| 0.0% | 450us | 0.0% | 0us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5050` |
| 0.0% | 448us | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6904` |
| 0.0% | 447us | 0.0% | 296us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:487` |
| 0.0% | 446us | 0.0% | 446us | `_lineStarts` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:611` |
| 0.0% | 439us | 0.0% | 143us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:419` |
| 0.0% | 430us | 0.0% | 148us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:308` |
| 0.0% | 413us | 0.0% | 413us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6613` |
| 0.0% | 409us | 0.0% | 409us | `fetch` | `[native code]` |
| 0.0% | 409us | 0.0% | 0us | `requestFetch` | `[native code]` |
| 0.0% | 398us | 0.0% | 0us | `checkReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:212` |
| 0.0% | 398us | 0.0% | 398us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3791` |
| 0.0% | 389us | 0.0% | 389us | `iterateDeclarations` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:59` |
| 0.0% | 385us | 0.0% | 0us | `checkReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:210` |
| 0.0% | 383us | 0.0% | 188us | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:513` |
| 0.0% | 383us | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:658` |
| 0.0% | 382us | 0.0% | 0us | `isEvaluatedDuringInitialization` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:197` |
| 0.0% | 382us | 0.0% | 0us | `segment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4250` |
| 0.0% | 382us | 0.0% | 382us | `CfgSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4286` |
| 0.0% | 381us | 0.0% | 0us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4993` |
| 0.0% | 380us | 0.0% | 380us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1607` |
| 0.0% | 379us | 0.0% | 379us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 378us | 0.0% | 378us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5290` |
| 0.0% | 374us | 0.0% | 374us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:930` |
| 0.0% | 373us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:400` |
| 0.0% | 372us | 0.0% | 372us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5693` |
| 0.0% | 372us | 0.0% | 169us | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2909` |
| 0.0% | 371us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn-jsx/index.js:3` |
| 0.0% | 371us | 0.0% | 0us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5678` |
| 0.0% | 371us | 0.0% | 0us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4197` |
| 0.0% | 371us | 0.0% | 201us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4192` |
| 0.0% | 369us | 0.0% | 369us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2774` |
| 0.0% | 369us | 0.0% | 369us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6634` |
| 0.0% | 369us | 0.0% | 369us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5752` |
| 0.0% | 368us | 0.0% | 368us | `_makeSafeHandler` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3818` |
| 0.0% | 367us | 0.0% | 367us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2183` |
| 0.0% | 366us | 0.0% | 0us | `skipChainExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:343` |
| 0.0% | 366us | 0.0% | 0us | `isSpecificMemberAccess` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:378` |
| 0.0% | 365us | 0.0% | 365us | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1007` |
| 0.0% | 364us | 0.0% | 187us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4200` |
| 0.0% | 363us | 0.0% | 363us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 362us | 0.0% | 362us | `iterateDeclarations` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:72` |
| 0.0% | 362us | 0.0% | 193us | `getDestructuringHost` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:98` |
| 0.0% | 362us | 0.0% | 0us | `iterateDeclarations` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:69` |
| 0.0% | 360us | 0.0% | 360us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7068` |
| 0.0% | 360us | 0.0% | 360us | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4655` |
| 0.0% | 360us | 0.0% | 173us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1677` |
| 0.0% | 360us | 0.0% | 0us | `getStaticPropertyName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:328` |
| 0.0% | 360us | 0.0% | 0us | `get property` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1943` |
| 0.0% | 359us | 0.0% | 359us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:165` |
| 0.0% | 359us | 0.0% | 182us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:418` |
| 0.0% | 358us | 0.0% | 358us | `_deepMergeObjects` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:129` |
| 0.0% | 357us | 0.0% | 357us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6644` |
| 0.0% | 357us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:413` |
| 0.0% | 356us | 0.0% | 169us | `ruleMetadataIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:12` |
| 0.0% | 354us | 0.0% | 182us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` |
| 0.0% | 354us | 0.0% | 196us | `getAssignedMessageData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:305` |
| 0.0% | 354us | 0.0% | 354us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1200` |
| 0.0% | 354us | 0.0% | 354us | `cloneObject` | `[native code]` |
| 0.0% | 353us | 0.0% | 0us | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5101` |
| 0.0% | 353us | 0.0% | 0us | `[Symbol.match]` | `[native code]` |
| 0.0% | 353us | 0.0% | 353us | `hasObservableSideEffectsForRegExpMatch` | `[native code]` |
| 0.0% | 353us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:440` |
| 0.0% | 353us | 0.0% | 0us | `groupByDestructuring` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:310` |
| 0.0% | 352us | 0.0% | 352us | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1012` |
| 0.0% | 352us | 0.0% | 0us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4210` |
| 0.0% | 352us | 0.0% | 0us | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5030` |
| 0.0% | 352us | 0.0% | 0us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3047` |
| 0.0% | 352us | 0.0% | 352us | `assign` | `[native code]` |
| 0.0% | 350us | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4213` |
| 0.0% | 350us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:411` |
| 0.0% | 350us | 0.0% | 0us | `ruleNameFromRuleId` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:28` |
| 0.0% | 350us | 0.0% | 350us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5689` |
| 0.0% | 349us | 0.0% | 349us | `isExported` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:363` |
| 0.0% | 349us | 0.0% | 349us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 348us | 0.0% | 162us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:656` |
| 0.0% | 348us | 0.0% | 0us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5665` |
| 0.0% | 348us | 0.0% | 348us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:641` |
| 0.0% | 347us | 0.0% | 347us | `link` | `[native code]` |
| 0.0% | 347us | 0.0% | 0us | `getIdentifierIfShouldBeConst` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:261` |
| 0.0% | 347us | 0.0% | 347us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 347us | 0.0% | 0us | `linkAndEvaluateModule` | `[native code]` |
| 0.0% | 347us | 0.0% | 194us | `runOnce` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:90` |
| 0.0% | 346us | 0.0% | 154us | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4630` |
| 0.0% | 345us | 0.0% | 150us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1533` |
| 0.0% | 345us | 0.0% | 173us | `get init` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2910` |
| 0.0% | 343us | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:162` |
| 0.0% | 343us | 0.0% | 343us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:420` |
| 0.0% | 343us | 0.0% | 171us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5742` |
| 0.0% | 342us | 0.0% | 152us | `reportReferenceId` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:242` |
| 0.0% | 342us | 0.0% | 0us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4230` |
| 0.0% | 342us | 0.0% | 158us | `getFunctionNameWithKind` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2181` |
| 0.0% | 342us | 0.0% | 193us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2057` |
| 0.0% | 341us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:12` |
| 0.0% | 341us | 0.0% | 0us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4218` |
| 0.0% | 341us | 0.0% | 0us | `buildUnicodeData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:3986` |
| 0.0% | 341us | 0.0% | 341us | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4844` |
| 0.0% | 341us | 0.0% | 341us | `RegExp` | `[native code]` |
| 0.0% | 340us | 0.0% | 340us | `/^(?:Function(?:Declaration\|Expression)\|ArrowFunctionExpression)$/u` | `[native code]` |
| 0.0% | 340us | 0.0% | 0us | `_tryLoad` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:34` |
| 0.0% | 340us | 0.0% | 340us | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:865` |
| 0.0% | 339us | 0.0% | 339us | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5802` |
| 0.0% | 339us | 0.0% | 0us | `isEvaluatedDuringInitialization` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:189` |
| 0.0% | 339us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:319` |
| 0.0% | 339us | 0.0% | 339us | `_getChainExpr` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3899` |
| 0.0% | 339us | 0.0% | 339us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6579` |
| 0.0% | 339us | 0.0% | 339us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1903` |
| 0.0% | 339us | 0.0% | 0us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1205` |
| 0.0% | 338us | 0.0% | 147us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4062` |
| 0.0% | 337us | 0.0% | 0us | `equalsToOriginalName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:177` |
| 0.0% | 337us | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6630` |
| 0.0% | 337us | 0.0% | 195us | `isFunctionNameInitializerException` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:423` |
| 0.0% | 337us | 0.0% | 337us | `RuleSkipSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4776` |
| 0.0% | 336us | 0.0% | 336us | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1037` |
| 0.0% | 336us | 0.0% | 336us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` |
| 0.0% | 336us | 0.0% | 336us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2065` |
| 0.0% | 336us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js:133` |
| 0.0% | 336us | 0.0% | 0us | `isNullLiteral` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:205` |
| 0.0% | 336us | 0.0% | 177us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4220` |
| 0.0% | 336us | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1719` |
| 0.0% | 335us | 0.0% | 335us | `get left` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1754` |
| 0.0% | 335us | 0.0% | 335us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2471` |
| 0.0% | 334us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:427` |
| 0.0% | 333us | 0.0% | 333us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 333us | 0.0% | 0us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3083` |
| 0.0% | 332us | 0.0% | 332us | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2879` |
| 0.0% | 332us | 0.0% | 142us | `get right` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1788` |
| 0.0% | 332us | 0.0% | 181us | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:636` |
| 0.0% | 331us | 0.0% | 331us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7365` |
| 0.0% | 331us | 0.0% | 0us | `MemberExpression[computed!=true] > Identifier.property` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:367` |
| 0.0% | 330us | 0.0% | 330us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3734` |
| 0.0% | 330us | 0.0% | 330us | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` |
| 0.0% | 330us | 0.0% | 330us | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4868` |
| 0.0% | 330us | 0.0% | 163us | `getNameRange` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:456` |
| 0.0% | 330us | 0.0% | 0us | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:656` |
| 0.0% | 330us | 0.0% | 330us | `/^(?:DoWhile\|For\|ForIn\|ForOf\|While)Statement$/u` | `[native code]` |
| 0.0% | 329us | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2462` |
| 0.0% | 329us | 0.0% | 329us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5744` |
| 0.0% | 329us | 0.0% | 0us | `isClassRefInClassDecorator` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:254` |
| 0.0% | 329us | 0.0% | 142us | `get decorators` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2088` |
| 0.0% | 329us | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:840` |
| 0.0% | 329us | 0.0% | 0us | `shouldCheck` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:413` |
| 0.0% | 329us | 0.0% | 329us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6832` |
| 0.0% | 329us | 0.0% | 329us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1614` |
| 0.0% | 328us | 0.0% | 328us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4033` |
| 0.0% | 327us | 0.0% | 327us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6258` |
| 0.0% | 327us | 0.0% | 0us | `checkLastSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:382` |
| 0.0% | 327us | 0.0% | 0us | `initialSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4343` |
| 0.0% | 327us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:414` |
| 0.0% | 325us | 0.0% | 0us | `shouldCheck` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:392` |
| 0.0% | 325us | 0.0% | 140us | `referenceContainsTypeQuery` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:227` |
| 0.0% | 324us | 0.0% | 182us | `isNullLiteral` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:204` |
| 0.0% | 324us | 0.0% | 175us | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5597` |
| 0.0% | 324us | 0.0% | 324us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5097` |
| 0.0% | 323us | 0.0% | 162us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2820` |
| 0.0% | 323us | 0.0% | 0us | `checkReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:202` |
| 0.0% | 322us | 0.0% | 322us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3999` |
| 0.0% | 322us | 0.0% | 0us | `bound call` | `[native code]` |
| 0.0% | 322us | 0.0% | 0us | `checkLastSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:370` |
| 0.0% | 322us | 0.0% | 0us | `isFunctionNameInitializerException` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:445` |
| 0.0% | 321us | 0.0% | 321us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2244` |
| 0.0% | 321us | 0.0% | 0us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1929` |
| 0.0% | 321us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:390` |
| 0.0% | 320us | 0.0% | 169us | `_getJsxTextTokFlags` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:696` |
| 0.0% | 320us | 0.0% | 175us | `requestSatisfy` | `[native code]` |
| 0.0% | 320us | 0.0% | 0us | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:798` |
| 0.0% | 320us | 0.0% | 0us | `getNameLocationInGlobalDirectiveComment` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2635` |
| 0.0% | 320us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/escape-string-regexp/index.js:11` |
| 0.0% | 319us | 0.0% | 182us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4188` |
| 0.0% | 319us | 0.0% | 137us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` |
| 0.0% | 318us | 0.0% | 0us | `getFunctionHeadLoc` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2299` |
| 0.0% | 318us | 0.0% | 138us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:399` |
| 0.0% | 317us | 0.0% | 0us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5291` |
| 0.0% | 317us | 0.0% | 153us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6449` |
| 0.0% | 316us | 0.0% | 316us | `describeRule` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:32` |
| 0.0% | 316us | 0.0% | 0us | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1754` |
| 0.0% | 315us | 0.0% | 315us | `get property` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1946` |
| 0.0% | 314us | 0.0% | 0us | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:486` |
| 0.0% | 314us | 0.0% | 314us | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5029` |
| 0.0% | 314us | 0.0% | 151us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` |
| 0.0% | 313us | 0.0% | 313us | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4840` |
| 0.0% | 313us | 0.0% | 313us | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3546` |
| 0.0% | 311us | 0.0% | 0us | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:662` |
| 0.0% | 311us | 0.0% | 0us | `getDeclaredLocation` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:471` |
| 0.0% | 310us | 0.0% | 310us | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4857` |
| 0.0% | 309us | 0.0% | 309us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2171` |
| 0.0% | 308us | 0.0% | 308us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6464` |
| 0.0% | 307us | 0.0% | 154us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4212` |
| 0.0% | 307us | 0.0% | 307us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:551` |
| 0.0% | 307us | 0.0% | 0us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1658` |
| 0.0% | 306us | 0.0% | 0us | `checkLastSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:388` |
| 0.0% | 305us | 0.0% | 305us | `create` | `[native code]` |
| 0.0% | 301us | 0.0% | 301us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 300us | 0.0% | 0us | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6048` |
| 0.0% | 300us | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5899` |
| 0.0% | 300us | 0.0% | 137us | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:480` |
| 0.0% | 298us | 0.0% | 162us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:430` |
| 0.0% | 298us | 0.0% | 0us | `checkGroup` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:421` |
| 0.0% | 296us | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7165` |
| 0.0% | 295us | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3758` |
| 0.0% | 295us | 0.0% | 0us | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4832` |
| 0.0% | 295us | 0.0% | 160us | `getLocFromIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3359` |
| 0.0% | 293us | 0.0% | 0us | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5554` |
| 0.0% | 292us | 0.0% | 0us | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:657` |
| 0.0% | 291us | 0.0% | 291us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2665` |
| 0.0% | 288us | 0.0% | 141us | `isModifyingProp` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:134` |
| 0.0% | 287us | 0.0% | 0us | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:672` |
| 0.0% | 287us | 0.0% | 287us | `_rawTokenText` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:781` |
| 0.0% | 286us | 0.0% | 286us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:179` |
| 0.0% | 285us | 0.0% | 148us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7065` |
| 0.0% | 285us | 0.0% | 0us | `getNameLocationInGlobalDirectiveComment` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2640` |
| 0.0% | 284us | 0.0% | 284us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6450` |
| 0.0% | 284us | 0.0% | 284us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6637` |
| 0.0% | 282us | 0.0% | 141us | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3574` |
| 0.0% | 270us | 0.0% | 270us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5891` |
| 0.0% | 204us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:22` |
| 0.0% | 204us | 0.0% | 204us | `isInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:231` |
| 0.0% | 204us | 0.0% | 204us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2700` |
| 0.0% | 204us | 0.0% | 0us | `isImportAttributeKey` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:1441` |
| 0.0% | 203us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` |
| 0.0% | 203us | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6532` |
| 0.0% | 202us | 0.0% | 202us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5120` |
| 0.0% | 201us | 0.0% | 201us | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4331` |
| 0.0% | 200us | 0.0% | 200us | `Ae` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 200us | 0.0% | 200us | `get start` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1106` |
| 0.0% | 199us | 0.0% | 199us | `Program` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js` |
| 0.0% | 198us | 0.0% | 198us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 198us | 0.0% | 198us | `be` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 197us | 0.0% | 197us | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 197us | 0.0% | 197us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1498` |
| 0.0% | 197us | 0.0% | 197us | `_symName` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:801` |
| 0.0% | 197us | 0.0% | 0us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6218` |
| 0.0% | 197us | 0.0% | 197us | `invokeHandlersWithNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6152` |
| 0.0% | 196us | 0.0% | 196us | `Ee` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 196us | 0.0% | 196us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4288` |
| 0.0% | 196us | 0.0% | 196us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7018` |
| 0.0% | 196us | 0.0% | 196us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:956` |
| 0.0% | 196us | 0.0% | 0us | `Se` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 195us | 0.0% | 0us | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5566` |
| 0.0% | 195us | 0.0% | 0us | `find` | `[native code]` |
| 0.0% | 195us | 0.0% | 195us | `_cookTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 195us | 0.0% | 195us | `get property` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 195us | 0.0% | 195us | `getNameLocationInGlobalDirectiveComment` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2643` |
| 0.0% | 195us | 0.0% | 0us | `getStaticStringValue` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:264` |
| 0.0% | 195us | 0.0% | 0us | `get expressions` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3031` |
| 0.0% | 195us | 0.0% | 195us | `isExported` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:364` |
| 0.0% | 195us | 0.0% | 0us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5012` |
| 0.0% | 195us | 0.0% | 195us | `groupByDestructuring` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:316` |
| 0.0% | 195us | 0.0% | 195us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5012` |
| 0.0% | 195us | 0.0% | 195us | `_buildThinScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2956` |
| 0.0% | 194us | 0.0% | 0us | `BinaryExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:186` |
| 0.0% | 194us | 0.0% | 194us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5785` |
| 0.0% | 194us | 0.0% | 194us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2172` |
| 0.0% | 194us | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3749` |
| 0.0% | 194us | 0.0% | 194us | `get operator` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1317` |
| 0.0% | 193us | 0.0% | 193us | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1048` |
| 0.0% | 193us | 0.0% | 0us | `get arguments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1898` |
| 0.0% | 193us | 0.0% | 0us | `getIdentifierIfShouldBeConst` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:232` |
| 0.0% | 193us | 0.0% | 0us | `getArrayMethodName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:118` |
| 0.0% | 193us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:232` |
| 0.0% | 193us | 0.0% | 193us | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2341` |
| 0.0% | 193us | 0.0% | 193us | `getIdentifierIfShouldBeConst` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:228` |
| 0.0% | 192us | 0.0% | 192us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1474` |
| 0.0% | 192us | 0.0% | 192us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1962` |
| 0.0% | 192us | 0.0% | 192us | `isModifyingProp` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:95` |
| 0.0% | 192us | 0.0% | 192us | `getVariableByName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js` |
| 0.0% | 192us | 0.0% | 192us | `[Symbol.split]` | `[native code]` |
| 0.0% | 192us | 0.0% | 0us | `isModifyingProp` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:118` |
| 0.0% | 192us | 0.0% | 192us | `get left` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 191us | 0.0% | 191us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1966` |
| 0.0% | 191us | 0.0% | 0us | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4681` |
| 0.0% | 191us | 0.0% | 191us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5678` |
| 0.0% | 191us | 0.0% | 191us | `_isChainChild` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3873` |
| 0.0% | 191us | 0.0% | 191us | `_deepMergeObjects` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 191us | 0.0% | 0us | `isInsideOfStorableFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:630` |
| 0.0% | 191us | 0.0% | 191us | `resolve` | `[native code]` |
| 0.0% | 191us | 0.0% | 0us | `getUpperFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:132` |
| 0.0% | 191us | 0.0% | 191us | `isStorableFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.0% | 190us | 0.0% | 190us | `_lineStarts` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 190us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:338` |
| 0.0% | 190us | 0.0% | 190us | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4036` |
| 0.0% | 190us | 0.0% | 190us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7071` |
| 0.0% | 190us | 0.0% | 0us | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2259` |
| 0.0% | 190us | 0.0% | 190us | `isImportAttributeKey` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:1426` |
| 0.0% | 190us | 0.0% | 0us | `reduce` | `[native code]` |
| 0.0% | 189us | 0.0% | 189us | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5031` |
| 0.0% | 189us | 0.0% | 189us | `get local` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3488` |
| 0.0% | 189us | 0.0% | 0us | `get initialSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4343` |
| 0.0% | 189us | 0.0% | 189us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6417` |
| 0.0% | 189us | 0.0% | 189us | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2889` |
| 0.0% | 189us | 0.0% | 189us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7341` |
| 0.0% | 189us | 0.0% | 189us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` |
| 0.0% | 189us | 0.0% | 189us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1503` |
| 0.0% | 188us | 0.0% | 188us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` |
| 0.0% | 188us | 0.0% | 188us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4242` |
| 0.0% | 188us | 0.0% | 0us | `internal:validators` | `internal:validators:47` |
| 0.0% | 188us | 0.0% | 188us | `defineProperty` | `[native code]` |
| 0.0% | 188us | 0.0% | 0us | `hideFromStack` | `internal:shared:19` |
| 0.0% | 188us | 0.0% | 188us | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1040` |
| 0.0% | 188us | 0.0% | 188us | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 188us | 0.0% | 0us | `node:fs/promises` | `node:fs/promises:2` |
| 0.0% | 188us | 0.0% | 188us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:318` |
| 0.0% | 187us | 0.0% | 187us | `isOuterVariableInDestructing` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:72` |
| 0.0% | 187us | 0.0% | 187us | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 187us | 0.0% | 187us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:228` |
| 0.0% | 187us | 0.0% | 0us | `exec` | `[native code]` |
| 0.0% | 187us | 0.0% | 187us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1176` |
| 0.0% | 187us | 0.0% | 0us | `isModifyingProp` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:159` |
| 0.0% | 187us | 0.0% | 187us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:155` |
| 0.0% | 187us | 0.0% | 187us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2494` |
| 0.0% | 187us | 0.0% | 0us | `isNullCheck` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:126` |
| 0.0% | 187us | 0.0% | 187us | `RuleMetadataIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js` |
| 0.0% | 187us | 0.0% | 187us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4000` |
| 0.0% | 186us | 0.0% | 186us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4133` |
| 0.0% | 186us | 0.0% | 186us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:205` |
| 0.0% | 186us | 0.0% | 0us | `node:fs` | `node:fs:303` |
| 0.0% | 186us | 0.0% | 186us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:788` |
| 0.0% | 186us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:379` |
| 0.0% | 186us | 0.0% | 0us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2727` |
| 0.0% | 186us | 0.0% | 186us | `getModuleExportName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:973` |
| 0.0% | 186us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:323` |
| 0.0% | 186us | 0.0% | 186us | `get key` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3120` |
| 0.0% | 186us | 0.0% | 0us | `equalsToOriginalName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:186` |
| 0.0% | 186us | 0.0% | 0us | `canBecomeVariableDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:58` |
| 0.0% | 186us | 0.0% | 186us | `toUpperCase` | `[native code]` |
| 0.0% | 186us | 0.0% | 186us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:59` |
| 0.0% | 186us | 0.0% | 186us | `isLogicalAssignmentOperator` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:941` |
| 0.0% | 186us | 0.0% | 0us | `isModifyingProp` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:141` |
| 0.0% | 186us | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6100` |
| 0.0% | 186us | 0.0% | 186us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2522` |
| 0.0% | 185us | 0.0% | 185us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4973` |
| 0.0% | 185us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:15` |
| 0.0% | 185us | 0.0% | 0us | `isAssignmentTarget` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:138` |
| 0.0% | 185us | 0.0% | 185us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1661` |
| 0.0% | 185us | 0.0% | 185us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6467` |
| 0.0% | 185us | 0.0% | 185us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:280` |
| 0.0% | 184us | 0.0% | 0us | `get callee` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1873` |
| 0.0% | 184us | 0.0% | 184us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5107` |
| 0.0% | 184us | 0.0% | 184us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4045` |
| 0.0% | 184us | 0.0% | 184us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 184us | 0.0% | 184us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3073` |
| 0.0% | 184us | 0.0% | 184us | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:487` |
| 0.0% | 184us | 0.0% | 0us | `reportReferenceId` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:251` |
| 0.0% | 184us | 0.0% | 184us | `_isSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 184us | 0.0% | 184us | `getTokenAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1289` |
| 0.0% | 184us | 0.0% | 184us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4201` |
| 0.0% | 183us | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2454` |
| 0.0% | 183us | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:148` |
| 0.0% | 183us | 0.0% | 183us | `get operator` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1307` |
| 0.0% | 183us | 0.0% | 183us | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:818` |
| 0.0% | 183us | 0.0% | 183us | `getFunctionNameWithKind` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2184` |
| 0.0% | 183us | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:931` |
| 0.0% | 182us | 0.0% | 182us | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:621` |
| 0.0% | 182us | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1676` |
| 0.0% | 182us | 0.0% | 182us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6097` |
| 0.0% | 182us | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:575` |
| 0.0% | 182us | 0.0% | 182us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn-jsx/xhtml.js:1` |
| 0.0% | 182us | 0.0% | 182us | `_applySchemaDefaults` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:171` |
| 0.0% | 182us | 0.0% | 0us | `node:child_process` | `node:child_process:2` |
| 0.0% | 182us | 0.0% | 182us | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4654` |
| 0.0% | 181us | 0.0% | 0us | `_extractFileLevelRules` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4871` |
| 0.0% | 181us | 0.0% | 0us | `isImportAttributeKey` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:1429` |
| 0.0% | 181us | 0.0% | 181us | `isSpecificMemberAccess` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js` |
| 0.0% | 181us | 0.0% | 181us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3759` |
| 0.0% | 181us | 0.0% | 181us | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3394` |
| 0.0% | 181us | 0.0% | 181us | `isAssignmentTarget` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:140` |
| 0.0% | 181us | 0.0% | 181us | `_getChainExpr` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3903` |
| 0.0% | 181us | 0.0% | 181us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3074` |
| 0.0% | 181us | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:935` |
| 0.0% | 181us | 0.0% | 181us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:653` |
| 0.0% | 181us | 0.0% | 181us | `isInClassStaticInitializerRange` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js` |
| 0.0% | 181us | 0.0% | 181us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:405` |
| 0.0% | 180us | 0.0% | 180us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5244` |
| 0.0% | 180us | 0.0% | 0us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:688` |
| 0.0% | 180us | 0.0% | 0us | `getAssignedMessageData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:306` |
| 0.0% | 180us | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1689` |
| 0.0% | 180us | 0.0% | 180us | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4665` |
| 0.0% | 180us | 0.0% | 180us | `defToVariableType` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:204` |
| 0.0% | 180us | 0.0% | 180us | `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:334` |
| 0.0% | 180us | 0.0% | 180us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3884` |
| 0.0% | 180us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:412` |
| 0.0% | 180us | 0.0% | 180us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6946` |
| 0.0% | 180us | 0.0% | 180us | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5601` |
| 0.0% | 180us | 0.0% | 180us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js` |
| 0.0% | 179us | 0.0% | 0us | `isInsideOfStorableFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:634` |
| 0.0% | 179us | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6973` |
| 0.0% | 179us | 0.0% | 179us | `get callee` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 179us | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:431` |
| 0.0% | 179us | 0.0% | 179us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4004` |
| 0.0% | 179us | 0.0% | 179us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2377` |
| 0.0% | 179us | 0.0% | 179us | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1783` |
| 0.0% | 179us | 0.0% | 179us | `getFunctionNameWithKind` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2110` |
| 0.0% | 178us | 0.0% | 178us | `isEvaluatedDuringInitialization` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js` |
| 0.0% | 178us | 0.0% | 178us | `onCodePathStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js` |
| 0.0% | 178us | 0.0% | 0us | `findIndex` | `[native code]` |
| 0.0% | 178us | 0.0% | 0us | `isReadForItself` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:655` |
| 0.0% | 178us | 0.0% | 0us | `getFunctionHeadLoc` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2307` |
| 0.0% | 178us | 0.0% | 178us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5051` |
| 0.0% | 178us | 0.0% | 0us | `isUnusedExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:506` |
| 0.0% | 178us | 0.0% | 178us | `slotTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5793` |
| 0.0% | 178us | 0.0% | 0us | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1760` |
| 0.0% | 178us | 0.0% | 178us | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3610` |
| 0.0% | 177us | 0.0% | 177us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 177us | 0.0% | 177us | `ensureBufferBytes` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js` |
| 0.0% | 177us | 0.0% | 177us | `ensureBufferBytes` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:61` |
| 0.0% | 177us | 0.0% | 177us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:479` |
| 0.0% | 177us | 0.0% | 177us | `getIdentifierIfShouldBeConst` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:187` |
| 0.0% | 177us | 0.0% | 177us | `isGenericOfAStaticMethodShadow` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js` |
| 0.0% | 177us | 0.0% | 177us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5643` |
| 0.0% | 177us | 0.0% | 0us | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:659` |
| 0.0% | 177us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:466` |
| 0.0% | 177us | 0.0% | 177us | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4668` |
| 0.0% | 176us | 0.0% | 0us | `ensureBufferBytes` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:58` |
| 0.0% | 176us | 0.0% | 0us | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1196` |
| 0.0% | 176us | 0.0% | 176us | `_tokenIndexAtOrBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 176us | 0.0% | 176us | `getNameLocationInGlobalDirectiveComment` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2634` |
| 0.0% | 176us | 0.0% | 0us | `checkGroup` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:426` |
| 0.0% | 176us | 0.0% | 176us | `equalsToOriginalName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:179` |
| 0.0% | 176us | 0.0% | 0us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5734` |
| 0.0% | 175us | 0.0% | 0us | `buildUnicodeData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:3982` |
| 0.0% | 175us | 0.0% | 0us | `isModifyingProp` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:96` |
| 0.0% | 175us | 0.0% | 175us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6945` |
| 0.0% | 175us | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2107` |
| 0.0% | 175us | 0.0% | 175us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:126` |
| 0.0% | 175us | 0.0% | 175us | `isAssignmentTarget` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:143` |
| 0.0% | 175us | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1421` |
| 0.0% | 174us | 0.0% | 0us | `get static` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2250` |
| 0.0% | 174us | 0.0% | 0us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1246` |
| 0.0% | 174us | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:555` |
| 0.0% | 174us | 0.0% | 174us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1669` |
| 0.0% | 174us | 0.0% | 174us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7136` |
| 0.0% | 174us | 0.0% | 174us | `replaceTextRange` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/fix-tracker.js:110` |
| 0.0% | 174us | 0.0% | 174us | `_computeIsStrict` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 174us | 0.0% | 0us | `getIdentifierIfShouldBeConst` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:237` |
| 0.0% | 174us | 0.0% | 0us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4202` |
| 0.0% | 174us | 0.0% | 174us | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:513` |
| 0.0% | 174us | 0.0% | 174us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5087` |
| 0.0% | 174us | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` |
| 0.0% | 174us | 0.0% | 0us | `isFromSeparateExecutionContext` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:138` |
| 0.0% | 174us | 0.0% | 174us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6200` |
| 0.0% | 174us | 0.0% | 174us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3783` |
| 0.0% | 174us | 0.0% | 174us | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3620` |
| 0.0% | 174us | 0.0% | 174us | `getStaticPropertyName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:307` |
| 0.0% | 174us | 0.0% | 0us | `isClassStaticInitializerScope` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:88` |
| 0.0% | 174us | 0.0% | 174us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2624` |
| 0.0% | 174us | 0.0% | 0us | `shouldCheck` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:377` |
| 0.0% | 173us | 0.0% | 173us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2216` |
| 0.0% | 173us | 0.0% | 173us | `_getTypeProto` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3967` |
| 0.0% | 173us | 0.0% | 173us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1620` |
| 0.0% | 173us | 0.0% | 173us | `get params` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2541` |
| 0.0% | 173us | 0.0% | 173us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.0% | 173us | 0.0% | 173us | `_isSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4026` |
| 0.0% | 172us | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2067` |
| 0.0% | 172us | 0.0% | 0us | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3606` |
| 0.0% | 172us | 0.0% | 172us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1628` |
| 0.0% | 172us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:289` |
| 0.0% | 172us | 0.0% | 0us | `unwrapExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:368` |
| 0.0% | 172us | 0.0% | 172us | `getFirstToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 171us | 0.0% | 0us | `getFunctionHeadLoc` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2300` |
| 0.0% | 171us | 0.0% | 0us | `findUp` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:339` |
| 0.0% | 171us | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1703` |
| 0.0% | 171us | 0.0% | 171us | `iterateDeclarations` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js` |
| 0.0% | 171us | 0.0% | 0us | `checkGroup` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:412` |
| 0.0% | 171us | 0.0% | 0us | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5809` |
| 0.0% | 171us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:322` |
| 0.0% | 170us | 0.0% | 170us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1295` |
| 0.0% | 170us | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6558` |
| 0.0% | 170us | 0.0% | 170us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5086` |
| 0.0% | 170us | 0.0% | 170us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2378` |
| 0.0% | 169us | 0.0% | 169us | `nodeViewChain` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4056` |
| 0.0% | 169us | 0.0% | 0us | `internal:primordials` | `internal:primordials:71` |
| 0.0% | 169us | 0.0% | 169us | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 169us | 0.0% | 169us | `(anonymous)` | `internal:primordials:35` |
| 0.0% | 169us | 0.0% | 169us | `get options` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2173` |
| 0.0% | 169us | 0.0% | 169us | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2278` |
| 0.0% | 169us | 0.0% | 0us | `isImportAttributeKey` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:1433` |
| 0.0% | 169us | 0.0% | 0us | `makeSafe` | `internal:primordials:30` |
| 0.0% | 169us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/tags.js:247` |
| 0.0% | 169us | 0.0% | 169us | `isWrite` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:217` |
| 0.0% | 169us | 0.0% | 169us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3756` |
| 0.0% | 169us | 0.0% | 169us | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 168us | 0.0% | 168us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:394` |
| 0.0% | 168us | 0.0% | 168us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3095` |
| 0.0% | 168us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:352` |
| 0.0% | 168us | 0.0% | 0us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4205` |
| 0.0% | 168us | 0.0% | 168us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:84` |
| 0.0% | 168us | 0.0% | 0us | `isNullLiteral` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:206` |
| 0.0% | 168us | 0.0% | 168us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:434` |
| 0.0% | 168us | 0.0% | 168us | `get regex` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1569` |
| 0.0% | 168us | 0.0% | 0us | `hasRestSibling` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:399` |
| 0.0% | 167us | 0.0% | 167us | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:808` |
| 0.0% | 167us | 0.0% | 0us | `isTypeOfBinary` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:100` |
| 0.0% | 167us | 0.0% | 0us | `isInTdz` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:490` |
| 0.0% | 167us | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:862` |
| 0.0% | 167us | 0.0% | 0us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4219` |
| 0.0% | 167us | 0.0% | 167us | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 167us | 0.0% | 167us | `isTypeOf` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js` |
| 0.0% | 167us | 0.0% | 167us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3790` |
| 0.0% | 167us | 0.0% | 0us | `BinaryExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:195` |
| 0.0% | 167us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:76` |
| 0.0% | 166us | 0.0% | 166us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6559` |
| 0.0% | 166us | 0.0% | 166us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6446` |
| 0.0% | 166us | 0.0% | 0us | `get computed` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1978` |
| 0.0% | 166us | 0.0% | 166us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2169` |
| 0.0% | 166us | 0.0% | 166us | `getIdentifierIfShouldBeConst` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:233` |
| 0.0% | 165us | 0.0% | 165us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6480` |
| 0.0% | 165us | 0.0% | 165us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:331` |
| 0.0% | 165us | 0.0% | 165us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1627` |
| 0.0% | 165us | 0.0% | 165us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:476` |
| 0.0% | 164us | 0.0% | 164us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4220` |
| 0.0% | 164us | 0.0% | 164us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:349` |
| 0.0% | 164us | 0.0% | 0us | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:576` |
| 0.0% | 164us | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:414` |
| 0.0% | 164us | 0.0% | 164us | `join` | `[native code]` |
| 0.0% | 164us | 0.0% | 164us | `get id` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2270` |
| 0.0% | 164us | 0.0% | 164us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:782` |
| 0.0% | 164us | 0.0% | 164us | `_buildReference` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2818` |
| 0.0% | 164us | 0.0% | 164us | `_findLineIdx` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:619` |
| 0.0% | 164us | 0.0% | 0us | `get declarations` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2616` |
| 0.0% | 163us | 0.0% | 163us | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2864` |
| 0.0% | 163us | 0.0% | 163us | `Program` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:152` |
| 0.0% | 163us | 0.0% | 163us | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1829` |
| 0.0% | 163us | 0.0% | 0us | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:658` |
| 0.0% | 163us | 0.0% | 163us | `get kind` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2626` |
| 0.0% | 163us | 0.0% | 163us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:398` |
| 0.0% | 163us | 0.0% | 163us | `(program)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:1` |
| 0.0% | 163us | 0.0% | 163us | `_nodeStartPos` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:888` |
| 0.0% | 163us | 0.0% | 0us | `checkLastSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:371` |
| 0.0% | 163us | 0.0% | 163us | `isReadRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:431` |
| 0.0% | 163us | 0.0% | 0us | `isInTdz` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:491` |
| 0.0% | 163us | 0.0% | 0us | `isAnySegmentReachable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:39` |
| 0.0% | 162us | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:151` |
| 0.0% | 162us | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2069` |
| 0.0% | 162us | 0.0% | 162us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2646` |
| 0.0% | 162us | 0.0% | 162us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:51` |
| 0.0% | 162us | 0.0% | 162us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1735` |
| 0.0% | 162us | 0.0% | 162us | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:665` |
| 0.0% | 162us | 0.0% | 162us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:396` |
| 0.0% | 162us | 0.0% | 162us | `fullMethodName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:58` |
| 0.0% | 162us | 0.0% | 162us | `hasRestSpreadSibling` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:410` |
| 0.0% | 162us | 0.0% | 0us | `areLiteralsAndSameType` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:113` |
| 0.0% | 162us | 0.0% | 162us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:682` |
| 0.0% | 162us | 0.0% | 0us | `isSpecificMemberAccess` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:380` |
| 0.0% | 161us | 0.0% | 161us | `canBecomeVariableDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:59` |
| 0.0% | 161us | 0.0% | 161us | `isArrayFromMethod` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:533` |
| 0.0% | 161us | 0.0% | 161us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4235` |
| 0.0% | 161us | 0.0% | 161us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2273` |
| 0.0% | 161us | 0.0% | 0us | `getFunctionNameWithKind` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2159` |
| 0.0% | 161us | 0.0% | 0us | `getIdentifierIfShouldBeConst` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:217` |
| 0.0% | 160us | 0.0% | 160us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1745` |
| 0.0% | 160us | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:940` |
| 0.0% | 160us | 0.0% | 160us | `isFunctionNameInitializerException` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:426` |
| 0.0% | 160us | 0.0% | 160us | `get params` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2543` |
| 0.0% | 160us | 0.0% | 160us | `getUsedIgnoredMessageData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.0% | 159us | 0.0% | 159us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4215` |
| 0.0% | 159us | 0.0% | 159us | `extraFnData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 159us | 0.0% | 159us | `safeHandler` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3820` |
| 0.0% | 159us | 0.0% | 159us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 159us | 0.0% | 159us | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 159us | 0.0% | 159us | `ensureChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1847` |
| 0.0% | 159us | 0.0% | 159us | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 159us | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1483` |
| 0.0% | 158us | 0.0% | 0us | `dlopen` | `bun:ffi:344` |
| 0.0% | 158us | 0.0% | 158us | `get flags` | `[native code]` |
| 0.0% | 158us | 0.0% | 0us | `getFunctionNameWithKind` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2180` |
| 0.0% | 158us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:29` |
| 0.0% | 158us | 0.0% | 158us | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4330` |
| 0.0% | 158us | 0.0% | 158us | `normalizePath` | `bun:ffi` |
| 0.0% | 158us | 0.0% | 158us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2447` |
| 0.0% | 158us | 0.0% | 0us | `getVariableDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:261` |
| 0.0% | 158us | 0.0% | 0us | `getDeclaredVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3067` |
| 0.0% | 158us | 0.0% | 0us | `isInClassStaticInitializerRange` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:64` |
| 0.0% | 157us | 0.0% | 0us | `get right` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1786` |
| 0.0% | 157us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:495` |
| 0.0% | 157us | 0.0% | 157us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2175` |
| 0.0% | 157us | 0.0% | 157us | `getArrayMethodName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:72` |
| 0.0% | 157us | 0.0% | 157us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js` |
| 0.0% | 157us | 0.0% | 0us | `areLiteralsAndSameType` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:112` |
| 0.0% | 157us | 0.0% | 157us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6768` |
| 0.0% | 157us | 0.0% | 0us | `BinaryExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:196` |
| 0.0% | 157us | 0.0% | 0us | `get properties` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3090` |
| 0.0% | 157us | 0.0% | 157us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 157us | 0.0% | 157us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:142` |
| 0.0% | 157us | 0.0% | 0us | `checkGroup` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:492` |
| 0.0% | 156us | 0.0% | 156us | `getFunctionNameWithKind` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js` |
| 0.0% | 156us | 0.0% | 0us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1710` |
| 0.0% | 156us | 0.0% | 156us | `e` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 156us | 0.0% | 156us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:384` |
| 0.0% | 156us | 0.0% | 0us | `a` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 156us | 0.0% | 156us | `_ensureTagCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 156us | 0.0% | 156us | `get body` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 156us | 0.0% | 156us | `extraClassData` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 156us | 0.0% | 156us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6588` |
| 0.0% | 155us | 0.0% | 155us | `getFirstToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:916` |
| 0.0% | 155us | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1712` |
| 0.0% | 155us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:416` |
| 0.0% | 155us | 0.0% | 155us | `get callee` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1871` |
| 0.0% | 155us | 0.0% | 155us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2321` |
| 0.0% | 155us | 0.0% | 155us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1693` |
| 0.0% | 155us | 0.0% | 155us | `_applySchemaDefaults` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:166` |
| 0.0% | 155us | 0.0% | 0us | `getDefinedMessageData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:278` |
| 0.0% | 155us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:453` |
| 0.0% | 155us | 0.0% | 155us | `getVariableDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:250` |
| 0.0% | 155us | 0.0% | 155us | `checkLastSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:320` |
| 0.0% | 155us | 0.0% | 0us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1690` |
| 0.0% | 155us | 0.0% | 155us | `getTokenAfter` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 154us | 0.0% | 0us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:428` |
| 0.0% | 154us | 0.0% | 154us | `isTypeValueShadow` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:157` |
| 0.0% | 154us | 0.0% | 154us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7015` |
| 0.0% | 154us | 0.0% | 0us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4212` |
| 0.0% | 154us | 0.0% | 154us | `startsWith` | `[native code]` |
| 0.0% | 154us | 0.0% | 154us | `_deepMergeArrays` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:134` |
| 0.0% | 153us | 0.0% | 153us | `_scopeForNode` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:847` |
| 0.0% | 153us | 0.0% | 0us | `pluginKeyFromRuleId` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:20` |
| 0.0% | 153us | 0.0% | 153us | `checkGroup` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js` |
| 0.0% | 153us | 0.0% | 0us | `internal:primordials` | `internal:primordials:50` |
| 0.0% | 153us | 0.0% | 153us | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6022` |
| 0.0% | 153us | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1451` |
| 0.0% | 153us | 0.0% | 0us | `getScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1528` |
| 0.0% | 153us | 0.0% | 153us | `_getFfiSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:105` |
| 0.0% | 153us | 0.0% | 153us | `/^[A-Z][A-Za-z]*$/` | `[native code]` |
| 0.0% | 153us | 0.0% | 153us | `isUsedVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:716` |
| 0.0% | 152us | 0.0% | 152us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6491` |
| 0.0% | 152us | 0.0% | 152us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6814` |
| 0.0% | 152us | 0.0% | 0us | `isFunctionNameInitializerException` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:424` |
| 0.0% | 152us | 0.0% | 152us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6415` |
| 0.0% | 151us | 0.0% | 151us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2721` |
| 0.0% | 151us | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7376` |
| 0.0% | 151us | 0.0% | 151us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6461` |
| 0.0% | 151us | 0.0% | 151us | `toLength` | `[native code]` |
| 0.0% | 151us | 0.0% | 151us | `isThisParam` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:147` |
| 0.0% | 151us | 0.0% | 0us | `binop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:130` |
| 0.0% | 151us | 0.0% | 151us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2514` |
| 0.0% | 151us | 0.0% | 151us | `TokenType` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:115` |
| 0.0% | 151us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:193` |
| 0.0% | 150us | 0.0% | 150us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:123` |
| 0.0% | 150us | 0.0% | 0us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6197` |
| 0.0% | 150us | 0.0% | 0us | `getUsedIgnoredMessageData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:331` |
| 0.0% | 150us | 0.0% | 150us | `shouldCheck` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:399` |
| 0.0% | 150us | 0.0% | 0us | `get async` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2217` |
| 0.0% | 150us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:351` |
| 0.0% | 150us | 0.0% | 150us | `unwrapExpression` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:372` |
| 0.0% | 150us | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:202` |
| 0.0% | 150us | 0.0% | 150us | `getVariableDescription` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:264` |
| 0.0% | 150us | 0.0% | 150us | `_getTypeProto` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 150us | 0.0% | 150us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6469` |
| 0.0% | 150us | 0.0% | 0us | `collectUnusedVariables` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:829` |
| 0.0% | 150us | 0.0% | 0us | `getFunctionNameWithKind` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2127` |
| 0.0% | 150us | 0.0% | 150us | `get end` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1109` |
| 0.0% | 149us | 0.0% | 149us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3101` |
| 0.0% | 149us | 0.0% | 149us | `isImportAttributeKey` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:1423` |
| 0.0% | 149us | 0.0% | 149us | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5956` |
| 0.0% | 149us | 0.0% | 0us | `_applySchemaDefaults` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:162` |
| 0.0% | 149us | 0.0% | 0us | `getIdentifierIfShouldBeConst` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:218` |
| 0.0% | 149us | 0.0% | 149us | `accessPath` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5204` |
| 0.0% | 149us | 0.0% | 149us | `setName` | `node:fs` |
| 0.0% | 149us | 0.0% | 149us | `_identAt` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:751` |
| 0.0% | 149us | 0.0% | 149us | `/:([a-z-]+)\([^)]*\)/g` | `[native code]` |
| 0.0% | 149us | 0.0% | 149us | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3996` |
| 0.0% | 149us | 0.0% | 149us | `_makeToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:805` |
| 0.0% | 149us | 0.0% | 149us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1662` |
| 0.0% | 149us | 0.0% | 0us | `node:fs` | `node:fs:618` |
| 0.0% | 148us | 0.0% | 148us | `get start` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1094` |
| 0.0% | 148us | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:558` |
| 0.0% | 148us | 0.0% | 148us | `/^:[a-z-]+\s*/` | `[native code]` |
| 0.0% | 148us | 0.0% | 148us | `get nodeTags` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 148us | 0.0% | 148us | `Program:exit` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1727` |
| 0.0% | 148us | 0.0% | 148us | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 148us | 0.0% | 148us | `_ensureDeclSymIndex` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1598` |
| 0.0% | 148us | 0.0% | 148us | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4229` |
| 0.0% | 147us | 0.0% | 0us | `isStorableFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:581` |
| 0.0% | 147us | 0.0% | 147us | `get property` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1941` |
| 0.0% | 147us | 0.0% | 147us | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 147us | 0.0% | 147us | `_buildScope` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1645` |
| 0.0% | 146us | 0.0% | 146us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1238` |
| 0.0% | 146us | 0.0% | 146us | `_computeMinTok` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:529` |
| 0.0% | 146us | 0.0% | 146us | `_buildScopeChildren` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2331` |
| 0.0% | 146us | 0.0% | 146us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` |
| 0.0% | 146us | 0.0% | 146us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2578` |
| 0.0% | 146us | 0.0% | 0us | `getFirstToken` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:945` |
| 0.0% | 146us | 0.0% | 0us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2106` |
| 0.0% | 146us | 0.0% | 146us | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1182` |
| 0.0% | 145us | 0.0% | 0us | `getIdentifierIfShouldBeConst` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:221` |
| 0.0% | 145us | 0.0% | 145us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6459` |
| 0.0% | 145us | 0.0% | 145us | `getAssignedMessageData` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:310` |
| 0.0% | 145us | 0.0% | 145us | `ExportAllDeclaration > Identifier.exported,ExportSpecifier > Identifier.exported` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:398` |
| 0.0% | 145us | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:221` |
| 0.0% | 145us | 0.0% | 145us | `_getOrBuildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5441` |
| 0.0% | 144us | 0.0% | 144us | `_ensureTagCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5522` |
| 0.0% | 144us | 0.0% | 144us | `ImportDeclaration` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:372` |
| 0.0% | 144us | 0.0% | 144us | `_dispatchSeg` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6108` |
| 0.0% | 144us | 0.0% | 0us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6505` |
| 0.0% | 144us | 0.0% | 144us | `fullMethodName` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:56` |
| 0.0% | 144us | 0.0% | 144us | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js` |
| 0.0% | 143us | 0.0% | 143us | `checkGroup` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:475` |
| 0.0% | 143us | 0.0% | 143us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 143us | 0.0% | 143us | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6359` |
| 0.0% | 143us | 0.0% | 143us | `getTagNames` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:190` |
| 0.0% | 143us | 0.0% | 143us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 143us | 0.0% | 143us | `ensureVarsSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1798` |
| 0.0% | 143us | 0.0% | 0us | `isForInOfRef` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` |
| 0.0% | 143us | 0.0% | 0us | `checkReference` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:205` |
| 0.0% | 142us | 0.0% | 142us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 142us | 0.0% | 142us | `isImportAttributeKey` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:1422` |
| 0.0% | 142us | 0.0% | 142us | `getTokenBefore` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 142us | 0.0% | 142us | `_findDefNode` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` |
| 0.0% | 142us | 0.0% | 142us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4251` |
| 0.0% | 142us | 0.0% | 0us | `getRhsNode` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:561` |
| 0.0% | 142us | 0.0% | 142us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5249` |
| 0.0% | 142us | 0.0% | 0us | `_precomputeScopes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2443` |
| 0.0% | 141us | 0.0% | 141us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6752` |
| 0.0% | 141us | 0.0% | 141us | `_isStatementTag` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 141us | 0.0% | 141us | `create` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:76` |
| 0.0% | 141us | 0.0% | 141us | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2910` |
| 0.0% | 141us | 0.0% | 141us | `get computed` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 141us | 0.0% | 141us | `_loadFromDisk` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js` |
| 0.0% | 141us | 0.0% | 141us | `getDestructuringHost` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:107` |
| 0.0% | 141us | 0.0% | 141us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6625` |
| 0.0% | 141us | 0.0% | 0us | `_buildVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2661` |
| 0.0% | 140us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:428` |
| 0.0% | 140us | 0.0% | 0us | `get directive` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3342` |
| 0.0% | 140us | 0.0% | 0us | `referenceContainsTypeQuery` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:233` |
| 0.0% | 140us | 0.0% | 140us | `getTagNames` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js` |
| 0.0% | 139us | 0.0% | 139us | `isExternalDeclarationMerging` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:577` |
| 0.0% | 139us | 0.0% | 139us | `_buildScopeRefsAndThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2275` |
| 0.0% | 139us | 0.0% | 139us | `node:child_process` | `node:child_process:10` |
| 0.0% | 139us | 0.0% | 0us | `checkForShadows` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:660` |
| 0.0% | 139us | 0.0% | 139us | `get` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1887` |
| 0.0% | 138us | 0.0% | 138us | `isTypeValueShadow` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js` |
| 0.0% | 138us | 0.0% | 138us | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 137us | 0.0% | 137us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:222` |
| 0.0% | 137us | 0.0% | 137us | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4791` |
| 0.0% | 137us | 0.0% | 0us | `getIdentifierIfShouldBeConst` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:222` |
| 0.0% | 136us | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:475` |
| 0.0% | 136us | 0.0% | 136us | `_buildScopeVarsAndSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1969` |
| 0.0% | 136us | 0.0% | 136us | `isInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js` |
| 0.0% | 136us | 0.0% | 136us | `_buildSymNameCache` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:815` |
| 0.0% | 136us | 0.0% | 0us | `_buildThinVariable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2865` |
| 0.0% | 135us | 0.0% | 135us | `getIdentifierIfShouldBeConst` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:229` |
| 0.0% | 134us | 0.0% | 134us | `ensureRefsThrough` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 134us | 0.0% | 134us | `segment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4251` |
| 0.0% | 134us | 0.0% | 134us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7083` |
| 0.0% | 134us | 0.0% | 0us | `isAssignmentTarget` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:148` |

## Function Details

### `parse`
`[native code]` | Self: 5.8% (50.2ms) | Total: 5.8% (50.2ms) | Samples: 292

**Called by:**
- `parseSource` (276)
- `(anonymous)` (13)
- `tryParse` (3)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1998` | Self: 2.7% (23.5ms) | Total: 2.9% (24.8ms) | Samples: 137

**Called by:**
- `ensureVarsSet` (145)

**Calls:**
- `set` (8)

### `Uint32Array`
`[native code]` | Self: 2.5% (21.7ms) | Total: 2.5% (21.7ms) | Samples: 126

**Called by:**
- `AstView` (19)
- `AstView` (6)
- `CfgGraph` (4)
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
- `AstView` (2)
- `CfgGraph` (2)
- `AstView` (2)
- `CfgGraph` (2)
- `AstView` (2)
- `AstView` (2)
- `AstView` (2)
- `AstView` (2)
- `AstView` (2)
- `AstView` (2)
- `AstView` (2)
- `AstView` (2)
- `CfgGraph` (2)
- `CfgGraph` (2)
- `AstView` (2)
- `AstView` (2)
- `AstView` (1)
- `AstView` (1)
- `AstView` (1)
- `AstView` (1)
- `CfgGraph` (1)
- `AstView` (1)
- `CfgGraph` (1)
- `CfgGraph` (1)
- `AstView` (1)
- `AstView` (1)
- `CfgGraph` (1)
- `CfgGraph` (1)
- `AstView` (1)
- `AstView` (1)
- `CfgGraph` (1)
- `AstView` (1)
- `CfgGraph` (1)
- `AstView` (1)
- `AstView` (1)
- `CfgGraph` (1)
- `CfgGraph` (1)

### `_mkGlobalVar`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:587` | Self: 2.3% (19.9ms) | Total: 2.3% (19.9ms) | Samples: 116

**Called by:**
- `_buildScopeVarsAndSet` (116)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6826` | Self: 2.3% (19.7ms) | Total: 2.4% (21.0ms) | Samples: 112

**Called by:**
- `runPlugins` (119)

**Calls:**
- `add` (7)

### `anonymous`
`[native code]` | Self: 2.2% (19.5ms) | Total: 5.5% (47.9ms) | Samples: 115

**Called by:**
- `require` (241)
- `bound require` (21)
- `node:path` (6)
- `node:fs` (5)
- `internal:validators` (4)
- `internal:shared` (3)
- `node:fs` (1)
- `node:child_process` (1)
- `node:fs/promises` (1)

**Calls:**
- `(anonymous)` (40)
- `(anonymous)` (25)
- `(anonymous)` (16)
- `(anonymous)` (10)
- `(anonymous)` (7)
- `(anonymous)` (7)
- `(anonymous)` (6)
- `node:path` (6)
- `(anonymous)` (6)
- `node:fs` (5)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `internal:validators` (4)
- `(anonymous)` (3)
- `internal:shared` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:fs` (1)
- `(anonymous)` (1)
- `node:fs/promises` (1)
- `internal:validators` (1)
- `internal:primordials` (1)
- `(anonymous)` (1)
- `node:child_process` (1)
- `internal:primordials` (1)
- `node:fs` (1)
- `node:child_process` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5745` | Self: 2.1% (18.3ms) | Total: 2.1% (18.3ms) | Samples: 107

**Called by:**
- `_getOrBuildPlan` (107)

### `DataView`
`[native code]` | Self: 2.1% (18.2ms) | Total: 2.1% (18.2ms) | Samples: 116

**Called by:**
- `parseSource` (109)
- `AstView` (5)
- `parseSource` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6685` | Self: 1.7% (15.4ms) | Total: 1.7% (15.4ms) | Samples: 89

**Called by:**
- `runPlugins` (89)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6602` | Self: 1.7% (14.7ms) | Total: 1.8% (15.8ms) | Samples: 89

**Called by:**
- `runPlugins` (95)

**Calls:**
- `has` (6)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6759` | Self: 1.7% (14.6ms) | Total: 1.9% (16.3ms) | Samples: 83

**Called by:**
- `runPlugins` (93)

**Calls:**
- `get` (10)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5761` | Self: 1.5% (13.6ms) | Total: 1.5% (13.6ms) | Samples: 82

**Called by:**
- `_getOrBuildPlan` (82)

### `Set`
`[native code]` | Self: 1.1% (10.2ms) | Total: 1.1% (10.2ms) | Samples: 52

**Called by:**
- `_buildScope` (43)
- `_getOrBuildSelectorPlan` (5)
- `_extractFileLevelRules` (2)
- `getDeclaredVariables` (2)

### `_buildTemplate`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5804` | Self: 1.1% (9.7ms) | Total: 1.3% (11.3ms) | Samples: 56

**Called by:**
- `_buildPlan` (66)

**Calls:**
- `map` (6)
- `slotTemplate` (3)
- `slotTemplate` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5690` | Self: 1.0% (9.2ms) | Total: 1.1% (10.0ms) | Samples: 53

**Called by:**
- `_getOrBuildPlan` (58)

**Calls:**
- `get` (5)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5754` | Self: 1.0% (8.9ms) | Total: 1.0% (8.9ms) | Samples: 53

**Called by:**
- `_getOrBuildPlan` (53)

### `Uint8Array`
`[native code]` | Self: 1.0% (8.7ms) | Total: 1.0% (8.7ms) | Samples: 49

**Called by:**
- `AstView` (9)
- `_encodeSource` (4)
- `AstView` (4)
- `AstView` (4)
- `CfgGraph` (3)
- `AstView` (3)
- `AstView` (3)
- `walkNodes` (3)
- `walkNodes` (3)
- `walkNodes` (2)
- `CfgGraph` (2)
- `AstView` (2)
- `AstView` (2)
- `AstView` (1)
- `_getJsxTextTokFlags` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `_buildPlan` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5687` | Self: 1.0% (8.6ms) | Total: 1.1% (9.4ms) | Samples: 52

**Called by:**
- `_getOrBuildPlan` (57)

**Calls:**
- `next` (5)

### `some`
`[native code]` | Self: 1.0% (8.5ms) | Total: 2.7% (23.4ms) | Samples: 50

**Called by:**
- `collectUnusedVariables` (47)
- `isUsedVariable` (43)
- `walkNodes` (27)
- `collectUnusedVariables` (5)
- `hasRestSpreadSibling` (3)
- `getIdentifierIfShouldBeConst` (3)
- `_buildPlan` (2)
- `checkForShadows` (1)
- `some` (1)
- `getIdentifierIfShouldBeConst` (1)
- `checkReference` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)

**Calls:**
- `(anonymous)` (47)
- `(anonymous)` (16)
- `(anonymous)` (6)
- `(anonymous)` (4)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `some` (1)
- `(anonymous)` (1)
- `isOuterVariableInDestructing` (1)
- `includes` (1)
- `toLength` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `hasRestSibling` (1)

### `_buildTemplate`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5803` | Self: 0.9% (8.5ms) | Total: 1.1% (10.1ms) | Samples: 50

**Called by:**
- `_buildPlan` (58)

**Calls:**
- `slotTemplate` (3)
- `map` (3)
- `slotTemplate` (1)
- `slotTemplate` (1)

### `defineProperties`
`[native code]` | Self: 0.9% (8.1ms) | Total: 0.9% (8.1ms) | Samples: 49

**Called by:**
- `_buildScope` (49)

### `indexOf`
`[native code]` | Self: 0.8% (7.4ms) | Total: 0.8% (7.4ms) | Samples: 44

**Called by:**
- `_buildPlan` (15)
- `walkNodes` (11)
- `walkNodes` (7)
- `walkNodes` (4)
- `_buildPlan` (2)
- `getNameLocationInGlobalDirectiveComment` (2)
- `_getOrBuildSelectorPlan` (2)
- `_buildPlan` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4176` | Self: 0.8% (7.3ms) | Total: 0.8% (7.3ms) | Samples: 11

**Called by:**
- `AstView` (11)

### `_buildTemplate`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5800` | Self: 0.7% (6.5ms) | Total: 0.7% (6.5ms) | Samples: 33

**Called by:**
- `_buildPlan` (33)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4837` | Self: 0.7% (6.3ms) | Total: 0.7% (6.3ms) | Samples: 38

**Called by:**
- `_buildPlan` (38)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6732` | Self: 0.6% (5.6ms) | Total: 0.6% (5.6ms) | Samples: 32

**Called by:**
- `runPlugins` (32)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3890` | Self: 0.6% (5.5ms) | Total: 0.6% (5.5ms) | Samples: 32

**Called by:**
- `runPlugins` (32)

### `get`
`[native code]` | Self: 0.6% (5.4ms) | Total: 0.6% (5.4ms) | Samples: 32

**Called by:**
- `walkNodes` (10)
- `walkNodes` (5)
- `_buildPlan` (5)
- `_buildPlan` (3)
- `walkNodes` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildPlan` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `runOnce` (1)
- `getDeclaredVariables` (1)
- `walkNodes` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5714` | Self: 0.6% (5.2ms) | Total: 0.6% (5.2ms) | Samples: 30

**Called by:**
- `_getOrBuildPlan` (30)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4839` | Self: 0.6% (5.2ms) | Total: 0.6% (5.2ms) | Samples: 31

**Called by:**
- `_buildPlan` (31)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5697` | Self: 0.6% (5.2ms) | Total: 0.6% (5.4ms) | Samples: 32

**Called by:**
- `_getOrBuildPlan` (33)

**Calls:**
- `indexOf` (1)

### `_getSelectorRootTypes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5557` | Self: 0.5% (4.7ms) | Total: 0.5% (4.7ms) | Samples: 28

**Called by:**
- `_getSelectorRootTypes` (19)
- `_buildPlan` (6)
- `_getOrBuildSelectorPlan` (3)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:505` | Self: 0.5% (4.7ms) | Total: 0.5% (4.7ms) | Samples: 28

**Called by:**
- `parseSource` (28)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1995` | Self: 0.5% (4.5ms) | Total: 0.6% (5.8ms) | Samples: 27

**Called by:**
- `ensureVarsSet` (35)

**Calls:**
- `toString` (8)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6733` | Self: 0.4% (4.1ms) | Total: 0.4% (4.1ms) | Samples: 24

**Called by:**
- `runPlugins` (24)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6818` | Self: 0.4% (4.1ms) | Total: 0.4% (4.1ms) | Samples: 22

**Called by:**
- `runPlugins` (22)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4842` | Self: 0.4% (4.0ms) | Total: 0.5% (5.0ms) | Samples: 23

**Called by:**
- `_buildPlan` (29)

**Calls:**
- `next` (6)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:121` | Self: 0.4% (4.0ms) | Total: 0.4% (4.0ms) | Samples: 22

**Called by:**
- `buildVisitorMap` (22)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5647` | Self: 0.4% (4.0ms) | Total: 0.4% (4.0ms) | Samples: 21

**Called by:**
- `_getOrBuildPlan` (21)

### `stringSplitFast`
`[native code]` | Self: 0.4% (3.9ms) | Total: 0.4% (3.9ms) | Samples: 23

**Called by:**
- `_getSelectorRootTypes` (18)
- `_compileAttrCheck` (3)
- `_buildScopeVarsAndSet` (1)
- `_isSelector` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6731` | Self: 0.4% (3.8ms) | Total: 0.4% (3.8ms) | Samples: 24

**Called by:**
- `runPlugins` (24)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1613` | Self: 0.4% (3.8ms) | Total: 0.4% (3.8ms) | Samples: 22

**Called by:**
- `_buildScopeVarsAndSet` (14)
- `getDeclaredVariables` (8)

### `get _tag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1072` | Self: 0.4% (3.6ms) | Total: 0.4% (3.6ms) | Samples: 22

**Called by:**
- `get parent` (7)
- `get parent` (5)
- `get name` (2)
- `get body` (2)
- `_findDefNode` (1)
- `get init` (1)
- `_findDefNode` (1)
- `get right` (1)
- `get computed` (1)
- `get parent` (1)

### `_extractBatchScannable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4641` | Self: 0.4% (3.6ms) | Total: 0.4% (3.6ms) | Samples: 20

**Called by:**
- `_buildPlan` (20)

### `has`
`[native code]` | Self: 0.3% (3.4ms) | Total: 0.3% (3.4ms) | Samples: 20

**Called by:**
- `walkNodes` (6)
- `walkNodes` (4)
- `_buildScopeVarsAndSet` (2)
- `walkNodes` (1)
- `_buildPlan` (1)
- `_extractFileLevelRules` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `_extractBatchScannable` (1)
- `walkNodes` (1)
- `walkNodes` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6610` | Self: 0.3% (3.2ms) | Total: 0.4% (3.4ms) | Samples: 15

**Called by:**
- `runPlugins` (16)

**Calls:**
- `Uint8Array` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3994` | Self: 0.3% (3.2ms) | Total: 0.4% (3.5ms) | Samples: 20

**Called by:**
- `_buildReference` (4)
- `_nodesFromRange` (3)
- `walkNodes` (2)
- `walkNodes` (2)
- `_buildThinVariable` (1)
- `(anonymous)` (1)
- `_buildVariable` (1)
- `walkNodes` (1)
- `_buildScope` (1)
- `getArrayMethodName` (1)
- `fn` (1)
- `get body` (1)
- `get body` (1)
- `get parent` (1)
- `_fireCfgEvents` (1)

**Calls:**
- `_getTypeProto` (1)
- `_getTypeProto` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1644` | Self: 0.3% (3.2ms) | Total: 0.3% (3.2ms) | Samples: 19

**Called by:**
- `_precomputeScopes` (8)
- `_buildScopeChildren` (4)
- `Program:exit` (3)
- `_buildScope` (2)
- `Program:exit` (1)
- `checkForBlock` (1)

### `next`
`[native code]` | Self: 0.3% (3.1ms) | Total: 0.6% (5.5ms) | Samples: 19

**Called by:**
- `findVariablesInScope` (13)
- `_extractFileLevelRules` (6)
- `_buildPlan` (5)
- `walkNodes` (4)
- `performIteration` (2)
- `isAnySegmentReachable` (1)
- `(anonymous)` (1)

**Calls:**
- `generatorResume` (13)

### `add`
`[native code]` | Self: 0.3% (3.0ms) | Total: 0.3% (3.0ms) | Samples: 17

**Called by:**
- `walkNodes` (7)
- `_extractFileLevelRules` (6)
- `_extractFileLevelRules` (4)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5731` | Self: 0.3% (2.9ms) | Total: 0.3% (2.9ms) | Samples: 18

**Called by:**
- `_getOrBuildPlan` (18)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1006` | Self: 0.3% (2.9ms) | Total: 0.3% (2.9ms) | Samples: 18

**Called by:**
- `_buildScopeRefsAndThrough` (4)
- `fn` (3)
- `(anonymous)` (2)
- `collectUnusedVariables` (2)
- `isFunctionNameInitializerException` (1)
- `isSpecificId` (1)
- `getIdentifierIfShouldBeConst` (1)
- `skipChainExpression` (1)
- `isForInOfRef` (1)
- `isFunction` (1)
- `getStaticPropertyName` (1)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4838` | Self: 0.3% (2.8ms) | Total: 0.4% (3.6ms) | Samples: 17

**Called by:**
- `_buildPlan` (21)

**Calls:**
- `add` (4)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:804` | Self: 0.3% (2.8ms) | Total: 0.3% (2.8ms) | Samples: 17

**Called by:**
- `Program:exit` (17)

### `_extractBatchScannable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4661` | Self: 0.3% (2.7ms) | Total: 0.3% (2.7ms) | Samples: 17

**Called by:**
- `_buildPlan` (17)

### `entries`
`[native code]` | Self: 0.3% (2.7ms) | Total: 0.3% (2.7ms) | Samples: 17

**Called by:**
- `buildVisitorMap` (14)
- `_applySchemaDefaults` (2)
- `performIteration` (1)

### `_mkGlobalVar`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.3% (2.7ms) | Total: 0.3% (2.7ms) | Samples: 17

**Called by:**
- `_buildScopeVarsAndSet` (17)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4252` | Self: 0.3% (2.6ms) | Total: 0.3% (2.8ms) | Samples: 15

**Called by:**
- `runPlugins` (16)

**Calls:**
- `set` (1)

### `map`
`[native code]` | Self: 0.3% (2.6ms) | Total: 0.9% (7.9ms) | Samples: 16

**Called by:**
- `_deepMergeArrays` (18)
- `_buildTemplate` (6)
- `_isSelector` (4)
- `_expandUnion` (3)
- `_buildTemplate` (3)
- `_compileSelectorFastMatcher` (3)
- `_buildTemplate` (2)
- `_compileSelectorFastMatcher` (2)
- `buildVisitorMap` (1)
- `getIdentifierIfShouldBeConst` (1)
- `_buildTemplate` (1)
- `getIdentifierIfShouldBeConst` (1)
- `hasRestSibling` (1)
- `getIdentifierIfShouldBeConst` (1)

**Calls:**
- `_compileAttrCheck` (5)
- `(anonymous)` (5)
- `_deepMergeObjects` (5)
- `_deepMergeObjects` (5)
- `trim` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `_deepMergeObjects` (1)
- `(anonymous)` (1)
- `_deepMergeObjects` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.3% (2.5ms) | Total: 0.3% (2.5ms) | Samples: 14

**Called by:**
- `_buildReference` (8)
- `_buildReference` (2)
- `_findDefNode` (2)
- `getUpperFunction` (1)
- `isInLoop` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6865` | Self: 0.3% (2.5ms) | Total: 0.3% (2.7ms) | Samples: 15

**Called by:**
- `runPlugins` (16)

**Calls:**
- `get allSkipped` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4176` | Self: 0.2% (2.5ms) | Total: 0.3% (2.7ms) | Samples: 13

**Called by:**
- `runPlugins` (14)

**Calls:**
- `Map` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1285` | Self: 0.2% (2.5ms) | Total: 0.3% (3.0ms) | Samples: 15

**Called by:**
- `_buildThinVariable` (5)
- `isInLoop` (4)
- `_findDefNode` (3)
- `_buildReference` (1)
- `_computeIsStrict` (1)
- `_computeIsStrict` (1)
- `isModifyingProp` (1)
- `_findDefNode` (1)
- `isInitOfForStatement` (1)

**Calls:**
- `get _tag` (3)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4005` | Self: 0.2% (2.4ms) | Total: 0.2% (2.4ms) | Samples: 14

**Called by:**
- `get parent` (6)
- `walkNodes` (2)
- `_nodesFromRange` (2)
- `walkNodes` (2)
- `_fireCfgEvents` (1)
- `_buildVariable` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.2% (2.3ms) | Total: 0.2% (2.3ms) | Samples: 14

**Called by:**
- `isFunction` (4)
- `_buildReference` (3)
- `_execReport` (2)
- `_computeIsStrict` (1)
- `getRhsNode` (1)
- `(anonymous)` (1)
- `isInitOfForStatement` (1)
- `getDestructuringHost` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6529` | Self: 0.2% (2.2ms) | Total: 0.3% (2.7ms) | Samples: 11

**Called by:**
- `runPlugins` (14)

**Calls:**
- `Uint8Array` (3)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4823` | Self: 0.2% (2.2ms) | Total: 0.2% (2.2ms) | Samples: 13

**Called by:**
- `_buildPlan` (13)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5889` | Self: 0.2% (2.2ms) | Total: 0.2% (2.2ms) | Samples: 13

**Called by:**
- `runPlugins` (13)

### `get _tag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.2% (2.2ms) | Total: 0.2% (2.2ms) | Samples: 12

**Called by:**
- `get parent` (3)
- `get parent` (3)
- `get parent` (3)
- `get init` (1)
- `get parent` (1)
- `get parent` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5710` | Self: 0.2% (2.2ms) | Total: 0.2% (2.2ms) | Samples: 13

**Called by:**
- `_getOrBuildPlan` (13)

### `_applySchemaDefaults`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:170` | Self: 0.2% (2.2ms) | Total: 0.2% (2.5ms) | Samples: 13

**Called by:**
- `buildVisitorMap` (15)

**Calls:**
- `entries` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:959` | Self: 0.2% (2.1ms) | Total: 0.3% (3.1ms) | Samples: 13

**Called by:**
- `Program:exit` (19)

**Calls:**
- `hasRestSpreadSibling` (5)
- `hasRestSpreadSibling` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3986` | Self: 0.2% (2.1ms) | Total: 0.2% (2.1ms) | Samples: 13

**Called by:**
- `get parent` (2)
- `_buildReference` (2)
- `_nodesFromRange` (1)
- `checkGroup` (1)
- `isEvaluatedDuringInitialization` (1)
- `invokeSelectorHandlers` (1)
- `_buildVariable` (1)
- `walkNodes` (1)
- `_buildScope` (1)
- `_buildThinScope` (1)
- `getArrayMethodName` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5641` | Self: 0.2% (2.0ms) | Total: 0.2% (2.0ms) | Samples: 12

**Called by:**
- `_getOrBuildPlan` (12)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:464` | Self: 0.2% (2.0ms) | Total: 0.5% (4.5ms) | Samples: 12

**Called by:**
- `isUsedVariable` (26)

**Calls:**
- `forEach` (14)

### `_buildTemplate`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5810` | Self: 0.2% (2.0ms) | Total: 0.6% (5.2ms) | Samples: 12

**Called by:**
- `_buildPlan` (31)

**Calls:**
- `performIteration` (12)
- `Map` (5)
- `map` (2)

### `filter`
`[native code]` | Self: 0.2% (2.0ms) | Total: 0.3% (3.3ms) | Samples: 12

**Called by:**
- `runOnce` (7)
- `checkReferencesInScope` (6)
- `_compileSelectorFastMatcher` (5)
- `getIdentifierIfShouldBeConst` (1)
- `Program:exit` (1)

**Calls:**
- `shouldCheck` (2)
- `shouldCheck` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `shouldCheck` (1)
- `shouldCheck` (1)

### `_extractBatchScannable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4635` | Self: 0.2% (2.0ms) | Total: 0.2% (2.0ms) | Samples: 11

**Called by:**
- `_buildPlan` (11)

### `getFunctionDefinitions`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:462` | Self: 0.2% (1.9ms) | Total: 0.2% (1.9ms) | Samples: 10

**Called by:**
- `isUsedVariable` (10)

### `decode`
`[native code]` | Self: 0.2% (1.9ms) | Total: 0.2% (1.9ms) | Samples: 12

**Called by:**
- `get source` (12)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6412` | Self: 0.2% (1.9ms) | Total: 0.2% (1.9ms) | Samples: 11

**Called by:**
- `runPlugins` (11)

### `_getSelectorRootTypes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5600` | Self: 0.2% (1.8ms) | Total: 0.2% (2.2ms) | Samples: 10

**Called by:**
- `_getSelectorRootTypes` (9)
- `_buildPlan` (3)

**Calls:**
- `/^:[a-z-]+\s*/` (1)
- `trim` (1)

### `performIteration`
`[native code]` | Self: 0.2% (1.8ms) | Total: 0.2% (2.3ms) | Samples: 11

**Called by:**
- `_buildTemplate` (12)
- `_precomputeScopes` (2)

**Calls:**
- `next` (2)
- `entries` (1)

### `generatorResume`
`[native code]` | Self: 0.2% (1.8ms) | Total: 0.5% (4.4ms) | Samples: 10

**Called by:**
- `next` (13)
- `findVariablesInScope` (12)

**Calls:**
- `iterateDeclarations` (4)
- `iterateDeclarations` (3)
- `iterateDeclarations` (3)
- `iterateDeclarations` (2)
- `iterateDeclarations` (2)
- `iterateDeclarations` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6570` | Self: 0.2% (1.8ms) | Total: 0.2% (1.8ms) | Samples: 11

**Called by:**
- `runPlugins` (11)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1954` | Self: 0.2% (1.8ms) | Total: 0.2% (1.8ms) | Samples: 10

**Called by:**
- `ensureVarsSet` (10)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1684` | Self: 0.2% (1.8ms) | Total: 0.2% (1.8ms) | Samples: 11

**Called by:**
- `_invokeFused` (11)

### `trim`
`[native code]` | Self: 0.2% (1.8ms) | Total: 0.2% (1.8ms) | Samples: 11

**Called by:**
- `map` (2)
- `_getSelectorRootTypes` (2)
- `_getSelectorRootTypes` (2)
- `_getSelectorRootTypes` (2)
- `_getSelectorRootTypes` (1)
- `_getSelectorRootTypes` (1)
- `_buildScopeVarsAndSet` (1)

### `_extractBatchScannable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4637` | Self: 0.2% (1.7ms) | Total: 0.2% (1.7ms) | Samples: 11

**Called by:**
- `_buildPlan` (11)

### `_extractBatchScannable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4666` | Self: 0.2% (1.7ms) | Total: 0.2% (1.7ms) | Samples: 10

**Called by:**
- `_buildPlan` (10)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6533` | Self: 0.1% (1.6ms) | Total: 0.2% (1.8ms) | Samples: 10

**Called by:**
- `runPlugins` (11)

**Calls:**
- `has` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4006` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 10

**Called by:**
- `get parent` (4)
- `_buildReference` (2)
- `walkNodes` (1)
- `walkNodes` (1)
- `_buildScope` (1)
- `_nodesFromRange` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6633` | Self: 0.1% (1.6ms) | Total: 0.2% (2.3ms) | Samples: 10

**Called by:**
- `runPlugins` (14)

**Calls:**
- `next` (4)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:92` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 10

**Called by:**
- `buildVisitorMap` (10)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1222` | Self: 0.1% (1.6ms) | Total: 0.4% (3.5ms) | Samples: 10

**Called by:**
- `_findDefNode` (6)
- `_computeIsStrict` (4)
- `_buildReference` (2)
- `getArrayMethodName` (2)
- `_buildThinVariable` (2)
- `isInLoop` (2)
- `isUnusedExpression` (1)
- `isForInOfRef` (1)

**Calls:**
- `get _tag` (7)
- `get _tag` (3)

### `_isSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4033` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 9

**Called by:**
- `buildVisitorMap` (9)

### `_isSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4029` | Self: 0.1% (1.6ms) | Total: 0.1% (1.6ms) | Samples: 10

**Called by:**
- `buildVisitorMap` (10)

### `findVariablesInScope`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:95` | Self: 0.1% (1.5ms) | Total: 0.7% (6.3ms) | Samples: 10

**Called by:**
- `Program` (35)
- `checkForBlock` (2)

**Calls:**
- `next` (13)
- `generatorResume` (12)
- `[Symbol.iterator]` (2)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:510` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 9

**Called by:**
- `get type` (4)
- `_buildSymNameCache` (2)
- `_buildScopeVarsAndSet` (1)
- `_identAt` (1)
- `_buildScopeVarsAndSet` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6538` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 9

**Called by:**
- `runPlugins` (9)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5712` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 9

**Called by:**
- `_getOrBuildPlan` (9)

### `set`
`[native code]` | Self: 0.1% (1.5ms) | Total: 0.1% (1.5ms) | Samples: 9

**Called by:**
- `_buildScopeVarsAndSet` (8)
- `buildVisitorMap` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5901` | Self: 0.1% (1.4ms) | Total: 0.2% (2.2ms) | Samples: 9

**Called by:**
- `runPlugins` (13)

**Calls:**
- `get nodeTags` (3)
- `get nodeTags` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5735` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 9

**Called by:**
- `_getOrBuildPlan` (9)

### `Map`
`[native code]` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 9

**Called by:**
- `_buildTemplate` (5)
- `ensureVarsSet` (2)
- `buildVisitorMap` (1)
- `_extractBatchScannable` (1)

### `endsWith`
`[native code]` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 9

**Called by:**
- `_buildPlan` (3)
- `_isSelector` (3)
- `_getSelectorRootTypes` (2)
- `_expandUnion` (1)

### `runOnce`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:95` | Self: 0.1% (1.4ms) | Total: 0.1% (1.4ms) | Samples: 8

**Called by:**
- `(anonymous)` (8)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1189` | Self: 0.1% (1.3ms) | Total: 0.7% (6.0ms) | Samples: 8

**Called by:**
- `_buildReference` (11)
- `_findDefNode` (7)
- `isInLoop` (3)
- `_findDefNode` (3)
- `_buildThinVariable` (2)
- `_buildVariable` (2)
- `_computeIsStrict` (2)
- `_findDefNode` (2)
- `canBecomeVariableDeclaration` (1)
- `_findDefNode` (1)
- `unwrapExpression` (1)
- `isImportAttributeKey` (1)

**Calls:**
- `_nodeViewRaw` (6)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `nodeView` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `nodeView` (1)
- `nodeView` (1)
- `_nodeViewRaw` (1)

### `/^_+\|_+$/gu`
`[native code]` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 7

**Called by:**
- `isUnderscored` (7)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6541` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 8

**Called by:**
- `runPlugins` (8)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6735` | Self: 0.1% (1.3ms) | Total: 0.6% (5.9ms) | Samples: 8

**Called by:**
- `runPlugins` (35)

**Calls:**
- `some` (27)

### `dlopen`
`[native code]` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 8

**Called by:**
- `dlopen` (5)
- `(anonymous)` (3)

### `_expandUnion`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4044` | Self: 0.1% (1.3ms) | Total: 0.1% (1.5ms) | Samples: 8

**Called by:**
- `buildVisitorMap` (9)

**Calls:**
- `includes` (1)

### `_getSelectorRootTypes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5564` | Self: 0.1% (1.3ms) | Total: 0.1% (1.6ms) | Samples: 8

**Called by:**
- `_getOrBuildSelectorPlan` (7)
- `_buildPlan` (3)

**Calls:**
- `trim` (2)

### `toString`
`[native code]` | Self: 0.1% (1.3ms) | Total: 0.1% (1.4ms) | Samples: 8

**Called by:**
- `_buildScopeVarsAndSet` (8)
- `getVariableDescription` (1)

**Calls:**
- `get flags` (1)

### `fill`
`[native code]` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 8

**Called by:**
- `runPlugins` (5)
- `CfgGraph` (2)
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6969` | Self: 0.1% (1.3ms) | Total: 0.1% (1.3ms) | Samples: 7

**Called by:**
- `runPlugins` (7)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5649` | Self: 0.1% (1.2ms) | Total: 0.1% (1.2ms) | Samples: 8

**Called by:**
- `_getOrBuildPlan` (8)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4845` | Self: 0.1% (1.2ms) | Total: 0.2% (2.3ms) | Samples: 8

**Called by:**
- `_buildPlan` (14)

**Calls:**
- `add` (6)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (1.2ms) | Total: 0.1% (1.2ms) | Samples: 7

**Called by:**
- `_buildPlan` (7)

### `getFunctionHeadLoc`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2312` | Self: 0.1% (1.2ms) | Total: 0.1% (1.2ms) | Samples: 6

**Called by:**
- `checkLastSegment` (6)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4032` | Self: 0.1% (1.2ms) | Total: 0.1% (1.2ms) | Samples: 7

**Called by:**
- `walkNodes` (2)
- `_buildThinVariable` (1)
- `_buildReference` (1)
- `_fireCfgEvents` (1)
- `get parent` (1)
- `_nodesFromRange` (1)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:747` | Self: 0.1% (1.2ms) | Total: 0.1% (1.4ms) | Samples: 7

**Called by:**
- `get name` (8)

**Calls:**
- `get source` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6949` | Self: 0.1% (1.2ms) | Total: 0.1% (1.2ms) | Samples: 6

**Called by:**
- `runPlugins` (6)

### `slice`
`[native code]` | Self: 0.1% (1.2ms) | Total: 0.1% (1.2ms) | Samples: 7

**Called by:**
- `_deepMergeArrays` (4)
- `getDeclaredVariables` (2)
- `_applySchemaDefaults` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6416` | Self: 0.1% (1.2ms) | Total: 0.1% (1.2ms) | Samples: 7

**Called by:**
- `runPlugins` (7)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1968` | Self: 0.1% (1.1ms) | Total: 0.1% (1.1ms) | Samples: 7

**Called by:**
- `ensureVarsSet` (7)

### `regExpMatchFast`
`[native code]` | Self: 0.1% (1.1ms) | Total: 0.1% (1.1ms) | Samples: 7

**Called by:**
- `_buildScopeVarsAndSet` (6)
- `_buildScopeVarsAndSet` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1013` | Self: 0.1% (1.1ms) | Total: 0.2% (1.8ms) | Samples: 5

**Called by:**
- `isFunction` (3)
- `isNullLiteral` (1)
- `_findDefNode` (1)
- `referenceContainsTypeQuery` (1)
- `fn` (1)
- `isSpecificId` (1)
- `_execReport` (1)

**Calls:**
- `get source` (4)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3804` | Self: 0.1% (1.1ms) | Total: 0.7% (6.5ms) | Samples: 5

**Called by:**
- `Program:exit` (10)
- `(anonymous)` (7)
- `(anonymous)` (5)
- `report` (3)
- `checkReference` (2)
- `checkForShadows` (2)
- `checkLastSegment` (2)
- `report` (2)
- `ReturnStatement` (2)
- `checkReference` (1)

**Calls:**
- `_execReport` (14)
- `_execReport` (3)
- `_execReport` (3)
- `_execReport` (2)
- `_execReport` (2)
- `_execReport` (1)
- `_execReport` (1)
- `_execReport` (1)
- `_execReport` (1)
- `_execReport` (1)
- `_execReport` (1)
- `_execReport` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:490` | Self: 0.1% (1.1ms) | Total: 0.1% (1.1ms) | Samples: 7

**Called by:**
- `parseSource` (7)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4002` | Self: 0.1% (1.1ms) | Total: 0.1% (1.1ms) | Samples: 6

**Called by:**
- `get parent` (2)
- `_nodesFromRange` (2)
- `_buildScope` (1)
- `get arguments` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2099` | Self: 0.1% (1.0ms) | Total: 0.1% (1.2ms) | Samples: 6

**Called by:**
- `ensureVarsSet` (7)

**Calls:**
- `get source` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5716` | Self: 0.1% (1.0ms) | Total: 0.1% (1.0ms) | Samples: 6

**Called by:**
- `_getOrBuildPlan` (6)

### `_extractBatchScannable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4656` | Self: 0.1% (1.0ms) | Total: 0.1% (1.0ms) | Samples: 7

**Called by:**
- `_buildPlan` (7)

### `nodeLhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:528` | Self: 0.1% (1.0ms) | Total: 0.1% (1.0ms) | Samples: 6

**Called by:**
- `get id` (1)
- `get declarations` (1)
- `get init` (1)
- `get right` (1)
- `get directive` (1)
- `get body` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1679` | Self: 0.1% (1.0ms) | Total: 4.8% (41.2ms) | Samples: 6

**Called by:**
- `_invokeFused` (239)

**Calls:**
- `collectUnusedVariables` (117)
- `collectUnusedVariables` (34)
- `collectUnusedVariables` (19)
- `collectUnusedVariables` (18)
- `collectUnusedVariables` (17)
- `collectUnusedVariables` (8)
- `collectUnusedVariables` (6)
- `collectUnusedVariables` (3)
- `collectUnusedVariables` (3)
- `collectUnusedVariables` (2)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4232` | Self: 0.1% (1.0ms) | Total: 0.3% (3.3ms) | Samples: 5

**Called by:**
- `runPlugins` (19)

**Calls:**
- `entries` (14)

### `get mainToken`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1089` | Self: 0.1% (1.0ms) | Total: 0.1% (1.0ms) | Samples: 6

**Called by:**
- `get name` (3)
- `get static` (1)
- `get value` (1)
- `get decorators` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1330` | Self: 0.1% (1.0ms) | Total: 0.1% (1.0ms) | Samples: 6

**Called by:**
- `_buildScopeRefsAndThrough` (2)
- `isSpecificId` (2)
- `_buildScopeRefsAndThrough` (1)
- `checkReference` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4192` | Self: 0.1% (1.0ms) | Total: 0.1% (1.0ms) | Samples: 5

**Called by:**
- `runPlugins` (5)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1038` | Self: 0.1% (1.0ms) | Total: 0.1% (1.0ms) | Samples: 6

**Called by:**
- `isFunction` (2)
- `isSpecificMemberAccess` (1)
- `fn` (1)
- `_buildReference` (1)
- `isModifyingProp` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7082` | Self: 0.1% (1.0ms) | Total: 0.1% (1.0ms) | Samples: 6

**Called by:**
- `runPlugins` (6)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1175` | Self: 0.1% (1.0ms) | Total: 0.1% (1.0ms) | Samples: 6

**Called by:**
- `_buildVariable` (2)
- `_buildReference` (1)
- `_precomputeScopes` (1)
- `_buildThinVariable` (1)
- `isInLoop` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1999` | Self: 0.1% (1.0ms) | Total: 0.1% (1.7ms) | Samples: 6

**Called by:**
- `ensureVarsSet` (10)

**Calls:**
- `push` (4)

### `getUint32`
`[native code]` | Self: 0.1% (1.0ms) | Total: 0.1% (1.0ms) | Samples: 6

**Called by:**
- `AstView` (1)
- `AstView` (1)
- `get init` (1)
- `AstView` (1)
- `AstView` (1)
- `get callee` (1)

### `_getSelectorRootTypes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5591` | Self: 0.1% (1.0ms) | Total: 0.1% (1.3ms) | Samples: 6

**Called by:**
- `_getSelectorRootTypes` (7)
- `_buildPlan` (1)

**Calls:**
- `trim` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1884` | Self: 0.1% (997us) | Total: 1.0% (9.1ms) | Samples: 6

**Called by:**
- `_precomputeScopes` (29)
- `_buildScopeChildren` (26)

**Calls:**
- `defineProperties` (49)

### `isFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:152` | Self: 0.1% (985us) | Total: 0.4% (3.8ms) | Samples: 6

**Called by:**
- `isInLoop` (21)

**Calls:**
- `get type` (4)
- `get type` (3)
- `get type` (2)
- `/^(?:Function(?:Declaration\|Expression)\|ArrowFunctionExpression)$/u` (2)
- `get type` (1)
- `get type` (1)
- `get type` (1)
- `get type` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:961` | Self: 0.1% (984us) | Total: 0.1% (984us) | Samples: 6

**Called by:**
- `Program:exit` (6)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5915` | Self: 0.1% (982us) | Total: 0.1% (982us) | Samples: 6

**Called by:**
- `runPlugins` (6)

### `isUnderscored`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:101` | Self: 0.1% (978us) | Total: 0.2% (2.3ms) | Samples: 6

**Called by:**
- `isGoodName` (13)

**Calls:**
- `/^_+\|_+$/gu` (7)

### `includes`
`[native code]` | Self: 0.1% (976us) | Total: 0.1% (976us) | Samples: 5

**Called by:**
- `buildVisitorMap` (2)
- `_expandUnion` (1)
- `some` (1)
- `buildVisitorMap` (1)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2893` | Self: 0.1% (975us) | Total: 0.3% (3.3ms) | Samples: 6

**Called by:**
- `_buildReference` (15)
- `_buildThinScope` (2)
- `_buildVariable` (1)

**Calls:**
- `get parent` (5)
- `get parent` (2)
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5730` | Self: 0.1% (974us) | Total: 0.1% (974us) | Samples: 6

**Called by:**
- `_getOrBuildPlan` (6)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2874` | Self: 0.1% (974us) | Total: 0.4% (4.0ms) | Samples: 6

**Called by:**
- `_buildReference` (22)
- `_buildThinScope` (2)

**Calls:**
- `_buildThinScope` (12)
- `_buildThinScope` (2)
- `_buildThinScope` (1)
- `_buildThinScope` (1)
- `_buildThinScope` (1)
- `_buildThinScope` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5642` | Self: 0.1% (968us) | Total: 0.1% (968us) | Samples: 6

**Called by:**
- `_getOrBuildPlan` (6)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4001` | Self: 0.1% (954us) | Total: 0.1% (954us) | Samples: 6

**Called by:**
- `get parent` (3)
- `_buildVariable` (1)
- `_buildThinVariable` (1)
- `walkNodes` (1)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:809` | Self: 0.1% (940us) | Total: 0.1% (1.3ms) | Samples: 6

**Called by:**
- `_symName` (8)

**Calls:**
- `get source` (2)

### `test`
`[native code]` | Self: 0.1% (938us) | Total: 0.1% (938us) | Samples: 5

**Called by:**
- `_buildScopeVarsAndSet` (3)
- `collectUnusedVariables` (1)
- `isLoop` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3991` | Self: 0.1% (933us) | Total: 0.1% (933us) | Samples: 6

**Called by:**
- `get parent` (3)
- `walkNodes` (1)
- `getAncestorsFor` (1)
- `_fireCfgEvents` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (924us) | Total: 0.1% (924us) | Samples: 5

**Called by:**
- `runPlugins` (5)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4256` | Self: 0.1% (899us) | Total: 0.1% (899us) | Samples: 5

**Called by:**
- `runPlugins` (5)

### `nodeRhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:533` | Self: 0.1% (895us) | Total: 0.1% (895us) | Samples: 5

**Called by:**
- `get property` (2)
- `get expressions` (1)
- `get body` (1)
- `get value` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4214` | Self: 0.1% (887us) | Total: 0.2% (2.1ms) | Samples: 5

**Called by:**
- `runPlugins` (13)

**Calls:**
- `describeRule` (6)
- `describeRule` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2060` | Self: 0.1% (880us) | Total: 0.1% (1.4ms) | Samples: 5

**Called by:**
- `ensureVarsSet` (8)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (2)
- `exec` (1)

### `/\r?\n/`
`[native code]` | Self: 0.1% (879us) | Total: 0.1% (879us) | Samples: 5

**Called by:**
- `regExpSplitFast` (5)

### `Uint16Array`
`[native code]` | Self: 0.1% (874us) | Total: 0.1% (874us) | Samples: 5

**Called by:**
- `AstView` (3)
- `AstView` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2579` | Self: 0.1% (871us) | Total: 0.1% (1.6ms) | Samples: 5

**Called by:**
- `getDeclaredVariables` (5)
- `_buildScopeVarsAndSet` (5)

**Calls:**
- `_buildThinScope` (4)
- `_buildThinScope` (1)

### `push`
`[native code]` | Self: 0.1% (866us) | Total: 0.1% (866us) | Samples: 5

**Called by:**
- `_buildScopeVarsAndSet` (4)
- `getFunctionNameWithKind` (1)

### `_expandUnion`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4043` | Self: 0.0% (856us) | Total: 0.0% (856us) | Samples: 5

**Called by:**
- `buildVisitorMap` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` | Self: 0.0% (852us) | Total: 0.0% (852us) | Samples: 5

**Called by:**
- `(anonymous)` (3)
- `ke` (1)
- `reduce` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1380` | Self: 0.0% (844us) | Total: 0.0% (844us) | Samples: 5

**Called by:**
- `_buildScope` (1)
- `_findDefNode` (1)
- `isNullLiteral` (1)
- `(anonymous)` (1)
- `areLiteralsAndSameType` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1612` | Self: 0.0% (844us) | Total: 0.0% (844us) | Samples: 5

**Called by:**
- `_buildScopeVarsAndSet` (4)
- `getDeclaredVariables` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2979` | Self: 0.0% (842us) | Total: 0.0% (842us) | Samples: 5

**Called by:**
- `_buildVariable` (4)
- `_buildThinVariable` (1)

### `isLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:168` | Self: 0.0% (839us) | Total: 0.1% (1.3ms) | Samples: 5

**Called by:**
- `isInLoop` (8)

**Calls:**
- `/^(?:DoWhile\|For\|ForIn\|ForOf\|While)Statement$/u` (2)
- `test` (1)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5248` | Self: 0.0% (839us) | Total: 0.0% (839us) | Samples: 5

**Called by:**
- `walkNodes` (5)

### `_applySchemaDefaults`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:161` | Self: 0.0% (838us) | Total: 0.0% (838us) | Samples: 5

**Called by:**
- `buildVisitorMap` (5)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:205` | Self: 0.0% (828us) | Total: 0.0% (828us) | Samples: 4

**Called by:**
- `runOnce` (4)

### `replace`
`[native code]` | Self: 0.0% (820us) | Total: 0.1% (1.0ms) | Samples: 5

**Called by:**
- `(anonymous)` (2)
- `wordsRegexp` (1)
- `_getSelectorRootTypes` (1)
- `_buildScopeRefsAndThrough` (1)
- `get value` (1)

**Calls:**
- `(anonymous)` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1184` | Self: 0.0% (817us) | Total: 0.0% (817us) | Samples: 4

**Called by:**
- `_computeIsStrict` (1)
- `getDestructuringHost` (1)
- `findUp` (1)
- `isInLoop` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:159` | Self: 0.0% (815us) | Total: 0.0% (815us) | Samples: 5

**Called by:**
- `buildVisitorMap` (5)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5694` | Self: 0.0% (808us) | Total: 0.0% (808us) | Samples: 5

**Called by:**
- `_getOrBuildPlan` (5)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:276` | Self: 0.0% (804us) | Total: 0.1% (1.6ms) | Samples: 5

**Called by:**
- `parseSource` (10)

**Calls:**
- `DataView` (5)

### `_tag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1072` | Self: 0.0% (800us) | Total: 0.0% (800us) | Samples: 5

**Called by:**
- `get name` (1)
- `_findDefNode` (1)
- `_findDefNode` (1)
- `get init` (1)
- `get async` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4225` | Self: 0.0% (798us) | Total: 0.0% (798us) | Samples: 5

**Called by:**
- `runPlugins` (5)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2204` | Self: 0.0% (793us) | Total: 1.7% (15.2ms) | Samples: 4

**Called by:**
- `ensureRefsThrough` (87)

**Calls:**
- `_buildReference` (39)
- `_buildReference` (24)
- `_buildReference` (8)
- `_buildReference` (5)
- `_buildReference` (3)
- `_buildReference` (2)
- `_buildReference` (1)
- `_buildReference` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6540` | Self: 0.0% (789us) | Total: 0.0% (789us) | Samples: 5

**Called by:**
- `runPlugins` (5)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:773` | Self: 0.0% (777us) | Total: 0.0% (777us) | Samples: 5

**Called by:**
- `get name` (5)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1674` | Self: 0.0% (773us) | Total: 0.1% (1.1ms) | Samples: 5

**Called by:**
- `_computeIsStrict` (4)
- `_computeIsStrict` (1)
- `checkLastSegment` (1)
- `isInClassStaticInitializerRange` (1)

**Calls:**
- `get _tag` (2)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5655` | Self: 0.0% (766us) | Total: 0.0% (766us) | Samples: 5

**Called by:**
- `_getOrBuildPlan` (5)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6727` | Self: 0.0% (754us) | Total: 0.1% (894us) | Samples: 4

**Called by:**
- `runPlugins` (5)

**Calls:**
- `Uint8Array` (1)

### `_deepMergeObjects`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:128` | Self: 0.0% (754us) | Total: 0.1% (1.2ms) | Samples: 5

**Called by:**
- `map` (5)
- `(anonymous)` (3)

**Calls:**
- `propertyIsEnumerable` (3)

### `runOnce`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:92` | Self: 0.0% (736us) | Total: 81.7% (701.4ms) | Samples: 4

**Called by:**
- `(anonymous)` (2155)
- `(anonymous)` (1922)

**Calls:**
- `runPlugins` (3697)
- `runPlugins` (298)
- `runPlugins` (63)
- `runPlugins` (5)
- `runPlugins` (3)
- `runPlugins` (2)
- `runPlugins` (2)
- `runPlugins` (1)
- `runPlugins` (1)
- `runPlugins` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6536` | Self: 0.0% (726us) | Total: 0.0% (726us) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1994` | Self: 0.0% (726us) | Total: 0.0% (726us) | Samples: 4

**Called by:**
- `ensureVarsSet` (4)

### `parseModule`
`[native code]` | Self: 0.0% (725us) | Total: 99.8% (856.4ms) | Samples: 4

**Called by:**
- `async (anonymous)` (4955)

**Calls:**
- `(anonymous)` (2612)
- `(anonymous)` (2201)
- `(anonymous)` (60)
- `(anonymous)` (22)
- `(anonymous)` (16)
- `(anonymous)` (15)
- `(anonymous)` (10)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (1)
- `(program)` (1)
- `(anonymous)` (1)

### `/\/\*([\s\S]*?)\*\//g`
`[native code]` | Self: 0.0% (717us) | Total: 0.0% (717us) | Samples: 4

**Called by:**
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (1)
- `exec` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6757` | Self: 0.0% (713us) | Total: 0.0% (713us) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2191` | Self: 0.0% (712us) | Total: 0.0% (712us) | Samples: 4

**Called by:**
- `ensureRefsThrough` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6822` | Self: 0.0% (709us) | Total: 0.1% (866us) | Samples: 4

**Called by:**
- `runPlugins` (5)

**Calls:**
- `has` (1)

### `_parseDisableDirectives`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7412` | Self: 0.0% (709us) | Total: 0.0% (709us) | Samples: 4

**Called by:**
- `applyDisableDirectives` (4)

### `forEach`
`[native code]` | Self: 0.0% (707us) | Total: 1.9% (16.9ms) | Samples: 4

**Called by:**
- `checkReferencesInScope` (17)
- `checkReferencesInScope` (17)
- `getFunctionDefinitions` (14)
- `checkForFunction` (13)
- `checkVariable` (13)
- `Program:exit` (12)
- `checkGroup` (5)
- `checkGroup` (1)
- `bound call` (1)

**Calls:**
- `checkReferencesInScope` (13)
- `checkVariable` (13)
- `(anonymous)` (7)
- `checkReference` (7)
- `(anonymous)` (7)
- `(anonymous)` (6)
- `(anonymous)` (5)
- `checkGroup` (5)
- `checkReferencesInScope` (4)
- `(anonymous)` (4)
- `checkReference` (2)
- `(anonymous)` (2)
- `checkGroup` (2)
- `checkReference` (2)
- `checkGroup` (1)
- `(anonymous)` (1)
- `checkReference` (1)
- `(anonymous)` (1)
- `checkGroup` (1)
- `checkGroup` (1)
- `checkGroup` (1)
- `checkGroup` (1)
- `(anonymous)` (1)
- `checkReference` (1)

### `slotTemplate`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5798` | Self: 0.0% (697us) | Total: 0.0% (697us) | Samples: 4

**Called by:**
- `_buildTemplate` (3)
- `_buildTemplate` (1)

### `_extractBatchScannable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (695us) | Total: 0.0% (695us) | Samples: 4

**Called by:**
- `_buildPlan` (4)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1384` | Self: 0.0% (692us) | Total: 0.1% (1.1ms) | Samples: 4

**Called by:**
- `_buildScope` (4)
- `isAssignmentTarget` (1)
- `equalsToOriginalName` (1)
- `isImportAttributeKey` (1)

**Calls:**
- `_rawTokenText` (2)
- `get mainToken` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:441` | Self: 0.0% (682us) | Total: 1.7% (14.9ms) | Samples: 2

**Called by:**
- `parseSource` (53)

**Calls:**
- `CfgGraph` (11)
- `CfgGraph` (5)
- `CfgGraph` (4)
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
- `CfgGraph` (2)
- `CfgGraph` (1)
- `CfgGraph` (1)
- `CfgGraph` (1)
- `CfgGraph` (1)
- `CfgGraph` (1)
- `CfgGraph` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6569` | Self: 0.0% (680us) | Total: 0.0% (851us) | Samples: 4

**Called by:**
- `runPlugins` (5)

**Calls:**
- `get` (1)

### `get start`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1092` | Self: 0.0% (678us) | Total: 0.0% (678us) | Samples: 4

**Called by:**
- `_execReport` (2)
- `_execReport` (1)
- `get range` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1855` | Self: 0.0% (675us) | Total: 1.1% (9.4ms) | Samples: 4

**Called by:**
- `_precomputeScopes` (34)
- `_buildScopeChildren` (12)
- `checkForBlock` (1)

**Calls:**
- `Set` (43)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4554` | Self: 0.0% (675us) | Total: 26.2% (224.8ms) | Samples: 3

**Called by:**
- `walkNodes` (959)
- `walkNodes` (347)

**Calls:**
- `Program:exit` (358)
- `Program:exit` (239)
- `Program:exit` (149)
- `Program` (117)
- `Program` (69)
- `Program:exit` (67)
- `VariableDeclaration` (42)
- `Program:exit` (38)
- `checkForFunction` (33)
- `Program` (25)
- `checkLastSegment` (21)
- `Program` (19)
- `Program` (16)
- `Program:exit` (11)
- `Program:exit` (10)
- `checkLastSegment` (9)
- `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause` (8)
- `BinaryExpression` (7)
- `Program` (6)
- `Program` (5)
- `Program:exit` (5)
- `BinaryExpression` (4)
- `Program:exit` (4)
- `Program:exit` (3)
- `checkForBlock` (3)
- `VariableDeclaration` (3)
- `checkForBlock` (3)
- `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause` (3)
- `Program` (3)
- `checkLastSegment` (2)
- `ReturnStatement` (2)
- `checkLastSegment` (2)
- `ReturnStatement` (2)
- `checkLastSegment` (2)
- `ImportDeclaration` (1)
- `ReturnStatement` (1)
- `BinaryExpression` (1)
- `Program:exit` (1)
- `Program:exit` (1)
- `checkLastSegment` (1)
- `Program:exit` (1)
- `checkLastSegment` (1)
- `BinaryExpression` (1)
- `BinaryExpression` (1)
- `Program` (1)
- `Program` (1)
- `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1679` | Self: 0.0% (669us) | Total: 1.0% (9.3ms) | Samples: 4

**Called by:**
- `_buildScopeChildren` (39)
- `_precomputeScopes` (17)

**Calls:**
- `_computeIsStrict` (22)
- `_computeIsStrict` (11)
- `_computeIsStrict` (11)
- `_computeIsStrict` (3)
- `_computeIsStrict` (2)
- `_computeIsStrict` (2)
- `_computeIsStrict` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5062` | Self: 0.0% (663us) | Total: 0.0% (807us) | Samples: 4

**Called by:**
- `fn` (5)

**Calls:**
- `get type` (1)

### `copyDataProperties`
`[native code]` | Self: 0.0% (661us) | Total: 0.0% (661us) | Samples: 4

**Called by:**
- `_deepMergeObjects` (4)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3786` | Self: 0.0% (661us) | Total: 0.2% (2.3ms) | Samples: 4

**Called by:**
- `report` (14)

**Calls:**
- `get start` (3)
- `get type` (2)
- `get start` (2)
- `get start` (1)
- `get type` (1)
- `get start` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6351` | Self: 0.0% (661us) | Total: 0.0% (661us) | Samples: 4

**Called by:**
- `walkNodes` (4)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1996` | Self: 0.0% (659us) | Total: 0.1% (1.0ms) | Samples: 4

**Called by:**
- `ensureVarsSet` (6)

**Calls:**
- `has` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:954` | Self: 0.0% (658us) | Total: 0.2% (1.9ms) | Samples: 4

**Called by:**
- `Program:exit` (8)
- `collectUnusedVariables` (2)

**Calls:**
- `isExported` (3)
- `isExported` (2)
- `isExported` (1)

### `iterateDeclarations`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:68` | Self: 0.0% (656us) | Total: 0.0% (656us) | Samples: 4

**Called by:**
- `generatorResume` (4)

### `_nodeEndPos`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:880` | Self: 0.0% (652us) | Total: 0.0% (652us) | Samples: 4

**Called by:**
- `get end` (3)
- `get loc` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1067` | Self: 0.0% (652us) | Total: 0.0% (652us) | Samples: 4

**Called by:**
- `skipChainExpression` (1)
- `fn` (1)
- `_buildReference` (1)
- `getDestructuringHost` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6729` | Self: 0.0% (650us) | Total: 0.0% (650us) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6263` | Self: 0.0% (647us) | Total: 0.0% (810us) | Samples: 4

**Called by:**
- `runPlugins` (5)

**Calls:**
- `has` (1)

### `runOnce`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:84` | Self: 0.0% (646us) | Total: 0.0% (646us) | Samples: 4

**Called by:**
- `(anonymous)` (4)

### `slotTemplate`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5792` | Self: 0.0% (645us) | Total: 0.0% (645us) | Samples: 4

**Called by:**
- `_buildTemplate` (3)
- `_buildTemplate` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (644us) | Total: 0.0% (644us) | Samples: 4

**Called by:**
- `parseSource` (4)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5771` | Self: 0.0% (640us) | Total: 3.3% (28.5ms) | Samples: 4

**Called by:**
- `_getOrBuildPlan` (168)

**Calls:**
- `_extractFileLevelRules` (38)
- `_extractFileLevelRules` (31)
- `_extractFileLevelRules` (29)
- `_extractFileLevelRules` (21)
- `_extractFileLevelRules` (14)
- `_extractFileLevelRules` (13)
- `_extractFileLevelRules` (7)
- `_extractFileLevelRules` (2)
- `_extractFileLevelRules` (2)
- `_extractFileLevelRules` (2)
- `_extractFileLevelRules` (2)
- `_extractFileLevelRules` (2)
- `_extractFileLevelRules` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2337` | Self: 0.0% (640us) | Total: 2.2% (19.7ms) | Samples: 4

**Called by:**
- `ensureChildren` (118)

**Calls:**
- `_buildScope` (39)
- `_buildScope` (26)
- `_buildScope` (12)
- `_buildScope` (10)
- `_buildScope` (8)
- `_buildScope` (5)
- `_buildScope` (4)
- `_buildScope` (2)
- `_buildScope` (2)
- `_buildScope` (2)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:642` | Self: 0.0% (636us) | Total: 0.0% (636us) | Samples: 4

**Called by:**
- `reset` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7032` | Self: 0.0% (635us) | Total: 0.0% (635us) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6824` | Self: 0.0% (633us) | Total: 0.0% (633us) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `_resolveUnicodeEscapes`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:226` | Self: 0.0% (631us) | Total: 0.0% (631us) | Samples: 3

**Called by:**
- `get name` (2)
- `_buildScopeRefsAndThrough` (1)

### `isInside`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:495` | Self: 0.0% (629us) | Total: 0.0% (629us) | Samples: 4

**Called by:**
- `isReadForItself` (3)
- `isInsideOfStorableFunction` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2317` | Self: 0.0% (624us) | Total: 0.0% (624us) | Samples: 4

**Called by:**
- `ensureRefsThrough` (4)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (622us) | Total: 0.0% (622us) | Samples: 4

**Called by:**
- `getAncestorsFor` (2)
- `get body` (1)
- `_buildThinVariable` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6817` | Self: 0.0% (622us) | Total: 0.0% (622us) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `regExpSplitFast`
`[native code]` | Self: 0.0% (618us) | Total: 0.1% (1.4ms) | Samples: 4

**Called by:**
- `_parseDisableDirectives` (9)

**Calls:**
- `/\r?\n/` (5)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6872` | Self: 0.0% (615us) | Total: 0.0% (784us) | Samples: 4

**Called by:**
- `runPlugins` (5)

**Calls:**
- `_resolveHandlers` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:637` | Self: 0.0% (606us) | Total: 0.0% (606us) | Samples: 4

**Called by:**
- `reset` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6726` | Self: 0.0% (606us) | Total: 0.0% (606us) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `encodeInto`
`[native code]` | Self: 0.0% (585us) | Total: 0.0% (585us) | Samples: 3

**Called by:**
- `_encodeSource` (3)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:802` | Self: 0.0% (575us) | Total: 0.2% (2.2ms) | Samples: 3

**Called by:**
- `_buildVariable` (10)
- `_ensureDeclSymIndex` (2)
- `_buildThinVariable` (1)

**Calls:**
- `_buildSymNameCache` (8)
- `_buildSymNameCache` (1)
- `_buildSymNameCache` (1)

### `get nodeTags`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:602` | Self: 0.0% (574us) | Total: 0.0% (574us) | Samples: 3

**Called by:**
- `walkNodes` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6414` | Self: 0.0% (556us) | Total: 0.1% (921us) | Samples: 3

**Called by:**
- `runPlugins` (5)

**Calls:**
- `Uint8Array` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (551us) | Total: 0.0% (551us) | Samples: 3

**Called by:**
- `ensureVarsSet` (3)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1649` | Self: 0.0% (542us) | Total: 0.0% (542us) | Samples: 3

**Called by:**
- `_precomputeScopes` (3)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:395` | Self: 0.0% (536us) | Total: 0.4% (4.2ms) | Samples: 3

**Called by:**
- `_buildVariable` (16)
- `_buildThinVariable` (10)

**Calls:**
- `get parent` (7)
- `get parent` (6)
- `get parent` (4)
- `get parent` (3)
- `get parent` (2)
- `get parent` (1)

### `_expandUnion`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4042` | Self: 0.0% (534us) | Total: 0.0% (698us) | Samples: 3

**Called by:**
- `buildVisitorMap` (4)

**Calls:**
- `endsWith` (1)

### `iterateDeclarations`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:61` | Self: 0.0% (533us) | Total: 0.0% (533us) | Samples: 3

**Called by:**
- `generatorResume` (3)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3915` | Self: 0.0% (533us) | Total: 0.0% (533us) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6539` | Self: 0.0% (531us) | Total: 0.0% (531us) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3995` | Self: 0.0% (530us) | Total: 0.0% (530us) | Samples: 3

**Called by:**
- `get body` (1)
- `_buildVariable` (1)
- `walkNodes` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2832` | Self: 0.0% (530us) | Total: 0.0% (530us) | Samples: 3

**Called by:**
- `_buildScopeRefsAndThrough` (2)
- `_buildVariable` (1)

### `get byteLength`
`[native code]` | Self: 0.0% (529us) | Total: 0.0% (529us) | Samples: 3

**Called by:**
- `AstView` (2)
- `ensureBufferBytes` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1888` | Self: 0.0% (526us) | Total: 16.8% (144.6ms) | Samples: 3

**Called by:**
- `_precomputeScopes` (673)
- `_buildScopeRefsAndThrough` (160)
- `ensureRefsThrough` (16)
- `_precomputeScopes` (2)

**Calls:**
- `ensureRefsThrough` (715)
- `ensureRefsThrough` (116)
- `ensureRefsThrough` (16)
- `ensureRefsThrough` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6735` | Self: 0.0% (526us) | Total: 0.0% (526us) | Samples: 3

**Called by:**
- `some` (3)

### `isExported`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:369` | Self: 0.0% (523us) | Total: 0.0% (700us) | Samples: 2

**Called by:**
- `collectUnusedVariables` (3)

**Calls:**
- `get parent` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2267` | Self: 0.0% (523us) | Total: 8.3% (71.2ms) | Samples: 3

**Called by:**
- `ensureRefsThrough` (417)

**Calls:**
- `get` (414)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5798` | Self: 0.0% (521us) | Total: 0.0% (521us) | Samples: 2

**Called by:**
- `map` (2)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7322` | Self: 0.0% (520us) | Total: 0.0% (520us) | Samples: 3

**Called by:**
- `runOnce` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6758` | Self: 0.0% (517us) | Total: 0.1% (1.4ms) | Samples: 3

**Called by:**
- `runPlugins` (8)

**Calls:**
- `get` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` | Self: 0.0% (515us) | Total: 0.0% (515us) | Samples: 3

**Called by:**
- `(anonymous)` (3)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4003` | Self: 0.0% (515us) | Total: 0.0% (515us) | Samples: 3

**Called by:**
- `_buildThinVariable` (1)
- `_nodesFromRange` (1)
- `walkNodes` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3046` | Self: 0.0% (512us) | Total: 0.1% (882us) | Samples: 2

**Called by:**
- `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause` (2)
- `isAfterLastUsedArg` (1)
- `VariableDeclaration` (1)

**Calls:**
- `Set` (2)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:440` | Self: 0.0% (512us) | Total: 0.0% (657us) | Samples: 3

**Called by:**
- `_buildVariable` (2)
- `_buildThinVariable` (2)

**Calls:**
- `get parent` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5782` | Self: 0.0% (510us) | Total: 4.0% (34.7ms) | Samples: 3

**Called by:**
- `_getOrBuildPlan` (197)

**Calls:**
- `_buildTemplate` (66)
- `_buildTemplate` (58)
- `_buildTemplate` (33)
- `_buildTemplate` (31)
- `_buildTemplate` (3)
- `_buildTemplate` (2)
- `_buildTemplate` (1)

### `propertyIsEnumerable`
`[native code]` | Self: 0.0% (508us) | Total: 0.0% (508us) | Samples: 3

**Called by:**
- `_deepMergeObjects` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6635` | Self: 0.0% (507us) | Total: 0.0% (507us) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1952` | Self: 0.0% (505us) | Total: 0.6% (5.7ms) | Samples: 3

**Called by:**
- `ensureVarsSet` (31)
- `ensureVarsSet` (1)

**Calls:**
- `_ensureDeclSymIndex` (14)
- `_ensureDeclSymIndex` (4)
- `_ensureDeclSymIndex` (3)
- `_ensureDeclSymIndex` (2)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)

### `fn`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5161` | Self: 0.0% (504us) | Total: 0.4% (3.5ms) | Samples: 3

**Called by:**
- `_runSelectorList` (20)
- `walkNodes` (1)

**Calls:**
- `fn` (7)
- `fn` (4)
- `fn` (2)
- `fn` (2)
- `fn` (1)
- `fn` (1)
- `fn` (1)

### `lastIndexOf`
`[native code]` | Self: 0.0% (503us) | Total: 0.0% (503us) | Samples: 3

**Called by:**
- `ruleNameFromRuleId` (2)
- `pluginKeyFromRuleId` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4034` | Self: 0.0% (502us) | Total: 0.0% (502us) | Samples: 3

**Called by:**
- `get parent` (1)
- `walkNodes` (1)
- `invokeSelectorHandlers` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5064` | Self: 0.0% (501us) | Total: 0.0% (501us) | Samples: 3

**Called by:**
- `fn` (3)

### `extraFnData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:664` | Self: 0.0% (498us) | Total: 0.0% (498us) | Samples: 3

**Called by:**
- `get id` (2)
- `get body` (1)

### `get start`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (497us) | Total: 0.0% (497us) | Samples: 3

**Called by:**
- `_execReport` (3)

### `[Symbol.iterator]`
`[native code]` | Self: 0.0% (495us) | Total: 0.0% (495us) | Samples: 3

**Called by:**
- `findVariablesInScope` (2)
- `bound call` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1696` | Self: 0.0% (495us) | Total: 0.0% (495us) | Samples: 3

**Called by:**
- `_precomputeScopes` (3)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7351` | Self: 0.0% (494us) | Total: 0.0% (494us) | Samples: 2

**Called by:**
- `runOnce` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6833` | Self: 0.0% (492us) | Total: 0.1% (1.1ms) | Samples: 3

**Called by:**
- `runPlugins` (7)

**Calls:**
- `has` (4)

### `_buildTemplate`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5801` | Self: 0.0% (490us) | Total: 0.0% (490us) | Samples: 3

**Called by:**
- `_buildPlan` (3)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1993` | Self: 0.0% (490us) | Total: 0.0% (490us) | Samples: 3

**Called by:**
- `ensureVarsSet` (3)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2352` | Self: 0.0% (488us) | Total: 0.0% (488us) | Samples: 3

**Called by:**
- `getScope` (3)

### `_extractBatchScannable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4673` | Self: 0.0% (487us) | Total: 0.0% (487us) | Samples: 3

**Called by:**
- `_buildPlan` (3)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1501` | Self: 0.0% (486us) | Total: 15.9% (137.2ms) | Samples: 3

**Called by:**
- `Program:exit` (353)
- `Program` (155)
- `Program:exit` (148)
- `Program` (117)
- `Program` (25)

**Calls:**
- `_precomputeScopes` (673)
- `_precomputeScopes` (98)
- `_precomputeScopes` (8)
- `_precomputeScopes` (3)
- `_precomputeScopes` (3)
- `_precomputeScopes` (2)
- `_precomputeScopes` (2)
- `_precomputeScopes` (1)
- `_precomputeScopes` (1)
- `_precomputeScopes` (1)
- `_precomputeScopes` (1)
- `_precomputeScopes` (1)
- `_precomputeScopes` (1)

### `runOnce`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:96` | Self: 0.0% (486us) | Total: 0.0% (486us) | Samples: 3

**Called by:**
- `(anonymous)` (2)
- `(anonymous)` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2470` | Self: 0.0% (486us) | Total: 0.1% (1.3ms) | Samples: 3

**Called by:**
- `getScope` (8)

**Calls:**
- `commentsInRange` (2)
- `commentsInRange` (1)
- `commentsInRange` (1)
- `commentsInRange` (1)

### `Int32Array`
`[native code]` | Self: 0.0% (485us) | Total: 0.0% (485us) | Samples: 3

**Called by:**
- `AstView` (3)

### `every`
`[native code]` | Self: 0.0% (484us) | Total: 0.1% (938us) | Samples: 3

**Called by:**
- `_isSelector` (6)

**Calls:**
- `(anonymous)` (3)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2553` | Self: 0.0% (484us) | Total: 0.6% (5.7ms) | Samples: 3

**Called by:**
- `_buildScopeVarsAndSet` (30)
- `getDeclaredVariables` (5)

**Calls:**
- `_findDefNode` (16)
- `_findDefNode` (4)
- `_findDefNode` (2)
- `_findDefNode` (2)
- `_findDefNode` (2)
- `_findDefNode` (1)
- `_findDefNode` (1)
- `_findDefNode` (1)
- `_findDefNode` (1)
- `_findDefNode` (1)
- `_findDefNode` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7373` | Self: 0.0% (483us) | Total: 1.2% (10.7ms) | Samples: 3

**Called by:**
- `runOnce` (63)

**Calls:**
- `reset` (32)
- `get source` (11)
- `reset` (11)
- `reset` (3)
- `reset` (2)
- `reset` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:423` | Self: 0.0% (482us) | Total: 0.0% (620us) | Samples: 3

**Called by:**
- `_buildThinVariable` (4)

**Calls:**
- `get _tag` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4226` | Self: 0.0% (481us) | Total: 1.0% (9.2ms) | Samples: 3

**Called by:**
- `runPlugins` (54)

**Calls:**
- `create` (22)
- `create` (10)
- `create` (5)
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

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1663` | Self: 0.0% (480us) | Total: 0.1% (975us) | Samples: 3

**Called by:**
- `_buildScopeChildren` (5)
- `_precomputeScopes` (1)

**Calls:**
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6612` | Self: 0.0% (479us) | Total: 0.0% (479us) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6504` | Self: 0.0% (472us) | Total: 0.0% (472us) | Samples: 3

**Called by:**
- `walkNodes` (2)
- `walkNodes` (1)

### `readFileSync`
`[native code]` | Self: 0.0% (471us) | Total: 0.1% (942us) | Samples: 3

**Called by:**
- `(anonymous)` (3)
- `readFileSync` (3)

**Calls:**
- `readFileSync` (3)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3997` | Self: 0.0% (467us) | Total: 0.0% (467us) | Samples: 3

**Called by:**
- `get parent` (1)
- `walkNodes` (1)
- `_fireCfgEvents` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6358` | Self: 0.0% (463us) | Total: 0.0% (463us) | Samples: 3

**Called by:**
- `walkNodes` (3)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2859` | Self: 0.0% (462us) | Total: 0.0% (462us) | Samples: 3

**Called by:**
- `_buildReference` (2)
- `_buildVariable` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3594` | Self: 0.0% (459us) | Total: 0.0% (770us) | Samples: 3

**Called by:**
- `isInside` (2)
- `(anonymous)` (2)
- `report` (1)

**Calls:**
- `_nodeStartPos` (1)
- `get start` (1)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5258` | Self: 0.0% (458us) | Total: 0.0% (458us) | Samples: 3

**Called by:**
- `walkNodes` (3)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:306` | Self: 0.0% (454us) | Total: 0.1% (949us) | Samples: 2

**Called by:**
- `parseSource` (5)

**Calls:**
- `Uint32Array` (3)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1255` | Self: 0.0% (452us) | Total: 0.1% (1.4ms) | Samples: 3

**Called by:**
- `_findDefNode` (4)
- `_findDefNode` (2)
- `_computeIsStrict` (1)
- `_buildThinVariable` (1)
- `isInLoop` (1)

**Calls:**
- `get _tag` (5)
- `get _tag` (1)

### `_lineStarts`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:611` | Self: 0.0% (446us) | Total: 0.0% (446us) | Samples: 3

**Called by:**
- `get loc` (2)
- `getLocFromIndex` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6613` | Self: 0.0% (413us) | Total: 0.0% (413us) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `fetch`
`[native code]` | Self: 0.0% (409us) | Total: 0.0% (409us) | Samples: 2

**Called by:**
- `requestFetch` (2)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3791` | Self: 0.0% (398us) | Total: 0.0% (398us) | Samples: 1

**Called by:**
- `report` (1)

### `iterateDeclarations`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:59` | Self: 0.0% (389us) | Total: 0.0% (389us) | Samples: 2

**Called by:**
- `findVariablesInScope` (2)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1885` | Self: 0.0% (386us) | Total: 1.7% (15.1ms) | Samples: 2

**Called by:**
- `findVariablesInScope` (31)
- `Program` (19)
- `collectUnusedVariables` (18)
- `checkForShadows` (13)
- `ensureFenVars` (8)

**Calls:**
- `ensureVarsSet` (79)
- `ensureVarsSet` (3)
- `ensureVarsSet` (2)
- `ensureVarsSet` (1)
- `ensureVarsSet` (1)
- `ensureVarsSet` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:451` | Self: 0.0% (384us) | Total: 0.1% (910us) | Samples: 2

**Called by:**
- `parseSource` (5)

**Calls:**
- `Uint32Array` (3)

### `CfgSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4286` | Self: 0.0% (382us) | Total: 0.0% (382us) | Samples: 2

**Called by:**
- `segment` (2)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1607` | Self: 0.0% (380us) | Total: 0.0% (380us) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `isGlobalAugmentation`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:136` | Self: 0.0% (380us) | Total: 0.0% (543us) | Samples: 2

**Called by:**
- `checkForShadows` (3)

**Calls:**
- `get kind` (1)

### `ensureRefsThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1824` | Self: 0.0% (380us) | Total: 14.2% (121.9ms) | Samples: 2

**Called by:**
- `get` (715)

**Calls:**
- `_buildScopeRefsAndThrough` (417)
- `_buildScopeRefsAndThrough` (163)
- `_buildScopeRefsAndThrough` (87)
- `_buildScopeRefsAndThrough` (17)
- `_buildScopeRefsAndThrough` (9)
- `_buildScopeRefsAndThrough` (4)
- `_buildScopeRefsAndThrough` (4)
- `_buildScopeRefsAndThrough` (4)
- `_buildScopeRefsAndThrough` (2)
- `_buildScopeRefsAndThrough` (2)
- `_buildScopeRefsAndThrough` (1)
- `_buildScopeRefsAndThrough` (1)
- `_buildScopeRefsAndThrough` (1)
- `_buildScopeRefsAndThrough` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (379us) | Total: 0.0% (379us) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:435` | Self: 0.0% (379us) | Total: 0.1% (1.3ms) | Samples: 2

**Called by:**
- `parseSource` (6)

**Calls:**
- `Uint8Array` (4)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5290` | Self: 0.0% (378us) | Total: 0.0% (378us) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:930` | Self: 0.0% (374us) | Total: 0.0% (374us) | Samples: 2

**Called by:**
- `Program:exit` (1)
- `collectUnusedVariables` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6524` | Self: 0.0% (373us) | Total: 21.7% (186.5ms) | Samples: 2

**Called by:**
- `runPlugins` (1087)

**Calls:**
- `_getOrBuildPlan` (1084)
- `_getOrBuildPlan` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5693` | Self: 0.0% (372us) | Total: 0.0% (372us) | Samples: 2

**Called by:**
- `_getOrBuildPlan` (2)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5752` | Self: 0.0% (369us) | Total: 0.0% (369us) | Samples: 2

**Called by:**
- `_getOrBuildPlan` (2)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4195` | Self: 0.0% (369us) | Total: 0.0% (796us) | Samples: 2

**Called by:**
- `runPlugins` (4)

**Calls:**
- `includes` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6634` | Self: 0.0% (369us) | Total: 0.0% (369us) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2774` | Self: 0.0% (369us) | Total: 0.0% (369us) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (2)

### `_makeSafeHandler`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3818` | Self: 0.0% (368us) | Total: 0.0% (368us) | Samples: 2

**Called by:**
- `buildVisitorMap` (2)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2183` | Self: 0.0% (367us) | Total: 0.0% (367us) | Samples: 2

**Called by:**
- `ensureRefsThrough` (2)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1007` | Self: 0.0% (365us) | Total: 0.0% (365us) | Samples: 2

**Called by:**
- `_computeIsStrict` (1)
- `isFunction` (1)

### `Program`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:294` | Self: 0.0% (364us) | Total: 0.1% (881us) | Samples: 2

**Called by:**
- `_invokeFused` (5)

**Calls:**
- `isGoodName` (2)
- `get name` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (363us) | Total: 0.0% (363us) | Samples: 2

**Called by:**
- `_buildScopeChildren` (2)

### `hasRestSpreadSibling`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:411` | Self: 0.0% (362us) | Total: 0.0% (843us) | Samples: 2

**Called by:**
- `collectUnusedVariables` (5)

**Calls:**
- `some` (3)

### `iterateDeclarations`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:72` | Self: 0.0% (362us) | Total: 0.0% (362us) | Samples: 2

**Called by:**
- `generatorResume` (2)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:689` | Self: 0.0% (360us) | Total: 0.0% (809us) | Samples: 2

**Called by:**
- `_invokeFused` (5)

**Calls:**
- `get` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7068` | Self: 0.0% (360us) | Total: 0.0% (360us) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `_extractBatchScannable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4655` | Self: 0.0% (360us) | Total: 0.0% (360us) | Samples: 1

**Called by:**
- `_buildPlan` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2529` | Self: 0.0% (360us) | Total: 0.1% (1.2ms) | Samples: 2

**Called by:**
- `_buildScopeVarsAndSet` (5)
- `getDeclaredVariables` (2)

**Calls:**
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:165` | Self: 0.0% (359us) | Total: 0.0% (359us) | Samples: 2

**Called by:**
- `buildVisitorMap` (2)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1237` | Self: 0.0% (359us) | Total: 0.0% (717us) | Samples: 2

**Called by:**
- `_buildReference` (2)
- `_buildThinVariable` (1)
- `_findDefNode` (1)

**Calls:**
- `get _tag` (1)
- `get _tag` (1)

### `_deepMergeObjects`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:129` | Self: 0.0% (358us) | Total: 0.0% (358us) | Samples: 2

**Called by:**
- `(anonymous)` (1)
- `map` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6644` | Self: 0.0% (357us) | Total: 0.0% (357us) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1680` | Self: 0.0% (355us) | Total: 7.1% (61.0ms) | Samples: 2

**Called by:**
- `_invokeFused` (358)

**Calls:**
- `getScope` (353)
- `_buildScope` (3)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1328` | Self: 0.0% (354us) | Total: 0.0% (854us) | Samples: 2

**Called by:**
- `_buildScopeRefsAndThrough` (3)
- `isSpecificId` (1)
- `_buildScope` (1)

**Calls:**
- `get mainToken` (3)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1200` | Self: 0.0% (354us) | Total: 0.0% (354us) | Samples: 2

**Called by:**
- `_findDefNode` (1)
- `isExported` (1)

### `cloneObject`
`[native code]` | Self: 0.0% (354us) | Total: 0.0% (354us) | Samples: 2

**Called by:**
- `_deepMergeObjects` (2)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:461` | Self: 0.0% (353us) | Total: 0.1% (1.0ms) | Samples: 2

**Called by:**
- `parseSource` (6)

**Calls:**
- `Uint32Array` (4)

### `hasObservableSideEffectsForRegExpMatch`
`[native code]` | Self: 0.0% (353us) | Total: 0.0% (353us) | Samples: 2

**Called by:**
- `[Symbol.match]` (2)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1012` | Self: 0.0% (352us) | Total: 0.0% (352us) | Samples: 2

**Called by:**
- `(anonymous)` (1)
- `isFunction` (1)

### `accessPath`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5206` | Self: 0.0% (352us) | Total: 0.0% (493us) | Samples: 2

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `get computed` (1)

### `assign`
`[native code]` | Self: 0.0% (352us) | Total: 0.0% (352us) | Samples: 2

**Called by:**
- `_applySchemaDefaults` (2)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4199` | Self: 0.0% (351us) | Total: 0.5% (4.7ms) | Samples: 2

**Called by:**
- `runPlugins` (28)

**Calls:**
- `_deepMergeArrays` (20)
- `_deepMergeArrays` (5)
- `_deepMergeArrays` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2816` | Self: 0.0% (351us) | Total: 1.3% (11.3ms) | Samples: 2

**Called by:**
- `_buildScopeRefsAndThrough` (39)
- `_buildVariable` (28)

**Calls:**
- `_buildThinVariable` (22)
- `_buildThinVariable` (18)
- `_buildThinVariable` (15)
- `_buildThinVariable` (3)
- `_buildThinVariable` (2)
- `_buildThinVariable` (1)
- `_buildThinVariable` (1)
- `_buildThinVariable` (1)
- `_buildThinVariable` (1)
- `_buildThinVariable` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5689` | Self: 0.0% (350us) | Total: 0.0% (350us) | Samples: 2

**Called by:**
- `_getOrBuildPlan` (2)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4205` | Self: 0.0% (350us) | Total: 0.0% (518us) | Samples: 2

**Called by:**
- `runPlugins` (3)

**Calls:**
- `create` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3774` | Self: 0.0% (349us) | Total: 0.0% (523us) | Samples: 2

**Called by:**
- `report` (3)

**Calls:**
- `replaceTextRange` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (349us) | Total: 0.0% (349us) | Samples: 2

**Called by:**
- `(anonymous)` (1)
- `findIndex` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1325` | Self: 0.0% (349us) | Total: 0.0% (856us) | Samples: 2

**Called by:**
- `_buildScopeRefsAndThrough` (3)
- `getFunctionNameWithKind` (1)
- `Program` (1)

**Calls:**
- `get _tag` (2)
- `_tag` (1)

### `isExported`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:363` | Self: 0.0% (349us) | Total: 0.0% (349us) | Samples: 2

**Called by:**
- `collectUnusedVariables` (2)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:641` | Self: 0.0% (348us) | Total: 0.0% (348us) | Samples: 2

**Called by:**
- `reset` (2)

### `link`
`[native code]` | Self: 0.0% (347us) | Total: 0.0% (347us) | Samples: 1

**Called by:**
- `linkAndEvaluateModule` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (347us) | Total: 0.0% (347us) | Samples: 2

**Called by:**
- `_getOrBuildPlan` (2)

### `_applySchemaDefaults`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:169` | Self: 0.0% (346us) | Total: 0.0% (698us) | Samples: 2

**Called by:**
- `buildVisitorMap` (4)

**Calls:**
- `assign` (2)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:313` | Self: 0.0% (345us) | Total: 0.0% (544us) | Samples: 2

**Called by:**
- `parseSource` (3)

**Calls:**
- `Uint32Array` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6816` | Self: 0.0% (345us) | Total: 0.1% (866us) | Samples: 2

**Called by:**
- `runPlugins` (5)

**Calls:**
- `Uint8Array` (3)

### `describeRule`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:30` | Self: 0.0% (344us) | Total: 0.1% (975us) | Samples: 2

**Called by:**
- `buildVisitorMap` (6)

**Calls:**
- `_getPlugin` (4)

### `isUnderscored`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:105` | Self: 0.0% (343us) | Total: 0.0% (529us) | Samples: 2

**Called by:**
- `isGoodName` (3)

**Calls:**
- `toUpperCase` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:420` | Self: 0.0% (343us) | Total: 0.0% (343us) | Samples: 2

**Called by:**
- `parseSource` (2)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4844` | Self: 0.0% (341us) | Total: 0.0% (341us) | Samples: 2

**Called by:**
- `_buildPlan` (2)

### `RegExp`
`[native code]` | Self: 0.0% (341us) | Total: 0.0% (341us) | Samples: 2

**Called by:**
- `wordsRegexp` (2)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1716` | Self: 0.0% (340us) | Total: 0.2% (1.7ms) | Samples: 2

**Called by:**
- `_computeIsStrict` (8)
- `_computeIsStrict` (2)

**Calls:**
- `_nodesFromRange` (7)
- `_nodesFromRange` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:865` | Self: 0.0% (340us) | Total: 0.0% (340us) | Samples: 2

**Called by:**
- `get properties` (1)
- `get body` (1)

### `/^(?:Function(?:Declaration\|Expression)\|ArrowFunctionExpression)$/u`
`[native code]` | Self: 0.0% (340us) | Total: 0.0% (340us) | Samples: 2

**Called by:**
- `isFunction` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6579` | Self: 0.0% (339us) | Total: 0.0% (339us) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1903` | Self: 0.0% (339us) | Total: 0.0% (339us) | Samples: 2

**Called by:**
- `_buildScope` (2)

### `_buildTemplate`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5802` | Self: 0.0% (339us) | Total: 0.0% (339us) | Samples: 2

**Called by:**
- `_buildPlan` (2)

### `_getChainExpr`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3899` | Self: 0.0% (339us) | Total: 0.0% (339us) | Samples: 2

**Called by:**
- `get parent` (2)

### `RuleSkipSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4776` | Self: 0.0% (337us) | Total: 0.0% (337us) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `Program`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:275` | Self: 0.0% (337us) | Total: 0.3% (2.8ms) | Samples: 2

**Called by:**
- `_invokeFused` (16)

**Calls:**
- `isGoodName` (14)

### `_getSelectorRootTypes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5593` | Self: 0.0% (337us) | Total: 0.4% (3.9ms) | Samples: 2

**Called by:**
- `_getSelectorRootTypes` (22)
- `_getOrBuildSelectorPlan` (1)

**Calls:**
- `stringSplitFast` (18)
- `trim` (2)
- `replace` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` | Self: 0.0% (336us) | Total: 0.0% (336us) | Samples: 2

**Called by:**
- `(anonymous)` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2065` | Self: 0.0% (336us) | Total: 0.0% (336us) | Samples: 2

**Called by:**
- `ensureVarsSet` (2)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1037` | Self: 0.0% (336us) | Total: 0.0% (336us) | Samples: 2

**Called by:**
- `_buildScope` (1)
- `getStaticPropertyName` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6411` | Self: 0.0% (335us) | Total: 0.0% (475us) | Samples: 2

**Called by:**
- `runPlugins` (3)

**Calls:**
- `get` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2471` | Self: 0.0% (335us) | Total: 0.0% (335us) | Samples: 2

**Called by:**
- `getScope` (2)

### `get left`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1754` | Self: 0.0% (335us) | Total: 0.0% (335us) | Samples: 2

**Called by:**
- `isNullCheck` (1)
- `getRhsNode` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (333us) | Total: 0.0% (333us) | Samples: 2

**Called by:**
- `getDeclaredVariables` (1)
- `_buildScopeVarsAndSet` (1)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2879` | Self: 0.0% (332us) | Total: 0.0% (332us) | Samples: 2

**Called by:**
- `_buildReference` (1)
- `_buildThinScope` (1)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:92` | Self: 0.0% (332us) | Total: 0.1% (1.5ms) | Samples: 2

**Called by:**
- `parseSource` (9)

**Calls:**
- `Uint8Array` (4)
- `encodeInto` (3)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7365` | Self: 0.0% (331us) | Total: 0.0% (331us) | Samples: 2

**Called by:**
- `runOnce` (2)

### `/^(?:DoWhile\|For\|ForIn\|ForOf\|While)Statement$/u`
`[native code]` | Self: 0.0% (330us) | Total: 0.0% (330us) | Samples: 2

**Called by:**
- `isLoop` (2)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4868` | Self: 0.0% (330us) | Total: 0.0% (330us) | Samples: 2

**Called by:**
- `_buildPlan` (2)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1700` | Self: 0.0% (330us) | Total: 0.0% (814us) | Samples: 2

**Called by:**
- `_computeIsStrict` (5)

**Calls:**
- `_nodeViewRaw` (1)
- `nodeView` (1)
- `_nodeViewRaw` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3734` | Self: 0.0% (330us) | Total: 0.0% (330us) | Samples: 2

**Called by:**
- `report` (2)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:711` | Self: 0.0% (330us) | Total: 0.0% (330us) | Samples: 2

**Called by:**
- `collectUnusedVariables` (2)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5744` | Self: 0.0% (329us) | Total: 0.0% (329us) | Samples: 2

**Called by:**
- `_getOrBuildPlan` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6832` | Self: 0.0% (329us) | Total: 0.0% (329us) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1614` | Self: 0.0% (329us) | Total: 0.0% (329us) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4237` | Self: 0.0% (328us) | Total: 0.0% (525us) | Samples: 2

**Called by:**
- `AstView` (3)

**Calls:**
- `Uint32Array` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4033` | Self: 0.0% (328us) | Total: 0.0% (328us) | Samples: 2

**Called by:**
- `get body` (1)
- `walkNodes` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4190` | Self: 0.0% (328us) | Total: 0.0% (684us) | Samples: 2

**Called by:**
- `runPlugins` (4)

**Calls:**
- `ruleMetadataIndex` (2)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:305` | Self: 0.0% (328us) | Total: 0.1% (1.0ms) | Samples: 2

**Called by:**
- `parseSource` (6)

**Calls:**
- `Uint8Array` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6744` | Self: 0.0% (327us) | Total: 0.0% (483us) | Samples: 2

**Called by:**
- `runPlugins` (3)

**Calls:**
- `get` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6258` | Self: 0.0% (327us) | Total: 0.0% (327us) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2283` | Self: 0.0% (324us) | Total: 0.1% (1.4ms) | Samples: 2

**Called by:**
- `ensureRefsThrough` (9)

**Calls:**
- `get name` (4)
- `get name` (2)
- `_resolveUnicodeEscapes` (1)

### `_compileSelectorFastMatcher`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5097` | Self: 0.0% (324us) | Total: 0.0% (324us) | Samples: 2

**Called by:**
- `_compileSelectorFastMatcher` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3999` | Self: 0.0% (322us) | Total: 0.0% (322us) | Samples: 2

**Called by:**
- `get parent` (1)
- `isSpecificMemberAccess` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:497` | Self: 0.0% (321us) | Total: 0.1% (861us) | Samples: 2

**Called by:**
- `parseSource` (5)

**Calls:**
- `Uint32Array` (3)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2244` | Self: 0.0% (321us) | Total: 0.0% (321us) | Samples: 2

**Called by:**
- `ensureRefsThrough` (2)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2954` | Self: 0.0% (320us) | Total: 0.0% (467us) | Samples: 2

**Called by:**
- `_buildThinVariable` (2)
- `_buildVariable` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2281` | Self: 0.0% (320us) | Total: 3.1% (27.3ms) | Samples: 2

**Called by:**
- `ensureRefsThrough` (163)

**Calls:**
- `get` (160)
- `get` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:473` | Self: 0.0% (320us) | Total: 0.0% (658us) | Samples: 2

**Called by:**
- `parseSource` (4)

**Calls:**
- `Uint32Array` (2)

### `_getOrBuildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5453` | Self: 0.0% (318us) | Total: 21.6% (186.0ms) | Samples: 2

**Called by:**
- `walkNodes` (1084)

**Calls:**
- `_buildPlan` (197)
- `_buildPlan` (168)
- `_buildPlan` (107)
- `_buildPlan` (90)
- `_buildPlan` (82)
- `_buildPlan` (58)
- `_buildPlan` (57)
- `_buildPlan` (53)
- `_buildPlan` (46)
- `_buildPlan` (33)
- `_buildPlan` (30)
- `_buildPlan` (21)
- `_buildPlan` (18)
- `_buildPlan` (15)
- `_buildPlan` (13)
- `_buildPlan` (12)
- `_buildPlan` (9)
- `_buildPlan` (9)
- `_buildPlan` (8)
- `_buildPlan` (6)
- `_buildPlan` (6)
- `_buildPlan` (6)
- `_buildPlan` (5)
- `_buildPlan` (5)
- `_buildPlan` (3)
- `_buildPlan` (3)
- `_buildPlan` (3)
- `_buildPlan` (2)
- `_buildPlan` (2)
- `_buildPlan` (2)
- `_buildPlan` (2)
- `_buildPlan` (2)
- `_buildPlan` (2)
- `_buildPlan` (2)
- `_buildPlan` (2)
- `_buildPlan` (1)
- `_buildPlan` (1)
- `_buildPlan` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2845` | Self: 0.0% (318us) | Total: 0.1% (1.3ms) | Samples: 2

**Called by:**
- `_buildScopeRefsAndThrough` (5)
- `_buildVariable` (3)

**Calls:**
- `get type` (3)
- `get local` (1)
- `get type` (1)
- `get type` (1)

### `_parseDisableDirectives`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7404` | Self: 0.0% (317us) | Total: 0.2% (2.0ms) | Samples: 2

**Called by:**
- `applyDisableDirectives` (12)

**Calls:**
- `regExpSplitFast` (9)
- `[Symbol.split]` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1925` | Self: 0.0% (317us) | Total: 0.4% (3.6ms) | Samples: 2

**Called by:**
- `_buildScope` (22)

**Calls:**
- `get body` (5)
- `get body` (4)
- `get body` (4)
- `get body` (2)
- `get body` (2)
- `get body` (2)
- `get body` (1)

### `describeRule`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:32` | Self: 0.0% (316us) | Total: 0.0% (316us) | Samples: 2

**Called by:**
- `buildVisitorMap` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:953` | Self: 0.0% (316us) | Total: 2.6% (22.8ms) | Samples: 2

**Called by:**
- `Program:exit` (117)
- `collectUnusedVariables` (14)

**Calls:**
- `some` (47)
- `isUsedVariable` (43)
- `isUsedVariable` (36)
- `isUsedVariable` (2)
- `isUsedVariable` (1)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5285` | Self: 0.0% (315us) | Total: 0.1% (1.1ms) | Samples: 2

**Called by:**
- `walkNodes` (7)

**Calls:**
- `Set` (5)

### `get property`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1946` | Self: 0.0% (315us) | Total: 0.0% (315us) | Samples: 1

**Called by:**
- `fn` (1)

### `fn`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5029` | Self: 0.0% (314us) | Total: 0.0% (314us) | Samples: 2

**Called by:**
- `fn` (2)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4840` | Self: 0.0% (313us) | Total: 0.0% (313us) | Samples: 2

**Called by:**
- `_buildPlan` (2)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:766` | Self: 0.0% (313us) | Total: 0.4% (4.1ms) | Samples: 2

**Called by:**
- `Program:exit` (18)
- `collectUnusedVariables` (8)

**Calls:**
- `get` (18)
- `get` (3)
- `get` (3)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3546` | Self: 0.0% (313us) | Total: 0.0% (313us) | Samples: 2

**Called by:**
- `getNameRange` (1)
- `(anonymous)` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2102` | Self: 0.0% (312us) | Total: 0.0% (502us) | Samples: 2

**Called by:**
- `ensureVarsSet` (3)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (1)

### `get init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2907` | Self: 0.0% (312us) | Total: 0.1% (860us) | Samples: 2

**Called by:**
- `(anonymous)` (3)
- `isFunctionNameInitializerException` (1)
- `isEvaluatedDuringInitialization` (1)

**Calls:**
- `_tag` (1)
- `get _tag` (1)
- `get _tag` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7092` | Self: 0.0% (312us) | Total: 0.0% (822us) | Samples: 2

**Called by:**
- `runPlugins` (5)

**Calls:**
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3033` | Self: 0.0% (311us) | Total: 0.2% (2.0ms) | Samples: 2

**Called by:**
- `VariableDeclaration` (6)
- `checkForFunction` (4)
- `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause` (2)

**Calls:**
- `_ensureDeclSymIndex` (8)
- `_ensureDeclSymIndex` (1)
- `_ensureDeclSymIndex` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2978` | Self: 0.0% (310us) | Total: 0.2% (2.3ms) | Samples: 2

**Called by:**
- `_buildThinVariable` (12)
- `_buildThinScope` (1)
- `_buildReference` (1)

**Calls:**
- `_buildThinVariable` (6)
- `_buildThinVariable` (2)
- `_buildThinVariable` (2)
- `_buildThinVariable` (1)
- `_buildThinVariable` (1)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4857` | Self: 0.0% (310us) | Total: 0.0% (310us) | Samples: 2

**Called by:**
- `_buildPlan` (2)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5713` | Self: 0.0% (310us) | Total: 0.0% (476us) | Samples: 2

**Called by:**
- `_getOrBuildPlan` (3)

**Calls:**
- `has` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2171` | Self: 0.0% (309us) | Total: 0.0% (309us) | Samples: 2

**Called by:**
- `ensureVarsSet` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6464` | Self: 0.0% (308us) | Total: 0.0% (308us) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2316` | Self: 0.0% (308us) | Total: 0.3% (2.9ms) | Samples: 2

**Called by:**
- `ensureRefsThrough` (17)

**Calls:**
- `get name` (7)
- `get name` (3)
- `get name` (3)
- `get name` (1)
- `replace` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:551` | Self: 0.0% (307us) | Total: 0.0% (307us) | Samples: 2

**Called by:**
- `_precomputeScopes` (2)

### `_deepMergeArrays`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:136` | Self: 0.0% (307us) | Total: 0.3% (3.3ms) | Samples: 2

**Called by:**
- `buildVisitorMap` (20)

**Calls:**
- `map` (18)

### `create`
`[native code]` | Self: 0.0% (305us) | Total: 0.0% (305us) | Samples: 2

**Called by:**
- `buildVisitorMap` (1)
- `walkNodes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4031` | Self: 0.0% (301us) | Total: 0.0% (454us) | Samples: 2

**Called by:**
- `every` (3)

**Calls:**
- `/^[A-Z][A-Za-z]*$/` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (301us) | Total: 0.0% (301us) | Samples: 2

**Called by:**
- `walkNodes` (1)
- `walkNodes` (1)

### `_compileAttrCheck`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5198` | Self: 0.0% (301us) | Total: 0.0% (831us) | Samples: 2

**Called by:**
- `map` (5)

**Calls:**
- `stringSplitFast` (3)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:487` | Self: 0.0% (296us) | Total: 0.0% (447us) | Samples: 2

**Called by:**
- `parseSource` (3)

**Calls:**
- `Uint32Array` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:314` | Self: 0.0% (295us) | Total: 0.0% (639us) | Samples: 2

**Called by:**
- `parseSource` (4)

**Calls:**
- `Uint32Array` (2)

### `_isSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4025` | Self: 0.0% (294us) | Total: 0.0% (759us) | Samples: 2

**Called by:**
- `buildVisitorMap` (5)

**Calls:**
- `endsWith` (3)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2665` | Self: 0.0% (291us) | Total: 0.0% (291us) | Samples: 2

**Called by:**
- `getDeclaredVariables` (1)
- `_buildScopeVarsAndSet` (1)

### `_rawTokenText`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:781` | Self: 0.0% (287us) | Total: 0.0% (287us) | Samples: 2

**Called by:**
- `get value` (2)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:179` | Self: 0.0% (286us) | Total: 0.0% (286us) | Samples: 2

**Called by:**
- `buildVisitorMap` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6637` | Self: 0.0% (284us) | Total: 0.0% (284us) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6450` | Self: 0.0% (284us) | Total: 0.0% (284us) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5891` | Self: 0.0% (270us) | Total: 0.0% (270us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `isInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:231` | Self: 0.0% (204us) | Total: 0.0% (204us) | Samples: 1

**Called by:**
- `isInitPatternNode` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2700` | Self: 0.0% (204us) | Total: 0.0% (204us) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_compileSelectorFastMatcher`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5120` | Self: 0.0% (202us) | Total: 0.0% (202us) | Samples: 1

**Called by:**
- `_getOrBuildSelectorPlan` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4192` | Self: 0.0% (201us) | Total: 0.0% (371us) | Samples: 1

**Called by:**
- `AstView` (2)

**Calls:**
- `Uint32Array` (1)

### `CfgCodePath`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4331` | Self: 0.0% (201us) | Total: 0.0% (201us) | Samples: 1

**Called by:**
- `codepath` (1)

### `Ae`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` | Self: 0.0% (200us) | Total: 0.0% (200us) | Samples: 1

**Called by:**
- `parse` (1)

### `get start`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1106` | Self: 0.0% (200us) | Total: 0.0% (200us) | Samples: 1

**Called by:**
- `_execReport` (1)

### `Program`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js` | Self: 0.0% (199us) | Total: 0.0% (199us) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:436` | Self: 0.0% (199us) | Total: 0.0% (760us) | Samples: 1

**Called by:**
- `_buildVariable` (2)
- `_buildThinVariable` (2)

**Calls:**
- `get parent` (3)

### `be`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` | Self: 0.0% (198us) | Total: 0.0% (198us) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (198us) | Total: 0.0% (198us) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6484` | Self: 0.0% (198us) | Total: 0.8% (6.9ms) | Samples: 1

**Called by:**
- `walkNodes` (40)

**Calls:**
- `onCodePathStart` (38)
- `onCodePathStart` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2844` | Self: 0.0% (197us) | Total: 0.0% (710us) | Samples: 1

**Called by:**
- `_buildScopeRefsAndThrough` (3)
- `_buildVariable` (1)

**Calls:**
- `get parent` (2)
- `get parent` (1)

### `invokeHandlersWithNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6152` | Self: 0.0% (197us) | Total: 0.0% (197us) | Samples: 1

**Called by:**
- `invokeMethodFnHandlers` (1)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1498` | Self: 0.0% (197us) | Total: 0.0% (197us) | Samples: 1

**Called by:**
- `Program` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (197us) | Total: 0.0% (197us) | Samples: 1

**Called by:**
- `_buildThinVariable` (1)

### `_symName`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:801` | Self: 0.0% (197us) | Total: 0.0% (197us) | Samples: 1

**Called by:**
- `_buildVariable` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7018` | Self: 0.0% (196us) | Total: 0.0% (196us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:956` | Self: 0.0% (196us) | Total: 0.0% (196us) | Samples: 1

**Called by:**
- `Program:exit` (1)

### `Ee`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (196us) | Total: 0.0% (196us) | Samples: 1

**Called by:**
- `Se` (1)

### `getAssignedMessageData`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:305` | Self: 0.0% (196us) | Total: 0.0% (354us) | Samples: 1

**Called by:**
- `Program:exit` (2)

**Calls:**
- `getVariableDescription` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4288` | Self: 0.0% (196us) | Total: 0.0% (196us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `onCodePathStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:406` | Self: 0.0% (195us) | Total: 0.7% (6.5ms) | Samples: 1

**Called by:**
- `_fireCfgEvents` (38)

**Calls:**
- `getArrayMethodName` (22)
- `getArrayMethodName` (7)
- `getArrayMethodName` (3)
- `getArrayMethodName` (1)
- `getArrayMethodName` (1)
- `getStaticPropertyName` (1)
- `getStaticPropertyName` (1)
- `getStaticPropertyName` (1)

### `_cookTemplate`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (195us) | Total: 0.0% (195us) | Samples: 1

**Called by:**
- `get value` (1)

### `getNameLocationInGlobalDirectiveComment`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2643` | Self: 0.0% (195us) | Total: 0.0% (195us) | Samples: 1

**Called by:**
- `iterateDeclarations` (1)

### `isExported`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:364` | Self: 0.0% (195us) | Total: 0.0% (195us) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5012` | Self: 0.0% (195us) | Total: 0.0% (195us) | Samples: 1

**Called by:**
- `find` (1)

### `isFunctionNameInitializerException`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:423` | Self: 0.0% (195us) | Total: 0.0% (337us) | Samples: 1

**Called by:**
- `checkForShadows` (2)

**Calls:**
- `get type` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2956` | Self: 0.0% (195us) | Total: 0.0% (195us) | Samples: 1

**Called by:**
- `_buildThinVariable` (1)

### `groupByDestructuring`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:316` | Self: 0.0% (195us) | Total: 0.0% (195us) | Samples: 1

**Called by:**
- `Program:exit` (1)

### `get property`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (195us) | Total: 0.0% (195us) | Samples: 1

**Called by:**
- `getStaticPropertyName` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2172` | Self: 0.0% (194us) | Total: 0.0% (194us) | Samples: 1

**Called by:**
- `ensureVarsSet` (1)

### `get operator`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1317` | Self: 0.0% (194us) | Total: 0.0% (194us) | Samples: 1

**Called by:**
- `BinaryExpression` (1)

### `runOnce`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:90` | Self: 0.0% (194us) | Total: 0.0% (347us) | Samples: 1

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `get` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5785` | Self: 0.0% (194us) | Total: 0.0% (194us) | Samples: 1

**Called by:**
- `_getOrBuildPlan` (1)

### `getIdentifierIfShouldBeConst`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:228` | Self: 0.0% (193us) | Total: 0.0% (193us) | Samples: 1

**Called by:**
- `groupByDestructuring` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2341` | Self: 0.0% (193us) | Total: 0.0% (193us) | Samples: 1

**Called by:**
- `ensureChildren` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2057` | Self: 0.0% (193us) | Total: 0.0% (342us) | Samples: 1

**Called by:**
- `ensureVarsSet` (2)

**Calls:**
- `get source` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1997` | Self: 0.0% (193us) | Total: 2.6% (22.8ms) | Samples: 1

**Called by:**
- `ensureVarsSet` (134)

**Calls:**
- `_mkGlobalVar` (116)
- `_mkGlobalVar` (17)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1048` | Self: 0.0% (193us) | Total: 0.0% (193us) | Samples: 1

**Called by:**
- `isFunction` (1)

### `getDestructuringHost`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:98` | Self: 0.0% (193us) | Total: 0.0% (362us) | Samples: 1

**Called by:**
- `getIdentifierIfShouldBeConst` (1)
- `groupByDestructuring` (1)

**Calls:**
- `isWrite` (1)

### `getVariableByName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js` | Self: 0.0% (192us) | Total: 0.0% (192us) | Samples: 1

**Called by:**
- `checkForShadows` (1)

### `isModifyingProp`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:95` | Self: 0.0% (192us) | Total: 0.0% (192us) | Samples: 1

**Called by:**
- `checkReference` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1962` | Self: 0.0% (192us) | Total: 0.0% (192us) | Samples: 1

**Called by:**
- `ensureVarsSet` (1)

### `[Symbol.split]`
`[native code]` | Self: 0.0% (192us) | Total: 0.0% (192us) | Samples: 1

**Called by:**
- `_parseDisableDirectives` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1474` | Self: 0.0% (192us) | Total: 0.0% (192us) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `get left`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (192us) | Total: 0.0% (192us) | Samples: 1

**Called by:**
- `isModifyingProp` (1)

### `checkForShadows`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:620` | Self: 0.0% (192us) | Total: 0.0% (735us) | Samples: 1

**Called by:**
- `Program:exit` (4)

**Calls:**
- `isGlobalAugmentation` (3)

### `resolve`
`[native code]` | Self: 0.0% (191us) | Total: 0.0% (191us) | Samples: 1

**Called by:**
- `async (anonymous)` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1966` | Self: 0.0% (191us) | Total: 0.0% (191us) | Samples: 1

**Called by:**
- `ensureVarsSet` (1)

### `_deepMergeObjects`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (191us) | Total: 0.0% (191us) | Samples: 1

**Called by:**
- `map` (1)

### `_isChainChild`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3873` | Self: 0.0% (191us) | Total: 0.0% (191us) | Samples: 1

**Called by:**
- `nodeViewChain` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5678` | Self: 0.0% (191us) | Total: 0.0% (191us) | Samples: 1

**Called by:**
- `some` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:690` | Self: 0.0% (191us) | Total: 1.3% (11.4ms) | Samples: 1

**Called by:**
- `_invokeFused` (67)

**Calls:**
- `checkForShadows` (20)
- `checkForShadows` (19)
- `checkForShadows` (7)
- `checkForShadows` (4)
- `checkForShadows` (3)
- `checkForShadows` (2)
- `checkForShadows` (2)
- `checkForShadows` (2)
- `checkForShadows` (2)
- `checkForShadows` (2)
- `checkForShadows` (1)
- `checkForShadows` (1)
- `checkForShadows` (1)

### `isStorableFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` | Self: 0.0% (191us) | Total: 0.0% (191us) | Samples: 1

**Called by:**
- `isReadForItself` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4036` | Self: 0.0% (190us) | Total: 0.0% (190us) | Samples: 1

**Called by:**
- `get parent` (1)

### `isImportAttributeKey`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:1426` | Self: 0.0% (190us) | Total: 0.0% (190us) | Samples: 1

**Called by:**
- `Program` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7071` | Self: 0.0% (190us) | Total: 0.0% (190us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_lineStarts`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (190us) | Total: 0.0% (190us) | Samples: 1

**Called by:**
- `get loc` (1)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2889` | Self: 0.0% (189us) | Total: 0.0% (189us) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7341` | Self: 0.0% (189us) | Total: 0.0% (189us) | Samples: 1

**Called by:**
- `runOnce` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1503` | Self: 0.0% (189us) | Total: 0.0% (189us) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `runOnce`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:101` | Self: 0.0% (189us) | Total: 0.4% (4.0ms) | Samples: 1

**Called by:**
- `(anonymous)` (15)
- `(anonymous)` (9)

**Calls:**
- `applyDisableDirectives` (16)
- `filter` (7)

### `fn`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5031` | Self: 0.0% (189us) | Total: 0.0% (189us) | Samples: 1

**Called by:**
- `fn` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6417` | Self: 0.0% (189us) | Total: 0.0% (189us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `get local`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3488` | Self: 0.0% (189us) | Total: 0.0% (189us) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:884` | Self: 0.0% (189us) | Total: 0.0% (189us) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4187` | Self: 0.0% (189us) | Total: 0.0% (713us) | Samples: 1

**Called by:**
- `AstView` (4)

**Calls:**
- `Uint8Array` (3)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4242` | Self: 0.0% (188us) | Total: 0.0% (188us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `isUnusedExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:513` | Self: 0.0% (188us) | Total: 0.0% (383us) | Samples: 1

**Called by:**
- `isReadForItself` (2)

**Calls:**
- `get expressions` (1)

### `fn`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5102` | Self: 0.0% (188us) | Total: 0.1% (863us) | Samples: 1

**Called by:**
- `_runSelectorList` (3)
- `fn` (1)

**Calls:**
- `_nodeViewRaw` (1)
- `get property` (1)
- `get property` (1)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1040` | Self: 0.0% (188us) | Total: 0.0% (188us) | Samples: 1

**Called by:**
- `isInitOfForStatement` (1)

### `defineProperty`
`[native code]` | Self: 0.0% (188us) | Total: 0.0% (188us) | Samples: 1

**Called by:**
- `hideFromStack` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:885` | Self: 0.0% (188us) | Total: 0.0% (188us) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1625` | Self: 0.0% (188us) | Total: 0.0% (594us) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (3)

**Calls:**
- `_symName` (2)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:318` | Self: 0.0% (188us) | Total: 0.0% (188us) | Samples: 1

**Called by:**
- `parseSource` (1)

### `fn`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (188us) | Total: 0.0% (188us) | Samples: 1

**Called by:**
- `fn` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1176` | Self: 0.0% (187us) | Total: 0.0% (187us) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:155` | Self: 0.0% (187us) | Total: 0.0% (187us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (187us) | Total: 0.0% (187us) | Samples: 1

**Called by:**
- `get name` (1)

### `RuleMetadataIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js` | Self: 0.0% (187us) | Total: 0.0% (187us) | Samples: 1

**Called by:**
- `ruleMetadataIndex` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4000` | Self: 0.0% (187us) | Total: 0.0% (187us) | Samples: 1

**Called by:**
- `get parent` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2494` | Self: 0.0% (187us) | Total: 0.0% (187us) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:228` | Self: 0.0% (187us) | Total: 0.0% (187us) | Samples: 1

**Called by:**
- `replace` (1)

### `get name`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1337` | Self: 0.0% (187us) | Total: 0.3% (3.2ms) | Samples: 1

**Called by:**
- `_buildScopeRefsAndThrough` (7)
- `_buildScopeRefsAndThrough` (4)
- `getStaticPropertyName` (2)
- `_buildScope` (1)
- `collectUnusedVariables` (1)
- `_precomputeScopes` (1)
- `checkReference` (1)
- `(anonymous)` (1)

**Calls:**
- `_identAt` (8)
- `_identAt` (5)
- `_resolveUnicodeEscapes` (2)
- `_identAt` (1)
- `_identAt` (1)

### `isOuterVariableInDestructing`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:72` | Self: 0.0% (187us) | Total: 0.0% (187us) | Samples: 1

**Called by:**
- `some` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:401` | Self: 0.0% (187us) | Total: 0.0% (526us) | Samples: 1

**Called by:**
- `parseSource` (3)

**Calls:**
- `Uint16Array` (2)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4200` | Self: 0.0% (187us) | Total: 0.0% (364us) | Samples: 1

**Called by:**
- `AstView` (2)

**Calls:**
- `Uint32Array` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2522` | Self: 0.0% (186us) | Total: 0.0% (186us) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:205` | Self: 0.0% (186us) | Total: 0.0% (186us) | Samples: 1

**Called by:**
- `reportReferenceId` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4133` | Self: 0.0% (186us) | Total: 0.0% (186us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `toUpperCase`
`[native code]` | Self: 0.0% (186us) | Total: 0.0% (186us) | Samples: 1

**Called by:**
- `isUnderscored` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:59` | Self: 0.0% (186us) | Total: 0.0% (186us) | Samples: 1

**Called by:**
- `parseModule` (1)

### `get key`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3120` | Self: 0.0% (186us) | Total: 0.0% (186us) | Samples: 1

**Called by:**
- `isModifyingProp` (1)

### `isLogicalAssignmentOperator`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:941` | Self: 0.0% (186us) | Total: 0.0% (186us) | Samples: 1

**Called by:**
- `isReadForItself` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:788` | Self: 0.0% (186us) | Total: 0.0% (186us) | Samples: 1

**Called by:**
- `Program:exit` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4234` | Self: 0.0% (186us) | Total: 0.7% (6.6ms) | Samples: 1

**Called by:**
- `runPlugins` (40)

**Calls:**
- `_isSelector` (10)
- `_isSelector` (9)
- `_isSelector` (6)
- `_isSelector` (6)
- `_isSelector` (5)
- `includes` (1)
- `_isSelector` (1)
- `_isSelector` (1)

### `getStaticPropertyName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:320` | Self: 0.0% (186us) | Total: 0.0% (550us) | Samples: 1

**Called by:**
- `isSpecificMemberAccess` (2)
- `onCodePathStart` (1)

**Calls:**
- `get property` (1)
- `get property` (1)

### `getModuleExportName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:973` | Self: 0.0% (186us) | Total: 0.0% (186us) | Samples: 1

**Called by:**
- `equalsToOriginalName` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:433` | Self: 0.0% (185us) | Total: 0.1% (1.0ms) | Samples: 1

**Called by:**
- `forEach` (6)

**Calls:**
- `isEvaluatedDuringInitialization` (2)
- `isEvaluatedDuringInitialization` (2)
- `isEvaluatedDuringInitialization` (1)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:180` | Self: 0.0% (185us) | Total: 0.2% (2.3ms) | Samples: 1

**Called by:**
- `getRhsNode` (14)

**Calls:**
- `get parent` (4)
- `get parent` (3)
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1661` | Self: 0.0% (185us) | Total: 0.0% (185us) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `_compileSelectorFastMatcher`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4973` | Self: 0.0% (185us) | Total: 0.0% (185us) | Samples: 1

**Called by:**
- `_compileSelectorFastMatcher` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6467` | Self: 0.0% (185us) | Total: 0.0% (185us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:280` | Self: 0.0% (185us) | Total: 0.0% (185us) | Samples: 1

**Called by:**
- `parseSource` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:329` | Self: 0.0% (185us) | Total: 0.0% (506us) | Samples: 1

**Called by:**
- `parseSource` (3)

**Calls:**
- `Uint32Array` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4045` | Self: 0.0% (184us) | Total: 0.0% (184us) | Samples: 1

**Called by:**
- `map` (1)

### `_compileSelectorFastMatcher`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5107` | Self: 0.0% (184us) | Total: 0.0% (184us) | Samples: 1

**Called by:**
- `_compileSelectorFastMatcher` (1)

### `_isSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (184us) | Total: 0.0% (184us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:234` | Self: 0.0% (184us) | Total: 0.0% (557us) | Samples: 1

**Called by:**
- `runOnce` (3)

**Calls:**
- `DataView` (2)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6476` | Self: 0.0% (184us) | Total: 0.0% (701us) | Samples: 1

**Called by:**
- `walkNodes` (3)
- `walkNodes` (1)

**Calls:**
- `codepath` (3)

### `ReturnStatement`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:487` | Self: 0.0% (184us) | Total: 0.0% (184us) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:296` | Self: 0.0% (184us) | Total: 0.1% (880us) | Samples: 1

**Called by:**
- `parseSource` (5)

**Calls:**
- `Uint32Array` (4)

### `getTokenAfter`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1289` | Self: 0.0% (184us) | Total: 0.0% (184us) | Samples: 1

**Called by:**
- `getFunctionHeadLoc` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3073` | Self: 0.0% (184us) | Total: 0.0% (184us) | Samples: 1

**Called by:**
- `VariableDeclaration` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (184us) | Total: 0.0% (184us) | Samples: 1

**Called by:**
- `report` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4201` | Self: 0.0% (184us) | Total: 0.0% (184us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `checkForShadows`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:651` | Self: 0.0% (183us) | Total: 0.1% (1.1ms) | Samples: 1

**Called by:**
- `Program:exit` (7)

**Calls:**
- `isFunctionNameInitializerException` (2)
- `isFunctionNameInitializerException` (2)
- `isFunctionNameInitializerException` (1)
- `isFunctionNameInitializerException` (1)

### `getFunctionNameWithKind`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2184` | Self: 0.0% (183us) | Total: 0.0% (183us) | Samples: 1

**Called by:**
- `checkLastSegment` (1)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:818` | Self: 0.0% (183us) | Total: 0.0% (183us) | Samples: 1

**Called by:**
- `_symName` (1)

### `get operator`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1307` | Self: 0.0% (183us) | Total: 0.0% (183us) | Samples: 1

**Called by:**
- `report` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:418` | Self: 0.0% (182us) | Total: 0.0% (359us) | Samples: 1

**Called by:**
- `parseSource` (2)

**Calls:**
- `Uint32Array` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:477` | Self: 0.0% (182us) | Total: 0.0% (354us) | Samples: 1

**Called by:**
- `forEach` (2)

**Calls:**
- `get init` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:621` | Self: 0.0% (182us) | Total: 0.0% (182us) | Samples: 1

**Called by:**
- `commentsInRange` (1)

### `_applySchemaDefaults`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:171` | Self: 0.0% (182us) | Total: 0.0% (182us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `isNullLiteral`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:204` | Self: 0.0% (182us) | Total: 0.0% (324us) | Samples: 1

**Called by:**
- `isNullCheck` (2)

**Calls:**
- `get type` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4188` | Self: 0.0% (182us) | Total: 0.0% (319us) | Samples: 1

**Called by:**
- `AstView` (2)

**Calls:**
- `Uint32Array` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6097` | Self: 0.0% (182us) | Total: 0.0% (182us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1673` | Self: 0.0% (182us) | Total: 0.1% (1.7ms) | Samples: 1

**Called by:**
- `_buildScopeChildren` (10)

**Calls:**
- `get value` (4)
- `get value` (1)
- `get value` (1)
- `get value` (1)
- `get value` (1)
- `get value` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn-jsx/xhtml.js:1` | Self: 0.0% (182us) | Total: 0.0% (182us) | Samples: 1

**Called by:**
- `anonymous` (1)

### `async loadAndEvaluateModule`
`[native code]` | Self: 0.0% (182us) | Total: 0.1% (1.3ms) | Samples: 1

**Called by:**
- `async loadAndEvaluateModule` (3)

**Calls:**
- `async loadAndEvaluateModule` (3)
- `async loadModule` (2)
- `linkAndEvaluateModule` (1)

### `_extractBatchScannable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4654` | Self: 0.0% (182us) | Total: 0.0% (182us) | Samples: 1

**Called by:**
- `_buildPlan` (1)

### `checkForShadows`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:636` | Self: 0.0% (181us) | Total: 0.0% (332us) | Samples: 1

**Called by:**
- `Program:exit` (2)

**Calls:**
- `isThisParam` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3759` | Self: 0.0% (181us) | Total: 0.0% (181us) | Samples: 1

**Called by:**
- `report` (1)

### `isInClassStaticInitializerRange`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js` | Self: 0.0% (181us) | Total: 0.0% (181us) | Samples: 1

**Called by:**
- `isEvaluatedDuringInitialization` (1)

### `get directive`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3394` | Self: 0.0% (181us) | Total: 0.0% (181us) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3074` | Self: 0.0% (181us) | Total: 0.0% (181us) | Samples: 1

**Called by:**
- `isAfterLastUsedArg` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:405` | Self: 0.0% (181us) | Total: 0.0% (181us) | Samples: 1

**Called by:**
- `parseSource` (1)

### `_getChainExpr`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3903` | Self: 0.0% (181us) | Total: 0.0% (181us) | Samples: 1

**Called by:**
- `getArrayMethodName` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:653` | Self: 0.0% (181us) | Total: 0.0% (181us) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `isSpecificMemberAccess`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js` | Self: 0.0% (181us) | Total: 0.0% (181us) | Samples: 1

**Called by:**
- `getArrayMethodName` (1)

### `isAssignmentTarget`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:140` | Self: 0.0% (181us) | Total: 0.0% (181us) | Samples: 1

**Called by:**
- `MemberExpression[computed!=true] > Identifier.property` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3884` | Self: 0.0% (180us) | Total: 0.0% (180us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js` | Self: 0.0% (180us) | Total: 0.0% (180us) | Samples: 1

**Called by:**
- `some` (1)

### `_getSelectorRootTypes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5601` | Self: 0.0% (180us) | Total: 0.0% (180us) | Samples: 1

**Called by:**
- `_getSelectorRootTypes` (1)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5244` | Self: 0.0% (180us) | Total: 0.0% (180us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `defToVariableType`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:204` | Self: 0.0% (180us) | Total: 0.0% (180us) | Samples: 1

**Called by:**
- `getAssignedMessageData` (1)

### `_extractBatchScannable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4665` | Self: 0.0% (180us) | Total: 0.0% (180us) | Samples: 1

**Called by:**
- `_buildPlan` (1)

### `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:334` | Self: 0.0% (180us) | Total: 0.0% (180us) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6946` | Self: 0.0% (180us) | Total: 0.0% (180us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3902` | Self: 0.0% (180us) | Total: 0.2% (1.7ms) | Samples: 1

**Called by:**
- `runPlugins` (11)

**Calls:**
- `reset` (4)
- `reset` (4)
- `reset` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4004` | Self: 0.0% (179us) | Total: 0.0% (179us) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2377` | Self: 0.0% (179us) | Total: 0.0% (179us) | Samples: 1

**Called by:**
- `getScope` (1)

### `_isSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4030` | Self: 0.0% (179us) | Total: 0.1% (988us) | Samples: 1

**Called by:**
- `buildVisitorMap` (6)

**Calls:**
- `map` (4)
- `stringSplitFast` (1)

### `ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1783` | Self: 0.0% (179us) | Total: 0.0% (179us) | Samples: 1

**Called by:**
- `get` (1)

### `get callee`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (179us) | Total: 0.0% (179us) | Samples: 1

**Called by:**
- `getArrayMethodName` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2356` | Self: 0.0% (179us) | Total: 2.0% (17.9ms) | Samples: 1

**Called by:**
- `getScope` (98)

**Calls:**
- `_buildScope` (34)
- `_buildScope` (29)
- `_buildScope` (17)
- `_buildScope` (8)
- `_buildScope` (3)
- `_buildScope` (3)
- `_buildScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `getFunctionNameWithKind`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2110` | Self: 0.0% (179us) | Total: 0.0% (179us) | Samples: 1

**Called by:**
- `checkLastSegment` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3610` | Self: 0.0% (178us) | Total: 0.0% (178us) | Samples: 1

**Called by:**
- `getFunctionHeadLoc` (1)

### `slotTemplate`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5793` | Self: 0.0% (178us) | Total: 0.0% (178us) | Samples: 1

**Called by:**
- `_buildTemplate` (1)

### `_compileSelectorFastMatcher`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5051` | Self: 0.0% (178us) | Total: 0.0% (178us) | Samples: 1

**Called by:**
- `_compileSelectorFastMatcher` (1)

### `onCodePathStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js` | Self: 0.0% (178us) | Total: 0.0% (178us) | Samples: 1

**Called by:**
- `_fireCfgEvents` (1)

### `isEvaluatedDuringInitialization`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js` | Self: 0.0% (178us) | Total: 0.0% (178us) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4220` | Self: 0.0% (177us) | Total: 0.0% (336us) | Samples: 1

**Called by:**
- `AstView` (2)

**Calls:**
- `Uint32Array` (1)

### `ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1778` | Self: 0.0% (177us) | Total: 0.0% (473us) | Samples: 1

**Called by:**
- `get` (3)

**Calls:**
- `Map` (2)

### `getIdentifierIfShouldBeConst`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:187` | Self: 0.0% (177us) | Total: 0.0% (177us) | Samples: 1

**Called by:**
- `groupByDestructuring` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5643` | Self: 0.0% (177us) | Total: 0.0% (177us) | Samples: 1

**Called by:**
- `_getOrBuildPlan` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (177us) | Total: 0.0% (177us) | Samples: 1

**Called by:**
- `runOnce` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:479` | Self: 0.0% (177us) | Total: 0.0% (177us) | Samples: 1

**Called by:**
- `parseSource` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:810` | Self: 0.0% (177us) | Total: 0.0% (660us) | Samples: 1

**Called by:**
- `some` (4)

**Calls:**
- `get type` (2)
- `get type` (1)

### `isGenericOfAStaticMethodShadow`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js` | Self: 0.0% (177us) | Total: 0.0% (177us) | Samples: 1

**Called by:**
- `checkForShadows` (1)

### `ensureBufferBytes`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js` | Self: 0.0% (177us) | Total: 0.0% (177us) | Samples: 1

**Called by:**
- `_encodeSource` (1)

### `_extractBatchScannable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4668` | Self: 0.0% (177us) | Total: 0.0% (177us) | Samples: 1

**Called by:**
- `_buildPlan` (1)

### `ensureBufferBytes`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:61` | Self: 0.0% (177us) | Total: 0.0% (177us) | Samples: 1

**Called by:**
- `_encodeSource` (1)

### `_tokenIndexAtOrBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (176us) | Total: 0.0% (176us) | Samples: 1

**Called by:**
- `getTokenBefore` (1)

### `equalsToOriginalName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:179` | Self: 0.0% (176us) | Total: 0.0% (176us) | Samples: 1

**Called by:**
- `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause` (1)

### `getNameLocationInGlobalDirectiveComment`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2634` | Self: 0.0% (176us) | Total: 0.0% (176us) | Samples: 1

**Called by:**
- `Program:exit` (1)

### `checkForShadows`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:624` | Self: 0.0% (176us) | Total: 0.3% (3.2ms) | Samples: 1

**Called by:**
- `Program:exit` (19)

**Calls:**
- `get` (13)
- `get` (5)

### `isAssignmentTarget`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:143` | Self: 0.0% (175us) | Total: 0.0% (175us) | Samples: 1

**Called by:**
- `MemberExpression[computed!=true] > Identifier.property` (1)

### `requestSatisfy`
`[native code]` | Self: 0.0% (175us) | Total: 0.0% (320us) | Samples: 1

**Called by:**
- `async loadModule` (2)

**Calls:**
- `requestSatisfyUtil` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:126` | Self: 0.0% (175us) | Total: 0.0% (175us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `_getSelectorRootTypes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5597` | Self: 0.0% (175us) | Total: 0.0% (324us) | Samples: 1

**Called by:**
- `_getSelectorRootTypes` (2)

**Calls:**
- `/:([a-z-]+)\([^)]*\)/g` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6945` | Self: 0.0% (175us) | Total: 0.0% (175us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5331` | Self: 0.0% (175us) | Total: 0.2% (2.1ms) | Samples: 1

**Called by:**
- `walkNodes` (13)

**Calls:**
- `_getFfiSelector` (8)
- `_getFfiSelector` (3)
- `_getFfiSelector` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1669` | Self: 0.0% (174us) | Total: 0.0% (174us) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:513` | Self: 0.0% (174us) | Total: 0.0% (174us) | Samples: 1

**Called by:**
- `commentsInRange` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (174us) | Total: 0.0% (174us) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7136` | Self: 0.0% (174us) | Total: 0.0% (174us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6200` | Self: 0.0% (174us) | Total: 0.0% (174us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3783` | Self: 0.0% (174us) | Total: 0.0% (174us) | Samples: 1

**Called by:**
- `report` (1)

### `_compileSelectorFastMatcher`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5087` | Self: 0.0% (174us) | Total: 0.0% (174us) | Samples: 1

**Called by:**
- `_compileSelectorFastMatcher` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2624` | Self: 0.0% (174us) | Total: 0.0% (174us) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3620` | Self: 0.0% (174us) | Total: 0.0% (174us) | Samples: 1

**Called by:**
- `get parent` (1)

### `replaceTextRange`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/fix-tracker.js:110` | Self: 0.0% (174us) | Total: 0.0% (174us) | Samples: 1

**Called by:**
- `_execReport` (1)

### `getStaticPropertyName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:307` | Self: 0.0% (174us) | Total: 0.0% (174us) | Samples: 1

**Called by:**
- `isSpecificMemberAccess` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1620` | Self: 0.0% (173us) | Total: 0.0% (173us) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `get init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2910` | Self: 0.0% (173us) | Total: 0.0% (345us) | Samples: 1

**Called by:**
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `getUint32` (1)

### `_getTypeProto`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3967` | Self: 0.0% (173us) | Total: 0.0% (173us) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `get params`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2541` | Self: 0.0% (173us) | Total: 0.0% (173us) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` | Self: 0.0% (173us) | Total: 0.0% (173us) | Samples: 1

**Called by:**
- `some` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2216` | Self: 0.0% (173us) | Total: 0.0% (173us) | Samples: 1

**Called by:**
- `ensureRefsThrough` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7380` | Self: 0.0% (173us) | Total: 5.9% (51.4ms) | Samples: 1

**Called by:**
- `runOnce` (298)

**Calls:**
- `buildVisitorMap` (54)
- `buildVisitorMap` (40)
- `buildVisitorMap` (28)
- `buildVisitorMap` (27)
- `buildVisitorMap` (23)
- `buildVisitorMap` (22)
- `buildVisitorMap` (19)
- `buildVisitorMap` (16)
- `buildVisitorMap` (14)
- `buildVisitorMap` (13)
- `buildVisitorMap` (5)
- `buildVisitorMap` (5)
- `buildVisitorMap` (5)
- `buildVisitorMap` (4)
- `buildVisitorMap` (4)
- `buildVisitorMap` (3)
- `buildVisitorMap` (3)
- `buildVisitorMap` (2)
- `buildVisitorMap` (2)
- `buildVisitorMap` (1)
- `buildVisitorMap` (1)
- `buildVisitorMap` (1)
- `buildVisitorMap` (1)
- `buildVisitorMap` (1)
- `buildVisitorMap` (1)
- `buildVisitorMap` (1)
- `buildVisitorMap` (1)

### `_isSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4026` | Self: 0.0% (173us) | Total: 0.0% (173us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1677` | Self: 0.0% (173us) | Total: 0.0% (360us) | Samples: 1

**Called by:**
- `_computeIsStrict` (2)

**Calls:**
- `nodeRhs` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1628` | Self: 0.0% (172us) | Total: 0.0% (172us) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `getFirstToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (172us) | Total: 0.0% (172us) | Samples: 1

**Called by:**
- `getFunctionHeadLoc` (1)

### `iterateDeclarations`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js` | Self: 0.0% (171us) | Total: 0.0% (171us) | Samples: 1

**Called by:**
- `generatorResume` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:433` | Self: 0.0% (171us) | Total: 0.0% (664us) | Samples: 1

**Called by:**
- `parseSource` (4)

**Calls:**
- `Uint32Array` (3)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5742` | Self: 0.0% (171us) | Total: 0.0% (343us) | Samples: 1

**Called by:**
- `_getOrBuildPlan` (2)

**Calls:**
- `Uint8Array` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:430` | Self: 0.0% (171us) | Total: 0.0% (551us) | Samples: 1

**Called by:**
- `parseSource` (3)

**Calls:**
- `Uint32Array` (2)

### `_compileSelectorFastMatcher`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5086` | Self: 0.0% (170us) | Total: 0.0% (170us) | Samples: 1

**Called by:**
- `_getOrBuildSelectorPlan` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1295` | Self: 0.0% (170us) | Total: 0.0% (170us) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:460` | Self: 0.0% (170us) | Total: 0.0% (701us) | Samples: 1

**Called by:**
- `parseSource` (4)

**Calls:**
- `Uint32Array` (3)

### `checkLastSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:384` | Self: 0.0% (170us) | Total: 0.4% (3.7ms) | Samples: 1

**Called by:**
- `_invokeFused` (21)

**Calls:**
- `getFunctionHeadLoc` (10)
- `getFunctionHeadLoc` (6)
- `getFunctionHeadLoc` (2)
- `getFunctionHeadLoc` (1)
- `getFunctionHeadLoc` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2378` | Self: 0.0% (170us) | Total: 0.0% (170us) | Samples: 1

**Called by:**
- `getScope` (1)

### `get id`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (169us) | Total: 0.0% (169us) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `(anonymous)`
`internal:primordials:35` | Self: 0.0% (169us) | Total: 0.0% (169us) | Samples: 1

**Called by:**
- `forEach` (1)

### `get options`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2173` | Self: 0.0% (169us) | Total: 0.0% (169us) | Samples: 1

**Called by:**
- `isImportAttributeKey` (1)

### `ruleMetadataIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:12` | Self: 0.0% (169us) | Total: 0.0% (356us) | Samples: 1

**Called by:**
- `buildVisitorMap` (2)

**Calls:**
- `RuleMetadataIndex` (1)

### `isWrite`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:217` | Self: 0.0% (169us) | Total: 0.0% (169us) | Samples: 1

**Called by:**
- `getDestructuringHost` (1)

### `get init`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2909` | Self: 0.0% (169us) | Total: 0.0% (372us) | Samples: 1

**Called by:**
- `(anonymous)` (1)
- `isInitPatternNode` (1)

**Calls:**
- `nodeLhs` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4056` | Self: 0.0% (169us) | Total: 0.0% (169us) | Samples: 1

**Called by:**
- `getArrayMethodName` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3756` | Self: 0.0% (169us) | Total: 0.0% (169us) | Samples: 1

**Called by:**
- `report` (1)

### `_resolveHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (169us) | Total: 0.0% (169us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:302` | Self: 0.0% (169us) | Total: 0.1% (992us) | Samples: 1

**Called by:**
- `parseSource` (5)

**Calls:**
- `Uint32Array` (4)

### `_getJsxTextTokFlags`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:696` | Self: 0.0% (169us) | Total: 0.0% (320us) | Samples: 1

**Called by:**
- `_makeToken` (2)

**Calls:**
- `Uint8Array` (1)

### `get id`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2278` | Self: 0.0% (169us) | Total: 0.0% (169us) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3095` | Self: 0.0% (168us) | Total: 0.0% (168us) | Samples: 1

**Called by:**
- `map` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:434` | Self: 0.0% (168us) | Total: 0.0% (168us) | Samples: 1

**Called by:**
- `parseSource` (1)

### `get regex`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1569` | Self: 0.0% (168us) | Total: 0.0% (168us) | Samples: 1

**Called by:**
- `isNullLiteral` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:84` | Self: 0.0% (168us) | Total: 0.0% (168us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:394` | Self: 0.0% (168us) | Total: 0.0% (168us) | Samples: 1

**Called by:**
- `parseSource` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3790` | Self: 0.0% (167us) | Total: 0.0% (167us) | Samples: 1

**Called by:**
- `report` (1)

### `isTypeOf`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js` | Self: 0.0% (167us) | Total: 0.0% (167us) | Samples: 1

**Called by:**
- `isTypeOfBinary` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:808` | Self: 0.0% (167us) | Total: 0.0% (167us) | Samples: 1

**Called by:**
- `getFirstToken` (1)

### `_compileSelectorFastMatcher`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (167us) | Total: 0.0% (167us) | Samples: 1

**Called by:**
- `_getOrBuildSelectorPlan` (1)

### `getIdentifierIfShouldBeConst`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:233` | Self: 0.0% (166us) | Total: 0.0% (166us) | Samples: 1

**Called by:**
- `groupByDestructuring` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6559` | Self: 0.0% (166us) | Total: 0.0% (166us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2169` | Self: 0.0% (166us) | Total: 0.0% (166us) | Samples: 1

**Called by:**
- `ensureVarsSet` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6446` | Self: 0.0% (166us) | Total: 0.0% (166us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1627` | Self: 0.0% (165us) | Total: 0.0% (165us) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:476` | Self: 0.0% (165us) | Total: 0.0% (165us) | Samples: 1

**Called by:**
- `parseSource` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6480` | Self: 0.0% (165us) | Total: 0.0% (165us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:331` | Self: 0.0% (165us) | Total: 0.0% (165us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4220` | Self: 0.0% (164us) | Total: 0.0% (164us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1923` | Self: 0.0% (164us) | Total: 0.2% (1.9ms) | Samples: 1

**Called by:**
- `_buildScope` (11)

**Calls:**
- `get body` (8)
- `get body` (1)
- `get body` (1)

### `join`
`[native code]` | Self: 0.0% (164us) | Total: 0.0% (164us) | Samples: 1

**Called by:**
- `checkLastSegment` (1)

### `_findLineIdx`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:619` | Self: 0.0% (164us) | Total: 0.0% (164us) | Samples: 1

**Called by:**
- `commentsInRange` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:349` | Self: 0.0% (164us) | Total: 0.0% (164us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2818` | Self: 0.0% (164us) | Total: 0.0% (164us) | Samples: 1

**Called by:**
- `_buildScopeRefsAndThrough` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:782` | Self: 0.0% (164us) | Total: 0.0% (164us) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1816` | Self: 0.0% (164us) | Total: 10.2% (87.5ms) | Samples: 1

**Called by:**
- `get` (433)
- `get` (79)

**Calls:**
- `_buildScopeVarsAndSet` (145)
- `_buildScopeVarsAndSet` (134)
- `_buildScopeVarsAndSet` (78)
- `_buildScopeVarsAndSet` (35)
- `_buildScopeVarsAndSet` (31)
- `_buildScopeVarsAndSet` (10)
- `_buildScopeVarsAndSet` (10)
- `_buildScopeVarsAndSet` (8)
- `_buildScopeVarsAndSet` (8)
- `_buildScopeVarsAndSet` (7)
- `_buildScopeVarsAndSet` (7)
- `_buildScopeVarsAndSet` (6)
- `_buildScopeVarsAndSet` (4)
- `_buildScopeVarsAndSet` (3)
- `_buildScopeVarsAndSet` (3)
- `_buildScopeVarsAndSet` (3)
- `_buildScopeVarsAndSet` (3)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (2)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2439` | Self: 0.0% (164us) | Total: 0.0% (496us) | Samples: 1

**Called by:**
- `getScope` (3)

**Calls:**
- `get` (2)

### `_deepMergeArrays`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:137` | Self: 0.0% (164us) | Total: 0.1% (867us) | Samples: 1

**Called by:**
- `buildVisitorMap` (5)

**Calls:**
- `slice` (4)

### `get id`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2270` | Self: 0.0% (164us) | Total: 0.0% (164us) | Samples: 1

**Called by:**
- `_buildScope` (1)

### `(program)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:1` | Self: 0.0% (163us) | Total: 0.0% (163us) | Samples: 1

**Called by:**
- `parseModule` (1)

### `get kind`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2626` | Self: 0.0% (163us) | Total: 0.0% (163us) | Samples: 1

**Called by:**
- `isGlobalAugmentation` (1)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2864` | Self: 0.0% (163us) | Total: 0.0% (163us) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `Program`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:152` | Self: 0.0% (163us) | Total: 0.0% (163us) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `isReadRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:431` | Self: 0.0% (163us) | Total: 0.0% (163us) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_nodeStartPos`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:888` | Self: 0.0% (163us) | Total: 0.0% (163us) | Samples: 1

**Called by:**
- `get range` (1)

### `get argument`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1829` | Self: 0.0% (163us) | Total: 0.0% (163us) | Samples: 1

**Called by:**
- `ReturnStatement` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:398` | Self: 0.0% (163us) | Total: 0.0% (163us) | Samples: 1

**Called by:**
- `_buildThinVariable` (1)

### `_runSelectorList`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5993` | Self: 0.0% (163us) | Total: 0.6% (5.1ms) | Samples: 1

**Called by:**
- `invokeSelectorHandlers` (30)

**Calls:**
- `fn` (20)
- `fn` (4)
- `fn` (3)
- `fn` (2)

### `getNameRange`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:456` | Self: 0.0% (163us) | Total: 0.0% (330us) | Samples: 1

**Called by:**
- `isInTdz` (1)
- `isInTdz` (1)

**Calls:**
- `get range` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6749` | Self: 0.0% (163us) | Total: 0.2% (1.9ms) | Samples: 1

**Called by:**
- `runPlugins` (12)

**Calls:**
- `indexOf` (11)

### `fullMethodName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:58` | Self: 0.0% (162us) | Total: 0.0% (162us) | Samples: 1

**Called by:**
- `checkLastSegment` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:682` | Self: 0.0% (162us) | Total: 0.0% (162us) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:656` | Self: 0.0% (162us) | Total: 0.0% (348us) | Samples: 1

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `isLogicalAssignmentOperator` (1)

### `hasRestSpreadSibling`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:410` | Self: 0.0% (162us) | Total: 0.0% (162us) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `extraFnData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:665` | Self: 0.0% (162us) | Total: 0.0% (162us) | Samples: 1

**Called by:**
- `get body` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2636` | Self: 0.0% (162us) | Total: 0.0% (451us) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (3)

**Calls:**
- `_buildThinVariable` (1)
- `_buildThinVariable` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:430` | Self: 0.0% (162us) | Total: 0.0% (298us) | Samples: 1

**Called by:**
- `_buildThinVariable` (1)
- `_buildVariable` (1)

**Calls:**
- `_tag` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2646` | Self: 0.0% (162us) | Total: 0.0% (162us) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:396` | Self: 0.0% (162us) | Total: 0.0% (162us) | Samples: 1

**Called by:**
- `_buildVariable` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2498` | Self: 0.0% (162us) | Total: 0.2% (2.0ms) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (8)
- `getDeclaredVariables` (4)

**Calls:**
- `_symName` (10)
- `_symName` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2820` | Self: 0.0% (162us) | Total: 0.0% (323us) | Samples: 1

**Called by:**
- `_buildScopeRefsAndThrough` (1)
- `_buildVariable` (1)

**Calls:**
- `_buildThinScope` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1735` | Self: 0.0% (162us) | Total: 0.0% (162us) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:51` | Self: 0.0% (162us) | Total: 0.0% (162us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `canBecomeVariableDeclaration`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:59` | Self: 0.0% (161us) | Total: 0.0% (161us) | Samples: 1

**Called by:**
- `getIdentifierIfShouldBeConst` (1)

### `isArrayFromMethod`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:533` | Self: 0.0% (161us) | Total: 0.0% (161us) | Samples: 1

**Called by:**
- `getArrayMethodName` (1)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5263` | Self: 0.0% (161us) | Total: 0.4% (3.6ms) | Samples: 1

**Called by:**
- `walkNodes` (21)

**Calls:**
- `_compileSelectorFastMatcher` (16)
- `_compileSelectorFastMatcher` (1)
- `_compileSelectorFastMatcher` (1)
- `_compileSelectorFastMatcher` (1)
- `_compileSelectorFastMatcher` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4235` | Self: 0.0% (161us) | Total: 0.0% (161us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2273` | Self: 0.0% (161us) | Total: 0.0% (161us) | Samples: 1

**Called by:**
- `ensureRefsThrough` (1)

### `isFunctionNameInitializerException`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:426` | Self: 0.0% (160us) | Total: 0.0% (160us) | Samples: 1

**Called by:**
- `checkForShadows` (1)

### `getLocFromIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3359` | Self: 0.0% (160us) | Total: 0.0% (295us) | Samples: 1

**Called by:**
- `_execReport` (2)

**Calls:**
- `_lineStarts` (1)

### `getDestructuringHost`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:103` | Self: 0.0% (160us) | Total: 0.0% (501us) | Samples: 1

**Called by:**
- `getIdentifierIfShouldBeConst` (2)
- `groupByDestructuring` (1)

**Calls:**
- `get type` (1)
- `get type` (1)

### `getUsedIgnoredMessageData`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` | Self: 0.0% (160us) | Total: 0.0% (160us) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `get params`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2543` | Self: 0.0% (160us) | Total: 0.0% (160us) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:404` | Self: 0.0% (160us) | Total: 0.0% (485us) | Samples: 1

**Called by:**
- `parseSource` (3)

**Calls:**
- `Uint32Array` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1745` | Self: 0.0% (160us) | Total: 0.0% (160us) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (159us) | Total: 0.0% (159us) | Samples: 1

**Called by:**
- `get value` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (159us) | Total: 0.0% (159us) | Samples: 1

**Called by:**
- `isInside` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:408` | Self: 0.0% (159us) | Total: 0.0% (694us) | Samples: 1

**Called by:**
- `parseSource` (4)

**Calls:**
- `Uint16Array` (3)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4215` | Self: 0.0% (159us) | Total: 0.0% (159us) | Samples: 1

**Called by:**
- `AstView` (1)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (159us) | Total: 0.0% (159us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `extraFnData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (159us) | Total: 0.0% (159us) | Samples: 1

**Called by:**
- `get body` (1)

### `safeHandler`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3820` | Self: 0.0% (159us) | Total: 0.0% (159us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `ensureChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1847` | Self: 0.0% (159us) | Total: 0.0% (159us) | Samples: 1

**Called by:**
- `get` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1274` | Self: 0.0% (158us) | Total: 0.0% (686us) | Samples: 1

**Called by:**
- `_computeIsStrict` (2)
- `_buildReference` (2)

**Calls:**
- `get _tag` (3)

### `get flags`
`[native code]` | Self: 0.0% (158us) | Total: 0.0% (158us) | Samples: 1

**Called by:**
- `toString` (1)

### `codepath`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4256` | Self: 0.0% (158us) | Total: 0.0% (517us) | Samples: 1

**Called by:**
- `_fireCfgEvents` (3)

**Calls:**
- `CfgCodePath` (1)
- `CfgCodePath` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2447` | Self: 0.0% (158us) | Total: 0.0% (158us) | Samples: 1

**Called by:**
- `getScope` (1)

### `CfgCodePath`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4330` | Self: 0.0% (158us) | Total: 0.0% (158us) | Samples: 1

**Called by:**
- `codepath` (1)

### `normalizePath`
`bun:ffi` | Self: 0.0% (158us) | Total: 0.0% (158us) | Samples: 1

**Called by:**
- `dlopen` (1)

### `getFunctionNameWithKind`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2181` | Self: 0.0% (158us) | Total: 0.0% (342us) | Samples: 1

**Called by:**
- `checkLastSegment` (2)

**Calls:**
- `get name` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js` | Self: 0.0% (157us) | Total: 0.0% (157us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6768` | Self: 0.0% (157us) | Total: 0.0% (157us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (157us) | Total: 0.0% (157us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:142` | Self: 0.0% (157us) | Total: 0.0% (157us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `getArrayMethodName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:72` | Self: 0.0% (157us) | Total: 0.0% (157us) | Samples: 1

**Called by:**
- `onCodePathStart` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2175` | Self: 0.0% (157us) | Total: 0.0% (157us) | Samples: 1

**Called by:**
- `ensureVarsSet` (1)

### `getFunctionHeadLoc`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2308` | Self: 0.0% (157us) | Total: 0.1% (1.6ms) | Samples: 1

**Called by:**
- `checkLastSegment` (10)

**Calls:**
- `getFirstToken` (4)
- `getFirstToken` (1)
- `getFirstToken` (1)
- `getTokenAfter` (1)
- `getFirstToken` (1)
- `getTokenAfter` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4255` | Self: 0.0% (156us) | Total: 0.0% (524us) | Samples: 1

**Called by:**
- `runPlugins` (3)

**Calls:**
- `_makeSafeHandler` (2)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:384` | Self: 0.0% (156us) | Total: 0.0% (156us) | Samples: 1

**Called by:**
- `_buildVariable` (1)

### `getFunctionNameWithKind`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js` | Self: 0.0% (156us) | Total: 0.0% (156us) | Samples: 1

**Called by:**
- `checkLastSegment` (1)

### `BinaryExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:184` | Self: 0.0% (156us) | Total: 0.1% (1.1ms) | Samples: 1

**Called by:**
- `_invokeFused` (7)

**Calls:**
- `isNullCheck` (5)
- `isNullCheck` (1)

### `extraClassData`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (156us) | Total: 0.0% (156us) | Samples: 1

**Called by:**
- `get body` (1)

### `_ensureTagCaches`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (156us) | Total: 0.0% (156us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6588` | Self: 0.0% (156us) | Total: 0.0% (156us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:401` | Self: 0.0% (156us) | Total: 0.1% (1.1ms) | Samples: 1

**Called by:**
- `_buildVariable` (4)
- `_buildThinVariable` (3)

**Calls:**
- `get parent` (2)
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (156us) | Total: 0.0% (156us) | Samples: 1

**Called by:**
- `_computeIsStrict` (1)

### `e`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (156us) | Total: 0.0% (156us) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getTokenAfter`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (155us) | Total: 0.0% (155us) | Samples: 1

**Called by:**
- `getFunctionHeadLoc` (1)

### `checkLastSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:320` | Self: 0.0% (155us) | Total: 0.0% (155us) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2321` | Self: 0.0% (155us) | Total: 0.0% (155us) | Samples: 1

**Called by:**
- `ensureRefsThrough` (1)

### `getFirstToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:916` | Self: 0.0% (155us) | Total: 0.0% (155us) | Samples: 1

**Called by:**
- `getFunctionHeadLoc` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4240` | Self: 0.0% (155us) | Total: 0.0% (491us) | Samples: 1

**Called by:**
- `AstView` (3)

**Calls:**
- `fill` (2)

### `getVariableDescription`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:250` | Self: 0.0% (155us) | Total: 0.0% (155us) | Samples: 1

**Called by:**
- `getDefinedMessageData` (1)

### `get callee`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1871` | Self: 0.0% (155us) | Total: 0.0% (155us) | Samples: 1

**Called by:**
- `getArrayMethodName` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1693` | Self: 0.0% (155us) | Total: 0.0% (155us) | Samples: 1

**Called by:**
- `filter` (1)

### `_applySchemaDefaults`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:166` | Self: 0.0% (155us) | Total: 0.0% (155us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5947` | Self: 0.0% (154us) | Total: 0.0% (624us) | Samples: 1

**Called by:**
- `_runSelectorList` (4)

**Calls:**
- `nodeView` (2)
- `_nodeViewRaw` (1)

### `_extractBatchScannable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4630` | Self: 0.0% (154us) | Total: 0.0% (346us) | Samples: 1

**Called by:**
- `_buildPlan` (2)

**Calls:**
- `Map` (1)

### `_deepMergeArrays`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:134` | Self: 0.0% (154us) | Total: 0.0% (154us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `isTypeValueShadow`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:157` | Self: 0.0% (154us) | Total: 0.0% (154us) | Samples: 1

**Called by:**
- `checkForShadows` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4212` | Self: 0.0% (154us) | Total: 0.0% (307us) | Samples: 1

**Called by:**
- `runPlugins` (2)

**Calls:**
- `pluginKeyFromRuleId` (1)

### `startsWith`
`[native code]` | Self: 0.0% (154us) | Total: 0.0% (154us) | Samples: 1

**Called by:**
- `require` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7015` | Self: 0.0% (154us) | Total: 0.0% (154us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_getFfiSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:105` | Self: 0.0% (153us) | Total: 0.0% (153us) | Samples: 1

**Called by:**
- `_getOrBuildSelectorPlan` (1)

### `_scopeForNode`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:847` | Self: 0.0% (153us) | Total: 0.0% (153us) | Samples: 1

**Called by:**
- `getScope` (1)

### `/^[A-Z][A-Za-z]*$/`
`[native code]` | Self: 0.0% (153us) | Total: 0.0% (153us) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `checkGroup`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js` | Self: 0.0% (153us) | Total: 0.0% (153us) | Samples: 1

**Called by:**
- `forEach` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6449` | Self: 0.0% (153us) | Total: 0.0% (317us) | Samples: 1

**Called by:**
- `runPlugins` (2)

**Calls:**
- `has` (1)

### `invokeSelectorHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6022` | Self: 0.0% (153us) | Total: 0.0% (153us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:716` | Self: 0.0% (153us) | Total: 0.0% (153us) | Samples: 1

**Called by:**
- `collectUnusedVariables` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6491` | Self: 0.0% (152us) | Total: 0.0% (152us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6415` | Self: 0.0% (152us) | Total: 0.0% (152us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `reportReferenceId`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:242` | Self: 0.0% (152us) | Total: 0.0% (342us) | Samples: 1

**Called by:**
- `Program` (2)

**Calls:**
- `get right` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6814` | Self: 0.0% (152us) | Total: 0.0% (152us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `isThisParam`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:147` | Self: 0.0% (151us) | Total: 0.0% (151us) | Samples: 1

**Called by:**
- `checkForShadows` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2514` | Self: 0.0% (151us) | Total: 0.0% (151us) | Samples: 1

**Called by:**
- `getDeclaredVariables` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:730` | Self: 0.0% (151us) | Total: 0.0% (314us) | Samples: 1

**Called by:**
- `some` (2)

**Calls:**
- `isReadRef` (1)

### `toLength`
`[native code]` | Self: 0.0% (151us) | Total: 0.0% (151us) | Samples: 1

**Called by:**
- `some` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2721` | Self: 0.0% (151us) | Total: 0.0% (151us) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6461` | Self: 0.0% (151us) | Total: 0.0% (151us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `TokenType`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:115` | Self: 0.0% (151us) | Total: 0.0% (151us) | Samples: 1

**Called by:**
- `binop` (1)

### `unwrapExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:372` | Self: 0.0% (150us) | Total: 0.0% (150us) | Samples: 1

**Called by:**
- `isFunctionNameInitializerException` (1)

### `getVariableDescription`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:264` | Self: 0.0% (150us) | Total: 0.0% (150us) | Samples: 1

**Called by:**
- `getUsedIgnoredMessageData` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6469` | Self: 0.0% (150us) | Total: 0.0% (150us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `isSpecificMemberAccess`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:384` | Self: 0.0% (150us) | Total: 0.1% (1.2ms) | Samples: 1

**Called by:**
- `getArrayMethodName` (7)

**Calls:**
- `isSpecificId` (5)
- `_nodeViewRaw` (1)

### `shouldCheck`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:399` | Self: 0.0% (150us) | Total: 0.0% (150us) | Samples: 1

**Called by:**
- `filter` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1533` | Self: 0.0% (150us) | Total: 0.0% (345us) | Samples: 1

**Called by:**
- `_buildScope` (1)
- `getStaticStringValue` (1)

**Calls:**
- `_cookTemplate` (1)

### `_getTypeProto`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (150us) | Total: 0.0% (150us) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:123` | Self: 0.0% (150us) | Total: 0.0% (150us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `VariableDeclaration`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:549` | Self: 0.0% (150us) | Total: 0.8% (7.0ms) | Samples: 1

**Called by:**
- `_invokeFused` (42)

**Calls:**
- `getDeclaredVariables` (33)
- `getDeclaredVariables` (6)
- `getDeclaredVariables` (1)
- `getDeclaredVariables` (1)

### `get end`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1109` | Self: 0.0% (150us) | Total: 0.0% (150us) | Samples: 1

**Called by:**
- `invokeMethodFnHandlers` (1)

### `_identAt`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:751` | Self: 0.0% (149us) | Total: 0.0% (149us) | Samples: 1

**Called by:**
- `get name` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1662` | Self: 0.0% (149us) | Total: 0.0% (149us) | Samples: 1

**Called by:**
- `_precomputeScopes` (1)

### `/:([a-z-]+)\([^)]*\)/g`
`[native code]` | Self: 0.0% (149us) | Total: 0.0% (149us) | Samples: 1

**Called by:**
- `_getSelectorRootTypes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3101` | Self: 0.0% (149us) | Total: 0.0% (149us) | Samples: 1

**Called by:**
- `map` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:805` | Self: 0.0% (149us) | Total: 0.0% (149us) | Samples: 1

**Called by:**
- `getFirstToken` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3996` | Self: 0.0% (149us) | Total: 0.0% (149us) | Samples: 1

**Called by:**
- `get parent` (1)

### `accessPath`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5204` | Self: 0.0% (149us) | Total: 0.0% (149us) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `setName`
`node:fs` | Self: 0.0% (149us) | Total: 0.0% (149us) | Samples: 1

**Called by:**
- `node:fs` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4207` | Self: 0.0% (149us) | Total: 0.0% (857us) | Samples: 1

**Called by:**
- `AstView` (5)

**Calls:**
- `Uint32Array` (4)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5956` | Self: 0.0% (149us) | Total: 0.0% (149us) | Samples: 1

**Called by:**
- `_runSelectorList` (1)

### `isImportAttributeKey`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:1423` | Self: 0.0% (149us) | Total: 0.0% (149us) | Samples: 1

**Called by:**
- `Program` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:308` | Self: 0.0% (148us) | Total: 0.0% (430us) | Samples: 1

**Called by:**
- `parseSource` (3)

**Calls:**
- `Uint32Array` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7065` | Self: 0.0% (148us) | Total: 0.0% (285us) | Samples: 1

**Called by:**
- `runPlugins` (2)

**Calls:**
- `create` (1)

### `_ensureDeclSymIndex`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1598` | Self: 0.0% (148us) | Total: 0.0% (148us) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `/^:[a-z-]+\s*/`
`[native code]` | Self: 0.0% (148us) | Total: 0.0% (148us) | Samples: 1

**Called by:**
- `_getSelectorRootTypes` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4229` | Self: 0.0% (148us) | Total: 0.0% (148us) | Samples: 1

**Called by:**
- `AstView` (1)

### `get start`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1094` | Self: 0.0% (148us) | Total: 0.0% (148us) | Samples: 1

**Called by:**
- `_execReport` (1)

### `get nodeTags`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (148us) | Total: 0.0% (148us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (148us) | Total: 0.0% (148us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `findVariablesInScope`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:94` | Self: 0.0% (148us) | Total: 0.6% (5.4ms) | Samples: 1

**Called by:**
- `Program` (31)
- `checkForBlock` (1)

**Calls:**
- `get` (31)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1727` | Self: 0.0% (148us) | Total: 0.0% (148us) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `isInside`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:494` | Self: 0.0% (147us) | Total: 0.0% (617us) | Samples: 1

**Called by:**
- `isReadForItself` (3)
- `isStorableFunction` (1)

**Calls:**
- `get range` (2)
- `get range` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (147us) | Total: 0.0% (147us) | Samples: 1

**Called by:**
- `ensureChildren` (1)

### `getArrayMethodName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:116` | Self: 0.0% (147us) | Total: 0.4% (3.8ms) | Samples: 1

**Called by:**
- `onCodePathStart` (22)

**Calls:**
- `isSpecificMemberAccess` (7)
- `isSpecificMemberAccess` (2)
- `isSpecificMemberAccess` (2)
- `_getChainExpr` (1)
- `_nodeViewRaw` (1)
- `get callee` (1)
- `isSpecificMemberAccess` (1)
- `isArrayFromMethod` (1)
- `nodeViewChain` (1)
- `get callee` (1)
- `nodeViewChain` (1)
- `_nodeViewRaw` (1)
- `isSpecificMemberAccess` (1)

### `nodeViewChain`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4062` | Self: 0.0% (147us) | Total: 0.0% (338us) | Samples: 1

**Called by:**
- `(anonymous)` (1)
- `getArrayMethodName` (1)

**Calls:**
- `_isChainChild` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4225` | Self: 0.0% (147us) | Total: 0.0% (493us) | Samples: 1

**Called by:**
- `AstView` (3)

**Calls:**
- `Uint32Array` (2)

### `get property`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1941` | Self: 0.0% (147us) | Total: 0.0% (147us) | Samples: 1

**Called by:**
- `isModifyingProp` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1645` | Self: 0.0% (147us) | Total: 0.0% (147us) | Samples: 1

**Called by:**
- `_buildScopeChildren` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1182` | Self: 0.0% (146us) | Total: 0.0% (146us) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2578` | Self: 0.0% (146us) | Total: 0.0% (146us) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1238` | Self: 0.0% (146us) | Total: 0.0% (146us) | Samples: 1

**Called by:**
- `getDestructuringHost` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:676` | Self: 0.0% (146us) | Total: 0.0% (146us) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_buildScopeChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2331` | Self: 0.0% (146us) | Total: 0.0% (146us) | Samples: 1

**Called by:**
- `ensureChildren` (1)

### `_computeMinTok`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:529` | Self: 0.0% (146us) | Total: 0.0% (146us) | Samples: 1

**Called by:**
- `getFirstToken` (1)

### `_getOrBuildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5441` | Self: 0.0% (145us) | Total: 0.0% (145us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6459` | Self: 0.0% (145us) | Total: 0.0% (145us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `ExportAllDeclaration > Identifier.exported,ExportSpecifier > Identifier.exported`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:398` | Self: 0.0% (145us) | Total: 0.0% (145us) | Samples: 1

**Called by:**
- `_runSelectorList` (1)

### `get id`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2269` | Self: 0.0% (145us) | Total: 0.0% (502us) | Samples: 1

**Called by:**
- `_buildScope` (2)
- `getFunctionNameWithKind` (1)

**Calls:**
- `extraFnData` (2)

### `async (anonymous)`
`[native code]` | Self: 0.0% (145us) | Total: 99.9% (857.7ms) | Samples: 1

**Called by:**
- `async (anonymous)` (3)
- `requestInstantiate` (3)

**Calls:**
- `parseModule` (4955)
- `async (anonymous)` (3)
- `requestFetch` (2)
- `resolve` (1)

### `getStaticPropertyName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:327` | Self: 0.0% (145us) | Total: 0.0% (602us) | Samples: 1

**Called by:**
- `isSpecificMemberAccess` (3)
- `onCodePathStart` (1)

**Calls:**
- `get type` (1)
- `get computed` (1)
- `get type` (1)

### `getAssignedMessageData`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:310` | Self: 0.0% (145us) | Total: 0.0% (145us) | Samples: 1

**Called by:**
- `Program:exit` (1)

### `_dispatchSeg`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6108` | Self: 0.0% (144us) | Total: 0.0% (144us) | Samples: 1

**Called by:**
- `_fireCfgEvents` (1)

### `fullMethodName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:56` | Self: 0.0% (144us) | Total: 0.0% (144us) | Samples: 1

**Called by:**
- `checkLastSegment` (1)

### `_ensureTagCaches`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5522` | Self: 0.0% (144us) | Total: 0.0% (144us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `ImportDeclaration`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:372` | Self: 0.0% (144us) | Total: 0.0% (144us) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js` | Self: 0.0% (144us) | Total: 0.0% (144us) | Samples: 1

**Called by:**
- `getRhsNode` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (143us) | Total: 0.0% (143us) | Samples: 1

**Called by:**
- `getScope` (1)

### `getTagNames`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:190` | Self: 0.0% (143us) | Total: 0.0% (143us) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6359` | Self: 0.0% (143us) | Total: 0.0% (143us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1798` | Self: 0.0% (143us) | Total: 0.0% (143us) | Samples: 1

**Called by:**
- `get` (1)

### `checkGroup`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:475` | Self: 0.0% (143us) | Total: 0.0% (143us) | Samples: 1

**Called by:**
- `forEach` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:419` | Self: 0.0% (143us) | Total: 0.0% (439us) | Samples: 1

**Called by:**
- `parseSource` (3)

**Calls:**
- `Uint32Array` (2)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (143us) | Total: 0.0% (143us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4251` | Self: 0.0% (142us) | Total: 0.0% (142us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (142us) | Total: 0.0% (142us) | Samples: 1

**Called by:**
- `getFunctionHeadLoc` (1)

### `get right`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1788` | Self: 0.0% (142us) | Total: 0.0% (332us) | Samples: 1

**Called by:**
- `getRhsNode` (1)
- `reportReferenceId` (1)

**Calls:**
- `nodeLhs` (1)

### `groupByDestructuring`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:290` | Self: 0.0% (142us) | Total: 0.4% (3.9ms) | Samples: 1

**Called by:**
- `Program:exit` (23)

**Calls:**
- `getIdentifierIfShouldBeConst` (7)
- `getIdentifierIfShouldBeConst` (3)
- `getIdentifierIfShouldBeConst` (2)
- `getIdentifierIfShouldBeConst` (1)
- `getIdentifierIfShouldBeConst` (1)
- `getIdentifierIfShouldBeConst` (1)
- `getIdentifierIfShouldBeConst` (1)
- `getIdentifierIfShouldBeConst` (1)
- `getIdentifierIfShouldBeConst` (1)
- `getIdentifierIfShouldBeConst` (1)
- `getIdentifierIfShouldBeConst` (1)
- `getIdentifierIfShouldBeConst` (1)
- `getIdentifierIfShouldBeConst` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (142us) | Total: 0.0% (142us) | Samples: 1

**Called by:**
- `_buildScopeRefsAndThrough` (1)

### `get decorators`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2088` | Self: 0.0% (142us) | Total: 0.0% (329us) | Samples: 1

**Called by:**
- `isClassRefInClassDecorator` (2)

**Calls:**
- `get mainToken` (1)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2571` | Self: 0.0% (142us) | Total: 0.0% (731us) | Samples: 1

**Called by:**
- `_buildScopeVarsAndSet` (4)
- `getDeclaredVariables` (1)

**Calls:**
- `get parent` (2)
- `get parent` (2)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5249` | Self: 0.0% (142us) | Total: 0.0% (142us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:416` | Self: 0.0% (142us) | Total: 0.0% (142us) | Samples: 1

**Called by:**
- `_buildVariable` (1)

### `isImportAttributeKey`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:1422` | Self: 0.0% (142us) | Total: 0.0% (142us) | Samples: 1

**Called by:**
- `Program` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6625` | Self: 0.0% (141us) | Total: 0.0% (141us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2910` | Self: 0.0% (141us) | Total: 0.0% (141us) | Samples: 1

**Called by:**
- `_buildReference` (1)

### `get computed`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (141us) | Total: 0.0% (141us) | Samples: 1

**Called by:**
- `accessPath` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6752` | Self: 0.0% (141us) | Total: 0.0% (141us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3574` | Self: 0.0% (141us) | Total: 0.0% (282us) | Samples: 1

**Called by:**
- `_buildVariable` (1)
- `(anonymous)` (1)

**Calls:**
- `_isStatementTag` (1)

### `create`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:76` | Self: 0.0% (141us) | Total: 0.0% (141us) | Samples: 1

**Called by:**
- `buildVisitorMap` (1)

### `_loadFromDisk`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js` | Self: 0.0% (141us) | Total: 0.0% (141us) | Samples: 1

**Called by:**
- `_getPlugin` (1)

### `isModifyingProp`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:134` | Self: 0.0% (141us) | Total: 0.0% (288us) | Samples: 1

**Called by:**
- `checkReference` (2)

**Calls:**
- `get property` (1)

### `getDestructuringHost`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:107` | Self: 0.0% (141us) | Total: 0.0% (141us) | Samples: 1

**Called by:**
- `getIdentifierIfShouldBeConst` (1)

### `_isStatementTag`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (141us) | Total: 0.0% (141us) | Samples: 1

**Called by:**
- `get range` (1)

### `getTagNames`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js` | Self: 0.0% (140us) | Total: 0.0% (140us) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:402` | Self: 0.0% (140us) | Total: 0.1% (975us) | Samples: 1

**Called by:**
- `parseSource` (6)

**Calls:**
- `Uint32Array` (4)
- `getUint32` (1)

### `referenceContainsTypeQuery`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:227` | Self: 0.0% (140us) | Total: 0.0% (325us) | Samples: 1

**Called by:**
- `referenceContainsTypeQuery` (1)
- `shouldCheck` (1)

**Calls:**
- `get type` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2275` | Self: 0.0% (139us) | Total: 0.0% (139us) | Samples: 1

**Called by:**
- `ensureRefsThrough` (1)

### `isExternalDeclarationMerging`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:577` | Self: 0.0% (139us) | Total: 0.0% (139us) | Samples: 1

**Called by:**
- `checkForShadows` (1)

### `node:child_process`
`node:child_process:10` | Self: 0.0% (139us) | Total: 0.0% (139us) | Samples: 1

**Called by:**
- `anonymous` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1887` | Self: 0.0% (139us) | Total: 0.0% (139us) | Samples: 1

**Called by:**
- `checkReferencesInScope` (1)

### `isTypeValueShadow`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js` | Self: 0.0% (138us) | Total: 0.0% (138us) | Samples: 1

**Called by:**
- `checkForShadows` (1)

### `invokeSelectorHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (138us) | Total: 0.0% (138us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:399` | Self: 0.0% (138us) | Total: 0.0% (318us) | Samples: 1

**Called by:**
- `_buildVariable` (2)

**Calls:**
- `get _tag` (1)

### `(anonymous)`
`[native code]` | Self: 0.0% (138us) | Total: 0.1% (1.0ms) | Samples: 1

**Called by:**
- `bound require` (4)

**Calls:**
- `dlopen` (3)
- `requestSatisfyUtil` (2)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:681` | Self: 0.0% (137us) | Total: 0.0% (319us) | Samples: 1

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `get type` (1)

### `ReturnStatement`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:480` | Self: 0.0% (137us) | Total: 0.0% (300us) | Samples: 1

**Called by:**
- `_invokeFused` (2)

**Calls:**
- `get argument` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:222` | Self: 0.0% (137us) | Total: 0.0% (137us) | Samples: 1

**Called by:**
- `map` (1)

### `get allSkipped`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4791` | Self: 0.0% (137us) | Total: 0.0% (137us) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1969` | Self: 0.0% (136us) | Total: 0.0% (136us) | Samples: 1

**Called by:**
- `ensureVarsSet` (1)

### `_buildSymNameCache`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:815` | Self: 0.0% (136us) | Total: 0.0% (136us) | Samples: 1

**Called by:**
- `_symName` (1)

### `isInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js` | Self: 0.0% (136us) | Total: 0.0% (136us) | Samples: 1

**Called by:**
- `isInitPatternNode` (1)

### `getIdentifierIfShouldBeConst`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:229` | Self: 0.0% (135us) | Total: 0.0% (135us) | Samples: 1

**Called by:**
- `groupByDestructuring` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:815` | Self: 0.0% (135us) | Total: 0.0% (499us) | Samples: 1

**Called by:**
- `Program:exit` (3)

**Calls:**
- `get type` (2)

### `findVariablesInScope`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:96` | Self: 0.0% (135us) | Total: 0.0% (524us) | Samples: 1

**Called by:**
- `Program` (3)

**Calls:**
- `iterateDeclarations` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7083` | Self: 0.0% (134us) | Total: 0.0% (134us) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `segment`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4251` | Self: 0.0% (134us) | Total: 0.0% (134us) | Samples: 1

**Called by:**
- `initialSegment` (1)

### `ensureRefsThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (134us) | Total: 0.0% (134us) | Samples: 1

**Called by:**
- `get` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:868` | Self: 0.0% (134us) | Total: 0.2% (2.0ms) | Samples: 1

**Called by:**
- `get body` (7)
- `get body` (4)
- `checkGroup` (1)

**Calls:**
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (2)
- `nodeView` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:931` | Self: 0.0% (0us) | Total: 0.0% (183us) | Samples: 0

**Called by:**
- `Program:exit` (1)

**Calls:**
- `test` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1421` | Self: 0.0% (0us) | Total: 0.0% (175us) | Samples: 0

**Called by:**
- `isNullLiteral` (1)

**Calls:**
- `replace` (1)

### `_tryLoad`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:34` | Self: 0.0% (0us) | Total: 0.0% (340us) | Samples: 0

**Called by:**
- `isAvailable` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:436` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `forEach` (7)

**Calls:**
- `report` (7)

### `fn`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5100` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `fn` (7)
- `_runSelectorList` (4)

**Calls:**
- `(anonymous)` (5)
- `(anonymous)` (3)
- `(anonymous)` (3)

### `checkVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:228` | Self: 0.0% (0us) | Total: 0.2% (2.4ms) | Samples: 0

**Called by:**
- `forEach` (13)

**Calls:**
- `forEach` (13)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:14` | Self: 0.0% (0us) | Total: 0.0% (821us) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `get property`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1943` | Self: 0.0% (0us) | Total: 0.0% (360us) | Samples: 0

**Called by:**
- `fn` (1)
- `getStaticPropertyName` (1)

**Calls:**
- `nodeRhs` (2)

### `isClassRefInClassDecorator`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:254` | Self: 0.0% (0us) | Total: 0.0% (329us) | Samples: 0

**Called by:**
- `shouldCheck` (2)

**Calls:**
- `get decorators` (2)

### `ensureRefsThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1830` | Self: 0.0% (0us) | Total: 0.2% (2.5ms) | Samples: 0

**Called by:**
- `get` (16)

**Calls:**
- `get` (16)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:727` | Self: 0.0% (0us) | Total: 0.9% (8.2ms) | Samples: 0

**Called by:**
- `some` (47)

**Calls:**
- `getRhsNode` (44)
- `getRhsNode` (1)
- `getRhsNode` (1)
- `getRhsNode` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1676` | Self: 0.0% (0us) | Total: 0.0% (182us) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `nodeLhs` (1)

### `node:fs/promises`
`node:fs/promises:2` | Self: 0.0% (0us) | Total: 0.0% (188us) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `get arguments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1898` | Self: 0.0% (0us) | Total: 0.0% (193us) | Samples: 0

**Called by:**
- `getArrayMethodName` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `Program`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:147` | Self: 0.0% (0us) | Total: 1.3% (11.8ms) | Samples: 0

**Called by:**
- `_invokeFused` (69)

**Calls:**
- `findVariablesInScope` (35)
- `findVariablesInScope` (31)
- `findVariablesInScope` (3)

### `getVariableDescription`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:261` | Self: 0.0% (0us) | Total: 0.0% (158us) | Samples: 0

**Called by:**
- `getAssignedMessageData` (1)

**Calls:**
- `toString` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1886` | Self: 0.0% (0us) | Total: 8.6% (74.1ms) | Samples: 0

**Called by:**
- `_buildScopeRefsAndThrough` (414)
- `getVariableByName` (19)

**Calls:**
- `ensureVarsSet` (433)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:289` | Self: 0.0% (0us) | Total: 0.0% (172us) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `getUint32` (1)

### `node:child_process`
`node:child_process:2` | Self: 0.0% (0us) | Total: 0.0% (182us) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `Ae`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.1% (1.0ms) | Samples: 0

**Called by:**
- `parse` (6)

**Calls:**
- `_e` (6)

### `equalsToOriginalName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:186` | Self: 0.0% (0us) | Total: 0.0% (186us) | Samples: 0

**Called by:**
- `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause` (1)

**Calls:**
- `getModuleExportName` (1)

### `checkGroup`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:412` | Self: 0.0% (0us) | Total: 0.0% (171us) | Samples: 0

**Called by:**
- `forEach` (1)

**Calls:**
- `findUp` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.3% (2.6ms) | Samples: 0

**Called by:**
- `anonymous` (16)

**Calls:**
- `bound require` (16)

### `checkReference`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:202` | Self: 0.0% (0us) | Total: 0.0% (323us) | Samples: 0

**Called by:**
- `forEach` (2)

**Calls:**
- `report` (2)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3067` | Self: 0.0% (0us) | Total: 0.0% (158us) | Samples: 0

**Called by:**
- `checkForFunction` (1)

**Calls:**
- `get` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:224` | Self: 0.0% (0us) | Total: 5.5% (47.5ms) | Samples: 0

**Called by:**
- `runOnce` (276)

**Calls:**
- `parse` (276)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1205` | Self: 0.0% (0us) | Total: 0.0% (339us) | Samples: 0

**Called by:**
- `getArrayMethodName` (1)
- `isAssignmentTarget` (1)

**Calls:**
- `_getChainExpr` (2)

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

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6894` | Self: 0.0% (0us) | Total: 1.0% (9.3ms) | Samples: 0

**Called by:**
- `runPlugins` (54)

**Calls:**
- `_fireCfgEvents` (40)
- `_fireCfgEvents` (5)
- `_fireCfgEvents` (3)
- `_fireCfgEvents` (3)
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6558` | Self: 0.0% (0us) | Total: 0.0% (170us) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `get` (1)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2813` | Self: 0.0% (0us) | Total: 0.6% (5.2ms) | Samples: 0

**Called by:**
- `_buildScopeRefsAndThrough` (24)
- `_buildVariable` (5)

**Calls:**
- `get parent` (11)
- `get parent` (8)
- `get parent` (2)
- `get parent` (2)
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:429` | Self: 0.0% (0us) | Total: 0.0% (476us) | Samples: 0

**Called by:**
- `parseSource` (3)

**Calls:**
- `Uint32Array` (3)

### `_compileSelectorFastMatcher`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5142` | Self: 0.0% (0us) | Total: 0.3% (2.8ms) | Samples: 0

**Called by:**
- `_getOrBuildSelectorPlan` (16)

**Calls:**
- `_compileSelectorFastMatcher` (4)
- `_compileSelectorFastMatcher` (3)
- `_compileSelectorFastMatcher` (2)
- `_compileSelectorFastMatcher` (2)
- `_compileSelectorFastMatcher` (1)
- `_compileSelectorFastMatcher` (1)
- `_compileSelectorFastMatcher` (1)
- `_compileSelectorFastMatcher` (1)
- `_compileSelectorFastMatcher` (1)

### `isSpecificMemberAccess`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:378` | Self: 0.0% (0us) | Total: 0.0% (366us) | Samples: 0

**Called by:**
- `getArrayMethodName` (2)

**Calls:**
- `skipChainExpression` (2)

### `isNullCheck`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:126` | Self: 0.0% (0us) | Total: 0.0% (187us) | Samples: 0

**Called by:**
- `BinaryExpression` (1)

**Calls:**
- `get left` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3606` | Self: 0.0% (0us) | Total: 0.0% (172us) | Samples: 0

**Called by:**
- `iterateDeclarations` (1)

**Calls:**
- `_nodeEndPos` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5688` | Self: 0.0% (0us) | Total: 0.0% (547us) | Samples: 0

**Called by:**
- `_getOrBuildPlan` (3)

**Calls:**
- `endsWith` (3)

### `isInTdz`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:490` | Self: 0.0% (0us) | Total: 0.0% (167us) | Samples: 0

**Called by:**
- `checkForShadows` (1)

**Calls:**
- `getNameRange` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:202` | Self: 0.0% (0us) | Total: 0.0% (150us) | Samples: 0

**Called by:**
- `MemberExpression[computed!=true] > Identifier.property` (1)

**Calls:**
- `get range` (1)

### `BinaryExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:186` | Self: 0.0% (0us) | Total: 0.0% (194us) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `get operator` (1)

### `ke`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (698us) | Samples: 0

**Called by:**
- `we` (4)

**Calls:**
- `(anonymous)` (3)
- `(anonymous)` (1)

### `isModifyingProp`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:96` | Self: 0.0% (0us) | Total: 0.0% (175us) | Samples: 0

**Called by:**
- `checkReference` (1)

**Calls:**
- `get type` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` | Self: 0.0% (0us) | Total: 0.1% (1.1ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `iterateDeclarations`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:77` | Self: 0.0% (0us) | Total: 0.0% (490us) | Samples: 0

**Called by:**
- `generatorResume` (3)

**Calls:**
- `getNameLocationInGlobalDirectiveComment` (1)
- `getNameLocationInGlobalDirectiveComment` (1)
- `getNameLocationInGlobalDirectiveComment` (1)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4871` | Self: 0.0% (0us) | Total: 0.0% (181us) | Samples: 0

**Called by:**
- `_buildPlan` (1)

**Calls:**
- `has` (1)

### `isModifyingProp`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:141` | Self: 0.0% (0us) | Total: 0.0% (186us) | Samples: 0

**Called by:**
- `checkReference` (1)

**Calls:**
- `get key` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:661` | Self: 0.0% (0us) | Total: 0.1% (920us) | Samples: 0

**Called by:**
- `(anonymous)` (6)

**Calls:**
- `isInside` (3)
- `isInside` (3)

### `getFirstToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:984` | Self: 0.0% (0us) | Total: 0.0% (636us) | Samples: 0

**Called by:**
- `getFunctionHeadLoc` (4)

**Calls:**
- `_makeToken` (2)
- `_makeToken` (1)
- `_makeToken` (1)

### `checkLastSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:380` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `_invokeFused` (9)

**Calls:**
- `getFunctionNameWithKind` (2)
- `getFunctionNameWithKind` (1)
- `getFunctionNameWithKind` (1)
- `getFunctionNameWithKind` (1)
- `join` (1)
- `getFunctionNameWithKind` (1)
- `getFunctionNameWithKind` (1)
- `getFunctionNameWithKind` (1)

### `checkGroup`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:426` | Self: 0.0% (0us) | Total: 0.0% (176us) | Samples: 0

**Called by:**
- `forEach` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` | Self: 0.0% (0us) | Total: 0.1% (1.1ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `(anonymous)` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` | Self: 0.0% (0us) | Total: 0.0% (821us) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `bound require` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:20` | Self: 0.0% (0us) | Total: 0.3% (2.6ms) | Samples: 0

**Called by:**
- `parseModule` (15)

**Calls:**
- `bound require` (15)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:12` | Self: 0.0% (0us) | Total: 0.0% (341us) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2462` | Self: 0.0% (0us) | Total: 0.0% (329us) | Samples: 0

**Called by:**
- `getScope` (2)

**Calls:**
- `performIteration` (2)

### `initialSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4343` | Self: 0.0% (0us) | Total: 0.0% (327us) | Samples: 0

**Called by:**
- `_fireCfgEvents` (2)

**Calls:**
- `segment` (1)
- `segment` (1)

### `isSpecificMemberAccess`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:389` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `getArrayMethodName` (6)
- `getArrayMethodName` (2)

**Calls:**
- `getStaticPropertyName` (3)
- `getStaticPropertyName` (2)
- `getStaticStringValue` (1)
- `getStaticPropertyName` (1)
- `getStaticPropertyName` (1)

### `shouldCheck`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:413` | Self: 0.0% (0us) | Total: 0.0% (329us) | Samples: 0

**Called by:**
- `filter` (2)

**Calls:**
- `isClassRefInClassDecorator` (2)

### `_getSelectorRootTypes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5554` | Self: 0.0% (0us) | Total: 0.0% (293us) | Samples: 0

**Called by:**
- `_getSelectorRootTypes` (1)
- `_buildPlan` (1)

**Calls:**
- `endsWith` (2)

### `find`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (195us) | Samples: 0

**Called by:**
- `_compileSelectorFastMatcher` (1)

**Calls:**
- `(anonymous)` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4210` | Self: 0.0% (0us) | Total: 0.0% (352us) | Samples: 0

**Called by:**
- `AstView` (2)

**Calls:**
- `Uint32Array` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2066` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `ensureVarsSet` (8)

**Calls:**
- `regExpMatchFast` (6)
- `[Symbol.match]` (2)

### `isAnySegmentReachable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:39` | Self: 0.0% (0us) | Total: 0.0% (163us) | Samples: 0

**Called by:**
- `checkLastSegment` (1)

**Calls:**
- `next` (1)

### `tryParse`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:126` | Self: 0.0% (0us) | Total: 0.0% (490us) | Samples: 0

**Called by:**
- `_loadFromDisk` (3)

**Calls:**
- `parse` (3)

### `getScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1528` | Self: 0.0% (0us) | Total: 0.0% (153us) | Samples: 0

**Called by:**
- `checkForBlock` (1)

**Calls:**
- `_scopeForNode` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4249` | Self: 0.0% (0us) | Total: 0.4% (3.7ms) | Samples: 0

**Called by:**
- `runPlugins` (22)

**Calls:**
- `_expandUnion` (9)
- `_expandUnion` (5)
- `_expandUnion` (4)
- `_expandUnion` (3)
- `map` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:193` | Self: 0.0% (0us) | Total: 0.0% (151us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `binop` (1)

### `_e`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.1% (1.0ms) | Samples: 0

**Called by:**
- `Ae` (6)

**Calls:**
- `Pe` (6)

### `getIdentifierIfShouldBeConst`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:207` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `groupByDestructuring` (7)

**Calls:**
- `getDestructuringHost` (3)
- `getDestructuringHost` (2)
- `getDestructuringHost` (1)
- `getDestructuringHost` (1)

### `isInsideOfStorableFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:630` | Self: 0.0% (0us) | Total: 0.0% (191us) | Samples: 0

**Called by:**
- `isReadForItself` (1)

**Calls:**
- `getUpperFunction` (1)

### `binop`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:130` | Self: 0.0% (0us) | Total: 0.0% (151us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `TokenType` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:466` | Self: 0.0% (0us) | Total: 0.0% (177us) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `Uint32Array` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4205` | Self: 0.0% (0us) | Total: 0.0% (168us) | Samples: 0

**Called by:**
- `AstView` (1)

**Calls:**
- `Uint32Array` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6218` | Self: 0.0% (0us) | Total: 0.0% (197us) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `invokeHandlersWithNode` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2369` | Self: 0.0% (0us) | Total: 13.3% (114.8ms) | Samples: 0

**Called by:**
- `getScope` (673)

**Calls:**
- `get` (673)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:162` | Self: 0.0% (0us) | Total: 0.0% (343us) | Samples: 0

**Called by:**
- `BinaryExpression` (2)

**Calls:**
- `report` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7165` | Self: 0.0% (0us) | Total: 0.0% (296us) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:511` | Self: 0.0% (0us) | Total: 0.2% (1.9ms) | Samples: 0

**Called by:**
- `runPlugins` (11)
- `runPlugins` (1)

**Calls:**
- `decode` (12)

### `parse`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `g` (7)

**Calls:**
- `Ae` (6)
- `Ae` (1)

### `checkReference`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:210` | Self: 0.0% (0us) | Total: 0.0% (385us) | Samples: 0

**Called by:**
- `forEach` (2)

**Calls:**
- `some` (1)
- `get name` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:428` | Self: 0.0% (0us) | Total: 0.0% (154us) | Samples: 0

**Called by:**
- `_buildThinVariable` (1)

**Calls:**
- `_tag` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/escape-string-regexp/index.js:11` | Self: 0.0% (0us) | Total: 0.0% (320us) | Samples: 0

**Called by:**
- `getNameLocationInGlobalDirectiveComment` (2)

**Calls:**
- `replace` (2)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:413` | Self: 0.0% (0us) | Total: 0.0% (357us) | Samples: 0

**Called by:**
- `parseSource` (2)

**Calls:**
- `Uint32Array` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:510` | Self: 0.0% (0us) | Total: 0.1% (1.1ms) | Samples: 0

**Called by:**
- `forEach` (5)

**Calls:**
- `report` (5)

### `ObjectExpression > Property[computed!=true] > Identifier.key,MethodDefinition[computed!=true] > Identifier.key,PropertyDefinition[computed!=true] > Identifier.key,MethodDefinition > PrivateIdentifier.key,PropertyDefinition > PrivateIdentifier.key`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:352` | Self: 0.0% (0us) | Total: 0.0% (554us) | Samples: 0

**Called by:**
- `_runSelectorList` (3)

**Calls:**
- `isImportAttributeKey` (1)
- `isImportAttributeKey` (1)
- `isImportAttributeKey` (1)

### `getIdentifierIfShouldBeConst`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:261` | Self: 0.0% (0us) | Total: 0.0% (347us) | Samples: 0

**Called by:**
- `groupByDestructuring` (2)

**Calls:**
- `canBecomeVariableDeclaration` (1)
- `canBecomeVariableDeclaration` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1929` | Self: 0.0% (0us) | Total: 0.0% (321us) | Samples: 0

**Called by:**
- `_buildScope` (2)

**Calls:**
- `get directive` (1)
- `get directive` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` | Self: 0.0% (0us) | Total: 0.0% (694us) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `bound require` (4)

### `getFunctionHeadLoc`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2299` | Self: 0.0% (0us) | Total: 0.0% (318us) | Samples: 0

**Called by:**
- `checkLastSegment` (2)

**Calls:**
- `getTokenBefore` (1)
- `getTokenBefore` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:721` | Self: 0.0% (0us) | Total: 0.1% (950us) | Samples: 0

**Called by:**
- `some` (6)

**Calls:**
- `isForInOfRef` (2)
- `isForInOfRef` (1)
- `isForInOfRef` (1)
- `isForInOfRef` (1)
- `isForInOfRef` (1)

### `reportReferenceId`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:251` | Self: 0.0% (0us) | Total: 0.0% (184us) | Samples: 0

**Called by:**
- `Program` (1)

**Calls:**
- `equalsToOriginalName` (1)

### `dlopen`
`bun:ffi:345` | Self: 0.0% (0us) | Total: 0.0% (833us) | Samples: 0

**Called by:**
- `_tryLoad` (5)

**Calls:**
- `dlopen` (5)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4213` | Self: 0.0% (0us) | Total: 0.0% (350us) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `ruleNameFromRuleId` (2)

### `Program`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:268` | Self: 0.0% (0us) | Total: 2.4% (21.1ms) | Samples: 0

**Called by:**
- `_invokeFused` (117)

**Calls:**
- `getScope` (117)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6863` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `runPlugins` (8)

**Calls:**
- `getDFSEvents` (4)
- `getDFSEvents` (3)
- `getDFSEvents` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:575` | Self: 0.0% (0us) | Total: 0.0% (182us) | Samples: 0

**Called by:**
- `_precomputeScopes` (1)

**Calls:**
- `_findLineIdx` (1)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:179` | Self: 0.0% (0us) | Total: 0.4% (3.8ms) | Samples: 0

**Called by:**
- `getRhsNode` (21)

**Calls:**
- `isFunction` (21)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7382` | Self: 0.0% (0us) | Total: 74.1% (635.8ms) | Samples: 0

**Called by:**
- `runOnce` (3697)

**Calls:**
- `walkNodes` (1087)
- `walkNodes` (970)
- `walkNodes` (355)
- `walkNodes` (181)
- `walkNodes` (119)
- `walkNodes` (97)
- `walkNodes` (95)
- `walkNodes` (93)
- `walkNodes` (89)
- `walkNodes` (54)
- `walkNodes` (49)
- `walkNodes` (35)
- `walkNodes` (32)
- `walkNodes` (24)
- `walkNodes` (24)
- `walkNodes` (22)
- `walkNodes` (16)
- `walkNodes` (16)
- `walkNodes` (14)
- `walkNodes` (14)
- `walkNodes` (13)
- `walkNodes` (13)
- `walkNodes` (12)
- `walkNodes` (11)
- `walkNodes` (11)
- `walkNodes` (11)
- `walkNodes` (9)
- `walkNodes` (8)
- `walkNodes` (8)
- `walkNodes` (8)
- `walkNodes` (7)
- `walkNodes` (7)
- `walkNodes` (7)
- `walkNodes` (7)
- `walkNodes` (6)
- `walkNodes` (6)
- `walkNodes` (6)
- `walkNodes` (5)
- `walkNodes` (5)
- `walkNodes` (5)
- `walkNodes` (5)
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

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:720` | Self: 0.0% (0us) | Total: 0.8% (7.4ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (43)

**Calls:**
- `some` (43)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1744` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `checkForShadows` (5)
- `collectUnusedVariables` (3)

**Calls:**
- `ensureFenVars` (8)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7376` | Self: 0.0% (0us) | Total: 0.0% (151us) | Samples: 0

**Called by:**
- `runOnce` (1)

**Calls:**
- `get source` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6898` | Self: 0.0% (0us) | Total: 0.9% (8.2ms) | Samples: 0

**Called by:**
- `runPlugins` (49)

**Calls:**
- `invokeSelectorHandlers` (45)
- `invokeSelectorHandlers` (2)
- `invokeSelectorHandlers` (1)
- `invokeSelectorHandlers` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5734` | Self: 0.0% (0us) | Total: 0.0% (176us) | Samples: 0

**Called by:**
- `_getOrBuildPlan` (1)

**Calls:**
- `get` (1)

### `safeHandler`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3822` | Self: 0.0% (0us) | Total: 3.5% (30.7ms) | Samples: 0

**Called by:**
- `walkNodes` (180)

**Calls:**
- `Program` (180)

### `_buildReference`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2809` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `_buildScopeRefsAndThrough` (8)
- `_buildVariable` (1)

**Calls:**
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (2)
- `nodeView` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:662` | Self: 0.0% (0us) | Total: 0.0% (708us) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `isStorableFunction` (1)
- `isStorableFunction` (1)
- `isInsideOfStorableFunction` (1)
- `isInsideOfStorableFunction` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` | Self: 0.0% (0us) | Total: 0.1% (1.1ms) | Samples: 0

**Called by:**
- `anonymous` (6)
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (4)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `bound require` (1)

### `internal:validators`
`internal:validators:2` | Self: 0.0% (0us) | Total: 0.0% (630us) | Samples: 0

**Called by:**
- `anonymous` (4)

**Calls:**
- `anonymous` (4)

### `checkForShadows`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:659` | Self: 0.0% (0us) | Total: 0.0% (177us) | Samples: 0

**Called by:**
- `Program:exit` (1)

**Calls:**
- `isGenericOfAStaticMethodShadow` (1)

### `checkLastSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:388` | Self: 0.0% (0us) | Total: 0.0% (306us) | Samples: 0

**Called by:**
- `_invokeFused` (2)

**Calls:**
- `fullMethodName` (1)
- `fullMethodName` (1)

### `checkForShadows`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:654` | Self: 0.0% (0us) | Total: 0.0% (509us) | Samples: 0

**Called by:**
- `Program:exit` (3)

**Calls:**
- `isInitPatternNode` (3)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4200` | Self: 0.0% (0us) | Total: 0.5% (4.5ms) | Samples: 0

**Called by:**
- `runPlugins` (27)

**Calls:**
- `_applySchemaDefaults` (15)
- `_applySchemaDefaults` (5)
- `_applySchemaDefaults` (4)
- `_applySchemaDefaults` (1)
- `_applySchemaDefaults` (1)
- `_applySchemaDefaults` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:475` | Self: 0.0% (0us) | Total: 0.0% (136us) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `getUint32` (1)

### `internal:validators`
`internal:validators:47` | Self: 0.0% (0us) | Total: 0.0% (188us) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `hideFromStack` (1)

### `VariableDeclaration`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:548` | Self: 0.0% (0us) | Total: 0.0% (527us) | Samples: 0

**Called by:**
- `_invokeFused` (3)

**Calls:**
- `isInitOfForStatement` (3)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5678` | Self: 0.0% (0us) | Total: 0.0% (371us) | Samples: 0

**Called by:**
- `_getOrBuildPlan` (2)

**Calls:**
- `some` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:221` | Self: 0.0% (0us) | Total: 0.0% (145us) | Samples: 0

**Called by:**
- `filter` (1)

**Calls:**
- `get value` (1)

### `getIdentifierIfShouldBeConst`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:218` | Self: 0.0% (0us) | Total: 0.0% (149us) | Samples: 0

**Called by:**
- `groupByDestructuring` (1)

**Calls:**
- `map` (1)

### `hideFromStack`
`internal:shared:19` | Self: 0.0% (0us) | Total: 0.0% (188us) | Samples: 0

**Called by:**
- `internal:validators` (1)

**Calls:**
- `defineProperty` (1)

### `checkForShadows`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:642` | Self: 0.0% (0us) | Total: 0.4% (3.6ms) | Samples: 0

**Called by:**
- `Program:exit` (20)

**Calls:**
- `getVariableByName` (19)
- `getVariableByName` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3614` | Self: 0.0% (0us) | Total: 0.0% (501us) | Samples: 0

**Called by:**
- `getDeclaredLocation` (2)
- `iterateDeclarations` (1)

**Calls:**
- `_lineStarts` (2)
- `_lineStarts` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:136` | Self: 0.0% (0us) | Total: 0.0% (817us) | Samples: 0

**Called by:**
- `map` (5)

**Calls:**
- `_deepMergeObjects` (3)
- `_deepMergeObjects` (1)
- `_deepMergeObjects` (1)

### `isImportAttributeKey`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:1429` | Self: 0.0% (0us) | Total: 0.0% (181us) | Samples: 0

**Called by:**
- `ObjectExpression > Property[computed!=true] > Identifier.key,MethodDefinition[computed!=true] > Identifier.key,PropertyDefinition[computed!=true] > Identifier.key,MethodDefinition > PrivateIdentifier.key,PropertyDefinition > PrivateIdentifier.key` (1)

**Calls:**
- `get parent` (1)

### `pluginKeyFromRuleId`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:20` | Self: 0.0% (0us) | Total: 0.0% (153us) | Samples: 0

**Called by:**
- `buildVisitorMap` (1)

**Calls:**
- `lastIndexOf` (1)

### `getTagNames`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:186` | Self: 0.0% (0us) | Total: 0.0% (651us) | Samples: 0

**Called by:**
- `(anonymous)` (4)

**Calls:**
- `loadBinding` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:725` | Self: 0.0% (0us) | Total: 0.3% (2.7ms) | Samples: 0

**Called by:**
- `some` (16)

**Calls:**
- `isReadForItself` (6)
- `isReadForItself` (4)
- `isReadForItself` (2)
- `isReadForItself` (2)
- `isReadForItself` (1)
- `isReadForItself` (1)

### `getDeclaredLocation`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:471` | Self: 0.0% (0us) | Total: 0.0% (311us) | Samples: 0

**Called by:**
- `checkForShadows` (2)

**Calls:**
- `get loc` (2)

### `get id`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2259` | Self: 0.0% (0us) | Total: 0.0% (190us) | Samples: 0

**Called by:**
- `_buildScope` (1)

**Calls:**
- `nodeLhs` (1)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5260` | Self: 0.0% (0us) | Total: 0.8% (6.9ms) | Samples: 0

**Called by:**
- `walkNodes` (41)

**Calls:**
- `_getSelectorRootTypes` (30)
- `_getSelectorRootTypes` (7)
- `_getSelectorRootTypes` (3)
- `_getSelectorRootTypes` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:840` | Self: 0.0% (0us) | Total: 0.0% (329us) | Samples: 0

**Called by:**
- `Program:exit` (2)

**Calls:**
- `get body` (1)
- `some` (1)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2865` | Self: 0.0% (0us) | Total: 0.0% (136us) | Samples: 0

**Called by:**
- `_buildReference` (1)

**Calls:**
- `_symName` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:416` | Self: 0.0% (0us) | Total: 0.0% (155us) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `Uint32Array` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6197` | Self: 0.0% (0us) | Total: 0.0% (150us) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `get end` (1)

### `referenceContainsTypeQuery`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:233` | Self: 0.0% (0us) | Total: 0.0% (140us) | Samples: 0

**Called by:**
- `shouldCheck` (1)

**Calls:**
- `referenceContainsTypeQuery` (1)

### `get`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1889` | Self: 0.0% (0us) | Total: 2.3% (20.3ms) | Samples: 0

**Called by:**
- `ensureRefsThrough` (116)
- `collectUnusedVariables` (3)
- `Program:exit` (3)

**Calls:**
- `ensureChildren` (121)
- `ensureChildren` (1)

### `fn`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5101` | Self: 0.0% (0us) | Total: 0.0% (353us) | Samples: 0

**Called by:**
- `_runSelectorList` (2)

**Calls:**
- `get type` (1)
- `get type` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7097` | Self: 0.0% (0us) | Total: 19.3% (166.1ms) | Samples: 0

**Called by:**
- `runPlugins` (970)

**Calls:**
- `_invokeFused` (959)
- `_nodeViewRaw` (2)
- `nodeView` (2)
- `_nodeViewRaw` (2)
- `nodeView` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_invokeFused` (1)
- `_nodeViewRaw` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1703` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `_invokeFused` (10)

**Calls:**
- `report` (10)

### `findIndex`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (178us) | Samples: 0

**Called by:**
- `ensureVarsSet` (1)

**Calls:**
- `(anonymous)` (1)

### `isImportAttributeKey`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:1433` | Self: 0.0% (0us) | Total: 0.0% (169us) | Samples: 0

**Called by:**
- `ObjectExpression > Property[computed!=true] > Identifier.key,MethodDefinition[computed!=true] > Identifier.key,PropertyDefinition[computed!=true] > Identifier.key,MethodDefinition > PrivateIdentifier.key,PropertyDefinition > PrivateIdentifier.key` (1)

**Calls:**
- `get options` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7361` | Self: 0.0% (0us) | Total: 0.0% (818us) | Samples: 0

**Called by:**
- `runOnce` (5)

**Calls:**
- `fill` (5)

### `isSpecificId`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:365` | Self: 0.0% (0us) | Total: 0.1% (895us) | Samples: 0

**Called by:**
- `isSpecificMemberAccess` (5)

**Calls:**
- `get name` (2)
- `get name` (1)
- `get type` (1)
- `get type` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7001` | Self: 0.0% (0us) | Total: 0.0% (678us) | Samples: 0

**Called by:**
- `runPlugins` (4)

**Calls:**
- `invokeMethodFnHandlers` (1)
- `invokeMethodFnHandlers` (1)
- `invokeMethodFnHandlers` (1)
- `invokeMethodFnHandlers` (1)

### `checkReference`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:205` | Self: 0.0% (0us) | Total: 0.0% (143us) | Samples: 0

**Called by:**
- `forEach` (1)

**Calls:**
- `get name` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:46` | Self: 0.0% (0us) | Total: 1.1% (10.1ms) | Samples: 0

**Called by:**
- `parseModule` (60)

**Calls:**
- `bound require` (60)

### `hasRestSibling`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:399` | Self: 0.0% (0us) | Total: 0.0% (168us) | Samples: 0

**Called by:**
- `some` (1)

**Calls:**
- `map` (1)

### `checkForBlock`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:139` | Self: 0.0% (0us) | Total: 0.0% (495us) | Samples: 0

**Called by:**
- `_invokeFused` (3)

**Calls:**
- `findVariablesInScope` (2)
- `findVariablesInScope` (1)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:688` | Self: 0.0% (0us) | Total: 0.0% (180us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get body` (1)

### `buildUnicodeData`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:3982` | Self: 0.0% (0us) | Total: 0.0% (175us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `wordsRegexp` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1710` | Self: 0.0% (0us) | Total: 0.0% (156us) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `extraClassData` (1)

### `skipChainExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:343` | Self: 0.0% (0us) | Total: 0.0% (366us) | Samples: 0

**Called by:**
- `isSpecificMemberAccess` (2)

**Calls:**
- `get type` (1)
- `get type` (1)

### `checkForFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:238` | Self: 0.0% (0us) | Total: 0.6% (5.7ms) | Samples: 0

**Called by:**
- `_invokeFused` (33)

**Calls:**
- `getDeclaredVariables` (13)
- `forEach` (13)
- `getDeclaredVariables` (4)
- `getDeclaredVariables` (2)
- `getDeclaredVariables` (1)

### `checkLastSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:382` | Self: 0.0% (0us) | Total: 0.0% (327us) | Samples: 0

**Called by:**
- `_invokeFused` (2)

**Calls:**
- `report` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:21` | Self: 0.0% (0us) | Total: 0.4% (3.5ms) | Samples: 0

**Called by:**
- `parseModule` (22)

**Calls:**
- `bound require` (22)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4219` | Self: 0.0% (0us) | Total: 0.0% (167us) | Samples: 0

**Called by:**
- `AstView` (1)

**Calls:**
- `Uint32Array` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:232` | Self: 0.0% (0us) | Total: 1.9% (17.0ms) | Samples: 0

**Called by:**
- `runOnce` (109)

**Calls:**
- `DataView` (109)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1246` | Self: 0.0% (0us) | Total: 0.0% (174us) | Samples: 0

**Called by:**
- `getDestructuringHost` (1)

**Calls:**
- `get loc` (1)

### `getIdentifierIfShouldBeConst`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:237` | Self: 0.0% (0us) | Total: 0.0% (174us) | Samples: 0

**Called by:**
- `groupByDestructuring` (1)

**Calls:**
- `some` (1)

### `canBecomeVariableDeclaration`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:58` | Self: 0.0% (0us) | Total: 0.0% (186us) | Samples: 0

**Called by:**
- `getIdentifierIfShouldBeConst` (1)

**Calls:**
- `get parent` (1)

### `getNameLocationInGlobalDirectiveComment`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2635` | Self: 0.0% (0us) | Total: 0.0% (320us) | Samples: 0

**Called by:**
- `iterateDeclarations` (1)
- `Program:exit` (1)

**Calls:**
- `(anonymous)` (2)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1658` | Self: 0.0% (0us) | Total: 0.0% (307us) | Samples: 0

**Called by:**
- `_buildScopeChildren` (2)

**Calls:**
- `_buildScope` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:29` | Self: 0.0% (0us) | Total: 0.0% (158us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `equalsToOriginalName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:177` | Self: 0.0% (0us) | Total: 0.0% (337us) | Samples: 0

**Called by:**
- `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause` (1)
- `reportReferenceId` (1)

**Calls:**
- `get value` (1)
- `get value` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2454` | Self: 0.0% (0us) | Total: 0.0% (183us) | Samples: 0

**Called by:**
- `getScope` (1)

**Calls:**
- `get parent` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6471` | Self: 0.0% (0us) | Total: 0.0% (842us) | Samples: 0

**Called by:**
- `walkNodes` (5)

**Calls:**
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `nodeView` (1)
- `_nodeViewRaw` (1)

### `isGoodName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:128` | Self: 0.0% (0us) | Total: 0.3% (2.8ms) | Samples: 0

**Called by:**
- `Program` (14)
- `Program` (2)

**Calls:**
- `isUnderscored` (13)
- `isUnderscored` (3)

### `isForInOfRef`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:677` | Self: 0.0% (0us) | Total: 0.0% (143us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get parent` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1712` | Self: 0.0% (0us) | Total: 0.0% (155us) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `getDefinedMessageData` (1)

### `getAssignedMessageData`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:306` | Self: 0.0% (0us) | Total: 0.0% (180us) | Samples: 0

**Called by:**
- `Program:exit` (1)

**Calls:**
- `defToVariableType` (1)

### `get properties`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3090` | Self: 0.0% (0us) | Total: 0.0% (157us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `_nodesFromRange` (1)

### `_buildScopeRefsAndThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2282` | Self: 0.0% (0us) | Total: 0.0% (620us) | Samples: 0

**Called by:**
- `ensureRefsThrough` (4)

**Calls:**
- `get type` (4)

### `invokeSelectorHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6084` | Self: 0.0% (0us) | Total: 0.8% (7.6ms) | Samples: 0

**Called by:**
- `walkNodes` (45)

**Calls:**
- `_runSelectorList` (30)
- `_runSelectorList` (10)
- `_runSelectorList` (5)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:450` | Self: 0.0% (0us) | Total: 0.0% (694us) | Samples: 0

**Called by:**
- `parseSource` (4)

**Calls:**
- `Uint32Array` (4)

### `isStorableFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:581` | Self: 0.0% (0us) | Total: 0.0% (147us) | Samples: 0

**Called by:**
- `isReadForItself` (1)

**Calls:**
- `isInside` (1)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.0% (843us) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `anonymous` (5)

### `shouldCheck`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:377` | Self: 0.0% (0us) | Total: 0.0% (174us) | Samples: 0

**Called by:**
- `filter` (1)

**Calls:**
- `isFromSeparateExecutionContext` (1)

### `[Symbol.match]`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (353us) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (2)

**Calls:**
- `hasObservableSideEffectsForRegExpMatch` (2)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:148` | Self: 0.0% (0us) | Total: 0.0% (183us) | Samples: 0

**Called by:**
- `BinaryExpression` (1)

**Calls:**
- `get operator` (1)

### `getFunctionNameWithKind`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2159` | Self: 0.0% (0us) | Total: 0.0% (161us) | Samples: 0

**Called by:**
- `checkLastSegment` (1)

**Calls:**
- `push` (1)

### `Program`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:145` | Self: 0.0% (0us) | Total: 0.4% (4.2ms) | Samples: 0

**Called by:**
- `_invokeFused` (25)

**Calls:**
- `getScope` (25)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4239` | Self: 0.0% (0us) | Total: 0.4% (4.0ms) | Samples: 0

**Called by:**
- `runPlugins` (23)

**Calls:**
- `esquery` (16)
- `g` (7)

### `ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1760` | Self: 0.0% (0us) | Total: 0.0% (178us) | Samples: 0

**Called by:**
- `get` (1)

**Calls:**
- `findIndex` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:151` | Self: 0.0% (0us) | Total: 0.0% (162us) | Samples: 0

**Called by:**
- `BinaryExpression` (1)

**Calls:**
- `areLiteralsAndSameType` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3` | Self: 0.0% (0us) | Total: 0.0% (531us) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` | Self: 0.0% (0us) | Total: 6.5% (55.8ms) | Samples: 0

**Called by:**
- `runOnce` (291)

**Calls:**
- `AstView` (53)
- `AstView` (28)
- `AstView` (19)
- `AstView` (10)
- `AstView` (9)
- `AstView` (7)
- `AstView` (6)
- `AstView` (6)
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
- `AstView` (1)
- `AstView` (1)
- `AstView` (1)
- `AstView` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1961` | Self: 0.0% (0us) | Total: 1.5% (13.0ms) | Samples: 0

**Called by:**
- `ensureVarsSet` (78)
- `ensureVarsSet` (1)

**Calls:**
- `_buildVariable` (30)
- `_buildVariable` (12)
- `_buildVariable` (8)
- `_buildVariable` (5)
- `_buildVariable` (5)
- `_buildVariable` (4)
- `_buildVariable` (3)
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
- `_buildVariable` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1680` | Self: 0.0% (0us) | Total: 0.0% (659us) | Samples: 0

**Called by:**
- `_computeIsStrict` (4)

**Calls:**
- `_nodesFromRange` (4)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:390` | Self: 0.0% (0us) | Total: 0.0% (321us) | Samples: 0

**Called by:**
- `parseSource` (2)

**Calls:**
- `Uint32Array` (2)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:428` | Self: 0.0% (0us) | Total: 0.0% (140us) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `Uint32Array` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:561` | Self: 0.0% (0us) | Total: 0.0% (142us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get right` (1)

### `get right`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1786` | Self: 0.0% (0us) | Total: 0.0% (157us) | Samples: 0

**Called by:**
- `areLiteralsAndSameType` (1)

**Calls:**
- `get _tag` (1)

### `segment`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4250` | Self: 0.0% (0us) | Total: 0.0% (382us) | Samples: 0

**Called by:**
- `initialSegment` (1)
- `get initialSegment` (1)

**Calls:**
- `CfgSegment` (2)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3749` | Self: 0.0% (0us) | Total: 0.0% (194us) | Samples: 0

**Called by:**
- `report` (1)

**Calls:**
- `get start` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:495` | Self: 0.0% (0us) | Total: 0.0% (157us) | Samples: 0

**Called by:**
- `forEach` (1)

**Calls:**
- `get properties` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1703` | Self: 0.0% (0us) | Total: 0.0% (171us) | Samples: 0

**Called by:**
- `getFunctionHeadLoc` (1)

**Calls:**
- `nodeView` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:56` | Self: 0.0% (0us) | Total: 0.3% (2.6ms) | Samples: 0

**Called by:**
- `parseModule` (16)

**Calls:**
- `parse` (13)
- `readFileSync` (3)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:437` | Self: 0.0% (0us) | Total: 0.0% (545us) | Samples: 0

**Called by:**
- `parseSource` (3)

**Calls:**
- `Uint8Array` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:113` | Self: 0.0% (0us) | Total: 52.1% (447.5ms) | Samples: 0

**Called by:**
- `parseModule` (2612)

**Calls:**
- `runOnce` (2155)
- `runOnce` (440)
- `runOnce` (15)
- `runOnce` (1)
- `runOnce` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1483` | Self: 0.0% (0us) | Total: 0.0% (159us) | Samples: 0

**Called by:**
- `_buildScope` (1)

**Calls:**
- `get loc` (1)

### `internal:primordials`
`internal:primordials:50` | Self: 0.0% (0us) | Total: 0.0% (153us) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound call` (1)

### `_extractFileLevelRules`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4832` | Self: 0.0% (0us) | Total: 0.0% (295us) | Samples: 0

**Called by:**
- `_buildPlan` (2)

**Calls:**
- `Set` (2)

### `ruleNameFromRuleId`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:28` | Self: 0.0% (0us) | Total: 0.0% (350us) | Samples: 0

**Called by:**
- `buildVisitorMap` (2)

**Calls:**
- `lastIndexOf` (2)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:400` | Self: 0.0% (0us) | Total: 0.0% (373us) | Samples: 0

**Called by:**
- `parseSource` (2)

**Calls:**
- `Uint8Array` (2)

### `_compileSelectorFastMatcher`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5088` | Self: 0.0% (0us) | Total: 0.1% (907us) | Samples: 0

**Called by:**
- `_compileSelectorFastMatcher` (4)
- `_getOrBuildSelectorPlan` (1)

**Calls:**
- `filter` (5)

### `isInTdz`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:491` | Self: 0.0% (0us) | Total: 0.0% (163us) | Samples: 0

**Called by:**
- `checkForShadows` (1)

**Calls:**
- `getNameRange` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2067` | Self: 0.0% (0us) | Total: 0.0% (172us) | Samples: 0

**Called by:**
- `ensureVarsSet` (1)

**Calls:**
- `trim` (1)

### `makeSafe`
`internal:primordials:30` | Self: 0.0% (0us) | Total: 0.0% (169us) | Samples: 0

**Called by:**
- `internal:primordials` (1)

**Calls:**
- `bound call` (1)

### `getFunctionHeadLoc`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2307` | Self: 0.0% (0us) | Total: 0.0% (178us) | Samples: 0

**Called by:**
- `checkLastSegment` (1)

**Calls:**
- `get loc` (1)

### `checkForShadows`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:660` | Self: 0.0% (0us) | Total: 0.0% (139us) | Samples: 0

**Called by:**
- `Program:exit` (1)

**Calls:**
- `isExternalDeclarationMerging` (1)

### `BinaryExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:195` | Self: 0.0% (0us) | Total: 0.0% (167us) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `isTypeOfBinary` (1)

### `isModifyingProp`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:118` | Self: 0.0% (0us) | Total: 0.0% (192us) | Samples: 0

**Called by:**
- `checkReference` (1)

**Calls:**
- `get left` (1)

### `_compileSelectorFastMatcher`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4993` | Self: 0.0% (0us) | Total: 0.0% (381us) | Samples: 0

**Called by:**
- `_compileSelectorFastMatcher` (2)

**Calls:**
- `map` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:15` | Self: 0.0% (0us) | Total: 0.0% (185us) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5665` | Self: 0.0% (0us) | Total: 0.0% (348us) | Samples: 0

**Called by:**
- `_getOrBuildPlan` (2)

**Calls:**
- `indexOf` (2)

### `getFirstToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:945` | Self: 0.0% (0us) | Total: 0.0% (146us) | Samples: 0

**Called by:**
- `getFunctionHeadLoc` (1)

**Calls:**
- `_computeMinTok` (1)

### `get directive`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3342` | Self: 0.0% (0us) | Total: 0.0% (140us) | Samples: 0

**Called by:**
- `_computeIsStrict` (1)

**Calls:**
- `nodeLhs` (1)

### `isAssignmentTarget`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:138` | Self: 0.0% (0us) | Total: 0.0% (185us) | Samples: 0

**Called by:**
- `MemberExpression[computed!=true] > Identifier.property` (1)

**Calls:**
- `get parent` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:576` | Self: 0.0% (0us) | Total: 0.0% (164us) | Samples: 0

**Called by:**
- `_precomputeScopes` (1)

**Calls:**
- `_findLineIdx` (1)

### `getStaticStringValue`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:264` | Self: 0.0% (0us) | Total: 0.0% (195us) | Samples: 0

**Called by:**
- `isSpecificMemberAccess` (1)

**Calls:**
- `get value` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:351` | Self: 0.0% (0us) | Total: 0.0% (150us) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `Uint32Array` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:935` | Self: 0.0% (0us) | Total: 0.0% (181us) | Samples: 0

**Called by:**
- `Program:exit` (1)

**Calls:**
- `some` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:440` | Self: 0.0% (0us) | Total: 0.0% (353us) | Samples: 0

**Called by:**
- `parseSource` (2)

**Calls:**
- `get byteLength` (2)

### `internal:primordials`
`internal:primordials:71` | Self: 0.0% (0us) | Total: 0.0% (169us) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `makeSafe` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5222` | Self: 0.0% (0us) | Total: 0.0% (642us) | Samples: 0

**Called by:**
- `fn` (2)
- `(anonymous)` (2)

**Calls:**
- `accessPath` (3)
- `accessPath` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:683` | Self: 0.0% (0us) | Total: 2.9% (25.2ms) | Samples: 0

**Called by:**
- `_invokeFused` (149)

**Calls:**
- `getScope` (148)
- `_buildScope` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:14` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `parseModule` (10)

**Calls:**
- `bound require` (10)

### `checkReferencesInScope`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:426` | Self: 0.0% (0us) | Total: 0.4% (4.0ms) | Samples: 0

**Called by:**
- `forEach` (13)
- `Program` (11)

**Calls:**
- `forEach` (17)
- `filter` (6)
- `get` (1)

### `isAvailable`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:399` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `_getFfiSelector` (8)

**Calls:**
- `_tryLoad` (6)
- `_tryLoad` (2)

### `checkForBlock`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:132` | Self: 0.0% (0us) | Total: 0.0% (478us) | Samples: 0

**Called by:**
- `_invokeFused` (3)

**Calls:**
- `getScope` (1)
- `_buildScope` (1)
- `_buildScope` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:12` | Self: 0.0% (0us) | Total: 0.7% (6.7ms) | Samples: 0

**Called by:**
- `anonymous` (40)

**Calls:**
- `bound require` (40)

### `isTypeOfBinary`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:100` | Self: 0.0% (0us) | Total: 0.0% (167us) | Samples: 0

**Called by:**
- `BinaryExpression` (1)

**Calls:**
- `isTypeOf` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:319` | Self: 0.0% (0us) | Total: 0.0% (339us) | Samples: 0

**Called by:**
- `parseSource` (2)

**Calls:**
- `Uint32Array` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2071` | Self: 0.0% (0us) | Total: 0.0% (564us) | Samples: 0

**Called by:**
- `ensureVarsSet` (3)

**Calls:**
- `test` (3)

### `invokeSelectorHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6048` | Self: 0.0% (0us) | Total: 0.0% (300us) | Samples: 0

**Called by:**
- `walkNodes` (2)

**Calls:**
- `nodeView` (1)
- `_nodeViewRaw` (1)

### `_compileSelectorFastMatcher`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5012` | Self: 0.0% (0us) | Total: 0.0% (195us) | Samples: 0

**Called by:**
- `_compileSelectorFastMatcher` (1)

**Calls:**
- `find` (1)

### `applyDisableDirectives`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7442` | Self: 0.0% (0us) | Total: 0.3% (2.7ms) | Samples: 0

**Called by:**
- `runOnce` (16)

**Calls:**
- `_parseDisableDirectives` (12)
- `_parseDisableDirectives` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` | Self: 0.0% (0us) | Total: 0.1% (1.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (7)

**Calls:**
- `(anonymous)` (3)
- `(anonymous)` (3)
- `(anonymous)` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:411` | Self: 0.0% (0us) | Total: 0.0% (350us) | Samples: 0

**Called by:**
- `parseSource` (2)

**Calls:**
- `Uint32Array` (2)

### `get end`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1127` | Self: 0.0% (0us) | Total: 0.0% (480us) | Samples: 0

**Called by:**
- `_execReport` (3)

**Calls:**
- `_nodeEndPos` (3)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:352` | Self: 0.0% (0us) | Total: 0.0% (168us) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `Uint32Array` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5656` | Self: 0.0% (0us) | Total: 0.0% (511us) | Samples: 0

**Called by:**
- `_getOrBuildPlan` (3)

**Calls:**
- `get` (3)

### `getIdentifierIfShouldBeConst`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:232` | Self: 0.0% (0us) | Total: 0.0% (193us) | Samples: 0

**Called by:**
- `groupByDestructuring` (1)

**Calls:**
- `map` (1)

### `checkGroup`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:509` | Self: 0.0% (0us) | Total: 0.1% (1.1ms) | Samples: 0

**Called by:**
- `forEach` (5)

**Calls:**
- `forEach` (5)

### `getArrayMethodName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:78` | Self: 0.0% (0us) | Total: 0.0% (537us) | Samples: 0

**Called by:**
- `onCodePathStart` (3)

**Calls:**
- `get parent` (2)
- `get parent` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5065` | Self: 0.0% (0us) | Total: 0.0% (461us) | Samples: 0

**Called by:**
- `fn` (3)

**Calls:**
- `(anonymous)` (2)
- `(anonymous)` (1)

### `isFunctionNameInitializerException`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:445` | Self: 0.0% (0us) | Total: 0.0% (322us) | Samples: 0

**Called by:**
- `checkForShadows` (2)

**Calls:**
- `unwrapExpression` (1)
- `unwrapExpression` (1)

### `getVariableByName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:1599` | Self: 0.0% (0us) | Total: 0.3% (3.4ms) | Samples: 0

**Called by:**
- `checkForShadows` (19)

**Calls:**
- `get` (19)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (10)

**Calls:**
- `bound require` (10)

### `ensureRefsThrough`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1823` | Self: 0.0% (0us) | Total: 2.2% (19.4ms) | Samples: 0

**Called by:**
- `get` (116)

**Calls:**
- `get` (116)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:923` | Self: 0.0% (0us) | Total: 0.0% (518us) | Samples: 0

**Called by:**
- `collectUnusedVariables` (2)

**Calls:**
- `isAfterLastUsedArg` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6742` | Self: 0.0% (0us) | Total: 0.0% (756us) | Samples: 0

**Called by:**
- `runPlugins` (4)

**Calls:**
- `indexOf` (4)

### `isUsedVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:715` | Self: 0.0% (0us) | Total: 0.7% (6.4ms) | Samples: 0

**Called by:**
- `collectUnusedVariables` (36)

**Calls:**
- `getFunctionDefinitions` (26)
- `getFunctionDefinitions` (10)

### `_applySchemaDefaults`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:162` | Self: 0.0% (0us) | Total: 0.0% (149us) | Samples: 0

**Called by:**
- `buildVisitorMap` (1)

**Calls:**
- `slice` (1)

### `isNullCheck`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:125` | Self: 0.0% (0us) | Total: 0.0% (828us) | Samples: 0

**Called by:**
- `BinaryExpression` (5)

**Calls:**
- `isNullLiteral` (2)
- `isNullLiteral` (2)
- `isNullLiteral` (1)

### `iterateDeclarations`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js:69` | Self: 0.0% (0us) | Total: 0.0% (362us) | Samples: 0

**Called by:**
- `generatorResume` (2)

**Calls:**
- `get loc` (1)
- `get loc` (1)

### `reportReferenceId`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:262` | Self: 0.0% (0us) | Total: 0.0% (562us) | Samples: 0

**Called by:**
- `Program` (3)

**Calls:**
- `report` (2)
- `report` (1)

### `checkForShadows`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:672` | Self: 0.0% (0us) | Total: 0.0% (287us) | Samples: 0

**Called by:**
- `Program:exit` (2)

**Calls:**
- `report` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:22` | Self: 0.0% (0us) | Total: 0.0% (204us) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:90` | Self: 0.0% (0us) | Total: 0.0% (530us) | Samples: 0

**Called by:**
- `parseSource` (3)

**Calls:**
- `ensureBufferBytes` (1)
- `ensureBufferBytes` (1)
- `ensureBufferBytes` (1)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2887` | Self: 0.0% (0us) | Total: 0.4% (3.8ms) | Samples: 0

**Called by:**
- `_buildReference` (18)
- `_buildThinScope` (6)

**Calls:**
- `_findDefNode` (10)
- `_findDefNode` (4)
- `_findDefNode` (3)
- `_findDefNode` (2)
- `_findDefNode` (2)
- `_findDefNode` (1)
- `_findDefNode` (1)
- `_findDefNode` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1699` | Self: 0.0% (0us) | Total: 0.0% (462us) | Samples: 0

**Called by:**
- `_computeIsStrict` (2)
- `checkLastSegment` (1)

**Calls:**
- `extraFnData` (1)
- `extraFnData` (1)
- `extraFnData` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:24` | Self: 0.0% (0us) | Total: 0.1% (934us) | Samples: 0

**Called by:**
- `parseModule` (6)

**Calls:**
- `getTagNames` (4)
- `getTagNames` (1)
- `getTagNames` (1)

### `isModifyingProp`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:159` | Self: 0.0% (0us) | Total: 0.0% (187us) | Samples: 0

**Called by:**
- `checkReference` (1)

**Calls:**
- `get parent` (1)

### `isInClassStaticInitializerRange`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:64` | Self: 0.0% (0us) | Total: 0.0% (158us) | Samples: 0

**Called by:**
- `isEvaluatedDuringInitialization` (1)

**Calls:**
- `get body` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3083` | Self: 0.0% (0us) | Total: 0.0% (333us) | Samples: 0

**Called by:**
- `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause` (2)

**Calls:**
- `get params` (1)
- `get params` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:427` | Self: 0.0% (0us) | Total: 0.0% (334us) | Samples: 0

**Called by:**
- `parseSource` (2)

**Calls:**
- `Uint8Array` (2)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2107` | Self: 0.0% (0us) | Total: 0.0% (175us) | Samples: 0

**Called by:**
- `ensureVarsSet` (1)

**Calls:**
- `get` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6630` | Self: 0.0% (0us) | Total: 0.0% (337us) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `RuleSkipSet` (2)

### `get static`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2250` | Self: 0.0% (0us) | Total: 0.0% (174us) | Samples: 0

**Called by:**
- `isClassStaticInitializerScope` (1)

**Calls:**
- `get mainToken` (1)

### `_extractBatchScannable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4681` | Self: 0.0% (0us) | Total: 0.0% (191us) | Samples: 0

**Called by:**
- `_buildPlan` (1)

**Calls:**
- `has` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:379` | Self: 0.0% (0us) | Total: 0.0% (186us) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `Uint32Array` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:410` | Self: 0.0% (0us) | Total: 0.0% (470us) | Samples: 0

**Called by:**
- `parseSource` (3)

**Calls:**
- `Uint8Array` (3)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:655` | Self: 0.0% (0us) | Total: 0.0% (178us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `isUnusedExpression` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:366` | Self: 0.0% (0us) | Total: 0.0% (485us) | Samples: 0

**Called by:**
- `parseSource` (3)

**Calls:**
- `Int32Array` (3)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2069` | Self: 0.0% (0us) | Total: 0.0% (162us) | Samples: 0

**Called by:**
- `ensureVarsSet` (1)

**Calls:**
- `stringSplitFast` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5776` | Self: 0.0% (0us) | Total: 1.8% (15.6ms) | Samples: 0

**Called by:**
- `_getOrBuildPlan` (90)

**Calls:**
- `_extractBatchScannable` (20)
- `_extractBatchScannable` (17)
- `_extractBatchScannable` (11)
- `_extractBatchScannable` (11)
- `_extractBatchScannable` (10)
- `_extractBatchScannable` (7)
- `_extractBatchScannable` (4)
- `_extractBatchScannable` (3)
- `_extractBatchScannable` (2)
- `_extractBatchScannable` (1)
- `_extractBatchScannable` (1)
- `_extractBatchScannable` (1)
- `_extractBatchScannable` (1)
- `_extractBatchScannable` (1)

### `checkReferencesInScope`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:444` | Self: 0.0% (0us) | Total: 0.3% (2.9ms) | Samples: 0

**Called by:**
- `Program` (13)
- `forEach` (4)

**Calls:**
- `forEach` (17)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:322` | Self: 0.0% (0us) | Total: 0.0% (171us) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `getUint32` (1)

### `isInitPatternNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:304` | Self: 0.0% (0us) | Total: 0.0% (509us) | Samples: 0

**Called by:**
- `checkForShadows` (3)

**Calls:**
- `isInRange` (1)
- `isInRange` (1)
- `get init` (1)

### `_precomputeScopes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2443` | Self: 0.0% (0us) | Total: 0.0% (142us) | Samples: 0

**Called by:**
- `getScope` (1)

**Calls:**
- `get name` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6291` | Self: 0.0% (0us) | Total: 1.9% (16.3ms) | Samples: 0

**Called by:**
- `runPlugins` (97)

**Calls:**
- `_getOrBuildSelectorPlan` (41)
- `_getOrBuildSelectorPlan` (21)
- `_getOrBuildSelectorPlan` (13)
- `_getOrBuildSelectorPlan` (7)
- `_getOrBuildSelectorPlan` (5)
- `_getOrBuildSelectorPlan` (3)
- `_getOrBuildSelectorPlan` (2)
- `_getOrBuildSelectorPlan` (2)
- `_getOrBuildSelectorPlan` (1)
- `_getOrBuildSelectorPlan` (1)
- `_getOrBuildSelectorPlan` (1)

### `checkGroup`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:421` | Self: 0.0% (0us) | Total: 0.0% (298us) | Samples: 0

**Called by:**
- `forEach` (2)

**Calls:**
- `get declarations` (1)
- `_nodesFromRange` (1)

### `checkForShadows`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:662` | Self: 0.0% (0us) | Total: 0.0% (311us) | Samples: 0

**Called by:**
- `Program:exit` (2)

**Calls:**
- `getDeclaredLocation` (2)

### `isUnusedExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:506` | Self: 0.0% (0us) | Total: 0.0% (178us) | Samples: 0

**Called by:**
- `isReadForItself` (1)

**Calls:**
- `get parent` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:967` | Self: 0.0% (0us) | Total: 0.7% (6.6ms) | Samples: 0

**Called by:**
- `Program:exit` (34)
- `collectUnusedVariables` (4)

**Calls:**
- `collectUnusedVariables` (14)
- `collectUnusedVariables` (8)
- `collectUnusedVariables` (4)
- `collectUnusedVariables` (2)
- `collectUnusedVariables` (2)
- `collectUnusedVariables` (2)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)
- `collectUnusedVariables` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:474` | Self: 0.0% (0us) | Total: 0.0% (507us) | Samples: 0

**Called by:**
- `parseSource` (3)

**Calls:**
- `Uint32Array` (3)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:476` | Self: 0.0% (0us) | Total: 0.0% (203us) | Samples: 0

**Called by:**
- `forEach` (1)

**Calls:**
- `get init` (1)

### `getIdentifierIfShouldBeConst`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:223` | Self: 0.0% (0us) | Total: 0.0% (512us) | Samples: 0

**Called by:**
- `groupByDestructuring` (3)

**Calls:**
- `some` (3)

### `esquery`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:53` | Self: 0.0% (0us) | Total: 0.3% (2.7ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (16)

**Calls:**
- `bound require` (16)

### `_buildTemplate`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5809` | Self: 0.0% (0us) | Total: 0.0% (171us) | Samples: 0

**Called by:**
- `_buildPlan` (1)

**Calls:**
- `map` (1)

### `ensureBufferBytes`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:58` | Self: 0.0% (0us) | Total: 0.0% (176us) | Samples: 0

**Called by:**
- `_encodeSource` (1)

**Calls:**
- `get byteLength` (1)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1906` | Self: 0.0% (0us) | Total: 0.2% (1.7ms) | Samples: 0

**Called by:**
- `_buildScope` (11)

**Calls:**
- `get parent` (4)
- `get parent` (2)
- `get parent` (2)
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1719` | Self: 0.0% (0us) | Total: 0.0% (336us) | Samples: 0

**Called by:**
- `_buildScopeChildren` (2)

**Calls:**
- `get name` (1)
- `get name` (1)

### `shouldCheck`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:392` | Self: 0.0% (0us) | Total: 0.0% (325us) | Samples: 0

**Called by:**
- `filter` (2)

**Calls:**
- `referenceContainsTypeQuery` (1)
- `referenceContainsTypeQuery` (1)

### `get callee`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1873` | Self: 0.0% (0us) | Total: 0.0% (184us) | Samples: 0

**Called by:**
- `getArrayMethodName` (1)

**Calls:**
- `getUint32` (1)

### `_compileSelectorFastMatcher`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5050` | Self: 0.0% (0us) | Total: 0.0% (450us) | Samples: 0

**Called by:**
- `_compileSelectorFastMatcher` (3)

**Calls:**
- `map` (3)

### `getIdentifierIfShouldBeConst`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:222` | Self: 0.0% (0us) | Total: 0.0% (137us) | Samples: 0

**Called by:**
- `groupByDestructuring` (1)

**Calls:**
- `map` (1)

### `isEvaluatedDuringInitialization`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:189` | Self: 0.0% (0us) | Total: 0.0% (339us) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `isInClassStaticInitializerRange` (1)
- `isInClassStaticInitializerRange` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5658` | Self: 0.0% (0us) | Total: 0.2% (2.5ms) | Samples: 0

**Called by:**
- `_getOrBuildPlan` (15)

**Calls:**
- `indexOf` (15)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2661` | Self: 0.0% (0us) | Total: 0.0% (141us) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `get range` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3065` | Self: 0.0% (0us) | Total: 0.9% (7.9ms) | Samples: 0

**Called by:**
- `VariableDeclaration` (33)
- `checkForFunction` (13)
- `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause` (2)

**Calls:**
- `_buildVariable` (28)
- `_buildVariable` (5)
- `_buildVariable` (5)
- `_buildVariable` (4)
- `_buildVariable` (2)
- `_buildVariable` (1)
- `_buildVariable` (1)
- `_buildVariable` (1)
- `_buildVariable` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:431` | Self: 0.0% (0us) | Total: 0.0% (179us) | Samples: 0

**Called by:**
- `_buildVariable` (1)

**Calls:**
- `get value` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:76` | Self: 0.0% (0us) | Total: 0.0% (167us) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `next` (1)

### `Program`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:272` | Self: 0.0% (0us) | Total: 0.3% (3.3ms) | Samples: 0

**Called by:**
- `_invokeFused` (19)

**Calls:**
- `get` (19)

### `a`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (156us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5291` | Self: 0.0% (0us) | Total: 0.0% (317us) | Samples: 0

**Called by:**
- `walkNodes` (2)

**Calls:**
- `indexOf` (2)

### `MemberExpression[computed!=true] > Identifier.property`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:367` | Self: 0.0% (0us) | Total: 0.0% (331us) | Samples: 0

**Called by:**
- `_runSelectorList` (2)

**Calls:**
- `report` (1)
- `report` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:345` | Self: 0.0% (0us) | Total: 0.3% (3.4ms) | Samples: 0

**Called by:**
- `parseSource` (19)

**Calls:**
- `Uint32Array` (19)

### `getArrayMethodName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:118` | Self: 0.0% (0us) | Total: 0.0% (193us) | Samples: 0

**Called by:**
- `onCodePathStart` (1)

**Calls:**
- `get arguments` (1)

### `isReadForItself`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:658` | Self: 0.0% (0us) | Total: 0.0% (383us) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `isUnusedExpression` (2)

### `buildUnicodeData`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:3986` | Self: 0.0% (0us) | Total: 0.0% (341us) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `wordsRegexp` (2)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5651` | Self: 0.0% (0us) | Total: 0.9% (7.9ms) | Samples: 0

**Called by:**
- `_getOrBuildPlan` (46)

**Calls:**
- `_getSelectorRootTypes` (31)
- `_getSelectorRootTypes` (6)
- `_getSelectorRootTypes` (3)
- `_getSelectorRootTypes` (3)
- `_getSelectorRootTypes` (1)
- `_getSelectorRootTypes` (1)
- `_getSelectorRootTypes` (1)

### `reduce`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (190us) | Samples: 0

**Called by:**
- `Pe` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.1% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (4)
- `ke` (3)
- `anonymous` (2)
- `a` (1)

**Calls:**
- `(anonymous)` (4)
- `(anonymous)` (3)
- `be` (1)
- `a` (1)
- `e` (1)

### `_makeToken`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:798` | Self: 0.0% (0us) | Total: 0.0% (320us) | Samples: 0

**Called by:**
- `getFirstToken` (2)

**Calls:**
- `_getJsxTextTokFlags` (2)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 4.7% (41.0ms) | Samples: 0

**Called by:**
- `bound require` (242)

**Calls:**
- `anonymous` (241)
- `startsWith` (1)

### `BinaryExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:196` | Self: 0.0% (0us) | Total: 0.0% (157us) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `areLiteralsAndSameType` (1)

### `isImportAttributeKey`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:1441` | Self: 0.0% (0us) | Total: 0.0% (204us) | Samples: 0

**Called by:**
- `ObjectExpression > Property[computed!=true] > Identifier.key,MethodDefinition[computed!=true] > Identifier.key,PropertyDefinition[computed!=true] > Identifier.key,MethodDefinition > PrivateIdentifier.key,PropertyDefinition > PrivateIdentifier.key` (1)

**Calls:**
- `get value` (1)

### `node:path`
`node:path:2` | Self: 0.0% (0us) | Total: 0.1% (1.0ms) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `anonymous` (6)

### `areLiteralsAndSameType`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:112` | Self: 0.0% (0us) | Total: 0.0% (157us) | Samples: 0

**Called by:**
- `BinaryExpression` (1)

**Calls:**
- `get right` (1)

### `ReturnStatement`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:486` | Self: 0.0% (0us) | Total: 0.0% (314us) | Samples: 0

**Called by:**
- `_invokeFused` (2)

**Calls:**
- `report` (2)

### `fn`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5030` | Self: 0.0% (0us) | Total: 0.0% (352us) | Samples: 0

**Called by:**
- `fn` (2)

**Calls:**
- `(anonymous)` (2)

### `getUpperFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:132` | Self: 0.0% (0us) | Total: 0.0% (191us) | Samples: 0

**Called by:**
- `isInsideOfStorableFunction` (1)

**Calls:**
- `get parent` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:13` | Self: 0.0% (0us) | Total: 0.1% (1.0ms) | Samples: 0

**Called by:**
- `parseModule` (6)

**Calls:**
- `bound require` (6)

### `areLiteralsAndSameType`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:113` | Self: 0.0% (0us) | Total: 0.0% (162us) | Samples: 0

**Called by:**
- `report` (1)

**Calls:**
- `get value` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js:133` | Self: 0.0% (0us) | Total: 0.0% (336us) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `(anonymous)` (2)

### `isNullLiteral`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:206` | Self: 0.0% (0us) | Total: 0.0% (168us) | Samples: 0

**Called by:**
- `isNullCheck` (1)

**Calls:**
- `get regex` (1)

### `unwrapExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:368` | Self: 0.0% (0us) | Total: 0.0% (172us) | Samples: 0

**Called by:**
- `isFunctionNameInitializerException` (1)

**Calls:**
- `get parent` (1)

### `ensureFenVars`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1741` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `get` (8)

**Calls:**
- `get` (8)

### `get computed`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1978` | Self: 0.0% (0us) | Total: 0.0% (166us) | Samples: 0

**Called by:**
- `getStaticPropertyName` (1)

**Calls:**
- `get _tag` (1)

### `checkReference`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js:212` | Self: 0.0% (0us) | Total: 0.0% (398us) | Samples: 0

**Called by:**
- `forEach` (1)

**Calls:**
- `report` (1)

### `isSpecificMemberAccess`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:380` | Self: 0.0% (0us) | Total: 0.0% (162us) | Samples: 0

**Called by:**
- `getArrayMethodName` (1)

**Calls:**
- `get type` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:208` | Self: 0.0% (0us) | Total: 0.0% (557us) | Samples: 0

**Called by:**
- `reportReferenceId` (2)
- `MemberExpression[computed!=true] > Identifier.property` (1)

**Calls:**
- `report` (3)

### `_runSelectorList`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5998` | Self: 0.0% (0us) | Total: 0.1% (1.7ms) | Samples: 0

**Called by:**
- `invokeSelectorHandlers` (10)

**Calls:**
- `MemberExpression[computed!=true] > Identifier.property` (4)
- `ObjectExpression > Property[computed!=true] > Identifier.key,MethodDefinition[computed!=true] > Identifier.key,PropertyDefinition[computed!=true] > Identifier.key,MethodDefinition > PrivateIdentifier.key,PropertyDefinition > PrivateIdentifier.key` (3)
- `MemberExpression[computed!=true] > Identifier.property` (2)
- `ExportAllDeclaration > Identifier.exported,ExportSpecifier > Identifier.exported` (1)

### `_getFfiSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:109` | Self: 0.0% (0us) | Total: 0.0% (468us) | Samples: 0

**Called by:**
- `_getOrBuildSelectorPlan` (3)

**Calls:**
- `bound require` (3)

### `isInitOfForStatement`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:40` | Self: 0.0% (0us) | Total: 0.0% (527us) | Samples: 0

**Called by:**
- `VariableDeclaration` (3)

**Calls:**
- `get type` (1)
- `get type` (1)
- `get parent` (1)

### `wordsRegexp`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:285` | Self: 0.0% (0us) | Total: 0.0% (516us) | Samples: 0

**Called by:**
- `buildUnicodeData` (2)
- `buildUnicodeData` (1)

**Calls:**
- `RegExp` (2)
- `replace` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1733` | Self: 0.0% (0us) | Total: 0.0% (486us) | Samples: 0

**Called by:**
- `_invokeFused` (3)

**Calls:**
- `getNameLocationInGlobalDirectiveComment` (1)
- `getNameLocationInGlobalDirectiveComment` (1)
- `getNameLocationInGlobalDirectiveComment` (1)

### `get expressions`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3031` | Self: 0.0% (0us) | Total: 0.0% (195us) | Samples: 0

**Called by:**
- `isUnusedExpression` (1)

**Calls:**
- `nodeRhs` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:431` | Self: 0.0% (0us) | Total: 0.0% (596us) | Samples: 0

**Called by:**
- `forEach` (4)

**Calls:**
- `get range` (2)
- `get range` (1)
- `get range` (1)

### `_buildScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1718` | Self: 0.0% (0us) | Total: 0.1% (1.4ms) | Samples: 0

**Called by:**
- `_buildScopeChildren` (8)

**Calls:**
- `get id` (2)
- `get id` (1)
- `get id` (1)
- `get id` (1)
- `get id` (1)
- `get type` (1)
- `_nodeViewRaw` (1)

### `dlopen`
`bun:ffi:344` | Self: 0.0% (0us) | Total: 0.0% (158us) | Samples: 0

**Called by:**
- `_tryLoad` (1)

**Calls:**
- `normalizePath` (1)

### `_expandUnion`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4045` | Self: 0.0% (0us) | Total: 0.0% (482us) | Samples: 0

**Called by:**
- `buildVisitorMap` (3)

**Calls:**
- `map` (3)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4218` | Self: 0.0% (0us) | Total: 0.0% (341us) | Samples: 0

**Called by:**
- `AstView` (2)

**Calls:**
- `Uint8Array` (2)

### `exec`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (187us) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `/\/\*([\s\S]*?)\*\//g` (1)

### `_isSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4031` | Self: 0.0% (0us) | Total: 0.1% (938us) | Samples: 0

**Called by:**
- `buildVisitorMap` (6)

**Calls:**
- `every` (6)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6973` | Self: 0.0% (0us) | Total: 0.0% (179us) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `fn` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:232` | Self: 0.0% (0us) | Total: 0.0% (193us) | Samples: 0

**Called by:**
- `map` (1)

**Calls:**
- `get name` (1)

### `get body`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1689` | Self: 0.0% (0us) | Total: 0.0% (180us) | Samples: 0

**Called by:**
- `isForInOfRef` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `checkGroup`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:492` | Self: 0.0% (0us) | Total: 0.0% (157us) | Samples: 0

**Called by:**
- `forEach` (1)

**Calls:**
- `forEach` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:414` | Self: 0.0% (0us) | Total: 0.0% (327us) | Samples: 0

**Called by:**
- `parseSource` (2)

**Calls:**
- `Uint32Array` (2)

### `isInsideOfStorableFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:634` | Self: 0.0% (0us) | Total: 0.0% (179us) | Samples: 0

**Called by:**
- `isReadForItself` (1)

**Calls:**
- `isInside` (1)

### `isFromSeparateExecutionContext`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:138` | Self: 0.0% (0us) | Total: 0.0% (174us) | Samples: 0

**Called by:**
- `shouldCheck` (1)

**Calls:**
- `isClassStaticInitializerScope` (1)

### `get initialSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4343` | Self: 0.0% (0us) | Total: 0.0% (189us) | Samples: 0

**Called by:**
- `_fireCfgEvents` (1)

**Calls:**
- `segment` (1)

### `checkLastSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:370` | Self: 0.0% (0us) | Total: 0.0% (322us) | Samples: 0

**Called by:**
- `_invokeFused` (2)

**Calls:**
- `get body` (1)
- `get body` (1)

### `getDeclaredVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3047` | Self: 0.0% (0us) | Total: 0.0% (352us) | Samples: 0

**Called by:**
- `checkForFunction` (2)

**Calls:**
- `slice` (2)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2524` | Self: 0.0% (0us) | Total: 0.7% (6.6ms) | Samples: 0

**Called by:**
- `getDeclaredVariables` (28)
- `_buildScopeVarsAndSet` (12)

**Calls:**
- `_buildReference` (28)
- `_buildReference` (5)
- `_buildReference` (3)
- `_buildReference` (1)
- `_buildReference` (1)
- `_buildReference` (1)
- `_buildReference` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:558` | Self: 0.0% (0us) | Total: 0.0% (148us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get left` (1)

### `requestSatisfyUtil`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (554us) | Samples: 0

**Called by:**
- `(anonymous)` (2)
- `requestSatisfy` (1)

**Calls:**
- `requestInstantiate` (3)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6479` | Self: 0.0% (0us) | Total: 0.0% (516us) | Samples: 0

**Called by:**
- `walkNodes` (3)

**Calls:**
- `initialSegment` (2)
- `get initialSegment` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6505` | Self: 0.0% (0us) | Total: 0.0% (144us) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_dispatchSeg` (1)

### `getArrayMethodName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:124` | Self: 0.0% (0us) | Total: 0.1% (1.1ms) | Samples: 0

**Called by:**
- `onCodePathStart` (7)

**Calls:**
- `isSpecificMemberAccess` (6)
- `get callee` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6532` | Self: 0.0% (0us) | Total: 0.0% (203us) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `has` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6100` | Self: 0.0% (0us) | Total: 0.0% (186us) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `get` (1)

### `BinaryExpression`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js:206` | Self: 0.0% (0us) | Total: 0.0% (688us) | Samples: 0

**Called by:**
- `_invokeFused` (4)

**Calls:**
- `report` (2)
- `report` (1)
- `report` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1451` | Self: 0.0% (0us) | Total: 0.0% (153us) | Samples: 0

**Called by:**
- `equalsToOriginalName` (1)

**Calls:**
- `nodeRhs` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:475` | Self: 0.0% (0us) | Total: 0.1% (1.1ms) | Samples: 0

**Called by:**
- `forEach` (7)

**Calls:**
- `get init` (3)
- `_nodeViewRaw` (1)
- `nodeViewChain` (1)
- `_nodeViewRaw` (1)
- `get init` (1)

### `Se`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (196us) | Samples: 0

**Called by:**
- `Pe` (1)

**Calls:**
- `Ee` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:215` | Self: 0.0% (0us) | Total: 0.2% (2.1ms) | Samples: 0

**Called by:**
- `runOnce` (12)

**Calls:**
- `_encodeSource` (9)
- `_encodeSource` (3)

### `g`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (7)

**Calls:**
- `parse` (7)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` | Self: 0.0% (0us) | Total: 0.1% (973us) | Samples: 0

**Called by:**
- `anonymous` (6)

**Calls:**
- `bound require` (6)

### `linkAndEvaluateModule`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (347us) | Samples: 0

**Called by:**
- `async loadAndEvaluateModule` (1)

**Calls:**
- `link` (1)

### `getUsedIgnoredMessageData`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:331` | Self: 0.0% (0us) | Total: 0.0% (150us) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `getVariableDescription` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:323` | Self: 0.0% (0us) | Total: 0.0% (186us) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `Uint32Array` (1)

### `fn`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5027` | Self: 0.0% (0us) | Total: 0.0% (638us) | Samples: 0

**Called by:**
- `fn` (4)

**Calls:**
- `get type` (3)
- `get type` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:295` | Self: 0.0% (0us) | Total: 0.1% (1.5ms) | Samples: 0

**Called by:**
- `parseSource` (9)

**Calls:**
- `Uint8Array` (9)

### `_tryLoad`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:51` | Self: 0.0% (0us) | Total: 0.1% (991us) | Samples: 0

**Called by:**
- `isAvailable` (6)

**Calls:**
- `dlopen` (5)
- `dlopen` (1)

### `checkLastSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js:371` | Self: 0.0% (0us) | Total: 0.0% (163us) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `isAnySegmentReachable` (1)

### `isFunctionNameInitializerException`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:424` | Self: 0.0% (0us) | Total: 0.0% (152us) | Samples: 0

**Called by:**
- `checkForShadows` (1)

**Calls:**
- `get init` (1)

### `internal:shared`
`internal:shared:2` | Self: 0.0% (0us) | Total: 0.0% (470us) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `anonymous` (3)

### `_buildVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2727` | Self: 0.0% (0us) | Total: 0.0% (186us) | Samples: 0

**Called by:**
- `_buildScopeVarsAndSet` (1)

**Calls:**
- `_buildThinVariable` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:808` | Self: 0.0% (0us) | Total: 0.0% (834us) | Samples: 0

**Called by:**
- `Program:exit` (3)
- `collectUnusedVariables` (2)

**Calls:**
- `some` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:108` | Self: 0.0% (0us) | Total: 44.8% (384.9ms) | Samples: 0

**Called by:**
- `parseModule` (2201)

**Calls:**
- `runOnce` (1922)
- `runOnce` (255)
- `runOnce` (9)
- `runOnce` (8)
- `runOnce` (4)
- `runOnce` (2)
- `runOnce` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4197` | Self: 0.0% (0us) | Total: 0.0% (371us) | Samples: 0

**Called by:**
- `AstView` (2)

**Calls:**
- `Uint32Array` (2)

### `_getSelectorRootTypes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5571` | Self: 0.0% (0us) | Total: 1.2% (10.6ms) | Samples: 0

**Called by:**
- `_buildPlan` (31)
- `_getOrBuildSelectorPlan` (30)

**Calls:**
- `_getSelectorRootTypes` (22)
- `_getSelectorRootTypes` (19)
- `_getSelectorRootTypes` (9)
- `_getSelectorRootTypes` (7)
- `_getSelectorRootTypes` (2)
- `_getSelectorRootTypes` (1)
- `_getSelectorRootTypes` (1)

### `getTokenBefore`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1196` | Self: 0.0% (0us) | Total: 0.0% (176us) | Samples: 0

**Called by:**
- `getFunctionHeadLoc` (1)

**Calls:**
- `_tokenIndexAtOrBefore` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/tags.js:247` | Self: 0.0% (0us) | Total: 0.0% (169us) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `fill` (1)

### `ensureChildren`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1848` | Self: 0.0% (0us) | Total: 2.3% (20.1ms) | Samples: 0

**Called by:**
- `get` (121)

**Calls:**
- `_buildScopeChildren` (118)
- `_buildScopeChildren` (1)
- `_buildScopeChildren` (1)
- `_buildScopeChildren` (1)

### `get declarations`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2616` | Self: 0.0% (0us) | Total: 0.0% (164us) | Samples: 0

**Called by:**
- `checkGroup` (1)

**Calls:**
- `nodeLhs` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.4% (4.2ms) | Samples: 0

**Called by:**
- `anonymous` (25)

**Calls:**
- `bound require` (25)

### `getStaticPropertyName`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:328` | Self: 0.0% (0us) | Total: 0.0% (360us) | Samples: 0

**Called by:**
- `isSpecificMemberAccess` (1)
- `onCodePathStart` (1)

**Calls:**
- `get name` (2)

### `getDestructuringHost`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:104` | Self: 0.0% (0us) | Total: 0.0% (631us) | Samples: 0

**Called by:**
- `getIdentifierIfShouldBeConst` (3)

**Calls:**
- `get parent` (1)
- `get parent` (1)
- `get parent` (1)

### `_findDefNode`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:414` | Self: 0.0% (0us) | Total: 0.0% (164us) | Samples: 0

**Called by:**
- `_buildVariable` (1)

**Calls:**
- `get type` (1)

### `getFunctionNameWithKind`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2180` | Self: 0.0% (0us) | Total: 0.0% (158us) | Samples: 0

**Called by:**
- `checkLastSegment` (1)

**Calls:**
- `get id` (1)

### `getFunctionHeadLoc`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2300` | Self: 0.0% (0us) | Total: 0.0% (171us) | Samples: 0

**Called by:**
- `checkLastSegment` (1)

**Calls:**
- `get body` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4230` | Self: 0.0% (0us) | Total: 0.0% (342us) | Samples: 0

**Called by:**
- `AstView` (2)

**Calls:**
- `Uint32Array` (2)

### `isClassStaticInitializerScope`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:88` | Self: 0.0% (0us) | Total: 0.0% (174us) | Samples: 0

**Called by:**
- `isFromSeparateExecutionContext` (1)

**Calls:**
- `get static` (1)

### `_runSelectorList`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5992` | Self: 0.0% (0us) | Total: 0.0% (773us) | Samples: 0

**Called by:**
- `invokeSelectorHandlers` (5)

**Calls:**
- `getAncestorsFor` (4)
- `getAncestorsFor` (1)

### `getIdentifierIfShouldBeConst`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:221` | Self: 0.0% (0us) | Total: 0.0% (145us) | Samples: 0

**Called by:**
- `groupByDestructuring` (1)

**Calls:**
- `filter` (1)

### `groupByDestructuring`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:310` | Self: 0.0% (0us) | Total: 0.0% (353us) | Samples: 0

**Called by:**
- `Program:exit` (2)

**Calls:**
- `getDestructuringHost` (1)
- `getDestructuringHost` (1)

### `_buildThinVariable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2880` | Self: 0.0% (0us) | Total: 0.1% (864us) | Samples: 0

**Called by:**
- `_buildReference` (3)
- `_buildVariable` (1)
- `_buildThinScope` (1)

**Calls:**
- `_nodeViewRaw` (1)
- `nodeView` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `nodeView` (1)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:182` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `getRhsNode` (8)

**Calls:**
- `isLoop` (8)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:555` | Self: 0.0% (0us) | Total: 0.0% (174us) | Samples: 0

**Called by:**
- `_precomputeScopes` (1)

**Calls:**
- `source` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3758` | Self: 0.0% (0us) | Total: 0.0% (295us) | Samples: 0

**Called by:**
- `report` (2)

**Calls:**
- `getLocFromIndex` (2)

### `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:318` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `_invokeFused` (8)

**Calls:**
- `getDeclaredVariables` (2)
- `getDeclaredVariables` (2)
- `getDeclaredVariables` (2)
- `getDeclaredVariables` (2)

### `get async`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:2217` | Self: 0.0% (0us) | Total: 0.0% (150us) | Samples: 0

**Called by:**
- `getFunctionNameWithKind` (1)

**Calls:**
- `_tag` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:542` | Self: 0.0% (0us) | Total: 0.7% (6.6ms) | Samples: 0

**Called by:**
- `_invokeFused` (38)

**Calls:**
- `groupByDestructuring` (23)
- `forEach` (12)
- `groupByDestructuring` (2)
- `groupByDestructuring` (1)

### `findUp`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:339` | Self: 0.0% (0us) | Total: 0.0% (171us) | Samples: 0

**Called by:**
- `checkGroup` (1)

**Calls:**
- `get parent` (1)

### `Program`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:449` | Self: 0.0% (0us) | Total: 3.5% (30.7ms) | Samples: 0

**Called by:**
- `safeHandler` (180)

**Calls:**
- `getScope` (155)
- `checkReferencesInScope` (13)
- `checkReferencesInScope` (11)
- `getScope` (1)

### `Program`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:295` | Self: 0.0% (0us) | Total: 0.0% (481us) | Samples: 0

**Called by:**
- `_invokeFused` (3)

**Calls:**
- `isImportAttributeKey` (1)
- `isImportAttributeKey` (1)
- `isImportAttributeKey` (1)

### `bound call`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (322us) | Samples: 0

**Called by:**
- `internal:primordials` (1)
- `makeSafe` (1)

**Calls:**
- `[Symbol.iterator]` (1)
- `forEach` (1)

### `_buildThinScope`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2945` | Self: 0.0% (0us) | Total: 0.0% (772us) | Samples: 0

**Called by:**
- `_buildThinScope` (3)
- `_buildThinVariable` (1)

**Calls:**
- `_buildThinScope` (3)
- `_buildThinScope` (1)

### `checkForShadows`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:658` | Self: 0.0% (0us) | Total: 0.0% (163us) | Samples: 0

**Called by:**
- `Program:exit` (1)

**Calls:**
- `some` (1)

### `_buildScopeVarsAndSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:2106` | Self: 0.0% (0us) | Total: 0.0% (146us) | Samples: 0

**Called by:**
- `ensureVarsSet` (1)

**Calls:**
- `regExpMatchFast` (1)

### `isAssignmentTarget`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:148` | Self: 0.0% (0us) | Total: 0.0% (134us) | Samples: 0

**Called by:**
- `MemberExpression[computed!=true] > Identifier.property` (1)

**Calls:**
- `get value` (1)

### `isAfterLastUsedArg`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:748` | Self: 0.0% (0us) | Total: 0.0% (518us) | Samples: 0

**Called by:**
- `collectUnusedVariables` (2)

**Calls:**
- `getDeclaredVariables` (1)
- `getDeclaredVariables` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6900` | Self: 0.0% (0us) | Total: 7.2% (61.8ms) | Samples: 0

**Called by:**
- `runPlugins` (355)

**Calls:**
- `_invokeFused` (347)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `nodeView` (1)
- `_nodeViewRaw` (1)

### `VariableDeclaration,FunctionDeclaration,FunctionExpression,ArrowFunctionExpression,ClassDeclaration,ClassExpression,CatchClause`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:325` | Self: 0.0% (0us) | Total: 0.0% (515us) | Samples: 0

**Called by:**
- `_invokeFused` (3)

**Calls:**
- `equalsToOriginalName` (1)
- `equalsToOriginalName` (1)
- `equalsToOriginalName` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5899` | Self: 0.0% (0us) | Total: 0.0% (300us) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `_ensureTagCaches` (1)
- `_ensureTagCaches` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6716` | Self: 0.0% (0us) | Total: 3.6% (30.9ms) | Samples: 0

**Called by:**
- `runPlugins` (181)

**Calls:**
- `safeHandler` (180)
- `safeHandler` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4202` | Self: 0.0% (0us) | Total: 0.0% (174us) | Samples: 0

**Called by:**
- `AstView` (1)

**Calls:**
- `Uint32Array` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:453` | Self: 0.0% (0us) | Total: 0.0% (155us) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `Uint32Array` (1)

### `isNullLiteral`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:205` | Self: 0.0% (0us) | Total: 0.0% (336us) | Samples: 0

**Called by:**
- `isNullCheck` (2)

**Calls:**
- `get value` (1)
- `get value` (1)

### `runOnce`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js:87` | Self: 0.0% (0us) | Total: 14.4% (124.0ms) | Samples: 0

**Called by:**
- `(anonymous)` (440)
- `(anonymous)` (255)

**Calls:**
- `parseSource` (291)
- `parseSource` (276)
- `parseSource` (109)
- `parseSource` (12)
- `parseSource` (4)
- `parseSource` (3)

### `we`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (698us) | Samples: 0

**Called by:**
- `Pe` (4)

**Calls:**
- `ke` (4)

### `_computeIsStrict`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1907` | Self: 0.0% (0us) | Total: 0.0% (531us) | Samples: 0

**Called by:**
- `_buildScope` (3)

**Calls:**
- `get type` (1)
- `get type` (1)
- `get parent` (1)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 5.2% (45.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (60)
- `(anonymous)` (40)
- `(anonymous)` (25)
- `(anonymous)` (22)
- `(anonymous)` (16)
- `esquery` (16)
- `(anonymous)` (15)
- `(anonymous)` (10)
- `(anonymous)` (10)
- `(anonymous)` (7)
- `(anonymous)` (6)
- `(anonymous)` (6)
- `(anonymous)` (5)
- `(anonymous)` (5)
- `(anonymous)` (4)
- `loadBinding` (4)
- `(anonymous)` (3)
- `_getFfiSelector` (3)
- `_tryLoad` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `require` (242)
- `anonymous` (21)
- `(anonymous)` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6713` | Self: 0.0% (0us) | Total: 0.0% (452us) | Samples: 0

**Called by:**
- `runPlugins` (3)

**Calls:**
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `requestInstantiate`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (554us) | Samples: 0

**Called by:**
- `requestSatisfyUtil` (3)

**Calls:**
- `async (anonymous)` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6904` | Self: 0.0% (0us) | Total: 0.0% (448us) | Samples: 0

**Called by:**
- `runPlugins` (3)

**Calls:**
- `_fireCfgEvents` (2)
- `_fireCfgEvents` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3750` | Self: 0.0% (0us) | Total: 0.0% (480us) | Samples: 0

**Called by:**
- `report` (3)

**Calls:**
- `get end` (3)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:412` | Self: 0.0% (0us) | Total: 0.0% (180us) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `Uint32Array` (1)

### `requestFetch`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (409us) | Samples: 0

**Called by:**
- `async (anonymous)` (2)

**Calls:**
- `fetch` (2)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:338` | Self: 0.0% (0us) | Total: 0.0% (190us) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `Uint8Array` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:862` | Self: 0.0% (0us) | Total: 0.0% (167us) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `get name` (1)

### `ensureVarsSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1754` | Self: 0.0% (0us) | Total: 0.0% (316us) | Samples: 0

**Called by:**
- `get` (2)

**Calls:**
- `_buildScopeVarsAndSet` (1)
- `_buildScopeVarsAndSet` (1)

### `_deepMergeObjects`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:126` | Self: 0.0% (0us) | Total: 0.1% (1.0ms) | Samples: 0

**Called by:**
- `map` (5)
- `(anonymous)` (1)

**Calls:**
- `copyDataProperties` (4)
- `cloneObject` (2)

### `node:fs`
`node:fs:618` | Self: 0.0% (0us) | Total: 0.0% (149us) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `setName` (1)

### `getIdentifierIfShouldBeConst`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js:217` | Self: 0.0% (0us) | Total: 0.0% (161us) | Samples: 0

**Called by:**
- `groupByDestructuring` (1)

**Calls:**
- `get type` (1)

### `getNameLocationInGlobalDirectiveComment`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2640` | Self: 0.0% (0us) | Total: 0.0% (285us) | Samples: 0

**Called by:**
- `iterateDeclarations` (1)
- `Program:exit` (1)

**Calls:**
- `indexOf` (2)

### `_loadFromDisk`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:69` | Self: 0.0% (0us) | Total: 0.0% (490us) | Samples: 0

**Called by:**
- `_getPlugin` (3)

**Calls:**
- `tryParse` (3)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1690` | Self: 0.0% (0us) | Total: 0.0% (155us) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `filter` (1)

### `node:fs`
`node:fs:303` | Self: 0.0% (0us) | Total: 0.0% (186us) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `Pe`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.1% (1.0ms) | Samples: 0

**Called by:**
- `_e` (6)

**Calls:**
- `we` (4)
- `Se` (1)
- `reduce` (1)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:940` | Self: 0.0% (0us) | Total: 0.0% (160us) | Samples: 0

**Called by:**
- `Program:exit` (1)

**Calls:**
- `getUsedIgnoredMessageData` (1)

### `checkForShadows`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:656` | Self: 0.0% (0us) | Total: 0.0% (330us) | Samples: 0

**Called by:**
- `Program:exit` (2)

**Calls:**
- `isInTdz` (1)
- `isInTdz` (1)

### `Program`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:304` | Self: 0.0% (0us) | Total: 0.1% (1.0ms) | Samples: 0

**Called by:**
- `_invokeFused` (6)

**Calls:**
- `reportReferenceId` (3)
- `reportReferenceId` (2)
- `reportReferenceId` (1)

### `Program:exit`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:1711` | Self: 0.0% (0us) | Total: 0.0% (679us) | Samples: 0

**Called by:**
- `_invokeFused` (4)

**Calls:**
- `getAssignedMessageData` (2)
- `getAssignedMessageData` (1)
- `getAssignedMessageData` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:325` | Self: 0.0% (0us) | Total: 0.0% (518us) | Samples: 0

**Called by:**
- `parseSource` (3)

**Calls:**
- `Uint32Array` (3)

### `collectUnusedVariables`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:829` | Self: 0.0% (0us) | Total: 0.0% (150us) | Samples: 0

**Called by:**
- `collectUnusedVariables` (1)

**Calls:**
- `getUsedIgnoredMessageData` (1)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4212` | Self: 0.0% (0us) | Total: 0.0% (154us) | Samples: 0

**Called by:**
- `AstView` (1)

**Calls:**
- `Uint32Array` (1)

### `getDefinedMessageData`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:278` | Self: 0.0% (0us) | Total: 0.0% (155us) | Samples: 0

**Called by:**
- `Program:exit` (1)

**Calls:**
- `getVariableDescription` (1)

### `loadBinding`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` | Self: 0.0% (0us) | Total: 0.0% (651us) | Samples: 0

**Called by:**
- `getTagNames` (4)

**Calls:**
- `bound require` (4)

### `getFunctionNameWithKind`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:2127` | Self: 0.0% (0us) | Total: 0.0% (150us) | Samples: 0

**Called by:**
- `checkLastSegment` (1)

**Calls:**
- `get async` (1)

### `checkForShadows`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js:657` | Self: 0.0% (0us) | Total: 0.0% (292us) | Samples: 0

**Called by:**
- `Program:exit` (2)

**Calls:**
- `isTypeValueShadow` (1)
- `isTypeValueShadow` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6577` | Self: 0.0% (0us) | Total: 0.1% (1.2ms) | Samples: 0

**Called by:**
- `runPlugins` (7)

**Calls:**
- `indexOf` (7)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:403` | Self: 0.0% (0us) | Total: 0.1% (1.0ms) | Samples: 0

**Called by:**
- `parseSource` (6)

**Calls:**
- `Uint32Array` (6)

### `_getPlugin`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:60` | Self: 0.0% (0us) | Total: 0.0% (631us) | Samples: 0

**Called by:**
- `describeRule` (4)

**Calls:**
- `_loadFromDisk` (3)
- `_loadFromDisk` (1)

### `MemberExpression[computed!=true] > Identifier.property`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js:362` | Self: 0.0% (0us) | Total: 0.0% (675us) | Samples: 0

**Called by:**
- `_runSelectorList` (4)

**Calls:**
- `isAssignmentTarget` (1)
- `isAssignmentTarget` (1)
- `isAssignmentTarget` (1)
- `isAssignmentTarget` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:545` | Self: 0.0% (0us) | Total: 0.9% (7.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (44)

**Calls:**
- `isInLoop` (21)
- `isInLoop` (14)
- `isInLoop` (8)
- `isInLoop` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn-jsx/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (371us) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `_getFfiSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:110` | Self: 0.0% (0us) | Total: 0.1% (1.3ms) | Samples: 0

**Called by:**
- `_getOrBuildSelectorPlan` (8)

**Calls:**
- `isAvailable` (8)

### `async loadModule`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (640us) | Samples: 0

**Called by:**
- `async loadModule` (2)
- `async loadAndEvaluateModule` (2)

**Calls:**
- `async loadModule` (2)
- `requestSatisfy` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:3999` | Self: 0.0% (0us) | Total: 0.0% (516us) | Samples: 0

**Called by:**
- `(anonymous)` (3)

**Calls:**
- `buildUnicodeData` (2)
- `buildUnicodeData` (1)

### `_getSelectorRootTypes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5566` | Self: 0.0% (0us) | Total: 0.0% (195us) | Samples: 0

**Called by:**
- `_buildPlan` (1)

**Calls:**
- `trim` (1)

### `isEvaluatedDuringInitialization`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js:197` | Self: 0.0% (0us) | Total: 0.0% (382us) | Samples: 0

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `get init` (1)
- `_nodeViewRaw` (1)

### `getRhsNode`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js:556` | Self: 0.0% (0us) | Total: 0.0% (174us) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `get type` (1)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 54.9% | 471.4ms | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 25.4% | 218.6ms | `[native code]` |
| 11.9% | 102.5ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 3.2% | 28.2ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-unused-vars.js` |
| 0.7% | 6.8ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js` |
| 0.6% | 5.5ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/camelcase.js` |
| 0.5% | 4.2ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-redeclare.js` |
| 0.4% | 4.0ms | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_runner.js` |
| 0.4% | 3.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-shadow.js` |
| 0.3% | 2.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/prefer-const.js` |
| 0.2% | 1.9ms | `/Users/ericsan/Development/OpenSource/Ez/js/index.js` |
| 0.1% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/array-callback-return.js` |
| 0.1% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.1% | 999us | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-use-before-define.js` |
| 0.1% | 988us | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js` |
| 0.0% | 666us | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
| 0.0% | 336us | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` |
| 0.0% | 333us | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-param-reassign.js` |
| 0.0% | 323us | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/eqeqeq.js` |
| 0.0% | 182us | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn-jsx/xhtml.js` |
| 0.0% | 174us | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/fix-tracker.js` |
| 0.0% | 169us | `internal:primordials` |
| 0.0% | 158us | `bun:ffi` |
| 0.0% | 149us | `node:fs` |
| 0.0% | 139us | `node:child_process` |
