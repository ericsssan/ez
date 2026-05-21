# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 8.90s | 5857 | 1.0ms | 318 |

**Top 10:** `parse` 23.5%, `walkNodes` 6.0%, `_fireCfgEvents` 4.0%, `CfgSegment` 3.9%, `_nodeViewRaw` 3.8%, `walkNodes` 2.7%, `filter` 2.2%, `onCodePathSegmentStart` 2.0%, `onCodePathSegmentStart` 2.0%, `walkNodes` 1.8%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 23.5% | 2.09s | 23.5% | 2.09s | `parse` | `[native code]` |
| 6.0% | 543.0ms | 6.8% | 608.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6867` |
| 4.0% | 361.0ms | 4.0% | 362.7ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6471` |
| 3.9% | 352.8ms | 3.9% | 352.8ms | `CfgSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4374` |
| 3.8% | 340.2ms | 3.8% | 340.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3994` |
| 2.7% | 242.0ms | 3.0% | 272.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6451` |
| 2.2% | 196.6ms | 2.2% | 199.9ms | `filter` | `[native code]` |
| 2.0% | 182.0ms | 2.0% | 182.0ms | `onCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:324` |
| 2.0% | 181.1ms | 2.0% | 181.1ms | `onCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:313` |
| 1.8% | 165.3ms | 1.8% | 165.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7086` |
| 1.7% | 152.8ms | 1.7% | 152.8ms | `has` | `[native code]` |
| 1.6% | 150.1ms | 1.6% | 150.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6627` |
| 1.6% | 147.5ms | 1.6% | 147.5ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 1.5% | 134.0ms | 4.0% | 360.8ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6473` |
| 1.5% | 133.6ms | 2.0% | 181.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6874` |
| 1.4% | 125.6ms | 1.8% | 162.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7036` |
| 1.3% | 116.3ms | 1.3% | 116.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6619` |
| 1.2% | 112.9ms | 3.1% | 279.1ms | `forEach` | `[native code]` |
| 1.2% | 108.4ms | 1.2% | 108.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6623` |
| 1.1% | 102.6ms | 1.1% | 103.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6951` |
| 1.1% | 102.3ms | 1.1% | 102.3ms | `CfgSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4381` |
| 1.1% | 98.8ms | 13.2% | 1.18s | `_dispatchSeg` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6110` |
| 0.9% | 88.9ms | 0.9% | 88.9ms | `_csrSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4267` |
| 0.9% | 86.5ms | 0.9% | 86.5ms | `push` | `[native code]` |
| 0.9% | 84.4ms | 1.8% | 166.3ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:157` |
| 0.9% | 83.0ms | 0.9% | 83.0ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.9% | 80.9ms | 0.9% | 85.6ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5946` |
| 0.8% | 75.0ms | 2.2% | 196.5ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5949` |
| 0.8% | 75.0ms | 0.8% | 75.0ms | `WeakSet` | `[native code]` |
| 0.6% | 59.2ms | 0.8% | 73.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6452` |
| 0.6% | 59.1ms | 0.6% | 59.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3986` |
| 0.6% | 55.3ms | 1.4% | 130.4ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:141` |
| 0.5% | 53.2ms | 0.5% | 53.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6866` |
| 0.5% | 51.9ms | 0.5% | 51.9ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4793` |
| 0.5% | 50.1ms | 3.6% | 327.7ms | `markReturnStatementsOnCurrentSegmentsAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:257` |
| 0.5% | 48.2ms | 0.5% | 48.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3991` |
| 0.5% | 47.8ms | 1.2% | 110.6ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5953` |
| 0.5% | 47.3ms | 0.5% | 47.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6868` |
| 0.5% | 46.5ms | 0.5% | 46.5ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4037` |
| 0.5% | 45.6ms | 0.5% | 45.6ms | `CfgSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4371` |
| 0.5% | 45.4ms | 0.5% | 45.4ms | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:189` |
| 0.4% | 44.0ms | 0.4% | 44.0ms | `defineProperty` | `[native code]` |
| 0.4% | 43.7ms | 0.4% | 43.7ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4331` |
| 0.4% | 41.8ms | 0.4% | 41.8ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:158` |
| 0.4% | 40.3ms | 6.0% | 542.5ms | `segment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4253` |
| 0.4% | 39.9ms | 0.9% | 81.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6948` |
| 0.4% | 39.7ms | 0.4% | 39.7ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5936` |
| 0.4% | 38.9ms | 0.4% | 38.9ms | `_csrSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4271` |
| 0.3% | 35.3ms | 0.3% | 35.3ms | `create` | `[native code]` |
| 0.3% | 33.0ms | 0.3% | 33.0ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:146` |
| 0.3% | 32.6ms | 0.3% | 32.6ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4291` |
| 0.3% | 29.9ms | 4.9% | 437.2ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4556` |
| 0.3% | 28.8ms | 0.3% | 28.8ms | `onCodePathSegmentEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:336` |
| 0.3% | 28.2ms | 0.3% | 28.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3995` |
| 0.3% | 27.7ms | 0.3% | 27.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4005` |
| 0.3% | 27.4ms | 8.4% | 753.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6897` |
| 0.2% | 26.4ms | 0.2% | 26.4ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6358` |
| 0.2% | 26.3ms | 3.2% | 285.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6907` |
| 0.2% | 24.1ms | 0.2% | 24.1ms | `next` | `[native code]` |
| 0.2% | 23.4ms | 0.2% | 23.4ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4428` |
| 0.2% | 23.3ms | 0.2% | 23.3ms | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:188` |
| 0.2% | 23.1ms | 0.2% | 23.1ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5933` |
| 0.2% | 22.7ms | 0.2% | 22.7ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5958` |
| 0.2% | 22.2ms | 0.2% | 22.2ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4032` |
| 0.2% | 22.0ms | 0.2% | 22.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4001` |
| 0.2% | 22.0ms | 0.2% | 22.0ms | `onUnreachableCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:328` |
| 0.2% | 21.4ms | 0.2% | 21.4ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4363` |
| 0.2% | 21.3ms | 0.2% | 21.3ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 21.2ms | 0.2% | 21.2ms | `decode` | `[native code]` |
| 0.2% | 21.1ms | 0.2% | 21.1ms | `DataView` | `[native code]` |
| 0.2% | 20.9ms | 6.0% | 541.0ms | `onCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:316` |
| 0.2% | 20.6ms | 16.9% | 1.51s | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6506` |
| 0.2% | 20.3ms | 7.0% | 627.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6903` |
| 0.2% | 19.7ms | 0.2% | 21.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6968` |
| 0.2% | 19.7ms | 4.0% | 357.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7169` |
| 0.2% | 18.0ms | 0.2% | 18.0ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:143` |
| 0.1% | 17.7ms | 0.3% | 27.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7070` |
| 0.1% | 16.7ms | 0.1% | 16.7ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5956` |
| 0.1% | 16.5ms | 0.5% | 51.0ms | `anonymous` | `[native code]` |
| 0.1% | 15.8ms | 1.4% | 125.8ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6508` |
| 0.1% | 15.2ms | 0.1% | 15.2ms | `get` | `[native code]` |
| 0.1% | 14.8ms | 0.4% | 42.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7072` |
| 0.1% | 14.2ms | 0.1% | 14.2ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5960` |
| 0.1% | 14.1ms | 18.2% | 1.62s | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7096` |
| 0.1% | 13.7ms | 0.1% | 13.7ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 12.2ms | 0.1% | 12.2ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 11.9ms | 0.3% | 33.2ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6499` |
| 0.1% | 11.9ms | 0.1% | 11.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7037` |
| 0.1% | 11.6ms | 0.3% | 34.2ms | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6050` |
| 0.1% | 11.1ms | 0.3% | 30.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7074` |
| 0.1% | 11.0ms | 0.1% | 11.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6447` |
| 0.1% | 10.2ms | 0.1% | 11.8ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6497` |
| 0.1% | 10.0ms | 0.1% | 10.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6848` |
| 0.1% | 8.9ms | 0.1% | 8.9ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6484` |
| 0.0% | 8.3ms | 0.1% | 13.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6901` |
| 0.0% | 8.3ms | 0.0% | 8.3ms | `onUnreachableCodePathSegmentEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:332` |
| 0.0% | 8.2ms | 0.0% | 8.2ms | `onCodePathEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:280` |
| 0.0% | 8.1ms | 0.0% | 8.1ms | `set` | `[native code]` |
| 0.0% | 8.0ms | 0.0% | 8.0ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:156` |
| 0.0% | 7.9ms | 0.0% | 7.9ms | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js` |
| 0.0% | 7.8ms | 0.0% | 7.8ms | `onCodePathStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:270` |
| 0.0% | 7.6ms | 0.0% | 7.6ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4431` |
| 0.0% | 7.5ms | 0.0% | 7.5ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3620` |
| 0.0% | 6.9ms | 0.0% | 6.9ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4322` |
| 0.0% | 6.6ms | 0.0% | 6.6ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:528` |
| 0.0% | 6.2ms | 0.1% | 14.0ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6486` |
| 0.0% | 6.1ms | 0.3% | 29.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7139` |
| 0.0% | 6.1ms | 0.1% | 12.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6460` |
| 0.0% | 6.0ms | 0.0% | 6.0ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1019` |
| 0.0% | 5.9ms | 0.0% | 5.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7062` |
| 0.0% | 5.9ms | 0.0% | 5.9ms | `encodeInto` | `[native code]` |
| 0.0% | 5.9ms | 0.0% | 5.9ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4358` |
| 0.0% | 5.9ms | 0.0% | 5.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6620` |
| 0.0% | 5.9ms | 0.0% | 5.9ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6480` |
| 0.0% | 5.8ms | 0.1% | 14.3ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:147` |
| 0.0% | 5.8ms | 0.0% | 5.8ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6495` |
| 0.0% | 5.7ms | 0.2% | 18.1ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5064` |
| 0.0% | 5.4ms | 0.1% | 15.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6461` |
| 0.0% | 5.1ms | 0.0% | 5.1ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4345` |
| 0.0% | 4.9ms | 0.0% | 4.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1285` |
| 0.0% | 4.8ms | 0.4% | 40.1ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6478` |
| 0.0% | 4.4ms | 0.0% | 4.4ms | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1857` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7075` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5947` |
| 0.0% | 4.2ms | 0.0% | 4.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7140` |
| 0.0% | 4.2ms | 0.0% | 4.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7068` |
| 0.0% | 4.1ms | 0.1% | 11.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6462` |
| 0.0% | 4.0ms | 0.0% | 4.0ms | `_dispatchSeg` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6106` |
| 0.0% | 4.0ms | 0.1% | 10.0ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6482` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4304` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4333` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `_extendRangeToIncludeSemicolon` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:82` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1829` |
| 0.0% | 3.2ms | 0.2% | 24.9ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6509` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1011` |
| 0.0% | 3.2ms | 0.7% | 62.8ms | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:341` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `allNextSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4398` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `Object` | `[native code]` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:152` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3594` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3719` |
| 0.0% | 3.0ms | 0.0% | 5.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7078` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7014` |
| 0.0% | 2.9ms | 0.8% | 72.9ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6507` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4033` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7063` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1429` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4244` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4306` |
| 0.0% | 2.6ms | 0.3% | 35.3ms | `codepath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4259` |
| 0.0% | 2.6ms | 1.2% | 114.9ms | `nextSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4387` |
| 0.0% | 2.4ms | 0.0% | 2.4ms | `dlopen` | `[native code]` |
| 0.0% | 2.4ms | 5.8% | 517.6ms | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5994` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `existsSync` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 3.2ms | `some` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:551` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4311` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4543` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1829` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4290` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3550` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:555` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6785` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4150` |
| 0.0% | 1.6ms | 0.1% | 10.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7064` |
| 0.0% | 1.5ms | 0.0% | 3.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7013` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6517` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get prevSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4393` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6469` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4300` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3771` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_fromRunnerReport` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6448` |
| 0.0% | 1.5ms | 0.0% | 4.7ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6516` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_rawTokenText` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:794` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4426` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4327` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7077` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6360` |
| 0.0% | 1.4ms | 0.0% | 3.1ms | `isInFinally` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:49` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1380` |
| 0.0% | 1.3ms | 0.1% | 10.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7065` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6445` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get label` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3220` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4336` |
| 0.0% | 1.3ms | 6.0% | 539.8ms | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6086` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 6.4% | 573.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7099` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `async lintSource` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:461` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.2% | 19.5ms | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5995` |
| 0.0% | 1.3ms | 0.4% | 36.0ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6481` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `CfgSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4375` |
| 0.0% | 1.3ms | 0.0% | 7.3ms | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:345` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6514` |
| 0.0% | 1.2ms | 0.0% | 8.6ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6483` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5978` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getUint32` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3631` |
| 0.0% | 1.2ms | 0.0% | 2.4ms | `readFileSync` | `[native code]` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 75.8% | 6.75s | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:304` |
| 75.5% | 6.73s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7385` |
| 23.8% | 2.12s | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:300` |
| 23.5% | 2.09s | 23.5% | 2.09s | `parse` | `[native code]` |
| 23.5% | 2.09s | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` |
| 18.2% | 1.62s | 0.1% | 14.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7096` |
| 16.9% | 1.51s | 0.2% | 20.6ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6506` |
| 13.2% | 1.18s | 1.1% | 98.8ms | `_dispatchSeg` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6110` |
| 8.4% | 753.9ms | 0.3% | 27.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6897` |
| 7.0% | 627.2ms | 0.2% | 20.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6903` |
| 6.8% | 608.7ms | 6.0% | 543.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6867` |
| 6.4% | 573.7ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7099` |
| 6.0% | 542.5ms | 0.4% | 40.3ms | `segment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4253` |
| 6.0% | 541.0ms | 0.2% | 20.9ms | `onCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:316` |
| 6.0% | 539.8ms | 0.0% | 1.3ms | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6086` |
| 5.8% | 517.6ms | 0.0% | 2.4ms | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5994` |
| 4.9% | 437.2ms | 0.3% | 29.9ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4556` |
| 4.0% | 362.7ms | 4.0% | 361.0ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6471` |
| 4.0% | 360.8ms | 1.5% | 134.0ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6473` |
| 4.0% | 357.3ms | 0.2% | 19.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7169` |
| 3.9% | 352.8ms | 3.9% | 352.8ms | `CfgSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4374` |
| 3.8% | 340.2ms | 3.8% | 340.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3994` |
| 3.6% | 327.7ms | 0.5% | 50.1ms | `markReturnStatementsOnCurrentSegmentsAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:257` |
| 3.2% | 285.0ms | 0.2% | 26.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6907` |
| 3.1% | 279.1ms | 1.2% | 112.9ms | `forEach` | `[native code]` |
| 3.0% | 272.5ms | 2.7% | 242.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6451` |
| 2.2% | 199.9ms | 2.2% | 196.6ms | `filter` | `[native code]` |
| 2.2% | 196.5ms | 0.8% | 75.0ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5949` |
| 2.0% | 182.0ms | 2.0% | 182.0ms | `onCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:324` |
| 2.0% | 181.2ms | 1.5% | 133.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6874` |
| 2.0% | 181.1ms | 2.0% | 181.1ms | `onCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:313` |
| 1.8% | 166.3ms | 0.9% | 84.4ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:157` |
| 1.8% | 165.3ms | 1.8% | 165.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7086` |
| 1.8% | 162.7ms | 1.4% | 125.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7036` |
| 1.7% | 152.8ms | 1.7% | 152.8ms | `has` | `[native code]` |
| 1.6% | 150.1ms | 1.6% | 150.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6627` |
| 1.6% | 147.5ms | 1.6% | 147.5ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 1.5% | 139.1ms | 0.0% | 0us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6515` |
| 1.4% | 130.4ms | 0.6% | 55.3ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:141` |
| 1.4% | 125.8ms | 0.1% | 15.8ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6508` |
| 1.3% | 122.1ms | 0.0% | 0us | `onCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:318` |
| 1.3% | 120.7ms | 0.0% | 0us | `allPrevSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4410` |
| 1.3% | 116.4ms | 0.0% | 0us | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:149` |
| 1.3% | 116.3ms | 1.3% | 116.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6619` |
| 1.2% | 114.9ms | 0.0% | 2.6ms | `nextSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4387` |
| 1.2% | 110.6ms | 0.5% | 47.8ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5953` |
| 1.2% | 108.4ms | 1.2% | 108.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6623` |
| 1.1% | 103.9ms | 1.1% | 102.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6951` |
| 1.1% | 102.3ms | 1.1% | 102.3ms | `CfgSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4381` |
| 0.9% | 88.9ms | 0.9% | 88.9ms | `_csrSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4267` |
| 0.9% | 86.5ms | 0.9% | 86.5ms | `push` | `[native code]` |
| 0.9% | 85.6ms | 0.9% | 80.9ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5946` |
| 0.9% | 83.0ms | 0.9% | 83.0ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.9% | 81.0ms | 0.4% | 39.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6948` |
| 0.8% | 75.0ms | 0.8% | 75.0ms | `WeakSet` | `[native code]` |
| 0.8% | 73.0ms | 0.6% | 59.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6452` |
| 0.8% | 72.9ms | 0.0% | 2.9ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6507` |
| 0.7% | 64.0ms | 0.0% | 0us | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:211` |
| 0.7% | 62.8ms | 0.0% | 3.2ms | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:341` |
| 0.6% | 61.0ms | 0.0% | 0us | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:342` |
| 0.6% | 59.1ms | 0.6% | 59.1ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3986` |
| 0.5% | 53.2ms | 0.5% | 53.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6866` |
| 0.5% | 51.9ms | 0.5% | 51.9ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4793` |
| 0.5% | 51.0ms | 0.1% | 16.5ms | `anonymous` | `[native code]` |
| 0.5% | 48.2ms | 0.5% | 48.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3991` |
| 0.5% | 47.3ms | 0.5% | 47.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6868` |
| 0.5% | 46.5ms | 0.5% | 46.5ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4037` |
| 0.5% | 45.6ms | 0.5% | 45.6ms | `CfgSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4371` |
| 0.5% | 45.4ms | 0.5% | 45.4ms | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:189` |
| 0.5% | 45.1ms | 0.0% | 0us | `bound require` | `[native code]` |
| 0.4% | 44.0ms | 0.4% | 44.0ms | `defineProperty` | `[native code]` |
| 0.4% | 43.7ms | 0.4% | 43.7ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4331` |
| 0.4% | 42.3ms | 0.1% | 14.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7072` |
| 0.4% | 41.8ms | 0.4% | 41.8ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:158` |
| 0.4% | 40.1ms | 0.0% | 4.8ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6478` |
| 0.4% | 39.8ms | 0.0% | 0us | `require` | `[native code]` |
| 0.4% | 39.7ms | 0.4% | 39.7ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5936` |
| 0.4% | 38.9ms | 0.4% | 38.9ms | `_csrSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4271` |
| 0.4% | 36.0ms | 0.0% | 1.3ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6481` |
| 0.3% | 35.3ms | 0.3% | 35.3ms | `create` | `[native code]` |
| 0.3% | 35.3ms | 0.0% | 2.6ms | `codepath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4259` |
| 0.3% | 34.6ms | 0.0% | 0us | `initialSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4442` |
| 0.3% | 34.2ms | 0.1% | 11.6ms | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6050` |
| 0.3% | 33.2ms | 0.1% | 11.9ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6499` |
| 0.3% | 33.0ms | 0.3% | 33.0ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:146` |
| 0.3% | 32.6ms | 0.3% | 32.6ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4291` |
| 0.3% | 30.8ms | 0.1% | 11.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7074` |
| 0.3% | 29.6ms | 0.0% | 6.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7139` |
| 0.3% | 28.8ms | 0.3% | 28.8ms | `onCodePathSegmentEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:336` |
| 0.3% | 28.2ms | 0.3% | 28.2ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3995` |
| 0.3% | 27.8ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6865` |
| 0.3% | 27.7ms | 0.3% | 27.7ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4005` |
| 0.3% | 27.3ms | 0.1% | 17.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7070` |
| 0.2% | 26.4ms | 0.2% | 26.4ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6358` |
| 0.2% | 25.8ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7069` |
| 0.2% | 25.2ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` |
| 0.2% | 24.9ms | 0.0% | 3.2ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6509` |
| 0.2% | 24.1ms | 0.2% | 24.1ms | `next` | `[native code]` |
| 0.2% | 23.4ms | 0.2% | 23.4ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4428` |
| 0.2% | 23.3ms | 0.2% | 23.3ms | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:188` |
| 0.2% | 23.1ms | 0.2% | 23.1ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5933` |
| 0.2% | 22.7ms | 0.2% | 22.7ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5958` |
| 0.2% | 22.2ms | 0.2% | 22.2ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4032` |
| 0.2% | 22.0ms | 0.2% | 22.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4001` |
| 0.2% | 22.0ms | 0.2% | 22.0ms | `onUnreachableCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:328` |
| 0.2% | 21.4ms | 0.2% | 21.4ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4363` |
| 0.2% | 21.4ms | 0.2% | 19.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6968` |
| 0.2% | 21.3ms | 0.2% | 21.3ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.2% | 21.2ms | 0.0% | 0us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:511` |
| 0.2% | 21.2ms | 0.2% | 21.2ms | `decode` | `[native code]` |
| 0.2% | 21.2ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7377` |
| 0.2% | 21.1ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:276` |
| 0.2% | 21.1ms | 0.2% | 21.1ms | `DataView` | `[native code]` |
| 0.2% | 21.0ms | 0.0% | 0us | `get nextSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4387` |
| 0.2% | 19.5ms | 0.0% | 1.3ms | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5995` |
| 0.2% | 18.1ms | 0.0% | 5.7ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5064` |
| 0.2% | 18.1ms | 0.0% | 0us | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5102` |
| 0.2% | 18.0ms | 0.2% | 18.0ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:143` |
| 0.1% | 16.7ms | 0.1% | 16.7ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5956` |
| 0.1% | 15.5ms | 0.0% | 5.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6461` |
| 0.1% | 15.2ms | 0.1% | 15.2ms | `get` | `[native code]` |
| 0.1% | 14.3ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7005` |
| 0.1% | 14.3ms | 0.0% | 5.8ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:147` |
| 0.1% | 14.2ms | 0.1% | 14.2ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5960` |
| 0.1% | 14.0ms | 0.0% | 6.2ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6486` |
| 0.1% | 13.7ms | 0.1% | 13.7ms | `get allSkipped` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 13.3ms | 0.0% | 8.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6901` |
| 0.1% | 13.2ms | 0.0% | 0us | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:191` |
| 0.1% | 12.9ms | 0.0% | 0us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6196` |
| 0.1% | 12.5ms | 0.0% | 6.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6460` |
| 0.1% | 12.2ms | 0.1% | 12.2ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 11.9ms | 0.1% | 11.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7037` |
| 0.1% | 11.8ms | 0.1% | 10.2ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6497` |
| 0.1% | 11.7ms | 0.0% | 4.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6462` |
| 0.1% | 11.0ms | 0.1% | 11.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6447` |
| 0.1% | 10.9ms | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 0.1% | 10.9ms | 0.0% | 0us | `parseModule` | `[native code]` |
| 0.1% | 10.7ms | 0.0% | 1.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7064` |
| 0.1% | 10.6ms | 0.0% | 0us | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:192` |
| 0.1% | 10.6ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7065` |
| 0.1% | 10.0ms | 0.1% | 10.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6848` |
| 0.1% | 10.0ms | 0.0% | 4.0ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6482` |
| 0.1% | 9.7ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3789` |
| 0.1% | 9.7ms | 0.0% | 0us | `onCodePathEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:281` |
| 0.1% | 8.9ms | 0.1% | 8.9ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6484` |
| 0.0% | 8.7ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1483` |
| 0.0% | 8.6ms | 0.0% | 1.2ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6483` |
| 0.0% | 8.3ms | 0.0% | 8.3ms | `onUnreachableCodePathSegmentEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:332` |
| 0.0% | 8.2ms | 0.0% | 8.2ms | `onCodePathEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:280` |
| 0.0% | 8.1ms | 0.0% | 8.1ms | `set` | `[native code]` |
| 0.0% | 8.0ms | 0.0% | 8.0ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:156` |
| 0.0% | 7.9ms | 0.0% | 7.9ms | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js` |
| 0.0% | 7.8ms | 0.0% | 7.8ms | `onCodePathStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:270` |
| 0.0% | 7.6ms | 0.0% | 7.6ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4431` |
| 0.0% | 7.5ms | 0.0% | 7.5ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3620` |
| 0.0% | 7.3ms | 0.0% | 0us | `(anonymous)` | `/private/tmp/prof.js:3` |
| 0.0% | 7.3ms | 0.0% | 1.3ms | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:345` |
| 0.0% | 7.2ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:54` |
| 0.0% | 7.2ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:144` |
| 0.0% | 6.9ms | 0.0% | 6.9ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4322` |
| 0.0% | 6.6ms | 0.0% | 6.6ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:528` |
| 0.0% | 6.3ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7384` |
| 0.0% | 6.2ms | 0.0% | 0us | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:347` |
| 0.0% | 6.0ms | 0.0% | 6.0ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1019` |
| 0.0% | 5.9ms | 0.0% | 5.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7062` |
| 0.0% | 5.9ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:215` |
| 0.0% | 5.9ms | 0.0% | 5.9ms | `encodeInto` | `[native code]` |
| 0.0% | 5.9ms | 0.0% | 0us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:92` |
| 0.0% | 5.9ms | 0.0% | 5.9ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4358` |
| 0.0% | 5.9ms | 0.0% | 5.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6620` |
| 0.0% | 5.9ms | 0.0% | 5.9ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6480` |
| 0.0% | 5.8ms | 0.0% | 5.8ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6495` |
| 0.0% | 5.6ms | 0.0% | 3.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7078` |
| 0.0% | 5.2ms | 0.0% | 0us | `fix` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:288` |
| 0.0% | 5.2ms | 0.0% | 0us | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3759` |
| 0.0% | 5.1ms | 0.0% | 5.1ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4345` |
| 0.0% | 5.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:11` |
| 0.0% | 4.9ms | 0.0% | 4.9ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1285` |
| 0.0% | 4.7ms | 0.0% | 1.5ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6516` |
| 0.0% | 4.4ms | 0.0% | 4.4ms | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1857` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7075` |
| 0.0% | 4.3ms | 0.0% | 4.3ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5947` |
| 0.0% | 4.2ms | 0.0% | 4.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7140` |
| 0.0% | 4.2ms | 0.0% | 0us | `get allPrevSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4410` |
| 0.0% | 4.2ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1478` |
| 0.0% | 4.2ms | 0.0% | 0us | `_nodesFromRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:868` |
| 0.0% | 4.2ms | 0.0% | 4.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7068` |
| 0.0% | 4.0ms | 0.0% | 4.0ms | `_dispatchSeg` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6106` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4304` |
| 0.0% | 3.3ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.0% | 3.3ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7013` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4333` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `_extendRangeToIncludeSemicolon` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:82` |
| 0.0% | 3.2ms | 0.0% | 0us | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3611` |
| 0.0% | 3.2ms | 0.0% | 0us | `onCodePathEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:283` |
| 0.0% | 3.2ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7060` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1829` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `get type` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1011` |
| 0.0% | 3.2ms | 0.0% | 1.7ms | `some` | `[native code]` |
| 0.0% | 3.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:220` |
| 0.0% | 3.2ms | 0.0% | 0us | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:346` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `allNextSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4398` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `Object` | `[native code]` |
| 0.0% | 3.1ms | 0.0% | 1.4ms | `isInFinally` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:49` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `isFunction` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:152` |
| 0.0% | 3.1ms | 0.0% | 0us | `isInFinally` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:53` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3594` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3719` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7014` |
| 0.0% | 2.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` |
| 0.0% | 2.8ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4241` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4033` |
| 0.0% | 2.8ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6293` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7063` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1429` |
| 0.0% | 2.7ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:441` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4244` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4306` |
| 0.0% | 2.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` |
| 0.0% | 2.5ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6950` |
| 0.0% | 2.4ms | 0.0% | 2.4ms | `dlopen` | `[native code]` |
| 0.0% | 2.4ms | 0.0% | 1.2ms | `readFileSync` | `[native code]` |
| 0.0% | 2.3ms | 0.0% | 0us | `node:path` | `node:path:2` |
| 0.0% | 2.3ms | 0.0% | 0us | `internal:shared` | `internal:shared:2` |
| 0.0% | 2.3ms | 0.0% | 0us | `(anonymous)` | `/private/tmp/prof.js:1` |
| 0.0% | 2.3ms | 0.0% | 0us | `internal:validators` | `internal:validators:2` |
| 0.0% | 1.8ms | 0.0% | 0us | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:180` |
| 0.0% | 1.7ms | 0.0% | 0us | `_loadFromDisk` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:68` |
| 0.0% | 1.7ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4216` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `existsSync` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `describeRule` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:30` |
| 0.0% | 1.7ms | 0.0% | 0us | `existsSync` | `node:fs:273` |
| 0.0% | 1.7ms | 0.0% | 0us | `_getPlugin` | `/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:60` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:551` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4311` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4543` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1829` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4290` |
| 0.0% | 1.7ms | 0.0% | 0us | `_csrSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4270` |
| 0.0% | 1.7ms | 0.0% | 0us | `nextSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4388` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3550` |
| 0.0% | 1.7ms | 0.0% | 0us | `getCommentsInside` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3081` |
| 0.0% | 1.7ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `commentsInRange` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:555` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js:133` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6785` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` |
| 0.0% | 1.6ms | 0.0% | 0us | `parse` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.6ms | 0.0% | 0us | `Ae` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.6ms | 0.0% | 0us | `ke` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.6ms | 0.0% | 0us | `_e` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.6ms | 0.0% | 0us | `g` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.6ms | 0.0% | 0us | `Pe` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `we` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` |
| 0.0% | 1.6ms | 0.0% | 0us | `_getOrBuildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5455` |
| 0.0% | 1.6ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6526` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:14` |
| 0.0% | 1.6ms | 0.0% | 0us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5265` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_compileSelectorFastMatcher` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4150` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` |
| 0.0% | 1.6ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1482` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6517` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get prevSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4393` |
| 0.0% | 1.5ms | 0.0% | 0us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6513` |
| 0.0% | 1.5ms | 0.0% | 0us | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:196` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6469` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4300` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3771` |
| 0.0% | 1.5ms | 0.0% | 0us | `allPrevSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4408` |
| 0.0% | 1.5ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:309` |
| 0.0% | 1.5ms | 0.0% | 0us | `map` | `[native code]` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_fromRunnerReport` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6448` |
| 0.0% | 1.4ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1384` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_rawTokenText` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:794` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:223` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4426` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4327` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7077` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6360` |
| 0.0% | 1.4ms | 0.0% | 0us | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6208` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1380` |
| 0.0% | 1.4ms | 0.0% | 0us | `isInLoop` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:179` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6445` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get label` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3220` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4336` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `async lintSource` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:461` |
| 0.0% | 1.3ms | 0.0% | 0us | `async (anonymous)` | `/private/tmp/prof.js:9` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `CfgSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4375` |
| 0.0% | 1.3ms | 0.0% | 0us | `get nextSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4388` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6514` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5978` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getUint32` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:279` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3631` |
| 0.0% | 1.2ms | 0.0% | 0us | `esquery` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:53` |
| 0.0% | 1.2ms | 0.0% | 0us | `loadBinding` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `[native code]` |
| 0.0% | 1.2ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:170` |
| 0.0% | 1.2ms | 0.0% | 0us | `getNativeRules` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:458` |
| 0.0% | 1.2ms | 0.0% | 0us | `_getFfiSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:110` |
| 0.0% | 1.2ms | 0.0% | 0us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5333` |
| 0.0% | 1.2ms | 0.0% | 0us | `isAvailable` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:399` |
| 0.0% | 1.2ms | 0.0% | 0us | `dlopen` | `bun:ffi:345` |
| 0.0% | 1.2ms | 0.0% | 0us | `_tryLoad` | `/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:51` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/private/tmp/prof.js:5` |

