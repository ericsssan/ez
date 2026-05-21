# CPU Profile

| Duration | Samples | Interval | Functions |
|----------|---------|----------|----------|
| 3.92s | 2579 | 1.0ms | 305 |

**Top 10:** `parse` 19.9%, `_NodeView` 5.0%, `walkNodes` 5.0%, `walkNodes` 3.6%, `onCodePathSegmentStart` 3.5%, `walkNodes` 3.0%, `onCodePathSegmentStart` 2.7%, `markReturnStatementsOnSegmentAsUsed` 2.7%, `walkNodes` 2.4%, `_csrSegments` 2.1%

## Hot Functions (Self Time)

| Self% | Self | Total% | Total | Function | Location |
|------:|-----:|-------:|------:|----------|----------|
| 19.9% | 782.1ms | 19.9% | 782.1ms | `parse` | `[native code]` |
| 5.0% | 199.3ms | 5.0% | 199.3ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` |
| 5.0% | 198.6ms | 7.1% | 278.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7386` |
| 3.6% | 144.3ms | 6.4% | 253.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7123` |
| 3.5% | 137.9ms | 3.5% | 137.9ms | `onCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:324` |
| 3.0% | 120.0ms | 3.2% | 128.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7091` |
| 2.7% | 108.5ms | 2.7% | 108.5ms | `onCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:313` |
| 2.7% | 107.9ms | 2.7% | 107.9ms | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:189` |
| 2.4% | 95.8ms | 2.4% | 97.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7254` |
| 2.1% | 83.3ms | 2.1% | 83.3ms | `_csrSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4416` |
| 1.9% | 77.8ms | 15.4% | 607.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7119` |
| 1.8% | 70.7ms | 1.8% | 70.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6799` |
| 1.7% | 67.3ms | 2.9% | 114.1ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:157` |
| 1.7% | 67.0ms | 1.9% | 76.2ms | `filter` | `[native code]` |
| 1.6% | 65.0ms | 6.4% | 251.7ms | `forEach` | `[native code]` |
| 1.6% | 63.3ms | 1.6% | 63.3ms | `WeakSet` | `[native code]` |
| 1.6% | 63.2ms | 19.2% | 754.2ms | `_dispatchSeg` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6275` |
| 1.5% | 59.3ms | 1.5% | 59.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4095` |
| 1.3% | 52.9ms | 1.3% | 52.9ms | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1862` |
| 1.3% | 51.5ms | 3.1% | 124.7ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6114` |
| 1.2% | 49.3ms | 2.8% | 111.3ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:141` |
| 1.1% | 46.7ms | 1.1% | 46.7ms | `push` | `[native code]` |
| 1.0% | 39.2ms | 1.0% | 39.2ms | `CfgSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4520` |
| 0.9% | 36.1ms | 0.9% | 36.1ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6111` |
| 0.9% | 35.8ms | 4.2% | 166.5ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6628` |
| 0.8% | 33.5ms | 0.8% | 33.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4100` |
| 0.8% | 33.4ms | 17.2% | 674.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7313` |
| 0.8% | 32.2ms | 0.8% | 32.2ms | `defineProperty` | `[native code]` |
| 0.7% | 29.9ms | 0.7% | 29.9ms | `create` | `[native code]` |
| 0.7% | 27.9ms | 0.7% | 27.9ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.6% | 26.4ms | 0.6% | 26.4ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4480` |
| 0.6% | 25.9ms | 0.6% | 25.9ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4132` |
| 0.6% | 24.9ms | 0.6% | 26.3ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:158` |
| 0.5% | 22.6ms | 0.5% | 22.6ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4440` |
| 0.5% | 21.6ms | 0.5% | 21.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6790` |
| 0.5% | 21.3ms | 0.5% | 21.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7079` |
| 0.5% | 21.3ms | 9.9% | 391.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7113` |
| 0.5% | 20.7ms | 0.5% | 20.7ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:146` |
| 0.5% | 19.6ms | 0.5% | 19.6ms | `decode` | `[native code]` |
| 0.4% | 19.4ms | 1.4% | 56.8ms | `anonymous` | `[native code]` |
| 0.4% | 19.2ms | 0.4% | 19.2ms | `onCodePathSegmentEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:336` |
| 0.4% | 18.8ms | 8.2% | 325.0ms | `onCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:316` |
| 0.4% | 18.2ms | 0.4% | 18.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6803` |
| 0.4% | 18.2ms | 0.4% | 18.2ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6640` |
| 0.4% | 18.0ms | 5.8% | 229.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 0.4% | 17.9ms | 0.4% | 17.9ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:565` |
| 0.4% | 17.9ms | 0.4% | 17.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7081` |
| 0.4% | 17.7ms | 0.4% | 17.7ms | `onUnreachableCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:328` |
| 0.4% | 17.6ms | 0.4% | 17.6ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4587` |
| 0.4% | 17.3ms | 0.4% | 17.3ms | `onCodePathStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:270` |
| 0.3% | 15.6ms | 0.3% | 15.6ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6101` |
| 0.3% | 14.8ms | 0.3% | 14.8ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6125` |
| 0.3% | 14.0ms | 0.4% | 17.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7117` |
| 0.3% | 12.9ms | 0.3% | 12.9ms | `getUint32` | `[native code]` |
| 0.3% | 12.2ms | 0.3% | 12.2ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6123` |
| 0.3% | 12.0ms | 0.3% | 12.0ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6098` |
| 0.3% | 11.8ms | 0.3% | 11.8ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 10.9ms | 1.0% | 41.0ms | `codepath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4408` |
| 0.2% | 10.4ms | 0.2% | 10.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7255` |
| 0.2% | 10.0ms | 11.7% | 459.4ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4713` |
| 0.2% | 10.0ms | 7.2% | 284.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7316` |
| 0.2% | 9.6ms | 0.2% | 9.6ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 9.6ms | 0.6% | 25.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7289` |
| 0.2% | 8.8ms | 0.2% | 8.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:258` |
| 0.2% | 8.7ms | 0.7% | 29.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7287` |
| 0.2% | 7.9ms | 0.2% | 7.9ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4137` |
| 0.1% | 7.8ms | 0.1% | 7.8ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6118` |
| 0.1% | 7.7ms | 0.1% | 7.7ms | `onCodePathEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:280` |
| 0.1% | 7.6ms | 0.1% | 7.6ms | `onUnreachableCodePathSegmentEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:332` |
| 0.1% | 7.0ms | 0.1% | 7.0ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3656` |
| 0.1% | 6.1ms | 0.1% | 6.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7292` |
| 0.1% | 6.1ms | 0.1% | 6.1ms | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 6.1ms | 0.6% | 23.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7221` |
| 0.1% | 6.0ms | 0.1% | 6.0ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6121` |
| 0.1% | 5.8ms | 0.1% | 5.8ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4058` |
| 0.1% | 5.7ms | 0.1% | 5.7ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6636` |
| 0.1% | 5.6ms | 18.0% | 707.7ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6662` |
| 0.1% | 5.6ms | 0.1% | 5.6ms | `lhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1863` |
| 0.1% | 5.3ms | 0.1% | 6.9ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1417` |
| 0.1% | 5.2ms | 0.1% | 5.2ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4133` |
| 0.1% | 5.1ms | 0.1% | 5.1ms | `get` | `[native code]` |
| 0.1% | 5.0ms | 0.1% | 5.0ms | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:195` |
| 0.1% | 4.8ms | 0.1% | 4.8ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 4.7ms | 1.1% | 44.0ms | `segment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4402` |
| 0.1% | 4.6ms | 0.1% | 4.6ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 4.6ms | 0.1% | 4.6ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4482` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4492` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7230` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:143` |
| 0.1% | 4.2ms | 0.1% | 7.1ms | `readdirSync` | `[native code]` |
| 0.1% | 4.2ms | 0.1% | 4.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5221` |
| 0.1% | 4.2ms | 0.4% | 19.0ms | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6215` |
| 0.1% | 4.1ms | 6.4% | 251.9ms | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6251` |
| 0.1% | 4.1ms | 0.1% | 4.1ms | `_extendRangeToIncludeSemicolon` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:82` |
| 0.0% | 3.9ms | 0.0% | 3.9ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6653` |
| 0.0% | 3.8ms | 0.0% | 3.8ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4393` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:145` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4592` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7300` |
| 0.0% | 3.4ms | 6.5% | 255.1ms | `markReturnStatementsOnCurrentSegmentsAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:257` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1890` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `get label` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3247` |
| 0.0% | 3.2ms | 0.5% | 22.4ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6642` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `existsSync` | `[native code]` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `isReturned` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:114` |
| 0.0% | 3.1ms | 0.1% | 4.7ms | `initialSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4601` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4590` |
| 0.0% | 3.0ms | 0.4% | 17.6ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6655` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4455` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4591` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6143` |
| 0.0% | 3.0ms | 6.0% | 235.6ms | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6159` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 3.0ms | 0.2% | 7.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7281` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7184` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4453` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `isReturned` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js` |
| 0.0% | 2.8ms | 0.1% | 7.6ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6637` |
| 0.0% | 2.8ms | 0.1% | 4.4ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1211` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4507` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4471` |
| 0.0% | 2.8ms | 0.3% | 11.8ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6665` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6525` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1413` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4585` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4502` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_csrSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4420` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.8ms | 1.5% | 61.2ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6663` |
| 0.0% | 1.8ms | 0.4% | 18.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7291` |
| 0.0% | 1.8ms | 1.2% | 48.0ms | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:211` |
| 0.0% | 1.7ms | 0.0% | 3.5ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1507` |
| 0.0% | 1.7ms | 0.0% | 3.3ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3630` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `onCodePathStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:269` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4391` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `entries` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 3.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7277` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `encodeInto` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.6% | 26.1ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6664` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4494` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:570` |
| 0.0% | 1.6ms | 1.6% | 63.5ms | `nextSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4546` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3587` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6652` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `Set` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1552` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4449` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `RegExp` | `[native code]` |
| 0.0% | 1.5ms | 0.7% | 30.1ms | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1889` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4472` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:550` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6112` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `isInFinally` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:53` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7075` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4825` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get start` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4485` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `isReturned` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:112` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:429` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `remove` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:28` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4123` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `map` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:465` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7280` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4051` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `dlopen` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4439` |
| 0.0% | 1.4ms | 0.2% | 11.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7286` |
| 0.0% | 1.4ms | 0.1% | 4.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7229` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `Uint8Array` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6523` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `fetch` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1191` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_extendRangeToIncludeSemicolon` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:112` |
| 0.0% | 1.3ms | 3.4% | 134.9ms | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:341` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_getSharedCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:726` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4700` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7295` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `slotTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5951` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:147` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6631` |
| 0.0% | 1.2ms | 0.4% | 18.8ms | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6361` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3932` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1525` |
| 0.0% | 1.1ms | 0.0% | 1.1ms | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:188` |

