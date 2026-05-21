# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 2.62s | 1733 | 1.0ms | 222 |

**Top 10:** `walkNodes` 9.2%, `onCodePathSegmentStart` 7.2%, `walkNodes` 6.8%, `filter` 4.7%, `onCodePathSegmentStart` 3.7%, `getAncestorsFor` 2.9%, `getUselessReturns` 2.9%, `parse` 2.9%, `_fireCfgEvents` 2.7%, `walkNodes` 2.6%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 9.2% | 242.5ms | 9.7% | 255.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7129` |
| 7.2% | 191.3ms | 7.2% | 191.3ms | `onCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:313` |
| 6.8% | 179.2ms | 9.6% | 253.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7351` |
| 4.7% | 123.5ms | 4.7% | 124.8ms | `filter` | `[native code]` |
| 3.7% | 99.4ms | 3.7% | 99.4ms | `onCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:324` |
| 2.9% | 78.1ms | 5.9% | 156.5ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6106` |
| 2.9% | 77.4ms | 5.0% | 132.6ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:157` |
| 2.9% | 76.1ms | 2.9% | 76.1ms | `parse` | `[native code]` |
| 2.7% | 73.2ms | 27.3% | 717.8ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6653` |
| 2.6% | 70.1ms | 2.9% | 77.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7219` |
| 2.6% | 69.5ms | 2.6% | 69.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6770` |
| 2.5% | 67.1ms | 2.5% | 67.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4100` |
| 2.3% | 62.6ms | 2.4% | 64.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7056` |
| 2.2% | 59.7ms | 9.1% | 240.2ms | `forEach` | `[native code]` |
| 2.1% | 56.7ms | 2.1% | 56.7ms | `push` | `[native code]` |
| 2.1% | 56.2ms | 2.6% | 68.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7321` |
| 2.0% | 55.0ms | 12.3% | 323.7ms | `onCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:316` |
| 1.8% | 48.1ms | 26.4% | 693.1ms | `_dispatchSeg` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6267` |
| 1.8% | 47.3ms | 1.8% | 47.3ms | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1862` |
| 1.6% | 42.6ms | 1.6% | 42.6ms | `WeakSet` | `[native code]` |
| 1.5% | 41.5ms | 1.5% | 41.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6766` |
| 1.5% | 41.4ms | 1.5% | 41.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:258` |
| 1.4% | 37.0ms | 3.0% | 79.7ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:141` |
| 1.0% | 28.7ms | 1.7% | 46.9ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6619` |
| 1.0% | 28.2ms | 1.0% | 28.2ms | `has` | `[native code]` |
| 1.0% | 27.5ms | 4.0% | 105.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7088` |
| 0.9% | 25.6ms | 0.9% | 25.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7044` |
| 0.9% | 24.6ms | 0.9% | 24.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6759` |
| 0.8% | 23.4ms | 0.8% | 23.4ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:158` |
| 0.8% | 22.1ms | 14.4% | 379.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7084` |
| 0.7% | 20.1ms | 0.7% | 20.1ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6627` |
| 0.7% | 19.9ms | 22.3% | 587.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7278` |
| 0.7% | 18.8ms | 0.7% | 18.8ms | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:189` |
| 0.6% | 17.7ms | 0.6% | 17.7ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6093` |
| 0.6% | 16.6ms | 1.5% | 39.6ms | `anonymous` | `[native code]` |
| 0.6% | 15.9ms | 0.6% | 15.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6774` |
| 0.5% | 15.0ms | 0.5% | 15.0ms | `onCodePathSegmentEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:336` |
| 0.5% | 13.9ms | 8.1% | 212.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7078` |
| 0.5% | 13.7ms | 0.5% | 13.7ms | `onUnreachableCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:328` |
| 0.5% | 13.3ms | 0.5% | 13.3ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4132` |
| 0.5% | 13.2ms | 0.5% | 13.2ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6510` |
| 0.4% | 13.0ms | 12.7% | 333.1ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4713` |
| 0.4% | 12.7ms | 0.4% | 12.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7046` |
| 0.4% | 12.5ms | 0.4% | 12.5ms | `onCodePathStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:270` |
| 0.4% | 12.4ms | 0.4% | 12.4ms | `getUint32` | `[native code]` |
| 0.4% | 12.0ms | 0.4% | 12.0ms | `onCodePathEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:280` |
| 0.4% | 11.9ms | 0.4% | 11.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4095` |
| 0.3% | 10.3ms | 0.3% | 10.3ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6117` |
| 0.3% | 10.1ms | 0.6% | 16.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7082` |
| 0.3% | 8.9ms | 0.3% | 8.9ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.3% | 8.5ms | 0.3% | 8.5ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:146` |
| 0.3% | 7.9ms | 0.3% | 7.9ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6103` |
| 0.2% | 7.3ms | 0.2% | 7.3ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4133` |
| 0.2% | 6.5ms | 2.2% | 60.1ms | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:341` |
| 0.2% | 6.5ms | 0.2% | 6.5ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:565` |
| 0.2% | 6.2ms | 0.2% | 6.2ms | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 5.9ms | 1.6% | 42.2ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4137` |
| 0.2% | 5.7ms | 0.2% | 5.7ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6644` |
| 0.2% | 5.6ms | 8.5% | 223.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7281` |
| 0.2% | 5.5ms | 0.3% | 10.0ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:147` |
| 0.1% | 4.9ms | 0.2% | 6.6ms | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6207` |
| 0.1% | 4.8ms | 0.1% | 4.8ms | `get` | `[native code]` |
| 0.1% | 4.8ms | 0.7% | 20.5ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6633` |
| 0.1% | 4.8ms | 0.2% | 6.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7322` |
| 0.1% | 4.8ms | 0.1% | 4.8ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6944` |
| 0.1% | 4.7ms | 0.1% | 4.7ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4700` |
| 0.1% | 4.7ms | 0.1% | 4.7ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6517` |
| 0.1% | 4.4ms | 0.2% | 5.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7186` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 4.4ms | 0.3% | 9.3ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6110` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `initialSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4597` |
| 0.1% | 4.4ms | 0.2% | 5.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7244` |
| 0.1% | 4.3ms | 0.1% | 4.3ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:143` |
| 0.1% | 3.4ms | 0.3% | 7.9ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6628` |
| 0.1% | 3.2ms | 2.9% | 77.5ms | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:211` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7256` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4490` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `onCodePathStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:269` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4108` |
| 0.1% | 3.0ms | 0.7% | 19.9ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6655` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4134` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7040` |
| 0.1% | 3.0ms | 0.1% | 4.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7247` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6115` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4389` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `some` | `[native code]` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6358` |
| 0.1% | 2.7ms | 0.1% | 4.3ms | `segment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4398` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7259` |
| 0.1% | 2.6ms | 0.1% | 2.6ms | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6631` |
| 0.0% | 2.4ms | 0.0% | 2.4ms | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:188` |
| 0.0% | 1.8ms | 9.2% | 242.0ms | `markReturnStatementsOnCurrentSegmentsAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:257` |
| 0.0% | 1.8ms | 0.5% | 14.6ms | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1889` |
| 0.0% | 1.7ms | 0.1% | 5.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `isInFinally` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:49` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6181` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7265` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4498` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6353` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `TokenType` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:119` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_dispatchSeg` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6263` |
| 0.0% | 1.6ms | 1.4% | 37.9ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6654` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:355` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6678` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4456` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6152` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get label` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3247` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:592` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `CfgSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4516` |
| 0.0% | 1.5ms | 0.1% | 3.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7149` |
| 0.0% | 1.5ms | 0.6% | 16.5ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6646` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `segment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4397` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7195` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4468` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4286` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7220` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4116` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7245` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4032` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4503` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `onUnreachableCodePathSegmentEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:332` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7146` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_csrSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7251` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3876` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_dispatchSeg` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6270` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `remove` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:28` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `dlopen` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1413` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6135` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `segment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4442` |
| 0.0% | 1.2ms | 0.1% | 2.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7260` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3630` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 100.0% | 2.62s | 0.0% | 0us | `parseModule` | `[native code]` |
| 100.0% | 2.62s | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 99.8% | 2.61s | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` |
| 99.8% | 2.61s | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` |
| 95.9% | 2.51s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7567` |
| 90.0% | 2.36s | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:66` |
| 27.3% | 717.8ms | 2.7% | 73.2ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6653` |
| 26.4% | 693.1ms | 1.8% | 48.1ms | `_dispatchSeg` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6267` |
| 22.3% | 587.4ms | 0.7% | 19.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7278` |
| 14.4% | 379.0ms | 0.8% | 22.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7084` |
| 12.7% | 333.1ms | 0.4% | 13.0ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4713` |
| 12.3% | 323.7ms | 2.0% | 55.0ms | `onCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:316` |
| 9.7% | 255.3ms | 9.2% | 242.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7129` |
| 9.6% | 253.2ms | 6.8% | 179.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7351` |
| 9.2% | 242.0ms | 0.0% | 1.8ms | `markReturnStatementsOnCurrentSegmentsAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:257` |
| 9.1% | 240.2ms | 2.2% | 59.7ms | `forEach` | `[native code]` |
| 8.5% | 223.2ms | 0.2% | 5.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7281` |
| 8.1% | 212.6ms | 0.5% | 13.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7078` |
| 7.9% | 209.1ms | 0.0% | 0us | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6243` |
| 7.8% | 206.2ms | 0.0% | 0us | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6151` |
| 7.2% | 191.3ms | 7.2% | 191.3ms | `onCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:313` |
| 6.1% | 162.4ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:62` |
| 5.9% | 156.5ms | 2.9% | 78.1ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6106` |
| 5.0% | 132.6ms | 2.9% | 77.4ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:157` |
| 4.7% | 124.8ms | 4.7% | 123.5ms | `filter` | `[native code]` |
| 4.0% | 105.4ms | 1.0% | 27.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7088` |
| 3.7% | 99.4ms | 3.7% | 99.4ms | `onCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:324` |
| 3.0% | 80.6ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:59` |
| 3.0% | 79.7ms | 1.4% | 37.0ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:141` |
| 2.9% | 77.6ms | 2.6% | 70.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7219` |
| 2.9% | 77.5ms | 0.1% | 3.2ms | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:211` |
| 2.9% | 76.1ms | 2.9% | 76.1ms | `parse` | `[native code]` |
| 2.9% | 76.1ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` |
| 2.6% | 69.5ms | 2.6% | 69.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6770` |
| 2.6% | 68.6ms | 2.1% | 56.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7321` |
| 2.5% | 67.1ms | 2.5% | 67.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4100` |
| 2.4% | 64.5ms | 2.3% | 62.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7056` |
| 2.2% | 60.1ms | 0.2% | 6.5ms | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:341` |
| 2.1% | 56.7ms | 2.1% | 56.7ms | `push` | `[native code]` |
| 1.8% | 47.3ms | 1.8% | 47.3ms | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1862` |
| 1.7% | 46.9ms | 1.0% | 28.7ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6619` |
| 1.6% | 42.6ms | 1.6% | 42.6ms | `WeakSet` | `[native code]` |
| 1.6% | 42.2ms | 0.2% | 5.9ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4137` |
| 1.5% | 41.5ms | 1.5% | 41.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6766` |
| 1.5% | 41.4ms | 1.5% | 41.4ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:258` |
| 1.5% | 40.7ms | 0.0% | 0us | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:342` |
| 1.5% | 39.6ms | 0.6% | 16.6ms | `anonymous` | `[native code]` |
| 1.4% | 38.3ms | 0.0% | 0us | `bound require` | `[native code]` |
| 1.4% | 37.9ms | 0.0% | 1.6ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6654` |
| 1.3% | 35.2ms | 0.0% | 0us | `require` | `[native code]` |
| 1.0% | 28.2ms | 1.0% | 28.2ms | `has` | `[native code]` |
| 0.9% | 25.6ms | 0.9% | 25.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7044` |
| 0.9% | 24.6ms | 0.9% | 24.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6759` |
| 0.9% | 24.0ms | 0.0% | 0us | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:192` |
| 0.8% | 23.4ms | 0.8% | 23.4ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:158` |
| 0.7% | 20.5ms | 0.1% | 4.8ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6633` |
| 0.7% | 20.1ms | 0.7% | 20.1ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6627` |
| 0.7% | 19.9ms | 0.1% | 3.0ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6655` |
| 0.7% | 18.8ms | 0.7% | 18.8ms | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:189` |
| 0.6% | 17.9ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7043` |
| 0.6% | 17.7ms | 0.6% | 17.7ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6093` |
| 0.6% | 16.5ms | 0.0% | 1.5ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6646` |
| 0.6% | 16.3ms | 0.3% | 10.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7082` |
| 0.6% | 15.9ms | 0.6% | 15.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6774` |
| 0.5% | 15.0ms | 0.5% | 15.0ms | `onCodePathSegmentEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:336` |
| 0.5% | 14.6ms | 0.0% | 1.8ms | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1889` |
| 0.5% | 14.5ms | 0.0% | 0us | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:149` |
| 0.5% | 14.4ms | 0.0% | 0us | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:345` |
| 0.5% | 13.7ms | 0.5% | 13.7ms | `onUnreachableCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:328` |
| 0.5% | 13.3ms | 0.5% | 13.3ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4132` |
| 0.5% | 13.2ms | 0.5% | 13.2ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6510` |
| 0.4% | 12.7ms | 0.4% | 12.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7046` |
| 0.4% | 12.5ms | 0.4% | 12.5ms | `onCodePathStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:270` |
| 0.4% | 12.4ms | 0.4% | 12.4ms | `getUint32` | `[native code]` |
| 0.4% | 12.0ms | 0.4% | 12.0ms | `onCodePathEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:280` |
| 0.4% | 11.9ms | 0.0% | 0us | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:191` |
| 0.4% | 11.9ms | 0.4% | 11.9ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4095` |
| 0.4% | 10.7ms | 0.0% | 0us | `get nextSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4542` |
| 0.4% | 10.7ms | 0.0% | 0us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6662` |
| 0.4% | 10.5ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:46` |
| 0.3% | 10.3ms | 0.3% | 10.3ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6117` |
| 0.3% | 10.0ms | 0.2% | 5.5ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:147` |
| 0.3% | 9.3ms | 0.1% | 4.4ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6110` |
| 0.3% | 8.9ms | 0.3% | 8.9ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.3% | 8.5ms | 0.3% | 8.5ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:146` |
| 0.3% | 7.9ms | 0.3% | 7.9ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6103` |
| 0.3% | 7.9ms | 0.1% | 3.4ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6628` |
| 0.2% | 7.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:477` |
| 0.2% | 7.7ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:435` |
| 0.2% | 7.3ms | 0.2% | 7.3ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4133` |
| 0.2% | 6.6ms | 0.1% | 4.9ms | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6207` |
| 0.2% | 6.6ms | 0.1% | 4.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7322` |
| 0.2% | 6.5ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7566` |
| 0.2% | 6.5ms | 0.2% | 6.5ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:565` |
| 0.2% | 6.2ms | 0.2% | 6.2ms | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 5.9ms | 0.1% | 4.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7186` |
| 0.2% | 5.7ms | 0.2% | 5.7ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6644` |
| 0.2% | 5.6ms | 0.1% | 4.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7244` |
| 0.2% | 5.4ms | 0.0% | 0us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6656` |
| 0.1% | 5.0ms | 0.0% | 1.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 0.1% | 4.8ms | 0.1% | 4.8ms | `get` | `[native code]` |
| 0.1% | 4.8ms | 0.1% | 4.8ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6944` |
| 0.1% | 4.7ms | 0.1% | 4.7ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4700` |
| 0.1% | 4.7ms | 0.1% | 4.7ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6517` |
| 0.1% | 4.4ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:478` |
| 0.1% | 4.4ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` |
| 0.1% | 4.4ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7350` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `initialSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4597` |
| 0.1% | 4.3ms | 0.1% | 2.7ms | `segment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4398` |
| 0.1% | 4.3ms | 0.1% | 4.3ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:143` |
| 0.1% | 4.3ms | 0.1% | 3.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7247` |
| 0.1% | 3.3ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4398` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7256` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4490` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `onCodePathStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:269` |
| 0.1% | 3.2ms | 0.1% | 3.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4108` |
| 0.1% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.1% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.1% | 3.1ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7194` |
| 0.1% | 3.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` |
| 0.1% | 3.1ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7149` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4134` |
| 0.1% | 3.0ms | 0.1% | 3.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7040` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6115` |
| 0.1% | 2.9ms | 0.0% | 0us | `onCodePathEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:281` |
| 0.1% | 2.9ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3946` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4389` |
| 0.1% | 2.9ms | 0.1% | 2.9ms | `some` | `[native code]` |
| 0.1% | 2.9ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6884` |
| 0.1% | 2.8ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7260` |
| 0.1% | 2.8ms | 0.1% | 2.8ms | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6358` |
| 0.1% | 2.7ms | 0.1% | 2.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7259` |
| 0.1% | 2.6ms | 0.1% | 2.6ms | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6631` |
| 0.0% | 2.5ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6450` |
| 0.0% | 2.5ms | 0.0% | 0us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6630` |
| 0.0% | 2.4ms | 0.0% | 2.4ms | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:188` |
| 0.0% | 1.7ms | 0.0% | 0us | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:347` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `isInFinally` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:49` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6181` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7265` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4498` |
| 0.0% | 1.7ms | 0.0% | 0us | `ke` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.7ms | 0.0% | 0us | `we` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.7ms | 0.0% | 0us | `parse` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.7ms | 0.0% | 0us | `_e` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.7ms | 0.0% | 0us | `Ae` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.7ms | 0.0% | 0us | `g` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.7ms | 0.0% | 0us | `Pe` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6353` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:221` |
| 0.0% | 1.6ms | 0.0% | 0us | `kw` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:143` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `TokenType` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:119` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_dispatchSeg` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6263` |
| 0.0% | 1.6ms | 0.0% | 0us | `esquery` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:53` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:20` |
| 0.0% | 1.6ms | 0.0% | 0us | `lhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1863` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:355` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6678` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4456` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6152` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get label` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3247` |
| 0.0% | 1.6ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7132` |
| 0.0% | 1.6ms | 0.0% | 0us | `fix` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:288` |
| 0.0% | 1.6ms | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3916` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:592` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `CfgSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4516` |
| 0.0% | 1.5ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:54` |
| 0.0% | 1.5ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:53` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `segment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4397` |
| 0.0% | 1.5ms | 0.0% | 0us | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:205` |
| 0.0% | 1.5ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:45` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7195` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4468` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4286` |
| 0.0% | 1.4ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7131` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4116` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7220` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7245` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4032` |
| 0.0% | 1.4ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7559` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4503` |
| 0.0% | 1.4ms | 0.0% | 0us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6352` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `onUnreachableCodePathSegmentEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:332` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7146` |
| 0.0% | 1.3ms | 0.0% | 0us | `get prevSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4548` |
| 0.0% | 1.3ms | 0.0% | 0us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6660` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_csrSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7251` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3876` |
| 0.0% | 1.3ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_dispatchSeg` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6270` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `remove` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:28` |
| 0.0% | 1.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:239` |
| 0.0% | 1.3ms | 0.0% | 0us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5490` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `dlopen` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `dlopen` | `bun:ffi:345` |
| 0.0% | 1.3ms | 0.0% | 0us | `isAvailable` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:399` |
| 0.0% | 1.3ms | 0.0% | 0us | `_tryLoad` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:51` |
| 0.0% | 1.3ms | 0.0% | 0us | `_getFfiSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:110` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1413` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6135` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `segment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4442` |
| 0.0% | 1.2ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1515` |
| 0.0% | 1.2ms | 0.0% | 0us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5419` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3630` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_getSelectorRootTypes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |

## Function Details

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7129` | Self: 9.2% (242.5ms) | Total: 9.7% (255.3ms) | Samples: 159