## Function Details

### `parse`
`[native code]` | Self: 23.5% (2.09s) | Total: 23.5% (2.09s) | Samples: 1381

**Called by:**
- `parseSource` (1381)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6867` | Self: 6.0% (543.0ms) | Total: 6.8% (608.7ms) | Samples: 352

**Called by:**
- `runPlugins` (395)

**Calls:**
- `get allSkipped` (34)
- `get allSkipped` (9)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6471` | Self: 4.0% (361.0ms) | Total: 4.0% (362.7ms) | Samples: 237

**Called by:**
- `walkNodes` (125)
- `walkNodes` (88)
- `walkNodes` (23)
- `walkNodes` (2)

**Calls:**
- `get` (1)

### `CfgSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4374` | Self: 3.9% (352.8ms) | Total: 3.9% (352.8ms) | Samples: 232

**Called by:**
- `segment` (232)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3994` | Self: 3.8% (340.2ms) | Total: 3.8% (340.2ms) | Samples: 225

**Called by:**
- `_fireCfgEvents` (101)
- `walkNodes` (76)
- `ReturnStatement` (20)
- `invokeSelectorHandlers` (10)
- `getAncestorsFor` (7)
- `walkNodes` (4)
- `walkNodes` (4)
- `walkNodes` (2)
- `_nodesFromRange` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6451` | Self: 2.7% (242.0ms) | Total: 3.0% (272.5ms) | Samples: 161