## Call Tree (Total Time)

| Total% | Total | Self% | Self | Function | Location |
|-------:|------:|------:|-----:|----------|----------|
| 78.9% | 3.09s | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:274` |
| 78.2% | 3.06s | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7602` |
| 20.1% | 792.1ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` |
| 19.9% | 782.1ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` |
| 19.9% | 782.1ms | 19.9% | 782.1ms | `parse` | `[native code]` |
| 19.2% | 754.2ms | 1.6% | 63.2ms | `_dispatchSeg` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6275` |
| 18.0% | 707.7ms | 0.1% | 5.6ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6662` |
| 17.2% | 674.8ms | 0.8% | 33.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7313` |
| 15.4% | 607.1ms | 1.9% | 77.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7119` |
| 11.7% | 459.4ms | 0.2% | 10.0ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4713` |
| 9.9% | 391.1ms | 0.5% | 21.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7113` |
| 8.2% | 325.0ms | 0.4% | 18.8ms | `onCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:316` |
| 7.2% | 284.0ms | 0.2% | 10.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7316` |
| 7.1% | 278.8ms | 5.0% | 198.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7386` |
| 6.5% | 255.1ms | 0.0% | 3.4ms | `markReturnStatementsOnCurrentSegmentsAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:257` |
| 6.4% | 253.6ms | 3.6% | 144.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7123` |
| 6.4% | 251.9ms | 0.1% | 4.1ms | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6251` |
| 6.4% | 251.7ms | 1.6% | 65.0ms | `forEach` | `[native code]` |
| 6.0% | 235.6ms | 0.0% | 3.0ms | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6159` |
| 5.8% | 229.3ms | 0.4% | 18.0ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` |
| 5.0% | 199.3ms | 5.0% | 199.3ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` |
| 4.2% | 166.5ms | 0.9% | 35.8ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6628` |
| 3.5% | 137.9ms | 3.5% | 137.9ms | `onCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:324` |
| 3.4% | 134.9ms | 0.0% | 1.3ms | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:341` |
| 3.2% | 128.1ms | 3.0% | 120.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7091` |
| 3.1% | 124.7ms | 1.3% | 51.5ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6114` |
| 2.9% | 114.1ms | 1.7% | 67.3ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:157` |
| 2.8% | 111.3ms | 1.2% | 49.3ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:141` |
| 2.7% | 108.5ms | 2.7% | 108.5ms | `onCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:313` |
| 2.7% | 107.9ms | 2.7% | 107.9ms | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:189` |
| 2.4% | 97.3ms | 2.4% | 95.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7254` |
| 2.1% | 85.1ms | 0.0% | 0us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6671` |
| 2.1% | 83.3ms | 2.1% | 83.3ms | `_csrSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4416` |
| 1.9% | 76.2ms | 1.7% | 67.0ms | `filter` | `[native code]` |
| 1.9% | 74.8ms | 0.0% | 0us | `allPrevSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4569` |
| 1.9% | 74.8ms | 0.0% | 0us | `onCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:318` |
| 1.8% | 70.7ms | 1.8% | 70.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6799` |
| 1.6% | 63.5ms | 0.0% | 1.6ms | `nextSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4546` |
| 1.6% | 63.3ms | 1.6% | 63.3ms | `WeakSet` | `[native code]` |
| 1.5% | 61.2ms | 0.0% | 1.8ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6663` |
| 1.5% | 59.3ms | 1.5% | 59.3ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4095` |
| 1.4% | 56.8ms | 0.4% | 19.4ms | `anonymous` | `[native code]` |
| 1.3% | 52.9ms | 1.3% | 52.9ms | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1862` |
| 1.3% | 52.6ms | 0.0% | 0us | `bound require` | `[native code]` |
| 1.2% | 49.9ms | 0.0% | 0us | `require` | `[native code]` |
| 1.2% | 48.0ms | 0.0% | 1.8ms | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:211` |
| 1.1% | 46.8ms | 0.0% | 0us | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:345` |
| 1.1% | 46.7ms | 1.1% | 46.7ms | `push` | `[native code]` |
| 1.1% | 46.1ms | 0.0% | 0us | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:342` |
| 1.1% | 44.0ms | 0.1% | 4.7ms | `segment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4402` |
| 1.0% | 41.0ms | 0.0% | 0us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6634` |
| 1.0% | 41.0ms | 0.2% | 10.9ms | `codepath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4408` |
| 1.0% | 39.2ms | 1.0% | 39.2ms | `CfgSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4520` |
| 0.9% | 36.1ms | 0.9% | 36.1ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6111` |
| 0.8% | 33.5ms | 0.8% | 33.5ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4100` |
| 0.8% | 32.2ms | 0.8% | 32.2ms | `defineProperty` | `[native code]` |
| 0.7% | 30.1ms | 0.0% | 1.5ms | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1889` |
| 0.7% | 29.9ms | 0.7% | 29.9ms | `create` | `[native code]` |
| 0.7% | 29.0ms | 0.2% | 8.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7287` |
| 0.7% | 27.9ms | 0.7% | 27.9ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.6% | 26.4ms | 0.6% | 26.4ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4480` |
| 0.6% | 26.3ms | 0.6% | 24.9ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:158` |
| 0.6% | 26.1ms | 0.0% | 1.7ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6664` |
| 0.6% | 25.9ms | 0.6% | 25.9ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4132` |
| 0.6% | 25.0ms | 0.2% | 9.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7289` |
| 0.6% | 24.4ms | 0.0% | 0us | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:149` |
| 0.6% | 23.6ms | 0.1% | 6.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7221` |
| 0.5% | 22.6ms | 0.5% | 22.6ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4440` |
| 0.5% | 22.5ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7594` |
| 0.5% | 22.4ms | 0.0% | 3.2ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6642` |
| 0.5% | 21.6ms | 0.5% | 21.6ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6790` |
| 0.5% | 21.3ms | 0.5% | 21.3ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7079` |
| 0.5% | 20.7ms | 0.5% | 20.7ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:146` |
| 0.5% | 19.8ms | 0.0% | 0us | `get nextSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4546` |
| 0.5% | 19.7ms | 0.0% | 0us | `async (anonymous)` | `[native code]` |
| 0.5% | 19.6ms | 0.0% | 0us | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` |
| 0.5% | 19.6ms | 0.5% | 19.6ms | `decode` | `[native code]` |
| 0.4% | 19.2ms | 0.4% | 19.2ms | `onCodePathSegmentEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:336` |
| 0.4% | 19.0ms | 0.1% | 4.2ms | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6215` |
| 0.4% | 18.8ms | 0.0% | 1.2ms | `invokeMethodFnHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6361` |
| 0.4% | 18.6ms | 0.0% | 1.8ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7291` |
| 0.4% | 18.2ms | 0.4% | 18.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6803` |
| 0.4% | 18.2ms | 0.4% | 18.2ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6640` |
| 0.4% | 17.9ms | 0.4% | 17.9ms | `nodeLhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:565` |
| 0.4% | 17.9ms | 0.4% | 17.9ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7081` |
| 0.4% | 17.7ms | 0.4% | 17.7ms | `onUnreachableCodePathSegmentStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:328` |
| 0.4% | 17.6ms | 0.4% | 17.6ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4587` |
| 0.4% | 17.6ms | 0.0% | 3.0ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6655` |
| 0.4% | 17.3ms | 0.4% | 17.3ms | `onCodePathStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:270` |
| 0.4% | 17.2ms | 0.3% | 14.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7117` |
| 0.4% | 16.9ms | 0.0% | 0us | `parseModule` | `[native code]` |
| 0.3% | 15.6ms | 0.3% | 15.6ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6101` |
| 0.3% | 14.8ms | 0.3% | 14.8ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6125` |
| 0.3% | 12.9ms | 0.3% | 12.9ms | `getUint32` | `[native code]` |
| 0.3% | 12.9ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:25` |
| 0.3% | 12.2ms | 0.3% | 12.2ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6123` |
| 0.3% | 12.0ms | 0.3% | 12.0ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6098` |
| 0.3% | 11.8ms | 0.3% | 11.8ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.3% | 11.8ms | 0.0% | 2.8ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6665` |
| 0.2% | 11.1ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7286` |
| 0.2% | 11.0ms | 0.0% | 0us | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:191` |
| 0.2% | 10.4ms | 0.2% | 10.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7255` |
| 0.2% | 10.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` |
| 0.2% | 9.6ms | 0.2% | 9.6ms | `_resolveHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.2% | 9.0ms | 0.0% | 0us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6639` |
| 0.2% | 9.0ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7078` |
| 0.2% | 8.9ms | 0.0% | 0us | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:347` |
| 0.2% | 8.8ms | 0.2% | 8.8ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:258` |
| 0.2% | 8.7ms | 0.0% | 0us | `allPrevSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4567` |
| 0.2% | 8.2ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` |
| 0.2% | 7.9ms | 0.2% | 7.9ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4137` |
| 0.2% | 7.8ms | 0.0% | 3.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7281` |
| 0.1% | 7.8ms | 0.1% | 7.8ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6118` |
| 0.1% | 7.7ms | 0.1% | 7.7ms | `onCodePathEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:280` |
| 0.1% | 7.6ms | 0.0% | 2.8ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6637` |
| 0.1% | 7.6ms | 0.1% | 7.6ms | `onUnreachableCodePathSegmentEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:332` |
| 0.1% | 7.4ms | 0.0% | 0us | `isInFinally` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:49` |
| 0.1% | 7.3ms | 0.0% | 0us | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6160` |
| 0.1% | 7.1ms | 0.1% | 4.2ms | `readdirSync` | `[native code]` |
| 0.1% | 7.1ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:135` |
| 0.1% | 7.1ms | 0.0% | 0us | `patchAstUtils` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:435` |
| 0.1% | 7.1ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:477` |
| 0.1% | 7.0ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1516` |
| 0.1% | 7.0ms | 0.1% | 7.0ms | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3656` |
| 0.1% | 6.9ms | 0.1% | 5.3ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1417` |
| 0.1% | 6.6ms | 0.0% | 0us | `runPlugins` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7601` |
| 0.1% | 6.1ms | 0.1% | 6.1ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7292` |
| 0.1% | 6.1ms | 0.1% | 6.1ms | `invokeSelectorHandlers` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 6.0ms | 0.1% | 6.0ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6121` |
| 0.1% | 5.8ms | 0.1% | 5.8ms | `_NodeView_LR` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4058` |
| 0.1% | 5.7ms | 0.1% | 5.7ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6636` |
| 0.1% | 5.6ms | 0.1% | 5.6ms | `lhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1863` |
| 0.1% | 5.5ms | 0.0% | 0us | `get loc` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3647` |
| 0.1% | 5.5ms | 0.0% | 0us | `onCodePathEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:283` |
| 0.1% | 5.2ms | 0.1% | 5.2ms | `nodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4133` |
| 0.1% | 5.1ms | 0.1% | 5.1ms | `get` | `[native code]` |
| 0.1% | 5.0ms | 0.1% | 5.0ms | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:195` |
| 0.1% | 4.9ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7167` |
| 0.1% | 4.9ms | 0.0% | 0us | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1515` |
| 0.1% | 4.8ms | 0.1% | 4.8ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.1% | 4.7ms | 0.0% | 3.1ms | `initialSegment` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4601` |
| 0.1% | 4.6ms | 0.1% | 4.6ms | `_NodeView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.1% | 4.6ms | 0.1% | 4.6ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4482` |
| 0.1% | 4.6ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7282` |
| 0.1% | 4.5ms | 0.1% | 4.5ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4492` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7230` |
| 0.1% | 4.4ms | 0.0% | 2.8ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1211` |
| 0.1% | 4.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7229` |
| 0.1% | 4.4ms | 0.1% | 4.4ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:143` |
| 0.1% | 4.2ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:47` |
| 0.1% | 4.2ms | 0.0% | 0us | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5259` |
| 0.1% | 4.2ms | 0.1% | 4.2ms | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5221` |
| 0.1% | 4.1ms | 0.1% | 4.1ms | `_extendRangeToIncludeSemicolon` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:82` |
| 0.0% | 3.9ms | 0.0% | 3.9ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6653` |
| 0.0% | 3.8ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:478` |
| 0.0% | 3.8ms | 0.0% | 3.8ms | `CfgGraph` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4393` |
| 0.0% | 3.5ms | 0.0% | 1.7ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1507` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:145` |
| 0.0% | 3.5ms | 0.0% | 3.5ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4592` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7300` |
| 0.0% | 3.4ms | 0.0% | 0us | `ReturnStatement` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:355` |
| 0.0% | 3.4ms | 0.0% | 3.4ms | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1890` |
| 0.0% | 3.3ms | 0.0% | 1.7ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7277` |
| 0.0% | 3.3ms | 0.0% | 3.3ms | `get label` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3247` |
| 0.0% | 3.3ms | 0.0% | 1.7ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3630` |
| 0.0% | 3.2ms | 0.0% | 0us | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:192` |
| 0.0% | 3.2ms | 0.0% | 0us | `existsSync` | `node:fs:273` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `existsSync` | `[native code]` |
| 0.0% | 3.2ms | 0.0% | 0us | `async _resolveConfig` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:70` |
| 0.0% | 3.2ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:75` |
| 0.0% | 3.2ms | 0.0% | 0us | `async _resolveConfig` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:67` |
| 0.0% | 3.2ms | 0.0% | 0us | `async lintSource` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:350` |
| 0.0% | 3.2ms | 0.0% | 0us | `async lintSource` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:349` |
| 0.0% | 3.2ms | 0.0% | 3.2ms | `isReturned` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:114` |
| 0.0% | 3.1ms | 0.0% | 3.1ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4590` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4455` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` |
| 0.0% | 3.0ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `fn` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6143` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4591` |
| 0.0% | 3.0ms | 0.0% | 0us | `esquery` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:53` |
| 0.0% | 3.0ms | 0.0% | 0us | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4398` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 3.0ms | 0.0% | 3.0ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7184` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4453` |
| 0.0% | 2.9ms | 0.0% | 2.9ms | `isReturned` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4507` |
| 0.0% | 2.8ms | 0.0% | 0us | `(anonymous)` | `[native code]` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4471` |
| 0.0% | 2.8ms | 0.0% | 2.8ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6525` |
| 0.0% | 2.7ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6682` |
| 0.0% | 2.7ms | 0.0% | 0us | `_getOrBuildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5612` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1413` |
| 0.0% | 2.7ms | 0.0% | 2.7ms | `CfgCodePath` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4585` |
| 0.0% | 2.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` |
| 0.0% | 2.5ms | 0.0% | 2.5ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4502` |
| 0.0% | 2.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:11` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `_csrSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4420` |
| 0.0% | 1.8ms | 0.0% | 1.8ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `onCodePathStart` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:269` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `buildVisitorMap` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4391` |
| 0.0% | 1.7ms | 0.0% | 0us | `_csrSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4419` |
| 0.0% | 1.7ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:116` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `entries` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `parseSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:220` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `encodeInto` | `[native code]` |
| 0.0% | 1.7ms | 0.0% | 0us | `_encodeSource` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` |
| 0.0% | 1.7ms | 0.0% | 1.7ms | `_runSelectorList` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 0.0% | 1.7ms | 0.0% | 0us | `nextSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4547` |
| 0.0% | 1.6ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7294` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4494` |
| 0.0% | 1.6ms | 0.0% | 0us | `prevSegments` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4552` |
| 0.0% | 1.6ms | 0.0% | 0us | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6669` |
| 0.0% | 1.6ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7278` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `nodeRhs` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:570` |
| 0.0% | 1.6ms | 0.0% | 0us | `get label` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3256` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` |
| 0.0% | 1.6ms | 0.0% | 0us | `_rawTokenText` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:818` |
| 0.0% | 1.6ms | 0.0% | 0us | `async _loadFlatConfig` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:42` |
| 0.0% | 1.6ms | 0.0% | 0us | `async _loadFlatConfig` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:36` |
| 0.0% | 1.6ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:38` |
| 0.0% | 1.6ms | 0.0% | 0us | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:81` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get range` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3587` |
| 0.0% | 1.6ms | 0.0% | 0us | `RuleSkipSet` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4935` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6652` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `Set` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6812` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1552` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4449` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:49` |
| 0.0% | 1.6ms | 0.0% | 1.6ms | `RegExp` | `[native code]` |
| 0.0% | 1.6ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:4` |
| 0.0% | 1.5ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:42` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4472` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get source` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:550` |
| 0.0% | 1.5ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:31` |
| 0.0% | 1.5ms | 0.0% | 0us | `async (anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:34` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `async _resolveConfigImpl` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js` |
| 0.0% | 1.5ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:43` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6112` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `isInFinally` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:53` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7075` |
| 0.0% | 1.5ms | 0.0% | 0us | `getAncestorsFor` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6119` |
| 0.0% | 1.5ms | 0.0% | 0us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5935` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `get start` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_extractBatchScannable` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4825` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4485` |
| 0.0% | 1.5ms | 0.0% | 1.5ms | `isReturned` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:112` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:429` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `remove` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:28` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:239` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_nodeViewRaw` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4123` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `map` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:279` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:465` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7280` |
| 0.0% | 1.4ms | 0.0% | 0us | `node:fs` | `node:fs:2` |
| 0.0% | 1.4ms | 0.0% | 0us | `node:fs/promises` | `node:fs/promises:2` |
| 0.0% | 1.4ms | 0.0% | 0us | `internal:fs/glob` | `internal:fs/glob:2` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_NodeView_LRN` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4051` |
| 0.0% | 1.4ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:15` |
| 0.0% | 1.4ms | 0.0% | 0us | `getTagNames` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:191` |
| 0.0% | 1.4ms | 0.0% | 0us | `_lintSourceOne` | `/Users/ericsan/Development/OpenSource/Ez/js/api.js:267` |
| 0.0% | 1.4ms | 0.0% | 0us | `loadBinding` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `dlopen` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4439` |
| 0.0% | 1.4ms | 0.0% | 0us | `AstView` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:405` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `Uint8Array` | `[native code]` |
| 0.0% | 1.4ms | 0.0% | 1.4ms | `getDFSEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6523` |
| 0.0% | 1.3ms | 0.0% | 0us | `requestFetch` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `fetch` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `requestSatisfyUtil` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 0us | `requestInstantiate` | `[native code]` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get parent` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1191` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_extendRangeToIncludeSemicolon` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:112` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `get argument` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_ensureNextAdjacency` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 0.0% | 1.3ms | 0.0% | 0us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4044` |
| 0.0% | 1.3ms | 0.0% | 0us | `reset` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1078` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_getSharedCaches` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:726` |
| 0.0% | 1.3ms | 0.0% | 1.3ms | `_invokeFused` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4700` |
| 0.0% | 1.2ms | 0.0% | 0us | `loadCoreRules` | `/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:54` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` |
| 0.0% | 1.2ms | 0.0% | 0us | `_getFfiSelector` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:109` |
| 0.0% | 1.2ms | 0.0% | 0us | `_getOrBuildSelectorPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5490` |
| 0.0% | 1.2ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6458` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7295` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js` |
| 0.0% | 1.2ms | 0.0% | 0us | `_buildTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5963` |
| 0.0% | 1.2ms | 0.0% | 0us | `_buildPlan` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5941` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `slotTemplate` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5951` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `getUselessReturns` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:147` |
| 0.0% | 1.2ms | 0.0% | 0us | `(anonymous)` | `/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` |
| 0.0% | 1.2ms | 0.0% | 0us | `walkNodes` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7385` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_fireCfgEvents` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6631` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `_execReport` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3932` |
| 0.0% | 1.2ms | 0.0% | 0us | `report` | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3946` |
| 0.0% | 1.2ms | 0.0% | 0us | `onCodePathEnd` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:281` |
| 0.0% | 1.2ms | 0.0% | 1.2ms | `get value` | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1525` |
| 0.0% | 1.1ms | 0.0% | 1.1ms | `markReturnStatementsOnSegmentAsUsed` | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:188` |

## Function Details

### `parse`
`[native code]` | Self: 19.9% (782.1ms) | Total: 19.9% (782.1ms) | Samples: 511

**Called by:**
- `parseSource` (511)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4027` | Self: 5.0% (199.3ms) | Total: 5.0% (199.3ms) | Samples: 131