**Called by:**
- `runPlugins` (167)

**Calls:**
- `has` (8)

### `onCodePathSegmentStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:313` | Self: 7.2% (191.3ms) | Total: 7.2% (191.3ms) | Samples: 128

**Called by:**
- `_dispatchSeg` (128)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7351` | Self: 6.8% (179.2ms) | Total: 9.6% (253.2ms) | Samples: 118

**Called by:**
- `runPlugins` (168)

**Calls:**
- `_fireCfgEvents` (11)
- `_fireCfgEvents` (9)
- `_fireCfgEvents` (8)
- `_fireCfgEvents` (7)
- `_fireCfgEvents` (6)
- `_fireCfgEvents` (4)
- `_fireCfgEvents` (3)
- `_fireCfgEvents` (2)

### `filter`
`[native code]` | Self: 4.7% (123.5ms) | Total: 4.7% (124.8ms) | Samples: 83

**Called by:**
- `markReturnStatementsOnSegmentAsUsed` (50)
- `markReturnStatementsOnSegmentAsUsed` (16)
- `getUselessReturns` (10)
- `markReturnStatementsOnSegmentAsUsed` (8)

**Calls:**
- `(anonymous)` (1)

### `onCodePathSegmentStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:324` | Self: 3.7% (99.4ms) | Total: 3.7% (99.4ms) | Samples: 66

**Called by:**
- `_dispatchSeg` (66)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6106` | Self: 2.9% (78.1ms) | Total: 5.9% (156.5ms) | Samples: 50