**Called by:**
- `runPlugins` (181)

**Calls:**
- `has` (15)
- `set` (5)

### `filter`
`[native code]` | Self: 2.2% (196.6ms) | Total: 2.2% (199.9ms) | Samples: 127

**Called by:**
- `getUselessReturns` (72)
- `markReturnStatementsOnSegmentAsUsed` (42)
- `markReturnStatementsOnSegmentAsUsed` (9)
- `markReturnStatementsOnSegmentAsUsed` (6)

**Calls:**
- `(anonymous)` (2)

### `onCodePathSegmentStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:324` | Self: 2.0% (182.0ms) | Total: 2.0% (182.0ms) | Samples: 120

**Called by:**
- `_dispatchSeg` (120)

### `onCodePathSegmentStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:313` | Self: 2.0% (181.1ms) | Total: 2.0% (181.1ms) | Samples: 117

**Called by:**
- `_dispatchSeg` (117)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7086` | Self: 1.8% (165.3ms) | Total: 1.8% (165.3ms) | Samples: 109

**Called by:**
- `runPlugins` (109)

### `has`
`[native code]` | Self: 1.7% (152.8ms) | Total: 1.7% (152.8ms) | Samples: 101

**Called by:**
- `getAncestorsFor` (40)
- `walkNodes` (27)
- `walkNodes` (16)
- `walkNodes` (15)
- `getAncestorsFor` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6627` | Self: 1.6% (150.1ms) | Total: 1.6% (150.1ms) | Samples: 100