**Called by:**
- `_nodeViewRaw` (131)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7386` | Self: 5.0% (198.6ms) | Total: 7.1% (278.8ms) | Samples: 132

**Called by:**
- `runPlugins` (186)

**Calls:**
- `_fireCfgEvents` (12)
- `_fireCfgEvents` (12)
- `_fireCfgEvents` (11)
- `_fireCfgEvents` (8)
- `_fireCfgEvents` (3)
- `_fireCfgEvents` (3)
- `_fireCfgEvents` (2)
- `_fireCfgEvents` (2)
- `_fireCfgEvents` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7123` | Self: 3.6% (144.3ms) | Total: 6.4% (253.6ms) | Samples: 97

**Called by:**
- `runPlugins` (168)

**Calls:**
- `_fireCfgEvents` (65)
- `_fireCfgEvents` (2)
- `_fireCfgEvents` (2)
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)

### `onCodePathSegmentStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:324` | Self: 3.5% (137.9ms) | Total: 3.5% (137.9ms) | Samples: 88

**Called by:**
- `_dispatchSeg` (88)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7091` | Self: 3.0% (120.0ms) | Total: 3.2% (128.1ms) | Samples: 80

**Called by:**
- `runPlugins` (85)

**Calls:**
- `_resolveHandlers` (5)

### `onCodePathSegmentStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:313` | Self: 2.7% (108.5ms) | Total: 2.7% (108.5ms) | Samples: 70

**Called by:**
- `_dispatchSeg` (70)

### `markReturnStatementsOnSegmentAsUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:189` | Self: 2.7% (107.9ms) | Total: 2.7% (107.9ms) | Samples: 72

**Called by:**
- `forEach` (72)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7254` | Self: 2.4% (95.8ms) | Total: 2.4% (97.3ms) | Samples: 63