**Called by:**
- `_runSelectorList` (102)

**Calls:**
- `nodeView` (22)
- `_nodeViewRaw` (14)
- `nodeView` (5)
- `_nodeViewRaw` (5)
- `nodeView` (4)
- `nodeView` (2)

### `getUselessReturns`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:157` | Self: 2.9% (77.4ms) | Total: 5.0% (132.6ms) | Samples: 51

**Called by:**
- `onCodePathSegmentStart` (88)

**Calls:**
- `push` (37)

### `parse`
`[native code]` | Self: 2.9% (76.1ms) | Total: 2.9% (76.1ms) | Samples: 50

**Called by:**
- `parseSource` (50)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6653` | Self: 2.7% (73.2ms) | Total: 27.3% (717.8ms) | Samples: 49

**Called by:**
- `walkNodes` (332)
- `walkNodes` (87)
- `walkNodes` (51)
- `walkNodes` (7)

**Calls:**
- `_dispatchSeg` (424)
- `segment` (3)
- `_dispatchSeg` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7219` | Self: 2.6% (70.1ms) | Total: 2.9% (77.6ms) | Samples: 46

**Called by:**
- `runPlugins` (51)

**Calls:**
- `_resolveHandlers` (3)
- `_resolveHandlers` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6770` | Self: 2.6% (69.5ms) | Total: 2.6% (69.5ms) | Samples: 46

**Called by:**
- `runPlugins` (46)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4100` | Self: 2.5% (67.1ms) | Total: 2.5% (67.1ms) | Samples: 44