**Called by:**
- `runPlugins` (100)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 1.6% (147.5ms) | Total: 1.6% (147.5ms) | Samples: 97

**Called by:**
- `walkNodes` (75)
- `walkNodes` (22)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6473` | Self: 1.5% (134.0ms) | Total: 4.0% (360.8ms) | Samples: 90

**Called by:**
- `walkNodes` (111)
- `walkNodes` (102)
- `walkNodes` (22)
- `walkNodes` (5)

**Calls:**
- `_nodeViewRaw` (101)
- `_nodeViewRaw` (14)
- `_nodeViewRaw` (12)
- `nodeView` (9)
- `_nodeViewRaw` (4)
- `nodeView` (3)
- `_nodeViewRaw` (3)
- `_nodeViewRaw` (2)
- `nodeView` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6874` | Self: 1.5% (133.6ms) | Total: 2.0% (181.2ms) | Samples: 88

**Called by:**
- `runPlugins` (119)

**Calls:**
- `_resolveHandlers` (30)
- `_resolveHandlers` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7036` | Self: 1.4% (125.6ms) | Total: 1.8% (162.7ms) | Samples: 84

**Called by:**
- `runPlugins` (108)

**Calls:**
- `_resolveHandlers` (24)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6619` | Self: 1.3% (116.3ms) | Total: 1.3% (116.3ms) | Samples: 76

**Called by:**
- `runPlugins` (76)

### `forEach`
`[native code]` | Self: 1.2% (112.9ms) | Total: 3.1% (279.1ms) | Samples: 76

**Called by:**
- `markReturnStatementsOnCurrentSegmentsAsUsed` (184)
- `markReturnStatementsOnSegmentAsUsed` (1)

**Calls:**
- `markReturnStatementsOnSegmentAsUsed` (42)
- `markReturnStatementsOnSegmentAsUsed` (30)
- `markReturnStatementsOnSegmentAsUsed` (16)
- `markReturnStatementsOnSegmentAsUsed` (9)
- `markReturnStatementsOnSegmentAsUsed` (6)
- `markReturnStatementsOnSegmentAsUsed` (5)
- `markReturnStatementsOnSegmentAsUsed` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6623` | Self: 1.2% (108.4ms) | Total: 1.2% (108.4ms) | Samples: 69

**Called by:**
- `runPlugins` (69)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6951` | Self: 1.1% (102.6ms) | Total: 1.1% (103.9ms) | Samples: 68

**Called by:**
- `runPlugins` (69)

**Calls:**
- `get label` (1)

### `CfgSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4381` | Self: 1.1% (102.3ms) | Total: 1.1% (102.3ms) | Samples: 67

**Called by:**
- `segment` (67)

### `_dispatchSeg`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6110` | Self: 1.1% (98.8ms) | Total: 13.2% (1.18s) | Samples: 64

**Called by:**
- `_fireCfgEvents` (701)
- `_fireCfgEvents` (47)
- `_fireCfgEvents` (16)
- `_fireCfgEvents` (11)

**Calls:**
- `onCodePathSegmentStart` (355)
- `onCodePathSegmentStart` (120)
- `onCodePathSegmentStart` (117)
- `onCodePathSegmentStart` (79)
- `onCodePathSegmentEnd` (20)
- `onUnreachableCodePathSegmentStart` (15)
- `onUnreachableCodePathSegmentEnd` (5)

### `_csrSegments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4267` | Self: 0.9% (88.9ms) | Total: 0.9% (88.9ms) | Samples: 57

**Called by:**
- `allPrevSegments` (56)
- `allPrevSegments` (1)

### `push`
`[native code]` | Self: 0.9% (86.5ms) | Total: 0.9% (86.5ms) | Samples: 57

**Called by:**
- `getUselessReturns` (54)
- `walkNodes` (2)
- `walkNodes` (1)

### `getUselessReturns`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:157` | Self: 0.9% (84.4ms) | Total: 1.8% (166.3ms) | Samples: 57

**Called by:**
- `onCodePathSegmentStart` (108)
- `getUselessReturns` (3)

**Calls:**
- `push` (54)

### `_resolveHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.9% (83.0ms) | Total: 0.9% (83.0ms) | Samples: 54

**Called by:**
- `walkNodes` (30)
- `walkNodes` (24)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5946` | Self: 0.9% (80.9ms) | Total: 0.9% (85.6ms) | Samples: 53

**Called by:**
- `_runSelectorList` (56)

**Calls:**
- `has` (3)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5949` | Self: 0.8% (75.0ms) | Total: 2.2% (196.5ms) | Samples: 50

**Called by:**
- `_runSelectorList` (131)

**Calls:**
- `_nodeViewRaw` (26)
- `nodeView` (19)
- `_nodeViewRaw` (16)
- `nodeView` (7)
- `_nodeViewRaw` (7)
- `nodeView` (5)
- `_nodeViewRaw` (1)

### `WeakSet`
`[native code]` | Self: 0.8% (75.0ms) | Total: 0.8% (75.0ms) | Samples: 49

**Called by:**
- `getUselessReturns` (49)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6452` | Self: 0.6% (59.2ms) | Total: 0.8% (73.0ms) | Samples: 39

**Called by:**
- `runPlugins` (48)

**Calls:**
- `get` (7)
- `push` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3986` | Self: 0.6% (59.1ms) | Total: 0.6% (59.1ms) | Samples: 39

**Called by:**
- `getAncestorsFor` (16)
- `_fireCfgEvents` (12)
- `walkNodes` (7)
- `invokeSelectorHandlers` (3)
- `ReturnStatement` (1)

### `getUselessReturns`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:141` | Self: 0.6% (55.3ms) | Total: 1.4% (130.4ms) | Samples: 36

**Called by:**
- `onCodePathSegmentStart` (83)
- `getUselessReturns` (2)

**Calls:**
- `WeakSet` (49)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6866` | Self: 0.5% (53.2ms) | Total: 0.5% (53.2ms) | Samples: 35

**Called by:**
- `runPlugins` (35)

### `get allSkipped`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4793` | Self: 0.5% (51.9ms) | Total: 0.5% (51.9ms) | Samples: 34

**Called by:**
- `walkNodes` (34)

### `markReturnStatementsOnCurrentSegmentsAsUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:257` | Self: 0.5% (50.1ms) | Total: 3.6% (327.7ms) | Samples: 32

**Called by:**
- `_invokeFused` (176)
- `ReturnStatement` (40)

**Calls:**
- `forEach` (184)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3991` | Self: 0.5% (48.2ms) | Total: 0.5% (48.2ms) | Samples: 31

**Called by:**
- `getAncestorsFor` (26)
- `walkNodes` (2)
- `_fireCfgEvents` (2)
- `invokeSelectorHandlers` (1)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5953` | Self: 0.5% (47.8ms) | Total: 1.2% (110.6ms) | Samples: 31

**Called by:**
- `_runSelectorList` (72)

**Calls:**
- `has` (40)
- `nodeLhs` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6868` | Self: 0.5% (47.3ms) | Total: 0.5% (47.3ms) | Samples: 31

**Called by:**
- `runPlugins` (31)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4037` | Self: 0.5% (46.5ms) | Total: 0.5% (46.5ms) | Samples: 31

**Called by:**
- `getAncestorsFor` (19)
- `walkNodes` (7)
- `_fireCfgEvents` (3)
- `invokeSelectorHandlers` (1)
- `ReturnStatement` (1)

### `CfgSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4371` | Self: 0.5% (45.6ms) | Total: 0.5% (45.6ms) | Samples: 29

**Called by:**
- `segment` (29)

### `markReturnStatementsOnSegmentAsUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:189` | Self: 0.5% (45.4ms) | Total: 0.5% (45.4ms) | Samples: 30

**Called by:**
- `forEach` (30)

### `defineProperty`
`[native code]` | Self: 0.4% (44.0ms) | Total: 0.4% (44.0ms) | Samples: 30