**Called by:**
- `runPlugins` (64)

**Calls:**
- `_resolveHandlers` (1)

### `_csrSegments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4416` | Self: 2.1% (83.3ms) | Total: 2.1% (83.3ms) | Samples: 57

**Called by:**
- `allPrevSegments` (49)
- `allPrevSegments` (6)
- `nextSegments` (1)
- `prevSegments` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7119` | Self: 1.9% (77.8ms) | Total: 15.4% (607.1ms) | Samples: 52

**Called by:**
- `runPlugins` (402)

**Calls:**
- `_invokeFused` (305)
- `_nodeViewRaw` (32)
- `_nodeViewRaw` (6)
- `_nodeViewRaw` (4)
- `nodeView` (2)
- `_invokeFused` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6799` | Self: 1.8% (70.7ms) | Total: 1.8% (70.7ms) | Samples: 46

**Called by:**
- `runPlugins` (46)

### `getUselessReturns`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:157` | Self: 1.7% (67.3ms) | Total: 2.9% (114.1ms) | Samples: 45

**Called by:**
- `onCodePathSegmentStart` (76)

**Calls:**
- `push` (31)

### `filter`
`[native code]` | Self: 1.7% (67.0ms) | Total: 1.9% (76.2ms) | Samples: 43

**Called by:**
- `markReturnStatementsOnSegmentAsUsed` (30)
- `getUselessReturns` (10)
- `markReturnStatementsOnSegmentAsUsed` (7)
- `markReturnStatementsOnSegmentAsUsed` (2)

**Calls:**
- `isReturned` (2)
- `isReturned` (2)
- `(anonymous)` (1)
- `isReturned` (1)

### `forEach`
`[native code]` | Self: 1.6% (65.0ms) | Total: 6.4% (251.7ms) | Samples: 44

**Called by:**
- `markReturnStatementsOnCurrentSegmentsAsUsed` (167)

**Calls:**
- `markReturnStatementsOnSegmentAsUsed` (72)
- `markReturnStatementsOnSegmentAsUsed` (31)
- `markReturnStatementsOnSegmentAsUsed` (7)
- `(anonymous)` (6)
- `markReturnStatementsOnSegmentAsUsed` (3)
- `markReturnStatementsOnSegmentAsUsed` (2)
- `markReturnStatementsOnSegmentAsUsed` (1)
- `markReturnStatementsOnSegmentAsUsed` (1)

### `WeakSet`
`[native code]` | Self: 1.6% (63.3ms) | Total: 1.6% (63.3ms) | Samples: 43

**Called by:**
- `getUselessReturns` (42)
- `getUselessReturns` (1)

### `_dispatchSeg`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6275` | Self: 1.6% (63.2ms) | Total: 19.2% (754.2ms) | Samples: 42

**Called by:**
- `_fireCfgEvents` (438)
- `_fireCfgEvents` (40)
- `_fireCfgEvents` (13)
- `_fireCfgEvents` (6)

**Calls:**
- `onCodePathSegmentStart` (216)
- `onCodePathSegmentStart` (88)
- `onCodePathSegmentStart` (70)
- `onCodePathSegmentStart` (51)
- `onCodePathSegmentEnd` (13)
- `onUnreachableCodePathSegmentStart` (12)
- `onUnreachableCodePathSegmentEnd` (5)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4095` | Self: 1.5% (59.3ms) | Total: 1.5% (59.3ms) | Samples: 38

**Called by:**
- `getAncestorsFor` (13)
- `_fireCfgEvents` (10)
- `walkNodes` (6)
- `invokeSelectorHandlers` (5)
- `ReturnStatement` (3)
- `ReturnStatement` (1)

### `get argument`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1862` | Self: 1.3% (52.9ms) | Total: 1.3% (52.9ms) | Samples: 35

**Called by:**
- `ReturnStatement` (21)
- `ReturnStatement` (14)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6114` | Self: 1.3% (51.5ms) | Total: 3.1% (124.7ms) | Samples: 34

**Called by:**
- `_runSelectorList` (81)

**Calls:**
- `_nodeViewRaw` (13)
- `nodeView` (11)
- `nodeView` (9)
- `_nodeViewRaw` (9)
- `_nodeViewRaw` (3)
- `nodeView` (1)
- `nodeView` (1)

### `getUselessReturns`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:141` | Self: 1.2% (49.3ms) | Total: 2.8% (111.3ms) | Samples: 32

**Called by:**
- `onCodePathSegmentStart` (74)

**Calls:**
- `WeakSet` (42)

### `push`
`[native code]` | Self: 1.1% (46.7ms) | Total: 1.1% (46.7ms) | Samples: 31

**Called by:**
- `getUselessReturns` (31)

### `CfgSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4520` | Self: 1.0% (39.2ms) | Total: 1.0% (39.2ms) | Samples: 26

**Called by:**
- `segment` (26)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6111` | Self: 0.9% (36.1ms) | Total: 0.9% (36.1ms) | Samples: 24

**Called by:**
- `_runSelectorList` (24)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6628` | Self: 0.9% (35.8ms) | Total: 4.2% (166.5ms) | Samples: 24

**Called by:**
- `walkNodes` (70)
- `walkNodes` (30)
- `walkNodes` (8)
- `walkNodes` (2)

**Calls:**
- `_nodeViewRaw` (62)
- `_nodeViewRaw` (10)
- `nodeView` (8)
- `_nodeViewRaw` (4)
- `nodeView` (1)
- `_nodeViewRaw` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4100` | Self: 0.8% (33.5ms) | Total: 0.8% (33.5ms) | Samples: 22

**Called by:**
- `getAncestorsFor` (9)
- `_fireCfgEvents` (4)
- `walkNodes` (4)
- `walkNodes` (2)
- `walkNodes` (1)
- `invokeSelectorHandlers` (1)
- `ReturnStatement` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7313` | Self: 0.8% (33.4ms) | Total: 17.2% (674.8ms) | Samples: 21

**Called by:**
- `runPlugins` (444)

**Calls:**
- `_fireCfgEvents` (261)
- `_fireCfgEvents` (70)
- `_fireCfgEvents` (56)
- `_fireCfgEvents` (20)
- `_fireCfgEvents` (5)
- `_fireCfgEvents` (5)
- `_fireCfgEvents` (4)
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)

### `defineProperty`
`[native code]` | Self: 0.8% (32.2ms) | Total: 0.8% (32.2ms) | Samples: 21

**Called by:**
- `walkNodes` (11)
- `walkNodes` (10)

### `create`
`[native code]` | Self: 0.7% (29.9ms) | Total: 0.7% (29.9ms) | Samples: 19

**Called by:**
- `walkNodes` (13)
- `walkNodes` (6)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.7% (27.9ms) | Total: 0.7% (27.9ms) | Samples: 18

**Called by:**
- `getAncestorsFor` (9)
- `_fireCfgEvents` (8)
- `get parent` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4480` | Self: 0.6% (26.4ms) | Total: 0.6% (26.4ms) | Samples: 17

**Called by:**
- `nextSegments` (17)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4132` | Self: 0.6% (25.9ms) | Total: 0.6% (25.9ms) | Samples: 16

**Called by:**
- `getAncestorsFor` (11)
- `ReturnStatement` (4)
- `ReturnStatement` (1)

### `getUselessReturns`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:158` | Self: 0.6% (24.9ms) | Total: 0.6% (26.3ms) | Samples: 16

**Called by:**
- `onCodePathSegmentStart` (17)

**Calls:**
- `WeakSet` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4440` | Self: 0.5% (22.6ms) | Total: 0.5% (22.6ms) | Samples: 15

**Called by:**
- `nextSegments` (15)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6790` | Self: 0.5% (21.6ms) | Total: 0.5% (21.6ms) | Samples: 14

**Called by:**
- `runPlugins` (14)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7079` | Self: 0.5% (21.3ms) | Total: 0.5% (21.3ms) | Samples: 14

**Called by:**
- `runPlugins` (14)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7113` | Self: 0.5% (21.3ms) | Total: 9.9% (391.1ms) | Samples: 14

**Called by:**
- `runPlugins` (258)

**Calls:**
- `_fireCfgEvents` (137)
- `_fireCfgEvents` (30)
- `_fireCfgEvents` (27)
- `_fireCfgEvents` (15)
- `_fireCfgEvents` (11)
- `_fireCfgEvents` (9)
- `_fireCfgEvents` (6)
- `_fireCfgEvents` (3)
- `_fireCfgEvents` (2)
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)
- `_fireCfgEvents` (1)

### `getUselessReturns`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:146` | Self: 0.5% (20.7ms) | Total: 0.5% (20.7ms) | Samples: 14

**Called by:**
- `onCodePathSegmentStart` (14)

### `decode`
`[native code]` | Self: 0.5% (19.6ms) | Total: 0.5% (19.6ms) | Samples: 12

**Called by:**
- `get source` (12)

### `anonymous`
`[native code]` | Self: 0.4% (19.4ms) | Total: 1.4% (56.8ms) | Samples: 14

**Called by:**
- `require` (35)
- `bound require` (2)
- `internal:fs/glob` (1)
- `node:fs` (1)
- `node:fs/promises` (1)

**Calls:**
- `(anonymous)` (7)
- `(anonymous)` (5)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `node:fs` (1)
- `node:fs/promises` (1)
- `internal:fs/glob` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)