**Called by:**
- `nodeView` (21)
- `getAncestorsFor` (14)
- `walkNodes` (5)
- `_fireCfgEvents` (2)
- `ReturnStatement` (1)
- `invokeMethodFnHandlers` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7056` | Self: 2.3% (62.6ms) | Total: 2.4% (64.5ms) | Samples: 42

**Called by:**
- `runPlugins` (43)

**Calls:**
- `_resolveHandlers` (1)

### `forEach`
`[native code]` | Self: 2.2% (59.7ms) | Total: 9.1% (240.2ms) | Samples: 38

**Called by:**
- `markReturnStatementsOnCurrentSegmentsAsUsed` (159)

**Calls:**
- `markReturnStatementsOnSegmentAsUsed` (52)
- `(anonymous)` (27)
- `markReturnStatementsOnSegmentAsUsed` (16)
- `markReturnStatementsOnSegmentAsUsed` (13)
- `markReturnStatementsOnSegmentAsUsed` (8)
- `markReturnStatementsOnSegmentAsUsed` (2)
- `markReturnStatementsOnSegmentAsUsed` (2)
- `markReturnStatementsOnSegmentAsUsed` (1)

### `push`
`[native code]` | Self: 2.1% (56.7ms) | Total: 2.1% (56.7ms) | Samples: 38

**Called by:**
- `getUselessReturns` (37)
- `walkNodes` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7321` | Self: 2.1% (56.2ms) | Total: 2.6% (68.6ms) | Samples: 36

**Called by:**
- `runPlugins` (45)

**Calls:**
- `has` (9)

### `onCodePathSegmentStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:316` | Self: 2.0% (55.0ms) | Total: 12.3% (323.7ms) | Samples: 35

**Called by:**
- `_dispatchSeg` (214)

**Calls:**
- `getUselessReturns` (88)
- `getUselessReturns` (52)
- `getUselessReturns` (15)
- `getUselessReturns` (10)
- `getUselessReturns` (7)
- `getUselessReturns` (6)
- `getUselessReturns` (1)

### `_dispatchSeg`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6267` | Self: 1.8% (48.1ms) | Total: 26.4% (693.1ms) | Samples: 32

**Called by:**
- `_fireCfgEvents` (424)
- `_fireCfgEvents` (22)
- `_fireCfgEvents` (11)
- `_fireCfgEvents` (3)

**Calls:**
- `onCodePathSegmentStart` (214)
- `onCodePathSegmentStart` (128)
- `onCodePathSegmentStart` (66)
- `onCodePathSegmentEnd` (10)
- `onUnreachableCodePathSegmentStart` (9)
- `onUnreachableCodePathSegmentEnd` (1)

### `get argument`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1862` | Self: 1.8% (47.3ms) | Total: 1.8% (47.3ms) | Samples: 32

**Called by:**
- `ReturnStatement` (27)
- `ReturnStatement` (5)

### `WeakSet`
`[native code]` | Self: 1.6% (42.6ms) | Total: 1.6% (42.6ms) | Samples: 29

**Called by:**
- `getUselessReturns` (29)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6766` | Self: 1.5% (41.5ms) | Total: 1.5% (41.5ms) | Samples: 28

**Called by:**
- `runPlugins` (28)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:258` | Self: 1.5% (41.4ms) | Total: 1.5% (41.4ms) | Samples: 27

**Called by:**
- `forEach` (27)

### `getUselessReturns`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:141` | Self: 1.4% (37.0ms) | Total: 3.0% (79.7ms) | Samples: 24

**Called by:**
- `onCodePathSegmentStart` (52)
- `getUselessReturns` (1)

**Calls:**
- `WeakSet` (29)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6619` | Self: 1.0% (28.7ms) | Total: 1.7% (46.9ms) | Samples: 20

**Called by:**
- `walkNodes` (15)
- `walkNodes` (11)
- `walkNodes` (6)

**Calls:**
- `nodeView` (4)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (2)
- `nodeView` (1)
- `nodeView` (1)
- `nodeView` (1)

### `has`
`[native code]` | Self: 1.0% (28.2ms) | Total: 1.0% (28.2ms) | Samples: 19

**Called by:**
- `walkNodes` (9)
- `walkNodes` (8)
- `getAncestorsFor` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7088` | Self: 1.0% (27.5ms) | Total: 4.0% (105.4ms) | Samples: 18

**Called by:**
- `runPlugins` (70)

**Calls:**
- `_fireCfgEvents` (51)
- `_fireCfgEvents` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7044` | Self: 0.9% (25.6ms) | Total: 0.9% (25.6ms) | Samples: 17

**Called by:**
- `runPlugins` (17)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6759` | Self: 0.9% (24.6ms) | Total: 0.9% (24.6ms) | Samples: 17