**Called by:**
- `walkNodes` (16)
- `walkNodes` (14)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4331` | Self: 0.4% (43.7ms) | Total: 0.4% (43.7ms) | Samples: 28

**Called by:**
- `nextSegments` (27)
- `get nextSegments` (1)

### `getUselessReturns`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:158` | Self: 0.4% (41.8ms) | Total: 0.4% (41.8ms) | Samples: 28

**Called by:**
- `onCodePathSegmentStart` (28)

### `segment`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4253` | Self: 0.4% (40.3ms) | Total: 6.0% (542.5ms) | Samples: 26

**Called by:**
- `_fireCfgEvents` (273)
- `_fireCfgEvents` (58)
- `initialSegment` (23)
- `_csrSegments` (1)

**Calls:**
- `CfgSegment` (232)
- `CfgSegment` (67)
- `CfgSegment` (29)
- `CfgSegment` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6948` | Self: 0.4% (39.9ms) | Total: 0.9% (81.0ms) | Samples: 26

**Called by:**
- `runPlugins` (53)

**Calls:**
- `has` (27)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5936` | Self: 0.4% (39.7ms) | Total: 0.4% (39.7ms) | Samples: 26

**Called by:**
- `_runSelectorList` (26)

### `_csrSegments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4271` | Self: 0.4% (38.9ms) | Total: 0.4% (38.9ms) | Samples: 26

**Called by:**
- `allPrevSegments` (22)
- `get allPrevSegments` (3)
- `get nextSegments` (1)

### `create`
`[native code]` | Self: 0.3% (35.3ms) | Total: 0.3% (35.3ms) | Samples: 23

**Called by:**
- `walkNodes` (17)
- `walkNodes` (6)

### `getUselessReturns`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:146` | Self: 0.3% (33.0ms) | Total: 0.3% (33.0ms) | Samples: 22

**Called by:**
- `onCodePathSegmentStart` (22)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4291` | Self: 0.3% (32.6ms) | Total: 0.3% (32.6ms) | Samples: 22

**Called by:**
- `nextSegments` (21)
- `get nextSegments` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4556` | Self: 0.3% (29.9ms) | Total: 4.9% (437.2ms) | Samples: 19

**Called by:**
- `walkNodes` (287)

**Calls:**
- `markReturnStatementsOnCurrentSegmentsAsUsed` (176)
- `ReturnStatement` (41)
- `ReturnStatement` (40)
- `ReturnStatement` (5)
- `ReturnStatement` (4)
- `ReturnStatement` (2)

### `onCodePathSegmentEnd`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:336` | Self: 0.3% (28.8ms) | Total: 0.3% (28.8ms) | Samples: 20

**Called by:**
- `_dispatchSeg` (20)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3995` | Self: 0.3% (28.2ms) | Total: 0.3% (28.2ms) | Samples: 18

**Called by:**
- `ReturnStatement` (7)
- `walkNodes` (5)
- `_fireCfgEvents` (4)
- `_nodesFromRange` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4005` | Self: 0.3% (27.7ms) | Total: 0.3% (27.7ms) | Samples: 19

**Called by:**
- `_fireCfgEvents` (14)
- `walkNodes` (4)
- `walkNodes` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6897` | Self: 0.3% (27.4ms) | Total: 8.4% (753.9ms) | Samples: 19

**Called by:**
- `runPlugins` (500)

**Calls:**
- `_fireCfgEvents` (192)
- `_fireCfgEvents` (111)
- `_fireCfgEvents` (88)
- `_fireCfgEvents` (26)
- `_fireCfgEvents` (24)
- `_fireCfgEvents` (9)
- `_fireCfgEvents` (7)
- `_fireCfgEvents` (6)
- `_fireCfgEvents` (5)
- `_fireCfgEvents` (5)
- `_fireCfgEvents` (3)
- `_fireCfgEvents` (3)
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6358` | Self: 0.2% (26.4ms) | Total: 0.2% (26.4ms) | Samples: 18

**Called by:**
- `walkNodes` (18)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6907` | Self: 0.2% (26.3ms) | Total: 3.2% (285.0ms) | Samples: 17

**Called by:**
- `runPlugins` (188)

**Calls:**
- `_fireCfgEvents` (120)
- `_fireCfgEvents` (23)
- `_fireCfgEvents` (22)
- `_fireCfgEvents` (5)
- `_fireCfgEvents` (1)

### `next`
`[native code]` | Self: 0.2% (24.1ms) | Total: 0.2% (24.1ms) | Samples: 16

**Called by:**
- `walkNodes` (7)
- `walkNodes` (5)
- `walkNodes` (4)

### `CfgCodePath`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4428` | Self: 0.2% (23.4ms) | Total: 0.2% (23.4ms) | Samples: 16

**Called by:**
- `codepath` (16)

### `markReturnStatementsOnSegmentAsUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:188` | Self: 0.2% (23.3ms) | Total: 0.2% (23.3ms) | Samples: 16

**Called by:**
- `forEach` (16)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5933` | Self: 0.2% (23.1ms) | Total: 0.2% (23.1ms) | Samples: 15

**Called by:**
- `_runSelectorList` (15)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5958` | Self: 0.2% (22.7ms) | Total: 0.2% (22.7ms) | Samples: 15

**Called by:**
- `_runSelectorList` (15)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4032` | Self: 0.2% (22.2ms) | Total: 0.2% (22.2ms) | Samples: 14

**Called by:**
- `getAncestorsFor` (7)
- `ReturnStatement` (3)
- `walkNodes` (2)
- `_fireCfgEvents` (2)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4001` | Self: 0.2% (22.0ms) | Total: 0.2% (22.0ms) | Samples: 14

**Called by:**
- `walkNodes` (4)
- `_fireCfgEvents` (3)
- `ReturnStatement` (3)
- `walkNodes` (2)
- `getAncestorsFor` (1)
- `walkNodes` (1)

### `onUnreachableCodePathSegmentStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:328` | Self: 0.2% (22.0ms) | Total: 0.2% (22.0ms) | Samples: 15

**Called by:**
- `_dispatchSeg` (15)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4363` | Self: 0.2% (21.4ms) | Total: 0.2% (21.4ms) | Samples: 14

**Called by:**
- `nextSegments` (14)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.2% (21.3ms) | Total: 0.2% (21.3ms) | Samples: 15

**Called by:**
- `_fireCfgEvents` (9)
- `getAncestorsFor` (5)
- `walkNodes` (1)

### `decode`
`[native code]` | Self: 0.2% (21.2ms) | Total: 0.2% (21.2ms) | Samples: 14

**Called by:**
- `get source` (14)

### `DataView`
`[native code]` | Self: 0.2% (21.1ms) | Total: 0.2% (21.1ms) | Samples: 14

**Called by:**
- `AstView` (14)

### `onCodePathSegmentStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:316` | Self: 0.2% (20.9ms) | Total: 6.0% (541.0ms) | Samples: 13

**Called by:**
- `_dispatchSeg` (355)

**Calls:**
- `getUselessReturns` (108)
- `getUselessReturns` (83)
- `getUselessReturns` (75)
- `getUselessReturns` (28)
- `getUselessReturns` (22)
- `getUselessReturns` (12)
- `getUselessReturns` (10)
- `getUselessReturns` (4)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6506` | Self: 0.2% (20.6ms) | Total: 16.9% (1.51s) | Samples: 14

**Called by:**
- `walkNodes` (671)
- `walkNodes` (192)
- `walkNodes` (120)
- `walkNodes` (5)

**Calls:**
- `_dispatchSeg` (701)
- `segment` (273)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6903` | Self: 0.2% (20.3ms) | Total: 7.0% (627.2ms) | Samples: 14

**Called by:**
- `runPlugins` (411)

**Calls:**
- `_invokeFused` (287)
- `_nodeViewRaw` (76)
- `nodeView` (7)
- `_nodeViewRaw` (7)
- `_nodeViewRaw` (5)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (2)
- `nodeView` (2)
- `nodeView` (1)
- `_invokeFused` (1)
- `nodeView` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6968` | Self: 0.2% (19.7ms) | Total: 0.2% (21.4ms) | Samples: 13

**Called by:**
- `runPlugins` (14)

**Calls:**
- `push` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7169` | Self: 0.2% (19.7ms) | Total: 4.0% (357.3ms) | Samples: 14

**Called by:**
- `runPlugins` (235)

**Calls:**
- `_fireCfgEvents` (75)
- `_fireCfgEvents` (60)
- `_fireCfgEvents` (22)
- `_fireCfgEvents` (20)
- `_fireCfgEvents` (20)
- `_fireCfgEvents` (8)
- `_fireCfgEvents` (5)
- `_fireCfgEvents` (4)
- `_fireCfgEvents` (3)
- `_fireCfgEvents` (2)
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)

### `getUselessReturns`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:143` | Self: 0.2% (18.0ms) | Total: 0.2% (18.0ms) | Samples: 12

**Called by:**
- `onCodePathSegmentStart` (12)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7070` | Self: 0.1% (17.7ms) | Total: 0.3% (27.3ms) | Samples: 12

**Called by:**
- `runPlugins` (18)

**Calls:**
- `create` (6)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5956` | Self: 0.1% (16.7ms) | Total: 0.1% (16.7ms) | Samples: 11

**Called by:**
- `_runSelectorList` (11)

### `anonymous`
`[native code]` | Self: 0.1% (16.5ms) | Total: 0.5% (51.0ms) | Samples: 10

**Called by:**
- `require` (25)
- `bound require` (2)
- `internal:validators` (1)
- `node:path` (1)
- `internal:shared` (1)

**Calls:**
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:shared` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:path` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `internal:validators` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6508` | Self: 0.1% (15.8ms) | Total: 1.4% (125.8ms) | Samples: 10

**Called by:**
- `walkNodes` (60)
- `walkNodes` (20)
- `walkNodes` (3)
- `walkNodes` (1)

**Calls:**
- `segment` (58)
- `_dispatchSeg` (16)

### `get`
`[native code]` | Self: 0.1% (15.2ms) | Total: 0.1% (15.2ms) | Samples: 10

**Called by:**
- `walkNodes` (7)
- `walkNodes` (2)
- `_fireCfgEvents` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7072` | Self: 0.1% (14.8ms) | Total: 0.4% (42.3ms) | Samples: 10

**Called by:**
- `runPlugins` (28)

**Calls:**
- `defineProperty` (16)
- `Object` (2)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5960` | Self: 0.1% (14.2ms) | Total: 0.1% (14.2ms) | Samples: 9

**Called by:**
- `_runSelectorList` (9)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7096` | Self: 0.1% (14.1ms) | Total: 18.2% (1.62s) | Samples: 9

**Called by:**
- `runPlugins` (1062)