### `onCodePathSegmentEnd`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:336` | Self: 0.4% (19.2ms) | Total: 0.4% (19.2ms) | Samples: 13

**Called by:**
- `_dispatchSeg` (13)

### `onCodePathSegmentStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:316` | Self: 0.4% (18.8ms) | Total: 8.2% (325.0ms) | Samples: 13

**Called by:**
- `_dispatchSeg` (216)

**Calls:**
- `getUselessReturns` (76)
- `getUselessReturns` (74)
- `getUselessReturns` (17)
- `getUselessReturns` (16)
- `getUselessReturns` (14)
- `getUselessReturns` (3)
- `getUselessReturns` (2)
- `getUselessReturns` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6803` | Self: 0.4% (18.2ms) | Total: 0.4% (18.2ms) | Samples: 12

**Called by:**
- `runPlugins` (12)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6640` | Self: 0.4% (18.2ms) | Total: 0.4% (18.2ms) | Samples: 11

**Called by:**
- `walkNodes` (11)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4105` | Self: 0.4% (18.0ms) | Total: 5.8% (229.3ms) | Samples: 12

**Called by:**
- `_fireCfgEvents` (62)
- `ReturnStatement` (51)
- `walkNodes` (32)
- `getAncestorsFor` (3)
- `walkNodes` (1)
- `walkNodes` (1)
- `invokeSelectorHandlers` (1)

**Calls:**
- `_NodeView` (131)
- `_NodeView_LR` (4)
- `_NodeView` (3)
- `_NodeView_LRN` (1)

### `nodeLhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:565` | Self: 0.4% (17.9ms) | Total: 0.4% (17.9ms) | Samples: 12

**Called by:**
- `get argument` (9)
- `walkNodes` (1)
- `walkNodes` (1)
- `get label` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7081` | Self: 0.4% (17.9ms) | Total: 0.4% (17.9ms) | Samples: 12

**Called by:**
- `runPlugins` (12)

### `onUnreachableCodePathSegmentStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:328` | Self: 0.4% (17.7ms) | Total: 0.4% (17.7ms) | Samples: 12

**Called by:**
- `_dispatchSeg` (12)

### `CfgCodePath`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4587` | Self: 0.4% (17.6ms) | Total: 0.4% (17.6ms) | Samples: 12

**Called by:**
- `codepath` (12)

### `onCodePathStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:270` | Self: 0.4% (17.3ms) | Total: 0.4% (17.3ms) | Samples: 12

**Called by:**
- `_fireCfgEvents` (12)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6101` | Self: 0.3% (15.6ms) | Total: 0.3% (15.6ms) | Samples: 10

**Called by:**
- `_runSelectorList` (10)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6125` | Self: 0.3% (14.8ms) | Total: 0.3% (14.8ms) | Samples: 10

**Called by:**
- `_runSelectorList` (10)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7117` | Self: 0.3% (14.0ms) | Total: 0.4% (17.2ms) | Samples: 9

**Called by:**
- `runPlugins` (11)

**Calls:**
- `invokeSelectorHandlers` (2)

### `getUint32`
`[native code]` | Self: 0.3% (12.9ms) | Total: 0.3% (12.9ms) | Samples: 9

**Called by:**
- `get argument` (7)
- `walkNodes` (1)
- `get value` (1)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6123` | Self: 0.3% (12.2ms) | Total: 0.3% (12.2ms) | Samples: 8

**Called by:**
- `_runSelectorList` (8)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6098` | Self: 0.3% (12.0ms) | Total: 0.3% (12.0ms) | Samples: 8

**Called by:**
- `_runSelectorList` (8)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.3% (11.8ms) | Total: 0.3% (11.8ms) | Samples: 8

**Called by:**
- `walkNodes` (4)
- `walkNodes` (2)
- `walkNodes` (1)
- `walkNodes` (1)

### `codepath`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4408` | Self: 0.2% (10.9ms) | Total: 1.0% (41.0ms) | Samples: 7

**Called by:**
- `_fireCfgEvents` (27)

**Calls:**
- `CfgCodePath` (12)
- `CfgCodePath` (2)
- `CfgCodePath` (2)
- `CfgCodePath` (2)
- `CfgCodePath` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7255` | Self: 0.2% (10.4ms) | Total: 0.2% (10.4ms) | Samples: 7

**Called by:**
- `runPlugins` (7)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4713` | Self: 0.2% (10.0ms) | Total: 11.7% (459.4ms) | Samples: 7

**Called by:**
- `walkNodes` (305)

**Calls:**
- `markReturnStatementsOnCurrentSegmentsAsUsed` (138)
- `ReturnStatement` (90)
- `ReturnStatement` (31)
- `ReturnStatement` (31)
- `ReturnStatement` (6)
- `ReturnStatement` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7316` | Self: 0.2% (10.0ms) | Total: 7.2% (284.0ms) | Samples: 6

**Called by:**
- `runPlugins` (185)

**Calls:**
- `invokeSelectorHandlers` (165)
- `invokeSelectorHandlers` (12)
- `invokeSelectorHandlers` (2)

### `_resolveHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.2% (9.6ms) | Total: 0.2% (9.6ms) | Samples: 6

**Called by:**
- `walkNodes` (5)
- `walkNodes` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7289` | Self: 0.2% (9.6ms) | Total: 0.6% (25.0ms) | Samples: 6

**Called by:**
- `runPlugins` (16)

**Calls:**
- `defineProperty` (10)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:258` | Self: 0.2% (8.8ms) | Total: 0.2% (8.8ms) | Samples: 6

**Called by:**
- `forEach` (6)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7287` | Self: 0.2% (8.7ms) | Total: 0.7% (29.0ms) | Samples: 6

**Called by:**
- `runPlugins` (19)

**Calls:**
- `create` (13)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4137` | Self: 0.2% (7.9ms) | Total: 0.2% (7.9ms) | Samples: 5

**Called by:**
- `walkNodes` (2)
- `_fireCfgEvents` (1)
- `walkNodes` (1)
- `getAncestorsFor` (1)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6118` | Self: 0.1% (7.8ms) | Total: 0.1% (7.8ms) | Samples: 5

**Called by:**
- `_runSelectorList` (5)

### `onCodePathEnd`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:280` | Self: 0.1% (7.7ms) | Total: 0.1% (7.7ms) | Samples: 5

**Called by:**
- `_fireCfgEvents` (5)

### `onUnreachableCodePathSegmentEnd`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:332` | Self: 0.1% (7.6ms) | Total: 0.1% (7.6ms) | Samples: 5

**Called by:**
- `_dispatchSeg` (5)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3656` | Self: 0.1% (7.0ms) | Total: 0.1% (7.0ms) | Samples: 5

**Called by:**
- `get value` (5)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7292` | Self: 0.1% (6.1ms) | Total: 0.1% (6.1ms) | Samples: 4

**Called by:**
- `runPlugins` (4)

### `invokeSelectorHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (6.1ms) | Total: 0.1% (6.1ms) | Samples: 4

**Called by:**
- `walkNodes` (2)
- `walkNodes` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7221` | Self: 0.1% (6.1ms) | Total: 0.6% (23.6ms) | Samples: 4

**Called by:**
- `runPlugins` (16)

**Calls:**
- `invokeMethodFnHandlers` (12)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6121` | Self: 0.1% (6.0ms) | Total: 0.1% (6.0ms) | Samples: 4

**Called by:**
- `_runSelectorList` (4)

### `_NodeView_LR`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4058` | Self: 0.1% (5.8ms) | Total: 0.1% (5.8ms) | Samples: 4

**Called by:**
- `_nodeViewRaw` (4)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6636` | Self: 0.1% (5.7ms) | Total: 0.1% (5.7ms) | Samples: 4

**Called by:**
- `walkNodes` (2)
- `walkNodes` (2)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6662` | Self: 0.1% (5.6ms) | Total: 18.0% (707.7ms) | Samples: 4

**Called by:**
- `walkNodes` (261)
- `walkNodes` (137)
- `walkNodes` (65)
- `walkNodes` (3)

**Calls:**
- `_dispatchSeg` (438)
- `segment` (24)

### `lhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1863` | Self: 0.1% (5.6ms) | Total: 0.1% (5.6ms) | Samples: 4

**Called by:**
- `get argument` (4)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1417` | Self: 0.1% (5.3ms) | Total: 0.1% (6.9ms) | Samples: 4

**Called by:**
- `invokeMethodFnHandlers` (3)
- `_fireCfgEvents` (2)

**Calls:**
- `_rawTokenText` (1)

### `nodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4133` | Self: 0.1% (5.2ms) | Total: 0.1% (5.2ms) | Samples: 3

**Called by:**
- `invokeSelectorHandlers` (2)
- `getAncestorsFor` (1)

### `get`
`[native code]` | Self: 0.1% (5.1ms) | Total: 0.1% (5.1ms) | Samples: 3

**Called by:**
- `ReturnStatement` (2)
- `walkNodes` (1)

### `markReturnStatementsOnSegmentAsUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:195` | Self: 0.1% (5.0ms) | Total: 0.1% (5.0ms) | Samples: 3

**Called by:**
- `forEach` (3)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.1% (4.8ms) | Total: 0.1% (4.8ms) | Samples: 3

**Called by:**
- `walkNodes` (3)

### `segment`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4402` | Self: 0.1% (4.7ms) | Total: 1.1% (44.0ms) | Samples: 3

**Called by:**
- `_fireCfgEvents` (24)
- `_fireCfgEvents` (3)
- `_csrSegments` (1)
- `initialSegment` (1)

**Calls:**
- `CfgSegment` (26)

### `_NodeView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.1% (4.6ms) | Total: 0.1% (4.6ms) | Samples: 3

**Called by:**
- `_nodeViewRaw` (3)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4482` | Self: 0.1% (4.6ms) | Total: 0.1% (4.6ms) | Samples: 3

**Called by:**
- `get nextSegments` (2)
- `nextSegments` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4492` | Self: 0.1% (4.5ms) | Total: 0.1% (4.5ms) | Samples: 3

**Called by:**
- `get nextSegments` (2)
- `nextSegments` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7230` | Self: 0.1% (4.4ms) | Total: 0.1% (4.4ms) | Samples: 3

**Called by:**
- `runPlugins` (3)

### `getUselessReturns`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:143` | Self: 0.1% (4.4ms) | Total: 0.1% (4.4ms) | Samples: 3

**Called by:**
- `onCodePathSegmentStart` (3)