**Called by:**
- `runPlugins` (17)

### `getUselessReturns`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:158` | Self: 0.8% (23.4ms) | Total: 0.8% (23.4ms) | Samples: 15

**Called by:**
- `onCodePathSegmentStart` (15)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7084` | Self: 0.8% (22.1ms) | Total: 14.4% (379.0ms) | Samples: 15

**Called by:**
- `runPlugins` (249)

**Calls:**
- `_invokeFused` (219)
- `_nodeViewRaw` (5)
- `nodeView` (3)
- `_invokeFused` (3)
- `nodeView` (2)
- `nodeView` (1)
- `_nodeViewRaw` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6627` | Self: 0.7% (20.1ms) | Total: 0.7% (20.1ms) | Samples: 14

**Called by:**
- `walkNodes` (8)
- `walkNodes` (3)
- `walkNodes` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7278` | Self: 0.7% (19.9ms) | Total: 22.3% (587.4ms) | Samples: 13

**Called by:**
- `runPlugins` (391)

**Calls:**
- `_fireCfgEvents` (332)
- `_fireCfgEvents` (15)
- `_fireCfgEvents` (12)
- `_fireCfgEvents` (7)
- `_fireCfgEvents` (4)
- `_fireCfgEvents` (4)
- `_fireCfgEvents` (3)
- `_fireCfgEvents` (1)

### `markReturnStatementsOnSegmentAsUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:189` | Self: 0.7% (18.8ms) | Total: 0.7% (18.8ms) | Samples: 13

**Called by:**
- `forEach` (13)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6093` | Self: 0.6% (17.7ms) | Total: 0.6% (17.7ms) | Samples: 12

**Called by:**
- `_runSelectorList` (12)

### `anonymous`
`[native code]` | Self: 0.6% (16.6ms) | Total: 1.5% (39.6ms) | Samples: 11

**Called by:**
- `require` (23)
- `bound require` (2)
- `node:fs` (1)

**Calls:**
- `(anonymous)` (5)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:fs` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6774` | Self: 0.6% (15.9ms) | Total: 0.6% (15.9ms) | Samples: 11

**Called by:**
- `runPlugins` (11)

### `onCodePathSegmentEnd`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:336` | Self: 0.5% (15.0ms) | Total: 0.5% (15.0ms) | Samples: 10

**Called by:**
- `_dispatchSeg` (10)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7078` | Self: 0.5% (13.9ms) | Total: 8.1% (212.6ms) | Samples: 10

**Called by:**
- `runPlugins` (141)

**Calls:**
- `_fireCfgEvents` (87)
- `_fireCfgEvents` (13)
- `_fireCfgEvents` (11)
- `_fireCfgEvents` (8)
- `_fireCfgEvents` (3)
- `_fireCfgEvents` (3)
- `_fireCfgEvents` (2)
- `_fireCfgEvents` (2)
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)

### `onUnreachableCodePathSegmentStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:328` | Self: 0.5% (13.7ms) | Total: 0.5% (13.7ms) | Samples: 9

**Called by:**
- `_dispatchSeg` (9)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4132` | Self: 0.5% (13.3ms) | Total: 0.5% (13.3ms) | Samples: 9

**Called by:**
- `getAncestorsFor` (4)
- `ReturnStatement` (2)
- `_fireCfgEvents` (1)
- `invokeSelectorHandlers` (1)
- `walkNodes` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6510` | Self: 0.5% (13.2ms) | Total: 0.5% (13.2ms) | Samples: 9

**Called by:**
- `walkNodes` (9)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4713` | Self: 0.4% (13.0ms) | Total: 12.7% (333.1ms) | Samples: 8

**Called by:**
- `walkNodes` (219)

**Calls:**
- `markReturnStatementsOnCurrentSegmentsAsUsed` (133)
- `ReturnStatement` (40)
- `ReturnStatement` (27)
- `ReturnStatement` (9)
- `ReturnStatement` (1)
- `ReturnStatement` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7046` | Self: 0.4% (12.7ms) | Total: 0.4% (12.7ms) | Samples: 8

**Called by:**
- `runPlugins` (8)

### `onCodePathStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:270` | Self: 0.4% (12.5ms) | Total: 0.4% (12.5ms) | Samples: 8

**Called by:**
- `_fireCfgEvents` (8)

### `getUint32`
`[native code]` | Self: 0.4% (12.4ms) | Total: 0.4% (12.4ms) | Samples: 8

**Called by:**
- `get argument` (4)
- `walkNodes` (2)
- `getAncestorsFor` (1)
- `walkNodes` (1)

### `onCodePathEnd`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:280` | Self: 0.4% (12.0ms) | Total: 0.4% (12.0ms) | Samples: 8

**Called by:**
- `_fireCfgEvents` (8)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4095` | Self: 0.4% (11.9ms) | Total: 0.4% (11.9ms) | Samples: 8

**Called by:**
- `getAncestorsFor` (5)
- `_fireCfgEvents` (3)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6117` | Self: 0.3% (10.3ms) | Total: 0.3% (10.3ms) | Samples: 7

**Called by:**
- `_runSelectorList` (7)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7082` | Self: 0.3% (10.1ms) | Total: 0.6% (16.3ms) | Samples: 7

**Called by:**
- `runPlugins` (11)

**Calls:**
- `invokeSelectorHandlers` (3)
- `invokeSelectorHandlers` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.3% (8.9ms) | Total: 0.3% (8.9ms) | Samples: 6

**Called by:**
- `walkNodes` (3)
- `getAncestorsFor` (2)
- `_fireCfgEvents` (1)

### `getUselessReturns`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:146` | Self: 0.3% (8.5ms) | Total: 0.3% (8.5ms) | Samples: 6

**Called by:**
- `onCodePathSegmentStart` (6)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6103` | Self: 0.3% (7.9ms) | Total: 0.3% (7.9ms) | Samples: 5

**Called by:**
- `_runSelectorList` (5)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4133` | Self: 0.2% (7.3ms) | Total: 0.2% (7.3ms) | Samples: 5

**Called by:**
- `getAncestorsFor` (5)

### `ReturnStatement`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:341` | Self: 0.2% (6.5ms) | Total: 2.2% (60.1ms) | Samples: 4

**Called by:**
- `_invokeFused` (40)

**Calls:**
- `get argument` (27)
- `get argument` (5)
- `nodeView` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `nodeLhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:565` | Self: 0.2% (6.5ms) | Total: 0.2% (6.5ms) | Samples: 4

**Called by:**
- `get argument` (3)
- `lhs` (1)

### `invokeSelectorHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.2% (6.2ms) | Total: 0.2% (6.2ms) | Samples: 4