**Calls:**
- `_fireCfgEvents` (671)
- `_fireCfgEvents` (125)
- `_fireCfgEvents` (102)
- `_fireCfgEvents` (91)
- `_fireCfgEvents` (24)
- `_fireCfgEvents` (20)
- `_fireCfgEvents` (10)
- `_fireCfgEvents` (3)
- `_fireCfgEvents` (3)
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)

### `get allSkipped`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (13.7ms) | Total: 0.1% (13.7ms) | Samples: 9

**Called by:**
- `walkNodes` (9)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (12.2ms) | Total: 0.1% (12.2ms) | Samples: 8

**Called by:**
- `(anonymous)` (7)
- `invokeMethodFnHandlers` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6499` | Self: 0.1% (11.9ms) | Total: 0.3% (33.2ms) | Samples: 8

**Called by:**
- `walkNodes` (20)
- `walkNodes` (1)

**Calls:**
- `onCodePathEnd` (6)
- `onCodePathEnd` (5)
- `onCodePathEnd` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7037` | Self: 0.1% (11.9ms) | Total: 0.1% (11.9ms) | Samples: 8

**Called by:**
- `runPlugins` (8)

### `invokeSelectorHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6050` | Self: 0.1% (11.6ms) | Total: 0.3% (34.2ms) | Samples: 7

**Called by:**
- `walkNodes` (21)
- `walkNodes` (1)

**Calls:**
- `_nodeViewRaw` (10)
- `_nodeViewRaw` (3)
- `nodeView` (1)
- `_nodeViewRaw` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7074` | Self: 0.1% (11.1ms) | Total: 0.3% (30.8ms) | Samples: 7

**Called by:**
- `runPlugins` (21)

**Calls:**
- `defineProperty` (14)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6447` | Self: 0.1% (11.0ms) | Total: 0.1% (11.0ms) | Samples: 7

**Called by:**
- `runPlugins` (7)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6497` | Self: 0.1% (10.2ms) | Total: 0.1% (11.8ms) | Samples: 7

**Called by:**
- `walkNodes` (8)

**Calls:**
- `get type` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6848` | Self: 0.1% (10.0ms) | Total: 0.1% (10.0ms) | Samples: 7

**Called by:**
- `runPlugins` (7)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6484` | Self: 0.1% (8.9ms) | Total: 0.1% (8.9ms) | Samples: 6

**Called by:**
- `walkNodes` (5)
- `walkNodes` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6901` | Self: 0.0% (8.3ms) | Total: 0.1% (13.3ms) | Samples: 5

**Called by:**
- `runPlugins` (8)

**Calls:**
- `invokeSelectorHandlers` (2)
- `invokeSelectorHandlers` (1)

### `onUnreachableCodePathSegmentEnd`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:332` | Self: 0.0% (8.3ms) | Total: 0.0% (8.3ms) | Samples: 5

**Called by:**
- `_dispatchSeg` (5)

### `onCodePathEnd`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:280` | Self: 0.0% (8.2ms) | Total: 0.0% (8.2ms) | Samples: 5

**Called by:**
- `_fireCfgEvents` (5)

### `set`
`[native code]` | Self: 0.0% (8.1ms) | Total: 0.0% (8.1ms) | Samples: 5

**Called by:**
- `walkNodes` (5)

### `getUselessReturns`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:156` | Self: 0.0% (8.0ms) | Total: 0.0% (8.0ms) | Samples: 5

**Called by:**
- `onCodePathSegmentStart` (4)
- `getUselessReturns` (1)

### `markReturnStatementsOnSegmentAsUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js` | Self: 0.0% (7.9ms) | Total: 0.0% (7.9ms) | Samples: 5

**Called by:**
- `forEach` (5)

### `onCodePathStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:270` | Self: 0.0% (7.8ms) | Total: 0.0% (7.8ms) | Samples: 5

**Called by:**
- `_fireCfgEvents` (5)

### `CfgCodePath`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4431` | Self: 0.0% (7.6ms) | Total: 0.0% (7.6ms) | Samples: 5

**Called by:**
- `codepath` (5)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3620` | Self: 0.0% (7.5ms) | Total: 0.0% (7.5ms) | Samples: 5

**Called by:**
- `get value` (5)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4322` | Self: 0.0% (6.9ms) | Total: 0.0% (6.9ms) | Samples: 5

**Called by:**
- `nextSegments` (5)

### `nodeLhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:528` | Self: 0.0% (6.6ms) | Total: 0.0% (6.6ms) | Samples: 4

**Called by:**
- `walkNodes` (2)
- `walkNodes` (1)
- `getAncestorsFor` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6486` | Self: 0.0% (6.2ms) | Total: 0.1% (14.0ms) | Samples: 4

**Called by:**
- `walkNodes` (9)

**Calls:**
- `onCodePathStart` (5)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7139` | Self: 0.0% (6.1ms) | Total: 0.3% (29.6ms) | Samples: 4

**Called by:**
- `runPlugins` (20)

**Calls:**
- `has` (16)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6460` | Self: 0.0% (6.1ms) | Total: 0.1% (12.5ms) | Samples: 4

**Called by:**
- `runPlugins` (8)

**Calls:**
- `next` (4)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1019` | Self: 0.0% (6.0ms) | Total: 0.0% (6.0ms) | Samples: 4

**Called by:**
- `_fireCfgEvents` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7062` | Self: 0.0% (5.9ms) | Total: 0.0% (5.9ms) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `encodeInto`
`[native code]` | Self: 0.0% (5.9ms) | Total: 0.0% (5.9ms) | Samples: 4

**Called by:**
- `_encodeSource` (4)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4358` | Self: 0.0% (5.9ms) | Total: 0.0% (5.9ms) | Samples: 4

**Called by:**
- `get nextSegments` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6620` | Self: 0.0% (5.9ms) | Total: 0.0% (5.9ms) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6480` | Self: 0.0% (5.9ms) | Total: 0.0% (5.9ms) | Samples: 4

**Called by:**
- `walkNodes` (3)
- `walkNodes` (1)

### `getUselessReturns`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:147` | Self: 0.0% (5.8ms) | Total: 0.1% (14.3ms) | Samples: 4

**Called by:**
- `onCodePathSegmentStart` (10)

**Calls:**
- `getUselessReturns` (3)
- `getUselessReturns` (2)
- `getUselessReturns` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6495` | Self: 0.0% (5.8ms) | Total: 0.0% (5.8ms) | Samples: 4

**Called by:**
- `walkNodes` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5064` | Self: 0.0% (5.7ms) | Total: 0.2% (18.1ms) | Samples: 4

**Called by:**
- `fn` (12)

**Calls:**
- `get type` (7)
- `get type` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6461` | Self: 0.0% (5.4ms) | Total: 0.1% (15.5ms) | Samples: 4

**Called by:**
- `runPlugins` (11)

**Calls:**
- `next` (7)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4345` | Self: 0.0% (5.1ms) | Total: 0.0% (5.1ms) | Samples: 3

**Called by:**
- `get nextSegments` (3)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1285` | Self: 0.0% (4.9ms) | Total: 0.0% (4.9ms) | Samples: 3

**Called by:**
- `isInFinally` (2)
- `isInLoop` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6478` | Self: 0.0% (4.8ms) | Total: 0.4% (40.1ms) | Samples: 3

**Called by:**
- `walkNodes` (26)
- `walkNodes` (1)

**Calls:**
- `codepath` (24)

### `get argument`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1857` | Self: 0.0% (4.4ms) | Total: 0.0% (4.4ms) | Samples: 3

**Called by:**
- `ReturnStatement` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7075` | Self: 0.0% (4.3ms) | Total: 0.0% (4.3ms) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5947` | Self: 0.0% (4.3ms) | Total: 0.0% (4.3ms) | Samples: 3

**Called by:**
- `_runSelectorList` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7140` | Self: 0.0% (4.2ms) | Total: 0.0% (4.2ms) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7068` | Self: 0.0% (4.2ms) | Total: 0.0% (4.2ms) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6462` | Self: 0.0% (4.1ms) | Total: 0.1% (11.7ms) | Samples: 3

**Called by:**
- `runPlugins` (8)

**Calls:**
- `next` (5)

### `_dispatchSeg`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6106` | Self: 0.0% (4.0ms) | Total: 0.0% (4.0ms) | Samples: 3

**Called by:**
- `_fireCfgEvents` (3)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6482` | Self: 0.0% (4.0ms) | Total: 0.1% (10.0ms) | Samples: 3

**Called by:**
- `walkNodes` (7)

**Calls:**
- `get type` (4)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4304` | Self: 0.0% (3.4ms) | Total: 0.0% (3.4ms) | Samples: 2

**Called by:**
- `get nextSegments` (1)
- `nextSegments` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4333` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `get nextSegments` (1)
- `nextSegments` (1)

### `invokeSelectorHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `_extendRangeToIncludeSemicolon`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:82` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `get loc` (2)

### `get argument`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1829` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `ReturnStatement` (1)
- `ReturnStatement` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6509` | Self: 0.0% (3.2ms) | Total: 0.2% (24.9ms) | Samples: 2

**Called by:**
- `walkNodes` (10)
- `walkNodes` (3)
- `walkNodes` (3)

**Calls:**
- `_dispatchSeg` (11)
- `_dispatchSeg` (3)

### `get type`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1011` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `(anonymous)` (1)
- `_fireCfgEvents` (1)

### `ReturnStatement`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:341` | Self: 0.0% (3.2ms) | Total: 0.7% (62.8ms) | Samples: 2

**Called by:**
- `_invokeFused` (41)

**Calls:**
- `_nodeViewRaw` (20)
- `_nodeViewRaw` (7)
- `get argument` (3)
- `_nodeViewRaw` (3)
- `nodeView` (3)
- `nodeView` (1)
- `get argument` (1)
- `get argument` (1)

### `allNextSegments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4398` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `_fireCfgEvents` (2)

### `Object`
`[native code]` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `isFunction`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:152` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `isInLoop` (1)
- `isInFinally` (1)

### `range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3594` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `get value` (1)
- `(anonymous)` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3719` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `report` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7078` | Self: 0.0% (3.0ms) | Total: 0.0% (5.6ms) | Samples: 2

**Called by:**
- `runPlugins` (4)

**Calls:**
- `get` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7014` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6507` | Self: 0.0% (2.9ms) | Total: 0.8% (72.9ms) | Samples: 2

**Called by:**
- `walkNodes` (24)
- `walkNodes` (20)
- `walkNodes` (5)

**Calls:**
- `_dispatchSeg` (47)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4033` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `walkNodes` (1)
- `ReturnStatement` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7063` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1429` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `invokeMethodFnHandlers` (2)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4244` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4306` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `get nextSegments` (1)
- `nextSegments` (1)