### `readdirSync`
`[native code]` | Self: 0.1% (4.2ms) | Total: 0.1% (7.1ms) | Samples: 3

**Called by:**
- `loadCoreRules` (3)
- `readdirSync` (2)

**Calls:**
- `readdirSync` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5221` | Self: 0.1% (4.2ms) | Total: 0.1% (4.2ms) | Samples: 3

**Called by:**
- `fn` (3)

### `invokeSelectorHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6215` | Self: 0.1% (4.2ms) | Total: 0.4% (19.0ms) | Samples: 3

**Called by:**
- `walkNodes` (12)

**Calls:**
- `_nodeViewRaw` (5)
- `nodeView` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)

### `invokeSelectorHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6251` | Self: 0.1% (4.1ms) | Total: 6.4% (251.9ms) | Samples: 3

**Called by:**
- `walkNodes` (165)

**Calls:**
- `_runSelectorList` (154)
- `_runSelectorList` (5)
- `_runSelectorList` (2)
- `_runSelectorList` (1)

### `_extendRangeToIncludeSemicolon`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:82` | Self: 0.1% (4.1ms) | Total: 0.1% (4.1ms) | Samples: 3

**Called by:**
- `get loc` (3)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6653` | Self: 0.0% (3.9ms) | Total: 0.0% (3.9ms) | Samples: 3

**Called by:**
- `walkNodes` (3)

### `CfgGraph`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4393` | Self: 0.0% (3.8ms) | Total: 0.0% (3.8ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `getUselessReturns`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:145` | Self: 0.0% (3.5ms) | Total: 0.0% (3.5ms) | Samples: 2

**Called by:**
- `onCodePathSegmentStart` (2)

### `CfgCodePath`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4592` | Self: 0.0% (3.5ms) | Total: 0.0% (3.5ms) | Samples: 2

**Called by:**
- `codepath` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7300` | Self: 0.0% (3.4ms) | Total: 0.0% (3.4ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `markReturnStatementsOnCurrentSegmentsAsUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:257` | Self: 0.0% (3.4ms) | Total: 6.5% (255.1ms) | Samples: 2

**Called by:**
- `_invokeFused` (138)
- `ReturnStatement` (31)

**Calls:**
- `forEach` (167)

### `get argument`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1890` | Self: 0.0% (3.4ms) | Total: 0.0% (3.4ms) | Samples: 2

**Called by:**
- `ReturnStatement` (2)

### `get label`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3247` | Self: 0.0% (3.3ms) | Total: 0.0% (3.3ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6642` | Self: 0.0% (3.2ms) | Total: 0.5% (22.4ms) | Samples: 2

**Called by:**
- `walkNodes` (15)

**Calls:**
- `onCodePathStart` (12)
- `onCodePathStart` (1)

### `existsSync`
`[native code]` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `existsSync` (2)

### `isReturned`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:114` | Self: 0.0% (3.2ms) | Total: 0.0% (3.2ms) | Samples: 2

**Called by:**
- `filter` (2)

### `initialSegment`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4601` | Self: 0.0% (3.1ms) | Total: 0.1% (4.7ms) | Samples: 2

**Called by:**
- `_fireCfgEvents` (3)

**Calls:**
- `segment` (1)

### `CfgCodePath`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4590` | Self: 0.0% (3.1ms) | Total: 0.0% (3.1ms) | Samples: 2

**Called by:**
- `codepath` (2)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6655` | Self: 0.0% (3.0ms) | Total: 0.4% (17.6ms) | Samples: 2

**Called by:**
- `walkNodes` (11)
- `walkNodes` (1)

**Calls:**
- `onCodePathEnd` (5)
- `onCodePathEnd` (4)
- `onCodePathEnd` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4455` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `get nextSegments` (1)
- `nextSegments` (1)

### `fn`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `_runSelectorList` (2)

### `CfgCodePath`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4591` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `codepath` (2)

### `_runSelectorList`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6143` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `invokeSelectorHandlers` (2)

### `_runSelectorList`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6159` | Self: 0.0% (3.0ms) | Total: 6.0% (235.6ms) | Samples: 2

**Called by:**
- `invokeSelectorHandlers` (154)

**Calls:**
- `getAncestorsFor` (81)
- `getAncestorsFor` (24)
- `getAncestorsFor` (10)
- `getAncestorsFor` (10)
- `getAncestorsFor` (8)
- `getAncestorsFor` (8)
- `getAncestorsFor` (5)
- `getAncestorsFor` (4)
- `getAncestorsFor` (1)
- `getAncestorsFor` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7281` | Self: 0.0% (3.0ms) | Total: 0.2% (7.8ms) | Samples: 2

**Called by:**
- `runPlugins` (5)

**Calls:**
- `_nodeViewRaw` (1)
- `nodeView` (1)
- `_nodeViewRaw` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7184` | Self: 0.0% (3.0ms) | Total: 0.0% (3.0ms) | Samples: 2

**Called by:**
- `runPlugins` (2)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4453` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `get nextSegments` (1)
- `nextSegments` (1)

### `isReturned`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js` | Self: 0.0% (2.9ms) | Total: 0.0% (2.9ms) | Samples: 2

**Called by:**
- `filter` (2)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6637` | Self: 0.0% (2.8ms) | Total: 0.1% (7.6ms) | Samples: 2

**Called by:**
- `walkNodes` (3)
- `walkNodes` (1)
- `walkNodes` (1)

**Calls:**
- `initialSegment` (3)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1211` | Self: 0.0% (2.8ms) | Total: 0.1% (4.4ms) | Samples: 2

**Called by:**
- `isInFinally` (3)

**Calls:**
- `nodeView` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4507` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `get nextSegments` (2)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4471` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `nextSegments` (2)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6665` | Self: 0.0% (2.8ms) | Total: 0.3% (11.8ms) | Samples: 2

**Called by:**
- `walkNodes` (5)
- `walkNodes` (2)
- `walkNodes` (1)

**Calls:**
- `_dispatchSeg` (6)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6525` | Self: 0.0% (2.8ms) | Total: 0.0% (2.8ms) | Samples: 2

**Called by:**
- `walkNodes` (2)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1413` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `getAncestorsFor` (1)
- `invokeMethodFnHandlers` (1)

### `CfgCodePath`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4585` | Self: 0.0% (2.7ms) | Total: 0.0% (2.7ms) | Samples: 2

**Called by:**
- `codepath` (2)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4502` | Self: 0.0% (2.5ms) | Total: 0.0% (2.5ms) | Samples: 2

**Called by:**
- `get nextSegments` (2)

### `_csrSegments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4420` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `allPrevSegments` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.8ms) | Total: 0.0% (1.8ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6663` | Self: 0.0% (1.8ms) | Total: 1.5% (61.2ms) | Samples: 1

**Called by:**
- `walkNodes` (20)
- `walkNodes` (12)
- `walkNodes` (9)

**Calls:**
- `_dispatchSeg` (40)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7291` | Self: 0.0% (1.8ms) | Total: 0.4% (18.6ms) | Samples: 1

**Called by:**
- `runPlugins` (12)

**Calls:**
- `defineProperty` (11)

### `markReturnStatementsOnSegmentAsUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:211` | Self: 0.0% (1.8ms) | Total: 1.2% (48.0ms) | Samples: 1

**Called by:**
- `forEach` (31)

**Calls:**
- `filter` (30)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1507` | Self: 0.0% (1.7ms) | Total: 0.0% (3.5ms) | Samples: 1

**Called by:**
- `_fireCfgEvents` (1)
- `invokeMethodFnHandlers` (1)

**Calls:**
- `getUint32` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3630` | Self: 0.0% (1.7ms) | Total: 0.0% (3.3ms) | Samples: 1

**Called by:**
- `get value` (2)

**Calls:**
- `get start` (1)

### `onCodePathStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:269` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_fireCfgEvents` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4391` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `entries`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `async _resolveConfigImpl` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7277` | Self: 0.0% (1.7ms) | Total: 0.0% (3.3ms) | Samples: 1

**Called by:**
- `runPlugins` (2)

**Calls:**
- `nodeLhs` (1)

### `encodeInto`
`[native code]` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `_encodeSource` (1)

### `_runSelectorList`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` | Self: 0.0% (1.7ms) | Total: 0.0% (1.7ms) | Samples: 1

**Called by:**
- `invokeSelectorHandlers` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6664` | Self: 0.0% (1.7ms) | Total: 0.6% (26.1ms) | Samples: 1

**Called by:**
- `walkNodes` (12)
- `walkNodes` (5)

**Calls:**
- `_dispatchSeg` (13)
- `segment` (3)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4494` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `get nextSegments` (1)

### `nodeRhs`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:570` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `nextSegments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4546` | Self: 0.0% (1.6ms) | Total: 1.6% (63.5ms) | Samples: 1

**Called by:**
- `_fireCfgEvents` (42)

**Calls:**
- `_ensureNextAdjacency` (17)
- `_ensureNextAdjacency` (15)
- `_ensureNextAdjacency` (2)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)

### `source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `_rawTokenText` (1)

### `get range`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3587` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `get value` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6652` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `Set`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `RuleSkipSet` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1552` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `invokeMethodFnHandlers` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4449` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `nextSegments` (1)