**Called by:**
- `walkNodes` (3)
- `walkNodes` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4137` | Self: 0.2% (5.9ms) | Total: 1.6% (42.2ms) | Samples: 4

**Called by:**
- `getAncestorsFor` (22)
- `_fireCfgEvents` (4)
- `walkNodes` (2)

**Calls:**
- `_nodeViewRaw` (21)
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6644` | Self: 0.2% (5.7ms) | Total: 0.2% (5.7ms) | Samples: 4

**Called by:**
- `walkNodes` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7281` | Self: 0.2% (5.6ms) | Total: 8.5% (223.2ms) | Samples: 4

**Called by:**
- `runPlugins` (146)

**Calls:**
- `invokeSelectorHandlers` (137)
- `invokeSelectorHandlers` (4)
- `invokeSelectorHandlers` (1)

### `getUselessReturns`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:147` | Self: 0.2% (5.5ms) | Total: 0.3% (10.0ms) | Samples: 4

**Called by:**
- `onCodePathSegmentStart` (7)

**Calls:**
- `getUselessReturns` (2)
- `getUselessReturns` (1)

### `invokeSelectorHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6207` | Self: 0.1% (4.9ms) | Total: 0.2% (6.6ms) | Samples: 3

**Called by:**
- `walkNodes` (4)

**Calls:**
- `nodeView` (1)

### `get`
`[native code]` | Self: 0.1% (4.8ms) | Total: 0.1% (4.8ms) | Samples: 3

**Called by:**
- `markReturnStatementsOnSegmentAsUsed` (1)
- `walkNodes` (1)
- `walkNodes` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6633` | Self: 0.1% (4.8ms) | Total: 0.7% (20.5ms) | Samples: 3

**Called by:**
- `walkNodes` (13)

**Calls:**
- `onCodePathStart` (8)
- `onCodePathStart` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7322` | Self: 0.1% (4.8ms) | Total: 0.2% (6.6ms) | Samples: 3

**Called by:**
- `runPlugins` (4)

**Calls:**
- `get` (1)

### `_resolveHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6944` | Self: 0.1% (4.8ms) | Total: 0.1% (4.8ms) | Samples: 3

**Called by:**
- `walkNodes` (3)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4700` | Self: 0.1% (4.7ms) | Total: 0.1% (4.7ms) | Samples: 3

**Called by:**
- `walkNodes` (3)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6517` | Self: 0.1% (4.7ms) | Total: 0.1% (4.7ms) | Samples: 3

**Called by:**
- `walkNodes` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7186` | Self: 0.1% (4.4ms) | Total: 0.2% (5.9ms) | Samples: 3

**Called by:**
- `runPlugins` (4)

**Calls:**
- `invokeMethodFnHandlers` (1)

### `_resolveHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (4.4ms) | Total: 0.1% (4.4ms) | Samples: 3

**Called by:**
- `walkNodes` (2)
- `walkNodes` (1)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6110` | Self: 0.1% (4.4ms) | Total: 0.3% (9.3ms) | Samples: 3

**Called by:**
- `_runSelectorList` (6)

**Calls:**
- `has` (2)
- `getUint32` (1)

### `initialSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4597` | Self: 0.1% (4.4ms) | Total: 0.1% (4.4ms) | Samples: 3

**Called by:**
- `_fireCfgEvents` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7244` | Self: 0.1% (4.4ms) | Total: 0.2% (5.6ms) | Samples: 3

**Called by:**
- `runPlugins` (4)

**Calls:**
- `getUint32` (1)

### `getUselessReturns`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:143` | Self: 0.1% (4.3ms) | Total: 0.1% (4.3ms) | Samples: 3