### `codepath`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4259` | Self: 0.0% (2.6ms) | Total: 0.3% (35.3ms) | Samples: 2

**Called by:**
- `_fireCfgEvents` (24)

**Calls:**
- `CfgCodePath` (16)
- `CfgCodePath` (5)
- `CfgCodePath` (1)

### `nextSegments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4387` | Self: 0.0% (2.6ms) | Total: 1.2% (114.9ms) | Samples: 2

**Called by:**
- `_fireCfgEvents` (76)

**Calls:**
- `_ensureNextAdjacency` (27)
- `_ensureNextAdjacency` (21)
- `_ensureNextAdjacency` (14)
- `_ensureNextAdjacency` (5)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)

### `dlopen`
`[native code]` | Self: 0.0% (2.4ms) | Total: 0.0% (2.4ms) | Samples: 2

**Called by:**
- `dlopen` (1)
- `(anonymous)` (1)

### `_runSelectorList`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5994` | Self: 0.0% (2.4ms) | Total: 5.8% (517.6ms) | Samples: 2

**Called by:**
- `invokeSelectorHandlers` (341)

**Calls:**
- `getAncestorsFor` (131)
- `getAncestorsFor` (72)
- `getAncestorsFor` (56)
- `getAncestorsFor` (26)
- `getAncestorsFor` (15)
- `getAncestorsFor` (15)
- `getAncestorsFor` (11)
- `getAncestorsFor` (9)
- `getAncestorsFor` (3)
- `getAncestorsFor` (1)

### `existsSync`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `existsSync` (1)

### `some`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (3.2ms) | Samples: 1

**Called by:**
- `(anonymous)` (2)

**Calls:**
- `(anonymous)` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:551` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `fix` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4311` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `get nextSegments` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4543` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `argument`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1829` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `ReturnStatement` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4290` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `nextSegments` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3550` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `getCommentsInside` (1)

### `commentsInRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:555` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `fix` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_resolveHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6785` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `ke` (1)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_getOrBuildPlan` (1)

### `_compileSelectorFastMatcher`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_getOrBuildSelectorPlan` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4150` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7064` | Self: 0.0% (1.6ms) | Total: 0.1% (10.7ms) | Samples: 1

**Called by:**
- `runPlugins` (7)

**Calls:**
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7013` | Self: 0.0% (1.5ms) | Total: 0.0% (3.3ms) | Samples: 1

**Called by:**
- `runPlugins` (2)

**Calls:**
- `nodeLhs` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6517` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `get prevSegments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4393` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_fireCfgEvents` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6469` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4300` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `nextSegments` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3771` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `report` (1)

### `_fromRunnerReport`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `map` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6448` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6516` | Self: 0.0% (1.5ms) | Total: 0.0% (4.7ms) | Samples: 1

**Called by:**
- `walkNodes` (3)

**Calls:**
- `allNextSegments` (2)

### `_rawTokenText`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:794` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `get value` (1)

### `CfgCodePath`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4426` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `codepath` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4327` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `nextSegments` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7077` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6360` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `isInFinally`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:49` | Self: 0.0% (1.4ms) | Total: 0.0% (3.1ms) | Samples: 1

**Called by:**
- `ReturnStatement` (2)

**Calls:**
- `isFunction` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1380` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_fireCfgEvents` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7065` | Self: 0.0% (1.3ms) | Total: 0.1% (10.6ms) | Samples: 1

**Called by:**
- `runPlugins` (7)

**Calls:**
- `_nodeViewRaw` (4)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6445` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `get label`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3220` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4336` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `nextSegments` (1)

### `invokeSelectorHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6086` | Self: 0.0% (1.3ms) | Total: 6.0% (539.8ms) | Samples: 1

**Called by:**
- `walkNodes` (356)

**Calls:**
- `_runSelectorList` (341)
- `_runSelectorList` (13)
- `_runSelectorList` (1)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `_runSelectorList` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7099` | Self: 0.0% (1.3ms) | Total: 6.4% (573.7ms) | Samples: 1

**Called by:**
- `runPlugins` (378)

**Calls:**
- `invokeSelectorHandlers` (356)
- `invokeSelectorHandlers` (21)

### `async lintSource`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:461` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `async (anonymous)` (1)

### `get argument`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `ReturnStatement` (1)

### `_runSelectorList`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5995` | Self: 0.0% (1.3ms) | Total: 0.2% (19.5ms) | Samples: 1

**Called by:**
- `invokeSelectorHandlers` (13)

**Calls:**
- `fn` (12)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6481` | Self: 0.0% (1.3ms) | Total: 0.4% (36.0ms) | Samples: 1

**Called by:**
- `walkNodes` (24)

**Calls:**
- `initialSegment` (23)

### `CfgSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4375` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `segment` (1)

### `ReturnStatement`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:345` | Self: 0.0% (1.3ms) | Total: 0.0% (7.3ms) | Samples: 1

**Called by:**
- `_invokeFused` (5)

**Calls:**
- `nodeView` (1)
- `argument` (1)
- `get argument` (1)
- `_nodeViewRaw` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6514` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6483` | Self: 0.0% (1.2ms) | Total: 0.0% (8.6ms) | Samples: 1

**Called by:**
- `walkNodes` (6)

**Calls:**
- `get value` (4)
- `get value` (1)

### `_runSelectorList`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5978` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `invokeSelectorHandlers` (1)

### `getUint32`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3631` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `get value` (1)

### `readFileSync`
`[native code]` | Self: 0.0% (1.2ms) | Total: 0.0% (2.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)
- `readFileSync` (1)

**Calls:**
- `readFileSync` (1)

### `markReturnStatementsOnSegmentAsUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:192` | Self: 0.0% (0us) | Total: 0.1% (10.6ms) | Samples: 0

**Called by:**
- `forEach` (6)

**Calls:**
- `filter` (6)

### `_getFfiSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:110` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_getOrBuildSelectorPlan` (1)

**Calls:**
- `isAvailable` (1)

### `markReturnStatementsOnSegmentAsUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:191` | Self: 0.0% (0us) | Total: 0.1% (13.2ms) | Samples: 0

**Called by:**
- `forEach` (9)

**Calls:**
- `filter` (9)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:300` | Self: 0.0% (0us) | Total: 23.8% (2.12s) | Samples: 0

**Calls:**
- `parseSource` (1381)
- `parseSource` (16)
- `parseSource` (4)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:11` | Self: 0.0% (0us) | Total: 0.0% (5.0ms) | Samples: 0

**Called by:**
- `anonymous` (3)

**Calls:**
- `bound require` (3)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7377` | Self: 0.0% (0us) | Total: 0.2% (21.2ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (14)

**Calls:**
- `get source` (14)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6865` | Self: 0.0% (0us) | Total: 0.3% (27.8ms) | Samples: 0

**Called by:**
- `runPlugins` (19)

**Calls:**
- `getDFSEvents` (18)
- `getDFSEvents` (1)

### `allPrevSegments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4408` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `getUselessReturns` (1)