### `RegExp`
`[native code]` | Self: 0.0% (1.6ms) | Total: 0.0% (1.6ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `get argument`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1889` | Self: 0.0% (1.5ms) | Total: 0.7% (30.1ms) | Samples: 1

**Called by:**
- `ReturnStatement` (13)
- `ReturnStatement` (8)

**Calls:**
- `nodeLhs` (9)
- `getUint32` (7)
- `lhs` (4)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4472` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `get nextSegments` (1)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:550` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `async _resolveConfigImpl` (1)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6112` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_runSelectorList` (1)

### `isInFinally`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:53` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `ReturnStatement` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `isInFinally` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7075` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_extractBatchScannable`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4825` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `_buildPlan` (1)

### `get start`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `get range` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4485` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `nextSegments` (1)

### `isReturned`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:112` | Self: 0.0% (1.5ms) | Total: 0.0% (1.5ms) | Samples: 1

**Called by:**
- `filter` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:429` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `parseSource` (1)

### `remove`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:28` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_nodeViewRaw`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4123` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_fireCfgEvents` (1)

### `map`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_lintSourceOne` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:465` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `parseSource` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7280` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `_NodeView_LRN`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4051` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `_nodeViewRaw` (1)

### `dlopen`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `(anonymous)` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4439` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `nextSegments` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7286` | Self: 0.0% (1.4ms) | Total: 0.2% (11.1ms) | Samples: 1

**Called by:**
- `runPlugins` (7)

**Calls:**
- `create` (6)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7229` | Self: 0.0% (1.4ms) | Total: 0.1% (4.4ms) | Samples: 1

**Called by:**
- `runPlugins` (3)

**Calls:**
- `nodeLhs` (1)
- `getUint32` (1)

### `Uint8Array`
`[native code]` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `AstView` (1)

### `getDFSEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6523` | Self: 0.0% (1.4ms) | Total: 0.0% (1.4ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `fetch`
`[native code]` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `requestFetch` (1)

### `get parent`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1191` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `isInFinally` (1)

### `_extendRangeToIncludeSemicolon`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:112` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `get loc` (1)

### `ReturnStatement`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:341` | Self: 0.0% (1.3ms) | Total: 3.4% (134.9ms) | Samples: 1

**Called by:**
- `_invokeFused` (90)

**Calls:**
- `_nodeViewRaw` (51)
- `get argument` (21)
- `get argument` (8)
- `nodeView` (4)
- `get argument` (2)
- `_nodeViewRaw` (1)
- `_nodeViewRaw` (1)
- `get argument` (1)

### `get argument`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `ReturnStatement` (1)

### `_ensureNextAdjacency`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `get nextSegments` (1)

### `_getSharedCaches`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:726` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `reset` (1)

### `_invokeFused`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4700` | Self: 0.0% (1.3ms) | Total: 0.0% (1.3ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7295` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `runPlugins` (1)

### `markReturnStatementsOnSegmentAsUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `forEach` (1)

### `slotTemplate`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5951` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `_buildTemplate` (1)

### `getUselessReturns`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:147` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `onCodePathSegmentStart` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6631` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `walkNodes` (1)

### `invokeMethodFnHandlers`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6361` | Self: 0.0% (1.2ms) | Total: 0.4% (18.8ms) | Samples: 1

**Called by:**
- `walkNodes` (12)
- `walkNodes` (1)

**Calls:**
- `get value` (3)
- `get value` (3)
- `get value` (2)
- `get value` (1)
- `get value` (1)
- `get value` (1)
- `get value` (1)

### `_execReport`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3932` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `report` (1)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1525` | Self: 0.0% (1.2ms) | Total: 0.0% (1.2ms) | Samples: 1

**Called by:**
- `invokeMethodFnHandlers` (1)

### `markReturnStatementsOnSegmentAsUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:188` | Self: 0.0% (1.1ms) | Total: 0.0% (1.1ms) | Samples: 1

**Called by:**
- `forEach` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7601` | Self: 0.0% (0us) | Total: 0.1% (6.6ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (4)

**Calls:**
- `buildVisitorMap` (2)
- `buildVisitorMap` (1)
- `buildVisitorMap` (1)

### `report`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:3946` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `onCodePathEnd` (1)

**Calls:**
- `_execReport` (1)

### `onCodePathEnd`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:281` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_fireCfgEvents` (1)

**Calls:**
- `report` (1)

### `getAncestorsFor`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6119` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_runSelectorList` (1)

**Calls:**
- `get value` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:229` | Self: 0.0% (0us) | Total: 19.9% (782.1ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (511)

**Calls:**
- `parse` (511)

### `fn`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5259` | Self: 0.0% (0us) | Total: 0.1% (4.2ms) | Samples: 0

**Called by:**
- `_runSelectorList` (3)

**Calls:**
- `(anonymous)` (3)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4044` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `reset` (1)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:42` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (1)

**Calls:**
- `existsSync` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6634` | Self: 0.0% (0us) | Total: 1.0% (41.0ms) | Samples: 0

**Called by:**
- `walkNodes` (27)

**Calls:**
- `codepath` (27)

### `_runSelectorList`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6160` | Self: 0.0% (0us) | Total: 0.1% (7.3ms) | Samples: 0

**Called by:**
- `invokeSelectorHandlers` (5)

**Calls:**
- `fn` (3)
- `fn` (2)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5941` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_getOrBuildPlan` (1)

**Calls:**
- `_buildTemplate` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:15` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6812` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `RuleSkipSet` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:30` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `bound require` (1)

### `async _loadFlatConfig`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:42` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `async _loadFlatConfig` (1)

**Calls:**
- `existsSync` (1)

### `ReturnStatement`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:342` | Self: 0.0% (0us) | Total: 1.1% (46.1ms) | Samples: 0

**Called by:**
- `_invokeFused` (31)

**Calls:**
- `markReturnStatementsOnCurrentSegmentsAsUsed` (31)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:267` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Calls:**
- `getTagNames` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:49` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `RegExp` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:241` | Self: 0.0% (0us) | Total: 0.2% (8.2ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (4)

**Calls:**
- `AstView` (1)
- `AstView` (1)
- `AstView` (1)
- `AstView` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:3` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

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

### `async lintSource`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:350` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `async lintSource` (2)

**Calls:**
- `async _resolveConfig` (2)

### `reset`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:1078` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `reset` (1)

**Calls:**
- `_getSharedCaches` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:270` | Self: 0.0% (0us) | Total: 20.1% (792.1ms) | Samples: 0

**Calls:**
- `parseSource` (511)
- `parseSource` (4)
- `parseSource` (1)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:274` | Self: 0.0% (0us) | Total: 78.9% (3.09s) | Samples: 0

**Calls:**
- `runPlugins` (2023)
- `runPlugins` (14)
- `runPlugins` (4)

### `_buildTemplate`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5963` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_buildPlan` (1)

**Calls:**
- `slotTemplate` (1)

### `markReturnStatementsOnSegmentAsUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:191` | Self: 0.0% (0us) | Total: 0.2% (11.0ms) | Samples: 0

**Called by:**
- `forEach` (7)

**Calls:**
- `filter` (7)

### `ReturnStatement`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:355` | Self: 0.0% (0us) | Total: 0.0% (3.4ms) | Samples: 0

**Called by:**
- `_invokeFused` (2)

**Calls:**
- `get` (2)

### `_buildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5935` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `_getOrBuildPlan` (1)

**Calls:**
- `_extractBatchScannable` (1)

### `get source`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:548` | Self: 0.0% (0us) | Total: 0.5% (19.6ms) | Samples: 0

**Called by:**
- `runPlugins` (12)

**Calls:**
- `decode` (12)

### `async lintSource`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:349` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)
- `async (anonymous)` (1)

**Calls:**
- `async lintSource` (2)

### `get nextSegments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4546` | Self: 0.0% (0us) | Total: 0.5% (19.8ms) | Samples: 0

**Called by:**
- `_fireCfgEvents` (13)

**Calls:**
- `_ensureNextAdjacency` (2)
- `_ensureNextAdjacency` (2)
- `_ensureNextAdjacency` (2)
- `_ensureNextAdjacency` (2)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)
- `_ensureNextAdjacency` (1)

### `node:fs/promises`
`node:fs/promises:2` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `allPrevSegments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4569` | Self: 0.0% (0us) | Total: 1.9% (74.8ms) | Samples: 0

**Called by:**
- `onCodePathSegmentStart` (51)

**Calls:**
- `_csrSegments` (49)
- `_csrSegments` (1)
- `_csrSegments` (1)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:54` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (1)

**Calls:**
- `require` (1)

### `requestInstantiate`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `requestSatisfyUtil` (1)

**Calls:**
- `async (anonymous)` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7167` | Self: 0.0% (0us) | Total: 0.1% (4.9ms) | Samples: 0

**Called by:**
- `runPlugins` (3)

**Calls:**
- `get label` (2)
- `get label` (1)

### `requestFetch`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `fetch` (1)

### `onCodePathEnd`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:283` | Self: 0.0% (0us) | Total: 0.1% (5.5ms) | Samples: 0

**Called by:**
- `_fireCfgEvents` (4)

**Calls:**
- `get loc` (4)

### `getUselessReturns`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:149` | Self: 0.0% (0us) | Total: 0.6% (24.4ms) | Samples: 0

**Called by:**
- `onCodePathSegmentStart` (16)

**Calls:**
- `filter` (10)
- `allPrevSegments` (6)

### `_rawTokenText`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:818` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `get value` (1)

**Calls:**
- `source` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7078` | Self: 0.0% (0us) | Total: 0.2% (9.0ms) | Samples: 0

**Called by:**
- `runPlugins` (6)

**Calls:**
- `getDFSEvents` (3)
- `getDFSEvents` (2)
- `getDFSEvents` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6639` | Self: 0.0% (0us) | Total: 0.2% (9.0ms) | Samples: 0

**Called by:**
- `walkNodes` (6)

**Calls:**
- `get value` (2)
- `get value` (2)
- `get value` (1)
- `get value` (1)

### `patchAstUtils`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:435` | Self: 0.0% (0us) | Total: 0.1% (7.1ms) | Samples: 0

**Called by:**
- `(anonymous)` (5)

**Calls:**
- `bound require` (5)

### `prevSegments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4552` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `_fireCfgEvents` (1)

**Calls:**
- `_csrSegments` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:135` | Self: 0.0% (0us) | Total: 0.1% (7.1ms) | Samples: 0

**Calls:**
- `loadCoreRules` (3)
- `loadCoreRules` (1)
- `loadCoreRules` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:477` | Self: 0.0% (0us) | Total: 0.1% (7.1ms) | Samples: 0

**Called by:**
- `anonymous` (5)

**Calls:**
- `patchAstUtils` (5)

### `existsSync`
`node:fs:273` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `async _loadFlatConfig` (1)
- `loadCoreRules` (1)

**Calls:**
- `existsSync` (2)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:38` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Calls:**
- `async lintSource` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:75` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `async _resolveConfig` (2)

**Calls:**
- `async _resolveConfigImpl` (1)
- `async _resolveConfigImpl` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7594` | Self: 0.0% (0us) | Total: 0.5% (22.5ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (14)

**Calls:**
- `get source` (12)
- `get source` (1)
- `reset` (1)

### `parseSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:220` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `_encodeSource` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:25` | Self: 0.0% (0us) | Total: 0.3% (12.9ms) | Samples: 0

**Called by:**
- `parseModule` (9)

**Calls:**
- `bound require` (9)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/acorn/dist/acorn.js:2` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `(anonymous)` (1)

### `onCodePathSegmentStart`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:318` | Self: 0.0% (0us) | Total: 1.9% (74.8ms) | Samples: 0

**Called by:**
- `_dispatchSeg` (51)

**Calls:**
- `allPrevSegments` (51)

### `RuleSkipSet`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4935` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `Set` (1)