**Called by:**
- `getUselessReturns` (2)
- `onCodePathSegmentStart` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6628` | Self: 0.1% (3.4ms) | Total: 0.3% (7.9ms) | Samples: 2

**Called by:**
- `walkNodes` (3)
- `walkNodes` (2)

**Calls:**
- `initialSegment` (3)

### `markReturnStatementsOnSegmentAsUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:211` | Self: 0.1% (3.2ms) | Total: 2.9% (77.5ms) | Samples: 2

**Called by:**
- `forEach` (52)

**Calls:**
- `filter` (50)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7256` | Self: 0.1% (3.2ms) | Total: 0.1% (3.2ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` | Self: 0.1% (3.2ms) | Total: 0.1% (3.2ms) | Samples: 2

**Called by:**
- `_nodeViewRaw` (2)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4490` | Self: 0.1% (3.2ms) | Total: 0.1% (3.2ms) | Samples: 2

**Called by:**
- `get nextSegments` (2)

### `onCodePathStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:269` | Self: 0.1% (3.2ms) | Total: 0.1% (3.2ms) | Samples: 2

**Called by:**
- `_fireCfgEvents` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4108` | Self: 0.1% (3.2ms) | Total: 0.1% (3.2ms) | Samples: 2

**Called by:**
- `nodeView` (2)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6655` | Self: 0.1% (3.0ms) | Total: 0.7% (19.9ms) | Samples: 2

**Called by:**
- `walkNodes` (8)
- `walkNodes` (4)
- `walkNodes` (1)

**Calls:**
- `_dispatchSeg` (11)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4134` | Self: 0.1% (3.0ms) | Total: 0.1% (3.0ms) | Samples: 2

**Called by:**
- `walkNodes` (1)
- `_fireCfgEvents` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7040` | Self: 0.1% (3.0ms) | Total: 0.1% (3.0ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7247` | Self: 0.1% (3.0ms) | Total: 0.1% (4.3ms) | Samples: 2

**Called by:**
- `runPlugins` (3)

**Calls:**
- `nodeView` (1)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6115` | Self: 0.1% (2.9ms) | Total: 0.1% (2.9ms) | Samples: 2

**Called by:**
- `_runSelectorList` (2)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4389` | Self: 0.1% (2.9ms) | Total: 0.1% (2.9ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `some`
`[native code]` | Self: 0.1% (2.9ms) | Total: 0.1% (2.9ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6358` | Self: 0.1% (2.8ms) | Total: 0.1% (2.8ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `segment`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4398` | Self: 0.1% (2.7ms) | Total: 0.1% (4.3ms) | Samples: 2

**Called by:**
- `_fireCfgEvents` (3)

**Calls:**
- `CfgSegment` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7259` | Self: 0.1% (2.7ms) | Total: 0.1% (2.7ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `markReturnStatementsOnSegmentAsUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js` | Self: 0.1% (2.6ms) | Total: 0.1% (2.6ms) | Samples: 2

**Called by:**
- `forEach` (2)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6631` | Self: 0.0% (2.5ms) | Total: 0.0% (2.5ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `markReturnStatementsOnSegmentAsUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:188` | Self: 0.0% (2.4ms) | Total: 0.0% (2.4ms) | Samples: 2

**Called by:**
- `forEach` (2)

### `markReturnStatementsOnCurrentSegmentsAsUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:257` | Self: 0.0% (1.8ms) | Total: 9.2% (242.0ms) | Samples: 1

**Called by:**
- `_invokeFused` (133)
- `ReturnStatement` (27)

**Calls:**
- `forEach` (159)

### `get argument`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1889` | Self: 0.0% (1.8ms) | Total: 0.5% (14.6ms) | Samples: 1

**Called by:**
- `ReturnStatement` (5)
- `ReturnStatement` (4)

**Calls:**
- `getUint32` (4)
- `nodeLhs` (3)
- `lhs` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` | Self: 0.0% (1.7ms) | Total: 0.1% (5.0ms) | Samples: 1

**Called by:**
- `ReturnStatement` (1)
- `walkNodes` (1)
- `walkNodes` (1)

**Calls:**
- `_NodeView` (2)

### `isInFinally`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:49` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `ReturnStatement` (1)

### `invokeSelectorHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6181` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7265` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4498` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `get nextSegments` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `ke` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `async (anonymous)` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6353` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `TokenType`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:119` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `kw` (1)

### `_dispatchSeg`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6263` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_fireCfgEvents` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6654` | Self: 0.0% (1.6ms) | Total: 1.4% (37.9ms) | Samples: 1

**Called by:**
- `walkNodes` (12)
- `walkNodes` (9)
- `walkNodes` (3)
- `walkNodes` (1)

**Calls:**
- `_dispatchSeg` (22)
- `_dispatchSeg` (1)
- `segment` (1)

### `ReturnStatement`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:355` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_invokeFused` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6678` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4456` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `get nextSegments` (1)

### `_runSelectorList`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6152` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `invokeSelectorHandlers` (1)

### `get label`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3247` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:592` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `fix` (1)

### `CfgSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4516` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `segment` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7149` | Self: 0.0% (1.5ms) | Total: 0.1% (3.1ms) | Samples: 1

**Called by:**
- `runPlugins` (2)

**Calls:**
- `push` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6646` | Self: 0.0% (1.5ms) | Total: 0.6% (16.5ms) | Samples: 1

**Called by:**
- `walkNodes` (11)

**Calls:**
- `onCodePathEnd` (8)
- `onCodePathEnd` (2)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `segment`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4397` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_fireCfgEvents` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7195` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4468` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get nextSegments` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4286` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7220` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4116` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `nodeView` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7245` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4032` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4503` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get nextSegments` (1)

### `onUnreachableCodePathSegmentEnd`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:332` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_dispatchSeg` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7146` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_csrSegments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `get prevSegments` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7251` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_runSelectorList` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3876` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `report` (1)

### `_dispatchSeg`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6270` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_fireCfgEvents` (1)

### `remove`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:28` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `dlopen`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `dlopen` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1413` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_fireCfgEvents` (1)

### `_runSelectorList`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6135` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `invokeSelectorHandlers` (1)

### `segment`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_fireCfgEvents` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4442` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `get nextSegments` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7260` | Self: 0.0% (1.2ms) | Total: 0.1% (2.8ms) | Samples: 1

**Called by:**
- `runPlugins` (2)

**Calls:**
- `get` (1)

### `_getSelectorRootTypes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_getOrBuildSelectorPlan` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3630` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `get value` (1)

### `markReturnStatementsOnSegmentAsUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:205` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `forEach` (1)

**Calls:**
- `get` (1)

### `_getFfiSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:110` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_getOrBuildSelectorPlan` (1)

**Calls:**
- `isAvailable` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

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

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:17` | Self: 0.0% (0us) | Total: 0.1% (3.1ms) | Samples: 0

**Called by:**
- `parseModule` (2)

**Calls:**
- `bound require` (2)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:62` | Self: 0.0% (0us) | Total: 6.1% (162.4ms) | Samples: 0

**Called by:**
- `async (anonymous)` (106)

**Calls:**
- `runPlugins` (103)
- `runPlugins` (3)

### `ke`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `we` (1)

**Calls:**
- `(anonymous)` (1)

### `kw`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:143` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `TokenType` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6884` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `some` (2)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:435` | Self: 0.0% (0us) | Total: 0.2% (7.7ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `bound require` (5)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:478` | Self: 0.0% (0us) | Total: 0.1% (4.4ms) | Samples: 0

**Called by:**
- `parseSource` (2)

**Calls:**
- `CfgGraph` (1)
- `CfgGraph` (1)

### `isAvailable`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:399` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_getFfiSelector` (1)

**Calls:**
- `_tryLoad` (1)

### `fix`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:288` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_execReport` (1)

**Calls:**
- `commentsInRange` (1)

### `ReturnStatement`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:347` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_invokeFused` (1)

**Calls:**
- `isInFinally` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4398` | Self: 0.0% (0us) | Total: 0.1% (3.3ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `g` (1)
- `esquery` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:477` | Self: 0.0% (0us) | Total: 0.2% (7.7ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `patchAstUtils` (5)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6450` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `_getOrBuildSelectorPlan` (1)
- `_getOrBuildSelectorPlan` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7559` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `reset` (1)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5419` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_getSelectorRootTypes` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:53` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `loadCoreRules` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7350` | Self: 0.0% (0us) | Total: 0.1% (4.4ms) | Samples: 0

**Called by:**
- `runPlugins` (3)

**Calls:**
- `invokeMethodFnHandlers` (2)
- `invokeMethodFnHandlers` (1)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 100.0% (2.62s) | Samples: 0

**Calls:**
- `parseModule` (1733)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.1% (3.1ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `onCodePathEnd`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:281` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `_fireCfgEvents` (2)

**Calls:**
- `report` (2)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 1.3% (35.2ms) | Samples: 0

**Called by:**
- `bound require` (23)

**Calls:**
- `anonymous` (23)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:59` | Self: 0.0% (0us) | Total: 3.0% (80.6ms) | Samples: 0

**Called by:**
- `async (anonymous)` (52)

**Calls:**
- `parseSource` (50)
- `parseSource` (2)

### `_e`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `Ae` (1)

**Calls:**
- `Pe` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6656` | Self: 0.0% (0us) | Total: 0.2% (5.4ms) | Samples: 0

**Called by:**
- `walkNodes` (4)

**Calls:**
- `_dispatchSeg` (3)
- `segment` (1)

### `lhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1863` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `get argument` (1)

**Calls:**
- `nodeLhs` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.1% (3.1ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:239` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `filter` (1)

**Calls:**
- `remove` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:45` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `bound require` (1)

### `we`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `Pe` (1)

**Calls:**
- `ke` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:39` | Self: 0.0% (0us) | Total: 99.8% (2.61s) | Samples: 0

**Called by:**
- `(anonymous)` (1731)

**Calls:**
- `async (anonymous)` (1563)
- `async (anonymous)` (106)
- `async (anonymous)` (52)
- `async (anonymous)` (7)
- `async (anonymous)` (1)
- `async (anonymous)` (1)
- `async (anonymous)` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` | Self: 0.0% (0us) | Total: 0.1% (4.4ms) | Samples: 0

**Called by:**
- `async (anonymous)` (2)

**Calls:**
- `AstView` (2)

### `_tryLoad`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:51` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `isAvailable` (1)

**Calls:**
- `dlopen` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3916` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `report` (1)

**Calls:**
- `fix` (1)

### `ReturnStatement`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:342` | Self: 0.0% (0us) | Total: 1.5% (40.7ms) | Samples: 0

**Called by:**
- `_invokeFused` (27)

**Calls:**
- `markReturnStatementsOnCurrentSegmentsAsUsed` (27)

### `g`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (1)

**Calls:**
- `parse` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:81` | Self: 0.0% (0us) | Total: 99.8% (2.61s) | Samples: 0

**Called by:**
- `parseModule` (1731)

**Calls:**
- `async (anonymous)` (1731)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:20` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7566` | Self: 0.0% (0us) | Total: 0.2% (6.5ms) | Samples: 0

**Called by:**
- `async (anonymous)` (3)
- `async (anonymous)` (1)

**Calls:**
- `buildVisitorMap` (2)
- `buildVisitorMap` (1)
- `buildVisitorMap` (1)

### `Pe`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_e` (1)

**Calls:**
- `we` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` | Self: 0.0% (0us) | Total: 2.9% (76.1ms) | Samples: 0

**Called by:**
- `async (anonymous)` (50)

**Calls:**
- `parse` (50)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 1.4% (38.3ms) | Samples: 0

**Called by:**
- `async (anonymous)` (7)
- `patchAstUtils` (5)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `loadCoreRules` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `async (anonymous)` (1)
- `esquery` (1)

**Calls:**
- `require` (23)
- `anonymous` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7131` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7194` | Self: 0.0% (0us) | Total: 0.1% (3.1ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `getUint32` (2)

### `markReturnStatementsOnSegmentAsUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:192` | Self: 0.0% (0us) | Total: 0.9% (24.0ms) | Samples: 0

**Called by:**
- `forEach` (16)

**Calls:**
- `filter` (16)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1515` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_fireCfgEvents` (1)

**Calls:**
- `get range` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6352` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_nodeViewRaw` (1)

### `invokeSelectorHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6243` | Self: 0.0% (0us) | Total: 7.9% (209.1ms) | Samples: 0

**Called by:**
- `walkNodes` (137)

**Calls:**
- `_runSelectorList` (135)
- `_runSelectorList` (1)
- `_runSelectorList` (1)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `Ae`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `parse` (1)

**Calls:**
- `_e` (1)

### `_runSelectorList`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6151` | Self: 0.0% (0us) | Total: 7.8% (206.2ms) | Samples: 0

**Called by:**
- `invokeSelectorHandlers` (135)

**Calls:**
- `getAncestorsFor` (102)
- `getAncestorsFor` (12)
- `getAncestorsFor` (7)
- `getAncestorsFor` (6)
- `getAncestorsFor` (5)
- `getAncestorsFor` (2)
- `getAncestorsFor` (1)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5490` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_getFfiSelector` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:221` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `kw` (1)

### `dlopen`
`bun:ffi:345` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_tryLoad` (1)

**Calls:**
- `dlopen` (1)

### `esquery`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:53` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7132` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `get label` (1)

### `markReturnStatementsOnSegmentAsUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:191` | Self: 0.0% (0us) | Total: 0.4% (11.9ms) | Samples: 0

**Called by:**
- `forEach` (8)

**Calls:**
- `filter` (8)

### `ReturnStatement`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:345` | Self: 0.0% (0us) | Total: 0.5% (14.4ms) | Samples: 0

**Called by:**
- `_invokeFused` (9)

**Calls:**
- `get argument` (5)
- `get argument` (4)

### `parseModule`
`[native code]` | Self: 0.0% (0us) | Total: 100.0% (2.62s) | Samples: 0

**Called by:**
- `async (anonymous)` (1733)

**Calls:**
- `(anonymous)` (1731)
- `(anonymous)` (2)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6630` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `walkNodes` (2)

**Calls:**
- `get value` (1)
- `get value` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:46` | Self: 0.0% (0us) | Total: 0.4% (10.5ms) | Samples: 0

**Called by:**
- `async (anonymous)` (7)

**Calls:**
- `bound require` (7)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6662` | Self: 0.0% (0us) | Total: 0.4% (10.7ms) | Samples: 0

**Called by:**
- `walkNodes` (7)

**Calls:**
- `get nextSegments` (7)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:54` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `bound require` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7567` | Self: 0.0% (0us) | Total: 95.9% (2.51s) | Samples: 0

**Called by:**
- `async (anonymous)` (1561)
- `async (anonymous)` (103)

**Calls:**
- `walkNodes` (391)
- `walkNodes` (249)
- `walkNodes` (168)
- `walkNodes` (167)
- `walkNodes` (146)
- `walkNodes` (141)
- `walkNodes` (70)
- `walkNodes` (51)
- `walkNodes` (46)
- `walkNodes` (45)
- `walkNodes` (43)
- `walkNodes` (28)
- `walkNodes` (17)
- `walkNodes` (17)
- `walkNodes` (12)
- `walkNodes` (11)
- `walkNodes` (11)
- `walkNodes` (8)
- `walkNodes` (4)
- `walkNodes` (4)
- `walkNodes` (4)
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
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)

### `parse`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `g` (1)

**Calls:**
- `Ae` (1)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:66` | Self: 0.0% (0us) | Total: 90.0% (2.36s) | Samples: 0

**Called by:**
- `async (anonymous)` (1563)

**Calls:**
- `runPlugins` (1561)
- `runPlugins` (1)
- `runPlugins` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3946` | Self: 0.0% (0us) | Total: 0.1% (2.9ms) | Samples: 0

**Called by:**
- `onCodePathEnd` (2)

**Calls:**
- `_execReport` (1)
- `_execReport` (1)

### `get prevSegments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4548` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_fireCfgEvents` (1)

**Calls:**
- `_csrSegments` (1)

### `getUselessReturns`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:149` | Self: 0.0% (0us) | Total: 0.5% (14.5ms) | Samples: 0

**Called by:**
- `onCodePathSegmentStart` (10)

**Calls:**
- `filter` (10)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7043` | Self: 0.0% (0us) | Total: 0.6% (17.9ms) | Samples: 0

**Called by:**
- `runPlugins` (12)

**Calls:**
- `getDFSEvents` (9)
- `getDFSEvents` (3)

### `get nextSegments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4542` | Self: 0.0% (0us) | Total: 0.4% (10.7ms) | Samples: 0

**Called by:**
- `_fireCfgEvents` (7)

**Calls:**
- `_ensureNextAdjacency` (2)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6660` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `get prevSegments` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 50.8% | 1.33s | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 24.4% | 642.1ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js` |
| 16.2% | 425.2ms | `[native code]` |
| 8.2% | 217.0ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.7ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js` |
| 0.0% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js` |