**Calls:**
- `_csrSegments` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.0% (3.3ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:144` | Self: 0.0% (0us) | Total: 0.0% (7.2ms) | Samples: 0

**Calls:**
- `loadCoreRules` (4)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4241` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `g` (1)
- `esquery` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:511` | Self: 0.0% (0us) | Total: 0.2% (21.2ms) | Samples: 0

**Called by:**
- `runPlugins` (14)

**Calls:**
- `decode` (14)

### `markReturnStatementsOnSegmentAsUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:211` | Self: 0.0% (0us) | Total: 0.7% (64.0ms) | Samples: 0

**Called by:**
- `forEach` (42)

**Calls:**
- `filter` (42)

### `getNativeRules`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:458` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (1)

**Calls:**
- `loadBinding` (1)

### `get nextSegments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4388` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `_fireCfgEvents` (1)

**Calls:**
- `_csrSegments` (1)

### `_getOrBuildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5455` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_buildPlan` (1)

### `Ae`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `parse` (1)

**Calls:**
- `_e` (1)

### `node:path`
`node:path:2` | Self: 0.0% (0us) | Total: 0.0% (2.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `initialSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4442` | Self: 0.0% (0us) | Total: 0.3% (34.6ms) | Samples: 0

**Called by:**
- `_fireCfgEvents` (23)

**Calls:**
- `segment` (23)

### `loadBinding`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `getNativeRules` (1)

**Calls:**
- `bound require` (1)

### `_loadFromDisk`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:68` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_getPlugin` (1)

**Calls:**
- `existsSync` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:170` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Calls:**
- `getNativeRules` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:279` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `getUint32` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7069` | Self: 0.0% (0us) | Total: 0.2% (25.8ms) | Samples: 0

**Called by:**
- `runPlugins` (17)

**Calls:**
- `create` (17)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:220` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `filter` (2)

**Calls:**
- `some` (2)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:304` | Self: 0.0% (0us) | Total: 75.8% (6.75s) | Samples: 0

**Calls:**
- `runPlugins` (4424)
- `runPlugins` (14)
- `runPlugins` (4)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6196` | Self: 0.0% (0us) | Total: 0.1% (12.9ms) | Samples: 0

**Called by:**
- `walkNodes` (9)

**Calls:**
- `get value` (3)
- `get value` (2)
- `get value` (2)
- `get value` (1)
- `get value` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3759` | Self: 0.0% (0us) | Total: 0.0% (5.2ms) | Samples: 0

**Called by:**
- `report` (3)

**Calls:**
- `fix` (3)

### `isInFinally`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:53` | Self: 0.0% (0us) | Total: 0.0% (3.1ms) | Samples: 0

**Called by:**
- `ReturnStatement` (2)

**Calls:**
- `get parent` (2)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:180` | Self: 0.0% (0us) | Total: 0.0% (1.8ms) | Samples: 0

**Called by:**
- `ReturnStatement` (1)

**Calls:**
- `get parent` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:54` | Self: 0.0% (0us) | Total: 0.0% (7.2ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (4)

**Calls:**
- `bound require` (4)

### `_e`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `Ae` (1)

**Calls:**
- `Pe` (1)

### `fix`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:288` | Self: 0.0% (0us) | Total: 0.0% (5.2ms) | Samples: 0

**Called by:**
- `_execReport` (3)

**Calls:**
- `commentsInRange` (1)
- `commentsInRange` (1)
- `getCommentsInside` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:14` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `onCodePathEnd`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:281` | Self: 0.0% (0us) | Total: 0.1% (9.7ms) | Samples: 0

**Called by:**
- `_fireCfgEvents` (6)

**Calls:**
- `report` (6)

### `(anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `bound require` (1)

**Calls:**
- `dlopen` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:215` | Self: 0.0% (0us) | Total: 0.0% (5.9ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (4)

**Calls:**
- `_encodeSource` (4)

### `we`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `Pe` (1)

**Calls:**
- `ke` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `_tryLoad`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:51` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `isAvailable` (1)

**Calls:**
- `dlopen` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:236` | Self: 0.0% (0us) | Total: 0.2% (25.2ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (16)

**Calls:**
- `AstView` (14)
- `AstView` (1)
- `AstView` (1)

### `ke`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `we` (1)

**Calls:**
- `(anonymous)` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1384` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (1)

**Calls:**
- `_rawTokenText` (1)

### `ReturnStatement`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:347` | Self: 0.0% (0us) | Total: 0.0% (6.2ms) | Samples: 0

**Called by:**
- `_invokeFused` (4)

**Calls:**
- `isInFinally` (2)
- `isInFinally` (2)

### `onCodePathEnd`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:283` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `_fireCfgEvents` (2)

**Calls:**
- `get loc` (2)

### `get allPrevSegments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4410` | Self: 0.0% (0us) | Total: 0.0% (4.2ms) | Samples: 0

**Called by:**
- `getUselessReturns` (2)
- `onCodePathSegmentStart` (1)

**Calls:**
- `_csrSegments` (3)

### `allPrevSegments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4410` | Self: 0.0% (0us) | Total: 1.3% (120.7ms) | Samples: 0

**Called by:**
- `onCodePathSegmentStart` (78)

**Calls:**
- `_csrSegments` (56)
- `_csrSegments` (22)

### `isAvailable`
`/Users/ericsan/Development/OpenSource/Ez/js/ffi-dispatch.js:399` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_getFfiSelector` (1)

**Calls:**
- `_tryLoad` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js:133` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6208` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `get type` (1)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:92` | Self: 0.0% (0us) | Total: 0.0% (5.9ms) | Samples: 0

**Called by:**
- `parseSource` (4)

**Calls:**
- `encodeInto` (4)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6950` | Self: 0.0% (0us) | Total: 0.0% (2.5ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `_nodeViewRaw` (2)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1478` | Self: 0.0% (0us) | Total: 0.0% (4.2ms) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (3)

**Calls:**
- `_nodesFromRange` (3)

### `getUselessReturns`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:149` | Self: 0.0% (0us) | Total: 1.3% (116.4ms) | Samples: 0

**Called by:**
- `onCodePathSegmentStart` (75)

**Calls:**
- `filter` (72)
- `get allPrevSegments` (2)
- `allPrevSegments` (1)

### `async (anonymous)`
`/private/tmp/prof.js:9` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Calls:**
- `async lintSource` (1)

### `map`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `_fromRunnerReport` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:309` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Calls:**
- `map` (1)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5333` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_getFfiSelector` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6526` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_getOrBuildPlan` (1)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 0.5% (45.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)
- `loadCoreRules` (4)
- `(anonymous)` (3)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `esquery` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `loadBinding` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

**Calls:**
- `require` (25)
- `anonymous` (2)
- `(anonymous)` (1)

### `(anonymous)`
`/private/tmp/prof.js:3` | Self: 0.0% (0us) | Total: 0.0% (7.3ms) | Samples: 0

**Called by:**
- `parseModule` (5)

**Calls:**
- `bound require` (5)

### `parse`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `g` (1)

**Calls:**
- `Ae` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:222` | Self: 0.0% (0us) | Total: 23.5% (2.09s) | Samples: 0

**Called by:**
- `_lintSourceOne` (1381)

**Calls:**
- `parse` (1381)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7005` | Self: 0.0% (0us) | Total: 0.1% (14.3ms) | Samples: 0

**Called by:**
- `runPlugins` (10)

**Calls:**
- `invokeMethodFnHandlers` (9)
- `invokeMethodFnHandlers` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:223` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `some` (1)

**Calls:**
- `range` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` | Self: 0.0% (0us) | Total: 0.0% (2.9ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `nextSegments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4388` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_fireCfgEvents` (1)

**Calls:**
- `_csrSegments` (1)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (10.9ms) | Samples: 0

**Calls:**
- `parseModule` (7)

### `esquery`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:53` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (1)

**Calls:**
- `bound require` (1)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 0.4% (39.8ms) | Samples: 0

**Called by:**
- `bound require` (25)

**Calls:**
- `anonymous` (25)

### `getCommentsInside`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3081` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `fix` (1)

**Calls:**
- `get range` (1)

### `describeRule`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (1)

**Calls:**
- `_getPlugin` (1)

### `isInLoop`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:179` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `ReturnStatement` (1)

**Calls:**
- `isFunction` (1)

### `g`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (1)

**Calls:**
- `parse` (1)

### `markReturnStatementsOnSegmentAsUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:196` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `forEach` (1)

**Calls:**
- `forEach` (1)

### `get nextSegments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4387` | Self: 0.0% (0us) | Total: 0.2% (21.0ms) | Samples: 0

**Called by:**
- `_fireCfgEvents` (13)

**Calls:**
- `_ensureNextAdjacency` (4)
- `_ensureNextAdjacency` (3)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6515` | Self: 0.0% (0us) | Total: 1.5% (139.1ms) | Samples: 0

**Called by:**
- `walkNodes` (91)

**Calls:**
- `nextSegments` (76)
- `get nextSegments` (13)
- `nextSegments` (1)
- `get nextSegments` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7385` | Self: 0.0% (0us) | Total: 75.5% (6.73s) | Samples: 0

**Called by:**
- `_lintSourceOne` (4424)

**Calls:**
- `walkNodes` (1062)
- `walkNodes` (500)
- `walkNodes` (411)
- `walkNodes` (395)
- `walkNodes` (378)
- `walkNodes` (235)
- `walkNodes` (188)
- `walkNodes` (181)
- `walkNodes` (119)
- `walkNodes` (109)
- `walkNodes` (108)
- `walkNodes` (100)
- `walkNodes` (76)
- `walkNodes` (69)
- `walkNodes` (69)
- `walkNodes` (53)
- `walkNodes` (48)
- `walkNodes` (35)
- `walkNodes` (31)
- `walkNodes` (28)
- `walkNodes` (21)
- `walkNodes` (20)
- `walkNodes` (19)
- `walkNodes` (18)
- `walkNodes` (17)
- `walkNodes` (14)
- `walkNodes` (11)
- `walkNodes` (10)
- `walkNodes` (8)
- `walkNodes` (8)
- `walkNodes` (8)
- `walkNodes` (8)
- `walkNodes` (7)
- `walkNodes` (7)
- `walkNodes` (7)
- `walkNodes` (7)
- `walkNodes` (4)
- `walkNodes` (4)
- `walkNodes` (4)
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
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)
- `walkNodes` (1)

### `_nodesFromRange`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:868` | Self: 0.0% (0us) | Total: 0.0% (4.2ms) | Samples: 0

**Called by:**
- `get value` (3)

**Calls:**
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7060` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `nodeLhs` (2)

### `fn`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5102` | Self: 0.0% (0us) | Total: 0.2% (18.1ms) | Samples: 0

**Called by:**
- `_runSelectorList` (12)

**Calls:**
- `(anonymous)` (12)

### `dlopen`
`bun:ffi:345` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_tryLoad` (1)

**Calls:**
- `dlopen` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1483` | Self: 0.0% (0us) | Total: 0.0% (8.7ms) | Samples: 0

**Called by:**
- `_fireCfgEvents` (4)
- `invokeMethodFnHandlers` (2)

**Calls:**
- `get loc` (5)
- `get loc` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3611` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `onCodePathEnd` (2)

**Calls:**
- `_extendRangeToIncludeSemicolon` (2)

### `(anonymous)`
`/private/tmp/prof.js:5` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `readFileSync` (1)

### `internal:shared`
`internal:shared:2` | Self: 0.0% (0us) | Total: 0.0% (2.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `existsSync`
`node:fs:273` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_loadFromDisk` (1)

**Calls:**
- `existsSync` (1)

### `parseModule`
`[native code]` | Self: 0.0% (0us) | Total: 0.1% (10.9ms) | Samples: 0

**Called by:**
- `async (anonymous)` (7)

**Calls:**
- `(anonymous)` (5)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `Pe`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js:1` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_e` (1)

**Calls:**
- `we` (1)

### `ReturnStatement`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:342` | Self: 0.0% (0us) | Total: 0.6% (61.0ms) | Samples: 0

**Called by:**
- `_invokeFused` (40)

**Calls:**
- `markReturnStatementsOnCurrentSegmentsAsUsed` (40)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:441` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `CfgGraph` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:276` | Self: 0.0% (0us) | Total: 0.2% (21.1ms) | Samples: 0

**Called by:**
- `parseSource` (14)

**Calls:**
- `DataView` (14)

### `onCodePathSegmentStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:318` | Self: 0.0% (0us) | Total: 1.3% (122.1ms) | Samples: 0

**Called by:**
- `_dispatchSeg` (79)

**Calls:**
- `allPrevSegments` (78)
- `get allPrevSegments` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6513` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `get prevSegments` (1)

### `_getPlugin`
`/Users/ericsan/Development/OpenSource/Ez/js/rule-metadata.js:60` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `describeRule` (1)

**Calls:**
- `_loadFromDisk` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7384` | Self: 0.0% (0us) | Total: 0.0% (6.3ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (4)

**Calls:**
- `buildVisitorMap` (2)
- `buildVisitorMap` (1)
- `buildVisitorMap` (1)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5265` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_compileSelectorFastMatcher` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6293` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `_getOrBuildSelectorPlan` (1)
- `_getOrBuildSelectorPlan` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4216` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `describeRule` (1)

### `ReturnStatement`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:346` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `_invokeFused` (2)

**Calls:**
- `isInLoop` (1)
- `isInLoop` (1)

### `_csrSegments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4270` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `nextSegments` (1)

**Calls:**
- `segment` (1)

### `(anonymous)`
`/private/tmp/prof.js:1` | Self: 0.0% (0us) | Total: 0.0% (2.3ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `bound require` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1482` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (1)

**Calls:**
- `range` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `internal:validators`
`internal:validators:2` | Self: 0.0% (0us) | Total: 0.0% (2.3ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3789` | Self: 0.0% (0us) | Total: 0.1% (9.7ms) | Samples: 0

**Called by:**
- `onCodePathEnd` (6)

**Calls:**
- `_execReport` (3)
- `_execReport` (2)
- `_execReport` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:4` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 40.3% | 3.59s | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 32.8% | 2.92s | `[native code]` |
| 17.2% | 1.53s | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 9.4% | 838.9ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js` |
| 0.0% | 3.1ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js` |
| 0.0% | 2.8ms | `/Users/ericsan/Development/OpenSource/Ez/js/api.js` |
| 0.0% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/code.js` |
| 0.0% | 1.6ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esquery/dist/esquery.min.js` |