### `_getOrBuildPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5612` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `walkNodes` (2)

**Calls:**
- `_buildPlan` (1)
- `_buildPlan` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7385` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `invokeMethodFnHandlers` (1)

### `internal:fs/glob`
`internal:fs/glob:2` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `nextSegments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4547` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `_fireCfgEvents` (1)

**Calls:**
- `_csrSegments` (1)

### `_getFfiSelector`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:109` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `_getOrBuildSelectorPlan` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:18` | Self: 0.0% (0us) | Total: 0.0% (2.6ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `_lintSourceOne`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:279` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Calls:**
- `map` (1)

### `require`
`[native code]` | Self: 0.0% (0us) | Total: 1.2% (49.9ms) | Samples: 0

**Called by:**
- `bound require` (34)
- `loadCoreRules` (1)

**Calls:**
- `anonymous` (35)

### `async (anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.5% (19.7ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)
- `requestInstantiate` (1)

**Calls:**
- `parseModule` (12)
- `async (anonymous)` (1)
- `requestFetch` (1)

### `get loc`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3647` | Self: 0.0% (0us) | Total: 0.1% (5.5ms) | Samples: 0

**Called by:**
- `onCodePathEnd` (4)

**Calls:**
- `_extendRangeToIncludeSemicolon` (3)
- `_extendRangeToIncludeSemicolon` (1)

### `runPlugins`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7602` | Self: 0.0% (0us) | Total: 78.2% (3.06s) | Samples: 0

**Called by:**
- `_lintSourceOne` (2023)

**Calls:**
- `walkNodes` (444)
- `walkNodes` (402)
- `walkNodes` (258)
- `walkNodes` (186)
- `walkNodes` (185)
- `walkNodes` (168)
- `walkNodes` (85)
- `walkNodes` (64)
- `walkNodes` (46)
- `walkNodes` (19)
- `walkNodes` (16)
- `walkNodes` (16)
- `walkNodes` (14)
- `walkNodes` (14)
- `walkNodes` (12)
- `walkNodes` (12)
- `walkNodes` (12)
- `walkNodes` (11)
- `walkNodes` (7)
- `walkNodes` (7)
- `walkNodes` (6)
- `walkNodes` (5)
- `walkNodes` (4)
- `walkNodes` (3)
- `walkNodes` (3)
- `walkNodes` (3)
- `walkNodes` (3)
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

### `loadBinding`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `getTagNames` (1)

**Calls:**
- `bound require` (1)

### `getTagNames`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:191` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `_lintSourceOne` (1)

**Calls:**
- `loadBinding` (1)

### `isInFinally`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:49` | Self: 0.0% (0us) | Total: 0.1% (7.4ms) | Samples: 0

**Called by:**
- `ReturnStatement` (5)

**Calls:**
- `get parent` (3)
- `get parent` (1)
- `get parent` (1)

### `ReturnStatement`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:347` | Self: 0.0% (0us) | Total: 0.2% (8.9ms) | Samples: 0

**Called by:**
- `_invokeFused` (6)

**Calls:**
- `isInFinally` (5)
- `isInFinally` (1)

### `async _resolveConfig`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:67` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `async lintSource` (2)

**Calls:**
- `async _resolveConfig` (2)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `async (anonymous)` (1)

### `buildVisitorMap`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:4398` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `esquery` (2)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1516` | Self: 0.0% (0us) | Total: 0.1% (7.0ms) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (3)
- `_fireCfgEvents` (2)

**Calls:**
- `get loc` (5)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:11` | Self: 0.0% (0us) | Total: 0.0% (2.4ms) | Samples: 0

**Called by:**
- `parseModule` (2)

**Calls:**
- `bound require` (2)

### `bound require`
`[native code]` | Self: 0.0% (0us) | Total: 1.3% (52.6ms) | Samples: 0

**Called by:**
- `(anonymous)` (9)
- `(anonymous)` (7)
- `patchAstUtils` (5)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `(anonymous)` (2)
- `esquery` (2)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `(anonymous)` (1)
- `loadBinding` (1)
- `_getFfiSelector` (1)
- `(anonymous)` (1)

**Calls:**
- `require` (34)
- `anonymous` (2)
- `(anonymous)` (1)

### `get label`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:3256` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `nodeLhs` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7278` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `nodeRhs` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:20` | Self: 0.0% (0us) | Total: 0.2% (10.2ms) | Samples: 0

**Called by:**
- `anonymous` (7)

**Calls:**
- `bound require` (7)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6669` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `prevSegments` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/node_modules/espree/dist/espree.cjs:3` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:14` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `anonymous` (2)

**Calls:**
- `bound require` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7294` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `get` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:239` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `filter` (1)

**Calls:**
- `remove` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:43` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `parseModule` (1)

**Calls:**
- `async (anonymous)` (1)

### `node:fs`
`node:fs:2` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `anonymous` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6682` | Self: 0.0% (0us) | Total: 0.0% (2.7ms) | Samples: 0

**Called by:**
- `runPlugins` (2)

**Calls:**
- `_getOrBuildPlan` (2)

### `_encodeSource`
`/Users/ericsan/Development/OpenSource/Ez/js/index.js:97` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `encodeInto` (1)

### `_csrSegments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4419` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Called by:**
- `allPrevSegments` (1)

**Calls:**
- `segment` (1)

### `async _loadFlatConfig`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:36` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (1)

**Calls:**
- `async _loadFlatConfig` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:405` | Self: 0.0% (0us) | Total: 0.0% (1.4ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `Uint8Array` (1)

### `AstView`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:478` | Self: 0.0% (0us) | Total: 0.0% (3.8ms) | Samples: 0

**Called by:**
- `parseSource` (1)

**Calls:**
- `CfgGraph` (1)

### `markReturnStatementsOnSegmentAsUsed`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:192` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `forEach` (2)

**Calls:**
- `filter` (2)

### `get value`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:1515` | Self: 0.0% (0us) | Total: 0.1% (4.9ms) | Samples: 0

**Called by:**
- `invokeMethodFnHandlers` (2)
- `_fireCfgEvents` (1)

**Calls:**
- `get range` (2)
- `get range` (1)

### `(anonymous)`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (2.8ms) | Samples: 0

**Called by:**
- `bound require` (1)

**Calls:**
- `requestSatisfyUtil` (1)
- `dlopen` (1)

### `parseModule`
`[native code]` | Self: 0.0% (0us) | Total: 0.4% (16.9ms) | Samples: 0

**Called by:**
- `async (anonymous)` (12)

**Calls:**
- `(anonymous)` (9)
- `(anonymous)` (2)
- `(anonymous)` (1)

### `_getOrBuildSelectorPlan`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:5490` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `walkNodes` (1)

**Calls:**
- `_getFfiSelector` (1)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6458` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `runPlugins` (1)

**Calls:**
- `_getOrBuildSelectorPlan` (1)

### `requestSatisfyUtil`
`[native code]` | Self: 0.0% (0us) | Total: 0.0% (1.3ms) | Samples: 0

**Called by:**
- `(anonymous)` (1)

**Calls:**
- `requestInstantiate` (1)

### `esquery`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:53` | Self: 0.0% (0us) | Total: 0.0% (3.0ms) | Samples: 0

**Called by:**
- `buildVisitorMap` (2)

**Calls:**
- `bound require` (2)

### `allPrevSegments`
`/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js:4567` | Self: 0.0% (0us) | Total: 0.2% (8.7ms) | Samples: 0

**Called by:**
- `getUselessReturns` (6)

**Calls:**
- `_csrSegments` (6)

### `async (anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/bench/profile_one_rule.js:34` | Self: 0.0% (0us) | Total: 0.0% (1.5ms) | Samples: 0

**Called by:**
- `async (anonymous)` (1)

**Calls:**
- `async lintSource` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:116` | Self: 0.0% (0us) | Total: 0.0% (1.7ms) | Samples: 0

**Calls:**
- `entries` (1)

### `async _resolveConfig`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:70` | Self: 0.0% (0us) | Total: 0.0% (3.2ms) | Samples: 0

**Called by:**
- `async _resolveConfig` (2)

**Calls:**
- `async _resolveConfigImpl` (2)

### `walkNodes`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:7282` | Self: 0.0% (0us) | Total: 0.1% (4.6ms) | Samples: 0

**Called by:**
- `runPlugins` (3)

**Calls:**
- `_nodeViewRaw` (2)
- `_nodeViewRaw` (1)

### `ReturnStatement`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js:345` | Self: 0.0% (0us) | Total: 1.1% (46.8ms) | Samples: 0

**Called by:**
- `_invokeFused` (31)

**Calls:**
- `get argument` (14)
- `get argument` (13)
- `_nodeViewRaw` (3)
- `nodeView` (1)

### `_fireCfgEvents`
`/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js:6671` | Self: 0.0% (0us) | Total: 2.1% (85.1ms) | Samples: 0

**Called by:**
- `walkNodes` (56)

**Calls:**
- `nextSegments` (42)
- `get nextSegments` (13)
- `nextSegments` (1)

### `async _resolveConfigImpl`
`/Users/ericsan/Development/OpenSource/Ez/js/api.js:81` | Self: 0.0% (0us) | Total: 0.0% (1.6ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (1)

**Calls:**
- `async _loadFlatConfig` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/utils/ast-utils.js:13` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `bound require` (1)

### `(anonymous)`
`/Users/ericsan/Development/OpenSource/Ez/js/node_modules/esutils/lib/utils.js:31` | Self: 0.0% (0us) | Total: 0.0% (1.2ms) | Samples: 0

**Called by:**
- `anonymous` (1)

**Calls:**
- `(anonymous)` (1)

### `loadCoreRules`
`/Users/ericsan/Development/OpenSource/Ez/js/load-plugin.js:47` | Self: 0.0% (0us) | Total: 0.1% (4.2ms) | Samples: 0

**Called by:**
- `async _resolveConfigImpl` (3)

**Calls:**
- `readdirSync` (3)

## Files

| Self% | Self | File |
|------:|-----:|------|
| 33.7% | 1.32s | `/Users/ericsan/Development/OpenSource/Ez/js/eslint-runner.js` |
| 29.6% | 1.16s | `[native code]` |
| 19.9% | 781.8ms | `/Users/ericsan/Development/OpenSource/Ez/js/estree-adapter.js` |
| 16.5% | 650.3ms | `/Users/ericsan/Development/OpenSource/Ez/js/node_modules/eslint/lib/rules/no-useless-return.js` |
| 0.0% | 1.5ms | `/Users/ericsan/Development/OpenSource/Ez/js/api.js` |
